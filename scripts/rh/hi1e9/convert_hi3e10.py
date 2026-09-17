#!/usr/bin/env python3
"""Convert the 476 hi3e10 .dat shards (N in [1.002e9, 2e9)) to a raw LE
float64 band file, same precision class as the existing hi1e9 band.

.dat format (LMFDB/Platt, per convert_shards.py): [8B nblk] then per
block: [t0,f64][t1,f64][Nt0,u64][Nt1,u64] then (Nt1-Nt0) records of
13 bytes = one 104-bit little-endian integer Z_k; the zero values are
DELTA-ENCODED: within a block, v_k = t0 + (sum_{j<=k} Z_j) * 2^(-101).
"""
import struct
import numpy as np
import sys

SRC = "/tmp/zeta-dl/hi3e10/shards"
NS = [int(x) for x in open("/tmp/zeta-dl/hi3e10/shard_Ns_2e9.txt")]
OUT = sys.argv[1] if len(sys.argv) > 1 else \
    "/home/jsmille/Projects/rh-missing-tail/scripts/rh/hi1e9/" \
    "zeros_1002e6_to_2000e6.f64"

NS.sort()
total = 0
nt0_first = None
nt1_last = None
f = open(OUT, "wb")
import time
t_start = time.time()
for k, N in enumerate(NS):
    data = open(f"{SRC}/zeros_{N}.dat", "rb").read()
    nblk = struct.unpack_from("Q", data, 0)[0]
    off = 8
    for _ in range(nblk):
        t0, t1, Nt0, Nt1 = struct.unpack_from("<ddQQ", data, off)
        off += 32
        cnt = int(Nt1 - Nt0)
        b = np.frombuffer(data, dtype=np.uint8, offset=off,
                          count=13*cnt).reshape(cnt, 13)
        off += 13*cnt
        b = np.ascontiguousarray(b)
        u64 = np.zeros(cnt, dtype=np.uint64)
        for i in range(8):
            u64 |= b[:, i].astype(np.uint64) << np.uint64(8*i)
        u32 = np.zeros(cnt, dtype=np.uint32)
        for i in range(4):
            u32 |= b[:, 8+i].astype(np.uint32) << np.uint32(8*i)
        delta = (u64.astype(np.float64) * (2.0**(-101))
                 + u32.astype(np.float64) * (2.0**(-37))
                 + b[:, 12].astype(np.float64) * (2.0**(-5)))
        v = t0 + np.cumsum(delta)
        if nt0_first is None:
            nt0_first = int(Nt0)
        nt1_last = int(Nt1)
        f.write(v.astype("<f8").tobytes())
        total += cnt
    if (k + 1) % 50 == 0:
        print(f"{k+1}/{len(NS)} shards, total {total}, "
              f"{time.time()-t_start:.0f}s", flush=True)
f.close()
print(f"TOTAL {total} zeros in {time.time()-t_start:.0f}s")
print(f"Nt bookkeeping: first block Nt0 = {nt0_first}, "
      f"last block Nt1 = {nt1_last}, span = {nt1_last-nt0_first}")
