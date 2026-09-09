// Riemann–von Mangoldt main-term inversion: given a zero index n, find a
// height T0 with N(T0) ~= n, and the local zero spacing (2pi/ln(T0/2pi)).
// Main term: N(T) = T/(2pi) * (ln(T/(2pi)) - 1) + 7/8 + S(T)  (S = O(1);
// measured max|S| ~ 5 through 1e6).
// Newton on f(T) = T/(2pi)(ln(T/(2pi)) - 1) + 7/8,  f'(T) = ln(T/(2pi))/(2pi).
// Fixed 24 iterations (quadratic convergence; no branch needed).

const TWO_PI = 2 * Math.PI;

export const zeroBracketOf = (n: number): readonly [number, number] => {
  const checkN: number =
    n >= 1 ? n : (() => { throw new Error("zero index n must be >= 1"); })();
  const t0: number = 2 * Math.PI * (checkN <= 1 ? 3 : checkN / Math.max(1, Math.log(2 * checkN)));
  const tFinal: number = Array.from({ length: 24 }, (_, i) => i).reduce(
    (tCur: number) => {
      const u = tCur / TWO_PI;
      const f = u * (Math.log(u) - 1) + 0.875 - checkN;
      const fp = Math.log(u) / TWO_PI;
      return tCur - f / fp;
    },
    t0,
  );
  const spacing: number = TWO_PI / Math.log(tFinal / TWO_PI);
  return [tFinal, spacing];
};
