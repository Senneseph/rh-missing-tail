#!/usr/bin/env python3
"""day049a -- the PI probe: which dps-30 component carries the ~pi
phase shift of Kfull at the day048 worst points?

Method:  at the p01 point (x=3490744654.3e0 / t=3490744648.3185544014,
g=3490744654.3185544014) compute the fast_core components at dps-30 and
dps-120, and build Kfull both ways with the SAME tail re/im (the
day048 80-bit-exact stream values from the p01 .res file, so the f64
sum is not a factor).  Compare every component's REAL and PHASE
between the two precisions and report the phase difference mod 2pi.

The day048 finding to explain:
  ledger  (dps-30 run)  residf = 1.3075849021  (~ |z|,  K30 ~ +z side)
  reissue (dps-90/120)  residf = 2.60134       (~ |z|+|K|,  K120 ~ -z)
  |K| ~ 1.29 at both precisions  ->  an ~168-degree phase flip, not a
  magnitude change.  Exactly one component must carry ~pi of phase.

Compute:  single stream, 1 core, dps-45 cross for each component as a
sanity that the 30-vs-120 difference is a dps-30 artifact (if the
30->45 and 45->120 steps are comparable, the 30 level is simply
under-resolved;  if 30->45 carries the whole jump, it is a dps-30
branch/cancellation defect in that component).
"""
import json
import math
import sys

R_H = "/home/jsmille/Projects/rh-missing-tail"
sys.path.insert(0, R_H + "/scripts/rh")
import day037_h1_3e10 as D37          # noqa: E402  (verbatim engine math)
from mpmath import mp                # noqa: E402

TF = 3490744648.3185544014
GX = 3490744654.3185544014

with open(
        R_H + "/scripts/rh/out_day048_pts/pt01_k-12_x3490744654.295046.res"
) as fh:
    RES = json.load(fh)
LD = RES["stream"]["ld"]
RE_TAIL = mp.mpf(LD["re"])
IM_TAIL = mp.mpf(LD["im"])
NLT_TAIL = int(LD["nlt"])
IM_TAIL = IM_TAIL + mp.mpf(repr(NLT_TAIL * math.pi))


_T = None


def get_T():
    global _T
    if _T is None:
        _T = D37.Tail3E10(verbose=False)
    return _T


core_G_LAST = None


def core(dps):
    global core_G_LAST
    mp.dps = dps
    if core_G_LAST is None:
        core_G_LAST = repr(get_T().G_LAST)
    t = mp.mpf(repr(TF))
    s = mp.mpc(0.5, t)
    z = mp.zeta(s)
    lm = D37.logmain25212(s)
    qrem = D37.quad_section(D37._kint(s), core_G_LAST, D37.REMHI, 400, dps)
    qext = D37.quad_section(D37._kint(s), D37.REMHI, D37.REMHI2, 400, dps)
    dev = D37.dev_parts(TF, GX, dps)
    (la, ar, _bla, _bar, _dmg) = D37.prod_with_budget(TF)
    return {"dps": dps, "z": z, "lm": lm, "la": la, "ar": ar,
            "qrem": qrem, "qext": qext, "dev": float(dev)}


def kfull(c):
    mp.dps = c["dps"]
    K = mp.e ** (c["lm"] + c["la"] + 1j * c["ar"] + RE_TAIL + 1j * IM_TAIL)
    K = K * mp.e ** c["qrem"]
    K = K * mp.e ** c["qext"]
    return K


def ph(x):
    """phase of an mpmath complex/real number in [0, 2pi)."""
    mp.dps = max(30, int(mp.dps))
    if abs(mp.im(x)) < 1e-40 and mp.re(x) > 0:
        return 0.0
    return float(mp.arg(x)) % (2 * math.pi)


def two_pi(a, b):
    d = (a - b + math.pi) % (2 * math.pi) - math.pi
    return d


def main():
    out = []
    for dps in (30, 45, 90, 120):
        out.append(core(dps))
    base = out[0]
    hdr = ("component        dps30                dps45              "
           "         dps90              dps120             ph30-120")
    print(hdr)
    for name in ("lm", "la", "ar", "qrem", "qext"):
        row = "%-14s" % name
        for c in out:
            v = c[name]
            if abs(mp.im(v)) < 1e-40 and mp.re(v) >= 0:
                row += "  re=%.6f           " % float(mp.re(v))
            else:
                row += "  %.3f+i%.3f      " % (float(mp.re(v)),
                                                float(mp.im(v)))
        d3045 = two_pi(ph(base[name]), ph(out[1][name]))
        d4590 = two_pi(ph(out[1][name]), ph(out[2][name]))
        d90120 = two_pi(ph(out[2][name]), ph(out[3][name]))
        d30120 = two_pi(ph(base[name]), ph(out[3][name]))
        row += "  30-45=%+.4f  45-90=%+.4f  90-120=%+.4f  30-120=%+.4f" % (
            d3045, d4590, d90120, d30120)
        print(row)
    # full Kfull, same tail re/im at every precision
    ks = [kfull(c) for c in out]
    print()
    print("Kfull (same 80-bit-exact tail re/im at every dps):")
    for c, K in zip(out, ks):
        z = c["z"]
        residf = abs(z - K)
        print("  dps=%-3d |K|=%.9f  ph(K)=%.4f rad  |z|=%.6f  "
              "residf=%.6f  margin=% .6f"
              % (c["dps"], float(abs(K)), ph(K), float(abs(z)),
                 float(residf),
                 float(abs(z)) * c["dev"]
                 / (float(D37.M.p8_B(mp.mpf(repr(TF)), D37.n4(TF)))
                    + float(residf))))
    print()
    print("phase(K30) - phase(K120)  mod 2pi  =  %+.4f rad"
          % two_pi(ph(ks[0]), ph(ks[3])))
    print("phase(K30) - phase(z)      mod 2pi  =  %+.4f rad  (ledger side)"
          % two_pi(ph(ks[0]), ph(base["z"])))
    print("phase(K120) - phase(z)     mod 2pi  =  %+.4f rad  (reissue side)"
          % two_pi(ph(ks[3]), ph(out[3]["z"])))


if __name__ == "__main__":
    main()
