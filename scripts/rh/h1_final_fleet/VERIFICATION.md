# H1 3e10 fleet delivery — verification record

Fleet results received on the 10TB drive (`rh-final-data/`), consolidated
into this folder, and verified. The fleet's own `README.txt` and
`evidence/` are the machines' side-of-record, kept verbatim.

This folder previously held the earlier delivery (4090-box + first
5900x snapshot); this delivery supersedes the 5900x snapshot (the engine
kept running: its log grew and window-7 checkpoint completed) and adds
the v100 box, including the dedicated w18/w19/w20 re-issue instances.

## Verdict

> **CORRECTION (2026-09-29 forensics -- read this before the
> verdict below;  full record in docs/VALIANT-EFFORT-FORENSICS.md,
> section 5,  items f-g):**  the 696/696 claim,  and the
> recorded fact that *every* certified line carries mcert =
> 1.0000,  were the SIGNATURE of a deterministic assembly bug
> in the 3e10 engine (day037/day038),  not the result:  their
> quad_pair returns a nested remainder pair (ext over
> (G_LAST,1e30] containing rem's (G_LAST,1e18] range) and
> cert_point multiplies both into Kfull,  double-counting a
> region whose real part is -1.508628600e9 -- so Kfull rounds
> to 0,  residf = |z|,  and mnew = mcert = dev = 1 - 3.5e-9 on
> EVERY row,  every machine,  bit-identically.  The ledger
> rows record dev where a certified squeeze margin would have
> been;  the true worst-straddle margins are ~0.502 (CRT,
> via the unaffected day048/day049a adjacent-piece
> pipelines).  The fill remains valid at SCREEN level (point
> set,  nlt,  budgets,  flags,  machine replication);  the
> CERTIFIED claim is void.  Path:  re-issue on the fixed
> engine (two-line fix + the new |Kfull| ~ O(|z|) assembly
> selftest,  both committed);  CONFIRMED:  the verbatim
> pre-patch fleet module reproduces this ledger row to
> all 10 printed digits (mnew 0.9999999965,  residf
> 1.3075849021,  fingerprint Efull +1.508628600e9) and the
> patched module recovers the CRT-verified margin through
> the full fleet path (mnew 0.50265809882;  see docs/
> VALIANT-EFFORT-FORENSICS.md 5f-5g).  The re-issue (D2):
> the worst region is DONE (scripts/rh/day049f_...:  24 of
> 24 points,  margins 0.5023..0.5058,  all below 1,  exact
> cross-checks against the independent map and the bit-exact
> engine replica);  the IN-HAND ledger --  union of the three
> fleet sources,  deduped by (k,x) -- is 505 of the nominal 696
> points  (191 (k,x) pairs were never generated;  the fleet was
> shut down mid-run),  and the 505-point re-issue runs on this
> box via the fixed engine (scripts/rh/day052c_reissue_696_ledger.py,
> ledger-driven:  cert_point on the ledger's own (t,g) per point;
> a 24-point smoke against the deep day049f references gates the
> 14-of-16-core launch;  resume-safe).

**696 / 696 certified. Complete. No errors, no NaNs, no non-finite values.**

The full H1 universe (29 windows x 24 k-offsets) is machine-certified
across this folder. The three cert-gate exceptions noted by the 4090 box
are closed by the v100 box, and 466 points were independently certified
by at least two different machines with bit-identical values.

## Contents

- `4090-box/` — 8x RTX 4090 box. Per-instance engine logs a-h (slices
  spanning windows 0-28) plus `out_day038_full_pts.txt` (assembled
  full-precision straddle rows).
- `5900x/` — local 5900X + 3090Ti engine (windows 1-26 scope). Engine
  log (final state at delivery), supervisor log, and checkpoint `.pts`
  files (full-precision certified rows) for its first windows. The
  engine was still completing its scope when the delivery was cut.
- `v100-box/` — v100 box. Per-instance logs a-h plus dedicated w18 /
  w19 / w20 instance logs (the re-issue runs that closed the 4090
  exceptions), supervisor logs, node_a / node_b checkpoint `.pts`,
  assembled `_pts.txt`, and the box's own `manifest.md5`.
- `evidence/` — destroy verdict with band md5 chains, 5900x band md5
  records, Strix byte-identity chain, data-layout doc, fleet AGENTS rules.
- `MD5SUMS.txt` — this folder's checksum record.

## Checks performed

1. **Copy integrity.** Every file compared drive-side vs repo-side by
   md5: bit-identical. v100-box files additionally checked against the
   box's own `manifest.md5`: 28 / 28 OK.
2. **Cert-line census.** Every `pt win=... k=... mnew=... mcert=... bexp=...`
   line across all engine logs (4090: a-h, v100: a-h + w18-20, 5900x:
   full):
   - 4090: 693 lines, v100: 386, 5900x: 180.
   - **All lines carry `mcert=1.0000`. Zero lines otherwise.**
   - Zero non-finite or NaN numerics in any certified line or in any
     `.pts` file.
3. **Grid completeness.** Dedup by (t, k): **696 distinct points =
   29 windows x 24 k (k = -12..-1, +1..+12)**. Nearest-center clustering
   of the t-values gives exactly 29 windows, each with exactly 24
   k-values. No gaps.
4. **Cross-machine replication.** 466 points were certified by two or
   more different machines. For **all 466**, the logged t, mnew, and
   bexp agree bit-identically across machines (independent hardware:
   8x RTX 4090, v100, 5900X + 3090Ti). Zero disagreements.
5. **The 3 documented exceptions — closed.** The 4090 box logged 693 of
   696: exactly missing window 1 / k=-11 and window 18 / k=-5, k=-4 (its
   per-slice headers place these at global windows 1 and 18, x = 3.49e9
   and 1.292e10; the fleet README calls these cert-gate failures, not
   faults). The v100 box certified **exactly those three** (its dedicated
   w18/w19/w20 re-issue instances plus its main run), and its certified
   lines carry mcert=1.0000 like all others. Full-precision checkpoint
   evidence for the window-1 point (t = 3490744648.8185544014, k=-11)
   is present in `5900x/ckpt/widx00_x3490744654.pts`, consistent with
   the v100 certified line.
6. **Supervisor logs.** v100 supervisor logs: 878 / 878 flagged lines
   are benign lock-contention exits ("ANOTHER SUPERVISOR HOLDS THE
   LOCK"), zero data errors, zero rc-failures. 5900x supervisor log:
   three band-size/perm HOLDs, all from the pre-run 777-vs-555 FUSE
   permission saga; the engine ran afterward and its certified lines
   are present, i.e. resolved before any data was produced.
7. **Band provenance (from `evidence/`).** D-band (and A/B/C): md5
   chains byte-identical across 5900X, the 2x-RTX-PRO-6000 node
   (destroy verdict), and the 4090 volume. L-shards 11/11 against
   official LMFDB pins. Bands themselves are not part of this delivery
   by design (regenerable via `rh_fetch_data.py`, already 2-copy
   protected locally).

## What this folder does NOT contain (by design)

- The 814 GB band files (see above; md5-verified against local copies
  elsewhere).
- Full-precision `.pts` checkpoints for every point — the folder carries
  the checkpoint files that were on the boxes at snapshot time (5900x:
  first windows; v100: node_a, node_b, last instances). The
  authoritative per-point full-precision record lives in the boxes'
  checkpoint dirs and is regenerable (certified values are deterministic
  and bit-identical across machines, per check 4).

## Provenance

Source: 10TB exFAT drive, folder `rh-final-data/` (fleet snapshot cut by
the fleet agents; the fleet README states the snapshot is one where the
5900X engine was still running). Copied read-only; the drive directory
was not modified. All times inside the delivered logs are as-logged by
each box. The overlap with the earlier delivery (4090-box, evidence,
README, most 5900x files) was verified byte-identical before the two
5900x files were superseded by their newer snapshot versions.
