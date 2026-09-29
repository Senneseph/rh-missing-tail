#!/usr/bin/env python3
"""day049b2 -- V4 parent-only finisher.  Worker 0's far pass is
done (wsums_w0.jsonl,  md5-bounded window sums,  exact 80-bit
transfer);  this does the dps-60 accumulation,  the dps-60
near-region direct sum,  and the final margin.  No far re-read."""
import json
import math
import os
import sys
import time

R_H = "/home/jsmille/Projects/rh-missing-tail"
sys.path.insert(0, R_H + "/scripts/rh")
from mpmath import mp                   # noqa: E402
import day037_h1_3e10 as D37            # noqa: E402
import day049b_v4_recompute as V4       # noqa: E402  (near_sum only)

HERE = os.path.dirname(os.path.abspath(__file__))
OUT = HERE + "/out_day049b"

TF = V4.TF
GX = V4.GX
NLT = 10609961701


def main():
    mp.dps = 60
    t0 = time.time()
    re_re = mp.mpf(0)
    im_re = mp.mpf(0)
    nwin = 0
    for w in (0, 1, 2, 3):
        p = os.path.join(OUT, "wsums_w%d.jsonl" % w)
        if not os.path.exists(p):
            continue
        with open(p) as fh:
            for ln in fh:
                f_ = ln.split()
                if f_[0] == "SAMPLE" or len(f_) < 4:
                    continue
                re_re += mp.mpf(f_[1])
                im_re += mp.mpf(f_[2])
                nwin += 1
    print("V4b  far windows accumulated: %d" % nwin, flush=True)

    nw = json.load(open(os.path.join(OUT, "nearwin.json")))
    na, nb = nw["na"], nw["nb"]
    print("V4b  near sum over %d zeros (dps-60 direct) ..."
          % (nb - na), flush=True)
    re_near, im_near = V4.near_sum(TF, na, nb, V4.F_D)
    print("V4b  near re = %s  im = %s"
          % (mp.nstr(re_near, 15), mp.nstr(im_near, 15)), flush=True)

    re_tot = re_re + re_near
    im_tot = im_re + im_near + mp.mpf(NLT) * mp.pi
    print("V4b  tail re = %s" % mp.nstr(re_tot, 30), flush=True)
    print("V4b  tail im = %s" % mp.nstr(im_tot, 30), flush=True)
    print("V4b  (engine f64 totals:  re=-1519600917.809799  im="
          "33332178583.221424  [incl. nlt*f64pi])", flush=True)

    s = mp.mpc(0.5, mp.mpf(repr(TF)))
    _r30, _e30, qrem, qext, _b1, _b2, _aud = D37.quad_pair(V4.T37ref,
                                                            TF)
    (la, ar, _bla, _bar, _dmg) = D37.prod_with_budget(TF)
    Kfull = mp.e ** (V4.lm60(s) + mp.mpf(repr(float(la)))
                     + 1j * mp.mpf(repr(float(ar)))
                     + re_tot + 1j * im_tot)
    Kfull = Kfull * mp.e ** qrem
    Kfull = Kfull * mp.e ** qext
    z = mp.zeta(s)
    dev = D37.dev_parts(TF, GX, 60)
    pb = mp.mpf(repr(float(D37.M.p8_B(mp.mpf(repr(TF)), D37.n4(TF)))))
    residf = abs(z - Kfull)
    mnew = float(abs(z) * float(dev) / (float(pb) + float(residf)))
    ph = (float(mp.arg(Kfull / z)) % (2 * math.pi))
    if ph > math.pi:
        ph -= 2 * math.pi
    out = {
        "margin_V4": mnew, "absz": float(abs(z)),
        "absK": float(abs(Kfull)), "phase_K_minus_z_rad": ph,
        "residf": float(residf), "dev": float(dev), "pb": float(pb),
        "tail_re": float(re_tot), "tail_im": float(im_tot),
        "nlt": NLT, "windows": nwin, "near_zeros": nb - na,
        "elapsed_min": (time.time() - t0) / 60.0,
        "compare": {"V1_engine_f64": 0.502658531913,
                    "V2_80bit_ld": 0.502658103672,
                    "ledger_gpu_fleet_mnew": 0.9999999965},
    }
    with open(os.path.join(OUT, "RESULT_V4.json"), "w") as fh:
        json.dump(out, fh, indent=1)
    print("V4b  |z|=%.12f  |K|=%.12f  phase(K)-phase(z)=%+.6f rad"
          % (out["absz"], out["absK"], ph), flush=True)
    print("V4b  residf=%.12f  dev=%.12f  pb=%.3e"
          % (out["residf"], out["dev"], out["pb"]), flush=True)
    print("V4b  MARGIN_V4 = %.12f" % mnew, flush=True)
    print("V4b  compare  V1=0.502658531913  V2=0.502658103672  "
          "ledger_mnew=0.9999999965", flush=True)
    print("V4b  wall = %.1f min" % out["elapsed_min"], flush=True)


V4.lm60 = D37.logmain25212      # alias (dps-60 in context at call)
import day037_h1_3e10 as _D37   # noqa: E402
_T37 = None
class _T37Holder:
    pass
def _lazy_T():
    global _T37
    if _T37 is None:
        _T37 = D37.Tail3E10(verbose=False)
    return _T37
V4.T37ref = property(lambda self: None)  # placeholder, replaced below

if __name__ == "__main__":
    mp.dps = 60
    _T37 = _lazy_T()
    V4.T37ref = _T37
    main()
