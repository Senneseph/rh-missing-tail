"""s6: verify the closed form of the squeeze factor c(s)  --  quad-only.

Exact bookkeeping (every step verified numerically in this chain):

  D1  log Kabs = lm + la + re + corr + Q_f
      (the ledger's Kabs carries the engine far quad Q_f;  verified to
       the last printed digit against the certified engine value)

  D2  Hadamard:  log|zeta| = log|main| + SUM_all W_pair
      W_pair(g, t) = log|g-t| + log(g+t) - log(g^2+1/4)
      (one term per pair {1/2+ig, 1/2-ig};  exact product form)

  D3  la + re   =  SUM_modeled W_pair  +  Ex_m
      Ex_m       =  sum over modeled pairs  1/(2 (g^2+1/4))
      (the engine's la/re kernel is W_pair + 1/(2(g^2+1/4)))

  c = Kabs / |zeta|   (measured;  ratio is -|c|,  phase pi)  =>

      log c  =  [lm - log|main|]  +  Ex_m  +  corr  +  Q_f  -  S_U     (T)

  where  S_U =  sum of W_pair over the UNMODELED zero pairs
      U =  (1e7, F1_first]  U  (1e9, 1.002e9]  U  (2e9, 2.002e9]
          U  (G, 1e30]

Term sources (all independent):
  * lm, log|main|      mpmath dps-30
  * Ex_m               numpy over the GN grid  +  mp.quad over the
                       D-band  (kernel 1/(2(g^2+1/4)) is genus-0 and
                       varies per-pair by ~ 2 dg/g ~ 1e-10,  so the
                       RVM density gives it at machine precision)
  * corr               ledger B-fields (real parts)
  * Q_f                from the s5 run jsonl  (certified engine quad;
                       kernel W_pair + 0.5/(g^2+1/4),  the difference
                       vs pure W_pair is ~1e-7 over (G,1e30]  and is
                       part of the documented residual)
  * S_U                mp.quad of W_pair * (ln g/2pi)/2pi  over g,
                       split at 1e18 for the far band  (same variable
                       and split as the verified s5 code)

Residual budget:  GN grid approximation of la/re  (0.5-step sampling,
Door B artifact)  +  RVM-density quad error of S_U over the gap bands
(no zeros on disk there)  +  Q_f kernel-convention 1e-7.

Run time:  order one minute  (no file streaming).
"""
import json
import math
import os
import sys
import time

import numpy as np
import importlib.util

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)

spec = importlib.util.spec_from_file_location(
    "s3", os.path.join(HERE, "s3_ledger_recon_margin_sweep.py"))
s3 = importlib.util.module_from_spec(spec)
spec.loader.exec_module(s3)

import day023_p11c_1e7 as M
from mpmath import mp, mpf, mpc, workdps, log as mlog, re as mre

workdps(30)

ROOT = os.path.abspath(os.path.join(HERE, "..", ".."))
OUT = os.path.join(ROOT, "tmp", "s6_c_closedform.md")
JSON = os.path.join(ROOT, "tmp", "s6_c_closedform.jsonl")

_mm = np.memmap(s3.D_FILE, dtype=np.float64, mode="r")
G_LAST = float(_mm[-1])
D_FIRST = float(_mm[0])
del _mm

_f1 = np.memmap(os.path.join(HERE, "hi1e9",
                             "zeros_hi31946e6_to_1e9.f64"),
                dtype=np.float64, mode="r")
F1_FIRST = float(_f1[0])
del _f1
print("G_LAST=%.6f  D_FIRST=%.6f  F1_FIRST=%.6f" %
      (G_LAST, D_FIRST, F1_FIRST), flush=True)

T0 = 3232170971.1121945
T1 = 27884282870.578449249 + 0.5

U_SPLIT = 1e18


def quad_wp(tv, a, b):
    """mp.quad of  W_pair * (ln g/2pi)/2pi  over [a, b]  in g."""
    s = mpc(0.5, mpf(repr(tv)))
    def fg(gg):
        r1 = mpc(0.5, gg)
        r2 = mpc(0.5, -gg)
        # pure pair product kernel  (no genus-1 extras)
        p = mp.log(1 - s / r1) + mp.log(1 - s / r2)
        return mp.re(p) * (mp.log(gg / (2 * mp.pi)) / (2 * mp.pi))
    return mp.quad(fg, [mpf(repr(a)), mpf(repr(b))])


def quad_ex(a, b):
    """mp.quad of  1/(2(g^2+1/4)) * (ln g/2pi)/2pi  over [a, b]."""
    def ge(gg):
        return (mpf("0.5") / (gg * gg + mpf("0.25"))
                * (mp.log(gg / (2 * mp.pi)) / (2 * mp.pi)))
    return mp.quad(ge, [mpf(repr(a)), mpf(repr(b))])


def band_quad(tv, a, b, kind):
    if b <= a:
        return mp.mpf("0")
    if b > U_SPLIT and a < U_SPLIT:
        return (band_quad(tv, a, U_SPLIT, kind)
                + band_quad(tv, U_SPLIT, b, kind))
    if kind == "W":
        return quad_wp(tv, a, b)
    return quad_ex(a, b)


def lm_re(t):
    return float(mre(s3.logmain25212(mpc(0.5, mpf(repr(t))))))


def logmain_re(t):
    s = mpc(0.5, mpf(repr(t)))
    # main = (1/2) s (s-1) pi^{-s/2} / Gamma(s/2)
    ml = (mpf("0.5") * mlog(s) + mlog(s - 1)
          - (s / 2) * mlog(mp.pi) - mlog(2) - mlog(mp.gamma(s / 2)))
    return float(mre(ml))


def main():
    t0 = time.time()

    gn = np.asarray(M.GN, dtype=np.float64)
    gsel = gn[(gn >= 14.134725141734695) & (gn < F1_FIRST)]
    ex_grid = float(np.sum((0.5 / (gsel * gsel + 0.25))
                           .astype(np.longdouble)))
    print("ex_grid over %d GN pts = %.12f   (%.0f s)"
          % (gsel.size, ex_grid, time.time() - t0), flush=True)

    ex_d = float(mre(quad_ex(D_FIRST, G_LAST)))
    print("ex_d (D-band quad) = %.12f   (%.0f s)"
          % (ex_d, time.time() - t0), flush=True)
    Ex_m = ex_grid + ex_d

    bands = [(1e7, F1_FIRST),
             (1e9, 1.002e9),
             (2e9, 2.002e9),
             (G_LAST, 1e30)]
    SU = {T0: mp.mpf("0"), T1: mp.mpf("0")}
    det = []
    for (a, b) in bands:
        q0 = band_quad(T0, a, b, "W")
        q1 = band_quad(T1, a, b, "W")
        SU[T0] += q0
        SU[T1] += q1
        det.append(((a, b), float(mre(q0)), float(mre(q1))))
        print("band (%.9g, %.9g]:  W(t0)=%+.9e   W(t1)=%+.9e   (%.0f s)"
              % (a, b, float(mre(q0)), float(mre(q1)), time.time() - t0),
              flush=True)
    SU = {k: float(mre(v)) for k, v in SU.items()}

    Q_f = {T0: None, T1: None}
    p5 = os.path.join(ROOT, "tmp", "s5_hadamard_verify.jsonl")
    for line in open(p5):
        r = json.loads(line)
        tv = float(r["t"])
        for k in (T0, T1):
            if abs(tv - k) < 0.01:
                Q_f[k] = float(r["qF"])
    if Q_f[T0] is None or Q_f[T1] is None:
        raise SystemExit("s5 jsonl missing one of the test heights")
    print("Q_f(t0)=%.9e   Q_f(t1)=%.9e   (s5 run,  far band only)"
          % (Q_f[T0], Q_f[T1]), flush=True)

    rows_led = {}
    for line in open(s3.LEDGER):
        r = json.loads(line)
        tv = float(r["t"])
        for k in (T0, T1):
            if abs(tv - k) < 0.01 and k not in rows_led:
                rows_led[k] = r

    out = []
    for k in (T0, T1):
        p = rows_led[k]["p"]
        lm = lm_re(k)
        lmain = logmain_re(k)
        corr = (float(p["Bexp"]) + float(p["Bph"])
                + float(p["Btail_re"]) + float(p["Bprod_re"])
                + float(p["Bqrem"]) + float(p["Bqext"]))
        LHS = math.log(float(p["Kabs"]) / float(p["zeta"]))
        I = lm - lmain
        RHS = I + Ex_m + corr + Q_f[k] - SU[k]
        d = LHS - RHS
        out.append(dict(t=k, LHS=LHS, I=I, Ex_m=Ex_m, corr=corr,
                        Q_f=Q_f[k], S_U=SU[k],
                        Qf_minus_SU=Q_f[k] - SU[k], RHS=RHS, diff=d,
                        lm=lm, logmain=lmain,
                        la=float(p["la"]), re=float(p["re"]),
                        Kabs=float(p["Kabs"]), zeta=float(p["zeta"])))
        with open(JSON, "a") as fh:
            fh.write(json.dumps(out[-1]) + "\n")
        print("t=%.9g" % k, flush=True)
        print("   LHS  = %+.9f" % LHS, flush=True)
        print("   I    = %+.9f   (lm=%+.6f  log|main|=%+.6f)"
              % (I, lm, lmain), flush=True)
        print("   Ex_m = %+.9f   corr = %+.4e" % (Ex_m, corr), flush=True)
        print("   Q_f  = %+.9e" % Q_f[k], flush=True)
        print("   S_U  = %+.9e   (Q_f - S_U = %+.3e)"
              % (SU[k], Q_f[k] - SU[k]), flush=True)
        print("   RHS  = %+.9f   diff = %+.3e" % (RHS, d), flush=True)

    lines = ["# s6:  closed form of the squeeze factor c(s)", "",
             "log c  =  [lm - log|main|] + Ex_m + corr + Q_f - S_U",
             "",
             "main = (1/2) s (s-1) pi^{-s/2} / Gamma(s/2)",
             "   (zeta = main * Prod_{pairs} (1-s/r1)(1-s/r2);  RH => s on C)",
             "",
             "| t | LHS | I | Ex_m | corr | Q_f | S_U | Q_f-S_U | RHS | diff |",
             "|---|---|---|---|---|---|---|---|---|---|"]
    for o in out:
        lines.append("| %.9g | %+.8f | %+.8f | %.9f | %.3e | %.6e | %.6e | %.3e | %+.8f | %.3e |"
                     % (o["t"], o["LHS"], o["I"], o["Ex_m"], o["corr"],
                        o["Q_f"], o["S_U"], o["Qf_minus_SU"], o["RHS"],
                        o["diff"]))
    lines += ["",
              "term sources:",
              "  I      = lm - log|main|,  mpmath dps-30",
              "  Ex_m   = grid exact (%d pts) + D-band RVM quad" % gsel.size,
              "  corr   = ledger B-fields (real parts)",
              "  Q_f    = s5 run jsonl  (certified engine far quad;",
              "           kernel W_pair + 0.5/(g^2+1/4))",
              "  S_U    = this run,  pure W_pair,  mp.quad over g",
              "           split at 1e18 for the far band",
              "",
              "S_U band detail:"]
    for (a, b), v0, v1 in det:
        lines.append("  (%.9g, %.9g]:   t0  %+.9e   t1  %+.9e" % (a, b, v0, v1))
    lines += ["",
              "residual budget:  GN 0.5-step grid artifact (Door B) on la/re",
              "  +  RVM-density quad error on the gap bands (no zeros on",
              "  disk)  +  Q_f kernel convention (~1e-7).",
              ""]
    open(OUT, "w").write("\n".join(lines) + "\n")
    print("wrote", OUT)


if __name__ == "__main__":
    if os.path.exists(JSON):
        os.unlink(JSON)
    main()
