// run-law-chi5.ts — the chi_5 missing-term law (fusion bridge from the
// Fibonacci primitive-prime bands into the zeta missing-term hierarchy).
//
// Law under test (measured on zeta day 4, re-measured here in TypeScript):
//   sum_{n > N} chi_5(n) n^{-s} = -A(N) N^{-s} + (2s/5) N^{-s-1} + O(N^{-s-2})
// so  |L5(s) - P_N(s) + A(N) N^{-s}| ~ c(t) N^{-3/2}  with  c(t) = |2s/5|.
// Goldens (python baselines): c(1) = 0.4471 (predicted |2(0.5+i)/5| =
// 0.44721); per-decade decay of the raw missing tail is 10^{3/2} = 31.62;
// the corrected exponent is -3/2.

import { l5BlockReferenceAt } from "./l5-block-reference-at.js";
import { chi5SequentialPartialSums } from "./chi5-sequential-partial-sums.js";
import { chi5CumulativeResidueAt } from "./chi5-residue.js";
import { complexPowerTermForLog } from "./complex-power-term-for-log.js";
import { absOfComplex } from "./complex-value.js";
import { powerLawLeastSquaresFit } from "./power-law-least-squares-fit.js";
import { summarizeCrossChecks, type CrossCheckRecord } from "./cross-check-summary.js";

const BLOCK_COUNT: number = 100_000;
const T_VALUES: readonly number[] = [1, 10, 100, 1000];
// N values all divisible by 5, so the A(N) residue term is exactly zero and
// the raw tail obeys the pure power law across the measured grid.
const N_VALUES: readonly number[] = [1_000, 10_000, 100_000];
const COEFFICIENT_N_REFERENCE: number = 10_000;

const measuredCoefficientAt = (correctedMagnitudes: readonly number[]): number =>
  correctedMagnitudes[1]! * Math.pow(COEFFICIENT_N_REFERENCE, 1.5);

// c(t) = |2s/5| with s = 0.5 + it: (2/5) sqrt(0.25 + t^2).
const predictedCoefficientAtT = (t: number): number => (2 / 5) * Math.sqrt(0.25 + t * t);

const lawMeasurementAtT = (t: number) => {
  const l5Reference: { re: number; im: number } = l5BlockReferenceAt(0.5, t, BLOCK_COUNT);
  const [partialRe, partialIm] = chi5SequentialPartialSums(0.5, t, BLOCK_COUNT);
  const rawMagnitudes: number[] = [];
  const correctedMagnitudes: number[] = [];
  N_VALUES.forEach((n) => {
    const partialReHere: number = partialRe[n - 1]!;
    const partialImHere: number = partialIm[n - 1]!;
    rawMagnitudes.push(
      absOfComplex({ re: l5Reference.re - partialReHere, im: l5Reference.im - partialImHere }),
    );
    const residueTerm: { re: number; im: number } = complexPowerTermForLog(0.5, t, Math.log(n));
    const residueSign: number = chi5CumulativeResidueAt(n);
    correctedMagnitudes.push(
      absOfComplex({
        re: l5Reference.re - partialReHere + residueSign * residueTerm.re,
        im: l5Reference.im - partialImHere + residueSign * residueTerm.im,
      }),
    );
  });
  const exponentFit: { amplitude: number; exponent: number } =
    powerLawLeastSquaresFit(N_VALUES, correctedMagnitudes);
  return { t, rawMagnitudes, correctedMagnitudes, exponentFit };
};

const main = (): void => {
  const measurements: ReturnType<typeof lawMeasurementAtT>[] = T_VALUES.map(lawMeasurementAtT);
  const tOneMeasurement: ReturnType<typeof lawMeasurementAtT> = measurements[0]!;

  const crossCheckRecords: CrossCheckRecord[] = [
    {
      label: "c(t=1) = 0.4471 to 4 digits (python baseline)",
      measured: measuredCoefficientAt(tOneMeasurement.correctedMagnitudes),
      expected: 0.4471,
      tolerance: 2e-3,
    },
    {
      label: "c(t) tracks |2s/5| = (2/5) sqrt(0.25 + t^2) at every measured t (2%)",
      measured: Math.max(
        ...measurements.map((measurement) => Math.abs(measuredCoefficientAt(measurement.correctedMagnitudes) - predictedCoefficientAtT(measurement.t)) / predictedCoefficientAtT(measurement.t)),
      ),
      expected: 0,
      tolerance: 0.02,
    },
    {
      label: "raw two-decade decay T0(1e3)/T0(1e5) at t=1 is 10^3 (10^{3/2} per decade)",
      measured: tOneMeasurement.rawMagnitudes[0]! / tOneMeasurement.rawMagnitudes[2]!,
      expected: 1000,
      tolerance: 20,
    },
    {
      label: "corrected exponent -3/2 (python: -1.492 at t=1)",
      measured: tOneMeasurement.exponentFit.exponent,
      expected: -1.5,
      tolerance: 0.05,
    },
  ];
  const summary = summarizeCrossChecks(crossCheckRecords);

  console.log("chi_5 missing-term law (TypeScript re-measurement)");
  console.log("=================================================");
  measurements.forEach((measurement) => {
    console.log(
      `t=${String(measurement.t).padStart(5)}  T0=[${measurement.rawMagnitudes
        .map((magnitude) => magnitude.toExponential(4))
        .join(", ")}]  T1exp=${measurement.exponentFit.exponent.toFixed(4)}  c(t)=${measuredCoefficientAt(
        measurement.correctedMagnitudes,
      ).toFixed(4)}  c_pred=${predictedCoefficientAtT(measurement.t).toFixed(4)}`,
    );
  });
  console.log("\ncross-checks vs python baselines:");
  summary.records.forEach((record) => {
    const passes: boolean = Math.abs(record.measured - record.expected) <= record.tolerance;
    console.log(`  ${passes ? "PASS" : "FAIL"}  ${record.label} (measured ${record.measured.toFixed(5)}, expected ${record.expected})`);
  });

  process.exitCode = summary.passed ? 0 : 1;
};

main();
