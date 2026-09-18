
/- =================================================================
   §2b (S1)  remaining Xwire component bounds: log anchors, Ssum, Cf,
        Kbar, the X4 chain bound, and the exp bound.

   The single exp anchor (log 124000000 < 19) uses the dps-9 certified
   bound 2.7182818283 < e (Mathlib `Real.exp_one_gt_d9`):
     124000000 * 10^190 <= 27182818283^19   (exact integers, norm_num)
     =>  1.24e8 <= e_d9^19 < e^19  =>  log 124000000 < 19.
   All other log bounds follow by monotonicity + log_mul/log_pow.
   ================================================================= -/

/-- e_d9 := 27182818283/10^10 (the dps-9 certified lower bound for e). -/
def e_d9 : ℝ := 27182818283 / 10 ^ 10

/-- 124000000 * (10^10)^19 <= 27182818283^19 (exact integer arithmetic). -/
lemma st_ed9_19 : (124000000 : ℝ) * (10 ^ 10 : ℝ) ^ 19 ≤ (27182818283 : ℝ) ^ 19 := by
  norm_num

/-- e_d9 < e. -/
lemma st_ed9_lt_e : e_d9 < Real.exp 1 := by
  rw [e_d9, show (27182818283 : ℝ) / 10 ^ 10 = (2.7182818283 : ℝ) from by norm_num]
  exact Real.exp_one_gt_d9

/-- log 124000000 < 19. -/
lemma st_logB_anchor : Real.log 124000000 < 19 := by
  have hA : (124000000 : ℝ) ≤ (e_d9 : ℝ) ^ 19 := by
    rw [e_d9, div_pow (27182818283 : ℝ) (10 ^ 10) 19]
    have hden : 0 < (10 ^ 10 : ℝ) ^ 19 := pow_pos (by norm_num : (0 : ℝ) < 10 ^ 10) 19
    rw [div_le_one hden]
    exact st_ed9_19
  have hB : (e_d9 : ℝ) ^ 19 < Real.exp 19 := by
    calc (e_d9 : ℝ) ^ 19 < (Real.exp 1) ^ 19 :=
      pow_lt_pow_left₀ st_ed9_lt_e (by norm_num : (0 : ℝ) ≤ e_d9) (by norm_num : (19 : ℕ) ≠ 0)
      _ = Real.exp 19 := exp_one_pow 19
  calc Real.log 124000000 ≤ Real.log ((e_d9 : ℝ) ^ 19) :=
        Real.log_le_log (by norm_num : (0 : ℝ) < 124000000) hA
    _ < Real.log (Real.exp 19) :=
        Real.log_lt_log (pow_pos (by norm_num : (0 : ℝ) < e_d9) 19) hB
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
    rw [Real.log_pow ht0 4]
    ring
  calc Real.log (B4 t) = Real.log (124000000 * t ^ 4) := by dsimp only [B4]
    _ = Real.log 124000000 + Real.log (t ^ 4) :=
        Real.log_mul (by norm_num : (0 : ℝ) < 124000000) ht4
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
    rw [Real.log_pow ht0 4]
    ring
  calc Real.log (G4 t) = Real.log (62000000 * t ^ 4) := by dsimp only [G4]
    _ = Real.log 62000000 + Real.log (t ^ 4) :=
        Real.log_mul (by norm_num : (0 : ℝ) < 62000000) ht4
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
  set lb := Real.log (B4 t) with hlb
  set lg := Real.log (G4 t) with hlg
  have hlb1 : lb < 19 + 4 * L := by simpa [hL] using st_B4log t ht
  have hlg1 : lg < 19 + 4 * L := by simpa [hL] using st_G4log t ht
  have hlbpos : 0 < lb := by simpa [hL] using st_logB_pos t ht
  have hlgpos : 0 < lg := by simpa [hL] using st_logG_pos t ht
  have hllB : Real.log lb ≤ Real.log (19 + 4 * L) :=
    Real.log_le_log hlbpos (le_of_lt hlb1)
  have hllG : Real.log lg ≤ Real.log (19 + 4 * L) :=
    Real.log_le_log hlgpos (le_of_lt hlg1)
  have hllub : Real.log (19 + 4 * L) ≤ 18 + 4 * L := st_log19L L hL0
  calc Sbar (B4 t) + Sbar (G4 t)
      = (0.110 : ℝ) * (lb + lg) + (0.290 : ℝ) * (Real.log lb + Real.log lg) + 4.58 := by
        dsimp only [Sbar, lb, lg]
        ring
      ≤ (0.110 : ℝ) * (38 + 8 * L) + (0.290 : ℝ) * (2 * Real.log (19 + 4 * L)) + 4.58 := by
        refine add_le_add (add_le_add ?_ ?_) ?_
        · nlinarith [le_of_lt hlb1, le_of_lt hlg1]
        · nlinarith [hllB, hllG]
        · norm_num
      ≤ (0.110 : ℝ) * (38 + 8 * L) + (0.290 : ℝ) * (2 * (18 + 4 * L)) + 4.58 := by
        nlinarith [hllub]
      _ = 19.2 + 3.2 * L := by norm_num
      _ ≤ 20 + 4 * L := by nlinarith [hL0]
      _ = SsumUB t := by
        dsimp only [SsumUB]
        simp only [hL]
        ring

/-- 1/(1-e) <= 1+2e for 0 <= e <= 1/2. -/
lemma st_inv_eps (e : ℝ) (he0 : 0 ≤ e) (he : e ≤ 1 / 2) : 1 / (1 - e) ≤ 1 + 2 * e := by
  have hden : 0 < 1 - e := sub_pos_of_lt (by nlinarith : e < 1)
  have hm : 0 ≤ e * (1 - 2 * e) := mul_nonneg he0 (by nlinarith : 0 ≤ 1 - 2 * e)
  have hgoal : 1 ≤ (1 + 2 * e) * (1 - e) := by nlinarith [hm]
  rw [div_le_one hden]
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
        _ ≤ c4sq * t ^ 6 := mul_le_mul_of_nonneg_left ht6 (st_c4sq_pos.le)
    nlinarith [hc4t, pow_pos ht0 2]
  have hG2pos : 0 < G4 t * G4 t := by
    nlinarith [st_G4pos t ht]
  have heps : t * t / (G4 t * G4 t) ≤ 1 / 2 := by
    rw [hG4sq]
    have hden2 : 0 < c4sq * t ^ 6 := mul_pos st_c4sq_pos (pow_pos ht0 6)
    rw [div_le_iff₀ hden2]
    have ht6 : (1000 : ℝ) ^ 6 ≤ t ^ 6 := pow_le_pow_left₀ (by norm_num : (0 : ℝ) ≤ 1000) ht 6
    have hc4 : (2 : ℝ) ≤ c4sq * 1000 ^ 6 := by norm_num [c4sq]
    nlinarith [hc4, ht6, st_c4sq_pos.le]
  have hfr : (G4 t * G4 t) / (G4 t * G4 t - t * t) = 1 / (1 - t * t / (G4 t * G4 t)) := by
    have hden : 0 ≠ G4 t * G4 t - t * t := sub_ne_of_lt hgp
    field_simp [hden, hG2pos.ne', sub_pos_iff_lt.mpr hgp]
    ring
  have hw0 : 0 ≤ w t := by dsimp only [w]; nlinarith [ht0.le]
  have heps0 : 0 ≤ t * t / (G4 t * G4 t) :=
    div_nonneg (mul_nonneg ht0.le ht0.le) hG2pos.le
  have h4e : 4 * (t * t / (G4 t * G4 t)) * w t ≤ 2 * t * t := by
    have hw : 4 * (t * t / (G4 t * G4 t)) * w t = 4 * (t * t + 1 / 4) / (c4sq * t ^ 6) := by
      rw [w, hG4sq]
      field_simp [pow_pos ht0 8, pow_pos ht0 6, st_c4sq_pos.ne']
      ring
    rw [hw]
    have hden3 : 0 < c4sq * t ^ 6 := mul_pos st_c4sq_pos (pow_pos ht0 6)
    rw [le_div_iff₀ hden3]
    have ht6 : (1000 : ℝ) ^ 6 ≤ t ^ 6 := pow_le_pow_left₀ (by norm_num : (0 : ℝ) ≤ 1000) ht 6
    have hc4 : (2 : ℝ) ≤ c4sq * 1000 ^ 6 := by norm_num [c4sq]
    nlinarith [hc4, ht6, st_c4sq_pos.le]
  calc Cf t (G4 t)
      = 1 + 2 * w t * ((G4 t * G4 t) / (G4 t * G4 t - t * t)) := by
        dsimp only [Cf, w]
        ring
      _ = 1 + 2 * w t * (1 / (1 - t * t / (G4 t * G4 t))) := by rw [hfr]
      _ ≤ 1 + 2 * w t * (1 + 2 * (t * t / (G4 t * G4 t))) := by
        nlinarith [st_inv_eps (t * t / (G4 t * G4 t)) heps0 heps, hw0]
      _ = 1 + 2 * w t + 4 * (t * t / (G4 t * G4 t)) * w t := by ring
      _ ≤ 1 + 2 * w t + 2 * t * t := by nlinarith [h4e]
      _ ≤ 4 * t * t + 2 := by
        dsimp only [w]
        nlinarith

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
      rw [Real.log_mul (by norm_num : (0 : ℝ) < 62000000) (pow_pos ht0 4),
          Real.log_pow ht0 4]
      ring
    have hL : (6 : ℝ) < Real.log t := st_L6 t ht
    have hlp : 0 < Real.log 62000000 := Real.log_pos (by norm_num : (1 : ℝ) < 62000000)
    rw [heq]
    nlinarith [hL, hlp]
  have hllg : 0 < Real.log (Real.log (G4 t)) := Real.log_pos hlg1
  have hden : 0 < 2 * (G4 t * G4 t) := by
    apply mul_pos (by norm_num : (0 : ℝ) < 2)
    exact pow_pos hg1 2
  dsimp only [Kbar]
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
      _ ≤ 18 + 4 * L := st_log19L L (le_of_lt hL6)
  have hden2 : 2 * (G4 t * G4 t) = 2 * c4sq * t ^ 8 := by
    rw [st_G4sq t, c4sq]
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
    apply mul_pos (by norm_num : (0 : ℝ) < 2)
    exact mul_pos st_c4sq_pos (pow_pos ht0 8)
  dsimp only [Kbar]
  calc Kbar (G4 t)
      = (0.110 * (Real.log (G4 t) + 1 / 2) +
          0.290 * (Real.log (Real.log (G4 t)) + 1 / 2) + 2.290) / (2 * (G4 t * G4 t)) :=
        by dsimp only [Kbar]
      _ = (0.110 * (Real.log (G4 t) + 1 / 2) +
          0.290 * (Real.log (Real.log (G4 t)) + 1 / 2) + 2.290) / (2 * c4sq * t ^ 8) := by
        rw [hden2]
      _ ≤ (10 + 2 * L) / (2 * c4sq * t ^ 8) := by
        apply div_le_div_of_nonneg hnum
        exact hdenpos.le
      _ = Kbar4UB t := by
        dsimp only [Kbar4UB]
        rw [show (L : ℝ) = Real.log t from by dsimp only [L]]
        ring
        norm_num [c4sq]

/-- 0 <= X4fun t for t >= 1000. -/
lemma st_X4nonneg (t : ℝ) (ht : 1000 ≤ t) : 0 ≤ X4fun t := by
  dsimp only [X4fun]
  apply add_nonneg
  · apply mul_nonneg
    · dsimp only [Bf, w]
      have ht0 : 0 < t := st_tpos t ht
      have hg2 : 0 < G4 t * G4 t + 1 / 4 := by
        nlinarith [st_G4pos t ht]
      have hzf : z t = w t / (G4 t * G4 t + 1 / 4) := by
        dsimp only [z]
        rw [st_G4sq t]
        field_simp [(pow_pos ht0 8).ne', st_c4sq_pos.ne']
        ring
      have hz : z t < 1 / 2 := st_zhalf t ht
      have hden : 0 < 1 - z t := by nlinarith [hz]
      have hwpos : 0 < w t := by
        dsimp only [w]
        nlinarith [ht0.le]
      apply add_nonneg <;> (try apply add_nonneg)
      · apply div_nonneg (by norm_num : 0 ≤ 1)
        apply mul_pos (by norm_num : 0 < 2) hg2
      · apply div_nonneg ht0.le hg2
      · apply div_nonneg
        · apply mul_nonneg
          · nlinarith [hwpos]
          · apply div_nonneg hwpos.le hg2
        · exact hden
    · dsimp only [Sbar]
      have hllB : 0 < Real.log (Real.log (B4 t)) := by
        have hq : (1 : ℝ) < Real.log (B4 t) := by
          have hL : (6 : ℝ) < Real.log t := st_L6 t ht
          have hge : 4 * Real.log t ≤ Real.log (B4 t) := by
            dsimp only [B4]
            have ht4 : 0 < t ^ 4 := pow_pos (st_tpos t ht) 4
            have heq : Real.log (B4 t) = Real.log 124000000 + 4 * Real.log t := by
              rw [Real.log_mul (by norm_num : (0 : ℝ) < 124000000) ht4,
                  Real.log_pow (st_tpos t ht) 4]
              ring
            rw [heq]
            nlinarith [Real.log_pos (by norm_num : (1 : ℝ) < 124000000), hL]
          linarith [hge]
        exact Real.log_pos hq
      have hllG : 0 < Real.log (Real.log (G4 t)) := by
        have hq : (1 : ℝ) < Real.log (G4 t) := by
          have hL : (6 : ℝ) < Real.log t := st_L6 t ht
          have hge : 4 * Real.log t ≤ Real.log (G4 t) := by
            dsimp only [G4]
            have ht4 : 0 < t ^ 4 := pow_pos (st_tpos t ht) 4
            have heq : Real.log (G4 t) = Real.log 62000000 + 4 * Real.log t := by
              rw [Real.log_mul (by norm_num : (0 : ℝ) < 62000000) ht4,
                  Real.log_pow (st_tpos t ht) 4]
              ring
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
    · dsimp only [Cf, w]
      have ht0 : 0 < t := st_tpos t ht
      have hG4sq : G4 t * G4 t = c4sq * t ^ 8 := st_G4sq t
      have hgp : 0 < G4 t * G4 t - t * t := by
        rw [hG4sq]
        have ht6 : (1000 : ℝ) ^ 6 ≤ t ^ 6 := pow_le_pow_left₀ (by norm_num : (0 : ℝ) ≤ 1000) ht 6
        have hc4 : (2 : ℝ) ≤ c4sq * 1000 ^ 6 := by norm_num [c4sq]
        have hc4t : 2 ≤ c4sq * t ^ 6 := by
          calc 2 ≤ c4sq * 1000 ^ 6 := hc4
            _ ≤ c4sq * t ^ 6 := mul_le_mul_of_nonneg_left ht6 (st_c4sq_pos.le)
        nlinarith [hc4t, pow_pos ht0 2]
      have htpos : 0 < 2 * (w t) * (G4 t * G4 t) := by
        apply mul_pos (mul_pos (by norm_num : 0 < 2) (show 0 < w t from by
          dsimp only [w]; nlinarith [ht0.le]))
        exact sq_pos_of_pos (st_G4pos t ht)
      nlinarith [div_nonneg htpos.le hgp.le]
    · exact le_of_lt (st_Kbarpos t ht)

/-- (X4) X4fun t <= X4UBfun t for t >= 1000 (component chain). -/
lemma st_X4bound (t : ℝ) (ht : 1000 ≤ t) : X4fun t ≤ X4UBfun t := by
  dsimp only [X4fun]
  have hL0 : 0 ≤ Real.log t := Real.log_nonneg (by linarith : 1 ≤ t)
  have ht0 : 0 < t := st_tpos t ht
  have hBf : Bf t (G4 t) ≤ Bf4UB t := st_hBf4 t ht
  have hSsum : Sbar (B4 t) + Sbar (G4 t) ≤ SsumUB t := st_hSsum t ht
  have hSs0 : 0 ≤ Sbar (B4 t) + Sbar (G4 t) := by
    dsimp only [Sbar]
    nlinarith [st_logB_pos t ht, st_logG_pos t ht]
  have hCf : Cf t (G4 t) ≤ Cf4UB t := st_hCf4 t ht
  have hCf0 : 0 ≤ Cf t (G4 t) := by
    dsimp only [Cf, w]
    have ht6 : (1000 : ℝ) ^ 6 ≤ t ^ 6 := pow_le_pow_left₀ (by norm_num : (0 : ℝ) ≤ 1000) ht 6
    have hc4 : (2 : ℝ) ≤ c4sq * 1000 ^ 6 := by norm_num [c4sq]
    have hc4t : 2 ≤ c4sq * t ^ 6 := by
      calc 2 ≤ c4sq * 1000 ^ 6 := hc4
        _ ≤ c4sq * t ^ 6 := mul_le_mul_of_nonneg_left ht6 (st_c4sq_pos.le)
    nlinarith [hc4t, pow_pos ht0 2]
  have hK : Kbar (G4 t) ≤ Kbar4UB t := st_hKbar4 t ht
  have hK0 : 0 ≤ Kbar (G4 t) := le_of_lt (st_Kbarpos t ht)
  have hBf0 : 0 ≤ Bf4UB t := by
    dsimp only [Bf4UB]
    apply div_nonneg
    · nlinarith [div_nonneg (by norm_num : 0 ≤ 1) (pow_pos ht0 2).le]
    · exact le_of_lt (mul_pos (pow_pos ht0 6) st_c4sq_pos)
  set L := Real.log t
  have hL0' : 0 ≤ L := hL0
  calc Bf t (G4 t) * (Sbar (B4 t) + Sbar (G4 t)) + Cf t (G4 t) * Kbar (G4 t)
      ≤ Bf4UB t * (Sbar (B4 t) + Sbar (G4 t)) + Cf t (G4 t) * Kbar (G4 t) := by
        nlinarith [hBf, hSs0]
      _ ≤ Bf4UB t * SsumUB t + Cf t (G4 t) * Kbar (G4 t) := by
        nlinarith [hSsum, hBf0]
      _ ≤ Bf4UB t * SsumUB t + Cf4UB t * Kbar (G4 t) := by
        nlinarith [hCf, hK0]
      _ ≤ Bf4UB t * SsumUB t + Cf4UB t * Kbar4UB t := by
        nlinarith [hK, hCf0]

  -- Component-chain squeeze (exact rationals):
  --   Bf4UB*SsumUB + Cf4UB*Kbar4UB
  --     <= [2001001(20+4L) + 2000001(10+2L)] / (1e6 * c4sq * t^6)
  --     = (60020030 + 12004006 L) / (1e6 * c4sq * t^6)
  --     <= (160 + 35 L) / (1e16 * t^6)   (norm_num integer anchors, L >= 0)
  --     = X4UBfun t.
  have hTden : 0 < t ^ 6 * c4sq := mul_pos (pow_pos ht0 6) st_c4sq_pos
  have hb : Bf4UB t * SsumUB t ≤ (2001001 : ℝ) * (20 + 4 * L) / (10 ^ 6 * c4sq * t ^ 6) := by
    dsimp only [Bf4UB, SsumUB]
    have hinv : (2 : ℝ) + 1 / t + 1 / (t * t) ≤ 2001001 / 10 ^ 6 := by
      have h1t : 1 / t ≤ 1 / 1000 := by
        rw [inv_le_inv₀ ht0 (by norm_num : (0 : ℝ) < 1000)]
        exact ht
      have h1t2 : 1 / (t * t) ≤ 1 / 10 ^ 6 := by
        calc 1 / (t * t) = (1 / t) ^ 2 := by ring
          _ ≤ (1 / 1000) ^ 2 := pow_le_pow_left₀ (inv_nonneg ht0.le) h1t 2
          _ = 1 / 10 ^ 6 := by norm_num
      nlinarith [h1t, h1t2, show (2 : ℝ) ≤ 2001001 / 10 ^ 6 from by norm_num]
    have hS0 : 0 ≤ SsumUB t := by
      dsimp only [SsumUB]
      nlinarith [hL0]
    have hB0 : Bf4UB t * SsumUB t =
        (2 + 1 / t + 1 / (t * t)) * (SsumUB t) / (t ^ 6 * c4sq) := by
      dsimp only [Bf4UB, SsumUB]
      field_simp [hTden.ne']
      ring
    rw [hB0]
    calc (2 + 1 / t + 1 / (t * t)) * (SsumUB t) / (t ^ 6 * c4sq)
        ≤ (2001001 / 10 ^ 6) * (SsumUB t) / (t ^ 6 * c4sq) := by
          apply div_le_div_of_nonneg
          · nlinarith [hinv, hS0]
          · exact hTden.le
        _ = (2001001 : ℝ) * (20 + 4 * Real.log t) / (10 ^ 6 * c4sq * t ^ 6) := by
          dsimp only [SsumUB]
          field_simp [hTden.ne']
          ring
        _ = (2001001 : ℝ) * (20 + 4 * L) / (10 ^ 6 * c4sq * t ^ 6) := by
          dsimp only [L]
  have hc : Cf4UB t * Kbar4UB t ≤ (2000001 : ℝ) * (10 + 2 * L) / (10 ^ 6 * c4sq * t ^ 6) := by
    dsimp only [Cf4UB, Kbar4UB, L]
    have ht2 : (1000 : ℝ) ^ 2 ≤ t ^ 2 := pow_le_pow_left₀ (by norm_num : (0 : ℝ) ≤ 1000) ht 2
    have hc4 : (4 : ℝ) * t * t + 2 ≤ (4000002 : ℝ) / 10 ^ 6 * t * t := by
      have ht6 : (1 : ℝ) * 10 ^ 6 ≤ t * t := by
        norm_num at ht2
        ring_nf at ht2
        exact by simpa [pow_two] using ht2
      have hinv : 2 ≤ (2 : ℝ) / 10 ^ 6 * (t * t) := by
        nlinarith [ht6, show (10 ^ 6 : ℝ) > 0 from by norm_num]
      nlinarith [hinv]
    have hK0' : 0 ≤ (10 + 2 * Real.log t) / (2 * c4sq * t ^ 8) := by
      apply div_nonneg
      · nlinarith [hL0]
      · exact le_of_lt (by
          apply mul_pos (by norm_num : (0 : ℝ) < 2)
          exact mul_pos st_c4sq_pos (pow_pos ht0 8))
    have hC0 : Cf4UB t * Kbar4UB t =
        (4 * t * t + 2) * ((10 + 2 * Real.log t) / (2 * c4sq * t ^ 8)) := by
      dsimp only [Cf4UB, Kbar4UB]
      field_simp [c4sq]
      ring
    rw [hC0]
    calc (4 * t * t + 2) * ((10 + 2 * Real.log t) / (2 * c4sq * t ^ 8))
        ≤ ((4000002 : ℝ) / 10 ^ 6 * t * t) * ((10 + 2 * Real.log t) / (2 * c4sq * t ^ 8)) := by
          apply mul_le_mul_of_nonneg_left hc4 hK0'
        _ = (2000001 : ℝ) * (10 + 2 * Real.log t) / (10 ^ 6 * c4sq * t ^ 6) := by
          field_simp [(mul_pos st_c4sq_pos (pow_pos ht0 8)).ne', (pow_pos ht0 6).ne']
          ring
        _ = (2000001 : ℝ) * (10 + 2 * L) / (10 ^ 6 * c4sq * t ^ 6) := by
          dsimp only [L]
  have hc1 : (60020030 : ℝ) * 10 ^ 16 ≤ 10 ^ 6 * c4sq * 160 := by norm_num [c4sq]
  have hc2 : (12004006 : ℝ) * 10 ^ 16 ≤ 10 ^ 6 * c4sq * 35 := by norm_num [c4sq]
  have hsum : (60020030 + 12004006 * L) * 10 ^ 16 ≤ 10 ^ 6 * c4sq * (160 + 35 * L) := by
    nlinarith [hc1, hc2, mul_nonneg (by norm_num : 0 ≤ (12004006 : ℝ) * 10 ^ 16) hL0']
  have htotal : Bf4UB t * SsumUB t + Cf4UB t * Kbar4UB t ≤ X4UBfun t := by
    calc Bf4UB t * SsumUB t + Cf4UB t * Kbar4UB t
        ≤ (2001001 : ℝ) * (20 + 4 * L) / (10 ^ 6 * c4sq * t ^ 6) +
            (2000001 : ℝ) * (10 + 2 * L) / (10 ^ 6 * c4sq * t ^ 6) := by
          nlinarith [hb, hc]
    _ = (60020030 + 12004006 * L) / (10 ^ 6 * c4sq * t ^ 6) := by
      have hden : 0 ≠ 10 ^ 6 * c4sq * t ^ 6 := by
        intro h; nlinarith [show (0 : ℝ) < t ^ 6 * c4sq from by
          apply mul_pos (pow_pos ht0 6) st_c4sq_pos]
      field_simp [hden]
      ring
    _ ≤ (160 + 35 * L) / (10 ^ 16 * t ^ 6) := by
      have hsumt : (60020030 + 12004006 * L) * 10 ^ 16 * t ^ 6 ≤
          10 ^ 6 * c4sq * (160 + 35 * L) * t ^ 6 := by
        have ht6 : 0 ≤ t ^ 6 := pow_nonneg ht0.le 6
        exact mul_le_mul_of_nonneg_right hsum ht6
      have h1 : 0 < 10 ^ 6 * c4sq * t ^ 6 := by
        apply mul_pos (mul_pos (pow_pos (by norm_num : (0 : ℝ) < 10) 6) st_c4sq_pos)
        exact pow_pos ht0 6
      have h2 : 0 < 10 ^ 16 * t ^ 6 := by
        apply mul_pos (pow_pos (by norm_num : (0 : ℝ) < 10) 16) (pow_pos ht0 6)
      field_simp [h1.ne', h2.ne']
      nlinarith [hsumt]
    _ = X4UBfun t := by
      have hden : 0 < 10 ^ 16 * t ^ 6 := by
        apply mul_pos (pow_pos (by norm_num : (0 : ℝ) < 10) 16) (pow_pos ht0 6)
      dsimp only [X4UBfun]
      field_simp [hden.ne']
      ring
  nlinarith [htotal]

/-- X4fun t <= 1/2 for t >= 1000. -/
lemma st_X4half (t : ℝ) (ht : 1000 ≤ t) : X4fun t ≤ 1 / 2 := by
  calc X4fun t ≤ X4UBfun t := st_X4bound t ht
    _ ≤ 1 / 2 := by
      dsimp only [X4UBfun]
      have ht0 : 0 < t := st_tpos t ht
      have ht5 : (1000 : ℝ) ^ 5 ≤ t ^ 5 := pow_le_pow_left₀ (by norm_num : (0 : ℝ) ≤ 1000) ht 5
      have hL0 : 0 ≤ Real.log t := Real.log_nonneg (by linarith : 1 ≤ t)
      have hL2 : (Real.log t) ^ 2 ≤ t := st_L2le_t t ht
      have hLtle : Real.log t ≤ t := by
        have ht2 : t ≤ t * t := by nlinarith [ht0.le, ht]
        have hL2t : (Real.log t) ^ 2 ≤ t * t := le_trans hL2 ht2
        exact (sq_le_sq₀ hL0 (sq_nonneg t)).mpr hL2t
      calc (16 / 10 ^ 15 + 35 / 10 ^ 16 * Real.log t) / t ^ 6
          = 16 / (10 ^ 15 * t ^ 6) + 35 * Real.log t / (10 ^ 16 * t ^ 6) := by
            field_simp [(pow_pos ht0 6).ne']
            ring
          _ ≤ 16 / (10 ^ 15 * t ^ 6) + 35 * t / (10 ^ 16 * t ^ 6) := by
            apply add_le_add (by ring)
            have hlt : Real.log t / (10 ^ 16 * t ^ 6) ≤ t / (10 ^ 16 * t ^ 6) := by
              apply div_le_div_of_nonneg hLtle
              nlinarith [pow_pos (by norm_num : (0 : ℝ) < 10) 16, pow_pos ht0 6]
            nlinarith [hlt]
          _ ≤ 16 / (10 ^ 15 * 10 ^ 18 : ℝ) + 35 / (10 ^ 16 * 10 ^ 15 : ℝ) := by
            have h5 : 35 * t / (10 ^ 16 * t ^ 6) = 35 / (10 ^ 16 * t ^ 5) := by
              field_simp [(pow_pos ht0 6).ne', (pow_pos ht0 5).ne']
              ring
            have h6 : (1000 : ℝ) ^ 6 ≤ t ^ 6 := pow_le_pow_left₀ (by norm_num : (0 : ℝ) ≤ 1000) ht 6
            have h6a : 16 / (10 ^ 15 * t ^ 6) ≤ 16 / (10 ^ 15 * 10 ^ 18 : ℝ) := by
              rw [div_le_div_iff₀ (mul_pos (pow_pos (by norm_num : (0 : ℝ) < 10) 15) (pow_pos ht0 6))
                  (mul_pos (pow_pos (by norm_num : (0 : ℝ) < 10) 15) (pow_pos (by norm_num : (0 : ℝ) < 1000) 6))]
              nlinarith [h6]
            have h6b : 35 / (10 ^ 16 * t ^ 5) ≤ 35 / (10 ^ 16 * 10 ^ 15 : ℝ) := by
              rw [div_le_div_iff₀ (mul_pos (pow_pos (by norm_num : (0 : ℝ) < 10) 16) (pow_pos ht0 5))
                  (mul_pos (pow_pos (by norm_num : (0 : ℝ) < 10) 16) (pow_pos (by norm_num : (0 : ℝ) < 1000) 5))]
              nlinarith [ht5]
            rw [h5]
            nlinarith [h6a, h6b]
          _ ≤ 1 / 2 := by norm_num

/-- exp (1/2) <= 2. -/
lemma st_e12 : Real.exp (1 / 2) ≤ 2 := by
  have h34 : Real.exp 1 < 4 := by linarith [Real.exp_one_lt_three]
  have hsq : (Real.exp (1 / 2) : ℝ) ^ 2 < 4 := by
    calc (Real.exp (1 / 2) : ℝ) ^ 2 = Real.exp (1 / 2) * Real.exp (1 / 2) := by ring
      _ = Real.exp (1 / 2 + 1 / 2) := by rw [Real.exp_add (1 / 2) (1 / 2)]
      _ = Real.exp 1 := by rw [show (1 / 2 : ℝ) + 1 / 2 = 1 from by norm_num]
      _ < 4 := h34
  have hp : 0 ≤ Real.exp (1 / 2) := Real.exp_nonneg (1 / 2)
  exact (sq_le_sq₀ hp (by norm_num : (0 : ℝ) ≤ 2)).mpr (le_of_lt hsq)

/-- (E4) exp (X4fun t) <= 2 for t >= 1000. -/
lemma st_eX4le2 (t : ℝ) (ht : 1000 ≤ t) : Real.exp (X4fun t) ≤ 2 := by
  calc Real.exp (X4fun t) ≤ Real.exp (1 / 2) :=
        Real.exp_le_exp (st_X4half t ht)
    _ ≤ 2 := st_e12
