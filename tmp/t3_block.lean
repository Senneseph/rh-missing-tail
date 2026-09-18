  --/ (3B.10) the sharpened T3 bound on the critical line (25ae F1): with
  --|  T3(s, n) := -(1/2)·s(s+1)·∫_n^∞ B2(x)·x^{-s-2} dx,
  --|  |T3| <= |s(s+1)(s+2)| n^{-7/2}/720
  --|        + |s(s+1)(s+2)(s+3)(s+4)| n^{-9/2}/30240
  --|        + |s(s+1)(s+2)..(s+6)| n^{-15/2}/1209600
  --|        + |s(s+1)(s+2)..(s+6)(s+7)| n^{-15/2}/9072000.
  --|  Uses J_eq (4-term decomposition), I8_bound for the residual integral,
  --|  and the endpoint values B4(0)=-1/30, B6(0)=1/42, B8(0)=-1/30. -/
  theorem p4_25ae_T3_bound {s : ℂ} (hsre : s.re = 1 / 2) (n : ℕ) (hn : 0 < n) :
      ‖(-(1 / 2 : ℂ) * s * (s + 1)) *
        (∫ x : ℝ in Set.Ioi (n : ℝ), (B2 x : ℂ) * (x : ℂ) ^ (-s - 2))‖ ≤
          ‖s * (s + 1) * (s + 2)‖ * (n : ℝ) ^ (-(7 : ℝ) / 2) / 720
        + ‖s * (s + 1) * (s + 2) * (s + 3) * (s + 4)‖ *
            (n : ℝ) ^ (-(9 : ℝ) / 2) / 30240
        + ‖s * (s + 1) * (s + 2) * (s + 3) * (s + 4) * (s + 5) * (s + 6)‖ *
            (n : ℝ) ^ (-(15 : ℝ) / 2) / 1209600
        + ‖s * (s + 1) * (s + 2) * (s + 3) * (s + 4) * (s + 5) * (s + 6) * (s + 7)‖ *
            (n : ℝ) ^ (-(15 : ℝ) / 2) / 9072000 := by
    set F8 := (∫ x : ℝ in Set.Ioi (n : ℝ), (B8 x : ℂ) * (x : ℂ) ^ (-s - 8)) with hF8
    set A' := ((s + 2 : ℂ) / 3) * (((B4poly 0) / 4) : ℂ) with hA
    set B' := ((s + 2 : ℂ) * (s + 3) * (s + 4) / 60) * (((B6poly 0) / 6) : ℂ) with hB
    set C' := ((s + 2 : ℂ) * (s + 3) * (s + 4) * (s + 5) * (s + 6) / 2520) *
        (((B8poly 0) / 8) : ℂ) with hC
    set D' := ((s + 2 : ℂ) * (s + 3) * (s + 4) * (s + 5) * (s + 6) * (s + 7) / 20160)
        with hD
    set U3 := A' * (0 - ((n : ℝ) : ℂ) ^ (-s - 3)) with hU3
    set U5 := B' * (0 - ((n : ℝ) : ℂ) ^ (-s - 5)) with hU5
    set U7 := C' * (0 - ((n : ℝ) : ℂ) ^ (-s - 7)) with hU7
    set U8 := D' * F8 with hU8
    set K4 := U3 + (U5 + (U7 + U8)) with hK4
    rw [p4_25ae_J_eq hsre n hn]
    -- bridge the J_eq RHS (left-associated U3+U5+U7+U8) to K4
    rw [show A' * (0 - ((n : ℝ) : ℂ) ^ (-s - 3)) +
            (B' * (0 - ((n : ℝ) : ℂ) ^ (-s - 5)) +
              (C' * (0 - ((n : ℝ) : ℂ) ^ (-s - 7)) + D' * F8)) = K4 from by
      dsimp only [K4, U3, U5, U7, U8]
      ring]
    have hneg : ‖-((1 / 2 : ℂ) * s * (s + 1) * K4)‖ = ‖(1 / 2 : ℂ) * s * (s + 1) * K4‖ :=
      norm_neg _
    rw [show -(1 / 2 : ℂ) * s * (s + 1) * K4 =
        -((1 / 2 : ℂ) * s * (s + 1) * K4) from by ring, hneg]
    -- (a) norm of the endpoint powers
    have hN3 : ‖((n : ℝ) : ℂ) ^ (-s - 3)‖ = (n : ℝ) ^ (-(7 : ℝ) / 2) := by
      rw [Complex.norm_cpow_eq_rpow_re_of_pos (Nat.cast_pos.mpr hn) (-s - 3),
        show (-s - 3 : ℂ).re = -(7 : ℝ) / 2 from by
          rw [show (-(s : ℂ) - 3 : ℂ) = -((s : ℂ) + 3) from by ring,
            Complex.neg_re, Complex.add_re,
            show (3 : ℂ).re = 3 from by norm_num]
          rw [hsre]
          norm_num]
    have hN5 : ‖((n : ℝ) : ℂ) ^ (-s - 5)‖ = (n : ℝ) ^ (-(9 : ℝ) / 2) := by
      rw [Complex.norm_cpow_eq_rpow_re_of_pos (Nat.cast_pos.mpr hn) (-s - 5),
        show (-s - 5 : ℂ).re = -(9 : ℝ) / 2 from by
          rw [show (-(s : ℂ) - 5 : ℂ) = -((s : ℂ) + 5) from by ring,
            Complex.neg_re, Complex.add_re,
            show (5 : ℂ).re = 5 from by norm_num]
          rw [hsre]
          norm_num]
    have hN7 : ‖((n : ℝ) : ℂ) ^ (-s - 7)‖ = (n : ℝ) ^ (-(15 : ℝ) / 2) := by
      rw [Complex.norm_cpow_eq_rpow_re_of_pos (Nat.cast_pos.mpr hn) (-s - 7),
        show (-s - 7 : ℂ).re = -(15 : ℝ) / 2 from by
          rw [show (-(s : ℂ) - 7 : ℂ) = -((s : ℂ) + 7) from by ring,
            Complex.neg_re, Complex.add_re,
            show (7 : ℂ).re = 7 from by norm_num]
          rw [hsre]
          norm_num]
    -- (b) coefficient-norm computations
    have hca : ‖(((B4poly 0) / 4) : ℂ)‖ = (1 : ℝ) / 120 := by
      change ‖((-(1 / 120 : ℝ)) : ℂ)‖ = (1 : ℝ) / 120
      norm_num
    have hA1 : ‖A'‖ = ‖s + 2‖ / 360 := by
      rw [hA, norm_mul, hca, norm_div, norm_num]
      ring
    have hcb : ‖(((B6poly 0) / 6) : ℂ)‖ = (1 : ℝ) / 252 := by
      change ‖(((1 / 42 : ℝ) / 6 : ℝ) : ℂ)‖ = (1 : ℝ) / 252
      norm_num
    have hB1 : ‖B'‖ = ‖s + 2‖ * ‖s + 3‖ * ‖s + 4‖ / 15120 := by
      rw [hB, norm_mul, hcb, norm_div, norm_num, ← norm_mul, ← norm_mul]
      ring
    have hcc : ‖(((B8poly 0) / 8) : ℂ)‖ = (1 : ℝ) / 240 := by
      change ‖((-(1 / 240 : ℝ)) : ℂ)‖ = (1 : ℝ) / 240
      norm_num
    set PC := (s + 2 : ℂ) * ((s + 3) * ((s + 4) * ((s + 5) * (s + 6)))) with hPC
    have hPCn : ‖PC‖ = ‖s + 2‖ * ‖s + 3‖ * ‖s + 4‖ * ‖s + 5‖ * ‖s + 6‖ := by
      repeat' rw [norm_mul]
      ring
    have hC1 : ‖C'‖ = ‖s + 2‖ * ‖s + 3‖ * ‖s + 4‖ * ‖s + 5‖ * ‖s + 6‖ / 604800 := by
      rw [hC, norm_mul, hcc]
      rw [show (s + 2 : ℂ) * (s + 3) * (s + 4) * (s + 5) * (s + 6) / 2520 =
          PC / 2520 from by
            rw [hPC]
            ring]
      rw [norm_div, norm_num, hPCn]
      ring
    set PD := (s + 2 : ℂ) * ((s + 3) * ((s + 4) * ((s + 5) * ((s + 6) * (s + 7))))) with hPD
    have hPDn : ‖PD‖ = ‖s + 2‖ * ‖s + 3‖ * ‖s + 4‖ * ‖s + 5‖ * ‖s + 6‖ * ‖s + 7‖ := by
      repeat' rw [norm_mul]
      ring
    have hD1 : ‖D'‖ = ‖s + 2‖ * ‖s + 3‖ * ‖s + 4‖ * ‖s + 5‖ * ‖s + 6‖ * ‖s + 7‖ / 20160 := by
      rw [hD, norm_div, norm_num]
      rw [show (s + 2 : ℂ) * (s + 3) * (s + 4) * (s + 5) * (s + 6) * (s + 7) =
          (s + 2 : ℂ) * ((s + 3) * ((s + 4) * ((s + 5) * ((s + 6) * (s + 7))))) from by ring,
        ← hPD]
      rw [hPDn]
      ring
    -- (c) product-norm forms of the target coefficients
    have hprod3 : ‖s * (s + 1) * (s + 2)‖ = ‖s‖ * ‖s + 1‖ * ‖s + 2‖ := by
      rw [norm_mul, norm_mul]
      rfl
    have hprod5 : ‖s * (s + 1) * (s + 2) * (s + 3) * (s + 4)‖ =
        ‖s‖ * ‖s + 1‖ * ‖s + 2‖ * ‖s + 3‖ * ‖s + 4‖ := by
      rw [show s * (s + 1) * (s + 2) * (s + 3) * (s + 4) =
          s * ((s + 1) * ((s + 2) * ((s + 3) * (s + 4)))) from by ring]
      repeat' rw [norm_mul]
      ring
    have hprod7 : ‖s * (s + 1) * (s + 2) * (s + 3) * (s + 4) * (s + 5) * (s + 6)‖ =
        ‖s‖ * ‖s + 1‖ * ‖s + 2‖ * ‖s + 3‖ * ‖s + 4‖ * ‖s + 5‖ * ‖s + 6‖ := by
      rw [show s * (s + 1) * (s + 2) * (s + 3) * (s + 4) * (s + 5) * (s + 6) =
          s * ((s + 1) *
            ((s + 2) * ((s + 3) * ((s + 4) * ((s + 5) * (s + 6))))))) from by ring]
      repeat' rw [norm_mul]
      ring
    have hprod8 : ‖s * (s + 1) * (s + 2) * (s + 3) * (s + 4) * (s + 5) * (s + 6) * (s + 7)‖ =
        ‖s‖ * ‖s + 1‖ * ‖s + 2‖ * ‖s + 3‖ * ‖s + 4‖ * ‖s + 5‖ * ‖s + 6‖ * ‖s + 7‖ := by
      rw [show s * (s + 1) * (s + 2) * (s + 3) * (s + 4) * (s + 5) * (s + 6) * (s + 7) =
          s * ((s + 1) *
            ((s + 2) * ((s + 3) * ((s + 4) * ((s + 5) * ((s + 6) * (s + 7)))))))) from by ring]
      repeat' rw [norm_mul]
      ring
    -- (d) the four termwise bounds
    have hT1 : (1 / 2 : ℝ) * ‖s‖ * ‖s + 1‖ * ‖U3‖ ≤
        ‖s * (s + 1) * (s + 2)‖ * (n : ℝ) ^ (-(7 : ℝ) / 2) / 720 := by
      calc (1 / 2 : ℝ) * ‖s‖ * ‖s + 1‖ * ‖U3‖
          _ = (1 / 2 : ℝ) * ‖s‖ * ‖s + 1‖ * (‖A'‖ * ‖((n : ℝ) : ℂ) ^ (-s - 3)‖) := by
            rw [hU3, norm_mul,
              show ‖0 - ((n : ℝ) : ℂ) ^ (-s - 3)‖ =
                ‖((n : ℝ) : ℂ) ^ (-s - 3)‖ from by rw [zero_sub, norm_neg]]
          _ = (1 / 2 : ℝ) * ‖s‖ * ‖s + 1‖ *
              ((‖s + 2‖ / 360) * (n : ℝ) ^ (-(7 : ℝ) / 2)) := by
            rw [hA1, hN3]
            ring
          _ = (‖s‖ * ‖s + 1‖ * ‖s + 2‖) / 720 * (n : ℝ) ^ (-(7 : ℝ) / 2) := by ring
          _ = ‖s * (s + 1) * (s + 2)‖ * (n : ℝ) ^ (-(7 : ℝ) / 2) / 720 := by
            rw [← hprod3]
            ring
    have hT2 : (1 / 2 : ℝ) * ‖s‖ * ‖s + 1‖ * ‖U5‖ ≤
        ‖s * (s + 1) * (s + 2) * (s + 3) * (s + 4)‖ * (n : ℝ) ^ (-(9 : ℝ) / 2) / 30240 := by
      calc (1 / 2 : ℝ) * ‖s‖ * ‖s + 1‖ * ‖U5‖
          _ = (1 / 2 : ℝ) * ‖s‖ * ‖s + 1‖ * (‖B'‖ * ‖((n : ℝ) : ℂ) ^ (-s - 5)‖) := by
            rw [hU5, norm_mul,
              show ‖0 - ((n : ℝ) : ℂ) ^ (-s - 5)‖ =
                ‖((n : ℝ) : ℂ) ^ (-s - 5)‖ from by rw [zero_sub, norm_neg]]
          _ = (1 / 2 : ℝ) * ‖s‖ * ‖s + 1‖ *
              ((‖s + 2‖ * ‖s + 3‖ * ‖s + 4‖ / 15120) *
                (n : ℝ) ^ (-(9 : ℝ) / 2)) := by
            rw [hB1, hN5]
            ring
          _ = (‖s‖ * ‖s + 1‖ * ‖s + 2‖ * ‖s + 3‖ * ‖s + 4‖) / 30240 *
              (n : ℝ) ^ (-(9 : ℝ) / 2) := by ring
          _ = ‖s * (s + 1) * (s + 2) * (s + 3) * (s + 4)‖ *
              (n : ℝ) ^ (-(9 : ℝ) / 2) / 30240 := by
            rw [← hprod5]
            ring
    have hT3 : (1 / 2 : ℝ) * ‖s‖ * ‖s + 1‖ * ‖U7‖ ≤
        ‖s * (s + 1) * (s + 2) * (s + 3) * (s + 4) * (s + 5) * (s + 6)‖ *
          (n : ℝ) ^ (-(15 : ℝ) / 2) / 1209600 := by
      calc (1 / 2 : ℝ) * ‖s‖ * ‖s + 1‖ * ‖U7‖
          _ = (1 / 2 : ℝ) * ‖s‖ * ‖s + 1‖ * (‖C'‖ * ‖((n : ℝ) : ℂ) ^ (-s - 7)‖) := by
            rw [hU7, norm_mul,
              show ‖0 - ((n : ℝ) : ℂ) ^ (-s - 7)‖ =
                ‖((n : ℝ) : ℂ) ^ (-s - 7)‖ from by rw [zero_sub, norm_neg]]
          _ = (1 / 2 : ℝ) * ‖s‖ * ‖s + 1‖ *
              ((‖s + 2‖ * ‖s + 3‖ * ‖s + 4‖ * ‖s + 5‖ * ‖s + 6‖ / 604800) *
                (n : ℝ) ^ (-(15 : ℝ) / 2)) := by
            rw [hC1, hN7]
            ring
          _ = (‖s‖ * ‖s + 1‖ * ‖s + 2‖ * ‖s + 3‖ * ‖s + 4‖ * ‖s + 5‖ *
              ‖s + 6‖) / 1209600 * (n : ℝ) ^ (-(15 : ℝ) / 2) := by ring
          _ = ‖s * (s + 1) * (s + 2) * (s + 3) * (s + 4) * (s + 5) * (s + 6)‖ *
              (n : ℝ) ^ (-(15 : ℝ) / 2) / 1209600 := by
            rw [← hprod7]
            ring
    have hI8 := p4_25ae_I8_bound hsre n hn
    have hT4a : (1 / 2 : ℝ) * ‖s‖ * ‖s + 1‖ * ‖D'‖ * ‖F8‖ ≤
        (1 / 2 : ℝ) * ‖s‖ * ‖s + 1‖ * ‖D'‖ * ((n : ℝ) ^ (-(15 : ℝ) / 2) / 225) := by
      gcongr
    have hT4b : (1 / 2 : ℝ) * ‖s‖ * ‖s + 1‖ * ‖D'‖ *
        ((n : ℝ) ^ (-(15 : ℝ) / 2) / 225) ≤
        ‖s * (s + 1) * (s + 2) * (s + 3) * (s + 4) * (s + 5) * (s + 6) * (s + 7)‖ *
          (n : ℝ) ^ (-(15 : ℝ) / 2) / 9072000 := by
      calc (1 / 2 : ℝ) * ‖s‖ * ‖s + 1‖ * ‖D'‖ *
          ((n : ℝ) ^ (-(15 : ℝ) / 2) / 225)
          _ = (1 / 2 : ℝ) * ‖s‖ * ‖s + 1‖ *
              ((‖s + 2‖ * ‖s + 3‖ * ‖s + 4‖ * ‖s + 5‖ * ‖s + 6‖ * ‖s + 7‖) / 20160) *
              ((n : ℝ) ^ (-(15 : ℝ) / 2) / 225) := by
            rw [hD1]
            ring
          _ = (‖s‖ * ‖s + 1‖ * ‖s + 2‖ * ‖s + 3‖ * ‖s + 4‖ *
      ‖s + 5‖ * ‖s + 6‖ * ‖s + 7‖) / 9072000 *
              (n : ℝ) ^ (-(15 : ℝ) / 2) := by ring
          _ = ‖s * (s + 1) * (s + 2) * (s + 3) * (s + 4) * (s + 5) *
                (s + 6) * (s + 7)‖ * (n : ℝ) ^ (-(15 : ℝ) / 2) / 9072000 := by
            rw [← hprod8]
            ring
    have hT4 : (1 / 2 : ℝ) * ‖s‖ * ‖s + 1‖ * ‖U8‖ ≤
        ‖s * (s + 1) * (s + 2) * (s + 3) * (s + 4) * (s + 5) * (s + 6) * (s + 7)‖ *
          (n : ℝ) ^ (-(15 : ℝ) / 2) / 9072000 := by
      rw [show (1 / 2 : ℝ) * ‖s‖ * ‖s + 1‖ * ‖U8‖ =
          (1 / 2 : ℝ) * ‖s‖ * ‖s + 1‖ * ‖D'‖ * ‖F8‖ from by
            rw [hU8, norm_mul]
            ring]
      calc _
          _ ≤ (1 / 2 : ℝ) * ‖s‖ * ‖s + 1‖ * ‖D'‖ *
              ((n : ℝ) ^ (-(15 : ℝ) / 2) / 225) := hT4a
          _ ≤ ‖s * (s + 1) * (s + 2) * (s + 3) * (s + 4) * (s + 5) *
                (s + 6) * (s + 7)‖ * (n : ℝ) ^ (-(15 : ℝ) / 2) / 9072000 := hT4b
    -- (e) the triangle decomposition of K4
    have htri : ‖K4‖ ≤ ‖U3‖ + ‖U5‖ + (‖U7‖ + ‖U8‖) := by
      calc ‖K4‖
          _ = ‖U3 + (U5 + (U7 + U8))‖ := (hK4).symm
          _ ≤ ‖U3‖ + ‖U5 + (U7 + U8)‖ := norm_add_le U3 (U5 + (U7 + U8))
          _ ≤ ‖U3‖ + (‖U5‖ + ‖U7 + U8‖) := by
            apply add_le_add (le_rfl : _ ≤ _)
            exact (norm_add_le U5 (U7 + U8))
          _ ≤ ‖U3‖ + (‖U5‖ + (‖U7‖ + ‖U8‖)) := by
            apply add_le_add (le_rfl : _ ≤ _)
            apply add_le_add (le_rfl : _ ≤ _)
            exact (norm_add_le U7 U8)
          _ = ‖U3‖ + ‖U5‖ + (‖U7‖ + ‖U8‖) := by ring
    -- (f) the prefactor norm
    have hpref : ‖(1 / 2 : ℂ) * s * (s + 1) * K4‖ =
        (1 / 2 : ℝ) * ‖s‖ * ‖s + 1‖ * ‖K4‖ := by
      calc ‖(1 / 2 : ℂ) * s * (s + 1) * K4‖
          _ = ‖(1 / 2 : ℂ) * s * (s + 1)‖ * ‖K4‖ := by rw [norm_mul]
          _ = (‖(1 / 2 : ℂ) * s‖ * ‖s + 1‖) * ‖K4‖ := by rw [norm_mul]
          _ = ((‖(1 / 2 : ℂ)‖ * ‖s‖) * ‖s + 1‖) * ‖K4‖ := by rw [norm_mul]
          _ = ((1 / 2 : ℝ) * ‖s‖) * ‖s + 1‖ * ‖K4‖ := by
            rw [show ‖(1 / 2 : ℂ)‖ = (1 / 2 : ℝ) from by norm_num]
            ring
          _ = (1 / 2 : ℝ) * ‖s‖ * ‖s + 1‖ * ‖K4‖ := by ring
    calc ‖(1 / 2 : ℂ) * s * (s + 1) * K4‖
        _ = (1 / 2 : ℝ) * ‖s‖ * ‖s + 1‖ * ‖K4‖ := hpref
        _ ≤ (1 / 2 : ℝ) * ‖s‖ * ‖s + 1‖ *
            (‖U3‖ + (‖U5‖ + (‖U7‖ + ‖U8‖))) := by
          have htrir : ‖K4‖ ≤ ‖U3‖ + (‖U5‖ + (‖U7‖ + ‖U8‖)) := by
            convert htri using 2
            ring
          apply mul_le_mul_of_nonneg_left htrir
          positivity
        _ = (1 / 2 : ℝ) * ‖s‖ * ‖s + 1‖ * ‖U3‖ +
            ((1 / 2 : ℝ) * ‖s‖ * ‖s + 1‖ * ‖U5‖ +
              (1 / 2 : ℝ) * ‖s‖ * ‖s + 1‖ * ‖U7‖) +
            (1 / 2 : ℝ) * ‖s‖ * ‖s + 1‖ * ‖U8‖ := by ring
        _ ≤ ‖s * (s + 1) * (s + 2)‖ * (n : ℝ) ^ (-(7 : ℝ) / 2) / 720 +
            (‖s * (s + 1) * (s + 2) * (s + 3) * (s + 4)‖ *
              (n : ℝ) ^ (-(9 : ℝ) / 2) / 30240 +
              (‖s * (s + 1) * (s + 2) * (s + 3) * (s + 4) * (s + 5) * (s + 6)‖ *
                (n : ℝ) ^ (-(15 : ℝ) / 2) / 1209600 +
                ‖s * (s + 1) * (s + 2) * (s + 3) * (s + 4) * (s + 5) * (s + 6) * (s + 7)‖ *
                  (n : ℝ) ^ (-(15 : ℝ) / 2) / 9072000)) := by
          calc (1 / 2 : ℝ) * ‖s‖ * ‖s + 1‖ * ‖U3‖ +
                  ((1 / 2 : ℝ) * ‖s‖ * ‖s + 1‖ * ‖U5‖ +
                    (1 / 2 : ℝ) * ‖s‖ * ‖s + 1‖ * ‖U7‖) +
                  (1 / 2 : ℝ) * ‖s‖ * ‖s + 1‖ * ‖U8‖
              _ = ((1 / 2 : ℝ) * ‖s‖ * ‖s + 1‖ * ‖U3‖ +
                    (1 / 2 : ℝ) * ‖s‖ * ‖s + 1‖ * ‖U5‖) +
                  ((1 / 2 : ℝ) * ‖s‖ * ‖s + 1‖ * ‖U7‖ +
                    (1 / 2 : ℝ) * ‖s‖ * ‖s + 1‖ * ‖U8‖) := by ring
              _ ≤ (‖s * (s + 1) * (s + 2)‖ * (n : ℝ) ^ (-(7 : ℝ) / 2) / 720 +
                    ‖s * (s + 1) * (s + 2) * (s + 3) * (s + 4)‖ *
                      (n : ℝ) ^ (-(9 : ℝ) / 2) / 30240) +
                  (‖s * (s + 1) * (s + 2) * (s + 3) * (s + 4) * (s + 5) * (s + 6)‖ *
                      (n : ℝ) ^ (-(15 : ℝ) / 2) / 1209600 +
                      ‖s * (s + 1) * (s + 2) * (s + 3) * (s + 4) * (s + 5) * (s + 6) *
                        (s + 7)‖ * (n : ℝ) ^ (-(15 : ℝ) / 2) / 9072000) := by
                apply add_le_add
                · exact add_le_add hT1 hT2
                · exact add_le_add hT3 hT4
              _ = ‖s * (s + 1) * (s + 2)‖ * (n : ℝ) ^ (-(7 : ℝ) / 2) / 720 +
                  (‖s * (s + 1) * (s + 2) * (s + 3) * (s + 4)‖ *
                    (n : ℝ) ^ (-(9 : ℝ) / 2) / 30240 +
                    (‖s * (s + 1) * (s + 2) * (s + 3) * (s + 4) * (s + 5) * (s + 6)‖ *
                      (n : ℝ) ^ (-(15 : ℝ) / 2) / 1209600 +
                      ‖s * (s + 1) * (s + 2) * (s + 3) * (s + 4) * (s + 5) * (s + 6) *
                        (s + 7)‖ * (n : ℝ) ^ (-(15 : ℝ) / 2) / 9072000)) := by ring
        _ = ‖s * (s + 1) * (s + 2)‖ * (n : ℝ) ^ (-(7 : ℝ) / 2) / 720 +
            ‖s * (s + 1) * (s + 2) * (s + 3) * (s + 4)‖ *
              (n : ℝ) ^ (-(9 : ℝ) / 2) / 30240 +
            ‖s * (s + 1) * (s + 2) * (s + 3) * (s + 4) * (s + 5) * (s + 6)‖ *
              (n : ℝ) ^ (-(15 : ℝ) / 2) / 1209600 +
            ‖s * (s + 1) * (s + 2) * (s + 3) * (s + 4) * (s + 5) * (s + 6) * (s + 7)‖ *
              (n : ℝ) ^ (-(15 : ℝ) / 2) / 9072000 := by ring
    done
