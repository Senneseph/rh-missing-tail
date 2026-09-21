# Ceiling report — day035 re-issuance

Status date: 2026-09-20 (day035 close-out:  W2-attack queue items
2-5 DONE;  S3a + M6 Lean ports GREEN;  the 3e10 extension handed off
to a cloud machine per owner direction).

Supersedes the 2026-09-19 PHASE1A-CEILING.md status only in the
sections marked (day035 update);  the 2026-09-19 content stands
where not updated.  Pre-registered, no RH claim made or implied
either way.

## 1. What changed since the 2026-09-19 report (day035 update)

The 2026-09-19 report ended with the queue:  pin the cancellation
(done), the W3 3e10 decision-maker, the one-sided W form as a named
Lean theorem, the S3a Lean port, and the composition through the S1
wire.  day035 closed items 2-5 as follows.

### 1.1  Data at 3e9 (the W3 decision-maker, at 3e9)

- N(3e9) = 9,064,192,826 EXACT (one md5-gated shard past the band
  end;  RVM(3e9) = 9,064,192,825.58,  |diff| = 0.42 <= 3).
- The S3e walk on band 3 (2e9, 2.9992e9] extended the walk pin:
  sup|DN| = 2.4772 on (1e7, 2.9992e9] (both census conventions),
  extending the 2.503 pin (which stood to 2e9).
- Gate-1 (the |S1 - (B - Dc + R)| = 0 cancellation identity) held at
  t = 2.5e9 + 1/2:  |S1 - L-form| = 9.5e-7,  the anatomy
  S1 = -5.998e9 with R = -5.998e9 (the big-term cancellation) and
  B = -0.1464,  Dc = -0.8984 — the O(1) gap mechanism is the same
  at N = 9e9 as at 2.9e9.
- The full 3e10 extension remained disk-blocked on this machine
  (~765GB needed, 132GB free) and was handed off to a cloud machine
  (stream script + shard-conversion code + output-disk/core/
  shard-layout runbook;  resumable from the 3e9 shards).

Honest reading:  the no-divergence read PAST G_LAST = 1.006e9 is
now data-backed to 9.06e9 zeros (one more decade), and the 3e10
extension (another decade, to ~3e10 zeros) is queued, not
precluded.

### 1.2  The W2 one-sided form (Lean, M1-M5, GREEN)

The telescope identity of 2026-09-19 is now a Lean theorem with its
consequences:

- W2Telescope:  W = p(G2)DN(G2) - p(G1)DN(G1) - int DN p' dx
  (exact, as stated).
- W2Bound:  the e1/e2 term bounds;  the e4 assembly;  the one-sided
  form W >= -C with EXPLICIT C (e4_tailFloor:  S1Sum - RSum >=
  -(K (|p 0| + |p M|) + K sum |Dp|));  the I_DN-side bound
  (e4_idnBound).
- W2M5:  the pinned instantiation  K_pin = 2.503 (the measured
  sup|DN| on (1e7, 2e9]),  L_pin = Rho(2e9) = log(2e9/(2 pi))/(2 pi)
  (the explicit slope bound;  Rho increasing).  m5_floor and
  m5_idn are the named theorems with these constants.

This is the certificate input the 2026-09-19 report's point 3
("the certificate needs the LOWER bound W >= -C (C small)") asked
for — now a named Lean theorem on the band with the data as named
hypotheses.

### 1.3  The S3a detector certificate (Lean, GREEN)

The algebraic detector core Ralg(g, k, d) (the rational part of
R_closed on the quantized straddles t = g + k/2, d in [0, 1/2]):

- The exact crossing:  Ralg 14 12 (1/2) > 1 and Ralg 15 12 (1/2) < 1
  — g0 = 15;  below it the core can exceed 1 (finite pinned data
  territory, already handled by the low-t slice).
- d-corner:  d = 1/2 is uniform worst for g >= 15, 1 <= k <= 12
  (chord structure, no interval_cases in the d-core).
- k-monotonicity:  the outer straddle is uniform worst,
  Rcorner(g, k) <= Rcorner(g, k+1), 1 <= k < 12.
- Decay:  Rcorner(g, 12) <= 13/g for g >= 40 (exact quartic
  certificate at 40 + v;  the ~12.8/g asymptote sits below 13/g
  from 40 on).
- The composed statement:  s3a_dev — Ralg g k d <= 13/g on the
  quantized straddle grid (1 <= k <= 12, 0 <= d <= 1/2, g >= 40).

The exponential factor of R_closed (|exp(s w)| = exp(w/2),  w a real
O(1/g^2) combination) is carried by the already-proven C1b discrete
floor (1 - 25/g with the 23/1000 witness-scale margin);  S3a is the
pure algebraic side.

### 1.4  The composition through the S1 wire (Lean, GREEN)

M6.lean meets the two proven sides on the S1LowT wire:

- m6_feed:  1 - Ralg g k d >= 1 - 13/g on the grid (the algebraic
  dev feed, |zeta|-free).
- m6_feed_dom:  the feed dominates the wire's PROVEN floor family —
  floStripMin g d <= max (floWin g) 0 = 23/1000 <= 27/40 <=
  1 - 13/g for g >= 40:  the wire's dev >= f leg is carried by a
  PROVEN feed on the grid, strictly.
- w2noise / w2noise_bound / w2noise_tail:  the W2 noise side as a
  named functional with its two named theorems (the I_DN remainder
  and the S1 - R tail).
- m6_compose:  the wire's squeezed-margin form at (g, d) on the S3a
  grid with dev := f := 1 - 13/g, outputting the wire form + feed
  dominance + a STRICTLY POSITIVE dev-vs-noise margin
  1 - 13/g - (Bwire + Mr + Mf),  where the zero-side witness Q and
  the noise total are NAMED hypotheses (H6 pattern;  the W2-proven
  expressions are their fill where the data matches).

Bound-level statement of plan 3.2-D:  the "disguised identity" now
reduces, on the grid g >= 40, to comparing two explicit functions —
the feed 1 - 13/g (PROVEN, decreasing) against the proven noise
expression (w2noise / the tail floor) — with the |zeta| factor
carried by the named noise-side hypotheses (the raw statistic
remains the measurement proxy).

## 2. What is established (2026-09-19 split, updated)

LEAN-PROVEN (infinite content) — day035 additions marked (+):
- (as before) the S1LowT v1 + v2 wires (t < 1000);  S2/S3/S4 in all
  regimes;  P12 closure as pure logic;  the P8 floor family.
- (+) W2Telescope + W2Bound + W2M5:  the telescope identity, the
  one-sided W >= -C form with explicit C, the I_DN-side bound, with
  the pinned constants K_pin = 2.503, L_pin = Rho(2e9).
- (+) S3a:  the exact crossing g0 = 15, the d-corner and
  k-monotonicity lemmas, the decay Rcorner(g, 12) <= 13/g (g >= 40),
  and the composed s3a_dev on the straddle grid.
- (+) M6:  m6_feed, m6_feed_pos, m6_feed_dom, w2noise_bound,
  w2noise_tail, m6_compose.

PINNED (audited data) — day035 additions:
- (+) N(3e9) = 9,064,192,826 exact;  the 3e9 band zero file
  (3,142,622,346 zeros, span (2.0017e9, 2.9992e9), md5-audited);
  sup|DN| = 2.4772 to 3e9;  K_pin = 2.503 (the (1e7, 2e9] census;
  still a valid pin — the extension to 2.4772 refines it, does not
  contradict it).
- (as before) the low-t slice record, the band to G_LAST, the
  207-point grid-adequacy floor 7357/1000.

MEASURED (screen, with tracked error budgets) — as before, plus the
S3e band-3 anatomy (9.5e-7 at t = 2.5e9 + 1/2).

## 3. What is NOT established (the ceiling, restated)

1. The S1 uniform theorem (P1.2, uniform in t and d) remains the
   open research theorem.  day035 converts two of its ingredients
   from measurement to named theorems (the algebraic detector side
   on the grid g >= 40, and the W2 noise side on the band), and
   composes them on the wire — but the wire's zero-side /
   definition-side / squeeze roles (hs1 / hs3 / hs4 in S1LowT and
   the Q/hnoise hypotheses in M6) remain NAMED hypotheses whose
   fills are the pinned data and the W2-proven bounds, not a single
   uniform statement.
2. The 3e10 extension has not been run (disk-blocked here;  cloud
   handoff queued).  The no-divergence read past 9.06e9 zeros is
   still density-model until the cloud run lands.  Nothing in the
   Lean composition depends on it (all inputs exist at 3e9);  it
   extends the empirical drift law.
3. THE LOW-T SLIVER AND THE d = 1/2 EDGE ARE NOW CLOSED as named
   Lean items (day035,  post-queue):  formal/RhAttack/SliverEdge
   records the sliver pin family (firstZeroPin 14.134725...
   inside (14, 707/50),  on-line count 1,  floor family
   0 < 0.9975 < 1 —  SliverEdge.SliverRecord,  norm_num proven)
   and proves the edge vacuity (edgePairAtZeroOne +
   SliverEdge.edgeVoid from the CITED classical zero-free
   regions):  the strict d < 1/2 detector atoms cover everything
   the actual zero set can present.  The B-6A composition onto
   the actual set is now a single named theorem:  formal/
   RhAttack/ZetaZeroSet —  ZetaLike q (the cited + pinned
   actual-set bundle) and rhIfMarginZeta (P12.p1_2 engine with
   the exact leg map in the docstring).
4. Below g0 = 15 the algebraic core can exceed 1:  that is finite
   pinned data territory (the low-t slice handles it), stated, not
   a gap.
5. The claim level is unchanged and honest:  a bound-level
   composition of the squeezed margin on the quantized route, with
   every atom labeled LEAN-PROVEN / CITED / PINNED / MEASURED.
   NO RH claim is made or implied.

## 4. Where the route stands after day035

The 2026-09-19 "order of attack" list is fully closed:  items 1-5
DONE (item 2 at 3e9 with the 3e10 extension handed off as a cloud
job per owner direction).  The project state is:  a Lean-verified
certificate chain (telescope + one-sided noise + detector decay +
wire composition) on the quantized route, pinned to data at 3e9,
with the remaining open item being the uniform theorem itself
(research mathematics —  attack plan:  docs/W2-BEYOND-ATTACK-
PLAN.md) and the queued 3e10 empirical extension.  The front
page naming exactly what remains is ZetaZeroSet.rhIfMarginZeta
(the [S1] uniform walk bound —  W2-beyond —  and the measured
[S3/S4] fills are the two remaining legs).  The next owner
actions are the pre-print draft (this report and the queue
close-out are its inputs) and the cloud launch of the 3e10
stream.

## POST-DATA ADDENDUM (appended —  the report above is the
as-issued day035 record)

-  The 3e10 extension has LANDED (the T2.5 parallel
    orchestrator):  12,858 md5-gated shards,
    92,577,877,714 zeros in (2.9992e9, 3.0001e10];
    N(3.0e10) = 101,635,962,231 (RVM diff 0.09),  N(band end)
    = 101,639,672,418 (diff 0.78),  min gap 2.2888e-05,  seam
    0.319307,  G_LAST = 30001045999.981976.  The "queued,  not
    started" lines above are the as-issued state.
-  The no-divergence read past 9.06e9 zeros is no longer
    density-model:  sup|DN| = 2.615067 on (1e7, 3.0e10] (full
    census,  both conventions) —  under the pre-registered rule
    the band classifies as **OUTCOME A** (the walk keeps its
    shape);  outcome B (a break) is excluded on the band.
-  The [S1] data layer is COMPLETE and certified (A2-class):
    per-gap eps over the band,
    SUM_EPS_CERT = 31,047,116,350.923088 (the certified total
    variation —  the domain-verified engine;  why the absolute-
    sum mechanism is not the universal closer:
    docs/S1-A1-EXPLORATION.md E2).
-  The measured [S3/S4] fill decision:  grade (i) H1-full on the
    extended band (owner-selected);  the engine stands built and
    self-tested (CPU and iGPU variants),  profile-gated before
    the certified full run.
-  No RH claim in the addendum,  as in the report.
