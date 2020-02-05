/*
 * Copyright (c) 2018-2019 Simple Rules Company.

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
 */

#include <stdbool.h>
#include <string.h>
#include <strings.h>
#include <stdint.h>
#include <os.h>
#include <cx.h>
#include "harmony.h"
#include "bech32.h"


void deriveOneKeypair(cx_ecfp_private_key_t *privateKey, cx_ecfp_public_key_t *publicKey) {
    // bip32 path for ONE is 44'/1023'/0'/0/0
    uint32_t bip32Path[] = {44 | 0x80000000, 1023 | 0x80000000,  0x80000000, 0, 0};
	uint8_t keySeed[32];
	cx_ecfp_private_key_t pk;

    if (privateKey || publicKey) {
        os_perso_derive_node_bip32(CX_CURVE_256K1, bip32Path, 5, keySeed, NULL);
        cx_ecfp_init_private_key(CX_CURVE_256K1, keySeed, 32, &pk);
    }

    if (publicKey) {
        cx_ecfp_init_public_key(CX_CURVE_256K1, NULL, 0, publicKey);
        cx_ecfp_generate_pair(CX_CURVE_256K1, publicKey, &pk, 1);
	}
	if (privateKey) {
		*privateKey = pk;
	}

    explicit_bzero(keySeed, sizeof(keySeed));
    explicit_bzero(&pk, sizeof(pk));
}

void extractPubkeyBytes(unsigned char *dst, cx_ecfp_public_key_t *publicKey) {
    os_memmove(dst, publicKey->W, SIGNATURE_LEN);
}


void convert_signature_to_RSV(const unsigned char *tlv_signature, unsigned char *dst) {
    int r_size = tlv_signature[3];
    int s_size = tlv_signature[3 + r_size + 2];

    int r_offset = r_size - 32;
    int s_offset = s_size - 32;

    const int offset_before_R = 4;
    const int offset_before_S = 2;

    os_memmove(dst, tlv_signature + offset_before_R + r_offset, 32); // skip first bytes and store the `R` part
    os_memmove(dst + 32, tlv_signature + offset_before_R + 32 + offset_before_S + r_offset + s_offset,
               32); // skip unused bytes and store the `S` part
}


void deriveAndSign(uint8_t *dst, const uint8_t *hash) {
    unsigned char tlv_sig[80];
    unsigned int info = 0;
    unsigned int recovery_id = 0;

	cx_ecfp_private_key_t privateKey;

	//generate private key
	deriveOneKeypair(&privateKey, NULL);

    //uint8_t data[32] = {1};
    cx_ecdsa_sign(&privateKey, CX_RND_RFC6979 | CX_LAST, CX_SHA256, hash, 32, tlv_sig, sizeof(tlv_sig),  &info);

	//clear private key ASAP
    explicit_bzero(&privateKey, sizeof(privateKey));

    if (info & CX_ECCINFO_PARITY_ODD)
        recovery_id++;

    if (info & CX_ECCINFO_xGTn)
        recovery_id += 2;

    convert_signature_to_RSV(tlv_sig, dst);

    dst[64] = recovery_id;
}

void bin2hex(uint8_t *dst, uint8_t *data, uint64_t inlen) {
	static uint8_t const hex[] = "0123456789abcdef";
	for (uint64_t i = 0; i < inlen; i++) {
		dst[2*i+0] = hex[(data[i]>>4) & 0x0F];
		dst[2*i+1] = hex[(data[i]>>0) & 0x0F];
	}
	dst[2*inlen] = '\0';
}

void getEthAddressFromKey(cx_ecfp_public_key_t *publicKey, uint8_t *out) {
    cx_sha3_t sha3Context;
    uint8_t hashAddress[32];
    cx_keccak_init(&sha3Context, 256);
    cx_hash((cx_hash_t*)&sha3Context, CX_LAST, publicKey->W + 1, 64, hashAddress, 32);
    os_memmove(out, hashAddress + 12, 20);
}

void pubkeyToOneAddress(uint8_t *dst, cx_ecfp_public_key_t *publicKey) {
    unsigned char etherAddr[20];
    getEthAddressFromKey(publicKey, etherAddr);
    bech32_get_address((char *)dst, etherAddr, 20);
}

int bin2dec(uint8_t *dst, uint64_t n) {
	if (n == 0) {
		dst[0] = '0';
		dst[1] = '\0';
		return 1;
	}
	// determine final length
	int len = 0;
	for (uint64_t nn = n; nn != 0; nn /= 10) {
		len++;
	}
	// write digits in big-endian order
	for (int i = len-1; i >= 0; i--) {
		dst[i] = (n % 10) + '0';
		n /= 10;
	}
	dst[len] = '\0';
	return len;
}
