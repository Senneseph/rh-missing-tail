#!/usr/bin/env python3
"""day049d -- the fleet's OWN cert_point, verbatim, on this box, at
the p01 ledger point.  The ledger row shows residf = zeta (|z|) to
every printed digit in EVERY row of its window -- i.e. the fleet's
Kfull was ~0 everywhere (the margin then degenerates to mnew ~= dev
~= 1 - eps,  and the certificate to mcert ~= 1.0000,  because dK
scales with |K|).  All the fleet's component budgets (Bexp 4.022e-4,
Btail 4.000e-4,  Bqrem 1.527e-21,  Bz 6.795e-22,  ...) are
normal -- but the B columns are dps-30/60 SPREADS,  which cannot
see a ~1e9 absolute error in any single component.  The four
components of the exponent (lm, la, re, q) are each O(1e9) and
cancel to ~+0.257 (verified at dps 30-120 by the pi-probe);  losing
(or offsetting) one of {lm, la, re} by ~1e9 collapses K to 0.

  This driver runs, in the CURRENT environment:
    (1) D38.cert_point(T, t, g, audit=True, nthreads=8)  -- the
        exact fleet function (the ledger row's producer);
    (2) the component stack (lm30, la, ar, qrem30, qext30) for a
        side-by-side comparison with the pi-probe reference values;
    (3) the comparison table:  today's row  vs  the recorded fleet
        ledger row (h1_final_fleet/5900x/ckpt/widx00_x3490744654.
        pts,  the k=-12 row),  component by component.

  If today's cert_point reproduces mnew ~= 1.000000000 (K ~ 0):
  the bug is in the CURRENT code/environment and the component
  comparison above names it (a single ~1e9 component is wrong).
  If today's cert_point gives mnew ~= 0.502658:  the current
  (code, data, environment) is CLEAN and the fleet run's
  environment (the fleet ran under its own python environment at
  launch time;  this file is unchanged since then) is the provenance
  question.

  One 8-thread GPU tail pass (~30-40 min).  Runs ALONE (after D1's
  per-slab phase),  1 CPU core + iGPU.
"""
import json
import math
import os
import sys
import time

R_H = "/home/jsmille/Projects/rh-missing-tail"
sys.path.insert(0, R_H + "/scripts/rh")
from mpmath import mp                   # noqa: E402
import day038_h1_3e10_gpu as D38        # noqa: E402

HERE = os.path.dirname(os.path.abspath(__file__))
OUT = os.path.join(HERE, "out_day049d")
os.makedirs(OUT, exist_ok=True)

T_P01 = 3490744648.3185544014
G_P01 = 3490744654.3185544014
NLT_P01 = 10609961701

# the recorded fleet ledger row (k = -12 of widx00_x3490744654.pts,
# 5900x, md5-chained delivery):
LEDGER = {
    "mnew": 0.9999999965, "mcert": 0.9999999965,
    "residf": 1.3075849021, "zeta": 1.307585, "dev": 1.0,
    "Bexp": 4.022e-4, "Bph": 1.0e-4, "Bz": 6.795e-22,
    "Bdev": 8.519e-32, "Btail_re": 4.000e-4, "Btail_im": 6.809e-5,
    "Bprod_re": 2.232e-6, "Bprod_im": 3.194e-5,
    "Bqrem": 1.527e-21, "Bqext": 7.026e-10, "nlt": 10609961701,
    "audit": {"rem_spread_max": 4.023e-21,
              "ext_spread_max": 7.026e-10},
}

# the day049a pi-probe reference (dps-invariant at 30/45/90/120):
PIPROBE = {
    "lm": "(2741624396.408, -33479200054.330)",   # complex, printed
    "la": 286605200.676542, "ar": 14219278.525265,
    "re": -1519600917.8097972869873047,          # 80-bit ld stream
    "im": 33332178583.221424,                    # engine convention
    "Kfull_abs": 1.2937556, "Kfull_phase": 4.1815,
    "margin": 0.502658, "residf_true": 2.601338,
}


def main():
    t0 = time.time()
    print("D4  cert_point replication at p01 (t=%.16f, g=%.16f)"
          % (T_P01, G_P01), flush=True)
    T = D38.Tail3E10(verbose=False)
    pc = D38.cert_point(T, T_P01, G_P01, audit=True, nthreads=8)
    out = {"point": {"t": T_P01, "g": G_P01, "nlt": pc["nlt"]},
           "today": {}, "ledger": LEDGER, "pi_probe": PIPROBE}
    for (k, v) in pc.items():
        out["today"][k] = str(v) if isinstance(v, (mp.mpf, mp.mpc)) \
            else v
    # the component stack (same calls cert_point makes;  no tail
    # pass involved here):
    mp.dps = 30
    s30 = mp.mpc(0.5, mp.mpf(repr(float(T_P01))))
    lm30 = D38.logmain25212(s30)
    (la, ar, _b1, _b2, _b3) = D38.prod_with_budget(T_P01)
    (qr30, qx30, _q60a, _q60b, _bq1, _bq2, _aud) = \
        D38.quad_pair(T, T_P01, False)
    out["components_today"] = {
        "lm30": str(lm30), "la": repr(float(la)), "ar": repr(float(ar)),
        "qrem30": str(qr30), "qext30": str(qx30),
    }
    # the exponent's real part, assembled today at dps-60:
    mp.dps = 60
    s60 = mp.mpc(0.5, mp.mpf(repr(float(T_P01))))
    lm60 = D38.logmain25212(s60)
    (qr60, qx60, *_rest) = D38.quad_pair(T, T_P01, False)
    re_t, im_t, nlt_t, _B1, _B2, _dm = D38.tail_with_budget(
        T, T_P01, nthreads=8)
    exp_re = (mp.re(lm60) + mp.mpf(repr(float(la)))
              + mp.mpf(repr(re_t)) + mp.re(qr60) + mp.re(qx60))
    exp_im = (mp.im(lm60) + mp.mpf(repr(float(ar)))
              + mp.mpf(repr(im_t)) + mp.im(qr60) + mp.im(qx60))
    out["components_today"] |= {
        "exponent_real_dps60": str(exp_re),
        "exponent_imag_dps60": str(exp_im),
        "K_abs_from_exponent": str(mp.e ** exp_re),
    }
    with open(os.path.join(OUT, "cert_p01.json"), "w") as fh:
        json.dump(out, fh, indent=1)
    print("D4  TODAY:    mnew=%s  mcert=%s  residf=%s  zeta=%s"
          % (format(out["today"]["mnew"], ".10f"),
             format(out["today"]["mcert"], ".10f"),
             format(out["today"]["residf"], ".10f"),
             format(out["today"]["zeta"], ".10f")), flush=True)
    print("D4  LEDGER:   mnew=%s  mcert=%s  residf=%s  zeta=%s"
          % (format(LEDGER["mnew"], ".10f"),
             format(LEDGER["mcert"], ".10f"),
             format(LEDGER["residf"], ".10f"),
             format(LEDGER["zeta"], ".10f")), flush=True)
    print("D4  exponent real (dps-60) = %s   (pi-probe needs ~+0.257;"
          % mp.nstr(exp_re, 12), flush=True)
    print("D4    K=0 in the ledger would need it ~ < -30 at dps-30)")
    print("D4  components lm30=%s" % out["components_today"]["lm30"],
          flush=True)
    print("D4    la=%s ar=%s" % (out["components_today"]["la"],
                                 out["components_today"]["ar"]),
          flush=True)
    print("D4    qrem30=%s" % out["components_today"]["qrem30"],
          flush=True)
    print("D4    qext30=%s" % out["components_today"]["qext30"],
          flush=True)
    print("D4  Efull today = %s  (the |z|/|K| log-ratio)"
          % out["today"].get("Efull"), flush=True)
    print("D4  done. wall = %.1f min" % ((time.time() - t0) / 60.0),
          flush=True)


if __name__ == "__main__":
    main()
