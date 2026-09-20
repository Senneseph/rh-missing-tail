# 3e10 cloud handoff — runbook

Handed off 2026-09-20 per owner direction (the extension is a
"~700-750GB" job:  the local disk is blocked at 132GB free of
~765GB needed).  Throughput measured 2026-09-20 from the 3e9
run (475 shards / 44 min):  per shard = ~3s download + ~2.5s
DECODE (the 104-bit fixed-point per-zero walk is CPU-bound,
not bandwidth-bound) → a 1Gbps cloud box runs it **~11h
sequential,  ~3h with the T2.5 parallel orchestration (4-8
vCPU;  unchanged decoder,  identical gates — COMPUTE-DEPLOY-
PLAN.md section 1d;  no GPU benefit:  the data is downloaded,
not computed)**.  See
COMPUTE-DEPLOY-PLAN.md for the full plan (container design,
cloud options with pricing, launch protocol, and the 2026-09-20
script audit that fixed 3 real launch blockers in the companion
script).  Resume base:  the day035 3e9 band, already audited.
The companion script is `scripts/rh/day035_3e10_stream.sh`
(same mechanism as the proven `day035_3e9_stream.sh`).

## 1.  What the run produces

-  A band file `hi3e10/zeros_2999e6_to_30000e6.f64` carrying the
    zeros in (2.9992e9, band end] as float64 (8 bytes each),
    ~700-750GB if the public index reaches 3e10:
      N(3e10) ~= 9.67e10 (Riemann-von Mangoldt estimate),
      N(2.9992e9) = 9,061,794,704 (pinned),
      new zeros ~= 8.76e10 × 8 B ~= 701GB.
-  A per-shard manifest (`manifest.tsv`:  shard name, md5, decoder
    summary line) and a shard state file (`state.txt`) — the
    audit trail and the resume record.
-  If the index reaches 3e10:  EXACT N(3e10) via the finish gate
    (searchsorted + frontier offset), RVM cross-check tol 3.

## 2.  Machine requirements

-  Disk:  >= 1TB FREE at the output path (output ~700-750GB +
    one transient shard ~80MB + OS margin).  A tmpfs or second
    volume for the transient downloads is NOT required.
-  CPU:  2+ vCPU (the decoder is single-threaded per shard;  the
    3e9 run was backgrounded on 2 usable cores).  4 vCPU is nicer
    for the numpy finish gate (a ~700GB fromfile needs a
    700GB read — RAM matters only transiently;  numpy streams, but
    32GB+ RAM avoids swap during the gate).
-  RAM:  16GB minimum, 32GB+ preferred (finish gate).
-  Network:  sustained access to beta.lmfdb.org (resumable
    `curl -C -`;  the loop tolerates 5 transient failures per
    shard with 120s backoff).  No other external dependencies.
-  Software:  python3 with numpy (decoder + gates);  curl;
    bash.  No Lean, no GPU, no packages beyond numpy.
-  Time:  the 3e9 band (476 shards, ~25GB output) streamed in
    about a day on 2 cores.  The 3e10 extension is roughly 9× the
    t-range;  at the same single-stream throughput expect
    order ~1-2 WEEKS wall (the script logs progress and an ETA
    every 25 shards;  the preflight prints the exact shard count
    from the live index at launch).  If a parallel download is
    attempted, do NOT parallelize the decode-append (it is a
    strict sequential append with the seam-count assert); keep
    exactly one decoder at a time.

## 3.  What to copy to the cloud box

1.  The whole `rh-missing-tail` git repo (or at minimum:
    `scripts/rh/` — the stream script, `day024_platt_fast.py`,
    `convert_shards.py` — plus this runbook).
2.  NOTHING else is required:  the resume frontier is a COUNT, not
    data — `FRONTIER_N = 9061794704` and the old band end
    `2999245999.862950` are hard-wired in the script (both pinned
    values of the day035 band finish).  The 3e9 band file itself
    does not need to travel (the new band starts fresh;  seam
    audit is by COUNT against the frontier, as in the 3e9 run).
    (For extra safety the 3e9 band end could be kept for a
    byte-level seam check — optional, not required by the gates.)
3.  The local md5 manifest `/tmp/zeta-dl/md5.txt` (14,580 entries)
    is OPTIONAL:  the script fetches the live manifest
    (`data/md5.txt`) at preflight and uses that.

## 4.  Launch

    cd rh-missing-tail/scripts/rh
    bash -n day035_3e10_stream.sh          # syntax check
    nohup bash day035_3e10_stream.sh >/dev/null 2>&1 &
    # then poll:  tail -f hi3e10/supervisor.log

-  Preflight 1 crawls the live LMFDB index, prints the exact shard
    count, and fails loudly if the range is not public (the
    `Cookie: human=1` header is what the 3e9 run used;  if LMFDB
    changes its gate the preflight FATAL says so).
-  Preflight 2 fetches the live md5 manifest and asserts every
    needed shard has an entry.
-  The loop is resumable:  kill at any shard boundary, relaunch,
    and `state.txt` skips the finished shards.

## 5.  Finish gates (built into the script)

-  total in (5e9, 1.5e11);  strict monotone;  min gap > 0;
-  seam gap:  first new zero − 2.9992e9 band end in (0, 1);
-  N(band end) vs RVM(band end) tol 3;
-  N(3e10) vs RVM(3e10) tol 3 — reached only if the public index
    actually reaches t = 3e10 (the script prints
    MAXIMAL-PUBLIC-EXTENSION + FINISH-GATES-PARTIAL otherwise —
    an honest outcome, not a failure).

## 6.  After the run (on the local box, when the band lands back)

1.  md5/manifest audit of the returned `hi3e10/` directory.
2.  The S3e machine (`scripts/rh/day035_s3e_3e9band.py`, band 3
    logic) re-pointed at the new band:  extends the sup|DN| pin
    from 2.4772 (to 3e9) toward 3e10 — THAT is the datum the next
    certificate tier consumes (END_GAME_PLAN 3.6, item 2 read).
3.  If N(3e10) is pinned:  the drift-law table gains its third
    decade (1e9 → 3e9 → 3e10);  update DISCOVERY_LOG + the
    ceiling report's Section 3 item 2 (the no-divergence read
    becomes data-backed to 3e10).
4.  NO Lean code changes are triggered by this run (nothing in
    the repository depends on it — see the script header's honest
    scope note).

## 7.  Failure modes and dispositions

-  LMFDB gate / cookie change  → preflight FATAL, no data written;
    fix the header (or the owner's LMFDB access) and relaunch.
-  Index does not reach 3e10 yet  → the run is still worth
    launching (maximal public extension + the gates);  revisit
    when the index grows.  (2026-09-20 live crawl: the index
    DOES reach 3e10 — to 3.0608e10 — so this risk is currently
    dormant;  re-run the preflight at actual launch.)
-  Disk fills mid-run  → the script FATALs on the next append;
    the band up to the last state.txt entry is a valid
    shorter-extension band (the gates can be run on it manually
    with the same python block).
-  Decoder Nt0 mismatch (seam assert)  → FATAL by design:  the
    count chain broke;  do NOT resume past it without an audit
    (the 3e9 run's lesson:  seam audit is the load-bearing wall).
