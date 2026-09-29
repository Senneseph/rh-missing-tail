#!/usr/bin/env python3
"""day049c -- D1: the GPU-vs-CPU slab-by-slab tail diff (valiant
forensics).  The 3e10 C-3 deepening localized the margin artifact to
the day038 GPU full-tail instrument:  at the worst straddles the
ledger's margin column reads ~1 - 4e-9 while three independent
pipelines (V1 engine f64, V2 80-bit tree, V4 f128+dps-60) read
0.502658.  The day049a pi-probe ruled out dps.  The only unverified
instrument left:  the GPU tail sum itself (no selftest on the live
band compares GPU full-tail totals to the CPU reference).

  This driver runs, at the audit height(s):

  (1) the FLGPU path:  day038.tail_with_budget(T, t, nthreads=8) --
      the exact fleet code path (2^24 slabs, 8 threads, iGPU);
  (2) the CPU reference:  day037.tail_with_budget (verified engine);
  (3) PER-SLAB capture:  the same sequential 2^24-slab walk, each
      slab read ONCE from the verified band files and evaluated by
      BOTH cores -- day038.slab_budget (numpy f64, the day034
      verbatim arithmetic) and day038.slab_budget_gpu (cupy f64) --
      so the per-slab values are directly comparable with no reader
      or I/O confound;  per-slab CPU and GPU sums are written as
      they go (interrupt-safe CSV),  with the cumulative CPU and
      GPU drift profiles.

  The margin is then recomputed at dps-60 from the GPU totals and
  from the CPU totals:  if the GPU totals reproduce the ledger's
  ~1 - 4e-9 and the CPU totals reproduce 0.502658, the unit-level
  K difference is confirmed to live inside the tail, and the CSV
  tells us which slab(s) carry it.

  READ-ONLY over the band files.  One GPU thread pool at a time.
"""
import csv
import json
import math
import os
import sys
import time

R_H = "/home/jsmille/Projects/rh-missing-tail"
sys.path.insert(0, R_H + "/scripts/rh")
import numpy as np                      # noqa: E402
from mpmath import mp                   # noqa: E402
import day038_h1_3e10_gpu as D38        # noqa: E402  (the GPU engine)
import day037_h1_3e10 as D37            # noqa: E402  (the CPU reference)

HERE = os.path.dirname(os.path.abspath(__file__))

AUDIT_T = {
    "p01": (3490744648.3185544014, 10609961701),   # t, ledger nlt
}
# p00 (3234812862.415509005) added after p01 completes.


def margin_at(t, g, re, im, nlt):
    """the margin at dps-60 from a (re, im) tail pair (V4 formula)."""
    mp.dps = 60
    s = mp.mpc(0.5, mp.mpf(repr(t)))
    lm = D37.logmain25212(s)
    _r30, _e30, qrem, qext, _b1, _b2, _a = D37.quad_pair(
        _T, t)
    (la, ar, _bla, _bar, _dmg) = D37.prod_with_budget(t)
    Kfull = mp.e ** (lm + mp.mpf(repr(float(la)))
                     + 1j * mp.mpf(repr(float(ar)))
                     + mp.mpf(repr(re)) + 1j * mp.mpf(repr(im))
                     + qrem + qext)
    z = mp.zeta(s)
    dev = D37.dev_parts(t, g, 60)
    pb = mp.mpf(repr(float(D37.M.p8_B(mp.mpf(repr(t)), D37.n4(t)))))
    residf = abs(z - Kfull)
    return (float(abs(z) * float(dev) / (float(pb) + float(residf))),
            float(abs(Kfull)),
            (float(mp.arg(Kfull / z)) % (2 * math.pi)),
            float(residf))


_T = None
def one_height(tag, t):
    global _T
    t0 = time.time()
    outd = os.path.join(HERE, "out_day049c_%s" % tag)
    os.makedirs(outd, exist_ok=True)
    csvp = os.path.join(outd, "slabs_%s.csv" % tag)
    T = D38.Tail3E10(verbose=False)
    _T = T
    print("[%s] GPU tail (fleet path, 8 threads) ..." % tag, flush=True)
    re_g, im_g, nlt_g, Brg, Big, dming = D38.tail_with_budget(
        T, t, nthreads=8)
    print("[%s] gpu totals re=%.17g im=%.17g nlt=%d" %
          (tag, re_g, im_g, nlt_g), flush=True)
    print("[%s] CPU engine tail (day037, verified) ..." % tag,
          flush=True)
    T37 = D37.Tail3E10(verbose=False)
    re_c, im_c, nlt_c, Brc, Bic, dminc = D37.tail_with_budget(T37, t)
    print("[%s] cpu totals re=%.17g im=%.17g nlt=%d" %
          (tag, re_c, im_c, nlt_c), flush=True)

    # anchor zero for the margin:  the pre-issued g_x of the audit
    # point (day048 re-issue;  k<0 zero just above t);  fallback to
    # the first band zero above t (marked as a surrogate).
    ax = AUDIT_T[tag]
    g_x = AX.get(tag, None)
    if g_x is None:
        idx = nlt_g
        c = T.read_slab_at(min(idx, max(0, T.n_tail - 1)), 1)
        g_x = float(c[0]) if c.size else t + 1.0
        print("[%s] WARNING:  no pre-issued g_x;  surrogate %.17g"
              % (tag, g_x), flush=True)

    m_g, k_g, ph_g, res_g = margin_at(t, g_x, re_g, im_g, nlt_g)
    m_c, k_c, ph_c, res_c = margin_at(t, g_x, re_c, im_c, nlt_c)
    with open(os.path.join(outd, "totals_%s.json" % tag), "w") as fh:
        json.dump({
            "t": t, "g_x": g_x,
            "gpu": {"re": re_g, "im": im_g, "nlt": nlt_g,
                    "margin": m_g, "absK": k_g, "phase": ph_g,
                    "residf": res_g},
            "cpu": {"re": re_c, "im": im_c, "nlt": nlt_c,
                    "margin": m_c, "absK": k_c, "phase": ph_c,
                    "residf": res_c},
            "compare": {"V1_engine_f64": 0.502658531913,
                        "V2_80bit_ld": 0.502658103672,
                        "ledger_gpu_fleet": 0.9999999965 if tag == "p01"
                        else None},
            "wall_min_at_totals": (time.time() - t0) / 60.0,
        }, fh, indent=1)
    print("[%s] MARGIN gpu=%s  cpu=%s   (ledger=1.000e+00-ish,  "
          "V1=0.5026585)" % (tag, format(m_g, ".12f"),
                             format(m_c, ".12f")), flush=True)

    # ---- per-slab capture -------------------------------------
    sub = D38.SUB // 2                 # 2^24  (fleet threaded size)
    n = T.n_tail
    nsl = (n + sub - 1) // sub
    t2 = t * t
    extra = getattr(T, "extra_idx", None)
    w = csv.writer(open(csvp, "a"))
    w.writerow(["slab", "i0", "m", "re_cpu", "re_gpu",
                "im_cpu", "im_gpu", "bre_cpu", "bre_gpu",
                "bim_cpu", "bim_gpu", "cum_re_cpu", "cum_re_gpu",
                "cum_im_cpu", "cum_im_gpu"])
    rc = rg = ic = ig = np.longdouble(0)
    i = 0
    while i < n:
        m = min(sub, n - i)
        c = T.read_slab_at(i, m)
        src, sic, br_c, bi_c, _sar, _dm = D38.slab_budget(
            c, t, t2, m, i, extra, free_pool=True)
        srg, sig, br_g, bi_g, _sar, _dm = D38.slab_budget_gpu(
            c, t, t2, m, i, extra, free_pool=True)
        rc += np.longdouble(src)
        rg += np.longdouble(srg)
        ic += np.longdouble(sic)
        ig += np.longdouble(sig)
        w.writerow([i // sub, i, m,
                    "%.17g" % src, "%.17g" % srg,
                    "%.17g" % sic, "%.17g" % sig,
                    "%.6e" % br_c, "%.6e" % br_g,
                    "%.6e" % bi_c, "%.6e" % bi_g,
                    "%.17g" % rc, "%.17g" % rg,
                    "%.17g" % ic, "%.17g" % ig])
        w.flush()
        del c
        i += m
    w.close()
    # walk totals vs engine totals (reader/walk sanity)
    with open(os.path.join(outd, "walkcheck_%s.json" % tag), "w") as fh:
        json.dump({
            "walk_re_cpu": float(rc), "walk_im_cpu": float(ic),
            "walk_re_gpu": float(rg), "walk_im_gpu": float(ig),
            "engine_re_cpu": re_c, "engine_im_cpu": im_c,
            "engine_re_gpu_threaded": re_g, "engine_im_gpu_threaded":
                im_g,
            "nslabs": nsl,
        }, fh, indent=1)

    # === fleet-row replication: the fleet's OWN cert_point, plus the
    # component stack compared against the day049a pi-probe values.
    print("[%s] cert_point (fleet function verbatim, 8 threads) ..."
          % tag, flush=True)
    t1 = time.time()
    pc = D38.cert_point(T, t, g_x, audit=True, nthreads=8)
    mp.dps = 30
    s30 = mp.mpc(0.5, mp.mpf(repr(float(t))))
    lm30 = D38.logmain25212(s30)
    la30, ar30 = D38.prod_with_budget(t)[0], D38.prod_with_budget(t)[1]
    q30 = D38.quad_pair(T, t, False)
    comp = {"lm30": str(lm30), "la": repr(la30), "ar": repr(ar30),
            "qrem30": str(q30[0]), "qext30": str(q30[1])}
    pi_probe_ref = {  # day049a pi-probe (dps-invariant 30/45/90/120)
        "lm": "(2741624396.408, -33479200054.330)",
        "la": "286605200.676542", "ar": "14219278.525265",
        "re": "-1519600917.8097972869873047 (80-bit ld)  /
  -1519600917.809799 (engine f64)",
        "im": "33332178583.221424 (+ nlt*pi, engine convention)",
        "Kfull": "1.2937556 @ 4.1815 rad (all dps)",
        "margin": "0.502658",
    }
    pc_out = dict(pc)
    for (k, v) in pc_out.items():
        if isinstance(v, (mp.mpf, mp.mpc)):
            pc_out[k] = str(v)
    pc_out["components"] = comp
    pc_out["pi_probe_reference"] = pi_probe_ref
    pc_out["wall_min_at_certpoint"] = (time.time() - t1) / 60.0
    with open(os.path.join(outd, "certpoint_%s.json" % tag), "w") as fh:
        json.dump(pc_out, fh, indent=1)
    print("[%s] LEDGER-REPLICA row:  mnew=%s  mcert=%s  residf=%s"
          % (tag, format(pc["mnew"], ".10f"), format(pc["mcert"],
                                                    ".10f"),
             format(pc["residf"], ".10f")), flush=True)
    print("[%s]   zeta=%s  dev=%s  Efull=%s  nlt=%s"
          % (tag, format(pc["zeta"], ".10f"), format(pc["dev"],
                                                     ".12f"),
             format(pc["Efull"], ".6g"), pc["nlt"]), flush=True)
    print("[%s]   components:  lm30=%s" % (tag, comp["lm30"]), flush=True)
    print("[%s]               la=%s  ar=%s  qrem30=%s" %
          (tag, comp["la"], comp["ar"], comp["qrem30"]), flush=True)
    print("[%s] done.  wall = %.1f min" % (tag, (time.time() - t0) / 60.0),
          flush=True)


# pre-issued anchor zero for the audit points (day048 re-issue)
AX = {"p01": 3490744654.3185544014}


def main():
    tags = sys.argv[1:] if len(sys.argv) > 1 else list(AUDIT_T)
    for tag in tags:
        one_height(tag, AUDIT_T[tag][0])


if __name__ == "__main__":
    main()
