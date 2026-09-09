// Fast-doubling Fibonacci mod m, state kept reduced so every product fits in
// a bounded number of machine words; bigint state is retained so the module
// accepts prime factors at the full F_n size (up to ~2^137 for n <= 400).
export const fibModulo = (index: number, modulus: bigint): bigint => {
  const MODULUS: bigint = modulus;
  let bitLength: number = 0;
  let probe: bigint = index >= 1 ? BigInt(index) : 1n;
  while (probe > 0n) {
    probe >>= 1n;
    bitLength += 1;
  }
  const runningIndex: bigint = BigInt(index);
  let highestBit: bigint = index >= 1 ? 1n << BigInt(bitLength - 1) : 0n;
  let lowFib: bigint = 0n;
  let highFib: bigint = 1n;
  while (highestBit > 0n) {
    const bitSet: boolean = (runningIndex & highestBit) === highestBit;
    const doubledLow: bigint = (lowFib * ((highFib << 1n) - lowFib + MODULUS)) % MODULUS;
    const doubledHigh: bigint = (lowFib * lowFib + highFib * highFib) % MODULUS;
    const nextLow: bigint = bitSet ? doubledHigh : doubledLow;
    const nextHigh: bigint = bitSet ? (doubledLow + doubledHigh) % MODULUS : doubledHigh;
    lowFib = nextLow;
    highFib = nextHigh;
    highestBit >>= 1n;
  }
  return lowFib;
};
