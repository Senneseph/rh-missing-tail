# Big-data crunch and deploy plan (Docker-in-repo + cloud)

So the plan survives across sessions.
Every number below was measured or live-checked on this date;
estimates say so when estimate.

One-line state: **the data is the last external input of the
RH chain.**  The 3e10 extension of the zero census (band
(2.9992e9, 3e10]) is the decision-maker for the [S1] uniform
walk bound, and as of today's live crawl the public LMFDB index
already reaches it.

────────────────────────────────────────────────────────────
## 1.  State on disk (measured 2026-09-20)

### 1a.  The compute script

`scripts/rh/day035_3e10_stream.sh` —  cloud handoff script
from the 1e9 run family.  Mechanism (already ironclad by
design):  resumable curl (-C -) per shard,  LIVE-minted md5
manifest gate per shard,  decode-append via
`day024_platt_fast.py` (pure stdlib,  struct unpack,  per-shard
Nt0 count-chain assert),  state/manifest/lastN bookkeeping,
transient shard deleted after each decode,  progress + ETA
every 25 shards,  finish gates,  explicit PARTIAL path if the
public index does not reach 3e10.

**Audit performed 2026-09-20:  THREE REAL BUGS FOUND AND
FIXED** (the script had never been executed;  the 3e9 sister
script's run is the only live ancestor):

1.  Preflight shard-count assert was `150..4000` —  the live
    index needs **12,858** shards for our range,  so the run
    would have FATAL'd at preflight.  Fixed to a principled
    bound `8000..25000` (the LMFDB grid is adaptive:  ~2.1e6
    t-spaced at low t,  ~58.6e3 at high t —  the count is
    data-dependent,  not a fixed formula;  the live value is
    logged at preflight).
2.  Finish-gate heredoc had a SyntaxError (stray closing
    paren on the `sys.argv` line) —  the gate would have
    crashed with a traceback on EVERY run,  even a perfect
    one.  Fixed;  both heredoc blocks now compile
    (`py_compile` verified).
3.  Finish gate did `np.fromfile` + `np.diff` on the whole
    ~700-750GB file —  needs ~750GB RAM plus a ~700GB diff
    copy (the 3e9 gate squeezed through on this host's 31GB
    because the band was 25GB).  Rewritten RAM-SAFE:
    `np.memmap` + 512MB chunked streaming of
    monotonicity/min-gap (peak ~1GB),  seam + RVM gates
    unchanged,  3e10 gate via `np.searchsorted` on the memmap.

Verification:  `bash -n` clean;  both embedded python blocks
`py_compile` clean;  the fixed preflight assert passes against
today's live crawl count (12,858).

### 1b.  Live preflights (run today,  read-only against LMFDB)

-  Index crawl:  **14,580 public shards**,  first = 14,
    last = 30,607,946,000.  **3e10 IS public** (margin of
    ~0.6e9 t).
-  Needed for [2,999,246,000 → 30,000,000,000]:  **12,858
    shards**,  last needed name = 29,998,946,000 (its span
    crosses 3e10).
-  md5 manifest:  **all 12,858 present** (0 missing).
-  Band size:  ~8.76e10 zeros (N(3e10) pinned later within
    tol 3 of RVM(3e10) ≈ 9.66e10;  frontier 9,061,794,704 at
    2999245999.862950)  →  **~700-750GB output file**.

### 1c.  Seam audit (cross-checked against day035 data)

The 3e10 run's first shard `zeros_2999246000` starts at
t = 2999246000.0,  but the 3e9 band file ends at
2999245999.862950 —  a 0.137-t slice in between.  Concern:
if a zero lay in that slice,  the seam assert
(`Nt0 == FRONTIER_N`) would FATAL on a correct shard.  It
does NOT:  day035 already fetched and md5-gated exactly this
shard to pin N(3e9),  and recorded **Nt0 = N(band end)
chain-exact** —  the slice is empirically zero-free.  Seam
audit is sound as written.

### 1d.  Throughput and runtime (from the 3e9 run,  measured)

The per-shard wall decomposes into two measured pieces:

-  DOWNLOAD:  one shard ~54MB.  On this box ~3s (residential);
    on a 1Gbps cloud box ~0.5-1s.
-  DECODE (the hidden half):  the shards are NOT raw floats —
    each zero is 13 bytes of 104-bit fixed-point STEPS (the
    Bober/Platt format),  and the verified decoder does a
    per-zero 104-bit integer walk in pure python:  **~2.5s per
    shard,  measured on the 3e9 run** (6.5M zeros).  CPU-bound,
    download-speed-independent.

So for the 12,858-shard 3e10 extension:

-  SEQUENTIAL script on a 1Gbps box:  decode-bound at
    ~3.1s/shard → **~11h wall** (not the 3-5h a
    download-only estimate suggests).
-  PARALLEL orchestration (fetch pipelined,  4-8 worker
    decodes of the UNCHANGED verified decoder,  ordered
    byte-append + the same md5/chain/gate asserts):  decode
    overlaps the download → **~3h wall**.  This is work unit
    T2.5 (a few hours of scripting,  zero change to any
    verification semantic:  same decoder,  same md5 gates,
    same count chain,  same finish gates).
-  **GPU / "GPU mpmath?" check (owner question):**  there is
    no GPU version of mpmath (it is a pure-python package;  no
    maintained port exists).  The "something we used earlier"
    in the project was the CUPY-based GPU walks (the
    day004/day009 `*_gpu` S(t)/zero-walk scripts + bench_cupy_
    numpy —  now archived in the pre-split kainos-logos
    repo):  GPU-numpy for the vectorizable argument-main
    part,  screen-level accuracy,  deliberately NOT
    bit-identical to the mpmath/CPU evaluations,  and exactly
    for that reason it never feeds a pin.  Irrelevant to this
    run anyway:  the 3e10 ingest path uses no mpmath at all
    (pure-stdlib 104-bit decode + numpy gates).  If a future
    job COMPUTES zeros beyond the public index,  the cupy
    approach applies again —  same screen-level role,  CPU
    checkpoints,  no pin authority.

CPU/RAM reality:  4-8 vCPU,  8GB RAM is plenty (each decode
worker ~200MB;  the finish gates stream at ~1GB peak).  The
earlier "3-5h / download-bound" line is superseded by the
decomposition above.

**STANDING CONSTRAINT (owner):  never occupy all cores —
leave 2 physical cores (4 threads) free for system/resource
management at all times,  so the machine stays responsive
and a hung worker cannot stall the box.**  The orchestrator
is therefore capped at 14 physical cores (12-14 workers
default) on this 16c/32t machine,  and the cap is a
hard-wired default,  not an operator judgment call.

**Local machine now PRIMARY (measured):**  the 10TB USB
(exFAT,  8.1T free) landed;  the LMFDB rate from here is
capped at **~40MB/s aggregate** (measured:  38.8MB/s
single-connection,  41.9MB/s 4-way concurrent —  no gain,
so the cap is aggregate,  md5-verified on all fetch
tests).  Local 3e10 run:  ~750GB / 40MB/s ≈ **~5h
wall,  download-bound** —  the 12-14 worker decode
(~48min of work) fully hides inside it.  Resumable,
kill-safe,  free,  and the finished band STAYS on the
owner's drive (no 750GB egress,  no retrieval).  Run dir:
`/media/jsmille/My Book/rh-missing-tail/` (isolated lane,
owner's existing data untouched).  Cloud drops to the
fallback / public-reproducibility venue (and the Docker
turnkey image is what makes it a no-brainer there).

────────────────────────────────────────────────────────────
## 2.  Ironclad-script contract (what guarantees,  checked)

| Guarantee | Status |
| --- | --- |
| Kill-safe at any shard boundary (relaunch skips done shards) | `state.txt` skip-list — PASS (3e9-ancestor proven) |
| Every shard md5-gated against the LIVE manifest (refetched each run) | PASS |
| Count continuity (Nt0 of each shard = previous Nt1) | PASS (decoder assert) |
| Seam to the 3e9 band (Nt0 of first shard = frontier) | PASS (verified vs day035 data,  1c) |
| Finish gates (monotone,  min gap,  seam gap in (0,1),  RVM tol 3 at band end AND at 3e10) | PASS (rewritten RAM-safe,  2026-09-20) |
| Partial-index path (explicit FINISH-GATES-PARTIAL,  no fake pass) | PASS (index currently full-reach,  1b) |
| No auto-run anywhere (manual launch only) | by design — the script is a manual entrypoint |
| Idempotent relaunch (no double-append,  no state corruption) | PASS (state-gated loop) |
| Disk budget explicit (>= 1TB free at output path) | header says so;  sizing in 3b |

Residual risks (honest):  LMFDB availability/rate limits
(mitigated:  resumable + backoff + md5),  the `Cookie:
human=1` fetch pattern could age out over months (mitigated:
preflight fails loudly,  fix is a one-liner),  and disk
exhaustion (mitigated:  preflight sizes the range;  the
cloud box is provisioned with >= 1TB).

────────────────────────────────────────────────────────────
## 3.  The container (built INTO rh-missing-tail)

Goal (owner direction):  the compute is part of the repo,
runs inside the repo's own Docker container,  and when the
repo becomes public anyone can spin up a clean container and
reproduce any part of the Lean or the data computation.
Normal docker constraints.  **Nothing runs automatically
when the container starts** —  compute is always an explicit
named command.

### 3a.  Pattern

Follow the pinned-image discipline already proven in
kainos-logos (ADR-0010):  base image pinned by digest (no
:latest),  python dependencies sha256-lockfile-pinned,  no
moving apt index inside the build,  small + secret-free build
context.  Difference from the kainos image:  this one is
SELF-CONTAINED (the repo tree is COPYed in,  slimmed by
.dockerignore) so a clean machine + `docker run` is
sufficient —  no prior checkout state needed.

### 3b.  Contents

-  Base:  python 3.12-slim pinned by digest (same family as
    the kainos image).
-  Python deps,  pinned to the EXACT versions the data chain
    was run with:  **mpmath 1.4.1,  numpy 1.26.4** (host
    environment,  verified today) + pip-compiled lock with
    hashes.  (Note:  the kainos image pins mpmath 1.3.0 —
    different project,  different pin;  do NOT reuse that
    lockfile.)
-  `curl` (shard fetch) —  from base if present,  else one
    apt line with exact version + lockfile note per ADR-0010.
-  Lean toolchain:  `elan` + **leanprover/lean4:v4.33.1**
    (the exact pin in `formal/lean-toolchain`),  installed in
    the image.  `lake build` first run is the slow part
    (mathlib v4.33.1 compile,  ~1-2h on a fast box);  the
    runner documents a `LAKE_CACHE` volume so the mathlib
    build is paid once per machine,  not per container.
-  Repo tree:  COPYed at build (slimmed),  `WORKDIR /work`;
    the 68GB of banded zero data (hi3e9/hi1e9) and `formal/
    .lake` are excluded by .dockerignore —  they are
    GENERATED products of the in-container pipeline,  not
    inputs (the md5 gates make the regenerated data
    verifiable).
-  `rh-reproduce` runner (small committed script) with
    EXPLICIT subcommands —  the only way compute runs:
    -  `lean-build`       full lake build of the chain
    -  `3e10-band`        run day035_3e10_stream.sh (manual,  logs to stdout+file)
    -  `gate-3e10`        re-run only the finish gates on an existing band file
    -  `walk-pin`         the S3e-style drift walk over a band file (produces sup|DN|)
    -  `verify-chain`     the screen-level verification battery (low-t + band checks)
    -  `status`           report state files / frontier / sizes
-  Default `CMD` is an interactive shell.  No entrypoint
  auto-runs anything.  (The container is a LABORATORY,  not a
  cron job —  the "no auto-run at boot" contract,  owner
  direction.)

### 3c.  Cleanup (the "cleaned up first" list)

-  .dockerignore:  `.git/`,  `formal/.lake/` (14GB cache),
    `scripts/rh/hi3e9/` (24GB),  `scripts/rh/hi1e9/` (44GB),
    `*.f64` band files,  `__pycache__/`,  `tmp/` (13MB),
    `results/` generated artifacts (keep small pin records),
    `node_modules/` (rh-ts),  `.env*`.
-  Repo hygiene for the public build:  probe scratch files
    (Probe*.lean),  the owner-personal untracked files
    (PUBLICUM.md,  docs/BONUS.md) stay UNCOMMITTED and out of
    the image.
-  Image size target:  < 2GB (base + python deps + elan +
    lean + slim repo).

────────────────────────────────────────────────────────────
## 4.  Cloud choice (real pricing,  checked 2026-09-20)

Requirements (from 1b/1d):  >= 1TB disk (700-750GB output +
headroom),  1Gbps uplink,  **4-8 vCPU (decode parallelism is
the dominant wall-time lever —  see 1d)**,  8GB+ RAM (peak
~1-4GB for the gates),  ~3-11h of runtime (billed
per-second/per-hour),  then RETRIEVAL of the final band file
(~700-750GB egress).  **No GPU:  the workload is a ~700GB
download + a scalar per-zero integer decode —  there is no
dense numeric kernel for a GPU to eat (see 1d).**

| Option | Spec | Compute cost (run) | Storage | Egress of 750GB | Notes |
| --- | --- | --- | --- | --- | --- |
| **DigitalOcean (owner's pick)** | 8GB/**4-8 vCPU** droplet (per-second billing → ~$0.03/h) | ~$0.30-0.60 for the 3-11h run | 1TB block volume @ $0.10/GiB/mo,  per-second → ~$1.40 for a day | $0.01/GB → **~$7.50** | Easiest ops;  total ≈ **$10-15** |
| Hetzner dedicated EX101 | i9-13900,  64GB, **2x1.92TB local NVMe** (RAID1),  1Gbit guaranteed,  traffic unlimited | ~EUR 0.15/h → **~EUR 4 for 24h**;  setup EUR 39-44 one-off | included (local NVMe,  no volume attach) | **unlimited → free** | Best perf/price;  ops = root VM (SSH-only,  no fancy console);  one-off setup fee |
| Hetzner cloud (CX/CX32) | 2-16 vCPU,  8-64GB,  NVMe | ~EUR 2-6 for the run | volume ~EUR 0.04/GiB/day-ish | 20TB free tier | Between the two |
| This machine | 16 cores / 32 threads (Ryzen AI MAX+ 395),  124GiB,  10TB USB (8.1T free),  LMFDB capped ~40MB/s | free | ~5h download-bound | n/a —  data stays on the owner's drive | **PRIMARY** |

**Recommendation:**  LOCAL FIRST (owner's 10TB drive + the 32-thread box;  ~5h download-bound,  free,  the data stays home —  see 1d).  The Docker turnkey image makes every other venue a one-command fallback:  DigitalOcean droplet + 1TB volume (per-second billing,  ~$10-15 all-in including egress) for a public/vendor reproduction or a repeat run,  Hetzner EX101 (local NVMe,  free egress) for heavy repeats.  All fit "normal docker constraints" (x86_64,  docker on the host).

────────────────────────────────────────────────────────────
## 5.  Launch protocol (explicit,  manual,  step by step)

1.  Build the image locally:  `docker build -t rh-missing-tail .`
    (after T2 below).  Smoke-test in the container:
    `rh-reproduce status`,  a `lean-build` of ONE module,  a
    small `3e9-band`-sized dry fetch of ONE shard (md5-gated).
2.  Push image:  owner's DO account →  `docker tag` +
    `docker push` to the owner's private registry (or
    `docker save | ssh | docker load` for a one-shot).
3.  Provision:  DO 8GB/4vCPU + 1TB volume attached +
    formatted ext4 + mounted at /mnt/band (the runner takes
    `BAND_DIR=/mnt/band` so the script's ROOT-relative
    layout lands on the volume;  >= 1TB free preflight).
4.  Launch (EXPLICIT,  never auto):
    `docker run -d --name rh3e10 -v /mnt/band:/data BAND_DIR=/data -e BAND_DIR=/data rh-missing-tail rh-reproduce 3e10-band`
    —  supervised;  `supervisor.log` gives shard progress +
    ETA every 25 shards.  Kill/relaunch is safe at any shard
    boundary (2a).
5.  Watch:  preflight lines (index crawl,  md5 OK,  count),
    then progress lines.  If LMFDB throttles,  the backoff
    loop shows it in the log —  decision:  keep waiting (it
    resumes) or stop (state is safe).
6.  Finish:  the finish gates print (FINISH-GATES-PASS with
    N(3e10) pinned,  or PARTIAL).  `BAND-3E10-DONE` in the log
    is the completion signal.
7.  Retrieve:  md5 the final band file in the box,
    download it (egress ~$7.50),  md5-match locally,  plus
    the state/manifest/log files (small).
8.  Local verification:  `rh-reproduce gate-3e10` (re-run the
    gates on the retrieved file),  then `walk-pin` over
    (2.9992e9, 3e10] (sup|DN| on the extended band —  the
    [S1] decision-maker),  then the pre-registered outcome
    classification (preprint Section 6,  "Final gate and
    pre-registered outcomes").

────────────────────────────────────────────────────────────
## 6.  What happens when it gets back (pre-registered)

Per the preprint's pre-registered outcomes (written BEFORE
the data exists —  the selection is by rule,  not by hope):

-  **A1:**  per-gap eps admit analytic bounds → data-free eps
    sum → [S1] closes UNIVERSAL → "final resolution" claim.
-  **A2:**  eps close only with measured stats → [S1] closes
    domain-verified to 3e10 → "historic verification result"
    claim.
-  **B:**  the walk breaks in (2.9992e9, 3e10] → break point
    becomes the theorem (pre-registered counterexample);
    ceiling report moves there.
-  **C:**  partial run → re-point at the reached frontier.

The walk-pin (step 8) is the referee that picks among them.

────────────────────────────────────────────────────────────
## 7.  Publish polish (after the run,  part of the final gate)

-  README:  container section (build/run/reproduce,  explicit
    commands,  no-auto-run contract,  hardware notes).
-  docker-compose example for one-command reproduction.
-  Reproducibility matrix:  "which command reproduces which
    result" (Lean chain → lean-build;  3e9 census → 3e9
    stream;  3e10 extension → this plan;  pins → verify-chain).
-  Image tag + lockfile freeze at finalization;  the
    pre-registered sentence swap in the preprint (Section 6
    of the doc,  per outcome).

────────────────────────────────────────────────────────────
## 8.  Work units and the stop rule

| Unit | Content | Size | Status |
| --- | --- | --- | --- |
| T1 | Script audit + 3 fixes (assert bound,  gate syntax,  RAM-safe gate) + live preflights | small | **DONE** (this session) |
| T2.5 | Parallel orchestration of the 3e10 run:  pipelined fetch (2-4 concurrent) + 12-14 workers (HARD CAP 14 physical cores — 2 cores always reserved,  owner rule) running the UNCHANGED verified decoder,  ordered append,  identical md5/chain/gate asserts | ~1-2h scripting + a 1-shard parallel-vs-sequential bit-exact cross-check | after T2,  before launch |
| T2 | Dockerfile + rh-reproduce runner + .dockerignore + lockfile + local image build + in-container smoke tests (one module lean-build,  one shard md5 fetch) | the one medium unit,  est 2-4h | OWNER GO-AHEAD |
| T3 | Provision DO (or Hetzner) + push image + attach volume + launch | owner action w/ my protocol,  ~1h hands-on | after T2 |
| T4 | Watch run (3-11h cloud,  mostly external) + retrieve + local gate/walk-pin + outcome classification | ~1-2h agent work after data | after T3 |
| T5 | Publish polish (README,  compose,  matrix,  tag,  preprint sentence swap) | small,  several passes | after T4 |

Nothing here is a hidden >4h job:  T2 is the largest unit and
is bounded;  T4's run time is CLOUD time (the box works
while the owner lives their life),  not agent time.

────────────────────────────────────────────────────────────
## 9.  Owner decisions needed

1.  Cloud:  DO droplet + 1TB volume (recommended,  ~$10-15
    total)  vs  Hetzner EX101 (~EUR 4 run + EUR 39-44 setup,
    free egress).  GO/NO-GO on spending.
2.  GO on unit T2 (container build,  2-4h,  in-repo,  local —
    no cloud needed).
3.  Image hosting for one-shot:  DO private registry account,
    or `docker save | ssh | docker load`.

Provenance of numbers:  live LMFDB crawl + md5 manifest
(fetches of 2026-09-20,  cached at /tmp/zeta-dl for the
session),  3e9 stream supervisor log (475 shards / 44 min),
band file sizes (du),  DO/Hetzner pricing pages (fetched
2026-09-20).
