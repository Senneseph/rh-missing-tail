#!/usr/bin/env python3
"""Day-024 — FAST Platt-format shard decoder (pure-python, float64 target).

Format (per /riemann-zeta-zeros/examples/every_millionth_zero/
platt_zeros.py, Bober — the 24b record, decoder verified BEFORE trust
against the independent 31-digit API list, float-identical at float64):
    file: [Q nblocks]; per block:
    (f64 t0)(f64 t1)(Q Nt0)(Q Nt1) + (Nt1-Nt0) x 13-byte LITTLE-endian
    104-bit per-zero STEPS;  zero #k = t0 + (sum of steps so far) * 2^-101
    (the cumulative Z is an unbounded Python int; each STEP < 2^104).
Block size ~ 2100 rad / ~5e3 zeros (measured: zeros_29846000 = 1000
blocks, block0 = [29846000.000, 29848100.000] x 5139 zeros).

argv:
  day024_platt_fast.py <shard> <out-raw-f64-append>
  day024_platt_fast.py --meta-only <shard>     (header walk, no decode)

Gates per shard (loud, P-0.8):
  - Nt continuity vs the running counter (first-call counter passed via
    stdin line "COUNT n" — used by the supervisor for cross-shard
    Nt0 checks)
  - in-shard per-block: last zero strictly inside (t0, t1) (t1 = the
    interval end / next block's t0, NOT a zero); strict monotone
  - cross-block seam: t0_{k+1} == t1_k within 2e-9
  - header walk consumes the file exactly
summary line:
  SHARD <name> nblocks=<nb> Nt0=<a> Nt1=<b> count=<c> t0=<...>
  t1=<...> mingap=<...> sec=<...>
"""
import struct
import sys
import time

PACK = struct.Struct("<d").pack

E101 = 2.0 ** -101


def metadata_only(path):
    data = open(path, "rb").read()
    (nblk,) = struct.unpack_from("Q", data, 0)
    off = 8
    first = last = None
    for _ in range(nblk):
        t0, t1, Nt0, Nt1 = struct.unpack_from("<ddQQ", data, off)
        off += 32
        if first is None:
            first = (t0, t1, Nt0, Nt1)
        last = (t0, t1, Nt0, Nt1)
        off += 13 * (Nt1 - Nt0)
    assert off == len(data), "header walk != file size"
    return nblk, first, last


def decode(shard, outpath, n_expected_start=None):
    t_start = time.time()
    data = open(shard, "rb").read()
    (nblk,) = struct.unpack_from("Q", data, 0)
    off = 8
    n_tot = 0
    Nt0_first = None
    t0_first = None
    t1_last = None
    mingap = float("inf")
    prev_block_end = None
    f_out = open(outpath, "ab")
    out = bytearray()
    for b in range(nblk):
        t0, t1, Nt0, Nt1 = struct.unpack_from("<ddQQ", data, off)
        off += 32
        cnt = int(Nt1 - Nt0)
        buf = data[off:off + 13 * cnt]
        off += 13 * cnt
        if Nt0_first is None:
            Nt0_first = int(Nt0)
            if n_expected_start is not None:
                assert int(Nt0) == n_expected_start, \
                    "cross-shard Nt0 %d != expected %d" % (
                        int(Nt0), n_expected_start)
        else:
            assert int(Nt0) == Nt0_first + n_tot, \
                "in-shard Nt0 mismatch at block %d" % b
        if t0_first is None:
            t0_first = float(t0)
        if prev_block_end is not None:
            assert abs(t0 - prev_block_end) <= 2e-9, \
                "block seam violated at block %d: %.9f vs %.9f" % (
                    b, t0, prev_block_end)
        Z = 0
        prev_z = None
        for k in range(cnt):
            p = 13 * k
            Z += (buf[p + 12] << 96) | (
                int.from_bytes(buf[p + 8:p + 12], "little") << 64) | \
                int.from_bytes(buf[p:p + 8], "little")
            v = t0 + Z * E101
            if prev_z is None:
                prev_z = v
            else:
                g = v - prev_z
                if g <= 0.0:
                    raise AssertionError(
                        "monotonicity violated at block %d zero %d"
                        % (b, k))
                if g < mingap:
                    mingap = g
                prev_z = v
            out += PACK(v)
        assert prev_z is not None
        # t1 is the interval END (the next block's t0).  A ZERO may
        # still ENCODE to exactly t1 in f64 when its true value lies
        # in (t1 - ulp(t1)/2, t1):  the f64 rounding lands ON the grid
        # point although the true zero is below it.  First observed on
        # shard zeros_4964846000,  block 146 (last zero
        # 4965154700.0 == t1;  the next block's first zero is
        # 4965154700.394309 > t1,  so no seam duplicate;  Nt chain
        # 15399842434 -> 15399849282 consistent).  The N-chain asserts
        # above are the authoritative partition (each true zero counted
        # exactly once);  this invariant guards f64-rounding drift,  so
        # equality at the upper end is allowed.  The lower bound stays
        # strict:  a zero at exactly t0 would be the PREVIOUS block's
        # boundary event under the same convention.
        assert t0 < prev_z <= t1, \
            "block interval violated at block %d: %.9f not in (%.9f, %.9f]" % (
                b, prev_z, t0, t1)
        prev_block_end = t1
        t1_last = t1
        n_tot += cnt
    assert off == len(data), "trailing bytes: header walk != file size"
    f_out.write(bytes(out))
    f_out.close()
    del out
    Nt1_last = Nt0_first + n_tot
    print("SHARD %s nblocks=%d Nt0=%d Nt1=%d count=%d t0=%.6f t1=%.6f "
          "mingap=%.8f sec=%.1f"
          % (shard, nblk, Nt0_first, Nt1_last, n_tot, t0_first,
             t1_last, mingap, time.time() - t_start), flush=True)
    return Nt1_last


if __name__ == "__main__":
    if len(sys.argv) >= 3 and sys.argv[1] == "--meta-only":
        nblk, first, last = metadata_only(sys.argv[2])
        print("META %s nblocks=%d first=(t0=%.6f, t1=%.6f, Nt0=%d, Nt1=%d) "
              "last=(t0=%.6f, t1=%.6f, Nt0=%d, Nt1=%d)"
              % (sys.argv[2], nblk, *first, *last), flush=True)
    else:
        expected = None
        line = sys.stdin.readline().strip()
        if line.startswith("COUNT "):
            expected = int(line.split()[1])
        decode(sys.argv[1], sys.argv[2], expected)
