#!/usr/bin/env python3
"""QUAD-FIX step 1: per-cell complex-vs-real diff over the sweep's 400
cells of (G1, 1e18] at t = 999999994.6157 (dps-30). Locate the cell(s)
where the mpmath complex path stops short of the real path."""
import mpmath as mpm
mpm.mp.dps = 30
import sys; sys.path.insert(0, '.')
import day029_s1gap_hi as H

T = H.TailHi2()
G1 = float(T.old[-1])
t = 999999994.6157

def f_cmplx(gg):
    smp = mpm.mpc(0.5, mpm.mpf(repr(t)))
    r1 = mpm.mpc(0.5, gg); r2 = mpm.mpc(0.5, -gg)
    p = (mpm.log(1 - smp/r1) + mpm.log(1 - smp/r2) + smp/r1 + smp/r2)
    return p * (mpm.log(gg/(2*mpm.pi))/(2*mpm.pi))

k = 400
hi0 = mpm.mpf(repr(G1)); hi1 = mpm.mpf("1e18")
pts = [hi0 * (hi1/hi0)**(mpm.mpf(j)/k) for j in range(k+1)]
rows = []
for j in range(k):
    c = float(mpm.re(mpm.quad(f_cmplx, [pts[j], pts[j+1]])))
    r = float(mpm.quad(lambda gg, J=j: mpm.re(f_cmplx(gg)), [pts[j], pts[j+1]]))
    rows.append((abs(c - r), j, c, r))
rows.sort(reverse=True)
print("top-10 cells by |complex - real|:", flush=True)
for d, j, c, r in rows[:10]:
    gmid = float(pts[j])
    print(f"  cell {j:3d}  |d|={d:.6f}  cmplx={c:.6f}  real={r:.6f}  g~{gmid:.3g}", flush=True)
tot_c = sum(x[2] for x in rows); tot_r = sum(x[3] for x in rows)
print(f"totals: cmplx={tot_c:.6f}  real={tot_r:.6f}  diff={tot_c-tot_r:.6f}", flush=True)
# verbose traces for the two worst cells (complex path stopping degree)
for d, j, c, r in rows[:2]:
    print(f"=== verbose complex trace, cell {j} ===", flush=True)
    mpm.quad(f_cmplx, [pts[j], pts[j+1]], verbose=True)
