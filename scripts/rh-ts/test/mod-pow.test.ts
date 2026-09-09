import { test } from "node:test";
import assert from "node:assert/strict";
import { modPow } from "../src/mod-pow.ts";

test("modPow golden (python computed)", () => {
  assert.equal(modPow(7n, 256n, 13n), 9n);
});

test("modPow edge cases", () => {
  assert.equal(modPow(0n, 5n, 13n), 0n);
  assert.equal(modPow(4n, 0n, 13n), 1n);
  assert.equal(modPow(2n, 64n, 13n), 3n); // order of 2 mod 13 is 12; 64 = 5*12 + 4 -> 2^4 = 16 = 3 mod 13
});
