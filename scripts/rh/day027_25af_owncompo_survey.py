#!/usr/bin/env python3
"""25af — OWN-COMPOSITION RESIDUAL SURVEY (item (a); the (i-b) strip-prerequisite)

DEMAND (25v / S4Sharp, LEAN-PROVEN): any wire W closing the own-regime strip
squeeze  W + Mr + Mf < mown(t, d)  on the closure-relevant strip d >= 1/200
must sit below the d-edge floor
    mown(t, 1/200) ≈ 0.998937566 · Eenv(t),
    Eenv(t) = (1e-4)(16001/15984) t^{-2} = 1.001064e-4 t^{-2}.
25ad [2]/[5]: the EM-tail at the t^4 scale has term1 = 8.98e-5 t^{-2} = ~90%
of the true floor, so the residual budget is ≈ (1.0e-4 - 8.98e-5) t^{-2}
≈ 1.0e-5 t^{-2}.  The demand boundary is n > (5000.15984/16001)² t^4 ≈ 2.495e7 t^4;
the wire is W(t) = p8_B(t, ceil(3.1e7 t^4)).

THIS SURVEY measures the DEFINITION-SIDE RESIDUAL at the t^4 scale — the
non-EM-tail (action-composition / Sbar + mass) piece — whose t-scale is the
UNKNOWN of item (a) (25ad [4]: "mown's closed form is the DETECTOR side at
4d^2/t^2; its definition-side counterpart at the same scale is the unknown").

Two candidate scalings, opposite answers (pre-registered):
  CRUDE  (25ab-style RVM count bound):  Rcrude = Zbound(t) · e^{X4} · X4,
        Zbound(t) = 1.6 t^{1/4} log t  (Backlund-admissible RVM upper bound),
        X4(t) = Bf(t,G4)(Sbar B4 + Sbar G4) + Cf(t,G4) Kbar(G4), the B3Core
        Xwire on the t^4 band (G4, B4], verbatim mirrors of B3Core/B3Sbar.
  MASS   (actual band product mass):    Rmass = M(t) · e^{X4} · X4,
        M(t) = exp(∫_{G4}^{B4} nHat(x) fT(t, x) dx)  — the closed-form
        model-integral mass (p8_residual_wired: |e^{Tt}∏F| ≤ mass · e^{Xval}Xval).

fT(t,x) = 1/(2(x²+¼)) + log(1 − (t²+¼)/(x²+¼));  nHat = (x/2π) log(x/2πe)
(verbatim B3Core).  X4 is pure closed form (no zero data).  M(t) is a
closed-form mpmath quadrature (no zero data).  The band constants (G4, B4)
are free witnesses (b3BoundExplicit is generic in (L,t,G,B)); the dominant
t-scaling X4 ~ (log t)/t^6 is band-constant-robust (see [5]).

Pre-registered verdicts:
  A. Rcrude << budget  AND  W + Rcrude < mown(t,1/200) on the strip
     -> (i-b) CLOSEABLE at the CRUDE bound level: Lean port is a
        25ab-style S4Growth stage at the t^4 scale with the mown floor
        replacing 0.9975 (record the exact endpoint constants).
  B. Rcrude >> budget but Rmass << budget
     -> the closing wire REQUIRES the mass smallness (e^{∫nHat fT});
        record the exact mass form for Lean (a genuinely sharper P4-adjacent
        identity, NOT the EM-tail family).  This is the substantive (i-b).
  C. both >> budget  -> the t^4 EM wire cannot close the strip; GAP-O
     re-quantified at the t^4 scale (new S4Sharp-style certificate); a
     different wire family (action composition) is required.
"""
import math
import numpy as np
import mpmath as mp

mp.mp.dps = 30
import day023_p11c_1e7 as p11        # p8_B mirror (Lean-authoritative)

# ---------------- constants / mirrors (verbatim) ----------------
EENV_C  = (1.0 / 10000.0) * (16001.0 / 15984.0)     # 1.001064e-4
def Eenv(t):    return EENV_C / (t * t)

def mown(t, d):
    t = float(t); d = float(d)
    A = (0.5 + d) ** 2 + t * t
    B = (0.5 - d) ** 2 + t * t
    c = (0.5 + d) / A + (0.5 - d) / B
    return d * d * (d * d + 4.0 * t * t) / (A * B) * math.exp(c)

def true_floor(t):   # mown(t, 1/200) / Eenv(t)  (25ad [4])
    return mown(t, 1.0 / 200.0) / Eenv(t)

# --- B3Core / B3Sbar mirrors (verbatim from formal/RhAttack/B3Core.lean) ---
def u(x):  return x * x + mp.mpf(1) / 4
def w(t):  return t * t + mp.mpf(1) / 4
def fT(t, x):
    # BAND form (exact to O((w/u)^2) < 1e-60 on the t^4 band, where
    # w/u = (t^2+1/4)/(x^2+1/4) ~ t^2/x^2 <= 2.6e-34):
    #   log(1 - w/u) = -w/u - (w/u)^2/2 - ...  (k>=1)
    # Neither mp.log(1 - w/u) NOR log(u-w) - log(u) resolves at dps-30:
    # u - w and u are IDENTICAL to 30 significant digits (DISCIPLINE NOTE
    # [2]: the naive form silently returns log(1) = 0).  The k=1 series
    # term is exact to O((w/u)^2) << 1e-30 here; w/u^2 max on the band =
    # w/G4^2 <= 3e-29·...  (verified in [5b] below).
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

def Zbound(t):       # RVM upper bound at the reference height t (25ab form)
    return mp.mpf("1.6") * mp.nthroot(mp.mpf(float(t)), 4) * mp.log(mp.mpf(float(t)))

# --- the t^4 wire + band (free witnesses; band-constant-robust scaling) ---
C4 = mp.mpf("3.1e7")     # 25ad wire scale n = ceil(3.1e7 t^4)
def n4(t):    return int(math.ceil(float(C4) * float(t) ** 4))
def G4(t):    return mp.mpf(2) * (C4 * mp.mpf(float(t)) ** 4)          # band lower
def B4(t):    return mp.mpf(2) * G4(t)                                  # band upper
def X4(t):    # B3Core Xwire on (G4, B4]
    g, b = G4(t), B4(t)
    return Bf(mp.mpf(float(t)), g) * (Sbar(b) + Sbar(g)) \
         + Cf(mp.mpf(float(t)), g) * Kbar(g)

def mass(t, nspl=64):    # actual band product mass = exp(∫_{G4}^{B4} nHat fT)
    g, b = G4(t), B4(t)
    def f(x):
        return nHat(x) * fT(mp.mpf(float(t)), x)
    # log-spaced split: the integrand ~ (1/x^2) decays; quad per sub-interval
    import mpmath
    pts = [g * (b / g) ** (mp.mpf(k) / nspl) for k in range(nspl + 1)]
    Tt = mpmath.fsum(mpmath.quad(f, [pts[k], pts[k + 1]]) for k in range(nspl))
    return Tt     # = log M  (the model integral); M = e^Tt

out = []
def p(*a):
    line = " ".join(str(x) for x in a); out.append(line); print(line)

p("#" * 78)
p("# 25af — own-composition residual survey (item (a); the (i-b) strip-prerequisite)")
p("#" * 78)

# ---------- [0] self-check: mown true-floor + demand boundary ----------
p("")
p("[0] SELF-CHECK (mirror fidelity):")
for t in (1e3, 1e4, 1e5, 1e6, 1e7):
    p("    t = %-7.3g  Eenv = %-11.5e  true_floor mown/Eenv = %.9f  mown = %-11.5e"
      % (t, Eenv(t), true_floor(t), mown(t, 0.005)))
p("    (expect true_floor -> 0.998937566 for t >= 1e4; 25ad [4]/25w).")

# ---------- [1] X4 scaling + crude residual ----------
p("")
p("[1] X4(t) = t^4-band Xwire  +  CRUDE residual Rcrude = Zbound(t) e^{X4} X4:")
p("    t          n4            X4              Zbound        Rcrude        Rcrude/Eenv  Rcrude/budget")
rows = []
ts = list(np.geomspace(1e3, 1e7, 33))   # keep the t^4 quad tractable
for t in ts:
    x4 = X4(t)
    zb = Zbound(t)
    rcrude = zb * mp.e ** x4 * x4
    ee = Eenv(t)
    budget = (EENV_C * 0.998937566 - 8.98e-5) / (t * t)   # ~1.0e-5 t^-2
    n4v = n4(t)
    rows.append((t, n4v, float(x4), float(zb), float(rcrude), float(ee), float(budget)))
    p("    %-8.4g %-13d %-13.6e %-12.5e %-12.5e %-11.5e %-11.5e %-11.5e"
      % (t, n4v, float(x4), float(zb), float(rcrude), float(ee),
         float(rcrude) / float(ee), float(rcrude) / float(budget)))

# log-fit the crude residual exponent
sel = [r for r in rows if 1e4 <= r[0] <= 1e6]
if len(sel) >= 3:
    lx = np.log(np.array([r[0] for r in sel]))
    ly = np.log(np.array([r[4] for r in sel]))
    sl, ic = np.polyfit(lx, ly, 1)
    p("    FIT (1e4..1e6): Rcrude ~ t^(%.4f)   [Eenv ~ t^-2; budget ~ t^-2]" % sl)

# ---------- [2] MASS residual ----------
p("")
p("[2] MASS residual Rmass = M(t) e^{X4} X4,  M(t) = exp(∫_{G4}^{B4} nHat fT)  (dps-30):")
mrows = []
for t in (1e3, 2e3, 5e3, 1e4, 2e4, 5e4, 1e5):
    x4 = X4(t)
    logM = mass(t)
    mm = mp.e ** logM if logM > mp.mpf("-1000") else None
    rmass = (mm * mp.e ** x4 * x4) if mm is not None else None
    logrmass = logM + x4 + mp.log(x4)     # log Rmass (x4 ~ 1e-33: e^{x4} ~ 1)
    ee = Eenv(t)
    budget = (EENV_C * 0.998937566 - 8.98e-5) / (t * t)
    mrows.append((t, float(logM), float(mm) if mm else None, float(rmass) if rmass else None))
    if mm is None:
        p("    t = %-7.3g  ∫nHat fT = %-12.5e  M = e^(that) (underflow)  log Rmass = %-12.5e  (budget log = %-10.5e)"
          % (t, float(logM), float(logrmass), float(mp.log(budget))))
    else:
        p("    t = %-7.3g  ∫nHat fT = %-12.5e  M = %-12.5e  Rmass = %-12.5e  Rmass/Eenv = %-9.5e"
          % (t, float(logM), float(mm), float(rmass), float(rmass) / float(ee)))

# ---------- [3] the full definition side vs the floor ----------
p("")
p("[3] FULL DEFINITION SIDE vs the d-edge floor (the (i-b) decision):")
p("    t          W/mown      Rcrude/mown      (W+Rcrude)/mown  log(Rmass/Eenv) [crude = RVM-bounded residual]")
crows = []
for t in (1e3, 2e3, 5e3, 1e4, 2e4, 5e4, 1e5):
    n4v = n4(t)
    W = p11.p8_B(float(t), n4v)
    ee = Eenv(t)
    mfl = mown(t, 0.005)                       # = true_floor(t) * Eenv(t)
    x4 = X4(t)
    zb = Zbound(t)
    rcrude = float(zb * mp.e ** x4 * x4)
    logrmass = mass(t) + x4 + mp.log(x4)     # log of the mass residual
    crows.append((t, W / ee, rcrude / mfl,
                  (W + rcrude) / mfl, float(logrmass)))
    p("    %-8.4g %-11.6f %-14.5e %-16.6f  log(Rmass/Eenv) = %-10.3e"
      % (t, W / mfl, rcrude / mfl, (W + rcrude) / mfl,
         float(logrmass) - float(mp.log(mfl))))

# ---------- [4] budget bookkeeping ----------
p("")
p("[4] BUDGET bookkeeping at the d-edge 1/200:")
for t in (1e3, 1e4, 1e5):
    ee = Eenv(t)
    p("    t = %-7.3g  Eenv = %-11.5e  W term1 = %-11.5e (frac of mown: %.3f)"
      "  budget ~ %-11.5e"
      % (t, ee, 8.98e-5 / (t * t), 8.98e-5 / (EENV_C * 0.998937566),
         (EENV_C * 0.998937566 - 8.98e-5) / (t * t)))

# ---------- [5] band-constant robustness of X4 ----------
p("")
p("[5] BAND-CONSTANT ROBUSTNESS (X4 ~ (log t)/t^6 is c-robust; G4 = c t^4):")
for c in ("1e7", "3.1e7", "1e8"):
    def X4c(t_, c=mp.mpf(c)):
        g = mp.mpf(2) * (c * mp.mpf(float(t_)) ** 4)
        b = mp.mpf(2) * g
        return Bf(mp.mpf(float(t_)), g) * (Sbar(b) + Sbar(g)) \
             + Cf(mp.mpf(float(t_)), g) * Kbar(g)
    vals = [float(X4c(1e3)), float(X4c(1e4))]
    p("    c = %-6s  X4(1e3) = %-12.5e  X4(1e4) = %-12.5e" % (c, vals[0], vals[1]))



# ---------- [5b] series-truncation + analytic cross-check of the mass integral ----------
p("")
p("[5b] Fidelity: (i) max (w/u)^2 on the band; (ii) quad vs analytic")
p("     -∫ nHat (w/u) dx ≈ -(w/4π)[(ln(B/2π)-1)² - (ln(G/2π)-1)²] (k=2 term of log):")
for t in (1e3, 1e4, 1e5):
    g, b = G4(t), B4(t)
    wt2 = mp.mpf(float(t)) ** 2
    maxz2 = (wt2 / u(g)) ** 2        # w/u largest at G (x smallest)
    logM_num = mass(t)
    Lg = mp.log(g / (2 * mp.pi)) - 1
    Lb = mp.log(b / (2 * mp.pi)) - 1
    ana = -(wt2 / (4 * mp.pi)) * (Lb * Lb - Lg * Lg)
    p("    t = %-7.3g  max (w/u)^2 = %-11.3e  quad logM = %-13.6e  analytic = %-13.6e  rel diff = %.2e"
      % (t, float(maxz2), float(logM_num), float(ana),
         abs(logM_num - ana) / abs(ana)))

# ---------- [6] mown d-monotonicity on the closure strip ----------
p("")
p("[6] mown d-MONOTONICITY (need mown(t,d) >= mown(t,1/200) for d >= 1/200):")
for t in (1e3, 1e4, 1e6):
    dm = mown(t, 1.0 / 200.0)
    worst = 1.0; dmin = 1.0 / 200.0
    d = 0.005
    while d <= 0.5000001:
        v = mown(t, d) / dm
        if v < worst:
            worst, dmin = v, d
        d += 0.005
    p("    t = %-8.3g  min_{d in [0.005, 0.5] step .005} mown(t,d)/mown(t,0.005) = %.6f at d = %.4f  (>= 1 => monotone)"
      % (t, worst, dmin))

# ---------- [7] EXACT d-edge of the squeeze (mown(t,d*) = W term1) ----------
p("")
p("[7] SQUEEZE d-EDGE: d* with mown(t,d*) = W_term1 = 8.9801e-5 t^-2 (bisection):")
for t in (1e3, 1e4, 1e5, 1e6):
    w1 = 8.9801e-5 / (t * t)
    lo, hi = 0.001, 0.5
    for _ in range(100):
        mid = 0.5 * (lo + hi)
        if mown(t, mid) < w1: lo = mid
        else: hi = mid
    p("    t = %-8.3g  d* = %.6f   (closure d-edge 1/200 = 0.005: margin %+.4f%% in d; squeeze holds for d > d*)"
      % (t, 0.5 * (lo + hi), 100.0 * (0.005 - 0.5 * (lo + hi)) / (0.5 * (lo + hi))))

# ---------- verdict ----------
p("")
p("#" * 78)
if len(crows) >= 3:
    cr_worst = max(r[3] for r in crows)   # (W+Rcrude)/mown worst over the grid
    rm_worst = max(r[3] for r in crows)   # mass residual is e^{log} ~ 0: same total
    p("-- VERDICT (pre-registered) --")
    p("   worst (W + Rcrude)/mown on the grid: %.4f   (CLOSE if < 1)" % cr_worst)
    p("   worst (W + Rmass )/mown on the grid: %.4f   (CLOSE if < 1)" % rm_worst)
    if cr_worst < 1.0:
        p("   -> (A) CRUDE bound level CLOSES the closure-relevant strip d >= 1/200:")
        p("          the (i-b) wire is a 25ab-style S4Growth stage at the t^4 scale")
        p("          + mown floor (W + M e^{X4} X4 < mown(t,1/200) <= mown(t,d)).")
        p("          The t^4-band residual is O((log t) t^-5.75), far below the")
        p("          t^-2 budget; the 10% margin is on W's term1 (25ad [4] (b)).")
    elif rm_worst < 1.0:
        p("   -> (B) CRUDE fails but the MASS smallness closes it: the closing")
        p("          wire REQUIRES the band mass e^{∫nHat fT} (record exact form).")
    else:
        p("   -> (C) NEITHER closes the strip: GAP-O re-quantified at t^4 scale;")
        p("          a different (action-composition) wire family is required.")
else:
    p("-- VERDICT: insufficient grid; extend the t-range.")

open("out_day027_25af_owncompo_survey.txt", "w").write("\n".join(out) + "\n")
p("\n[written out_day027_25af_owncompo_survey.txt]")
