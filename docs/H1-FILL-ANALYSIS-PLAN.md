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
