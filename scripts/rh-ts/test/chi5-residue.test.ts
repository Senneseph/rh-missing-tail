import { test } from "node:test";
import assert from "node:assert/strict";
import { chi5At, chi5CumulativeResidueAt } from "../src/chi5-residue.ts";

test("chi5At residues match the (5/n) character", () => {
  assert.deepEqual(
    [1, 2, 3, 4, 5, 6, 7, 8, 9, 10].map((n) => chi5At(n)),
    [1, -1, -1, 1, 0, 1, -1, -1, 1, 0],
  );
});

test("chi5CumulativeResidueAt follows the period-zero law", () => {
  assert.equal(chi5CumulativeResidueAt(5), 0);   // n mod 5 = 0 -> 0
  assert.equal(chi5CumulativeResidueAt(6), 1);   // n mod 5 = 1 -> 1
  assert.equal(chi5CumulativeResidueAt(7), 0);   // n mod 5 = 2 -> 0
  assert.equal(chi5CumulativeResidueAt(8), -1);  // n mod 5 = 3 -> -1
  assert.equal(chi5CumulativeResidueAt(9), 0);   // n mod 5 = 4 -> 0
  assert.equal(chi5CumulativeResidueAt(12), 0);
  assert.equal(chi5CumulativeResidueAt(100), 0);
});
