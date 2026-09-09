export interface StrippedRemainder {
  readonly remainder: bigint;
  readonly strippedPrimes: readonly number[];
}

export const stripSmallFactorRemainderOf = (
  value: bigint,
  primeList: readonly number[],
): StrippedRemainder => {
  let index: number = 0;
  let remainder: bigint = value;
  let strippedPrimes: number[] = [];
  while (index < primeList.length && remainder > 1n) {
    const prime: number | undefined = primeList[index];
    const divides: boolean = prime !== undefined && remainder % BigInt(prime) === 0n;
    while (divides && prime !== undefined && remainder % BigInt(prime) === 0n) remainder = remainder / BigInt(prime);
    strippedPrimes = divides && prime !== undefined ? [...strippedPrimes, prime] : strippedPrimes;
    index += 1;
  }
  return { remainder, strippedPrimes };
};
