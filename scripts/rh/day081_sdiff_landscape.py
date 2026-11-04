#!/usr/bin/env python3
"""day081  0278 datum: the EMPIRICAL S-difference landscape on the known
side, [1e9, 3e9) (2e9 units, ~6.2e9 on-line zeros streamed from the
in-repo data).

The 0276 gate (cGate = 2.5821 at sigma_A, decaying in t) is a SUP-level
input on the per-piece S-difference.  Before 0278 (the mechanism)
designs a theorem, measure what the S-difference actually does on the
known data: the per-unit (t, t+1] on-line zero count distribution and
the 2-unit (t-1, t+1] window count max in [1e9, 3e9).  The classical
S-oscillation unit difference S(t+1)-S(t) (the (1/pi)arg form) drops by
1 per zero crossing, so the count distribution IS the empirical
S-oscillation-diff landscape (vs the gate 2.58 and the certified window
law: HSXW two-unit <= 22; R-vM mean = ln(t/2pi)/(2pi) ~ 3.1 at 2e9).

Single streaming pass, O(1) extra memory (2^22 chunks, no full-file
loads).  No RH claim. Pure empirical datum (0278 input).
"""
import os, sys, time
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
os.chdir(os.path.dirname(os.path.abspath(__file__)))
import numpy as np
import day069_xiproduct_excl_probe as D69

TLO, THI = 1_000_000_000, 3_000_000_000
t0 = time.time()
hist = np.zeros(16, dtype=np.int64)   # distinct units that have k zeros (k=15: k>=15)
distinct_units = 0
pairmax = 0
n_in = 0
prev_unit = -10
prev_cnt = 0
nch = 1 << 22

def _proc(a):
    global pairmax, n_in, prev_unit, prev_cnt, distinct_units
    a = a[(a >= TLO) & (a < THI)]
    if not a.size:
        return
    n_in += a.size
    idx, c = np.unique(a.astype(np.int64) - TLO, return_counts=True)
    for j, cc in zip(idx, c):
        if prev_unit >= 0 and j == prev_unit + 1:
            pairmax = max(pairmax, prev_cnt + int(cc))
        distinct_units += 1
        hist[min(int(cc), 15)] += 1
        prev_unit, prev_cnt = int(j), int(cc)

for kind, name in D69.COVERAGE:
    if kind == 'txt':
        _proc(np.loadtxt(name))
    elif kind == 'f64r':
        sz = os.path.getsize(name)
        nn = sz // 8
        for off in range(0, nn, nch):
            a = np.fromfile(name, dtype="<f8", offset=8 * off,
                            count=min(nch, nn - off))
            _proc(a)
            del a
    else:
        _proc(D69.load_lshard(name))
    print(f"  file {name.split('/')[-1]:40s} n_in={n_in} "
          f"({int(time.time()-t0)}s)", flush=True)

NU = THI - TLO
zero_units = NU - distinct_units
print()
print(f"known on-line zeros in [1e9, 3e9): {n_in}  over {NU} units "
      f"= {n_in/NU:.4f}/unit  (R-vM mean at 2e9: "
      f"{float(np.log(2e9/(2*np.pi))/(2*np.pi)):.4f}/unit)")
print()
print("PER-UNIT COUNT DISTRIBUTION (units with exactly k on-line zeros):")
for k in range(12):
    if k == 0:
        v = zero_units
    else:
        v = int(hist[k])
    bar = "#" * int(v / 4e7)
    print(f"  k={k:2d}:  {v:15d} units  {100*v/NU:5.2f}%  {bar}")
print(f"  k>=15: {int(hist[15]):15d} units")
print()
print(f"consecutive-unit PAIR max (count[t]+count[t+1], the 2-unit "
      f"(t-1,t+1] window count): {pairmax}")
print(f"  vs 0276 gate cGate(tPT2) = 2.5821 (per piece; the 2-unit "
      f"window reading is the binding piece)")
print(f"  vs HSXW certified two-unit upper 22 (0275): {pairmax} <= 22: "
      f"{'ok' if pairmax <= 22 else 'CHECK'}")
print("No RH claim.")
