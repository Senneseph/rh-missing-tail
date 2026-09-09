import { test } from "node:test";
import assert from "node:assert/strict";
import { l5BlockReferenceAt } from "../src/l5-block-reference-at.ts";

// Goldens: L(2, chi_5) float64 block sum from python (M = 2e6);
// L(1, chi_5) = 2*ln(phi)/sqrt(5) from the class-number formula (independent
// number theory, not a summation).
test("l5BlockReferenceAt reproduces L(2, chi_5) to 1e-9", () => {
  const value: { re: number; im: number } = l5BlockReferenceAt(2, 0, 2_000_000);
  assert.ok(Math.abs(value.re - 0.706211403259695) < 1e-9, `got ${value.re}`);
  assert.ok(Math.abs(value.im) < 1e-12);
});

test("l5BlockReferenceAt reproduces L(1, chi_5) = 2 ln(phi)/sqrt(5) to 1e-9", () => {
  const value: { re: number; im: number } = l5BlockReferenceAt(1, 0, 2_000_000);
  assert.ok(Math.abs(value.re - 0.430408940964004) < 1e-9, `got ${value.re}`);
});

test("l5BlockReferenceAt is idempotent in result for the same inputs", () => {
  const first = l5BlockReferenceAt(0.5, 3, 50_000);
  const second = l5BlockReferenceAt(0.5, 3, 50_000);
  assert.equal(first.re, second.re);
  assert.equal(first.im, second.im);
});
