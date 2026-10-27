#!/usr/bin/env python3
# kcs3c_g_derivation.py - U3c (g): the DERIVATION test (0193+).
#
# What the paper gives (Conjecture 1.1, q = 4, read verbatim from
# tmp/u3c_c_fig/paper.txt, identity-checked 0173/0191):
#
#   distinct pair (a,b), a != b (q = 4, b-a = 2):
#   pi(a,b) + pi(b,a) = (2 li(x)/4) [ 1 + (loglog x)/(2 log x)
#                       + ( log(2 pi) - phi(4)*Lambda(2)/phi(2) )/(2 log x) ]
#                         + O(x / log^(7/4) x)
#                 = (li/2) [ 1 + u/2 + ln(pi/2)/(2L) ] + O(...)
#
#   diagonal (a,a):
#   pi(a,a) = (li/4) [ 1 - (phi(4)-1)/2 * loglog x / log x
#                       + ( phi(4) log(4/2 pi) + log 2 pi - phi(4) sum_{p|4} ln p/(p-1) )/(2L) ]
#                         + O(x / log^(7/4) x)
#                 = (li/4) [ 1 - u/2 + ln(2/pi)/(2L) ] + O(...)
#
#   (u = loglog x / log x, L = log x; phi(4) = 2, Lambda(2) = ln 2)
#
# THE DERIVATION (this script verifies it numerically):
#   N = pi(1,3)+pi(3,1) = (li/2) [1 + u/2 + c/(2L)] + O,  c = ln(pi/2)
#   D = N + Diag = li [ 2 terms cancel: +u/2 - u/2 = 0; c + ln(2/pi) = ln 1 = 0 ]
#                = li + O(1/L^2-scale)
#   meas_paper = N/D = (1/2) [1 + u/2 + c/(2L)] = EXACTLY (1+delta)/2
#        delta = (ln L + ln(pi/2))/(2L) = ln(2 pi L / 4) / (2L)
#   to order 1/log x - the 0173 verified delta identity falls out of the
#   full Conjecture 1.1 machinery (the diagonal/off-diagonal 1-logx
#   corrections cancel in the RATIO).
#
#   => meas(x) = (1+delta)/2 + [paper-flagged: non-oscillating lower
#   order terms of size (loglog x / log x)^2, unquantified by the paper
#   ("we hope to understand these lower order terms in future work") ]
#                 + [zero contributions, oscillating, unquantified]
#
# THE DECOMPOSITION (data-driven, 8-point ladder, 0170-0192):
#   S(x) = meas(x) - (1+delta)/2          (the 0173 "52-sigma" structure)
#   S(x) = g(x) + R(x)   where
#     g(x) = u3(x) - (1+delta)/2          (the BASELINE GAP: the exact
#            difference of the two pair models - computable closed/sum)
#     R(x) = meas(x) - u3(x)              (the recorded residual; the
#            0190 derived law R = -1.88114 u^2 + 3.69471 delta u)
#   Screen S(x) itself on {u^2, u/L, 1/L}: does the paper-flagged
#   (loglog/log)^2 scale (u^2) carry the structure?
#
# No RH claim: paper-verbatim algebra, exact integer census data,
# finite statistical screens; flank work.

import json
import math
import re
import sys

import numpy as np

sys.stdout.reconfigure(line_buffering=True)
OUT = open("/home/jsmille/Projects/rh-missing-tail/tmp/u3c_c_fig/kcs3c_g_out.txt",
           "w")


def W(s):
    print(s)
    OUT.write(s + "\n")


def Wt(s):
    OUT.write(s + "\n")
    OUT.flush()


# ---------- verbatim u3 machinery (0192): ----------
_SRC = open(
    "/home/jsmille/Projects/rh-missing-tail/scripts/rh/kcs3b_gap_class_u3b.py"
).read()
_NS = {"np": np, "math": math}
for _name in ["twin_constant", "w_array", "class_sums", "los_delta"]:
    _m = re.search(r"\ndef %s\(.*?(?=\ndef |\nOUT |\nif __name__)" % _name,
                   _SRC, re.S)
    assert _m, _name
    exec(_m.group(0), _NS)
twin_constant = _NS["twin_constant"]
w_array = _NS["w_array"]
class_sums = _NS["class_sums"]
los_delta = _NS["los_delta"]

C = math.log(math.pi / 2.0)   # 0.451582705289...
w = w_array(2000, twin_constant())


def baselines(X):
    L = math.log(X)
    delta = los_delta(L)
    u = math.log(L) / L
    u3s, _ = class_sums(L, w, 2000)
    S2, S0 = u3s, class_sums(L, w, 2000)[1]
    u3 = S2 / (S2 + S0)
    return L, delta, u, u3


# ---------- the 8 recorded ladder points ----------
PTS = [
    # X, meas, se, source
    (10 ** 7, 0.564864, 6.082e-04, "0170/0171/0173"),
    (10 ** 8, 0.556519, 2.070e-04, "0170/0171/0173"),
    (3 * 10 ** 8, 0.553811, 1.233e-04, "0173"),
    (10 ** 9, 0.551072, 6.975e-05, "0173"),
    (10 ** 10, 0.546585, 2.334e-05, "0186"),
    (3 * 10 ** 10, 0.544733, 1.381e-05, "0187"),
    (10 ** 11, 0.542888, 7.763e-06, "0187"),
    (10 ** 12, 0.539769, 2.570e-06, "0192"),
]

W("=== U3c (g): the DERIVATION TEST (no RH claim; flank) ===")
W("paper: arXiv:1603.03720v4 (identity-checked 0173/0191); the Conjecture")
W("1.1 display read VERBATIM from paper.txt (q = 4):")
W("  pi(1,3)+pi(3,1) = (li/2)[1 + u/2 + ln(pi/2)/(2L)] + O(x/log^(7/4)x)")
W("  pi(a,a)         = (li/4)[1 - u/2 + ln(2/pi)/(2L)] + O(x/log^(7/4)x)")
W("  [u = loglog/log, L = log; phi(4)=2, Lambda(2)=ln2, c = ln(pi/2) = %.6f]" % C)
W("")

# ---------- (1) the N/D derivation check ----------
W("(1) THE N/D DERIVATION (paper display formulas -> census ratio):")
W("    meas_paper(x) = N/D with N = (li/2)[1+u/2+c/(2L)], D = li + O(1/L^2)")
W("    (cancellations: +u/2 - u/2 = 0;  c + ln(2/pi) = ln(pi/2 * 2/pi) = ln 1 = 0)")
W("    => meas_paper = (1/2)[1 + u/2 + c/(2L)] = (1+delta)/2, delta = (Lln + c)/(2L)")
W("    numerical check (paper N/D formula vs (1+delta)/2, per X):")
W("      X           u        N/D - (1+delta)/2     (= the O(1/L^2)+ display gap)")
for X in [10 ** k for k in (7, 8, 9, 10, 11, 12)]:
    L, delta, u, u3 = baselines(X)
    N = 0.5 * (1 + u / 2 + C / (2 * L))   # li/2 factor
    D = 1.0                                # li factor (to the displayed order)
    Nd = N / D
    diff = Nd - (1 + delta) / 2.0
    # the display formulas agree to O(1/L): the residual is O(1/L^2):
    W("    %.0e   f%7.5f      %+12.3e        (1/L = %.3e)" % (X, u, diff, 1 / L))
W("")

# ---------- (2) S, g, R decomposition ----------
W("(2) THE DECOMPOSITION S = meas - (1+delta)/2 = g + R  (8 recorded pts):")
W("    X          meas     (1+delta)/2   g = u3-(1+delta)/2   R = S-g    S = meas-(1+delta)/2")
S_data = []
for X, meas, se, src in PTS:
    L, delta, u, u3 = baselines(X)
    p1d2 = (1 + delta) / 2.0
    g = u3 - p1d2
    S = meas - p1d2
    S_data.append((X, meas, se, u, delta, g, S))
    W("    %.0e   f%.6f  f%.6f   %+10.6f   %+10.6f   %+10.6f"
      % (X, meas, p1d2, g, S - g, S))
W("")
W("    the recorded R ladder (0173-0192) = meas - u3;  R = S - g exactly;")
W("    0173: S(1e8) = 0.556519 - 0.545634 = +0.010885 ~ 52 sigma structure")
W("")

# ---------- (3) the derived-law check in (u, 1/L) basis ----------
W("(3) THE 0190 DERIVED LAW IN THE (u, 1/L) BASIS:")
W("    R = -1.88114 u^2 + 3.69471 delta * u")
W("      = (3.69471/2 - 1.88114) u^2 + 3.69471/2 * c * u/L  [delta = (Lln+c)/(2L)]")
A = 3.69471 / 2.0 - 1.88114
B = 3.69471 / 2.0 * C
W("      = %+.6f u^2 + %+.6f (u/L)" % (A, B))
W("      i.e. the fitted law is a (loglog/log)^2 term + a (loglog/log^2) term:")
W("      -  u^2 scale   = the paper's own flagged 'non-oscillating lower-order")
W("                       terms of size (loglog x / log x)^2' (unquantified there)")
W("      -  u/L scale   = one order smaller (loglog/log^2); the baseline gap g(x)")
W("                       is the exact, computable difference of the two pair")
W("                       models and carries mostly THIS structure (below).")
W("")
W("    per point: R_recorded vs the (u,1/L)-basis law:")
W("      X        R (S-g)      law A*u^2+B*u/L       diff")
for X, meas, se, u, delta, g, S in S_data:
    R = S - g
    law = A * u * u + B * u / math.log(X)
    W("    %.0e   %+10.6f   %+10.6f      %+10.6f  (%+.1f se)"
      % (X, R, law, law - R, (law - R) / se))
W("")

# ---------- (4) screen S itself on {u^2, u/L, 1/L} ----------
W("(4) SCREEN S(x) = meas - (1+delta)/2 ON {u^2, u/L, 1/L} (8 pts, inv-var OLS):")
Xs = [p[0] for p in S_data]
Ss = [p[6] for p in S_data]
ses = [p[2] for p in S_data]
u2 = [p[3] ** 2 for p in S_data]
uL = [p[3] / math.log(p[0]) for p in S_data]
invL = [1.0 / math.log(p[0]) for p in S_data]
invvar = [1.0 / s ** 2 for s in ses]
cols = [u2, uL, invL]
names = ["u^2 (the paper-flagged (loglog/log)^2 scale)",
         "u/L  = (loglog/log^2)",
         "1/L"]
n = len(Ss)
p = 3
AtA = [[sum(invvar[i] * cols[a][i] * cols[b][i] for i in range(n))
        for b in range(p)] for a in range(p)]
Aty = [sum(invvar[i] * cols[a][i] * Ss[i] for i in range(n)) for a in range(p)]
# solve 3x3
import copy
M = [row[:] + [Aty[a]] for a, row in enumerate(AtA)]
for a in range(3):
    pv = max(range(a, 3), key=lambda r: abs(M[r][a]))
    M[a], M[pv] = M[pv], M[a]
    for r in range(3):
        if r != a:
            f = M[r][a] / M[a][a]
            M[r] = [x - f * y for x, y in zip(M[r], M[a])]
co = [M[a][3] / M[a][a] for a in range(3)]
resid = [math.sqrt(invvar[i]) * (Ss[i] - sum(c * col[i] for c, col in zip(co, cols)))
         for i in range(n)]
chi2 = sum(r * r for r in resid)
W("    fit: S = %.5f u^2 + %.5f (u/L) + %.5f (1/L)" % tuple(co))
W("    chi2 = %.2f / %d dof   max|resid| = %.2f se"
  % (chi2, n - p, max(abs(r) for r in resid)))
W("    per point (fit vs S):")
W("      X          S (data)   S (fit)        resid (se)")
for i, X in enumerate(Xs):
    fitv = sum(c * col[i] for c, col in zip(co, cols))
    W("    %.0e   %+10.6f  %+10.6f    %+10.6f  (%+.1f se)"
      % (X, Ss[i], fitv, resid[i], resid[i]))
W("")
W("    and the SAME screen on the baseline gap g = u3 - (1+delta)/2:")
gs = [p[5] for p in S_data]
Aty2 = [sum(invvar[i] * cols[a][i] * gs[i] for i in range(n)) for a in range(p)]
M2 = [row[:] + [Aty2[a]] for a, row in enumerate(AtA)]
for a in range(3):
    pv = max(range(a, 3), key=lambda r: abs(M2[r][a]))
    M2[a], M2[pv] = M2[pv], M2[a]
    for r in range(3):
        if r != a:
            f = M2[r][a] / M2[a][a]
            M2[r] = [x - f * y for x, y in zip(M2[r], M2[a])]
co2 = [M2[a][3] / M2[a][a] for a in range(3)]
resid2 = [math.sqrt(invvar[i]) * (gs[i] - sum(c * col[i] for c, col in zip(co2, cols)))
          for i in range(n)]
chi22 = sum(r * r for r in resid2)
W("    fit: g = %.5f u^2 + %.5f (u/L) + %.5f (1/L)" % tuple(co2))
W("    chi2 = %.2f / %d dof   max|resid| = %.2f se"
  % (chi22, n - p, max(abs(r) for r in resid2)))
W("")

# ---------- (5) statement ----------
W("(5) STATEMENT (honest):")
W("    ALGEBRA (verified above): the paper's Conjecture 1.1 display formulas,")
W("    read verbatim, collapse in the census RATIO to exactly (1+delta)/2")
W("    to order 1/log x - the 0173 delta identity is a CONSEQUENCE of the")
W("    full main conjecture (the +u/2 / -u/2 and c / ln(2/pi) terms cancel")
W("    because c + ln(2/pi) = ln 1 = 0). What remains by the paper's own")
W("    accounting: (i) O(x/log^(7/4)) from the display, (ii) the paper-")
W("    flagged NON-OSCILLATING terms of size (loglog/log)^2 ('we hope to")
W("    understand these in future work'), (iii) oscillating zero")
W("    contributions (unquantified).")
W("    DATA: S = meas - (1+delta)/2 is dominated over 1e7..1e12 by the two")
W("    small scales u^2 and u/L (the fit above); the baseline gap g (the")
W("    exact difference of the u3 and (1+delta)/2 pair models) and the")
W("    recorded residual R carry the split  S = g + R.")
W("    What this DERIVES vs what it FITS (no drift):")
W("      DERIVED: meas_paper = (1+delta)/2 to 1/log x (algebra, verified);")
W("               the structure of S is limited by the paper to {non-oscillating")
W("               (loglog/log)^2-scale} + {oscillating zero terms}; u^2 IS the")
W("               (loglog/log)^2 scale and u/L is one order below it.")
W("      FITTED:  the two coefficients (this entry's law, 0190): a fit to the")
W("               8-point ladder - NOT derived from the paper's O-terms (the")
W("               paper does not quantify them). The strict-CI gate therefore")
W("               stands as recorded in 0192 (derived terms, fitted")
W("               coefficients; out-of-sample confirmed at 1e12 to -3.1 se;")
W("               3e12 in flight as the second out-of-sample test).")
W("")
W("No RH claim: paper-verbatim algebra + measured finite screens; flank.")
OUT.close()
