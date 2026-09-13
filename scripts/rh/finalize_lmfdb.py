#!/usr/bin/env python3
"""Finalize LMFDB canonical list: truncate to t<=1e7, write canonical + high-band slice,
full verification battery. Run after convert_shards.py completes."""
import bisect

T_MAX = 1e7
merged = "/tmp/zeta-dl/zeros_merged.tsv"
canon = "/home/jsmille/Projects/rh-missing-tail/scripts/rh/zeros_T10000000_lmfdb.txt"
hi  = "/home/jsmille/Projects/rh-missing-tail/scripts/rh/zeros_hi1e7_band.txt"   # (6e6, 1e7]
L = "/home/jsmille/Projects/kainos-logos/scripts/rh/zeros_T6000000_ext_full.txt"

zs = []
with open(merged) as f:
    for line in f:
        a, b = line.split()
        t = float(b)
        if t <= T_MAX:
            zs.append(t)
        else:
            break
print("count in [14.13, 1e7]:", len(zs))
assert zs[0] == 14.134725141734694, zs[0]

# monotone
bad = sum(1 for i in range(1, len(zs)) if zs[i] <= zs[i-1])
print("non-monotone steps:", bad)

with open(canon, "w") as f:
    for t in zs:
        f.write(f"{t:.15f}\n")
with open(hi, "w") as f:
    k = bisect.bisect_right(zs, 6e6)
    for t in zs[k:]:
        f.write(f"{t:.15f}\n")
    print("(6e6,1e7] slice written:", len(zs)-k)
    print("  first/last:", zs[k], zs[-1])

# min gap + twin pairs full range
mn = min(zs[i]-zs[i-1] for i in range(1, len(zs)))
print("min gap [14,1e7]:", mn)
twin_pairs = [i for i in range(1, len(zs)) if zs[i]-zs[i-1] < 0.02]
print("twin pairs <0.02:", len(twin_pairs), [ (zs[i-1], zs[i]) for i in twin_pairs[:8] ])

# vs our list (count-diff must be exactly the known 4 twins + nothing (6e6,1e7] yet)
ours = [float(l) for l in open(L) if l.strip()]
i = max(j for j, t in enumerate(ours) if t <= 1e7) + 1
ours6 = ours[:i]
# align by index: ours6[k] should match zs[k + miss(k)] ; do a merge-diff with tolerance
merged_diff = 0
j = 0
for k, t in enumerate(zs):
    if j < len(ours6) and abs(t - ours6[j]) < 5e-4:
        j += 1
        continue
    merged_diff += 1
    if merged_diff <= 10:
        near = [o for o in ours6[max(0,j-3):j+3] if abs(t-o) < 5e-3]
        print(f"  extra zero vs our list: #{merged_diff} t={t}  near_ours={near[:3]}")
print("extra zeros vs our 6e6 list (expect 4: the twin pairs):", merged_diff)

# vs Odlyzko zeros6 (2,001,052, 9 digits)
od = [float(l) for l in open("/tmp/zeta-dl/zeros6") if l.strip()]
mx = 0
for k in range(len(od)):
    mx = max(mx, abs(od[k] - zs[k]))
print("max|ours - odlyzko| (first 2001052):", mx)
print("CANONICAL LIST:", canon)
