/- 25ae Stage 3B.11 -- The list-scale wall for the sharpened T3 bound.
   Part A (1 <= t < 13), four bands.  Endpoint constants: strict rational
   upper bounds computed in scripts/rh/day026_25ae_t3wall.py (isqrt + 1);
   every comparison closes by norm_num.  Part B (13 <= t <= 1e8): batch 2. -/
set_option maxSynthPendingDepth 8


/-- t3w_prod t i = ∏_{k <= i} (t^2 + (k + 1/2)^2) = |S_i(t)|^2. -/
def t3w_prod (t : ℝ) (i : ℕ) : ℝ :=
  ∏ k ∈ Finset.range (i + 1), (t ^ 2 + (k + 1 / 2 : ℝ) ^ 2)

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


def t3w_qA1_2 : ℝ := (4983772 : ℝ) / 14114211

def t3w_qA1_4 : ℝ := (1502859194746946382456392547 : ℝ) / 39080966454345923952478521520625

def t3w_qA1_6 : ℝ := (116421237610681507751902027148866967117371242851865631999038676718099 : ℝ) / 848148949534638458986587467545761005268541614173769360528737610758496274625

def t3w_qA1_8 : ℝ := (4673768311994492894219461766745702095382064867279345224670856838556546758433372578 : ℝ) / 520980157116571205745301652688943660996440696736428251805069850816356165658766328125


theorem t3w_qA1 :
    Real.sqrt (t3w_prod (16 / 13) 2) < t3w_qA1_2 ∧
    Real.sqrt (t3w_prod (16 / 13) 4) < t3w_qA1_4 ∧
    Real.sqrt (t3w_prod (16 / 13) 6) < t3w_qA1_6 ∧
    Real.sqrt (t3w_prod (16 / 13) 8) < t3w_qA1_8 := by
  refine ⟨?_, ?_, ?_, ?_⟩
  all_goals exact (Real.sqrt_lt' (by norm_num [t3w_qA1_2, t3w_qA1_4, t3w_qA1_6, t3w_qA1_8])).mpr (by norm_num [t3w_prod, t3w_qA1_2, t3w_qA1_4, t3w_qA1_6, t3w_qA1_8])

def t3w_qA2_2 : ℝ := (1848 : ℝ) / 601

def t3w_qA2_4 : ℝ := (51261935390797 : ℝ) / 4806720364854304

def t3w_qA2_6 : ℝ := (38321091914035790083 : ℝ) / 142156206932330311680

def t3w_qA2_8 : ℝ := (118664095704944357 : ℝ) / 175816752253656248672


theorem t3w_qA2 :
    Real.sqrt (t3w_prod (4) 2) < t3w_qA2_2 ∧
    Real.sqrt (t3w_prod (4) 4) < t3w_qA2_4 ∧
    Real.sqrt (t3w_prod (4) 6) < t3w_qA2_6 ∧
    Real.sqrt (t3w_prod (4) 8) < t3w_qA2_8 := by
  refine ⟨?_, ?_, ?_, ?_⟩
  all_goals exact (Real.sqrt_lt' (by norm_num [t3w_qA2_2, t3w_qA2_4, t3w_qA2_6, t3w_qA2_8])).mpr (by norm_num [t3w_prod, t3w_qA2_2, t3w_qA2_4, t3w_qA2_6, t3w_qA2_8])

def t3w_qA3_2 : ℝ := (1038368 : ℝ) / 100375

def t3w_qA3_4 : ℝ := (308865459811845 : ℝ) / 2827340696980896

def t3w_qA3_6 : ℝ := (125273133965089553 : ℝ) / 78956970802130749440

def t3w_qA3_8 : ℝ := (253032781322650125 : ℝ) / 329540631957371815936


theorem t3w_qA3 :
    Real.sqrt (t3w_prod (8) 2) < t3w_qA3_2 ∧
    Real.sqrt (t3w_prod (8) 4) < t3w_qA3_4 ∧
    Real.sqrt (t3w_prod (8) 6) < t3w_qA3_6 ∧
    Real.sqrt (t3w_prod (8) 8) < t3w_qA3_8 := by
  refine ⟨?_, ?_, ?_, ?_⟩
  all_goals exact (Real.sqrt_lt' (by norm_num [t3w_qA3_2, t3w_qA3_4, t3w_qA3_6, t3w_qA3_8])).mpr (by norm_num [t3w_prod, t3w_qA3_2, t3w_qA3_4, t3w_qA3_6, t3w_qA3_8])

def t3w_qA4_2 : ℝ := (10174728 : ℝ) / 1098505

def t3w_qA4_4 : ℝ := (9260405786968037082572925 : ℝ) / 3453536683734581692029825084157842881

def t3w_qA4_6 : ℝ := (26974492172077878447116878758611338947684799 : ℝ) / 2246822875069249810144953750337536290148726740034515625

def t3w_qA4_8 : ℝ := (3449285309443320744762575001520288 : ℝ) / 2341672835847628839254119201950605753331432373046875000


theorem t3w_qA4 :
    Real.sqrt (t3w_prod (13) 2) < t3w_qA4_2 ∧
    Real.sqrt (t3w_prod (13) 4) < t3w_qA4_4 ∧
    Real.sqrt (t3w_prod (13) 6) < t3w_qA4_6 ∧
    Real.sqrt (t3w_prod (13) 8) < t3w_qA4_8 := by
  refine ⟨?_, ?_, ?_, ?_⟩
  all_goals exact (Real.sqrt_lt' (by norm_num [t3w_qA4_2, t3w_qA4_4, t3w_qA4_6, t3w_qA4_8])).mpr (by norm_num [t3w_prod, t3w_qA4_2, t3w_qA4_4, t3w_qA4_6, t3w_qA4_8])


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
  have hinv2 : (n : ℝ) ^ (-( 7/2 : ℝ)) <= 1 := t3w_invpow_le_one n (by linarith [hnmin]) (7/2) (by norm_num)
  have hinv4 : (n : ℝ) ^ (-( 11/2 : ℝ)) <= 1 := t3w_invpow_le_one n (by linarith [hnmin]) (11/2) (by norm_num)
  have hinv6 : (n : ℝ) ^ (-( 15/2 : ℝ)) <= 1 := t3w_invpow_le_one n (by linarith [hnmin]) (15/2) (by norm_num)
  have hinv8 : (n : ℝ) ^ (-( 15/2 : ℝ)) <= 1 := t3w_invpow_le_one n (by linarith [hnmin]) (15/2) (by norm_num)
  have hT2 : t3w_term n t 2 < t3w_qA1_2 / 720 := by
    calc
      t3w_term n t 2 = Real.sqrt (t3w_prod t 2) * (n : ℝ) ^ (-( 7/2 : ℝ)) / 720 := by
        simp [t3w_term, t3w_p, t3w_d]
      _ <= Real.sqrt (t3w_prod t 2) * (1 : ℝ) / 720 := by
        gcongr
        all_goals (try exact hinv2) <;> (try norm_num)
      _ = Real.sqrt (t3w_prod t 2) / 720 := by ring
      _ < t3w_qA1_2 / 720 := by
        gcongr
        all_goals (try exact hS2) <;> (try norm_num)
  have hT4 : t3w_term n t 4 < t3w_qA1_4 / 30240 := by
    calc
      t3w_term n t 4 = Real.sqrt (t3w_prod t 4) * (n : ℝ) ^ (-( 11/2 : ℝ)) / 30240 := by
        simp [t3w_term, t3w_p, t3w_d]
      _ <= Real.sqrt (t3w_prod t 4) * (1 : ℝ) / 30240 := by
        gcongr
        all_goals (try exact hinv4) <;> (try norm_num)
      _ = Real.sqrt (t3w_prod t 4) / 30240 := by ring
      _ < t3w_qA1_4 / 30240 := by
        gcongr
        all_goals (try exact hS4) <;> (try norm_num)
  have hT6 : t3w_term n t 6 < t3w_qA1_6 / 1209600 := by
    calc
      t3w_term n t 6 = Real.sqrt (t3w_prod t 6) * (n : ℝ) ^ (-( 15/2 : ℝ)) / 1209600 := by
        simp [t3w_term, t3w_p, t3w_d]
      _ <= Real.sqrt (t3w_prod t 6) * (1 : ℝ) / 1209600 := by
        gcongr
        all_goals (try exact hinv6) <;> (try norm_num)
      _ = Real.sqrt (t3w_prod t 6) / 1209600 := by ring
      _ < t3w_qA1_6 / 1209600 := by
        gcongr
        all_goals (try exact hS6) <;> (try norm_num)
  have hT8 : t3w_term n t 8 < t3w_qA1_8 / 9072000 := by
    calc
      t3w_term n t 8 = Real.sqrt (t3w_prod t 8) * (n : ℝ) ^ (-( 15/2 : ℝ)) / 9072000 := by
        simp [t3w_term, t3w_p, t3w_d]
      _ <= Real.sqrt (t3w_prod t 8) * (1 : ℝ) / 9072000 := by
        gcongr
        all_goals (try exact hinv8) <;> (try norm_num)
      _ = Real.sqrt (t3w_prod t 8) / 9072000 := by ring
      _ < t3w_qA1_8 / 9072000 := by
        gcongr
        all_goals (try exact hS8) <;> (try norm_num)
  calc
    t3w_T3UB n t = t3w_term n t 2 + t3w_term n t 4 + t3w_term n t 6 + t3w_term n t 8 := rfl
    _ < t3w_qA1_2 / 720 + t3w_qA1_4 / 30240 + t3w_qA1_6 / 1209600 + t3w_qA1_8 / 9072000 := by
      gcongr <;> (try exact hT2) <;> (try exact hT4) <;> (try exact hT6) <;> (try exact hT8)
    _ < 35 / 78 := by norm_num [t3w_qA1_2, t3w_qA1_4, t3w_qA1_6, t3w_qA1_8]


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
  have hinv2 : (n : ℝ) ^ (-( 7/2 : ℝ)) <= 1 := t3w_invpow_le_one n (by linarith [hnmin]) (7/2) (by norm_num)
  have hinv4 : (n : ℝ) ^ (-( 11/2 : ℝ)) <= 1 := t3w_invpow_le_one n (by linarith [hnmin]) (11/2) (by norm_num)
  have hinv6 : (n : ℝ) ^ (-( 15/2 : ℝ)) <= 1 := t3w_invpow_le_one n (by linarith [hnmin]) (15/2) (by norm_num)
  have hinv8 : (n : ℝ) ^ (-( 15/2 : ℝ)) <= 1 := t3w_invpow_le_one n (by linarith [hnmin]) (15/2) (by norm_num)
  have hT2 : t3w_term n t 2 < t3w_qA2_2 / 720 := by
    calc
      t3w_term n t 2 = Real.sqrt (t3w_prod t 2) * (n : ℝ) ^ (-( 7/2 : ℝ)) / 720 := by
        simp [t3w_term, t3w_p, t3w_d]
      _ <= Real.sqrt (t3w_prod t 2) * (1 : ℝ) / 720 := by
        gcongr
        all_goals (try exact hinv2) <;> (try norm_num)
      _ = Real.sqrt (t3w_prod t 2) / 720 := by ring
      _ < t3w_qA2_2 / 720 := by
        gcongr
        all_goals (try exact hS2) <;> (try norm_num)
  have hT4 : t3w_term n t 4 < t3w_qA2_4 / 30240 := by
    calc
      t3w_term n t 4 = Real.sqrt (t3w_prod t 4) * (n : ℝ) ^ (-( 11/2 : ℝ)) / 30240 := by
        simp [t3w_term, t3w_p, t3w_d]
      _ <= Real.sqrt (t3w_prod t 4) * (1 : ℝ) / 30240 := by
        gcongr
        all_goals (try exact hinv4) <;> (try norm_num)
      _ = Real.sqrt (t3w_prod t 4) / 30240 := by ring
      _ < t3w_qA2_4 / 30240 := by
        gcongr
        all_goals (try exact hS4) <;> (try norm_num)
  have hT6 : t3w_term n t 6 < t3w_qA2_6 / 1209600 := by
    calc
      t3w_term n t 6 = Real.sqrt (t3w_prod t 6) * (n : ℝ) ^ (-( 15/2 : ℝ)) / 1209600 := by
        simp [t3w_term, t3w_p, t3w_d]
      _ <= Real.sqrt (t3w_prod t 6) * (1 : ℝ) / 1209600 := by
        gcongr
        all_goals (try exact hinv6) <;> (try norm_num)
      _ = Real.sqrt (t3w_prod t 6) / 1209600 := by ring
      _ < t3w_qA2_6 / 1209600 := by
        gcongr
        all_goals (try exact hS6) <;> (try norm_num)
  have hT8 : t3w_term n t 8 < t3w_qA2_8 / 9072000 := by
    calc
      t3w_term n t 8 = Real.sqrt (t3w_prod t 8) * (n : ℝ) ^ (-( 15/2 : ℝ)) / 9072000 := by
        simp [t3w_term, t3w_p, t3w_d]
      _ <= Real.sqrt (t3w_prod t 8) * (1 : ℝ) / 9072000 := by
        gcongr
        all_goals (try exact hinv8) <;> (try norm_num)
      _ = Real.sqrt (t3w_prod t 8) / 9072000 := by ring
      _ < t3w_qA2_8 / 9072000 := by
        gcongr
        all_goals (try exact hS8) <;> (try norm_num)
  calc
    t3w_T3UB n t = t3w_term n t 2 + t3w_term n t 4 + t3w_term n t 6 + t3w_term n t 8 := rfl
    _ < t3w_qA2_2 / 720 + t3w_qA2_4 / 30240 + t3w_qA2_6 / 1209600 + t3w_qA2_8 / 9072000 := by
      gcongr <;> (try exact hT2) <;> (try exact hT4) <;> (try exact hT6) <;> (try exact hT8)
    _ < 35 / 234 := by norm_num [t3w_qA2_2, t3w_qA2_4, t3w_qA2_6, t3w_qA2_8]


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
  have hinv2 : (n : ℝ) ^ (-( 7/2 : ℝ)) <= 1 := t3w_invpow_le_one n (by linarith [hnmin]) (7/2) (by norm_num)
  have hinv4 : (n : ℝ) ^ (-( 11/2 : ℝ)) <= 1 := t3w_invpow_le_one n (by linarith [hnmin]) (11/2) (by norm_num)
  have hinv6 : (n : ℝ) ^ (-( 15/2 : ℝ)) <= 1 := t3w_invpow_le_one n (by linarith [hnmin]) (15/2) (by norm_num)
  have hinv8 : (n : ℝ) ^ (-( 15/2 : ℝ)) <= 1 := t3w_invpow_le_one n (by linarith [hnmin]) (15/2) (by norm_num)
  have hT2 : t3w_term n t 2 < t3w_qA3_2 / 720 := by
    calc
      t3w_term n t 2 = Real.sqrt (t3w_prod t 2) * (n : ℝ) ^ (-( 7/2 : ℝ)) / 720 := by
        simp [t3w_term, t3w_p, t3w_d]
      _ <= Real.sqrt (t3w_prod t 2) * (1 : ℝ) / 720 := by
        gcongr
        all_goals (try exact hinv2) <;> (try norm_num)
      _ = Real.sqrt (t3w_prod t 2) / 720 := by ring
      _ < t3w_qA3_2 / 720 := by
        gcongr
        all_goals (try exact hS2) <;> (try norm_num)
  have hT4 : t3w_term n t 4 < t3w_qA3_4 / 30240 := by
    calc
      t3w_term n t 4 = Real.sqrt (t3w_prod t 4) * (n : ℝ) ^ (-( 11/2 : ℝ)) / 30240 := by
        simp [t3w_term, t3w_p, t3w_d]
      _ <= Real.sqrt (t3w_prod t 4) * (1 : ℝ) / 30240 := by
        gcongr
        all_goals (try exact hinv4) <;> (try norm_num)
      _ = Real.sqrt (t3w_prod t 4) / 30240 := by ring
      _ < t3w_qA3_4 / 30240 := by
        gcongr
        all_goals (try exact hS4) <;> (try norm_num)
  have hT6 : t3w_term n t 6 < t3w_qA3_6 / 1209600 := by
    calc
      t3w_term n t 6 = Real.sqrt (t3w_prod t 6) * (n : ℝ) ^ (-( 15/2 : ℝ)) / 1209600 := by
        simp [t3w_term, t3w_p, t3w_d]
      _ <= Real.sqrt (t3w_prod t 6) * (1 : ℝ) / 1209600 := by
        gcongr
        all_goals (try exact hinv6) <;> (try norm_num)
      _ = Real.sqrt (t3w_prod t 6) / 1209600 := by ring
      _ < t3w_qA3_6 / 1209600 := by
        gcongr
        all_goals (try exact hS6) <;> (try norm_num)
  have hT8 : t3w_term n t 8 < t3w_qA3_8 / 9072000 := by
    calc
      t3w_term n t 8 = Real.sqrt (t3w_prod t 8) * (n : ℝ) ^ (-( 15/2 : ℝ)) / 9072000 := by
        simp [t3w_term, t3w_p, t3w_d]
      _ <= Real.sqrt (t3w_prod t 8) * (1 : ℝ) / 9072000 := by
        gcongr
        all_goals (try exact hinv8) <;> (try norm_num)
      _ = Real.sqrt (t3w_prod t 8) / 9072000 := by ring
      _ < t3w_qA3_8 / 9072000 := by
        gcongr
        all_goals (try exact hS8) <;> (try norm_num)
  calc
    t3w_T3UB n t = t3w_term n t 2 + t3w_term n t 4 + t3w_term n t 6 + t3w_term n t 8 := rfl
    _ < t3w_qA3_2 / 720 + t3w_qA3_4 / 30240 + t3w_qA3_6 / 1209600 + t3w_qA3_8 / 9072000 := by
      gcongr <;> (try exact hT2) <;> (try exact hT4) <;> (try exact hT6) <;> (try exact hT8)
    _ < 35 / 312 := by norm_num [t3w_qA3_2, t3w_qA3_4, t3w_qA3_6, t3w_qA3_8]


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
  have hinv2 : (n : ℝ) ^ (-( 7/2 : ℝ)) <= 1 := t3w_invpow_le_one n (by linarith [hnmin]) (7/2) (by norm_num)
  have hinv4 : (n : ℝ) ^ (-( 11/2 : ℝ)) <= 1 := t3w_invpow_le_one n (by linarith [hnmin]) (11/2) (by norm_num)
  have hinv6 : (n : ℝ) ^ (-( 15/2 : ℝ)) <= 1 := t3w_invpow_le_one n (by linarith [hnmin]) (15/2) (by norm_num)
  have hinv8 : (n : ℝ) ^ (-( 15/2 : ℝ)) <= 1 := t3w_invpow_le_one n (by linarith [hnmin]) (15/2) (by norm_num)
  have hT2 : t3w_term n t 2 < t3w_qA4_2 / 720 := by
    calc
      t3w_term n t 2 = Real.sqrt (t3w_prod t 2) * (n : ℝ) ^ (-( 7/2 : ℝ)) / 720 := by
        simp [t3w_term, t3w_p, t3w_d]
      _ <= Real.sqrt (t3w_prod t 2) * (1 : ℝ) / 720 := by
        gcongr
        all_goals (try exact hinv2) <;> (try norm_num)
      _ = Real.sqrt (t3w_prod t 2) / 720 := by ring
      _ < t3w_qA4_2 / 720 := by
        gcongr
        all_goals (try exact hS2) <;> (try norm_num)
  have hT4 : t3w_term n t 4 < t3w_qA4_4 / 30240 := by
    calc
      t3w_term n t 4 = Real.sqrt (t3w_prod t 4) * (n : ℝ) ^ (-( 11/2 : ℝ)) / 30240 := by
        simp [t3w_term, t3w_p, t3w_d]
      _ <= Real.sqrt (t3w_prod t 4) * (1 : ℝ) / 30240 := by
        gcongr
        all_goals (try exact hinv4) <;> (try norm_num)
      _ = Real.sqrt (t3w_prod t 4) / 30240 := by ring
      _ < t3w_qA4_4 / 30240 := by
        gcongr
        all_goals (try exact hS4) <;> (try norm_num)
  have hT6 : t3w_term n t 6 < t3w_qA4_6 / 1209600 := by
    calc
      t3w_term n t 6 = Real.sqrt (t3w_prod t 6) * (n : ℝ) ^ (-( 15/2 : ℝ)) / 1209600 := by
        simp [t3w_term, t3w_p, t3w_d]
      _ <= Real.sqrt (t3w_prod t 6) * (1 : ℝ) / 1209600 := by
        gcongr
        all_goals (try exact hinv6) <;> (try norm_num)
      _ = Real.sqrt (t3w_prod t 6) / 1209600 := by ring
      _ < t3w_qA4_6 / 1209600 := by
        gcongr
        all_goals (try exact hS6) <;> (try norm_num)
  have hT8 : t3w_term n t 8 < t3w_qA4_8 / 9072000 := by
    calc
      t3w_term n t 8 = Real.sqrt (t3w_prod t 8) * (n : ℝ) ^ (-( 15/2 : ℝ)) / 9072000 := by
        simp [t3w_term, t3w_p, t3w_d]
      _ <= Real.sqrt (t3w_prod t 8) * (1 : ℝ) / 9072000 := by
        gcongr
        all_goals (try exact hinv8) <;> (try norm_num)
      _ = Real.sqrt (t3w_prod t 8) / 9072000 := by ring
      _ < t3w_qA4_8 / 9072000 := by
        gcongr
        all_goals (try exact hS8) <;> (try norm_num)
  calc
    t3w_T3UB n t = t3w_term n t 2 + t3w_term n t 4 + t3w_term n t 6 + t3w_term n t 8 := rfl
    _ < t3w_qA4_2 / 720 + t3w_qA4_4 / 30240 + t3w_qA4_6 / 1209600 + t3w_qA4_8 / 9072000 := by
      gcongr <;> (try exact hT2) <;> (try exact hT4) <;> (try exact hT6) <;> (try exact hT8)
    _ < 35 / 390 := by norm_num [t3w_qA4_2, t3w_qA4_4, t3w_qA4_6, t3w_qA4_8]
