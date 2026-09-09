export const modPow = (base: bigint, exponent: bigint, modulus: bigint): bigint => {
  let carry: bigint = 1n;
  let remaining: bigint = exponent;
  let baseResidue: bigint = base % modulus;
  const squareBase: () => void = () => { baseResidue = (baseResidue * baseResidue) % modulus; };
  while (remaining > 0n) {
    while (remaining > 0n && (remaining & 1n) === 0n) {
      remaining >>= 1n;
      squareBase();
    }
    while (remaining > 0n && (remaining & 1n) === 1n) {
      carry = (carry * baseResidue) % modulus;
      remaining >>= 1n;
      squareBase();
    }
  }
  return carry;
};
