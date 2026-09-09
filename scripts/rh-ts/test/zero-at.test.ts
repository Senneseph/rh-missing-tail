import { test } from "node:test";
import assert from "node:assert/strict";
import { rsZValueOfT } from "../src/rs-z-value-of-t.ts";
import { zeroBracketOf } from "../src/zero-bracket-of.ts";
import { zeroAt } from "../src/zero-at.ts";

// Goldens computed 2026-09-09 from the CERTIFIED census file
// (kainos-logos scripts/rh/zeros_T100000.txt, the day-003/004b 1e5 census:
// N(1e5) = 138,065 exact, dps-verified). Computed, not recalled.
const GAMMA_6 = 37.58617815882566049;
const GAMMA_7 = 40.9187190121474913;
const GAMMA_100 = 236.5242296658162786;
const GAMMA_138065 = 99999.70094848258304;
const N_40 = 6; // zeros below 40 (counted from the census file)
const N_1E5 = 138065;

test("zeroBracketOf: RVM inversion lands within a few spacings (census goldens)", () => {
  // n = 1: the main term alone sits S(14.13) zeros high (S ~ 0.55 = 3.7 rad);
  // the bracket is the walker's input, and the anchor protocol, not the
  // bracket, is what certifies. Tolerances are in radians.
  const t1: number = zeroBracketOf(1)[0];
  assert.ok(Math.abs(t1 - 14.134725) < 5, `n=1 bracket ${t1}`);
  const t6: number = zeroBracketOf(6)[0];
  assert.ok(Math.abs(t6 - GAMMA_6) < 3, `n=6 bracket ${t6}`);
  const t100: number = zeroBracketOf(100)[0];
  assert.ok(Math.abs(t100 - GAMMA_100) < 4, `n=100 bracket ${t100}`);
  const t138065: number = zeroBracketOf(N_1E5)[0];
  assert.ok(Math.abs(t138065 - GAMMA_138065) < 12, `n=138065 bracket ${t138065}`);
});

test("zeroAt(7): anchor N(40)=6, first flip = gamma_7 (census golden)", () => {
  // t ~ 41 sits on the 2-term O(u^-5) RS floor (measured: zero-location
  // offset ~1e-4); the float engine brackets, the dps tail owns the digits.
  const found = zeroAt(7, 40, N_40);
  assert.ok(Math.abs(found.gammaFloat - GAMMA_7) < 2e-3, `gamma_7 = ${found.gammaFloat}`);
  assert.ok(found.deltaN >= 1, "found at least one flip");
});

test("zeroAt(100): walk 40 -> ~264, 94th flip = gamma_100 (census golden)", () => {
  const found = zeroAt(100, 40, N_40);
  assert.ok(
    Math.abs(found.gammaFloat - GAMMA_100) < 1e-3,
    `gamma_100 = ${found.gammaFloat} (expected ${GAMMA_100})`,
  );
  assert.ok(found.deltaN >= found.relativeFlipIndex, "enough flips in the window");
});

test("zeroAt(138066): first zero ABOVE 1e5 (unknown — found by walk, Z ~ 0)", () => {
  // t ~ 1e5: engine error ~1e-8 (day-007 dps measurement), so the float
  // zero is good to ~1e-8; the dps tail certifies it to 1e-45.
  const found = zeroAt(N_1E5 + 1, 100000, N_1E5);
  assert.ok(found.gammaFloat > 100000 && found.gammaFloat < 100040, `gamma = ${found.gammaFloat}`);
  assert.ok(Math.abs(rsZValueOfT(found.gammaFloat)) < 1e-6, `Z at gamma`);
  assert.ok(found.relativeFlipIndex === 1, "first flip after the anchor");
  console.error(`  gamma_138066 (float) = ${found.gammaFloat}  (dps tail pending)`);
});
