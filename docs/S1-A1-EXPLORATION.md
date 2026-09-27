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
