# day-005 completion: verify corrected N/S at 1.4e6, 5e6, 9.9e6, 1e7.
#
# Part A (host, float64): read the GPU walk S-file, rebuild the running
# count N_file(t) = round(S_file(t) + vartheta_float(t)/pi) at the four
# grid points.  The vartheta convention MUST be the DLMF 25.10.2 one
# (arg Gamma(1/4 + it/2) - (t/2) ln pi), identical to the verified
# dps-40 checks of day-003/004b.
#
# Part B (docker mpmath, dps-45): for each (t, N_cand):
#   2K = (N - main + 1) - g/pi   must be an even integer (mod-2 parity)
#   S  = N - (main - 1 + g/pi)   must be O(1)
#   where g = vartheta (DLMF) and main = floor( t/(2pi) ln(t/(2pi)) - t/(2pi) + 1/4 ).
#
# Usage:
#   python3 day005h_verify_1e7.py <delta_total_missed_flips> [t1 N1 t2 N2 ...]
# With no candidate list, computes N_file itself and applies the delta at
# every point >= 1.4e6 (the rewalk window end) — the single-blackout model.
import math
import os
import subprocess
import sys

sys.path.insert(0, ".")
import zeta_core  # verified float64 engine (DLMF vartheta)

WALK = "S_t_walk_1e6_1e7_gpu_dt0005.txt"
POINTS = (1400000, 5000000, 9900000, 10000000)


def s_file_at(t):
    row = t - 1000000 + 1  # 1-indexed row for t = 1e6 + k
    with open(WALK) as fh:
        for i, line in enumerate(fh, 1):
            if i == row:
                return float(line.split()[1])
    raise AssertionError(f"row {row} not found")


def vartheta_float(t):
    # DLMF 25.10.2 in float64, same expression as zeta_core.vartheta
    v = math.log(2 * math.pi)  # unused placeholder keeps names explicit
    del v
    # arg Gamma(1/4 + it/2) - (t/2) ln pi, via the engine's verified path
    return zeta_core.vartheta(t)


def main():
    delta = int(sys.argv[1]) if len(sys.argv) > 1 else None
    if delta is None:
        print("usage: pass the total missed-flip delta from the rewalk run")
        return 1
    lines = ["t dN Sfile Nfile Ncorr Sf Sfile_g Sfile_gpi gpi"]
    candidates = []
    for t in POINTS:
        sf = s_file_at(t)
        gpi_f = vartheta_float(t) / math.pi
        n_file = int(round(sf + gpi_f))
        n_corr = n_file + delta
        frac = abs(gpi_f - round(gpi_f))
        margin_note = "" if min(frac, 1 - frac) > 1e-6 else "  !! rounding margin small"
        print(f"t={t}: S_file={sf:.12f}  gpi_float={gpi_f:.9f}  "
              f"N_file={n_file}  N_corr={n_corr}{margin_note}")
        candidates.append((t, n_corr))
    mp_script = r"""
from mpmath import mp
mp.dps = 45
for line in sys.stdin:
    t, N = line.split()
    tv = mp.mpf(t)
    g = mp.arg(mp.gamma(0.25 + tv/2*mp.j)) - tv/2*mp.log(mp.pi)
    main_ = mp.floor(tv/(2*mp.pi)*mp.log(tv/(2*mp.pi)) - tv/(2*mp.pi) + mp.mpf("0.25"))
    twoK = (mp.mpf(N) - main_ + 1) - g/mp.pi
    twoK_even = twoK - 2*mp.floor(twoK/2 + mp.mpf("0.5"))
    S = mp.mpf(N) - (main_ - 1 + g/mp.pi)
    print(f"t={t} N={N}: 2K={mp.nstr(twoK, 22)} (dist-even={mp.nstr(twoK_even, 8)}) S={mp.nstr(S, 16)}")
import sys
"""
    # day-014 bug fix: payload must travel on stdin as DATA, not be
    # concatenated into the program source (SyntaxError: '1400000 2520971'
    # terminated the for-loop and hit module level). The script body is now
    # written next to this file and fed the payload separately.
    with open(os.path.join(os.path.dirname(os.path.abspath(__file__)),
                           "day005h_mp.py"), "w") as out:
        out.write(r"""
import sys
from mpmath import mp
mp.dps = 45
for line in sys.stdin:
    line = line.strip()
    if not line:
        continue
    t, N = line.split()
    tv = mp.mpf(t)
    g = mp.arg(mp.gamma(0.25 + tv/2*mp.j)) - tv/2*mp.log(mp.pi)
    main_ = mp.floor(tv/(2*mp.pi)*mp.log(tv/(2*mp.pi)) - tv/(2*mp.pi) + mp.mpf("0.25"))
    twoK = (mp.mpf(N) - main_ + 1) - g/mp.pi
    twoK_even = twoK - 2*mp.floor(twoK/2 + mp.mpf("0.5"))
    S = mp.mpf(N) - (main_ - 1 + g/mp.pi)
    print(f"t={t} N={N}:  2K = {mp.nstr(twoK, 22)}  (dist-to-even-integer = {mp.nstr(twoK_even, 8)})  S = {mp.nstr(S, 16)}")
""")
    payload = "\n".join(f"{t} {n}" for t, n in candidates) + "\n"
    here = os.path.dirname(os.path.abspath(__file__))
    proc = subprocess.run(
        ["docker", "run", "--rm", "-i", "-v", f"{here}:/work", "kainos-dev:dev",
         "sh", "-c", "pip -q install mpmath; python3 /work/day005h_mp.py"],
        input=payload,
        text=True, capture_output=True, timeout=600)
    print("--- dps-45 verification (docker mpmath) ---")
    print(proc.stdout)
    if proc.returncode != 0:
        print("docker stderr:", proc.stderr)
    return proc.returncode


if __name__ == "__main__":
    raise SystemExit(main())
