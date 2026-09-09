import { gcdOf } from "./gcd-of.js";

const floydIteration = (
  candidate: bigint,
  seedConstant: bigint,
  maxSteps: number,
): bigint => {
  let xPoint: bigint = 2n;
  let yPoint: bigint = 2n;
  let divergence: bigint = 1n;
  let stepsTaken: number = 0;
  while (divergence === 1n && stepsTaken < maxSteps) {
    xPoint = (xPoint * xPoint + seedConstant) % candidate;
    yPoint = (yPoint * yPoint + seedConstant) % candidate;
    yPoint = (yPoint * yPoint + seedConstant) % candidate;
    const rawDifference: bigint = (xPoint - yPoint) % candidate;
    const difference: bigint = rawDifference < 0n ? rawDifference + candidate : rawDifference;
    divergence = gcdOf(difference, candidate);
    stepsTaken += 1;
  }
  return divergence;
};

export const pollardRhoFactorOf = (candidate: bigint): bigint => {
  let seed: bigint = 1n;
  let factor: bigint = 1n;
  while ((factor === 1n || factor >= candidate) && seed < 64n) {
    seed += 1n;
    factor = floydIteration(candidate, seed, 300_000);
  }
  return factor > 1n && factor < candidate ? factor : 0n;
};
