// Sequential partial sums P_N(s) = sum_{n <= N} chi_5(n) n^{-s} for
// N = 1..count, returned as parallel re/im arrays (index n-1 holds P_n).
export const chi5SequentialPartialSums = (
  realPartOfExponent: number,
  imaginaryPartOfExponent: number,
  count: number,
): readonly [Float64Array, Float64Array] => {
  const realRunning: Float64Array = new Float64Array(count);
  const imaginaryRunning: Float64Array = new Float64Array(count);
  let runningRe: number = 0;
  let runningIm: number = 0;
  let n: number = 1;
  while (n <= count) {
    const residue: number = n % 5;
    const magnitude: number = Math.exp(-realPartOfExponent * Math.log(n));
    const phase: number = -imaginaryPartOfExponent * Math.log(n);
    const sign: number = residue === 0 ? 0 : residue === 1 || residue === 4 ? 1 : -1;
    runningRe += sign * magnitude * Math.cos(phase);
    runningIm += sign * magnitude * Math.sin(phase);
    realRunning[n - 1] = runningRe;
    imaginaryRunning[n - 1] = runningIm;
    n += 1;
  }
  return [realRunning, imaginaryRunning] as const;
};
