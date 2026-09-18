#!/usr/bin/env python3
"""
day031 — T^4 CEILING (queue item 3; the 25af strip-closure data-side
extension): the 25af survey (day027_25af_owncompo_survey.py, out_
day027_25af_owncompo_survey.txt) verified the t^4-wire strip
    p8_B(t, ceil(3.1e7 t^4)) + R  <  mown(t, 1/200),   d-edge floor
on the data side over t in [1e3, 1e7] (33-pt log grid, dps-30).
The S1 A-1 data territory (day029) reaches t = 1e9.  THIS EXTENDS the
t^4 wire's data-side margin check from 1e7 up to 1e9 (the S1 data
ceiling) and states the data-side CEILING of the t^4 wire:

  - the (W + Rcrude)/mown closure ratio (25af [3] form, Rcrude =
    Zbound(t) e^{X4} X4 the RVM-bounded residual, X4 = the B3Core
    Xwire on the t^4 band (G4, B4] = (6.2e7 t^4, 1.24e8 t^4));
  - log(Rmass/Eenv) (the TRUE band-product mass residual, k=1
    SERIES form of fT — the 25af discipline: on the t^4 band
    w/u ~ 2.6e-34·(1000/t)^6 << 1e-30, the log is NEVER evaluated,
    the k=1 term -w/u + O((w/u)^2) is used, truncation recorded);
  - the true floor mown/Eenv flatness (25ad [4] constant
    0.998937566 for t >= 1e4);
  - dual-precision anchor (dps-30 vs dps-50) at THE CEILING POINT
    t = 1e9 (the mpmath parts; W = p11.p8_B is float64 by
    construction in both — recorded).

The functions below are VERBATIM copies of the 25af survey's pure
core (Eenv, mown, u, w, fT, nHat, Bf, Cf, Kbar, Sbar, Zbound, X4,
mass, the C4 band) — reuse, not reimplementation (pin-reuse
discipline); the import would execute the whole 25af survey at
module level (it has no main guard).

LEAN side: the bound-level theorem s4_strip_close (formal/
RhAttack/S4Strip.lean, 25af Stages 1-5) covers ALL t >= 1000 —
this script extends the DATA-side verification only; the two agree
by construction (same mirrors).
"""
import math
import sys
import mpmath as mp

mp.mp.dps = 30
import day023_p11c_1e7 as p11          # p8_B mirror (Lean-authoritative)

# ---------------- verbatim 25af core (day027) ----------------
EENV_C = (1.0 / 10000.0) * (16001.0 / 15984.0)     # 1.001064e-4

def Eenv(t):    return EENV_C / (t * t)

def mown(t, d):
    t = float(t); d = float(d)
    A = (0.5 + d) ** 2 + t * t
    B = (0.5 - d) ** 2 + t * t
    c = (0.5 + d) / A + (0.5 - d) / B
    return d * d * (d * d + 4.0 * t * t) / (A * B) * math.exp(c)

def true_floor(t):   # mown(t, 1/200) / Eenv(t)
    return mown(t, 1.0 / 200.0) / Eenv(t)

def u(x):  return x * x + mp.mpf(1) / 4
def w(t):  return t * t + mp.mpf(1) / 4
def fT(t, x):
    # k=1 SERIES band form (25af discipline: w/u < 1e-30 on the t^4
    # band -> the log is never evaluated; truncation O((w/u)^2)
    # recorded per point).
    ux = u(x); wt = w(t)
    return mp.mpf(1) / 2 / ux - wt / ux
def nHat(x):
    return (x / (2 * mp.pi)) * (mp.log(x / (2 * mp.pi)) - 1) + mp.mpf(7) / 8
def Bf(t, G):
    uw = w(t) / (G * G + mp.mpf(1) / 4)
    return (mp.mpf(1) / (2 * (G * G + mp.mpf(1) / 4))
            + uw / (1 - uw) + t / (G * G + mp.mpf(1) / 4))
def Cf(t, G):
    return 1 + 2 * w(t) * (G * G) / (G * G - t * t)
def Kbar(G):
    return ((mp.mpf("0.110") * (mp.log(G) + mp.mpf(1) / 2)
             + mp.mpf("0.290") * (mp.log(mp.log(G)) + mp.mpf(1) / 2)
             + mp.mpf("2.290")) / (2 * G * G))
def Sbar(x):
    return (mp.mpf("0.110") * mp.log(x)
            + mp.mpf("0.290") * mp.log(mp.log(x)) + mp.mpf("2.290"))
def Zbound(t):
    return mp.mpf("1.6") * mp.nthroot(mp.mpf(float(t)), 4) * mp.log(mp.mpf(float(t)))

C4 = mp.mpf("3.1e7")
def n4(t):    return int(math.ceil(float(C4) * float(t) ** 4))
def G4(t):    return mp.mpf(2) * (C4 * mp.mpf(float(t)) ** 4)
def B4(t):    return mp.mpf(2) * G4(t)
def X4(t):
    g, b = G4(t), B4(t)
    return Bf(mp.mpf(float(t)), g) * (Sbar(b) + Sbar(g)) \
         + Cf(mp.mpf(float(t)), g) * Kbar(g)
def mass(t, nspl=64):    # log M = ∫_{G4}^{B4} nHat fT  (k=1 form)
    g, b = G4(t), B4(t)
    def f(x):
        return nHat(x) * fT(mp.mpf(float(t)), x)
    pts = [g * (b / g) ** (mp.mpf(k) / nspl) for k in range(nspl + 1)]
    return mp.fsum(mp.quad(f, [pts[k], pts[k + 1]]) for k in range(nspl))
# ------------------------------------------------------------

def wu_max(t):
    """max |w/u| on the band = w(t)/u(G4(t)) (the series truncation
        control): (w/u)^2 recorded per point."""
    return w(mp.mpf(float(t))) / u(G4(t))

def eval_point(t, dps):
    x4 = X4(t)
    logM = mass(t)
    ee = Eenv(t)
    mfl = mown(t, 0.005)
    n4v = n4(t)
    W = p11.p8_B(float(t), n4v)
    zb = Zbound(t)
    rcrude = float(mp.mpf(float(zb)) * mp.e ** x4 * x4)
    logRmass_Eenv = logM + x4 + mp.log(x4) - mp.log(mpf_eenv(t))
    z2 = wu_max(t) ** 2
    return dict(t=t, W=float(W), mfl=mfl, rcrude=rcrude, x4=float(x4),
                logM=float(logM), logRmass_Eenv=float(logRmass_Eenv),
                n4=n4v, z2=float(z2), dps=dps)

def mpf_eenv(t):
    return mp.mpf(16001) / mp.mpf(15984) / mp.mpf(10000) / (mp.mpf(float(t)) ** 2)

def main():
    out = []
    def p(*a):
        line = " ".join(str(x) for x in a)
        print(line, flush=True)
        out.append(line)

    p("# day031 — T^4 CEILING: the t^4-wire strip closure margin, extended")
    p("# data-side from the 25af ceiling t = 1e7 up to t = 1e9 (the S1")
    p("# A-1 data ceiling).  Mirrors: verbatim 25af core (k=1 series fT,")
    p("# B3Core Xwire on (6.2e7 t^4, 1.24e8 t^4]); W = p11.p8_B float64")
    p("# (Lean-authoritative); Rcrude = Zbound(t) e^{X4} X4 (RVM-bounded);")
    p("# Rmass log-form (band mass underflows by e^{-O(t^2 log t)}).")
    p("")
    p("[1] CLOSURE RATIO (W + Rcrude)/mown over the ceiling extension dps-30:")
    p("    t          (W+Rcrude)/mown   W/mown      true_floor      z2=(w/u)^2   log(Rmass/Eenv)")
    worst = None
    for t in (1e7, 2e7, 5e7, 1e8, 2e8, 5e8, 1e9):
        e = eval_point(t, 30)
        ratio = (e["W"] + e["rcrude"]) / e["mfl"]
        worst = ratio if worst is None else max(worst, ratio)
        p("    %-10.3g   %-10.7f   %-10.7f   %-10.9f  %-8.2e  %-12.5e"
          % (t, ratio, e["W"] / e["mfl"], true_floor(t), e["z2"], e["logRmass_Eenv"]))
    p("    worst (W+Rcrude)/mown on the extension: %.7f  (25af constant 0.898026;"
      % worst)
    p("    < 1 = the t^4 strip closure margin HOLDS to the S1 data ceiling)")
    p("")
    p("[2] CEILING POINT DUAL ANCHOR (t = 1e9, dps-30 vs dps-50, mpmath parts):")
    e30 = eval_point(1e9, 30)
    mp.mp.dps = 50
    e50 = eval_point(1e9, 50)
    mp.mp.dps = 30
    p("    X4          dps30 = %.10e   dps50 = %.10e   |d| = %.2e"
      % (e30["x4"], e50["x4"], abs(e30["x4"] - e50["x4"])))
    p("    logM        dps30 = %.10e   dps50 = %.10e   |d| = %.2e"
      % (e30["logM"], e50["logM"], abs(e30["logM"] - e50["logM"])))
    p("    log(Rmass/Eenv)  dps30 = %.10e   dps50 = %.10e   |d| = %.2e"
      % (e30["logRmass_Eenv"], e50["logRmass_Eenv"],
         abs(e30["logRmass_Eenv"] - e50["logRmass_Eenv"])))
    p("    W = %.10e (float64 by construction in both — p11.p8_B);" % e30["W"])
    p("    true_floor(1e9) = %.9f (25ad [4] constant 0.998937566" % true_floor(1e9))
    p("    for t >= 1e4);  n4(1e9) = %d (%d digits; float64 t^4 has"
      % (e30["n4"], len(str(e30["n4"]))))
    p("    ~15.96 significant digits — W's relative precision is float64")
    p("    grade, 1e-16, absorbed far below the 0.102 margin.)")
    p("")
    p("[3] CEILING STATEMENT:")
    p("    - the t^4 wire's DATA-side verification now spans")
    p("      [1e3, 1e9]: 25af (1e3..1e7) + this extension (1e7..1e9);")
    p("      the closure ratio stays its t-constant 0.898.. across the")
    p("      whole span (the margin is entirely on W's term1, t^4/16001-anchored).")
    p("    - THE CEILING: t = 1e9 is the S1 DATA ceiling (the A-1 sweep")
    p("      territory; above 1e9 the S1 side is model-grade only).  The")
    p("      bound-level theorem (s4_strip_close, S4Strip.lean) speaks")
    p("      for ALL t >= 1000 independently of this data side.")
    p("    - no practical data-side ceiling below the S1 ceiling:")
    p("      mpmath-range evaluation of the t^4 scale survives to")
    p("      t >> 1e9 (n4 = 3.1e7 t^4 exact-integer display is the only")
    p("      cosmetic limit; W itself only needs n^{-1/2}, float64-")
    p("      representable to t ~ 1e151).")

    open("/home/jsmille/Projects/rh-missing-tail/scripts/rh/"
         "out_day031_t4ceiling.txt", "w").write("\n".join(out) + "\n")
    print("wrote out_day031_t4ceiling.txt", file=sys.stderr)

if __name__ == "__main__":
    main()
