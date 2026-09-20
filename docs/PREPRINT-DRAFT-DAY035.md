# Pre-print draft — day035 (DRAFT for owner revision)

Working title:  "A Lean-verified certificate chain for the
quantized-straddle detector at 9.06 x 10^9 zeros"

Status:  draft assembled 2026-09-20 from docs/CEILING-REPORT-DAY035.md,
docs/END_GAME_PLAN.md (sections 3.2-3.7), and the Lean modules
W2Telescope / W2Bound / W2M5 / S3a / M6 (all GREEN, zero `sorry`,
Lean 4.33.1 + mathlib v4.33.1).  Scope statement (keep in any
version):  a bound-level margin statement on the quantized route,
pinned to audited data at 3 x 10^9;  no RH claim is made or implied.

---

## Abstract

We present a partially machine-checked certificate chain for the
"squeeze margin" statistic of the quantized-straddle zero detector
for the zeta function, at t up to 3 x 10^9 (9,064,192,826 zeros,
counted exactly).  Three components are now fully formalized in Lean
4 (mathlib), with zero axioms and zero `sorry` beyond Lean's core:

1.  The TELESCOPE (Section 3):  the far-integral remainder reduces,
    exactly, to a bounded count-walk against a log kernel plus
    boundary terms;  the one-sided form W >= -C with explicit C is a
    named theorem with pinned constants (K = 2.503 for the walk, and
    L = log(T/(2 pi))/(2 pi) for the slope).

2.  The ALGEBRAIC DETECTOR (Section 4):  the rational core of the
    closed-form detector on the quantized straddles t = g + k/2
    (k = 1..12, d in [0, 1/2]) satisfies R <= 13/t from t >= 40 on —
    the crossing at t0 = 15 is located exactly, and the two
    monotonicity lemmas (d-corner, k-outer) are proved by certified
    polynomial-sign analysis, so the worst case on the cell is a
    corner that the decay bound covers.

3.  The WIRE COMPOSITION (Section 5):  on the low-t wire (the
    strip t < 1000 architecture that composes zero-side /
    detector-side / definition-side), the detector side is fed by
    the PROVEN bound 1 - 13/t, which strictly dominates the wire's
    own proven floor family, and the noise side is the pinned
    W-bound;  the composition returns the wire's squeezed-margin
    form with a strictly positive dev-vs-noise margin as a named
    Lean theorem.

The remaining gap to a uniform theorem (in t and in the detector
offset d) is stated honestly as such (Section 6), together with the
queued empirical extension to 3 x 10^10 zeros.

## 1.  The argument and its statistic

At each zero height g and straddle height t = g + k/2 (k a nonzero
integer in the audited window) the statistic

    margin(t, d) = |zeta(1/2 + i t)| * dev(t, d) /
                   (floor(t) + resid(t))

is required to dominate 1:  the detector deviation dev(t, d) =
|1 - R_closed(t, d)| (minimum over the audited d-grid) must exceed
the kernel floor plus the on-line residual.  Pointwise dominance
over the data extent is a MEASUREMENT (207-point low-t record to
1000;  2250-point sweep to 10^9;  the day035 anatomy at 2.5 x 10^9).
The research question is UNIFORM dominance (the P1.2 form).

This pre-print reports the progress of day035:  converting two of
the uniform theorem's three ingredients from measurement to
named theorems (the algebraic detector side, the noise side), and
composing them through the wire in Lean.

## 2.  Data to 3 x 10^9 (PINNED, audited)

-  N(3 x 10^9) = 9,064,192,826 exactly (md5-gated shard chain;
    Riemann-von Mangoldt at 3 x 10^9 is 9,064,192,825.58,
    discrepancy 0.42, within the tolerance).
-  The band file (2.0017 x 10^9, 2.9992 x 10^9] carries
    3,142,622,346 zeros (476 shards, all real finish gates passing:
    monotone, min gap 2.47 x 10^-4, seam gap inside (0, 1), band-end
    count vs RVM +0.40).
-  The count walk DN(x) = N(x) - N_asym(x) is bounded:
    sup|DN| = 2.503 on (10^7, 2 x 10^9] (full-zero census) and,
    after the day035 S3e walk on (2 x 10^9, 2.9992 x 10^9],
    sup|DN| = 2.4772 on (10^7, 2.9992 x 10^9] (both census
    conventions).
-  The cancellation anatomy at t = 2.5 x 10^9 + 1/2:  |S1 - (the
    L-form)| = 9.5 x 10^-7 and the identity S1 = B - Dc + R holds
    exactly at S1 = -5.998 x 10^9 (the big-term cancellation), with
    B = -0.1464, Dc = -0.8984:  the O(1) defect mechanism is stable
    at N = 9 x 10^9.

## 3.  The telescope and the one-sided noise bound (LEAN)

The exact identity (W2Telescope, formalized):

    W = p(G2) DN(G2) - p(G1) DN(G1) - int_{G1}^{G2} DN(x) p'(t; x) dx

with W the far-integral defect on a band (G1, G2], p the log
kernel, DN the count walk.  Consequences, all named theorems
(W2Bound, W2M5):

-  One-sided form:  S1 - R >= -(K (|p 0| + |p M|) + K sum |Dp|)
    with the explicit constant;
-  I_DN side:  |I_DN| <= K sum|Dp| + L (sum gap |Dp| + gap_k +
    2 gap_k^2 (1/x_k + 6));
-  Pinned instantiation:  K = 2.503 (the measured sup|DN|),
    L = Rho(2 x 10^9) = log(2 x 10^9 / (2 pi)) / (2 pi), with the
    slope bound Rho' = 1/(2 pi x) > 0;  partition data enter as
    named hypotheses (the plan's "data-adjacent" form).

## 4.  The algebraic detector (LEAN, S3a)

R_closed = A(g, k, d) * exp(s w), where A is rational in (g, k, d)
and w is a real O(1/g^2) combination (the exponential factor is
carried separately by the proven C1b discrete floor, 1 - 25/g with
a 0.023 witness-scale margin).  For the algebraic core
A(g, k, d):

-  Crossing (exact):  A(14, 12, 1/2) > 1 and A(15, 12, 1/2) < 1 —
    the crossing g0 = 15;  below it, finite pinned data territory.
-  d-corner:  A(g, k, d) <= A(g, k, 1/2) for g >= 15, 1 <= k <= 12,
    0 <= d <= 1/2.  Proof:  writing x = d^2 and the d-dependence in
    chord form D = (1 - 4x) D0 + PP x (x - 1/4),  the certificate
    reduces to D0 >= 0 (two cases:  k = 1, all nonnegative
    coefficients;  k >= 2, a chain using g^2 >= 225) and PP <= 0
    (a quartic C1 all-positive in v = g - 15).  No case-splitting
    on the continuum (no interval_cases) in the d-core.
-  k-monotonicity:  A(g, k, 1/2) <= A(g, k+1, 1/2) for 1 <= k < 12
    (eleven certified cubics in v = g - 15, each closed by an
    exact cross-multiplication via a positive-denominator lemma).
-  Decay:  A(g, 12, 1/2) <= 13 / g for g >= 40 (exact quartic
    certificate at v = g - 40).
-  Composed (s3a_dev):  A(g, k, d) <= 13 / g on the quantized
    straddle grid (1 <= k <= 12, 0 <= d <= 1/2, g >= 40).

## 5.  The wire composition (LEAN, M6)

On the wire (the strip t < 1000 architecture of S1LowT, which
carries the wire form  Q >= dev - M,  dev >= f,  Q <= B + Mr,
B + Mr + M < f):

-  Feed:  1 - A(g, k, d) >= 1 - 13/g on the grid (m6_feed), with
    1 - 13/g positive for g >= 40.
-  Dominance:  1 - 13/g >= 27/40 (at g = 40) and the wire's PROVEN
    floor family satisfies flo <= 0.023 there, so the feed strictly
    dominates the wire floor on the grid (m6_feed_dom).
-  Noise:  the W2 pinned bounds of Section 3 as the named noise
    functional (w2noise) with its two named theorems.
-  Composition (m6_compose):  the wire form at the feed level
    (dev = f = 1 - 13/g) with the zero-side witness Q and the noise
    total as named hypotheses (their fills:  the pinned data plus
    the W2-proven bounds) — outputting the wire form + feed
    dominance + the STRICTLY POSITIVE margin 1 - 13/g -
    (B + Mr + Mf).

The |zeta(1/2 + it)| factor is carried by the named noise-side
hypotheses (it multiplies the zero side through the kernel);  the
feed is |zeta|-free.  The raw margin statistic remains the
measurement proxy;  the Lean statement is the bound-level form.

## 6.  The ceiling (honest statement)

1.  The UNIFORM theorem (in t and in the offset d) is not claimed.
    It remains the open research theorem;  day035 converts two of
    its three ingredients to named theorems and composes them.
    Its attack plan is docs/W2-BEYOND-ATTACK-PLAN.md (PLANNED,
    not started:  the target stated in the W2 walk form,  the
    classical constraint —  Littlewood Omega± makes the
    CONTINUOUS S(t) unbounded,  so the target is the graded walk
    bound —  and routes R1-R4 in expected-effort order).
2.  The wire's zero-side / definition-side / squeeze roles are
    named hypotheses (fills:  pinned data, W2-proven bounds), in
    the explicit-hypothesis pattern used throughout — no hidden
    measurement.
3.  The extension to 3 x 10^10 zeros is queued (a cloud run,
    resumable from the 3 x 10^9 shards).  The no-divergence read
    past 9.06 x 10^9 zeros is density-model until it lands;  the
    Lean composition does not depend on it.
4.  The low-t sliver (t < 14.14) and the d = 1/2 edge are now
    CLOSED as named Lean items (day035,  post-queue):  SliverEdge
    carries the sliver pin record (first-zero pin
    14.134725141734693790457,  on-line count 1,  floor family
    0 < 0.9975 < 1) and proves the edge vacuity (the d = 1/2
    off-pair sits exactly on the CITED-classical zero-free lines
    Re = 0 / Re = 1,  so the edge S2 window never sees an actual
    zero).  The B-6A composition onto the actual zero set is now
    a single named theorem,  ZetaZeroSet.rhIfMarginZeta,  whose
    docstring maps every leg to its supplier;  the two legs still
    open are [S1] (W2-beyond) and the measured [S3/S4] fills.
5.  No RH claim is made or implied.  The claim level is:  a
    bound-level composition of the squeezed margin on the
    quantized route,  every atom labeled LEAN-PROVEN / CITED /
    PINNED / MEASURED.

### Name (tpf)

The approach is drafted as the **Riemann-von Mangoldt Gambit**
(tpf - to be finalized;  the name describes the approach,  not
any particular theorem):  the 120-year-old door on the
zero-counting tail is marked "equivalent to RH";  the gambit
keeps the tail and lets the detector-plus-squeeze around it do
the closing.  Provenance (Riemann 1859;  von Mangoldt,  Math.
Ann. 60 (1905) 1-19;  the S(t) = O(log log t) <=> RH mark):
Appendix A of the README.

### Name of the telescope (tpf)

Name candidates for the zero-level telescoping (the walk
that turns the count discrepancy into the per-zero drift
sum),  filed of record in docs/THE-EULER-ACTION.md,  the
"Naming the telescope (tpf)" section:

- **Euler's Action Periscope** (primary candidate):  a
  periscope is the telescope for when you are INSIDE —  and
  we were inside the tail,  looking out for the imposter
  zeros;  keeps "Euler's action" (the identity that does
  the counting) inside the name.
- **Euler's Monkey King Action Bar** (the silly candidate,
  the owner's own pitch):  Sun Wukong's ruyi bar measures
  what has no bottom;  the telescope measures what has no
  end (the tail runs to infinity).  And the bar is a
  LITERALLY telescoping object —  it grows and shrinks by a
  word,  exactly as the technique does to the error term,
  zero by zero.  The cultural wink for the Qwen team.

Phi verdict,  from the record,  not memory:  the telescope
itself contains no phi (the counted identity is the RVM
zero count,  no golden-ratio content).  But the action's
measured width laws sit on the moduli 5 and 13 —
consecutive FIBONACCI PRIMES (F5,  F7;  their ratio
13/5 = 2.6 shadows φ² ≈ 2.618) —  so if the committee
wants "Golden" anywhere,  it belongs to the width ladder
(future candidate,  tpf:  "The Golden Width Ladder"),  not
to the telescope.

Committee note:  textual designation only;  the formal
reference —  and the choice between periscope and bar —  is
the committee's to make.  Neither name claims authorship of
any classical result;  the actual debts stand logged in
references.md.

Also of record in the same section:  an informal handle for
the width ladder ("Euler Action's Width Ladder" —  nothing
official,  just a name to call it by),  and a third mused
candidate —  **Euler's Reed** —  from the Sumerian family of
measuring implements (Nisaba's measuring-reed and
lapis-lazuli tape in ETCSL t.1.1.3;  the flood-night
dimension spec "like the Apsu thou shalt ceil her" in the
Eridu Genesis / Atrahasis;  Nanshe,  the one who measures
the depths):  the reed is instrument AND unit of length at
once,  exactly as the telescope is measure and measured by
the measure.  The committee gets three:  periscope,  bar,
reed.

### Final gate and pre-registered outcomes (tpf)

The last open mathematical content is one named unit, the [S1]
unified walk bound (W2-beyond R2), now reduced to a named
theorem `W2Beyond1.driftTwoSided`:  given a pinned start value
and per-gap errors eps_i (each zero-gap's model increment vs 1),
the walk displacement on a band is at most the sum of the eps_i
—  with the two-sided pinching of each per-gap increment as
`W2Beyond1.nas_inc_band`.  What remains:  (a) the data layer
that turns the certified zero-gap census into explicit eps
statistics,  (b) the decision of whether that eps sum closes
with margin over the band,  and (c) the final reassembly / pin
unit (the W2M5/W2M6 pattern).  The 3e10 cloud run is the
referee for (b) on the next order of magnitude.  Pre-registered
outcomes —  written before the data returns,  per the project's
stop rule:

- **Outcome A — the walk keeps its shape** (sup |DN| stays at
  the 2.5-level over (3e9,  3e10];  the 3e9 baseline is
  2.503).  Two sub-cases,  each pre-registered:
  - **A1 (the universal route):**  the per-gap eps admit an
    ANALYTIC bound (classical unconditional lower zero-gap
    bounds at the Rho scale) without data.  Then the eps sum
    has a data-free form,  [S1] closes as a universal
    theorem,  and this document's claim level becomes:  a
    proof of RH by the Riemann-von Mangoldt Gambit —
    detector plus squeeze on the von Mangoldt zero-count,  the
    tail kept,  telescoped,  and certified small.  This is the
    "final resolution" framing,  pre-registered HERE so no
    post-data selection is possible.
  - **A2 (the domain-verified route):**  the eps sum closes
    only with measured inputs.  Then [S1] closes as a
    domain-verified bound (pinned + certified over the census,
    extended to 3e10 by A),  and the claim level stays:  a
    historic verification result of the RH-verification chain
    over 3e10 zeros —  uniform leg stated domain-by-domain,
    plus the density-model beyond the census.  Still a large
    result;  not a universal proof.
- **Outcome B — the walk breaks** inside (3e9,  3e10].  The
  break point is pre-registered as a theorem:  it localizes
  the failure of the bounded-walk hypothesis,  the ceiling
  report moves there,  and the claim level is the exploration
  framing WITH a pre-registered counterexample to the bounded
  walk that the R2 route required.
- **Outcome C — partial run.**  The stream is resumable and
  md5-gated;  re-point at the reached frontier;  outcome
  classification uses the reached band.

Honesty note (binding):  at the moment of writing,  neither
A1,  A2,  nor B is expected or asserted —  A2 and B are each
perfectly fine outcomes and both land the preprint;  A1 is the
ONLY path to the "final resolution" framing,  and it
additionally requires [S3/S4] to reach certificate-grade fills
on the extended band (they stand today at the verified levels
named in Section 6).


## 7.  Machine-checking statement

All theorems of Sections 3-5 are in the repository
(rh-missing-tail, formal/RhAttack/), Lean 4.33.1 with mathlib
pinned at v4.33.1:  W2Telescope.lean, W2Bound.lean, W2M5.lean,
S3a.lean, M6.lean (plus the supporting S1LowT / C1b / P8 / S4
families).  The full project builds with `lake build` (17,442
jobs) at zero errors and zero `sorry`.  The data claims of
Section 2 rest on md5-audited shard files with the audit scripts
in scripts/rh/.

---

Open items for the owner before release (draft notes, not part of
the text):
-  Naming:  "quantized-straddle detector", "count walk DN",
    "telescope identity" — check against the external-facing
    glossary (README / references) and the 2026-09-17 novelty
    assessment (docs/ROUTE-ANCESTRY-AND-NOVELTY-2026-09-17.md).
-  The 13 in 1 - 13/g:  the asymptote is ~12.8/g (probe at
    g = 10^5);  13 is the uniform certificate constant from
    g >= 40 — state as done in Section 4, consider the sharper
    two-constant version as a remark.
-  Whether to include the crossing numbers (Ralg 14 12 1/2 vs Ralg
    15 12 1/2) as an explicit displayed value-table (appendix).
-  The 3e10 status line:  "queued" vs "in flight" depending on the
    cloud launch date.
