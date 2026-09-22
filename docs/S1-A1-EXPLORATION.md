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
