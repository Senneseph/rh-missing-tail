
/-- log 124000000 < 19. -/
lemma st_logB_anchor : Real.log 124000000 < 19 := by
  have heq : (e_d9 : ℝ) ^ (19 : ℝ) = (27182818283 : ℝ) ^ (19 : ℝ) / (10 ^ 10 : ℝ) ^ (19 : ℝ) := by
    rw [show (e_d9 : ℝ) = (27182818283 : ℝ) / (10 ^ 10 : ℝ) from by norm_num [e_d9],
        Real.div_rpow (by norm_num : (0 : ℝ) ≤ 27182818283) (by norm_num : (0 : ℝ) ≤ 10 ^ 10)]
  have hA : (124000000 : ℝ) ≤ (e_d9 : ℝ) ^ 19 := by
    have hA' : (124000000 : ℝ) ≤ (e_d9 : ℝ) ^ (19 : ℝ) := by
      rw [heq]
      have hden : 0 < (10 ^ 10 : ℝ) ^ (19 : ℝ) :=
        Real.rpow_pos_of_pos (by norm_num : (0 : ℝ) < 10 ^ 10) 19
      rw [le_div_iff₀ hden]
      have hn : (10 ^ 10 : ℝ) ^ (19 : ℝ) = (10 ^ 10 : ℝ) ^ 19 := by norm_num
      rw [hn]
      nlinarith [st_ed9_19]
    have hnum : (e_d9 : ℝ) ^ 19 = (e_d9 : ℝ) ^ (19 : ℝ) := by norm_num
    simpa [hnum] using hA'
  have hB : (e_d9 : ℝ) ^ 19 < Real.exp 19 := by
    calc (e_d9 : ℝ) ^ 19 < (Real.exp 1) ^ 19 :=
        pow_lt_pow_left₀ st_ed9_lt_e (by norm_num [e_d9] : (0 : ℝ) ≤ e_d9) (by norm_num : (19 : ℕ) ≠ 0)
      _ = Real.exp 19 := exp_one_pow 19
  calc Real.log 124000000 ≤ Real.log ((e_d9 : ℝ) ^ 19) :=
      Real.log_le_log (by norm_num : (0 : ℝ) < 124000000) hA
    _ < Real.log (Real.exp 19) :=
      Real.log_lt_log (pow_pos (by norm_num [e_d9] : (0 : ℝ) < e_d9) 19) hB
    _ = (19 : ℝ) := Real.log_exp 19

/-- log 62000000 < 19 (transitivity: 62000000 < 124000000). -/
lemma st_logG_anchor : Real.log 62000000 < 19 := by
  have hlt : Real.log 62000000 < Real.log 124000000 :=
    Real.log_lt_log (by norm_num : (0 : ℝ) < 62000000) (by norm_num)
  linarith [st_logB_anchor]

/-- 0 < log (B4 t) for t >= 1000. -/
lemma st_logB_pos (t : ℝ) (ht : 1000 ≤ t) : 0 < Real.log (B4 t) := by
  have hB4 : (1 : ℝ) < B4 t := by
    dsimp only [B4]
    have ht4 : (1 : ℝ) ^ 4 ≤ t ^ 4 :=
      pow_le_pow_left₀ (by norm_num : (0 : ℝ) ≤ 1) (by linarith : 1 ≤ t) 4
    nlinarith [ht4, show (1 : ℝ) ≤ 124000000 from by norm_num]
  exact Real.log_pos hB4

/-- log (B4 t) < 19 + 4 log t. -/
lemma st_B4log (t : ℝ) (ht : 1000 ≤ t) : Real.log (B4 t) < 19 + 4 * Real.log t := by
  have ht0 : 0 < t := st_tpos t ht
  have ht4 : 0 < t ^ 4 := pow_pos ht0 4
  have hL4 : Real.log (t ^ 4) = 4 * Real.log t := by
    rw [Real.log_pow t 4]
    ring
  calc Real.log (B4 t) = Real.log (124000000 * t ^ 4) := by dsimp only [B4]
    _ = Real.log 124000000 + Real.log (t ^ 4) :=
        Real.log_mul (by norm_num : (124000000 : ℝ) ≠ 0) ht4.ne'
    _ = Real.log 124000000 + 4 * Real.log t := by rw [hL4]
    _ < 19 + 4 * Real.log t := by linarith [st_logB_anchor]

/-- 0 < log (G4 t) for t >= 1000. -/
lemma st_logG_pos (t : ℝ) (ht : 1000 ≤ t) : 0 < Real.log (G4 t) := by
  have hG4 : (1 : ℝ) < G4 t := by
    dsimp only [G4]
    have ht4 : (1 : ℝ) ^ 4 ≤ t ^ 4 :=
      pow_le_pow_left₀ (by norm_num : (0 : ℝ) ≤ 1) (by linarith : 1 ≤ t) 4
    nlinarith [ht4, show (1 : ℝ) ≤ 62000000 from by norm_num]
  exact Real.log_pos hG4

/-- log (G4 t) < 19 + 4 log t. -/
lemma st_G4log (t : ℝ) (ht : 1000 ≤ t) : Real.log (G4 t) < 19 + 4 * Real.log t := by
  have ht0 : 0 < t := st_tpos t ht
  have ht4 : 0 < t ^ 4 := pow_pos ht0 4
  have hL4 : Real.log (t ^ 4) = 4 * Real.log t := by
    rw [Real.log_pow t 4]
    ring
  calc Real.log (G4 t) = Real.log (62000000 * t ^ 4) := by dsimp only [G4]
    _ = Real.log 62000000 + Real.log (t ^ 4) :=
        Real.log_mul (by norm_num : (62000000 : ℝ) ≠ 0) ht4.ne'
    _ = Real.log 62000000 + 4 * Real.log t := by rw [hL4]
    _ < 19 + 4 * Real.log t := by linarith [st_logG_anchor]

/-- log (19 + 4L) <= 18 + 4L for L >= 0 (log x <= x - 1). -/
lemma st_log19L (L : ℝ) (hL0 : 0 ≤ L) : Real.log (19 + 4 * L) ≤ 18 + 4 * L := by
  have hpos : 0 < 19 + 4 * L := by nlinarith
  have hlm1 : Real.log (19 + 4 * L) ≤ (19 + 4 * L) - 1 :=
    Real.log_le_sub_one_of_pos hpos
  convert hlm1 using 1
  ring

/-- (S4) Sbar(B4 t) + Sbar(G4 t) <= 20 + 4 log t. -/
lemma st_hSsum (t : ℝ) (ht : 1000 ≤ t) : Sbar (B4 t) + Sbar (G4 t) ≤ SsumUB t := by
  set L := Real.log t with hL
  have hL0 : 0 ≤ L := by dsimp only [L]; exact Real.log_nonneg (by linarith : 1 ≤ t)
  have hlb1 : Real.log (B4 t) < 19 + 4 * L := by simpa [hL] using st_B4log t ht
  have hlg1 : Real.log (G4 t) < 19 + 4 * L := by simpa [hL] using st_G4log t ht
  have hlbpos : 0 < Real.log (B4 t) := by simpa [hL] using st_logB_pos t ht
  have hlgpos : 0 < Real.log (G4 t) := by simpa [hL] using st_logG_pos t ht
  have hllB : Real.log (Real.log (B4 t)) ≤ Real.log (19 + 4 * L) :=
    Real.log_le_log hlbpos (le_of_lt hlb1)
  have hllG : Real.log (Real.log (G4 t)) ≤ Real.log (19 + 4 * L) :=
    Real.log_le_log hlgpos (le_of_lt hlg1)
  have hllub : Real.log (19 + 4 * L) ≤ 18 + 4 * L := st_log19L L hL0
  have hSb : Sbar (B4 t) + Sbar (G4 t) =
      (0.110 : ℝ) * (Real.log (B4 t) + Real.log (G4 t)) +
      (0.290 : ℝ) * (Real.log (Real.log (B4 t)) + Real.log (Real.log (G4 t))) + 4.58 := by
    unfold Sbar
    ring
  calc Sbar (B4 t) + Sbar (G4 t)
      = (0.110 : ℝ) * (Real.log (B4 t) + Real.log (G4 t)) + (0.290 : ℝ) * (Real.log (Real.log (B4 t)) + Real.log (Real.log (G4 t))) + 4.58 := hSb
    _ ≤ (0.110 : ℝ) * (38 + 8 * L) + (0.290 : ℝ) * (2 * Real.log (19 + 4 * L)) + 4.58 := by
      refine add_le_add (add_le_add ?_ ?_) ?_
      · nlinarith [le_of_lt hlb1, le_of_lt hlg1]
      · nlinarith [hllB, hllG]
      · norm_num
    _ ≤ (0.110 : ℝ) * (38 + 8 * L) + (0.290 : ℝ) * (2 * (18 + 4 * L)) + 4.58 := by
      nlinarith [hllub]
    _ = 19.2 + 3.2 * L := by norm_num
    _ ≤ 20 + 4 * L := by nlinarith [hL0]
    _ = SsumUB t := by
      unfold SsumUB
      rw [hL]
      ring

/-- 1/(1-e) <= 1+2e for 0 <= e <= 1/2. -/
lemma st_inv_eps (e : ℝ) (he0 : 0 ≤ e) (he : e ≤ 1 / 2) : 1 / (1 - e) ≤ 1 + 2 * e := by
  have hden : 0 < 1 - e := sub_pos_of_lt (by nlinarith : e < 1)
  have hm : 0 ≤ e * (1 - 2 * e) := mul_nonneg he0 (by nlinarith : 0 ≤ 1 - 2 * e)
  have hgoal : 1 ≤ (1 + 2 * e) * (1 - e) := by nlinarith [hm]
  rw [div_le_iff₀ hden]
  exact hgoal

/-- (C4) Cf(t, G4 t) <= 4 t^2 + 2. -/
lemma st_hCf4 (t : ℝ) (ht : 1000 ≤ t) : Cf t (G4 t) ≤ Cf4UB t := by
  have ht0 : 0 < t := st_tpos t ht
  have hG4sq : G4 t * G4 t = c4sq * t ^ 8 := st_G4sq t
  have hgp : 0 < G4 t * G4 t - t * t := by
    rw [hG4sq]
    have ht6 : (1000 : ℝ) ^ 6 ≤ t ^ 6 := pow_le_pow_left₀ (by norm_num : (0 : ℝ) ≤ 1000) ht 6
    have hc4 : (2 : ℝ) ≤ c4sq * 1000 ^ 6 := by norm_num [c4sq]
    have hc4t : 2 ≤ c4sq * t ^ 6 := by
      calc 2 ≤ c4sq * 1000 ^ 6 := hc4
        _ ≤ c4sq * t ^ 6 := mul_le_mul_of_nonneg_left ht6 (by linarith [st_c4sq_pos])
    nlinarith [hc4t, pow_pos ht0 2]
  have hG2pos : 0 < G4 t * G4 t := by nlinarith [st_G4pos t ht]
  have heps : t * t / (G4 t * G4 t) ≤ 1 / 2 := by
    rw [hG4sq]
    rw [div_le_iff₀ (st_ct8 t ht)]
    have ht6 : (1000 : ℝ) ^ 6 ≤ t ^ 6 := pow_le_pow_left₀ (by norm_num : (0 : ℝ) ≤ 1000) ht 6
    have hmid : (2 : ℝ) * t * t ≤ c4sq * 1000 ^ 6 * (t * t) := by
      have hc4 : (2 : ℝ) ≤ c4sq * 1000 ^ 6 := by norm_num [c4sq]
      have hstep1 : (2 : ℝ) * t * t = (t * t) * 2 := by ring
      have hstep2 : (t * t) * 2 ≤ (t * t) * (c4sq * 1000 ^ 6) := by
        apply mul_le_mul_of_nonneg_left hc4
        nlinarith [ht0.le]
      have hstep3 : (t * t) * (c4sq * 1000 ^ 6) = c4sq * 1000 ^ 6 * (t * t) := by ring
      calc (2 : ℝ) * t * t = (t * t) * 2 := hstep1
      _ ≤ (t * t) * (c4sq * 1000 ^ 6) := hstep2
      _ = c4sq * 1000 ^ 6 * (t * t) := hstep3
    have hstep : c4sq * 1000 ^ 6 * (t * t) ≤ c4sq * t ^ 6 * (t * t) := by
      apply mul_le_mul_of_nonneg_right
      · apply mul_le_mul_of_nonneg_left ht6
        exact st_c4sq_pos.le
      · nlinarith [ht0.le]
    have hcalc : 2 * t * t ≤ c4sq * t ^ 8 := by
      calc 2 * t * t ≤ c4sq * 1000 ^ 6 * (t * t) := hmid
        _ ≤ c4sq * t ^ 6 * (t * t) := hstep
        _ = c4sq * t ^ 8 := by ring
    nlinarith [hcalc]
  have herr : 1 - t * t / (G4 t * G4 t) = (G4 t * G4 t - t * t) / (G4 t * G4 t) := by
    field_simp [hG2pos.ne']
  have hright : 1 / (1 - t * t / (G4 t * G4 t)) = (G4 t * G4 t) / (G4 t * G4 t - t * t) := by
    rw [herr]
    field_simp [hG2pos.ne', hgp]
  have hw0 : 0 ≤ w t := by dsimp only [w]; nlinarith [ht0.le]
  have heps0 : 0 ≤ t * t / (G4 t * G4 t) :=
    div_nonneg (mul_nonneg ht0.le ht0.le) (le_of_lt hG2pos)
  have h4e : 4 * (t * t / (G4 t * G4 t)) * w t ≤ 2 * t * t := by
    have hhw : 4 * (t * t / (G4 t * G4 t)) * w t = 4 * (t * t + 1 / 4) / (c4sq * t ^ 6) := by
      rw [w, hG4sq]
      field_simp [pow_pos ht0 8, pow_pos ht0 6, st_c4sq_pos.ne']
    rw [hhw]
    rw [div_le_iff₀ (st_ct6 t ht)]
    have ht2' : (1 : ℝ) ≤ t * t := by
      have ht2 : t ≤ t * t := by nlinarith [ht0.le, ht]
      exact le_trans (by linarith [ht]) ht2
    have hinv : 1 / (t * t) ≤ 1 := (div_le_one₀ (mul_pos ht0 ht0)).2 ht2'
    have hct : (4 : ℝ) + 1 / (t * t) ≤ (2 * c4sq : ℝ) * 1000 ^ 6 := by
      have hc : (5 : ℝ) ≤ (2 * c4sq : ℝ) * 1000 ^ 6 := by norm_num [c4sq]
      nlinarith [hinv, hc]
    have hnum : 4 * t * t + 1 ≤ (2 * c4sq : ℝ) * t ^ 6 * (t * t) := by
      have ht6 : (1000 : ℝ) ^ 6 ≤ t ^ 6 := pow_le_pow_left₀ (by norm_num : (0 : ℝ) ≤ 1000) ht 6
      have hbig : (2 * c4sq : ℝ) * 1000 ^ 6 ≤ (2 * c4sq : ℝ) * t ^ 6 := by
        apply mul_le_mul_of_nonneg_left ht6
        nlinarith [st_c4sq_pos]
      have hstep1 : (4 : ℝ) * t * t + 1 = (t * t) * (4 + 1 / (t * t)) := by
        field_simp [(pow_pos ht0 2).ne']
      have hstep2 : (t * t) * (4 + 1 / (t * t)) ≤ (t * t) * ((2 * c4sq : ℝ) * 1000 ^ 6) := by
        apply mul_le_mul_of_nonneg_left hct
        nlinarith [ht0.le]
      have hstep3 : (t * t) * ((2 * c4sq : ℝ) * 1000 ^ 6) ≤ (t * t) * ((2 * c4sq : ℝ) * t ^ 6) := by
        apply mul_le_mul_of_nonneg_left hbig
        nlinarith [ht0.le]
      have hstep4 : (t * t) * ((2 * c4sq : ℝ) * t ^ 6) = (2 * c4sq : ℝ) * t ^ 8 := by ring
      calc (4 : ℝ) * t * t + 1 = (t * t) * (4 + 1 / (t * t)) := hstep1
      _ ≤ (t * t) * ((2 * c4sq : ℝ) * 1000 ^ 6) := hstep2
      _ ≤ (t * t) * ((2 * c4sq : ℝ) * t ^ 6) := hstep3
      _ = (2 * c4sq : ℝ) * t ^ 8 := hstep4
    nlinarith [hnum]
  calc Cf t (G4 t)
      = 1 + 2 * w t * ((G4 t * G4 t) / (G4 t * G4 t - t * t)) := by
        dsimp only [Cf, w]
        field_simp [hG2pos.ne', hgp]
      _ = 1 + 2 * w t * (1 / (1 - t * t / (G4 t * G4 t))) := by
        rw [← hright]
      _ ≤ 1 + 2 * w t * (1 + 2 * (t * t / (G4 t * G4 t))) := by
        nlinarith [st_inv_eps (t * t / (G4 t * G4 t)) heps0 heps, hw0]
      _ = 1 + 2 * w t + 4 * (t * t / (G4 t * G4 t)) * w t := by ring
      _ ≤ 1 + 2 * w t + 2 * t * t := by nlinarith [h4e]
      _ = 1 + 2 * (t * t + 1 / 4) + 2 * t * t := by
        rw [show (w t : ℝ) = t * t + 1 / 4 from by dsimp only [w]]
      _ ≤ 4 * t * t + 2 := by nlinarith

/-- Kbar(G4 t) > 0 for t >= 1000. -/
lemma st_Kbarpos (t : ℝ) (ht : 1000 ≤ t) : 0 < Kbar (G4 t) := by
  have hg1 : (1 : ℝ) < G4 t := by
    dsimp only [G4]
    have ht4 : (1 : ℝ) ^ 4 ≤ t ^ 4 :=
      pow_le_pow_left₀ (by norm_num : (0 : ℝ) ≤ 1) (by linarith : 1 ≤ t) 4
    nlinarith [ht4, show (1 : ℝ) ≤ 62000000 from by norm_num]
  have hlg : 0 < Real.log (G4 t) := Real.log_pos hg1
  have hlg1 : (1 : ℝ) < Real.log (G4 t) := by
    have ht0 : 0 < t := st_tpos t ht
    have heq : Real.log (G4 t) = Real.log 62000000 + 4 * Real.log t := by
      dsimp only [G4]
      rw [Real.log_mul (by norm_num : (62000000 : ℝ) ≠ 0) (pow_pos ht0 4).ne',
          Real.log_pow t 4]
      ring
    have hL : (6 : ℝ) < Real.log t := st_L6 t ht
    have hlp : 0 < Real.log 62000000 := Real.log_pos (by norm_num : (1 : ℝ) < 62000000)
    rw [heq]
    nlinarith [hL, hlp]
  have hllg : 0 < Real.log (Real.log (G4 t)) := Real.log_pos hlg1
  have hden : 0 < 2 * G4 t * G4 t := by
    apply mul_pos
    · nlinarith [hg1]
    · nlinarith [hg1]
  unfold Kbar
  apply div_pos
  · nlinarith [hlg, hllg]
  · exact hden

/-- (K4) Kbar(G4 t) <= (10 + 2 log t) / (2 c4^2 t^8). -/
lemma st_hKbar4 (t : ℝ) (ht : 1000 ≤ t) : Kbar (G4 t) ≤ Kbar4UB t := by
  set L := Real.log t with hL
  have hL6 : (6 : ℝ) < L := by simpa [hL] using st_L6 t ht
  have ht0 : 0 < t := st_tpos t ht
  have hlg : Real.log (G4 t) < 19 + 4 * L := by simpa [hL] using st_G4log t ht
  have hlg0 : 0 < Real.log (G4 t) := by simpa [hL] using st_logG_pos t ht
  have hllg : Real.log (Real.log (G4 t)) ≤ 18 + 4 * L := by
    calc Real.log (Real.log (G4 t)) ≤ Real.log (19 + 4 * L) :=
          Real.log_le_log hlg0 (le_of_lt hlg)
      _ ≤ 18 + 4 * L := st_log19L L (by linarith [hL6])
  have hden2 : 2 * G4 t * G4 t = 2 * c4sq * t ^ 8 := by
    have hgg : G4 t * G4 t = c4sq * t ^ 8 := st_G4sq t
    rw [show (2 : ℝ) * G4 t * G4 t = 2 * (G4 t * G4 t) from by ring, hgg]
    ring
  have hnum : 0.110 * (Real.log (G4 t) + 1 / 2) +
        0.290 * (Real.log (Real.log (G4 t)) + 1 / 2) + 2.290 ≤ 10 + 2 * L := by
    have h1 : 0.110 * (Real.log (G4 t) + 1 / 2) ≤ 0.110 * (19 + 4 * L + 1 / 2) := by
      nlinarith [le_of_lt hlg]
    have h2 : 0.290 * (Real.log (Real.log (G4 t)) + 1 / 2) ≤
        0.290 * (18 + 4 * L + 1 / 2) := by
      nlinarith [hllg]
    nlinarith [h1, h2, hL6]
  have hdenpos : 0 < 2 * c4sq * t ^ 8 := by
    nlinarith [st_c4sq_pos, pow_pos ht0 8]
  calc Kbar (G4 t)
      = (0.110 * (Real.log (G4 t) + 1 / 2) +
          0.290 * (Real.log (Real.log (G4 t)) + 1 / 2) + 2.290) / (2 * G4 t * G4 t) := by
        unfold Kbar
        rfl
      _ = (0.110 * (Real.log (G4 t) + 1 / 2) +
          0.290 * (Real.log (Real.log (G4 t)) + 1 / 2) + 2.290) / (2 * c4sq * t ^ 8) := by
        rw [hden2]
      _ ≤ (10 + 2 * L) / (2 * c4sq * t ^ 8) := by
        exact div_le_div_of_nonneg_right hnum (le_of_lt hdenpos)
      _ = Kbar4UB t := by
        unfold Kbar4UB
        rw [show (L : ℝ) = Real.log t from by dsimp only [L]]
        field_simp [st_c4sq_pos.ne', (pow_pos ht0 8).ne']
        ring

/-- 0 <= X4fun t for t >= 1000. -/
lemma st_X4nonneg (t : ℝ) (ht : 1000 ≤ t) : 0 ≤ X4fun t := by
  dsimp only [X4fun]
  have ht0 : 0 < t := st_tpos t ht
  have hg2 : 0 < G4 t * G4 t + 1 / 4 := by nlinarith [st_G4pos t ht]
  have heps : w t / (G4 t * G4 t + 1 / 4) < 1 / 2 := st_zhalf t ht
  have hden : 0 < 1 - w t / (G4 t * G4 t + 1 / 4) := by linarith [heps]
  have hBfE : Bf t (G4 t) =
      1 / (2 * (G4 t * G4 t + 1 / 4)) +
      (w t / (G4 t * G4 t + 1 / 4)) / (1 - w t / (G4 t * G4 t + 1 / 4)) +
      t / (G4 t * G4 t + 1 / 4) := by
    unfold Bf
    rfl
  apply add_nonneg
  · apply mul_nonneg
    · rw [hBfE]
      have ht1 : 0 ≤ 1 / (2 * (G4 t * G4 t + 1 / 4)) := by
        apply div_nonneg
        · norm_num
        · nlinarith [st_G4pos t ht]
      have ht2 : 0 ≤ t / (G4 t * G4 t + 1 / 4) := by
        apply div_nonneg
        · nlinarith [ht]
        · nlinarith [st_G4pos t ht]
      have ht3 : 0 ≤ (w t / (G4 t * G4 t + 1 / 4)) / (1 - w t / (G4 t * G4 t + 1 / 4)) := by
        apply div_nonneg
        · apply div_nonneg
          · dsimp only [w]; nlinarith [ht]
          · nlinarith [st_G4pos t ht]
        · exact hden.le
      nlinarith [ht1, ht2, ht3]
    · unfold Sbar
      have hllB : 0 < Real.log (Real.log (B4 t)) := by
        have hq : (1 : ℝ) < Real.log (B4 t) := by
          have hL : (6 : ℝ) < Real.log t := st_L6 t ht
          have hge : 4 * Real.log t ≤ Real.log (B4 t) := by
            have ht4 : 0 < t ^ 4 := pow_pos ht0 4
            have heq : Real.log (124000000 * t ^ 4) = Real.log 124000000 + 4 * Real.log t := by
              rw [Real.log_mul (by norm_num : (124000000 : ℝ) ≠ 0) ht4.ne',
                  Real.log_pow t 4]
              ring
            dsimp only [B4]
            rw [heq]
            nlinarith [Real.log_pos (by norm_num : (1 : ℝ) < 124000000), hL]
          linarith [hge]
        exact Real.log_pos hq
      have hllG : 0 < Real.log (Real.log (G4 t)) := by
        have hq : (1 : ℝ) < Real.log (G4 t) := by
          have hL : (6 : ℝ) < Real.log t := st_L6 t ht
          have hge : 4 * Real.log t ≤ Real.log (G4 t) := by
            have ht4 : 0 < t ^ 4 := pow_pos ht0 4
            have heq : Real.log (62000000 * t ^ 4) = Real.log 62000000 + 4 * Real.log t := by
              rw [Real.log_mul (by norm_num : (62000000 : ℝ) ≠ 0) ht4.ne',
                  Real.log_pow t 4]
              ring
            dsimp only [G4]
            rw [heq]
            nlinarith [Real.log_pos (by norm_num : (1 : ℝ) < 62000000), hL]
          linarith [hge]
        exact Real.log_pos hq
      apply add_nonneg
      · apply add_nonneg
        · nlinarith [st_logB_pos t ht]
        · nlinarith [hllB]
      · apply add_nonneg
        · nlinarith [st_logG_pos t ht]
        · nlinarith [hllG]
  · apply mul_nonneg
    · unfold Cf
      have hgp : 0 < G4 t * G4 t - t * t := by
        have hG4sq : G4 t * G4 t = c4sq * t ^ 8 := st_G4sq t
        rw [hG4sq]
        have ht6 : (1000 : ℝ) ^ 6 ≤ t ^ 6 := pow_le_pow_left₀ (by norm_num : (0 : ℝ) ≤ 1000) ht 6
        have hc4 : (2 : ℝ) ≤ c4sq * 1000 ^ 6 := by norm_num [c4sq]
        have hc4t : 2 ≤ c4sq * t ^ 6 := by
          calc 2 ≤ c4sq * 1000 ^ 6 := hc4
            _ ≤ c4sq * t ^ 6 := mul_le_mul_of_nonneg_left ht6 (by linarith [st_c4sq_pos])
        nlinarith [hc4t, pow_pos ht0 2]
      have hwp : 0 < w t := by dsimp only [w]; nlinarith [st_G4pos t ht]
      have htpos : 0 < 2 * w t * (G4 t * G4 t) := by
        nlinarith [hwp, st_G4pos t ht]
      have hCf1 : 0 ≤ 2 * w t * (G4 t * G4 t) / (G4 t * G4 t - t * t) :=
        div_nonneg htpos.le (le_of_lt hgp)
      nlinarith [hCf1]
    · exact le_of_lt (st_Kbarpos t ht)

/-- (X4) X4fun t <= X4UBfun t for t >= 1000 (component chain). -/
lemma st_X4bound (t : ℝ) (ht : 1000 ≤ t) : X4fun t ≤ X4UBfun t := by
  dsimp only [X4fun]
  have ht0 : 0 < t := st_tpos t ht
  have hL0 : 0 ≤ Real.log t := Real.log_nonneg (by linarith : 1 ≤ t)
  have hBf : Bf t (G4 t) ≤ Bf4UB t := st_hBf4 t ht
  have hSsum : Sbar (B4 t) + Sbar (G4 t) ≤ SsumUB t := st_hSsum t ht
  have hSs0 : 0 ≤ Sbar (B4 t) + Sbar (G4 t) := by
    unfold Sbar
    nlinarith [st_logB_pos t ht, st_logG_pos t ht]
  have hCf : Cf t (G4 t) ≤ Cf4UB t := st_hCf4 t ht
  have hCf0 : 0 ≤ Cf t (G4 t) := by
    unfold Cf
    have ht6 : (1000 : ℝ) ^ 6 ≤ t ^ 6 := pow_le_pow_left₀ (by norm_num : (0 : ℝ) ≤ 1000) ht 6
    have hc4 : (2 : ℝ) ≤ c4sq * 1000 ^ 6 := by norm_num [c4sq]
    have hc4t : 2 ≤ c4sq * t ^ 6 := by
      calc 2 ≤ c4sq * 1000 ^ 6 := hc4
        _ ≤ c4sq * t ^ 6 := mul_le_mul_of_nonneg_left ht6 (by linarith [st_c4sq_pos])
    nlinarith [hc4t, pow_pos ht0 2]
  have hK : Kbar (G4 t) ≤ Kbar4UB t := st_hKbar4 t ht
  have hK0 : 0 ≤ Kbar (G4 t) := le_of_lt (st_Kbarpos t ht)
  have hBf0 : 0 ≤ Bf4UB t := by
    unfold Bf4UB
    have hnumB : 0 ≤ (2 : ℝ) + 1 / t + 1 / (t * t) := by
      nlinarith [inv_nonneg ht0.le]
    apply div_nonneg
    · exact hnumB
    · exact le_of_lt (mul_pos (pow_pos ht0 6) st_c4sq_pos)
  have hCf4UB0 : 0 ≤ Cf4UB t := by
    dsimp only [Cf4UB]
    nlinarith [ht]

  have hBfS : Bf t (G4 t) * (Sbar (B4 t) + Sbar (G4 t)) ≤
      Bf4UB t * (Sbar (B4 t) + Sbar (G4 t)) :=
    mul_le_mul hBf le_rfl hBf0 hSs0
  have hBs : Bf4UB t * (Sbar (B4 t) + Sbar (G4 t)) ≤ Bf4UB t * SsumUB t :=
    mul_le_mul le_rfl hSsum hBf0 hBf0
  have hCfK : Cf t (G4 t) * Kbar (G4 t) ≤ Cf4UB t * Kbar (G4 t) :=
    mul_le_mul hCf le_rfl hCf4UB0 hK0
  have hKs : Cf4UB t * Kbar (G4 t) ≤ Cf4UB t * Kbar4UB t :=
    mul_le_mul le_rfl hK hCf4UB0 hCf4UB0
  have hfinal : Bf t (G4 t) * (Sbar (B4 t) + Sbar (G4 t)) + Cf t (G4 t) * Kbar (G4 t) ≤
      Bf4UB t * SsumUB t + Cf4UB t * Kbar4UB t := by
    have hm1 : Bf t (G4 t) * (Sbar (B4 t) + Sbar (G4 t)) + Cf t (G4 t) * Kbar (G4 t) ≤
        Bf4UB t * (Sbar (B4 t) + Sbar (G4 t)) + Cf t (G4 t) * Kbar (G4 t) := by
      nlinarith [hBfS]
    have hm2 : Bf4UB t * (Sbar (B4 t) + Sbar (G4 t)) + Cf t (G4 t) * Kbar (G4 t) ≤
        Bf4UB t * SsumUB t + Cf t (G4 t) * Kbar (G4 t) := by
      nlinarith [hBs]
    have hm3 : Bf4UB t * SsumUB t + Cf t (G4 t) * Kbar (G4 t) ≤
        Bf4UB t * SsumUB t + Cf4UB t * Kbar (G4 t) := by
      nlinarith [hCfK]
    have hm4 : Bf4UB t * SsumUB t + Cf4UB t * Kbar (G4 t) ≤
        Bf4UB t * SsumUB t + Cf4UB t * Kbar4UB t := by
      nlinarith [hKs]
    nlinarith [hm1, hm2, hm3, hm4]

  set L := Real.log t
  have hL0' : 0 ≤ L := hL0
  have hTden : 0 < t ^ 6 * c4sq := mul_pos (pow_pos ht0 6) st_c4sq_pos
  have hb : Bf4UB t * SsumUB t ≤ (2001001 : ℝ) * (20 + 4 * L) / (10 ^ 6 * c4sq * t ^ 6) := by
    unfold Bf4UB, SsumUB
    have hinv : (2 : ℝ) + 1 / t + 1 / (t * t) ≤ 2001001 / 10 ^ 6 := by
      have h1t : 1 / t ≤ 1 / 1000 := by
        rw [inv_le_inv₀ (by norm_num : (0 : ℝ) < 1000) ht0]
        exact ht
      have h1t2a : 1 / (t * t) = (1 / t) ^ 2 := by ring
      have h1t2b : (1 / t) ^ 2 ≤ (1 / 1000) ^ 2 :=
        pow_le_pow_left₀ (inv_nonneg ht0.le) h1t 2
      have h1t2c : (1 / 1000 : ℝ) ^ 2 = 1 / 10 ^ 6 := by norm_num
      have h1t2 : 1 / (t * t) ≤ 1 / 10 ^ 6 := by
        rw [h1t2a]
        linarith [h1t2b, h1t2c]
      nlinarith [h1t, h1t2, show (2 : ℝ) ≤ 2001001 / 10 ^ 6 from by norm_num]
    have hS0 : 0 ≤ SsumUB t := by
      unfold SsumUB
      nlinarith [hL0]
    apply div_le_div_of_nonneg_right (by
      apply mul_le_mul_of_nonneg_right hinv
      exact hS0)
    exact hTden.le
  have hc : Cf4UB t * Kbar4UB t ≤ (2000001 : ℝ) * (10 + 2 * L) / (10 ^ 6 * c4sq * t ^ 6) := by
    unfold Cf4UB, Kbar4UB, L
    have hc4 : (4 : ℝ) * t * t + 2 ≤ (4000002 : ℝ) / 10 ^ 6 * (t * t) := by
      have ht2 : (1000 : ℝ) ^ 2 ≤ t ^ 2 := pow_le_pow_left₀ (by norm_num : (0 : ℝ) ≤ 1000) ht 2
      have hinv : 2 ≤ (2 : ℝ) / 10 ^ 6 * (t * t) := by
        have hinv1 : (2 : ℝ) = (2 : ℝ) / 10 ^ 6 * (1000 * 1000 : ℝ) := by norm_num
        have ht2' : 1000 * 1000 ≤ t * t := by simpa [show (1000 : ℝ) ^ 2 = 1000 * 1000 from by ring, pow_two] using ht2
        have hstep : (2 : ℝ) / 10 ^ 6 * (1000 * 1000 : ℝ) ≤ (2 : ℝ) / 10 ^ 6 * (t * t) := by
          apply mul_le_mul_of_nonneg_left ht2'
          nlinarith [show (0 : ℝ) < 10 ^ 6 from by norm_num]
        linarith [hinv1, hstep]
      nlinarith [hinv]
    have hK0' : 0 ≤ (10 + 2 * Real.log t) / (2 * c4sq * t ^ 8) := by
      apply div_nonneg
      · nlinarith [hL0]
      · exact le_of_lt (by nlinarith [st_c4sq_pos, pow_pos ht0 8])
    have hC0 : Cf4UB t * Kbar4UB t =
        (4 * t * t + 2) * ((10 + 2 * Real.log t) / (2 * c4sq * t ^ 8)) := by
      field_simp [c4sq, (mul_pos st_c4sq_pos (pow_pos ht0 8)).ne']
      ring
    rw [hC0]
    have hmul : (4 * t * t + 2) * ((10 + 2 * Real.log t) / (2 * c4sq * t ^ 8)) ≤
        ((4000002 : ℝ) / 10 ^ 6 * (t * t)) * ((10 + 2 * Real.log t) / (2 * c4sq * t ^ 8)) := by
      apply mul_le_mul_of_nonneg_left hc4
      exact hK0'
    have hstep : ((4000002 : ℝ) / 10 ^ 6 * (t * t)) * ((10 + 2 * Real.log t) / (2 * c4sq * t ^ 8)) =
        (2000001 : ℝ) * (10 + 2 * Real.log t) / (10 ^ 6 * c4sq * t ^ 6) := by
      field_simp [(st_ct8 t ht).ne', (st_ct6 t ht).ne', (pow_pos ht0 2).ne']
      ring
    have hstep2 : (2000001 : ℝ) * (10 + 2 * Real.log t) / (10 ^ 6 * c4sq * t ^ 6) =
        (2000001 : ℝ) * (10 + 2 * L) / (10 ^ 6 * c4sq * t ^ 6) := by
      dsimp only [L]
      ring
    calc (4 * t * t + 2) * ((10 + 2 * Real.log t) / (2 * c4sq * t ^ 8))
        ≤ ((4000002 : ℝ) / 10 ^ 6 * (t * t)) * ((10 + 2 * Real.log t) / (2 * c4sq * t ^ 8)) := hmul
    _ = (2000001 : ℝ) * (10 + 2 * Real.log t) / (10 ^ 6 * c4sq * t ^ 6) := hstep
    _ = (2000001 : ℝ) * (10 + 2 * L) / (10 ^ 6 * c4sq * t ^ 6) := hstep2

  have hc1 : (60020030 : ℝ) * 10 ^ 16 ≤ 10 ^ 6 * c4sq * 160 := by norm_num [c4sq]
  have hc2 : (12004006 : ℝ) * 10 ^ 16 ≤ 10 ^ 6 * c4sq * 35 := by norm_num [c4sq]
  have hsum : (60020030 + 12004006 * L) * 10 ^ 16 ≤ 10 ^ 6 * c4sq * (160 + 35 * L) := by
    nlinarith [hc1, hc2, mul_nonneg (by norm_num : 0 ≤ (12004006 : ℝ) * 10 ^ 16) hL0']
  have hmid : Bf4UB t * SsumUB t + Cf4UB t * Kbar4UB t ≤
      (60020030 + 12004006 * L) / (10 ^ 6 * c4sq * t ^ 6) := by
    have hadd : (2001001 : ℝ) * (20 + 4 * L) / (10 ^ 6 * c4sq * t ^ 6) +
        (2000001 : ℝ) * (10 + 2 * L) / (10 ^ 6 * c4sq * t ^ 6) =
        (60020030 + 12004006 * L) / (10 ^ 6 * c4sq * t ^ 6) := by
      field_simp [(st_ct6 t ht).ne', (mul_pos (pow_pos (by norm_num : (0 : ℝ) < 10) 6) st_c4sq_pos).ne']
      ring
    calc Bf4UB t * SsumUB t + Cf4UB t * Kbar4UB t
        ≤ (2001001 : ℝ) * (20 + 4 * L) / (10 ^ 6 * c4sq * t ^ 6) +
          (2000001 : ℝ) * (10 + 2 * L) / (10 ^ 6 * c4sq * t ^ 6) := by
          nlinarith [hb, hc]
    _ = (60020030 + 12004006 * L) / (10 ^ 6 * c4sq * t ^ 6) := hadd
  have hsqueeze : (60020030 + 12004006 * L) / (10 ^ 6 * c4sq * t ^ 6) ≤
      (160 + 35 * L) / (10 ^ 16 * t ^ 6) := by
    have hsumt : (60020030 + 12004006 * L) * 10 ^ 16 * t ^ 6 ≤
        10 ^ 6 * c4sq * (160 + 35 * L) * t ^ 6 :=
      mul_le_mul_of_nonneg_right hsum (pow_nonneg ht0.le 6)
    rw [div_le_div_iff₀ (mul_pos (mul_pos (pow_pos (by norm_num : (0 : ℝ) < 10) 6) st_c4sq_pos) (pow_pos ht0 6))
        (mul_pos (pow_pos (by norm_num : (0 : ℝ) < 10) 16) (pow_pos ht0 6))]
    ring_nf
    nlinarith [hsumt]
  have htotal2 : Bf4UB t * SsumUB t + Cf4UB t * Kbar4UB t ≤
      (160 + 35 * L) / (10 ^ 16 * t ^ 6) := by
    calc Bf4UB t * SsumUB t + Cf4UB t * Kbar4UB t ≤
          (60020030 + 12004006 * L) / (10 ^ 6 * c4sq * t ^ 6) := hmid
    _ ≤ (160 + 35 * L) / (10 ^ 16 * t ^ 6) := hsqueeze
  have hend : (160 + 35 * L) / (10 ^ 16 * t ^ 6) = X4UBfun t := by
    unfold X4UBfun
    field_simp [(mul_pos (pow_pos (by norm_num : (0 : ℝ) < 10) 16) (pow_pos ht0 6)).ne']
    ring
  have htotal : Bf4UB t * SsumUB t + Cf4UB t * Kbar4UB t ≤ X4UBfun t := by
    calc Bf4UB t * SsumUB t + Cf4UB t * Kbar4UB t ≤
        (160 + 35 * L) / (10 ^ 16 * t ^ 6) := htotal2
      _ = X4UBfun t := hend
  nlinarith [hfinal, htotal]


/-- (E3) X4UBfun t <= 1/2 for t >= 1000. -/
lemma st_XUBhalf (t : ℝ) (ht : 1000 ≤ t) : X4UBfun t ≤ 1 / 2 := by
  dsimp only [X4UBfun]
  set L := Real.log t
  have hL0 : 0 ≤ L := by dsimp only [L]; exact Real.log_nonneg (by linarith : 1 ≤ t)
  have ht0 : 0 < t := st_tpos t ht
  have ht2 : t ≤ t * t := by nlinarith [ht0.le, ht]
  have hL2 : (L : ℝ) ^ 2 ≤ t := st_L2le_t t ht
  have hL2t : (L : ℝ) ^ 2 ≤ t * t := le_trans hL2 ht2
  have hLtle : L ≤ t := (sq_le_sq₀ hL0 ht0.le).mp hL2t
  have hstep1 : (16 / 10 ^ 15 + 35 / 10 ^ 16 * L) / t ^ 6 =
      16 / (10 ^ 15 * t ^ 6) + 35 * L / (10 ^ 16 * t ^ 6) := by
    field_simp [(pow_pos ht0 6).ne']
  have hlt : 35 * L / (10 ^ 16 * t ^ 6) ≤ 35 * t / (10 ^ 16 * t ^ 6) := by
    have hLover : L / (10 ^ 16 * t ^ 6) ≤ t / (10 ^ 16 * t ^ 6) := by
      have hD : 0 < 10 ^ 16 * t ^ 6 :=
        mul_pos (pow_pos (by norm_num : (0 : ℝ) < 10) 16) (pow_pos ht0 6)
      exact (div_le_iff₀ hD).mpr hLtle
    rw [show (35 : ℝ) * L / (10 ^ 16 * t ^ 6) = 35 * (L / (10 ^ 16 * t ^ 6)) from by ring,
        show (35 : ℝ) * t / (10 ^ 16 * t ^ 6) = 35 * (t / (10 ^ 16 * t ^ 6)) from by ring]
    exact mul_le_mul_of_nonneg_left hLover (by norm_num : (0 : ℝ) ≤ 35)
  have hstep2 : 16 / (10 ^ 15 * t ^ 6) + 35 * L / (10 ^ 16 * t ^ 6) ≤
      16 / (10 ^ 15 * t ^ 6) + 35 * t / (10 ^ 16 * t ^ 6) := by
    exact add_le_add (by linarith : 16 / (10 ^ 15 * t ^ 6) ≤ 16 / (10 ^ 15 * t ^ 6)) hlt
  have h5 : 35 * t / (10 ^ 16 * t ^ 6) = 35 / (10 ^ 16 * t ^ 5) := by
    field_simp [(pow_pos ht0 6).ne', (pow_pos ht0 5).ne']
  have h6a : 16 / (10 ^ 15 * t ^ 6) ≤ 16 / (10 ^ 15 * (1000 : ℝ) ^ 6 : ℝ) := by
    have ht6 : (1000 : ℝ) ^ 6 ≤ t ^ 6 := pow_le_pow_left₀ (by norm_num : (0 : ℝ) ≤ 1000) ht 6
    have hc6 : 10 ^ 15 * (1000 : ℝ) ^ 6 ≤ 10 ^ 15 * t ^ 6 :=
      mul_le_mul_of_nonneg_left ht6 (by norm_num : (0 : ℝ) ≤ 10 ^ 15)
    exact div_le_div_of_nonneg_left (by norm_num : (0 : ℝ) ≤ 16)
      (by norm_num : (0 : ℝ) < 10 ^ 15 * (1000 : ℝ) ^ 6) hc6
  have h6b : 35 / (10 ^ 16 * t ^ 5) ≤ 35 / (10 ^ 16 * (1000 : ℝ) ^ 5 : ℝ) := by
    have ht5 : (1000 : ℝ) ^ 5 ≤ t ^ 5 := pow_le_pow_left₀ (by norm_num : (0 : ℝ) ≤ 1000) ht 5
    have hc5 : 10 ^ 16 * (1000 : ℝ) ^ 5 ≤ 10 ^ 16 * t ^ 5 :=
      mul_le_mul_of_nonneg_left ht5 (by norm_num : (0 : ℝ) ≤ 10 ^ 16)
    exact div_le_div_of_nonneg_left (by norm_num : (0 : ℝ) ≤ 35)
      (by norm_num : (0 : ℝ) < 10 ^ 16 * (1000 : ℝ) ^ 5) hc5
  have h6c : 16 / (10 ^ 15 * t ^ 6) + 35 / (10 ^ 16 * t ^ 5) ≤
      16 / (10 ^ 15 * (1000 : ℝ) ^ 6 : ℝ) + 35 / (10 ^ 16 * (1000 : ℝ) ^ 5 : ℝ) :=
    add_le_add h6a h6b
  calc (16 / 10 ^ 15 + 35 / 10 ^ 16 * L) / t ^ 6
      = 16 / (10 ^ 15 * t ^ 6) + 35 * L / (10 ^ 16 * t ^ 6) := hstep1
    _ ≤ 16 / (10 ^ 15 * t ^ 6) + 35 * t / (10 ^ 16 * t ^ 6) := hstep2
    _ = 16 / (10 ^ 15 * t ^ 6) + 35 / (10 ^ 16 * t ^ 5) := by rw [h5]
    _ ≤ 16 / (10 ^ 15 * (1000 : ℝ) ^ 6 : ℝ) + 35 / (10 ^ 16 * (1000 : ℝ) ^ 5 : ℝ) := h6c
    _ ≤ 1 / 2 := by norm_num

/-- (E3) X4fun t <= 1/2 for t >= 1000 (from the X4 bound chain). -/
lemma st_X4half (t : ℝ) (ht : 1000 ≤ t) : X4fun t ≤ 1 / 2 := by
  calc X4fun t ≤ X4UBfun t := st_X4bound t ht
    _ ≤ 1 / 2 := st_XUBhalf t ht

/-- exp (1/2) <= 2. -/
lemma st_e12 : Real.exp (1 / 2) ≤ 2 := by
  have h34 : Real.exp 1 < 4 := by linarith [Real.exp_one_lt_three]
  have hsq : (Real.exp (1 / 2) : ℝ) ^ 2 < 4 := by
    calc (Real.exp (1 / 2) : ℝ) ^ 2 = Real.exp (1 / 2 + 1 / 2) := by rw [Real.exp_add (1/2) (1/2)]
      _ = Real.exp 1 := by rw [show (1 / 2 : ℝ) + 1 / 2 = 1 from by norm_num]
      _ < 4 := h34
  exact (sq_le_sq₀ (by linarith [Real.exp_nonneg (1/2)]) (by norm_num : (0 : ℝ) ≤ 2)).mp (le_of_lt hsq)

/-- (E4) exp (X4fun t) <= 2 for t >= 1000. -/
lemma st_eX4le2 (t : ℝ) (ht : 1000 ≤ t) : Real.exp (X4fun t) ≤ 2 := by
  calc Real.exp (X4fun t) ≤ Real.exp (1 / 2) :=
        Real.exp_le_exp (st_X4half t ht)
    _ ≤ 2 := st_e12
end S4Strip
