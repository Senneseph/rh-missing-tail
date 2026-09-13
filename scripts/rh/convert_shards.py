#!/usr/bin/env python3
"""Convert LMFDB/Platt .dat shards (format per official examples/every_millionth_zero/
platt_zeros.py: [Q nblocks][ (d t0)(d t1)(Q Nt0)(Q Nt1) + 13B cumulative 'QIB' deltas]*)."""
import struct
from mpmath import mp

mp.dps = 40
E19 = mp.mpf(1) / (2**101)

FILES = ["zeros_14.dat","zeros_5000.dat","zeros_26000.dat","zeros_236000.dat",
         "zeros_446000.dat","zeros_2546000.dat","zeros_4646000.dat","zeros_6746000.dat",
         "zeros_8846000.dat","zeros_10946000.dat","zeros_13046000.dat","zeros_15146000.dat",
         "zeros_17246000.dat","zeros_19346000.dat","zeros_21446000.dat"]

out = open("/tmp/zeta-dl/zeros_merged.tsv","w")
n = 0
for fn in FILES:
    data = open(f"/tmp/zeta-dl/shards/{fn}","rb").read()
    off = 0
    (nblk,) = struct.unpack_from("Q", data, 0); off = 8
    for _ in range(nblk):
        t0, t1, Nt0, Nt1 = struct.unpack_from("<ddQQ", data, off); off += 32
        cnt = Nt1 - Nt0
        buf = data[off:off+13*cnt]; off += 13*cnt
        Z = 0
        for k in range(cnt):
            b = buf[13*k:13*k+13]
            Z += (b[12]<<96) | (int.from_bytes(b[8:12],"little")<<64) | int.from_bytes(b[0:8],"little")
            n += 1
            v = mp.mpf(t0) + mp.mpf(Z)*E19
            out.write(f"{n}\t{mp.nstr(v,20)}\n")
    print(f"{fn}: done, cumulative {n}", flush=True)
out.close()
print("TOTAL ZEROS:", n)
