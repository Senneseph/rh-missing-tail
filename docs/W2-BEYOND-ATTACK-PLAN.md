# W2-BEYOND:  the uniform walk bound —  attack plan (DAY035)

**Status:  PLANNED.  Not started.**  The research item behind the
[S1] leg of the verification chain.  This document is the attack
plan;  the plan does not kick off the work (session stop rule).

## 1.  The exact target

The W2 telescope (formal/W2Telescope) defines the discrete walk

    DN(N0, Nas, j) = N0 + j - Nas j        (index j in the zero grid)

against the asymptotic count function `Nas`,  and has already

  * proven the telescoping structure (W2Telescope:  DP, DcSum,
    S1Sum, RSum,  the t1 / t2 / t3 channels),
  * proven the E1 / E2 / E4 floors (W2Bound:  e1_bound, e2_bound,
    e4_assembly,  e4_idnBound,  e4_wBound,  e4_tailFloor),
  * instantiated the pins (W2M5:  G1_pin = 1e7,  G2_pin = 2e9,
    K_pin = 2.503 = sup|DN| pinned on (1e7, 2e9],  L_pin = the
    explicit RVM slope bound log(G2 / 2pi) / 2pi,
    m5_floor,  m5_idn —  the walk bound enters the noise budget
    PARAMETERIZED by K_pin).

The target theorem (the [S1] leg,  uniform form):

    THEOREM (target,  stated data-adjacent).  There is an explicit
    constant K (data shape:  K ~ 2.5) such that on the verified
    domain,  sup_j |DN(N0, Nas, j)| ≤ K —  with the Lean form
    exactly the universal quantifier over the domain lifted off
    the W2M5 pins,  and the same telescope / floor machinery
    below it.

Two honest variants,  both legitimate targets:

  * **Domain-verified form**:  sup|DN| ≤ K with K explicit and the
    domain explicit (the 3e10 run lifts the domain from 2.9992e9
    to 3e10;  each run is a decision-maker,  not a proof).
  * **Universal form**:  sup|DN| ≤ K for ALL heights —  the
    research-grade claim (section 3 explains the classical
    constraint on this form).

## 2.  What the wire consumes

The S1 / S3 / S4 wire (S1LowT,  S4Asm,  M6) consumes the walk
bound in two places:

  * the W2 noise budget `w2noise` (W2M5.m5_idn):  the
    K_pin-weighted S1-channel sum plus the L_pin gap terms —
    replacing K_pin by a height-dependent bound is what the
    "T drops out" wire was built to absorb;
  * the squeeze margin (day030 measured):  the measured squeeze
    Bwire + Mr + Mf < flo carries an explicit slack that a
    height-dependent K eats —  the margin must be re-verified
    against any lifted K (the 25ae / 25af wire already separates
    the K-dependence from the |zeta| fill).

So the [S1] leg does not need "S for all t" in the literature
senses;  it needs:  an explicit,  Lean-checkable bound on
|DN| (or on the S1-channel sum) with a stated domain,  whose
residual the wire's measured slack can absorb.

## 3.  The classical constraint (HONESTY CORE)

On the zero grid DN measures  N(x) against the RVM main term —
the same object (up to the constant 7/8 and grid rounding) as
the classical argument function S(t) = (1/pi) arg zeta(i t)
minus its main terms:

    N(x) = RVM(x) + S(x) + O(1-convention),   RVM(x) =
    x/(2 pi) log(x / (2 pi)) - x / (2 pi) + 7 / 8

Consequences the plan must respect:

  * **Littlewood (unconditional Ω±)**:  S(t) is UNBOUNDED —
    |S(t)| reaches at least c (log t)^{1/2} (logloglog t /
    loglog t)^{1/2} along unbounded sequences.  A uniform
    O(1) bound on the CONTINUOUS S(t) is therefore classically
    REFUTED.
  * **Under RH (Littlewood)**:  S(t) = O(log t / loglog t) —
    slow growth,  but growth.
  * **Data**:  sup|DN| = 2.503 pinned on (1e7, 2e9];  2.4772 on
    (1e7, 2.9992e9] (S3e walk).  Littlewood's unconditional
    lower bound at 3e9 is of size ~3 (limsup flavor,  not
    pointwise) —  the data is consistent with a bounded
    DISCRETE/GRADED walk while the continuous function is
    unbounded;  the discrete walk (integer N0 + j at zero
    heights,  Nas sampled on the grid) is a coarser object.
  * The program's honest target is therefore the **graded walk
    bound** (domain-verified first,  universal second),  NOT
    "S(t) is bounded" —  which would be false.  Any universal
    form must be stated with the correct object (the grid DN,
    or a refined S with the lattice rounding isolated) or it
    misclaims.

## 4.  Attack routes (ordered by expected effort)

**R1 — data domain extension (ALREADY HANDLED).**  The 3e10
cloud run (scripts/rh/day035_3e10_stream.sh + docs/3E10-CLOUD-
RUNBOOK.md) extends the verified domain from 2.9992e9 to 3e10
(resumable,  md5-gated,  seam asserts,  RVM gate at 3e10).
Output:  a new sup|DN| pin K_3e10;  either the 2.503 shape
holds (the walk keeps its shape over another decade —  strong
evidence;  re-point S3e + re-pin W2M5 + re-run the full Lean
build) or it breaks (the break point IS the theorem — it
localizes the failure and the wire margin tells you the
budget).  No new research;  external compute;  running or
queued.

**R2 — per-step drift summation (the main candidate).**  The
walk changes by `1 - (local model increment)` at each zero:
DN_{j+1} - DN_j = 1 - (x_{j+1} - x_j) * Nas'(x_j) + (Nas
sampling error).  With Nas' = Rho(x) = log(x/2pi)/(2pi)
(explicit,  increasing on (0, ∞),  L_pin-bounded on
(0, G2] —  W2M5) and the zero gaps measured (the e2_bound / e4
family already bounds gap * Rho-type sums):  |DN_j - DN_{j-1}|
is an explicit small quantity with a summable tail —  so
|DN_j - DN_j0| ≤ sum of drifts,  and a uniform bound reduces
to an explicit series + a pinned start value.  This is the
route most likely to yield a Lean-checkable universal bound IF
the drift series converges fast enough at the measured gap
statistics;  the S3a / S4 certificate machinery (polynomial
certificates over the gap variables) is exactly the tool the
drift bounds need.
**Step 1 is now in Lean (W2Beyond0.lean,  GREEN):**  the
drift identity (`driftStep`),  the Rho monotonicity
(`rho_increasing`),  the MVT model-increment bound
(`nas_incr_bound`:  Nas b - Nas a ≤ Rho b · (b - a) on
[0, ∞) —  built on the W2K K3 derivative +  the pointwise
HasDerivAt form of Lagrange MVT,  `exists_hasDerivAt_eq_slope`
in the pinned mathlib),  and the per-step band (`driftBand`:
the step sits in [1 - S, 1] once the gap increment is
bounded).  The open content starts at the summation.

**R3 — kernel-decay (S1 channel direct).**  W2Telescope already
writes S1Sum - RSum as a kernel sum over the zeros (the t1 /
t2 /
t3 split).  A direct uniform bound on the sum via explicit
kernel decay + zero counting (the e1_bound floor already gives
one side;  the missing side is the positive tail) would close
[S1] without the drift route.  Likely harder than R2 (the
kernel tail is the hard part) but independent of gap
statistics.

**R4 — conditional explicit S estimates (fallback).**  Under
RH (or a bounded-S hypothesis),  Littlewood-Tao give explicit
O(log t / loglog t) bounds;  if the wire margin (section 2)
absorbs a height-dependent K(t) = C log t / loglog t (the
25ae / 25af wire was built for T to drop out),  the [S1] leg
closes CONDITIONALLY.  This is the honest fallback:  it would
make the whole chain RH + measured fills => RH (circular
unless the conditional is decoupled) —  so R4 is useful for
the MARGIN computation (how much slack the wire has for a
growing K) even if it cannot close [S1] unconditionally.

**Recommended order**:  R1 (external,  in flight) → R2 (the
Lean-checkable candidate,  builds on proven machinery) → R3
(independent backup) → R4 (margin analysis,  not a closer).

## 5.  Verification protocol (when any route yields a bound)

  1. Pin the bound as explicit rational/real constants in a
     W2M6-style module (norm_num-checked).
  2. Re-state the W2 telescope floors with the new bound in
     the noise budget (the m5_idn shape parameterized by K).
  3. Re-run the W2 / M6 / S1LowT / S4Asm / ZetaZeroSet build
     target set;  full `lake build` from formal/.
  4. Update CEILING-REPORT + this plan's status + the preprint
     (the [S1] leg line in ZetaZeroSet's leg map).
  5. NO RH claim unless the [S1] leg is closed AND the measured
     [S3/S4] fills are closed —  the front page
     (ZetaZeroSet.rhIfMarginZeta) is the single source of
     truth for what remains.

## 6.  Out of scope (this item alone)

  * A closed [S1] leg does NOT prove RH —  the measured [S3/S4]
    fills (the |zeta| fill + zero-side witness on the actual
    set) remain separate legs of the front page.
  * The "S(t) is bounded" statement (section 3) is NOT a target
    —  it is classically refuted;  misstating the object is a
    correctness bug,  not an open question.
