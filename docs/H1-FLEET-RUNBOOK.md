# H1 3e10 FLEET RUNBOOK

The (i) full fill = 696 point jobs = 29 windows (geometric x grid,
3.23e9 .. 2.79e10) x 24 offsets (k in -12..-1, +1..+12). Every point
is an INDEPENDENT unit: it streams the canonical 812.9GB zero set
once, computes its certified margin, and fsyncs one row into a
per-WINDOW checkpoint file (`ckpt_h1_3e10/widx%02d_x%s.pts`).
Windows never share a file, so any machine can take any DISJOINT set
of windows with `H1_WINDOWS`; no synchronization exists and none is
needed. The ledger is complete when the union of all machines' rows
covers 24/24 k-values in every window.

## 1. Assignment (default split)

| machine                          | H1_WINDOWS | points | engine |
|----------------------------------|------------|--------|--------|
| Strix Halo (primary)             | 0-11       | 288    | 4 ctx x 8 thr GPU (H1GPU=1) |
| Ryzen 5900X + RTX 3090 Ti (32GB) | 12-26      | 360    | 1-2 ctx x 8 thr GPU (CUDA) |
| 4070 Ti laptop (8GB, 32GB RAM)   | 27-28      | 48     | 1 ctx x 3 thr GPU or H1GPU=0 x 6 thr |
| cloud burst (optional)           | any gaps   | any    | as 5900X row |

Rebalance freely: an assignment is just an env var. The Strix
currently runs windows 0-14 (H1_WINDOWS unset = all remaining);
switch it to its assigned half at the next clean stop (the stop
helper + supervisor make that one command each).

## 2. Per-machine requirements

- **Data (canonical, md5-pinned):** the 3e10 band
  `zeros_2999e6_to_30000e6.f64` = 740,623,021,712 bytes
  (first zero 2999246000.182257, last 30001045999.981976) + the
  companion band files (L/A/B'/C — see `scripts/rh/hi3e10/`)
  + the 11 L-shards in `scripts/rh/lshards/` (md5 pinned in
  `lshards/md5.txt`). Total ~813GB. Staging options:
  (a) `scripts/rh/rh_fetch_data.py` (official lmfdb beta sources,
  the T2 Docker package path), (b) 10GbE stream from the Strix
  (`tar` over ssh, ~15-30 min), (c) pre-staged cloud block volume.
  The supervisor REFUSES to launch on any band/size/md5 mismatch
  (rc 5 / rc 7) — a machine can never silently use the wrong data.
- **RAM:** 28GiB untouchable reserve + ~2.5GiB per slab thread.
  Configurations:
  - 32GB box: 1 context x 8 threads (20-24GiB working set) — the
    5900X / laptop default.
  - 128GB Strix: 4 contexts x 8 threads = 32 threads.
- **GPU:** optional. CUDA (cupy-cuda*) or ROCm (cupy-rocm) — the
  code uses plain cupy only. VRAM rule: the slab pool keeps ~2.4GiB
  per thread live, so 8 threads ~= 19-20GiB VRAM (fits the 3090 Ti
  24GB, NOT the 4070 Ti 8GB — the laptop runs 3 threads or
  `H1GPU=0`). No GPU is fine: `H1GPU=0` is the verified CPU path
  (measured 428 MB/s per context on the Strix, ~5-7 min per 812.9GB
  pass, I/O-bound).
- **Python env:** `~/venvs/cupy` equivalent (mpmath 1.4.1, numpy
  1.26.x, the cupy wheel for the driver) or the repo Docker image
  (T2 package, smoke-tested).

## 3. Launch (per machine)

```
cd <repo>/scripts/rh
H1_WINDOWS="12-26" nohup bash day045_h1_supervisor.sh >> out_day045.log 2>&1 &
```

The supervisor verifies the band + 11 L-shard md5s, applies the
launch gate, and runs `day038_h1_3e10_gpu.py` with the env
(WORKERS=4 contexts, H1_THREADS=8, H1_WINDOWS passthrough).
Stop = `bash day045b_h1_stop.sh` (pid-file + cmdline-verified).
A crash/OOM/kill is not an event: the next launch resumes from the
per-window checkpoints (verified on the real run, twice).

## 4. Merge (when all assignments are green)

1. Copy every machine's `ckpt_h1_3e10/*.pts` rows into one directory
   on the Strix. Same window from different machines = same filename;
   union the rows, dedupe by k (a k must appear exactly once; two
   machines running the same k is recoverable by keeping either row —
   the rows are independently certified).
2. On the Strix, launch with `H1_WINDOWS` unset: the resume scan
   finds 24/24 in all 29 windows, assembles `out_day038_full_pts.txt`,
   prints `H1 FULL-DONE`, and the supervisor exits clean.
3. The finish gates (`day036` family) run against the assembled
   ledger as before.

## 5. Measured pace (this run)

- Strix, 4 ctx x 8 thr GPU (per-thread streams, 128MiB slabs):
  ~836 MB/s per context in the A/B benchmark; per pass ~6-10 min
  realistic; ~24-40 points/hour at 4 contexts; its 288-window half
  lands in ~8-12h wall.
- CPU mode (H1GPU=0): ~428 MB/s per context — the safe fallback on
  any box without a compatible GPU.
- The 3090 Ti should beat the 8060S by 2-4x per pass (936 GB/s HBM2e
  class memory + faster CUs): expect ~8-15 points/hour per
  8-thread context on the 5900X.

Fleet ETA (local 3 machines, parallel): ~12-24h wall
clock. Adding a 4-10 machine cloud burst (each machine: 812.9GB
staging ~1-2h from lmfdb or a pre-staged volume, then 8-20 points
per 2-4h burst class) can pull it under 24h; the local fleet alone
is the ~1-1.5 day answer.

## 6. Integrity invariants (fleet-wide)

- The band is `chmod a-w`; any machine that cannot verify
  size/perm/first-last/md5 pins does not launch (rc 5/7).
- Point rows carry their own certification (mnew, mcert, Bexp,
  audit row at k=-12); a merge never recomputes a row, it only
  checks 24/24 coverage and k-uniqueness per window.
- Checkpoint rows are append-only + fsync after every row; the only
  writer for window i is the machine that owns window i — no cross-
  machine interleaving exists by construction.
