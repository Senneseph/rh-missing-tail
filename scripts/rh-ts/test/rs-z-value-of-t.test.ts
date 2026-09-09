import { test } from "node:test";
import assert from "node:assert/strict";
import { rsZValueOfT, varthetaOfT } from "../src/rs-z-value-of-t.ts";

// Goldens captured 2026-09-09 FROM the patched python engine
// (zeta_core.Z_rs with the day-007 psi''' fix; the fix validated vs dps
// mpmath: |Z - Z_mp| ~ 2e-9..1e-8 for t >= 4.5e4). Computed, not recalled.
// [t, Z_rs(t), vartheta(t)]
const GOLDENS: ReadonlyArray<readonly [number, number, number]> = [
  [50, -0.34045891516343546, 26.46136607016138],
  [123.456, -0.6272647328309892, 121.7059321159723],
  [1000, 0.9978037592833762, 2034.5464280380297],
  [1234.567, -1.7965567049390392, 2641.9501505410053],
  [45374.03, 1.4582661817044706e-5, 178882.59443266928],
  [138065, 0.6124686785775557, 621126.6226838991],
  [500000, 7.775129007129897, 2571121.185049706],
  [567000, -1.1743411191688502, 2951301.943172159],
];

test("rsZValueOfT matches the patched python engine at 8 float64 goldens (abs < 1e-9)", () => {
  let maxDiff = 0;
  GOLDENS.forEach(([t, zPy]) => {
    const d = Math.abs(rsZValueOfT(t) - zPy);
    maxDiff = Math.max(maxDiff, d);
    assert.ok(d < 1e-9, `Z mismatch at t=${t}: |diff| = ${d}`);
  });
  console.error(`  max |Z_ts - Z_py| over goldens = ${maxDiff.toExponential(3)}`);
});

test("varthetaOfT matches the python engine at 8 goldens (rel < 1e-9)", () => {
  let maxRel = 0;
  GOLDENS.forEach(([t, , vPy]) => {
    const d = Math.abs(varthetaOfT(t) - vPy) / Math.abs(vPy);
    maxRel = Math.max(maxRel, d);
    assert.ok(d < 1e-9, `vartheta mismatch at t=${t}: rel = ${d}`);
  });
  console.error(`  max rel |v_ts - v_py| over goldens = ${maxRel.toExponential(3)}`);
});

test("rsZValueOfT rejects t < 40", () => {
  assert.throws(() => rsZValueOfT(10));
});
