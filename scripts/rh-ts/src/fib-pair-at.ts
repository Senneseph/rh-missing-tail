export interface FibPair {
  readonly current: bigint;
  readonly next: bigint;
}

export const fibPairAt = (index: number): FibPair =>
  index < 2
    ? { current: BigInt(index), next: 1n }
    : (() => {
        const half: FibPair = fibPairAt(Math.floor(index / 2));
        const doubledEven: bigint = half.current * (2n * half.next - half.current);
        const doubledOdd: bigint = half.current ** 2n + half.next ** 2n;
        return index % 2 === 0
          ? { current: doubledEven, next: doubledOdd }
          : { current: doubledOdd, next: doubledEven + doubledOdd };
      })();

export const fibValueAt = (index: number): bigint => fibPairAt(index).current;
