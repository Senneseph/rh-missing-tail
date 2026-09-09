import { trialPrimesUpTo } from "./trial-primes.js";

export const eulerPhiOf = (
  value: number,
  primeList: readonly number[] = trialPrimesUpTo(10_000),
): number => {
  let remaining: number = value;
  let runningPhi: number = value;
  let scanIndex: number = 0;
  while (
    scanIndex < primeList.length &&
    remaining > 1 &&
    primeList[scanIndex]! * primeList[scanIndex]! <= remaining
  ) {
    const prime: number = primeList[scanIndex]!;
    const dividesRemaining: boolean = remaining % prime === 0;
    while (dividesRemaining && remaining % prime === 0) remaining = Math.floor(remaining / prime);
    runningPhi = dividesRemaining ? Math.floor(runningPhi / prime) * (prime - 1) : runningPhi;
    scanIndex += 1;
  }
  const finalPhi: number = remaining > 1 ? Math.floor(runningPhi / remaining) * (remaining - 1) : runningPhi;
  return finalPhi;
};
