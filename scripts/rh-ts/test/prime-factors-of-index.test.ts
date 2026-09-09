import { test } from "node:test";
import assert from "node:assert/strict";
import { primeFactorsOfIndex } from "../src/prime-factors-of-index.ts";

test("primeFactorsOfIndex goldens", () => {
  assert.deepEqual([...primeFactorsOfIndex(180)], [2, 3, 5]);
  assert.deepEqual([...primeFactorsOfIndex(97)], [97]);
  assert.deepEqual([...primeFactorsOfIndex(1)], []);
});
