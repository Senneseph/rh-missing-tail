/- 25ae Stage 3B.11 -- The list-scale wall for the sharpened T3 bound.
   Part A (1 <= t <= 13), four bands.  Endpoint constants (records in
   scripts/rh/day026_25ae_t3wall.py, exact Fraction + isqrt):
   t3w_qB_r = strict rational upper bound of sqrt(t3w_prod t* r) at the band
   endpoint t*; t3w_rB_r = strict rational upper bound of (n_min)^(-p_r).
   Every comparison closes by norm_num.  Part B (13 <= t <= 1e8): batch 2. -/
set_option maxSynthPendingDepth 8

/-- t3w_prod t i = prod_{k <= i} (t^2 + (k + 1/2)^2) = |S_i(t)|^2. -/
def t3w_prod (t : ℝ) (i : ℕ) : ℝ :=
  ∏ k ∈ Finset.range (i + 1), (t ^ 2 + (k + 1 / 2 : ℝ) ^ 2)

/-- Powers p_i of the list scale n in term i (7/2, 11/2, 15/2, 15/2). -/
def t3w_p (i : ℕ) : ℝ :=
  if i = 2 then 7 / 2 else if i = 4 then 11 / 2 else if i = 6 then 15 / 2
  else if i = 7 then 15 / 2 else 0

/-- Denominators d_i (720, 30240, 1209600, 9072000). -/
def t3w_d (i : ℕ) : ℝ :=
  if i = 2 then 720 else if i = 4 then 30240 else if i = 6 then 1209600
  else if i = 7 then 9072000 else 1

/-- Term i of the sharpened T3 bound at list scale: |S_i(t)| * n^{-p_i} / d_i. -/
def t3w_term (n : ℕ) (t : ℝ) (i : ℕ) : ℝ :=
  Real.sqrt (t3w_prod t i) * (n : ℝ) ^ (-(t3w_p i)) / (t3w_d i)

/-- The sharpened 4-term bound. -/
def t3w_T3UB (n : ℕ) (t : ℝ) : ℝ :=
  t3w_term n t 2 + t3w_term n t 4 + t3w_term n t 6 + t3w_term n t 7

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
def t3w_qA1_7 : ℝ := (1536332078500642084460770895 : ℝ) / 43608742899428874059776
def t3w_rA1_7 : ℝ := (1 : ℝ) / 1

theorem t3w_qA1 :
    Real.sqrt (t3w_prod (16 / 13) 2) < t3w_qA1_2 ∧
    Real.sqrt (t3w_prod (16 / 13) 4) < t3w_qA1_4 ∧
    Real.sqrt (t3w_prod (16 / 13) 6) < t3w_qA1_6 ∧
    Real.sqrt (t3w_prod (16 / 13) 7) < t3w_qA1_7 := by
  refine ⟨?_, ?_, ?_, ?_⟩
  all_goals exact (Real.sqrt_lt' (by norm_num [t3w_qA1_2, t3w_rA1_2, t3w_qA1_4, t3w_rA1_4, t3w_qA1_6, t3w_rA1_6, t3w_qA1_7, t3w_rA1_7])).mpr (by norm_num [t3w_prod, t3w_qA1_2, t3w_rA1_2, t3w_qA1_4, t3w_rA1_4, t3w_qA1_6, t3w_rA1_6, t3w_qA1_7, t3w_rA1_7])
def t3w_qA2_2 : ℝ := (5199 : ℝ) / 64
def t3w_rA2_2 : ℝ := (1 : ℝ) / 8
def t3w_qA2_4 : ℝ := (2661867 : ℝ) / 1024
def t3w_rA2_4 : ℝ := (1 : ℝ) / 32
def t3w_qA2_6 : ℝ := (2210599813 : ℝ) / 16384
def t3w_rA2_6 : ℝ := (1 : ℝ) / 128
def t3w_qA2_7 : ℝ := (75160393639 : ℝ) / 65536
def t3w_rA2_7 : ℝ := (1 : ℝ) / 128

theorem t3w_qA2 :
    Real.sqrt (t3w_prod (4) 2) < t3w_qA2_2 ∧
    Real.sqrt (t3w_prod (4) 4) < t3w_qA2_4 ∧
    Real.sqrt (t3w_prod (4) 6) < t3w_qA2_6 ∧
    Real.sqrt (t3w_prod (4) 7) < t3w_qA2_7 := by
  refine ⟨?_, ?_, ?_, ?_⟩
  all_goals exact (Real.sqrt_lt' (by norm_num [t3w_qA2_2, t3w_rA2_2, t3w_qA2_4, t3w_rA2_4, t3w_qA2_6, t3w_rA2_6, t3w_qA2_7, t3w_rA2_7])).mpr (by norm_num [t3w_prod, t3w_qA2_2, t3w_rA2_2, t3w_qA2_4, t3w_rA2_4, t3w_qA2_6, t3w_rA2_6, t3w_qA2_7, t3w_rA2_7])
def t3w_qA3_2 : ℝ := (17499 : ℝ) / 32
def t3w_rA3_2 : ℝ := (1 : ℝ) / 432
def t3w_qA3_4 : ℝ := (22440241 : ℝ) / 512
def t3w_rA3_4 : ℝ := (1 : ℝ) / 15552
def t3w_qA3_6 : ℝ := (17964810777 : ℝ) / 4096
def t3w_rA3_6 : ℝ := (1 : ℝ) / 559872
def t3w_qA3_7 : ℝ := (3151992477389 : ℝ) / 65536
def t3w_rA3_7 : ℝ := (1 : ℝ) / 559872

theorem t3w_qA3 :
    Real.sqrt (t3w_prod (8) 2) < t3w_qA3_2 ∧
    Real.sqrt (t3w_prod (8) 4) < t3w_qA3_4 ∧
    Real.sqrt (t3w_prod (8) 6) < t3w_qA3_6 ∧
    Real.sqrt (t3w_prod (8) 7) < t3w_qA3_7 := by
  refine ⟨?_, ?_, ?_, ?_⟩
  all_goals exact (Real.sqrt_lt' (by norm_num [t3w_qA3_2, t3w_rA3_2, t3w_qA3_4, t3w_rA3_4, t3w_qA3_6, t3w_rA3_6, t3w_qA3_7, t3w_rA3_7])).mpr (by norm_num [t3w_prod, t3w_qA3_2, t3w_rA3_2, t3w_qA3_4, t3w_rA3_4, t3w_qA3_6, t3w_rA3_6, t3w_qA3_7, t3w_rA3_7])
def t3w_qA4_2 : ℝ := (144241 : ℝ) / 64
def t3w_rA4_2 : ℝ := (1 : ℝ) / 6591
def t3w_qA4_4 : ℝ := (213715271 : ℝ) / 512
def t3w_rA4_4 : ℝ := (1 : ℝ) / 1113879
def t3w_qA4_6 : ℝ := (701541006115 : ℝ) / 8192
def t3w_rA4_6 : ℝ := (1 : ℝ) / 188245551
def t3w_qA4_7 : ℝ := (42115838574947 : ℝ) / 32768
def t3w_rA4_7 : ℝ := (1 : ℝ) / 188245551

theorem t3w_qA4 :
    Real.sqrt (t3w_prod (13) 2) < t3w_qA4_2 ∧
    Real.sqrt (t3w_prod (13) 4) < t3w_qA4_4 ∧
    Real.sqrt (t3w_prod (13) 6) < t3w_qA4_6 ∧
    Real.sqrt (t3w_prod (13) 7) < t3w_qA4_7 := by
  refine ⟨?_, ?_, ?_, ?_⟩
  all_goals exact (Real.sqrt_lt' (by norm_num [t3w_qA4_2, t3w_rA4_2, t3w_qA4_4, t3w_rA4_4, t3w_qA4_6, t3w_rA4_6, t3w_qA4_7, t3w_rA4_7])).mpr (by norm_num [t3w_prod, t3w_qA4_2, t3w_rA4_2, t3w_qA4_4, t3w_rA4_4, t3w_qA4_6, t3w_rA4_6, t3w_qA4_7, t3w_rA4_7])

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

  have hS7 : Real.sqrt (t3w_prod t 7) < t3w_qA1_7 := by
    exact lt_of_le_of_lt (Real.sqrt_le_sqrt (t3w_prod_mono h0t htstar 7)) t3w_qA1.2.2.2

  have hR2 : (n : ℝ) ^ (-( 7/2 : ℝ)) <= t3w_rA1_2 := by
    calc
      (n : ℝ) ^ (-( 7/2 : ℝ)) <= 1 := t3w_invpow_le_one n (by linarith [hnmin]) (7/2) (by norm_num)
      _ <= t3w_rA1_2 := by norm_num [t3w_rA1_2]

  have hR4 : (n : ℝ) ^ (-( 11/2 : ℝ)) <= t3w_rA1_4 := by
    calc
      (n : ℝ) ^ (-( 11/2 : ℝ)) <= 1 := t3w_invpow_le_one n (by linarith [hnmin]) (11/2) (by norm_num)
      _ <= t3w_rA1_4 := by norm_num [t3w_rA1_4]

  have hR6 : (n : ℝ) ^ (-( 15/2 : ℝ)) <= t3w_rA1_6 := by
    calc
      (n : ℝ) ^ (-( 15/2 : ℝ)) <= 1 := t3w_invpow_le_one n (by linarith [hnmin]) (15/2) (by norm_num)
      _ <= t3w_rA1_6 := by norm_num [t3w_rA1_6]

  have hR7 : (n : ℝ) ^ (-( 15/2 : ℝ)) <= t3w_rA1_7 := by
    calc
      (n : ℝ) ^ (-( 15/2 : ℝ)) <= 1 := t3w_invpow_le_one n (by linarith [hnmin]) (15/2) (by norm_num)
      _ <= t3w_rA1_7 := by norm_num [t3w_rA1_7]

  have hT2 : t3w_term n t 2 < t3w_qA1_2 * t3w_rA1_2 / 720 := by
    calc
      t3w_term n t 2 = Real.sqrt (t3w_prod t 2) * (n : ℝ) ^ (-( 7/2 : ℝ)) / 720 := by
        simp [t3w_term, t3w_p, t3w_d]
      _ <= Real.sqrt (t3w_prod t 2) * (t3w_rA1_2 : ℝ) / 720 := by
        gcongr
        all_goals (try exact hR2) <;> (try exact le_of_lt hR2) <;> (try norm_num) <;> (try positivity)
      _ < t3w_qA1_2 * (t3w_rA1_2 : ℝ) / 720 := by
        gcongr
        all_goals (try exact hS2) <;> (try norm_num) <;> (try positivity)

  have hT4 : t3w_term n t 4 < t3w_qA1_4 * t3w_rA1_4 / 30240 := by
    calc
      t3w_term n t 4 = Real.sqrt (t3w_prod t 4) * (n : ℝ) ^ (-( 11/2 : ℝ)) / 30240 := by
        simp [t3w_term, t3w_p, t3w_d]
      _ <= Real.sqrt (t3w_prod t 4) * (t3w_rA1_4 : ℝ) / 30240 := by
        gcongr
        all_goals (try exact hR4) <;> (try exact le_of_lt hR4) <;> (try norm_num) <;> (try positivity)
      _ < t3w_qA1_4 * (t3w_rA1_4 : ℝ) / 30240 := by
        gcongr
        all_goals (try exact hS4) <;> (try norm_num) <;> (try positivity)

  have hT6 : t3w_term n t 6 < t3w_qA1_6 * t3w_rA1_6 / 1209600 := by
    calc
      t3w_term n t 6 = Real.sqrt (t3w_prod t 6) * (n : ℝ) ^ (-( 15/2 : ℝ)) / 1209600 := by
        simp [t3w_term, t3w_p, t3w_d]
      _ <= Real.sqrt (t3w_prod t 6) * (t3w_rA1_6 : ℝ) / 1209600 := by
        gcongr
        all_goals (try exact hR6) <;> (try exact le_of_lt hR6) <;> (try norm_num) <;> (try positivity)
      _ < t3w_qA1_6 * (t3w_rA1_6 : ℝ) / 1209600 := by
        gcongr
        all_goals (try exact hS6) <;> (try norm_num) <;> (try positivity)

  have hT7 : t3w_term n t 7 < t3w_qA1_7 * t3w_rA1_7 / 9072000 := by
    calc
      t3w_term n t 7 = Real.sqrt (t3w_prod t 7) * (n : ℝ) ^ (-( 15/2 : ℝ)) / 9072000 := by
        simp [t3w_term, t3w_p, t3w_d]
      _ <= Real.sqrt (t3w_prod t 7) * (t3w_rA1_7 : ℝ) / 9072000 := by
        gcongr
        all_goals (try exact hR7) <;> (try exact le_of_lt hR7) <;> (try norm_num) <;> (try positivity)
      _ < t3w_qA1_7 * (t3w_rA1_7 : ℝ) / 9072000 := by
        gcongr
        all_goals (try exact hS7) <;> (try norm_num) <;> (try positivity)

  calc
    t3w_T3UB n t = t3w_term n t 2 + t3w_term n t 4 + t3w_term n t 6 + t3w_term n t 7 := rfl
    _ < t3w_qA1_2 * (t3w_rA1_2 : ℝ) / 720 + t3w_qA1_4 * (t3w_rA1_4 : ℝ) / 30240 +
        t3w_qA1_6 * (t3w_rA1_6 : ℝ) / 1209600 + t3w_qA1_8 * (t3w_rA1_8 : ℝ) / 9072000 := by
      gcongr
      all_goals (try exact hT2) <;> (try exact hT4) <;> (try exact hT6) <;> (try exact hT7) <;> (try norm_num) <;> (try positivity)
    _ < 35 / 78 := by norm_num [t3w_qA1_2, t3w_rA1_2, t3w_qA1_4, t3w_rA1_4, t3w_qA1_6, t3w_rA1_6, t3w_qA1_7, t3w_rA1_7]


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

  have hS7 : Real.sqrt (t3w_prod t 7) < t3w_qA2_7 := by
    exact lt_of_le_of_lt (Real.sqrt_le_sqrt (t3w_prod_mono h0t htstar 7)) t3w_qA2.2.2.2


  have hR2 : (n : ℝ) ^ (-( 7/2 : ℝ)) < t3w_rA2_2 := by
    calc
      (n : ℝ) ^ (-( 7/2 : ℝ)) = 1 / (n : ℝ) ^ ( 7/2 : ℝ) := by rw [rpow_neg (Nat.cast_nonneg n), inv_eq_one_div]
      _ <= 1 / (2 : ℝ) ^ ( 7/2 : ℝ) := by
        have hbase : (2 : ℝ) <= (n : ℝ) := Nat.cast_le.mpr hnmin
        exact (one_div_le_one_div (rpow_pos_of_pos (by norm_num : (0 : ℝ) < 2) ( 7/2 : ℝ))
          (rpow_pos_of_pos (Nat.cast_pos.mpr (show (0 : ℕ) < n from by linarith [hnmin])) ( 7/2 : ℝ))).mpr
          (rpow_le_rpow (by norm_num) hbase (by norm_num))
      _ < t3w_rA2_2 := by
        have hrew : (2 : ℝ) ^ ( 7/2 : ℝ) = Real.sqrt ((2 : ℝ) ^ (7 : ℕ)) := by
          have hp2 : ( 7/2 : ℝ) = (7 : ℝ) / 2 := by norm_num
          rw [hp2, show (2 : ℝ) ^ ((7 : ℝ) / 2) = (2 : ℝ) ^ ((7 : ℝ) * (1 / 2)) from by norm_num]
          rw [Real.rpow_mul (by norm_num : 0 ≤ (2 : ℝ)) (7 : ℝ) (1 / 2)]
          rw [show (7 : ℝ) = (7 : ℕ) from by norm_num]
          rw [Real.rpow_natCast, ← sqrt_eq_rpow]
        rw [hrew]
        rw [one_div_lt (by positivity) (by norm_num : 0 < t3w_rA2_2)]
        exact (Real.lt_sqrt (by positivity)).mpr (by norm_num)


  have hR4 : (n : ℝ) ^ (-( 11/2 : ℝ)) < t3w_rA2_4 := by
    calc
      (n : ℝ) ^ (-( 11/2 : ℝ)) = 1 / (n : ℝ) ^ ( 11/2 : ℝ) := by rw [rpow_neg (Nat.cast_nonneg n), inv_eq_one_div]
      _ <= 1 / (2 : ℝ) ^ ( 11/2 : ℝ) := by
        have hbase : (2 : ℝ) <= (n : ℝ) := Nat.cast_le.mpr hnmin
        exact (one_div_le_one_div (rpow_pos_of_pos (by norm_num : (0 : ℝ) < 2) ( 11/2 : ℝ))
          (rpow_pos_of_pos (Nat.cast_pos.mpr (show (0 : ℕ) < n from by linarith [hnmin])) ( 11/2 : ℝ))).mpr
          (rpow_le_rpow (by norm_num) hbase (by norm_num))
      _ < t3w_rA2_4 := by
        have hrew : (2 : ℝ) ^ ( 11/2 : ℝ) = Real.sqrt ((2 : ℝ) ^ (11 : ℕ)) := by
          have hp2 : ( 11/2 : ℝ) = (11 : ℝ) / 2 := by norm_num
          rw [hp2, show (2 : ℝ) ^ ((11 : ℝ) / 2) = (2 : ℝ) ^ ((11 : ℝ) * (1 / 2)) from by norm_num]
          rw [Real.rpow_mul (by norm_num : 0 ≤ (2 : ℝ)) (11 : ℝ) (1 / 2)]
          rw [show (11 : ℝ) = (11 : ℕ) from by norm_num]
          rw [Real.rpow_natCast, ← sqrt_eq_rpow]
        rw [hrew]
        rw [one_div_lt (by positivity) (by norm_num : 0 < t3w_rA2_4)]
        exact (Real.lt_sqrt (by positivity)).mpr (by norm_num)


  have hR6 : (n : ℝ) ^ (-( 15/2 : ℝ)) < t3w_rA2_6 := by
    calc
      (n : ℝ) ^ (-( 15/2 : ℝ)) = 1 / (n : ℝ) ^ ( 15/2 : ℝ) := by rw [rpow_neg (Nat.cast_nonneg n), inv_eq_one_div]
      _ <= 1 / (2 : ℝ) ^ ( 15/2 : ℝ) := by
        have hbase : (2 : ℝ) <= (n : ℝ) := Nat.cast_le.mpr hnmin
        exact (one_div_le_one_div (rpow_pos_of_pos (by norm_num : (0 : ℝ) < 2) ( 15/2 : ℝ))
          (rpow_pos_of_pos (Nat.cast_pos.mpr (show (0 : ℕ) < n from by linarith [hnmin])) ( 15/2 : ℝ))).mpr
          (rpow_le_rpow (by norm_num) hbase (by norm_num))
      _ < t3w_rA2_6 := by
        have hrew : (2 : ℝ) ^ ( 15/2 : ℝ) = Real.sqrt ((2 : ℝ) ^ (15 : ℕ)) := by
          have hp2 : ( 15/2 : ℝ) = (15 : ℝ) / 2 := by norm_num
          rw [hp2, show (2 : ℝ) ^ ((15 : ℝ) / 2) = (2 : ℝ) ^ ((15 : ℝ) * (1 / 2)) from by norm_num]
          rw [Real.rpow_mul (by norm_num : 0 ≤ (2 : ℝ)) (15 : ℝ) (1 / 2)]
          rw [show (15 : ℝ) = (15 : ℕ) from by norm_num]
          rw [Real.rpow_natCast, ← sqrt_eq_rpow]
        rw [hrew]
        rw [one_div_lt (by positivity) (by norm_num : 0 < t3w_rA2_6)]
        exact (Real.lt_sqrt (by positivity)).mpr (by norm_num)


  have hR7 : (n : ℝ) ^ (-( 15/2 : ℝ)) < t3w_rA2_7 := by
    calc
      (n : ℝ) ^ (-( 15/2 : ℝ)) = 1 / (n : ℝ) ^ ( 15/2 : ℝ) := by rw [rpow_neg (Nat.cast_nonneg n), inv_eq_one_div]
      _ <= 1 / (2 : ℝ) ^ ( 15/2 : ℝ) := by
        have hbase : (2 : ℝ) <= (n : ℝ) := Nat.cast_le.mpr hnmin
        exact (one_div_le_one_div (rpow_pos_of_pos (by norm_num : (0 : ℝ) < 2) ( 15/2 : ℝ))
          (rpow_pos_of_pos (Nat.cast_pos.mpr (show (0 : ℕ) < n from by linarith [hnmin])) ( 15/2 : ℝ))).mpr
          (rpow_le_rpow (by norm_num) hbase (by norm_num))
      _ < t3w_rA2_7 := by
        have hrew : (2 : ℝ) ^ ( 15/2 : ℝ) = Real.sqrt ((2 : ℝ) ^ (15 : ℕ)) := by
          have hp2 : ( 15/2 : ℝ) = (15 : ℝ) / 2 := by norm_num
          rw [hp2, show (2 : ℝ) ^ ((15 : ℝ) / 2) = (2 : ℝ) ^ ((15 : ℝ) * (1 / 2)) from by norm_num]
          rw [Real.rpow_mul (by norm_num : 0 ≤ (2 : ℝ)) (15 : ℝ) (1 / 2)]
          rw [show (15 : ℝ) = (15 : ℕ) from by norm_num]
          rw [Real.rpow_natCast, ← sqrt_eq_rpow]
        rw [hrew]
        rw [one_div_lt (by positivity) (by norm_num : 0 < t3w_rA2_7)]
        exact (Real.lt_sqrt (by positivity)).mpr (by norm_num)

  have hT2 : t3w_term n t 2 < t3w_qA2_2 * t3w_rA2_2 / 720 := by
    calc
      t3w_term n t 2 = Real.sqrt (t3w_prod t 2) * (n : ℝ) ^ (-( 7/2 : ℝ)) / 720 := by
        simp [t3w_term, t3w_p, t3w_d]
      _ <= Real.sqrt (t3w_prod t 2) * (t3w_rA2_2 : ℝ) / 720 := by
        gcongr
        all_goals (try exact hR2) <;> (try exact le_of_lt hR2) <;> (try norm_num) <;> (try positivity)
      _ < t3w_qA2_2 * (t3w_rA2_2 : ℝ) / 720 := by
        gcongr
        all_goals (try exact hS2) <;> (try norm_num) <;> (try positivity)

  have hT4 : t3w_term n t 4 < t3w_qA2_4 * t3w_rA2_4 / 30240 := by
    calc
      t3w_term n t 4 = Real.sqrt (t3w_prod t 4) * (n : ℝ) ^ (-( 11/2 : ℝ)) / 30240 := by
        simp [t3w_term, t3w_p, t3w_d]
      _ <= Real.sqrt (t3w_prod t 4) * (t3w_rA2_4 : ℝ) / 30240 := by
        gcongr
        all_goals (try exact hR4) <;> (try exact le_of_lt hR4) <;> (try norm_num) <;> (try positivity)
      _ < t3w_qA2_4 * (t3w_rA2_4 : ℝ) / 30240 := by
        gcongr
        all_goals (try exact hS4) <;> (try norm_num) <;> (try positivity)

  have hT6 : t3w_term n t 6 < t3w_qA2_6 * t3w_rA2_6 / 1209600 := by
    calc
      t3w_term n t 6 = Real.sqrt (t3w_prod t 6) * (n : ℝ) ^ (-( 15/2 : ℝ)) / 1209600 := by
        simp [t3w_term, t3w_p, t3w_d]
      _ <= Real.sqrt (t3w_prod t 6) * (t3w_rA2_6 : ℝ) / 1209600 := by
        gcongr
        all_goals (try exact hR6) <;> (try exact le_of_lt hR6) <;> (try norm_num) <;> (try positivity)
      _ < t3w_qA2_6 * (t3w_rA2_6 : ℝ) / 1209600 := by
        gcongr
        all_goals (try exact hS6) <;> (try norm_num) <;> (try positivity)

  have hT7 : t3w_term n t 7 < t3w_qA2_7 * t3w_rA2_7 / 9072000 := by
    calc
      t3w_term n t 7 = Real.sqrt (t3w_prod t 7) * (n : ℝ) ^ (-( 15/2 : ℝ)) / 9072000 := by
        simp [t3w_term, t3w_p, t3w_d]
      _ <= Real.sqrt (t3w_prod t 7) * (t3w_rA2_7 : ℝ) / 9072000 := by
        gcongr
        all_goals (try exact hR7) <;> (try exact le_of_lt hR7) <;> (try norm_num) <;> (try positivity)
      _ < t3w_qA2_7 * (t3w_rA2_7 : ℝ) / 9072000 := by
        gcongr
        all_goals (try exact hS7) <;> (try norm_num) <;> (try positivity)

  calc
    t3w_T3UB n t = t3w_term n t 2 + t3w_term n t 4 + t3w_term n t 6 + t3w_term n t 7 := rfl
    _ < t3w_qA2_2 * (t3w_rA2_2 : ℝ) / 720 + t3w_qA2_4 * (t3w_rA2_4 : ℝ) / 30240 +
        t3w_qA2_6 * (t3w_rA2_6 : ℝ) / 1209600 + t3w_qA2_8 * (t3w_rA2_8 : ℝ) / 9072000 := by
      gcongr
      all_goals (try exact hT2) <;> (try exact hT4) <;> (try exact hT6) <;> (try exact hT7) <;> (try norm_num) <;> (try positivity)
    _ < 35 / 234 := by norm_num [t3w_qA2_2, t3w_rA2_2, t3w_qA2_4, t3w_rA2_4, t3w_qA2_6, t3w_rA2_6, t3w_qA2_7, t3w_rA2_7]


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

  have hS7 : Real.sqrt (t3w_prod t 7) < t3w_qA3_7 := by
    exact lt_of_le_of_lt (Real.sqrt_le_sqrt (t3w_prod_mono h0t htstar 7)) t3w_qA3.2.2.2


  have hR2 : (n : ℝ) ^ (-( 7/2 : ℝ)) < t3w_rA3_2 := by
    calc
      (n : ℝ) ^ (-( 7/2 : ℝ)) = 1 / (n : ℝ) ^ ( 7/2 : ℝ) := by rw [rpow_neg (Nat.cast_nonneg n), inv_eq_one_div]
      _ <= 1 / (6 : ℝ) ^ ( 7/2 : ℝ) := by
        have hbase : (6 : ℝ) <= (n : ℝ) := Nat.cast_le.mpr hnmin
        exact (one_div_le_one_div (rpow_pos_of_pos (by norm_num : (0 : ℝ) < 6) ( 7/2 : ℝ))
          (rpow_pos_of_pos (Nat.cast_pos.mpr (show (0 : ℕ) < n from by linarith [hnmin])) ( 7/2 : ℝ))).mpr
          (rpow_le_rpow (by norm_num) hbase (by norm_num))
      _ < t3w_rA3_2 := by
        have hrew : (6 : ℝ) ^ ( 7/2 : ℝ) = Real.sqrt ((6 : ℝ) ^ (7 : ℕ)) := by
          have hp2 : ( 7/2 : ℝ) = (7 : ℝ) / 2 := by norm_num
          rw [hp2, show (6 : ℝ) ^ ((7 : ℝ) / 2) = (6 : ℝ) ^ ((7 : ℝ) * (1 / 2)) from by norm_num]
          rw [Real.rpow_mul (by norm_num : 0 ≤ (6 : ℝ)) (7 : ℝ) (1 / 2)]
          rw [show (7 : ℝ) = (7 : ℕ) from by norm_num]
          rw [Real.rpow_natCast, ← sqrt_eq_rpow]
        rw [hrew]
        rw [one_div_lt (by positivity) (by norm_num : 0 < t3w_rA3_2)]
        exact (Real.lt_sqrt (by positivity)).mpr (by norm_num)


  have hR4 : (n : ℝ) ^ (-( 11/2 : ℝ)) < t3w_rA3_4 := by
    calc
      (n : ℝ) ^ (-( 11/2 : ℝ)) = 1 / (n : ℝ) ^ ( 11/2 : ℝ) := by rw [rpow_neg (Nat.cast_nonneg n), inv_eq_one_div]
      _ <= 1 / (6 : ℝ) ^ ( 11/2 : ℝ) := by
        have hbase : (6 : ℝ) <= (n : ℝ) := Nat.cast_le.mpr hnmin
        exact (one_div_le_one_div (rpow_pos_of_pos (by norm_num : (0 : ℝ) < 6) ( 11/2 : ℝ))
          (rpow_pos_of_pos (Nat.cast_pos.mpr (show (0 : ℕ) < n from by linarith [hnmin])) ( 11/2 : ℝ))).mpr
          (rpow_le_rpow (by norm_num) hbase (by norm_num))
      _ < t3w_rA3_4 := by
        have hrew : (6 : ℝ) ^ ( 11/2 : ℝ) = Real.sqrt ((6 : ℝ) ^ (11 : ℕ)) := by
          have hp2 : ( 11/2 : ℝ) = (11 : ℝ) / 2 := by norm_num
          rw [hp2, show (6 : ℝ) ^ ((11 : ℝ) / 2) = (6 : ℝ) ^ ((11 : ℝ) * (1 / 2)) from by norm_num]
          rw [Real.rpow_mul (by norm_num : 0 ≤ (6 : ℝ)) (11 : ℝ) (1 / 2)]
          rw [show (11 : ℝ) = (11 : ℕ) from by norm_num]
          rw [Real.rpow_natCast, ← sqrt_eq_rpow]
        rw [hrew]
        rw [one_div_lt (by positivity) (by norm_num : 0 < t3w_rA3_4)]
        exact (Real.lt_sqrt (by positivity)).mpr (by norm_num)


  have hR6 : (n : ℝ) ^ (-( 15/2 : ℝ)) < t3w_rA3_6 := by
    calc
      (n : ℝ) ^ (-( 15/2 : ℝ)) = 1 / (n : ℝ) ^ ( 15/2 : ℝ) := by rw [rpow_neg (Nat.cast_nonneg n), inv_eq_one_div]
      _ <= 1 / (6 : ℝ) ^ ( 15/2 : ℝ) := by
        have hbase : (6 : ℝ) <= (n : ℝ) := Nat.cast_le.mpr hnmin
        exact (one_div_le_one_div (rpow_pos_of_pos (by norm_num : (0 : ℝ) < 6) ( 15/2 : ℝ))
          (rpow_pos_of_pos (Nat.cast_pos.mpr (show (0 : ℕ) < n from by linarith [hnmin])) ( 15/2 : ℝ))).mpr
          (rpow_le_rpow (by norm_num) hbase (by norm_num))
      _ < t3w_rA3_6 := by
        have hrew : (6 : ℝ) ^ ( 15/2 : ℝ) = Real.sqrt ((6 : ℝ) ^ (15 : ℕ)) := by
          have hp2 : ( 15/2 : ℝ) = (15 : ℝ) / 2 := by norm_num
          rw [hp2, show (6 : ℝ) ^ ((15 : ℝ) / 2) = (6 : ℝ) ^ ((15 : ℝ) * (1 / 2)) from by norm_num]
          rw [Real.rpow_mul (by norm_num : 0 ≤ (6 : ℝ)) (15 : ℝ) (1 / 2)]
          rw [show (15 : ℝ) = (15 : ℕ) from by norm_num]
          rw [Real.rpow_natCast, ← sqrt_eq_rpow]
        rw [hrew]
        rw [one_div_lt (by positivity) (by norm_num : 0 < t3w_rA3_6)]
        exact (Real.lt_sqrt (by positivity)).mpr (by norm_num)


  have hR7 : (n : ℝ) ^ (-( 15/2 : ℝ)) < t3w_rA3_7 := by
    calc
      (n : ℝ) ^ (-( 15/2 : ℝ)) = 1 / (n : ℝ) ^ ( 15/2 : ℝ) := by rw [rpow_neg (Nat.cast_nonneg n), inv_eq_one_div]
      _ <= 1 / (6 : ℝ) ^ ( 15/2 : ℝ) := by
        have hbase : (6 : ℝ) <= (n : ℝ) := Nat.cast_le.mpr hnmin
        exact (one_div_le_one_div (rpow_pos_of_pos (by norm_num : (0 : ℝ) < 6) ( 15/2 : ℝ))
          (rpow_pos_of_pos (Nat.cast_pos.mpr (show (0 : ℕ) < n from by linarith [hnmin])) ( 15/2 : ℝ))).mpr
          (rpow_le_rpow (by norm_num) hbase (by norm_num))
      _ < t3w_rA3_7 := by
        have hrew : (6 : ℝ) ^ ( 15/2 : ℝ) = Real.sqrt ((6 : ℝ) ^ (15 : ℕ)) := by
          have hp2 : ( 15/2 : ℝ) = (15 : ℝ) / 2 := by norm_num
          rw [hp2, show (6 : ℝ) ^ ((15 : ℝ) / 2) = (6 : ℝ) ^ ((15 : ℝ) * (1 / 2)) from by norm_num]
          rw [Real.rpow_mul (by norm_num : 0 ≤ (6 : ℝ)) (15 : ℝ) (1 / 2)]
          rw [show (15 : ℝ) = (15 : ℕ) from by norm_num]
          rw [Real.rpow_natCast, ← sqrt_eq_rpow]
        rw [hrew]
        rw [one_div_lt (by positivity) (by norm_num : 0 < t3w_rA3_7)]
        exact (Real.lt_sqrt (by positivity)).mpr (by norm_num)

  have hT2 : t3w_term n t 2 < t3w_qA3_2 * t3w_rA3_2 / 720 := by
    calc
      t3w_term n t 2 = Real.sqrt (t3w_prod t 2) * (n : ℝ) ^ (-( 7/2 : ℝ)) / 720 := by
        simp [t3w_term, t3w_p, t3w_d]
      _ <= Real.sqrt (t3w_prod t 2) * (t3w_rA3_2 : ℝ) / 720 := by
        gcongr
        all_goals (try exact hR2) <;> (try exact le_of_lt hR2) <;> (try norm_num) <;> (try positivity)
      _ < t3w_qA3_2 * (t3w_rA3_2 : ℝ) / 720 := by
        gcongr
        all_goals (try exact hS2) <;> (try norm_num) <;> (try positivity)

  have hT4 : t3w_term n t 4 < t3w_qA3_4 * t3w_rA3_4 / 30240 := by
    calc
      t3w_term n t 4 = Real.sqrt (t3w_prod t 4) * (n : ℝ) ^ (-( 11/2 : ℝ)) / 30240 := by
        simp [t3w_term, t3w_p, t3w_d]
      _ <= Real.sqrt (t3w_prod t 4) * (t3w_rA3_4 : ℝ) / 30240 := by
        gcongr
        all_goals (try exact hR4) <;> (try exact le_of_lt hR4) <;> (try norm_num) <;> (try positivity)
      _ < t3w_qA3_4 * (t3w_rA3_4 : ℝ) / 30240 := by
        gcongr
        all_goals (try exact hS4) <;> (try norm_num) <;> (try positivity)

  have hT6 : t3w_term n t 6 < t3w_qA3_6 * t3w_rA3_6 / 1209600 := by
    calc
      t3w_term n t 6 = Real.sqrt (t3w_prod t 6) * (n : ℝ) ^ (-( 15/2 : ℝ)) / 1209600 := by
        simp [t3w_term, t3w_p, t3w_d]
      _ <= Real.sqrt (t3w_prod t 6) * (t3w_rA3_6 : ℝ) / 1209600 := by
        gcongr
        all_goals (try exact hR6) <;> (try exact le_of_lt hR6) <;> (try norm_num) <;> (try positivity)
      _ < t3w_qA3_6 * (t3w_rA3_6 : ℝ) / 1209600 := by
        gcongr
        all_goals (try exact hS6) <;> (try norm_num) <;> (try positivity)

  have hT7 : t3w_term n t 7 < t3w_qA3_7 * t3w_rA3_7 / 9072000 := by
    calc
      t3w_term n t 7 = Real.sqrt (t3w_prod t 7) * (n : ℝ) ^ (-( 15/2 : ℝ)) / 9072000 := by
        simp [t3w_term, t3w_p, t3w_d]
      _ <= Real.sqrt (t3w_prod t 7) * (t3w_rA3_7 : ℝ) / 9072000 := by
        gcongr
        all_goals (try exact hR7) <;> (try exact le_of_lt hR7) <;> (try norm_num) <;> (try positivity)
      _ < t3w_qA3_7 * (t3w_rA3_7 : ℝ) / 9072000 := by
        gcongr
        all_goals (try exact hS7) <;> (try norm_num) <;> (try positivity)

  calc
    t3w_T3UB n t = t3w_term n t 2 + t3w_term n t 4 + t3w_term n t 6 + t3w_term n t 7 := rfl
    _ < t3w_qA3_2 * (t3w_rA3_2 : ℝ) / 720 + t3w_qA3_4 * (t3w_rA3_4 : ℝ) / 30240 +
        t3w_qA3_6 * (t3w_rA3_6 : ℝ) / 1209600 + t3w_qA3_8 * (t3w_rA3_8 : ℝ) / 9072000 := by
      gcongr
      all_goals (try exact hT2) <;> (try exact hT4) <;> (try exact hT6) <;> (try exact hT7) <;> (try norm_num) <;> (try positivity)
    _ < 35 / 312 := by norm_num [t3w_qA3_2, t3w_rA3_2, t3w_qA3_4, t3w_rA3_4, t3w_qA3_6, t3w_rA3_6, t3w_qA3_7, t3w_rA3_7]


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

  have hS7 : Real.sqrt (t3w_prod t 7) < t3w_qA4_7 := by
    exact lt_of_le_of_lt (Real.sqrt_le_sqrt (t3w_prod_mono h0t htstar 7)) t3w_qA4.2.2.2


  have hR2 : (n : ℝ) ^ (-( 7/2 : ℝ)) < t3w_rA4_2 := by
    calc
      (n : ℝ) ^ (-( 7/2 : ℝ)) = 1 / (n : ℝ) ^ ( 7/2 : ℝ) := by rw [rpow_neg (Nat.cast_nonneg n), inv_eq_one_div]
      _ <= 1 / (13 : ℝ) ^ ( 7/2 : ℝ) := by
        have hbase : (13 : ℝ) <= (n : ℝ) := Nat.cast_le.mpr hnmin
        exact (one_div_le_one_div (rpow_pos_of_pos (by norm_num : (0 : ℝ) < 13) ( 7/2 : ℝ))
          (rpow_pos_of_pos (Nat.cast_pos.mpr (show (0 : ℕ) < n from by linarith [hnmin])) ( 7/2 : ℝ))).mpr
          (rpow_le_rpow (by norm_num) hbase (by norm_num))
      _ < t3w_rA4_2 := by
        have hrew : (13 : ℝ) ^ ( 7/2 : ℝ) = Real.sqrt ((13 : ℝ) ^ (7 : ℕ)) := by
          have hp2 : ( 7/2 : ℝ) = (7 : ℝ) / 2 := by norm_num
          rw [hp2, show (13 : ℝ) ^ ((7 : ℝ) / 2) = (13 : ℝ) ^ ((7 : ℝ) * (1 / 2)) from by norm_num]
          rw [Real.rpow_mul (by norm_num : 0 ≤ (13 : ℝ)) (7 : ℝ) (1 / 2)]
          rw [show (7 : ℝ) = (7 : ℕ) from by norm_num]
          rw [Real.rpow_natCast, ← sqrt_eq_rpow]
        rw [hrew]
        rw [one_div_lt (by positivity) (by norm_num : 0 < t3w_rA4_2)]
        exact (Real.lt_sqrt (by positivity)).mpr (by norm_num)


  have hR4 : (n : ℝ) ^ (-( 11/2 : ℝ)) < t3w_rA4_4 := by
    calc
      (n : ℝ) ^ (-( 11/2 : ℝ)) = 1 / (n : ℝ) ^ ( 11/2 : ℝ) := by rw [rpow_neg (Nat.cast_nonneg n), inv_eq_one_div]
      _ <= 1 / (13 : ℝ) ^ ( 11/2 : ℝ) := by
        have hbase : (13 : ℝ) <= (n : ℝ) := Nat.cast_le.mpr hnmin
        exact (one_div_le_one_div (rpow_pos_of_pos (by norm_num : (0 : ℝ) < 13) ( 11/2 : ℝ))
          (rpow_pos_of_pos (Nat.cast_pos.mpr (show (0 : ℕ) < n from by linarith [hnmin])) ( 11/2 : ℝ))).mpr
          (rpow_le_rpow (by norm_num) hbase (by norm_num))
      _ < t3w_rA4_4 := by
        have hrew : (13 : ℝ) ^ ( 11/2 : ℝ) = Real.sqrt ((13 : ℝ) ^ (11 : ℕ)) := by
          have hp2 : ( 11/2 : ℝ) = (11 : ℝ) / 2 := by norm_num
          rw [hp2, show (13 : ℝ) ^ ((11 : ℝ) / 2) = (13 : ℝ) ^ ((11 : ℝ) * (1 / 2)) from by norm_num]
          rw [Real.rpow_mul (by norm_num : 0 ≤ (13 : ℝ)) (11 : ℝ) (1 / 2)]
          rw [show (11 : ℝ) = (11 : ℕ) from by norm_num]
          rw [Real.rpow_natCast, ← sqrt_eq_rpow]
        rw [hrew]
        rw [one_div_lt (by positivity) (by norm_num : 0 < t3w_rA4_4)]
        exact (Real.lt_sqrt (by positivity)).mpr (by norm_num)


  have hR6 : (n : ℝ) ^ (-( 15/2 : ℝ)) < t3w_rA4_6 := by
    calc
      (n : ℝ) ^ (-( 15/2 : ℝ)) = 1 / (n : ℝ) ^ ( 15/2 : ℝ) := by rw [rpow_neg (Nat.cast_nonneg n), inv_eq_one_div]
      _ <= 1 / (13 : ℝ) ^ ( 15/2 : ℝ) := by
        have hbase : (13 : ℝ) <= (n : ℝ) := Nat.cast_le.mpr hnmin
        exact (one_div_le_one_div (rpow_pos_of_pos (by norm_num : (0 : ℝ) < 13) ( 15/2 : ℝ))
          (rpow_pos_of_pos (Nat.cast_pos.mpr (show (0 : ℕ) < n from by linarith [hnmin])) ( 15/2 : ℝ))).mpr
          (rpow_le_rpow (by norm_num) hbase (by norm_num))
      _ < t3w_rA4_6 := by
        have hrew : (13 : ℝ) ^ ( 15/2 : ℝ) = Real.sqrt ((13 : ℝ) ^ (15 : ℕ)) := by
          have hp2 : ( 15/2 : ℝ) = (15 : ℝ) / 2 := by norm_num
          rw [hp2, show (13 : ℝ) ^ ((15 : ℝ) / 2) = (13 : ℝ) ^ ((15 : ℝ) * (1 / 2)) from by norm_num]
          rw [Real.rpow_mul (by norm_num : 0 ≤ (13 : ℝ)) (15 : ℝ) (1 / 2)]
          rw [show (15 : ℝ) = (15 : ℕ) from by norm_num]
          rw [Real.rpow_natCast, ← sqrt_eq_rpow]
        rw [hrew]
        rw [one_div_lt (by positivity) (by norm_num : 0 < t3w_rA4_6)]
        exact (Real.lt_sqrt (by positivity)).mpr (by norm_num)


  have hR7 : (n : ℝ) ^ (-( 15/2 : ℝ)) < t3w_rA4_7 := by
    calc
      (n : ℝ) ^ (-( 15/2 : ℝ)) = 1 / (n : ℝ) ^ ( 15/2 : ℝ) := by rw [rpow_neg (Nat.cast_nonneg n), inv_eq_one_div]
      _ <= 1 / (13 : ℝ) ^ ( 15/2 : ℝ) := by
        have hbase : (13 : ℝ) <= (n : ℝ) := Nat.cast_le.mpr hnmin
        exact (one_div_le_one_div (rpow_pos_of_pos (by norm_num : (0 : ℝ) < 13) ( 15/2 : ℝ))
          (rpow_pos_of_pos (Nat.cast_pos.mpr (show (0 : ℕ) < n from by linarith [hnmin])) ( 15/2 : ℝ))).mpr
          (rpow_le_rpow (by norm_num) hbase (by norm_num))
      _ < t3w_rA4_7 := by
        have hrew : (13 : ℝ) ^ ( 15/2 : ℝ) = Real.sqrt ((13 : ℝ) ^ (15 : ℕ)) := by
          have hp2 : ( 15/2 : ℝ) = (15 : ℝ) / 2 := by norm_num
          rw [hp2, show (13 : ℝ) ^ ((15 : ℝ) / 2) = (13 : ℝ) ^ ((15 : ℝ) * (1 / 2)) from by norm_num]
          rw [Real.rpow_mul (by norm_num : 0 ≤ (13 : ℝ)) (15 : ℝ) (1 / 2)]
          rw [show (15 : ℝ) = (15 : ℕ) from by norm_num]
          rw [Real.rpow_natCast, ← sqrt_eq_rpow]
        rw [hrew]
        rw [one_div_lt (by positivity) (by norm_num : 0 < t3w_rA4_7)]
        exact (Real.lt_sqrt (by positivity)).mpr (by norm_num)

  have hT2 : t3w_term n t 2 < t3w_qA4_2 * t3w_rA4_2 / 720 := by
    calc
      t3w_term n t 2 = Real.sqrt (t3w_prod t 2) * (n : ℝ) ^ (-( 7/2 : ℝ)) / 720 := by
        simp [t3w_term, t3w_p, t3w_d]
      _ <= Real.sqrt (t3w_prod t 2) * (t3w_rA4_2 : ℝ) / 720 := by
        gcongr
        all_goals (try exact hR2) <;> (try exact le_of_lt hR2) <;> (try norm_num) <;> (try positivity)
      _ < t3w_qA4_2 * (t3w_rA4_2 : ℝ) / 720 := by
        gcongr
        all_goals (try exact hS2) <;> (try norm_num) <;> (try positivity)

  have hT4 : t3w_term n t 4 < t3w_qA4_4 * t3w_rA4_4 / 30240 := by
    calc
      t3w_term n t 4 = Real.sqrt (t3w_prod t 4) * (n : ℝ) ^ (-( 11/2 : ℝ)) / 30240 := by
        simp [t3w_term, t3w_p, t3w_d]
      _ <= Real.sqrt (t3w_prod t 4) * (t3w_rA4_4 : ℝ) / 30240 := by
        gcongr
        all_goals (try exact hR4) <;> (try exact le_of_lt hR4) <;> (try norm_num) <;> (try positivity)
      _ < t3w_qA4_4 * (t3w_rA4_4 : ℝ) / 30240 := by
        gcongr
        all_goals (try exact hS4) <;> (try norm_num) <;> (try positivity)

  have hT6 : t3w_term n t 6 < t3w_qA4_6 * t3w_rA4_6 / 1209600 := by
    calc
      t3w_term n t 6 = Real.sqrt (t3w_prod t 6) * (n : ℝ) ^ (-( 15/2 : ℝ)) / 1209600 := by
        simp [t3w_term, t3w_p, t3w_d]
      _ <= Real.sqrt (t3w_prod t 6) * (t3w_rA4_6 : ℝ) / 1209600 := by
        gcongr
        all_goals (try exact hR6) <;> (try exact le_of_lt hR6) <;> (try norm_num) <;> (try positivity)
      _ < t3w_qA4_6 * (t3w_rA4_6 : ℝ) / 1209600 := by
        gcongr
        all_goals (try exact hS6) <;> (try norm_num) <;> (try positivity)

  have hT7 : t3w_term n t 7 < t3w_qA4_7 * t3w_rA4_7 / 9072000 := by
    calc
      t3w_term n t 7 = Real.sqrt (t3w_prod t 7) * (n : ℝ) ^ (-( 15/2 : ℝ)) / 9072000 := by
        simp [t3w_term, t3w_p, t3w_d]
      _ <= Real.sqrt (t3w_prod t 7) * (t3w_rA4_7 : ℝ) / 9072000 := by
        gcongr
        all_goals (try exact hR7) <;> (try exact le_of_lt hR7) <;> (try norm_num) <;> (try positivity)
      _ < t3w_qA4_7 * (t3w_rA4_7 : ℝ) / 9072000 := by
        gcongr
        all_goals (try exact hS7) <;> (try norm_num) <;> (try positivity)

  calc
    t3w_T3UB n t = t3w_term n t 2 + t3w_term n t 4 + t3w_term n t 6 + t3w_term n t 7 := rfl
    _ < t3w_qA4_2 * (t3w_rA4_2 : ℝ) / 720 + t3w_qA4_4 * (t3w_rA4_4 : ℝ) / 30240 +
        t3w_qA4_6 * (t3w_rA4_6 : ℝ) / 1209600 + t3w_qA4_8 * (t3w_rA4_8 : ℝ) / 9072000 := by
      gcongr
      all_goals (try exact hT2) <;> (try exact hT4) <;> (try exact hT6) <;> (try exact hT7) <;> (try norm_num) <;> (try positivity)
    _ < 35 / 390 := by norm_num [t3w_qA4_2, t3w_rA4_2, t3w_qA4_4, t3w_rA4_4, t3w_qA4_6, t3w_rA4_6, t3w_qA4_7, t3w_rA4_7]

