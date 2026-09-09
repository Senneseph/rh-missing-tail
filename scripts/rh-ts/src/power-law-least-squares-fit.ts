export interface PowerLawFit {
  readonly amplitude: number;
  readonly exponent: number;
}

// Least-squares fit of log(magnitude) ~ log(amplitude) + exponent * log(x).
export const powerLawLeastSquaresFit = (
  xValues: readonly number[],
  magnitudes: readonly number[],
): PowerLawFit => {
  const usablePairs: readonly [number, number][] = xValues
    .map((x, position) => [x, magnitudes[position]!] as [number, number])
    .filter((pair) => pair[0] > 0 && pair[1] > 0);
  const pairCount: number = usablePairs.length;
  const sumLogX: number = usablePairs.reduce((total, pair) => total + Math.log(pair[0]), 0);
  const sumLogY: number = usablePairs.reduce((total, pair) => total + Math.log(pair[1]), 0);
  const sumLogXLogY: number = usablePairs.reduce((total, pair) => total + Math.log(pair[0]) * Math.log(pair[1]), 0);
  const sumLogXLogX: number = usablePairs.reduce((total, pair) => total + Math.log(pair[0]) ** 2, 0);
  const denominator: number = pairCount * sumLogXLogX - sumLogX ** 2;
  const exponent: number = denominator === 0 ? 0 : (pairCount * sumLogXLogY - sumLogX * sumLogY) / denominator;
  const amplitude: number = Math.exp((sumLogY - exponent * sumLogX) / pairCount);
  return { amplitude, exponent };
};
