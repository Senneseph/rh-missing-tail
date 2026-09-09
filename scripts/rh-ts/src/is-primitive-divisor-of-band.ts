import { exponentOrderOfGoldenRatioModulo } from "./exponent-order-of-golden-ratio.js";

// p = 5 ramifies in Q(sqrt(5)) and p = 2 degenerates the field mod 2, so the
// order criterion only applies to primes other than 2 and 5.
export const isPrimitiveDivisorOfBand = (prime: bigint, bandIndex: number): boolean =>
  prime !== 2n &&
  prime !== 5n &&
  exponentOrderOfGoldenRatioModulo(prime, bandIndex) === bandIndex;
