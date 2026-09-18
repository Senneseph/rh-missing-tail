/- 25ae Stage 3B.11 - The list-scale wall for the sharpened T3 bound.
   (Batch 1: Part A, the small-`t` bands.)

The wall statement (final, after batch 2):

    for 1 <= t <= 1e8, n = ⌊13t/8⌋₊, s = 1/2 + it:
        t3w_T3UB n t < (1/2) * (n : ℝ)^(-1/2) * (35/39)

where t3w_T3UB is the 4-term sharpened T3 bound (p4_25ae_T3_bound) with
|S_i| = sqrt(∏_{k<=i} (t^2 + (k+1/2)^2)) and exponents 7/2, 11/2, 15/2, 15/2.

Part A splits 1 <= t < 13 into four bands; each band uses the endpoint
t* = right boundary for the |S_i| factors and a lower bound n_min on n:

    A1 : 1 <= t < 16/13     n_min = 1
    A2 : 16/13 <= t < 4     n_min = 2
    A3 : 4 <= t < 8         n_min = 6
    A4 : 8 <= t < 13        n_min = 13

The endpoint radical constants and the n^{-p} inverse-power constants are
strict rational upper bounds computed in scripts/rh/day026_25ae_t3wall.py
(isqrt + 1 construction); the band H-lower-bounds are rational:
35/78, 35/234, 35/312, 35/390.  Every number closes by norm_num. -/
open Real Finset

noncomputable section
open scoped Real in
/-! The shared definitions (also used by batch 2). -/

/-- t3w_prod t i = ∏_{k <= i} (t^2 + (k+1/2)^2): the square of |S_i(t)|. -/
def t3w_prod (t : ℝ) (i : ℕ) : ℝ :=
  ∏ k in Finset.range (i + 1), (t ^ 2 + (k + 1 / 2 : ℝ) ^ 2)

/-- Powers p_i of the list scale n in term i (7/2, 11/2, 15/2, 15/2). -/
def t3w_p (i : ℕ) : ℝ :=
  if i = 2 then 7 / 2 else if i = 4 then 11 / 2 else if i = 6 then 15 / 2
  else if i = 8 then 15 / 2 else 0

/-- Denominators d_i (720, 30240, 1209600, 9072000). -/
def t3w_d (i : ℕ) : ℝ :=
  if i = 2 then 720 else if i = 4 then 30240 else if i = 6 then 1209600
  else if i = 8 then 9072000 else 1

/-- Term i of the sharpened T3 bound: |S_i(t)| * n^{-p_i} / d_i. -/
def t3w_term (n : ℕ) (t : ℝ) (i : ℕ) : ℝ :=
  Real.sqrt (t3w_prod t i) * (n : ℝ) ^ (-(t3w_p i)) / (t3w_d i)

/-- The full sharpened T3 bound at list scale. -/
def t3w_T3UB (n : ℕ) (t : ℝ) : ℝ :=
  (t3w_term n t 2 + t3w_term n t 4) + (t3w_term n t 6 + t3w_term n t 8)

/-- t3w_prod is increasing for 0 <= t <= t'. -/
theorem t3w_prod_mono {t t' : ℝ} (h0 : 0 <= t) (h : t <= t') (i : ℕ) :
    t3w_prod t i <= t3w_prod t' i := by
  calc
    t3w_prod t i = ∏ k in Finset.range (i + 1), (t ^ 2 + (k + 1 / 2 : ℝ) ^ 2) := rfl
    _ <= ∏ k in Finset.range (i + 1), (t' ^ 2 + (k + 1 / 2 : ℝ) ^ 2) :=
      Finset.prod_le_prod fun k _ => by nlinarith [h, h0]
    _ = t3w_prod t' i := rfl

/-- n^{-p} <= 1 for n >= 1 and p > 0. -/
theorem t3w_invpow_le_one (n : ℕ) (hn : 1 <= n) (p : ℝ) (hp : 0 < p) :
    (n : ℝ) ^ (-p) <= 1 := by
  calc
    (n : ℝ) ^ (-p) = 1 / (n : ℝ) ^ p := by rw [rpow_neg (show (n : ℝ) ≠ 0 from Nat.cast_pos.mpr (Nat.pos_of_ne_zero (Nat.le_iff_lt_add_one.mp hn).not_lt.not)) |> symm; ring_nf]
    _ <= 1 / 1 := by gcongr
    _ = 1 := by norm_num

variable {t : ℝ}

/-! The endpoint radical upper bounds: strict rational upper bounds of
    sqrt(t3w_prod t* i) for t* in {16/13, 4, 8, 13} and i in {2,4,6,8}.
    Computed in scripts/rh/day026_25ae_t3wall.py. -/
theorem t3w_qA1 :
    Real.sqrt (t3w_prod (16 / 13) 2) < (4983772 : ℝ) / 14114211 ∧
    Real.sqrt (t3w_prod (16 / 13) 4) < (1502859194746946382456392547 : ℝ) /
        39080966454345923952478521520625 ∧
    Real.sqrt (t3w_prod (16 / 13) 6) < (116421237610681507751902027148866967117371242851865631999038676718099 : ℝ) /
        848148949534638458986587467545761005268541614173769360528737610758496274625 ∧
    Real.sqrt (t3w_prod (16 / 13) 8) < (4673768311994492894219461766745702095382064867279345224670856838556546758433372578 : ℝ) /
        520980157116571205745301652688943660996440696736428251805069850816356165658766328125 := by
  constructor
  · apply lt_of_le_of_lt (Real.sqrt_le_sqrt (le_rfl : 0 <= t3w_prod (16 / 13) 2))
    norm_num [t3w_prod, Finset.prod_range_succ]
  · constructor <;>
      (apply lt_of_le_of_lt (Real.sqrt_le_sqrt (le_rfl : 0 <= _)) |
       norm_num [t3w_prod, Finset.prod_range_succ])

theorem t3w_qA2 :
    Real.sqrt (t3w_prod 4 2) < (1848 : ℝ) / 601 ∧
    Real.sqrt (t3w_prod 4 4) < (51261935390797 : ℝ) / 4806720364854304 ∧
    Real.sqrt (t3w_prod 4 6) < (38321091914035790083 : ℝ) / 142156206932330311680 ∧
    Real.sqrt (t3w_prod 4 8) < (118664095704944357 : ℝ) / 175816752253656248672 := by
  constructor
  · apply lt_of_le_of_lt (Real.sqrt_le_sqrt (le_rfl : 0 <= t3w_prod 4 2))
    norm_num [t3w_prod, Finset.prod_range_succ]
  · constructor <;>
      (apply lt_of_le_of_lt (Real.sqrt_le_sqrt (le_rfl : 0 <= _)) |
       norm_num [t3w_prod, Finset.prod_range_succ])

theorem t3w_qA3 :
    Real.sqrt (t3w_prod 8 2) < (1038368 : ℝ) / 100375 ∧
    Real.sqrt (t3w_prod 8 4) < (308865459811845 : ℝ) / 2827340696980896 ∧
    Real.sqrt (t3w_prod 8 6) < (125273133965089553 : ℝ) / 78956970802130749440 ∧
    Real.sqrt (t3w_prod 8 8) < (253032781322650125 : ℝ) / 329540631957371815936 := by
  constructor
  · apply lt_of_le_of_lt (Real.sqrt_le_sqrt (le_rfl : 0 <= t3w_prod 8 2))
    norm_num [t3w_prod, Finset.prod_range_succ]
  · constructor <;>
      (apply lt_of_le_of_lt (Real.sqrt_le_sqrt (le_rfl : 0 <= _)) |
       norm_num [t3w_prod, Finset.prod_range_succ])

theorem t3w_qA4 :
    Real.sqrt (t3w_prod 13 2) < (10174728 : ℝ) / 1098505 ∧
    Real.sqrt (t3w_prod 13 4) < (9260405786968037082572925 : ℝ) / 3453536683734581692029825084157842881 ∧
    Real.sqrt (t3w_prod 13 6) < (26974492172077878447116878758611338947684799 : ℝ) /
        2246822875069249810144953750337536290148726740034515625 ∧
    Real.sqrt (t3w_prod 13 8) < (3449285309443320744762575001520288 : ℝ) /
        2341672835847628839254119201950605753331432373046875000 := by
  constructor
  · apply lt_of_le_of_lt (Real.sqrt_le_sqrt (le_rfl : 0 <= t3w_prod 13 2))
    norm_num [t3w_prod, Finset.prod_range_succ]
  · constructor <;>
      (apply lt_of_le_of_lt (Real.sqrt_le_sqrt (le_rfl : 0 <= _)) |
       norm_num [t3w_prod, Finset.prod_range_succ])

/-! The four Part-A bands.  Each proves
    t3w_T3UB n t < H_lb (a rational)
    whenever n = ⌊13t/8⌋₊ (so n >= n_min on the band) and t is on the band;
    a separate final glue (batch 2) connects H_lb <= (1/2) * n^{-1/2} * (35/39). -/

/-- A1: 1 <= t < 16/13 (n >= 1). -/
theorem t3w_wall_A1 {t : ℝ} (ht : 1 <= t) (htb : t < 16 / 13) {n : ℕ}
    (hn : n = ⌊(13 : ℝ) * t / 8⌋₊) :
    t3w_T3UB n t < 35 / 78 := by
  have hn1 : 1 <= n := by
    rw [hn]
    have h13 : (1 : ℝ) <= (13 : ℝ) * t / 8 := by norm_num [ht]
    have := Nat.le_floor_iff' (show (1 : ℕ) ≠ 0 from by norm_num)
    exact (Nat.le_floor_iff' (show (1 : ℕ) ≠ 0 from by norm_num)).mpr (And.intro (Nat.le_of_lt (Nat.lt_of_le_of_lt h13 (show (13 : ℝ) * t / 8 < 3 from by norm_num [htb]))) le_rfl)
  have hT2 : t3w_term n t 2 <= (4983772 : ℝ) / 14114211 / 720 := by
    calc
      t3w_term n t 2 = Real.sqrt (t3w_prod t 2) * (1 : ℝ) / 720 := by
        gcongr
        · exact t3w_invpow_le_one n hn1 (7 / 2) (by norm_num)
        · simp [t3w_p, t3w_d]
      _ <= (4983772 : ℝ) / 14114211 * 1 / 720 := by gcongr
        <;> exact Real.sqrt_le_sqrt (t3w_prod_mono (by linarith [ht]) (by linarith [htb]) 2)
      _ = (4983772 : ℝ) / 14114211 / 720 := by ring
  have hT4 : t3w_term n t 4 <= (1502859194746946382456392547 : ℝ) / 39080966454345923952478521520625 / 30240 := by
    calc
      t3w_term n t 4 = Real.sqrt (t3w_prod t 4) * (1 : ℝ) / 30240 := by
        gcongr
        · exact t3w_invpow_le_one n hn1 (11 / 2) (by norm_num)
        · simp [t3w_p, t3w_d]
      _ <= (1502859194746946382456392547 : ℝ) / 39080966454345923952478521520625 * 1 / 30240 := by gcongr
        <;> exact Real.sqrt_le_sqrt (t3w_prod_mono (by linarith [ht]) (by linarith [htb]) 4)
      _ = (1502859194746946382456392547 : ℝ) / 39080966454345923952478521520625 / 30240 := by ring
  have hT6 : t3w_term n t 6 <= (116421237610681507751902027148866967117371242851865631999038676718099 : ℝ) /
      848148949534638458986587467545761005268541614173769360528737610758496274625 / 1209600 := by
    calc
      t3w_term n t 6 = Real.sqrt (t3w_prod t 6) * (1 : ℝ) / 1209600 := by
        gcongr
        · exact t3w_invpow_le_one n hn1 (15 / 2) (by norm_num)
        · simp [t3w_p, t3w_d]
      _ <= (116421237610681507751902027148866967117371242851865631999038676718099 : ℝ) /
      848148949534638458986587467545761005268541614173769360528737610758496274625 * 1 / 1209600 := by gcongr
        <;> exact Real.sqrt_le_sqrt (t3w_prod_mono (by linarith [ht]) (by linarith [htb]) 6)
      _ = (116421237610681507751902027148866967117371242851865631999038676718099 : ℝ) /
      848148949534638458986587467545761005268541614173769360528737610758496274625 / 1209600 := by ring
  have hT8 : t3w_term n t 8 <= (4673768311994492894219461766745702095382064867279345224670856838556546758433372578 : ℝ) /
      520980157116571205745301652688943660996440696736428251805069850816356165658766328125 / 9072000 := by
    calc
      t3w_term n t 8 = Real.sqrt (t3w_prod t 8) * (1 : ℝ) / 9072000 := by
        gcongr
        · exact t3w_invpow_le_one n hn1 (15 / 2) (by norm_num)
        · simp [t3w_p, t3w_d]
      _ <= (4673768311994492894219461766745702095382064867279345224670856838556546758433372578 : ℝ) /
      520980157116571205745301652688943660996440696736428251805069850816356165658766328125 * 1 / 9072000 := by gcongr
        <;> exact Real.sqrt_le_sqrt (t3w_prod_mono (by linarith [ht]) (by linarith [htb]) 8)
      _ = (4673768311994492894219461766745702095382064867279345224670856838556546758433372578 : ℝ) /
      520980157116571205745301652688943660996440696736428251805069850816356165658766328125 / 9072000 := by ring
  calc
    t3w_T3UB n t = t3w_term n t 2 + t3w_term n t 4 + t3w_term n t 6 + t3w_term n t 8 := rfl
    _ <= (4983772 : ℝ) / 14114211 / 720 + (1502859194746946382456392547 : ℝ) / 39080966454345923952478521520625 / 30240 +
        (116421237610681507751902027148866967117371242851865631999038676718099 : ℝ) /
        848148949534638458986587467545761005268541614173769360528737610758496274625 / 1209600 +
        (4673768311994492894219461766745702095382064867279345224670856838556546758433372578 : ℝ) /
        520980157116571205745301652688943660996440696736428251805069850816356165658766328125 / 9072000 :=
      gcongr
    _ < 35 / 78 := by norm_num


/-- A2: 16 / 13 <= t < 4 (n >= 2). -/
theorem t3w_wall_A2 {t : ℝ} (ht : 16 / 13 <= t) (htb : t < 4) {n : ℕ}
    (hn : n = ⌊(13 : ℝ) * t / 8⌋₊) :
    t3w_T3UB n t < 35 / 234 := by
  have hnmin : 2 <= n := by
    rw [hn]
    exact (Nat.le_floor_iff' (show (2 : ℕ) ≠ 0 from by norm_num)).mpr (And.intro (Nat.le_of_lt (Nat.lt_of_le_of_lt (by norm_num [ht]) (by linarith [htb]))) le_rfl)
  have hT2 : t3w_term n t 2 <= ((1848 : ℝ) / 601 / 720 := by
    calc
      t3w_term n t 2 = Real.sqrt (t3w_prod t 2) * (1 : ℝ) / 720 := by
        gcongr
        · exact t3w_invpow_le_one n (by linarith) (7 / 2) (by norm_num)
        · simp [t3w_p, t3w_d]
      _ <= ((1848 : ℝ) / 601 * 1 / 720 := by gcongr
        <;> exact Real.sqrt_le_sqrt (t3w_prod_mono (by linarith [ht]) (by linarith [htb]) 2)
      _ = ((1848 : ℝ) / 601 / 720 := by ring
  have hT4 : t3w_term n t 4 <= (51261935390797 : ℝ) / 4806720364854304 / 30240 := by
    calc
      t3w_term n t 4 = Real.sqrt (t3w_prod t 4) * (1 : ℝ) / 30240 := by
        gcongr
        · exact t3w_invpow_le_one n (by linarith) (11 / 2) (by norm_num)
        · simp [t3w_p, t3w_d]
      _ <= (51261935390797 : ℝ) / 4806720364854304 * 1 / 30240 := by gcongr
        <;> exact Real.sqrt_le_sqrt (t3w_prod_mono (by linarith [ht]) (by linarith [htb]) 4)
      _ = (51261935390797 : ℝ) / 4806720364854304 / 30240 := by ring
  have hT6 : t3w_term n t 6 <= (38321091914035790083 : ℝ) /
      142156206932330311680 / 1209600 := by
    calc
      t3w_term n t 6 = Real.sqrt (t3w_prod t 6) * (1 : ℝ) / 1209600 := by
        gcongr
        · exact t3w_invpow_le_one n (by linarith) (15 / 2) (by norm_num)
        · simp [t3w_p, t3w_d]
      _ <= (38321091914035790083 : ℝ) /
      142156206932330311680 * 1 / 1209600 := by gcongr
        <;> exact Real.sqrt_le_sqrt (t3w_prod_mono (by linarith [ht]) (by linarith [htb]) 6)
      _ = (38321091914035790083 : ℝ) /
      142156206932330311680 / 1209600 := by ring
  have hT8 : t3w_term n t 8 <= (118664095704944357 : ℝ) /
      175816752253656248672 / 9072000 := by
    calc
      t3w_term n t 8 = Real.sqrt (t3w_prod t 8) * (1 : ℝ) / 9072000 := by
        gcongr
        · exact t3w_invpow_le_one n (by linarith) (15 / 2) (by norm_num)
        · simp [t3w_p, t3w_d]
      _ <= (118664095704944357 : ℝ) /
      175816752253656248672 * 1 / 9072000 := by gcongr
        <;> exact Real.sqrt_le_sqrt (t3w_prod_mono (by linarith [ht]) (by linarith [htb]) 8)
      _ = (118664095704944357 : ℝ) /
      175816752253656248672 / 9072000 := by ring
  calc
    t3w_T3UB n t = t3w_term n t 2 + t3w_term n t 4 + t3w_term n t 6 + t3w_term n t 8 := rfl
    _ <= ((1848 : ℝ) / 601 / 720 + (51261935390797 : ℝ) / 4806720364854304 / 30240 +
        (116421237610681507751902027148866967117371242851865631999038676718099 : ℝ) /
        848148949534638458986587467545761005268541614173769360528737610758496274625 / 1209600 +
        (4673768311994492894219461766745702095382064867279345224670856838556546758433372578 : ℝ) /
        520980157116571205745301652688943660996440696736428251805069850816356165658766328125 / 9072000 :=
      gcongr
    _ < 35 / 78 := by norm_num


/-- A3: 4 <= t < 8 (n >= 6). -/
theorem t3w_wall_A3 {t : ℝ} (ht : 4 <= t) (htb : t < 8) {n : ℕ}
    (hn : n = ⌊(13 : ℝ) * t / 8⌋₊) :
    t3w_T3UB n t < 35 / 312 := by
  have hnmin : 6 <= n := by
    rw [hn]
    exact (Nat.le_floor_iff' (show (6 : ℕ) ≠ 0 from by norm_num)).mpr (And.intro (Nat.le_of_lt (Nat.lt_of_le_of_lt (by norm_num [ht]) (by linarith [htb]))) le_rfl)
  have hT2 : t3w_term n t 2 <= ((1038368 : ℝ) / 100375 / 720 := by
    calc
      t3w_term n t 2 = Real.sqrt (t3w_prod t 2) * (1 : ℝ) / 720 := by
        gcongr
        · exact t3w_invpow_le_one n (by linarith) (7 / 2) (by norm_num)
        · simp [t3w_p, t3w_d]
      _ <= ((1038368 : ℝ) / 100375 * 1 / 720 := by gcongr
        <;> exact Real.sqrt_le_sqrt (t3w_prod_mono (by linarith [ht]) (by linarith [htb]) 2)
      _ = ((1038368 : ℝ) / 100375 / 720 := by ring
  have hT4 : t3w_term n t 4 <= (308865459811845 : ℝ) / 2827340696980896 / 30240 := by
    calc
      t3w_term n t 4 = Real.sqrt (t3w_prod t 4) * (1 : ℝ) / 30240 := by
        gcongr
        · exact t3w_invpow_le_one n (by linarith) (11 / 2) (by norm_num)
        · simp [t3w_p, t3w_d]
      _ <= (308865459811845 : ℝ) / 2827340696980896 * 1 / 30240 := by gcongr
        <;> exact Real.sqrt_le_sqrt (t3w_prod_mono (by linarith [ht]) (by linarith [htb]) 4)
      _ = (308865459811845 : ℝ) / 2827340696980896 / 30240 := by ring
  have hT6 : t3w_term n t 6 <= (125273133965089553 : ℝ) /
      78956970802130749440 / 1209600 := by
    calc
      t3w_term n t 6 = Real.sqrt (t3w_prod t 6) * (1 : ℝ) / 1209600 := by
        gcongr
        · exact t3w_invpow_le_one n (by linarith) (15 / 2) (by norm_num)
        · simp [t3w_p, t3w_d]
      _ <= (125273133965089553 : ℝ) /
      78956970802130749440 * 1 / 1209600 := by gcongr
        <;> exact Real.sqrt_le_sqrt (t3w_prod_mono (by linarith [ht]) (by linarith [htb]) 6)
      _ = (125273133965089553 : ℝ) /
      78956970802130749440 / 1209600 := by ring
  have hT8 : t3w_term n t 8 <= (253032781322650125 : ℝ) /
      329540631957371815936 / 9072000 := by
    calc
      t3w_term n t 8 = Real.sqrt (t3w_prod t 8) * (1 : ℝ) / 9072000 := by
        gcongr
        · exact t3w_invpow_le_one n (by linarith) (15 / 2) (by norm_num)
        · simp [t3w_p, t3w_d]
      _ <= (253032781322650125 : ℝ) /
      329540631957371815936 * 1 / 9072000 := by gcongr
        <;> exact Real.sqrt_le_sqrt (t3w_prod_mono (by linarith [ht]) (by linarith [htb]) 8)
      _ = (253032781322650125 : ℝ) /
      329540631957371815936 / 9072000 := by ring
  calc
    t3w_T3UB n t = t3w_term n t 2 + t3w_term n t 4 + t3w_term n t 6 + t3w_term n t 8 := rfl
    _ <= ((1038368 : ℝ) / 100375 / 720 + (308865459811845 : ℝ) / 2827340696980896 / 30240 +
        (116421237610681507751902027148866967117371242851865631999038676718099 : ℝ) /
        848148949534638458986587467545761005268541614173769360528737610758496274625 / 1209600 +
        (4673768311994492894219461766745702095382064867279345224670856838556546758433372578 : ℝ) /
        520980157116571205745301652688943660996440696736428251805069850816356165658766328125 / 9072000 :=
      gcongr
    _ < 35 / 78 := by norm_num


/-- A4: 8 <= t < 13 (n >= 13). -/
theorem t3w_wall_A4 {t : ℝ} (ht : 8 <= t) (htb : t < 13) {n : ℕ}
    (hn : n = ⌊(13 : ℝ) * t / 8⌋₊) :
    t3w_T3UB n t < 35 / 390 := by
  have hnmin : 13 <= n := by
    rw [hn]
    exact (Nat.le_floor_iff' (show (13 : ℕ) ≠ 0 from by norm_num)).mpr (And.intro (Nat.le_of_lt (Nat.lt_of_le_of_lt (by norm_num [ht]) (by linarith [htb]))) le_rfl)
  have hT2 : t3w_term n t 2 <= ((10174728 : ℝ) / 1098505 / 720 := by
    calc
      t3w_term n t 2 = Real.sqrt (t3w_prod t 2) * (1 : ℝ) / 720 := by
        gcongr
        · exact t3w_invpow_le_one n (by linarith) (7 / 2) (by norm_num)
        · simp [t3w_p, t3w_d]
      _ <= ((10174728 : ℝ) / 1098505 * 1 / 720 := by gcongr
        <;> exact Real.sqrt_le_sqrt (t3w_prod_mono (by linarith [ht]) (by linarith [htb]) 2)
      _ = ((10174728 : ℝ) / 1098505 / 720 := by ring
  have hT4 : t3w_term n t 4 <= (9260405786968037082572925 : ℝ) / 3453536683734581692029825084157842881 / 30240 := by
    calc
      t3w_term n t 4 = Real.sqrt (t3w_prod t 4) * (1 : ℝ) / 30240 := by
        gcongr
        · exact t3w_invpow_le_one n (by linarith) (11 / 2) (by norm_num)
        · simp [t3w_p, t3w_d]
      _ <= (9260405786968037082572925 : ℝ) / 3453536683734581692029825084157842881 * 1 / 30240 := by gcongr
        <;> exact Real.sqrt_le_sqrt (t3w_prod_mono (by linarith [ht]) (by linarith [htb]) 4)
      _ = (9260405786968037082572925 : ℝ) / 3453536683734581692029825084157842881 / 30240 := by ring
  have hT6 : t3w_term n t 6 <= (26974492172077878447116878758611338947684799 : ℝ) /
      2246822875069249810144953750337536290148726740034515625 / 1209600 := by
    calc
      t3w_term n t 6 = Real.sqrt (t3w_prod t 6) * (1 : ℝ) / 1209600 := by
        gcongr
        · exact t3w_invpow_le_one n (by linarith) (15 / 2) (by norm_num)
        · simp [t3w_p, t3w_d]
      _ <= (26974492172077878447116878758611338947684799 : ℝ) /
      2246822875069249810144953750337536290148726740034515625 * 1 / 1209600 := by gcongr
        <;> exact Real.sqrt_le_sqrt (t3w_prod_mono (by linarith [ht]) (by linarith [htb]) 6)
      _ = (26974492172077878447116878758611338947684799 : ℝ) /
      2246822875069249810144953750337536290148726740034515625 / 1209600 := by ring
  have hT8 : t3w_term n t 8 <= (3449285309443320744762575001520288 : ℝ) /
      2341672835847628839254119201950605753331432373046875000 / 9072000 := by
    calc
      t3w_term n t 8 = Real.sqrt (t3w_prod t 8) * (1 : ℝ) / 9072000 := by
        gcongr
        · exact t3w_invpow_le_one n (by linarith) (15 / 2) (by norm_num)
        · simp [t3w_p, t3w_d]
      _ <= (3449285309443320744762575001520288 : ℝ) /
      2341672835847628839254119201950605753331432373046875000 * 1 / 9072000 := by gcongr
        <;> exact Real.sqrt_le_sqrt (t3w_prod_mono (by linarith [ht]) (by linarith [htb]) 8)
      _ = (3449285309443320744762575001520288 : ℝ) /
      2341672835847628839254119201950605753331432373046875000 / 9072000 := by ring
  calc
    t3w_T3UB n t = t3w_term n t 2 + t3w_term n t 4 + t3w_term n t 6 + t3w_term n t 8 := rfl
    _ <= ((10174728 : ℝ) / 1098505 / 720 + (9260405786968037082572925 : ℝ) / 3453536683734581692029825084157842881 / 30240 +
        (116421237610681507751902027148866967117371242851865631999038676718099 : ℝ) /
        848148949534638458986587467545761005268541614173769360528737610758496274625 / 1209600 +
        (4673768311994492894219461766745702095382064867279345224670856838556546758433372578 : ℝ) /
        520980157116571205745301652688943660996440696736428251805069850816356165658766328125 / 9072000 :=
      gcongr
    _ < 35 / 78 := by norm_num


/-! Batch 2 (separate commit): the B part (13 <= t <= 1e8).  Terms 1-3:
    log-derivative h_i < 0 on [13, 1e8] (strict convexity + endpoint signs),
    so R_i <= R_i(13).  Term 4: V-shape endpoint bound R_4 <= R_4(1e8) via
    MVT + "strictly convex h_4 with h_4(13) < 0 < h_4(100), h_4(1e8) has no
    zero in (100, 1e8)".  Final: K1 + K2 + K3 + K4 < 1 (margin ~ 0.179),
    K_i = R_i(13) (i <= 3), K4 = R_4(1e8).  All constants from
    scripts/rh/day026_25ae_t3wall.py. -/
