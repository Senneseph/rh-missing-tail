#!/usr/bin/env python3
# WF-24: the 24-adic FRAME WAVEFRONT probe (OFF-BOARD side quest, 0186 lane).
#
# Owner idea (2026-10-29): take a reading at the BEGINNING of the 24-adic and at
# the END, treat the prime itself as always (its class r = p mod 24), and get
# FOUR waveforms: (past, future) x (absolute, relative). Then study how they
# propagate (or how the 'holes' propagate) beginning<->end, at zero heights,
# for predictive power.
#
# Frame definition (the established 24-adic machinery, day006, 0909):
#   q = 24 phases r = 0..23 on the period cell (F_24 = fib mod 12, centered).
#   The M1 wave reading at scale N and zeta height t (S = 1/2 + i t), with n1 =
#   N aligned to phase r (n1 = N + ((r-N) mod q)):
#     v(r; n1, S) = (n1^{S+1}/S) [ sum_j c_j q^{-S} zeta(S, (n1+1-j)/q ) + P[r] n1^{-S} ]
#   PAST frame   = phase r       (the prime's own phase = beginning of its orbit)
#   FUTURE frame = phase r + 12  (the antipode, front->back = end of the 24-adic)
#   ABSOLUTE     = v itself (raw, pole part included)
#   RELATIVE     = v(r) - mean_{24 phases} v   (common pole removed)
#   => FOUR waveforms per prime class r: A_r(t), W_r(t), A_{r+12}(t), W_{r+12}(t).
#
# Propagation holes (the 'missing tail' of the frame, by construction only):
#   H_id(t)  = A_{r+12}(t) - A_r(t)   identity-propagation hole (F_24 law)
#   H_idr(t) = W_{r+12}(t) - W_r(t)   centered identity hole (pole-independent)
#   H_sf(t)  = A_{r+12}(t) + A_r(t)   sign-flip hole (tau_12 control should be small)
#
# Sampled at t = uniform grid [4..404] + 204 certified zero heights (gamma<=404).
# Controls: (1) validate M1 constants vs the 0909 recorded values; (2) tau_12
# (multiplicative cell) where the antipode law is the sign flip.
#
# NO RH CLAIM: exploratory off-board side quest; borrows the day006 machinery
# exactly; all objects are named, finite, and reproducible. 1 thread (4 cores
# left open by construction).

import os
import math
from mpmath import mp, mpf, mpc

mp.dps = 30
L = 10 ** 6           # the 0909 wave scale N
Q = 24                # phases
N1 = L + Q            # aligned window: n1(r) = L + d(r), d in 0..23 -> n1 in L..L+23

# day006 zeta argument = nf/q where nf = first integer in class j (mod q) with
# nf >= n1+1  (the residue-class TAIL above the cut, NOT the naive (n1+1-j)/q).
# Write n1 = a*q + e (a = n1 div q, e in 0..q-1, e=0 <=> class q). Then
#   nf = a*q + j          j >  e  (and always for j = q)
#   nf = a*q + q + j      j <= e  (j in 1..q-1)
# so the argument per (t) lives on 3 integer parts k in {a0, a0+1, a0+2}
# where a0 = L div q, with fractions j/q.
KA_LO = L // Q
KA_HI = (L + Q - 1) // Q + 1     # max (a) + 1 over all cuts

def fib_cell_24():
    a, b, out = 1, 1, []
    while True:
        out.append(a % 12)
        a, b = b, (a + b) % 12
        if a % 12 == 1 and b % 12 == 1 and len(out) >= 2:
            break
    assert len(out) == 24, len(out)
    return [mpf(v) - mpf("9/2") for v in out]

def tau12_cell_24():
    def t12(j):  # j in 1..12 (primitive real Dirichlet mod 12)
        if j % 2 == 0 or j % 3 == 0:
            return mpf(0)
        return mpf(1) if ((j % 4 == 1 and j % 3 == 1) or (j % 4 == 3 and j % 3 == 2)) else mpf(-1)
    return [t12(((j - 1) % 12) + 1) for j in range(1, Q + 1)]

def cumrow(cell):
    P = [0] * Q
    for i in range(1, Q):
        P[i] = P[i - 1] + cell[i - 1]
    return P

def d_of(r):
    return (r - L) % Q

def n1_of(r):
    return L + d_of(r)

def zeta_lattice(S):
    """ZA[k][j] = q^{-S} zeta(S, (k*q + j)/q) for k in KA_LO..KA_HI, j in 1..q."""
    qmss = mp.power(mpf(Q), -S)
    ZA = {}
    for k in range(KA_LO, KA_HI + 1):
        row = [mpf(0)]
        for j in range(1, Q + 1):
            row.append(mp.zeta(S, (mpf(k * Q) + mpf(j)) / Q) * qmss)
        ZA[k] = row
    return ZA

def readings_at(cell, P, ZA, S):
    """all 24 phase readings v(r) from the zeta lattice ZA (day006 tail args)."""
    out = []
    for r in range(Q):
        n1i = n1_of(r)
        a, e = divmod(n1i, Q)
        n1 = mpf(n1i)
        total = mpc(0)
        for j in range(1, Q + 1):
            cj = cell[j - 1]
            if cj == 0:
                continue
            k = a + (1 if (j < Q and j <= e) else 0)
            total += cj * ZA[k][j]
        total += P[r] * mp.power(n1, -S)
        out.append(total * mp.power(n1, S + 1) / S)
    return out

def read_grid(cell, P, ts):
    """v(r; n1(r), S(t)) for all r, for each t. 3x24 lattice points per t."""
    allv = []
    for t in ts:
        S = mp.mpf("0.5") + mp.j * t
        ZA = zeta_lattice(S)
        allv.append(readings_at(cell, P, ZA, S))
    return allv

def m1_fitted(cell, P, r, S):
    """3-cut c1 tail fit -> N-stable M1(r) (the 0909 constant)."""
    n0 = n1_of(r)
    vs = []
    for c in (0, 1, 4):
        n1i = n0 + c * Q
        a, e = divmod(n1i, Q)
        qmss = mp.power(mpf(Q), -S)
        total = mpc(0)
        for j in range(1, Q + 1):
            cj = cell[j - 1]
            if cj == 0:
                continue
            k = a + (1 if (j < Q and j <= e) else 0)
            total += cj * qmss * mp.zeta(S, (mpf(k * Q) + mpf(j)) / Q)
        n1 = mpf(n1i)
        total += P[r] * mp.power(n1, -S)
        vs.append(total * mp.power(n1, S + 1) / S)
    inv = [1 / mpf(n0 + c * Q) for c in (0, 1, 4)]
    c1 = (vs[0] - vs[1]) / (inv[0] - inv[1])
    M0 = vs[0] - c1 * inv[0]
    M2 = vs[2] - c1 * inv[2]
    return (M0 + M2) / 2

def nstr(z, n=8):
    return mp.nstr(z, n)

def main():
    out = []
    def rep(s=""):
        print(s)
        out.append(s)

    rep("WF-24: 24-adic frame wavefront probe (OFF-BOARD; no RH claim)")
    rep(f"  scale N = {L}, q = {Q}, dps = {mp.dps}")

    # ---- t samples ---------------------------------------------------------
    ts_uniform = [mpf(4) + mpf(0.5) * mpf(k) for k in range(801)]  # 4..404
    gpath = "/home/jsmille/Projects/rh-missing-tail/scripts/rh/lowt/zeros_0_to_1p2e3.dec20.txt"
    gammas = []
    with open(gpath) as f:
        for line in f:
            g = mpf(line.strip())
            if mpf("4") <= g <= mpf("404"):
                gammas.append(g)
    rep(f"  t samples: uniform {len(ts_uniform)} (4..404 step 0.5), "
        f"certified zeros {len(gammas)} (gamma<=404)")

    cells = {
        "F_24 (non-multiplicative; fib mod 12 centered)": fib_cell_24(),
        "tau_12x24 (multiplicative control)": tau12_cell_24(),
    }
    FRONT = [1, 5, 7, 11]   # prime residue classes mod 24 (front half)

    for name, cell in cells.items():
        P = cumrow(cell)
        rep(f"\n== {name} ==")

        # ---- validation: M1 constants at t=10 vs 0909 -----------------------
        S10 = mp.mpf("0.5") + mp.j * mpf(10)
        M = [m1_fitted(cell, P, r, S10) for r in range(Q)]
        if "F_24" in name:
            # day006 ORIGINAL machine values (verbatim port, 3-cut; the 0909
            # dps-40 6-cut rerun is flagged ill-conditioned for this cell:
            # 'CONVERGED? NO ... NOT a result'). Expect c2-curvature dev ~1e-3.
            refs = {0: (-17483.0832294, 349134.164589),
                    1: (-17484.8506858, 349134.513716),
                    5: (-17460.9205112, 349135.910224),
                    12: (-17443.2927058, 349138.354115),
                    13: (-17443.0601621, 349138.703242)}
            rep("   M1 constants (3-cut, t=10) vs day006 ORIGINAL machine "
                "(mechanism-identity gate; dev ~ c2/1e12 curvature):")
            for r in sorted(refs):
                rr, ri = refs[r]
                dev = abs(M[r] - (mpf(rr) + mp.j * mpf(ri)))
                rep(f"     r={r:2d}: |fit-ref| = {nstr(dev, 5)}   (fit {nstr(M[r], 11)})")
        else:
            # from out_day006_cyclotomic_12_24.txt quadrant 4-tuples:
            # [0]=2 [3]=~0 [6]=-2 [9]=~0 | [1]=2 [4]=-1 [7]=-2 [10]=1 | [2]=1 [5]=-2 [8]=-1 [11]=2
            ref12 = [2, 2, 1, 0, -1, -2, -2, -2, -1, 0, 1, 2]
            rep("   M1 constants (3-cut, t=10) vs 0909 tau_12 table:")
            for r in range(12):
                dev = abs(M[r] - ref12[r])
                rep(f"     r={r:2d}: |fit-ref| = {nstr(dev, 5)}  (ref {ref12[r]})")

        # ---- wave readings over t (uniform + zeros) -------------------------
        rep("   reading 24-phase frame over t grid (lattice 47 pts/t) ...")
        WU = read_grid(cell, P, ts_uniform)
        WZ = read_grid(cell, P, gammas)
        rep("   done.")

        poleU = [sum(v) / Q for v in WU]
        poleZ = [sum(v) / Q for v in WZ]

        # ---- deep-dive class r=1 --------------------------------------------
        r0, rF = 1, 13
        Lnp = mp.log(mpf(n1_of(r0)))
        rep(f"\n   [deep class r={r0} (past) -> r={rF} (future antipode); "
            f"spin freq ln(n1) = {nstr(Lnp, 8)}, period {nstr(2*mp.pi/Lnp, 5)}]")
        rep("     t     |A_past|   |A_fut|   |W_past|  |W_fut|  |H_id|   |H_sf|")
        for i in list(range(0, 8)) + [12, 20]:
            a, b = WU[i][r0], WU[i][rF]
            pa, pb = a - poleU[i], b - poleU[i]
            rep(f"     {nstr(ts_uniform[i], 5):>5}  {nstr(abs(a), 7):>8}  {nstr(abs(b), 7):>8}"
                f"  {nstr(abs(pa), 7):>8}  {nstr(abs(pb), 7):>8}  {nstr(abs(b - a), 7):>8}"
                f"  {nstr(abs(b + a), 7):>8}")
        # 4 waveforms at selected t (complex values)
        rep("     4 waveforms (re + im), t in {10, 50, 100, 200, 400}:")
        for i in [12, 92, 192, 392, 792]:
            t = ts_uniform[i]
            a, b = WU[i][r0] - poleU[i], WU[i][rF] - poleU[i]
            ar, br = WU[i][r0], WU[i][rF]
            rep(f"       t={nstr(t, 4):>5}  pastA=({nstr(ar.real, 5)},{nstr(ar.imag, 5)})"
                f"  futA=({nstr(br.real, 5)},{nstr(br.imag, 5)})")
            rep(f"               pastW=({nstr(a.real, 5)},{nstr(a.imag, 5)})"
                f"         futW=({nstr(b.real, 5)},{nstr(b.imag, 5)})")

        # ---- hole statistics on both grids ----------------------------------
        rep("\n     propagation holes, class r=1 -> 13:")
        for grid, W, pole, ts in (("uniform", WU, poleU, ts_uniform),
                                  ("zeros", WZ, poleZ, gammas)):
            idr = [abs((W[i][rF] - pole[i]) - (W[i][r0] - pole[i])) for i in range(len(ts))]
            idabs = [abs(W[i][rF] - W[i][r0]) for i in range(len(ts))]
            sf = [abs(W[i][rF] + W[i][r0]) for i in range(len(ts))]
            for nm, hs in (("H_idr (rel)", idr), ("H_id (abs)", idabs), ("H_sf (sum)", sf)):
                mean = sum(hs) / len(hs)
                rms = mp.sqrt(sum(h * h for h in hs) / len(hs))
                rep(f"       {grid:>7} {nm:>12}: mean|H| = {nstr(mean, 7)}   rms = {nstr(rms, 7)}")

        # ---- zero-location test ----------------------------------------------
        rep("     zero-location test (|H_id abs| exactly AT each zero):")
        hz = [abs(WZ[i][rF] - WZ[i][r0]) for i in range(len(gammas))]
        hz_mean = sum(hz) / len(hz)
        # uniform-grid holes on the same t-range for scale comparison
        hu = [abs(WU[i][rF] - WU[i][r0]) for i in range(len(ts_uniform))]
        hu_mean = sum(hu) / len(hu)
        rep(f"       mean |H_id| at zeros        = {nstr(hz_mean, 8)}")
        rep(f"       mean |H_id| on uniform grid = {nstr(hu_mean, 8)}  "
            f"ratio = {nstr(hz_mean / hu_mean, 5)}")
        top = sorted(range(len(hz)), key=lambda i: -hz[i])[:10]
        rep("       largest |H_id| at zeros: " +
            ", ".join(f"g={nstr(gammas[i], 6)}/|H|={nstr(hz[i], 6)}" for i in top))
        bot = sorted(range(len(hz)), key=lambda i: hz[i])[:6]
        rep("       smallest |H_id| at zeros: " +
            ", ".join(f"g={nstr(gammas[i], 6)}/|H|={nstr(hz[i], 6)}" for i in bot))
        hu_top = sorted(range(len(hu)), key=lambda i: -hu[i])[:10]
        rep("       largest |H_id| on uniform: " +
            ", ".join(f"t={nstr(ts_uniform[i], 6)}/|H|={nstr(hu[i], 6)}" for i in hu_top))

        # ---- propagation of the hole itself (end<->beginning dual) -----------
        # dual hole: predict future(t) from past(t) with the best phase-shift:
        # scan lag in t: corr(lag) = max |<W_past(t), W_future(t+lag)>|  (W = rel)
        relU_p = [WU[i][r0] - poleU[i] for i in range(len(ts_uniform))]
        relU_f = [WU[i][rF] - poleU[i] for i in range(len(ts_uniform))]
        def inner(x, y):
            s = mpc(0)
            for a, b in zip(x, y):
                s += a * b.conjugate()
            return s
        best = (None, None)
        for lag in range(-40, 41):  # +/- 20 in t
            if lag >= 0:
                x = relU_p[:-lag] if lag else relU_p
                y = relU_f[lag:] if lag else relU_f
            else:
                x = relU_p[-lag:]
                y = relU_f[:lag]
            c = abs(inner(x, y)) / (mp.sqrt(abs(inner(x, x)) * abs(inner(y, y))))
            if best[0] is None or c > best[0]:
                best = (c, lag)
        nrm = mp.sqrt(abs(inner(relU_p, relU_p)) * abs(inner(relU_f, relU_f)))
        c0 = abs(inner(relU_p, relU_f)) / nrm
        rep(f"\n     rel-wave lag correlation past<->future: lag=0 |<p,f>|/norm = {nstr(c0, 6)}; "
            f"best lag = {best[1]} (|corr| = {nstr(best[0], 6)})")

        # ---- envelope (raw absolute) spin check for one t ---------------------
        a0 = WU[12][r0]
        rep(f"     spin check t=10: A_past = {nstr(a0, 10)};")
        rep(f"       |A_past| = {nstr(abs(a0), 8)}  arg = {nstr(mp.arg(a0), 8)}  "
            f"(predicted spin arg = t*ln(n1) mod 2pi = {nstr(mpf(10)*Lnp % (2*mp.pi), 8)})")

    # ---- prime-own-reading at zero heights (the 'treat the prime' handle) ----
    rep("\n== prime-own-reading at the zero windows (prime itself, as always) ==")
    LIM = 700
    sieve = [True] * (LIM + 1)
    sieve[0] = sieve[1] = False
    for m in range(2, int(LIM ** 0.5) + 1):
        if sieve[m]:
            for m2 in range(m * m, LIM + 1, m):
                sieve[m2] = False
    primes = [m for m in range(2, LIM + 1) if sieve[m]]
    rep(f"   primes to {LIM} ({len(primes)})")
    for r in FRONT:
        tot, tote = 0, mpf(0)
        for g in gammas:
            w = g / mp.log(g)
            lo, hi = int(max(2, g - w)), int(g + w)
            cnt = sum(1 for p in primes if lo <= p <= hi and p % 24 == r)
            tot += cnt
            tote += (2 * w) / (mpf(8) * mp.log(g))
        rep(f"   class r={r}: prime hits in {len(gammas)} zero-windows [g-w,g+w], "
            f"w = g/ln g: {tot}  (Poisson exp {nstr(tote, 5)}; ratio {nstr(tot / tote, 5)})")

    rep("\nDONE. WF-24 probe complete.")
    os.makedirs("/home/jsmille/Projects/rh-missing-tail/tmp/sq24", exist_ok=True)
    with open("/home/jsmille/Projects/rh-missing-tail/tmp/sq24/wf24_out.txt", "w") as f:
        f.write("\n".join(out) + "\n")

if __name__ == "__main__":
    main()
