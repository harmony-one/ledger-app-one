package main

import (
	"bytes"
	"encoding/binary"
	"encoding/hex"
	"errors"
	"fmt"
	"io"
	"log"
	"math"
	"os"
	"strconv"
	"golang.org/x/crypto/sha3"

	"github.com/karalabe/hid"
	"github.com/btcsuite/btcutil/bech32"
	"github.com/ethereum/go-ethereum/crypto"
	"lukechampine.com/flagg"
)

var DEBUG bool

type hidFramer struct {
	rw  io.ReadWriter
	seq uint16
	buf [64]byte
	pos int
}

func (hf *hidFramer) Reset() {
	hf.seq = 0
}

func ConvertAndEncode(hrp string, data []byte) (string, error) {
	converted, err := bech32.ConvertBits(data, 8, 5, true)
	if err != nil {
		return "", errors.New("encoding bech32 failed")
	}
	return bech32.Encode(hrp, converted)

}

func (hf *hidFramer) Write(p []byte) (int, error) {
	if DEBUG {
		fmt.Println("HID <=", hex.EncodeToString(p))
	}
	// split into 64-byte chunks
	chunk := make([]byte, 64)
	binary.BigEndian.PutUint16(chunk[:2], 0x0101)
	chunk[2] = 0x05
	var seq uint16
	buf := new(bytes.Buffer)
	binary.Write(buf, binary.BigEndian, uint16(len(p)))
	buf.Write(p)
	for buf.Len() > 0 {
		binary.BigEndian.PutUint16(chunk[3:5], seq)
		n, _ := buf.Read(chunk[5:])
		if n, err := hf.rw.Write(chunk[:5+n]); err != nil {
			return n, err
		}
		seq++
	}
	return len(p), nil
}

func (hf *hidFramer) Read(p []byte) (int, error) {
	if hf.seq > 0 && hf.pos != 64 {
		// drain buf
		n := copy(p, hf.buf[hf.pos:])
		hf.pos += n
		return n, nil
	}
	// read next 64-byte packet
	if n, err := hf.rw.Read(hf.buf[:]); err != nil {
		return 0, err
	} else if n != 64 {
		panic("read less than 64 bytes from HID")
	}
	// parse header
	channelID := binary.BigEndian.Uint16(hf.buf[:2])
	commandTag := hf.buf[2]
	seq := binary.BigEndian.Uint16(hf.buf[3:5])
	if channelID != 0x0101 {
		return 0, fmt.Errorf("bad channel ID 0x%x", channelID)
	} else if commandTag != 0x05 {
		return 0, fmt.Errorf("bad command tag 0x%x", commandTag)
	} else if seq != hf.seq {
		return 0, fmt.Errorf("bad sequence number %v (expected %v)", seq, hf.seq)
	}
	hf.seq++
	// start filling p
	n := copy(p, hf.buf[5:])
	hf.pos = 5 + n
	return n, nil
}

type APDU struct {
	CLA     byte
	INS     byte
	P1, P2  byte
	Payload []byte
}

type apduFramer struct {
	hf  *hidFramer
	buf [2]byte // to read APDU length prefix
}

func (af *apduFramer) Exchange(apdu APDU) ([]byte, error) {
	if len(apdu.Payload) > 255 {
		panic("APDU payload cannot exceed 255 bytes")
	}
	af.hf.Reset()
	data := append([]byte{
		apdu.CLA,
		apdu.INS,
		apdu.P1, apdu.P2,
		byte(len(apdu.Payload)),
	}, apdu.Payload...)
	if _, err := af.hf.Write(data); err != nil {
		return nil, err
	}

	// read APDU length
	if _, err := io.ReadFull(af.hf, af.buf[:]); err != nil {
		return nil, err
	}
	// read APDU payload
	respLen := binary.BigEndian.Uint16(af.buf[:2])
	resp := make([]byte, respLen)
	_, err := io.ReadFull(af.hf, resp)
	if DEBUG {
		fmt.Println("HID =>", hex.EncodeToString(resp))
	}
	return resp, err
}

type NanoS struct {
	device *apduFramer
}

type ErrCode uint16

func (c ErrCode) Error() string {
	return fmt.Sprintf("Error code 0x%x", uint16(c))
}

const codeSuccess = 0x9000
const codeUserRejected = 0x6985
const codeInvalidParam = 0x6b01

var errUserRejected = errors.New("user denied request")
var errInvalidParam = errors.New("invalid request parameters")

func (n *NanoS) Exchange(cmd byte, p1, p2 byte, data []byte) (resp []byte, err error) {
	resp, err = n.device.Exchange(APDU{
		CLA:     0xe0,
		INS:     cmd,
		P1:      p1,
		P2:      p2,
		Payload: data,
	})
	if err != nil {
		return nil, err
	} else if len(resp) < 2 {
		return nil, errors.New("APDU response missing status code")
	}
	code := binary.BigEndian.Uint16(resp[len(resp)-2:])
	resp = resp[:len(resp)-2]
	switch code {
	case codeSuccess:
		err = nil
	case codeUserRejected:
		err = errUserRejected
	case codeInvalidParam:
		err = errInvalidParam
	default:
		err = ErrCode(code)
	}
	return
}

const (
	cmdGetVersion   = 0x01
	cmdGetPublicKey = 0x02
	cmdSignStake    = 0x04
	cmdSignTx       = 0x08

	p1First         = 0x0
	p1More          = 0x80

	p2DisplayAddress = 0x00
	p2SilentMode     = 0x01
	p2DisplayHash    = 0x00
	p2SignHash       = 0x01
	p2Finish         = 0x02
	// APDU parameters
)

func (n *NanoS) GetVersion() (version string, err error) {
	resp, err := n.Exchange(cmdGetVersion, 0, 0, nil)
	if err != nil {
		return "", err
	} else if len(resp) != 3 {
		return "", errors.New("version has wrong length")
	}
	return fmt.Sprintf("v%d.%d.%d", resp[0], resp[1], resp[2]), nil
}

func (n *NanoS) GetAddress() (oneAddr string, err error) {
	resp, err := n.Exchange(cmdGetPublicKey, 0, p2DisplayAddress,  []byte{})
	if err != nil {
		return "", err
	}

	var pubkey [42]byte
	if copy(pubkey[:], resp) != len(pubkey) {
    	return "", errors.New("pubkey has wrong length")
    }
	return string(pubkey[:]), nil
}

func (n *NanoS) SignStake(stake []byte) (sig [65]byte, err error) {
	var resp []byte

	resp, err = n.Exchange(cmdSignStake, p1First, p2Finish, stake)
	if err != nil {
	    return [65]byte{}, err
	}

	copy(sig[:], resp)

	if copy(sig[:], resp) != len(sig) {
		return [65]byte{}, errors.New("signature has wrong length")
	}
	return
}

func (n *NanoS) SignTxn(txn []byte) (sig [65]byte, err error) {
	var resp []byte

	resp, err = n.Exchange(cmdSignTx, p1First, p2Finish, txn)
	if err != nil {
	    return [65]byte{}, err
	}

	copy(sig[:], resp)

	if copy(sig[:], resp) != len(sig) {
		return [65]byte{}, errors.New("signature has wrong length")
	}
	return
}

func OpenNanoS() (*NanoS, error) {
	const (
		ledgerVendorID       = 0x2c97
		ledgerNanoSProductID = 0x1011
		ledgerNanoXProductID = 0x0004
	)

	// search for Nano S
	devices := hid.Enumerate(ledgerVendorID, ledgerNanoSProductID)
	if len(devices) == 0 {
		devices = hid.Enumerate(ledgerVendorID, ledgerNanoXProductID)
		if len(devices) == 0 {
			return nil, errors.New("Ledger Nano S or X not detected")
		} else if len(devices) > 1 {
			return nil, errors.New("Unexpected error -- Is the harmony one wallet app running?")
		}
	} else if len(devices) > 1 {
		return nil, errors.New("Unexpected error -- Is the one wallet app running?")
	}

	// open the device
	device, err := devices[0].Open()
	if err != nil {
		return nil, err
	}

	// wrap raw device I/O in HID+APDU protocols
	return &NanoS{
		device: &apduFramer{
			hf: &hidFramer{
				rw: device,
			},
		},
	}, nil
}

func parseIndex(s string) uint32 {
	index, err := strconv.ParseUint(s, 10, 32)
	if err != nil {
		log.Fatalln("Couldn't parse index:", err)
	} else if index > math.MaxUint32 {
		log.Fatalf("Index too large (max %v)", math.MaxUint32)
	}
	return uint32(index)
}

const (
	rootUsage = `Usage:
    oneledger [flags] [action]

Actions:
    addr            get address of the wallet
    signtx          sign a transaction
    signstake       sign a staking transaction
`
	debugUsage = `print raw APDU exchanges`

	versionUsage = `Usage:
	oneledger version

Prints the version of the oneledger binary, as well as the version reported by
the one Ledger Nano S app (if available).
`
	addrUsage = `Usage:
	oneledger addr

Generates the ONE address of the wallet.
`
	stakeUsage = `Usage:
	oneledger signstake [rlp-encoded staking transaction]

Signs a 256-bit hash using the private key. The hash
must be hex-encoded.

Only sign hashes you trust. In practice, it is very difficult
to calculate a hash in a trusted manner.
`
	txnUsage = `Usage:
	oneledger signtx [rlp-encoded transaction]

Calculates and signs the hash of a RLP encoded transaction using the private key.
`
)

func main() {
	log.SetFlags(0)
	rootCmd := flagg.Root
	rootCmd.Usage = flagg.SimpleUsage(rootCmd, rootUsage)
	rootCmd.BoolVar(&DEBUG, "apdu", false, debugUsage)

	versionCmd := flagg.New("version", versionUsage)
	addrCmd := flagg.New("addr", addrUsage)
	signStakeCmd:= flagg.New("signstake", stakeUsage)
	signTxCmd := flagg.New("signtx", txnUsage)

	cmd := flagg.Parse(flagg.Tree{
		Cmd: rootCmd,
		Sub: []flagg.Tree{
			{Cmd: versionCmd},
			{Cmd: addrCmd},
			{Cmd: signStakeCmd},
			{Cmd: signTxCmd},
		},
	})
	args := cmd.Args()

	var nanos *NanoS
	if cmd != rootCmd && cmd != versionCmd {
		var err error
		nanos, err = OpenNanoS()
		if err != nil {
			log.Fatalln("Couldn't open device:", err)
		}
	}

	switch cmd {
	case rootCmd:
		if len(args) != 0 {
			rootCmd.Usage()
			return
		}
		fallthrough

	case versionCmd:
		// try to get Nano S app version
		var appVersion string
		nanos, err := OpenNanoS()
		if err != nil {
			appVersion = "(could not connect to Nano S), try with sudo "
		} else if appVersion, err = nanos.GetVersion(); err != nil {
			appVersion = "(could not read version from Nano S: " + err.Error() + ")"
		}

		fmt.Printf("%s v1.0.0\n", os.Args[0])
		fmt.Println("Nano S app version:", appVersion)

	case addrCmd:
		if len(args) != 0 {
			addrCmd.Usage()
			return
		}
		oneAddr, err := nanos.GetAddress()
		if err != nil {
        	log.Fatalln("Couldn't get one address:", err)
        }
		fmt.Println(oneAddr)

	case signStakeCmd:
		if (len(args) != 1) {
			signStakeCmd.Usage()
			return
		}

		stakeBytes, err := hex.DecodeString(args[0])
		if err != nil {
			log.Fatalln("Couldn't read transaction:", err)
		}

        sig, err := nanos.SignStake(stakeBytes)

        if err != nil {
            log.Fatalln("Couldn't get signature:", err)
        }

		if err != nil {
			log.Fatalln("Couldn't get signature:", err)
		}

        var hash [32]byte
        hw := sha3.NewLegacyKeccak256()
        hw.Write(stakeBytes[:])
        hw.Sum(hash[:0])

		fmt.Println("signature:")
		fmt.Println(hex.EncodeToString(sig[:]))
		fmt.Println("hash:")
		fmt.Println(hex.EncodeToString(hash[:]))


		pubkey, err := crypto.Ecrecover(hash[:], sig[:])
		if err != nil {
        	log.Fatalln("Ecrecover failed :", err)
        }

        if len(pubkey) == 0 || pubkey[0] != 4 {
        	log.Fatalln("invalid public key")
        }

        //fmt.Println("signed with pubkey: " + hex.EncodeToString(pubkey[:65]))
        pubBytes := crypto.Keccak256(pubkey[1:65])[12:]
        oneAddr, _ := ConvertAndEncode("one", pubBytes)
        fmt.Println("signed with address: " + oneAddr)

	case signTxCmd:
		if (len(args) != 1) {
			signTxCmd.Usage()
			return
		}

		txnBytes, err := hex.DecodeString(args[0])
		if err != nil {
			log.Fatalln("Couldn't read transaction:", err)
		}

        sig, err := nanos.SignTxn(txnBytes)

        if err != nil {
            log.Fatalln("Couldn't get signature:", err)
        }

		if err != nil {
			log.Fatalln("Couldn't get signature:", err)
		}

        var hash [32]byte
        hw := sha3.NewLegacyKeccak256()
        hw.Write(txnBytes[:])
        hw.Sum(hash[:0])

		fmt.Println("signature:")
		fmt.Println(hex.EncodeToString(sig[:]))
		fmt.Println("hash:")
		fmt.Println(hex.EncodeToString(hash[:]))


		pubkey, err := crypto.Ecrecover(hash[:], sig[:])
		if err != nil {
        	log.Fatalln("Ecrecover failed :", err)
        }

        if len(pubkey) == 0 || pubkey[0] != 4 {
        	log.Fatalln("invalid public key")
        }

        //fmt.Println("signed with pubkey: " + hex.EncodeToString(pubkey[:65]))
        pubBytes := crypto.Keccak256(pubkey[1:65])[12:]
        oneAddr, _ := ConvertAndEncode("one", pubBytes)
        fmt.Println("signed with address: " + oneAddr)
	}

}
