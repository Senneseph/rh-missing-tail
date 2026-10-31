#!/usr/bin/env python3
"""day058b: LEFT-FLANK MARGIN SWEEP (G-hs3-left, discoveries 0121/0123).

Closed-form machine-wire arithmetic only (mpmath, high precision).
No zeta evaluation, no zero-existence statement, no RH claim.

Objects (all with exact in-tree counterparts):
  n4(t)        = ceil(3.1e7 * t^4)                 [S4Strip.n4]
  pairfac(d,t) = |d|*sqrt(d^2+4t^2)*exp((1/2+d)/((1/2+d)^2+t^2))
                   / ((1/2+d)^2+t^2)               [S4WinGate.pairfac_norm]
  flo_edge(t)  = poff(t, 1/200, t) = pairfac(1/200,t)*pairfac(-1/200,t)
                 = floStripMin(t, 1/200)  (poff branch: floWin = min(0.023,
                 1 - 25/t) ~ 0.023 at these heights is 26 orders above poff)
  T1(t, sigma) = (1/2) * n^(-sigma)                [first T4 term, wire]
  t4l_schedA   = (9999/2)^(1/sigma)                [T4OffL S7.1]
  crit(σ)      = schedA * t^(2/sigma)              [per-point critical scale]

Part 1: reproduce the 0121 pins (edge barrier, sigma0, crossing).
Part 2: per-point schedule / n4 breakdown map at t = tPT2.
Part 3: fixed-power schedule family lever map (C*t^k coverage).
"""
import mpmath as mp

mp.mp.dps = 50
try:
    mp.mpf.nstr
except AttributeError:  # mpmath 1.4.x: module function only
    mp.mpf.nstr = lambda self, n=17: mp.nstr(self, n)

T_PT2 = mp.mpf("3000175332800")      # WinC.tPT2 (Platt-Trudgian frontier)
C0 = mp.mpf("31000000")              # n4 leading constant
D_EDGE = mp.mpf(1) / 200             # band edge d0 = 1/200
SIGMA0_EDGE = mp.mpf(99) / 200       # sigma at the band edge (99/200)


def n4_real(t):
    return C0 * t ** 4


def n4(t):
    return mp.ceil(n4_real(t))


def pairfac(d, t):
    a = mp.mpf(1) / 2 + d
    return abs(d) * mp.sqrt(d ** 2 + 4 * t ** 2) * mp.exp(
        a / (a ** 2 + t ** 2)) / (a ** 2 + t ** 2)


def flo_edge(t):
    """floStripMin(t, 1/200): poff branch (floWin ~ 0.023, 26 orders looser)."""
    return pairfac(D_EDGE, t) * pairfac(-D_EDGE, t)


def t1(n, sigma):
    return mp.mpf(1) / 2 * n ** (-sigma)


def main():
    out = []

    def P(s=""):
        out.append(s)

    P("=" * 74)
    P("day058b LEFT-FLANK MARGIN SWEEP (G-hs3-left, 0121/0123 map)")
    P("closed-form machine-wire arithmetic; no zeta, no RH claim")
    P("=" * 74)
    P(f"tPT2 = {mp.nstr(T_PT2, 30)}")
    P(f"n4(tPT2) ~= {mp.nstr(n4_real(T_PT2), 15)}   (scale C0 t^4)")
    P()

    # ------------------------------------------------------------ Part 1
    P("-" * 74)
    P("PART 1: the 0121 pins, reproduced numerically (edge d0 = 1/200)")
    P("-" * 74)
    P(f"{'t':>22}  {'T1(n4,99/200)':>16}  {'flo_edge(t)':>16}  {'T1/floor':>10}")
    pins = [
        (mp.mpf("7330000000"), "0121 crossing (15750/9999)^50 ~ 7.33e9"),
        (mp.mpf("10000000000"), "1e10 (0121 barrier threshold)"),
        (mp.mpf("1000000000000"), "1e12"),
        (T_PT2, "tPT2 (frontier)"),
    ]
    for t, tag in pins:
        tr = t1(n4(t), SIGMA0_EDGE)
        fe = flo_edge(t)
        P(f"{mp.nstr(t, 15):>22}  {mp.nstr(tr, 16):>16}  {mp.nstr(fe, 16):>16}  "
          f"{mp.nstr(tr / fe, 10):>10}   {tag}")
    P()
    P("sigma0 barrier (d0 = 1/2, sigma = 0): T1 = 1/2 at EVERY schedule")
    P(f"  T1/flo_edge(tPT2) = {mp.nstr((mp.mpf(1)/2) / flo_edge(T_PT2), 8)}"
      "  (never below the floor)")
    P()

    # crossing scan (1/9999-scale target, the 0121 analytic pin):
    # (1/2)(n4)^(-99/200) = (1/9999) t^-2.  The ratio grows like t^{1/50}
    # (n4 ~ C0 t^4, sigma = 99/200 -> T1 ~ const * t^{-1.98} vs t^{-2}),
    # so there is a single low-t crossover: the wire is ABOVE the floor
    # for all t above it (barrier direction).
    f = lambda t: t1(C0 * t ** 4, SIGMA0_EDGE) - (mp.mpf(1) / 9999) * t ** (-2)
    lo, hi = mp.mpf(1), mp.mpf(1000)
    if f(lo) > 0:
        P(f"NOTE: T1 already above the (1/9999) scale at t = 1: "
          f"{mp.nstr(f(1) + (1 / 9999), 8)}")
    else:
        assert f(hi) > 0
        for _ in range(200):
            mid = (lo + hi) / 2
            if f(mid) < 0:
                lo = mid
            else:
                hi = mid
        P(f"measured crossover (1/9999 scale) = {mp.nstr((lo + hi) / 2, 8)}")
    P(f"0121 sufficient-threshold pin (15750/9999)^50 = "
      f"{mp.nstr((mp.mpf(15750) / mp.mpf(9999)) ** 50, 12)}")
    P("relation: both thresholds are inside the barrier region (ratio")
    P("t^{1/50} grows with t); the measured crossover is the sharp one.")
    P()

    # exact-floor crossing for the n4 (real, not ceil) wire:
    g = lambda t: t1(n4_real(t), SIGMA0_EDGE) / flo_edge(t) - 1
    lo, hi = mp.mpf(1), mp.mpf(1000)
    if g(lo) > 0:
        P(f"NOTE: T1 above the EXACT edge floor already at t = 1: "
          f"T1/floor = {mp.nstr(g(1) + 1, 6)}")
    elif g(hi) > 0:
        for _ in range(200):
            mid = (lo + hi) / 2
            if g(mid) < 0:
                lo = mid
            else:
                hi = mid
        P(f"exact-floor crossing (T1(n4) vs flo_edge, n4 real) = "
          f"{mp.nstr((lo + hi) / 2, 10)}")
    else:
        P(f"T1 below the exact edge floor on [1, 1000]: "
          f"ratio(1000) = {mp.nstr(g(1000) + 1, 6)}")
    P()

    # ------------------------------------------------------------ Part 2
    P("-" * 74)
    P("PART 2: per-point schedule vs n4 breakdown at t = tPT2")
    P("-" * 74)
    P("sigma = 1/2 - d0, d0 in [1/200, 1/2):  T1(n4, sigma) vs flo_edge;")
    P("critical scale crit(sigma) = (9999/2)^(1/sigma) * t^(2/sigma)")
    P(f"{'d0':>12}  {'sigma':>12}  {'T1n4/floor':>14}  {'crit/n4':>16}  "
      f"{'crit scale':>18}")
    ds = [1 / 200, 0.01, 0.02, 0.05, 0.1, 0.15, 0.2, 0.25, 0.3, 0.35, 0.4,
          0.45, 0.49, 0.495, mp.mpf(1) / 2 - mp.mpf(1) / 1000]
    n4t = n4_real(T_PT2)
    for d in ds:
        d = mp.mpf(d)
        sigma = mp.mpf(1) / 2 - d
        ratio = t1(n4t, sigma) / flo_edge(T_PT2)
        crit = (mp.mpf(9999) / 2) ** (1 / sigma) * T_PT2 ** (2 / sigma)
        P(f"{mp.nstr(d, 12):>12}  {mp.nstr(sigma, 12):>12}  "
          f"{mp.nstr(ratio, 14):>14}  {mp.nstr(crit / n4t, 16):>16}  "
          f"{mp.nstr(crit, 18):>18}")
    P()
    P("reading:  T1n4/floor > 1  =  the n4 wire is BROKEN at that sigma")
    P("(the S3 wire leg of the squeeze cannot hold there);  crit/n4 is the")
    P("outgrowth factor the per-point schedule must carry (0123 S7).")
    P()
    P("n4 closure crossover on the left band (ratio T1/floor = 1):")
    H = lambda s: t1(n4t, s) / flo_edge(T_PT2) - 1
    lo, hi = mp.mpf(99) / 200, mp.mpf(1) / 2
    if H(lo) < 0 and H(hi) < 0:
        P("  (wire below the floor across the whole band at tPT2: none)")
    elif H(lo) > 0 and H(hi) > 0:
        P("  (wire above the floor across the whole band: all of it broken)")
    else:
        for _ in range(200):
            mid = (lo + hi) / 2
            if H(lo) * H(mid) <= 0:
                hi = mid
            else:
                lo = mid
        sb = (lo + hi) / 2
        P(f"  sigma_break = {mp.nstr(sb, 10)}   (d0_break = "
          f"{mp.nstr(mp.mpf(1) / 2 - sb, 10)})  -  wire CLOSED for")
        P("  d0 < d0_break, broken for d0 > d0_break  at t = tPT2")
    P()

    # ------------------------------------------------------------ Part 3
    P("-" * 74)
    P("PART 3: fixed-power family n = C * t^k at t = tPT2 (the lever map)")
    P("-" * 74)
    P("coverage:  T1(n, sigma) <= flo_edge  for sigma > sigma*(C,k);")
    P("sigma*(C,k) solved numerically from the exact edge floor.")
    lnt = mp.log(T_PT2)

    def sigma_star(C, k):
        # smallest sigma in (0, 1/2) with T1 <= floor; returns None if no
        # crossing (always broken, or always closed on (0, 1/2))
        F = lambda s: t1(C * T_PT2 ** k, s) / flo_edge(T_PT2) - 1
        if F(mp.mpf(1) / 2) > 0:
            return None  # broken all the way to sigma = 1/2
        lo, hi = mp.mpf(0), mp.mpf(1) / 2
        # march from 0 until sign change
        s = mp.mpf(0)
        for _ in range(600):
            s += (mp.mpf(1) / 2) / 600
            if F(s) <= 0:
                hi, lo = s, s - (mp.mpf(1) / 2) / 600
                break
        else:
            return "none"  # broken on all of (0, 1/2)
        for _ in range(200):
            mid = (lo + hi) / 2
            if F(mid) > 0:
                lo = mid
            else:
                hi = mid
        return (lo + hi) / 2

    P(f"{'C':>14}  {'k':>6}  {'sigma*':>12}  {'covers edge 99/200?':>20}  "
      f"{'scale at tPT2':>18}")
    fams = [
        (C0, 4, "n4 (machine)"),
        (C0, 5, "C0 t^5"),
        (C0, 8, "C0 t^8"),
        (C0, 16, "C0 t^16"),
        (mp.mpf("10") ** 12, 4, "1e12 t^4"),
        (mp.mpf("10") ** 20, 8, "1e20 t^8"),
        (mp.mpf("10") ** 40, 16, "1e40 t^16"),
    ]
    for C, k, tag in fams:
        ss = sigma_star(C, k)
        if ss is None:
            cover = "NO (broken at 1/2)"
            sstr = "1/2"
        elif ss == "none":
            cover = "NO (broken all)"
            sstr = "none"
        else:
            cover = "yes" if ss < SIGMA0_EDGE else "no"
            sstr = mp.nstr(ss, 12)
        P(f"{mp.nstr(C, 14):>14}  {k:>6}  {sstr:>12}  {cover:>20}  "
          f"{mp.nstr(C * T_PT2 ** k, 18):>18}   {tag}")
    P()
    P("required lever at C = 3.1e7 (n4 constant):  solve")
    P("  (1/2)(C t^4)^(-sigma_edge) = flo_edge(tPT2)  for C:")
    Creq = (mp.mpf(1) / 2) * T_PT2 ** (-4 * SIGMA0_EDGE) / flo_edge(T_PT2)
    Creq = Creq ** (1 / SIGMA0_EDGE)
    P(f"  C_required = {mp.nstr(Creq, 12)}   (n4 has C0 = 3.1e7;")
    P(f"  factor {mp.nstr(Creq / C0, 8)}x at the t^4 power)")
    P("required lever at k-power with C = 3.1e7:")
    kreq = (mp.log((mp.mpf(1) / 2) / flo_edge(T_PT2)) - mp.log(C0)) / lnt / 1
    # (1/2)(C0 t^k)^(-se) = fe  ->  k*log(C0 t^k) = log(1/2) - log(fe)
    # solved for k with se = SIGMA0_EDGE:
    kreq = (mp.log((mp.mpf(1) / 2) / flo_edge(T_PT2)) / SIGMA0_EDGE - mp.log(C0)) / lnt
    P(f"  k_required = {mp.nstr(kreq, 8)}   (n4 has k = 4)")
    P()

    # consistency: continuity with the REV2 window map (0243) at the edge
    P("-" * 74)
    P("CONSISTENCY: window map (0243) continuity at d = 1/200")
    P("-" * 74)
    dlo = mp.mpf(1) / 200 - mp.mpf("1e-6")
    P(f"pairfac(+d,tPT2)*pairfac(-d,tPT2) at d = 1/200 - 1e-6: "
      f"{mp.nstr(pairfac(dlo, T_PT2) * pairfac(-dlo, T_PT2), 12)}")
    P(f"at d = 1/200 (the edge floor itself):               "
      f"{mp.nstr(flo_edge(T_PT2), 12)}")
    P()
    P("=" * 74)
    P("VERDICT (G-hs3-left, machine-level, no RH claim):")
    P("  - 0121 barrier numerically REPRODUCED: the first left-flank T4")
    P("    term on n4 is above the EXACT edge floor for every t >= ~5.9")
    P("    (sharp crossover; the 0121 sufficient threshold (15750/9999)^50")
    P("    = 7.35e9 sits far inside the barrier region), and above tPT2")
    P("    by 1.739 = 73.9% (growing slowly like t^{1/50}, i.e. effectively")
    P("    frozen in the endpoint regime).  sigma0: T1 = 1/2 at every")
    P("    schedule, 4.5e28 above the floor - unreachable.")
    P("  - the WHOLE left strip band [1/200, 1/2) is broken at tPT2 on n4:")
    P("    ratio 1.739 (edge d0 = 1/200) -> 4.5e28 (d0 = 1/2); the sigma")
    P("    where the n4 wire would close is 0.49919 (d0 ~= 0.000814),")
    P("    far below the band edge (d0 >= 1/200 = 0.005 is fully broken) - i.e.")
    P("    no height buys the band on n4.")
    P("  - per-point (d0-adaptive) schedule: closes at every d0 < 1/2 with")
    P("    outgrowth crit/n4 = 3.057 at the band edge, diverging as")
    P("    t^{2/sigma} * (9999/2)^{1/sigma} for d0 -> 1/2 (0123 rate).")
    P("  - fixed-power lever (C t^k, at tPT2): covering the BAND EDGE ALONE")
    P("    needs C = 9.48e7 = 3.058x the n4 constant at k = 4 (exactly the")
    P("    crit/n4 factor - the two maps agree), or k = 4.0389 at C0; a")
    P("    schedule C0 t^5 covers only d0 <= 0.09, C0 t^8 d0 <= 0.233,")
    P("    C0 t^16 d0 <= 0.362; d0 -> 1/2 is unreachable at every fixed")
    P("    (C, k).  The no-uniform-schedule barrier in quantitative form:")
    P("    the band edge is a 3.06x n4 bump, the band interior is not.")
    P("  - G-hs3-left remains open at the machine; this map is the measured")
    P("    margin (0121 negative + 0123 positive half, both confirmed).")
    P("=" * 74)
    txt = "\n".join(out)
    print(txt)
    with open("/home/jsmille/Projects/rh-missing-tail/"
              "scripts/rh/out_day058b_leftflank_margin.txt", "w") as f:
        f.write(txt + "\n")


if __name__ == "__main__":
    main()
