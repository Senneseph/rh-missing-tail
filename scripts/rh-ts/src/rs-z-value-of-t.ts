// The verified float64 Riemann–Siegel Z(t) engine, ported to TS.
// Port of zeta_core.Z_rs (kainos-logos, validated vs mpmath dps-30/50 on
// day-003: |Z_rs - Z_mp| measured, O(u^-5) remainder checked).
//
//   Z(t) = 2 * sum_{n=1..N} cos(theta - t*ln n)/sqrt(n) + R(t)
//   sq = sqrt(t/2pi), N = floor(sq), p = sq - N, u = sqrt(sq)
//   R  = (-1)^(N-1) * ( psi(p)/u - psiD3(p)/(96 pi^2 u^3) )
//   psi(p) = cos(2pi(p^2 - p - 1/16)) / cos(2pi p)
//
// FIDELITY NOTE (day-007 fix, 2026-09-09): the RS R term needs the TRUE
// psi'''(p). The original python engine returned RE[S]/h^3 (an O(h*psi'''')
// near-zero residual, a 35x / wrong-sign derivative error vs mpmath). The
// complex-step alternating sum S = (ih)^3 psi'''(p) - 1.5 h^4 psi''''(p) + ...
// puts the true derivative in the IMAGINARY part, so this port (and the
// day-007-patched zeta_core) compute psi'''(p) = -Im[S]/h^3. Measured dps:
// |Z - Z_mp| ~ 2e-9..1e-8 for t >= 4.5e4 (was 1e-7..1e-6); below t ~ 1e4 the
// 2-term O(u^-5) RS floor (~5e-4 at t=41, zero location offset ~1e-4) is
// intrinsic — the float engine brackets; the dps tail owns the digits.

const TWO_PI = 2 * Math.PI;

type C = readonly [number, number];

const cMul = (a: C, b: C): C => [a[0] * b[0] - a[1] * b[1], a[0] * b[1] + a[1] * b[0]];

const cDiv = (a: C, b0: C): C => {
  const d = b0[0] * b0[0] + b0[1] * b0[1];
  return [(a[0] * b0[0] + a[1] * b0[1]) / d, (a[1] * b0[0] - a[0] * b0[1]) / d];
};

const cCos = (x: number, y: number): C => [
  Math.cos(x) * Math.cosh(y),
  -Math.sin(x) * Math.sinh(y),
];

const cLog = (x: number, y: number): C => [Math.log(Math.hypot(x, y)), Math.atan2(y, x)];

// psi(p + i y)
const psiAt = (p: number, y: number): C =>
  cDiv(
    cCos(2 * Math.PI * (p * p - p - 0.0625 - y * y), 2 * Math.PI * (2 * p * y - y)),
    cCos(2 * Math.PI * p, 2 * Math.PI * y),
  );

// True psi'''(p) = -Im[S]/h^3 (day-007 fix; see fidelity note). h = 1e-3.
const PSI_ORDER: readonly number[] = [1, 3, 3, 1];

const psiThirdDerivAt = (p: number): number =>
  PSI_ORDER.map((binom, k) => {
    const sgn = (3 - k) % 2 === 0 ? 1 : -1;
    const v = psiAt(p, k * 1e-3);
    return [sgn * binom * v[0], sgn * binom * v[1]] as C;
  }).reduce((acc: C, v) => [acc[0] + v[0], acc[1] + v[1]], [0, 0] as C)[1] * -1 / 1e-9;

const LANCZOS: readonly number[] = [
  0.99999999999980993, 676.5203681218851, -1259.1392167224028, 771.32342877765313,
  -176.61502916214059, 12.507343278686905, -0.13857109526572012, 9.9843695780195716e-6,
  1.5056327351493116e-7,
];

// Im cloggamma(0.25 + 0.5 i t) — exact port of zeta_core.cloggamma
// (Lanczos, shift ns = ceil(50 - 0.25) = 50, then subtract sum log(z+i))
const imagClogGammaAtQuarter = (t: number): number => {
  const ns = Math.max(0, Math.ceil(50 - 0.25));
  const zRe = 0.25;
  const zIm = 0.5 * t;
  const wRe = zRe - 1 + ns;
  const wIm = zIm;
  const [sumRe, sumIm] = Array.from({ length: LANCZOS.length - 1 }, (_, i) => i + 1).reduce(
    (acc: C, i) => {
      const d = (wRe + i) ** 2 + wIm ** 2;
      return [acc[0] + (LANCZOS[i]! * (wRe + i)) / d, acc[1] - (LANCZOS[i]! * wIm) / d];
    },
    [LANCZOS[0]!, 0] as C,
  );
  const wPlusTRe = wRe + 7.5;
  const part = cMul([wRe + 0.5, wIm], cLog(wPlusTRe, wIm));
  const aIm = part[1] - wIm + cLog(sumRe, sumIm)[1];
  const subIm = Array.from({ length: ns }, (_, i) => i).reduce(
    (acc: number, i) => acc + cLog(zRe + i, zIm)[1],
    0,
  );
  return aIm - subIm;
};

export const varthetaOfT = (t: number): number =>
  t === 0 ? 0 : imagClogGammaAtQuarter(t) - 0.5 * t * Math.log(Math.PI);

export const rsZValueOfT = (t: number): number => {
  const safeT: number =
    t >= 40
      ? t
      : (() => {
          throw new Error("rsZValueOfT is valid for t >= 40 (use the EM engine below)");
        })();
  const sq = Math.sqrt(safeT / TWO_PI);
  const nTerms = Math.floor(sq);
  const p = sq - nTerms;
  const u = Math.sqrt(sq);
  const th = varthetaOfT(safeT);
  const sumPart = Array.from({ length: nTerms }, (_, k) => k + 1).reduce(
    (acc: number, k) => acc + (Math.cos(th - safeT * Math.log(k)) / Math.sqrt(k)),
    0,
  );
  const sign = (nTerms - 1) % 2 === 0 ? 1 : -1;
  const rTerm = sign * (psiAt(p, 0)[0] / u - psiThirdDerivAt(p) / (96 * Math.PI ** 2 * u ** 3));
  return 2 * sumPart + rTerm;
};
