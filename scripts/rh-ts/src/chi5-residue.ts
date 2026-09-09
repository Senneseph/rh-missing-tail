// chi_5(n) = (5/n): residues of n mod 5 are 0 -> 0, 1 -> +1, 2 -> -1, 3 -> -1, 4 -> +1.
const chi5ResiduesByModuloFive: readonly number[] = [0, 1, -1, -1, 1];

export const chi5At = (n: number): number => chi5ResiduesByModuloFive[((n % 5) + 5) % 5]!;

// A(N) = sum_{n <= N} chi_5(n): full 5-periods sum to 0, so only the
// residue tail of the final partial period remains.
export const chi5CumulativeResidueAt = (n: number): number => {
  const partialPeriodLength: number = n % 5;
  let accumulated: number = 0;
  let position: number = 1;
  while (position <= partialPeriodLength) {
    accumulated += chi5At(position);
    position += 1;
  }
  return accumulated;
};
