# H1 fill — analysis plan for the completed 3e10 696-point ledger

Where we are in the approach (references):
- END_GAME_PLAN.md 3.9/3.10 — the [S3/S4] fill grade was DECIDED as
  H1-FULL; this run is that grade on (3e9, 3e10].
- The pre-registered readings for an H1 certificate run are C-1/C-2/C-3,
  defined in the day034_h1cert.py docstring (inherited verbatim by
  day038 — its STATUS line prints them):
    C-1: margin_cert >= 1 at ALL grid points
         -> the extended band's [S3/S4] fill RE-ISSUES at
            certificate grade (the leg fills of
            ZetaZeroSet.rhIfMarginZeta become certificate-grade
            on the actual zero set, preprint Section 6 levels
            updated).
    C-2: margin_cert < 1 <= margin_computed at ISOLATED points
         -> budget-tight: reissue those points at dps-90/120 +
            1600 nodes; record the per-point decision.
    C-3: margin_computed < 1 at any point
         -> the screen claim fails at certificate level; the
            Phase-1a ceiling report at that point IS the
            deliverable (prize-plan P1.2(b)).
- The [S1] epsilon layer is already closed at A2-class (preprint
  post-data classification). A1 — the data-free analytic bound —
  is the ONLY open theorem (S1-A1-EXPLORATION.md); this analysis
  does not touch it, and no RH claim is made or implied at any
  step (the honesty note binds).

This plan is the BULLETPROOF procedure from "data arrives" to
"ledger analyzed, levels updated, archive committed".  Every step
is read-only with respect to existing data, idempotent, and gated
by a named checkpoint.  The merge tool pre-built and self-tested
for this plan: scripts/rh/h1merge_ingest.py (selftest mode passes
all 9 rules: union, dedupe, conflict-HALT, corruption-HALT,
torn-tail drop, widx99-only writes, idempotency, target/source
refusal, existing-diff HALT).

## Storage check (owner's question, answered)

Incoming = per-window ledger rows only: ~13-19 windows x 24 rows x
~260 B per machine = well under 1 MB per machine.  Assembled
696-point ledger ~ 180 KB.  This box has ~395 GB free.  Five
orders of magnitude of headroom; the incoming data will not come
close to storage limits.
NOTE (load-bearing): the ~815 GB band data is EXCLUDED from the
transfer (this box is its source of truth — see
H1-LEDGER-TRANSFER.md); it also would NOT fit (740 GB single file
vs 395 GB free), so the exclusion is not just faster, it is
required.

## Data safety invariants (all steps)

  S1. Source ledgers (this box's ckpt_h1_3e10/*.pts; incoming
      copies) are opened READ-ONLY by every step; nothing is
      renamed, truncated, or written into them.
  S2. The 740 GB band file stays read-only (a-w) and is never
      rewritten by this plan; the D move / 10 TB drive are not
      touched.
  S3. The only files created are widx99_* files (the merge
      tool's namespace, verified to be the engine-visible glob)
      plus documents under results/ and docs/.
  S4. Every merge run prints a manifest and is idempotent:
      re-running on unchanged sources writes nothing
      ("identical (no write)").
  S5. Any divergence between machines on the same (x,k) HALTS
      (exit 2) — the plan never silently picks one row.
  S6. Missing points are never papered over: the final engine
      launch must print 24/24 for all 29 windows by its own
      resume banner; a short window is H1 INCOMPLETE (exit 4),
      visible, and is relaunchable (this box's engine recomputes
      exactly the missing k's).

## Step 0 — preconditions (minutes)

  Run on this box:
    python3 scripts/rh/h1merge_ingest.py selftest     # expect PASS
    git -C /home/jsmille/Projects/rh-missing-tail log --oneline -3
      # engine must be at or after commit e180eae (cross-slice
      # resume — the union-by-x scan the final assembly relies on)
  CHECKPOINT 0: selftest PASS; engine commit present.

## Step 1 — receive (per machine, when its run is FULL-DONE)

  Execute H1-LEDGER-TRANSFER.md (rsync of ckpt_h1_3e10/*.pts +
  the three provenance logs into ~/Projects/rh-missing-tail/
  incoming_5900x/ [and incoming_monster/ for the cloud instance])
  and its md5 round-trip.
  CHECKPOINT 1: md5sum -c all OK; census (step 2) lists the
  machine's windows.

## Step 2 — census (read-only, seconds)

    python3 scripts/rh/h1merge_ingest.py census \
      scripts/rh/ckpt_h1_3e10 \
      incoming_5900x/ckpt_h1_3e10 \
      incoming_monster/ckpt_h1_3e10        # include each dir that exists
  Read the report: per x, how many k, and which machines carry it.
  CHECKPOINT 2 (human read): the union of the census rows covers,
  per x, the expectation; windows owned by two machines appear
  with coverage from both (their byte-for-byte comparison happens
  at step 4, here we only see counts).

## Step 3 — dry-run merge (no writes, seconds)

    python3 scripts/rh/h1merge_ingest.py ingest \
      scripts/rh/ckpt_h1_3e10 \
      incoming_5900x/ckpt_h1_3e10 \
      --target scripts/rh/ckpt_h1_3e10 --dry-run
  (One ingest per source added is fine; the tool is idempotent.)
  CHECKPOINT 3: manifest lists one line per window x; every line
  24/24; no NOTE about incomplete windows; and no conflict HALT
  (a conflict HALT = STOP, investigate code versions / band
  files — two independent certified runs disagreeing is a
  signal, never noise).

## Step 4 — merge (writes exactly the widx99 files)

    python3 scripts/rh/h1merge_ingest.py ingest \
      scripts/rh/ckpt_h1_3e10 \
      incoming_5900x/ckpt_h1_3e10 \
      --target scripts/rh/ckpt_h1_3e10
  CHECKPOINT 4: manifest "written" for the supplied windows
  (12-18, 24-26, whatever the census said); "identical (no
  write)" for already-complete local windows; the source
  ledgers on both machines are untouched (step 2 census totals
  are the before-image; re-census sources after and compare).
  Cross-check result (record for the analysis): every (x,k) that
  two machines carried must have arrived here byte-identical
  (that is what the absence of a step-3 conflict HALT means);
  note it in results/ as the independent-recomputation
  cross-check, per the standing cross-implementation doctrine.

## Step 5 — final full-grid assembly (engine, ~10-15 min)

  On this box, with NO H1_WINDOWS set:
    nohup bash scripts/rh/day045_h1_supervisor.sh >> scripts/rh/out_day045.log 2>&1 &
  Expected behavior: the resume scan prints 24/24 for ALL 29
  windows (its own 19 local windows from their files, the
  supplied windows from the widx99 union — the cross-slice scan
  keys on x, verified in the banner); the job list is EMPTY
  ("FULL, 0 point jobs remaining"); the assembly writes
  out_day038_full_pts.txt with 696 rows and prints
  "H1 FULL-DONE: 29 windows, 696 points"; supervisor exits rc=0.
  If the banner shows a window short of 24/24: that window's
  rows are missing/insufficient — relaunch is safe (the engine
  recomputes exactly the missing k's); do not proceed.
  CHECKPOINT 5: the 29x24 banner + "FULL, 0 point jobs
  remaining" + H1 FULL-DONE line + rc=0.

## Step 6 — the pre-registered reading (the analysis proper)

  From the assembled ledger + the engine summary block:
  1. C-read: apply C-1/C-2/C-3 to the 696 points exactly as
     pre-registered (the STATUS line names the branch; the
     summary table gives worst margin per window).  Record the
     reading + worst points in results/.
     - C-1 -> the [S3/S4] fill on (3e9, 3e10] is certificate
       grade; preprint Section 6 levels update to that grade.
     - C-2 -> list the isolated points; reissue them (dps-90/120
       + 1600 nodes) as a small targeted run on this box;
       re-apply the reading on the re-issued rows.
     - C-3 -> ceiling report at that point becomes the
       deliverable; stop and meet on the read.
  2. Statistics (all 696): min/typ of margin_cert and
     margin_new per window and global; worst-10 points table;
     bexp/residf profile by window (the Efull watch item from
     the S1 sweep verdict); the assembled file already carries
     one row per straddle for all of it.
  3. Cross-check record: which windows were double-certified by
     two machines and that the rows byte-compared identical
     (step 4's silent pass); the provenance logs (which machine,
     which code commit, which resume chain) for every window —
     the ledger is now reproducible machine-by-machine.
  CHECKPOINT 6: reading recorded with numbers; worst-10 table
  in results/.

## Step 7 — update the proof documents (honest, no RH claim)

  - results/3E10-H1FILL.md: the analysis (reading, stats,
    cross-check, provenance).  [repo: proof output — belongs]
  - docs/CEILING-REPORT-DAY035.md is NOT rewritten; a new
    re-issued ceiling / results note cites it (corrections as
    appended sections, never rewrites).
  - docs/PREPRINT-DRAFT-DAY035.md: post-data addendum only, per
    its binding honesty note: the [S3/S4] fill grade on the
    extended band is now stated at the level the reading
    allows; [S1] A1 remains the open theorem; no RH claim.
  - docs/END_GAME_PLAN.md: appended section 3.11 — "the H1-full
    fill landed" with the reading and pointers.
  CHECKPOINT 7: documents committed (locally; push only on
  owner authorization).

## Step 8 — archive (no deletion, ever)

  - incoming_5900x/ and incoming_monster/ stay on disk
    (untracked data; the md5 manifests travel with them).
  - The widx99 files stay in ckpt_h1_3e10/ (they are now part
    of the certified ledger's history; the final assembly
    re-reads them).
  - results/ artifacts committed with the documents.
  CHECKPOINT 8: git status shows only documents/results; data
  directories untouched.

## What this plan does NOT do (kept out on purpose)

  - No attack on [S1] A1 (the data-free analytic epsilon bound)
    — that is the separate research theorem with its own plan.
  - No re-run of the day036 band finish gates as a prerequisite
    (they gate the D band file, which this plan never touches;
    they last passed on the unchanged file).
  - No changes to the 5900X or the cloud instance; no pushes.

## INTERIM STATE addendum (appended: analysis in flight, not the final read)

Added as the standing addendum for the in-flight analysis, per the
corrections-as-appended-sections discipline.  The body above remains
the as-planned record.

### Checkpoint state

- CHECKPOINT 0/1/2 DONE.  Preconditions verified (selftest PASS,
  engine >= e180eae).  The fleet delivery arrived from the 10 TB
  drive (not the LAN rsync of step 1, which is superseded): it lives
  in-repo at scripts/rh/h1_final_fleet/ (4090-box/ = 8 instance
  logs + one assembled ledger; 5900x/ = snapshot ckpt files + logs;
  evidence/).  The 4090 cloud box was then destroyed by the owner
  AFTER that delivery was pulled (nothing further can come from
  it); the final 696-point grid remains fully coverable without it
  (cloud box re-rented on the 9-26 slice; 5900x stands on 1-26).
- Read-only census over the three in-repo sources (Strix live
  ckpt_h1_3e10 post NaN-row surgery; the 5900x snapshot; the 4090
  assembled ledger): 505 distinct (x,k) points in hand =
  20 windows complete at 24/24 (windows 0-11, 19, 21, 22, 23,
  25, 26, 27, 28) + window 20 at 21/24 + window 12 at 4/24
  (the 4 rows are window-12's first four k's, k = -12,-11,-10,-9,
  written by this box's stopped 12-18,20,24 run before it halted
  — the cross-slice resume union will recompute exactly the
  missing 20).  By source: 456 this-box, 1 the 5900x row that
  heals window 5's removed NaN point (k = +12), 48 the 4090
  assembled new windows (25, 26).  Zero parse failures, zero
  corruption, zero torn tails.

### Interim pre-registered reading (PRELIMINARY — not the CP6 verdict)

On the 505 points in hand: C-1 does NOT hold (margin_cert below 1
at 254 points); C-2 does NOT fit (the shortfall is systematic,
half the grid, not isolated); C-3 fires verbatim (margin_computed
below 1 at many points) — whose deliverable, by the pre-registered
wording, is the re-issued ceiling report carrying the explicit
epsilon.  The honest interim statement: on (3.2e9, 2.8e10] in
hand the computed margin sits at 1 to within ~4e-9, with sign
structure in the straddle offset (see the drift law below); the
window-20 gap and windows 12-18/24 remain pending the fleet.

The CONSTRUCTIVE finding behind the reading (the confirmed
structural law, fit over all 505 points):

    margin(x, k) - 1  ~=  A(x) * k,   A(x) ~ (1.005 ... 1.019)/x

- per-k means: delta(k)/k = 1.42e-10 (window 0) falling to
  1.42e-10... precisely: A(x) rises weakly in x, A*x = 1.0057
  at x = 3.2e9 to 1.0188 at x = 2.8e10.
- oddness: mean of [delta(k) + delta(-k)] at the same x =
  -3.6e-11 +/ 6.2e-11 (n = 249 paired points) — the drift is
  odd in the straddle offset to within the residual scale.
- per-window linear fit: residual RMS 4.6e-11 vs raw delta RMS
  1.25e-9 — one k-linear term explains 96.4% of the variance;
  the offset term b fits at -1.8e-11 ~ 0.
- worst in-hand point: x = 3.23e9, k = -12, margin 0.9999999963
  (all ten worst points are k = -12..-9 in the low windows;
  the top points are k = +12..+9 at 1.0000000037).
- cross-machine: the drift appears identically in every source
  (all 4090-box FULL-DONE instance logs list every straddle of
  every window under their margin_new < 1 headers; Strix logs
  match; the 55 known cross-machine differing pairs remain
  3-sig-fig tail-budget noise with margin fields byte-identical)
  — it is the object, not an artifact.
- The certified margin (mcert) prints identical to the computed
  (mnew) at all ten digits on these points: the certificate
  budget is below print precision; the explicit epsilon for the
  re-issued ceiling is the measured drift amplitude (~1.01*12/x
  at the window edge, decaying in x).

### 3e9 ledger re-audit (done during the docs audit)

- out_day034_h1cert_b.txt = 936 rows = 39 windows x 24 straddles;
  global min margin_cert = 1.0816362118 at t = 1000000001.61565
  (the 1e9 window) — matches the recorded worst figure to the
  printed digit; 0 rows with margin_cert < 1 and 0 with
  margin_computed < 1; the single FLAG row is the budget-width
  flag (dmin < NLT_GUARD, the 1.3e8 window, margin ~101), already
  recorded honestly in PHASE1A-CEILING section 4.  The C-1
  reading on (1e6, 1e9] stands.
- Grid-count reconciliation: both 3e9 engines exclude the k = 0
  straddle (t = g is singular in R_closed's denominator); the
  executed grid is 24 straddles per window everywhere.

### Stale-number catalog (cosmetic; no conclusion affected)

The planning text "25 straddles per window" survived the
implementation (24 everywhere).  Stale figures located during the
audit, all superseded by the executed grids (3e9: 39 x 24 = 936
points; 3e10: 29 x 24 = 696 points):
- END_GAME_PLAN.md: header "975 points"; 3.9(b) "25 straddles per
  window"; 3.10(b) "29 windows / 725 straddles".
- PHASE1A-CEILING.md: section 2 "2250 grid points (90 windows x
  25 straddles)"; section 4 "39 windows x 25 straddles = 975",
  "all 975 points OK".
- KNOWN_LIMITATIONS.md: H1 entry "39 windows x 25 straddles =
  975", "all 975 points certified".
- PREPRINT-DRAFT-DAY035.md: "2250-point sweep to 10^9" (the
  day029 screen sweep description).
Proposed fix (owner's call): one short correction addendum in
each of the four docs, append-only, no body rewrites.  The
readings, worst margins, and C-branch verdicts in those docs are
VERIFIED CORRECT against the actual ledgers; only the grid counts
are stale.

### Open scientific questions for the final session (data in hand)

1. The margin-offset path through (1e9, 3e9): certified 1.0816 at
   1e9 -> screen-grade "hovering 1-4 above" near 1.95e9 (END_GAME
   0) -> 1.0000+/4e-9 at 3.2e9 (3e10 band).  Non-monotone: the
   residf/(zeta*dev) ratio wanders before settling at 1.  Pin it
   from the screen logs; the 3e10 drift law (A ~ 1/x, odd in k)
   is the 3e10-band statement of the settled regime.
2. The weak x-dependence A*x = 1.0057 -> 1.0188 across the band:
   refine on the full 696 (and decide the exact drift law:
   A*x = 1 + c*ln(x/x0)? fit once all windows are in hand).
3. Numerical-vs-structural split of the 4e-9 drift: the C-2
   prescription (dps-90/120 + 1600 nodes) re-issue of the ten
   worst negative-k points — queued, owner's GO.
4. Window 18's two known cert-gate misses (k = -5, -4, from the
   destroyed box): the re-run will show deterministic vs
   run-specific — recorded as C-2 reissue candidates if they
   recur.

### Lean audit (same pass)

- formal/ `lake build` GREEN: 17,442 jobs — matches every doc
  claim verbatim (Lean 4.33.1 + mathlib v4.33.1).
- The single open theorem's site (W2Beyond3.lean, a1_universal_
  wire / a1_universal_o1, the hA1_0/hA1M/hA1 hypotheses) is
  EXACTLY the E1/E13 description: the pointwise data-free walk
  bound |DN| <= K on the zero grid, with the kernel constant
  17/8 closed and G2 dropped out.  No mistranslation found at
  the open-theorem site; the E2Barrier pins (2.615067 /
  31,047,116,350.923088) match the certified data layer.

### Next gate (unchanged by the above)

When the cloud (9-26) and the 5900x (1-26) ledgers land: CP3
dry-run merge in the staging target (never into the live ckpt
while a run could resume) -> CP4 real merge, with the one
owner-visible conflict decision for the margin-identical
3-sig-fig tail-noise class (55 known pairs + any same-box
duplicates) -> CP5 full-grid engine assembly (29x24 banner) ->
CP6 the final C-read over 696 -> CP7 document updates (this
plan's step-7 list, the corrected counts included) -> CP8
archive, no deletion.
