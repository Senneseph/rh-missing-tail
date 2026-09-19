# END-GAME PLAN — what it takes from here to the final goal

Status date: 2026-09-19 (night of the day034 H1-cert landing).
No prize claim made or implied; this is a working plan, honest by design.

## 0. The one-sentence state

The logical skeleton (S1-S4 + P12 closure) is machine-proven in
Lean; the squeeze margin is measured (and tonight, re-certified with
explicit error budgets) over the full data extent [1e3, 1e9] at
grid density, always above 1 but decaying (about 1000 at low
heights, 1.08 at the top of the band, hovering 1-4 above it in the
extension to 1.95e9). The final goal needs the margin to be
PROVEN above 1 for ALL heights. That proof is the wall. Everything
else is carpentry.

## 1. The metric, plain (what "one" means)

At a zero height g and straddle height t = g + (integer)/(2):

  signal = |zeta(1/2 + i t)| * dev(t, g)
  noise  = p8_B(t, N) + residf(t)
  margin = signal / noise

- dev = minimum, over the small parameter d on a grid, of
  |R_closed(g, t, d) - 1|, where R_closed is an explicit ratio of
  quadratic forms in (g, t, d) times one exponential factor (the
  exact formula is frozen in `day023_p11c_1e7.R_closed` and in
  Lean).
- residf = |zeta - K_full|, the certified error of our explicit
  zero-data reconstruction of zeta (finite zero sum with budgeted
  precision + two far integrals + the proven P8 floor term).
- margin > 1: the argument's covering step goes through at that
  height. margin = 1: the signal sits exactly at the noise floor
  (no certified room). margin < 1: the chain breaks there; if
  certified, that height is the honest ceiling T* of the route.

## 2. What is blocking the final goal (ranked)

### W1 (THE wall) — the uniform theorem, P1.2(ii)

Prove, for ALL t (and all legal d): the detector dev stays above
the noise by an explicit margin. In the plan's own words: the
lower side — "the detector dominates the LHS uniformly in t" — is
the NEW inequality; nobody has it. Two entries into it:

  (2a) A polynomial-structure theorem for R_closed - 1 (finite
       algebra). See section 3 — this is where we start.
  (2b) A zero-spacing lower bound (hard, adjacent to open
       classical spacing problems; the 2026 Lean-zeta "two-thirds"
       project supplies the RVM-counting input if we get there).

### W2 — the upper side's last chunk, P1.2(i)

The noise bound is ALMOST theorem-strength (most pieces are
Lean-green: P8Floor A5, B3 Sbar, S4 families). The one measured
piece left: the oscillatory far integrals (the Efull remainder,
KNOWN_LIMITATIONS H2). Needed: an explicit PROVEN bound for those
integrals (oscillatory-integral / integration-by-parts estimate on
an integrand with known sign and log-scale structure). Closes the
upper side fully. Bounded effort, no new zeta theory; weeks-scale.

### W3 — the falsification decision (do this FIRST, it is cheap)

Before months on W1/W2: extend the certified scan to the 3e10 zero
chain (staged on disk). The thinnest measured margin above the
band is 1.14 near 2e9; a crossing, if one exists, is most likely
in exactly that region. A certified crossing closes the route
honestly and cheaply (pre-registered outcome (b)); a green 3e10
strongly favors the "hover above one" shape and justifies the
theorem investment.

### W4 — bounded carpentry (recorded, not urgent)

- Grid-density caveat (H4): we certify AT grid points; between
  points, smoothness is the argument. A dev-smoothness bound in t
  (derivative control of |R_closed - 1|) closes the interpolation
  step — the "certificate-continuous" variant, a defensible
  publishable result even if the full uniform theorem stays open.
- The five CITED universals (KNOWN_LIMITATIONS section 3 demotion
  audit, 2026-09-19): A2c bridge = small formal algebra port
  (next candidate); classical zero-free = separate port project;
  the two counting items lose their on-band load to pinned data
  already (Zeta23-style adoption is the off-band path).
- H3 low-t finite data: the d < 1/200 coverage is the window
  branch (pinned-scale floor); unchanged.

## 3. START HERE (owner's direction, 2026-09-19 night): the
polynomial-structure theorem for the detector

### 3.1 The owner's seed intuition (verbatim, preserved)

"We will find some convenient form that's wearing a disguise of a
well-recognized identity, probably related to squares, cubes,
quartic. The idea is that the smallest legal interval any number
could move is a single unit distance in the space where it
exists. If you added one more unit, the number couldn't be prime
because it'd be even by some indirect, unobvious truth" -- a
lattice/quantization obstruction used as the guarantee the
quantity never reaches the danger value.

### 3.2 Why the intuition is well-targeted (first structural read)

R_closed(g, t, d) is, exactly:

  [(1/4 + g^2) * ((g - t)^2 + d^2) * ((g + t)^2 + d^2)]
  ---------------------------------------------------- * exp(s*w)
        (g^2 - t^2) * ((1/2 + d)^2 + g^2) * ((1/2 - d)^2 + g^2)

with s = 1/2 + i t and w a real combination of three reciprocals
of quadratic forms. Three facts from the plain read:

  (i) The algebraic core is PURE quadratic forms; the product
      (g - t)^2 (g + t)^2 = (g^2 - t^2)^2 is the "disguised"
      piece -- a quartic that factorizes in two opposite-shift
      factors. Every factor is a sum of squares.
  (ii) The legal straddles QUANTIZE the height: t - g = k/2 with
      k a nonzero integer in [-12, 12]. The smallest legal
      distance from g is the HALF-UNIT 1/2 -- exactly the
      "single unit distance in the space where it exists" the
      intuition names. d sits on a 500-point grid (or the
      continuum, in the uniform version).
  (iii) On the d = 0 slice the exponential factor is harmless
      (w real, |exp(s w)| = exp(w/2) = 1 + O(1/g^2)) and the
      algebraic part |R| = |g^2 - t^2| / ((1/4 + g^2)) * (small
      corrections) ~ |k| / g for t = g + k/2. So the algebraic
      part of R is O(12/g) -- STRICTLY below 1 for g above a
      small constant (~14-30 with the worst-case k, d
      corrections), with the low-t region below that constant
      being finite pinned data (the 207-point low-t territory).

Candidate theorem shape (to be attacked, in order):

  A. Exact bound: for all t = g + k/2 (k = 1..12) and all
     d in [0, 1/2], the algebraic part |R_alg| is AT MOST an
     explicit rational function B(g, k, d) built from the
     quadratic forms, and B <= C/k-free-constant / g uniformly;
     verify the d-monotonicity (worst d = 1/2?) exactly with
     sympy (exact algebra, per the standing sympy directive).
  B. Exponential part: |exp(s w)| = exp(w/2) with w real;
     bound w/2 = O(1/g^2) exactly (rational function in g, k, d
     -- finite algebra again).
  C. Hence |R_closed| <= B + C/g^2-type < 1 - 1/(K*g) for g >=
     g0 (g0 small, explicit) -- so dev = min_d |R - 1| >=
     1 - 1/(K g) - (grid-vs-infimum caveat, the H4 piece) for
     ALL g >= g0. Below g0: finite data, already pinned.
  D. Compose: margin >= |zeta| * (1 - 1/(K g)) / (noise upper
     bound from W2) -- and check the |zeta| factor's role in the
     actual S1 wire (the wire's exact dev-vs-noise ratio is the
     Lean statement; the raw statistic is the measurement
     proxy). The composition step is where the S1Lean wire
     meets the new bound.

If A-C hold with comfortable constants, the uniform theorem
reduces to comparing two explicit functions (1 - 1/(Kg) versus
the proven noise) -- the "disguised identity" becomes a
one-line comparison, and the hard spacing theory (2b) is no
longer needed. If A-C fail at some (k, d), the failure location
IS the structure to study next (and the falsifier).

### 3.3 Concrete first steps (next session, in order)

  1. sympy exact-algebra probe of A: maximize B(g,k,d) over
     k = 1..12, d in [0, 1/2], as a rational function of g;
     find the exact g0 where sup_k,d B < 1 (expect g0 ~ 20-40);
     output the exact rational constants (Fractions).
  2. Same for B (the w/2 bound) and the combined bound.
  3. Port the winning rational-function bounds to Lean
     (flat numerals, the day033 toolchain discipline) as
     named theorems in a new S1Uniform module; compose with
     the existing S1Lean wire where the forms match.
  4. Run W3 (the 3e10 falsification extension) in parallel as
     a background data run (independent of the theorem work).
  5. Only then: W2's oscillatory-integral estimate (closes the
     noise side), and W4's dev-smoothness (closes H4).

## 4. Outcome ledger (pre-registered, no outcome is a loss)

- W1 proven (via 2a or 2b) + W2 closed -> the squeeze is a
  theorem; compose into Lean; the argument is unconditional.
- W3 finds a certified crossing at T* -> honest ceiling report
  at T*; the route pivots; the verification program stands as
  the strongest to date.
- W1 open after the honest attack -> the route stands as
  verification + falsification program, published as such, with
  the certificate-continuous variant (W4) as the strongest
  conditional result available.

## 5. Standing disciplines that apply to the end game

- Honest split per atom (LEAN-PROVEN / CITED / PINNED / MEASURED);
  corrections as appended sections, never rewrites.
- Search online first for Lean/mathlib content; corroborate in
  the pinned 4.33.1 checkout before using any lemma name.
- Exact algebra (sympy/Fraction) BEFORE any numeric or Lean claim;
  every polynomial identity grid-verified before it is written
  into Lean.
- Certificates over measurements; pre-registered readings over
  post-hoc stories.
- Two logical cores left free on every background job
  (taskset -c 0-29 at most, the project standard).
- No prize claim made or implied, in any document, ever.

## 3.4 PROBE RESULT (night of 2026-09-19, exact Fraction
arithmetic, tmp/der_s3a.py) — the detector side is nearly closed

The first probe of section 3.3 ran and the picture is stronger
than the speculative read:

1. **The supremum of the algebraic core over d in [0, 1/2] is
   always attained at the endpoint d = 1/2** (fine-grid, all
   tested g from 15 to 1e9, all k = 1..12) — the grid floor
   d = 0.005 never wins.
2. **The worst k is always k = 12** (the outer straddle),
   monotonically in k on every row.
3. **R_alg(g, k=12, d=1/2) < 1 for all g >= 15 tested**
   (g = 15: 0.9636446, margin 0.0364; g = 20: 0.693574; decays
   like 12/g: 0.256 at 50, 0.1244 at 100, 1.21e-2 at 1000,
   1.21e-5 at 1e6).
4. Consequence: for every quantized straddle t = g + k/2 and all
   d, |R_alg| <= R_alg(g, 12, 1/2), so
      dev = min_d |R_closed - 1| >= 1 - R_alg(g,12,1/2) * exp(w/2)
      >= 1 - B(g)
   with B(g) an EXPLICIT rational function of g (~12/g with an
   O(1/g^2) correction).  Below g ~ 15: finite heights, the
   pinned low-t territory (the S1LowT wire covers its own
   region).  The "quantization obstruction" the owner's
   intuition named is exactly the mechanism: the half-unit legal
   step (t - g = k/2, k a nonzero integer) plus the
   sum-of-squares factorization (g^2 - t^2)^2 = (t-g)^2 (t+g)^2
   keeps the algebraic core off the danger value 1 by a
   quantifiable gap 1 - 12/g + O(1/g^2).

Revised picture of the wall (important): the measured margin
decay (about 1000 -> 1.08 across the band) is driven by the
NOISE side, not the detector side -- dev sits at 1 - O(1/g)
(negligible: 12e-6 at g = 1e9) while the certified reconstruction
ratio |K/zeta| = exp(Efull) grows 0.0009 -> 2.58 (the Efull
oscillation, H2).  So after step 3.3, the bottleneck of the
uniform theorem moves to W2 with much higher priority:
**a proven oscillation bound for the far-integral remainder**
(equivalently: an explicit upper bound on Efull, the oscillatory
E, UNIFORM in t).  The detector side becomes a Lean port of the
rational-function bound above (3.3 step 3) plus the two
rigorization lemmas (d-monotonicity of the algebraic core on
[0, 1/2]; k-monotonicity) — both are polynomial sign-analysis on
fixed-degree polynomials in (g, k, d), exact and bounded.

Order of attack (revised): (1) exact g0 crossing + the d and k
monotonicity lemmas (exact algebra, days); (2) Lean port of the
dev lower bound as a named theorem; (3) W2 Efull oscillation
bound (the remaining real mathematics); (4) W3 falsification
extension (background, in parallel); (5) composition through the
S1 wire.
