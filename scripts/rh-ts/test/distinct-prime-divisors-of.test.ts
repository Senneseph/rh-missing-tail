import { test } from "node:test";
import assert from "node:assert/strict";
import { distinctPrimeDivisorsOf } from "../src/distinct-prime-divisors-of.ts";

test("distinctPrimeDivisorsOf goldens", () => {
  assert.deepEqual([...distinctPrimeDivisorsOf(30030n)], [2n, 3n, 5n, 7n, 11n, 13n]);
  assert.deepEqual([...distinctPrimeDivisorsOf(144n)], [2n, 3n]);           // F_12
  assert.deepEqual([...distinctPrimeDivisorsOf(75025n)], [5n, 3001n]);      // F_25
});

test("distinctPrimeDivisorsOf on a 19-digit semiprime", () => {
  assert.deepEqual([...distinctPrimeDivisorsOf(1000000016000000063n)], [1000000007n, 1000000009n]);
});

test("distinctPrimeDivisorsOf is idempotent in result (same input, same output)", () => {
  const first = distinctPrimeDivisorsOf(232792560n);
  const second = distinctPrimeDivisorsOf(232792560n);
  assert.deepEqual([...first], [...second]);
});
