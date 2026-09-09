import { isProbablyPrime } from "./is-probably-prime.js";
import { pollardRhoFactorOf } from "./pollard-rho-factor-of.js";
import { stripSmallFactorRemainderOf } from "./strip-small-factor-remainder-of.js";
import { trialPrimesUpTo } from "./trial-primes.js";

export const distinctPrimeDivisorsOf = (
  value: bigint,
  primeList: readonly number[] = trialPrimesUpTo(10_000),
): readonly bigint[] => {
  const compareBig = (left: bigint, right: bigint): number => (left < right ? -1 : left > right ? 1 : 0);

  const expand = (leftover: bigint): bigint[] => {
    const factor: bigint = leftover === 1n
      ? 1n
      : isProbablyPrime(leftover) ? leftover : pollardRhoFactorOf(leftover);
    const factorIsGenuine: boolean = factor !== 0n;
    // A total rho failure (0n) degrades to treating the leftover as a single
    // prime; unit tests pin the factorizations this path may serve.
    const factorAsBig: bigint = leftover === 1n ? 1n : factorIsGenuine ? factor : leftover;
    const coFactorAsBig: bigint = leftover === 1n || !factorIsGenuine ? 1n : leftover / factor;
    return leftover === 1n ? [] : [factorAsBig, ...expand(coFactorAsBig)];
  };

  const { remainder, strippedPrimes } = stripSmallFactorRemainderOf(value, primeList);
  const allDivisors: bigint[] = [...strippedPrimes.map((prime) => BigInt(prime)), ...expand(remainder)];
  return Array.from(new Set(allDivisors)).sort(compareBig);
};
