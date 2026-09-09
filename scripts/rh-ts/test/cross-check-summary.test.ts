import { test } from "node:test";
import assert from "node:assert/strict";
import { summarizeCrossChecks, evaluateCrossCheckRecord } from "../src/cross-check-summary.ts";

test("evaluateCrossCheckRecord respects the tolerance", () => {
  const passing = { label: "x", measured: 1.000001, expected: 1.0, tolerance: 1e-4 };
  const failing = { label: "x", measured: 1.01, expected: 1.0, tolerance: 1e-4 };
  assert.equal(evaluateCrossCheckRecord(passing), true);
  assert.equal(evaluateCrossCheckRecord(failing), false);
});

test("summarizeCrossChecks passes only when every record passes", () => {
  const summary = summarizeCrossChecks([
    { label: "a", measured: 1.0, expected: 1.0, tolerance: 1e-12 },
    { label: "b", measured: 2.0, expected: 2.0, tolerance: 1e-12 },
  ]);
  assert.equal(summary.passed, true);
  assert.equal(summary.records.length, 2);
});
