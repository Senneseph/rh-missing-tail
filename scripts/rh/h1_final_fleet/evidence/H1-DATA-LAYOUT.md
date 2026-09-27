# H1 3e10 — data layout, gates, env (AUTHORITATIVE, read from the scripts)

Everything in this file was transcribed from the scripts' own comments/gates
(day038 docstring, day045 guards, rh_fetch_data docstring, day030 header,
day023_p11c_1e7).  Do not guess paths — use this table.

## 1. Band files the day038 engine reads (all under `R_H + "/scripts/rh/"`)

`R_H = os.environ.get("H1_RH", "/home/hgoddard/Projects/rh-missing-tail")`
**(day038 line 100 — the default is the original author's box; EVERY fleet
launcher must export H1_RH, see §5.  day045 does NOT set it.)**

| name | t-range covered | file (relative to R_H/scripts/rh/) | built by |
|---|---|---|---|
| L | (1e7, 3.1946e7] | `lshards/zeros_{8846000,10946000,...,29846000}.dat` (11 shards, 2.1e6 grid) + `lshards/md5.txt` (official LMFDB pin list) | `stage_lshards.py` (fetched from beta.lmfdb.org, md5 vs official list) |
| A | (3.1946e7, 1.006346e9] | `hi1e9/zeros_hi31946e6_to_1e9.f64` (8×2,792,198,664 B) | `day024_band_1e9.sh` |
| B | (A-last, 2.001746e9] | `hi1e9/zeros_1002e6_to_2000e6.f64` (8×3,066,173,720 B) | `fetch_bband.py` (476 L-grid shards) + `hi1e9/convert_hi3e10.py`. **Stitched** from the first zero strictly above A's last; A/B overlap (1.002146e9, 1.006346e9] cross-checked byte-exact at engine init |
| C | (B-last, 2.999246e9] | `hi3e9/zeros_2002e6_to_3000e6.f64` (8×3,142,622,346 B) | `day035_3e9_stream.sh` (475 shards) |
| D | (C-last, 3.0001046e10] | `hi3e10/zeros_2999e6_to_30000e6.f64` (8×92,577,877,714 B = 740,623,021,712) | `day035_t25_orchestrator.py` (12,858 shards, 8 fetch + 12 decode workers) |

Low region (0, 1e7]: **NOT a band file for the engine** — it is the
"on-line product over GN": `day023_p11c_1e7.py` reads
`R_H.../scripts/rh/zeros_T10000000_lmfdb.txt` (built by `rh_fetch_data.py low`
from the 19 Platt shards; GN count pinned at 21136125 for (0,1e7]).

`lowt_zeros` (`scripts/rh/lowt/zeros_0_to_1p2e3.f64`, 813 zeros on (0,1200],
6504 B) — an audit unit (`day030_lowt_zeros.py`, local bisection build,
~4.5 h), consumed by `rh_fetch_data.py low` (built if absent — verify =
exists + >1000 B) and by `day030_lowt_preflight/sweep.py`. **day038 does not
read it**; engines have run for days on the 5900X without it being present.

## 2. `rh_fetch_data.py` — the one data entry point (docstring layout)

| band | t range | lands at | built by |
|---|---|---|---|
| low | (0, 3.2e7] | `/tmp/zeta-dl/shards/*.dat`, `scripts/rh/zeros_T10000000_lmfdb.txt`, `scripts/rh/lowt/zeros_0_to_1p2e3.f64` | 19-shard md5-gated download + day024_platt_fast decode + day030 (only if file absent) |
| 1e9 | (3.2e7, 1.0063e9] | `hi1e9/zeros_hi31946e6_to_1e9.f64` | day024_band_1e9.sh |
| 3e9 | (1.002e9, 3.0e9] | `hi1e9/zeros_1002e6_to_2000e6.f64` + `hi3e9/zeros_2002e6_to_3000e6.f64` | fetch_bband.py + day035_3e9_stream.sh |
| 3e10 | (3.0e9, 3.0001e10] | `hi3e10/zeros_2999e6_to_30000e6.f64` | day035_t25_orchestrator.py (~3-7 h, needs ≥900 GB free) |

`python3 rh_fetch_data.py {low|1e9|3e9|3e10|all} [--check]` — resume-safe,
md5-gated, COUNT-chained.  No zero data ever lives in git.

## 3. day045 supervisor gates (launch order; a HOLD = no launch, owner decides)

1. Lock `H1_LOCK` (default `supervisor_day045.lock`, per-instance override).
2. D-band spot check: size 740623021712, perm `BAND_PERM_EXPECT` (default
   555; 777 documented owner override for the FUSE 5900X mount), first
   2999246000.182257, last 30001045999.981976 → rc 5 on mismatch.
3. L-shard guard: 11 shards present + md5 vs `lshards/md5.txt` official pins;
   restores them to `/tmp/zeta-dl/shards/` for old code paths → rc 7 on
   failure (missing pin file is a hard fail, not a silent no-op).
4. Memguard: do not launch while `MemAvailable < MEM_HOLD_GIB` (default
   108; 5900X override 18); 24 h of holds = give up.
5. Launch: `taskset -c $CPURANGE env ... day038_h1_3e10_gpu.py`; rc 3 =
   corrupt checkpoint (stop); "H1 FULL-DONE" or "0 point jobs remaining" in
   `$H1_OUT_LOG` = instance complete (exit); MAX_ATTEMPTS=30.

Resume model: every point (29 windows × 24 offsets = 696 total) is persisted
to `H1_CKPT_DIR/*.pts` the moment it completes; relaunch resubmits only
missing point jobs; at most 13 in-flight (one ~100-min sweep) lost per crash.

## 4. File-permission invariants

Band files 555 (restored by h1-init after staging on fresh nodes; the 5900X
FUSE mount uses the documented 777 owner override).  Checkpoint dirs 700.

## 5. Env knobs (who reads them)

| var | read by | meaning / default |
|---|---|---|
| `H1_RH` | day038 | data-path root. **Must be exported by every fleet launcher** (default = author's box) |
| `H1_WINDOWS` | day045→day038 | window list, e.g. `1-11`, `0,27-28` |
| `H1_CKPT_DIR` | day045/day038 | checkpoint dir (per instance) |
| `H1_OUT_LOG` | day045/day038 | engine log (per instance) |
| `H1_PYTHON` | day045, h1-run-one | python with cupy (node: /opt/venvs/cupy/bin/python) |
| `WORKERS` | day045→day038 | GPU contexts (default 4); clamped down by memguard from RAM |
| `H1_THREADS` | day045→day038 | slab threads per context (default 8) |
| `CPURANGE` | day045 | taskset range |
| `MEM_HOLD_GIB` | day045 | launch RAM floor (default 108) |
| `BAND_PERM_EXPECT` | day045 | D-band perm gate (default 555) |
| `H1_PER_THREAD_GIB` / `H1_GPU_CLIENT_BUDGET` / `H1_XORG_CLIENTS` | day045→memguard | 2.5 / 11 / 1 |
| `H1_WINDOWS_<A-D>` | h1-run-one (fleet) | per-instance slice; `/workspace/h1/env/h1-<i>.env` file overrides |

## 6. Known traps (all fixed — do not reintroduce)

1. `H1_RH` unset on fresh nodes → FileNotFoundError at selftest(e)/engine
   init on `/home/hgoddard/...` (hit 2026-09-25, node 52294870).
2. day038 `walk()`: `newton_zero` must be `newton_zero_from(float(t), d)`
   (NameError, line ~218).
3. day030: `karr.size` not `keep.size` (line 338).
4. 3e9 gate anchors RVM at `min(3.0e9, t_end)` (band may end at a shard
   boundary, not the round number).
5. legacy scripts hardcode `/tmp/zeta-dl` and the author's repo path —
   h1-init aliases both before any fetch (idempotent).
6. finish gates need the cupy python (`PYF`), not system `python3` (no numpy).
7. `BAND_PERM_EXPECT=777` on the 5900X (FUSE D-band file is 777).

## 2026-09-25:  fast-track a fresh box's staging  (5900X is the standing lowt source)
day030 lowt zero-finding is CPU-bound and SLOWS toward the end (~45 s/zero near
t=1200;  4-8 h from scratch).  The finished artifact is canonical and tiny:
  scripts/rh/lowt/zeros_0_to_1p2e3.f64   (6504 B,  md5 d7bdf01d7840641d4cb384f124143cbd)
  scripts/rh/lowt/zeros_checkpoint.npz   (complete 813-zero checkpoint)
Ship both to a staging box before/while its fetch runs:
  cat lowt/zeros_0_to_1p2e3.f64 lowt/zeros_checkpoint.npz  (scp to $RH/scripts/rh/lowt/,
  overwrite the box's partial npz, then (re)start h1-init)
fetch's md5 gate then reports "band 'low' complete" in seconds and proceeds to 1e9.
(2026-09-25: applied on the 8x4090 box -- cut ~6 h off staging.)
