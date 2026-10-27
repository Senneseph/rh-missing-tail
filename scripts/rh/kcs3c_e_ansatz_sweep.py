"""kcs3c_e: U3c mechanism step - the ansatz-family SCREEN on the seven
recorded residual points (KCS plan: U3c = "derive the transfer
mechanism").  No RH claim.

What this unit does
-------------------
The residual law R(X) = meas(X) - u3(X) at the seven recorded points
(1e7..1e11, all exact sieves; records 0170/0171/0173/0186/0187) has
ruled out the single-form candidates at the tested shapes (0173-0187):
the (loglog/log)^2 scaling form A with constant C, the alpha
power-law form B, and the 4-pt-anchored 2-param mixed form C
(systematic under-prediction, growing positive excess at 1e10/3e10/
1e11).  This run does the MECHANISM screen on the recorded points
only (no new sieving):

  1. The family F of candidate loglog-scale functions:
       f1 = delta(X) = (1/(2 ln X)) ln(2 pi ln X / 4)   (LOS factor)
       f2 = (loglog X / log X)^2                        (tested A)
       f3 = (loglog X / log X)^3
       f4 = loglog X / log X
       f5 = 1 / log X
       f6 = 1 / (log X)^2
       f7 = 1                                            (a FLOOR:
                                                          R -> c0 > 0)
  2. Single-component fits  R ~ c*f  (7 families, 1 param):
     weighted LS with se weights; report c and per-point residuals
     in se.
  3. Two-component fits  R ~ c1*f_i + c2*f_j  (21 pairs, 2 params):
     weighted chi-square with dof = 5; a pair SURVIVES if max
     |resid| <= 3 se AND chi2 <= 2*dof (a loose screening bar, not a
     gate - the plan's strict gate requires a DERIVED correction).
  4. Three-component fits (35 triples, 3 params, dof = 4) - the top
     5 reported; flagged explicitly as the overfit zone (3 params for
     7 points, the earliest points carry only ~2-6 se of resolution).
  5. The EXCESS structure from 0187: e(X) = R(X) - pred4(X) at
     1e10/3e10/1e11 = +6.68e-04/+8.32e-04/+9.99e-04 - fit e(X) ~
     A*(loglog X)^k by 2-point and 3-point power fits (k reported),
     and test whether e is better a FLOOR (constant) + decaying tail.

Honesty rules (per the plan): the sweep NARROWS the mechanism space;
it does not close the strict-CI gate (which needs a derived, not
fitted, correction).  Family fits are candidates for derivation, not
laws.  No RH claim: R(X) is a prime-gap class census residual over
exact integers.
"""
import math
import itertools

# the seven recorded points (X, R, se) - records 0170/0171/0173/0186/0187
PTS = [
    (10 ** 7, 0.009055, 6.082e-04),
    (10 ** 8, 0.006205, 2.070e-04),
    (3 * 10 ** 8, 0.005714, 1.233e-04),
    (10 ** 9, 0.005166, 6.975e-05),
    (10 ** 10, 0.004307, 2.334e-05),
    (3 * 10 ** 10, 0.003971, 1.381e-05),
    (10 ** 11, 0.003654, 7.763e-06),
]


def los_delta(X):
    L = math.log(X)
    return math.log(2.0 * math.pi * L / 4.0) / (2.0 * L)


def fam(X):
    L = math.log(X)
    ll = math.log(L) / L
    return [
        los_delta(X),            # f1 LOS delta
        ll ** 2,                 # f2 (loglog/log)^2   (tested A)
        ll ** 3,                 # f3
        ll,                      # f4 loglog/log
        1.0 / L,                 # f5 1/log
        1.0 / (L * L),           # f6 1/log^2
        1.0,                     # f7 the FLOOR
        # U3c (f): the DERIVED next-order product term of the LOS q=4
        # expansion (the 0188 named candidate) and a BARE growing
        # loglog line (the measured 0187 excess GROWS in X, so a
        # growing candidate must be in the test space)
        los_delta(X) * ll,       # f8 = delta * (loglog/log)
        math.log(L),             # f11 = loglog X (bare, growing)
    ]


FNAMES = ["f1=delta", "f2=(ll/l)^2", "f3=(ll/l)^3", "f4=ll/l",
          "f5=1/log", "f6=1/log^2", "f7=floor",
          "f8=delta*ll/l", "f11=loglog"]


def ols(cols, y, invvar):
    """Weighted LS minimizing  sum_i (residual_i / se_i)^2,  weights
    = 1/se_i^2 = invvar.  cols: feature arrays (no intercept).
    Returns (coeffs, resid_in_se_units, chi2)."""
    n = len(y)
    p = len(cols)
    AtA = [[sum(invvar[i] * cols[a][i] * cols[b][i] for i in range(n))
            for b in range(p)] for a in range(p)]
    Aty = [sum(invvar[i] * cols[a][i] * y[i] for i in range(n))
           for a in range(p)]
    M = [row[:] + [Aty[a]] for a, row in enumerate(AtA)]
    for a in range(p):
        piv = max(range(a, p), key=lambda r: abs(M[r][a]))
        M[a], M[piv] = M[piv], M[a]
        for r in range(p):
            if r != a and M[r][a] != 0:
                f = M[r][a] / M[a][a]
                M[r] = [x - f * yy for x, yy in zip(M[r], M[a])]
    co = [M[a][p] / M[a][a] for a in range(p)]
    resid = [math.sqrt(invvar[i])
             * (y[i] - sum(c * col[i] for c, col in zip(co, cols)))
             for i in range(n)]
    chi2 = sum(r * r for r in resid)
    return co, resid, chi2


def main():
    lines = []
    W = lines.append
    W("U3c (e)  the ansatz-family SCREEN on the 7 recorded residual points")
    W("          (mechanism step;  no new sieving;  no RH claim)")
    W("")
    W("the 7 recorded points (R = meas - u3-only,  exact sieves):")
    W("  %12s %12s %12s" % ("X", "R", "se"))
    for (X, R, se) in PTS:
        W("  %12d %12.6f %12.3e" % (X, R, se))
    W("")

    W = main_W = lines.append
    Xs = [p[0] for p in PTS]
    ys = [p[1] for p in PTS]
    invvar = [1.0 / (p[2] ** 2) for p in PTS]
    FAM = [fam(X) for X in Xs]

    # (1) single-component
    W("== (1) single-component fits  R ~ c*f  (1 param) ==")
    W("  %12s %12s %12s" % ("family", "c", "max|resid|/se"))
    singles = []
    for j in range(7):
        col = [FAM[i][j] for i in range(7)]
        co, resid, chi2 = ols([col], ys, invvar)
        mx = max(abs(r) for r in resid)
        singles.append((mx, j, co[0], chi2))
        W("  %12s %12.5f %12.3f" % (FNAMES[j], co[0], mx))
    singles.sort()
    W("  best single: %s (max|resid| = %.2f se)"
      % (FNAMES[singles[0][1]], singles[0][0]))
    W("")

    # (2) two-component
    W("== (2) two-component fits  R ~ c1*f_i + c2*f_j  (2 params, dof 5) ==")
    W("  screening bar:  max|resid| <= 3 se  AND  chi2 <= 10 (2*dof)")
    W("  %24s %12s %12s %12s" % ("pair", "chi2", "max|res|/se", "c1,c2"))
    pairs = []
    for (i, j) in itertools.combinations(range(7), 2):
        cols = [[FAM[k][i] for k in range(7)], [FAM[k][j] for k in range(7)]]
        co, resid, chi2 = ols(cols, ys, invvar)
        mx = max(abs(r) for r in resid)
        pairs.append((mx, chi2, i, j, co))
    pairs.sort()
    for (mx, chi2, i, j, co) in pairs:
        star = "  <== SURVIVOR" if (mx <= 3.0 and chi2 <= 10.0) else ""
        W("  %10s + %10s  chi2 = %8.2f  max|res| = %6.2fse  c = %.4f, %.4f%s"
          % (FNAMES[i], FNAMES[j], chi2, mx, co[0], co[1], star))
    W("")

    # (3) three-component, top 5 (overfit zone - flagged)
    W("== (3) three-component fits (3 params, dof 4) - TOP 5 ==")
    W("  (OVERFIT ZONE: 3 params for 7 points; the earliest points carry")
    W("   only ~2-6 se of resolution - a triple passing here says almost")
    W("   nothing by itself)")
    W("  %36s %12s %12s" % ("triple", "chi2", "max|res|/se"))
    trips = []
    for (i, j, k) in itertools.combinations(range(7), 3):
        cols = [[FAM[x][t] for x in range(7)] for t in (i, j, k)]
        co, resid, chi2 = ols(cols, ys, invvar)
        mx = max(abs(r) for r in resid)
        trips.append((mx, chi2, (i, j, k), co))
    trips.sort()
    for (mx, chi2, (i, j, k), co) in trips[:5]:
        star = "  <== SURVIVOR" if (mx <= 3.0 and chi2 <= 8.0) else ""
        W("  %8s + %8s + %8s  chi2 = %8.2f  max|res| = %6.2fse%s"
          % (FNAMES[i], FNAMES[j], FNAMES[k], chi2, mx, star))
    W("")

    # (4) the excess structure (0187)
    W("== (4) the 0187 excess structure ==")
    # 4-pt-anchored mixed prediction (a = -0.123764, b = 0.715792 from 0186)
    a4, b4 = -0.123764, 0.715792
    W("  e(X) = R(X) - [a4*delta + b4*(loglog/log)^2],  a4/b4 = the 0186")
    W("  4-point OLS (anchored on 1e7..1e9):")
    expts = []
    for (X, R, se) in PTS[4:]:
        L = math.log(X)
        ll2 = (math.log(L) / L) ** 2
        pred = a4 * los_delta(X) + b4 * ll2
        expts.append((X, R - pred, se, math.log(math.log(X))))
    W("  %14s %14s %12s" % ("X", "excess e(X)", "loglog X"))
    for (X, e, se, lL) in expts:
        W("  %14d %+14.6f %12.4f" % (X, e, lL))
    ll = [p[3] for p in expts]
    le = [math.log(p[1]) for p in expts]
    # 2-point power fits e ~ A*(loglog X)^k
    (x1, y1), (x2, y2), (x3, y3) = (ll[0], le[0]), (ll[1], le[1]), (ll[2], le[2])
    k12 = (y2 - y1) / (x2 - x1)
    k23 = (y3 - y2) / (x3 - x2)
    k13 = (y3 - y1) / (x3 - x1)
    W("  power fits e ~ A*(loglog X)^k (k from point pairs):")
    W("    1e10-3e10:  k = %.3f     3e10-1e11:  k = %.3f     1e10-1e11: k = %.3f"
      % (k12, k23, k13))
    W("  3-point check: does e follow ONE power of loglog X?")
    A13 = math.exp(y1 - k13 * x1)
    e_pred_mid = A13 * math.exp(k13 * x2)
    W("    fit through the ends (k = %.3f):  e(3e10) = %+.6f"
      % (k13, e_pred_mid))
    W("    measured e(3e10) = %+.6f  (deviation %+.4f, i.e. %.1f%% of"
      % (expts[1][1], expts[1][1] - e_pred_mid,
         100.0 * (expts[1][1] - e_pred_mid) / expts[1][1]))
    A12 = math.exp(y1 - k12 * x1)
    e_pred_end = A12 * math.exp(k12 * x3)
    W("    first-pair slope (k = %.3f) extrapolated to 1e11: e = %+.6f"
      % (k12, e_pred_end))
    W("    vs measured 1e11 e = %+.6f (deviation %+.4f)"
      % (expts[2][1], expts[2][1] - e_pred_end))
    # floor test: is e(X) better a constant?
    e_mean = sum(p[1] for p in expts) / 3
    W("  constant-floor test:  e(X) ~ const:  mean = %+.6f,  spread"
      % e_mean)
    W("    %+.6f / %+.6f / %+.6f - the GROWTH is the content, not a"
      % (expts[0][1] - e_mean, expts[1][1] - e_mean,
         expts[2][1] - e_mean))
    W("    floor.")
    W("")

    # (4b) U3c (f): the named candidate structures
    W("")
    W("== (4b) U3c (f): the NAMED candidate structures ==")
    W("    (the (e) family extended with f8 = delta*ll/l, the derived")
    W("     next-order product term of the LOS q=4 expansion, and f11 =")
    W("     loglog X, a bare growing line for the measured 0187 excess)")
    W("")
    NI = {n: k for k, n in enumerate(FNAMES)}
    def col(j):
        return [FAM[i][j] for i in range(7)]
    cands = [
        ("(a) R ~ a*f2 + b*f8       (DERIVED: leading + product term)",
         ["f2=(ll/l)^2", "f8=delta*ll/l"], True),
        ("(b) R ~ a*f2 + b*f6       (0188 best pair, reference)",
         ["f2=(ll/l)^2", "f6=1/log^2"], False),
        ("(c) R ~ a*f2 + b*f8 + c*f11  (derived + growing loglog line)",
         ["f2=(ll/l)^2", "f8=delta*ll/l", "f11=loglog"], True),
        ("(d) R ~ a*f2 + b*f11      (leading + growing loglog line)",
         ["f2=(ll/l)^2", "f11=loglog"], False),
        ("(e) R ~ a*f8 + b*f11      (product + growing line, no lead)",
         ["f8=delta*ll/l", "f11=loglog"], False),
    ]
    for label, names, derived in cands:
        cols = [col(NI[n]) for n in names]
        co, resid, chi2 = ols(cols, ys, invvar)
        mx = max(abs(r) for r in resid)
        tag = "   <-- derived" if derived else ""
        W(label)
        W("    chi2 = %7.2f (dof %d)   max|res| = %6.2f se%s"
          % (chi2, 7 - len(cols), mx, tag))
        W("    c = " + "   ".join("% .5f" % c for c in co))
        W("    res by X: " + "  ".join("%+5.1f" % r for r in resid))
        W("")

    # (5) verdict
    W("== (5) screening verdict ==")
    W("  - the screen NARROWS: it says which family CONTAINS the data;")
    W("    it does NOT close the plan's strict-CI gate (which requires a")
    W("    DERIVED correction, not a fitted one).")
    W("  - flagged for derivation in the next step:")
    surv2 = [p for p in pairs if p[0] <= 3.0 and p[1] <= 10.0]
    surv3 = [p for p in trips if p[0] <= 3.0 and p[1] <= 8.0]
    for (mx, chi2, i, j, co) in surv2:
        W("      two-component: %s + %s (chi2 = %.2f, max %.2f se)"
          % (FNAMES[i], FNAMES[j], chi2, mx))
    for (mx, chi2, (i, j, k), co) in surv3:
        W("      three-component: %s + %s + %s (chi2 = %.2f, max %.2f se)"
          % (FNAMES[i], FNAMES[j], FNAMES[k], chi2, mx))
    if not surv2:
        W("      two-component: none survived the bar")
    if not surv3:
        W("      three-component: none survived the bar")
    W("")
    W("U3c (e) screen done - no RH claim")
    text = "\n".join(lines) + "\n"
    with open(
            "/home/jsmille/Projects/rh-missing-tail/tmp/kcs3c_e_out.txt",
            "w") as f:
        f.write(text)
    print(text)


if __name__ == "__main__":
    main()
