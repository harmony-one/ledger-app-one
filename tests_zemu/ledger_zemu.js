const Zemu = require("@zondax/zemu");
const path = require("path");
const { HarmonyApp } = require("./ledger_sdk");
const { sendTransaction } = require("./ledger.js");

const { Harmony } = require("@harmony-js/core");
const { ChainID, ChainType, numberToHex, Unit } = require("@harmony-js/utils");

const hmy = new Harmony("https://api.s0.b.hmny.io/", {
  chainType: ChainType.Harmony,
  chainId: ChainID.HmyTestnet,
});

const txn = hmy.transactions.newTx({
  to: "one1pdv9lrdwl0rg5vglh4xtyrv3wjk3wsqket7zxy",
  value: new Unit(1).asOne().toWei(),
  // gas limit, you can use string
  gasLimit: "21000",
  // send token from shardID
  shardID: 0,
  // send token to toShardID
  toShardID: 0,
  // gas Price, you can use Unit class, and use Gwei, then remember to use toWei(), which will be transformed to BN
  gasPrice: new hmy.utils.Unit("1").asGwei().toWei(),
});

hmy.stakings.setTxParams({
  gasLimit: 50000,
  gasPrice: numberToHex(new hmy.utils.Unit("1").asGwei().toWei()),
  chainId: 2,
});

const delegate = hmy.stakings.delegate({
  delegatorAddress: "one19dtf8rtftwqunjndew89v4cpgrv9xgelr87s76",
  validatorAddress: "one1gjsxmewzws9mt3fn65jmdhr3e4hel9xza8wd6t",
  amount: numberToHex(new Unit(1000).asOne().toWei()),
});
const stakingTxn = delegate.build();

const APP_PATH = path.resolve(`../bin/app.elf`);

const seed =
  "equip will roof matter pink blind book anxiety banner elbow sun young";
const ZEMU_OPTIONS = {
  logging: true,
  start_delay: 4000,
  X11: false,
  custom: `-s "${seed}" --color LAGOON_BLUE`,
};

const ZEMU_OPTIONS_S = {
  model: "nanos",
  ...ZEMU_OPTIONS,
};

const ZEMU_OPTIONS_X = {
  model: "nanox",
  ...ZEMU_OPTIONS,
};

async function beforeStart() {
  process.on("SIGINT", () => {
    Zemu.default.stopAllEmuContainers(function () {
      process.exit();
    });
  });
  await Zemu.default.checkAndPullImage();
}

async function beforeEnd() {
  await Zemu.default.stopAllEmuContainers();
}

async function transfer(sim, app) {
  const signedTxn = await app.signTransaction(
    txn,
    ChainID.HmyTestnet,
    0,
    hmy.messenger
  );

  let resp = await sendTransaction(signedTxn);
  console.log(resp);
}

async function staking(sim, app) {
  const signedTxn = await app.signStakingTransaction(
    stakingTxn,
    ChainID.HmyTestnet,
    0,
    hmy.messenger
  );

  console.log(signedTxn);
  let resp = await sendTransaction(signedTxn);
  console.log(resp);
}

async function main() {
  await beforeStart();

  if (process.argv.length > 2 && process.argv[2] === "debug") {
    ZEMU_OPTIONS_X["custom"] = ZEMU_OPTIONS_X["custom"] + " --debug";
  }

  const sim = new Zemu.default(APP_PATH);

  try {
    await sim.start(ZEMU_OPTIONS_X);
    const app = new HarmonyApp(sim.getTransport());
    console.log("calling app version");
    let resp = await app.getVersion();

    console.log(resp);

    resp = await app.publicKey(true);

    console.log(resp.one_address.toString());

    ////////////
    /// TIP you can use zemu commands here to take the app to the point where you trigger a breakpoint

    await staking(sim, app);

    /// TIP
  } finally {
    await sim.close();
    await beforeEnd();
  }
}

(async () => {
  await main();
})();
