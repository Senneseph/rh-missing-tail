#!/usr/bin/env python3
# Tile track (0229, part of the Loom+Wheel goal): THE TILED PATTERN THE
# WHEEL POPS OUT.
#
# The 120120 wheel (residues coprime to 30030 = 2*3*5*7*11*13; 23040
# points) is the fixed "future void field" of 0217 (PHASE_A = 1.0000: the
# first survivor after a cut N is a deterministic function of N mod
# 120120).  This script builds that pattern EXACTLY and measures it:
#
#  (1) THE TILE PATTERN: for every cut phase r in Z/120120, f(r) = the
#      first lattice point strictly after r (wrapping the period).
#      c(r) = the lane (mod-24 class, 8 lanes) of f(r);
#      Delta(r) = the tile size (f(r) - r mod 120120, in 1..120119).
#      The pattern = the 120120-step sequence c(0..120119):
#      "what the wheel pops out at every phase."  Structure: lane
#      histogram, run-length spectrum, tile-size spectrum, the mod-24
#      coarse projection (the PHASE_B of 0217).
#  (2) THE AGREEMENT LADDER (how the pattern matches REAL first primes):
#      for real primes p <= X (X = 2e6/1e7/1e8, p >= 1e5):
#        rho_class(X) = P( lane(p_next) == c(p mod 120120) )
#          vs the COARSE control: P( lane(p_next) == c24(p mod 24) )
#            (the 24-frame first survivor, PHASE_B of 0217: 0.5260)
#        vs the independence null (lane-histogram overlap).
#        sig(X) = P( the first survivor f(p) itself is the next prime )
#          (the primality rate of the wheel's prediction)
#        gate ladder at X = 1e7: agreement with the first survivor of the
#          y-gated lattice (y = 29/71/173/541/1223/390390), the 0217 L2C
#          generalization to the class level at scale.
#  (3) THE VISUAL: the pattern as a row of 120120 pixels (1 integer =
#      1 pixel, the parity anchor visible), 8 hues per lane + the
#      tile-size row -> tmp/loom/loom13_tile.png.
#
# OFF-BOARD. No RH claim. 1 core (4 open). Deterministic (no rng).
#
import os
import math
import time
import zlib
import struct
import numpy as np

ROOT = "/home/jsmille/Projects/rh-missing-tail"
OUT = ROOT + "/tmp/loom/loom13_out.txt"
PNOUT = ROOT + "/tmp/loom/loom13_tile.png"
LANES = np.array([1, 5, 7, 11, 13, 17, 19, 23])
PERIOD = 120120             # lcm(24, 30030)
WHEEL30 = 30030             # 2*3*5*7*11*13

def sieve(n):
    s = bytearray(b"\x01") * (n + 1)
    s[0:2] = b"\x00\x00"
    for i in range(2, int(math.isqrt(n)) + 1):
        if s[i]:
            s[i*i::i] = bytearray(len(range(i*i, n + 1, i)))
    return s

def write_png(path, w, h, rgb):
    """minimal PNG writer (rgb: h x w x 3 uint8 bytearray)."""
    def chunk(tag, data):
        c = struct.pack(">I", len(data)) + tag + data
        return c + struct.pack(">I", zlib.crc32(tag + data) & 0xffffffff)
    raw = bytearray()
    for y in range(h):
        raw.append(0)
        raw.extend(rgb[y * w * 3:(y + 1) * w * 3])
    png = (b"\x89PNG\r\n\x1a\n"
           + chunk(b"IHDR", struct.pack(">IIBBBBB", w, h, 8, 2, 0, 0, 0))
           + chunk(b"IDAT", zlib.compress(bytes(raw), 6))
           + chunk(b"IEND", b""))
    with open(path, "wb") as f:
        f.write(png)

def main():
    t0 = time.time()
    out = []
    ofh = open(OUT, "w")
    def rep(s=""):
        print(s); out.append(s); ofh.write(s + "\n"); ofh.flush()

    rep("TILE TRACK (0229): the tiled pattern the wheel pops out")
    rep("(OFF-BOARD; no RH claim; 1 core, 4 open)")

    # ---------------- the 120120 wheel and the first-survivor map -------
    keep = np.ones(PERIOD, dtype=bool)
    keep[0] = False
    for p in (2, 3, 5, 7, 11, 13):
        keep[p::p] = False
    S = np.nonzero(keep)[0]
    nS = len(S)
    rep(f"  wheel: period {PERIOD}, lattice {nS} points "
        f"(expected 23040), density {nS/PERIOD:.6f}")
    assert nS == 23040, nS
    # next lattice point after position r (r in 0..PERIOD-1), wrapping
    # for every r: f(r) = the smallest S element strictly > r (mod P)
    is_in = np.zeros(PERIOD + 1, dtype=bool)
    is_in[S] = True
    # first lattice point strictly after r (python walk: 120120 is fine)
    f = np.empty(PERIOD, dtype=np.int32)
    for r in range(PERIOD):
        pos = int(np.searchsorted(S, r + 1, side="left"))
        if pos < nS:
            f[r] = int(S[pos])
        else:
            f[r] = int(S[0]) + PERIOD
    # tile size and first-survivor lane
    delta = (f - np.arange(PERIOD)) % PERIOD
    delta[delta == 0] = PERIOD
    first_res = f % PERIOD            # the survivor's residue in the period
    lane_of_res = np.full(PERIOD, 8, dtype=np.int8)
    for idx, L in enumerate(LANES):
        lane_of_res[L::24] = idx
    c = lane_of_res[first_res]
    rep(f"  first-survivor map: f(r) built; lane histogram (expect 2880 "
        f"each): {np.bincount(c, minlength=8).tolist()}")
    sz, szc = np.unique(delta, return_counts=True)
    rep("  tile sizes: " + "  ".join(f"{a}:{b}" for a, b in zip(sz, szc)))

    # run-length structure of c
    chg = np.nonzero(np.diff(c.astype(np.int8)))[0]
    runs = np.diff(np.concatenate(([0], chg + 1, [PERIOD])))
    rl, rlc = np.unique(runs, return_counts=True)
    rep(f"  run-lengths of the lane pattern: "
        f"{dict(zip(rl.tolist(), rlc.tolist()))}")
    # max same-lane run (the class-locking check)
    rep(f"  max same-lane run = {runs.max()}")

    # coarse 24-frame projection: the lane index of the first lane after
    # rr (mod 24) -- the 24-frame tile (PHASE_B object of 0217).
    # As a lane index; as a value it is LANES[idx % 8].
    c24 = np.empty(24, dtype=np.int8)        # lane indices
    for rr in range(24):
        pos = int(np.searchsorted(LANES, rr + 1, side="left"))
        c24[rr] = pos if pos < 8 else 0      # wrap: lane 0 of the next period
    # agreement of the fine pattern with its own coarse projection
    # (the 0217 PHASE_A vs PHASE_B split, exact on the pattern itself):
    coarse = c24[np.arange(PERIOD) % 24]
    same_mod = float((coarse == c).mean())
    rep(f"  fine vs coarse first-survivor class agreement (pattern level): "
        f"{same_mod:.4f}  (0217 PHASE_A=1.0000 is an identity; its "
        f"real-data twin below is the 24-frame's rho_24)")

    # ---------------- real data agreement ladder -------------------------
    Xb = 100_000_000
    sarr = sieve(Xb)
    primes = np.array([i for i in range(2, Xb + 1) if sarr[i]],
                      dtype=np.int64)

    rep("")
    rep("AGREEMENT LADDER (real primes p in [1e5, X], next prime p')")
    rep("  rho_class = P(lane(p') == c(p mod 120120)); "
        "rho_24 = P(lane(p') == c24(p mod 24));")
    rep("  sig = P(p' == the wheel's first survivor); "
        "null = independence overlap of lane histograms")
    lane_of = np.full(Xb + 1, 8, dtype=np.int8)
    for idx, L in enumerate(LANES):
        lane_of[L::24] = idx
    for X in (2_000_000, 10_000_000, 100_000_000):
        m = (primes >= 100_000) & (primes <= X)
        ip = np.nonzero(m)[0]
        ok = (ip + 1 < len(primes)) & (primes[np.minimum(ip + 1, len(primes) - 1)] <= X)
        p = primes[ip[ok]]
        ip = ip[ok]
        pnxt = primes[ip + 1]
        ln = lane_of[p]
        ln_next = lane_of[pnxt]
        ctile = c[p % PERIOD]
        c24p = c24[p % 24]
        rho = (ln_next == ctile).mean()
        rho24 = (ln_next == c24p).mean()   # coarse 24-frame, lane-vs-lane
        # independence null: P(rho) if predictions independent of reality
        h_pred = np.bincount(ctile, minlength=8) / len(ctile)
        h_real = np.bincount(ln_next, minlength=8) / len(ln_next)
        null = float((h_pred * h_real).sum())
        # first survivor value = p - (p mod P) + f(r)  (f may wrap)
        fs = p - (p % PERIOD) + f[p % PERIOD]
        sig = float((fs == pnxt).mean())
        rep(f"  X={X:>10,}  n={len(p):>8}  rho_class={rho:.4f}  "
            f"rho_24={rho24:.4f}  null={null:.4f}  sig={sig:.5f}  "
            f"(z_class = {(rho-null)/math.sqrt(rho*(1-rho)/len(p)):+.1f})")

    # gate ladder at 1e7 (0217 L2C generalization, class level)
    Xg = 10_000_000
    mg = (primes >= 100_000) & (primes <= Xg)
    ip = np.nonzero(mg)[0]
    ok = (ip + 1 < len(primes)) & (primes[np.minimum(ip + 1, len(primes) - 1)] <= Xg)
    p = primes[ip[ok]]; ip = ip[ok]
    pnxt = primes[ip + 1]
    ln_next = lane_of[pnxt]
    rep("")
    rep("GATE LADDER at X=1e7 (first survivor of the y-gated lattice):")
    SMALL = [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53,
             59, 61, 67, 71, 73, 79, 83, 89, 97, 101, 103, 107, 109, 113,
             127, 131, 137, 139, 149, 151, 157, 163, 167, 173]
    # first survivor of the y-gated lattice after each prime:
    # vectorized trial division over candidate offsets (for y >= 71 the
    # primorial period is too large to sieve as an array)
    def gate_rho(y, p, ln_next, lane_of):
        ys = [q for q in SMALL if q <= y]
        Pg = 1
        for q in ys:
            Pg *= q
        CAND = 256
        off = np.arange(1, CAND + 1, dtype=np.int64)
        alive = None
        for q in ys:
            for c0 in range(0, len(p), 65536):
                pc = p[c0:c0 + 65536].astype(np.int64)
                cand = (pc[:, None] + off[None, :]) % q
                if alive is None:
                    alive = np.ones((len(p), CAND), dtype=bool)
                alive[c0:c0 + 65536] &= (cand != 0)
        assert float(alive.any(axis=1).mean()) == 1.0,             "survivor within 256 steps everywhere"
        idx = np.argmax(alive, axis=1)
        fs = p + idx + 1
        fs = np.minimum(fs, len(lane_of) - 1)
        rho = float((lane_of[fs] == ln_next).mean())
        return Pg, rho
    for y in (17, 23, 29, 71, 173):
        Pg, rho_g = gate_rho(y, p, ln_next, lane_of)
        rep(f"  y={y:<5} period={Pg:<13,} rho_class={rho_g:.4f}  (n={len(p)})")
    # y = 390390: the 120120 WHEEL itself (coprimality to 30030 is
    # 30030-periodic, so the wheel point right after p uses the r mod 30030
    # copy, not the r mod 120120 copy)
    Pg = WHEEL30
    y3 = 390390
    keep30 = np.ones(Pg, dtype=bool); keep30[0] = False
    for q in (2, 3, 5, 7, 11, 13):
        keep30[q::q] = False
    S30a = np.nonzero(keep30)[0]
    S30 = np.concatenate((S30a, S30a + Pg))
    r30 = (p % Pg).astype(np.int64)
    pos30 = np.searchsorted(S30, r30 + 1, side="left")
    fs30 = p - r30 + S30[pos30]
    fs30 = np.minimum(fs30, Xb)
    rep(f"  y={y3:<5} period={Pg:<13,} (the 120120 WHEEL) "
        f"rho_class={float((lane_of[fs30] == ln_next).mean()):.4f}")

    # ---------------- the visual ----------------------------------------
    hue = np.array([
        [200, 40, 40],    # lane 1
        [235, 190, 60],   # 5
        [60, 175, 80],    # 7
        [60, 120, 200],   # 11
        [200, 130, 40],   # 13
        [160, 60, 190],   # 17
        [240, 240, 120],  # 19
        [60, 200, 200],   # 23
        [120, 120, 120],  # (unused)
    ], dtype=np.uint8)
    img = hue[c]                     # 120120 x 3
    # second row: tile sizes (greyscale, 0..max)
    dmax = delta.max()
    drow = (255 * (delta - 1) / max(1, dmax - 1)).astype(np.uint8)
    drow = np.stack([drow, drow, drow], axis=1)
    # third row: zoom of the first 120120 lanes? keep the full period x 2 rows
    hgt = 2 * PERIOD // 30000 + 2
    # build: row1 = pattern, row2 = tile sizes (both PERIOD wide)
    block = np.concatenate([img, drow], axis=0)
    H, W = block.shape[:2]
    # downscale horizontally to width 1200 for a phone-able PNG
    fac = PERIOD // 400
    small = block[:, ::fac].copy()
    write_png(PNOUT, small.shape[1], small.shape[0],
              small.tobytes() if small.dtype == np.uint8 else small.astype(np.uint8).tobytes())
    rep("")
    rep(f"  visual: {PNOUT}  (row 1 = the lane pattern c(r), "
        f"row 2 = tile sizes Delta(r), 3 px per integer-phase-block)")
    rep("")
    rep(f"== done in {time.time()-t0:.1f}s ==")
    ofh.close()

if __name__ == "__main__":
    main()
