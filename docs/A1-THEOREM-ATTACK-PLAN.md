# A1 theorem attack plan — the data-free O(1) signed-defect bound

Status: prepared shelf for the goal window. Nothing in this file is a
date. Literature state below was fetched and pinned before the goal was
set; do not re-derive it from memory.

## The target (the one open clause)

The A1 assembly in `formal/RhAttack/W2Beyond3.lean`
carries a single open clause `hA1`: for every zero rho = 1/2 + i*gamma
of zeta, |S(gamma)| <= C with an absolute constant C (equivalently, in
wire form, |W(gamma)| <= C through the machine-proven 17/8 telescope).
That is the [S1] A1 gap. The data side (696/696 certified, cross-machine
bit-identical, |D| O(1) to the wire) is complete and is NOT an input to
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
