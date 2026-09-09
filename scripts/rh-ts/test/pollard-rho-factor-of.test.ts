import { test } from "node:test";
import assert from "node:assert/strict";
import { pollardRhoFactorOf } from "../src/pollard-rho-factor-of.ts";

test("pollardRhoFactorOf returns a genuine nontrivial factor", () => {
  const factorOf341: bigint = pollardRhoFactorOf(341n);
  assert.ok(factorOf341 === 11n || factorOf341 === 31n);

  const factorOfSemiprime: bigint = pollardRhoFactorOf(1000000016000000063n);
  assert.ok(
    factorOfSemiprime === 1000000007n || factorOfSemiprime === 1000000009n,
    `unexpected factor ${factorOfSemiprime}`,
  );
});
