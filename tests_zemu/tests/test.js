/** ******************************************************************************
 *  (c) 2020 Zondax GmbH
 *
 *  Licensed under the Apache License, Version 2.0 (the "License");
 *  you may not use this file except in compliance with the License.
 *  You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License.
 ******************************************************************************* */

import jest, { expect } from "jest";
import Zemu from "@zondax/zemu";
import { HarmonyApp } from "../ledger_sdk";
import sendTransaction from "../ledger";
import { Harmony } from "@harmony-js/core";
import { ChainID, ChainType, numberToHex, Unit } from "@harmony-js/utils";

const Resolve = require("path").resolve;
const APP_PATH = Resolve("../bin/app.elf");

const APP_SEED =
  "equip will roof matter pink blind book anxiety banner elbow sun young";
const sim_options = {
  logging: true,
  start_delay: 3000,
  custom: `-s "${APP_SEED}"`,
  X11: false,
  model: "nanox",
};

jest.setTimeout(30000);

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

describe("Basic checks", function () {
  it("can start and stop container", async function () {
    const sim = new Zemu(APP_PATH);
    try {
      await sim.start(sim_options);
    } finally {
      await sim.close();
    }
  });

  it("app version", async function () {
    const sim = new Zemu(APP_PATH);
    try {
      await sim.start(sim_options);
      const app = new HarmonyApp(sim.getTransport());
      const resp = await app.getVersion();

      expect(resp.return_code).toEqual(0x9000);
      expect(resp).toHaveProperty("test_mode");
      expect(resp).toHaveProperty("major");
      expect(resp).toHaveProperty("minor");
      expect(resp).toHaveProperty("patch");
    } finally {
      await sim.close();
    }
  });

  it("get public key", async function () {
    const sim = new Zemu(APP_PATH);
    try {
      await sim.start(sim_options);
      const app = new HarmonyApp(sim.getTransport());
      const resp = await app.publicKey(true);

      expect(resp.return_code).toEqual(0x9000);
      expect(resp).toHaveProperty("one_address");
      expect(resp.one_address.toString()).toEqual(
        "one19dtf8rtftwqunjndew89v4cpgrv9xgelr87s76"
      );
    } finally {
      await sim.close();
    }
  });

  it("basic transfer", async function () {
    const sim = new Zemu(APP_PATH);
    try {
      await sim.start(sim_options);
      const app = new HarmonyApp(sim.getTransport());

      const signedTxn = app.signTransaction(
        txn,
        ChainID.HmyTestnet,
        0,
        hmy.messenger
      );

      // Wait until we are not in the main menu
      await sim.waitUntilScreenIsNot(sim.getMainMenuSnapshot());

      // Now navigate the address / path
      await sim.compareSnapshotsAndAccept(".", "sign_transfer", 4);

      let resp = await signedTxn;

      expect(resp.txStatus).toEqual("SIGNED");
    } finally {
      await sim.close();
    }
  });

  it("staking", async function () {
    const sim = new Zemu(APP_PATH);
    try {
      await sim.start(sim_options);
      const app = new HarmonyApp(sim.getTransport());

      const signedTxn = app.signStakingTransaction(
        stakingTxn,
        ChainID.HmyTestnet,
        0,
        hmy.messenger
      );

      // Wait until we are not in the main menu
      await sim.waitUntilScreenIsNot(sim.getMainMenuSnapshot());

      // Now navigate the address / path
      await sim.compareSnapshotsAndAccept(".", "sign_staking", 5);

      let resp = await signedTxn;

      expect(resp.txStatus).toEqual("INITIALIZED");
    } finally {
      await sim.close();
    }
  });
});
