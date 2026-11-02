#!/usr/bin/env python3
"""day065 — EM-squeeze TOTAL-EXHAUSTION MAP (route (b) feasibility probe).

Context (discovery 0259-0262, FRONTIER-AND-RECORD-PLAN 0255 §3): a
VALID squeeze instance at run N for a band pair (t >= tPT2, 1/200 <=
d0 < 1/2) requires
  (i)   the A2c bridge at N          — IN BODY for every N (0265),
  (ii)  the S3 FACE: fill(N) <= wire — a mass statement (the only
        leg a hypothetical pair could satisfy);
  (iii) the PIN:     wallLo(N) > own — needed for the squeeze
        contradiction (0262 cycle wire < own < wallLo <= fill <= wire).
The legs are constrained by the TRUE fill, A2c-exact (0265):
  S3 face  possible only if  wallLo(N) < wire   (fill >= wallLo)
  S1 leg   possible only if  fill(N)  >  own    (MfR = 0: S1 needs
                                                  fill >= dev >= flo = own)
  squeeze  live          only if  wallLo(N) > own  (the pin, iii)
So at (t, d0) a hypothetical off-pair can be EM-squeezed exactly at
runs N in the live window  W = (N1, min(N2, N3)) where
  N1: wallLo(N) = wire  (S3 face impossible for N <= N1)
  N2: fill(N)  = own    (S1 leg impossible for N >= N2; fill ~
                         (1/2) N^-sig, so N2 is the closed crossing)
  N3: wallLo(N) = own   (pin impossible for N >= N3; 0259's in-body
                         pin range [nIdeal, 2 nIdeal] lies below N3)
TOTAL EM EXHAUSTION at (t, d0)  <=>  W is empty
  <=>  N1 >= N2  or  N3 <= N1.
W nonempty at some band point => the EM-squeeze class is a LIVE CLOSURE
ROUTE there (a hypothetical pair could be squeezed at N in W — the
legs become per-pair data obligations) and U7 must record W, not close
it.

LAYER 1 — the crossing map, exact closed forms of the tree:
  wire = BwireR + MrR (S4Asm d0>=1/200 branch: P8Floor.p8_B(t,ceil
  3.1e7 t^4) + S4Window.Zbound(t) e^{X4fun t} X4fun t; X4fun via
  S4Strip G4/B4 and B3Core Sbar/Bf/Cf/Kbar),
  own = S4Own.mown (25n exact own-height kernel mass),
  wallLo = T4OffLE 3-term closed kernel floor,
  nIdeal/Noff = T4OffLE decoupled run.
LAYER 2 — strict A2c-exact true fill at t = 1000 (frozen x-phase,
  t/x <= 1e-16): p4_em_expr computed with the per-interval frozen
  Bernoulli polynomial (P4Tail.B2poly on each [N+k, N+k+1]), so no
  fast-oscillation quad problem; verifies the 0262 chain numerically
  in exact form and quantifies the rigidity
  |fill/wallLo - 1| = O(1/N)  (the constant the future U7 asymptotic
  lemma must beat).
No zeta, no board, no RH claim: a quantitative map of where the
squeeze legs can and cannot hold simultaneously.
"""
import math
import mpmath as mp

mp.mp.dps = 50
TPT2 = mp.mpf("3000175332800")  # WinC.tPT2

# ---------- closed forms (tree sources cited per quantity) ----------

def mown(t, d0):
    """S4Own.mown (25n exact own-height kernel mass)."""
    A = (mp.mpf("0.5") + d0) ** 2 + t ** 2
    B = (mp.mpf("0.5") - d0) ** 2 + t ** 2
    c = (mp.mpf("0.5") + d0) / A + (mp.mpf("0.5") - d0) / B
    return d0 ** 2 * (d0 ** 2 + 4 * t ** 2) / (A * B) * mp.e ** c


def p8_B(t, n):
    """P8Floor.p8_B (on-line EM kernel floor at run n, s = 1/2 + it)."""
    n12 = mp.power(n, mp.mpf("-0.5"))
    n32 = mp.power(n, mp.mpf("-1.5"))
    n52 = mp.power(n, mp.mpf("-2.5"))
    n_half = mp.sqrt(mp.mpf("0.25") + t * t)
    norm3 = 1.0
    for a in (mp.mpf("0.5"), mp.mpf("1.5"), mp.mpf("2.5")):
        norm3 *= mp.sqrt(a * a + t * t)
    return (mp.mpf("0.5") * n12
            + (n_half / 12) * n32
            + (mp.sqrt(3) / 540) * norm3 * n52)


def X4fun(t):
    """S4Strip.X4fun = Bf(t,G4)(Sbar(B4)+Sbar(G4)) + Cf(t,G4)Kbar(G4)."""
    G4 = mp.mpf("62000000") * t ** 4
    B4 = mp.mpf("124000000") * t ** 4
    w = t * t + mp.mpf("0.25")
    G2 = G4 * G4

    def Sbar(x):
        return 0.110 * mp.log(x) + 0.290 * mp.log(mp.log(x)) + 2.290

    Bf = (1 / (2 * (G2 + mp.mpf("0.25")))
          + (w / (G2 + mp.mpf("0.25"))) / (1 - w / (G2 + mp.mpf("0.25")))
          + t / (G2 + mp.mpf("0.25")))
    Cf = 1 + 2 * w * G2 / (G2 - t * t)
    Kbar = ((0.110 * (mp.log(G4) + 0.5)
             + 0.290 * (mp.log(mp.log(G4)) + 0.5) + 2.290) / (2 * G4 * G4))
    return Bf * (Sbar(B4) + Sbar(G4)) + Cf * Kbar


def Zbound(t):
    """S4Window.Zbound = 1.6 t^(1/4) log t."""
    return mp.mpf("1.6") * mp.power(t, mp.mpf("0.25")) * mp.log(t)


def wire(t):
    """S4Asm BwireR + MrR, d0 >= 1/200 branch."""
    BwireR = p8_B(t, int(mp.ceil(mp.mpf("31000000") * t ** 4)))
    X = X4fun(t)
    MrR = Zbound(t) * mp.e ** X * X
    return BwireR + MrR


def sL(t, d0):
    """T4OffL.t4l_sOffL: (1/2 - d0) + it."""
    return mp.mpc(0.5 - float(d0), float(t))


def wallLo(t, d0, N):
    """T4OffLE.wallLo (3-term closed kernel floor; N positive real)."""
    s = sL(t, d0)
    sig = 0.5 - float(d0)
    N = mp.mpf(N)
    t1 = mp.mpf("0.5") * mp.power(N, -sig)
    t2 = (abs(s) / 12) * mp.power(N, -(1.5 - float(d0)))
    t3 = ((mp.sqrt(3) / 216) * abs(s * (s + 1) * (s + 2))
          * mp.power(N, -(sig + 2)) / (sig + 2))
    return t1 - t2 - t3


def nIdeal(t, d0):
    """T4OffLE.nIdeal = (16 d0^2)^(-1/sig) * t^(2/sig)."""
    sig = 0.5 - float(d0)
    return mp.power(mp.mpf("16") * d0 ** 2, -1 / sig) * mp.power(t, 2 / sig)


def find_wall_crossing(t, d0, target, Nlo, Nhi):
    """Crossing N of wallLo(N) = target in [Nlo, Nhi] (wallLo is
    strictly decreasing in N; bisection in log N)."""
    Llo, Lhi = mp.log(mp.mpf(Nlo)), mp.log(mp.mpf(Nhi))
    if not (wallLo(t, d0, Nlo) >= target >= wallLo(t, d0, Nhi)):
        return None
    for _ in range(70):
        Lm = (Llo + Lhi) / 2
        if wallLo(t, d0, mp.e ** Lm) >= target:
            Llo = Lm
        else:
            Lhi = Lm
    return mp.e ** ((Llo + Lhi) / 2)


# ---------- layer 2: strict A2c-exact true fill (frozen x-phase) ----------

def true_fill(t, d0, N, K=3000, V=mp.mpf("30")):
    """
    |p4_em_expr sL N| exactly (P4Limit L1315):
      -1/2 N^-s + (s/12) N^-s-1 - 1/2 s(s+1) I,
    I = INT_N^inf B2(x) x^-s-2 dx split into per-interval frozen
    polynomials (P4Tail.B2poly: on [N+k, N+k+1] B2 = (x-N-k)^2 -
    (x-N-k) + 1/6):
      I = sum_{k>=0} INT_{N+k}^{N+k+1} (frozen poly) s(s+1) x^-s-2 dx
    + tail.  Frozen x-phase (t = 1000, N ~ 1e19: rate t/x <= 1e-16).
    The tail is bounded by freezing ONE more derivative scale:
    |tail| <= (|s(s+1)|/3) (N+K)^(-sig-2)/(|s+2|)  (|B2| <= 1/6).
    """
    s = sL(t, d0)
    sig = 0.5 - float(d0)
    Nr = mp.mpf(N)
    t1 = -mp.mpf("0.5") * mp.power(Nr, -s)
    t2 = (s / 12) * mp.power(Nr, -s - 1)
    S = s * (s + 1)
    I = mp.mpc(0)
    for k in range(int(K)):
        a = Nr + k
        # integrand on u in [0,1]: (u^2 - u + 1/6) S (a+u)^(-s-2)
        def iv(u, a=a):
            return (u * u - u + mp.mpf("1/6")) * S * mp.power(a + u, -s - 2)
        I += mp.quad(iv, [mp.mpf("0"), mp.mpf("1")])
    tailb = (abs(S) / 3) * mp.power(Nr + K, -(sig + 2)) / abs(s + 2)
    return abs(t1 + t2 - mp.mpf("0.5") * I), tailb


def main():
    ts = [mp.mpf("1000"), mp.mpf("1e6"), TPT2]
    d0s = [mp.mpf("0.005"), mp.mpf("0.0075"), mp.mpf("0.01"), mp.mpf("0.02"),
           mp.mpf("0.05"), mp.mpf("0.1"), mp.mpf("0.2"), mp.mpf("0.3"),
           mp.mpf("0.37"), mp.mpf("0.45"), mp.mpf("0.49"), mp.mpf("0.4999")]
    print("LAYER 1 — EM-squeeze live-window map W = (N1, min(N2, N3))")
    print("  N1: wallLo = wire (S3 face impossible below)   N2: fill=own")
    print("  N3: wallLo = own  (pin impossible above; 0259 pin range below)")
    print(f"{'t':>14} {'d0':>8} | {'wire':>14} {'own':>14} {'wire/own':>9}"
          f" | {'logNoff':>10} {'logN1':>10} {'logN2':>10} {'logN3':>10}"
          f" | {'W (log10 of len)':>16} {'VERDICT':>10}")
    print("-" * 132)
    npts = 0
    n_live = 0
    worst_live_len = mp.mpf("-inf")
    for t in ts:
        w = wire(t)
        for d0 in d0s:
            own = mown(t, d0)
            sig = 0.5 - float(d0)
            ni = nIdeal(t, d0)
            Noff = mp.ceil(ni)
            N2 = mp.power(mp.mpf("0.5") / own, 1 / sig)
            N1 = find_wall_crossing(t, d0, w, Noff, mp.power(Noff, 1000))
            N3 = find_wall_crossing(t, d0, own, Noff, mp.power(Noff, 1000))
            npts += 1
            loW = mp.log(N1) if N1 else mp.log(10) * 1e300
            hiW = min(mp.log(N2), mp.log(N3)) if (N1 and N3) else None
            if N1 is None or N3 is None:
                verdict = "OUT-OF-RANGE"
            elif hiW is not None and loW < hiW:
                wlen = hiW - loW
                worst_live_len = max(worst_live_len, wlen)
                n_live += 1
                verdict = f"LIVE w={mp.nstr(wlen / mp.log(10), 4)}"
            else:
                verdict = "EXHAUSTED"
            print(f"{mp.nstr(t, 14):>14} {mp.nstr(d0, 8):>8} | "
                  f"{mp.nstr(w, 14):>14} {mp.nstr(own, 14):>14} "
                  f"{mp.nstr(w / own, 9):>9} | "
                  f"{mp.nstr(mp.log(Noff) / mp.log(10), 10):>10} "
                  f"{mp.nstr(mp.log(N1) / mp.log(10), 10) if N1 else '-':>10} "
                  f"{mp.nstr(mp.log(N2) / mp.log(10), 10):>10} "
                  f"{mp.nstr(mp.log(N3) / mp.log(10), 10) if N3 else '-':>10} | "
                  f"{'W=' + mp.nstr((hiW - loW) / mp.log(10), 4) if (N1 and N3 and hiW is not None and loW < hiW) else '-':>16} "
                  f"{verdict:>10}")
    print("-" * 132)
    print(f"grid points: {npts}   live-window points: {n_live} of {npts}   "
          f"max live-window length (log10): "
          f"{mp.nstr(worst_live_len / mp.log(10), 6) if worst_live_len != mp.mpf('-inf') else '-'}")

    print()
    print("LAYER 2 — strict A2c-exact true fill at t = 1000 (frozen phase):")
    print("  fill = |p4_em_expr sL Noff| (0265-exact); quantifies the")
    print("  rigidity |fill/wallLo - 1| the U7 asymptotic lemma must beat,")
    print("  and verifies the 0262 chain fill > own at Noff numerically.")
    t = mp.mpf("1000")
    w = wire(t)
    print(f"  t = 1000   wire = {mp.nstr(w, 12)}")
    for d0 in [mp.mpf("0.005"), mp.mpf("0.05"), mp.mpf("0.3"),
               mp.mpf("0.4999")]:
        own = mown(t, d0)
        Noff = int(mp.ceil(nIdeal(t, d0)))
        fill, tailb = true_fill(t, d0, Noff, K=4000)
        wl = wallLo(t, d0, Noff)
        asym = mp.mpf("0.5") * mp.power(Noff, -(0.5 - float(d0)))
        print(f"  d0 = {mp.nstr(d0, 10)}   Noff ~ 10^{mp.nstr(mp.log(Noff) / mp.log(10), 6)}")
        print(f"    fill  = {mp.nstr(fill, 16)}")
        print(f"    wallLo = {mp.nstr(wl, 16)}   fill/wallLo-1 = "
              f"{mp.nstr(fill / wl - 1, 4)}   (pure-asym/wallLo-1 = "
              f"{mp.nstr(asym / wl - 1, 4)})   fill/own = "
              f"{mp.nstr(fill / own, 6)}   fill>wire? {fill > w}")
        print(f"    (tail bound behind I: {mp.nstr(tailb, 3)} vs fill "
              f"{mp.nstr(fill / tailb, 1) if tailb > 0 else 'inf'}x)")
    print()
    print("VERDICT keys: EXHAUSTED at every grid point => no EM-squeeze")
    print("  instance can be live anywhere on the band => total EM-class")
    print("  exhaustion record (strengthens 0260/0262 from the pin range")
    print("  to EVERY run, A2c-citation-free via 0265); the named open")
    print("  question reduces to high-mass pairs (fill > wire) which no")
    print("  EM run can witness => route (b) OUTSIDE the EM kernel.")
    print("  LIVE windows => the EM squeeze IS a live closure route at")
    print("  those (t, d0): U7 records the window and the legs become")
    print("  per-pair data obligations (the hOffCPT2 narrowing there).")


if __name__ == "__main__":
    main()
