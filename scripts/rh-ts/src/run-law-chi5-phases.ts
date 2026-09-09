// run-law-chi5-phases.ts — the five-phase width table c_r(s) of the chi_5
// missing tail (the Lebesgue-cell-width cross-section).
//
// Law (dps-40 oracle, day006_c_r_s_oracle.py):
//   L(s,chi_5) - P_N(s) = -P(r) N^{-s} + c_r(s) N^{-s-1} + O(N^{-s-2}),  r = N mod 5
// with the phase table taking exactly two values:
//   c_r(s) = +2s/5  for r in {0, 1, 4};   c_r(s) = -3s/5  for r in {2, 3}.
// This runner re-measures every phase in float64 (block-form L5 vs sequential
// P_N, the established two-summation-order cross-validation) at N = 1e4 + r
// and asserts against the oracle's N = 1e4 column. Tolerances = the oracle's
// own N1-vs-N2 asymptotic drift (O(N^{-1})).

import { l5BlockReferenceAt } from "./l5-block-reference-at.js";
import { chi5SequentialPartialSums } from "./chi5-sequential-partial-sums.js";
import { chi5CumulativeResidueAt } from "./chi5-residue.js";
import { complexPowerTermForLog } from "./complex-power-term-for-log.js";
import type { ComplexValue } from "./complex-value.js";
import { summarizeCrossChecks, type CrossCheckRecord } from "./cross-check-summary.js";

// BLOCK_COUNT = 2e6: the c-measurement amplifies the tail by N^{s+1} = N^{1.5} = 1e6
// at N = 1e4, so the L5 reference needs |err| < tol/1e6 ~ 5e-13..5e-10; the block
// remainder is |s|(5M)^{-3/2}, which needs M >= ~1e6 (2e6 for margin).
const BLOCK_COUNT: number = 2_000_000;
const N_BASE: number = 10_000;
const T_VALUES: readonly number[] = [1, 10, 100, 1000];
const PHASES: readonly number[] = [0, 1, 2, 3, 4];

// Oracle goldens (dps = 40, N = 1e4 + r column of out_day006_c_r_s_oracle.txt):
// [t][r] = [ |c_r|, arg(c_r) ]; tolerances per t = oracle N1-vs-N2 drift + margin.
const GOLDEN_MAG: readonly (readonly number[])[] = [
  [0.4472136, 0.4472807, 0.6707701, 0.6708707, 0.4471465], // t = 1
  [4.0050001, 4.0056009, 6.0070485, 6.0079494, 4.0043997], // t = 10
  [40.0038323, 40.0098331, 59.9999978, 60.0089963, 39.9978316], // t = 100
  [403.3558478, 403.4163527, 603.7260684, 603.8166115, 403.2920008], // t = 1000
];
const GOLDEN_ARG: readonly (readonly number[])[] = [
  [1.1071487, 1.1072487, -2.0344939, -2.034394, 1.1070487],
  [1.5208376, 1.5218375, -1.6212549, -1.6202551, 1.519838],
  [1.565793, 1.5757925, -1.5807977, -1.5708002, 1.5557975],
  [1.5702626, 1.6702576, -1.6213104, -1.5213354, 1.4703076],
];
const TOLERANCES_BY_T: readonly number[] = [5e-4, 3e-3, 3e-2, 5.0];

const measuredCoefficientAtPhase = (
  l5Reference: ComplexValue,
  partialRe: Float64Array,
  partialIm: Float64Array,
  phase: number,
  t: number,
): ComplexValue => {
  const n: number = N_BASE + phase;
  const logOfN: number = Math.log(n);
  const tail: ComplexValue = {
    re: l5Reference.re - partialRe[n - 1]!,
    im: l5Reference.im - partialIm[n - 1]!,
  };
  const bandResidue: ComplexValue = {
    re: chi5CumulativeResidueAt(phase) * complexPowerTermForLog(0.5, t, logOfN).re,
    im: chi5CumulativeResidueAt(phase) * complexPowerTermForLog(0.5, t, logOfN).im,
  };
  // N^{s+1} = N^{-(-1.5 - i t)}
  const rescale: ComplexValue = complexPowerTermForLog(-1.5, -t, logOfN);
  return {
    re: (tail.re + bandResidue.re) * rescale.re - (tail.im + bandResidue.im) * rescale.im,
    im: (tail.re + bandResidue.re) * rescale.im + (tail.im + bandResidue.im) * rescale.re,
  };
};

const main = (): void => {
  const crossCheckRecords: CrossCheckRecord[] = [];
  const measuredByT: ComplexValue[][] = [];

  T_VALUES.forEach((t: number, tIndex: number) => {
    const l5Reference: ComplexValue = l5BlockReferenceAt(0.5, t, BLOCK_COUNT);
    const [partialRe, partialIm] = chi5SequentialPartialSums(0.5, t, N_BASE + 4);
    measuredByT.push(
      PHASES.map((phase) =>
        measuredCoefficientAtPhase(l5Reference, partialRe, partialIm, phase, t),
      ),
    );
    PHASES.forEach((phase: number) => {
      const measured: ComplexValue = measuredByT[tIndex]![phase]!;
      const expected: ComplexValue = {
        re: GOLDEN_MAG[tIndex]![phase]! * Math.cos(GOLDEN_ARG[tIndex]![phase]!),
        im: GOLDEN_MAG[tIndex]![phase]! * Math.sin(GOLDEN_ARG[tIndex]![phase]!),
      };
      crossCheckRecords.push({
        label: `c_r(${phase}) at s = 0.5+${t}i vs dps-40 oracle (cell width, phase ${phase})`,
        measured: Math.hypot(measured.re - expected.re, measured.im - expected.im),
        expected: 0,
        tolerance: TOLERANCES_BY_T[tIndex]!,
      });
    });
  });

  // Structural check: the table takes exactly two values: r in {0,1,4} vs {2,3}.
  const groupA: readonly number[] = [0, 1, 4].map((phase) => Math.hypot(
    measuredByT[0]![phase]!.re,
    measuredByT[0]![phase]!.im,
  ));
  const groupB: readonly number[] = [2, 3].map((phase) => Math.hypot(
    measuredByT[0]![phase]!.re,
    measuredByT[0]![phase]!.im,
  ));
  const groupSpread: number =
    (Math.max(...groupA) - Math.min(...groupA)) + (Math.max(...groupB) - Math.min(...groupB));
  crossCheckRecords.push({
    label: "two-valued structure: within-group spread of |c_r| at t=1 < 0.01",
    measured: groupSpread,
    expected: 0,
    tolerance: 0.01,
  });
  const ratioB: number =
    (groupB[0]! + groupB[1]!) / (groupA[0]! + groupA[1]! + groupA[2]!) * 1.5;
  crossCheckRecords.push({
    label: "group ratio: |(sum_B/sum_A) x 1.5 - 1.5| < 0.03, i.e. b/a = 3/2 per member",
    measured: ratioB - 1.5,
    expected: 0,
    tolerance: 0.03,
  });

  const summary = summarizeCrossChecks(crossCheckRecords);

  console.log("chi_5 five-phase width table, float64 (N = 1e4 + r) vs dps-40 oracle");
  console.log("=====================================================================");
  T_VALUES.forEach((t: number, tIndex: number) => {
    const row: string[] = PHASES.map((phase: number) => {
      const c: ComplexValue = measuredByT[tIndex]![phase]!;
      return `r=${phase}: |c|=${Math.hypot(c.re, c.im).toFixed(6)} arg=${Math.atan2(c.im, c.re).toFixed(6)}`;
    });
    console.log(`t=${String(t).padStart(4)}: ${row.join("  ")}`);
  });
  console.log("\ncross-checks vs dps-40 oracle (out_day006_c_r_s_oracle.txt):");
  summary.records.forEach((record) => {
    const passes: boolean = record.measured <= record.tolerance;
    console.log(`  ${passes ? "PASS" : "FAIL"}  ${record.label} (residual ${record.measured.toExponential(3)})`);
  });

  process.exitCode = summary.passed ? 0 : 1;
};

main();
