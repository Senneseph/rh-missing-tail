# Phase-1a ceiling report

Status date: 2026-09-19 (FINAL — day034 H1-cert landed, C-1 read applied).
# full-grid run; queue item 7, part c)

Status of the universality question (prize-plan P1.1/P1.2) at
2026-09-19, the honest ledger of what the squeeze argument
establishes and what it does not, on [10³, 10⁹] and beyond.
Pre-registered, no prize claim made or implied either way.

## 1. What the argument is

Route A (the squeeze): at each zero height g and straddle height
t = g + k/2, the statistic

    margin_new(t, g) = |ζ(½+it)| · dev(t, g) / (p8_B(t, n4(t)) + residf(t))

with dev the 500-delta minimum of |R_closed − 1| and
residf = |ζ − K_full| the on-line kernel residual, is meant to
dominate 1: the detector (dev) is larger than the kernel error
(residf) plus the floor (p8_B) by a margin. Margin > 1 everywhere
on the data extent is the POINTWISE statement; P1.2 asks for it
UNIFORMLY in t (and in δ), which is the open research theorem.

## 2. What is established (honest split)

LEAN-PROVEN (infinite content):
- S1LowT v1 + v2 wires (the t < 1000 region, 207-point low-t
  grid-adequacy floor 707/50 = 14.14; the 813-zero slice floors).
- S2/S3/S4 in all their regimes (S4 strip d ≥ 1/200 F4-line and
  d ≥ r2' = 0.0047384091 sharp-line, day033; S4-own window branch
  for d < 1/200).
- P12 closure (RH ← S1 ∧ S2 ∧ S3 ∧ S4) as pure logic.
- The P8 floor family (A5 residual terminal).

MEASURED → being upgraded to CERTIFY at grid density (day034,
this item):
- [10³, 10⁶] S1: the low-t data territory (207-point minimum
  margin 7.35737123) + the [1e6-seam] composition — screen-grade,
  certified machinery around it.
- (10⁶, 10⁹] S1: the A-1 sweep (31 windows, 25 straddles each,
  minimum margin_new 1.08164534 at the 10⁹ window, artifact-
  corrected day029) is the screen; the day034 re-issuance attaches
  an explicit tracked error budget to every one of the
  2250 grid points (90 windows at 8% spacing × 25 straddles).

PINNED (audited data):
- the zero data (LMFDB (0, 10⁷] 21,136,125 exact; cache
  (10⁷, 3.1946e7] 52,290,633 with seam Nt = 73,426,758; band
  2,792,198,664 to G_LAST = 1006345999.847005; md5-audited).
- the 25.2.12 main-term constants, the floor constants, the
  day033 sharp-line constants (all recorded with their sources).
- the empirical Platt–Trudgian counting defect = 0 on the band
  (Sbar datum).

CITED (audited against the pinned toolchain, 2026-09-19, see
KNOWN_LIMITATIONS §3 demotion audit): the five universals; on
the band the load has shifted to the pinned data for the
counting items, the A2c bridge is the next formalization
candidate, the classical zero-free stays load-bearing.

## 3. What is NOT established (the ceiling, stated)

- **P1.2(ii) is open.** The uniform-in-t (and in-δ) dominance of
  the detector over the kernel error is not proven for all t; the
  data say the margin sits at 1.0816 (grid minimum, (10⁶, 10⁹])
  and 7.35 (low-t) with no crossing of 1 seen anywhere on
  [10³, 10⁹] at the grid densities of record. That is the
  falsification program at work: it has not falsified the route,
  and it has not proven the route.
- **Grid density (H4):** the cert margins hold AT the grid points
  (90 windows × 25 straddles above 10⁶; 207 points below).
  Between grid points, smoothness is the argument, not a
  certificate. No pointwise decision is claimed off-grid.
- **H3 (low-t finite data):** the low-t remainder is finite data
  by design (the zero-line product is pinned, not closed form);
  the d < 1/200 coverage is the d-independent window branch
  (its floor is the pinned near scale).
- **H1 (now being closed at grid density):** the (10⁶, 10⁹]
  screen is re-issued with the explicit budget; the remaining
  H1 content is the grid caveat above.
- **H2 (Efull oscillation):** the quadrature sections'
  oscillatory remainder is the model (O(1)–O(4), day029
  calibration, quad-resolution rescheck 40f554c); the cert
  budget covers the quad VALUES via the dps-30/60 × node ladder,
  not a theorem about the remainder's amplitude.

## 4. The day034 certificate (part a of this item) — FINAL

The re-issuance grid is the screen grid itself (honest coverage):
39 windows x 25 straddles = 975 points — P1.1 LOW4
(1e6, 2e6, 4e6, 6e6), 4 flagged connectors (1.0e7, 1.6e7, 2.4e7,
3.3e7 — the 6e6 to 3.9e7 bridge, labeled as connectors in all
readings) and the day029 A-1 31 windows verbatim
(3.9e7..1e9).  Build: two-phase (window-batched band pass +
per-point dps-30/60 quad pairs at 400 nodes per section, dps-30/60
zeta/lm/dev agreement, exact-integer nlt with a 1e-4 guard,
worst-case exponential propagation), budget model self-tested
against dps-60 exact per-zero arithmetic (20-50x containment,
all four channels), batched pipeline cross-checked BIT-EXACT
against the per-point reference implementation
(CROSSCHECK: PASS, |re/im difference| = 0 on the 1e9 window).

RESULT (scripts/rh/out_day034_h1cert_b.txt; log
tmp/day034b_chain.log; wall 101.5 min, 27 workers, chain gates
clean):

- all 975 points OK (no gate rejections);
- **worst margin_cert = 1.081637 at t = 1000000001.61565** (the
  1e9 window; computed 1.081644; point budget 9.16e-5);
- **margin_cert < 1: NONE;  margin_computed < 1: NONE**;
- one wide-budget FLAG: the 1.3e8 window (budget 1.76e-4, margin
  ~101 — a budget-width flag, not a violation);
- window-best margins decay monotonically 17200 (1.05e7) ->
  1.0816 (1e9) — the decay is the Efull/noise side (see
  END_GAME_PLAN 3.5), the detector side is 1 - O(1/g) (S3a);
- audit ladder (8 corners, first straddle per window): quad
  spreads resolution-stable (e.g. rem 6.6e-21 / ext 1.3e-8 at
  the 1e6 window).

READING APPLIED: **C-1** (pre-registered): margin_cert >= 1 at
ALL 975 grid points -> the H1 band [10^6, 10^9] is RE-ISSUED at
certificate grade in the machine-verified error-budget sense
(the H1 Fix's second variant): every grid point carries an
explicit tracked budget; the claim is true margin >=
margin_cert.  The between-grid caveat (H4) is explicitly
UNCHANDED by this: the certificate is at the grid, as the
screen was.

## 5. Where the route stands after this item

- No crossing of 1 found on [10³, 10⁹] at certified grid density;
  the argument stands as the strongest VERIFICATION of the
  squeeze to date (prize-plan P1.2(c) outcome, in force until
  P1.2 proves or disproves (ii)).
- The falsification program extends naturally: the cert
  machinery (day034) runs per-strap without modification at any
  t the data reaches — the P1.1 scan extension (beyond 10⁹, the
  3e10 chain is staged) is the next tripwire, not a new
  instrument.
- The demotion list (CITED → PROVEN/PINNED) is bounded and
  located: A2c bridge (small port), Zeta23-style RVM count
  (adoption project), classical zero-free (separate port).
- Phase 2 (unconditionalize + publish) remains gated on P1.2.

*Companion: `KNOWN_LIMITATIONS.md` (H1–H4 + the §3 audit),
`RH-PROOF-OUTLINE.md` (the path), `DISCOVERY_LOG.md` (day033–034).*

## CORRECTION ADDENDUM (grid counts, append-only)

Section 2's "2250 grid points (90 windows at 8% spacing x 25
straddles)" and section 4's "39 windows x 25 straddles = 975
points" / "all 975 points OK" are superseded by the executed
ledgers: the k = 0 straddle (singular in R_closed) is excluded in
both engines, so the executed grids are 24 straddles per window.
Verified from out_day034_h1cert_b.txt: 936 rows (935 ok + 1 budget-
width FLAG); global min margin_cert = 1.0816362118 at
t = 1000000001.61565 (section 4's "1.081637" matches to the
printed digit); margin_cert < 1: NONE; margin_computed < 1: NONE.
The C-1 reading and every margin figure stand; only the grid
counts are corrected (3e9: 39 x 24 = 936; 3e10: 29 x 24 = 696).
