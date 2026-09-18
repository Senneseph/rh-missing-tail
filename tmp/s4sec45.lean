/- — §4: mown floor — F4·t⁻² ≤ mown(t,d); — §5: M-term chain + final squeeze.
    Certified chains: scripts/rh/day028_25af_constants.py [5] and the M-chain [4]. — -/

/-- (F4a) floor: F4·t⁻² ≤ mown(t, d) for d ≥ 1/200, t ≥ 1000. -/
theorem st_mownfloor (t d : ℝ) (ht : 1000 ≤ t) (hd0 : 0 < d) (hdl : (1 / 200 : ℝ) ≤ d)
    (hd : d ≤ 1 / 2) :
    F4 * t ^ (-2 : ℝ) ≤ S4O.mown t d := by
  have ht0 : 0 < t := st_tpos t ht
  have hscale : (4 * d ^ 2 / t ^ 2) * (t ^ 2 / (t ^ 2 + 1)) ^ 2 ≤ S4O.mown t d :=
    S4O.hMownScaleLo t d ht0 hd0 hd
  have hd2 : (4 : ℝ) * (1 / 200) ^ 2 ≤ 4 * d ^ 2 := by
    have hsq : (1 / 200 : ℝ) ^ 2 ≤ d ^ 2 :=
      (sq_le_sq₀ (by norm_num : (0 : ℝ) ≤ 1 / 200) (le_of_lt hd0)).mpr hdl
    exact mul_le_mul_of_nonneg_left hsq (by norm_num : (0 : ℝ) ≤ 4)
  have hstep1 : (4 * (1 / 200 : ℝ) ^ 2) / t ^ 2 ≤ 4 * d ^ 2 / t ^ 2 := by
    rw [div_le_div_iff₀ (pow_pos ht0 2) (pow_pos ht0 2)]
    exact mul_le_mul_of_nonneg_left hd2
      (mul_nonneg (by norm_num : (0 : ℝ) ≤ 4) (pow_nonneg ht0.le 2))
  have ht2 : (1000 : ℝ) ^ 2 ≤ t ^ 2 := pow_le_pow_left₀ (by norm_num : (0 : ℝ) ≤ 1000) ht 2
  have hfrac : (1000 : ℝ) ^ 2 / ((1000 : ℝ) ^ 2 + 1) ≤ t ^ 2 / (t ^ 2 + 1) := by
    rw [div_le_div_iff₀ (by nlinarith : (0 : ℝ) < (1000 : ℝ) ^ 2 + 1)
        (by nlinarith : (0 : ℝ) < t ^ 2 + 1)]
    nlinarith [ht2]
  have hfrac2 : ((1000 : ℝ) ^ 2 / ((1000 : ℝ) ^ 2 + 1)) ^ 2 ≤ (t ^ 2 / (t ^ 2 + 1)) ^ 2 := by
    have ha : (0 : ℝ) ≤ (1000 : ℝ) ^ 2 / ((1000 : ℝ) ^ 2 + 1) := by
      apply div_nonneg
      · norm_num
      · nlinarith
    exact pow_le_pow_left₀ ha hfrac 2
  have hcombo : (4 * (1 / 200 : ℝ) ^ 2) / t ^ 2 *
      ((1000 : ℝ) ^ 2 / ((1000 : ℝ) ^ 2 + 1)) ^ 2 ≤
      (4 * d ^ 2 / t ^ 2) * (t ^ 2 / (t ^ 2 + 1)) ^ 2 := by
    calc (4 * (1 / 200 : ℝ) ^ 2) / t ^ 2 * ((1000 : ℝ) ^ 2 / ((1000 : ℝ) ^ 2 + 1)) ^ 2
        ≤ ((4 * (1 / 200 : ℝ) ^ 2) / t ^ 2) * (t ^ 2 / (t ^ 2 + 1)) ^ 2 := by
          have hpre : 0 ≤ (4 * (1 / 200 : ℝ) ^ 2) / t ^ 2 := by
            apply div_nonneg
            · norm_num
            · exact pow_nonneg ht0.le 2
          exact mul_le_mul_of_nonneg_left hfrac2 hpre
      _ ≤ (4 * d ^ 2 / t ^ 2) * (t ^ 2 / (t ^ 2 + 1)) ^ 2 := by
        have hv : 0 ≤ (t ^ 2 / (t ^ 2 + 1)) ^ 2 := by
          apply pow_nonneg
          apply div_nonneg
          · exact pow_nonneg ht0.le 2
          · nlinarith
        exact mul_le_mul_of_nonneg_right hstep1 hv
  have hF : F4 * t ^ (-2 : ℝ) =
      (4 * (1 / 200 : ℝ) ^ 2) / t ^ 2 * ((1000 : ℝ) ^ 2 / ((1000 : ℝ) ^ 2 + 1)) ^ 2 := by
    dsimp only [F4]
    have hinv : (t : ℝ) ^ (-2 : ℝ) = 1 / (t : ℝ) ^ 2 := by
      rw [Real.rpow_neg ht0 2, show (t : ℝ) ^ (2 : ℝ) = (t ^ 2 : ℝ) from by simp]
      exact (one_div (t ^ 2)).symm
    rw [hinv]
    field_simp [(st_tpos t ht).ne']
    ring
  calc F4 * t ^ (-2 : ℝ)
      = (4 * (1 / 200 : ℝ) ^ 2) / t ^ 2 * ((1000 : ℝ) ^ 2 / ((1000 : ℝ) ^ 2 + 1)) ^ 2 := hF
    _ ≤ (4 * d ^ 2 / t ^ 2) * (t ^ 2 / (t ^ 2 + 1)) ^ 2 := hcombo
    _ ≤ S4O.mown t d := hscale

/-- (Z) final constant: A1 + (A2 + A3 + 25/10¹⁵)/10³ < F4. -/
theorem st_finalconst : A1 + (A2 + A3 + 25 / 10 ^ 15) / 1000 < F4 := by
  dsimp only [A1, A2, A3, F4]
  norm_num

/-- (S) W+M cap at the strip: p8_B + M-term ≤ [A1+(A2+A3+25/10¹⁵)/10³]·t⁻². -/
theorem st_hSQ (t M : ℝ) (ht : 1000 ≤ t) (hM0 : 0 ≤ M) (hMz : M ≤ S4W.Zbound t) :
    p8_B t (n4 t) + M * Real.exp (X4fun t) * X4fun t ≤
        (A1 + (A2 + A3 + 25 / 10 ^ 15) / 1000) * t ^ (-2 : ℝ) := by
  have ht0 : 0 < t := st_tpos t ht
  have hW := st_hW t ht
  have hM := st_hMterm t M ht hM0 hMz
  -- C·t^(-k) ≤ C·10⁻³·t⁻² for C ≥ 0, k ≥ 3, t ≥ 1000
  have hterm (C : ℝ) (k : ℝ) (hC : 0 ≤ C) (hk3 : (3 : ℝ) ≤ k) :
      C * t ^ (-k) ≤ C / 1000 * t ^ (-2 : ℝ) := by
    have hpow : t ^ (-k) ≤ t ^ (-3 : ℝ) :=
      Real.rpow_le_rpow_of_exponent_le (by linarith : (1 : ℝ) ≤ t) (by linarith : -k ≤ -3)
    have hA : C * t ^ (-k) ≤ C * t ^ (-3 : ℝ) := mul_le_mul_of_nonneg_left hpow hC
    have hinv1 : t ^ (-1 : ℝ) ≤ 1 / 1000 := by
      rw [show (t : ℝ) ^ (-1 : ℝ) = 1 / t from by
        rw [Real.rpow_neg ht0 1, Real.rpow_one, ← one_div]]
      rw [one_div_le_one_div ht0 (by norm_num : (0 : ℝ) < 1000)]
      linarith
    have hB : C * t ^ (-3 : ℝ) ≤ C / 1000 * t ^ (-2 : ℝ) := by
      calc C * t ^ (-3 : ℝ)
          = C * (t ^ (-2 : ℝ) * t ^ (-1 : ℝ)) := by
            have heq : (t : ℝ) ^ (-2 : ℝ) * (t : ℝ) ^ (-1 : ℝ) = (t : ℝ) ^ (-3 : ℝ) := by
              rw [Real.rpow_add ht0 (-2 : ℝ) (-1 : ℝ)]
              rw [show (-2 : ℝ) + (-1 : ℝ) = (-3 : ℝ) from by ring]
            rw [← heq]
            ring
          _ ≤ C * (t ^ (-2 : ℝ) * (1 / 1000)) := by
            have hstep : t ^ (-2 : ℝ) * t ^ (-1 : ℝ) ≤ t ^ (-2 : ℝ) * (1 / 1000) :=
              mul_le_mul_of_nonneg_right hinv1 (Real.rpow_nonneg ht0.le (-2 : ℝ))
            exact mul_le_mul_of_nonneg_left hstep hC
          _ = C / 1000 * t ^ (-2 : ℝ) := by ring
    calc C * t ^ (-k)
        ≤ C * t ^ (-3 : ℝ) := hA
      _ ≤ C / 1000 * t ^ (-2 : ℝ) := hB
  have hA2c := hterm A2 (5 : ℝ) (by dsimp only [A2]; norm_num) (by norm_num)
  have hA3c := hterm A3 (7 : ℝ) (by dsimp only [A3]; norm_num) (by norm_num)
  have hMc := hterm (25 / 10 ^ 15) (19 / 4 : ℝ) (by norm_num) (by norm_num)
  have hmt : MTUBfun t = (25 / 10 ^ 15 : ℝ) * t ^ (-19 / 4 : ℝ) := by
    dsimp only [MTUBfun]
    have hinv : (t : ℝ) ^ (-19 / 4 : ℝ) = 1 / t ^ (19 / 4 : ℝ) := by
      rw [Real.rpow_neg ht0 (19 / 4 : ℝ)]
      exact (one_div (t ^ (19 / 4 : ℝ))).symm
    rw [hinv]
    ring
  have hMtc : MTUBfun t ≤ 25 / 10 ^ 15 / 1000 * t ^ (-2 : ℝ) := by
    rw [hmt]
    exact hMc
  have hWcap : A1 * t ^ (-2 : ℝ) + A2 * t ^ (-5 : ℝ) + A3 * t ^ (-7 : ℝ) ≤
      (A1 + (A2 + A3) / 1000) * t ^ (-2 : ℝ) := by
    nlinarith [hA2c, hA3c]
  calc p8_B t (n4 t) + M * Real.exp (X4fun t) * X4fun t
      ≤ A1 * t ^ (-2 : ℝ) + A2 * t ^ (-5 : ℝ) + A3 * t ^ (-7 : ℝ) + MTUBfun t := by
        nlinarith [hW, hM]
    _ ≤ (A1 + (A2 + A3) / 1000) * t ^ (-2 : ℝ) + MTUBfun t := add_le_add hWcap le_rfl
    _ ≤ (A1 + (A2 + A3) / 1000) * t ^ (-2 : ℝ) + 25 / 10 ^ 15 / 1000 *
        t ^ (-2 : ℝ) := add_le_add le_rfl hMtc
    _ = (A1 + (A2 + A3 + 25 / 10 ^ 15) / 1000) * t ^ (-2 : ℝ) := by ring

/-- (MT) M-term: M·exp(X4)·X4 ≤ MTUB(t) for M ≤ Zbound(t). -/
theorem st_hMterm (t M : ℝ) (ht : 1000 ≤ t) (hM0 : 0 ≤ M) (hMz : M ≤ S4W.Zbound t) :
    M * Real.exp (X4fun t) * X4fun t ≤ MTUBfun t := by
  have ht0 : 0 < t := st_tpos t ht
  set L := Real.log t with hLdef
  have hx4 : (0 : ℝ) ≤ X4fun t := st_X4nonneg t ht
  have hx4ub : X4fun t ≤ X4UBfun t := st_X4bound t ht
  have hexp : Real.exp (X4fun t) ≤ 2 := st_eX4le2 t ht
  have hs1 : M * Real.exp (X4fun t) * X4fun t ≤ M * 2 * X4fun t := by
    have hMexp : M * Real.exp (X4fun t) ≤ M * 2 :=
      mul_le_mul_of_nonneg_right hexp hM0
    exact mul_le_mul_of_nonneg_right hMexp hx4
  have hs2 : M * 2 * X4fun t ≤ S4W.Zbound t * 2 * X4fun t := by
    have ht2x : (0 : ℝ) ≤ 2 * X4fun t :=
      mul_nonneg (by norm_num : (0 : ℝ) ≤ 2) hx4
    rw [show (M : ℝ) * 2 * X4fun t = M * (2 * X4fun t) from by ring,
        show (S4W.Zbound t : ℝ) * 2 * X4fun t = S4W.Zbound t * (2 * X4fun t) from by ring]
    exact mul_le_mul_of_nonneg_right hMz ht2x
  have hs3 : S4W.Zbound t * 2 * X4fun t = (32 / 10 : ℝ) * t ^ (1 / 4 : ℝ) * L * X4fun t := by
    dsimp only [S4W.Zbound]
    rw [hLdef]
    ring
  have hc4 : (0 : ℝ) ≤ (32 / 10 : ℝ) * t ^ (1 / 4 : ℝ) * L := by
    apply mul_nonneg
    · norm_num
    · apply mul_nonneg
      · exact Real.rpow_nonneg ht0.le (1 / 4 : ℝ)
      · exact Real.log_nonneg (by linarith : (1 : ℝ) ≤ t)
  have hs4 : (32 / 10 : ℝ) * t ^ (1 / 4 : ℝ) * L * X4fun t ≤
      (32 / 10 : ℝ) * t ^ (1 / 4 : ℝ) * L * X4UBfun t :=
    mul_le_mul_of_nonneg_right hx4ub hc4
  have hs5 : (32 / 10 : ℝ) * t ^ (1 / 4 : ℝ) * L * X4UBfun t =
      (32 / 10 : ℝ) * t ^ (1 / 4 : ℝ) * L * ((16 / 10 ^ 15 + 35 / 10 ^ 16 * L) / t ^ 6) := by
    dsimp only [X4UBfun]
    have hLd : Real.log t = L := by rw [← hLdef]
    rw [hLd]
  have hsumub : (16 / 10 ^ 15 + 35 / 10 ^ 16 * L : ℝ) * L ≤ (62 / 10 ^ 16 : ℝ) * L * L := by
    have hLge : (160 : ℝ) / 27 ≤ L := st_L16027 t ht
    have hL0 : (0 : ℝ) ≤ L := (by norm_num : (0 : ℝ) ≤ 160 / 27).le.trans hLge
    have hcore : (160 : ℝ) * L ≤ (27 : ℝ) * L * L := by
      have h1 : (160 / 27 : ℝ) * L ≤ L * L := mul_le_mul_of_nonneg_right hLge hL0
      calc (160 : ℝ) * L
          = (160 / 27 : ℝ) * L * 27 := by ring
        _ ≤ L * L * 27 := mul_le_mul_of_nonneg_right h1 (by norm_num : (0 : ℝ) ≤ 27)
        _ = (27 : ℝ) * L * L := by ring
    have hswitch : (16 / 10 ^ 15 : ℝ) * L ≤ (27 / 10 ^ 16 : ℝ) * L * L := by
      rw [show (16 / 10 ^ 15 : ℝ) * L = (160 : ℝ) * L / 10 ^ 16 from by ring,
          show (27 / 10 ^ 16 : ℝ) * L * L = (27 : ℝ) * L * L / 10 ^ 16 from by ring]
      rw [div_le_div_iff₀ (by norm_num : (0 : ℝ) < 10 ^ 16)
          (by norm_num : (0 : ℝ) < 10 ^ 16)]
      exact hcore
    calc (16 / 10 ^ 15 + 35 / 10 ^ 16 * L) * L
        = (16 / 10 ^ 15) * L + (35 / 10 ^ 16) * L * L := by ring
      _ ≤ (27 / 10 ^ 16) * L * L + (35 / 10 ^ 16) * L * L :=
          add_le_add hswitch le_rfl
      _ = (62 / 10 ^ 16) * L * L := by ring
  have hs7 : (32 / 10 : ℝ) * t ^ (1 / 4 : ℝ) * L * ((16 / 10 ^ 15 + 35 / 10 ^ 16 * L) / t ^ 6) ≤
      (32 / 10 : ℝ) * (62 / 10 ^ 16 : ℝ) * L * L * t ^ (-23 / 4 : ℝ) := by
    calc (32 / 10 : ℝ) * t ^ (1 / 4 : ℝ) * L * ((16 / 10 ^ 15 + 35 / 10 ^ 16 * L) / t ^ 6)
        = (32 / 10 : ℝ) * t ^ (1 / 4 : ℝ) * L *
            ((16 / 10 ^ 15 + 35 / 10 ^ 16 * L) * t ^ (-6 : ℝ)) := by
          have hinvA : ((16 / 10 ^ 15 + 35 / 10 ^ 16 * L : ℝ) / t ^ 6) =
              (16 / 10 ^ 15 + 35 / 10 ^ 16 * L) * (1 / (t : ℝ) ^ 6) := by ring
          rw [hinvA]
          have hinv6 : 1 / (t : ℝ) ^ 6 = (t : ℝ) ^ (-6 : ℝ) := by
            rw [Real.rpow_neg ht0 6, show (t : ℝ) ^ (6 : ℝ) = (t ^ 6 : ℝ) from by simp]
            exact (one_div (t ^ 6)).symm
          rw [hinv6]
          ring
      _ = (32 / 10 : ℝ) * (16 / 10 ^ 15 + 35 / 10 ^ 16 * L) * L *
          ((t : ℝ) ^ (1 / 4 : ℝ) * t ^ (-6 : ℝ)) := by ring
      _ = (32 / 10 : ℝ) * (16 / 10 ^ 15 + 35 / 10 ^ 16 * L) * L * t ^ (-23 / 4 : ℝ) := by
          have ht23 : (t : ℝ) ^ (1 / 4 : ℝ) * (t : ℝ) ^ (-6 : ℝ) = (t : ℝ) ^ (-23 / 4 : ℝ) := by
            rw [← Real.rpow_add ht0 (1 / 4 : ℝ) (-6 : ℝ)]
            rw [show (1 / 4 : ℝ) + (-6 : ℝ) = (-23 / 4 : ℝ) from by ring]
          rw [ht23]
      _ ≤ (32 / 10 : ℝ) * (62 / 10 ^ 16 : ℝ) * L * L * t ^ (-23 / 4 : ℝ) := by
          have hpre : (0 : ℝ) ≤ (32 / 10 : ℝ) * L * t ^ (-23 / 4 : ℝ) := by
            apply mul_nonneg
            · norm_num
            · apply mul_nonneg
              · exact Real.log_nonneg (by linarith : (1 : ℝ) ≤ t)
              · exact Real.rpow_nonneg ht0.le (-23 / 4 : ℝ)
          calc (32 / 10 : ℝ) * (16 / 10 ^ 15 + 35 / 10 ^ 16 * L) * L * t ^ (-23 / 4 : ℝ)
              = (32 / 10 : ℝ) * L * t ^ (-23 / 4 : ℝ) * ((16 / 10 ^ 15 + 35 / 10 ^ 16 * L) * L) := by ring
                _ ≤ (32 / 10 : ℝ) * L * t ^ (-23 / 4 : ℝ) * ((62 / 10 ^ 16 : ℝ) * L * L) :=
                    mul_le_mul_of_nonneg_right hsumub hpre
                _ = (32 / 10 : ℝ) * (62 / 10 ^ 16 : ℝ) * L * L * t ^ (-23 / 4 : ℝ) := by ring
  have hs8 : (32 / 10 : ℝ) * (62 / 10 ^ 16 : ℝ) * L * L * t ^ (-23 / 4 : ℝ) ≤
      (32 / 10 : ℝ) * (62 / 10 ^ 16 : ℝ) * t * t ^ (-23 / 4 : ℝ) := by
    have hL2 : L * L ≤ (t : ℝ) := by
      have h1 : L * L = (Real.log t) ^ 2 := by
        rw [hLdef, hLdef, pow_two]
      rw [h1]
      exact st_L2le_t t ht
    have hpre : (0 : ℝ) ≤ (32 / 10 : ℝ) * (62 / 10 ^ 16 : ℝ) * t ^ (-23 / 4 : ℝ) := by
      apply mul_nonneg
      · norm_num
      · apply mul_nonneg
        · norm_num
        · exact Real.rpow_nonneg ht0.le (-23 / 4 : ℝ)
    calc (32 / 10 : ℝ) * (62 / 10 ^ 16 : ℝ) * L * L * t ^ (-23 / 4 : ℝ)
        = (32 / 10 : ℝ) * (62 / 10 ^ 16 : ℝ) * t ^ (-23 / 4 : ℝ) * (L * L) := by ring
      _ ≤ (32 / 10 : ℝ) * (62 / 10 ^ 16 : ℝ) * t ^ (-23 / 4 : ℝ) * t :=
          mul_le_mul_of_nonneg_right hL2 hpre
      _ = (32 / 10 : ℝ) * (62 / 10 ^ 16 : ℝ) * t * t ^ (-23 / 4 : ℝ) := by ring
  have ht19 : (t : ℝ) * t ^ (-23 / 4 : ℝ) = t ^ (-19 / 4 : ℝ) := by
    rw [show (t : ℝ) * (t : ℝ) ^ (-23 / 4 : ℝ) = (t : ℝ) ^ (1 : ℝ) * (t : ℝ) ^ (-23 / 4 : ℝ) from
        (congrArg (fun (x : ℝ) => x * (t : ℝ) ^ (-23 / 4 : ℝ)) (Real.rpow_one t).symm)]
    rw [← Real.rpow_add ht0 (1 : ℝ) (-23 / 4 : ℝ)]
    rw [show (1 : ℝ) + (-23 / 4 : ℝ) = (-19 / 4 : ℝ) from by ring]
  calc M * Real.exp (X4fun t) * X4fun t
      ≤ M * 2 * X4fun t := hs1
    _ ≤ S4W.Zbound t * 2 * X4fun t := hs2
    _ = (32 / 10 : ℝ) * t ^ (1 / 4 : ℝ) * L * X4fun t := by rw [hs3]
    _ ≤ (32 / 10 : ℝ) * t ^ (1 / 4 : ℝ) * L * X4UBfun t := hs4
    _ = (32 / 10 : ℝ) * t ^ (1 / 4 : ℝ) * L * ((16 / 10 ^ 15 + 35 / 10 ^ 16 * L) / t ^ 6) := by rw [hs5]
    _ ≤ (32 / 10 : ℝ) * (62 / 10 ^ 16 : ℝ) * L * L * t ^ (-23 / 4 : ℝ) := hs7
    _ ≤ (32 / 10 : ℝ) * (62 / 10 ^ 16 : ℝ) * t * t ^ (-23 / 4 : ℝ) := hs8
    _ = (32 / 10 : ℝ) * (62 / 10 ^ 16 : ℝ) * t ^ (-19 / 4 : ℝ) := by rw [ht19]
    _ ≤ (25 / 10 ^ 15 : ℝ) * t ^ (-19 / 4 : ℝ) :=
        mul_le_mul_of_nonneg_right (by norm_num : (32 / 10 : ℝ) * (62 / 10 ^ 16 : ℝ) ≤ 25 / 10 ^ 15)
          (Real.rpow_nonneg ht0.le (-19 / 4 : ℝ))
    _ = MTUBfun t := by
      dsimp only [MTUBfun]
      have hinv : (t : ℝ) ^ (-19 / 4 : ℝ) = 1 / t ^ (19 / 4 : ℝ) := by
        rw [Real.rpow_neg ht0 (19 / 4 : ℝ)]
        exact (one_div (t ^ (19 / 4 : ℝ))).symm
      rw [hinv]
      ring

/- — THE (i-b) STRIP CLOSURE (bound level, 25af). — -/

/-- THE 25af OWN-REGIME STRIP CLOSURE. For 1000 ≤ t, 1/200 ≤ d ≤ 1/2, M ∈ [0, Zbound(t)]:
    p8_B(t, n4 t) + M·exp(X4(t))·X4(t) < mown(t, d). -/
theorem s4_strip_close (t d M : ℝ) (ht : 1000 ≤ t) (hd0 : 0 < d)
    (hdl : (1 / 200 : ℝ) ≤ d) (hd : d ≤ 1 / 2)
    (hM0 : 0 ≤ M) (hMz : M ≤ S4W.Zbound t) :
    p8_B t (n4 t) + M * Real.exp (X4fun t) * X4fun t < S4O.mown t d := by
  have hfloor : F4 * t ^ (-2 : ℝ) ≤ S4O.mown t d := st_mownfloor t d ht hd0 hdl hd
  have hsqe : p8_B t (n4 t) + M * Real.exp (X4fun t) * X4fun t ≤
      (A1 + (A2 + A3 + 25 / 10 ^ 15) / 1000) * t ^ (-2 : ℝ) := st_hSQ t M ht hM0 hMz
  have htin2 : 0 < t ^ (-2 : ℝ) := Real.rpow_pos_of_pos (st_tpos t ht) (-2 : ℝ)
  have hstrict : (A1 + (A2 + A3 + 25 / 10 ^ 15) / 1000) * t ^ (-2 : ℝ) <
      F4 * t ^ (-2 : ℝ) :=
    mul_lt_mul_of_pos_right st_finalconst htin2
  have h1 : p8_B t (n4 t) + M * Real.exp (X4fun t) * X4fun t < F4 * t ^ (-2 : ℝ) :=
    lt_of_le_of_lt hsqe hstrict
  exact lt_le_trans h1 hfloor
