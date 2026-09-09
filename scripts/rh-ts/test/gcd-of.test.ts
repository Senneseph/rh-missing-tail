import { test } from "node:test";
import assert from "node:assert/strict";
import { gcdOf } from "../src/gcd-of.ts";

test("gcdOf goldens", () => {
  assert.equal(gcdOf(252n, 105n), 21n);
  assert.equal(gcdOf(0n, 7n), 7n);
  assert.equal(gcdOf(7n, 0n), 7n);
  assert.equal(gcdOf(123456789n, 987654321n), 9n);
});
