// run-band-density.ts — Fibonacci primitive-prime band density (the
// "interesting side" of the fusion: where the bands live analytically).
//
// B(n) = sum of 1/q over the primitive prime divisors q of F_n, where q is
// primitive when the multiplicative order of phi = (1+sqrt5)/2 mod q is
// exactly n (Zsigmondy: every n outside {6, 12} has at least one).
// S(N) = sum_{n=3..N} B(n). Python goldens: S(10) = 0.70285, S(20) =
// 0.90405, S(100) = 1.26539; power-law fit S ~ N^0.24 over the measured
// range; B(9) = 1/17; B(6) = B(12) = 0 (Zsigmondy exceptions).

import { fibPairAt } from "./fib-pair-at.js";
import { distinctPrimeDivisorsOf } from "./distinct-prime-divisors-of.js";
import { isPrimitiveDivisorOfBand } from "./is-primitive-divisor-of-band.js";
import { powerLawLeastSquaresFit } from "./power-law-least-squares-fit.js";
import { summarizeCrossChecks, type CrossCheckRecord } from "./cross-check-summary.js";

const BAND_UPPER: number = 100;

// B(n) in double: the reciprocal 1/q uses Number(q) — q reaches ~10^21 at
// n = 100, and the double's 15-16 significant digits keep each reciprocal
// accurate to ~1e-16 relative, far below the 1e-4 reporting precision.
const bandReciprocalSumAt = (bandIndex: number): number => {
  const fibonacciValue: bigint = fibPairAt(bandIndex).current;
  const divisors: readonly bigint[] = distinctPrimeDivisorsOf(fibonacciValue);
  const primitiveDivisors: bigint[] = divisors.filter((divisor) => isPrimitiveDivisorOfBand(divisor, bandIndex));
  return primitiveDivisors.reduce((total: number, divisor: bigint): number => total + 1 / Number(divisor), 0);
};

const main = (): void => {
  const bandSummaries: { bandIndex: number; bandSum: number; runningSum: number }[] = Array.from(
    { length: BAND_UPPER - 2 },
    (_unused: unknown, offset: number) => 3 + offset,
  ).reduce(
    (
      state: { entries: { bandIndex: number; bandSum: number; runningSum: number }[]; running: number },
      bandIndex: number,
    ) => {
      const bandSum: number = bandReciprocalSumAt(bandIndex);
      return {
        entries: [...state.entries, { bandIndex, bandSum, runningSum: state.running + bandSum }],
        running: state.running + bandSum,
      };
    },
    { entries: [] as { bandIndex: number; bandSum: number; runningSum: number }[], running: 0 },
  ).entries;

  const runningAt = (n: number): number => bandSummaries.find((entry) => entry.bandIndex === n)!.runningSum;
  const sValues: number[] = [10, 20, 50, 100].map(runningAt);
  const nValues: number[] = [10, 20, 50, 100];
  const fit: { amplitude: number; exponent: number } = powerLawLeastSquaresFit(nValues, sValues);

  const crossCheckRecords: CrossCheckRecord[] = [
    { label: "S(10) = 0.70285 (python baseline)", measured: runningAt(10), expected: 0.70285, tolerance: 5e-5 },
    { label: "S(20) = 0.90405 (python baseline)", measured: runningAt(20), expected: 0.90405, tolerance: 5e-5 },
    { label: "S(100) = 1.26539 (python baseline)", measured: runningAt(100), expected: 1.26539, tolerance: 2e-4 },
    { label: "B(9) = 1/17 = 0.058824 (17 primitive for band 9)", measured: bandSummaries.find((entry) => entry.bandIndex === 9)!.bandSum, expected: 1 / 17, tolerance: 1e-12 },
    { label: "B(6) = 0 (Zsigmondy exception)", measured: bandSummaries.find((entry) => entry.bandIndex === 6)!.bandSum, expected: 0, tolerance: 1e-15 },
    { label: "B(12) = 0 (Zsigmondy exception)", measured: bandSummaries.find((entry) => entry.bandIndex === 12)!.bandSum, expected: 0, tolerance: 1e-15 },
    { label: "power-law exponent 0.24 (python: 0.2429 over the same range)", measured: fit.exponent, expected: 0.2429, tolerance: 0.015 },
  ];
  const summary = summarizeCrossChecks(crossCheckRecords);

  console.log("Fibonacci primitive-prime band density (TypeScript re-measurement)");
  console.log("=================================================================");
  const reportMarks: readonly number[] = [5, 10, 20, 50, 100];
  bandSummaries
    .filter((entry) => reportMarks.includes(entry.bandIndex))
    .forEach((entry) => {
      console.log(`n=${String(entry.bandIndex).padStart(3)}  B(n)=${entry.bandSum.toExponential(6)}  S(n)=${entry.runningSum.toFixed(5)}`);
    });
  console.log(`power-law fit: S(N) ~ ${fit.amplitude.toFixed(3)} * N^${fit.exponent.toFixed(4)}`);
  console.log("\ncross-checks vs python baselines:");
  summary.records.forEach((record) => {
    const passes: boolean = Math.abs(record.measured - record.expected) <= record.tolerance;
    console.log(`  ${passes ? "PASS" : "FAIL"}  ${record.label} (measured ${record.measured.toFixed(6)}, expected ${record.expected.toFixed(6)})`);
  });

  process.exitCode = summary.passed ? 0 : 1;
};

main();
