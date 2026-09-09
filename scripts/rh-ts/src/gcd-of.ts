export const gcdOf = (valueA: bigint, valueB: bigint): bigint => {
  let left: bigint = valueA <= 0n ? -valueA : valueA;
  let right: bigint = valueB <= 0n ? -valueB : valueB;
  while (right !== 0n) {
    const remainder: bigint = left % right;
    left = right;
    right = remainder;
  }
  return left;
};
