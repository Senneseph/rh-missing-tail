import { test } from "node:test";
import assert from "node:assert/strict";
import { powerLawLeastSquaresFit } from "../src/power-law-least-squares-fit.ts";

test("powerLawLeastSquaresFit recovers an exact synthetic power law", () => {
  const xValues = Array.from({ length: 50 }, (_, index) => 100 * 10 ** (index / 9));
  const magnitudes = xValues.map((x) => 3 * x ** -1.5);
  const fit = powerLawLeastSquaresFit(xValues, magnitudes);
  assert.ok(Math.abs(fit.amplitude - 3) < 1e-9, `amplitude ${fit.amplitude}`);
  assert.ok(Math.abs(fit.exponent + 1.5) < 1e-9, `exponent ${fit.exponent}`);
});

test("powerLawLeastSquaresFit ignores non-positive pairs", () => {
  const xValues = [1, 10, 100, 1000];
  const magnitudes = [0, 3 * 10 ** -1.5, 3 * 100 ** -1.5, 3 * 1000 ** -1.5];
  const fit = powerLawLeastSquaresFit(xValues, magnitudes);
  assert.ok(Math.abs(fit.exponent + 1.5) < 1e-9);
});
