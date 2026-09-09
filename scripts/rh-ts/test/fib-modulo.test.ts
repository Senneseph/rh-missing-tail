import { test } from "node:test";
import assert from "node:assert/strict";
import { fibModulo } from "../src/fib-modulo.ts";

test("fibModulo returns 0 exactly on prime divisors of F_n", () => {
  assert.equal(fibModulo(10, 11n), 0n);   // F_10 = 55 = 5 * 11
  assert.equal(fibModulo(10, 5n), 0n);
  assert.equal(fibModulo(12, 3n), 0n);    // F_12 = 144 = 2^4 * 3^2
  assert.equal(fibModulo(8, 7n), 0n);     // F_8 = 21 = 3 * 7
});

test("fibModulo goldens against python-modulo values", () => {
  assert.equal(fibModulo(50, 9999999967n), 2586269058n); // F_50 = 12586269025
  assert.equal(fibModulo(0, 9999999967n), 0n);
  assert.equal(fibModulo(1, 9999999967n), 1n);
});

test("fibModulo is nonzero for primes that do not divide F_n", () => {
  assert.notEqual(fibModulo(4, 7n), 0n); // F_4 = 3
  assert.notEqual(fibModulo(9, 13n), 0n); // F_9 = 34
});
