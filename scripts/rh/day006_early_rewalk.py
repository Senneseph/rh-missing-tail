"""day006: early-window re-walk of the S(1e7) decade [1e6, 1.4e6].

The GPU main walk (dt = 5e-4) finished with N(1e7) = 21,135,877 and
S(1e7) = -247.2 — S drops from -2.5 to -~248.75 inside the first bucket
[1e6, 2e6) and then stays ~ -247 constant: a ~128-rad (one GPU chunk of
256,000 points) counting blackout near t ~ 1.06e6. |S| ~ 247 at 1e7 is
incompatible with every published zero-walk (observed |S(t)| < ~11 to very
large t), so the count is defective, not S real.

This re-walk uses the INDEPENDENT CPU engine (zeta_core.Z_rs, 2-term RS)
at the main resolution dt = 5e-4 AND dt/2 = 2.5e-4 (twin-floor stability
protocol), and localizes the original defect by reconstructing the
original walk's running count from the S file:
    N_orig(t) = S_file(t) + vartheta(t)/pi   (1-rad samples, CPU vartheta)
    diff(t)   = N_new(t) - N_orig(t)         (cumulative missed flips)
"""
import numpy as np
import zeta_core

T_LO = 1_000_000.0
T_HI = 1_400_000.0
DT_COARSE = 5e-4
DT_FINE = 2.5e-4
N0 = 1_747_142  # N(1e6), dt-stability verified (day-004b)


def walk(dt: float):
    n = int(round((T_HI - T_LO) / dt)) + 1
    flips = 0
    prev_sign = None
    flip_times = []
    for k in range(n):
        t = T_LO + k * dt
        z = zeta_core.Z_rs(t)
        sign = 1.0 if z >= 0.0 else -1.0
        if prev_sign is not None and sign != prev_sign:
            flips += 1
            flip_times.append(t)
        prev_sign = sign
    gaps = [b - a for a, b in zip(flip_times, flip_times[1:])] if len(flip_times) > 1 else []
    min_gap = min(gaps) if gaps else float("inf")
    return flips, flip_times, min_gap


def original_running_count():
    out = {}
    with open("S_t_walk_1e6_1e7_gpu_dt0005.txt") as f:
        for line in f:
            t_str, s_str = line.split()
            t = float(t_str)
            if T_LO <= t <= T_HI:
                out[int(round(t))] = round(float(s_str) + zeta_core.vartheta(t) / np.pi)
    return out


print(f"window      : [{T_LO:.0f}, {T_HI:.0f}]")
n_orig = original_running_count()
orig_span = n_orig[max(n_orig)] - n_orig[min(n_orig)]
print(f"original walk: {orig_span} zeros counted in window (from S file)  "
      f"[N_orig range {min(n_orig.values())} .. {max(n_orig.values())}]")

coarse, coarse_t, min_gap_c = walk(DT_COARSE)
print(f"CPU re-walk dt={DT_COARSE}: {coarse} sign flips, min gap {min_gap_c:.6f}")
fine, fine_t, min_gap_f = walk(DT_FINE)
print(f"CPU re-walk dt={DT_FINE}: {fine} sign flips, min gap {min_gap_f:.6f}")
stable = "STABLE (exact agreement)" if coarse == fine else f"UNSTABLE (delta {fine - coarse})"
print(f"count agreement: {stable}")

# localize the defect: diff at 1-rad grid points (using fine-walk flips)
t_ints = sorted(n_orig)
diffs = []
fi = 0
for ti in t_ints:
    t_float = float(ti)
    while fi < len(fine_t) and fine_t[fi] <= t_float:
        fi += 1
    n_new = N0 + fi
    n_orig_t = n_orig[ti]
    diffs.append((ti, n_new - n_orig_t, fi))
print("\nt        N_NEW   N_ORIG  diff(t)  (cumulative missed flips)")
shown = 0
for ti, d, cnt in diffs:
    if d != 0 and shown < 400:
        print(f"{ti:.0f}     {N0 + cnt:9d}  {n_orig[ti]:8d}   {d:+d}")
        shown += 1
final_diff = diffs[-1][1]
print(f"\nfinal cumulative defect over window: {final_diff}")
print(f"corrected N(1e7) = 21135877 + {final_diff} = {21135877 + final_diff}")
