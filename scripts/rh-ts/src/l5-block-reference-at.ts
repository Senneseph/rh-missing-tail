import type { ComplexValue } from "./complex-value.js";

// L(s, chi_5) via exact 5-periodic blocking: sum over full blocks
// m = 0..blockCount-1 of chi-weighted (5m+r)^{-s} for r = 1..4.
// Converges like blockCount^{-(sigma + 1)}; the block form and the raw
// sequential sum are independent summation orders, so their agreement is a
// coding cross-check, not merely a self-consistency.
export const l5BlockReferenceAt = (
  realPartOfExponent: number,
  imaginaryPartOfExponent: number,
  blockCount: number,
): ComplexValue => {
  const residues: readonly number[] = [1, 2, 3, 4];
  const weights: readonly number[] = [1, -1, -1, 1];
  let accumulated: ComplexValue = { re: 0, im: 0 };
  let block: number = 0;
  while (block < blockCount) {
    let residueIndex: number = 0;
    while (residueIndex < residues.length) {
      const argument: number = 5.0 * block + residues[residueIndex]!;
      const logOfArgument: number = Math.log(argument);
      const magnitude: number = Math.exp(-realPartOfExponent * logOfArgument);
      const phase: number = -imaginaryPartOfExponent * logOfArgument;
      const sign: number = weights[residueIndex]!;
      accumulated = {
        re: accumulated.re + sign * magnitude * Math.cos(phase),
        im: accumulated.im + sign * magnitude * Math.sin(phase),
      };
      residueIndex += 1;
    }
    block += 1;
  }
  return accumulated;
};
