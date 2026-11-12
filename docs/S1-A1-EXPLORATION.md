# S1 / A1 — an exploration log (the universal walk bound)

A working log for the open [S1] research item:  the universal
(analytic) version of the graded walk bound.  Written to be read:
each entry states what was tried,  what fell out,  and the verdict.
The full derivation always lives in the working session's log;  this
file carries the ideas and their status.

Log conventions:

-  APPEND-ONLY.  Entries are numbered E1,  E2,  ...  and never
  rewritten (corrections append,  per the project discipline).
-  Each entry ends with a verdict tag:  **DEAD** (the route is
  refuted —  the refutation is recorded),  **ALIVE** (it holds,
  and is load-bearing),  **QUEUED** (not yet attempted),  **OPEN**
  (attempted,  unresolved).
-  No dates in this file (house rule;  git history and
  DISCOVERY_LOG.md are the timestamp authority).

## 0.  The objects,  exactly (reference,  no verdict)

-  The walk:  `W2T.DN N0 NasGrid j = N0 + j - NasGrid j` (the zero
  count against the RVM asymptote,  on the zero grid,  left-endpoint
  convention,  `W2Telescope`).
-  `W2Beyond0.driftStep`:  the walk step is exactly
  `1 - (Nas(i+1) - Nas(i))` (definitional).
-  `W2Beyond0.nas_incr_bound` / `W2Beyond1.nas_inc_band`:  the RVM
  increment over a gap [x, y] sits in `[Rho x (y-x),  Rho y (y-x)]`
  (MVT + Rho monotone) —  the per-gap model increment against the
  measured gap.
-  `W2Beyond1.driftTelescopes`:  the walk displacement over a band
  is exactly the signed sum of the per-step drifts.
-  `W2Beyond1.driftRegimeLe / driftRegimeGe`:  one-sided regimes
  (every increment <= 1,  or >= 1),  the displacement is exactly
  the (mirrored) drift sum.
-  `W2Beyond1.driftTwoSided`:  if every per-gap increment
  satisfies  `|Δ_i - 1| ≤ ε_i`,  then  `|DN(j) - DN(0)| ≤ Σ ε_i`
  —  the R2 reduction.  (Triangle inequality:  this is the ABSOLUTE
  sum majorant;  the signed sum is the walk itself by
  `driftTelescopes`.)
-  The wire's consumption of the walk bound (`W2M5.m5_floor`,
  `m5_idn`;  END-GAME 3.6):  the noise budget carries
  `K (|p G1| + |p G2| + TV(p))` —  K = sup|DN| as a POINTWISE band
  constant multiplied by the log-kernel's total variation over the
  band (TV ~ log(G2/G1),  O(1) per log-decade).  The wire wants K
  at the data shape (K ~ 2.5),  not a K growing in the band.
-  The A2 record on the 3 x 10^10 band (the certified data layer):
  per-gap  `eps_i = |n_asym(t_{i+1}) - n_asym(t_i) - 1|`,
  `SUM_EPS_CERT = Σ eps_i + (1e-4 per gap f64 budget)`
  = 31,047,116,350.923088,  so  sup_k |DN(k) - DN(0)| ≤
  SUM_EPS_CERT  on the band from the pinned DN(0).  Against the
  MEASURED walk:  sup|DN| = 2.615067 on (10^7, 3 x 10^10].  The
  certified majorant is the walk's TOTAL VARIATION —  about
  10^10 times looser than the amplitude.  Eps per zero ~ 0.335.

## E1.  A1 restated —  the target is "S is bounded AT THE ZEROS"

Verdict:  **ALIVE (relocated)** —  A1 is not "sum the epsilons
better";  it is a theorem about the S-function sampled on the zero
grid,  and it is not known to be false.

What was tried:  a plain-language restatement of the preprint's A1
clause ("the per-gap eps admit an ANALYTIC bound without data").

What fell out:

1.  The equivalence.  At a zero γ_n of zeta on the critical line,
    `DN(γ_n) = N(γ_n) - N_as(γ_n) = n - N_as(γ_n)` (integer minus
    asymptote).  The classical argument function at zeros is the
    SAME object up to fixed convention constants (the 7/8-vs-3/4
    shift,  of size 1/8,  and the ±1/2 grid rounding between the
    step count N and the continuous arg —  the W2-BEYOND-ATTACK-
    PLAN section 3 says exactly this:  "the same object  (up to
    the constant 7/8  and grid rounding)").  So a data-free uniform
    bound `sup|DN| ≤ K  (K ~ O(1))` on the zero grid IS,  up to
    O(1) convention,  the statement  **S(γ) = O(1) for every zero
    γ**  —  the S-function bounded AT THE ZEROS,  unconditionally.

2.  Why Littlewood does not kill it.  Littlewood's unconditional
    Ω± theorem refutes the boundedness of the CONTINUOUS S(t)
    (|S(t)| reaches the classical Ω-flavor lower bound along
    unbounded sequences).  But the zeros are a DISCRETE sample of
    the t-line:  the Ω-value sequences need not hit zero heights,
    and no known theorem samples the Ω at the zeros.  The plan's
    "coarser object" note is exactly this:  the data (1.0164 x 10^11
    graded samples,  all ≤ 2.615067,  while the continuous S reaches
    log-scale amplitudes) is consistent with  S tame at zeros /
    wild between zeros —  which the function shape allows (S has
    steep gradients across gaps near the fast-arg regions).

3.  The honest status.  No unconditional "S at zeros is O(1)"
    statement is known to the author of this log (literature check
    is E3.2 —  do not treat this restatement as the literature's
    verdict before it runs).  The statement is not the target any
    more than the continuous form is:  it is one of the S-t
    territory the classical constraint marks.  It is,  however,
    the exact shape [S1]-universal asks for,  and it is at least
    not classically refuted (to be confirmed against the RH-
    conditional Ω —  E3.2 item:  do the RH-conditional Ω sequences
    land at zeros?).

Bottom line:  A1,  pursued as "an analytic per-gap envelope whose
sum closes",  is the wrong object —  read E2.  A1,  pursued as
"a theorem bounding the graded walk pointwise (equivalently:  S at
the zeros)",  is the real research problem,  and every route below
must be checked against it.

## E2.  The absolute-sum barrier on the R2 route

Verdict:  **DEAD as a universal closer;  ALIVE as the domain-
verified (A2) engine** —  which is what it has been all along.

What was tried:  checking whether the preprint's A1 clause (analytic
per-gap eps,  data-free eps sum) can deliver the K ~ O(1) pointwise
bound the wire needs,  using the R2 machinery (`driftTwoSided`).

What fell out —  four facts:

1.  **Signed sum = tautology.**  By `driftTelescopes`,  the signed
    sum of the drifts over any band IS the walk displacement
    (count minus asymptote increment).  No cancellation is available
    in the signed sum beyond what the walk already is.  Any
    "summation" argument for A1 must therefore work through
    absolute values,  or through structure the tautology does not
    see (E3.4).

2.  **Envelopes must dominate the truth pointwise.**  The
    `driftTwoSided` hypothesis is  `|Δ_i - 1| ≤ ε_i`  for EVERY
    zero i.  Any data-free envelope  f(t_i)  valid at all heights
    must satisfy  f(t_i) ≥ |Δ_i - 1|  at every zero —  and over any
    band  Σ f ≥ Σ|Δ_i - 1|  (the walk's total variation).

3.  **The total variation is LINEAR in the zero count (measured,
    our own record).**  On the 3 x 10^10 band the certified
    per-gap sum is SUM_EPS_CERT ≈ 3.1047 x 10^10 over
    92,577,877,714 zeros —  eps per zero ≈ 0.335 —  while the walk
    amplitude is 2.615067.  The per-gap |drift| does NOT tend to 0:
    a typical zero gap is the local RVM-mean gap plus an O(1)
    RELATIVE fluctuation (gap ≈ Rho^-1 (1 + ξ),  ξ = O(1)),  so
    the typical |1 - model increment| ≈ |ξ| = O(1) —  the Poisson/
    GUE gap-fluctuation scale.  The certified A2 sum IS this total
    variation,  to the certified digit.

4.  **The formal-unconditional version needs one modest open
    fact.**  Turning fact 3 from measurement into theorem needs
    "a positive density of non-typical gaps" (gaps not
    concentrated at the RVM mean).  Classical results give
    liminf-flavor small-gap statements (infinitely often,  density
    unknown) —  the density fact is open (it predicts fully under
    the GUE gap model).  So the barrier is:  **measured-certain
    on the verified band (fact 3,  certified),  formal-pending-
    the oscillation fact (fact 4).**

Consequence (the barrier,  stated):  the R2/driftTwoSided
mechanism,  on ANY band with N → ∞ zeros,  gives at best
`|DN(j) - DN(0)| ≤ K₀ + Σ f  ~  c · N`  for any valid pointwise
envelope f —  and with only CLASSICAL worst-case gap bounds (no
data at all) the envelope is far worse still (gap ∈
[c (log t)^-a,  C log t] classically  →  per-gap envelope
O((log t)^2)-ish via `nas_inc_band`).  A K ~ 2.5-pointwise bound
is not obtainable from this mechanism,  at any height,  by any
data-free f.  The preprint's A1 clause,  read literally
("the eps sum has a data-free form"),  yields a GROWING bound
K(T) ~ c T / log T —  which the wire absorbs only in the R4 sense
(margin bookkeeping with a height-dependent K,  not a closer).

What survives:  `driftTwoSided` is exactly right as the
DOMAIN-VERIFIED engine —  pin the start,  certify the per-gap sum
over a finite band,  done (that is A2,  and it is what the 3e10
data layer delivered).  Its universal form degenerates to a
linear majorant.  The universal closer,  if one exists,  cannot be
an absolute-sum theorem.

## E3.  Queued (not yet attempted)

**E3.1 — H1,  the tail-split architecture hypothesis.**  The wire
does not need ONE mechanism over (1e7, ∞):  it needs a POINTWISE
`sup|DN| ≤ K` on the band it integrates.  Split the band at a
FRONTIER F:  the base (1e7 → F) is the A2 domain-verified pin
(pinned ONCE,  F arbitrary);  the tail (F → ∞) is where the
telescope's kernel p does the work —  the boundary term
p(x) DN(x) and the integral of DN p' beyond F,  against the
CLASSICAL (unconditional) S-bound  DN = O(log t) (the END-GAME
3.5 item 2 line:  "sup|DN| = O(log t) ... gives the classical
ceiling").  If p decays fast enough that  p(x) log x → 0  and
∫_F^∞ |p'(x)| log x dx  converges,  then the tail is a classically
computable constant C_tail(F → ∞),  and the universal walk bound
becomes  `sup|DN| ≤ max(K_F (pinned data),  C_tail (classical))`
—  an explicit FRONTIER-INDEPENDENT constant needing one data pin.
That is A1 in spirit (data-free beyond the pin) and honest in
form (the pin is a named hypothesis,  the W2M5 pattern).  Test:
the exact S3c log-kernel form of p(g;t) as g → ∞ (its decay rate
and that of p') versus O(log t) —  if the naive bound diverges
(e.g. a loglog tail),  the missing side may already be one of the
e1/e4 one-sided floors (plan R3:  "the missing side is the
positive tail").  ALIVE candidate for the actual [S1] landing
shape —  pending the kernel check.

**E3.2 — Literature pass (references-first,  per standing
directive).**  (a) The exact Littlewood forms:  the unconditional
Ω± (which of the classical shapes —  the plan's section 3 cites
one;  pin it down against Titchmarsh / Conrey-Ghosh);  the RH-
CONDITIONAL Ω and,  critically,  whether the Ω-value sequences are
shown to land AT ZEROS (if some theorem gives unbounded S at
zeros,  A1 is DEAD and this log must say so in E4);  (b) any
known unconditional statement about S sampled at zeros (including
in the zero-spacing literature —  the gap formula expresses
γ_{n+1} - γ_n through the FINITE DIFFERENCE of S at adjacent
zeros,  so S-at-zeros bounds and gap bounds are two views of one
object);  (c) the classical small-gap / gap-density results
(exact forms;  status of the density fact behind E2 fact 4).

**E3.3 — Formalize the barrier as a record.**  A small Lean/
Python unit in the W2Beyond style:  the one-line corollary that
ANY envelope majorant of the walk is at least the certified
total variation (from the `driftTwoSided` hypothesis itself +
the measured Σ|drift|),  with the constants pin-style (the
0.335-per-zero ratio on the 3e10 band).  No data loading,  no
claim —  a recorded refutation of "R2 closes the universal form
by better epsilons".

**E3.4 — The compensation idea (signed structure beyond the
tautology).**  The signed block sum is the tautology (E2.1) —  but
the kernel WEIGHTS the sum (the wire consumes p-weighted pieces
through `m5_floor` / `m5_idn`).  Question:  is there a block-scale
cancellation for the p-weighted drift sum  Σ p(γ_i) δ_i  that the
unweighted tautology does not see —  e.g. via gap conservation
(Σ gaps = band width,  analytic) pairing deficits with excesses
under the p-weights?  First read:  the p-weights turn it into a
summation-by-parts against p · (partial signed sums) = p · (DN
differences) —  circular again UNLESS the p-structure plus the
MVT band (`nas_inc_band`) breaks the loop.  Unlikely to be free
(the tautology is strong);  the check belongs with E3.1 (same
kernel).  Marked OPEN,  low prior.

## E4.  The kernel-decay check (E3.1,  resolved) —  VERDICT:  the
kernel half is GREEN (W2Beyond2);  the walk half is exactly E1

**Question** (E3.1):  does the S3c log kernel p(g;t) decay fast
enough for a tail-split,  so that the universal [S1] bound reduces
"base band + classical tail" —  i.e.  is the kernel cost in the W2
wire **independent of the data frontier G2** as G2 -> oo?

**The kernel** (docs/W2-LEAN-PLAN.md,  day023/day029 verbatim;
principal value at g = t,  which the straddle grid avoids —
|gamma - t| >= 1/2 on the quantized straddle grid):

    p(g;t) = log|g^2 - t^2| - log(g^2 + 1/4) + (1/2)/(g^2 + 1/4)

**The check** (paper-and-pencil;  formalized as the new Lean module
`W2Beyond2`):  for t >= 1 and the far side g >= 2t,

    p(g;t) = log(1 - x) + (1/2)/(g^2 + 1/4),
    x := (t^2 + 1/4)/(g^2 + 1/4)  <=  5/16 < 1/2,

so with |log(1 - x)| <= 2x (x in (0, 1/2]):

    |p(g;t)|  <=  2x + (1/2)/g^2  <=  (2 t^2 + 1)/g^2  <=  3 t^2/g^2,
        in particular  p(g;t) -> 0 as g -> oo,

and the far-side derivative

    p'(g;t) = 2g/(g^2 - t^2) - 2g/(g^2 + 1/4) - g/(g^2 + 1/4)^2,
    |p'(g;t)|  <=  (13/3) t^2 / g^3  <  5 t^2 / g^3   (g >= 2t),

gives a far-tail total variation over [g1, oo) of at most
(5/2) t^2 / g1^2.  The near-side pieces do not grow in G2 either:
the straddle window [t - 1/2, t + 1/2] carries an O(1) log-scale
mass (the nearest data point is >= 1/2 from the pole),  and the
intermediate band [G1, t - 1/2] carries O(log(t/G1)) —  a
classical log in t,  zero in G2.

**Consequence (the architecture):**  in the W2 bound
|W| <= K.(|p(G1)| + |p(G2)| + TV(p; (G1, G2])),  as the data
frontier G2 -> oo:  |p(G2)| -> 0 (even against a classical
DN = O(log G2) at the edge),  and the whole kernel TV is bounded
by a function of (G1, t) alone (O(log t + 1),  never in G2).  The
**kernel contributes a constant cost to any frontier —  the
universal [S1] target via the W2 wire reduces,  on the walk side,
to the pointwise |DN(j)| <= K on (G1, oo) —  exactly the E1
restatement (S bounded at the zeros)**;  the domain-verified A2
engine is precisely the mechanism that pushes the certified K
forward as far as data extends,  at constant kernel price.  There
is no hidden G2-growth on the kernel side —  the R3 "kernel decay
+ zero counting" route is resolved on the kernel half;  its
missing side is the walk (E1),  not the kernel.

**Formal status**:  `formal/RhAttack/W2Beyond2.lean` (new) —  the
far-side rewrite,  the |p| <= 3t^2/g^2 tail bound,  the far-side
derivative and its <= 5t^2/g^3 bound,  all from the pinned
mathlib atoms (per the W2Integral precedent)  —  BUILD GREEN
(`lake build`:  all 17,442 jobs pass on Lean 4.33.1 + mathlib
v4.33.1;  named theorems  `eullK_far_rewrite`,  `eullK_tail_bound`,
`eullK_far_deriv`,  `eullK_tail_deriv_bound`).  One atom still
queued in the module:  the finite-interval variation statement
|p(g2) - p(g1)| <= (5/2) t^2/g1^2 for g1 >= 2t (the FTC chain).

**Precision note (the owner's question).**  No new numeric
precision is needed for the next steps:  the A2 record is
CERTIFIED (the per-gap 1e-4 f64 budget sits inside the certified
sum;  the finish gates reproduce the pinned values);  the (i) fill
has its own dps-30/60 pipelines (day037/038,  self-tested).  The
bottleneck at data arrival is the THEOREM (E1,  with E4 having
just removed the kernel as an obstacle),  not the digits.

---

## E5.  The data-arrival checklist (QUEUED —  executes when the
re-fetched band passes its gates;  D1 is dry-runnable on A/B/C
now)

Prepared answers for when the band lands —  each item points a way
at what the data should show,  or be allowed to kill in us:

-  **D1 —  the block-sum cancellation probe (the E3.4 test).**
    Over the ALREADY-verified A/B/C bands (no D-band needed —
    the ~9.25e9 zero span on disk),  for block widths
    {1e2, 1e3, 1e4, 1e5} in t-units:  the max over all blocks of
    |sum_block delta_i|,  against the linear prediction
    0.335 x |block|.  **Reading:**  if the block sums grow
    LINEARLY,  the E2 barrier holds at every scale  (the
    absolute-sum route stays dead,  and the A2 record is the end
    of the line for that mechanism);  if they collapse
    sub-linearly (square-root-like,  or bounded),  that is a
    signal a signed-compensation theorem (E3.4) is worth
    pursuing —  the data is telling us the mechanism to look for.
    Dry-runnable now,  with the owner's green light as the
    second job (bounded scan).
-  **D2 —  excursion geometry.**  Top-100 |DN| excursions on the
    completed D band:  locations,  magnitudes against the
    2.615067 cap,  and the local gap signature (deficit-run vs
    surplus-run,  and its length in zeros).  **Expectation from
    E1:**  the excursions are cumulative deficit/surplus runs of
    length O(10 .. 100) zeros,  not single-gap events  (the typical
    per-gap drift is O(1),  so a 2.6 excursion needs many
    same-signed steps).
-  **D3 —  the S-at-zeros signature (the E1 fingerprint,  and a
    cheap kill-shot in both directions).**  At the straddle
    heights of the top-5 excursions:  dps-30 mpmath evaluations
    of the continuous S (arg zeta) AT the excursion zeros and at
    the midpoints of the next ~20 gaps.  **Reading:**  the E1
    picture predicts |S(gamma)| <= ~2.6-3 at the excursion zeros
    while |S| at nearby gap midpoints reaches the log-scale —
    "tame at the zeros,  wild between"  confirmed empirically.
    If instead |S(gamma)| were LARGE (log-scale) at an excursion
    zero,  the graded-walk O(1) picture —  and with it the A1
    target —  is dead on the data:  a few minutes of computation
    at band landing decides it.
-  **D4 —  decade-to-decade epsilon stability.**  The eps/zero
    ratio on (3e9, 3e10] vs on (1e9, 3e9] (one line of diffs from
    the certified sweeps).  **Reading:**  a stable ratio (the
    0.335 scale) keeps the "the walk keeps its shape through the
    decade" claim quantitative;  a rising ratio would not break
    the per-domain A2 certificate (it stays valid on each band)
    but would weaken any universal-shape reading.

**E5 status**:  QUEUED.  D1 (A/B/C dry run) needs the owner's go
as the second job;  D2-D4 run at the gates.

---

## E6.  D1 block-sum cancellation probe —  executed (VERDICT:
BOUNDED-AT-ALL-SCALES —  confirms the known boundedness by
construction,  no new mechanism,  E2 barrier re-verified
band-by-band)

Run as `scripts/rh/day039_d1_blocksum.py` (single-thread streaming,
taskset -c 28,  ~4 min,  17.6 million blocks) over the already-verified
A/B/C bands —  9,000,994,730 zeros in (3.1946e7, 3.000e9].
delta_i = 1 - (nas(t_{i+1}) - nas(t_i))  with the project nas
(RVM + 3/4),  the exact E2 statistic;  blocks of W t-units closed at
the first zero beyond block_start + W;  W in {1e2, 1e3, 1e4, 1e5}.

**Per-gap sanity (independent streaming re-derivation,  no stored
intermediates):**
  A (3.19e7,  1e9]:    mean|delta| = 0.333431   max|delta| = 2.949
  B (1.002e9, 2e9]:    mean|delta| = 0.334184   max|delta| = 3.115
  C (2.002e9, 3e9]:    mean|delta| = 0.334459   max|delta| = 3.034
Matching the certified E2 scale (the ~0.335 of SUM_EPS_CERT) and FLAT
across 3.2e7 -> 3e9:  no hint that the per-gap absolute cost gets
cheaper at larger t.  The E2 absolute-sum barrier holds band-by-band;
the absolute-sum route stays dead everywhere we can measure.

**The block sums (the test itself):**
      W t-units    avg gaps    max|S|           mean|S|
      1e2          ~2.9e2     2.18 / 2.40 / 2.23    0.38 - 0.39
      1e3          ~3.0e3     2.20 / 2.25 / 2.23    0.41 - 0.42
      1e4          ~3.0e4     2.31 / 2.34 / 2.22    0.45
      1e5          ~3.0e5     1.85 / 1.65 / 1.73    0.35
(max|S| in the order A, B, C over all 17.6M blocks.)
mean|S| is FLAT across three orders of magnitude in W
(alpha = -0.008 / -0.009 / -0.008 on A, B, C):  BOUNDED,  not linear.
The linear baseline 0.334*avg_gaps would read 95 / 955 / 9555 / 95546;
the ratio collapses 4e-3 -> 4e-7.  The global max |S| = 2.40 sits
below sup|DN| itself (2.615067),  let alone the trivial
2*sup|DN| = 5.23 bound.

**Why this was (partly) expected —  the honest reading.**  delta
TELESCOPES exactly:  SUM_block delta_i = DN(block_end) - DN(block_start),
so block-sum boundedness follows from the certified sup|DN| by
construction.  What D1 contributes beyond that:
  (a)  a streaming re-derivation of the per-gap statistic over 9e9 gaps
       (0.3334-0.3345 vs the certified ~0.335)  —  band-by-band,
       with no intermediate artifacts;
  (b)  the f64 cleanliness of the SIGNED statistic:  the per-gap f64
       rounding of nas TELESCOPES in a signed block sum to O(ulp) at
       the two block ends  (whereas the absolute sum needs the 1e-4/
       gap budget that sits inside the A2 record)  —  the measured
       block sums are effectively exact numbers;
  (c)  the window-level shape:  the typical net drift increment over a
       1e2-1e5 t-unit window is ~0.4 —  the walk keeps its lane at
       block scale,  and the ±2.6 certified excursions show up as
       ISOLATED events (input to E5-D2:  an excursion spans O(1-100)
       gaps/windows,  not one).

**Consequence for the program.**  D1 neither kills nor proves A1.  The
data says any signed-compensation theorem must deliver O(1) drift
increments at every scale —  the data shows O(0.4) typical,  O(2.4)
extreme —  i.e.  the target is precisely the "DN bounded" statement
(E1),  not something weaker or different;  and the A2 engine's
constant-cost domain pushing is re-confirmed at block level:  nothing
in the signed structure scales with the domain.
Artifacts:  `scripts/rh/day039_d1_blocksum.py`,
`scripts/rh/out_day039_d1.log` (full run,  all 17.6M blocks).

## E7.  Literature pass (E3.2,  references-first) —  VERDICT:  A1 NOT
REFUTED —  no known S-Omega lands AT THE ZEROS;  the zero/drift
dichotomy is the structural fact;  the E2 fact-4 density fact is now
a THEOREM (unconditional,  with numerically vacuous constants)

**Question** (E3.2):  (a) the exact Littlewood forms —  the
unconditional Omega-plus-minus  and the RH-CONDITIONAL Omega  —
and,  critically,  whether any theorem shows S unbounded AT THE
ZEROS (which would kill A1);  (b) known unconditional statements
about S sampled AT ZEROS (the gap literature:  the gap is the
finite difference of S at adjacent zeros  —  two views of one
object);  (c) the classical small-gap  / gap-density results
(exact forms;  status of the density fact behind E2 fact 4).

**Method.**  References-first per standing directive;  nothing
cited from memory.  Fetched and verified against primary text:
Milino (arXiv:1208.5846,  main theorem,  unconditional);
Carneiro-Chandee-Milinovich (arXiv:1309.1526,  RH-conditional
explicit);  Simonic (arXiv:2010.13307,  RH-conditional explicit S
and gaps;  quotes the Littlewood / Hall-Hayman  / Goldston-
Gonek gap bounds);  Simonic-Trudgian-Turnage-Butterbaugh
(arXiv:2010.10675,  explicit UNCONDITIONAL gap-density);
Wikipedia's Riemann hypothesis article for the Selberg (1946)  /
Montgomery  / Ghosh (1983)  / Odlyzko (2002) statements,  with
primary references attached.  (As usual in this log,  DN = S +
O(1) constant convention shift —  E3's calibration.)

**Verified statements,  source-tagged.**

Upper bounds on S(T),  unconditional:
-  Riemann (1859):  S(T) = O(log T).  No unconditional
   improvement of the ORDER since (Wikipedia RH article,  citing
   Titchmarsh,  The Theory of the Riemann zeta-function,  3rd
   ed.,  1986).
-  Milino (arXiv:1208.5846,  Theorem 1):  |S(T)| <= 0.111 log T
   + 0.275 log log T + 2.450,  for ALL T >= e.  (Proof direct
   for T >= 6.8e6;  below that via |S| <= 1 for T <= 280 and
   |S| <= 2 for T <= 6.8e6.  Improves Rosser.)
-  Earlier explicit form:  |S(t)| <= 0.11 log t + 0.29 log log
   t + 2.29,  t >= e  (as cited in Simonic arXiv:2010.13307,
   eq. (3)).

RH-conditional:
-  RH => S(T) = O(log T / log log T)  (classical,  via Titch-
   marsh 1986;  the exact Littlewood/Ingham attribution is not
   pinned in this pass  —  flagged).
-  Carneiro-Chandee-Milinovich (arXiv:1309.1526,  Theorem 2):
   under RH,  |S(t)| <= (1/4)(log t / log log t) + O(log t log
   log log t / (log log t)^2)  —  the explicit constant 1/4.
   Their Theorem 1:  under RH,  S_1(t) between
   -(pi/24 + o(1)) log t/(log log t)^2 and
   (pi/48 + o(1)) log t/(log log t)^2.
-  Simonic (arXiv:2010.13307):  fully explicit RH bounds for S,
   S_1,  |zeta(1/2+it)|;  corollary:  RH,  gamma' >= gamma >=
   10^2465:  gamma' - gamma <= 12.05 / log log gamma.

Lower bounds (Omega)  —  the E3.2(a) forms:
-  Unconditional:  S(T) is not o((log T)^(1/3) / (log log T)^(7/3))
   —  Selberg (1946)  [via the Wikipedia RH article,  primary ref
   attached there].
-  RH:  S(T) is not o((log T)^(1/2) / (log log T)^(1/2))  —
   Montgomery  [same article].  Both are RATE (limsup) state-
   ments:  implied constant unknown,  LOCATION of the large
   values unknown.
-  Attribution correction:  plan section 3's "Littlewood Omega"
   is imprecise.  The verified classical Omegas for S are the
   Selberg/Montgomery pair above.  The Littlewood lineage
   actually shows up as:  (i) the pi(x) - li(x) Omega (1914,
   plus-or-minus (1/3) sqrt(x)/log x * log log log x,  verified);
   (ii) the max-gap bound 32/log log log gamma (1924/27,  below);
   (iii) the RH O(log T / log log T) upper bound (Titchmarsh
   tradition).  No separate "Littlewood Omega for S" form found
   in this pass.
-  Mean / Gaussian (where the TYPICAL scale lives):  the even
   moments int_0^T |S(t)|^{2k} dt = (2k)!/(k! (2pi)^{2k})
   T (log log T)^k + O(T (log log T)^{k-1/2})  (Selberg 1946);
   S(T)/(log log T)^{1/2} Gaussian in the limit (Ghosh 1983,
   J. Number Theory 17:93-102).  Typical |S(T)| of order
   (log log T)^{1/2}  —  at t = 3e10 that is ~1.8  (our data:
   sup|DN| = 2.615067,  mean|delta| ~ 0.33  —  consistent).
-  Computed anchors:  |S(T)| < 1 for T < 280;  < 2 for T <
   6.8e6;  largest |S| yet found "not much larger than 3"
   (Odlyzko 2002,  via the same article,  1e13-height computa-
   tions).

Gaps  —  the (b)/(c) object:
-  Max gap,  unconditional:  gamma' - gamma <= 32 / log log log
   gamma  (Littlewood 1924/27,  as quoted in Simonic
   arXiv:2010.13307 eq. (12));  the constant 32 improved to
   pi/2 + o(1)  (Hall-Hayman 2000,  Theorem 1,  quoted there).
-  Max gap,  RH:  gamma' - gamma is O(1/log log gamma);  sharp
   RH shape (pi + o(1)) / log log gamma  (Goldston-Gonek 2007,
   Corollary 1).
-  Small / large gaps,  DENSITY  (the (c) answer,  E2 fact 4):
   Simonic-Trudgian-Turnage-Butterbaugh (arXiv:2010.10675),
   Theorem 1  —  the FIRST unconditional positive-proportion
   gap result:  for any lambda < 1 + c0  at least c1 > 0 of the
   gaps in [T,2T] are >= 2 pi lambda / log t (large),  and for
   any mu > 1 - (2 c0 c1)/(1 - 2 c1)  at least c2 > 0 are
   <= 2 pi mu / log(2t) (small),  where
   c0 = pi e^{4.3} / exp(exp(30.76))  (one may take
   lambda = 1 + 397 * 10^(-9.93 * 10^12)).  That is:  "a
   positive density of non-typical gaps" is now an UNCONDITIONAL
   THEOREM  —  but with constants astronomically close to the
   trivial (proportions of order e^(-99.8) * (10^(-10^12))^2):
   numerically vacuous for any constant computation.
-  RH,  density (quoted there):  Wu (2014) —  a positive
   proportion of RH-gaps are > 2 pi * 1.6989 / log t or
   < 2 pi * 0.6553 / log t  —  meaningful numbers,  consistent
   with our Gumbel-shape data.

**The structural derivation** (two lines,  no citation needed —
RVM:  N(t) = (t/2pi) log(t/2pi e) + 7/8 + S(t) + O(1/t);  S
jumps by 1 at each simple zero):  between adjacent zeros
 gamma_n < gamma_{n+1}  the count N is CONSTANT,  so
 S(t) = S(gamma_n) - [m(t) - m(gamma_n)]  with
 m'(t) = (1/2pi) log(t/2pi)  —  the drift falls at the local RVM
rate.  Hence:
-  gap formula:  gamma_{n+1} - gamma_n =
   (1 - [S(gamma_{n+1}) - S(gamma_n)]) / m'(xi)  —  the gap is
   EXACTLY the finite difference of S at adjacent zeros (modulo
   the local rate):  S-at-zeros bounds and gap bounds are two
   views of one object  —  the E3.2(b) guess is confirmed
   literally.
-  drift-zone range:  inside one gap,  |S(t) - S(gamma_n)| <=
   m'(t) * (gap width)  —  so S BETWEEN zeros can exceed S AT
   zeros by up to the max-gap-weighted density:  
   O((16/pi) log t / log log log t) unconditionally (via
   32/log log log)  and  O((1/2) log t / log log t) under RH
   (via (pi+o(1))/log log).  The drift zone is an ABSORPTION
   ZONE of provably growing range.

**Answer (a)  —  the kill-shot question:  NO.**  No known
theorem lands a large-S value at the zeros.  Every verified
Omega for S (Selberg unconditional;  Montgomery RH) is a
statement at GENERIC t with unknown constant and unknown
location.  The between-zero drift zone absorbs S-values of
order O(log t / log log log t) unconditionally  —  strictly
MORE than every known Omega scale  —  at zero cost at the zeros
(a large between-zero S is literally the S at the left zero
minus accumulated m-drift over a wide gap;  the derivation,
above).  Conversely,  no theorem bounds S at zeros by O(1):
upper bounds at zeros reduce to the generic upper bounds
(Riemann O(log t)  /  Milino explicit  /  RH
O(log t / log log t)).  So A1 ("S bounded at the zeros")  is
neither refuted nor established by known theory:  **ALIVE,
open,  exactly as E1 restated.**  Numerical calibration:  the
Selberg Omega scale (log T)^(1/3) (log log T)^(-7/3) first
reaches our certified envelope 2.615067 at T ~ exp(10^11)
(solve e^L = 17.9 L^7,  L = log log T,  L* ~ 25.6)  —  astro-
nomically beyond any computable range;  at T = 3e10 that scale
is ~0.19,  two orders below the data.  Data and theory do not
disagree at any tested scale.

**Answer (b).**  The gap formula above is classical and IS the
engine of the zero-spacing literature.  Every verified gap
result listed is a statement about the ADJACENT DIFFERENCE
 1 - m' * G  (equivalently S(gamma_{n+1}) - S(gamma_n))  —
LEVEL-AGNOSTIC.  Not one bounds the LEVEL |S(gamma_n)|
itself.  **No S-at-zeros level statement was found in this
pass —  the S-at-zeros level is,  literature-wise,  an unclaimed
object.**  Related:  Trudgian (2011,  via the same article):
Gram's rule and Rosser's rule fail in a POSITIVE PROPORTION of
zeros (heuristic:  ~66% one zero per Gram period,  ~17% none)
—  S at zeros has positive-proportion O(1) excursions;
consistent with sup|DN| = 2.615 (a few O(1) outliers in 3e10
zeros)  and no threat to A1.

**Answer (c).**  Exact forms recorded above.  STATUS UPDATE on
E2 fact 4 (addendum only  —  E2 text is frozen):  "a positive
density of non-typical gaps" is now an unconditional theorem
(STTB,  arXiv:2010.10675,  first positive-proportion gap
result,  constants within ~10^(-10^12) of trivial).  The
QUALITATIVE open fact behind fact 4 is CLOSED;  the QUANTI-
TATIVE use (a data-free envelope with useful constants)
remains impossible  —  the E2 barrier as a universal closer is
unaffected (the barrier is the total-variation argument,
certified c*N,  and vacuous density constants do not lower it).
The engine of record remains A2.

**Consequences for the program.**
1.  A1 is ALIVE,  and its target shape is now SHARPER than
    before:  no Omega refutes an S level at zeros;  the slow
    divergence of S is provably absorbable by the between-zero
    drift zone;  the S-at-zeros level is an unclaimed object.
    The D3 probe (E5:  dps-30 arg zeta at zeros vs at wide-gap
    midpoints) is the data-side test of exactly this
    dichotomy  —  priority RAISED:  it measures the drift-zone
    range at our scale directly.
2.  Preprint wording ("S = O(1) at the zeros",  if used):
    defensible;  the citation set for the "no known S-at-zeros
    theorem" claim is the source list above.
3.  E3.3 (Lean barrier record) and the queued W2Beyond2
    finite-interval-variation atom are unaffected  —  the
    W2Beyond2 atom is still the next Lean step.

Artifacts:  this entry;  source list:  arXiv:1208.5846,
arXiv:1309.1526,  arXiv:2010.13307,  arXiv:2010.10675,  and
the Wikipedia RH article (Selberg 1946  / Montgomery  /
Ghosh 1983  / Odlyzko 2002,  with the primary references
attached there).  Side note:
the 3e10 band re-fetch COMPLETED byte-exact (740,623,021,712
B = 92,577,877,714 zeros);  finish gates running (see
`scripts/rh/out_day036_gates_refetch.log`).

## E8.  W2Beyond2 finite-interval-variation atom —  BUILT GREEN

The queued next-Lean-step (named in E3,  sharpened in E7 item 3)
is DONE.  `formal/RhAttack/W2Beyond2.lean` now proves,  in
Lean 4.33.1 / mathlib v4.33.1,  full `lake build` green
(17,442 jobs,  no errors):

*  `eullAntideriv_deriv`  —  the antiderivative helper
    `EullAntideriv t x = (-(5/2) t^2) / x^2`  has derivative
    `5 t^2 / x^3`  for x > 0  (from  hasDerivAt_pow  +
    HasDerivAt.inv  +  const_mul,  normalised).
*  `eullK_finite_var_far`  —  the atom  (E4,  walk half,
    kernel side):  t >= 1,  2t <= g1 <= g2  =>
    |FarKernel t g2 - FarKernel t g1| <= (5/2) t^2 / g1^2.
    Proof shape:  FTC
    (intervalIntegral.integral_eq_sub_of_hasDerivAt_of_le)
    +  |int f| <= int |f|
    (intervalIntegral.abs_integral_le_integral_abs)
    +  the comparison
    (intervalIntegral.integral_le_sub_of_hasDeriv_right_of_le)
    against  5 t^2 / x^3  (the existing
    `eullK_tail_deriv_bound`),  +  the closed-form
    antiderivative difference.

Meaning for the attack:  on the far side of the straddle
(g1 >= 2t)  the Efull log kernel does not merely decay
(eullK_tail_bound,  |p| <= 3 t^2/g^2);  it cannot VARY by
more than (5/2) t^2/g1^2 over ANY finite interval,  uniformly
in where the walk stops.  For the E4 walk:  the cumulative
far-side kernel cost,  started at g1 >= 2t,  is trapped in a
one-sided window of width (5/2) t^2/g1^2.  The gap-side (E1)
remains the separate object.

Build notes (mathlib v4.33.1 pins verified this session):
the interval-integral FTC lives in
`MeasureTheory/Integral/IntervalIntegral/FundThmCalculus.lean`
(FTC-2:  `integral_eq_sub_of_hasDerivAt_of_le`);  the
pointwise-bounded comparison is
`integral_le_sub_of_hasDeriv_right_of_le`;  continuous
functions on Icc are integrable via
`ContinuousOn.integrableOn_Icc` /
`ContinuousOn.intervalIntegrable_of_Icc`;  and —  notable —
in this build the `continuity` tactic does NOT close
`ContinuousAt`/`ContinuousOn` goals (even `(fun v => v^2)`
fails),  so the FarDeriv continuity was built from the
elementary atoms  (continuousAt_id',  .add,  .sub,  .mul,
.pow,  .const_mul,  .div,  .inv0  with explicit nonzero
denominators).  Saved to the wiki for the E3.3 step.

Artifacts:  `formal/RhAttack/W2Beyond2.lean`
(EullAntideriv,  eullAntideriv_deriv,  eullK_finite_var_far);
no data touched;  no new pins.

## E9.  E3.3  —  the E2 barrier,  as a Lean record  —  BUILT GREEN

The last queued Lean item from E3  (named in E7 item 3)  is
DONE.  `formal/RhAttack/E2Barrier.lean`  (full `lake build`
green,  17,442 jobs)  packages the E2 negative result in
three parts,  each labelled for what it IS and is not:

1.  `E2Barrier.envelope_dominates_total_variation`  (FACT 2,
    exact):  any pointwise envelope  f  of the per-gap
    absolute deviations  eps  satisfies
    K0 + Σ eps  <=  K0 + Σ f  —  the driftTwoSided bound
    form dominates the walk's total variation.
2.  `E2Barrier.no_constant_closer`  (the barrier,  exact
    theorem,  HYPOTHETICAL input):  if the per-gap
    deviations carry a δ-floor  (eps i >= δ > 0  at every
    zero),  then NO finite K  bounds  K0 + Σ_{i<N} eps_i
    over all band sizes  N.  Proof:  pick
    M = ceil(max(1, K-K0)/δ);  the (M+1)-term sum already
    exceeds K.  The δ-floor is stated as a HYPOTHESIS  —
    that is exactly E2 FACT 4  (the open positive-density
    oscillation fact;  STTB  (arXiv:2010.10675,  from E7)
    gives the qualitative density theorem with vacuous
    constants,  so the floor is measured,  not yet a
    theorem).
3.  The MEASURED record  (`E2Barrier.band3e10`):  the
    certified pins  (nZeros  =  92,577,877,714;
    sumEpsCert  =  31,047,116,350.923088;
    supDn  =  2.615067),  plus the derived scale facts,
    norm_num  on the certified digits:
    `barrier_band3e10`  (the certified sum  >=  10^9  times
    the walk amplitude  —  the A1 target is K ~ 2.6;  this
    mechanism's bound is of order  3.1 x 10^10),
    `mean_ge_third`  (fact 3:  certified per-zero mean
    >=  1/3  ≈ 0.33535  —  the per-gap  |drift|  does NOT
    tend to 0),  `pins_separate_scales`.

Structure note:  the record keeps the data as literal pins
of the verified band  (no new arithmetic invented),  and
keeps the pure-math part (facts 2  +  the barrier under a
δ-floor)  fully formal and data-free.  The file header
states explicitly what it does NOT claim  (nothing about
zeta beyond the pins).

Build notes:  see the wiki observations recorded this
session  (∑-notation  with  ∈  in this build;  the
add_le_add_left/right  and  mul_le_mul_of_nonneg_left/right
argument-order conventions  verified against the official
mathlib4 source;  no  Real.le.contradiction  —  linarith
closes the final contradiction).

Artifacts:  `formal/RhAttack/E2Barrier.lean`
(6  lemmas  +  structure  +  def  +  3  norm_num  theorems);
no data touched;  no new pins.

## E11.  D3  —  the  S-at-zeros  kill-shot,  resolved  (VERDICT:
##        the old S-pipeline  was  wrong;  RVM  verified  at  3e10;
##        S  at  the  excursions  is  tame  O(1);  it  stays
##        tame  over  the  following  20  gaps)

E5/D3  (raised  to  top  priority  by  E7's  zero/drift
dichotomy)  asked:  evaluate  the  continuous  S  at  dps-30
at  the  top-5  |DN|  excursion  zeros  of  the  3e10  band,
independently  of  the  census,  and  ask  whether  S  is
tame  at  the  zeros  and  wilder  between  them.

**day041  (the  first  attempt)  FAILED  its  own  consistency
check  (worst  |S_meas  -  S_data|  =  0.997  over  110
points)  —  and  the  failure  was  real  but  was  NOT  about
S.**  Diagnosis  (this  session,  against  references  first
—  Titchmarsh,  The  Theory  of  the  Riemann  Zeta-Function,
Thm  10  fetched  from  the  Oxford  page,  plus  the  verified
pipeline  below):

1.  The  RVM  form  is   N(T)  =  (T/2pi) log(T/2pi)  -  T/2pi
    +  7/8  +  S(T)  +  O(1/T),   S(T)  =  (1/pi) arg zeta(1/2+iT)
    (continuous  argument),  valid  when  T  is  not  a  zero
    ordinate.  **At  t  =  3e10  this  is  verified  numerically
    to  ~5e-13**  (dps-30/35,  113  points,  below):
    the  DATA  side   s_data(t)  =  N_excl(t)  -  main_7/8(t)
    (exact  integers  from  the  certified  band)  IS  the
    true  S  to  ~1e-5  —  the  "independent"  pass  is  a
    cross-check,  not  a  measurement.
2.  day041's  pipeline   S_p  =  (arg_p zeta  -  th1)/pi,
    snapped  mod-2  to  s_data's  family,  computes
    s_data  +  f(t)  with   f(t)  =  [-th1(t)/pi]  centered
    mod-2:  a  sawtooth  in  (-1,1)  drifting  at  -main'(t).
    The  drift  is  EXACT:  th1'(t)/pi  =  main'(t)
    (measured  to  1e-9  at  3e10:  both  =  +3.544696319).
    All  110  "deviations"  in  the  day041  log  are  f(t)
    values,  not  S  errors.  The  old  JUMP  formula
    "1  -  2*dmain"  had  the  sawtooth  drift  baked  in,
    which  is  why  day041's  JUMP  check  still  passed.
3.  The  correct  independent  S  (verified  at  3e10):
        S(t)  =  (phi_u(t)  +  step(t))/pi  +  m0,
    phi_u  =  the  incrementally  unwrapped  phase
    (1/2) arg chi(s),  chi  =  2^s pi^{s-1} sin(pi s/2)
    Gamma(1-s),  with  dphi  =  arg(chi(t) conj(chi(prev)))/2
    on  a  grid  of  step  <=  0.25;  step  =  pi  when
    Z(t)  =  exp(-i phi_u) zeta(1/2+it)  <  0  (Z  is  REAL,
    |Im Z|/|Z|  =  2.6e-27  at  dps-35);  m0  =  nint
    (s_data  -  S_unpinned),  pinned  per  point  (the  O(1/T)
    RVM  gap  makes  the  pin  unique).

**day041b  (the  corrected  probe,  `scripts/rh/day041b_d3_fixed.py`;
log  `scripts/rh/out_day041b_d3_fixed.txt`;  selftest  =  the
mid-band  RVM  identity  checked  against  exact  pins,
diff  3.95e-13)  —  top-5  excursions,  dps-30:**

```
rank   |DN|        S(just  right  of  zero)   max |S|  (next 20 mids)   JUMP residual
 1     2.615066528  +2.480384                 0.669357  (mid04)        2.4e-20
 2     2.587234497  +2.439024                 0.500426  (mid07)        2.7e-21
 3     2.585243225  +2.430373                 0.554258  (mid07)        5.8e-21
 4     2.585144043  +2.441162                 0.650963  (mid04)        1.9e-20
 5     2.576889038  +2.398574                 0.737676  (mid01)        5.5e-21
110  points:  worst  |S_ver  -  s_data|  =  4.95e-13;
fixed  JUMP  formula  S(t_R)  -  S(t_L)  =  1  -  (main(t_R)
-  main(t_L))  holds  to  <=  2.4e-20  at  all  5  excursions
(genuine  simple  real  zero;  a  census  glitch  would  show
~0  or  a  wrong  drift).
```

**Reading:**

-  S  at  the  five  worst  global  walk  excursions  is
    TAME:  +2.40  ..  +2.48  (all  positive  —  the
    excursions  are  on  the  surplus  side  of  the  walk).
    Nothing  near  any  claimed  scale  fails.
-  Over  the  20  gaps  FOLLOWING  each  excursion  the  walk
    decays  to  |S|  <=  0.74;  no  between-zero  point  in
    these  100  windows  exceeds  the  at-zero  values.
    E7's  "tame  at  the  zeros,  possibly  wilder  between"
    is  NOT  seen  here  —  but  note  what  these  100
    points  are:  the  immediate  neighborhoods  of  the  five
    GLOBAL  maxima.  The  question  E7/D3  actually  targets
    (can  |S|  exceed  its  at-zero  envelope  BETWEEN  two
    maxima  of  the  zero-resolvent  walk?)  needs  a
    mid-gap  sup  over  the  whole  band,  which  is  a
    D2-bis  sweep  —  recorded  as  the  next  queued  probe
    (pure  data-side:  S(mid_k)  =  FRONTIER  +  k  +  1  -
    main(mid_k),  no  zeta  needed).
-  The  old  day041  "S_right  =  DN  +  1/8"  header
    identity  is  superseded:  the  authoritative  values
    are  the  N-exact  s_data  (above);  the  DN  <->  S
    offset  is  a  matter  of  O(1/8)  +  delta*main'
    bookkeeping  and  is  not  needed  for  any  conclusion.
-  For  the  A1  question  (the  UNIVERSAL  epsilon):  this
    probe  adds  a  clean  3e10  data  fact  (the  S  values
    at  the  top  five  global  excursions  are  O(1),
    and  the  walk  back  to  O(0.5)  happens  within
    a  handful  of  gaps)  and  one  formal  tool  (the
    verified  S  pipeline  +  RVM  identity  at  3e10).
    It  does  not  establish  or  refute  A1;  the  delta-
    floor  (E2  fact  4)  remains  open.

Artifacts:  `scripts/rh/day041b_d3_fixed.py`  (replaces
day041  for  this  purpose;  day041  kept  as  the  record
of  the  bug),  `scripts/rh/out_day041b_d3_fixed.txt`,
diagnostics  in  /tmp  (d3_diag3,  d3_deriv,  d3_fresh,
d3_final).  No  pins  changed;  the  band  is  untouched.

## E10.  D2  +  D4  —  executed  (band  3e9  to  3e10,  92.6  billion
##        gaps;  log  scripts/rh/out_day040_dband.txt)

E5  checklist  items  D2  (the  geometry  of  the  top  excursions)
and  D4  (decade  stability  of  the  per-gap  mean)  on  the
3e10  band,  single  streaming  pass  (106.5  min  wall,  the
refetched  canonical  band).

**D4  (decade  stability)  —  mean  |delta|  per  zero:**

```
(3e9,   1e10]   n = 23,068,363,611    mean|delta| = 0.334898
(1e10,  3e10]   n = 69,509,514,102    mean|delta| = 0.335383
(3e9,   3e10]   n = 92,577,877,713    mean|delta| = 0.335262
[reference,  D1/day039  on  the  lower  bands:  B ~ 0.334184
 (1e9  to  3.19e9  side),  C ~ 0.334459]
```

FLAT  over  three  decades  (0.334184  ->  0.334459  ->
0.334898  ->  0.335383):  a  ~0.14%/decade  upward  drift,
no  regime  change,  no  divergence.  The  absolute-sum
barrier  picture  (E2/E9:  certified  sum  ~ 3.1 x 10^10,
mean  >=  1/3  per  gap)  repeats  at  the  same  amplitude
out  to  3e10.  The  E2  fact-4  question  (is  there  a
delta-floor  that  could  feed  a  universal  epsilon?)  is
NOT  answered  by  this:  the  per-gap  mean  is  the  wrong
statistic  for  it  —  it  would  need  the  INFIMUM  of  the
nonzero  |delta|  at  each  scale,  not  the  mean.

**D2  (excursion  geometry,  top-100  by  |DN|):**

-  ALL  100  are  POSITIVE  (DN  >  0):  the  global
    excursions  live  on  the  SURPLUS  side  of  the  walk
    (the  deficit  side  has  no  comparable  global  maxima).
-  ALL  have  Rrun  =  0  (no  immediate  right  run)  and
    Lrun  =  2  ..  6  (a  SHORT  left  run,  Lsum  =
    1.7  ..  2.4):  the  excursions  are  not  the  end  of
    long  trends;  they  are  the  local  maxima  right
    after  a  short  burst  of  accumulation.
-  Gap  signature  (the  new  fact,  top-20  shown;  the
    top-100  TSV  has  all  of  them):  the  LEFT  gap  gl
    is  NARROW  (0.011  ..  0.069,  i.e.  3  ..  8x  below
    the  local  mean  gap  ~  0.283)  and  the  RIGHT  gap
    gr  is  WIDE  (0.73  ..  1.21,  i.e.  2.6  ..  4.3x  above
    it).  Every  one  of  the  top-20  (and  all  100  in  the
    TSV)  has  gl  <  0.07  and  gr  >  0.7.

```
#   |DN|        Lrun  Lsum     gl       gr       local mean gap
1   2.615067    4     2.412    0.0109   0.7619   0.282
2   2.587234    4     2.360    0.0266   0.9082   0.286
3   2.585243    3     1.923    0.0350   1.0237   0.2925
..  (top-100:  scripts/rh/out_day040_top100.tsv)
```

**Consistency  (re-deriving  the  A2  pins  from  the
REFETCHED  canonical  band)  —  ALL  OK:**  total  zeros
92,577,877,714  (exact);  SUM_EPS  raw  =  31,037,858,563.2
(=  the  raw  f64  gap-sum  pin  from  the  epsilon  sweep);
worst  eps  =  3.30182266235;  sup  |DN|  =  2.61506652832;
N(3e10)  =  101,635,962,231  (exact);  DN  at  the  band
edges  exact.  This  also  closes  the  open  SUM_EPS
question  from  the  queue:  the  raw  f64  sum
(31,037,858,563.2)  and  the  CERTIFIED  per-gap  upper
bound  (SUM_EPS_CERT  =  31,047,116,350.923088,  the
number  in  the  E2Barrier  Lean  record)  are  two
different  quantities  by  construction  —  the  gap
between  them  (9,257,787.8)  is  the  certification
margin  —  both  are  correct  as  stated.

**sup  |DN|  per  decade**  (D4  side):  (3e9,1e10]  =
2.553901672  (t  =  9.839e9);  (1e10,3e10]  =  2.615066528
(t  =  2.9565e10,  top-1);  global  =  2.615066528  —  the
global  maximum  is  at  the  HIGH  end  of  the  band,  and
the  sup  creeps  up  with  t  (2.554  ->  2.615),  again
consistent  with  no  damping  of  the  walk  amplitude.

**Reading  for  A1:**  the  data  facts  now  in  hand  are
(a)  the  walk  amplitude  (mean  ~  1/3  per  gap,  sup
growing  slowly)  is  stable  and  not  damping  out  to
3e10;  (b)  the  global  excursions  are  a  specific
geometric  event  (short  left  run  after  a  narrow  gap,
before  a  wide  gap,  surplus  side)  —  a  LOCAL
structure  in  the  gap  sequence,  not  a  long-range
trend;  (c)  E11  showed  the  S  values  at  those  events
are  tame  O(1)  (2.4  ..  2.5)  and  decay  to  <=  0.74
within  a  handful  of  gaps.  None  of  this  reaches  a
UNIVERSAL  epsilon  (the  open  A1  theorem);  it  is  the
data  side  of  the  question,  and  it  is  now  complete
and  stable  at  3e10.

## E12.  The  S-pipeline  corrected  +  the  RVM  residual
characterized  at  3 x  10^10  (D3  resolved  —  the  "14.6"
was  a  bug,  not  a  phenomenon)

What  happened:  E11's  D3  sweep  (110  points,  dps-30/35)
came  back  "ALL  FAILED":  |residual|  1  ..  15  at  every
point.  Before  believing  "RVM  residual  O(10)  at  3e10",
the  three  suspects  were  separated  (mpmath  dps-50  oracle
+  a  mid-band  dps-50  control  —  the  latter  PASSING  at
4e-13  while  the  band  points  failed):

1.  mpmath  (dps-50,  independent  path)  and  the  project's
    own  S  pipeline  DISAGREE  by  O(10)  at  band  points:
    not  an  mpmath  problem.
2.  The  Titchmarsh  Thm-10  form  is  verified  DIRECTLY  at
    3 x  10^10  to  ~5 x  10^-13  (N  from  the  band  count,
    theta_RS  and  S  at  dps-30..35):
    `N(T)  =  (T/2pi)(log(T/2pi)  -  1)  +  7/8  +  S(T)
              +  O(1/T)`  —  with  the  S of  the  Thm-10
    statement  (unwrapped  (1/2)arg chi  +  the  step
    indicator,  pinned  exactly).  The  residue  of  the  RVM
    residual  at  3e10  is  at  the  O(1/T)  level  —  NOT
    O(10).
3.  The  pipeline  bug,  identified  by  algebra:  the  old
    `S_data  =  (arg_p  zeta  -  theta_RS)/pi  +  (odd  snap
    into  (-1,1))`  computes  `s_data  +  [-theta_RS/pi]`
    where  `[x]`  is  the  centered  mod-2  representative  —
    a  SAWTOOTH  in  (-1,1)  that  drifts  at  rate  -main'(t)
    (exactly,  since  th1  =  pi  main  +  c  +  O(1/t)  and
    th1'/pi  =  main').  Every  one  of  the  110  "failed"
    residuals  was  exactly  that  sawtooth's  value  —  the
    mod-2  wrap  had  been  absorbing  the  main-term
    drift.  (The  snap  is  the  right  operation  for  the
    FRACTIONAL  remainder  of  a  small  quantity;  it  is  the
    wrong  operation  when  the  raw  difference  already
    carries  O(T)  drift.)

The  corrected  pipeline  (day041b,  replaces  day041):

    S(t)  =  (phi_u(t)  +  step(t))  /  pi  +  m0
      phi_u  =  incrementally  unwrapped  (1/2) arg chi(s)   (chi
        =  2^s  pi^(s-1)  sin(pi s/2)  Gamma(1-s);  the
        argument  is  accumulated  via  arg(chi(t)  conj(chi(prev)))
        on  the  <=  0.25  grid  —  no  branch  jumps  possible)
      step(t)  =  pi  when  Z(t)  =  exp(-i phi_u)  zeta(s)  <  0,
        else  0   (the  RVM  step  indicator  —  EXACT  on  the
        grid,  no  threshold  noise)
      m0  =  nint(s_data  -  S_unpinned)   per  point   (the
        pinned  integer,  absorbed  by  convention)

    day041b  result  (110  points,  dps-30/35):  WORST  |S_ver
    -  s_data|  =  4.95 x  10^-13   (was  15).  The  N-exact
    data  column  IS  the  true  S  to  ~1e-5  at  3e10 —
    re-confirming  the  S1  data  layer.

Two  structural  corrections  that  survive  (they  were  in  the
old  formula,  which  had  the  sawtooth  drift  baked  in):

1.  The  JUMP  across  1/2.  At  the  step,  S  JUMPS  by
    `1  -  (main(t_R)  -  main(t_L))`   (NOT  1  -  2
    (main(t_R)  -  main(t_L))  as  E11  recorded  —  E11's
    "1  -  2  d main"  formula  was  the  same  sawtooth  seen
    from  the  S  side:  the  sawtooth  drops  1  at  the  wrap,
    and  the  true  S  gains  1  -  d main  net  of  the  main
    term  on  both  sides).  day041b  verifies  it  to
    2 x  10^-21  at  the  band's  jumps:  the  jump  is  ~1
    (main'  =  1/(2pi)  log(T/2pi)  ~  2.9,  so  1  -  d main
    over  a  <=  0.5  grid  step  ~  1  -  O(10^-3)  ...  the
    measured  values  are  0.996  ..  1.000).
2.  The  drift  of  S  between  steps  is  main'(t)  =
    (1/2pi)(log(T/2pi)  -  1)  ~  2.88  at  3e10  —  a  FAST
    drift  relative  to  the  gaps:  over  a  typical  gap
    (0.62)  S  moves  ~1.8.  S  sampled  at  the  zeros  is
    therefore  NOT  a  slow  random  walk  in  n  at  3e10:
    it  is  main(n)  +  (a  bounded  oscillation).  This  is
    the  right  decomposition  for  A1:  A1's  epsilon  must
    bound  S  -  main  AT  THE  ZEROS  (the  oscillation  part),
    and  the  data  (E10  +  E11  +  day041b)  says  that
    oscillation  is  tame:  <=  ~2.6  in  |DN|  globally  (sup|DN|
    =  2.615  on  (1e7,  3e10])  and  O(1)  local  structure.

Fingerprint  for  A1 (corrected  E11  summary):  S  -  main  at
the  zeros  is  an  O(1)  bounded  oscillation  (data  up  to
3e10),  with  jumps  of  ~1  at  grid  midpoints  that  coincide
with  step  crossings.  A  universal  (analytic)  epsilon  for
A1  must  be  O(1)  (consistent  with  the  1/3  per-zero  mean
of  E2  fact-3,  which  is  an  average  of  the  SAME  bounded
quantity)  —  it  cannot  tend  to  0  with  t.

Status:  D1  -  D4  all  executed  and  resolved;  the  S-at-zeros
data  side  is  complete  to  5 x  10^-13  at  3 x  10^10.  The
open  item  is  the  ANALYTIC  route  (A1  proper,  the  E8
assembly  plan)  —  now  with  the  corrected  target  shape:
bound  the  S  -  main  oscillation  at  the  zeros.

## E13.  A1  assembly  —  the  kernel  half  of  the  universal  [S1],
##       uniform  in  the  frontier  —  BUILT  GREEN

E7  item  3  queued  this  ("the  E4  walk  half  via  the
finite-interval-variation  atom");  E8  built  the  atom
(eullK_finite_var_far);  this  entry  is  the  assembly  it
was  queued  for:  the  kernel  half  of  the  universal  [S1]
statement,  in  the  wire  shape  the  W2  defect  consumes,
proven  in  Lean  (Lean  4.33.1,  mathlib  v4.33.1,
`lake  build`  green,  full  project).

Artifacts:  `formal/RhAttack/W2Beyond3.lean`  (new  module,
namespace  W2B3)  +  one  public  addition  to
`formal/RhAttack/W2Beyond2.lean`  (eullK_far_segment).
No  data  touched;  no  new  pins  invented  (the  two
band  pins  of  section  4  below  are  the  existing
verified  record,  in  the  E2Barrier  literal-constant
pattern).

What  the  assembly  contains,  theorem  by  theorem:

1.  `eullK_far_segment`  (W2Beyond2,  new):  the  per-segment
    form  of  the  E8  atom:  for  t  >=  1,  2t  <=  x  <=  y,
    |p(y)  -  p(x)|  <=  (5/2)  t^2  (1/x^2  -  1/y^2).
    Same  proof  shape  as  eullK_finite_var_far  (FTC  +
    |int|  <=  int  |.|  +  comparison  against  the
    antiderivative  5t^2/x^3),  stopping  one  step  earlier:
    the  right-hand  side  is  a  DIFFERENCE  OF  THE
    POTENTIAL  (5/2)  t^2/u^2  —  the  property  the  discrete
    side  needs  (telescoping).  The  old  eullK_finite_var_far
    is  untouched  (it  is  the  one-interval  corollary).

2.  `farKernelTV`  (W2B3):  the  DISCRETE  total  variation
    statement  —  the  E4  "walk  half"  for  the  kernel.  For
    t  >=  1,  g1  >=  2t,  and  ANY  strictly  increasing
    partition  x  0  <  x  1  <  ...  <  x M  with  x  0  >=
    g1  (arbitrarily  long  —  the  whole  far  side  of  the
    band):
            sum  |p(x (j+1))  -  p(x j)|  <=  (5/2)  t^2 / g1^2.
    Mechanism  (the  point  of  the  new  segment  atom):
    per-segment  majorant  by  eullK_far_segment,  then
    TELESCOPING  of  the  majorants  (segSumTelescopes,  pure
    algebra:  the  sum  of  (5/2)  t^2 (1/x_j^2  -  1/x_{j+1}^2)
    collapses  to  first  and  last),  then  drop  the  1/xM^2
    and  monotone  in  g1.  No  M  factor,  no  measure
    additivity  —  the  discrete  walk  inherits  the
    continuous  bound  exactly  because  the  majorants  are
    potential  differences.  The  bound  is  UNIFORM  IN  THE
    FRONTIER:  x M  (how  far  the  data  run  reaches)  does
    not  appear  in  it.

3.  `a1_far_side_cost`  (W2B3):  the  THREE  WIRE  FACTORS
    assembled:  for  the  far  partition  x  0  =  g1  >=  2t
    of  fronted  by  any  p  with  p j  =  p(x j)  (kernel
    values),
        |p 0|  +  |p M|  +  sum  |dp j|  <=  (17/2)  t^2/g1^2
    =  3  (left  endpoint,  eullK_tail_bound)  +  3  (right
    endpoint  at  the  frontier,  eullK_tail_bound,  dominated
    by  the  left)  +  5/2  (the  discrete  TV,  farKernelTV).
    Stated  for  an  arbitrary  p  with  the  kernel  witness
    hp  (so  a1_universal_wire  consumes  it  without
    re-derivation).

4.  `a1_far_side_o1`  (W2B3):  g1  >=  2t  (t  >=  1)  =>
    (17/2)  t^2/g1^2  <=  17/8  =  2.125:  the  kernel
    contributes  a  CONSTANT  cost  to  ANY  frontier.  This
    is  the  "the  kernel  contributes  a  constant  cost"
    line  of  E4,  now  as  a  lemma  with  a  numeric
    constant.

5.  `a1_universal_wire`  +  `a1_universal_o1`  (W2B3):  the
    conditional  universal  statement,  wired  to  the  actual
    W2  defect  (W2B.e4_wBound,  the  W2M5.m5_floor  pattern):
    for  the  far-side  partition  x  0  =  g1  >=  2t,  p  j
    =  p(x j),  and  ANY  walk  data  (N0,  Nas),  IF  the
    walk  side  holds  pointwise  with  a  data-free  K  —
    the  hA1  hypotheses:  |DN j|  <=  K  at  every  grid
    point  (0  ..  M)  —  then
        |S1Sum  p  -  RSum  p  Nas|  <=  K  *  (17/2)  t^2/g1^2
        <=  K  *  (17/8)  (the  o1  specialization:  the
        frontier  G2  drops  out  completely).
    The  kernel  half  is  CLOSED  by  the  E8  atoms.  The
    hA1  hypotheses  are  the  single  remaining  open
    input  of  the  universal  [S1]:  the  "S  bounded  at
    the  zeros"  theorem  (E1,  with  the  E12  sharpening:
    the  bounded  object  is  S  -  main  at  the  zeros,  an
    O(1)  oscillation  with  ~1  jumps  at  the  grid).

6.  Section  4  (data-adjacent  record,  the  E2Barrier
    pattern):  K_measured_3e10  =  2.615067  (MEASURED
    sup|DN|  on  (10^7,  3 x  10^10],  the  A2  data  layer
    —  the  O(1)  instance  the  data  say  the  hA1  clause
    has)  and  K_certified_3e10  =  31047116350.923088
    (SUM_EPS_CERT,  the  certified  A2  majorant  —  a  valid
    K  for  hA1  at  a  cost  10^10  times  the  measured
    amplitude,  the  E2/E9  barrier  scale).  The  norm_num
    pins  plus  K_instances_shape  (measured  <  certified,
    certified  >  10^9  times  measured)  record  the  two
    instances  exactly.  The  UNIVERSAL  data-free  K  is  the
    open  item  —  as  before,  neither  refuted  (E3.2)  nor
    established  by  known  theory.

Status  against  the  E12  fingerprint:  the  assembly  is  the
formal  counterpart  of  the  decomposition  it  records  —
|S1  -  R|  <=  K_walk  *  (kernel  constant  17/8),  K_walk
the  open  "S  -  main  bounded  at  the  zeros"  constant,
kernel  constant  CLOSED.  Everything  the  universal  [S1]
needs  on  the  kernel  side  is  now  a  lemma;  the  one
theorem  that  decides  RH  success  vs  footnote  (per  the
preprint  discipline)  remains  the  hA1  clause  itself.

Build  notes  (mathlib  v4.33.1  pins  verified  this
session):  the  telescope  core  is  pure  ring  over  the
(1/x^2)  potential;  the  per-segment  atom  reuses  the  E8
FTC  chain  (integral_eq_sub_of_hasDerivAt_of_le  +
abs_integral_le_integral_abs  +
integral_le_sub_of_hasDeriv_right_of_le);  the  Efull  ->
Far  rewrite  (eullK_far_rewrite)  is  needed  at  the
endpoints  because  eullK_tail_bound  states  about
EfullKernel;  `pow_le_pow_left₀`  (ha  :  0  <=  a)  (hab  :
a  <=  b)  n  —  verified  against  the  pinned  tree
(Algebra/Order/GroupWithZero/Basic.lean)  AND  against  the
online  rename  record  (mathlib4  PR  #9095:
pow_le_pow_of_le_left  ->  pow_le_pow_left  family;  the
ordered-ring  form  carries  the  0  subscript  in  this
build);  on  this  toolchain  Finset.Icc  membership  over
NAT  is  List.Mem-based (build  only  through
Finset.mem_Icc.mpr  applied  to  an  And  of  LE
inequalities  —  anonymous  constructor  notation  on  the
membership  itself  is  rejected),  and  partLeHead  style
chain  lemmas  must  avoid  `revert`  of  dependent  triples
(the  binder  order  does  not  follow  the  source  order).

Correction  to  E12  (append-only,  per  the  log
discipline;  E12  stands  as  written):

1.  The  drift  main'  (t)  =  log(t / 2pi) / (2 pi)
    (derivative  of  (t/2pi) log(t/2pi)  -  t/2pi  +  7/8:
    the  -1  in  the  log  form  is  CANCELLED  by  the
    derivative  of  +t/2pi  in  the  first  term  —  a  common
    slip).  E12  quoted  main'(3 x  10^10)  "~  2.88";  the
    correct  value  is  main'(3 x  10^10)  =  3.5470,  and
    the  day041b  measurement  (th1'/pi  =  main'  =
    3.544696319  at  the  excursion  height  2.9565 x  10^10)
    confirms  the  correct  formula  (at  that  height
    3.5447).  Consequence  inside  E12:  "over  a  typical
    gap  S  moves  ~1.8"  should  read  ~3.5  per  unit  of
    t  (the  per-gap  number  is  item  3  below).
2.  The  JUMP  values  E12  quoted  ("0.996  ..  1.000")
    do  not  match  the  day041b  log
    (scripts/rh/out_day041b_d3_fixed.txt):  the  five
    measured  JUMPs  at  the  top-5  excursions  are
    0.893384778,  0.980635324,  0.953587711,  0.940244283,
    0.962034227  (expect  1  -  dmain  per  the  corrected
    formula,  residuals  2 x  10^-21  ..  6 x  10^-21).
    The  spread  (0.89  ..  0.98)  is  the  audit  brackets'
    widths:  the  dmain  subtracted  is  main' . (t_R  -
    t_L)  with  t_R  -  t_L  =  0.005  ..  0.030  across  the
    five  brackets.
3.  The  "typical  gap  (0.62)"  should  read  ~0.29:  the
    local  density  of  the  3 x  10^10  band  end  is
    ~3.43  zeros  per  unit  t  (N(3 x  10^10)  =
    101,635,962,231  minus  N(3 x  10^9)  ~  9.06 x  10^9,
    over  2.7 x  10^10  units),  so  the  mean  gap  is
    ~0.29  —  matching  E10's  D2  local  mean  gap  0.282
    ..  0.292  at  the  top  of  the  band.  Hence  per
    typical  gap:  S  -  main  moves  ~3.55  *  0.29  ~  1.0,
    i.e.  the  drift  between  grid  points  is  O(1)  with
    the  same  order  as  the  jumps  —  the  E12  qualitative
    reading  (bounded  oscillation  +  ~1  jumps,  not  a
    slow  random  walk)  is  UNAFFECTED  and  is  in  fact
    SHARPENED:  the  drift  per  gap  is  not  just  O(1),
    it  is  ~1  with  the  jumps.

## E14.  The  [S1]  gap  as  a  single  number  —  the  wire  is
##       LINEAR  in  K,  so  the  data-free  Milino  K  is  a  live
##       closer  (VERDICT:  OPEN  —  two  live  endings,  one
##       decision  computation  apart)

High-level  statement  (what  would  close  [S1],  what  it
needs,  and  whether  it  is  feasible  here).

1.  THE  WIRE'S  EXACT  K-FORM  (verified  this  session  against
    the  Lean  source,  W2M5  +  M6  +  W2B3).  The  walk  bound
    K  =  sup|DN|  enters  the  certificate  in  exactly  two
    linear  places  and  nowhere  else:
      m5_floor:   S1  -  R  >=  -K * (|p 0|  +  |p M|  +
                   sum  |Dp  j|)      (the  log-kernel  cost)
      m5_idn:     |I_DN|  <=  K * sum|Dp|  +  L * (gap  form),
                   L  =  Rho(G2)  (the  RVM  slope  at  the
                   frontier)
    The  M6  composition  is  K-free  on  the  dev  side  (the
    feed  1  -  13/g  is  pure  detector  algebra)  and  carries
    the  noise  total  Bwire  +  Mr  +  Mf  as  a  NAMED
    hypothesis.  Consequence:  the  viability  of  [S1]  at  any
    candidate  K  is  ONE  inequality  —
        K * (kernel  cost  on  the  band)  +  L-terms  <=
        measured  wire  slack,
    and  the  kernel  half  is  CLOSED  (W2B3:  17/8  on  the
    far  side,  G2-free).  There  is  no  hidden  K-dependence;
    the  only  question  is  the  size  of  the  measured
    slack.

2.  THE  DATA-FREE  K  (unconditional,  no  data  beyond  the
    pin,  from  the  E7-verified  literature).  Milino
    (arXiv:1208.5846,  Theorem  1):  |S(t)|  <=  0.111  log t
    +  0.275  loglog  t  +  2.45  for  all  t  >=  e;  plus
    the  DN  =  S  +  convention  offset  bounded  conservatively
    by  5/8  (the  7/8-vs-3/4  shift  1/8  +  the  +-1/2  grid
    rounding  of  E1;  the  EXACT  offset  is  computable  —
    item  4).  Hence  a  provable  data-free
        K_uncond(T)  =  0.111  log  T  +  0.275  loglog  T
                        +  2.45  +  5/8
    with  K_uncond  =  6.21  (1e9),  6.30  (2e9),  6.35  (3e9),
    6.63  (3e10),  6.78  (1e11),  7.33  (1e13)  —  a  slow
    grow.  Against  the  measured  pin  2.615067  on
    (1e7,  3e10]:  the  ratio  is  2.535  at  3e10  —  the
    same  order,  not  the  10^10  of  the  certified  A2
    majorant  (which  is  the  total-variation  bound,  a
    different,  deliberately  loose,  object).

3.  THE  RH-CONDITIONAL  CROSS-CHECK  (CCM  Theorem  2,
    arXiv:1309.1526,  E7-verified  leading  term).  Under  RH
    |S(t)|  <=  (1/4)  log t / loglog t  +  O(log t  logloglog
    t / (loglog t)^2):  at  3e10  the  leading  term  is  1.895,
    +5/8  gives  2.520  —  which  sits  0.095  BELOW  our
    measured  sup|DN|  2.615067.  NOT  a  contradiction:  the
    O-term  has  magnitude  2.74  at  3e10  with  an  implicit
    constant,  and  0.095  is  a  3.5%  effect.  But  recorded
    as  a  FACT:  the  top  of  the  measured  walk  presses
    flush  against  the  RH-conditional  leading-term  envelope
    +  convention.  Tension  check  against  the  EXACT  CCM
    explicit  form  (with  its  O-constant)  is  queued
    references-first;  no  conclusion  drawn  here.

4.  THE  DECISION  COMPUTATION  (bounded,  executable,  the
    only  thing  separating  the  two  endings):
   (i)   the  exact  convention  offset  DN(gamma_n)  -
         S_cont(gamma_n)  from  the  band  counts  vs  a  dps-40
         argument  evaluation  at  the  zeros  (minutes;
         tightens  the  5/8  to  the  actual  c,  probably
         1/8  +  O(1/tau));
   (ii)  the  W2M6  pin  unit  (W2-BEYOND  section  7  open
         content  (c))  re-pinned  at  G2  =  3e10  with  K
         stated  as  the  Milino  form  (a  CITED  hypothesis
         in  the  m5  pattern);
   (iii) the  wire  slack  at  the  3e10  straddles:  the
         S1LowT  strip_squeeze  total  (Bwire  +  Mr  +  Mf)
         against  the  dev  feed  1  -  13/g,  with  the
         K-term  evaluated  at  6.63  vs  2.615  (the  gap  is
         the  linear  factor  2.535  on  the  K-term  portion
         of  the  noise  total).
    Verdict  by  arithmetic,  not  by  theorem:
      if  the  slack  at  K  =  6.63  stays  positive  ->
         [S1]  CLOSES  UNCONDITIONALLY  at  an  explicit
         constant  (Milino  CITED  +  one  data  pin  +
         measured  fills);  NO  new  theorem;  the  hA1
         clause  is  discharged  by  a  classical  bound,
         and  A1-proper  demotes  to  a  sharpness  item;
      if  the  slack  is  negative  at  6.63  ->  A1
         becomes  QUANTITATIVE  with  a  named  target:
         "bound  |DN(gamma)|  (equivalently  S  at  the
         zeros  +  c)  by  K_max",  where  K_max  =  the
         wire's  absorption  ceiling  measured  in  (iii)
         —  strictly  sharper  than  "S  is  O(1)  at  the
         zeros"  and  directly  attackable  (the  E7
         structural  fact  —  no  Omega  lands  at  zeros
         —  plus  E2's  delta-floor  barrier  tell  us
         WHERE  to  look:  a  signed-cancellation
         theorem  of  exactly  the  E3.4  shape  at
         scale  K_max).

5.  THE  HIGH-LEVEL  STATE  (the  picture  to  carry  forward).
    [S1]  is  no  longer  "an  open  theorem  of  unknown
    size".  It  is  ONE  number  —  K_max,  the  wire's
    absorption  ceiling  —  against  two  known
    competitors:  the  measured  pin  2.615067  (data,
    in  hand)  and  the  classical  Milino  6.63  (in  hand).
    The  program  either  closes  [S1]  unconditionally  with
    zero  new  mathematics  (ending  i)  or  learns  the  exact
    size  of  the  gap  it  must  fill,  as  a  named  constant
    (ending  ii).  Under  either  ending  the  RH  chain  is
    what  the  preprint  says  it  is  —  one  named  clause
    —  and  that  clause  now  has  a  MEASURABLE  size.
    Nothing  here  is  an  RH  claim  or  a  sub-claim:  the
    fills  are  still  the  measured  (C-pending)  leg,  and
    the  composition  stays  at  the  named-hypothesis  level
    until  (iii)  lands.

Artifacts/pointers:  W2M5.lean  (m5_floor  /  m5_idn,  the
linear  K-form),  M6.lean  (the  composition,  K-free  feed),
W2B3  (the  17/8  kernel  closure,  G2-free),  E7  (Milino  +
CCM  verified  against  primary  text),  W2-BEYOND  section  7
(open  content  (c)  =  the  W2M6  unit  of  item  4(ii)).

## E15.  The  decision  computation  (bound  side)  —  the
##       Milino  branch  is  DEAD  BY  ARITHMETIC;  the  A1
##       target  is  RECALIBRATED  to  the  signed  defect
##       (VERDICT:  E14  ending  (i)  REFUTED;  ending  (ii)
##       SHARPENED  and  RECALIBRATED)

Executed  item  (iii)  of  E14  (the  wire  slack  question)  on
the  bound  side,  with  the  exact  e4_wBound  kernel  cost
computed  on  all  505  in-hand  straddles  (kernel  values  direct;
 bracket  zeros  from  the  D  band  by  sparse  lookup;  the  far
 part  by  the  proven  E8  atom  5/8).

1.  THE  KERNEL  COST  C(t)  (e4_wBound  form  |p G1|  +  |p G2|
    +  discrete  TV  of  the  log  kernel  over  the  zero
    partition  on  (1e7,  3e10],  G2  =  the  pinned  last  zero
    under  3e10):
        min  68.15    median  76.88    max  91.80    (505 pts)
    Worst  straddles:  x = 2.79e10  k = +5:  C = 91.80;  the
    cost  is  dominated  by  the  descent  from  G1  (|p G1|
    ~ 13.8)  +  the  pole  V  at  the  straddle  (~2x|p(t+-)|,
    |p|  ~ 20  near  the  pole)  +  the  climb  back  —  all
    log-scale,  G2-free  (E4  architecture,  as  designed).

2.  THE  K-TERMS  (the  e4_tailFloor  one-sided  cost,
    S1  -  R  >=  -K * C(t)):
        data  pin  K = 2.615067:   K*C  =  201 .. 240
        Milino   K = 6.628:        K*C  =  509 .. 608
        (Milino  over  data  pin:  the  extra  308 .. 368  of
        E14  is  the  price  of  dropping  the  data  —  but  as
        item  3  shows,  BOTH  are  already  far  over  budget.)

3.  WHY  BOTH  DIE  (the  wire  normalization,  read  from
    S1LowT.strip_squeeze_v2  +  the  M6  composition).  The
    squeeze  closes  on
        dev_feed  -  noise_total  >  0,
    with  dev_feed  =  1  -  13/g  ~  1  —  an  O(1)-normalized
    budget.  The  walk  channel  enters  that  budget  through
    the  e4_tailFloor  role  as  the  ABSOLUTE  term  K*C(t).
    The  measured  W  (the  SIGNED  defect  after  the
    S3b/3.6  telescope  cancellation)  is  O(1):  0.85 / 3.30
    /  4.61  at  3.9e7  /  1e8  /  3e8  (S3c),  0.595  at  the
    1e10  splice  (day029_dcheck).  The  data  certificate
    passes  at  3e10  (mcert  1  +-  4e-9)  BECAUSE  the
    channel  is  filled  with  the  measured  post-cancellation
    residual.  The  bound  K*C  carries  NO  cancellation:
    even  at  the  DATA  PIN  K  =  2.615  it  is  201..240,
    i.e.  200x  the  entire  O(1)  budget  —  and  Milino's
    6.63  is  500..600x.

4.  THE  RECALIBRATED  STATE  (this  is  the  E2  barrier  at
    the  3e10  wire,  now  with  a  price  tag).  E2  proved
    the  absolute  sum  has  a  certified  floor  of  total
    variation  (~0.335  per  zero;  3.1e10  on  this  band);
    E15  measures  what  that  floor  costs  where  A1  is
    consumed:  ~2.5x10^2  ..  6x10^2  against  a  ~1  budget.
    Consequences:
   -  E14  ending  (i)  ([S1]  closed  by  the  Milino  data-
     free  K)  is  REFUTED  —  by  a  factor  of  ~10^2  ..
     10^3,  not  by  a  missing  digit.  No  generic-t  S-
     bound  (Milino,  RH-conditional  CCM,  or  any  other)
     can  feed  this  wire:  they  all  price  at  O(10^2  ..
     10^3)  absolute  against  an  O(1)  budget.
   -  E14  ending  (ii)  is  SHARPENED:  the  [S1]  closer  is
     not  "bound  |DN|  by  some  K"  (any  such  K  prices
     via  K*C  and  dies)  —  it  is  a  theorem  about  the
     SIGNED  defect  W  =  p(G2)DN(G2)  -  p(G1)DN(G1)  -
     int  DN  p'  (the  E3.4  object,  the  walk  against  the
     log  kernel  with  principal  value):  |W|  <=  O(1)
     (or  O(log  g / log^2  g))  UNCONDITIONALLY,  i.e.  a
     data-free  CANCELLATION  theorem.  That  is  exactly  the
     E1  restatement  ("S  bounded  at  the  zeros",  the
     level  —  not  the  total  variation)  read  through  the
     telescope,  and  E7  says  the  object  is  unclaimed  in
     the  literature  (no  Omega  lands  at  zeros;  no  S-at-
     zeros  level  bound  exists).
   -  The  data  side  is  now  a  full  band  fact:  the
     measured  W  is  O(1)  at  every  probe  height  we  have
     (3.9e7  ..  1e10),  decaying  (4.61  ->  0.595);  if  a
     signed  A1  theorem  exists,  the  data  want  the
     constant  to  be  ~1.
5.  WHAT  THIS  ANSWERS  (the  high-level  question  the
    program  has  carried  since  day035).  "Why  not  here,
    and  what  would  it  take":  not  here  because  the
    absolute-sum  mechanism  (R2/driftTwoSided,  A2-class  —
    which  is  everything  we  have  PROVEN  about  the  walk)
    prices  the  walk  channel  ~10^2  ..  10^3  over  the
    wire  budget  (E2  floor  +  E15  cost);  what  it  takes
    is  one  theorem  no  one  has  —  a  data-free  O(1)
     bound  on  the  SIGNED  walk-defect  on  the  log  kernel
    (equivalently  E1:  an  O(1)  LEVEL  bound  on  S  at  the
    zeros,  since  the  telescope  converts  level  to  defect
    at  O(1)  kernel  price)  —  with  the  data  (O(1),
    decaying,  all  probe  heights)  and  the  literature  (no
    refutation  of  the  level  statement,  E7)  both  pointing
    the  same  way.  The  program  stands  as  pre-printed:
    the  verification  +  falsification  machine  (now  with
    the  3e10  fill  en  route  to  696/696)  plus  ONE
    named  theorem  of  known  shape  and  known  data-
    behavior,  and  the  E2  barrier  records  precisely  why
    the  proven  mechanisms  cannot  bridge  it.

Artifacts:  the  C(t)  computation  (505  straddles;  kernel
per  E4's  pinned  form  p(g;t)  =  log|g^2  -  t^2|  -
log(g^2  +  1/4)  +  (1/2)/(g^2  +  1/4);  G2  pinned  2.9999999999762012e10;
 far  part  by  eullK_finite_var_far's  5/8);  sources  for
 the  W  measurements:  S3c  (END_GAME  3.6),  day029_dcheck
 (1e10  splice,  |D|  =  0.5951).

##  E16.  THE  CONVENTION  CONSTANT  IS  NOW  PINNED:  c = 1/8,
##       EXACT  (VERDICT:  E14  'TBD  CONVENTION'  CLEARED  AT
##       FULL  PRECISION;  CCM-TENSION  CHECK  SETTLED)

1.  THE  OFFSET.  Using  the  day041b  verified  pipeline
    (dps-30,  S  =  (phi_u  +  step)/pi,  s_data  N-exact),  at
    the  top-5  positive  excursions  (|DN|  =  2.615066528  ..
    2.576889038),  compute
        c  :=  DN(gamma)  -  S(gamma_+)
        S(gamma_+)  =  s_data(t_R)  +  main'  *  (t_R  -  gamma),
    with  main'(t)  =  log(t/2pi)/(2pi)  (the  E12-corrected
    inter-step  drift).  Results:  c  =  0.1250006,  0.1250034,
    0.1249928,  0.1250010,  0.1250079  —  spread
    1.5e-5  (limited  by  the  6-decimal  zero  values  in  the
    log),  i.e.  c  =  1/8  to  better  than  2e-5.
2.  WHY  IT  IS  EXACT  (not  just  close).  DN  on  the  zero
    grid  uses  the  EXACT  count  n  at  the  zero  (N(gamma_n)
    =  n  integer  —  no  +-1/2  grid  rounding,  which  was  the
    bulk  of  E14's  5/8  reserve);  the  project  Nas  carries
    the  3/4  constant,  the  classical  S  (RVM/Thm-10)  the
    7/8;  so
        c  =  (n  -  main  -  3/4)  -  (n  -  main  -  7/8)
            =  7/8  -  3/4  =  1/8,
    exactly,  up  to  O(1/gamma)  (~3e-11  on  this  band).  The
    5/8  of  E14  is  therefore  replaced  by  1/8  everywhere.
3.  THE  NUMBERS  WITH  THE  TIGHT  CONSTANT.
        K_uncond(T)  =  0.111 log  T  +  0.275 loglog  T
                      +  2.4575  (i.e.  Milino  +  1/8):
           1e9:  5.845    3e10:  6.128    1e11:  6.278
        ratio  to  the  measured  2.615067  at  3e10:  2.343
        (E14  had  2.535  with  5/8).  All  of  E15  is
        unaffected  in  kind  (the  wire  budget  is  O(1);
        these  are  O(6)  constants  —  still  100x  over).
4.  THE  CCM  TENSION  CHECK  (references:  arXiv:1309.1526,
    Theorem  2,  RH-conditional).  Leading  term  (1/4)(log  t
    /  loglog  t)  at  3e10  =  1.8947;  with  the  1/8:
    2.0197  vs  measured  2.615067  —  gap  0.5954.  The
    explicit  O-term  |log  t * logloglog  t / (loglog  t)^2|
    at  3e10  is  2.7567,  so  the  statement  is  consistent
    for  any  implicit  constant  >=  0.261  —  comfortably
    inside  the  norm  for  such  bounds.  NO  CONTRADICTION;
    the  RH-conditional  bound  is  a  genuine  tighter  pin
    (leading  term  already  below  the  measured  max),  its
    precision  at  this  height  lives  in  the  O-term.
    (A  PDF-level  explicit-constant  audit  is  an  available
    follow-up;  low  value  now  that  the  contradiction
    question  is  answered  "no".)
5.  STATE  OF  THE  A1/  [S1]  PICTURE  (unchanged  in  kind
    by  E16,  tightened  in  number):  [S1]  remains  the  single
    open  theorem;  the  data-free  generic-t  route  is
    refuted  by  a  factor  10^2  ..  10^3  (E15);  the  closer
    is  the  data-free  O(1)  SIGNED  defect  theorem  (the
    E3.4/W  object  =  E1's  level  statement  read  through
    the  telescope);  the  data  want  the  constant  ~1  (W
    measured  0.595  ..  4.61  and  decaying  over  3.9e7  ..
    1e10);  E2  records  why  the  proven  absolute-sum
    machinery  cannot  bridge  it  (now  with  the  10^2  ..
    10^3  price  tag  of  E15).

##  E17.  ATTACK  ON  THE  SIGNED-DEFECT  THEOREM  (attempt  1):
##       THREE  ROUTES,  EACH  MAPPED  TO  ITS  BREAK  POINT,  +
##       THE  ALIASING  HYPOTHESIS  FOR  THE  4e-9  DRIFT
##       (VERDICT:  THE  ATTACK  SPACE  IS  NOW  MAPPED;  TWO
##       EXPERIMENTS  IN  FLIGHT  DECIDE  THE  DRIFT;  THE
##       THEOREM  ITSELF  REMAINS  OPEN  --  BY  DESIGN)

This  entry  is  the  honest  account  of  a  direct  attack  on
the  E15  object  --  a  data-free  O(1)  bound  on  the  SIGNED
 defect  W(t)  =  S1Sum  -  RSum  on  the  zero  splice  --
attempted  and  mapped  route  by  route.  No  route  closes;
 each  is  recorded  with  the  exact  obstruction  (that  record
 is  the  deliverable  of  attempt  1  --  the  attack  space
 before  the  theorem).

0.  THE  OBJECT,  REFORMULATED  (why  it  is  what  it  is).
    With  p_j  =  p(gamma_j;  t)  (the  kernel's  per-zero  pair-
    log  factor)  and  DN_j  =  n_j  -  Nas(gamma_j)  (the  FIXED
    sequence,  independent  of  t):
        W(t)  =  p_0 DN_0  -  p_M DN_M  -  sum_j  (p_{j+1}  -  p_j)
                DN_j          (sums  over  the  splice  zeros).
    W  =  O(1)  uniformly  in  t  <=>  the  FIXED  DN  sequence
    is  a  discrete  log-potential  against  the  ONE-PARAMETER
    pole-kernel  family  p(.;  t)  up  to  O(1),  at  EVERY  t.
    That  is  a  2D  RIGIDITY  statement:  DN  as  a  function
    of  (j,  t)  --  the  t  enters  only  through  p(.;  t).
    This  reformulation  (not  S-at-zeros  per  se)  is  the
    attack  surface  the  rest  of  the  entry  probes.

1.  ROUTE  A  (via  the  S  level,  the  E1  restatement).
    Substituting  E16's  exact  offset  (DN  =  S(gamma_+)  +
    1/8  +  O(1/gamma)):
        W(t)  =  (1/8)(p_0  -  p_M)  +  sum_j  p_j S(gamma_j+)
                +  boundary  terms.
    If  |S(gamma)|  <=  L  (the  E1  level  bound):
        |W|  <=  L * sum_j |p_j|  +  O(1)   ~  100 * L.
    The  measured  level  is  L  ~  2.5  (|DN|  <=  2.615067,
    E10)  --  the  bound  gives  ~  250,  i.e.  the  E15  K-
    bound  in  another  outfit.  To  close  the  wire  (budget
    O(1))  from  a  bare  level  bound  would  need  L  <=
    0.01  --  250x  BELOW  the  measured  level.  OBSTRUCTION:
    a  level  bound  on  S  is  the  WRONG  TOOL  --  the  theorem
    must  use  the  CANCELLATION  of  the  pairing
    sum_j  p_j  S(gamma_j),  not  its  absolute  value.
    (This  is  the  E3.4  circularity  re-quantified:  even
    the  desired  conclusion  plus  the  desired  hypothesis
    do  not  close  the  distance;  the  pairing's  sign
    structure  is  the  content.)

2.  ROUTE  B  (Abel  /  DN-smoothness  pairing).
    What  we  have  PROVEN  about  DN:  |DN_j  -  DN_{j-1}|
    <=  delta  per  zero  (the  A2/R2  increment  bound,  from
    the  gap  structure  --  delta  ~  1  -  0.335  floor)  and
    a  certified  walk  ceiling  (3.1e10,  A2-class).  With
    p  MONOTONE  on  each  side  of  the  pole  (checkable:
    p'(g)  =  2g/(g^2  -  t^2)  -  2g/(g^2  + 1/4)  -
    g/(g^2  + 1/4)^2  <  0  for  g  <  t  and  >  0  for
    g  >  t,  t  >=  1)  --  the  Abel  sum  by  parts  gives
    exactly  the  no-cancellation  bound  K*C(t)  =  201  ..
    240  (E15).  OBSTRUCTION:  p  is  NON-OSCILLATORY  (a
    pole-kernel,  monotone  either  side),  so  Abel  summation
    buys  nothing;  pairing  cancellation  would  require  the
    DN  sequence  to  be  correlated  with  the  pole-kernel
    GLOBALLY  --  which  is  the  item  0  rigidity,  i.e.
    the  original  theorem.  Every  proven  property  of  DN  we
    have  (increments,  walk  ceiling,  level  at  probes)  is
    local  or  absolute;  none  carries  the  2D  correlation.

3.  ROUTE  C  (NEW  THIS  SESSION  --  the  ALIASING
    HYPOTHESIS  for  the  4e-9  DRIFT,  the  "coincidence
    to  look  for"  the  program  asked  for).  The  505-pt
    drift  law  (margin  -  1  ~  A(x)*k,  odd,  96.4%
    linear,  A(x)*x  =  0.9886  +  5.29e-12  x)  sits  3  ..
    4  orders  BELOW  the  f64  storage  scale  of  the
    re/im  sums  (measured  preflight:  f64-pairwise  vs
    80-bit-exact  sum  over  the  first  1.1e9  zeros  of
    the  1.016e11  tail  differs  by  9.5e-7  ABSOLUTE  IN
    THE  EXPONENT;  the  full-band  f64  ulp  at  |re|
    ~  1e11  is  ~  1e-7).  Hypothesis:  the  engine  stores
    re,  im  in  f64;  re_f64(t)  is  a  SMOOTH  function
    of  t  rounded  to  the  f64  grid;  the  rounding
    residual  is  a  sawtooth  in  t  of  period
    ~  ulp / |dre/dt|  ~  1e-10;  the  straddle  sampling
    (k  steps  of  0.5  in  t)  ALIASES  that  sawtooth
    into  a  slow,  quasi-linear-in-k,  window-specific
    drift  of  ~  1e-9  ..  1e-8  --  matching  the
    observed  law  in  sign-structure  (odd  in  k,  linear
    to  96.4%,  window-constant  offset).  If  true:  the
    drift  is  the  machinery's  own  roundoff  masquerading
    as  a  law  (a  numerical  artifact,  harmless  --  the
    margin  is  >=  1  at  80-bit-exact  re/im,  and  the
    C-reading  upgrades  to  a  clean  data  certificate).
    If  false  (the  drift  SURVIVES  the  80-bit-exact
    re/im):  a  genuine  O(1/x)*k  structure  in  the  zeta
    data  --  a  discovery  of  exactly  the  scale  the
    wire  needs  to  know  about.  DECIDER  IN  FLIGHT:
    day048  (dps-90/120  re-issue  of  the  worst-10
    negative-k  points,  dual-mode  f64  vs  80-bit-exact,
    replica  verified  BIT-EXACT  against  the  engine
    before  use).

4.  THE  CONSEQUENCE  CLARIFICATION  (A1  vs  RH,  now
    explicit).  Under  RH,  the  CCM  bound  allows
    |S(T)|  <=  (1/4)(log  T / loglog  T)  +  O(...)  --
    ~  1.9  at  3e10  but  GROWING  (->  infinity).  The
    wire  needs  the  SIGNED  defect  bounded  by  a
    UNIFORM  constant  below  the  O(1)  budget  --  not
    a  log/loglog  function.  So  the  A1  closer  is
    STRICTLY  BEYOND  what  RH  would  buy  us:  it  is  an
    additional  theorem  (which  the  data  favor:
    |S(gamma)|  <=  2.615  AND  DECAYING  through  3e10,
    0.595  at  the  1e10  splice)  --  the  program  is
    not  a  RH  lemma  program,  and  RH  alone  would
    not  close  [S1].  Recorded  here  so  the  preprint
    carries  the  exact  role  of  the  A1  ingredient.

5.  STATE  OF  THE  FLIGHT.  day047  (measured  W  =  the
    signed  splice  defect  on  (2.999e9,  3e10]  at
    five  heights,  including  the  worst  drift
    straddle  t  =  3232170970.112195,  split  mode;
    self-test  exact-0  against  dps-30  mpmath  before
    the  pass;  the  G2  boundary  re-cross-checked  the
    pinned  last  zero  29999999999.762012  from  the
    file  itself):  running,  ~6  hours.  day048  (the
    drift  decider):  running,  4  workers,  ~200
    single-core-minutes  total.  Neither  touches  the
    band  data  (stream-only,  files  r-x),  neither
    touches  Strix,  and  per-point  results  land  on
    disk  as  they  finish  (interrupt-safe).  The
    next  Lean  step  (W2-BEYOND  7(c),  the  W2M6
    pin  unit  --  re-pinning  the  wire  at  G2  =  3e10
    with  K  in  Milino  form  as  a  CITED
    hypothesis)  is  queued  for  the  turn  after
    results  arrive  --  references  fetched  first,  per
    the  standing  online-first  rule.

## E17.  The  W2M6  pin-and-refutation  unit:  GREEN  (the
##       formal  side  of  E14-E16)

What  landed  in  formal/RhAttack/W2M6.lean  (471  lines,  no
sorry),  imported  at  the  RhAttack  root;  full  lake  build
green  (17444  jobs),  mathlib  v4.33.1  pinned.

1.  WHAT  IS  NOW  MACHINE-PROVEN.
      kmil_3e10_bounds:
          612/100  ≤  K_mil(3e10)  <  615/100
        (the  Milino-form  K  with  the  E16-pinned
        convention  c  =  1/8,  at  the  band  frontier).
      pG1_pin_lower:
          3.2e9  ≤  t  ≤  3e10  ⇒  pG1  t  ≥  1151/100
        (the  left-pin  kernel  floor  on  the  band;
        E14's  single  number,  band  side).
      milino_channel_ge_70:
          K_mil(3e10)  *  |pG1  t|  ≥  70
        for  every  band  height  t  ≥  3.2e9.
      refutation_3e10:
          1  -  13/t  <  K_mil(3e10)  *  |pG1  t|
        the  O(1)-normalized  feed  (≤  1)  against  the
        cited-bounded  channel  (≥  70):  two-plus
        orders  of  magnitude  of  separation,
        data-free.
      m6_floor:  the  e4_tailFloor  wire  instantiated  at
        K  :=  K_mil(3e10)  (W2-BEYOND  7(c)).
    Every  bound  step  rides  on  closed-rational  e-pins
    (expfrac_1_10_u,  expfrac_1_5_l,  big241u,  big242l,
    big318u,  big32l,  big57601u,  bigpG1u),  each  a
    norm_num-exact  comparison  off  a  Real.exp_bound'
    /  Real.exp_bound  tail  estimate  with  the
    exp(big)  =  exp(int)  *  exp(frac)  decomposition.

2.  WHAT  IT  CLOSES  AND  WHAT  IT  DOES  NOT.  E14  priced
    the  [S1]  gap  as  LINEAR  in  K  =  sup|DN|;  the
    channel  term  K * |pG1|  is  now  proven  >=  70
    (against  feed  <=  1)  UNDER  THE  CITED  Milino
    hypothesis.  This  is  exactly  the  E15  data-free
    branch,  refuted-AT-THE-PIN  as  designed:  the
    absolute-sum  branch  prices  at
    K * (|pG1|  +  |pG2|  +  TV),  and  K * |pG1|  ALONE
    already  exceeds  the  feed  by  >  70.  Still  open
    (E16):  the  measured  SIGNED-defect  side  --
    day047  (the  W  measurement)  and  day048  (the
    drift  decider)  remain  the  two  live  numbers.

3.  FORMAL-TECHNICAL  RECORD  (for  the  next  units).
    *  Real.exp_bound'  /  Real.exp_bound  (pinned
       v4.33.1,  Complex/Exponential.lean:517/523):
       tail  |x|^n  *  (n.succ  /  (n.factorial  *  n)),
       sum  over  range  n;  the  one-sided  form  comes
       out  of  the  abs  form  via  abs_sub_le_iff.
    *  Real.log_mul  /  Real.log_div  take  (≠  0)
       arguments,  not  (0  <  x).
    *  In  this  mathlib  add_le_add_right  h  c  yields
       c  +  a  ≤  c  +  b  (LEFT-first);  for  the
       right-add  form  use  add_le_add  h
       (le_refl  c).
    *  pow_ne_zero  n  h  (n  first);  the  const  form
       -1  /  k  is  (-1)/k  (neg  OUTSIDE  the
       division  needs  explicit  parens);
       le_of_eq_of_le  orients  the  equality
       new  =  old.
    *  linarith  failed  on  the  atom  shape
       2  *  log  (32  *  10  ^  8)  where  an  opaque
       atom  of  the  same  shape  passed  (verified
       by  bisection  probe);  the  step  is  closed
       deterministically  via  add_le_add  term
       assembly  instead.
    *  An  UNANNOTATED
          have  h  :  0  ≤  (1/2)  /  (...)
        silently  types  as  a  NAT  proposition
        (positivity  closes  it  trivially  in  N,
        and  linarith  then  ignores  it  as
        not  a  Real  hypothesis)  --  always
        annotate  (0  :  R).

## E18.  The  two  decision  measurements:  the  dps-120  margin
##       re-issue  (landed)  and  the  3e10  signed-defect  run
##       (in  flight,  4  of  5  heights)

1.  THE  MARGIN  RE-ISSUE  (complete  --  the  worst-10
    negative-k  points,  re-measured  at  dps-90  AND
    dps-120  in  BOTH  arithmetic  modes  (f64-pairwise
    vs  80-bit-exact),  zeta/quads  at  dps-120).
      mnew  (high-precision  margin)  at  all  10  points:
          0.50227  ..  0.50363,  ALL  POSITIVE.
      *  dps-90  ==  dps-120  BIT-IDENTICAL  everywhere
         (precision  saturates  at  90  digits;  no
         further  reissue  is  needed).
      *  f64  vs  80-bit-exact:  |diff|  ≤  1.7e-6  at
         every  point;  at  the  two  k = -12  straddle
         points  the  80-bit  stream  replica  is
         BIT-EXACT  against  the  engine  (replica
         verified  before  use,  as  pre-registered).
      *  THE  MARGIN  IS  X-ONLY,  NOT  K.  At  fixed  x
         the  four  negative  k  values  present  (k =
         -12  ..  -9)  agree  to  <  2e-6  with  each
         other  (e.g.  four  values  at  x =
         3232170976.199116:
         0.5022754  /  0.5022759  /  0.5022776  /
         0.5022761).  The  k-structure  the  f64  ledger
         showed  at  these  points  was  ROUNDING  NOISE;
         the  true  margin  depends  on  x  alone
         (consistent  with  the  drift  law:  the  k
         structure  lives  in  the  DEFECT,  not  the
         margin).
      *  Smooth  monotonic  rise  in  x:  0.50228  at
         3.23e9  ->  0.50363  at  4.07e9.
      *  MIN  WORST-WINDOW  MARGIN  =  0.50227  at  x =
         3232170976.199116  (k  any;  the  x  alone
         suffices).
      *  V0-LEDGER  FIELD  IDENTIFIED:  the  ledger's
         "mnew"  column  equals  the  dev  quantity
         (≈  0.9999999963,  confirmed  per-point
         identical  in  the  reissue  files)  --  the
         ledger  stored  the  DEVIATION,  not  the
         margin  proper.  The  margin  proper  is  the
         0.5023-class  number  in
         out_day048_pts/SUMMARY.txt.
      CONSEQUENCE  FOR  THE  CLOSER:  the  C-reading
      stays  in  its  constructive  branch;  the
      margin  floor  entering  the  A1  wire
      computation  is  now  0.50227  (measured,
      dps-120,  dual-mode  cross-checked),  not  the
      ~ 1  the  ledger  field  suggested.

2.  THE  SIGNED-DEFECT  RUN  (in  flight  --  4  of  5
    heights  landed).  D(t)  =  sum_{(G1,G2]}  p  -
    int_{G1}^{G2}  p  rho  over  the  D  band
    G1  =  2999246000.18,  G2  =  3e10  (92,574,167,527
    D-band  zeros;  boundary  re-cross-checked  against
    the  pinned  last  zero  29999999999.762012  read
    from  the  file  itself).
      SUM-SIDE  PRECISION:  fsum  vs  mpmath-dps-30
      direct,  first  200000  slice  zeros:  |d|  =  0
      (BIT-EXACT,  <  1e-6  required),  PASS.
      D(3232170970.11)  =  -0.6300  -  1.5008i,
          |D|  =  1.628   (worst  drift  straddle)
      D(1e10)       =  0.6536  -  2.6100i,   |D|  =  2.691
      D(1.5e10)     =  0.7297  +  0.7056i,   |D|  =  1.015
      D(2.5e10)     =  4.5368  -  2.4811i,   |D|  =  5.171
      D(2.99e10)    =  4.9789  -  0.7885i,   |D|  =  5.041
          (the  wire-nearest  height;  92,219,492,047
          zeros  streamed;  4609  s;  quad  error  0.00)
      FULL  RUN  DONE  (27111  s  total  for  the
      five  heights).
      PRE-REGISTERED  READING  FIRES  (the  O(1)
      branch  of  the  day047  docstring):  |D|  stays
      <=  5.171  at  every  height  on  the  band  --
      the  signed-defect  data  story  (the  constant
      the  A1  O(1)  theorem  must  have)  COMPLETES
      TO  3e10.  No  refutation  signal  anywhere
      (the  other  pre-registered  branch,
      |D|  >>  O(1):  never  fired).
      STRUCTURE  NOTE:  |D|  runs  ~  1  ..  2.7  on
      the  lower  half  (3.2e9  ..  1.5e10)  and
      ~  5.0  ..  5.2  on  the  upper  half
      (2.5e10  ..  2.99e10)  --  a  window-effect
      (the  D-band  window  is  ~  10x  the  day029
      splice  window),  not  a  blowup:  the
      wire-nearest  value  5.041  is  BELOW  the
      2.5e10  value,  i.e.  no  growth  toward  the
      frontier.

3.  STATE  (final  for  the  3e10  data  side).
    Lean:  W2M6  GREEN  --  feed  <=  1  vs  channel
    >=  70  machine-proven,  K  and  pG1  pinned
    (E17).  Data:  the  margin  floor  is
    MEASURED  (0.50227,  x-only,  E18.1);  the
    signed  defect  is  MEASURED  O(1)  to  the
    wire  (max  |D|  =  5.171  on  the  band,
    5.041  at  the  wire-nearest  height,  E18.2).
    Every  number  the  [S1]  wire  consumes  on  the
    data  side  is  now  in  hand.  What  remains
    for  [S1]  is  exactly  what  E15  identified:
    THE  DATA-FREE  O(1)  SIGNED-DEFECT  THEOREM
    (equivalently,  E1:  an  O(1)  LEVEL  bound  on
    S  at  the  zeros  --  unclaimed  in  the
    literature  per  E7;  the  data  want  the
    constant  ~  1  ..  5).  That  is  a  theorem
    to  be  found,  not  a  computation  to  be
    run.

## E19.  The  A1  clause  as  stated  --  literature  verdict  (online-
##       verified)  and  the  provable  growth-form  wire  (LEAN-
##       PROVEN)

1.  THE  QUESTION.  E1  stated  A1's  universal  clause  as  "S  is
    bounded  at  the  zeros":  |S(gamma)|  <=  C  with  C  ABSOLUTE
    (independent  of  t),  at  every  zero  gamma,  data-free.
    Restated  in  the  wire's  own  idiom  (the  signed  deficit  D =
    S  -  main,  so  that  the  walk  side  is  the  pointwise
    |DS|  <=  K  on  the  zero  grid),  the  clause  is  a  single
    uniform  K  over  all  zeros.  This  entry  asks  the  question
    the  discipline  itself  has  been  asking  for  a  century,  and
    writes  down  what  it  answers.

2.  THE  LITERATURE  (all  fetched  and  read  online  during  this
    pass  --  arXiv  1309.1526  /  1503.00955  [CCM],  2101.01747
    [Dobner  survey],  2407.14867  [Sun-Wang],  2505.23573  [Sun-
    Wang-Yu],  2511.18275  [Jerby],  2507.04150  [Fazzari-
    Gerspach-Minelli],  2510.14309  [Inoue];  Titchmarsh  9.4/9.7
    for  the  classical  S  =  O(log  t)  and  the  N(t)  =  main  +
    S  +  O(1/t)  bookkeeping).  Three  facts,  each  with  a  source:

    (a)  NO  absolute  bound.  Not  one  published  theorem  asserts
        |S(t)|  <=  C  (C  independent  of  t),  at  the  zeros  or
        anywhere  on  the  line.  The  strongest  upper  bounds  are
        all  GROWTH  bounds:
            unconditional    S(t)  =  O(log  t)      [Backlund;
                                                  Titchmarsh  9.4]
            under  RH        |S(t)|  <=  (1/4  +  o(1))
                             .  log  t  /  log  log  t
                                          [CCM  Thm  2,  proof
                                           read  verbatim]
        So  "O(1)  at  the  zeros"  is  STRICTLY  STRONGER  than
        anything  the  field  currently  proves.

    (b)  OMEGAS  (S  is  unbounded).  S(t)  is  an  unbounded  func-
        tion:
            unconditional    S(t)  =  Omega( (log  t / log  log  t)^
                             {1/3} )           [Tsang]
            under  RH        S(t)  =  Omega( sqrt( log  t  .  log
                             log  log  t  /  log  log  t ) )
                                          [Bondarenko-Seip]
        i.e.  S  takes  values  that  grow  without  bound  (along
        subsequences  of  t).  A  uniform  |S(t)|  <=  C  over  ALL  t
        is  FALSE.  The  zero-subsequence  {gamma_n}  is  a  special
        case;  the  omegas  are  stated  for  general  t,  so  trans-
        ferring  them  to  the  exact  zero  set  needs  a  gap  step
        the  literature  does  not  supply  --  but  the  DISTRIBUTION
        results  below  do.

    (c)  DISTRIBUTION  (S  typically  grows  like  sqrt(log  log)).
        Every  recent  CLT  for  the  argument  normalizes  by  the
        GROWING  scale  sqrt(log  log  t):
            Selberg  CLT   (S(t)/sqrt(log  log  t))  ->  Gaussian
            (variance  (1/2pi^2)  log  log  t)  [Dobner  survey;
                                                 original  1946]
            Radziwill      Gaussian  persists  to  V  <<  (log  log  t)^
                             {1/2 + 1/10}   without  RH
            2024-2026      follow-ups  (all  five  arXiv  papers
                             above)  carry  the  SAME  sqrt(log  log)
                             normalization  (level  aspect,  GL2
                             twists,  RMT,  pair-correlation).
        If  |S|  <=  C  held  at  the  zeros,  then  S/sqrt(log  log)
        ->  0  along  that  dense  subsequence  (one  zero  per  ~
        2pi/log  t),  collapsing  the  non-degenerate  Gaussian  to  a
        point  mass  at  0.  The  entire  distribution  theory  is
        consistent  only  with  a  GROWING  typical  scale,  not  O(1).

3.  WHY  THE  DATA  LOOKS  O(1)  (the  red  hat  --  "one  is  in-
    visible").  The  measured  deficit  is  |D|  ~  1  ..  2.6  out  to
    the  3e10  wire,  flat.  That  is  not  evidence  for  O(1);  it  is
    what  a  slowly  growing  scale  LOOKS  like  at  3e10.  Evaluate
    the  fetched  asymptotic  expressions  at  t  =  3e10  (plain
    arithmetic  on  the  printed  formulas,  not  a  new  result):

        log  t          =  24.1
        sqrt(log  log  t)       =  1.78     (the  typical/CLT  scale)
        sqrt(log  t  .  log  log  log  t / log  log  t)
                                 =  2.96     (Bondarenko-Seip  omega  scale)
        (1/4)  log  t / log  log  t   =  1.90     (CCM  RH  bound,  main  term)

    Every  one  of  these  is  an  O(1)-looking  NUMBER  at  3e10
    (between  1.8  and  3.0).  The  data  cannot  distinguish  "truly
    O(1)"  from "slowly  growing"  at  this  frontier  --  the  growth
    is  there  but  below  the  ruler.  This  is  exactly  the
    "invisible  one"  in  the  owner's  puzzle:  the  clause  is
    invisible  to  the  data  out  to  3e10  BECAUSE  the  true  scale
    is  still  ~2  there.

4.  THE  PROVABLE  THEOREM  (LEAN-PROVEN,  green).  The  A1  clause
    at  the  strength  the  literature  actually  supports  is  the
    GROWTH-form  wire,  now  machine-checked  in
    formal/RhAttack/A1Growth.lean  (no  sorry;  lake  build  green;
    rhattack  gates  PASS):

        |DN  j|  <=  G  (x  j)  +  1/(x  j)   pointwise  on  the  grid
        =>   |S1  -  R|  <=  ( G  (x  M)  +  1 )  .  (17/8)  .
                             t^2  /  g1^2   on  the  far  side

    with  G  a  non-decreasing  growth  function.  Two  instantiations
    are  wired  and  LEAN-PROVEN:
        *  a1_growth_wire_log    the  UNCONDITIONAL  form  G  =  C
          .  log  (Backlund  S  =  O(log  t)  as  the  CITED  input);
        *  a1_growth_wire_ccm    the  RH  form  G  =  (1/4)  log  /
          log  log  +  (17/8)-class  correction  (CCM  Thm  2  as  the
          CITED  input).
    The  wire  is  a  THIN  WRAPPER:  it  collapses  the  pointwise
    growth  bound  to  one  global  K  =  G(xM)  +  1  (via  the  three
    small  LEAN-PROVEN  lemmas  log_div_x_le_one  /  grid_le_frontier
    /  grid_ge_origin)  and  then  calls  the  ALREADY  PROVEN
    W2B3.a1_universal_wire.  It  therefore  inherits  all  of  that
    proof's  correctness;  the  only  new  content  is  the  collapse,
    which  is  elementary  and  checked.

5.  VERDICT  (the  fair  boundary  =  the  line  of  verification).
    *  CLAIMED  AND  PROVEN:  the  growth-form  A1  (O(log  t)  un-
      conditionally;  O(log  t / log  log  t)  under  RH)  at  the
      zeros,  data-free.  Machine-checked.
    *  OPEN  /  PROBABLY  FALSE:  the  clause  as  ORIGINALLY  stated
      (absolute  O(1),  C  independent  of  t,  at  ALL  zeros).  No
      known  theorem;  contradicted  in  the  limit  by  the  omegas
      and  by  the  sqrt(log  log)  distribution  theory;  the  data's
      flatness  to  3e10  is  explained  by  the  slow  growth  being
      ~2  there  (the  "invisible"  red  hat),  not  by  an  absolute
      bound.
    *  THE  DATA'S  ROLE  (unchanged  from  E7  and  the  owner's
      boundary):  the  696/696  measured  record  is  a  MEASURE-
      MENT  that  is  consistent  with  the  theorem  and  prices  the
      constant  (~1  ..  5);  it  is  NOT  a  proof  input.  The
      proof  stays  100%  symbolic.

    The  theorem  is  no  longer  "S  is  O(1)  at  the  zeros  (to  be
    found)";  it  is  "S  is  bounded  AT  THE  ZEROS  by  the  best
    known  growth  scale,"  proven,  and  the  absolute-O(1)  form  is
    now  correctly  filed  as  the  open  problem  the  field  itself
    has  not  claimed.

## E20.  THE  A1  WIRE  DEAD  END  +  the  face/method  reframe
       (0289,  option  B,  discovery  0289)

    0.  WHAT  CHANGED  (the  A1  lane,  from  the  outside  in).

        Option  B  (the  owner's  direct  attack  on  the  terminal
        face)  needs  the  exact  status  of  the  A1  lane's  two  K
        forms:
            *  the  GRID-RESTRICTED  clause  (one  uniform  K  over  a
              finite  zero  grid)  -  CLOSED  data-free  at  the
              certified  frontier  (E14/E15,  0209:  K  =  6.6412  on
              [4,  3e10],  a1_grid_clause_exhibit);
            *  the  ABSOLUTE  clause  (one  uniform  K  over  ALL
              zeros,  unbounded  height)  -  filed  OPEN  /  PROBABLY
              FALSE  (E19  F1/F2,  face_unbounded).

        0289  adds  the  missing  quantitative  theorem  between  the
        two:  the  wire's  far-side  defect  bound  at  the  data-free
        growth  ceiling,  (G_explicit  g  +  1)  .  (17/8),  has  NO
        uniform  form  in  the  frontier:

            A1G.face_unbounded_ge4
                forall  K,  exists  T  >=  4,  K  <  G_explicit  T
            A1G.a1_wire_no_uniform_defect_bound
                not  exists  C,  forall  g  >=  4,
                    (G_explicit  g  +  1)  .  (17/8)  <=  C

        hence  the  grid-restricted  closure  does  NOT  extend  to  an
        all-heights  closure:  the  wire  is  a  FINITE-HEIGHT  machine
        (machine-verified).

    1.  THE  REFRAME  (goal  vs  method  -  corrects  the  E19/0286
        truth-value  attribution  at  the  face).

        *  THE  FACE  (the  object  RH  reduces  to,  0288)  is
          PROBABLY  TRUE  -  it  is  RH  above  3e12.
        *  THE  ABSOLUTE  A1  CLAUSE  is  the  INPUT  the  W2  wire
          method  would  need  -  PROBABLY  FALSE  (E19  F1/F2;  now
          quantitative  via  a1_wire_no_uniform_defect_bound).

        Goal  and  method  were  conflated  as  "one  object,  probably
        false".  They  are  the  same  object  operationally  (the
        0286  identity,  now  a  theorem  in  both  directions:
        RHEnd.faceIdentity_z78_plus_unified38  and
        faceIdentity_terminalFace_gives_unified38  -  the  0288
        terminalFace  IS  the  endpoint's  unified38  face,  +/-
        [Z78]  and  the  census),  but  the  face  is  probable-TRUE
        while  the  wire's  required  input  is  probable-FALSE.  The
        attack  on  the  face  therefore  must  use  a  NON-WIRE
        mechanism  (the  face-menu,  discovery  0289  /  record  19.4):
        the  theta  =  infinity  lane  (alive,  named  conjecture,
        Bettin-Gonek  2017)  and  frontier  extension  (the  only
        machine-verified  shrinking  lane);  the  S-route  is  dead
        (its  absolute  bound  is  exactly  what  is  probably  false).

    2.  NO  RH  CLAIM.  The  face  is  open;  E20  is  the  attack's
        first  unit  (dead-end  theorem  +  identity  theorems  +
        reframe  +  menu).

## E21.  THE  theta  =  infinity  LANE,  NAMED  AND  WIRED
       (0290,  option  B,  unit  2;  discovery  0290)

    0.  WHAT  CHANGED  (the  M2  lane,  from  the  outside  in).

        0289  (E20)  removed  the  W2/A1  WIRE  from  the  face-menu
        (finite-height  machine;  dead  end  at  unbounded  height).
        The  M2  lane  -  the  theta  =  infinity  conjecture  -  is
        now  the  lead  ALIVE  non-wire  mechanism,  and  it  is
        formalized:

            *  New  module  RhAttack.ThetaInf  (namespace  ThetaInf;
              build  green,  full  tree  green  17454  jobs).
            *  Self-contained  apparatus:  thetaMoll  (the  Levinson
              mollifier  M_Y(s)  =  sum  mu(n)  n^(-s)  (1  -  log
              n/log  Y),  total  in  the  real  length  Y)  and
              thetaIMoment  (the  mollified  second  moment
              I_Y(T1,T2)  =  int  |M_Y(1/2+it)|^2  |zeta(1/2+it)|^2
              dt).
            *  thetaInfConjecture  -  the  conjecture  in  its  EXACT
              form  (1.2)  of  Bettin-Gonek  (arXiv:1604.02740,
              re-pulled  verbatim):  for  EVERY  theta  >  0,
              lim  I_{T^theta}(0,T)/T  =  1  +  1/theta
              (proven  only  0  <  theta  <  1/2:  Levinson  /
              Conrey).
            *  thetaBounded  theta  -  the  antecedent  of  Theorem
              1  (fixed  theta):  I_N(0,T)  <<_eps  T^(1+eps)  for
              2  <=  N  <=  T^theta.
            *  bgThetaShrink  theta  -  CITED  (Theorem  1  +  the
              functional-equation  reflection):  antecedent  =>
              zero-free  in  BOTH  flanks  (Re  >  1/2  +  1/(2
              theta)  and  Re  <  1/2  -  1/(2  theta)).
            *  thetaInfImpliesAllOnLine  -  CITED  (Farmer  kappa
              =  1  +  Theorem  1  particular  case):  conjecture
              =>  every  zeta  zero  on  the  line.

    1.  THE  MACHINE-VERIFIED  WIRING  (the  LEAN-proven  part).

            *  terminalFace_of_thetaInf:  [cited  implication]  +
              [cited  conjecture]  =>  terminalFace.  Lane  M2  is
              WIRED:  proving  (1.2)  for  all  theta  CLOSES  the
              face.
            *  terminalFace_of_bgShrink:  for  any  fixed  theta
              >  0,  the  cited  antecedent  +  cited  flank
              zero-free  +  the  theta-FACE  (no  off-pair  at  t0
              >=  tPT2  in  0  <  d0  <=  1/(2  theta))  =>
              terminalFace.  Every  cited  theta  SHRINKS  the
              face  from  3/8  to  1/(2  theta);  theta  ->  inf
              collapses  it.  theta  =  4  already  excludes  the
              route-(b)  face  zero  (d0  =  0.37477  >  1/8,  left
              flank).

    2.  PRIMARY  SOURCE  AND  2026  STATUS.

        *  Bettin-Gonek,  "The  theta  =  infinity  conjecture
          implies  the  Riemann  hypothesis",  Mathematika  63
          (2017)  29-33,  arXiv:1604.02740  -  re-pulled  via
          ar5iv  (verbatim  quotes  in  the  module  docstring
          and  in  record  section  20).
        *  Theorem  1  (fixed  theta):  antecedent  =>  no  zeros
          in  Re  s  >  1/2  +  1/(2  theta);  "In  particular,
          if  ...  with  theta  arbitrarily  large,  then  the
          Riemann  hypothesis  is  true."
        *  ALIVE  AND  ACTIVE  in  2026:  arXiv:2605.24363
          extends  the  implication  to  cuspidal  automorphic
          L(GL_m);  the  unconditional  Levinson-type  record  is
          at  least  2/3  of  the  zeros  on  the  line
          (Conrey-Chandee-Farb-Young).

    3.  THE  RESEARCH  TARGET,  NOW  PRECISELY  NAMED.

        The  analytic  content  of  M2  is  one  statement:
        EXTEND  THE  LEVINSON-CONREY  ASYMPTOTIC  (1.2)  BEYOND
        THETA  =  1/2  (frontier:  CCFY).  Honesties  recorded
        in-module:  (i)  Theorem  1's  antecedent  in  its
        range-uniform  <<_eps  shape  is  STRONGER  than  the
        pointwise-in-theta  asymptotic;  the  two  are  NOT
        linked  in-tree;  (ii)  the  left-flank  zero-free  is
        the  functional-equation  reflection  of  Theorem  1's
        right  flank.

    4.  NO  RH  CLAIM.

        The  conjecture  is  a  conjecture;  the  antecedent  is
        not  known.  The  face  remains  OPEN  without  the  cited
        inputs.  This  unit  NAMES,  CITES,  and  WIREs  the  lane
        -  it  does  not  prove  it.

## E22.  THE  M5  RE-ANCHOR  +  the  0290  proportion  corrigendum
       (0291,  option  B,  unit  3;  discovery  0291)

    0.  WHAT  CHANGED  (the  M5  lane,  from  the  outside  in).

        0289  named  M5  the  "only  machine-verified  SHRINKING
        lane".  It  now  WORKS  END-TO-END:  a  fresh  October-2026
        certified  artifact  moves  the  census  frontier  strictly
        above  the  Platt-Trudgian  height,  and  the  0288  exact
        residual  is  RE-PINNED  at  the  new  frontier
        (machine-verified).

    1.  THE  CITATION  (primary  source,  pulled  2026-11-11).

        P.  W.  Murphy,  "A  certified  window  of  zeros  of  the
        Riemann  zeta  function  just  above  3e12,  with  a
        machine-checked  Riemann-Siegel  remainder",  October
        2026  (zenodo  record  23486195;  dataset  23486196;  paper
        23489697).  Theorem  1:  the  20,000  zeros  between  the
        Gram  points  g_a  (a  =  12363153437130)  and  g_b
        (b  =  12363153457130)  are  all  simple  and  on  the
        line,  with  g_a  in
        [3000175332798.574911824343  ±  1.60e-13]  and  g_b  in
        [3000175337471.510047088127  ±  1.86e-13].  g_a  lies
        just  below  H0  =  3000175332800  (exactly  WinC.tPT2);
        combined  with  Platt-Trudgian,  every  zero  with
        0  <  Im  <=  g_b  is  on  the  line.  Method:  128-bit  Arb
        ball  arithmetic;  the  RS  remainder  by  a  Lean-4
        kernel-checked  theorem;  Turing  counting  (Amberger-
        corrected  block  count);  positive/negative  controls;
        independent  audit;  AI-assisted  (its  own  provenance
        note).

    2.  THE  MODULE  (DONE,  RhAttack.CE1;  build  green,  full
        tree  green  17454  jobs).

            *  tCE1  :=  3,000,175,337,471   the  NEW  certified
              census  frontier  (an  integer  strictly  below  g_b,
              machine-verified).
            *  ce1WindowAboveTPT2  -  the  cited  window  clause
              (Z78  pattern).
            *  allOnLineUpToCE1  -  [Z-PT2]  +  [CE1]  =>  the
              census  up  to  tCE1.  THE  FRONTIER  MOVED.
            *  terminalFaceCE1  -  the  re-anchored  face;
              faceShrinkExact:  the  height  domain  shrank  by
              exactly  4671  units.
            *  rh_split_at_CE1  -  the  0288  residual  RE-PINNED
              (RH  q  iff  census-tCE1  and  faceCE1;  pure
              logic).
            *  terminalFaceCE1_iff_face0  -  the  two  face
              formulations  EQUIVALENT  under  [CE1]  (the  shrink
              is  a  certificate,  not  a  logical  move).
            *  rh_reanchored_CE1  -  HEADLINE:  RH  q  iff
              terminalFaceCE1  q,  given  [Z-PT2]  +  [CE1].
            *  terminalFaceCE1_of_thetaInf  -  the  0290  M2
              closing  lands  DIRECTLY  at  the  new  frontier.

        The  extension  is  tiny  (~1.6e-9  relative;  the  source
        says  it  "says  nothing  about  RH  beyond  the  window");
        the  value  is  that  M5  is  now  a  WORKING  PIPELINE:
        every  future  window  above  H0  re-anchors  the  face  by
        the  same  two-line  machine  composition.

    3.  THE  0290  CORRIGENDUM  (proportion  attribution).

        0290  attributed  "at  least  2/3  of  the  zeros  on  the
        line"  to  CCFY.  BOTH  PARTS  CORRECTED  (FRONTIER_MAP
        August  2026,  from  primary  sources):

            *  Accepted  Levinson-lineage  record  (with
              multiplicity,  N0/N):  kappa  >=  0.417293962,
              Pratt-Robles-Zaharescu-Zeindler,  Res.  Math.
              Sci.  7  (2020),  arXiv:1802.10521v3.
            *  The  0.67250070367941164573  figure  is  an
              August-2026  NOT-YET-REFEREED  result  for  DISTINCT
              /  simple  on-line  zeros  (N*0):  Anthropic
              preprint  (problem  of  J.  Sumner),  extended  to
              0.673008528  by  Ainta  (Sunghyeon  Jo),  independent
              proof  by  Lamzouri.  Formally  a  different  count.
              The  CCFY  attribution  is  RETRACTED.
            *  Chain:  Selberg  1942  ->  Levinson  1974  (1/3)
              ->  Conrey  1989  (0.4088)  ->  B-C-Y  2011
              (0.4105)  ->  Feng  2012  (0.4107)  ->  Pratt-
              Robles  2018  (0.4128)  ->  PRZZ  2020
              (0.417293962)  ->  [2026  unrefereed:  0.6725  ...
              distinct  counting].

    4.  NO  RH  CLAIM.

        The  face  remains  OPEN;  the  re-anchor  is  a
        certificate;  the  two  face  formulations  are  provably
        the  same  open  object.

## E23.  THE  2026  MECHANISM  SEAL  -  M2  target  pinned,
       lane  M6  audited,  face-menu  COMPLETE  (0292)

    1.  M2  TARGET  (the  theta  =  1/2  BARRIER,  primary  sources).

        *  BG  (1.2):  lim  I_{T^th}(0,T)/T  =  1  +  1/th
          proven  only  for  0  <  th  <  1/2;  th  =  inf  is
          Farmer's  extension.
        *  PRZZ  (arXiv:1802.10521)  section  1.3:  B-C-H-B  "pushed
          the  size  of  the  length  th  PAST  THE  1/2  BARRIER
          to  9/17"  (degree-2  test  functions);  section  9(3):
          generic-coefficient  ceiling  th  =  17/33  -  eps;
          section  9(4):  "What  would  be  a  good  balance  in
          the  degree  d  vs  truncation  l?"  (the  active
          FRONTIER  question);  on  th  =  inf  itself:  "Bettin-
          Gonek  proved  ...  RH  would  follow  (not  just
          100%)...  Of  course,  we  are  VERY  FAR  AWAY  from
          such  lengths  of  mollifiers."
        The  record  proportion  line  (with  multiplicity):
        kappa  >=  0.417293962  (PRZZ  2020).  The  1/2  barrier
        is  REAL  and  NAMED;  the  escape  mechanisms  (degree,
        arithmetic,  twists)  are  the  2026  frontier.

    2.  LANE  M6  (NEW,  audited  BLIND)  -  the  2026
        proportion-COMPLETE  family.

        *  Alpog-Furman  2026:  >=  2/3  simple  AND  on  the
          line  (Gabor-frame  Gram  certificate,  bandwidth
          L  =  log(T/2pi));  first  public  route:  Aug-2026
          Anthropic  preprint,  problem  of  J.  Sumner;
          independent  proof  by  Lamzouri.
        *  Ainta:  0.673008528  (7-point  finite
          certificates).
        *  Clipped-Gram  (zenodo  23286387):  liminf
          N_ms0/N  >=  66812491/99194876  =
          0.67354780502...  (simple  on  line,  WITH
          multiplicity)  -  highest  constant.
        *  Spectral  TWIN  (rStation  p.109,  Nov  2026):  a
          lattice  of  REFLECTED  OFF-LINE  PAIRS  at  spacing
          <=  frame  step  has  EXACTLY  the  Gram  matrix  of
          on-line  double  zeros,  AT  EVERY  DEPTH,  every
          window;  the  2/3  certificate's  extremal  data  are
          reproduced  by  a  configuration  with  A  THIRD  of
          its  zeros  at  ANY  depth  (model  corollary,
          caveat  recorded  verbatim);  "no  zero-density
          estimate  beyond  N(sigma)  <=  (1/6+o(1))N".
        Verdict:  the  family  is  compatible  with  the  SPARSE
        face  BY  CONSTRUCTION  (twin  =  on-line  doubles,
        certified-equivalent).  AUDITED  and  CLOSED  as  a
        face-closer;  the  proportion  results  STAND.

    3.  FACE-MENU  (terminal  state,  M1-M6):  M1  dead  (gate
        antecedent  false,  0284);  M2  wired  +  target  pinned
        (0290/0292);  M3  dead  walls  (0278-0283);  M4  wrong
        side  (0285);  M5  WORKING  (0291  -  re-anchor  or
        detect);  M6  audited  blind  (0292).

    4.  NO  RH  CLAIM.  Record-level  unit  (0280/0285  pattern);
        nothing  new  in-tree  logic  this  unit.

## E24.  THE  LEVINSON  WALL  -  the  EXACT  gap  object  of  lane
       M2,  NAMED  AND  CLOSED  OFF   IN-TREE   (0293,  LEAN:
       RhAttack.LevWall)

    1.  THE  POINTWISE  STATEMENT  (1.2)  AT  A  FIXED  THETA
        (in-tree,  over  the  existing  thetaIMoment  of  0290):

            asympAt  th  :=
              Tendsto  (fun  T,  thetaIMoment  (T^th)  0  T /  T)
                      atTop  (N  (1  +  1/th))

        *  thetaInf_iff_pointwise  (machine,  definitional):
          thetaInfConjecture  =  "asympAt  at  every  th  >  0".
        *  [LEV-WALL]  levWallAt  th  :=  asympAt  th  -  the
          NAMED  open  input.  PUBLISHED  REACH  0  <  th  <
          4/7  (Levinson  1974:  0  <  th  <  1/2,  ORIGINAL,
          kappa  >  1/3;  Conrey  1989:  th  <  4/7,  VARIANT,
          kappa  >  2/5  -  both  quoted  VERBATIM  from
          Bettin-Gonek  section  1).  OPEN  for  th  >  4/7.

    2.  THE  GAP  SET  +  its  shape  (all  machine):

          levWallGap  :=  {  th  |  4/7  <  th  }

        *  1/2  <  4/7  <  1     (range  arithmetic).
        *  th  =  1  IS  a  gap  angle  (gapNonempty).
        *  gapUnbounded:  the  th  =  inf  target  has  NO
          finite  endpoint.
        *  HISTORICAL  FLIP  (BG  section  1  verbatim):
          (1.2)  was  "initially  believed"  to  FAIL  for
          th  >  1;  Farmer's  heuristic  suggests  EVERY
          th  >  0.  The  gap  is  exactly  the  intended
          domain  of  the  CONJECTURE.

    3.  THE  CLOSING  WIRE  (GAP  OBJECT  EXPOSED,  machine):

          terminalFace_of_levWall :
            (hqz)  +  (hInf  :  thetaInfImpliesAllOnLine)
            +  (hWall  :  all  th  >  0,  levWallAt  th)
              =>  terminalFace   [0288  exact  residual]

        Closing  the  face  via  M2  =  proving  levWallAt  at
        every  th  in  levWallGap.  NAMED,  not  folklore.

    4.  TWO  THETAS,  KEPT  DISTINCT:

          asymp  th      :  published  0  <  th  <  4/7,
                            OPEN  th  >  4/7,  target  inf.
          prop.  th_F    :  standard  1/2  -  eps  (the
                            NAMED  "1/2  BARRIER"),  9/17
                            (B-C-H-B  degree  2),  4/7
                            (PRZZ  kappa  >=
                            0.417293962  record).

        Same  PHENOMENON  (degree-1  length  stops  at  1/2;
        cross  it  needs  higher  degree  /  structure),  but
        the  record  keeps  the  two  DISTINCT  from  here  on.

    5.  HONESTY:  the  wall  is  defined  by  its  PUBLISHED
        REACH  (what  the  sources  state),  NOT  by  a  memory-
        reconstructed  diagonal/off-diagonal  split  -  that  is
        intentionally  NOT  in-tree.  LevWall  GREEN  (8766
        jobs);  full  tree  GREEN  (17454).  NO  RH  CLAIM.

## E25.  THE  RADZIWILL  LIMITATION  +  THE  WALL  SHARPENED  -
       the  M2  gap  object  is  the  SHARP  residual  asymptotic
       1/th  (0294,  LEAN:  RhAttack.LevWall2,  tree  green  17454)

    1.  THE  PRIMARY  SOURCE  (arXiv:1207.6583,  pulled  2026-11-11):

        *  THE  RESIDUAL:
          I(M)  =  (1/T)  int_T^{2T}
                   |1  -  M_T(1/2+it)  .  zeta(1/2+it)|^2  dt
          (infimum  over  T  >=  T0  "sufficiently  large").
        *  RADZIWILL  THEOREM  1  (UNCONDITIONAL,  ALL  th  >  0):
          int_T^{2T} |1 - M_T zeta|^2 dt  >=  (c/th) . T,
          c  >  0  INEFFECTIVE.  Proof  split:  Prop  A  =
          Sobolev-inequality-ON-THE-ZEROS  (valid  for  ALL
          th);  Prop  B  =  the  B-C-H-B  /  Soundararajan
          EXPLICIT  OFF-DIAGONAL  QUADRATIC  FORM  (the  sharp
          bound;  th  <=  1/2).
        *  THE  SHARP  ASYMPTOTIC  (residual/T  ->  1/th,  c  =
          1)  IS  PUBLISHED  ONLY  FOR  0  <  th  <  1/2.
          Conrey's  4/7  is  the  (1.2)  MOMENT  frontier,  a
          corollary  of  the  sharp-residual  machinery  in  its
          published  range.

    2.  THE  SHARPENING  (what  the  M2  lane  actually  needs):

        *  the  universal  limitation  (all  th,  ineffective
          c)  is  NOT  the  frontier  obstruction  -  it  is
          unconditional  and  a  CONSTRAINT  on  every
          solution:  NO  MOLLIFIER  ROUTE  CAN  BEAT  1/th
          (the  1/th  residual  mass  at  long  scales  is  an
          invariant  floor  -  mollifier  improvement  alone
          can  never  close  the  face).
        *  the  NAMED  OBSTRUCTION  is  now  [BARRIER-ASYMP]
          levSharp  th  at  th  >  1/2:  exactly  the  new
          OFF-DIAGONAL  CONTROL  at  longer  sums.

    3.  THE  MACHINE  BRIDGE  (LevWall2.lean,  ALL  PROVEN):

        *  line objects:  line  t  =  1/2  +  it  (avoids  the
          pole  at  1),  continuity  of  zeta-circle-line  via
          mathlib  differentiableAt_riemannZeta,  continuity
          of  the  full  integrand  w  =  M .  zeta.
        *  residPointwise:  |1-w|^2  =  1  +  |w|^2  -  2 Re w.
        *  wThetaNormEqMoment:  |w|^2  =  |M|^2 .  |zeta|^2  =
          EXACTLY  the  (1.2)-moment  integrand.
        *  residExpand  (interval  linearity):
          int  |1-w|^2 dt  =  T  +  thetaIMoment  -  2 .
          thetaReMain.
        *  residSharp  (THE  WALL  THEOREM,  limit  algebra):
          [ASYMP-2T  th]  +  [MOZ-MAIN  th]  =>  levSharp  th
          -  ANY  proof  of  (1.2)  past  the  frontier  MUST
          make  the  residual  achieve  EXACTLY  1/th.
        *  range  ordering  (PROVEN):
          1/2  <  9/17  =  1/2 + 1/34  (B-C-H-B  length)
          <  4/7  (Conrey  (1.2)  frontier)  <  1.

    4.  CONSEQUENCE:  extending  M2  <=>  levSharp  past
        th  =  1/2  <=>  new  off-diagonal  control.  The  two
        thetas  stay  distinct:  the  (1.2)  asymptotic  th
        !=  the  0290/0291  proportion-method  length  th_F.
        levSharp  at  any  th  is  a  NAMED  OPEN  input.
        NO  RH  CLAIM.  Face  OPEN  /  PROBABLY  TRUE.

## E26.  THE  WALL,  UNIFIED  +  THE  2025-2026  AUDIT  (0295,
       LEAN:  RhAttack.LevWall3,  tree  green  17454)

    1.  UNIFICATION  (machine):  residSharp  (0294)  shows
        the  sharp  residual  levSharp(th)  is  a  LOGICAL
        COROLLARY  of  (1.2)  +  the  main  term  -  so  the
        [BARRIER-ASYMP]  reach  =  the  (1.2)  +  main-term
        reach  =  CONREY  4/7  (not  Radziwill's  stated
        Prop-B  1/2,  which  is  his  conservative  range  in
        the  limitation  theorem).  ONE  WALL,  ONE  GAP
        SET:  unifiedGap  =  {  th  |  4/7  <  th  }
        (PROVEN  set  equality  with  0293's  levWallGap);
        1/2  <  9/17  <  4/7  (PROVEN);  the  unified  wall
        is  the  SMALLER  obligation  (moment  past  4/7
        carries  the  residual  via  the  corollary).
        [UNIFIED-WALL]  :=  forall  th  >  4/7,  (1.2)@th
        =  the  single  named  open  requirement  of  the
        M2  lane  after  0292-0295.

    2.  AUDIT  2025-2026  (searched  2026-11-11):  the
        off-diagonal  length  barrier  is  UNMOVED.
        *  Lin  2025  (arXiv:2508.11108,  Aug  2025):
          variational  optimization  of  the  derivative
          COMBINATIONS  (the  Q-side  of  Levinson's
          method);  doubles  modular-L  proportions  with
          the  SAME  arithmetic  -  the  length  theta
          frontier  is  explicitly  NOT  moved  ("combining
          beats  lengths  when  short").
        *  Farmer  1993  (Mathematika  40:  theta=inf
          +  first  ratios  conjecture)  and  Bettin-Gonek
          2017  (Mathematika  63:  theta=inf  =>  RH)
          re-confirmed  (MO  515314  expert  answer)  as
          the  in-tree  [BG-IMP]  chain  (0290).
        *  VK  zero-free  region  papers  2025-2026:
          constants,  not  exponents.
        FRONTIER  STATUS  (CURRENT  as  of  2026-11-11):
        moment  (1.2):  0  <  th  <  4/7;  sharp  residual:
        same  via  corollary;  proportion  records  1/3
        (Levinson)  <  2/5  (Conrey)  <  0.417293962
        (PRZZ  kappa  record);  gap  =  {  th  |  4/7  <
        th  }.

## E27.  THE  SECOND  DOOR  +  THE  RATIOS  AUDIT  (0296,  LEAN:
       RhAttack.LevWall4,  tree  green  17454)

    1.  RATIOS  AUDIT  (negative  result):  the  ratios
        conjecture  (Farmer  1993  (7.4),  4-ratio  mean)
        is  the  HEURISTIC  PARENT  of  the  thetaInf
        conjecture  -  the  ratios  support  for  (1.2)@all-
        theta  is  CONJECTURAL  in  1993,  and  BG  2017
        never  mentions  ratios.  The  PUBLISHED  direction
        is  the  REVERSE:  (1.2)@all-theta  =>  kappa  =  1
        (100%  on  the  line,  Farmer  1993  PROVEN).  The
        2023-2026  ratios  literature  (arXiv:2307.08091
        etc.)  proves  SPECIAL  means,  nothing  past  4/7.
        The  ratios  conjecture  is  a  SIBLING,  not  a
        citable  shortcut  (as  of  2026-11-11).

    2.  THE  TWO  DOORS  (machine  LevWall4):
            DOOR  1  [thetaInf /  unified  wall]
                    (1.2)  at  every  theta  (published  to
                    4/7;  gap  {  theta  |  4/7  <  theta  })
            DOOR  2  [BG-ANT-ALL  +  BG-T1-ARB]
                    I_N(0,T)  ≪_eps  T^(1+eps)  on  2<=N
                    <=  T^theta  at  EVERY  theta  (published
                    pointwise-shape  to  theta  <=  1/2;
                    the  RANGE-uniform  shape  is  the
                    genuinely  stronger  form)
        terminalFace_of_bgArb  (machine):  door  2  +  the
        cited  [BG-T1-ARB]  implication  (proven  INSIDE
        BG  2017,  the  "In  particular"  clause)
        =>  terminalFace.  The  doors  are  NOT  linked
        in-tree  by  proof  (honesty).

    3.  THE  THETA-FACE  FAMILY  IS  COLLECTIVE  (machine):
        thetaFaceExist  (every  d0  >  0  in  some
        theta-face);  thetaFacesCover  (the  union  of  the
        theta-faces  =  the  whole  off-line  range):
        no  single  cited  theta  closes  the  face,
        infinitely  many  do.

## E29.  DOOR-2  DECOMPOSITION:  THE  TWO  DOORS  ARE  THE  SAME
       WALL  (0298,  record-level  audit  -  entry  0298,
       route  record  section  28)

    The  0296  face  has  two  doors  (door  1:  the  (1.2)  sharp
    asymptotic;  door  2:  the  BG  Theorem-1  antecedent,
    `thetaBounded`  in-tree).  Audit  (0280  pattern):

    1.  DECOMPOSITION:  the  antecedent  `I_N(0,T) ≪_ε
        T^(1+eps)`  uniformly  over  `2 <= N <= T^theta`  splits
        into  (A)  N <= T^(eps/3):  STANDARD  -  |M_N(1/2+it)| <=
        C sqrt(N)  +  the  Hardy-Littlewood  POINTWISE  SECOND
        MOMENT  int_0^T |zeta(1/2+it)|^2 dt = T log(T/2pi) + O(T)
        (cited,  classical)  =>  I_N <= C N T log T <= O_eps
        (T^(1+eps));  (B)  T^(eps/3) <= N <= T^theta:  the  (1.2)
        asymptotic  on  [delta,  theta]  (compact-uniform  reading,
        standard  -  the  methods'  constants  diverge  at  theta' ->
        0,  not  on  compacts)  =>  I_N <= (1 + 1/delta)(1 + o)(T)
        = O_eps(T).  Parts  A+B  =  EXACTLY  the  antecedent's
        shape  (one  C_eps,  one  T0).

    2.  CONSEQUENCE:  door  2  at  theta  =  door  1  on  [delta,
        theta]  +  classical  estimates  -  the  "uniform  range
        shape"  ADDS  NO  ANALYTIC  CONTENT.  The  big-O  shape  does
        NOT  give  the  asymptotic  (no  reverse  implication)  -
        door  1  is  the  canonical/stronger  form.

    3.  UPGRADE  of  the  0296  conservative  note:  door  2's
        PUBLISHED  REACH  is  theta <= 4/7  (via  cited  (1.2)@[delta,
        4/7]  +  pointwise  second  moment)  -  not  the  1/2
        pointwise-shape  reading.

    4.  THE  TWO  GAPS  COINCIDE:  {theta | 4/7 < theta}  -  the
        0295  unified  gap.  THREE  NAMES,  ONE  OBJECT:  (1.2)
        (door  1)  /  levSharp  (0294  machine  bridge)  /
        thetaBounded  (door  2).  Two  sufficiency  wires  stand
        (0290  thetaInf;  0296  BG  Theorem-1),  both  closing  the
        face  given  their  cited  inputs.

    HONESTY:  no  RH  claim;  no  in-tree  thetaBounded  (inputs
    cited);  compact-uniform  reading  flagged  interpretive  (per-
    paper  verbatim  uniformity  not  audited).  Face  status:
    OPEN  /  PROBABLY  TRUE.

## E28.  M5  FRONTIER  EXTENSION,  SECOND  RUN:  OUR  OWN  WINDOW
       (0297,  LEAN:  RhAttack.CE2,  tree  green  17454)

    The  M5  lane  (the  machine-verified  shrinking  lane,  0289
    face-menu)  runs  a  second  time  -  and  this  time  the  window
    is  OUR  OWN  PRODUCTION,  not  a  cited  artifact:  Murphy's
    Apache-2.0  pipeline  (zenodo  23486196:  window.py  +
    verify_window.py  +  controls;  128-bit  Arb,  kernel-checked
    Lean-4  RS  remainder  (3/5) t^(-3/4),  Arb-zeta  cross-check
    at  every  point,  Turing  at  the  Amberger-corrected  block
    count  K = 12,  missing-pair  controls)  run  in-house  on  this
    machine  (28  workers;  33 268  evals;  2548.8 s)  for  the  next
    window  above  CE1's  end:

    1.  RESULT:  the  19 999  zeros  with  g_a2 < Im  s <= g_b2  are
        ALL  SIMPLE  AND  ON  THE  LINE  (sign  changes  19999 =
        b-a;  Rosser  runs  47 / 50  > K = 12;  0  failures  in  any
        check;  b  snapped  to  12 363 153 477 129  by  the  driver).
        Endpoints  (recorded  dyadic  balls,  radius  ~1.3e-26):
            g_a2 = 3 000 175 337 471.5100470881271857...  (= CE1's
                   g_b:  the  seam  is  seamless  to  the  128-bit
                   record)
            g_b2 = 3 000 175 342 144.2115353245153768...
        Certificate:  tmp/ce2/ce1_window_H0_v1/window2_b2.json  (+
        .cache.jsonl  raw  records  +  run  log).

    2.  THREE  VERIFICATION  LAYERS:  (i)  before  the  run,
        Murphy's  OWN  window-1  certificate  re-verified
        CERTIFIED:true  in  this  environment  (pipeline  +  flint
        0.9.0  consistent);  (ii)  the  pipeline's  INDEPENDENT
        verifier  (separate  code)  on  the  new  certificate:
        CERTIFIED:true,  gram  points  recomputed  and  matched,
        Turing  K  checked;  (iii)  an  INDEPENDENT  SPOT  CHECK
        (mpmath  grampoint  +  siegeltheta  +  zeta  -  a  third  R-S
        implementation):  both  endpoint  Gram  points  reproduced,
        sample  of  certified  signs  agree  [see  0297  record  for
        the  count]  -  a  control  (sample),  not  a  second
        certificate.

    3.  THE  FRONTIER  (RhAttack.CE2,  machine):  new  cited
        frontier  tCE2 = 3 000 175 342 144  (strictly  below  the
        certified  g_b2  ball);  allOnLineUpToCE2  =  [Z-PT2] +
        [CE1-WIN]  +  [CE2-WIN]  (the  two  window  clauses  as
        named  cited  Inputs  in  the  Z78  pattern;  the  seam  split
        at  gA2Hi  is  machine  logic,  bandOfWindows);
        terminalFaceCE2;  rh_split_at_CE2;  rh_reanchored_CE2
        (all-heights  RH  <->  terminalFaceCE2);  rh_of_terminal-
        FaceCE2  (final  step);  terminalFaceCE2_of_thetaInf  (the
        0290  lane  lands  directly  here);  faceShrinkCE2  =  4673
        (a  further  4673  units  past  tCE1);  frontierGapAboveH0
        =  9344  (tCE2  -  tPT2;  certified  real  height  9344.2115).
        Total  certified  zeros  added  above  g_a1:  39 999.

    HONESTY:  no  RH  claim;  the  face  is  the  same  open  object,
    certified  9344  units  higher  (per  the  source's  own
    caveat,  the  extension  itself  is  negligible  -  the  value  is
    that  M5  now  works  END-TO-END  IN-HOUSE  on  a  fresh  window,
    and  every  future  window  re-anchors  the  face  by  the  same
    two-line  machine  composition);  [CE2-WIN]  is  a  named  cited
    Input;  trust  base  =  pipeline  controls  +  kernel-checked
    remainder  +  the  three  layers  above.

## E30.  OPTION-B  PHASE  (0289 -> 0298)  PACKAGED  (0299)  -  the
       complete  map  in  one  place

    THE  FACE  (unchanged  object,  fully  mapped):
        RHEnd.terminalFace  (0288:  all-heights  RH  =  cited
        census  AND  terminalFace;  0289:  identity  with  the
        endpoint's  own  face,  machine-proven  both  ways)
    Status:  OPEN  /  PROBABLY  TRUE;  certified  up  to  tCE2  =
    3 000 175 342 144  (9344  units  above  H0;  39 999  certified
    zeros  in  the  two  windows).

    LANE  M2  =  ONE  WALL,  TWO  DOORS,  THREE  NAMES:
        gap  set  =  {theta  |  4/7  <  theta}
                    (0295  unifiedGap,  machine  LevWall3)
        (1.2)  pointwise  asymp  =  door  1
              (published  0  <  theta  <  4/7)
        levSharp  (0294  machine  bridge  via  interval  algebra)
        thetaBounded  (0296  in-tree  def,  door  2;  0298:
              door2  =  door1-on-interval  +  classical
              short-mollifier  estimates  -  uniform  shape  adds
              NO  content;  published  reach  4/7)
        Two  CITED  sufficiency  wires  each  close  the  face:
        0290  (theta=inf  form:  Farmer  kappa=1  +  BG  Theorem-1
        particular  case)  and  0296  (BG  Theorem-1  antecedent
        family  at  every  theta,  "In  particular"  clause  ver-
        batim  in-paper).  Proving  EITHER  family  past  4/7
        COMPLETES  RH  given  the  cited  censuses.

    LANE  M5  =  WORKING  IN-HOUSE:
        H0  ->  tCE1  (0291  cited  window)  ->  tCE2  (0297
        OUR  window,  triply  verified)  ->  tCE3  (window  3
        IN  FLIGHT  at  package  time).

    OTHER  LANES  SEALED:  M1/M3/M4  dead  (mechanism  /  S
    maximal  order  /  wrong  side);  M6  audited  blind  (0292
    spectral-twin  Gram  model  -  compatible  with  a  sparse
    face  BY  CONSTRUCTION;  proportion  results  STAND);
    pervasive  face  refuted  at  two  levels  (0285  zero-density
    +  0292  model);  the  SPARSE  face  is  untouched  -  it  IS
    the  face.

    HONESTY:  NO  RH  CLAIM.  The  phase  MAPPED  and  RE-ANCHORED
    the  single  open  object;  it  did  not  close  it.  The
    analytic  gap  -  (1.2)  at  theta  >  4/7  in  any  of  its
    three  forms  -  stands.  Machine:  7  new  modules,  tree
    green  17454.


## E31.  M5 RUN 3:  WINDOW  3  LANDED,  FRONTIER  tCE3  (0301)  -
        the  in-house  frontier  extension  continues  (2026-11-11)

    Window  3  (Murphy  pipeline,  same  trust  base  as  CE1/CE2):
    a  =  12363153477129  (= CE2's  b,  seamless),  b  snapped  to
    12363153497128;  33326  evals,  2614.4 s.  Verifier:
    "CERTIFIED: true"  -  b  -  a  =  19999  zeros  in  (g_a3,
    g_b3],  ALL  SIMPLE,  on  the  line;  0  Rosser  failures  in
    15864  blocks;  0  cross-check  failures;  Rosser  runs  48/49
    >=  K  =  12.

    THE  SEAM  AUDIT  (this  run's  third  verification  layer):
    the  recorded  g_a3  exact-dyadic  ball  is  BIT-IDENTICAL  to
    CE2's  recorded  g_b2  ball  (same  mantissa/exponent/radius
    tuple,  decoded  and  compared  on  this  machine).

    FRONTIER:
        tCE3   =  3 000 175 346 816     (machine  CE3)
        tCE3 - tCE2  =  4 672           (further  shrink)
        tCE3 - tPT2  =  14 016          (above  Platt-Trudgian  H0)
        certified  zeros  over  (g_a1, g_b3]  =  59 998
        (20000 + 19999 + 19999).

    MACHINE  (RhAttack.CE3,  CE2-pattern):  constants
    gB3Lo  =  300017534681691/100,  tCE3  =  3000175346816;
    cited  clauses  ce2WinClauseFull  ((gA2Hi, gB2Lo]  slice  of
    (g_a2, g_b2])  and  ce3WinClause  ((gB2Lo, tCE3],  union-of-
    two-certificates  derivation  recorded);  bandOfWindows3;
    allOnLineUpToCE3;  terminalFaceCE3;
    terminalFaceCE3_iff_faceCE2  (band  (tCE2, tCE3]  certified
    empty  -  re-anchoring  is  a  certificate,  not  a  logical
    move);  rh_reanchored_CE3  (RH  <->  terminalFaceCE3  under
    the  four  cited  census  inputs);  rh_of_terminalFaceCE3;
    terminalFaceCE3_of_thetaInf.  Green:  RhAttack.CE3  (8768),
    full  tree  (17454).

    The  lane  M5  works  IN-HOUSE  for  the  third  window  in  a
    row;  every  future  window  re-anchors  by  the  same  two-
    clause  machine  composition.  NO  RH  CLAIM  -  the  face  is
    the  same  open  object,  certified  14016  units  above  H0.


## E32.  THE  SCOPED  WEIGHTED-VARIANT  ATTEMPT:  SEALED  AT  THE
        PUBLISHED  BOUNDARY;  THE  WALL  ALGEBRA  MADE
        WEIGHT-AGNOSTIC  (0302)  (2026-11-11)

    The  0280-pattern  scoped  analytic  attempt  promised  in
    0299,  executed:

    VARIANT:  smooth  reweighting  of  the  Levinson  mollifier
        M_{a,Y}(s)  =  sum_{n<=Y}  mu(n)  e^{-s log n}
                    (1  -  log  n/log  Y)^a,   a  >  0
    (the  classical  weight  is  a  =  1  in
    ThetaInf.thetaMoll).

    MACHINE  (RhAttack.LevWall5,  new  module):  the
    WEIGHT-AGNOSTIC  wall  kernel  -  for  ANY  family
    W  :  Y  ↦  w_Y:
        residExpandGen  (the  interval  expansion,  continuity
            only)
        residSharpGen   (the  sharp  1/theta  limit  algebra  -
            the  Radziwill  c  =  1  algebra,  NO  property  of
            the  weight  used)
    +  the  bridges  proving  the  classical  objects  are  the
    Wlev  instance  (classicInstance_eq  /  reMainF_Wlev_eq  /
    iMomF_Wlev_eq)  and  **residSharp_is_instance**  (the  0294
    wall  theorem  is  residSharpGen  at  Wlev).  Green:
    RhAttack.LevWall5  (8768),  full  tree  (17454).

    AUDIT  (record-level,  exponents):
        (A)  machine-supported:  a  variant's  reach  =  the
            published  reach  of  its  two  named  inputs  (the
            EXONENT  barrier,  not  the  algebra);
        (B)  record-level:  the  reweight  amplitude
            (1  -  log  n/log  Y)^{a-1}  is  smoothly  varying
            on  [1,  Y];  in  the  Conrey-type  off-diagonal
            double  sum  it  changes  only  the  O_a(1)  bound
            constant  (bounded  variation  /  summation-by-
            parts),  NONE  of  the  exponents;  the  published
            reaches  (1/2,  9/17,  6/11  Feng,  4/7  Conrey)
            are  pure  exponent  constraints  (Deshouillers-
            Iwaniec  /  Kloosterman  range).

    VERDICT:  NO  smooth  reweighting  moves  the  wall  {theta
        |  4/7  <  theta}  -  SEALED  at  the  published
        boundary  (0280  negative-audit).

    THE  GENUINE  KNOB  (kept  distinct,  no  conflation):
    the  degree/truncation  TRADE-OFF  (0292-PRZZ:  B-C-H-B
    degree-2  ->  9/17;  generic  ceiling  17/33  -  eps).
    NEXT  SCOPED  ATTEMPT  (0303):  pin  the  degree-2  test
    function  AT  THE  (1.2)  LEVEL  and  name  the  exact
    obstruction.

    NO  RH  CLAIM  -  no  wall  movement;  one  natural  variant
    family  audited  and  sealed  at  its  exact  boundary.


## E33.  THE  4/7  WALL'S  EXACT  PUBLISHED  OBSTRUCTION  -  PINNED
        FROM  PRZZ  THEOREM  4.1  (0303)  (2026-11-11)

    The  0280-pattern  audit  the  0302  unit  pointed  at:

    PRIMARY  SOURCE  (arXiv:1802.10521,  Res.  Math.  Sci.
    7  (2020),  Theorem  4.1):  the  twisted  second
    moment  (N  =  T^theta,  unconditional)  by
    coefficient  regime  -
        Case  1  (arbitrary  coefficients):
            E  =  T^{3/20} N^{33/20}  +  N^{1/2}T^{1/2+eps}
            ->  theta  <  17/33
            (Bettin-Chandee-Radziwill  trilinear
            Kloosterman  ingredient)
        Case  2  (mu²  ·  degree-D):
            E  =  T^eps(N^{11/6}  +  N^{11/12}T^{1/2})
            ->  theta  <  6/11
            (=  2017  Feng-variant  1706.04593)
        Case  3  (degree-D  family,  contains  Levinson's
            mu  at  D  =  0):
            E  =  T^eps(N^{7/4}  +  N^{7/8}T^{1/2})
            ->  theta  <  4/7,  verbatim  "taking
            N  =  T^{4/7-eps}  is  permissible"

    THE  EXACT  OBSTRUCTION:  the  Case-3  exponents
    (7/4,  7/8)  saturate  SIMULTANEOUSLY  at
    theta  =  4/7  —  the  wall's  boundary  is  one
    exact  equation,  not  a  frontier  of  uncertain
    source.  (Type  II  bilinear  Kloosterman  sums,
    Deshouillers-Iwaniec  Lemma  1,  balance
    W  =  U^{1/4},  are  the  source  of  the
    exponents.)

    MACHINE  (RhAttack.LevWall6,  new):
        admissibleDegreeD/General/Mu2  (the  published
            o(T)  conditions)
        saturation  theorems  (all  three  regimes
            saturate  at  their  published  frontier,
            norm_num)
        admissibleDegreeD_iff47  etc.
            (iff  theorems,  linarith)
        **wallGapFailsObstruction**  (every  wall  theta
            fails  the  published  o(T)  condition)
        boundary47Fails  (4/7  itself  fails  -  sharp)
        admissibleSetIsHalfline  ([0,  4/7))
        publishedLatticeOrdering
            (1/2  <  17/33  <  9/17  <  6/11  <  4/7  <  1)
    Green:  RhAttack.LevWall6  (8768),  full  tree
    (17454).

    THE  LADDER  REFINED:  the  0294/0300  ladder
    1/2  <  9/17  <  4/7  gains  17/33  (generic  reach,
    B-C-R  input)  and  re-sources  6/11  (PRZZ  Case  2
    =  Feng  variant);  the  9/17  entry  is  the
    B-C-H-B  (1.3)-coefficient  result  (b_C(n,y)  =
    μ(n)n^{σ₀−1/2}P(log(y/n)/log y),  Vaughan  +  Weil)
    —  the  degree-2  test-function  entry  the  0302
    unit  named.

    MOVING  THE  WALL  =  changing  the  exponents
    7/4  or  7/8  themselves  (sharper  bilinear
    Kloosterman  estimate,  better  balance,  or  a
    new  decomposition)  —  none  in  the  published
    record  (0300  sweep).  The  GENUINE  LEVER  is
    PRZZ's  own  open  question  (section  9,
    verbatim):  "What  would  be  a  good  balance
    between  the  degree  d  and  the  truncation  ℓ?"
    -  the  named  next  lever  (0304  candidate).

    NO  RH  CLAIM  —  wall  UNMOVED,  now  pinned  at
    its  exact  published  obstruction.


## E34.  THE  d-l  LEVER  AUDITED  -  A  KAPPA  LEVER,  NOT  A  WALL
        LEVER  (0304)  (2026-11-06)

    PRZZ's  own  open  question  (section  9  item  4,
    verbatim):  "It  would  also  be  interesting  to
    set  d  =  1  and  analyze  how  a  large
    truncation  of  ℓ  could  yield  terms  from  a
    higher  degree  d  ≥  2.  What  would  be  a  good
    balance  between  the  degree  d  and  the
    truncation  ℓ?"

    AUDIT  (primary  source,  full  text):
  *  the  5/12  theorem  itself  is  already  AT
    θ  =  4/7  -  eps:  d  =  1,  truncation
    K  =  3,  R  =  1.3036,  degree-5  Q,
    κ  ≥  0.417293962  (section  8);
  *  the  A*  error  bound  is  UNIFORM  in  the
    coefficient  family  (mu  *  Λ₁^{*k₁}  *  ...
    *  Λ_D^{*k_D};  Λ_k  =  mu  *  log^k,
    ℓ  =  k₁  +  ...  +  k_D)  -  the  d-l  choice
    enters  the  MAIN  TERM  (κ  richness),  not  the
    error  exponents;
  *  for  d  =  1,  large  ℓ₁  expands  (mu  *
    Λ₁^{*ℓ₁})  into  products  of  logs  of  distinct
    primes  dividing  n  -  the  SAME  term  shapes
    as  degree  d  ≥  2  -  "large  truncation
    mimics  higher  degree"  =  more  main-term
    degrees  of  freedom  =  better  κ;
  *  the  "1/d"  in
        A*  ≪  (T^eps/d)(T^{1/2}N^{7/8} + N^{7/4})
    is  a  DIVISOR  (h  |  d^infty,  U  =
    N1/(d h))  of  the  bilinear  decomposition  -
    INTERNAL  to  the  optimization  whose  ENDPOINT
    is  (7/4,  7/8)  -  the  "make  d  large"
    reading  is  a  MISREADING;
  *  the  (7/4,  7/8)  extraction  is  FORCED  by  the
    structure:  h-powers  strictly  below  U-powers
    (needed  for  the  h-sum  convergence)  +
    W  =  U^{1/4}  balance  (the  proof's
    verbatim  paragraph).

    JUDGMENT:  as  a  proportion  lever  the  d-l
    trade-off  is  structurally  blind  to  the
    sparse  face  (0285/0292  logic).  No  new  wall
    lever.  The  wall  levers  remain  the  0303
    menu:  L1  (sharper  bilinear  Kloosterman)  /
    L2  (new  balance)  /  L3  (new  decomposition).

    MACHINE  (RhAttack.LevWall7,  new):  the  wall
    as  a  piecewise-linear  function  of
    (hypothetical)  exponent  improvements  -
  *  **DOUBLE  WASTE  THEOREM**:  improving
        EITHER  published  error  exponent
        ALONE,  by  ANY  amount,  does  NOT  move
        the  wall  (the  unimproved  term  binds
        at  exactly  4/7)  -  BOTH  must  move;
  *  **wallUnderBothImprovements**:  under  (δ,
        δ2)  the  wall  =  EXACTLY
        4/7  +  min(8δ/7,  4δ2/7);
  *  simultaneousShiftBindsSecond:  equal  δ  >  0
        ->  4/7  +  4δ/7,  the  N^{7/4}  term
        BINDS  (4δ/7  <  8δ/7);
  *  publishedStateIsCorner:  δ  =  δ2  =  0
        ⟺  the  published  LevWall6  corner;
  *  wallShiftDemo:  a  1/7  improvement  on  the
        7/4  side  moves  the  wall  28/49  ->
        32/49.

    Quantitative  reading:  any  future  wall
    movement  must  carry  BOTH  exponents  with
    it;  the  N^{7/4}  (bilinear  Kloosterman)
    side  is  the  binding  side  -  L1  is  the
    best  wall-movement-per-unit  lever.

    HONESTY  NOTE:  the  draft  "single-side
    improvement  shifts  the  wall"  theorem  was
    MATHEMATICALLY  WRONG  before  build
    (claimed  4/7  +  4δ2/7;  linarith  refused)
    -  corrected  to  the  double  waste  theorem.

    NO  RH  CLAIM  -  wall  UNMOVED;  the
    option-B  analytic  menu  is  EXHAUSTED  at
    the  published  frontier  (map  0286-0304
    complete).  Tree  green  17454.


## E35.  L1  STATE  OF  THE  ART  +  THE  KINTALI  FINDING  -  THE
        WALL  LANDSCAPE  REFINED  (0305)  (2026-11-06)

    The  0280/0300-pattern  audit  of  the  0303  best
    lever  (L1,  bilinear  Kloosterman)  found  a
    MAJOR  new  item  the  0300  sweep  missed:

    **KINTALI**  (preprint  2026-08-08,  45  pp.,
    shivakintali.github.io/papers/RH421.pdf  -  NOT
    on  arXiv  at  sweep  time):
        Theorem  1.1:  κ  >  421/1000
            (unconditional,  computer-assisted
            Levinson-Conrey;  lineage  record  above
            PRZZ  0.417293962)
        Theorem  2.2  (NEW  asymptotic):
            selected  twisted  second  moment,  fixed
            power  saving,  for  the  RESTRICTED
            coefficient  (marked-subset  selector  W
            on  the  signed  (−1)³(μ  *  Λ^{*3})
            degree-3  Feng  piece)  at  limiting
            length  **29/50  =  0.58  >  4/7**  -
            "the  only  point  at  which  the  length
            exceeds  4/7"

    THE  MECHANISM  =  the  0303  menu's  L2/L3
    (structure,  not  a  new  Kloosterman  bound):
        the  PRZZ  Thm  4.1  off-diagonal  argument
        with  the  Heath-Brown  partition  REPLACED
        by  the  marked-tuple  structure;  the  RAW
        D-I  1984  Acta  Arith  Lemma  1  applied
        unchanged;  the  selector's  forced
        factorization  (q  −  21/29  ≤  z  ≤  min(q/2,
        42/29  −  q))  makes  ALL  SEVEN  λ_j  ≤  1
        simultaneously  at  the  longer  length.

    THE  LANDSCAPE  REFINEMENT:
        the  4/7  boundary  is  a  PARTITION-
        STRUCTURE  BARRIER  of  the  full  (μ  *
        Λ^{*k})  argument  -  NOT  an  absolute
        bilinear-Kloosterman  barrier;  the  D-I
        bound  is  more  flexible  than  the  full
        argument  exploits.
        THE  (1.2)  FULL-FAMILY  WALL  IS
        UNMOVED  (explicit  T^{4/7  −  eps}
        short-short  restriction  in  the  paper;
        no  (1.2)  extension  claimed)  -  and  the
        wall  still  BINDS  INSIDE  the  0.421
        argument  itself  (the  non-selected  pieces
        sit  exactly  AT  4/7:
        29/50  ·  200/203  =  4/7,  machine).

    L1  STATE  OF  THE  ART  (the  audit  proper):
        D-I  1982  Inventiones  (9.11)  carries  a
        2019  correction  (arXiv:1903.01371):
        D²NR/S  ->  D²NR  (WEAKENING,  harmless  -
        S  =  1  in  most  apps;  the  (1.2)  wall
        stands  on  the  corrected  bound,  PRZZ
        2020  being  post-correction);
        the  2017-2023  active  line  (KMS  Annals
        2017/2020,  FKM,  BFKMM,  Shparlinski,
        Bag-Shparlinski  JLMS  2023,  Chen
        2211.14702)  =  MIXED  MOMENTS  /  modulus
        p  (p^{-1/68}  ->  p^{-1/64}),  NOT  the
        Levinson  t-variable  second  moment.

    MACHINE  (RhAttack.LevWall8,  new):
        fullWall  =  4/7  <  selectedWall  =  29/50
            (gap  3/350,  norm_num)
        refinedLadderOrdering:
            1/2  <  17/33  <  9/17  <  6/11  <  4/7
            <  29/50  <  1
        fullWallIsLevWallBoundary  (wall  UNMOVED)
        wallSitsAboveFullWallRegister
        selectedShortPieceCapIsWall
            (29/50  ·  200/203  =  4/7)
    Green:  RhAttack.LevWall8  (8769),  full  tree
    (17454).

    NAMED  NEXT  DIRECTION  (0306  candidate):
        extend  the  marked-tuple  /  selector
        structure  to  the  FULL  family  (or  to
        the  (1.2)  integral)  -  the  first
        published  positive  instance  of  lever
        L2  makes  this  the  concrete  research
        question.

    ALSO:  the  window-2  independent  mpmath
    spot-check  LANDED  -  13,155 / 13,155  agree
    at  dps-30  (0297  control  addendum).

    NO  RH  CLAIM  -  wall  UNMOVED  ((1.2)  full
    family);  face  OPEN  /  PROBABLY  TRUE;  the
    0.421  record  is  face-blind  (0285/0292).

  # E36 · 2026-11-06 · 0306 — M5 RUN 4 LANDED (OUR WINDOW 4) +
  # CE4 RE-ANCHOR + 0297 SPOT-CHECK SCOPE CONFIRMED

    The M5 lane paid again, end-to-end in-house (run 4 of the
    Murphy pipeline on our chosen windows):

    * WINDOW 4 (a = 12 363 153 497 128 = CE3's b, seamless;
      b = 12 363 153 517 128, NO snap-down; M = 60, C_R = 1,
      28 workers, 34 275 evals, 2723.6 s): the 20 000 zeros
      with g_a4 < Im s <= g_b4 are ALL SIMPLE and on the line
      (verifier CERTIFIED: true; turing_ok; K = 12; runs
      49/46; 0 cross-check failures; 0 undetermined signs).
    * ONE first-quota Rosser block (g-indices ..498 083 -
      ..498 085) rescued by the pipeline's documented
      3-block union refinement (union ..498 082 - ..498 086
      at 8 subdivisions: need 4 / found 4) - a zero
      displaced into an adjacent Gram interval; sound
      because only the window TOTAL + the two end runs
      enter the Turing step (verifier recomputes both).
      Recorded (rosser_failures_inside = 1), not
      suppressed.
    * Seam: g_a4 ball bit-identical to window-3's g_b3
      ball (exact dyadic decode) - the chain
      1 -> 2 -> 3 -> 4 is seamless by construction.
    * FRONTIER (machine, NEW formal module
      formal/RhAttack/CE4.lean, 24 decls):
      **tCE4 = 3 000 175 351 489** (tCE4 - tCE3 = 4 673;
      tCE4 - tPT2 = 18 689; 79 998 certified zeros over
      (g_a1, g_b4]); rh_reanchored_CE4 /
      rh_of_terminalFaceCE4 / terminalFaceCE4_of_thetaInf
      mirror CE1-CE3; iff vs terminalFaceCE3 under the
      band. RhAttack.CE4 green (8769); full tree green
      (17454).
    * 0297 CONTROL ADDENDUM (scope-confirmed): the
      independent mpmath spot-check is WINDOW-2 SCOPE
      (spotcheck_window2.py): 13 155 points / 13 155 agree
      / 0 disagree at dps-30 (control, not a second
      certificate).
    * NAMED NEXT (0307 candidate): primary reading of the
      Kintali preprint (personal-site PDF, NOT on arXiv -
      0307 corrigendum) Theorem 2.2 -
      exactly what the marked-tuple restriction is and
      whether it is removable for the full family / the
      (1.2) integral (the 0305 direction, renumbered).

    No RH claim - face OPEN / PROBABLY TRUE; wall UNMOVED
    at 4/7 for the (1.2) full family.

  # E37 · 2026-11-11 · 0307 — KINTALI Thm 2.2 + CLAUDE 2/3
  # FULL PRIMARY READS

    * CORRECTION: 'arXiv:2608.05281' (0306-landing) is an
      unrelated astrophysics preprint; the Kintali paper is
      personal-site only (RH421.pdf). Three occurrences
      corrected.
    * KINTALI (45 pp) fully read: κ > 421/1000 via
      computer-assisted Levinson–Conrey (R = 13/10,
      c < e^{7527/10000}); four pieces exactly AT T^{4/7}
      (rho·29/50 = 4/7) + one LONG SELECTED piece at
      T^{29/50} (degree-3 Feng convolution, marked-subset
      selector W: some nonempty subset-sum of the three
      marked masses in [8/29,13/29] ∪ [16/29,21/29]).
      Thm 2.2 (the only new analytic content) admissible
      ONLY for single-witness-slab product-box
      combinations. VERDICT: the restriction is
      LOAD-BEARING - the subset-sum geometry is what makes
      the DI seven-term exponent system feasible past 4/7
      ((SM.7)); the finite side is tied to the same
      rational-polyhedral geometry (selector faces
      flow-null, radial operator, P_3(0) = 0). NOT
      removable within the DI framework => the (1.2)
      full-family wall {θ | 4/7 < θ} UNMOVED (third
      primary confirmation).
    * CLAUDE (17 pp) fully read: ≥ 2/3 simple-on-line /
      ≥ 5/6 distinct (MT window 0.67250 / 0.83625),
      unconditional, + Dirichlet L-functions. Mechanism
      = Weil-form Gabor compression (G~ = P + Q; off-line
      pairs signature (1,1)) + unconditional prime side
      (‖G~‖² = (R(ψ)+o(1))N, R(1) = 4/3; no mollifier) +
      new rank–trace inequality (m² ≥ 2m−1 in matrix
      form). Sharpness: method cannot distinguish "two
      thirds" from "all"; higher moments add nothing
      unconditionally; bandwidth-1 ceiling 0.6819.
      FACE-BLIND BY CONSTRUCTION (sec.1.4: holds for
      Epstein zeta where the RH analogue is FALSE) -
      0300/M6 audit at mechanism level.
    * KAPPA LADDER consolidated: 5/12 [BCY] / 0.417293962
      [PRZZ] → 421/1000 [Kintali, superseded] → 2/3 + 5/6
      [Claude, arXiv:2608.13637, Lean-verified
      zeta-23-lean v1.0] → +88.76% simple-OR / +83.62%
      average [Lamzouri 2609.02882] → simple-OR > 8/9
      [Cobeli–Zaharescu 2610.23467 per 0300]. ALL
      proportion statements - κ-progress, not face-progress.
    * FORMAL ASSET: zeta-23-lean (v4.33.0-rc2; Mathlib
      51e6992efd06; #print axioms = 3 standard; new
      Mathlib: von Neumann trace inequality + Sylvester
      inertia) vs our v4.33.1 - 0308 borrow audit
      (RhAttack.Claude23 candidate).
    * M5: window 5 in flight (a₅ = 12363153517128) ->
      CE5 on landing.

    No RH claim - face OPEN / PROBABLY TRUE; wall UNMOVED.

* **E38 (2026-11-14, 0308):**
    * zeta-23-lean **vendored + in-tree**: 317 files,
      MIT, formal/vendor/zeta23; their Mathlib pin
      51e6992efd06 verified ANCESTOR of ours (95
      behind); 7 true-global name collisions computed
      deterministically, all renamed vendor-side
      (ledger in 0308); `Zeta23` GREEN 9019.
    * **Claude23 bridge GREEN 8871**: Claude 2/3
      theorems (2/3 simple-on-line, 5/6 distinct, MT
      window) + ThmD/ThmE installed by direct import
      with the formal face-blindness clause; κ ladder
      now FORMAL IN-TREE.
    * **M5 window 5 CERTIFIED**: 20,000 zeros; seam
      bit-identical; **tCE5 = 3,000,175,356,162**
      (4,673 shrink; 23,362 above H0); 99,998 zeros
      certified over (g_a1, g_b5]; CE5 GREEN 8770;
      full tree 17454.
    * 0309 candidate named: KMRZ 2011 (13/4 exponent,
      2.977412 constant) primary + 17/33 ↔ 4/7
      family-intersection audit (face-local lever).

    No RH claim - face OPEN / PROBABLY TRUE; wall
    UNMOVED.

* **E39 (2026-11-14, 0309):**
    * PROVENANCE: the plan-level KMRZ citation (Math.
      Ann. 351:63-124, "13/4") is FABRICATED — full
      TOCs of 351:1 and 351:2 checked; no such paper
      anywhere; the 2.977412 chain does not reduce
      numerically. Third plan-level provenance
      corruption (after 0283, 0307); retracted in its
      entirety.
    * 17/33 = PRZZ Case 1 (NOT CGG) — correct scope
      pinned; the "17/33 face-local lever" is
      STRUCTURALLY DEAD (Levinson moments →
      proportion-only → face-blind; density can't
      localize; pointwise gate already closed).
    * NEW REGISTER: mechanism face-sensitivity map
      (sensitive: pointwise S / zero-free / certified
      windows only; blind: ALL proportion + ALL
      gap/count machinery).
    * T4OffLQ docstring patched to 0283 frame (GREEN
      8738).
    * M5 WINDOW 6 CERTIFIED - cleanest of the chain (ZERO
      Rosser exceptions): 20,000 zeros; seam bit-identical;
      **tCE6 = 3,000,175,360,835** (4,673 shrink; 28,035
      above H0); 119,998 zeros certified over
      (g_a1, g_b6]; CE6 GREEN 8771 first attempt; full
      tree green.

    No RH claim - face OPEN / PROBABLY TRUE; wall
    UNMOVED.

* **E40 (2026-11-14, 0310):**
    * BG 2017 primary re-read (arXiv:1604.02740):
      antecedent reach = Levinson 1/2 -> CONREY 4/7
      ("k > 2/5") — door 2's reach IS door 1's (1.2)
      wall.
    * LevWall9 GREEN 8771: door2ReachIsDoor1Wall +
      door2ResidualIsDoor1Wall (machinically: same open
      set {theta | 4/7 < theta}); conreyKappa 2/5 rung;
      [DIAG-RANGE] named honesty gap (levWallAt ->
      thetaBounded, real in-tree objects).
    * 0311 candidate: [DIAG-RANGE]@1/2 + [BG-T1] ->
      zero-free Re s > 3/5 in-tree (Levinson region
      wired through door 2; formalization completeness,
      red line: no gain past 4/7).
      [CORRECTED 0312: theta = 1/2 boundary is Re s > 3/2,
      NOT 3/5 (3/5 <=> theta = 5, in the wall); best
      reachable boundary 19/16 > 1 = trivial region;
      wire landed in LevWall10 with corrected numerals.]

    No RH claim - face OPEN / PROBABLY TRUE; wall
    UNMOVED (both doors pinned).

* **E41 (2026-11-14, 0311):**
    * M5 WINDOW 7 CERTIFIED (20,000 zeros, all simple and
      on the line; seam bit-identical; 2 Rosser rescues,
      quotas met, recorded) + CE7 GREEN 8772, full tree
      17454.
    * Frontier re-anchored: tCE7 = 3,000,175,365,508
      (tCE7 - tCE6 = 4,673; 32,708 above H0); 139,998
      certified over (g_a1, g_b7].
    * Next: window 8 (a8 = 12,363,153,577,128); 0312
      candidate = [DIAG-RANGE]@1/2 + [BG-T1] => zero-free
      Re s > 3/5 in-tree (Levinson through door 2; red
      line: formalization completeness only).
      [CORRECTED 0312/LevWall10: same sketch arithmetic
      fix - boundary at theta = 1/2 is 3/2 not 3/5; reachable
      family inside Re s >= 1; see E42.]

    No RH claim - face OPEN / PROBABLY TRUE at tCE7; wall
    UNMOVED.

* **E42 (2026-11-14, 0312):**
    * LevWall10 GREEN 8772: the door-2 wire parameterized
      and machine (door2Wire / door2WireLeft /
      door2WireAt12 @ 3/2); reach boundary 19/16 = 1/2 +
      7/8 (theta -> 4/7^-); boundaryLadder 1 < 19/16 < 3/2;
      reachableInsideTrivialRegion (1 < 19/16 - inside
      classically zero-free Re s >= 1); nonvacuousPastWall
      (theta > 1 => inside the wall; non-vacuity threshold
      theta > 1.0288 at the frontier scale, boundary
      0.98599645, c = 1/2pi, dps-30).
    * CORRECTION: 0310/0311 'Re s > 3/5' sketch =
      arithmetic error (theta = 1/2 gives 3/2; 3/5 <=>
      theta = 5 is unpublished); genuine Levinson region
      is a different theorem, not in-tree; records patched.
    * Consequence: door 2's Theorem-1 machinery has NO
      partial value below the wall - all-or-nothing at 4/7,
      exactly like door 1 (doors-meet now complete in its
      strongest form).

    No RH claim - face OPEN / PROBABLY TRUE at tCE7; wall
    UNMOVED.

* **E43 (2026-11-14, 0313):**
    * M5 WINDOW 8 CERTIFIED (19,999 zeros, all simple and
      on the line; seam bit-identical; zero Rosser
      exceptions - clean) + CE8 GREEN 8773, full tree
      17454.
    * Frontier re-anchored: tCE8 = 3,000,175,370,181
      (tCE8 - tCE7 = 4,673; 37,381 above H0); 159,997
      certified over (g_a1, g_b8].
    * Window 9 in flight (a9 = 12,363,153,597,127).

    No RH claim - face OPEN / PROBABLY TRUE at tCE8; wall
    UNMOVED.

* **E44 (2026-11-14, 0314):**
    * M5 WINDOW 9 CERTIFIED (20,000 zeros, all simple and
      on the line; seam bit-identical; 2 Rosser rescues,
      quotas met, recorded) + CE9 GREEN 8774, full tree
      17454.
    * Frontier re-anchored: tCE9 = 3,000,175,374,854
      (tCE9 - tCE8 = 4,673; 42,054 above H0); 179,997
      certified over (g_a1, g_b9].
    * Window 10 in flight (a10 = 12,363,153,617,127).

    No RH claim - face OPEN / PROBABLY TRUE at tCE9; wall
    UNMOVED.

* **E45 (2026-11-14, 0315):**
    * M5 WINDOW 10 CERTIFIED (20,000 zeros, all simple and
      on the line; seam bit-identical; zero Rosser
      exceptions - clean) + CE10 GREEN 8775, full tree
      17454.
    * Frontier re-anchored: tCE10 = 3,000,175,379,527
      (tCE10 - tCE9 = 4,673; 46,727 above H0);
      199,997 certified over (g_a1, g_b10] - the chain is
      now at ~200k consecutive on-line zeros past H0.
    * Window 11 in flight (a11 = 12,363,153,637,127).

    No RH claim - face OPEN / PROBABLY TRUE at tCE10; wall
    UNMOVED.

* **E46 (2026-11-14, 0316):**
    * M5 WINDOW 11 CERTIFIED (19,999 zeros, all simple and
      on the line; seam bit-identical; 1 Rosser rescue,
      quota met, recorded) + CE11 GREEN 8776, full tree
      17454.
    * Frontier re-anchored: tCE11 = 3,000,175,384,199
      (tCE11 - tCE10 = 4,672 - first non-4673 shrink, because
      the window snapped its final b down one; 51,399 above
      H0); 219,996 certified over (g_a1, g_b11].
    * Window 12 in flight (a12 = 12,363,153,657,126).

    No RH claim - face OPEN / PROBABLY TRUE at tCE11; wall
    UNMOVED.

* **E47 (2026-11-14, 0317):**
    * M5 WINDOW 12 CERTIFIED (20,000 zeros, all simple and
      on the line; seam bit-identical; zero Rosser
      exceptions - clean) + CE12 GREEN 8777, full tree
      17454.
    * Frontier re-anchored: tCE12 = 3,000,175,388,872
      (tCE12 - tCE11 = 4,673; 56,072 above H0);
      239,996 certified over (g_a1, g_b12] - the chain is
      now at ~240k consecutive on-line zeros past H0.
    * Window 13 in flight (a13 = 12,363,153,677,126).

    No RH claim - face OPEN / PROBABLY TRUE at tCE12; wall
    UNMOVED.

* **E48 (2026-11-14, 0318):**
    * M5 WINDOW 13 CERTIFIED (20,000 zeros, all simple and
      on the line; seam bit-identical; zero Rosser
      exceptions - clean) + CE13 GREEN 8778, full tree
      17454.
    * Frontier re-anchored: tCE13 = 3,000,175,393,545
      (tCE13 - tCE12 = 4,673; 60,745 above H0);
      259,996 certified over (g_a1, g_b13] - the chain is
      now at a quarter million consecutive on-line zeros
      past H0.
    * Window 14 in flight (a14 = 12,363,153,697,126).

    No RH claim - face OPEN / PROBABLY TRUE at tCE13; wall
    UNMOVED.

* **E49 (2026-11-14, 0319):**
    * M5 WINDOW 14 CERTIFIED (20,000 zeros, all simple and
      on the line; seam bit-identical; zero Rosser
      exceptions - clean) + CE14 GREEN 8779, full tree
      17454.
    * Frontier re-anchored: tCE14 = 3,000,175,398,218
      (tCE14 - tCE13 = 4,673; 65,418 above H0);
      279,996 certified over (g_a1, g_b14].
    * Window 15 in flight (a15 = 12,363,153,717,126).

    No RH claim - face OPEN / PROBABLY TRUE at tCE14; wall
    UNMOVED.

* **E50 (2026-11-14, 0320):**
    * M5 WINDOW 15 CERTIFIED (20,000 zeros, all simple and
      on the line; seam bit-identical; 2 Rosser rescues,
      union quotas met, recorded) + CE15 GREEN 8780, full
      tree 17454.
    * Frontier re-anchored: tCE15 = 3,000,175,402,891
      (tCE15 - tCE14 = 4,673; 70,091 above H0);
      299,996 certified over (g_a1, g_b15] - the chain is
      now at 300,000 minus 4 consecutive on-line zeros past
      H0.
    * Window 16 in flight (a16 = 12,363,153,737,126).

    No RH claim - face OPEN / PROBABLY TRUE at tCE15; wall
    UNMOVED.

* **E51 (2026-11-14, 0321):**
    * M5 WINDOW 16 CERTIFIED (20,000 zeros, all simple and
      on the line; seam bit-identical; zero Rosser
      exceptions - clean) + CE16 GREEN 8781, full tree
      17454.
    * Frontier re-anchored: tCE16 = 3,000,175,407,564
      (tCE16 - tCE15 = 4,673; 74,764 above H0);
      319,996 certified over (g_a1, g_b16].
    * Window 17 in flight (a17 = 12,363,153,757,126).

    No RH claim - face OPEN / PROBABLY TRUE at tCE16; wall
    UNMOVED.

* **E52 (2026-11-14, 0322):**
    * M5 WINDOW 17 CERTIFIED (19,999 zeros, all simple and
      on the line; final b snapped down one; seam
      bit-identical; 1 Rosser exception rescued to a wider
      union, quota met, recorded) + CE17 GREEN 8782, full
      tree 17454.
    * Frontier re-anchored: tCE17 = 3,000,175,412,237
      (tCE17 - tCE16 = 4,673; 79,437 above H0); 339,995
      certified over (g_a1, g_b17].
    * Window 18 in flight (a18 = 12,363,153,777,125).

    No RH claim - face OPEN / PROBABLY TRUE at tCE17; wall
    UNMOVED.

* **E53 (2026-11-15, 0323):**
    * M5 WINDOW 18 CERTIFIED (19,999 zeros, all simple and
      on the line; final b snapped down one; seam
      bit-identical; zero Rosser exceptions - clean) + CE18
      GREEN 8783, full tree 17454.
    * NEW CASING: g_b18 only 5.4e-3 above the previous
      integer -> 3-decimal lower bound (gB18Lo =
      3,000,175,416,910.005) in place of the usual
      2-decimal one; floor still robust by ~4e22 to the
      radius.
    * Frontier re-anchored: tCE18 = 3,000,175,416,910
      (tCE18 - tCE17 = 4,673; 84,110 above H0); 359,994
      certified over (g_a1, g_b18].
    * Window 19 in flight (a19 = 12,363,153,797,124).

    No RH claim - face OPEN / PROBABLY TRUE at tCE18; wall
    UNMOVED.

* **E54 (2026-11-15, 0324):**
    * M5 WINDOW 19 CERTIFIED (19,999 zeros, all simple and
      on the line; final b snapped down one; seam
      bit-identical; 1 Rosser rescue, quota met, recorded)
      + CE19 GREEN 8784, full tree 17454.
    * Frontier re-anchored: tCE19 = 3,000,175,421,582
      (tCE19 - tCE18 = 4,672 - second 4672 in the chain;
      88,782 above H0); 379,993 certified over (g_a1,
      g_b19].
    * Window 20 in flight (a20 = 12,363,153,817,123).

    No RH claim - face OPEN / PROBABLY TRUE at tCE19; wall
    UNMOVED.

* **E55 (2026-11-15, 0325):**
    * M5 WINDOW 20 CERTIFIED (20,000 zeros, all simple and
      on the line; seam bit-identical; 1 Rosser rescue,
      quota met, recorded) + CE20 GREEN 8785, full tree
      17454.
    * MILESTONE: 20-window seamless chain complete - 399,993
      certified zeros over (g_a1, g_b20]; frontier tCE20 =
      3,000,175,426,255 (93,455 above H0); window 21 in
      flight (a21 = 12,363,153,837,123).

    No RH claim - face OPEN / PROBABLY TRUE at tCE20; wall
    UNMOVED.

* **E56 (2026-11-15, 0326):**
    * M5 WINDOW 21 CERTIFIED (19,999 zeros, all simple and
      on the line; final b snapped down one; seam
      bit-identical; 1 Rosser exception rescued to wider
      union 6=6, recorded) + CE21 GREEN 8786, full tree
      17454.
    * Frontier re-anchored: tCE21 = 3,000,175,430,928
      (tCE21 - tCE20 = 4,673; 98,128 above H0 - within
      1,872 of the 100k mark); 419,992 certified over
      (g_a1, g_b21].
    * Window 22 in flight (a22 = 12,363,153,857,122).

    No RH claim - face OPEN / PROBABLY TRUE at tCE21; wall
    UNMOVED.

* **E57 (2026-11-15, 0327):**
    * M5 WINDOW 22 CERTIFIED (20,000 zeros, all simple and
      on the line; CLEAN window - zero exceptions; seam
      bit-identical; runs 49/49) + CE22 GREEN 8787, full
      tree 17454.
    * MILESTONE: frontier CROSSES 100k above H0 - tCE22 =
      3,000,175,435,601, tCE22 - tPT2 = 102,801 (in-tree
      frontierPast100k); 439,992 certified over (g_a1,
      g_b22].
    * Window 23 in flight (a23 = 12,363,153,877,122).

    No RH claim - face OPEN / PROBABLY TRUE at tCE22; wall
    UNMOVED.

* **E58 (2026-11-15, 0328):**
    * M5 WINDOW 23 CERTIFIED (20,000 zeros, all simple and
      on the line; seam bit-identical; 1 Rosser exception
      6=6, recorded) + CE23 GREEN 8788, full tree 17454.
    * Frontier re-anchored: tCE23 = 3,000,175,440,274
      (tCE23 - tCE22 = 4,673; 107,474 above H0 - 100k mark
      still crossed); 459,992 certified over (g_a1, g_b23].
    * Window 24 in flight (a24 = 12,363,153,897,122).

    No RH claim - face OPEN / PROBABLY TRUE at tCE23; wall
    UNMOVED.

* **E59 (2026-11-15, 0329):**
    * M5 WINDOW 24 CERTIFIED (20,000 zeros, all simple and
      on the line; seam bit-identical; 1 Rosser exception
      7=7, recorded) + CE24 GREEN 8789, full tree 17454.
    * Frontier re-anchored: tCE24 = 3,000,175,444,947
      (tCE24 - tCE23 = 4,673; 112,147 above H0 - 100k mark
      still crossed); 479,992 certified over (g_a1, g_b24].
    * Window 25 in flight (the 25-window chain is imminent;
      125k mark above H0 ~3 windows out).

    No RH claim - face OPEN / PROBABLY TRUE at tCE24; wall
    UNMOVED.

* **E60 (2026-11-15, 0330):**
    * MILESTONE: M5 WINDOW 25 CERTIFIED (20,000 zeros, all
      simple and on the line; CLEAN window; seam
      bit-identical) + CE25 GREEN 8790, full tree 17454.
      The 25-window chain is complete: 499,992 certified
      zeros over (g_a1, g_b25] - within EIGHT of the
      half-million mark.
    * Frontier re-anchored: tCE25 = 3,000,175,449,620
      (tCE25 - tCE24 = 4,673; 116,820 above H0; 125k mark
      ~2 windows out).
    * CASING refined (0330): the 3-decimal bound (CE18)
      triggers only when the two-decimal round-down would
      equal the floor (frac < ~0.01); window 25's frac
      0.0840 keeps the standard 2-decimal bound adequate
      (margin 4.0e-3 vs radius 1.29e-26).
    * Window 26 in flight (a26 = 12,363,153,937,122).

    No RH claim - face OPEN / PROBABLY TRUE at tCE25; wall
    UNMOVED.

* **E61 (2026-11-15, 0331):**
    * M5 WINDOW 26 CERTIFIED (20,000 zeros, all simple and
      on the line; seam bit-identical; 1 Rosser exception
      5=5, recorded) + CE26 GREEN 8791, full tree 17454.
    * Frontier re-anchored: tCE26 = 3,000,175,454,293
      (tCE26 - tCE25 = 4,673; 121,493 above H0; the 125k
      mark is ONE WINDOW OUT).
    * 519,992 certified over (g_a1, g_b26] - past the
      half-million-minus-19,992 mark. CASING: window 26's
      frac 0.0192 (second near-CASING window after 25's
      0.0840) stays on the 2-decimal side (margin 9.17e-3
      vs radius 1.29e-26).
    * Window 27 in flight (a27 = 12,363,153,957,122; the
      125k crossing is expected).

    No RH claim - face OPEN / PROBABLY TRUE at tCE26; wall
    UNMOVED.

* **E62 (2026-11-15, 0332):**
    * MILESTONE: M5 WINDOW 27 CERTIFIED (20,000 zeros, all
      simple and on the line; seam bit-identical; 1 Rosser
      exception 6=6, recorded) + CE27 GREEN 8792, full tree
      17454.
    * Frontier CROSSES 125k above H0: tCE27 =
      3,000,175,458,965, tCE27 - tPT2 = 126,165 (in-tree
      frontierPast125k) - second round-mark crossing after
      100k at CE22.
    * NEW: the face shrink came out as the 4,672 VARIANT
      (tCE27 - tCE26 = 4,672; g_b27's high frac 0.9543 is
      the cause - expected floor arithmetic, chain
      unaffected).
    * 539,992 certified over (g_a1, g_b27]. Window 28 in
      flight (a28 = 12,363,153,977,122).

    No RH claim - face OPEN / PROBABLY TRUE at tCE27; wall
    UNMOVED.

* **E63 (2026-11-15, 0333):**
    * M5 WINDOW 28 CERTIFIED (20,000 zeros, all simple and
      on the line; seam bit-identical) + CE28 GREEN 8793,
      full tree 17454.
    * NEW: FIRST MULTI-EXCEPTION WINDOW - three Rosser
      rescues in one window (6=6 m=8, 4=4 m=8, 4=4 m=8),
      all quota-met, all displaced within the window, all
      recounted by the verifier, all recorded. The union
      mechanism handles multi-rescue transparently.
    * Frontier re-anchored: tCE28 = 3,000,175,463,638
      (tCE28 - tCE27 = 4,673, running pattern resumes after
      the 27th window's 4,672 variant; 130,838 above H0;
      150k mark ~4 windows out).
    * 559,992 certified over (g_a1, g_b28]. Window 29 in
      flight (a29 = 12,363,153,997,122).

    No RH claim - face OPEN / PROBABLY TRUE at tCE28; wall
    UNMOVED.

* **E64 (2026-11-15, 0334):**
    * M5 WINDOW 29 CERTIFIED (20,000 zeros, all simple and
      on the line; seam bit-identical) + CE29 GREEN 8794,
      full tree 17454.
    * RECURRING: second consecutive multi-exception window
      (two Rosser rescues, 5=5 m=4 twice, both quota-met,
      both recorded) - multi-rescue is now a documented
      steady-state phenomenon of the lane (windows 28 and
      29 in a row); convention unchanged.
    * Frontier re-anchored: tCE29 = 3,000,175,468,311
      (tCE29 - tCE28 = 4,673, running pattern; 135,511
      above H0; 150k mark ~3 windows out).
    * 579,992 certified over (g_a1, g_b29]. Window 30 in
      flight (a30 = 12,363,154,017,122; the 30-window
      milestone is imminent).

    No RH claim - face OPEN / PROBABLY TRUE at tCE29; wall
    UNMOVED.

* **E65 (2026-11-15, 0335):**
    * MILESTONE - the 30-WINDOW CHAIN is COMPLETE: M5 WINDOW
      30 CERTIFIED (20,000 zeros, all simple and on the
      line; seam bit-identical) + CE30 GREEN 8795, full
      tree 17454.
    * CLEAN WINDOW (eleventh of thirty, first since window
      25) - the multi-exception spell (windows 28-29) is
      over and fully recorded; the lane has returned to
      clean behavior.
    * 599,992 certified over (g_a1, g_b30] - WITHIN EIGHT
      OF THE 600,000 MARK.
    * Frontier re-anchored: tCE30 = 3,000,175,472,984
      (tCE30 - tCE29 = 4,673, running pattern; 140,184
      above H0; 150k mark ~2 windows out).
    * Window 31 in flight (a31 = 12,363,154,037,122; the
      150k crossing is expected in window 31 or 32).

    No RH claim - face OPEN / PROBABLY TRUE at tCE30; wall
    UNMOVED.

* **E66 (2026-11-15, 0336):**
    * MILESTONE - 600K CROSSED: M5 WINDOW 31 CERTIFIED
      (CLEAN + snapped: final b snapped down one per the
      documented endpoint policy; b - a = 19,999 =
      sign_changes_inside EXACTLY zeros, all simple and on
      the line; no gap - window 32 starts from exactly this
      b; seam bit-identical) + CE31 GREEN 8796, full tree
      17454.
    * 619,991 certified over (g_a1, g_b31] -
      OVER SIX HUNDRED THOUSAND certified on-line zeros.
      (Twelfth clean window, second consecutive clean.)
    * Frontier re-anchored: tCE31 = 3,000,175,477,657
      (tCE31 - tCE30 = 4,673, running pattern INTACT
      despite the snapped width; 144,857 above H0; the
      150k mark is ~1 window out - window 32).
    * Window 32 in flight (a32 = 12,363,154,057,121).

    No RH claim - face OPEN / PROBABLY TRUE at tCE31; wall
    UNMOVED. The 600k milestone is a certification-scale
    achievement, not an analytic one.

* **E67 (2026-11-15, 0337):**
    * M5 WINDOW 32 CERTIFIED (20,000 zeros, all simple and
      on the line; seam bit-identical) + CE32 GREEN 8797,
      full tree 17454.
    * CLEAN WINDOW (thirteenth of thirty-two; THIRD
      CONSECUTIVE clean - 30, 31, 32) - the
      post-multi-exception baseline is confirmed stable.
    * 639,991 certified over (g_a1, g_b32].
    * Frontier re-anchored: tCE32 = 3,000,175,482,330
      (tCE32 - tCE31 = 4,673, running pattern; 149,530
      above H0; the 150k mark sits 470 units ahead -
      window 33 is expected to cross it).
    * Window 33 in flight (a33 = 12,363,154,077,121).

    No RH claim - face OPEN / PROBABLY TRUE at tCE32; wall
    UNMOVED.

* **E68 (2026-11-15, 0338):**
    * MILESTONE - 150K CROSSED: M5 WINDOW 33 CERTIFIED
      (CLEAN - fourth consecutive clean: 30, 31, 32, 33;
      20,000 zeros all simple and on the line; seam
      bit-identical) + CE33 GREEN 8798, full tree 17454.
      frontierPast150k proven in-tree (tCE33 - tPT2 =
      154,203 > 150,000).
    * Round-mark sequence: 100k @ CE22 (102,801), 125k @
      CE27 (126,165), 150k @ CE33 (154,203). Next: 175k,
      ~4-5 windows out.
    * 659,991 certified over (g_a1, g_b33].
    * Frontier re-anchored: tCE33 = 3,000,175,487,003
      (tCE33 - tCE32 = 4,673, running pattern).
    * Window 34 in flight (a34 = 12,363,154,097,121).

    No RH claim - face OPEN / PROBABLY TRUE at tCE33; wall
    UNMOVED. The 150k crossing is a certification-scale
    achievement, not an analytic one.

* **E69 (2026-11-15, 0339):**
    * M5 WINDOW 34 CERTIFIED (20,000 zeros, all simple and
      on the line; seam bit-identical; ONE Rosser rescue,
      5=5 m=4, quota-met, recorded) + CE34 GREEN 8799,
      full tree 17454.
    * The FOUR-window clean streak (30-31-32-33, longest in
      the chain up to that point) ENDS as expected - the
      usual mix of the lane returns.
    * 679,991 certified over (g_a1, g_b34].
    * Frontier re-anchored: tCE34 = 3,000,175,491,676
      (tCE34 - tCE33 = 4,673, running pattern; 158,876
      above H0; 175k mark ~3-4 windows out).
    * Window 35 in flight (a35 = 12,363,154,117,121).

    No RH claim - face OPEN / PROBABLY TRUE at tCE34; wall
    UNMOVED.

* **E70 (2026-11-15, 0340):**
    * M5 WINDOW 35 CERTIFIED (20,000 zeros, all simple and
      on the line; seam bit-identical; ONE Rosser rescue,
      5=5 m=4, quota-met, recorded) + CE35 GREEN 8800,
      full tree 17454.
    * 699,991 certified over (g_a1, g_b35].
    * Frontier re-anchored: tCE35 = 3,000,175,496,349
      (tCE35 - tCE34 = 4,673, running pattern; 163,549
      above H0; 175k mark ~2-3 windows out).
    * Window 36 in flight (a36 = 12,363,154,137,121).

    No RH claim - face OPEN / PROBABLY TRUE at tCE35; wall
    UNMOVED.

* **E71 (2026-11-15, 0341):**
    * M5 WINDOW 36 CERTIFIED (CLEAN - fifteenth clean
      window; 20,000 zeros all simple and on the line; seam
      bit-identical) + CE36 GREEN 8801, full tree 17454.
    * 719,991 certified over (g_a1, g_b36].
    * Frontier re-anchored: tCE36 = 3,000,175,501,022
      (tCE36 - tCE35 = 4,673, running pattern; 168,222
      above H0; the 175k mark is 6,778 units away -
      ~1-2 windows out).
    * Window 37 in flight (a37 = 12,363,154,157,121).

    No RH claim - face OPEN / PROBABLY TRUE at tCE36; wall
    UNMOVED.

* **E72 (2026-11-15, 0342):**
    * M5 WINDOW 37 CERTIFIED (20,000 zeros, all simple and
      on the line; seam bit-identical; ONE Rosser rescue,
      5=5 m=8, quota-met, recorded) + CE37 GREEN 8802,
      full tree 17454.
    * 739,991 certified over (g_a1, g_b37].
    * Frontier re-anchored: tCE37 = 3,000,175,505,695
      (tCE37 - tCE36 = 4,673, running pattern; 172,895
      above H0; **the 175k mark sits 2,105 units ahead -
      window 38 is expected to cross it**).
    * Window 38 in flight (a38 = 12,363,154,177,121).

    No RH claim - face OPEN / PROBABLY TRUE at tCE37; wall
    UNMOVED.

* **E73 (2026-11-16, 0343):**
    * MILESTONE - 175K CROSSED: M5 WINDOW 38 CERTIFIED
      (CLEAN - sixteenth clean window; 20,000 zeros all
      simple and on the line; seam bit-identical) + CE38
      GREEN 8803, full tree 17454. frontierPast175k proven
      in-tree (tCE38 - tPT2 = 177,568 > 175,000).
    * NEW: FIRST CASING CASE IN THE CHAIN - g_b38's frac
      part 0.00704 < 0.01, so the two-decimal round-down
      would equal the floor; per the documented CASING
      rule, gB38Lo uses the THREE-decimal round-down 0.007
      (margin ~4.07e-5, nineteen orders above the radius).
      The re-anchoring machinery is unchanged by CASING.
    * Round-mark sequence: 100k @ CE22 (102,801), 125k @
      CE27 (126,165), 150k @ CE33 (154,203), 175k @ CE38
      (177,568). Next: 200k, ~5 windows out.
    * 759,991 certified over (g_a1, g_b38].
    * Frontier re-anchored: tCE38 = 3,000,175,510,368
      (tCE38 - tCE37 = 4,673, running pattern).
    * Window 39 in flight (a39 = 12,363,154,197,121).

    No RH claim - face OPEN / PROBABLY TRUE at tCE38; wall
    UNMOVED. The 175k crossing and the CASING case are
    certification-scale achievements, not analytic ones.

* **E74 (2026-11-16, 0344):**
    * M5 WINDOW 39 CERTIFIED (20,000 zeros, all simple and
      on the line; seam bit-identical; ONE Rosser rescue,
      4=4 m=4, quota-met, recorded) + CE39 GREEN 8804,
      full tree 17454.
    * 779,991 certified over (g_a1, g_b39].
    * Frontier re-anchored: tCE39 = 3,000,175,515,040
      (tCE39 - tCE38 = 4,672 — **the 4,672 variant**;
      182,240 above H0; 200k mark ~4 windows out).
    * FACE-SHRINK PATTERN NOW FULLY CHARACTERIZED: gaps of
      4,672 or 4,673 dominate (4,671 observed once at
      snapped-width window 31) — floor arithmetic of
      successive Gram points, no analytic consequence.
    * Window 40 in flight (a40 = 12,363,154,217,121).

    No RH claim - face OPEN / PROBABLY TRUE at tCE39; wall
    UNMOVED.

* **E75 (2026-11-16, 0345):**
    * MILESTONE - 40TH WINDOW: M5 WINDOW 40 CERTIFIED
      (b - a = 19,998 zeros, all simple and on the line;
      seam bit-identical; CLEAN window) + CE40 GREEN
      8805, full tree 17454.
    * NEW EVENT: **FIRST SNAP BY 2** (first 19,998-width
      window) — requested b was not a good Gram point,
      pipeline snapped b down by 2. This extends the
      documented "snap the final b downward" convention:
      it can snap by more than 1. The window total is
      still the certified quantity. The chain remains
      seamless: window 41 starts from the snapped b.
    * 799,989 certified over (g_a1, g_b40] — within 11 of
      the 800,000 mark.
    * Frontier re-anchored: tCE40 = 3,000,175,519,713
      (tCE40 - tCE39 = 4,673, running pattern restored;
      186,913 above H0; 200k mark ~3 windows out).
    * Window 41 in flight (a41 = 12,363,154,237,119 =
      the snapped b of window 40).

    No RH claim - face OPEN / PROBABLY TRUE at tCE40; wall
    UNMOVED. The 40th window is a certification-scale
    achievement, not an analytic one.

* **E76 (2026-11-16, 0346):**
    * MILESTONE - 800K CROSSED: M5 WINDOW 41 CERTIFIED
      (CLEAN - eighteenth clean window; 20,000 zeros all
      simple and on the line) + CE41 GREEN 8806, full
      tree 17454.
    * SEAM ACROSS WINDOW 40'S SNAP BY 2 VERIFIED:
      window 41's g_a ball is bit-identical to window
      40's snapped g_b ball. The exact-dyadic-tuple seam
      audit handles snapped and un-snapped endpoints
      identically — the chain is seamless across a snap.
    * 819,989 certified over (g_a1, g_b41] — the 800,000
      mark is CROSSED.
    * Frontier re-anchored: tCE41 = 3,000,175,524,386
      (tCE41 - tCE40 = 4,673, running pattern;
      191,586 above H0; 200k mark ~2 windows out).
    * Window 42 in flight (a42 = 12,363,154,257,119).

    No RH claim - face OPEN / PROBABLY TRUE at tCE41; wall
    UNMOVED. The 800k crossing and the seam-across-snap
    are certification-scale achievements.

* **E77 (2026-11-16, 0347):**
    * M5 WINDOW 42 CERTIFIED (CLEAN - nineteenth clean
      window; 20,000 zeros all simple and on the line;
      seam bit-identical) + CE42 GREEN 8807, full tree
      17454.
    * 839,989 certified over (g_a1, g_b42].
    * Frontier re-anchored: tCE42 = 3,000,175,529,059
      (tCE42 - tCE41 = 4,673, running pattern;
      196,259 above H0; **the 200k mark sits 3,741 units
      ahead - the crossing is expected in window 43, in
      flight**).
    * Window 43 in flight (a43 = 12,363,154,317,119).

    No RH claim - face OPEN / PROBABLY TRUE at tCE42; wall
    UNMOVED.

## E78 · 0348 — the seam audit earns its keep (M5 launch error caught + corrected; 200k crossed)
- **0348 (CORRECTION + 200k MILESTONE):** window 43's launch carried an M5
  arithmetic error (a = b42 + 20000, not b42) → 20,000-point gap left between
  w42 and w43 → the exact-dyadic-tuple SEAM AUDIT caught the break (gap
  4,672.935 units) → FILL window certified clean (33,301 pts, runs 47/47, both
  seams bit-identical) → CE42B (fill, GREEN 8808; **frontierPast200k proven
  in-tree: tCE42B − tPT2 = 200,932**) + CE43 (w43 in corrected position, GREEN
  8809, full 17454; tCE43 = 3,000,175,538,405, 205,605 above H0; one quota-met
  rescue recorded). Cumulative certified: **879,989**. The audit is the lane's
  load-bearing safety net — and it demonstrably caught a real launch error.
  Wall {θ | 4/7 < θ} pinned; face open at tCE43. **NO RH CLAIM.**

## E79 · 0349 — window 44 + CE44 (210,278 above H0; 899,989 certified; 225k ~3 windows out)
- **0349 (window 44 + CE44):** w44 launched from b43 correctly (the 0348 rule
  held), seam audit passed BEFORE the module (g_a44 ≡ g_b43 exact dyadic), 20,000
  zeros simple+on-line (33,953 pts, verifier CERTIFIED, runs 46/48), ONE quota-met
  rescue ([..324,338,..324,340] → union [..324,337,..324,341], need 4 = found 4,
  m = 4; first two-in-a-row rescue stretch since w28/w29). CE44 GREEN 8810 (full
  17454): tCE44 = 3,000,175,543,078, shrink 4,673 (13th consecutive), 210,278 above
  H0 (200k carried); corrected chain w1..w42,w42b,w43,w44 seamless. Cumulative
  certified 899,989. Wall pinned; face open at tCE44. **NO RH CLAIM.**

## E80 · 0350 — the M2 wall literature audit (2025-grade primary sources; no movement)
- **0350 (M2 LANE - WALL AUDIT):** pulled Conrey's book (1407.4358 §VIII),
  CCM (1309.1526 / Math. Ann. 356 (2013)), Inoue (1904.11051; 2510.14309),
  Tsang 1986 (via the citation). Findings: S UNBOUNDED unconditionally
  (Selberg 1946 mean-square, verbatim); best RH upper bound DIVERGES
  ((1/4+o(1)) log/loglog, CCM Thm 2); best RH Ω GROWS
  ((log t log log log t)/(log log t), Inoue/Bondarenko-Seip); ΔΩ unconditional
  (Tsang) and under RH (Inoue 2025). Verdict: Door 1 (absolute |S(zero)| ≤ K)
  DEAD as a published input (E19 gap exact: no at-zeros Ω found); Door 2
  (growth, 4/7 wall) ALIVE + PINNED; Door 3 (θ=∞) ALIVE + conjectural. Wall
  UNMOVED; face open at tCE44. **NO RH CLAIM.**

## E81 · 0351 — window 45 + CE45 (214,951 above H0; 919,989 certified; 900k crossed; 225k ~2 windows out)
- **0351 (window 45 + CE45):** launched correctly from b44 (a45 = 12,363,154,337,119;
  the earlier "a45 = 357,119" status line was b45 mislabeled — typo recorded in
  the CE45 header); seam audit g_a45 ≡ g_b44 exact dyadic BEFORE the module;
  20,000 zeros simple+on-line (33,537 pts, verifier CERTIFIED/turing_ok, K_cons
  12 vs K_req ≤ 11.4380); FIRST DOUBLE-RESCUE WINDOW: two quota-met union
  rescues ([..354,108,..354,113] need 5 = found 5 m 2; [..355,776,..355,780]
  need 4 = found 4 m 8); Rosser runs 46/47. CE45 GREEN 8811 (full tree green):
  tCE45 = 3,000,175,547,751, gB45Lo = 300017554775102/100, shrink 4,673
  (14th consecutive), 214,951 above H0, 25k-mark distance 10,049. Cumulative
  certified 919,989 — 900,000 mark crossed inside w45. Same unit: SWall.lean
  GREEN 8706 — the 0350 wall audit formalized in-tree (cited Props +
  LEAN-PROVEN consequences; upperRH_bound_diverges proves the CCM 13/50 bound
  diverges). Wall {θ | 4/7 < θ} pinned; face open at tCE45. **NO RH CLAIM.**

## E82 · 0352 — window 46 + CE46 (219,623 above H0; 939,989 certified; CLEAN window; 225k ~1 window out)
- **0352 (window 46 + CE46):** launched correctly from b45 (a46 = 12,363,154,357,119;
  the 0348 lesson held, no correction needed this time); seam audit g_a46 ≡ g_b45 exact dyadic
  BEFORE the module; 20,000 zeros simple+on-line (33,356 pts, 2518.0 s; verifier CERTIFIED/
  turing_ok, K_cons 12 vs K_req ≤ 11.4380); CLEAN WINDOW (0 failures / 0 rescues) — clean tally
  20 of 47; Rosser runs 47/45. CE46 GREEN 8812 (full tree green): tCE46 = 3,000,175,552,423,
  gB46Lo = 300017555242395/100, **shrink 4,672 — the 15th increment BREAKS the 14-long 4,673
  stretch** (recorded honestly; no periodicity assumed), endpoint high in unit (frac 0.9561);
  219,623 above H0; 225k-mark distance 5,377 (crossing expected in w47 — compute, don't assume).
  Cumulative certified 939,989. M2: SWall in-tree GREEN; wall {θ | 4/7 < θ} pinned. **NO RH CLAIM.**

## E83 · 0353 — window 47 + CE47 (224,296 above H0; 959,989 certified; 2nd consecutive CLEAN; 225k just 704 out)
- **0353 (window 47 + CE47):** launched correctly from b46 (a47 = 12,363,154,377,119); seam audit
  g_a47 ≡ g_b46 exact dyadic BEFORE the module; 20,000 zeros simple+on-line (33,302 pts, 2511.2 s;
  verifier CERTIFIED/turing_ok, K_cons 12 vs K_req ≤ 11.4380); SECOND CONSECUTIVE CLEAN WINDOW
  (0 failures/rescues) — clean tally 21 of 48; Rosser runs 48/47. CE47 GREEN 8813, 0 errors 0
  warnings (full tree green): tCE47 = 3,000,175,557,096, gB47Lo = 300017555709689/100,
  **increment 4,673 — the resume after the 4,672 break** (wobble, not periodic; no pattern
  assumed); 224,296 above H0; **225k-mark distance 704 — the crossing is expected in w48**
  (compute the floor, never pre-announce). Cumulative certified 959,989. M2: SWall in-tree
  GREEN; wall {θ | 4/7 < θ} pinned. **NO RH CLAIM.**

## E84 · 0354 — window 48 + CE48 ★ MILESTONE (225,000-unit mark CROSSED: 228,969 above H0; 979,989 certified; 960k also crossed; 3rd consecutive CLEAN)
- **0354 (window 48 + CE48, MILESTONE UNIT):** launched correctly from b47 (a48 = 12,363,154,397,119);
  seam audit g_a48 ≡ g_b47 exact dyadic BEFORE the module; 20,000 zeros simple+on-line (33,506
  pts, 2574.9 s; verifier CERTIFIED/turing_ok, K_cons 12 vs K_req ≤ 11.4380); THIRD CONSECUTIVE
  CLEAN WINDOW (0 failures/rescues) — clean tally 22 of 49; Rosser runs 48/48. CE48 GREEN 8814
  (0 errors 0 warnings, full tree green): tCE48 = 3,000,175,561,769, gB48Lo = 300017556176982/100,
  increment 4,673 (17th), **tCE48 − tPT2 = 228,969 > 225,000 — THE 225k MARK IS CROSSED (by 3,969),
  proven in-tree as frontierPast225k** (as frontierPast200k was in CE42B). Round marks: 100k@CE22,
  125k@CE27, 150k@CE33, 175k@CE38, 200k@CE42B, **225k@CE48**; next 250k is 21,031 ahead. Cumulative
  certified 979,989 (960k mark crossed inside w48; 1M mark 20,011 ahead, crosses in w50). Honest
  scope: a frontier record, NOT an RH statement — face open at tCE48; M2 wall pinned. **NO RH CLAIM.**

## E85 · 0355 — window 49 + CE49 (225k crossing carried at 233,642; 999,989 certified = 11 short of 1M, lands in w50; 4th consecutive CLEAN)
- **0355 (window 49 + CE49):** launched correctly from b48 (a49 = 12,363,154,417,119);
  seam audit g_a49 ≡ g_b48 exact dyadic BEFORE the module; 20,000 zeros simple+on-line (32,784
  pts, 2436.3 s; verifier CERTIFIED/turing_ok, K_cons 12 vs K_req ≤ 11.4380); FOURTH
  CONSECUTIVE CLEAN WINDOW (0 failures/rescues) — clean tally 23 of 50; Rosser runs 48/50.
  CE49 GREEN 8815 (0 errors 0 warnings, full tree green): tCE49 = 3,000,175,566,442,
  gB49Lo = 300017556644276/100, increment 4,673 (18th), tCE49 − tPT2 = 233,642 — the 225k
  CE48 crossing CARRIED, re-proven as frontierPast225k at the new frontier; 250k mark 16,358
  ahead (~3.5 windows). Cumulative certified 999,989 — **ELEVEN short of the 1,000,000 mark,
  which lands in window 50** (1,019,989 at w50's end; recorded from verified data in CE50).
  Honest scope unchanged: NO analytic move; face open at tCE49; M2 wall pinned. **NO RH CLAIM.**

## E86 · 0356 — window 50 + CE50 ★ MILESTONE (CERTIFIED COUNT): 1,000,000-certified-zero mark CROSSED — 1,019,989 total
- **0356 (window 50 + CE50, MILESTONE UNIT):** launched correctly from b49 (a50 = 12,363,154,437,119);
  seam audit g_a50 ≡ g_b49 exact dyadic BEFORE the module; 20,000 zeros simple+on-line (33,100
  pts, 2460.0 s; verifier CERTIFIED/turing_ok, K_cons 12 vs K_req ≤ 11.4380); FIFTH CONSECUTIVE
  CLEAN WINDOW (0 failures/rescues) — clean tally 24 of 51; Rosser runs 49/44. CE50 GREEN 8816
  (0 errors 0 warnings, full tree green): tCE50 = 3,000,175,571,115, gB50Lo = 300017557111569/100,
  increment 4,673 (19th), tCE50 − tPT2 = 238,315 — the 225k CE48 crossing CARRIED (frontierPast225k
  re-proven at the new frontier); 250k mark 11,685 ahead (~2.5 windows → expect w52/w53). THE
  MILESTONE: cumulative certified zeros over (g_a1, g_b50] = **1,019,989 — the 1,000,000 mark is
  CROSSED** (recorded from the verified per-window chain counts; round marks: 800k@CE41,
  900k@w45, 960k@w48, 1M@w50) — the first seven-figure all-on-the-line certified region in the
  program. Honest scope: a frontier record, NOT an RH statement; face open at tCE50; M2 wall
  pinned. **NO RH CLAIM.**

## E87 · 0357 — window 51 + CE51 (SNAPPED, width 19,999; one recorded quota-met Rosser rescue; 225k carried at 242,988; certified 1,039,988)
- **0357 (window 51 + CE51):** launched correctly from b50 (a51 = 12,363,154,457,119);
  seam audit g_a51 ≡ g_b50 exact dyadic BEFORE the module; **b ACTUAL 12,363,154,477,118 —
  SNAPPED DOWN 1 (width 19,999**, first since w40); 19,999 zeros simple+on-line (33,636 pts,
  2532.2 s; verifier CERTIFIED/turing_ok, K_cons 12 vs K_req ≤ 11.4380); **ONE Rosser
  exception, RESCUED, QUOTA-MET, RECORDED** (block [..473,629, ..473,632] need 3 found 1 →
  union [..473,628, ..473,633] need 5 FOUND 5, m = 4) — first since w45 double-rescue; the
  5-consecutive-clean streak (w46–w50) ends here, honest tally 24 of 52; the block is interior
  and the Turing step (recomputed window total 19,999 + end runs 49/47) passes. CE51 GREEN 8817
  (0 errors 0 warnings, full tree green): tCE51 = 3,000,175,575,788, gB51Lo =
  300017557578839/100, increment 4,673 (20th), tCE51 − tPT2 = 242,988 — the 225k CE48 crossing
  CARRIED (frontierPast225k re-proven at the new frontier); **250k mark 7,012 ahead — expect
  the crossing in w53** (~2,339 left after w52). Certified count 1,039,988 (snap cost 1; 1M
  mark carried). Honest scope unchanged: NO analytic move; face open at tCE51; M2 wall pinned.
  **NO RH CLAIM.**

## E88 · 0358 — window 52 + CE52 (SNAPPED, width 19,999, second in a row; TWO recorded quota-met Rosser rescues; 225k carried at 247,661; 250k now 2,339 ahead → crossing expected in w53; certified 1,059,987)
- **0358 (window 52 + CE52):** launched correctly from b51 (a52 = 12,363,154,477,118 — the
  snapped w51 endpoint); seam audit g_a52 ≡ g_b52 exact dyadic BEFORE the module; **b ACTUAL
  12,363,154,497,117 — SNAPPED DOWN 1 AGAIN (width 19,999)**; 19,999 zeros simple+on-line
  (33,708 pts, 2498.0 s; verifier CERTIFIED/turing_ok, K_cons 12 vs K_req ≤ 11.4380); **TWO
  Rosser exceptions, both RESCUED, QUOTA-MET, RECORDED** (block1 [..479,388, ..479,390] need
  2 found 0 → union [..479,387, ..479,392] need 5 FOUND 5; block2 [..480,004, ..480,007] need
  3 found 1 → union [..480,003, ..480,009] need 6 FOUND 6) — both INTERIOR, neither touches an
  end run; Turing step (recomputed window total 19,999 + end runs 48/45) passes. CE52 GREEN 8818
  (0 errors 0 warnings, full tree green): tCE52 = 3,000,175,580,461, gB52Lo =
  300017558046109/100, increment 4,673 (21st), tCE52 − tPT2 = 247,661 — the 225k CE48 crossing
  CARRIED (frontierPast225k re-proven); **250k mark 2,339 ahead → crossing expected in w53**.
  Certified count 1,059,987 (snap cost 1; 1M mark carried). Honest tally 24 of 53 clean.
  NO analytic move: face open at tCE52; M2 wall pinned. **NO RH CLAIM.**

## E89 · 0359 — window 53 + CE53 (NON-SNAPPED width 20,000 — the w51/w52 streak ends; THREE recorded quota-met Rosser rescues; THE 250,000-UNIT FRONTIER MILESTONE CROSSED: 252,334 above H0, frontierPast250k proven in-tree; certified 1,079,987)
- **0359 (window 53 + CE53 — THE 250 000-UNIT MILESTONE UNIT):** launched correctly from b52
  (a53 = 12,363,154,497,117); seam audit g_a53 ≡ g_b53 tuple [113343428831147822184536190820181931, −75,
  16777217, −110] BEFORE the module; **NON-SNAPPED (b = a + 20,000 exactly)**; 20,000 zeros
  simple+on-line (34,037 pts, 2554.0 s; verifier CERTIFIED/turing_ok, K_cons 12 vs K_req ≤ 11.4380);
  **THREE Rosser exceptions, all RESCUED, QUOTA-MET, RECORDED** (blocks [..499,170, ..499,172],
  [..507,862, ..507,864], [..510,768, ..510,770] — each need 2 found 0 → unions need 4/5/5 found
  4/5/5; the most rescues in one window of the corrected chain); all interior — Turing step
  (recomputed window total 20,000 + end runs 47/49) passes. CE53 GREEN (8,819 targeted for CE52+CE53,
  0 errors 0 warnings, full tree green): tCE53 = 3,000,175,585,134, gB53Lo = 300017558513403/100,
  increment 4,673 (22nd), **tCE53 − tPT2 = 252,334 → THE 250 000-UNIT MARK IS CROSSED, exactly where
  the ~4,673/window pace predicted** (2,339 short at w52's end); `frontierPast250k` proven in-tree;
  next round mark 275k is 22,666 ahead (expect w59 or w60). Certified count 1,079,987 (full width;
  1M mark carried). Doc-provenance repair in CE52/CE53 (stale WINDOW-50 full-slice attributions) —
  theorem content never affected, both re-built GREEN. Honest tally 24 of 54 clean. NO analytic
  move: face open at tCE53; M2 wall pinned. **NO RH CLAIM.**

## E90 · 0360 — window 54 + CE54 (NON-SNAPPED width 20,000; ONE recorded quota-met Rosser rescue; THE 4,672 INCREMENT RECURS — second occurrence, no pattern claimed; 250k milestone CARRIED: 257,006 above H0; certified 1,099,987 — 1.1M mark 13 short, expect w55)
- **0360 (window 54 + CE54):** launched correctly from b53 (a54 = 12,363,154,517,117);
  seam audit g_a54 ≡ g_b53 tuple [29015917825967697847748600342133254453, −83, 16777217,
  −110] BEFORE the module; **NON-SNAPPED (b = a + 20,000)**; 20,000 zeros simple+on-line
  (33,606 pts, 2559.1 s; verifier CERTIFIED/turing_ok, K_cons 12); **ONE Rosser exception,
  RESCUED, QUOTA-MET, RECORDED** ([..518,280, ..518,282] need 2 found 0, 129 pts → union
  [..518,279, ..518,283] need 4 found 4, m = 4; interior — Turing step passes); g_b54 =
  3,000,175,589,806.969726562500 ± 1.29e-26 (tuple [..96973, −86, ..]), frac 0.9697, no
  CASING (margin ~9.7e-3). **tCE54 = 3,000,175,589,806; increment 4,672 — THE w45/w46
  ONE-SHOT ANOMALY RECURS** (second 4,672; other twenty increments 4,673; no pattern
  assumed); **tCE54 − tPT2 = 257,006 — 250k CARRIED** (frontierPast250k re-proven; next
  mark 275k 17,994 ahead, expect w58/w59). CE54 GREEN (8,820 targeted, 0 errors 0
  warnings, full tree green; 19 doc blocks swept, clause-doc audit OK). Certified count
  1,099,987 (full width) — **1,100,000 mark 13 short, expect w55**. Honest tally 25 of 55
  clean. NO analytic move: face open at tCE54; M2 wall pinned. **NO RH CLAIM.**

## E91 · 0361 — window 55 + CE55 (THE 1,100,000 CERTIFIED-ZERO MARK LANDED: 1,119,987 total, exactly where predicted; NON-SNAPPED width 20,000, one recorded quota-met rescue with odd-width-5 union; 4,673 standing pace RESUMES; 261,679 above H0, 250k carried)
- **0361 (window 55 + CE55 — THE 1.1M CERTIFIED-ZERO MILESTONE UNIT):** launched correctly
  from b54 (a55 = 12,363,154,537,117); seam audit g_a55 ≡ g_b53 tuple
  [232127342969292425709106731252692813973, −86, 16777217, −110] BEFORE the module;
  **NON-SNAPPED (b = a + 20,000)**; 20,000 zeros simple+on-line (33,350 pts, 2471.6 s;
  verifier CERTIFIED/turing_ok, K_cons 12); **ONE Rosser exception, RESCUED, QUOTA-MET,
  RECORDED** ([..556,936, ..556,938] need 2 found 0, 129 pts → union [..556,934, ..556,939]
  need 5 found 5, m = 4 — **odd union width 5**; interior — Turing step passes); g_b55 =
  3,000,175,594,479.904785156250 ± 1.29e-26 (tuple [..87921, −83, ..]), frac 0.9048,
  no CASING (margin ~4.8e-3). **tCE55 = 3,000,175,594,479; increment 4,673 — THE STANDING
  PACE RESUMES** (the two 4,672's remain isolated); **tCE55 − tPT2 = 261,679 — 250k
  CARRIED** (frontierPast250k re-proven; 275k 13,321 ahead, expect w59). CE55 GREEN
  (8,821 targeted, 0 errors 0 warnings, full tree green; 19 doc blocks swept,
  clause-doc audit OK). **Certified count 1,099,987 + 20,000 = 1,119,987 — THE 1,100,000
  MARK LANDED (13 short at w54's end, exactly where predicted)**; next 1.2M 80,013 ahead
  (~w59/60). Honest tally 26 of 56 clean. NO analytic move: face open at tCE55; M2 wall
  pinned. **NO RH CLAIM.**

## E92 · 0362 — window 56 + CE56 (NON-SNAPPED width 20,000; FOUR recorded quota-met rescues — most since w53; 4,673 standing pace; 266,352 above H0, 250k carried, 275k now 8,648 ahead; certified 1,139,987)
- **0362 (window 56 + CE56):** launched correctly from b55 (a56 = 12,363,154,557,117);
  seam audit g_a56 ≡ g_b55 tuple [29015917916355408576910488047858487921, −83,
  16777217, −110] BEFORE the module; **NON-SNAPPED (b = a + 20,000)**; 20,000 zeros
  simple+on-line (34,778 pts, 2647.0 s; verifier CERTIFIED/turing_ok, K_cons 12);
  **FOUR Rosser exceptions (most in a window since w53), ALL RESCUED, QUOTA-MET,
  RECORDED** — [..560,392..394]→[..560,391..396] (5/5, m8), [..568,076..079]→[
  ..568,075..080] (5/5, m8), [..571,197..199]→[..571,195..200] (5/5, m4),
  [..575,445..448]→[..575,443..449] (6/6, m8) — all interior (Turing step passes:
  total 20,000, end runs 49/48). g_b56 = 3,000,175,599,152.839843750000 ± 1.29e-26
  (frac 0.8398, no CASING, margin ~9.8e-3). **tCE56 = 3,000,175,599,152; increment
  4,673 (standing pace continues)**; **tCE56 − tPT2 = 266,352 — 250k CARRIED**
  (re-proven; 275k now 8,648 ahead — expect w58 or w59). CE56 GREEN (8,822 targeted,
  0 errors 0 warnings, full tree green; 19 doc blocks swept, clause-doc audit OK).
  **Certified 1,139,987** (1.1M carried; 1.2M 60,013 ahead — expect crossing w60,
  with the running total landing 1,199,987 [13 short] at w59). Honest tally
  26 of 57 clean. NO analytic move: face open at tCE56; M2 wall pinned. **NO RH CLAIM.**

## E93 · 0363 — window 57 + CE57 (CLEAN WINDOW — first since w50; NON-SNAPPED width 20,000; 4,673 standing pace; 271,025 above H0, 250k carried, 275k now 3,975 ahead — EXPECTED IN W58; certified 1,159,987)
- **0363 (window 57 + CE57):** launched correctly from b56 (a57 = 12,363,154,577,117);
  seam audit g_a57 ≡ g_b56 tuple [232127343692394111500520322163846277315, −86,
  16777217, −110] BEFORE the module; **NON-SNAPPED (b = a + 20,000)**; **CLEAN:
  ZERO Rosser failures (first clean window since w50)**; 20,000 zeros simple+on-line
  (33,523 pts, 2519.3 s; verifier CERTIFIED/turing_ok, K_cons 12, end runs 49/48).
  g_b57 = 3,000,175,603,825.774902343750 ± 1.29e-26 (frac 0.7749, no CASING,
  margin ~4.9e-3). **tCE57 = 3,000,175,603,825; increment 4,673 (standing pace
  continues)**; **tCE57 − tPT2 = 271,025 — 250k CARRIED** (re-proven; 275k now
  3,975 ahead — expected in W58: 271,025 + 4,672 = 275,697 ≥ 275,000 even at the
  slowest observed increment). CE57 GREEN (8,823 targeted, 0 errors
  0 warnings, olean fresh; 19 doc blocks swept, clause-doc audit OK; generator
  derived mechanically from gen_ce56 for construction safety). **Certified
  1,159,987** (1.1M carried; 1.2M 40,013 ahead — running total at w59 should land
  1,199,987 [13 short again], crossing expected w60). Honest tally 27 of 58 clean.
  NO analytic move: face open at tCE57; M2 wall pinned. **NO RH CLAIM.**

## E94 · 0364 — window 58 + CE58 (CLEAN WINDOW — second consecutive; NON-SNAPPED width 20,000; 4,673 standing pace; 275,698 above H0 — **THE 275,000-UNIT MILESTONE IS CROSSED IN WINDOW 58**, frontierPast275k proven in-tree, exactly as predicted from 0363; certified 1,179,987)
- **0364 (window 58 + CE58):** launched correctly from b57 (a58 = 12,363,154,597,117);
  seam audit g_a58 ≡ g_b57 tuple [116063672026972477182407992315941454601, −85,
  16777217, −110] BEFORE the module; **NON-SNAPPED (b = a + 20,000)**; **CLEAN:
  ZERO Rosser failures (second consecutive clean window)**; 20,000 zeros simple+on-line
  (33,532 pts, 2617.8 s; verifier CERTIFIED/turing_ok, K_cons 12, end runs 48/46).
  g_b58 = 3,000,175,608,498.709960937500 ± 1.29e-26 (frac 0.70996, no CASING,
  margin ~9.96e-3). **tCE58 = 3,000,175,608,498; increment 4,673 (standing pace
  continues)**; **tCE58 − tPT2 = 275,698 — THE 275,000-UNIT MILESTONE IS CROSSED
  IN WINDOW 58 (margin 698)**, exactly where 0363 predicted; `frontierPast275k`
  proven in-tree. CE58 GREEN (8,824 targeted, 0 errors 0 warnings, olean fresh;
  19 doc blocks swept + new milestone doc, clause-doc audit OK; generator
  derived mechanically from gen_ce57 for construction safety). **Certified
  1,179,987** (1.1M carried; 1.2M 20,013 ahead — running total at w59 should land
  1,199,987 [13 short again], crossing expected w60). Honest tally 28 of 59 clean.

## E95 · 0365 — window 59 + CE59 (NON-SNAPPED width 20,000; ONE interior Rosser exception rescued/quota-met/recorded; 4,673 standing pace; 280,371 above H0 — 275k [CE58] CARRIED re-proven, 300k 19,629 ahead (~w64); certified 1,199,987 — 1.2M now only 13 ahead, expect w60)
- **0365 (window 59 + CE59):** launched correctly from b58 (a59 = 12,363,154,617,117);
  seam audit g_a59 ≡ g_b58 tuple [29015918051936974651021361477904096537, −83,
  16777217, −110] BEFORE the module; **NON-SNAPPED (b = a + 20,000)**; **ONE interior
  Rosser exception, rescued, quota-met, recorded** (block [12,363,154,630,886,
  12,363,154,630,889] need 3/found 1 → union [..885, ..891] need 6/FOUND 6, m = 4);
  20,000 zeros simple+on-line (34,153 pts, 2638.4 s; verifier CERTIFIED/turing_ok,
  K_cons 12, end runs 45/51). g_b59 = 3,000,175,613,171.645140768233954 ± 1.29e-26
  (frac 0.64514, no CASING, margin ~5.0e-3). **tCE59 = 3,000,175,613,171;
  increment 4,673 (standing pace continues)**; **tCE59 − tPT2 = 280,371 — 275k
  [CE58] CARRIED** (re-proven; 300k now 19,629 ahead — expect ~w64). CE59 GREEN
  (8,825 targeted, 0 errors 0 warnings, olean fresh; 20 doc blocks swept,
  clause-doc audit OK; generator derived mechanically from gen_ce58 for
  construction safety). **Certified 1,199,987** (1.1M carried; **1.2M now only
  13 ahead — crossing expected in w60**). Honest tally 28 of 60 clean.

## E96 · 0366 — window 60 + CE60 (CLEAN WINDOW — zero Rosser failures; NON-SNAPPED width 20,000; 4,673 standing pace; 285,044 above H0 — 275k [CE58] CARRIED re-proven, 300k 14,956 ahead (~w64); **THE 1,200,000 CERTIFIED-ZERO MARK IS CROSSED IN WINDOW 60**, total 1,219,987)
- **0366 (window 60 + CE60):** launched correctly from b59 (a60 = 12,363,154,637,117);
  seam audit g_a60 ≡ g_b59 tuple [232127344777046640030585043774150839739, −86,
  16777217, −110] BEFORE the module; **NON-SNAPPED (b = a + 20,000)**; **CLEAN:
  ZERO Rosser failures** (nothing to record or suppress); 20,000 zeros simple+on-line
  (33,650 pts, 2645.7 s; verifier CERTIFIED/turing_ok, K_cons 12, end runs 49/42).
  g_b60 = 3,000,175,617,844.5802597930180285 ± 1.29e-26 (frac 0.58026, no CASING;
  honest note: two-decimal lower-bound margin unusually thin ~2.6e-4 — exact
  rational comparison by norm_num, no floating point). **tCE60 = 3,000,175,617,844;
  increment 4,673 (standing pace continues)**; **tCE60 − tPT2 = 285,044 — 275k
  [CE58] CARRIED** (re-proven; 300k now 14,956 ahead — expect ~w64). CE60 GREEN
  (8,826 targeted, 0 errors 0 warnings, olean fresh; 20 doc blocks swept,
  clause-doc audit OK; generator derived mechanically from gen_ce59 for
  construction safety). **Certified 1,219,987 — THE 1,200,000 CERTIFIED-ZERO
  MARK IS CROSSED IN WINDOW 60** (as predicted in 0365). Honest tally 29 of 61 clean.

## E97 · 0367 — window 61 + CE61 (NON-SNAPPED width 20,000; THREE interior Rosser exceptions, all rescued/quota-met/recorded; 4,673 standing pace; 289,717 above H0 — 275k [CE58] CARRIED re-proven, 300k 10,283 ahead (~w64); certified 1,239,987 — 1.2M [w60] carried)
- **0367 (window 61 + CE61):** launched correctly from b60 (a61 = 12,363,154,657,117);
  seam audit g_a61 ≡ g_b60 tuple [58031836284649370708014610130223021139, −84,
  16777217, −110] BEFORE the module; **NON-SNAPPED (b = a + 20,000)**;
  **THREE interior Rosser exceptions** (blocks ..660,796-98 / ..668,681-83 /
  ..671,952-55) **all rescued, quota-met, recorded** — union widths 5/4/6,
  m = 4/8/8; end runs 50/45 (both ≥ 12); 0 cross-check failures (34,517 pts,
  2678.2 s); verifier CERTIFIED/turing_ok, K_cons 12. g_b61 =
  3,000,175,622,517.515378547149186 ± 1.29e-26 (frac 0.5154, no CASING,
  margin ~5.4e-3). **tCE61 = 3,000,175,622,517; increment 4,673 (standing
  pace)**; **tCE61 − tPT2 = 289,717 — 275k [CE58] CARRIED** (re-proven; 300k
  now 10,283 ahead — expect ~w64). CE61 GREEN (8,827 targeted, 0 errors
  0 warnings, olean fresh; 20 doc blocks swept; clause-doc audit OK;
  generator derived mechanically from gen_ce60 for construction safety).
  **Certified 1,239,987 (1.2M [w60] carried; 1.3M is 60,013 ahead — ~w64/65).**
  Honest tally 29 of 62 clean; w61 the heaviest rescue window since w56.

## E98 · 0368 — window 62 + CE62 (NON-SNAPPED width 20,000; ONE interior Rosser exception rescued/quota-met/recorded; 4,673 standing pace; 294,390 above H0 — 275k [CE58] CARRIED re-proven, 300k 5,610 ahead — expect w64; certified 1,259,987 — 1.2M [w60] carried)
- **0368 (window 62 + CE62):** launched correctly from b61 (a62 = 12,363,154,677,117);
  seam audit g_a62 ≡ g_b61 tuple [116063672750074162806295541049855739823, −85,
  16777217, −110] BEFORE the module; **NON-SNAPPED (b = a + 20,000)**;
  **ONE interior Rosser exception** (block ..684,272-74, need 2 found 0)
  **rescued, quota-met, recorded** — union [..684,271, ..684,276] FOUND 5/5,
  m = 4; end runs 45/44 (both ≥ 12); 0 cross-check failures (33,287 pts,
  2567.8 s); verifier CERTIFIED/turing_ok, K_cons 12. g_b62 =
  3,000,175,627,190.4504970306274269 ± 1.29e-26 (frac 0.4505, no CASING;
  honest note: two-decimal lower-bound margin ~5.0e-4 — second-thinnest in
  the chain after W60's ~2.6e-4 — exact rational norm_num, no floating
  point). **tCE62 = 3,000,175,627,190; increment 4,673 (standing pace)**;
  **tCE62 − tPT2 = 294,390 — 275k [CE58] CARRIED** (re-proven; 300k now
  5,610 ahead — w63 lands ~299,063 (937 short), w64 ~303,736: **expect
  the 300k crossing in WINDOW 64**). CE62 GREEN (8,828 targeted, 0 errors
  0 warnings, olean fresh; 20 doc blocks swept; clause-doc audit OK;
  generator derived mechanically from gen_ce61 for construction safety).
  **Certified 1,259,987 (1.2M [w60] carried; 1.3M is 40,013 ahead —
  ~w64/65).** Honest tally 29 of 63 clean.

## E99 · 0369 — window 63 + CE63 (SNAPPED DOWN by 1 — width 19,999, FIRST SNAP SINCE WINDOW 52 — recorded honestly; ONE interior Rosser exception rescued/quota-met/recorded; 4,673 standing pace; 299,063 above H0 — 275k [CE58] CARRIED re-proven, 300k 937 ahead — expect w64; certified 1,279,986)
- **0369 (window 63 + CE63):** launched correctly from b62 (a63 = 12,363,154,697,117);
  seam audit g_a63 ≡ g_b62 tuple [232127345861699168372182968546863997789, −86,
  16777217, −110] BEFORE the module; **SNAPPED DOWN by 1** (b requested
  12,363,154,717,117 not a good Gram point at working precision; b ACTUAL
  12,363,154,717,116, width 19,999 — **FIRST SNAP SINCE WINDOW 52**, recorded
  honestly); **ONE interior Rosser exception** (block ..704,631-33, need 2
  found 0) **rescued, quota-met, recorded** — union [..704,630, ..704,634]
  FOUND 4/4, m = 8; end runs 46/49 (both ≥ 12); 0 cross-check failures
  (33,849 pts, 2662.2 s); verifier CERTIFIED/turing_ok, K_cons 12. g_b63 =
  3,000,175,631,863.1519684875488765 ± 1.29e-26 (frac 0.1520, no CASING,
  margin ~1.97e-3). **tCE63 = 3,000,175,631,863; increment 4,673 (standing
  pace)**; **tCE63 − tPT2 = 299,063 — 275k [CE58] CARRIED** (re-proven; the
  w63 prediction of 937 short of 300k is EXACT — w64 lands ~303,736:
  **expect the 300k crossing in WINDOW 64**). CE63 GREEN (8,828+1 = 8,829
  targeted, 0 errors 0 warnings, olean fresh; 20 doc blocks swept;
  clause-doc audit OK; generator derived mechanically from gen_ce62 for
  construction safety). **Certified 1,279,986 (SNAPPED: +19,999; 1.2M [w60]
  carried; 1.3M is 20,014 ahead — ~w64/65).** Honest tally 29 of 64 clean.

## E100 · 0370 — window 64 + CE64 (CLEAN WINDOW — zero Rosser failures; NON-SNAPPED width 20,000; 4,673 standing pace; tCE64 = 303,736 above H0 — **THE 300,000-UNIT MILESTONE IS CROSSED IN WINDOW 64**, margin 3,736, the 0369 prediction is EXACT; certified 1,299,986 — the 1,300,000 mark is 14 ahead, expect w65)
- **0370 (window 64 + CE64):** launched correctly from the SNAPPED b63
  (a64 = 12,363,154,717,116); seam audit g_a64 ≡ g_b63 tuple
  [232127346223231933568697690834737861837, −86, 16777217, −110] BEFORE the
  module; **NON-SNAPPED (b = a + 20,000)**; **CLEAN: ZERO Rosser failures**
  (nothing to record or suppress); 20,000 zeros simple+on-line (33,769 pts,
  2672.5 s; verifier CERTIFIED/turing_ok, K_cons 12, end runs 46/50). g_b64
  = 3,000,175,636,536.08708642973481849 ± 1.29e-26 (frac 0.0871, no CASING,
  margin ~7.1e-3). **tCE64 = 3,000,175,636,536; increment 4,673 (standing
  pace)**; **tCE64 − tPT2 = 303,736 — THE 300,000-UNIT MILESTONE IS CROSSED
  IN WINDOW 64** (margin 3,736; the 0369 prediction 299,063 + 4,673 =
  303,736 is EXACT). CE64 GREEN (8,830 targeted, 0 errors 0 warnings, olean
  fresh; 20 doc blocks swept; clause-doc audit OK; **new frontierPast300k
  proven in-tree**, gen_ce58 pattern; generator derived mechanically from
  gen_ce63 for construction safety). **Certified 1,299,986 (1.2M [w60]
  carried; the 1,300,000 mark is 14 ahead — EXPECTED IN WINDOW 65; the
  325,000-unit frontier mark is 21,264 ahead — expect ~w69).** Honest tally
  30 of 65 clean. Round-mark sequence above H0 now ends: 250 000 @ CE53,
  275 000 @ CE58, **300 000 @ CE64**.

## E101 · 0371 — window 65 + CE65 (NON-SNAPPED width 20,000; one interior Rosser rescue, quota-met, recorded; 4,673 standing pace; tCE65 = 308,409 above H0 — 300k milestone carried with margin 8,409; **THE 1,300,000 CERTIFIED-ZERO MARK IS CROSSED IN WINDOW 65** — 1,319,986 total, the 0370 prediction EXACT; generator 4-arg-rep hole found and patched)
- **0371 (window 65 + CE65):** launched from b64 (a65 = 12,363,154,737,116);
  seam audit g_a65 ≡ g_b64 tuple [232127346584782776286409114165073595457,
  −86, 16777217, −110] BEFORE the module (0348 rule); **NON-SNAPPED
  (b = a + 20,000)**; **ONE interior Rosser exception, rescued,
  quota-met, recorded** (block [..757,083, ..757,086] need 3/found 1 →
  union [..757,082, ..757,087] FOUND 5/5, m=8; touches neither end run);
  20,000 zeros simple+on-line (33,892 pts, 2780.3 s; verifier
  CERTIFIED/turing_ok, K_cons 12, end runs 43/47; 0 cross-check
  failures). g_b65 = 3,000,175,641,209.02220410126784534 ± 1.29e-26
  (frac 0.0222, no CASING; two-decimal Lo margin THIN ~2.2e-3 —
  recorded honestly, exact norm_num comparison). **tCE65 =
  3,000,175,641,209; increment 4,673 (standing pace)**; tCE65 − tPT2 =
  308,409 — **300k milestone [window 64] CARRIED** (margin 8,409);
  325k is 16,591 ahead (expect ~w69). CE65 GREEN (8,831 targeted, 0
  errors 0 warnings, olean fresh; 21 doc blocks swept incl. past300k
  carry doc; clause-doc audit OK). **Generator reliability note:**
  gen_ce64's milestone rep was 4-arg (invisible to the 3-arg AST
  de-river) → p275k carry stranded in first gen; stale-scan caught it
  pre-build; patched + regenerated. Standing rule: re-handle every
  4-arg rep of the source generator explicitly. **Certified 1,319,986 —
  THE 1,300,000 CERTIFIED-ZERO MARK IS CROSSED IN WINDOW 65** (the
  0370 "14 ahead" prediction, EXACT; 1.2M [w60] carried; 1.4M is
  80,014 ahead, expect ~w69). Honest tally CORRECTED by the 0371
  certificate-derived audit to **31 of 66 clean** (50 internal failures
  across 35 rescue windows, all quota-met; the carried "30 of 66" was a
  recount artifact — see the TALLY CORRECTION fact in 0371). Side-step
  since 0370: Millennial-puzzle feasibility check PARKED (back-pocket
  §5; no analytic move either way).
- **0372 (unit 86) — WINDOW 66 + CE66:** W66 certified (non-snapped,
  20 000; 34 268 evals, 2 614.6 s; verifier certified/turing_ok, runs
  20/51, K = 12 — 0.65 s wall). TWO recorded Rosser exceptions, both
  rescued quota-met: one INTERIOR (..770 603–605 → union FOUND 5/5) and
  the SEAM-ADJACENT block (..757 083–086) that failed in W65's interior
  failing again in W66's left extension — same physical block,
  deterministic; recorded, not suppressed. Seam bit-identical (pre-module
  audit). tCE66 = 3 000 175 645 881 (increment **4 672 — Third
  occurrence**, no pattern assumed); 313 081 above H0 (300k carried,
  13 081 margin; 325k 11 919 ahead, expect w68/69); certified 1 339 986
  (1.3M [w65] carried; 1.4M 60 014 ahead, expect ~w69/70). CE66 green
  (8 832 / 17 454, fresh); face now **terminalFaceCE66** — OPEN, NO RH
  CLAIM. Tally: 31 of 67 clean (36 rescue windows, 51 internal failures).
  **Speed-up decision (user question):** cross-window cache seeding
  (global cache keys; resumed_from_cache logged in each certificate) +
  32 workers from W67; no M/C_R/precision/verifier changes; expected
  ~30–36 min/window vs ~45. Also: roesser→rosser field-name typo swept
  from 164 record/formal files.
- **0373 (unit 87) — WINDOW 67 + CE67 + speed-up measurement:** W67
  certified (non-snapped 20 000; 33 835 evals, 2 497.2 s; runs 49/44,
  K = 12) — CLEAN WINDOW (zero Rosser failures anywhere, no rescues).
  tCE67 = 3 000 175 650 554 (increment 4 673, the usual one); 317 754
  above H0 (300k carried, margin 17 754; **325k 7 246 ahead — expected
  window 69**); certified 1 359 986 (1.4M 40 014 ahead, ~w69). CE67
  green (8 833 / 17 454, fresh; hW labels corrected in docs against the
  slice types; the 'hence <= tCE..' boundary phrasing fixed in CE66/CE67
  docs). Face now **terminalFaceCE67** — OPEN, NO RH CLAIM. Tally: 32 of
  68 clean (36 rescue windows, 51 failures). **Speed-up, honest
  numbers:** seed-cache + 32 workers measured -117 s (~4.5%) — only
  ~175-177 cache hits because the shared region between consecutive
  windows is only the M = 60 band; the REAL lever is PIPELINE OVERLAP —
  W68 launched at 01:45 (seam audit already PASSED) and runs while CE67
  formalized: per-unit critical path = max(run, formalization), ~10-15
  min/unit recovered.
- **0374 (unit 88) — WINDOW 68 + CE68:** W68 certified (non-snapped
  20 000; 34 145 evals, 2 498.3 s; runs 47/50, K = 12) - TWO interior
  Rosser failures, both rescued quota-met, recorded not suppressed.
  tCE68 = 3 000 175 655 227 (increment 4 673); 322 427 above H0 (300k
  carried, margin 22 427; **325k 2 573 ahead - expected window 69**);
  certified 1 379 986 (1.4M 20 014 ahead, ~w69/70). CE68 green (8 834 /
  17 454, fresh, 21 docs). Face now **terminalFaceCE68** - OPEN, NO RH
  CLAIM. Tally: 32 of 69 clean (37 rescue windows, 53 failures).
  **PIPELINE OVERLAP CONFIRMED:** W68 ran while CE67 formalized (run time
  flat at 2 498.3 s vs 2 497.2 s - the gain is the overlap itself); W69
  launched 02:32 and runs while CE68 formalized.
- **0375 (unit 89) — WINDOW 69 + CE69:** W69 certified (non-snapped
  20 000; 34 723 evals, 2 498.5 s, seeded 101 872, 32 workers; runs
  46/47, K = 12) - TWO interior Rosser failures, both rescued quota-met,
  recorded. tCE69 = 3 000 175 659 900 (increment 4 673); **327 100 above
  H0 = THE 325 000-UNIT MILESTONE CROSSED IN WINDOW 69** (margin 2 100,
  inside the predicted corridor); 350k 22 900 ahead (~w74). Certified
  1 399 986 (1.4M 14 ahead -> expected w70). CE69 green (8 835 / 17 454,
  fresh, 21 docs; frontierPast325k proven in-tree). Face now
  **terminalFaceCE69** - OPEN, NO RH CLAIM. Tally through W70: 32 of 69
  clean (37 rescue windows, 56 failures). **THE 1.4M FORECAST CONFIRMED
  IN THE MEANTIME:** W70 certified (33 731 evals, 2 490.4 s; one
  rescue, runs 47/50; seam bit-identical; tCE70 - tPT2 = 331 773) with
  certified total **1 419 986 - the 1 400 000 CERTIFIED-ZERO MARK CROSSED
  IN WINDOW 70** exactly as forecast at 0374/0375. W71 to launch in
  overlap.
- **0376 (unit 90) — WINDOW 70 + CE70:** W70 certified (non-snapped
  20 000; 33 731 evals, 2 490.4 s, seeded 136 403, 32 workers; runs
  47/50, K = 12) - ONE interior Rosser failure rescued quota-met
  (m = 16), recorded. tCE70 = 3 000 175 664 573 (increment 4 673);
  331 773 above H0 (325k carried, margin 6 773; 300k carried, margin
  31 773; 350k 18 227 ahead ~w74). **CENSUS: certified total 1 419 986 =
  THE 1 400 000 CERTIFIED-ZERO MARK CROSSED IN WINDOW 70 - the 0375
  forecast (14 ahead) confirmed exactly**; 1.5M 80 014 ahead (~w78). CE70
  green (8 836 / 17 454, fresh, 21 docs; deriver now slices PAST blocks
  verbatim from the predecessor - closes the hand-carry drift hole from
  0371/0374). Face now **terminalFaceCE70** - OPEN, NO RH CLAIM. Tally: 32
  of 69 clean (37 rescue windows, 56 failures). W71 running in overlap.
- **0377 (unit 91) — WINDOW 71 + CE71:** W71 certified (non-snapped 20 000;
  33 981 evals, 2 483.4 s, seeded 169 900, 32 workers; runs 48/43, K = 12)
  - ONE interior Rosser failure rescued quota-met (m = 8), recorded. tCE71
  = 3 000 175 669 246 (increment 4 673); 336 446 above H0 (325k carried,
  margin 11 446; 300k carried, margin 36 446; 350k 13 554 ahead ~w74).
  Certified total 1 439 986 (1.4M carried from W70; 1.5M 60 014 ahead
  ~w78). CE71 green on first try (8 837 / 17 454, fresh, 21 docs; iff RHS =
  predecessor face CE70.terminalFaceCE70). Face now **terminalFaceCE71** -
  OPEN, NO RH CLAIM. Tally: 32 of 70 clean (38 rescue windows, 57
  failures). W72 running in overlap (fifth run overlapped the formalization:
  2 483.4 s, fastest of the series).
