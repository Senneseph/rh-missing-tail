#!/usr/bin/env python3
# LOOM-VIS generator (0222): build the single-file side-quest visualizer
#   sq/LOOM-VIS.html  (self-contained: data embedded, no deps, no network)
#
# Windows: the last N=100_000 primes under each X in 1e5/1e6/1e7/1e8
# (at 1e5 the full table). Gaps are int16 big-endian, base64 embedded.
# Per-window stats: mean gap, the BLOOM(24) antipode asymmetry, the 4-adic
# pair bias P(11)/P(01) (0196), the front fraction.
#
# OFF-BOARD; no RH claim; single-threaded; 4 cores open.

import base64, json, math, os, struct, sys, time

ROOT = "/home/jsmille/Projects/rh-missing-tail"
LANES = [1, 5, 7, 11, 13, 17, 19, 23]
NMAX = 100_000
XS = [100_000, 1_000_000, 10_000_000, 100_000_000]

def sieve(n):
    s = bytearray(b"\x01") * (n + 1)
    s[0:2] = b"\x00\x00"
    for i in range(2, int(math.isqrt(n)) + 1):
        if s[i]:
            s[i*i::i] = bytearray(len(range(i*i, n + 1, i)))
    return s

def main():
    t0 = time.time()
    sb = sieve(XS[-1])
    primes = [i for i in range(2, XS[-1] + 1) if sb[i]]
    print(f"sieve: {len(primes)} primes to 1e8 in {time.time()-t0:.1f}s")

    scales = []
    for X in XS:
        upto = len(primes)
        while upto and primes[upto - 1] > X:
            upto -= 1
        # window primes strictly ABOVE 2 (the anchor is the boundary, not
        # part of the weave: past 2 all primes are odd, gaps even)
        upto = min(upto, len(primes))
        if primes[0] == 2:
            pass
        base = 1 if primes[0] == 2 else 0
        n = min(NMAX, upto - base)
        win = primes[base + (upto - base - n): upto]
        gaps = [win[i + 1] - win[i] for i in range(len(win) - 1)]
        assert max(gaps) < 65535
        raw = struct.pack(f">{len(gaps)}h", *gaps)
        b64 = base64.b64encode(raw).decode()
        # stats
        f12 = [0.0] * 12
        for g in gaps:
            f12[(g % 24) // 2] += 1.0
        T = sum(f12)
        f12 = [x / T for x in f12]
        asym = sum(abs(f12[c] - f12[(c + 6) % 12]) for c in range(6)) / 6.0
        # 4-adic pair bias (0196): bit_i = (gap_i / 2) mod 2
        bits = [(g // 2) & 1 for g in gaps]
        c11 = sum(1 for i in range(len(bits) - 1) if bits[i] == 1 and bits[i + 1] == 1)
        c01 = sum(1 for i in range(len(bits) - 1) if bits[i] == 0 and bits[i + 1] == 1)
        pair = c11 / max(1, c01)
        front = sum(1 for g in gaps if (g % 24) // 2 < 6) / len(gaps)
        sg = sum(gaps) / len(gaps)
        scales.append({
            "X": X, "p0": win[0], "pL": win[-1], "n": len(gaps),
            "gaps": b64,
            "stats": {"meanGap": round(sg, 4), "bloomAsym": round(asym, 5),
                      "pairBias4": round(pair, 5), "frontFrac": round(front, 5)},
        })
        print(f"  X={X:<9} win={win[0]}..{win[-1]}  n={len(gaps)}  "
              f"meanGap={sg:.3f}  bloomAsym={asym:.5f}  pairBias4={pair:.4f} "
              f"frontFrac={front:.4f}  b64={len(b64)//1024}KB")

    data = json.dumps({"scales": scales}, separators=(",", ":"))
    tpl = open(os.path.join(ROOT, "sq/LOOM-VIS-template.html")).read()
    assert tpl.count("__DATA__") == 1
    out = tpl.replace("__DATA__", data)
    dest = os.path.join(ROOT, "sq/LOOM-VIS.html")
    open(dest, "w").write(out)
    print(f"wrote {dest}  ({os.path.getsize(dest)//1024} KB)  in {time.time()-t0:.1f}s")

if __name__ == "__main__":
    main()
