// The certified zero finder (the crown jewel): takes a zero index n and a
// certified anchor (walkFrom, nStart = exact N(walkFrom)), walks the Z(t)
// sign flips at twin-floor resolution over the window around the RVM
// bracket of n, and returns the (n - nStart)-th flip, floated by bisection.
//
// Protocol (the project's hard rules):
//  - dt = 2.5e-4 (below the measured twin floor through 1e6: min gap 2.95e-3)
//  - the count certificate for a window is a dt/2 stability re-walk of the
//    same window (2K is parity only — never the count)
//  - the anchor nStart is dps-certified (the 1e5 census: N(1e5) = 138,065)
// Output: { gammaFloat, relativeFlipIndex, deltaN, window } — the dps tail
// (40-digit refinement + off-line anomaly check) is the mpmath script
// day007_zero_at_dps.py, fed with gammaFloat.

import { rsZValueOfT } from "./rs-z-value-of-t.ts";
import { zeroBracketOf } from "./zero-bracket-of.ts";

export type ZeroFound = {
  readonly gammaFloat: number;
  readonly relativeFlipIndex: number;
  readonly deltaN: number;
  readonly window: readonly [number, number];
};

export const ZERO_AT_DT = 2.5e-4;

const flipsIn = (lo: number, hi: number, dt: number): number[] => {
  const nSteps: number = Math.max(1, Math.floor((hi - lo) / dt));
  let prevZ: number = rsZValueOfT(lo);
  const marks: number[] = [];
  Array.from({ length: nSteps }, (_, k) => k + 1).forEach((k) => {
    const tCur: number = lo + k * dt;
    const zCur: number = rsZValueOfT(tCur);
    marks.push(prevZ * zCur < 0 ? tCur - dt : Number.NaN);
    prevZ = zCur;
  });
  return marks.filter((v) => !Number.isNaN(v));
};

const bisectZero = (a: number, b: number): number => {
  const final: readonly [number, number] = Array.from({ length: 48 }).reduce(
    (state: readonly [number, number]) => {
      const lo: number = state[0];
      const hi: number = state[1];
      const mid: number = 0.5 * (lo + hi);
      const zm: number = rsZValueOfT(mid);
      const za: number = rsZValueOfT(lo);
      const next: readonly [number, number] = za * zm <= 0 ? [lo, mid] : [mid, hi];
      return next;
    },
    [a, b],
  );
  return 0.5 * (final[0] + final[1]);
};

export const zeroAt = (n: number, walkFrom: number, nStart: number): ZeroFound => {
  // v0 protocol: walk the FULL range [walkFrom, hi] so the flip index is
  // exactly (n - nStart) relative to the certified anchor. (For very large
  // n, re-anchor at a higher certified height first — see the dps runner.)
  const t0: number = zeroBracketOf(n)[0];
  const spacing: number = zeroBracketOf(n)[1];
  const w: number = Math.max(0.75, 16 * spacing);
  const lo: number = walkFrom;
  const hi: number = t0 + w;
  const flips: number[] = flipsIn(lo, hi, ZERO_AT_DT);
  const rel: number = n - nStart;
  const found: boolean = rel >= 1 && rel <= flips.length;
  const flipAt: number = found ? flips[rel - 1]! : Number.NaN;
  // The flip marker is the LOWER grid point of the sign-change interval
  // [flipAt, flipAt+dt]; the zero lies strictly inside it.
  const gamma: number = found ? bisectZero(flipAt, flipAt + ZERO_AT_DT) : Number.NaN;
  const guard: number = found
    ? 0
    : (() => {
        throw new Error(
          `zero index ${n}: flip #${rel} not found in [${lo.toFixed(3)}, ${hi.toFixed(3)}] ` +
            `(${flips.length} flips; anchor N(${walkFrom.toFixed(1)}) = ${nStart}); ` +
            `widen the window or re-anchor`,
        );
      })();
  void guard;
  return {
    gammaFloat: gamma,
    relativeFlipIndex: rel,
    deltaN: flips.length,
    window: [lo, hi],
  };
};
