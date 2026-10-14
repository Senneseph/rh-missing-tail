# PROVENANCE — `formal/` (machine-checked core)

**HOME AND SOURCE OF RECORD.** The Lean package **lives in this
repository** (`rh-missing-tail`), with `formal/` as the package root
(flattened from `formal/rh-lean/` on 2026-09-12 — no sub-directory).
`kainos-logos/scripts/rh-lean` is a **symlink into this directory**:

    kainos-logos/scripts/rh-lean -> ../../rh-missing-tail/formal

All daily work happens through that path; every file lives and is
committed here. (Older revisions of this document described a
one-way "copy-only mirror" scheme — superseded and wrong; the copy
scheme is what lost visibility of the B-3 work.)

## State of the tree (2026-09-13)

- **Toolchain:** Lean **4.33.1 (stable) + Mathlib 4.33.1 pinned** (no
  rc/nightly); the pin is `formal/lean-toolchain`.
- `formal/RhAttack.lean` — root module; imports every piece below, with
  the day-attributed history.
- `formal/RhAttack/` — the pieces, all green and imported:
  `EulerAction.lean` (the E7a Euler action identity over any
  commutative ring), `E7a.lean` (the five certified oracle instances),
  `B0.lean` (counting equivalence, RH iff D ≡ 0), `B3.lean` + pieces
  `B3Core/B3Abel/B3Sbar` (the B-3 bridge: finite exact Abel
  decomposition, RVM comparator, explicit finite bound, ζ-free
  residual decomposition), `B4.lean` (on-line pair identity, four
  parts), `B5.lean` (B-5 core exact ratio theorem), `P4Em.lean` (P4
  1st-order Euler–Maclaurin, verbatim port of a published proof),
  `P4Tail.lean` (P4 per-period 2nd-order identity), `P4Em2.lean`
  (P4 global finite 2nd-order law), `P4Limit.lean` (P4 strictification
  L1–L5: the M→∞ passage with explicit remainder, the P4 identity and
  the ‖W_n‖ bound at Re s = ½, the T4 corollary), `P8Floor.lean`
  (P8 residual-floor line A0–A4: the same-object definition-side
  floor, the bridge-wired residual, the B5 closed-form detector atoms,
  the zero-decision inequality), `Closure.lean` (P9 conditional
  closure: C0/C5/C5b/C1-far/C1a/C6/C7 + the audit pins, machine-checked).
- `formal/Main.lean` — the `rhattack` gate executable (E7a 5/5, B-4
  16/16, B-5 12/12, B-3 A/B checks at float64 vs the committed record).
- `formal/out_rhattack_day01{1,2}.txt` — the committed records of the
  last green gate runs.
- **Not in this repository** (by the repo-split rule — this repo holds
  only the proof output): the Lean syntax probes / scratch recipes
  (`Probe*.lean`, `Bt*.lean`) — day-to-day double-checks, not proofs;
  they live in the working tree
  `kainos-logos/scripts/rh-lean-probes/` (pass/fail state at creation
  recorded in the day journals). All internal progress tracking
  (day journals, specs, prompts) likewise lives in the working tree
  `kainos-logos/plan/40-prize-islands/rh-attack/`.
- Reference material lives in the working repo
  `kainos-logos/references/` (repo-split rule — the proof repo holds no
  toolchain copies): the pinned API quickref
  `LEAN4-4331-QUICKREF.md` (verified names, signatures, file:line
  sources against the pinned toolchain) and the `official-lean4-docs/`
  archive. The reproducible toolchain reference is the `lean-toolchain`
  pin + the gitignored `.lake/packages` cache; pinned-source greps
  resolve through it.

## Cited classical inputs (A1Growth, E19 — verified online before use)

`formal/RhAttack/A1Growth.lean` (the growth-form A1 wire) consumes
exactly four classical facts, carried as explicit hypotheses per the
project CITED convention. Their references, fetched and read online
during the E19 pass (full text verified, not recalled from memory):

- **[A1G-1] RVM bridge with O(1/t) residual:**
  `N(t) = (t/2pi) log(t/(2pi e)) + 7/8 + S(t) + O(1/t)` for t >= 2.
  Chandrasekharan, Chandramouli, Murty (later: CCM),
  https://arxiv.org/abs/1309.1526, eq. (1) (same form in the
  journal version https://arxiv.org/abs/1503.00955); the classical
  statement is Titchmarsh, *The Theory of the Riemann Zeta
  Function*, Thm 9.7. Consumed by the `1 / x j` term in the wire's
  pointwise hypothesis (the bridge residual is < 1 for x >= 2:
  `A1G.log_div_x_le_one`, LEAN-PROVEN).

- **[A1G-2] Unconditional growth of S:** `S(t) = O(log t)` (von
  Mangoldt–Backlund; Titchmarsh Thm 9.4; surveyed with references in
  Dobner, https://arxiv.org/abs/2101.01747). Consumed by
  `A1G.a1_growth_wire_log` as the shape `CS * log` of G.

- **[A1G-3] RH sharp bound for S (the CCM theorem):**
  `|S(t)| <= (1/4 + o(1)) log t / log log t` under RH, with the
  explicit error form `O( log t logloglog t / (log log t)^2 )` used
  as the C1 correction term. CCM, Thm 2 / Thm 1 respectively: the
  proof (Beurling–Selberg majorants) was read in full from
  https://arxiv.org/abs/1309.1526 (Lemma 4 gives the identity
  `S(t) = (1/pi) sum_gamma f(t - gamma) + O(1)` with
  `f(x) = arctan(1/x) - x/(1+x^2)`, the global bookkeeping that E19
  quotes). Consumed by `A1G.a1_growth_wire_ccm`.

- **[A1G-4] Monotonicity and non-negativity of the CCM growth shape**
  `G(u) = (1/4) log u / log log u + C1 log u logloglog u / (log log u)^2`
  on `u >= 16`: positive (log u > 1 for u >= 16) and non-decreasing
  (derivative of the main term `(log log u - 1)/(u (log log u)^2) > 0`
  for u > e^e; the correction term grows likewise on [16, oo)). One-
  line classical calculus; carried in Lean as the explicit premises
  `hG0` / `hGrow` of `A1G.a1_growth_wire_ccm` (the composition around
  them is LEAN-PROVEN).

- **[A1G-5] Sharpest known UNCONDITIONAL explicit all-t bound on S**
  (the stone-B input; read in full online during the valiant-effort
  pass): |S(T)| <= 0.111 log T + 0.275 loglog T + 2.450 for all
  T >= e. T. S. Trudgian, "An improved upper bound for the argument
  of the Riemann zeta-function on the critical line II",
  https://arxiv.org/abs/1208.5846, Theorem 1 (companion paper I:
  Math. Comp. 81:1053-1061 (2012), arXiv:1208.5846 line; the bound
  holds for all T >= e, proven analytically for T >= 6.8e6 and by
  verified computation below; NO RH assumed). Consumed by
  `A1G.a1_explicit_wire` as the hSbound input, through
  `A1G.G_explicit` (LEAN-PROVEN non-decreasing on [4, oo)); the single
  auxiliary classical fact is e < 4 (carried as the explicit premise
  hE: exp 1 = 2.71828 ..., one-line analysis). At the 3e10 frontier
  the Lean pins give G_explicit < 7 (cited numerics log 3e10 < 25,
  loglog < 4; the 6.325 < 7 arithmetic is LEAN-PROVEN), hence the
  data-free wire carries K < 8 and |S1 - R| < 17 on the far side
  (`A1G.pin_explicit_wire_3e10`) — against the measured wire
  2.615067 << 17/8 << 5.55 and the certified majorant
  31047116350.92 << 17/8 << 6.7e10.

- **[A1G-6] Zeta23 community port** (borrow source for the
  argument-principle line, cited per the iron rule). The repo
  MOVED: `anthropics/zeta-23-lean` now resolves to
  `anthropics/formal-math` (lean package under `zeta23/`).
  Inventoried at commit `e1a4e6508154` (2026-10-13): the RvM
  line is `zeta23/Zeta23/RvM/` (Backlund.lean = explicit
  Backlund O(log T) horizontal bound incl. the raw ~310 log T
  integral constant; CountByIntegral.lean = the completed-zeta
  window zero-count identity); the argument-principle base is
  `zeta23/Zeta23/FromPNTPlus/` (Rectangle.lean,
  ResidueCalcOnRectangles.lean, Tactic/AdditiveCombination.lean)
  plus `zeta23/Zeta23/Analytic/RectangleLogDeriv.lean` (weighted
  argument principle, finset residue theorem, finite zeros in
  rectangle). **ap1, ap2 AND ap3 are now PORTED IN-HOUSE**
  (namespaced `Ap1`/`Ap2`/`Ap3`, whole-mathlib import,
  attribution headers preserved, Apache-2.0):
  * Ap1: tactic + rectangle calculus + residue calculus +
    weighted argument principle (2 self-tests);
  * Ap2: the zero-count layer (Defs/Counting/Statement/Seam/
    Reflect) + the RVM window identity
    `rectangleIntegral'_logDeriv_completedZeta_eq_Ncount`
    (contour of completed-zeta log-derivative = window zero
    count); `zetaSeam` discharged from Mathlib with no paper
    inputs (RH self-test included);
  * Ap3: the bound layer (StrongPNTPrefix `ZerosBound` Jensen
    disk count, the 3 needed ZetaBounds lemmas + ~450-line
    closure, ZetaGrowth explicit bounds, Halving reflection
    halving, BacklundDefs reZeroSet, LocalCount Jensen/Landau,
    ReZeroCount `reZeroSet_card_le`) and **backlund_horizontal**
    (the explicit O(log T) horizontal argument-variation
    bound — source of the 17/2 base-cost datum) plus
    **vertical_two** (the sigma = 2 side is bounded by pi).
  Build green at the pinned mathlib v4.33.1, zero sorry.
  and **ap4, the full main-term assembly + the GammaFacts
  discharge**: `Ap3Hypotheses` (GammaFacts/PaperInputs as
  explicit structures), `Ap3RvMDefs` (GoodHeight, halfContour,
  the RiemannVonMangoldt packaging), `Ap3XiLogDeriv`
  (logDeriv-identity for the completed zeta + conj symmetry),
  `Ap3ZetaConj`, `Ap3NcountWindow`, `Ap3Fold` (the
  Lambda(1-s') = conj Lambda(s) fold: N(T1,T2) = (1/pi)Im
  halfContour of Lambda'/Lambda), `Ap3GammaSide` (the mu
  integral identity), `Ap3MainTerm` (rvM_main_param +
  corollaries), `Ap3RvMStatement`, and the complete
  GammaFacts discharge (`Ap3GammaSeries` digamma series,
  `Ap3GammaStirling`, `Ap3GammaMu`, `Ap3GammaIntMu`,
  `Ap3GammaStirlingVert` vertical Stirling estimate,
  `Ap3GammaComplete` = `gammaFacts`) — all proved from
  Mathlib alone. **Top-level result, hypothesis-free in
  this repo: `riemannVonMangoldt gammaFacts`** (N(T,2T) =
  (T/2pi)ell1(T) + O(log T) and the packaged
  RiemannVonMangoldt property; self-tests in
  `Ap3RvMStatement.lean`). Total: 34 ported files (~7.5k
  lines), zero sorry, build green at the pinned mathlib
  v4.33.1. The D4 classical S-identity wire (ap1-ap4) is
  COMPLETE: proven in-house, not cited.

  **ap5 (in-house, no borrow):** `RhAttack/S1Point.lean`
  (namespace `S1B`, ~450 lines) -- the POINT-scale
  Riemann-von Mangoldt with O(log T) error, a NEW in-repo
  theorem (no external source; classical reference:
  Backlund 1918 / Titchmarsh Thm 9.4 point form): for good
  heights T >= T0, under the single named input
  `S1B.C9NoZerosLow` (no nontrivial zero on 0 < Im <= 4;
  first zero 14.134725... in the data layer) --
      |N(T) - S1B.f_pt T|  <=  C * log T,
  where f_pt T = T/(2*pi)*(log(T/2*pi) - 1) and N(T) =
  S1B.Ncount 4 T counts all nontrivial zeros 0 < Im <= T.
  Components: `int_log_point` (FTC anchor),
  `int_mu_point_form` (integral of mu over [4,T] =
  f_pt T - f_pt 4 + O(1), direct integration of the
  Stirling field), `hc_zeta_im_bound` (the zeta half-
  contour [4,T] is O(log T): horizontals by
  `backlund_horizontal_at` at the explicit Jensen constant
  CJ ~ 48.3, sigma=2 by `vertical_two`), `f_pt_4_abs_le`,
  `point_rvM`, and **the rebase: `S1B.rebase_a1g6_dn_form`**
  proves the wire's hSbound premise form C*log t + 1/t in
  the classical smooth-count instantiation (Nas = f_pt) --
  the content previously CITED under A1G-6. Zero sorry,
  build green, all four rhattack gates PASS.

- **[A1G-7] The frontier of the UNCONDITIONAL S-bound, including at
  zeros** (valiant-effort verification, all cited online during the
  pass):
  (a) The adjacent Platt-Trudgian 2015 form, as cited in
  arXiv:2010.13307: |S(t)| <= 0.11 log t + 0.29 loglog t + 2.29 for
  t >= e, marginally sharper at the 3e10 frontier than the Trudgian
  II form used by K_mil (~5.87 vs ~6.00).
  (b) "At present, there is NO unconditional improvement on
  S(t) = O(log t)" (arXiv:2010.13307, section 1, 2021). Read with
  (c) "bounds for S(gamma+H) - S(gamma-H): no satisfactory results
  seem to be known for this problem" (arXiv:1706.08268, 2017), the
  statement is: even RESTRICTED TO ZEROS, no bound better than the
  all-t O(log t) scale is published. The growth-form wire of
  A1Growth therefore sits exactly at the known frontier; the data-
  free clause cannot be sharpened at the zeros from the current
  literature without a new theorem.
  (d) Under RH, Carneiro-Chandee-Milinovich (arXiv:1503.00955) give
  a new simple proof of |S(t)| <= (1/4 + o(1)) log t / loglog t (the
  CCM/Goldston-Gonek form, independent proof line), with the
  o(1) = O(logloglog t / loglog t); no zeros-specific refinement is
  stated there either. The Ole Miss "new_S(t)" paper (B. Milino) is
  the same CCC result line; it is NOT the source of the 0.111/
  0.275/2.450 constants (those are Trudgian II, [A1G-5]; the W2M6
  "Milino form" label was corrected accordingly, identifiers kept).

Supporting literature pinned by the same pass (survey-level, cited in
E19 rather than consumed by the Lean code): the omegas
`S(t) = Omega((log t/loglog t)^{1/3})` (Tsang) and under RH
`Omega( sqrt( log t logloglog t / log log t ) )` (Bondarenko–Seip)
as tabulated in Dobner 2101.01747; the Selberg CLT / Radziwill
Gaussian-window results (typical scale sqrt(loglog t)); and the 2024–2026
follow-ups carrying the same normalization (2407.14867, 2505.23573,
2511.18275, 2507.04150, 2510.14309).

## Build

    cd formal/                  # or through the working-tree symlink
    export PATH="$HOME/.elan/bin:$PATH"
    lake build
    lake exe rhattack           # gates: E7a 5/5, B-4 16/16, B-5 12/12,
                                # B-3 A/B (record above)
