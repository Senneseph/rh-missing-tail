"""s9 diagnostic 4:  independent  (1e7, G]  re-sum  at  t = G + 0.5.
Different  code  path  from  the  stream:  engine  kernel  form
    0.5/(g^2+1/4)  +  log|1 - (t^2+1/4)/(g^2+1/4)|
single-expression  (no  split  logs),  33M-f64  blocks,
np.longdouble  block  sums,  8  threads  (disjoint  slices).
Compare  the  total  against  the  streamed  re  =  128829355880.87236.
"""
import sys

import numpy as np

sys.path.insert(0, ".")
from concurrent.futures import ThreadPoolExecutor

import s9_dk_above_g as S

T = S.G_LAST + 0.5
A = T * T + 0.25
STEP = 1 << 25


def file_sum(mm, n, nsubs=8):
    q = n // nsubs

    def one(i):
        lo = i * q
        hi = (i + 1) * q if i < nsubs - 1 else n
        acc = np.longdouble(0)
        for k in range(lo, hi, STEP):
            g = np.ascontiguousarray(mm[k:min(k + STEP, hi)])
            A34 = g * g + 0.25
            w = 0.5 / A34 + np.log(np.abs(1.0 - A / A34))
            acc += np.sum(w, dtype=np.longdouble)
        return acc

    with ThreadPoolExecutor(max_workers=nsubs) as ex:
        tot = np.longdouble(0)
        for r in ex.map(one, range(nsubs)):
            tot += r
    return tot


def main():
    L = np.ascontiguousarray(S.L_ARR, dtype=np.float64)
    print("L  %d" % L.size, flush=True)
    tot = file_sum(L, L.size, nsubs=4)
    print("  L done:  %+.15e" % tot, flush=True)
    for name, path in (("A", S.A_F), ("B", S.B_F), ("C", S.C_F),
                       ("D", S.D_F)):
        mm = np.memmap(path, dtype=np.float64, mode="r")
        n = int(mm.size)
        print("%s  %d" % (name, n), flush=True)
        tot += file_sum(mm, n, nsubs=8)
        del mm
        print("  cum:  %+.15e" % tot, flush=True)
    streamed = 128829355880.87236
    print()
    print("independent  (1e7, G]  re  =  %+.15e" % tot)
    print("streamed                 =  %+.9f" % streamed)
    print("diff                       =  %+.9e" % (tot - streamed))


if __name__ == "__main__":
    main()
