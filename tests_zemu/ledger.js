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
  sendTransaction,
};
