import { test } from "node:test";
import assert from "node:assert/strict";
import { stripSmallFactorRemainderOf } from "../src/strip-small-factor-remainder-of.ts";
import { trialPrimesUpTo } from "../src/trial-primes.ts";

test("stripSmallFactorRemainderOf strips all small factors", () => {
  const result = stripSmallFactorRemainderOf(30030n, trialPrimesUpTo(100));
  assert.equal(result.remainder, 1n);
  assert.deepEqual([...result.strippedPrimes], [2, 3, 5, 7, 11, 13]);
});

test("stripSmallFactorRemainderOf leaves the large cofactor intact", () => {
  const result = stripSmallFactorRemainderOf(
    75025n, // F_25 = 5^2 * 3001
    trialPrimesUpTo(100),
  );
  assert.equal(result.remainder, 3001n);
  assert.deepEqual([...result.strippedPrimes], [5]);
});
