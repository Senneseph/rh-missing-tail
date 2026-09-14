# Day-023 — re-issue the 18 witness margins with the CORRECTED tail
# (day023_taildiscrete: exact discrete sum over actual zeros (1e7,3e7] +
#  audited density remainder).  Everything else (float64 product, dps-30 main,
#  closed-form dev/B) unchanged from the validated pipeline.
import re
import numpy as np
from mpmath import mp
mp.dps = 30
import day023_taildiscrete as td
from day023_p11c_1e7 import GN, logmain25212, R_closed, B_best, DG

def load():
    td.build_cache()

def witness_margins(pairs, tag):
    print("### re-issued %s" % tag)
    print("%-12s %10s %9s %9s %9s %9s %8s" % (
        "g", "t", "zero_c", "def_c", "resid", "margin", "E"))
    for (g, t) in pairs:
        s = mp.mpc(0.5, mp.mpf(t))
        # float64 vectorized product (validated part of the pipeline)
        t64 = float(mp.mpf(t))
        g2 = GN*GN
        A = g2 + np.float64(0.25)
        Bv = np.float64(1.0)/A
        inner = (g2 - t64*t64)/A
        la = float(np.sum(0.5*Bv + np.log(np.abs(inner)), dtype=np.float64))
        ar = t64*float(np.sum(Bv, dtype=np.float64)) \
             - float(np.pi*int(np.sum(GN < t64)))
        main = logmain25212(s)
        disc, rem, bound = td.tail_discrete(s)
        Kc = disc + rem
        K = mp.e**(main + mp.mpf(la) + mp.mpc(0, mp.mpf(ar))
                   + mp.mpf(Kc.real) + mp.mpc(0, mp.mpf(Kc.imag)))
        z = mp.zeta(s)
        resid = abs(z - K)
        dev = None
        gmp = mp.mpf(repr(float(g)))
        tmm = mp.mpf(t)
        for d in DG:
            v = abs(R_closed(gmp, tmm, d) - 1)
            dev = v if dev is None else min(dev, v)
        B = B_best(tmm)
        margin = abs(z)*dev/(B + resid)
        E = mp.log(abs(z)) - mp.re(mp.log(K))
        print("%-12s %10s %9s %9s %9s %9s %8s" % (
            repr(float(g))[:11], t,
            mp.nstr(abs(z)*dev, 8), mp.nstr(B + resid, 8),
            mp.nstr(resid, 8), mp.nstr(margin, 9), mp.nstr(E, 8)))
    print()

def parse(path, labels=None):
    out = []
    for line in open(path):
        m = re.match(r"^(\S+)\s+([\d.]+)\s+([\d.]+)", line)
        if not m or "best" in line or "g " in line:
            continue
        parts = line.split()
        try:
            g = parts[0]; tbest = parts[2]
            float(g); float(tbest)
        except (ValueError, IndexError):
            continue
        if parts[0] in ("g",):
            continue
        out.append((float(g), tbest))
    return out

if __name__ == "__main__":
    load()
    p1 = parse("/home/jsmille/Projects/rh-missing-tail/scripts/rh/"
               "out_day023_p11e_1e7.txt")
    # keep only the 14 candidate rows (g, t_best): filter by known labels
    p1 = [r for r in p1 if 900 < r[0] < 260000 and len(r[1]) > 4]
    p2 = parse("/home/jsmille/Projects/rh-missing-tail/scripts/rh/"
               "out_day023_p11e_1e6ext.txt")
    p2 = [r for r in p2 if 280000 < r[0] < 1020000]
    # pin witnesses (exact g from list, decimal t as used in the certifies)
    g5e3 = float(GN[int(np.searchsorted(GN, 5000.0))])
    g1e3 = float(GN[int(np.searchsorted(GN, 1000.0))])
    pins = [(g5e3, "5004.7343"), (g1e3, "988.2916")]
    witness_margins(p1, "P1.1e table (1e3..2.5e5), corrected tail")
    witness_margins(p2 + pins, "P1.1e extension (3e5..1e6) + pin witnesses")
