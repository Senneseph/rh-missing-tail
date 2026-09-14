#!/usr/bin/env python3
"""Day-023 — exact discrete tail at s0=-2 over zeros in (1e7, 3e7] from shards
16-19 (owner's 19-file set) + density-integrated (3e7, inf) remainder.
Arbitrates: pin-implied tail (9.728e-7) vs density integral (9.091e-7).
Per-zero-pair exact real form (s0 = -2):
  re pairlog = log| (1+2/r1)(1+2/r2) | + re(-2)(1/r1+1/r2)
             = log1p(6/A) - 2/A,  A = t^2 + 1/4           (float64-safe)
"""
import struct
import numpy as np
import math
from mpmath import mp

E19 = mp.mpf(1) / (2**101)


def zeros_from_shard(fn):
    d = open(fn, "rb").read()
    (nblk,) = struct.unpack_from("Q", d, 0)
    out = []
    off = 8
    for _ in range(nblk):
        t0, t1, Nt0, Nt1 = struct.unpack_from("<ddQQ", d, off)
        off += 32
        cnt = Nt1 - Nt0
        buf = d[off:off + 13*cnt]
        off += 13*cnt
        Z = 0
        for k in range(cnt):
            b = buf[13*k:13*k+13]
            Z += (b[12] << 96) | (int.from_bytes(b[8:12], "little") << 64) \
                   | int.from_bytes(b[0:8], "little")
            v = t0 + float(mp.mpf(Z) * E19)
            if v > 1.0e7:
                out.append(v)
    return np.array(out)


SHARDS1619 = ["zeros_8846000.dat", "zeros_10946000.dat", "zeros_13046000.dat",
              "zeros_15146000.dat", "zeros_17246000.dat", "zeros_19346000.dat",
              "zeros_21446000.dat", "zeros_23546000.dat", "zeros_25646000.dat",
              "zeros_27746000.dat", "zeros_29846000.dat"]
LO, HI = 1.0e7, 3.0e7
g = np.concatenate([zeros_from_shard(f"/tmp/zeta-dl/shards/{f}")
                    for f in SHARDS1619])
g = g[(g > LO) & (g < HI)]
print("zeros in (1e7, 3e7]:", g.size, "  range", g[0], "..", g[-1])

A = (g.astype(np.longdouble) ** 2 + np.longdouble("0.25"))
term = np.log1p(np.longdouble(6) / A) - np.longdouble(2) / A
S = float(np.sum(term, dtype=np.longdouble))
print("exact sum over (1e7, 3e7]        = %.12e" % S)

# density-integrated remainder (3e7, inf):  int 4 W(g)/g^2 dg
W = lambda B: math.log(B / (2*math.pi)) / (2*math.pi)
rem = 4.0 * (W(HI)/HI + 1.0/(2*HI*HI))
print("density remainder (3e7, inf)     = %.12e" % rem)
print("TOTAL discrete+cutoff tail(-2)   = %.12e" % (S + rem))
print()
print("pin-implied tail (R1 level)      =  9.727689404728e-07")
print("pure density integral (1e7,inf)  =  9.0911e-07")
