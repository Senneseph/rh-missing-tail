#!/usr/bin/env python3
"""25ad — OWN-REGIME WIRE SURVEY (item 2, the (i-b) gap).

S4Asm/S4Sharp (25v, LEAN-PROVEN): closing GAP-O requires a
replacement wire W with W + Mr + Mf < mown(t,d) on the strip
(0 < d <= 1/2, closure-relevant d >= 1/200); any such W must sit
below Eenv(t) = (1e-4)(16001/15984) t^{-2} — genuinely O(t^{-2}).
25v proved the BOUND-level wall (p8_B(t, floor(13t/8)) >=
(1/2)(8/13)^{1/2} t^{-1/2} >= Kgap t^{3/2} Eenv, Kgap ~ 3918.7, and
no p8_B scale n <= 13t/8 closes).

THIS SURVEY measures the QUANTITY level: the EM tail quantity itself
(verbatim mirror of P4Limit.lean, s = 1/2 + i t):

  p4_em_expr(s,n) = T1 + T2 + T3
  T1 = -1/2 n^{-s};  T2 = (1/12) s n^{-s-1};
  T3 = -1/2 Int_n^inf B2(x) s(s+1) x^{-s-2} dx,
  B2(x) = {x}^2 - {x} + 1/6 (period-1 Bernoulli; mathlib B2),
  W_n(s) := zeta(s) - P_n(s) + I(n,s) = p4_em_expr (p4_identity),
  I(n,s) = n^{-s+1}/(1-s) = -Int_n^inf x^{-s}dx  (the P4 "missing
  tail" is the sum-minus-integral tail difference).  Mirror
  cross-validated at dps-30 (sections [0b] + the s = 2/3/2.5+i
  home-territory check, 1e-15).

Pre-registered verdicts:
  A. raw |EM|/Eenv < 1 with margin on a decade, exponent <= -1.9
     -> wire candidate (REV2 certification -> Lean).
  B. raw |EM|/Eenv >= c t^p, p >= 1.4 on a decade (predict: T1
     dominance, p -> 1.5, c -> Kgap = 3918.7 as t -> inf)
     -> wall at the QUANTITY level: T1 = -2^{-1} n^{-s} is an
        explicit irreducible leading term (no same-order partner);
        record measured coefficient/exponent; the strip wire must
        come from a different family (action composition), not the
        EM tail.
"""
import numpy as np
import mpmath as mp
mp.mp.dps = 30
import day023_p11c_1e7 as p11   # GN list (certified zeros <= 1e7), p8_B mirror

EENV_C = (1.0 / 10000.0) * (16001.0 / 15984.0)

def Eenv(t):  return EENV_C / (t * t)

def mown(t, d):
    t = float(t); d = float(d)
    A = (0.5 + d) ** 2 + t * t
    B = (0.5 - d) ** 2 + t * t
    c = (0.5 + d) / A + (0.5 - d) / B
    return d * d * (d * d + 4 * t * t) / (A * B) * np.exp(c)

GLX, GLW = np.polynomial.legendre.leggauss(32)
NODES = 0.5 * (GLX + 1.0)                    # in (0,1)

def B2(x):
    f = np.mod(x, 1.0)
    return f * f - f + 1.0 / 6.0

def T3(s, t, n, M):
    tot = np.complex128(0)
    x0 = float(n)
    # chunked unit-interval Gauss-Legendre on [n, n+M]
    x0log = np.log(x0)
    for a in range(M):
        if a % 256 == 0:
            jc = np.arange(a, min(a + 256, M)) + x0
            x = jc[:, None] + NODES[None, :]
            f2 = np.exp((-s - 2.0) * np.log(x)) * (s * (s + 1.0))
            tot += np.sum(0.5 * B2(x) * f2 * GLW[None, :])
    return -0.5 * tot

def em(s, t, n, M=4096):
    ln = np.log(float(n))
    T1 = -0.5 * np.exp(-s * ln)
    T2 = (1.0 / 12.0) * s * np.exp((-s - 1.0) * ln)
    T3c = T3(s, t, n, M)
    return T1 + T2 + T3c, T1, T2, T3c

def nlist(t):
    return int(np.floor(13.0 * t / 8.0))

out = []
def p(*a):
    line = " ".join(str(x) for x in a)
    out.append(line); print(line)

p("=" * 78)
p("25ad — own-regime wire survey (quantity level of the 25v wall)")
p("=" * 78)

# ---------- [0] quadrature convergence (M-doubling) ----------
p("")
p("[0] T3 quadrature convergence check (M vs 2M), list scale:")
for t in (1e3, 1e5, 1e7, 1e8):
    n = nlist(t)
    s = complex(0.5, t)
    a = em(s, t, n, 1024); b = em(s, t, n, 2048)
    da = abs(a[3]); db = abs(b[3])
    rel = abs(a[3] - b[3]) / max(da, db, 1e-300)
    p("  t = %-8.3g  |T3(M=1024)| = %-11.5e  |T3(2M)/T3| rel diff = %.3e  |T1| = %.5e"
      % (t, da, rel, abs(a[1])))

# ---------- [0b] cross-validation vs zeta ----------
p("")
p("[0b] cross-validation: |T1+T2+T3| vs |zeta(s) - P_n(s) + I(n,s)| (dps-30)")
for t in (14.134725132581721, 100.0, 1e3, 1e4):
    n = max(2, nlist(t))
    tt = mp.mpf(repr(t)); sm = mp.mpc(mp.mpf("0.5"), tt)
    S = mp.fsum(mp.mpc(k) ** (-sm) for k in range(1, n + 1))
    I = mp.mpf(n) ** (-sm + 1) / (1 - sm)   # P4Limit p4_I = n^{-s+1}/(1-s) = -Int_n^inf
    W = mp.zeta(sm) - S + I
    E, T1, T2, T3c = em(complex(0.5, float(t)), float(t), n, 4096)
    p("  t = %-12.6g n = %-8d |EM| = %-12.6e |W_n| = %-12.6e ratio = %.6f"
      % (t, n, abs(E), float(abs(W)), float(abs(E) / abs(W))))
    p("         |T1| = %-10.4e |T2| = %-10.4e |T3| = %-10.4e  |EM|/|T1| = %.4f"
      % (abs(T1), abs(T2), abs(T3c), abs(E) / abs(T1)))

# ---------- [1] list scale, t grid ----------
p("")
p("[1] LIST SCALE n = floor(13t/8): raw EM norm vs Eenv, t in [1e3, 1e8]")
p("    t             n          |EM|/Eenv  |T1|/Eenv  |T2|/Eenv  |T3|/Eenv  p8_B/Eenv  mown/Eenv")
rows = []
ts = list(np.geomspace(1e3, 1e8, 90))
for t in ts:
    n = nlist(t)
    E, T1, T2, T3c = em(complex(0.5, t), t, n, 4096)
    ee = Eenv(t)
    b8 = p11.p8_B(t, n)
    rows.append((t, n, abs(E), ee, abs(T1), abs(T2), abs(T3c), b8))
    p("    %-13.6g %-12d %-12.6f %-11.5f %-11.5f %-11.5f %-12.6f %.5f"
      % (t, n, abs(E) / ee, abs(T1) / ee, abs(T2) / ee, abs(T3c) / ee,
         b8 / ee, mown(t, 1.0 / 200.0) / ee))
sel = [r for r in rows if 1e6 <= r[0] <= 1e8]
lx = np.log(np.array([r[0] for r in sel]))
ly = np.log(np.array([r[2] / r[3] for r in sel]))
slope, intercept = np.polyfit(lx, ly, 1)
c0 = min(sel, key=lambda r: abs(np.log10(r[0]) - 6.0))[2] / min(
    sel, key=lambda r: abs(np.log10(r[0]) - 6.0))[3]
t0 = min(sel, key=lambda r: abs(np.log10(r[0]) - 6.0))[0]
# direct point at exactly 1e6:
E_m, T1_m, T2_m, T3c_m = em(complex(0.5, 1e6), 1e6, nlist(1e6), 4096)
p("    FIT (1e6..1e8): |EM|/Eenv ~ t^(%.4f);  measured @ t=%.5g: %.6f"
  "   [T1-wall prediction: exponent 1.500, coeff -> Kgap = 3918.7]"
  % (slope, t0, c0))
p("    DIRECT t = 1e6: |EM|/Eenv = %.8f   (Kgap t^1.5 = %.8f; |EM|/|T1| = %.6f)"
  % (abs(E_m) / Eenv(1e6), 3918.6646 * 1e9, abs(E_m) / abs(T1_m)))

# ---------- [2] n-family map ----------
p("")
p("[2] n-FAMILY MAP at t = 1e5, 1e6, 1e7 (raw |EM|/Eenv and |T1|/Eenv):")
p("    t          family           n            |EM|/Eenv   |T1|/Eenv  p8_B/Eenv")
for t in (1e5, 1e6, 1e7):
    fams = [("list 13t/8", nlist(t)), ("t", int(t)), ("t^2", int(t * t)),
            ("2.495e7 t^4", int(2.495e7 * t ** 4))]
    for name, n in fams:
        M = 4096 if n < t * 10 else 512
        E, T1, T2, T3c = em(complex(0.5, t), t, n, M)
        ee = Eenv(t)
        b8 = p11.p8_B(t, n)
        p("    %-9.4g %-15s %-16d %-12.5f %-11.5f %-12.5f"
          % (t, name, n, abs(E) / ee, abs(T1) / ee, b8 / ee))

# ---------- [3] zero heights ----------
p("")
p("[3] ZERO HEIGHTS (actual strip pairs): t = gamma from the certified list")
GN = np.array(p11.GN, dtype=float)
zsel = GN[(GN >= 1e5) & (GN <= 2e7)]
if zsel.size == 0:
    zsel = GN[GN >= 1e4][:50]
zsel = np.linspace(zsel[0], zsel[-1], min(40, zsel.size)).astype(float)
zrows = []
for g in zsel:
    n = nlist(g)
    E, T1, T2, T3c = em(complex(0.5, g), g, n, 4096)
    zrows.append((g, abs(E) / Eenv(g)))
p("    gamma          |EM|/Eenv      |T1|/Eenv (T1 = -2^-1 n^{-s}, exact)")
for g, r in zrows:
    n = nlist(g)
    T1r = (0.5 * np.exp(-np.log(n) / 2.0)) / Eenv(g)
    p("    %-13.6f %-13.5f %-13.5f" % (g, r, T1r))
zl = np.log(np.array([r[0] for r in zrows]))
zr = np.log(np.array([r[1] for r in zrows]))
zs, zi = np.polyfit(zl, zr, 1)
p("    FIT (zero heights): exponent %.4f   [prediction 1.5]" % zs)

# ---------- [4] true floor at the d-edge ----------
p("")
p("[4] TRUE FLOOR at d-edge: mown(t, 1/200) / Eenv(t) (a wire must sit")
p("    below mown, i.e. below Eenv * this factor):")
for t in (1e3, 1e4, 1e5, 1e6, 1e7, 1e8):
    p("    t = %-8.3g  mown/Eenv = %.9f" % (t, mown(t, 1.0 / 200.0) / Eenv(t)))

# ---------- verdict ----------
p("")
p("=" * 78)
lo = [r[2] / r[3] for r in rows if 1e6 <= r[0] <= 1e8]
p("-- VERDICT (pre-registered) --")
p("   min |EM|/Eenv on 1e6..1e8 list scale: %.6g" % min(lo))
if min(lo) < 1.0:
    p("   -> (A) WIRE CANDIDATE: raw EM quantity below the demand envelope.")
elif min(lo) > 1.0 and slope > 1.4:
    p("   -> (B) WALL AT THE QUANTITY LEVEL: raw EM norm >= %.4g t^%.3f"
      " on 1e6..1e8; the T1 = -2^-1 n^{-s} term is irreducible at the" % (c0, slope))
    p("      list scale; the strip wire is not an EM-tail-family object.")
open("out_day026_ownwire_survey.txt", "w").write("\n".join(out) + "\n")
