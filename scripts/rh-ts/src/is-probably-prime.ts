// Deterministic Miller-Rabin: the first 12 primes as witnesses cover all
// composites below 3.3e24 (Jaeschke 1993); this bounds the range in which
// "probably prime" is actually certain for inputs at the F_n sizes used.
const SMALL_TEST_PRIMES: readonly number[] = [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37];

const modPowLocal = (base: bigint, exponent: bigint, modulus: bigint): bigint => {
  let result: bigint = 1n;
  let runningBase: bigint = base % modulus;
  let runningExponent: bigint = exponent;
  while (runningExponent > 0n) {
    result = (runningExponent & 1n) === 1n ? (result * runningBase) % modulus : result;
    runningBase = (runningBase * runningBase) % modulus;
    runningExponent >>= 1n;
  }
  return result;
};

const passesMillerRabinWitness = (
  witness: bigint,
  oddPart: bigint,
  shift: number,
  candidate: bigint,
): boolean => {
  let residue: bigint = modPowLocal(witness, oddPart, candidate);
  let round: number = 0;
  let verdict: boolean | null = residue === 1n || residue === candidate - 1n ? true : null;
  while (verdict === null && round < shift - 1) {
    residue = (residue * residue) % candidate;
    verdict = residue === candidate - 1n ? true : residue === 1n ? false : verdict;
    round += 1;
  }
  return verdict === null ? false : verdict;
};

const splitPowerOfTwo = (value: bigint): { readonly oddPart: bigint; readonly shift: number } => {
  let shift: number = 0;
  let running: bigint = value;
  while (running % 2n === 0n) {
    running >>= 1n;
    shift += 1;
  }
  return { oddPart: running, shift };
};

const allWitnessesPass = (candidate: bigint, oddPart: bigint, shift: number): boolean => {
  let witnessIndex: number = 0;
  let allPass: boolean = true;
  while (witnessIndex < SMALL_TEST_PRIMES.length && allPass) {
    const witness: bigint = BigInt(SMALL_TEST_PRIMES[witnessIndex]!);
    allPass = witness >= candidate
      ? true
      : passesMillerRabinWitness(witness, oddPart, shift, candidate);
    witnessIndex += 1;
  }
  return allPass;
};

export const isProbablyPrime = (candidate: bigint): boolean => {
  const belowTwo: boolean = candidate < 2n;
  const matchesSmallPrime: boolean = SMALL_TEST_PRIMES.some((smallPrime) => candidate === BigInt(smallPrime));
  const divisibleBySmallPrime: boolean = SMALL_TEST_PRIMES.some(
    (smallPrime) => candidate % BigInt(smallPrime) === 0n,
  );
  const { oddPart, shift } = splitPowerOfTwo(candidate - 1n);
  const strongResult: boolean = allWitnessesPass(candidate, oddPart, shift);
  return belowTwo ? false : matchesSmallPrime ? true : divisibleBySmallPrime ? false : strongResult;
};
