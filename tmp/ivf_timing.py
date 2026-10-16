import sys, time
sys.path.insert(0, "/home/jsmille/Projects/rh-missing-tail/scripts/rh")
import s9_dk_above_g as S
t = 2e7 * S.G_LAST
for dps in (int(sys.argv[1]),):
    t0 = time.time()
    v = S.i_far_split(t, dps)
    print("dps=%d  I_far(2e7G)=%+.17e  (%.1f s)" % (dps, v, time.time()-t0), flush=True)
