import { fibModulo } from "./fib-modulo.js";
import { primeFactorsOfIndex } from "./prime-factors-of-index.js";

const shrinkToExactOrder = (
  candidate: number,
  prime: bigint,
  factors: readonly number[],
): number => {
  let runningCandidate: number = candidate;
  let factorIndex: number = 0;
  while (factorIndex < factors.length) {
    const factor: number | undefined = factors[factorIndex];
    while (
      factor !== undefined &&
      runningCandidate % factor === 0 &&
      fibModulo(Math.floor(runningCandidate / factor), prime) === 0n
    ) {
      runningCandidate = Math.floor(runningCandidate / factor);
    }
    factorIndex += 1;
  }
  return runningCandidate;
};

export const exponentOrderOfGoldenRatioModulo = (prime: bigint, bandIndex: number): number | null => {
  const primeIsOddAndLarge: boolean = prime > 2n;
  const dividesFib: boolean = primeIsOddAndLarge && fibModulo(bandIndex, prime) === 0n;
  return dividesFib ? shrinkToExactOrder(bandIndex, prime, primeFactorsOfIndex(bandIndex)) : null;
};
