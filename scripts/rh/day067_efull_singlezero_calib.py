#!/usr/bin/env python3
"""day067 - 0272 unit: Efull single-zero calibration at KNOWN on-line
zeros (route (b) local-identity attack line, per 0271).

The Efull per-zero PRIMARY FACTOR in the product form (day029
quad_interval, verbatim): for zero r = 1/2 + i g and probe
s = 1/2 + i t,

  K_g(s) = (1 - s/r) (1 + s/r) = 1 - s^2/r^2,

and the Efull kernel p(g;t) = Re log K_g(s) plus the smooth
W2K-correction terms (-log(g^2+1/4) + 0.5/(g^2+1/4)) which carry NO
singularity. Near s -> r (t -> g, delta = t - g):

  |K_g| = |(r - s)(r + s)| / |r|^2  =  |delta| * |2r + i delta| / |r|^2,
  log|zeta(1/2 + i t)| = log|delta| + log|zeta'(r)| + o(1)   (simple zero),

so the SINGULAR PARTS CANCEL and the desingularized quantity

  M_K(t; g) := log|zeta(1/2 + i t)| - log|K_g(1/2 + i t)|,
  M_K(g; g)  = log|zeta'(r)| - log 2 + log|r|     holds EXACTLY.

This probe verifies, at the first five on-line zeros:
  (a) direct:     L  = log|zeta'(r)| - log 2 + log|r|  (mpmath derivative);
  (b) desingularized: M_K(g + delta; g) for delta -> 0, 3-point Newton
      extrapolation to delta = 0 (the residual is smooth in delta);
  (c) |L_a - L_b| -> 0 within error bars  -  the calibration constant
      for the local identity: the Efull kernel absorbs the on-line zero
      EXACTLY, leaving residue log|zeta'/2| + log|r| (the classical
      zero-derivative residue, genus-1 primary factor conventions).

The smooth W2K terms (-log(g^2+1/4) + 0.5/(g^2+1/4)) are added back at
the end as a plain finite correction to both sides (they do not
participate in the singularity match).

The off-line extension (0273): a hypothetical off-line zero rho in the
terminal strip would force the SAME local identity with the off-line
primary factor; the known-zero side is evaluable EXACTLY below tPT2
(bit-pinned Platt record, 0263) and the unknown-zero side is bounded by
R-vM spacing in a nearby box. No RH claim: calibration at KNOWN zeros
only.
"""
import mpmath as mpm

mpm.mp.dps = 60
LOG2 = mpm.log(2)

GAMMA_SEEDS = [
    "14.13472514173469379045725198356247",
    "21.02203963877155499322816114064710",
    "25.01085758014568876321379099256282",
    "30.42487612585951321031185793008222",
    "32.93506158773918969062266710552523",
]


def locate_zero(seed):
    """refine the seed to dps: h(t) = Re(zeta(1/2+it)) changes sign at
    each simple on-line zero; expand the bracket to a full sign change,
    then standard bisection (flip the non-changing side)."""
    seed = mpm.mpf(seed)
    h = lambda t: mpm.re(mpm.zeta(mpm.mpc(0.5, t)))
    span = mpm.mpf("0.05")
    for _ in range(20):
        lo, hi = seed - span, seed + span
        flo, fhi = h(lo), h(hi)
        if flo * fhi < 0:
            break
        span *= 2
    steps = 0
    while (hi - lo) > mpm.mpf("1e-55") and steps < 150:
        mid = (lo + hi) / 2
        fmid = h(mid)
        if fmid == 0:
            break
        if flo * fmid < 0:
            hi, fhi = mid, fmid
        else:
            lo, flo = mid, fmid
        steps += 1
    g = (lo + hi) / 2
    check = mpm.fabs(mpm.zeta(mpm.mpc(0.5, g)))
    return g, check, steps


def kfactor(g, t):
    """|K_g(s)| with r = 1/2 + i g, s = 1/2 + i t (exact complex form)."""
    r = mpm.mpc(0.5, g)
    s = mpm.mpc(0.5, t)
    return mpm.fabs((1 - s / r) * (1 + s / r))


def m_k(g, t):
    return mpm.log(mpm.fabs(mpm.zeta(mpm.mpc(0.5, t)))) - mpm.log(kfactor(g, t))


def extrapolate(points):
    """Newton divided-difference interpolant of (x_i, y_i) at x = 0.
    points sorted by increasing x; n = len >= 2."""
    xs = [p[0] for p in points]
    table = [list(p[1] for p in points)]
    for k in range(1, len(xs)):
        row = []
        prev = table[-1]
        for i in range(len(prev) - 1):
            x0, x1 = xs[i], xs[i + k]
            row.append((prev[i + 1] - prev[i]) / (x1 - x0))
        table.append(row)
    # Lagrange-at-0 form from the divided differences is overkill; the
    # Newton form  P(0) = c0 + c1*(0-x0) + c2*(0-x0)(0-x1) + ...
    acc = table[0][0]
    prod = mpm.mpf(1)
    for k in range(1, len(xs)):
        prod *= (0 - xs[k - 1])
        acc += table[k][0] * prod
    return acc


def main():
    print("0272 calibration: single-zero Efull identity at known on-line zeros")
    print("identity:  M_K(g;g) := lim_{t->g} [log|zeta(1/2+it)| - log|K_g(1/2+it)|")
    print("             = log|zeta'(1/2+ig)| - log 2 + log|1/2+ig|   (simple zero)")
    print()
    print(f"{'k':>3} | {'gamma':>30} | |zeta(at g)|:13 | {'L_direct':>14} | "
          f"{'L_extrap':>14} | {'diff':>11} | tail (M_K at g+d, d=1e-2..1e-7)")
    ds = ["1e-2", "1e-3", "1e-4", "1e-5", "1e-6", "1e-7"]
    worst = 0
    for i, seed in enumerate(GAMMA_SEEDS, 1):
        g, check, steps = locate_zero(seed)
        r = mpm.mpc(0.5, g)
        zp = mpm.diff(lambda x: mpm.zeta(mpm.mpc(0.5, x)), g)
        L_direct = mpm.log(mpm.fabs(zp)) - LOG2 + mpm.log(mpm.fabs(r))
        pts = [(mpm.mpf(d), m_k(g, g + mpm.mpf(d))) for d in ds][-4:]
        L_ex = extrapolate(pts)
        diff = float(L_ex - L_direct)
        worst = max(worst, abs(diff))
        tail = " ".join(f"{float(m_k(g, g + mpm.mpf(d))):.5f}" for d in ds)
        print(f"{i:>3} | {float(g):.30g} | {float(check):.2e} | {float(L_direct):+.10f} | "
              f"{float(L_ex):+.10f} | {diff:+.3e} | {tail}")
    print()
    print(f"worst |L_extrap - L_direct| over the 5 zeros: {worst:.3e}")
    print()
    print("interpretation (0272):")
    print(" - the singular parts CANCEL exactly: M_K is finite at the zero")
    print(" - the removable value is the zero-derivative residue (genus-1")
    print("   primary-factor conventions):  M_K(g;g) = log|zeta'(r)| - log 2 + log|r|")
    print(" - these are the calibration constants for the 0273 off-line unit:")
    print("   a hypothetical off-line zero rho in the terminal strip must make")
    print("   the SAME identity hold with the off-line primary factor; the right")
    print("   side is then a function of rho and the KNOWN zero field - evaluable")
    print("   exactly below tPT2 (bit-pinned Platt record, 0263) + R-vM-bounded")
    print("   unknown side. 0273 measures the residual at trial rho in the strip.")


if __name__ == "__main__":
    main()
