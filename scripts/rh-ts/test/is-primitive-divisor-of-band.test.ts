import { test } from "node:test";
import assert from "node:assert/strict";
import { isPrimitiveDivisorOfBand } from "../src/is-primitive-divisor-of-band.ts";

test("primitive divisors match the order-equals-band criterion", () => {
  assert.equal(isPrimitiveDivisorOfBand(47n, 16), true);
  assert.equal(isPrimitiveDivisorOfBand(7n, 16), false); // order 8 < 16
  assert.equal(isPrimitiveDivisorOfBand(3n, 8), false);  // order 4 < 8
  assert.equal(isPrimitiveDivisorOfBand(7n, 8), true);
  assert.equal(isPrimitiveDivisorOfBand(3n, 4), true);   // 3 | F_4 = 3, order 4
});

test("isPrimitiveDivisorOfBand excludes the degenerate primes 2 and 5", () => {
  assert.equal(isPrimitiveDivisorOfBand(5n, 5), false);  // 5 ramifies in Q(sqrt 5)
  assert.equal(isPrimitiveDivisorOfBand(2n, 3), false);  // 2 degenerates mod 2
});
