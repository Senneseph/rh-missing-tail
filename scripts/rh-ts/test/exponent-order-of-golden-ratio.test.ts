import { test } from "node:test";
import assert from "node:assert/strict";
import { exponentOrderOfGoldenRatioModulo } from "../src/exponent-order-of-golden-ratio.ts";

test("exponentOrderOfGoldenRatioModulo finds the exact multiplicative order of phi", () => {
  assert.equal(exponentOrderOfGoldenRatioModulo(7n, 8), 8);      // 7 | F_8 = 21, order 8
  assert.equal(exponentOrderOfGoldenRatioModulo(47n, 16), 16);   // 47 | F_16 = 987, order 16
  assert.equal(exponentOrderOfGoldenRatioModulo(3n, 4), 4);      // 3 | F_4 = 3, order 4
});

test("exponentOrderOfGoldenRatioModulo is null when the prime does not divide F_n", () => {
  assert.equal(exponentOrderOfGoldenRatioModulo(7n, 4), null);   // 7 ∤ F_4 = 3
  assert.equal(exponentOrderOfGoldenRatioModulo(13n, 9), null);  // 13 ∤ F_9 = 34
});
