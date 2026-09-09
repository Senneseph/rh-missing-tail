import { trialPrimesUpTo } from "./trial-primes.js";

export const primeFactorsOfIndex = (
  index: number,
  primeList: readonly number[] = trialPrimesUpTo(10_000),
): readonly number[] => {
  let collected: number[] = [];
  let remaining: number = index;
  let scanIndex: number = 0;
  while (scanIndex < primeList.length && remaining > 1) {
    const prime: number = primeList[scanIndex]!;
    const dividesIndex: boolean = remaining % prime === 0;
    collected = dividesIndex ? [...collected, prime] : collected;
    while (dividesIndex && remaining % prime === 0) remaining = Math.floor(remaining / prime);
    scanIndex += 1;
  }
  return collected;
};
