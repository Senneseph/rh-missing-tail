/- 25ae Stage 3B.11 -- The list-scale wall for the sharpened T3 bound.
   Part A (1 <= t <= 13), four bands.  Endpoint constants (scripts/rh/day026_25ae_t3wall.py,
   exact Fraction + isqrt):  t3w_qB_r = strict rational sqrt upper bound of
   t3w_prod t* r (endpoint t* of band B);  t3w_rB_r = strict rational upper
   bound of (n_min)^(-p_r).  Every comparison closes by norm_num.
   Part B (13 <= t <= 1e8): batch 2. -/
set_option maxSynthPendingDepth 8

/-- t3w_prod t i = prod_{k <= i} (t^2 + (k + 1/2)^2) = |S_i(t)|^2. -/
def t3w_prod (t : ℝ) (i : ℕ) : ℝ :=
  prod k in Finset.range (i + 1), (t ^ 2 + (k + 1 / 2 : ℝ) ^ 2)

/-- Powers p_i of the list scale n in term i (7/2, 11/2, 15/2, 15/2). -/
def t3w_p (i : ℕ) : ℝ :=
  if i = 2 then 7 / 2 else if i = 4 then 11 / 2 else if i = 6 then 15 / 2
  else if i = 8 then 15 / 2 else 0

/-- Denominators d_i (720, 30240, 1209600, 9072000). -/
def t3w_d (i : ℕ) : ℝ :=
  if i = 2 then 720 else if i = 4 then 30240 else if i = 6 then 1209600
  else if i = 8 then 9072000 else 1

/-- Term i of the sharpened T3 bound at list scale: |S_i(t)| * n^{-p_i} / d_i. -/
def t3w_term (n : ℕ) (t : ℝ) (i : ℕ) : ℝ :=
  Real.sqrt (t3w_prod t i) * (n : ℝ) ^ (-(t3w_p i)) / (t3w_d i)

/-- The sharpened 4-term bound. -/
def t3w_T3UB (n : ℕ) (t : ℝ) : ℝ :=
  t3w_term n t 2 + t3w_term n t 4 + t3w_term n t 6 + t3w_term n t 8

/-- t3w_prod is increasing for 0 <= t <= t'. -/
theorem t3w_prod_mono {t t' : ℝ} (h0 : 0 <= t) (h : t <= t') (i : ℕ) :
    t3w_prod t i <= t3w_prod t' i := by
  dsimp only [t3w_prod]
  gcongr
  all_goals nlinarith [sq_le_sq (by linarith [h0]) (by linarith [h0, h])]

/-- n^{-p} <= 1 for n >= 1 and p > 0. -/
theorem t3w_invpow_le_one (n : ℕ) (hn : 1 <= n) (p : ℝ) (hp : 0 < p) :
    (n : ℝ) ^ (-p) <= 1 := by
  have h1p : (1 : ℝ) <= (n : ℝ) ^ p := Real.one_le_rpow (by exact_mod_cast hn) hp.le
  calc
    (n : ℝ) ^ (-p) = ((n : ℝ) ^ p)⁻¹ := by rw [rpow_neg (Nat.cast_nonneg n)]
    _ = 1 / (n : ℝ) ^ p := by rw [inv_eq_one_div]
    _ <= 1 / 1 := (one_div_le_one_div (by positivity) (by norm_num : 0 < (1 : ℝ))).mpr h1p
    _ = 1 := by norm_num
def t3w_qA1_2 : ℝ := (2218821909 : ℝ) / 308915776
def t3w_rA1_2 : ℝ := (1 : ℝ) / 1
def t3w_qA1_4 : ℝ := (17550033412413605 : ℝ) / 141167095653376
def t3w_rA1_4 : ℝ := (1 : ℝ) / 1
def t3w_qA1_6 : ℝ := (149512256733405629341179 : ℝ) / 32254987351648575488
def t3w_rA1_6 : ℝ := (1 : ℝ) / 1
def t3w_qA1_8 : ℝ := (1114978187651465145192020070463 : ℝ) / 3684938775001739858051072
def t3w_rA1_8 : ℝ := (1 : ℝ) / 1

theorem t3w_qA1 :
    Real.sqrt (t3w_prod (16 / 13) 2) < t3w_qA1_2 ∧
    Real.sqrt (t3w_prod (16 / 13) 4) < t3w_qA1_4 ∧
    Real.sqrt (t3w_prod (16 / 13) 6) < t3w_qA1_6 ∧
    Real.sqrt (t3w_prod (16 / 13) 8) < t3w_qA1_8 := by
  refine ⟨?_, ?_, ?_, ?_⟩
  all_goals exact (Real.sqrt_lt' (by norm_num [t3w_qA1_2, t3w_rA1_2, t3w_qA1_4, t3w_rA1_4, t3w_qA1_6, t3w_rA1_6, t3w_qA1_8, t3w_rA1_8])).mpr (by norm_num [t3w_prod, t3w_qA1_2, t3w_rA1_2, t3w_qA1_4, t3w_rA1_4, t3w_qA1_6, t3w_rA1_6, t3w_qA1_8, t3w_rA1_8])
def t3w_qA2_2 : ℝ := (5199 : ℝ) / 64
def t3w_rA2_2 : ℝ := (1 : ℝ) / 8
def t3w_qA2_4 : ℝ := (2661867 : ℝ) / 1024
def t3w_rA2_4 : ℝ := (1 : ℝ) / 32
def t3w_qA2_6 : ℝ := (2210599813 : ℝ) / 16384
def t3w_rA2_6 : ℝ := (1 : ℝ) / 128
def t3w_qA2_8 : ℝ := (2824271179937 : ℝ) / 262144
def t3w_rA2_8 : ℝ := (1 : ℝ) / 128

theorem t3w_qA2 :
    Real.sqrt (t3w_prod (4) 2) < t3w_qA2_2 ∧
    Real.sqrt (t3w_prod (4) 4) < t3w_qA2_4 ∧
    Real.sqrt (t3w_prod (4) 6) < t3w_qA2_6 ∧
    Real.sqrt (t3w_prod (4) 8) < t3w_qA2_8 := by
  refine ⟨?_, ?_, ?_, ?_⟩
  all_goals exact (Real.sqrt_lt' (by norm_num [t3w_qA2_2, t3w_rA2_2, t3w_qA2_4, t3w_rA2_4, t3w_qA2_6, t3w_rA2_6, t3w_qA2_8, t3w_rA2_8])).mpr (by norm_num [t3w_prod, t3w_qA2_2, t3w_rA2_2, t3w_qA2_4, t3w_rA2_4, t3w_qA2_6, t3w_rA2_6, t3w_qA2_8, t3w_rA2_8])
def t3w_qA3_2 : ℝ := (17499 : ℝ) / 32
def t3w_rA3_2 : ℝ := (1 : ℝ) / 432
def t3w_qA3_4 : ℝ := (22440241 : ℝ) / 512
def t3w_rA3_4 : ℝ := (1 : ℝ) / 15552
def t3w_qA3_6 : ℝ := (17964810777 : ℝ) / 4096
def t3w_rA3_6 : ℝ := (1 : ℝ) / 559872
def t3w_qA3_8 : ℝ := (73584005291547 : ℝ) / 131072
def t3w_rA3_8 : ℝ := (1 : ℝ) / 559872

theorem t3w_qA3 :
    Real.sqrt (t3w_prod (8) 2) < t3w_qA3_2 ∧
    Real.sqrt (t3w_prod (8) 4) < t3w_qA3_4 ∧
    Real.sqrt (t3w_prod (8) 6) < t3w_qA3_6 ∧
    Real.sqrt (t3w_prod (8) 8) < t3w_qA3_8 := by
  refine ⟨?_, ?_, ?_, ?_⟩
  all_goals exact (Real.sqrt_lt' (by norm_num [t3w_qA3_2, t3w_rA3_2, t3w_qA3_4, t3w_rA3_4, t3w_qA3_6, t3w_rA3_6, t3w_qA3_8, t3w_rA3_8])).mpr (by norm_num [t3w_prod, t3w_qA3_2, t3w_rA3_2, t3w_qA3_4, t3w_rA3_4, t3w_qA3_6, t3w_rA3_6, t3w_qA3_8, t3w_rA3_8])
def t3w_qA4_2 : ℝ := (144241 : ℝ) / 64
def t3w_rA4_2 : ℝ := (1 : ℝ) / 6591
def t3w_qA4_4 : ℝ := (213715271 : ℝ) / 512
def t3w_rA4_4 : ℝ := (1 : ℝ) / 1113879
def t3w_qA4_6 : ℝ := (701541006115 : ℝ) / 8192
def t3w_rA4_6 : ℝ := (1 : ℝ) / 188245551
def t3w_qA4_8 : ℝ := (5233221300591837 : ℝ) / 262144
def t3w_rA4_8 : ℝ := (1 : ℝ) / 188245551

theorem t3w_qA4 :
    Real.sqrt (t3w_prod (13) 2) < t3w_qA4_2 ∧
    Real.sqrt (t3w_prod (13) 4) < t3w_qA4_4 ∧
    Real.sqrt (t3w_prod (13) 6) < t3w_qA4_6 ∧
    Real.sqrt (t3w_prod (13) 8) < t3w_qA4_8 := by
  refine ⟨?_, ?_, ?_, ?_⟩
  all_goals exact (Real.sqrt_lt' (by norm_num [t3w_qA4_2, t3w_rA4_2, t3w_qA4_4, t3w_rA4_4, t3w_qA4_6, t3w_rA4_6, t3w_qA4_8, t3w_rA4_8])).mpr (by norm_num [t3w_prod, t3w_qA4_2, t3w_rA4_2, t3w_qA4_4, t3w_rA4_4, t3w_qA4_6, t3w_rA4_6, t3w_qA4_8, t3w_rA4_8])

/-- A1: 1 <= t < 16 / 13 (n >= 1). -/
theorem t3w_wall_A1 {t : ℝ} (ht : 1 <= t) (htb : t < 16 / 13) {n : ℕ}
    (hn : n = ⌊(13 : ℝ) * t / 8⌋₊) :
    t3w_T3UB n t < 35 / 78 := by
  have hnmin : 1 <= n := by
    rw [hn]
    exact (Nat.le_floor_iff' (show (1 : ℕ) ≠ 0 from by norm_num)).mpr (by linarith [ht])
  have htstar : t <= 16 / 13 := htb.le
  have h0t : 0 <= t := by linarith [ht]
  have hS2 : Real.sqrt (t3w_prod t 2) < t3w_qA1_2 := by
    exact lt_of_le_of_lt (Real.sqrt_le_sqrt (t3w_prod_mono h0t htstar 2)) t3w_qA1.1
  have hS4 : Real.sqrt (t3w_prod t 4) < t3w_qA1_4 := by
    exact lt_of_le_of_lt (Real.sqrt_le_sqrt (t3w_prod_mono h0t htstar 4)) t3w_qA1.2.1
  have hS6 : Real.sqrt (t3w_prod t 6) < t3w_qA1_6 := by
    exact lt_of_le_of_lt (Real.sqrt_le_sqrt (t3w_prod_mono h0t htstar 6)) t3w_qA1.2.2.1
  have hS8 : Real.sqrt (t3w_prod t 8) < t3w_qA1_8 := by
    exact lt_of_le_of_lt (Real.sqrt_le_sqrt (t3w_prod_mono h0t htstar 8)) t3w_qA1.2.2.2
  have hR2 : (n : ℝ) ^ (-( 7/2 : ℝ)) <= t3w_rA1_2 :=
    t3w_invpow_le_one n (by linarith [hnmin]) (7/2) (by norm_num)
  have hR4 : (n : ℝ) ^ (-( 11/2 : ℝ)) <= t3w_rA1_4 :=
    t3w_invpow_le_one n (by linarith [hnmin]) (11/2) (by norm_num)
  have hR6 : (n : ℝ) ^ (-( 15/2 : ℝ)) <= t3w_rA1_6 :=
    t3w_invpow_le_one n (by linarith [hnmin]) (15/2) (by norm_num)
  have hR8 : (n : ℝ) ^ (-( 15/2 : ℝ)) <= t3w_rA1_8 :=
    t3w_invpow_le_one n (by linarith [hnmin]) (15/2) (by norm_num)

/-- A2: 16 / 13 <= t < 4 (n >= 2). -/
theorem t3w_wall_A2 {t : ℝ} (ht : 16 / 13 <= t) (htb : t < 4) {n : ℕ}
    (hn : n = ⌊(13 : ℝ) * t / 8⌋₊) :
    t3w_T3UB n t < 35 / 234 := by
  have hnmin : 2 <= n := by
    rw [hn]
    exact (Nat.le_floor_iff' (show (2 : ℕ) ≠ 0 from by norm_num)).mpr (by linarith [ht])
  have htstar : t <= 4 := htb.le
  have h0t : 0 <= t := by linarith [ht]
  have hS2 : Real.sqrt (t3w_prod t 2) < t3w_qA2_2 := by
    exact lt_of_le_of_lt (Real.sqrt_le_sqrt (t3w_prod_mono h0t htstar 2)) t3w_qA2.1
  have hS4 : Real.sqrt (t3w_prod t 4) < t3w_qA2_4 := by
    exact lt_of_le_of_lt (Real.sqrt_le_sqrt (t3w_prod_mono h0t htstar 4)) t3w_qA2.2.1
  have hS6 : Real.sqrt (t3w_prod t 6) < t3w_qA2_6 := by
    exact lt_of_le_of_lt (Real.sqrt_le_sqrt (t3w_prod_mono h0t htstar 6)) t3w_qA2.2.2.1
  have hS8 : Real.sqrt (t3w_prod t 8) < t3w_qA2_8 := by
    exact lt_of_le_of_lt (Real.sqrt_le_sqrt (t3w_prod_mono h0t htstar 8)) t3w_qA2.2.2.2
  have hR2 : (n : ℝ) ^ (-( 7/2 : ℝ)) <= t3w_rA2_2 := by
    calc
      (n : ℝ) ^ (-( 7/2 : ℝ)) = 1 / (n : ℝ) ^ ( 7/2 : ℝ) := by rw [rpow_neg (Nat.cast_nonneg n)]
      _ <= 1 / (2 : ℝ) ^ ( 7/2 : ℝ) := by
        gcongr
        all_goals (try exact hRtmp) <;> (try norm_num)
      _ < t3w_rA2_2 := by sorry
  have hR4 : (n : ℝ) ^ (-( 11/2 : ℝ)) <= t3w_rA2_4 := by
    calc
      (n : ℝ) ^ (-( 11/2 : ℝ)) = 1 / (n : ℝ) ^ ( 11/2 : ℝ) := by rw [rpow_neg (Nat.cast_nonneg n)]
      _ <= 1 / (2 : ℝ) ^ ( 11/2 : ℝ) := by
        gcongr
        all_goals (try exact hRtmp) <;> (try norm_num)
      _ < t3w_rA2_4 := by sorry
  have hR6 : (n : ℝ) ^ (-( 15/2 : ℝ)) <= t3w_rA2_6 := by
    calc
      (n : ℝ) ^ (-( 15/2 : ℝ)) = 1 / (n : ℝ) ^ ( 15/2 : ℝ) := by rw [rpow_neg (Nat.cast_nonneg n)]
      _ <= 1 / (2 : ℝ) ^ ( 15/2 : ℝ) := by
        gcongr
        all_goals (try exact hRtmp) <;> (try norm_num)
      _ < t3w_rA2_6 := by sorry
  have hR8 : (n : ℝ) ^ (-( 15/2 : ℝ)) <= t3w_rA2_8 := by
    calc
      (n : ℝ) ^ (-( 15/2 : ℝ)) = 1 / (n : ℝ) ^ ( 15/2 : ℝ) := by rw [rpow_neg (Nat.cast_nonneg n)]
      _ <= 1 / (2 : ℝ) ^ ( 15/2 : ℝ) := by
        gcongr
        all_goals (try exact hRtmp) <;> (try norm_num)
      _ < t3w_rA2_8 := by sorry

/-- A3: 4 <= t < 8 (n >= 6). -/
theorem t3w_wall_A3 {t : ℝ} (ht : 4 <= t) (htb : t < 8) {n : ℕ}
    (hn : n = ⌊(13 : ℝ) * t / 8⌋₊) :
    t3w_T3UB n t < 35 / 312 := by
  have hnmin : 6 <= n := by
    rw [hn]
    exact (Nat.le_floor_iff' (show (6 : ℕ) ≠ 0 from by norm_num)).mpr (by linarith [ht])
  have htstar : t <= 8 := htb.le
  have h0t : 0 <= t := by linarith [ht]
  have hS2 : Real.sqrt (t3w_prod t 2) < t3w_qA3_2 := by
    exact lt_of_le_of_lt (Real.sqrt_le_sqrt (t3w_prod_mono h0t htstar 2)) t3w_qA3.1
  have hS4 : Real.sqrt (t3w_prod t 4) < t3w_qA3_4 := by
    exact lt_of_le_of_lt (Real.sqrt_le_sqrt (t3w_prod_mono h0t htstar 4)) t3w_qA3.2.1
  have hS6 : Real.sqrt (t3w_prod t 6) < t3w_qA3_6 := by
    exact lt_of_le_of_lt (Real.sqrt_le_sqrt (t3w_prod_mono h0t htstar 6)) t3w_qA3.2.2.1
  have hS8 : Real.sqrt (t3w_prod t 8) < t3w_qA3_8 := by
    exact lt_of_le_of_lt (Real.sqrt_le_sqrt (t3w_prod_mono h0t htstar 8)) t3w_qA3.2.2.2
  have hR2 : (n : ℝ) ^ (-( 7/2 : ℝ)) <= t3w_rA3_2 := by
    calc
      (n : ℝ) ^ (-( 7/2 : ℝ)) = 1 / (n : ℝ) ^ ( 7/2 : ℝ) := by rw [rpow_neg (Nat.cast_nonneg n)]
      _ <= 1 / (6 : ℝ) ^ ( 7/2 : ℝ) := by
        gcongr
        all_goals (try exact hRtmp) <;> (try norm_num)
      _ < t3w_rA3_2 := by sorry
  have hR4 : (n : ℝ) ^ (-( 11/2 : ℝ)) <= t3w_rA3_4 := by
    calc
      (n : ℝ) ^ (-( 11/2 : ℝ)) = 1 / (n : ℝ) ^ ( 11/2 : ℝ) := by rw [rpow_neg (Nat.cast_nonneg n)]
      _ <= 1 / (6 : ℝ) ^ ( 11/2 : ℝ) := by
        gcongr
        all_goals (try exact hRtmp) <;> (try norm_num)
      _ < t3w_rA3_4 := by sorry
  have hR6 : (n : ℝ) ^ (-( 15/2 : ℝ)) <= t3w_rA3_6 := by
    calc
      (n : ℝ) ^ (-( 15/2 : ℝ)) = 1 / (n : ℝ) ^ ( 15/2 : ℝ) := by rw [rpow_neg (Nat.cast_nonneg n)]
      _ <= 1 / (6 : ℝ) ^ ( 15/2 : ℝ) := by
        gcongr
        all_goals (try exact hRtmp) <;> (try norm_num)
      _ < t3w_rA3_6 := by sorry
  have hR8 : (n : ℝ) ^ (-( 15/2 : ℝ)) <= t3w_rA3_8 := by
    calc
      (n : ℝ) ^ (-( 15/2 : ℝ)) = 1 / (n : ℝ) ^ ( 15/2 : ℝ) := by rw [rpow_neg (Nat.cast_nonneg n)]
      _ <= 1 / (6 : ℝ) ^ ( 15/2 : ℝ) := by
        gcongr
        all_goals (try exact hRtmp) <;> (try norm_num)
      _ < t3w_rA3_8 := by sorry

/-- A4: 8 <= t < 13 (n >= 13). -/
theorem t3w_wall_A4 {t : ℝ} (ht : 8 <= t) (htb : t < 13) {n : ℕ}
    (hn : n = ⌊(13 : ℝ) * t / 8⌋₊) :
    t3w_T3UB n t < 35 / 390 := by
  have hnmin : 13 <= n := by
    rw [hn]
    exact (Nat.le_floor_iff' (show (13 : ℕ) ≠ 0 from by norm_num)).mpr (by linarith [ht])
  have htstar : t <= 13 := htb.le
  have h0t : 0 <= t := by linarith [ht]
  have hS2 : Real.sqrt (t3w_prod t 2) < t3w_qA4_2 := by
    exact lt_of_le_of_lt (Real.sqrt_le_sqrt (t3w_prod_mono h0t htstar 2)) t3w_qA4.1
  have hS4 : Real.sqrt (t3w_prod t 4) < t3w_qA4_4 := by
    exact lt_of_le_of_lt (Real.sqrt_le_sqrt (t3w_prod_mono h0t htstar 4)) t3w_qA4.2.1
  have hS6 : Real.sqrt (t3w_prod t 6) < t3w_qA4_6 := by
    exact lt_of_le_of_lt (Real.sqrt_le_sqrt (t3w_prod_mono h0t htstar 6)) t3w_qA4.2.2.1
  have hS8 : Real.sqrt (t3w_prod t 8) < t3w_qA4_8 := by
    exact lt_of_le_of_lt (Real.sqrt_le_sqrt (t3w_prod_mono h0t htstar 8)) t3w_qA4.2.2.2
  have hR2 : (n : ℝ) ^ (-( 7/2 : ℝ)) <= t3w_rA4_2 := by
    calc
      (n : ℝ) ^ (-( 7/2 : ℝ)) = 1 / (n : ℝ) ^ ( 7/2 : ℝ) := by rw [rpow_neg (Nat.cast_nonneg n)]
      _ <= 1 / (13 : ℝ) ^ ( 7/2 : ℝ) := by
        gcongr
        all_goals (try exact hRtmp) <;> (try norm_num)
      _ < t3w_rA4_2 := by sorry
  have hR4 : (n : ℝ) ^ (-( 11/2 : ℝ)) <= t3w_rA4_4 := by
    calc
      (n : ℝ) ^ (-( 11/2 : ℝ)) = 1 / (n : ℝ) ^ ( 11/2 : ℝ) := by rw [rpow_neg (Nat.cast_nonneg n)]
      _ <= 1 / (13 : ℝ) ^ ( 11/2 : ℝ) := by
        gcongr
        all_goals (try exact hRtmp) <;> (try norm_num)
      _ < t3w_rA4_4 := by sorry
  have hR6 : (n : ℝ) ^ (-( 15/2 : ℝ)) <= t3w_rA4_6 := by
    calc
      (n : ℝ) ^ (-( 15/2 : ℝ)) = 1 / (n : ℝ) ^ ( 15/2 : ℝ) := by rw [rpow_neg (Nat.cast_nonneg n)]
      _ <= 1 / (13 : ℝ) ^ ( 15/2 : ℝ) := by
        gcongr
        all_goals (try exact hRtmp) <;> (try norm_num)
      _ < t3w_rA4_6 := by sorry
  have hR8 : (n : ℝ) ^ (-( 15/2 : ℝ)) <= t3w_rA4_8 := by
    calc
      (n : ℝ) ^ (-( 15/2 : ℝ)) = 1 / (n : ℝ) ^ ( 15/2 : ℝ) := by rw [rpow_neg (Nat.cast_nonneg n)]
      _ <= 1 / (13 : ℝ) ^ ( 15/2 : ℝ) := by
        gcongr
        all_goals (try exact hRtmp) <;> (try norm_num)
      _ < t3w_rA4_8 := by sorry
