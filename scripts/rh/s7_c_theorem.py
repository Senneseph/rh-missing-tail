"""s7: close the c(t) theorem.

From the verified engine composition (day037_h1_3e10.py,  code-read):

    Kfull = exp(lm + la + i ar + re + i im) * exp(qrem) * exp(qext)

    la      = sum over GN grid  [W_pair + 1/(2(g^2+1/4))]      (exact, f64)
    re      = sum over ACTUAL zeros of (1e7, G_LAST]
              [W_pair + 1/(2(g^2+1/4))]                         (exact, f64)
    qrem    = 400-node log-quad (G_LAST, 1e18],  dps-30
    qext    = 400-node log-quad (1e18,  1e30],  dps-30
              kernel  Re[log(1-s/r1)+log(1-s/r2)+s/r1+s/r2]
                     * (ln g/2pi)/2pi      =  W_pair + 1/(g^2+1/4)

    (the B-fields are error bounds,  not exponent addends)

and the verified main-term identity  (s7 below,  checked at both
heights to ~1e-7):

    lm(t) = log|main_exact(t)| + ln xi(0) - Ex_total   +  O(1e-7)

    main_exact = 2 pi^{s/2} / (s (s-1) Gamma(s/2))
        (  zeta(s) =  xi(s)/main_exact,
           xi(s) = (1/2) s (s-1) pi^{-s/2} Gamma(s/2) zeta(s),
           xi(0) = 1/2  (verified)  )
    Ex_total   = sum over all modeled pairs  1/(2 (g^2+1/4))
                 (grid exact + D-band quad,  t-independent)

Hadamard over the full zero set  (RH assumed above  G;  below  G
the actual zeros are on disk):

    log|zeta| = log|main_exact| + ln xi(0)
             + (la + re) - Ex_total
             + I_far,RVM(t) + M(t)

    I_far,RVM(t) = int_G^1e30  W_pair(g,t) (ln g/2pi)/2pi dg
    M(t)         = true tail product minus RVM density integral
                   (model error;  the missing-tail remainder)

THEOREM  (one line,  all else verified):

    log c(t)  =  EPS + Q_engine(t) - I_far,RVM(t) - M(t)

    EPS        = lm - log|main_exact| - ln xi(0) + Ex_total
                 ~ -1.2e-7   (t-independent to 1e-7,  below)
    Q_engine   = log Kabs - lm - la - re    (from the ledger;
                 = Re(qrem30 + qext30)  exactly)
    M(t)       = tail model error  (what RVM does not see)

s7 computes every term at both heights and reports  M(t) = the
residual.  If M is smooth and small,  the squeeze factor c(t) is
fully accounted for:  a constant,  the ledger's own tail quad,
the exact RVM quad,  and the RVM model error.
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
from mpmath import mp, mpf, mpc, workdps, log as mlog, re as mre, gamma

workdps(40)

ROOT = os.path.abspath(os.path.join(HERE, "..", ".."))
OUT = os.path.join(ROOT, "tmp", "s7_c_theorem.md")
JSON = os.path.join(ROOT, "tmp", "s7_c_theorem.jsonl")

_mm = np.memmap(s3.D_FILE, dtype=np.float64, mode="r")
G_LAST = float(_mm[-1])
D_FIRST = float(_mm[0])
del _mm

_f1 = np.memmap(os.path.join(HERE, "hi1e9",
                             "zeros_hi31946e6_to_1e9.f64"),
                dtype=np.float64, mode="r")
F1_FIRST = float(_f1[0])
del _f1

# Ex_total  from the s6 run  (grid exact + D-band quad)
_ex = None
p6 = os.path.join(ROOT, "tmp", "s6_c_closedform.jsonl")
for line in open(p6):
    r = json.loads(line)
    _ex = float(r["Ex_m"])
    break   # t-independent
EX_TOTAL = _ex

XI0 = mpf("0.5")          # verified 0.499999999999988 at dps-30

T0 = 3232170971.1121945
T1 = 27884282870.578449249 + 0.5


def lm_re(t):
    return float(mre(s3.logmain25212(mpc(0.5, mpf(repr(t))))))


def logmain_ex(t):
    s = mpc(0.5, mpf(repr(t)))
    ml = (mlog(2) + (s / 2) * mlog(mp.pi)
          - mlog(s) - mlog(s - 1) - mlog(gamma(s / 2)))
    return float(mre(ml))


def i_far(tv, dps):
    """exact (up to dps) RVM quad of W_pair over (G, 1e30],  in
    u = ln g  (smooth,  decaying  ->  tanh-sinh exact at dps)."""
    with workdps(dps):
        s = mpc(0.5, mpf(repr(tv)))
        def fu(u):
            g = mp.e**u
            r1 = mpc(0.5, g)
            r2 = mpc(0.5, -g)
            p = (mp.log(1 - s / r1) + mp.log(1 - s / r2))
            return mp.re(p) * (u - mp.log(2 * mp.pi)) / (2 * mp.pi) * g
        lo = mp.log(mpf(repr(G_LAST)))
        hi = mp.log(mpf("1e30"))
        return float(mre(mp.quad(fu, [lo, hi])))


def i_far_trap(tv):
    """independent check:  u-trapezoid,  2e6 points."""
    u0, u1 = math.log(G_LAST), math.log(1e30)
    u = np.linspace(u0, u1, 2_000_001)
    g = np.exp(u)
    g2 = g * g
    w = (np.log(np.abs(g - tv)) + np.log(g + tv) - np.log(g2 + 0.25))
    dens = (u - math.log(2 * math.pi)) / (2 * math.pi) * g
    v = w * dens
    return float(np.trapz(v, u))


def main():
    t0 = time.time()
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
        la = mpf(repr(float(p["la"])))
        re_ = mpf(repr(float(p["re"])))
        kabs = mpf(repr(float(p["Kabs"])))
        zeta = mpf(repr(float(p["zeta"])))
        lm = lm_re(k)
        lme = logmain_ex(k)
        eps = lm - lme - float(mre(mlog(XI0))) + EX_TOTAL
        Qeng = float(mre(mlog(kabs)) - lm - float(la) - float(re_))
        Ih = i_far(k, 40)
        It = i_far_trap(k)
        LHS = float(mre(mlog(kabs) - mlog(zeta)))
        M = eps + Qeng - Ih - LHS
        out.append(dict(t=k, LHS=LHS, lm=lm, logmain_ex=lme, eps=eps,
                        Q_engine=Qeng, I_far_quad=Ih, I_far_trap=It,
                        quad_vs_trap=It - Ih,
                        EPS_plus_Q_I=eps + Qeng - Ih,
                        M=M, la=float(la), re=float(re_),
                        Kabs=float(kabs), zeta=float(zeta)))
        with open(JSON, "a") as fh:
            fh.write(json.dumps(out[-1]) + "\n")
        print("t = %.10g   (%.0f s)" % (k, time.time() - t0), flush=True)
        print("  EPS            = %+.9f" % eps, flush=True)
        print("  Q_engine       = %+.9f" % Qeng, flush=True)
        print("  I_far (quad40) = %+.9f" % Ih, flush=True)
        print("  I_far (trap)   = %+.9f   (spread %.3e)"
              % (It, abs(It - Ih)), flush=True)
        print("  LHS  log c     = %+.9f" % LHS, flush=True)
        print("  M  (residual)  = %+.9f" % M, flush=True)

    lines = ["# s7:  the c(t) theorem", "",
             "log c(t)  =  EPS + Q_engine(t) - I_far,RVM(t) - M(t)", "",
             "  EPS        = lm - log|main_ex| - ln(xi(0)) + Ex_total"
             "   (constant ~ -1.2e-7)",
             "  main_ex    = 2 pi^{s/2} / (s (s-1) Gamma(s/2))",
             "  Q_engine   = log Kabs - lm - la - re      (ledger exact)",
             "  I_far,RVM  = int_G^{1e30} W_pair (ln g/2pi)/2pi dg",
             "  M(t)       = RVM tail model error  (true zeros - density)",
             "",
             "| t | LHS | EPS | Q_engine | I_far(quad40) | "
             "I_far(trap) | M |",
             "|---|---|---|---|---|---|---|"]
    for o in out:
        lines.append("| %.9g | %+.8f | %.6e | %.5f | %.5f | %.5f | %+.6f |"
                     % (o["t"], o["LHS"], o["eps"], o["Q_engine"],
                        o["I_far_quad"], o["I_far_trap"], o["M"]))
    lines += ["",
              "quad40 = u-quad dps-40;  trap = 2e6-pt u-trapezoid.",
              "M smooth and small  =>  c fully accounted:  constant,",
              "ledger's own tail quad, exact RVM quad, RVM model error.",
              ""]
    open(OUT, "w").write("\n".join(lines) + "\n")
    print("wrote", OUT)


if __name__ == "__main__":
    if os.path.exists(JSON):
        os.unlink(JSON)
    main()
