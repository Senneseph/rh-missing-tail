# LEAN-GUIDE — the rh-missing-tail formal base, in one file

Find out what is proven, where it lives, how the pieces connect, and the
exact conventions every side (Lean, engine, quad scripts) uses.  This is
the navigation + convention layer; per-file headers stay authoritative for
statement lists, `#doc`/hover for full statements.

Companions: `RH-LEAN-PROVENANCE.md` (port lineage + licenses),
`W2-LEAN-PLAN.md` (W2 build order), `docs/RH-PROOF-OUTLINE.md` (the
statement map P1-P9 + status), `docs/VALIANT-EFFORT-FORENSICS.md` (the
numeric record this guide wires against).


## 0. Build and gates

    cd formal
    lake build          (toolchain pinned: lean 4.33.1, mathlib v4.33.1)

  Gate A:  `lake build` green, 0 errors.  (Style lints may fire; they are
           not gates.)
  Gate B:  no `sorry` anywhere.  Base is sorry-free (every "sorry" hit in
           grep is inside a doc comment saying "no sorry").
  Gate C:  numeric cross-checks compiled into the base:
           B4.lean  16/16 float64 cross-check of the pair kernel
           E7a.lean 5/5 cross-check vs the dps-20 Python record
           (oracle: scripts/rh/day006_e7a_action_identity.py)
           MainBridge.lean 3/3 Float re-evaluations (E7a-style;
           the O(1e-6) residual C/2 + Ex_total ~= -1.2e-7 at f64)
           E1Clause.lean 3/3 Float re-evaluations (E7a-style;
           s8 M_true min/max/B-margin at f64, dps-50 oracle
           tmp/s8_m_true_sample.jsonl)
  Gate D:  engine invariants in scripts/rh/day037_h1_3e10.py (do not
           modify): Kfull self-test (bad_asm guard), B-field bounds,
           the 400-node adjacent-section quad pair (day049e fix:
           rem (G,1e18] and ext (1e18,1e30] are ADJACENT; a nested ext
           double-counts (G,1e18]).

Toolchain pins: `formal/lean-toolchain` (leanprover/lean4:v4.33.1),
mathlib rev v4.33.1 in `formal/lakefile.toml`.  Do not float these.


## 1. The map (module lines)

73 modules in `formal/RhAttack/`, ~38.8k lines.  Read top-down as lines;
imports go downward only.

### Line Ap (ported, Apache-2.0) — argument principle, RVM stack
Source: anthropics/formal-math (zeta-23-lean), commit e1a4e6508154.
Every Ap file carries the provenance header.  Naming caution: the ap4
content lives in files named Ap3Gamma*, Ap3Fold, Ap3MainTerm, Ap3RvM*,
Ap3XiLogDeriv, Ap3Hypotheses.

- ap1  argument principle: Ap1ArgumentPrinciple, Ap1Rectangle,
  Ap1Residue, Ap1Tactic (the additive_combination tactic).
- ap2  RVM window identity: Ap2Defs (64 defs), Ap2Statement,
  Ap2Counting, Ap2CountByIntegral, Ap2Reflect, Ap2Seam.
- ap3  bound layer: Ap3Backlund (+Defs), Ap3Growth, Ap3Halving,
  Ap3LocalCount, Ap3NcountWindow, Ap3ReZeroCount, Ap3StrongPNTPrefix,
  Ap3ZetaBounds, Ap3Prelude.
- ap4  main-term assembly + GammaFacts discharge: the Ap3Gamma*
  family, Ap3Fold, Ap3MainTerm, Ap3RvMDefs/Statement, Ap3XiLogDeriv,
  Ap3Hypotheses.

### Line S1Point (ap5) — NEW in-repo theorem
Point-scale Riemann-von Mangoldt with O(log T) error, T >= T0 at good
height T; built ONLY from ap1-ap4 + pinned mathlib.  The formal twin of
the RVM density the quad scripts integrate against.

### Line B (P1 core)
- B0: the counting lemma (RH iff D = 0) on an ABSTRACT zero set;
  N_total/N_on/D.
- B3 / B3Core / B3Abel / B3Sbar: the B-3 bridge; B3Sbar ends in
  `b3BoundExplicit` (B-2's M(G,t) at finite B).
- B4: the on-line per-pair closed form (P2); the certified zero list
  drives the kernel through it, no high-precision loop.  Gate C 16/16.
- B5: the deviation ratio R(s, delta) (P3): what one off-line pair does
  to the kernel, closed form.

### Line P4 — the rigorous missing-tail law
- P4Em: 1st-order Euler-Maclaurin (verbatim port, published proof).
- P4Tail: atom-2, the 2nd-order finite EM identity.
- P4Em2: atom-2b, the GLOBAL finite 2nd-order EM law (`em2_finite`).
- P4Limit: atoms L1-L5, the M-to-infinity passage, OP1/OP2,
  `p4_identity` (Re s > 1) and `p4_T4_bound` (critical line; the
  W_n-equality cited, DLMF 25.2.8 / Apostol 12.21).  Largest file
  (6957 lines, 131 theorems).

### Line W2 — the Efull defect band
- W2Kernel (M1): kernel algebra, EXACT, no data.  Defines Ker (the pair
  kernel), Nas (RVM asymptote), Rho (RVM density), Sm.  See the
  convention table below.
- W2Telescope (M2): finite-sum telescopes on an explicit finite zero
  partition; pure algebra.
- W2Integral (M3): per-gap integral side (non-straddle gaps); records
  the pinned-mathlib fact that Real.log IS the log|.| extension.
- W2Bound (M4): `e1`/`e1_sharp` (|DcSum| <= K * TV, sharp endpoint).
- W2M5 (M5): pinned constants G1 = 1e7, G2 = 2e9, K = 2.503 (sup|DN|
  on (1e7, 2e9], S3d census).
- W2M6 (M6): re-pin at G2 = 3e10; refutes the data-free branch of the
  S1 wire AT THE PIN (twin of S1-A1 exploration E14-E16).
- W2Beyond0..3: the R2 route step atoms (per-step drift, reduction to
  per-gap statistics, the kernel half of the universal clause, the A1
  assembly).  W2Beyond2 names the engine kernel p(g;t) verbatim.

### Line S3a / S4 — detector and squeeze
- S3a: the detector algebraic core Ralg(g,k,d); exact monotonicity and
  crossing on the quantized straddle grid (t = g + k/2, 0 <= d <= 1/2).
- S4Window (S4a): window-regime wire squeeze, first green; `hs4` is the
  uniform squeeze statement (28 theorems).
- S4Own (S4b): own-strip atom; the exact own-height kernel
  `mown(t, d) = d^2 (d^2 + 4 t^2)/(A B) * exp(c)` (25n, dps-40
  grid-exact twin).
- S4Gap (S4c): the own-regime squeeze FAILURE at the pin — GAP named
  formally (the S1/E1 residual).
- S4Sharp (S4d): wire-sharpness certificate; GAP-O quantified.
- S4Growth (25ab): the growing-wire family closes GAP-W for all
  t > T0 (50 theorems).
- S4Strip (25af): the t^4-strip composition residual closed in Lean
  (`s4_strip_close`; 52 lemmas).
- S4Asm (25q): the residue statement, ONE import (assembly).

### Line P8 / C1b / P12 / Closure — floor, closure
- P8Floor: Route A residual floor, the "<" side of the outline-8
  contradiction; from the definition side alone (no zero count, no
  height bound).
- C1b: the discrete-straddle detector floor (25i/25k; continuous-window
  floor refuted by pole+ridge).
- P12Uniform: the uniform squeeze theorem (P1.2); under four structural
  hypotheses composes to C5b and hence RH (the Lean-provable part).
- Closure (P9): composes the five pieces into the conditional
  contradiction; `Q(t)` = |W_n(t) - [K_on(t) - (P_n - I)]|.

### Line M6 / S1LowT / SliverEdge — composition, low-t wire
- M6: composition through the S1 wire (dev-vs-noise margin statement).
- S1LowT: the low-t wire (12 theorems); consumes the named records.
- SliverEdge: the sliver pin (0 < t0 < 14.14; C1b starts at 707/50 =
  14.14, just above the first zero 14.134725...) and the d = 1/2
  edge atom.

### Line MainBridge -- the main-term bridge (exact, no zero-free)
- MainBridge: mainFac (the xi-convention main factor
  2 / (s (s-1) GammaR s)), xiz (the xi factor (s/2)(s-1) xi(s)),
  engine_lm (the engine Stirling main term as a complex function),
  C_bridge = log(2 sqrt pi) - 1 - gamma/2, Ex_total, EPS.  The
  core identity exp(engine_lm s) = mainFac s exp(s C_bridge) / 2
  is BRANCH-FREE for 0 < s.re, s != 0, s != 1.  Theorems:
  mainFac_reduced (pi^{s/2} / ((s-1) Gamma(s/2+1)) form),
  zeta_eq_main_xi, contAt_tendsto_hnpunct + xiz_zero_tendsto
  (xi(0) = 1/2 along the punctured neighborhood), log_abs_decomp
  (Re-level log|mainFac| into elementary terms), main_term_bridge
  (headline: (engine_lm (1/2 + it)).re = log|mainFac (1/2 + it)|
  + C_bridge/2 - log 2,  exact), bridge_eps_form (the EPS face).
  Line-level theorems take only t > 0 -- NO zero-free hypothesis
  anywhere.  Part C: f64 data gates (C_float, EPS_float), E7a
  style.

### Line E1Clause -- the single open clause, named (E1: S = O(1))
- E1Clause: the missing-tail face of the program, named and pinned.
  Definitions: G_LAST / U_TOP (the s7/s8 far window
  (3.000104599998e10, 1e30]), farZeros (upper-half-plane true zeros
  in the window, from B0.finite), and the face itself in its two
  registered conventions:  pairLog (the s7/s8 DATA kernel, the
  exact real pair factor re[log(1-s/r1)+log(1-s/r2)])  and  Ker
  (= pairLog + convTerm,  the engine Efull convention;  ker_split
  + m_true_true_side_shift formalize the t-independent split).
  M_wp = the face on BOTH sides with pairLog  (s8's M(t) IS M_wp,
  the zeta-residual  EPS + log|zeta| - lm - la - re - I_far);  
  M_true = the Ker-face alias  (M_wp + t-independent shift).
  straddleRow:  t = g + k/2 at a true zero height g, k != 0, and t
  itself not a zero height  (self-pair exclusion:  at a true zero
  height the true pair factor vanishes and the face is singular —
  the clause lives on the detuned rows).  THE CLAUSE  (E1Clause q
  B):  |M_wp q t| <= B  at every straddle row in the t-domain
  (G_LAST, U_TOP)  --  the one remaining open statement of the
  program  (NOT proven here or anywhere in the base;  this module
  NAMES it).  Lean-proven glue:  farZeros membership + pair-
  uniqueness (each conjugate pair counted exactly once, from
  ZeroSet conj + nonReal only), zeta_abs_line (|zeta| = |mainFac|
  |xiz| on the critical line, MainBridge + norm_mul, no nonzero
  exception), if_E1_and_walk (the residual program:  E1Clause + the
  four P12 legs -> RH on any actual-set zero set, pure composition
  through ZetaZeroSet.rhIfMarginZeta).  DATA FACE (s8, 505 rows,
  dps-50 oracle, all |k| <= 12):  M_wp in [0.009100218,
  1.555465754] at every measured straddle row BELOW G
  (3.23e9 <= t <= 2.79e10);  data-supported bound  B = 2  (margin
  0.4445342).  The clause's t-domain (G, U_TOP) is the above-G
  regime — the face the pending s9 run targets
  (scripts/rh/s9_dk_above_g.py,  single 1.016e11-zero streaming
  pass,  straddle t = G + k/2  k = 1..10  +  log-spread 1.05..2.2;
  G itself is a true zero — the last on-disk one — so those rows
  are provable straddles).  Part C:  3/3 Float #eval gates.

### Front page + records
- ZetaZeroSet (B-6A): RH on the ACTUAL zero set; records leg-by-leg
  what the actual set owes the structural chain.
- A1Growth: the A1 wire at the provable growth form (E19).
- E2Barrier: NEGATIVE-result record (the R2 absolute-sum barrier).
- EulerAction + E7a: the exact finite-sum Euler-action identity +
  five certified oracle instances (Gate C 5/5).
- Probes (ProbeTmp, ProbeM5): scratch; NOT canonical.


## 2. Kernel and convention table

THE table — everything below is code-verified (day037 engine read,
B4/W2Kernel/W2Beyond2 headers, s6/s7 numeric runs).  Variable names:
s = 1/2 + i t; a zero pair is 1/2 +/- i g (g > 0); G = 3.0001045999e10
(last on-disk zero).

- W_pair(g, t)  =  log|g^2 - t^2| - log(g^2 + 1/4)
                 =  log|g-t| + log(g+t) - log(g^2 + 1/4)
   (cancellation-safe form in the 2nd line;  g^2 - t^2 overflows f64
   near g ~ t ~ 3e10).  Lean: RhAttack.W2Kernel.Ker.  This is
   Re[log(1-s/r1) + log(1-s/r2)], r1 = 1/2+ig, r2 = 1/2-ig — EXACT
   (|1-s/r1| = |g-t|/sqrt(g^2+1/4), by (rho-s) = i(g-t)).

- ENGINE kernel (la/re AND the far quad)  =  W_pair + 1/(2 (g^2+1/4)).
   Code: day037 _prod_budget_day034: la_t = 0.5/(g^2+0.25)
   + log|1 - (t^2+0.25)/(g^2+0.25)|;  quad integrand _kint:
   Re[log(1-s/r1) + log(1-s/r2) + s/r1 + s/r2] * density — note
   Re[s/r1 + s/r2] = 0.5/(g^2+0.25) = 1/(2(g^2+1/4)).  Lean:
   RhAttack.W2Beyond2 names this p(g;t) verbatim.

- W_single / f_re(g, t)  =  Re[log(1-s/r1) + s/r1]
                          =  log|g-t| - 0.5 log(g^2+1/4)
                            + (0.25 + t g)/(g^2 + 1/4).
   One side of a pair.  A pair contributes f_re(r1) + f_re(r2)
   = W_pair + 1/(g^2+1/4) to the genus-1 product.  s5's quad code used
   this; the verified value equals the engine kernel quad to ~1e-7
   (the 1/(g^2+1/4) part integrates to ~1e-10 over (G, 1e30]).

- Ex  =  sum of 1/(2(g^2+1/4)) over pairs.  t-INDEPENDENT.  Modeled
   total (grid exact + D-band quad): 0.011547732887 (s6 run).  The
   engine's la and re each carry their piece of Ex inside.

- Kabs composition (day037 ev_point, CODE-READ):
   Kfull = exp(lm + la + i ar + re + i im) * exp(qrem) * exp(qext)
   la, ar: GN grid (0, 1e7], 21,136,125 pts, kernel = ENGINE kernel.
   re, im: ACTUAL zeros of (1e7, G] (streamed; includes (1e7, 3.19e7]
   and the micro-gaps (1e9, 1.002e9], (2e9, 2.002e9] — those slices
   come from the day023 shard stream, not from quad).
   qrem/qext: 400-node log-quad, dps-30, ADJACENT sections
   (G, 1e18] and (1e18, 1e30].
   The B-fields (Bexp, Bph, Btail_re, Bprod_re, Bqrem, Bqext) are
   error bounds — NOT exponent addends.  So:
      log|Kabs| = lm_re + la + re + Re(qrem + qext)    (exact, f64)
   and Q_engine := log|Kabs| - lm_re - la - re is readable
   straight from the ledger.

- main_exact(s)  =  2 pi^{s/2} / (s (s-1) Gamma(s/2)),
   from xi(s) = (1/2) s (s-1) pi^{-s/2} Gamma(s/2) zeta(s):
   zeta(s) = xi(s) / main_exact(s),  xi(0) = 1/2 (dps-30 verified:
   0.499999999999988).  CAUTION: the factor (1/2) s (s-1) pi^{-s/2}
   / Gamma(s/2) is 1/(2 main_exact), NOT the zeta main factor — this
   inversion cost one failed s5/s6 attempt.

- VERIFIED main-term identity (s7, both ledger heights, to 1e-6):
      lm_re(t) = log|main_exact(t)| + log(1/2) - Ex_total  +  O(1e-6)
   i.e. the engine Stirling main term (logmain25212, DLMF 25.2.12
   form, the S1Point lean side) equals the exact xi-convention main
   factor minus the Ex bookkeeping.  LEAN FACE: MainBridge proves
   the identity EXACTLY (no O-term):  (engine_lm s).re =
   log|mainFac s| + C_bridge/2 - log 2  for  0 < s.re  (and the
   line form t > 0, with no zero-free hypothesis).  The measured
   O(1e-6) is exactly EPS = C_bridge/2 + Ex_total; the Float gate
   re-evaluates it to -1.2e-7 at f64.

- VERIFIED quad identity (s7):  Q_engine(t) = I_far,RVM(t) to 2.4e-7
   absolute at t0 (engine 400-node dps-30 vs u-quad dps-40); the
   engine quad is EXACT.

- THE c(t) theorem (s7; c = Kabs/zeta, measured, ratio -|c| phase pi):
      log c(t)  =  EPS + Q_engine(t) - I_far,RVM(t) - M_true(t)
      EPS      ~  +/- 2e-6   (t-independent verified constant)
      I_far,RVM(t) = int_G^{1e30} W_pair(g,t) (ln g / 2pi)/2pi dg
      (RH above G: no zeros on disk past G; RVM model in force)
      M_true(t) = log(product over TRUE zeros (G, 1e30]) - I_far,RVM(t)
          = the RVM model error = the missing-tail remainder,
            and log M... equivalently:
      M_true(t) = EPS - log c(t)          (measurable at every row)
   Measured: log c = -0.009110 at t = 3.23217e9 and -1.555411 at
   t = 2.78843e10, so the true tail product deviates from the RVM
   density model by a factor e^{0.009} and e^{1.555} there.  c is
   NOTHING else: a constant + the ledger's own quad pieces + the RVM
   model error.

- RVM density  Rho(x) = log(x/2pi)/(2pi)  (Lean: W2Kernel.Rho)
- RVM asymptote  Nas(x) = (x/2pi) log(x/2pi) - x/2pi + 7/8
- Test heights (ledger windows):  T0 = 3232170971.1121945
  (= zero g minus 5, g = 3232170976.1121945);  T1 = 27884282870.578449249 + 0.5


## 3. Formal <-> numeric wiring

- S1Point (ap5)  <->  every RVM-density quad in this program
  (s5/s6/s7 I_far; engine qrem/qext) integrates (ln g/2pi)/2pi —
  the density whose point-scale form is the Lean theorem.
- W2Kernel/W2Beyond2  <->  day037 engine kernels (la/re/qrem/qext)
  and s6/s7 S_U/I_far integrands.
- B4  <->  the certified zero lists drive float64 vector kernels
  (16/16 cross-check).
- EulerAction/E7a  <->  scripts/rh/day006_e7a_action_identity.py
  (dps-50 oracle, 5/5).
- W2M5/W2M6 pins  <->  S3c/S3d ciphers and the day035 census
  (K = 2.503 on (1e7, 2e9]); M6 re-pin G2 = 3e10.
- ZetaZeroSet  <->  the D-band zero files (scripts/rh/hi3e10/
  zeros_2999e6_to_30000e6.f64, G = last entry) + the ledger
  (scripts/rh/out_day052c_696/points.jsonl).
- s6/s7 scripts: scripts/rh/s6_c_closedform.py, s7_c_theorem.py;
  outputs tmp/s6_c_closedform.*, tmp/s7_c_theorem.*.


## 4. Pins and data (single source per fact)

- G (last zero): 30001045999.981975555  (D file last entry)
- D file first: 2999246000.182257;  D n = 92,577,877,714
- GN grid: 21,136,125 pts on (14.134725141734695, 9999999.327]
- file1 first zero: 31946000.066576
- zero files: scripts/rh/hi1e9/*, hi3e9/*, hi3e10/*, lowt/*
- ledger: scripts/rh/out_day052c_696/points.jsonl
  (s3.load_ledger() returns a DICT, not a list)
- Ex_total = 0.011547732887  (s6 run; t-independent)
- xi(0) = 1/2
- EPS in the c theorem: +1.66e-7 (t0), -1.74e-6 (t1)


## 5. Pitfalls (accumulated; each cost a day before)

- No symbols in user-facing text (plain ASCII); no dates in .md
  docs (DISCOVERY_LOG.md only); three-blank-line report sections.
- Never hand-estimate integrals at this scale — mpmath quad (or
  numpy u-trap with the e^u Jacobian if you substitute) is the
  oracle.  The u-substitution KILLS the integrand if you drop the
  Jacobian g = e^u.
- mp.quad over a wide g-interval (3e10..1e18) silently loses
  precision; the u-variable quad is the exact one (s7: 2.4e-7 vs
  4.7e10 spread on the naive trapezoid without the Jacobian fix).
- The B-fields of the ledger are bounds, not addends — adding them
  to the Kabs exponent corrupts D1 by ~1e-3..1e-2.
- micro-gaps (1e9, 1.002e9] and (2e9, 2.002e9] are NOT modeled by
  quad: the engine streams actual zeros there (day023 shards).
  Do not "fix" them with RVM quad in the bookkeeping.
- The (1e7, 3.19e7] slice is also actual-streamed, not grid, not
  quad (the GN grid stops at 1e7).
- ported Ap-line files: keep the license header; do not rename
  Ap3Gamma* (the ap4 content) without updating this guide.
- lake build is green with style lints firing; lints are not gates.
- cores 14-15 reserved; run single-core numeric jobs with
  taskset -c 0; 16 physical cores / 32 threads.
- do not grep the 740-GB band dir; do not delete anything;
  never commit the owner's personal files; 10TB drive = valuable
  data.  Push authorized for rh-missing-tail master.
- DOORS: DOOR B adjudicated (the 505-point flatness is a 0.5-step
  sampling artifact; the margin carries zero-scale structure);
  D5 (3e11) dropped from the active queue (locked); the program
  reduces to ONE clause: S = O(1) at zero heights (E1) — whose
  numeric face is now M_true(t) of the c theorem above, and whose
  formal face is E1Clause (e1clause.lean): the clause is named, the
  data face supports B = 2, and the residual program is the one
  line if_E1_and_walk.


## 6. Where the open content lives

- E1 (S = O(1) at zero heights):  formal face = S4Gap (the own-
  regime squeeze failure) + P12Uniform (the hypotheses) +
  ZetaZeroSet (the actual-zero obligations) + E1Clause (the clause
  named:  M_true(q, t) = true far-window pair-kernel sum minus the
  RVM model integral farRVM;  E1Clause q B  =  |M_true| <= B  at
  zero heights in (G_LAST, U_TOP];  B = 2 data-supported,  s8).
  Numeric face:  M_true(t) = EPS - log c(t) sampled at zero heights
  (ledger rows at t = g + k/2 straddles give c at detector scale).
- The main-term identity of section 2 IS the Lean bridge:
  MainBridge (main_term_bridge + bridge_eps_form, exact; the
  O(1e-6) is the named residual EPS, float-gated).
- W2M6 refutes the data-free branch at the pin; the A1 clause
  (W2Beyond3/E3.2) is the universal assembly question.
