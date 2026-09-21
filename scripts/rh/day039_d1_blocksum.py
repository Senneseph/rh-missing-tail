#!/usr/bin/env python3
# day039 - D1: the block-sum cancellation probe (S1-A1-EXPLORATION E5 item D1).
#
# Pre-registered design (docs/S1-A1-EXPLORATION.md, E5):
#   For the ALREADY-verified bands A, B, C (no D needed), stream the zeros and
#   form the signed per-gap increments
#       delta_i = 1 - (nas(t_{i+1}) - nas(t_i)),
#   with the project asymmetry  nas(t) = (t/2pi) log(t/2pi) - t/2pi + 3/4
#   (the exact E2/SUM_EPS statistic,  delta_i = 1 - Delta_asy_i,  so that a
#   block sum  SUM_block delta_i  is the drift increment over the block).
#
#   Partition each band into consecutive blocks of W t-units (the block
#   closes at the first zero beyond block_start + W)  for
#       W in {1e2, 1e3, 1e4, 1e5}.
#   For each (band, W):  max |S|,  mean |S_block|,  against the LINEAR
#   baseline  mean|delta| * gaps_per_block  (the E2 absolute-sum growth).
#
#   Reading:
#     mean |S_block|  ~  linear in W   (ratio to baseline ~ const,  alpha ~ 1)
#         => the E2 barrier (no signed compensation) holds at every scale;
#            the absolute-sum route is dead,  A2 record = end of mechanism.
#     mean |S_block|  sub-linear in W  (sqrt, or bounded;  alpha < 1)
#         => signed compensation IS visible in the data at block scale;
#            a signed-sum theorem is worth pursuing (the data says the
#            mechanism to look for).
#
# Bounded job:  1 thread,  streaming,  ~256MB working set.  Read-only on the
# A/B/C bands.  Run alongside the D re-fetch:  taskset -c 28.
#
# Usage:
#   python3 day039_d1_blocksum.py            # full probe,  A + B + C
#   python3 day039_d1_blocksum.py --selftest # first 2e6 zeros of C only
import sys
import numpy as np

R_H = "/home/jsmille/Projects/rh-missing-tail"

BANDS = [
    # (label, path, t_lo, t_hi)   t-values are the band spans (for reporting)
    ("A", f"{R_H}/scripts/rh/hi1e9/zeros_hi31946e6_to_1e9.f64", 3.1946e7, 1.0e9),
    ("B", f"{R_H}/scripts/rh/hi1e9/zeros_1002e6_to_2000e6.f64", 1.002e9, 2.0e9),
    ("C", f"{R_H}/scripts/rh/hi3e9/zeros_2002e6_to_3000e6.f64", 2.002e9, 3.0e9),
]

WIDTHS = [1e2, 1e3, 1e4, 1e5]          # t-units (pre-registered E5 set)
NCHUNK = 16_000_000                     # f64 per read  (128MB)
TPI_INV = 1.0 / (2.0 * np.pi)


def nas(t: np.ndarray) -> np.ndarray:
    # Project RVM asymmetry,  +3/4 (the E2 / SUM_EPS convention).
    u = t * TPI_INV
    return u * np.log(u) - u + 0.75


class BlockTracker:
    # One block of W t-units,  tracked across chunks.
    def __init__(self, w: float):
        self.w = w
        self.start_t = None            # zero that opened the current block
        self.S = 0.0                   # signed sum of the open block
        self.n = 0                     # gaps in the open block
        self.nblocks = 0
        self.sum_abs = 0.0
        self.max_abs = 0.0
        self.gaps_in_closed = 0
        self.first = True

    def feed(self, tvals: np.ndarray, deltas: np.ndarray):
        # tvals : zeros in this chunk (len m)
        # deltas: len m-1,  deltas[i] joins tvals[i] -> tvals[i+1]
        m = len(tvals)
        if m == 0:
            return
        if self.first:
            self.start_t = float(tvals[0])
            self.first = False
        i = 0
        end = m - 1                      # max gap index
        while i < end:
            close_t = self.start_t + self.w
            # first index k with tvals[k] >= close_t
            k = int(np.searchsorted(tvals[i + 1:], close_t, side="left")) + i + 1
            if k > end:
                # block runs past the chunk:  absorb the rest,  stay open
                #   (the cross-chunk gap will be fed next round)
                self.S += float(deltas[i:end].sum())
                self.n += end - i
                return
            else:
                self.S += float(deltas[i:k].sum())
                self.n += k - i
                self.nblocks += 1
                a = abs(self.S)
                self.sum_abs += a
                if a > self.max_abs:
                    self.max_abs = a
                self.gaps_in_closed += self.n
                # next block opens at tvals[k]
                self.start_t = float(tvals[k])
                self.S = 0.0
                self.n = 0
                i = k

    def mean_abs(self):
        return self.sum_abs / self.nblocks if self.nblocks else float("nan")

    def mean_gaps(self):
        return self.gaps_in_closed / self.nblocks if self.nblocks else float("nan")


def probe_band(label, path, t_lo, t_hi, limit=None):
    mm = np.memmap(path, dtype=np.float64, mode="r")
    total = mm.shape[0]
    if limit is not None:
        total = min(total, limit)
    trk = [BlockTracker(w) for w in WIDTHS]
    prev_t = None
    prev_na = None
    nG = 0
    abs_sum = 0.0
    dmin = np.inf
    dmax = -np.inf
    done = 0
    while done < total:
        n = min(NCHUNK, total - done)
        t = np.array(mm[done:done + n])
        anat = nas(t)
        d = 1.0 - (anat[1:] - anat[:-1])
        if prev_na is not None:
            # cross-chunk gap:  prev_t -> t[0]
            cross = 1.0 - (float(anat[0]) - prev_na)
            d = np.concatenate(([cross], d))
            tfull = np.concatenate(([prev_t], t))
        else:
            tfull = t
        done += n
        # stats on |delta|
        ad = np.abs(d)
        abs_sum += float(ad.sum())
        dmin = min(dmin, float(ad.min()))
        dmax = max(dmax, float(ad.max()))
        nG += len(d)
        for k, tr in enumerate(trk):
            tr.feed(tfull, d)
        prev_t = float(t[-1])
        prev_na = float(anat[-1])
        pct = 100.0 * done / total
        if (done // NCHUNK) % 5 == 0:
            print(f"  {label}: {pct:5.1f}%  ({done:,}/{total:,} zeros)", flush=True)

    nzeros = total
    nG = max(nG, 1)
    print(f"band {label}  span=({t_lo:.3e}, {t_hi:.3e}]  zeros={total:,}  "
          f"gaps={nG-1:,}")
    print(f"  mean|delta| = {abs_sum / nG:.6f}   min|delta| = {dmin:.6f}   "
          f"max|delta| = {dmax:.6f}")
    band_rows = []
    for w, tr in zip(WIDTHS, trk):
        mg = tr.mean_gaps()
        base = (abs_sum / nG) * mg if tr.nblocks else float("nan")
        mean_abs = tr.mean_abs()
        ratio = mean_abs / base if (tr.nblocks and base > 0) else float("nan")
        band_rows.append((w, tr.nblocks, tr.max_abs, mean_abs, mg, base, ratio))
        print(f"  W={w:7.0f}t  blocks={tr.nblocks:>10,}  max|S|={tr.max_abs:14.6f}  "
              f"mean|S|={mean_abs:14.6f}  avg_gaps={mg:12.1f}  "
              f"linear_base={base:14.6f}  ratio={ratio:.4f}", flush=True)
    print(flush=True)
    return label, abs_sum / nG, band_rows


def main():
    selftest = "--selftest" in sys.argv
    out = []
    out.append("D1 block-sum cancellation probe (S1-A1-EXPLORATION E5 item D1)")
    out.append("delta_i = 1 - (nas(t_{i+1}) - nas(t_i)),  "
               "nas(t) = (t/2pi) log(t/2pi) - t/2pi + 3/4")
    out.append("blocks close at the first zero beyond block_start + W t-units")
    print("\n".join(out), flush=True)
    allrows = []
    if selftest:
        print("SELFTEST: first 2,000,001 zeros of band C\n", flush=True)
        label, mean_d, rows = probe_band("C(st)", BANDS[2][1], BANDS[2][2],
                                         BANDS[2][3], limit=2_000_001)
        assert 0.15 < mean_d < 0.75, f"mean|delta| {mean_d} out of sanity range"
        # structural check:  a block sum is (up to the f64 telescope,
        # <~ 3e-5)  the drift increment  DN(end) - DN(start),  so it is
        # bounded by twice the certified sup|DN| = 2.615067:
        for r in rows:
            assert r[2] <= 5.5, f"max|S| {r[2]} breaks 2*sup|DN| + f64 slack"
        print("SELFTEST PASS (delta scale + bounded-drift structure sane)\n")
        return
    for label, path, tlo, thi in BANDS:
        allrows.append(probe_band(label, path, tlo, thi))
    # pooled alpha fit:  mean|S| ~ W^alpha  across the four widths
    import math
    print("alpha fit (mean|S| ~ W^alpha,  log-log slope across the 4 widths):")
    for label, mean_d, rows in allrows:
        lw = [math.log(r[0]) for r in rows]
        ls = [math.log(r[3]) for r in rows]
        # least-squares slope
        n = len(lw)
        sl = (n * sum(a * b for a, b in zip(lw, ls))
              - sum(lw) * sum(ls)) / (n * sum(a * a for a in lw) - sum(lw) ** 2)
        print(f"  {label}:  alpha = {sl:.3f}   "
              f"(1 = linear/E2-barrier,  0.5 = random-walk/compensation, "
              f"~0 = bounded/strong compensation)")
    print("\nVERDICT LINE (fill after reading the numbers):")
    print("  linear in W at every scale  =>  E2 barrier holds,  "
          "absolute-sum route dead")
    print("  sub-linear  =>  signed compensation visible,  "
          "pursue a signed-sum theorem")


if __name__ == "__main__":
    main()
