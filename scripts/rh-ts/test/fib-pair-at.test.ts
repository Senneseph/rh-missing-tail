import { test } from "node:test";
import assert from "node:assert/strict";
import { fibPairAt, fibValueAt } from "../src/fib-pair-at.ts";

test("fibPairAt base cases pin the (F_n, F_n+1) invariant", () => {
  assert.deepEqual(fibPairAt(0), { current: 0n, next: 1n });
  assert.deepEqual(fibPairAt(1), { current: 1n, next: 1n });
});

test("fibValueAt goldens (python-verified values)", () => {
  assert.equal(fibValueAt(10), 55n);
  assert.equal(fibValueAt(20), 6765n);
  assert.equal(fibValueAt(100), 354224848179261915075n);
});
