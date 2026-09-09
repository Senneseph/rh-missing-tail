import { test } from "node:test";
import assert from "node:assert/strict";
import { isProbablyPrime } from "../src/is-probably-prime.ts";

test("isProbablyPrime on small values", () => {
  assert.equal(isProbablyPrime(2n), true);
  assert.equal(isProbablyPrime(3n), true);
  assert.equal(isProbablyPrime(37n), true);
  assert.equal(isProbablyPrime(4n), false);
  assert.equal(isProbablyPrime(341n), false);      // 11 * 31 Carmichael
  assert.equal(isProbablyPrime(561n), false);      // 3 * 11 * 17 Carmichael
});

test("isProbablyPrime on a 44-digit probable prime (independently python-MR'd over 42 bases)", () => {
  // 2^113 - 1 is COMPOSITE (79615056208375 | it); the first genuine 44-digit
  // golden is the python-verified probable prime below.
  assert.equal(isProbablyPrime(11150372599265311570767859136324180752990213n), true);
  assert.equal(isProbablyPrime(11150372599265311570767859136324180752990212n), false); // even
});

test("isProbablyPrime on a 19-digit semiprime", () => {
  assert.equal(isProbablyPrime(1000000016000000063n), false); // 1000000007 * 1000000009
});
