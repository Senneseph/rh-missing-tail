"""s34k: the rssum-corruption boundary probe.

One FRESH process per (t, dps) per protocol.  t = the f64 integer
30001045999981977600 / 3000104599998197760 ... NO: t = 2.2e18-class
height, chosen as the f64 value of G_LAST*73 (t/G = 73, between the
verified-clean 1.5e18 (a = 4.89e8, dps-40 clean) and the verified-
corrupt 3e18 (a = 6.9e8, dps-40 corrupted): a = sqrt(t/2pi) =
5.92e8.  We compare fresh mpmath dps-15 vs dps-40 at this t and
against the C channel (ZETAC_TEST_T) run separately by the
supervisor.
"""
import json, sys
import mpmath as mp

dps = int(sys.argv[1])
mp.mp.dps = dps
t = 30001045999981977600  # 3e19/10 = 3.00010459999819776e18 = G*100
# we actually want t/G ~ 73: recompute from the engine constant
sys.path.insert(0, "/home/jsmille/Projects/rh-missing-tail/scripts/rh")
import s9_dk_above_g as S
tv = S.G_LAST * 73000000.0  # t/G = 7.3e7 -> t ~ 2.19e18, a ~ 5.9e8
ti = mp.mpf(int(tv.as_integer_ratio()[0]))
t0 = __import__("time").time()
z = mp.zeta(mp.mpf("0.5") + 1j * ti)
out = dict(dps=dps, t=int(ti),
           logabsz=float(mp.log(abs(z))), absz=float(abs(z)),
           time=__import__("time").time() - t0)
print(json.dumps(out))
