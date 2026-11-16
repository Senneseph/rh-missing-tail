import Mathlib
import RhAttack.B0
import RhAttack.WinCount
set_option maxRecDepth 1000000
set_option maxHeartbeats 4000000

/-!
# SIs — Ismail's explicit finite-height |S(T)| bound: the named external
# input [IS] (unit 130 / entry 0416, queued after CE97/FrontierCE97)

## PROVENANCE (audited, dual review — discovery 0391, 2026-11-13)

    Ismail, "A selected mollifier bound for zeros of zeta on the
    critical line", Zenodo https://doi.org/10.5281/zenodo.23301655
    (v3, 2026-10-11).

  THEOREM 1.1 (nine rows, all valid for every T ≥ e): explicit
  finite-height bounds  |S(T)| ≤ c1·log T + c2·log log T + c3  for the
  Riemann–Siegel S-function of the zeta zero count, with row-dependent
  explicit constants.  The ROW pinned here is the one whose optimum
  sits at T_opt = 3e12 (the row covering the frontiers of this
  program, tPT2 = 3 000 175 332 800 and every census frontier beyond
  it):

      |S(T)| ≤ 0.134791·log T + 0.159606·log log T + 1.505817   (T ≥ e),
      |S(3e12)| = 3.872496 + 0.535980 + 1.505817 = 5.914293.

  COROLLARY 1.4 (the N-form):  0.134791·log T + 0.159606·log log T
  + 2.380817  with  2.380817 = 1.505817 + 7/8  EXACTLY  (the RvM 7/8
  constant shift; the audit verified this identity digit-for-digit).

  CONSTANTS: the paper's rigorous (interval-computed) values are
  0.13479015 / 0.15960505 / 1.50581607;  the module pins the 6-decimal
  ROUNDED-UP row constants (134791 / 159606 / 1505817 over 10^6) so
  that every in-tree consequence is CONSERVATIVE relative to the
  paper.  (The unrounded values are `c1rig/c2rig/c3rig`.)

  AUDIT FINDINGS (0391): the Theorem 1.1 row re-derived at 200-bit Arb
  precision (certificate radius < 1e-56); the 69 public checks of the
  paper re-run and passing; one MISPINT flag: the Bellotti–Wong display
  carries an extra `log log T0` that does not affect the pinned row
  (effect < 1.5e-5, checked).  Verification status:
  LITERATURE-AUDIT-VERIFIED (dual audit), NOT kernel-verified — unlike
  [Z78], which is a kernel-verified external record.

## WHAT THIS MODULE IS (and is not)

  A NAMED EXTERNAL INPUT module in the exact [Z78] house pattern:
  the bound is recorded as `def ... : Prop` hypotheses (no axioms,
  no new constants in the kernel universe) and is consumed by the
  terminal-face program exactly as `Z78.externalZeroFree78` is:
  instantiate the input as a theorem hypothesis.

  * [IS-S] `ismailSBound`    — the height form (all T ≥ e).
  * [IS-Z] `ismailSAtZeros`  — the zero-height form on an abstract
    ZeroSet (the shape of the program's open |S|-at-zeros clauses).
  * in-tree PROVEN from [IS-S] alone (Parts C–E):
      - `sboundMon`      : the bound is increasing on [e, ∞);
      - `frontierS_pin`  : |S(tPT2)| ≤ 6 AT THE FRONTIER itself — a
        data-free absolute gate on the whole open regime above the
        census frontier (in-tree value < 14893541/2500000 ≈ 5.95742,
        from the brackets log tPT2 ≤ 29 and log log tPT2 < 34/10;
        the paper's own 3e12 evaluation 5.914293 is recorded in the
        header and in `pinM3e12`).
  * the exp pins used by the brackets are the house Bernoulli pattern
    (the S4Window.hEub25 / hE3 lineage): 1 + u ≤ exp u, powered, with
    exact bignum comparisons — no series statements, no measurements.

## HONESTY LABELS

  LITERATURE-AUDIT-VERIFIED   [IS-S], [IS-Z] (0391 dual audit; not
                              kernel-verified — cited at consumption).
  LITERATURE-PINNED           the 6-decimal constants, the 5.914293
                              decomposition, the 200-bit radius.
  LEAN-PROVEN                 the pins, the brackets, `sboundMon`,
                              `frontierS_pin` (given [IS-S]).
  NO RH claim.  [IS] is a named input, not a theorem of this program;
  the module changes nothing about the named residual of the endpoint.
-/

open Set Finset Real

noncomputable section

namespace SIs

/-! ## Part A — the row constants (exact rationals, rounded UP). -/

/-- The row constants of Ismail Theorem 1.1, row T_opt = 3e12,
    6-decimal ROUNDED-UP (conservative). -/
def c1 : ℚ := 134791 / 10 ^ 6
def c2 : ℚ := 159606 / 10 ^ 6
def c3 : ℚ := 1505817 / 10 ^ 6

/-- The paper's rigorous (unrounded) values, recomputed in 0391. -/
def c1rig : ℚ := 13479015 / 10 ^ 8
def c2rig : ℚ := 15960505 / 10 ^ 8
def c3rig : ℚ := 150581607 / 10 ^ 8

/-- The Cor 1.4 N-form constant: c3 + 7/8 exactly. -/
def c3N : ℚ := 2380817 / 10 ^ 6

theorem pinC3N : c3N = c3 + 7 / 8 := by
  dsimp only [c3N, c3]
  norm_num

theorem pinRoundingUp : c1rig ≤ c1 ∧ c2rig ≤ c2 ∧ c3rig ≤ c3 := by
  refine ⟨?_, ?_, ?_⟩ <;> (dsimp only [c1rig, c2rig, c3rig, c1, c2, c3]; norm_num)

theorem pinRoundingUpStrict : c1rig < c1 ∧ c2rig < c2 ∧ c3rig < c3 := by
  refine ⟨?_, ?_, ?_⟩ <;> (dsimp only [c1rig, c2rig, c3rig, c1, c2, c3]; norm_num)

/-- The paper's |S(3e12)| decomposition (3.872496 + 0.535980 +
    1.505817 = 5.914293), recomputed in 0391 (the ln(3e12)-evaluation
    layer is the audit record; this identity is its exact rational
    core). -/
theorem pinM3e12 :
    (3872496 : ℚ) / 10 ^ 6 + 535980 / 10 ^ 6 + 1505817 / 10 ^ 6 = 5914293 / 10 ^ 6 := by
  norm_num

/-! ## Part B — the bound and the named inputs. -/

/-- Ismail's explicit finite-height bound on |S(T)| (the pinned row;
    valid for all T ≥ e). -/
def Sbound (T : ℝ) : ℝ := (c1 : ℝ) * log T + (c2 : ℝ) * log (log T) + (c3 : ℝ)

/-- [IS-S] (named external input; literature-audit-verified, dual audit
    0391, 2026-11-13; NOT kernel-verified; Zenodo 23301655 v3 Theorem
    1.1 row T_opt = 3e12; 200-bit Arb radius < 1e-56; misprint flag
    checked).  For the Riemann–Siegel S-function S of the zeta zero
    count:

        |S(T)| ≤ c1·log T + c2·log log T + c3    for all T ≥ e.

    Consume as [Z78]: a named `def : Prop` theorem hypothesis — no
    axiom, no constant.  The bridge that the actual S is the RvM
    7/8-shifted defect of the zero count (with the cited O(1/T)
    remainder) is the standard cited layer of the W2SAtZeros /
    ZetaZeroSet convention. -/
def ismailSBound (S : ℝ → ℝ) : Prop :=
  ∀ (T : ℝ), (exp 1 : ℝ) ≤ T → |S T| ≤ Sbound T

/-- [IS-Z] (named external input; the zero-height form of [IS-S] on an
    abstract zero set — the shape of the program's open |S|-at-zeros
    clauses: for every zero ρ of q with height ≥ e, the S of q's count
    is explicitly bounded at that height; above the census frontier
    this is a DATA-FREE gauge growing like 0.134791·log T, never a
    finite absolute). -/
def ismailSAtZeros (q : ZeroSet) (S : ℝ → ℝ) : Prop :=
  ∀ (ρ : ℂ) (hρ : ρ ∈ q.Z), 0 < ρ.im → (exp 1 : ℝ) ≤ ρ.im →
    |S (ρ.im)| ≤ Sbound (ρ.im)

/-! ## Part C — monotonicity (proven). -/

/-- The bound is increasing on [e, ∞): the face regime above the
    frontier carries a monotone data-free |S| gauge. -/
theorem sboundMon (T U : ℝ) (hT : (exp 1 : ℝ) ≤ T) (hTU : T ≤ U) :
    Sbound T ≤ Sbound U := by
  dsimp only [Sbound]
  have hTpos : 0 < T := by linarith [exp_pos 1]
  have hTlog : 1 ≤ log T :=
    calc (1 : ℝ)
        = log (exp 1) := (Real.log_exp 1).symm
      _ ≤ log T := Real.log_le_log (by linarith [exp_pos 1]) hT
  have hUlog : 0 < log U := by linarith [Real.log_le_log hTpos hTU, hTlog]
  have hTlog0 : 0 < log T := by linarith [hTlog]
  have h1 : log T ≤ log U := Real.log_le_log hTpos hTU
  have h2 : log (log T) ≤ log (log U) := Real.log_le_log hTlog0 h1
  have hc1 : (0 : ℝ) ≤ (c1 : ℝ) := by
    unfold c1
    norm_num
  have hc2 : (0 : ℝ) ≤ (c2 : ℝ) := by
    unfold c2
    norm_num
  nlinarith [mul_le_mul_of_nonneg_left h1 hc1, mul_le_mul_of_nonneg_left h2 hc2]

/-! ## Part D — the exp pins and brackets (Bernoulli floors, house
    pattern). -/

/-- e ≤ 3 (the house certificate: e ≤ (25/24)^25 ≤ 3). -/
theorem hE3 : (exp 1 : ℝ) ≤ 3 := by
  set x := (1 / 25 : ℝ) with hx
  have hneg : 1 - x ≤ exp (-x) := by
    rw [show (1 : ℝ) - x = (-x) + 1 from by ring]
    exact Real.add_one_le_exp (-x)
  have hexp : 0 < exp (-x) := Real.exp_pos (-x)
  have hden : 0 < 1 - x := by dsimp only [x]; norm_num
  have hinv : exp x ≤ (1 - x)⁻¹ := by
    calc (exp x : ℝ)
        = (exp (-x))⁻¹ := by
          rw [Real.exp_neg x, inv_inv (exp x)]
      _ ≤ (1 - x)⁻¹ := by
        rw [inv_eq_one_div (exp (-x)), inv_eq_one_div (1 - x)]
        exact (one_div_le_one_div (a := exp (-x)) (b := 1 - x) hexp hden).mpr hneg
  calc (exp 1 : ℝ)
      = (exp x : ℝ) ^ 25 := by
        have he : exp (25 * x) = (exp x : ℝ) ^ 25 := Real.exp_nat_mul x 25
        have hx25 : (25 : ℝ) * x = 1 := by dsimp only [x]; norm_num
        rw [← hx25, he]
    _ ≤ ((1 - x)⁻¹ : ℝ) ^ 25 := pow_le_pow_left₀ (by positivity) hinv 25
    _ = (25 / 24 : ℝ) ^ 25 := by dsimp only [x]; norm_num
    _ ≤ 3 := by norm_num

/-- Bernoulli floor: (1 + x/n)^n ≤ exp x for x ≥ 0, n ≥ 1 — from
    1 + u ≤ exp u with u = x/n, powered. -/
protected theorem expBernoulli (x : ℝ) (n : ℕ) (hn : 0 < n) (hx : 0 ≤ x) :
    (1 + x / n : ℝ) ^ n ≤ exp x := by
  have hu : 1 + x / n ≤ exp (x / n) := by
    rw [show (1 : ℝ) + x / n = x / n + 1 from by ring]
    exact Real.add_one_le_exp (x / n)
  have hnn : (↑n : ℝ) ≠ 0 := by positivity
  have he : exp x = (exp (x / n : ℝ)) ^ n := by
    have harg : (↑n : ℝ) * (x / ↑n) = x := by field_simp [hnn]
    calc exp x
        = exp ((↑n : ℝ) * (x / ↑n)) := by rw [harg]
      _ = (exp (x / n : ℝ)) ^ n := Real.exp_nat_mul (x / n : ℝ) n
  calc (1 + x / n : ℝ) ^ n
      ≤ (exp (x / n : ℝ)) ^ n := pow_le_pow_left₀ (by positivity : 0 ≤ (1 + x / n : ℝ)) hu n
    _ = exp x := he.symm

/-- e ≥ (101/100)^100 (Bernoulli, x = 1, n = 100). -/
theorem hElo100 : (101 / 100 : ℝ) ^ 100 ≤ exp 1 := by
  have hL : (101 / 100 : ℝ) = (1 : ℝ) + 1 / 100 := by norm_num
  rw [hL]
  exact SIs.expBernoulli 1 100 (by norm_num) (by norm_num)

/-- (101/100)^50 > 8217/5000 (exact bignum: 5000·101^50 vs 8217·10^100;
    margin 0.075%). -/
theorem hB100a : (101 / 100 : ℝ) ^ 50 > 8217 / 5000 := by norm_num

/-- (101/100)^100 > 27/10, chained through (8217/5000)^2:
    27/10 < (8217/5000)^2 ≤ ((101/100)^50)^2 = (101/100)^100. -/
theorem hB100 : (27 / 10 : ℝ) < (101 / 100 : ℝ) ^ 100 := by
  calc (27 / 10 : ℝ)
      < (8217 / 5000 : ℝ) ^ 2 := by norm_num
    _ ≤ ((101 / 100 : ℝ) ^ 50) ^ 2 := by
         exact pow_le_pow_left₀ (by norm_num : 0 ≤ (8217 / 5000 : ℝ)) (le_of_lt hB100a) 2
    _ = (101 / 100 : ℝ) ^ 100 := by ring

/-- e ≥ 27/10. -/
theorem hE27 : (27 / 10 : ℝ) ≤ exp 1 := le_trans (le_of_lt hB100) hElo100

/-- e^29 ≥ (27/10)^29. -/
theorem hE29 : (27 / 10 : ℝ) ^ 29 ≤ exp 29 :=
  calc (27 / 10 : ℝ) ^ 29
      ≤ (exp 1 : ℝ) ^ 29 := pow_le_pow_left₀ (by norm_num) hE27 29
    _ = exp (29 * 1) := (Real.exp_nat_mul 1 29).symm
    _ = exp 29 := by rw [mul_one]

/-- (27/10)^29 > tPT2 (exact bignum: 27^29 vs 3000175332800·10^29 —
    margin 7.7%). -/
theorem hB29 : (WinC.tPT2 : ℝ) < (27 / 10 : ℝ) ^ 29 := by norm_num [WinC.tPT2]

/-- THE UPPER BRACKET: log tPT2 ≤ 29. -/
theorem hLnHi29 : log (WinC.tPT2 : ℝ) ≤ 29 := by
  have hpos : 0 < (WinC.tPT2 : ℝ) := by norm_num [WinC.tPT2]
  by_contra h
  have hg : (29 : ℝ) < log (WinC.tPT2 : ℝ) := by linarith
  have he : exp 29 < (WinC.tPT2 : ℝ) := by
    calc exp 29
        < exp (log (WinC.tPT2 : ℝ)) := Real.exp_lt_exp.mpr hg
      _ = (WinC.tPT2 : ℝ) := exp_log hpos
  nlinarith [he, hE29, hB29]

/-- exp(34/10) ≥ (1017/1000)^200 (Bernoulli, x = 34/10, n = 200). -/
theorem hE34 : (1017 / 1000 : ℝ) ^ 200 ≤ exp (34 / 10) := by
  have hL : (1017 / 1000 : ℝ) = (1 : ℝ) + (34 / 10) / 200 := by norm_num
  rw [hL]
  exact SIs.expBernoulli (34 / 10) 200 (by norm_num) (by norm_num)

/-- (1017/1000)^100 > 539/100 (exact bignum: 1017^100 vs 539·10^298;
    margin 0.12%). -/
theorem hB200a : (1017 / 1000 : ℝ) ^ 100 > 539 / 100 := by norm_num

/-- (1017/1000)^200 > 29, chained through (539/100)^2:
    29 < (539/100)^2 ≤ ((1017/1000)^100)^2 = (1017/1000)^200. -/
theorem hB200 : (29 : ℝ) < (1017 / 1000 : ℝ) ^ 200 := by
  calc (29 : ℝ)
      < (539 / 100 : ℝ) ^ 2 := by norm_num
    _ ≤ ((1017 / 1000 : ℝ) ^ 100) ^ 2 := by
         exact pow_le_pow_left₀ (by norm_num : 0 ≤ (539 / 100 : ℝ)) (le_of_lt hB200a) 2
    _ = (1017 / 1000 : ℝ) ^ 200 := by ring

/-- THE LOWER BRACKET: log 29 < 34/10. -/
theorem hLn29_34 : log 29 < (34 / 10 : ℝ) := by
  by_contra h
  have hg : (34 / 10 : ℝ) ≤ log 29 := by linarith
  have he : exp (34 / 10) ≤ 29 :=
    calc exp (34 / 10)
        ≤ exp (log 29) := Real.exp_le_exp.mpr hg
      _ = 29 := exp_log (by norm_num : 0 < (29 : ℝ))
  nlinarith [he, hE34, hB200]

/-- 1 ≤ log tPT2 (via e ≤ 3 ≤ tPT2 and monotonicity of log). -/
theorem hL1 : (1 : ℝ) ≤ log (WinC.tPT2 : ℝ) := by
  have h3 : (3 : ℝ) ≤ (WinC.tPT2 : ℝ) := by norm_num [WinC.tPT2]
  calc (1 : ℝ)
      = log (exp 1) := (Real.log_exp 1).symm
    _ ≤ log 3 := Real.log_le_log (by positivity) hE3
    _ ≤ log (WinC.tPT2 : ℝ) := Real.log_le_log (by norm_num) h3

/-- log(log tPT2) < 34/10 (via the two brackets and monotonicity;
    log tPT2 ≥ 1 keeps the inner log on its increasing branch). -/
theorem hLnLnPin : log (log (WinC.tPT2 : ℝ)) < (34 / 10 : ℝ) := by
  have hpos : 1 ≤ log (WinC.tPT2 : ℝ) := hL1
  have hLE : log (WinC.tPT2 : ℝ) ≤ 29 := hLnHi29
  calc log (log (WinC.tPT2 : ℝ))
      ≤ log 29 := Real.log_le_log (lt_of_lt_of_le (by norm_num : (0 : ℝ) < 1) hpos) hLE
    _ < (34 / 10 : ℝ) := hLn29_34

/-! ## Part E — the frontier consequence (proven from [IS-S]). -/

/-- IN-TREE EXACT VALUE OF THE PINNED BRACKETS:
    c1·29 + c2·(34/10) + c3 = 14893541/2500000 < 6 (margin 0.0426). -/
theorem pinBracketValue :
    (c1 : ℝ) * 29 + (c2 : ℝ) * (34 / 10) + (c3 : ℝ) = 14893541 / 2500000 := by
  dsimp only [c1, c2, c3]
  norm_num

theorem pinBracketLt6 : (c1 : ℝ) * 29 + (c2 : ℝ) * (34 / 10) + (c3 : ℝ) < 6 := by
  rw [pinBracketValue]
  norm_num

/-- THE FRONTIER PIN: under [IS-S] alone, |S| AT THE PLATT–TRUDGIAN
    FRONTIER HEIGHT is absolutely bounded:

        |S(tPT2)| ≤ 6     (tPT2 = 3 000 175 332 800).

    PROVEN in the body (no data, no measurement): [IS-S] gives
    |S(tPT2)| ≤ c1·log tPT2 + c2·log log tPT2 + c3, and the brackets of
    Part D give log tPT2 ≤ 29 and log log tPT2 < 34/10 (both with
    nonnegativity, so the monotone arithmetic is direct), so the pin is
    < 14893541/2500000 + c2·(34/10 − log log tPT2) ≤ 14893541/2500000
    < 6.  By `sboundMon` the same data-free gauge covers every height
    of the open regime above the frontier (the paper's 3e12 evaluation
    5.914293 is recorded in the header and `pinM3e12`).  NO RH claim:
    a named-input consequence, consumed at the witness step of the
    terminal-face program. -/
theorem frontierS_pin (S : ℝ → ℝ) (hIS : ismailSBound S) :
    |S (WinC.tPT2 : ℝ)| ≤ 6 := by
  have hT := hIS (WinC.tPT2 : ℝ) (by
    have h3 : (3 : ℝ) ≤ (WinC.tPT2 : ℝ) := by norm_num [WinC.tPT2]
    linarith [hE3, h3])
  dsimp only [Sbound] at hT
  have hl : log (WinC.tPT2 : ℝ) ≤ 29 := hLnHi29
  have hll : log (log (WinC.tPT2 : ℝ)) < (34 / 10 : ℝ) := hLnLnPin
  have hll0 : log (log (WinC.tPT2 : ℝ)) ≤ (34 / 10 : ℝ) := le_of_lt hll
  have hc1 : (0 : ℝ) ≤ (c1 : ℝ) := by
    unfold c1
    norm_num
  have hc2 : (0 : ℝ) ≤ (c2 : ℝ) := by
    unfold c2
    norm_num
  nlinarith [hT,
    mul_le_mul_of_nonneg_right hl hc1,
    mul_le_mul_of_nonneg_right hll0 hc2,
    pinBracketLt6]

/-- The BRIDGE [IS-S] --> [IS-Z] (one line, the zero-height form is a
    restriction of the all-real form): if |S T| <= Sbound T for ALL
    T >= e, then at every zero height rho.im >= e of any zero set q the
    same bound holds - [IS-Z] is not an independent input, it is
    [IS-S] restricted to the zero locus. -/
theorem ismailSAtZeros_of_ismailSBound (q : ZeroSet) (S : ℝ → ℝ)
    (hIS : ismailSBound S) : ismailSAtZeros q S :=
  fun ρ hρ hpos hT => hIS (ρ.im) hT

end SIs

end
