import os, sys, time
import numpy as np
os.chdir("/home/jsmille/Projects/rh-missing-tail/scripts/rh")
sys.path.insert(0, ".")
import day069_xiproduct_excl_probe as D
T, SR, A = 1e9, 0.1252270103, 0.3747729897
CH = 1 << 20
firsts = []
for (k, n) in D.COVERAGE:
    if k == "txt": firsts.append(float(np.loadtxt(n)[:1][0]))
    elif k == "f64r": firsts.append(float(np.fromfile(n, dtype="<f8", count=1)[0]))
    else: firsts.append(float(D.load_lshard(n)[0]))
S_tot, n_tot = 0.0, 0
rng = np.random.default_rng(3)
print("per-file S (SAFE chunking) + 100k sample mean f (sanity):")
for idx, (k, n) in enumerate(D.COVERAGE):
    lo, hi = firsts[idx], firsts[idx+1] if idx+1 < len(D.COVERAGE) else 3.002e9
    if k == "txt": arr = np.loadtxt(n)
    elif k == "f64r": arr = np.fromfile(n, dtype="<f8")
    else: arr = D.load_lshard(n)
    arr = arr[(arr >= lo) & (arr < hi)]
    tot = np.float64(0.0)
    for i0 in range(0, arr.size, CH):
        c = arr[i0:min(i0+CH, arr.size)]
        tot += np.sum(D.fpair_chunk(c, SR, T, A), dtype=np.float64)
    smp = arr[rng.integers(0, arr.size, min(100000, arr.size))]
    mf = float(np.mean(D.fpair_chunk(smp, SR, T, A)))
    S_tot += float(tot); n_tot += arr.size
    print("  %-42s n=%12d S= %+.9e  sampleE[f]= %+.6f (sum/n= %+.6f)" %
          (n, arr.size, float(tot), mf, float(tot)/arr.size), flush=True)
print("TOTAL n=%d S= %+.12e  (%.0fs)" % (n_tot, S_tot, 0))
