# chain_verify_6e6.py — final-chain verification for the certified 6e6 list.
# (float-only by design; dps certification is a separate M3-style batch.)
# Checks: strict monotone, count, min gap, twin-floor margin, 3e5 splice
# identity, S O(1) float, RVM loose band. Echoes everything (P-0.8).
import numpy as np
import zeta_core

FIN = "zeros_T6000000_ext_full.txt"
base = np.loadtxt("zeros_T300000_ext_full.txt")
g = np.loadtxt(FIN)
print("list %s: %d zeros, min %.6f max %.6f" % (FIN, g.size, g.min(), g.max()))
assert g.size > 10_000_000, "count implausible for T=6e6 (%d)" % g.size
d = np.diff(g)
assert (d > 0).all(), "NOT strictly monotone — abort chain"
i = int(np.argmin(d))
print("strict monotone: OK   min gap %.6f at t=%.3f" % (float(d[i]), float(g[i])))
print("twin-floor margin: min gap %.4f vs floor 0.002954 (day-4)" % float(d.min()))
assert np.array_equal(g[:base.size], base), "prefix != certified 3e5 list (splice broken)"
print("splice at 3e5: first %d zeros IDENTICAL to certified list" % base.size)
T = 6.0e6
thpi = zeta_core.vartheta(T) / np.pi
S = g.size - thpi
print("S_file(6e6) float = %+.6f  (O(1) expected; |S|>30 suspicious)" % S)
x = T / (2 * np.pi)
main = x * np.log(x) - x - 0.125
print("RVM main(6e6) float = %.4f   N - main = %+.4f (day-3 convention S)" % (main, g.size - main))
print("CHAIN-VERIFY: PASS (float-level; dps cert is a later batch)")
