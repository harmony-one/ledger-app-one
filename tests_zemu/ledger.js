const {
  default: TransportNodeHid,
} = require("@ledgerhq/hw-transport-node-hid");
const { HarmonyApp, SW_ERR, LEDGER_LOCKED } = require("./ledger_sdk");

const { Harmony } = require("@harmony-js/core");
const { ChainID, ChainType, hexToNumber } = require("@harmony-js/utils");

const hmy = new Harmony(process.env.HMY_NODE_URL, {
  chainType: ChainType.Harmony,
  chainId: Number(process.env.HMY_CHAIN_ID),
});
let options = { gasPrice: 1000000000, gasLimit: 6721900 };

// import BigNumber from "bignumber.js";
// import BN from "bn.js";

const oneToHexAddress = (address) => hmy.crypto.getAddress(address).basicHex;

const INTERACTION_TIMEOUT = 120 * 1000;
var harmonyApp;

async function getHarmonyApp() {
  if (harmonyApp) {
    return harmonyApp;
  }

  let transport;

  try {
    transport = await TransportNodeHid.create(INTERACTION_TIMEOUT);
  } catch (err) {
    console.log(err);
    /* istanbul ignore next: specific error rewrite */
    if (
      err.message
        .trim()
        .startsWith("No WebUSB interface found for your Ledger device")
    ) {
      throw new Error(
        "Couldn't connect to a Ledger. Please upgrade the Ledger firmware to version 1.5.5 or later."
      );
    }
    /* istanbul ignore next: specific error rewrite */
    if (err.message.trim().startsWith("Unable to claim interface")) {
      // apparently can't use it in several tabs in parallel
      throw new Error(
        "Could not access Ledger device. Is it being used in another tab?"
      );
    }
    /* istanbul ignore next: specific error rewrite */
    if (err.message.trim().startsWith("Not supported")) {
      // apparently can't use it in several tabs in parallel
      throw new Error(
        "Your browser doesn't seem to support WebUSB yet. Try updating it to the latest version."
      );
    }
    /* istanbul ignore next: specific error rewrite */
    if (err.message.trim().startsWith("No device selected")) {
      // apparently can't use it in several tabs in parallel
      throw new Error(
        "You did not select a Ledger device. Check if the Ledger is plugged in and unlocked."
      );
    }

    // throw unknown error
    throw err;
  }

  harmonyApp = new HarmonyApp(transport);
  return harmonyApp;
}

async function connectLedgerApp() {
  const app = await getHarmonyApp();
  let response = await app.publicKey(true);
  if (response.return_code === SW_ERR) {
    throw new Error(LEDGER_LOCKED);
  }

  if (!response.one_address) {
    throw new Error("Address Not Found");
  }

  if (response.one_address.indexOf(`1`) === -1) {
    throw new Error("Not A Valid Bech32 Address");
  }

  return response.one_address.toString();
}

async function signTxWithLedger(from, contractFile, ...params) {
  try {
    const contractJson = require(contractFile);
    const app = await getHarmonyApp();
    let contract = hmy.contracts.createContract(
      contractJson.abi,
      process.env.SALE
    );
    // let deployOptions = {
    //   data: contractJson.bytecode,//"0x60806040526000805534801561001457600080fd5b5061025e806100246000396000f3fe608060405234801561001057600080fd5b506004361061004c5760003560e01c8063313ce567146100515780635b34b96614610075578063a87d942c1461007f578063f5c5ad831461009d575b600080fd5b6100596100a7565b604",//contractJson.bytecode,
    //   arguments: params,
    // };
    const recipient = "0x48707da80F392C4F62e9bE76f1c834768f931034";
    const lotId = 0;
    const quantity = 1;
    const tokenAddress = "0xeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee";
    const maxTokenAmount = 10000;
    const minConversionRate = "0xDE0B6B3A7640000"; // equivalent to 1e+18
    const extData = "player-id-1";

    let txn = await contract.methods
      .purchaseFor(
        recipient,
        lotId,
        quantity,
        tokenAddress,
        maxTokenAmount,
        hexToNumber(minConversionRate),
        extData
      )
      .createTransaction();
    txn.setParams({
      ...txn.txParams,
      from: oneToHexAddress(from),
      gasLimit: options.gasLimit,
      gasPrice: options.gasPrice, //new harmony.utils.Unit(gasPrice).asGwei().toWei(),
      value: "0xD8D726B7177A80000",
    });

    const signedTxn = await app.signTransaction(
      txn,
      ChainID.HmyTestnet,
      0,
      hmy.messenger
    );

    return {
      success: true,
      result: signedTxn,
    };
  } catch (err) {
    return {
      success: false,
      result: err,
    };
  }
}

async function sendTransaction(signedTxn) {
  try {
    signedTxn
      .observed()
      .on("transactionHash", (txnHash) => {})
      .on("confirmation", (confirmation) => {
        console.log(confirmation);
        console.log(signedTxn.from);
        if (confirmation !== "CONFIRMED")
          throw new Error(
            "Transaction confirm failed. Network fee is not enough or something went wrong."
          );
      })
      .on("error", (error) => {
        throw new Error(error);
      });

    const [sentTxn, txnHash] = await signedTxn.sendTransaction();
    const confirmedTxn = await sentTxn.confirm(txnHash);

    if (!confirmedTxn.isConfirmed()) {
      return {
        result: false,
        mesg: "Can not confirm transaction " + txnHash,
      };
    }

    return {
      result: true,
      mesg: txnHash,
    };
  } catch (err) {
    return {
      result: false,
      mesg: err,
    };
  }
}

module.exports = {
  getHarmonyApp,
  connectLedgerApp,
  signTxWithLedger,
  sendTransaction,
};
