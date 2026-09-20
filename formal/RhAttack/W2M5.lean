/-
# (W2, M5)  Numeric instantiation:  the pinned constants.

Data-adjacent theorems taking the S3d/S3e pins as NAMED constants
(per docs/W2-LEAN-PLAN.md section 1.5 + build order M5):

  G1_pin = 1e7           band left end (the S3c census start)
  G2_pin = 2e9           band right end (S3d full-zero census end)
  K_pin  = 2.503         PINNED sup|DN| on (1e7, 2e9] (S3d, day035)
  L_pin  = Rho(G2_pin)   K3's explicit slope bound:
                         L = log(G2 / (2 pi)) / (2 pi)
                         (Rho is increasing, Rho' = 1 / (2 pi x) > 0)

The explicit certificate C is evaluated by norm_num where it is pure
arithmetic (the K_pin coefficient);  the partition data (M, x, p, Nas)
stays a hypothesis, exactly as the plan's "data-adjacent" form.
-/
import Mathlib
import RhAttack.W2Bound

open BigOperators

namespace W2M5

def G1_pin : ℝ := 1e7

def G2_pin : ℝ := 2e9

/-- The pinned sup|DN| on (1e7, 2e9] (S3d full-zero census, day035):
K_pin = 2.503. -/
def K_pin : ℝ := 2.503

/-- K3's explicit slope bound L := Rho(G2_pin) = log(G2 / (2 pi)) / (2 pi).
Rho(x) = log(x / (2 pi)) / (2 pi) is increasing (Rho' = 1 / (2 pi x) > 0),
so for all x in (0, G2_pin]:  |Nas'(x)| = Nas'(x) = Rho(x) <= Rho(G2_pin). -/
noncomputable def L_pin : ℝ := Real.log (G2_pin / (2 * Real.pi)) / (2 * Real.pi)

/-- K_pin in exact rational form (norm_num-checked). -/
theorem pin_check : K_pin = 2503 / 1000 := by
  norm_num [K_pin]

/-- The bound is positive (K_pin > 0, by norm_num). -/
theorem K_pin_pos : 0 < K_pin := by
  norm_num [K_pin]

/-- L_pin > 0:  the argument G2_pin / (2 pi) is > 1, because
2e9 > 2 pi (pi < 4 suffices, and the pin gives pi < 3551 / 1131). -/
theorem L_pin_pos : 0 < L_pin := by
  dsimp only [L_pin, G2_pin]
  have hden : 0 < 2 * Real.pi := by linarith [Real.pi_pos]
  have harg : 1 < 2e9 / (2 * Real.pi) := by
    rw [one_lt_div_iff (a := (2e9 : ℝ)) (b := 2 * Real.pi)]
    left
    refine ⟨hden, ?_⟩
    have h2p : 2 * Real.pi < 6.2832 := by linarith [Real.pi_lt_d4]
    have h3 : (6.2832 : ℝ) < 2e9 := by norm_num
    linarith [h2p, h3]
  have hlog : 0 < Real.log (2e9 / (2 * Real.pi)) := by
    have hx : 0 < 2e9 / (2 * Real.pi) := lt_trans zero_lt_one harg
    rw [← Real.log_one]
    exact Real.log_lt_log (show (0 : ℝ) < 1 from by norm_num) harg
  exact div_pos hlog hden

/-- GMAX factoring:  if every gap on the partition is <= GMAX, then
the e4 weighted sum factors as GMAX * TV (the plan's "GMAX_far * TV_far"
form). -/
theorem gapTV (M : ℕ) (x p : ℕ → ℝ) (GMAX : ℝ)
    (hgap : ∀ j ∈ Finset.range M, x (j + 1) - x j ≤ GMAX) (hG0 : 0 ≤ GMAX) :
    (∑ j ∈ Finset.range M, (x (j + 1) - x j) * abs (W2T.DP p j)) ≤
      GMAX * (∑ j ∈ Finset.range M, abs (W2T.DP p j)) := by
  have h1 : (∑ j ∈ Finset.range M, (x (j + 1) - x j) * abs (W2T.DP p j)) ≤
      (∑ j ∈ Finset.range M, GMAX * abs (W2T.DP p j)) := by
    apply Finset.sum_le_sum
    intro j hj
    apply mul_le_mul_of_nonneg_right
    · exact hgap j hj
    · exact abs_nonneg _
  calc
    _ ≤ (∑ j ∈ Finset.range M, GMAX * abs (W2T.DP p j)) := h1
    _ = GMAX * (∑ j ∈ Finset.range M, abs (W2T.DP p j)) := by
      rw [Finset.mul_sum]

/-! The two data-adjacent instantiations with the pinned constants. -/

/-- (M5-floor)  the one-sided certificate, K := K_pin = 2.503:
on any zero partition of the band, with |DN j| <= K_pin at every
partition point,
    S1 - R >= -(K_pin * (|p 0| + |p M|) + K_pin * sum |Dp|). -/
theorem m5_floor (M : ℕ) (p : ℕ → ℝ) (N0 : ℕ) (Nas : ℕ → ℝ)
    (hD0 : abs (W2T.DN N0 Nas 0) ≤ K_pin)
    (hDM : abs (W2T.DN N0 Nas M) ≤ K_pin)
    (hD : ∀ j ∈ Finset.range M, abs (W2T.DN N0 Nas j) ≤ K_pin) :
    W2T.S1Sum M p - W2T.RSum M p Nas ≥
      -(K_pin * (abs (p 0) + abs (p M)) +
        K_pin * (∑ j ∈ Finset.range M, abs (W2T.DP p j))) :=
  W2B.e4_tailFloor M p N0 Nas K_pin hD0 hDM hD

/-- (M5-idn)  the I_DN-side bound with K := K_pin and L := L_pin:
    |I_DN| <= K_pin * sum|Dp| + L_pin * sum gap|Dp|
            + L_pin * gap_k + 2 * L_pin * gap_k^2 * (1 / x_k + 6). -/
theorem m5_idn (M k : ℕ) (hM : k < M) (x p : ℕ → ℝ) (N0 : ℕ) (Nas : ℕ → ℝ)
    (t : ℝ) (ht : 0 < t) (ht2 : 1 / 2 ≤ t ^ 2)
    (hRhoLeL : abs (W2K.Rho t) ≤ L_pin)
    (hxPos : ∀ j ∈ Finset.range (M + 1), 0 < x j)
    (hxA : ∀ j ∈ Finset.range M, x j < x (j + 1))
    (hLips : ∀ j ∈ Finset.range M,
        ∀ z ∈ Set.Ioo (x j) (x (j + 1)), abs (deriv W2K.Nas z) ≤ L_pin)
    (hxk : x k < t) (hxt : t < x (k + 1))
    (hp : ∀ j ∈ Finset.range (M + 1), p j = W2K.Ker (x j) t)
    (hpNas : ∀ j ∈ Finset.range (M + 1), Nas j = W2K.Nas (x j))
    (hD : ∀ j ∈ Finset.range M, abs (W2T.DN N0 Nas j) ≤ K_pin) :
    abs ((∑ j ∈ Finset.range M,
        (if j = k then W2B.gapContS t (x j) (x (j + 1)) ((N0 : ℝ) + (j : ℝ))
         else W2B.gapContNS t (x j) (x (j + 1)) ((N0 : ℝ) + (j : ℝ))))) ≤
      K_pin * (∑ j ∈ Finset.range M, abs (W2T.DP p j)) +
      L_pin * (∑ j ∈ Finset.range M, (x (j + 1) - x j) * abs (W2T.DP p j)) +
      L_pin * (x (k + 1) - x k) +
      2 * L_pin * (x (k + 1) - x k) ^ 2 * (1 / x k + 6) :=
  W2B.e4_idnBound M k hM x p N0 Nas t L_pin K_pin ht ht2 (by
    exact L_pin_pos.le) hRhoLeL hxPos hxA hLips hxk hxt hp hpNas hD

end W2M5
