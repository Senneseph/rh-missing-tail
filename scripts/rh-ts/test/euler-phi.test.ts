import { test } from "node:test";
import assert from "node:assert/strict";
import { eulerPhiOf } from "../src/euler-phi.ts";

test("eulerPhiOf goldens", () => {
  assert.equal(eulerPhiOf(1), 1);
  assert.equal(eulerPhiOf(37), 36);
  assert.equal(eulerPhiOf(120), 32);
  assert.equal(eulerPhiOf(500), 200);
  assert.equal(eulerPhiOf(210), 48);
});
