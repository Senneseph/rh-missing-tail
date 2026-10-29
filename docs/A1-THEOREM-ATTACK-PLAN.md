# A1 theorem attack plan — the data-free O(1) signed-defect bound

Status: prepared shelf for the goal window. Nothing in this file is a
date. Literature state below was fetched and pinned before the goal was
set; do not re-derive it from memory.

## State of play (E19 — end of the first goal window)

1. **The growth-form A1 is PROVEN (machine-checked).**
   `formal/RhAttack/A1Growth.lean` is green and imported into the root:
   from the classical pointwise input
   `|DN j| <= G (x j) + 1/(x j)` (G non-decreasing; the `1/(x j)` is the
   CITED RVM bridge residual, < 1 for x >= 2) the wire proves
   `|S1 - R| <= (G (x M) + 1) * (17/2) * t^2 / g1^2` on the far side,
   as a thin collapse to a global K over the already-proven
   `W2B3.a1_universal_wire`. Instantiations: `a1_growth_wire_log`
   (unconditional, G = C.log — CITED Backlund O(log t)) and
   `a1_growth_wire_ccm` (RH, G = (1/4) log/loglog + C1 correction —
   CITED CCM Thm 2; hG0/hGrow carried as explicit cited premises).
   Gates at landing: `lake build` green (17450 jobs),
   `lake exe rhattack` 14/14 PASS, 0 sorry in the module.

2. **The absolute-O(1) clause (hA1 as originally stated) is documented
   as OPEN and under strong pressure — not as a live theorem.** The
   online-verified pass (E19, S1-A1-EXPLORATION.md) establishes:
   no theorem gives |S(t)| <= C anywhere (all bounds grow); the omegas
   (Tsang; Bondarenko-Seip under RH) and the whole sqrt(loglog)-
   normalized distribution line (Selberg 1946 through the 2024-26
   follow-ups) contradict an absolute bound in the limit; the data's
   flatness to 3e10 is explained by the slow growth being numerically
   ~2 there (sqrt(loglog(3e10)) = 1.78; Omega scale 2.96; CCM RH main
   term 1.90 — all below the ruler). The attempted zero-specific
   refutation (Omega + gap-transfer) failed cleanly: the CCM
   increment bound swallows the Omega value (the transfer error / omega
   ratio -> infinity) — so the clause is NOT refuted pointwise; it is
   characterized and named.

3. **Effect on the decomposition chain (ap1..ap5):** the chain's
   bounded-bookkeeping atoms (ap4/ap5 — the kernel floors, the 17/8
   telescope, the tail bounds) are exactly what the growth wire reuses
   via `a1_universal_wire`; the argument-principle lemmas (ap1-ap3)
   remain the machinery for the classical S-identity side, which the
   project carries CITED (per the ZetaZeroSet convention) rather than
   reproved in Lean. If the absolute clause is ever re-attempted, the
   E19 evidence says the first move is not harder pointwise estimates
   but a zero-scale distribution/transfer theorem — e.g. a proof that
   the Bondarenko-Seip Omega values land O(1)/gap-away from zeros
   (falsifying O(1) at the zeros) or a Selberg-CLT-at-the-zeros
   statement (same effect). Both are the discipline's own frontier.

4. **Honesty boundary (unchanged, now sharper):** the paper claims the
   growth-form bound (proven, formal), cites the CCM/Inoue line as
   closest existing machinery, and files "absolute O(1) at all zeros"
   as the named open problem with the E19 evidence — never as
   claimed.

5. **0204 (2026-10-28): the clause's data side is now the S-at-zeros
   census itself, machine-checked, and the frontier is pinned.**
   (a) OBJECT IDENTITY IN-TREE: `formal/RhAttack/W2SAtZeros.lean`
   (root-imported, full tree 17452 jobs green) proves the exact core
   `rvmShiftCore` (the RvM +7/8 main term = the project RVM +3/4 main
   term + 1/8) and the conversion `sDefect_le_dnPlusShift`
   (|DN| <= K  =>  |S| = |DN - 1/8| <= K + 1/8).  The in-tree K = 262/100
   ledger (W2Beyond4, certified 3e10 domain) gives the first in-tree
   |S|-at-the-zeros bound: |S| <= 549/200 = 2.745; with the signed
   measured extrema it sharpens to |S| <= 2.490066528
   (`instSignedExtremaToSBound_3e10`).  The O(1/T) RvM remainder is
   CITED (< 1e-9 for T >= 1e9).  So "what the 0201/0202 censuses
   measured" and "S(gamma) at the zeros" are now the same in-tree
   object, exactly, not just documented.
   (b) GROWTH-FORM FLANK (`tmp/a1_sat_zeros_growth_fit.py`): the
   S-at-zeros running-max ladder (1.9851 -> 2.4901 over [1e7, 3e10])
   fits c*ln t + b (c = 0.0628, R^2 = 0.986); the proportional
   coefficient S/ln t drifts -16.2%, versus -33% for O(1)-flat,
   -12.8% for ln t/loglog t, -28.5% for sqrt(loglog t).  The data does
   NOT support O(1) and most resembles the ln t/loglog t (RH
   main-term) shape; sqrt(loglog t) under-predicts the top by -14.7%.
   Eight points cannot yet separate slow saturation from slow
   divergence; the next test is a higher-T census of dS/d(ln t).
   (c) FRONTIER PINNED (online-verified): Selberg's CLT (1946) is a
   GENERIC-tau statement (tau uniform in [T,2T]; the 2024-26
   follow-ups arXiv 2507.04150 / 2403.19803 / 2202.06799 all state the
   generic-tau form) — it is not a zeros statement.  Bondarenko-Seip
   (arXiv 1704.06158) gives, under RH, max|S(t)| >= c sqrt(log T
   logloglog T / loglog T) on [T^beta, T] — a generic-t omega with no
   zeros-vs-generic location claim.  With E19's failed gap-transfer,
   hA1 stays characterized and open from all three angles at once.

6. **0205 (2026-10-28): the flank's shape is now machine-checked in-tree.**
   The S-at-zeros ladder of the 0204 reading is pinned in
   `formal/RhAttack/W2SAtZeros.lean` (T1..T8 = {1e7, 3.1946e7, 1e8, 3e8,
   1e9, 3e9, 1e10, 3e10}; SL1..SL8 = the 0201/0202 sup|DN| ladder minus
   1/8, exact rational pins). Three shape statements:
   (a) `sLadderRising` - the running max strictly increases at every
   step (norm_num, no premises); by itself it contradicts any bounded
   (O(1)) S on the measured domain.
   (b) `sLadderConcaveInT` - the decade increment
   (SL i+1 - SL i) / (T i+1 - T i) strictly shrinks at every step
   (norm_num on exact pins, no premises): a pure-rational
   concavity-in-T certificate ruling out linear-in-T drift.
   (c) `sLadderSublnDrift` - the sharp sub-ln-t reading:  SL(T_i) /
   log(T_i) strictly decreases at every step (total drift -16.19%).
   Stated with eleven NAMED numeric premises (four decade-ratio log
   lower bounds via 3-term positive arctanh sums; seven log-upper
   bounds via exp brackets), each documented in the module docstring
   with its verified value and margin (lower margins 0.009-0.014,
   upper 0.18-0.97). Proving the eleven brackets in-tree is a named
   stretch goal (the project convention cites elementary
   transcendental numeric facts, cf.  the `hE : exp 1 < 4` cited input
   of `A1Growth.a1_explicit_wire`). No RH claim: this is the DATA side
   of the clause, exactly in the W2Beyond4 footing.
7. **0206 (2026-10-28/29): the eleven brackets are PROVED IN-TREE —
   `sLadderSublnDrift` is now unconditional.**  New module
   `formal/RhAttack/TransNums.lean` builds the exact-rational
   exp/Taylor machinery and proves all eleven numeric brackets of 0205
   with no premises: the seven log-UPPER bounds (`log T_i <= 17,18,
   19,20,21,22,24`) via `exp b <= finsum(N) + geometric tail`
   (`exp_eq_tsum_real` + `Real.tsum_le_of_sum_range_le` + a sharp
   induction with tail ratio `a/(N+2)`; truncation points give
   margins +10.5%..+46.8%), and the four decade-ratio log-LOWER bounds
   (`log 3 > 1.09`, `log (10/3) > 1.19`, `log (31946/10000) > 1.15`,
   `log (50000/15973) > 1.13`) via `exp b < rational` with N = 10
   (margins +0.86% / +1.39% / +1.14% / +1.11%), each closed by
   `norm_num` on exact rationals (pins: tmp/transcnums_pins.json).
   `W2SAtZeros.sLadderSublnDrift` now takes NO numeric premises: the
   sub-ln-t drift statement (S/log T strictly down at all seven
   steps, -16.19% total) is a fully in-tree certificate. The 0204-0206
   flank is therefore complete on the data side: rising (0), concave-
   in-T (0), sub-ln-t drift (0) — all premise-free, machine-checked.
   The board re-sweep of the same orbit (37 catalogue records, as_of
   2026-10-28) confirms the in-tree face (0.8739461) IS the board
   best — no new B6 candidate. The next named A1 discriminator is the
   data-free `|DN| <= K` / `hA1` theorem itself, with the higher-T
   census (dS/d ln t beyond 3e10) as the optional data flank.
   No RH claim: all of 0205/0206 is the measured/structural data flank
   of the A1 input.
8. **0207 (2026-10-29): the data-free wire constants are PREMISE-FREE
   and the A1 terminal face is QUANTIFIED at the frontier, in-tree.**
   The two CITED numerics of `A1Growth.pin_explicit_3e10` are retired
   into `TransNums` with the 0206 machinery (exact-rational norm_num,
   no premises): `log (3e10) < 25` (via 3e10 < finsum(25, 24) ≤ exp 25,
   finsum margin x1.136) and `log (log 3e10) < 4` (via log 3e10 <
   25 < exp 4, finsum(4, 7) = 16319/315 ≈ 51.81); plus the matching
   LOWER log bracket `24 < log (3e10)` (via exp 24 < 3e10,
   finsum(24, 27) + geometric tail = 2.875467e10, margin x1.043).
   New premise-free A1Growth theorems: `pin_explicit_3e10_free`
   (G_explicit 3e10 < 7) and `pin_explicit_wire_3e10_free`
   ((G_explicit 3e10 + 1)(17/8) < 17) — the data-free wire constants
   K < 8 and |S1 - R| < 17 at the frontier are now machine-verified
   END TO END, with the single remaining CITED input the Trudgian
   bound itself (A1G-5, literature, the named frontier). The terminal
   face is quantified in-tree (A1Growth section 7, pure rational
   pins, no premises): S-side, the certified measured pin |S| ≤
   2.490066528 at the 3e10 domain sits strictly below the data-free
   growth certificate (pin_face_S_3e10: < 7; pin_face_S_interval_3e10:
   < G_explicit 3e10 itself), so any absolute K valid on the measured
   domain must lie in [2.490066528, 7); wire-side, the measured wire
   cost 2.615066528 . (17/8) ≈ 5.56 sits strictly below the data-free
   cost < 17 (pin_face_wire_3e10, margin ~3x). `face_unbounded`
   (only the standard e < 4 classical fact as hE) proves G_explicit
   outruns every K — the face gap is the CONSTANTNESS of G, not a
   numeric: the absolute clause hA1 is the growth wire at constant G,
   no theorem in the literature supplies it (F1: best unconditional
   bounds are growth-form; F2: even the best conditional CCM bound
   under RH GROWS), and the in-tree data flank (0204-0206) shows |S|
   strictly rising at every ladder step, so the interval's lower end
   only grows with the data. The face is NAMED, NOT CLOSED; no RH
   claim.
   0208 SHARPENS the interval: the coarse 25/4 log brackets are
   replaced by the sharp frontier brackets log 3e10 < 24.2 (finsum
   margin x1.0234) and log log 3e10 < 3.2, pinning
   G_explicit 3e10 < 30081/5000 = 6.0162 (true value 6.0032 — within
   0.013 of sharp; the pin must be the EXACT bracketed sum, not a
   rounded cap, or the downstream wire inequality cannot close — the
   6.1-cap attempt died exactly there). The face interval is now
   [2.490066528, 6.0162) and the data-free wire constant sharpens to
   < 15 (596377/40000 = 14.909425 at the step).
9. **0209 (2026-10-29): the A1 grid clause is CLOSED DATA-FREE at the
   certified 3e10 frontier.**  Re-reading `W2Beyond3.a1_universal_wire`
   shows the assembly's clause is GRID-RESTRICTED by signature (one
   uniform K for the finite zero grid x 0 ... x M) - the 0204-0208
   'absolute at all zeros' framing quantified the STRONGER statement
   (the one lit. F1/F2 says is not a live theorem); the assembly
   consumes the grid clause, and the grid is the certified frontier.
   New A1Growth section 9: `dn_defect_to_sbridge` turns exactly the
   two standing CITED inputs - (A) Trudgian A1G-5 (|S u| <= G_explicit u,
   u >= e) and (B) the RvM identity with explicit residual
   |DN j - S(x j) - 1/8| <= 1/x j (Titchmarsh Thm 9.7; the 0204 object
   identity, its exact 7/8-3/4 shift in-tree via rvmShiftCore) - into
   |DN j| <= G_explicit (x j) + 1/8 + 1/x j; `a1_grid_clause_exhibit`
   exhibits the uniform K = 33206/5000 = 6.6412 on every grid point of
   [4, 3e10] (data-free end to end; the only external inputs are the
   two CITED theorems + e < 4 per module convention); and
   `a1_zerofree_frontier` carries the full wire through
   `a1_growth_wire` at the shifted growth G' = G_explicit + 1/8
   (NonDecrOn survives the shift: `nondecr_on_add`): |S1Sum - RSum| <=
   (G(3e10) + 9/8)(17/8) = 607002/40000 = 15.17505 < 16 on the far
   side. The external input surface of the entire data-free lane is
   now two peer-reviewed theorems + one one-line analysis fact. The
   STRONGER absolute clause (one K over all zeros, unbounded) remains
   NAMED and OPEN per 0207 (face_unbounded) - but it is NOT what the
   assembly consumes. No RH claim.

## The target (the one open clause)

The A1 assembly in `formal/RhAttack/W2Beyond3.lean`
carries a single open clause `hA1`: for every zero rho = 1/2 + i*gamma
of zeta, |S(gamma)| <= C with an absolute constant C (equivalently, in
wire form, |W(gamma)| <= C through the machine-proven 17/8 telescope).
That is the [S1] A1 gap. The data side (696/696 points filled,
cross-machine bit-identical, |D| O(1) to the wire;  the per-point
certification column of that fill was voided by a named and fixed
engine artifact during the forensics pass -- docs/
VALIANT-EFFORT-FORENSICS.md section 5 -- and is being re-issued) is
complete at screen level and is NOT an input to
this theorem: the proof is 100 percent symbolic.

Data tells us the constant lives around 1..5 (measured |D| values and
the margin decider), but the theorem must give an absolute constant
data-free, with no t-dependent growth.

## What the literature says (fetched and pinned)

1. **Unconditional S(t) = O(log t)** is von Mangoldt's classical
   bound, and "at present there is no unconditional improvement" on
   the general-t order of magnitude (per the CCM-line survey, arXiv
   2010.13307 context). LH would give S(t) = o(log t) (Cramer); RH
   gives the Littlewood order O(log t / log log t).
   - https://arxiv.org/abs/2010.13307 (explicit estimates for S(t),
     S1(t), zeta(1/2+it) under RH)
2. **Under RH, the sharp general-t bound is
   |S(t)| <= (1/4 + o(1)) log t / log log t** (improving Goldston-Gonek
   by a factor of 2; also a note giving a new simple proof of the
   sharpest known bound plus central-order-of-vanishing consequences):
   - https://arxiv.org/abs/1309.1526
   - https://arxiv.org/abs/1503.00955
3. **The exact target ("S at the zeros is O(1), all zeros, absolute
   constant") is not claimed in the fetched literature.** The closest
   active work is explicit extreme values of the argument in short
   intervals with applications to r-gaps (Inoue, arXiv 2510.14309,
   Cambridge Philosophical Society; improves Conrey-Turnage-Butterbaugh)
   and the Conrey-Ghosh line on mean values at critical points /
   relative extrema. None of these is the uniform O(1)-at-all-zeros
   statement. This matches the earlier E7 no-claim finding.
   - https://arxiv.org/abs/2510.14309
   - Conrey-Ghosh mean value at critical points:
     https://aimath.org/~kaur/publications/11.pdf
   - Conrey-Ghosh-Gonek large gaps (context for the S(t+h)-S(t)
     machinery): https://aimath.org/~kaur/publications/13.pdf
4. Consequence for honesty: the paper may cite the above as the closest
   existing machinery, state that the uniform O(1)-at-zeros bound is
   new, and (if the proof lands) give the first formal verification of
   a S-at-zeros bound of this specific shape. Do NOT overclaim against
   the Littlewood/RH order or the Inoue short-interval results; those
   are different statements (growth under RH at arbitrary t, and
   explicit short-interval extremes respectively).

## What exists in mathlib v4.33.1 (scouted, pinned)

- **Present:** `Mathlib/Analysis/Complex/Arg.lean` is the SameRay/arg
  file for REAL arguments (sameRay_iff, arg_div_eq_zero,
  norm_add_eq_of_arg_eq ...). `Mathlib/Analysis/Complex/Order.lean`
  exists (zero-order machinery area).
- **Missing / to be named (the honest gaps):** there is NO
  `argumentPrinciple` in Analysis/Complex, NO `windingNumber` anywhere
  in the pinned mathlib, and the complex-argument continuity
  statements (arg of a nonvanishing holomorphic function is
  continuous; additivity of arg over products off the branch cut) are
  not single named lemmas to import. These must be proved or pulled
  from `Data/Complex` + `Analysis/Complex` building blocks
  (Complex.arg, Real.arctan, continuousArg-type lemmas if present,
  Liouville/zero-multiplicity from Order.lean) as the first named
  lemmas of the decomposition.
- Scout commands for the goal (pinned path, no network):
  `grep -rn "arg" formal/.lake/packages/mathlib/Mathlib/Data/Complex/`,
  `ls formal/.lake/packages/mathlib/Mathlib/Topology/Homotopy/`.

## The decomposition chain (first-round plan, each lemma green-or-named)

Work down from hA1 into the argument-principle zero-sum:

1. **ap1 (zero sum).** For a zero-free vertical contour piece between
   consecutive certified zero brackets, the change of the continuous
   argument of zeta along [1/2 + i t0, 1/2 + i t1] equals the sum of
   the individual zero contributions plus the remainder — the
   argument principle in the strip, made quantitative. STATUS: named,
   first building block.
2. **ap2 (arg continuity and branch).** A named lemma: on a vertical
   segment avoiding zeros, arg(zeta(1/2 + i t)) admits a continuous
   branch, and the branch value changes by an integer multiple of pi
   only when a zero is crossed. (Fills the mathlib gap above.)
   STATUS: named.
3. **ap3 (per-zero contribution = S jump).** The jump of S across a
   zero of multiplicity m is m; the wire contribution W(gamma) at a
   zero is the sum of the short-range (local, in the unit-straddle
   neighborhood) plus long-range (everything else) parts.
   STATUS: named.
4. **ap4 (short-range O(1)).** The local piece is O(1) data-free:
   bounded by the machine-proven kernel/K_mil floors and the 17/8
   telescope already in W2M6/W2Beyond* (these are the green lemmas the
   proof hangs on). STATUS: partially green (reuses W2M6).
5. **ap5 (long-range O(1)).** The far piece is O(1) by the already
   formalized tail bounds (P4/P8/E2 machinery). STATUS: partially
   green.
6. **a1-close.** |S(gamma)| = O(1) with an explicit absolute constant;
   plug into hA1. STATUS: the assembly step.

The constant that falls out of ap4+ap5 may be large (the theorem is
the point; sharpness is a stretch goal). The data (C ~ 1..5) is cited
separately as measured context, never as an input.

## First-round tasks for the goal window (in order)

1. Read `formal/RhAttack/W2Beyond3.lean` around `hA1`; write down the
   EXACT current statement and assumptions (copy into this plan).
2. Green ap2 (the arg-continuity/branch lemma) from pinned mathlib
   building blocks; one lemma per rebuild, as per the W2M6 workflow.
3. Green ap1 (quantitative argument principle on the strip piece),
   reusing `Mathlib/Analysis/Complex/Conjugate`, `Zeta` and
   `ZetaZeroSet` already in the project.
4. Then ap3, then close the short/long split against the existing
   green tail lemmas (ap4/ap5), then the a1-close assembly.
5. Keep the B3/B5 cross-checks (`lake exe rhattack`) green at every
   stage; 14/14 PASS is the invariant.

## Shelf of fetched sources (for citations, not inputs)

- arXiv 2010.13307 — explicit S(t)/S1(t)/zeta estimates under RH.
- arXiv 1309.1526 — (1/4+o(1)) log/loglog bound under RH.
- arXiv 1503.00955 — simple proof of sharpest S(t) bound +
  central order of vanishing.
- arXiv 2510.14309 — Inoue: explicit extreme values of the argument
  in short intervals; r-gap application (CAM 2025/26).
- aimath.org/~kaur/publications/11.pdf — Conrey-Ghosh mean value at
  relative extrema (critical points).
- aimath.org/~kaur/publications/13.pdf — Conrey-Ghosh(-Gonek) large
  gaps; S(t+h)-S(t) context.

## The lateral frame (attack heuristic, owner-supplied)

The last hardest question in a discipline is usually blocked by the
discipline's own standing assumptions, not by a missing calculation.
Fifteen years-plus of S(t) work pushed the FRONT DOOR (harder and
harder estimates of the same function at the same points). Lateral
thinking changes what the question is about, before it pushes harder.

The red-hat puzzle structure (three logicians, red and blue hats,
silence-based inference: the first man says nothing, the second hears
that and knows, the third hears both silences and knows) is exactly the
shape of an argument-principle zero-sum proof: the value you cannot see
directly — |S| AT the zero, from inside the zero — is determined by the
global bookkeeping of what the contour CAN see (the winding number is
fixed by the zeros inside, the zero contributions sum to it). The hat
on your own head is readable from the consistency of everyone else's.

Consequences for the attack:

- hA1 is a red-hat-shaped theorem. Do not estimate S(gamma) directly at
  the zero (impossible — it is the discontinuity point). Read it from
  the zero-sum: ap1..ap3 are the "hearing the silences" chain, ap4/ap5
  are the bounded bookkeeping, a1-close is the third logician speaking.
- If a sub-lemma resists by brute force, the first move is to RESTATE
  it in the other idiom (S-form vs W-form vs signed-defect form) —
  the three forms are three hats; the one that goes silent often has
  the answer. The signed-defect form is what the data-side instrument
  found to be the legible one; expect it to be the legible one here.
- The constant may come out large the first time. That is fine: walk
  through the side door first, then look for a prettier door.

## Iron rule — Lean research order (v2, no holes, owner-issued)

Diagnosis of the 90-percent syntax-loss: the pin (v4.33.1) PRE-DATES
training memory, so "first use as expected" is often born wrong, and the
reflex after a mismatch became local .lake grep + probe loops (the
norm_pos_iff episode is the recorded instance). Local grep answers "what
exists", never "how to wield it" — that is the online half of the
answer. This rule has no "try from memory first" license.

For every Lean work session, serially, per build round:

1. TRIAGE FIRST. Read all errors of one build; group into distinct
   error categories. Fix exactly ONE category per rebuild cycle.
   (Cascade triaged before anything is touched; never a shotgun pass.)
2. For that one error category, RESEARCH IN THIS ORDER:
   a. web_search ONLINE FIRST — mathlib4 GitHub (source + issues),
      the mathlib4 docs, leansearch, Zulip, community ports
      (Zeta23 etc.). "I am fairly confident from training" is NOT a
      license to skip (a) — the pin is older than the training and
      memory is the known mismatch source.
   b. Corroborate the candidate answer in the PINNED local source
      (.lake/packages/mathlib v4.33.1) for exact name / signature /
      location. Local grep is CORROBORATION, not research.
      Hard limit: at most ONE local grep before the online search;
      a second needed local grep is the stop signal for (a).
   c. At-most ONE quick probe for behavior not readable from source or
      docs; then patch; then rebuild; then — and only then — the next
   error category.
3. Append each confirmed answer to references/LEAN4-4331-QUICKREF.md
   exactly once. The quickref is a fast path for ALREADY-CONFIRMED
   patterns only; it never replaces step 2 for a new pattern.
4. Borrowed patterns (community ports, Zulip snippets) are cited in
   formal/RH-LEAN-PROVENANCE.md / DISCOVERY_LOG at use time.

Invariants unchanged: lake build green, `lake exe rhattack` 14/14 PASS
at every green stage, no sorry.
