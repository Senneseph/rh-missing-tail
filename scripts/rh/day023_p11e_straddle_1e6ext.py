# Day-023 — P1.1e extension: candidates 3e5..1e6 on the 31-digit LMFDB list
# (continuation of day023_p11e_straddle_1e7.py, which covered 1e3..2.5e5)
import concurrent.futures as cf
from day023_p11c_1e7 import GN
from day023_p11e_straddle_1e7 import scan_best
import numpy as np

zero_of = lambda x: float(min(GN[max(0, int(np.searchsorted(GN, x))-3):
                                 int(np.searchsorted(GN, x))+4],
                              key=lambda v: abs(v - x)))
cands = [(zero_of(300000.0), "3e5 ext"), (zero_of(500000.0), "5e5 ext"),
         (zero_of(750000.0), "7.5e5 ext"), (zero_of(1000000.0), "1e6 ext")]
print("P1.1e extension: %d candidates" % len(cands), flush=True)
with cf.ProcessPoolExecutor(max_workers=len(cands)) as ex:
    futs = [ex.submit(scan_best, g, lab) for (g, lab) in cands]
    results = [fu.result() for fu in futs]
results.sort(key=lambda r: r["g"])
print("%-10s %9s %10s %9s %8s %8s %9s %8s" % (
    "g", "best_marg", "t_best", "zero_c", "def_c", "resid", "zeta", "E"))
for r in results:
    print("%-10.4f %9.3f %10.4f %9.4f %8.4f %8.4f %9.4f %8.4f" % (
        r["g"], r["best_margin"], r["best_t"], r["zero"], r["def"],
        r["resid"], r["zeta"], r["E"]))
    print("   (worst over window = %.3f at t = %.4f; %s)" % (
        r["worst_margin"], r["worst_t"], r["label"]))
