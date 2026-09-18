
  --/ ===== 25ae Stage 3A — periodic B8, telescope, finite-M identity (J) =====

  -- The periodic 8th Bernoulli function (kernel = B8poly on each [j, j+1]).
  noncomputable def B8 (x : ℝ) : ℝ := B8poly (x - ⌊x⌋₊)

  @[fun_prop]
  lemma aestronglyMeasurable_B8 : AEStronglyMeasurable B8 := by
    unfold B8
    fun_prop

  -- On [n, n+1]: B8 = B8poly(·−n).  (Same shape as P4Tail.B2_of_Icc_int.)
  lemma B8_of_Icc_int (n : ℕ) {x : ℝ} (hx : x ∈ Set.Icc (n : ℝ) (n + 1 : ℝ)) :
      B8 x = B8poly (x - n) := by
    unfold B8
    by_cases htop : x = (n + 1 : ℝ)
    · rw [htop]
      have hfl : (⌊(n + 1 : ℝ)⌋₊ : ℕ) = n + 1 :=
        (Nat.floor_eq_iff (ha := by positivity)).mpr
          ⟨by norm_cast, by norm_cast; linarith⟩
      rw [hfl, show (n + 1 : ℝ) - (n + 1 : ℝ) = 0 from by ring]
      simp only [sub_zero, B8poly_at_0, B8poly_at_1]
    · have hn : (⌊x⌋₊ : ℝ) = (n : ℝ) := by
        norm_cast
        rw [Nat.floor_eq_iff (by linarith [show (0 : ℝ) ≤ x from le_trans (Nat.cast_nonneg n) hx.1])]
        constructor
        · linarith [hx.1]
        · exact lt_of_le_of_ne hx.2 htop
      rw [hn]

  -- |B8 x| <= 1/30 for x >= 0 (kernel in [0,1]; B8poly_bound_Icc on [0,1]).
  lemma abs_B8_le {x : ℝ} (hx : 0 ≤ x) : |B8 x| ≤ 1 / 30 := by
    unfold B8
    set v := (x - ⌊x⌋₊ : ℝ) with hv
    have hv0 : 0 ≤ v := by grind [Nat.floor_le hx]
    have hv1 : v ≤ 1 := by grind [Nat.lt_succ_floor x]
    dsimp only [v] at hv0 hv1
    have hb1 : B8poly v ≤ 1 / 30 := (B8poly_bound_Icc ⟨hv0, hv1⟩).2
    have hb0 : - (1 / 30 : ℝ) ≤ B8poly v := (B8poly_bound_Icc ⟨hv0, hv1⟩).1
    simpa [v] using abs_le.mpr ⟨hb0, hb1⟩

  -- Finite telescope over Ico (no ℕ-indexed Ico telescope in mathlib 4.33.1;
  -- induction on the length k with M = n + k).
  lemma p4_25ae_telescope_pow {p : ℂ} (n M : ℕ) (hnm : n ≤ M) :
      (∑ j ∈ Finset.Ico n M, (((j + 1 : ℝ) : ℂ) ^ p - ((j : ℝ) : ℂ) ^ p))
          = ((M : ℝ) : ℂ) ^ p - ((n : ℝ) : ℂ) ^ p := by
    set g : ℕ → ℂ := fun (j : ℕ) => ((j : ℝ) : ℂ) ^ p with hg
    have hgA : (∑ j ∈ Finset.Ico n M, (((j + 1 : ℝ) : ℂ) ^ p - ((j : ℝ) : ℂ) ^ p))
        = (∑ j ∈ Finset.Ico n M, (g (j + 1) - g j)) := by
      apply Finset.sum_congr rfl
      intro j _
      dsimp only [g]
    rw [hgA]
    obtain ⟨k, rfl⟩ := ⟨M - n, by rw [Nat.add_sub_cancel' hnm]⟩
    induction' k with k IH
    · have hc : Finset.Ico n n = ∅ := by
        ext x
        simp [Finset.mem_Ico]
        <;> omega
      rw [hc]
      simp
      ring
    · have hIco : Finset.Ico n ((n + k) + 1) = (Finset.Ico n (n + k)) ∪ {n + k} := by
        ext x
        simp only [Finset.mem_Ico, Finset.mem_union, Finset.mem_singleton]
        constructor
        · intro hx
          by_cases htop : x ≤ n + k
          · exact Or.inl ⟨hx.1, htop⟩
          · exact Or.inr (by omega)
        · intro hx
          cases hx with
          | inl hx => exact ⟨hx.1, by omega⟩
          | inr hx =>
            subst x
            exact ⟨by omega, by omega⟩
      have hdisj : Disjoint (Finset.Ico n (n + k)) {n + k} := by
        rw [Finset.disjoint_left.mpr]
        intro x hx hmem
        rw [Finset.mem_singleton] at hmem
        subst x
        simp_all
      have hsum : (∑ j ∈ Finset.Ico n ((n + k) + 1), (g (j + 1) - g j))
          = (∑ j ∈ Finset.Ico n (n + k), (g (j + 1) - g j))
              + (g (n + k + 1) - g (n + k)) := by
        rw [hIco, Finset.sum_union hdisj]
        simp
      rw [hsum, IH]
      ring

  -- The finite-M identity.  J(M) := ∫_n^M B̂₂ x^{-s-2} dx, expressed via the
  -- endpoint differences (B4/B6/B8 boundary values) and the B8 period-sum
  -- tail.  Coefficient atoms are verbatim those of the Stage-2 atoms
  -- (so all ring atoms between the assembled term and the target match).
  theorem p4_25ae_J_finite {s : ℂ} (hsre : s.re = 1 / 2) (n M : ℕ) (hn : 0 < n)
      (hnm : n ≤ M) :
      (∫ x in (n : ℝ)..(M : ℝ), (B2 x : ℂ) * (x : ℂ) ^ (-s - 2))
          = ((s + 2 : ℂ) / 3) * (((B4poly 0) / 4) : ℂ) *
              (((M : ℝ) : ℂ) ^ (-s - 3) - ((n : ℝ) : ℂ) ^ (-s - 3))
            + ((s + 2 : ℂ) * (s + 3) * (s + 4) / 60) * (((B6poly 0) / 6) : ℂ) *
              (((M : ℝ) : ℂ) ^ (-s - 5) - ((n : ℝ) : ℂ) ^ (-s - 5))
            + ((s + 2 : ℂ) * (s + 3) * (s + 4) * (s + 5) * (s + 6) / 2520) *
              (((B8poly 0) / 8) : ℂ) *
              (((M : ℝ) : ℂ) ^ (-s - 7) - ((n : ℝ) : ℂ) ^ (-s - 7))
            + ((s + 2 : ℂ) * (s + 3) * (s + 4) * (s + 5) * (s + 6) * (s + 7) / 20160) *
              (∑ j ∈ Finset.Ico n M,
                (∫ x in (j : ℝ)..(j + 1 : ℝ),
                  (B8poly (x - (j : ℝ)) : ℂ) * (x : ℂ) ^ (-s - 8))) := by
    -- period sums at each ladder level
    set S3 := (∑ j ∈ Finset.Ico n M,
        (∫ x in (j : ℝ)..(j + 1 : ℝ), (B3poly (x - (j : ℝ)) : ℂ) * (x : ℂ) ^ (-s - 3))) with hS3
    set S4 := (∑ j ∈ Finset.Ico n M,
        (∫ x in (j : ℝ)..(j + 1 : ℝ), (B4poly (x - (j : ℝ)) : ℂ) * (x : ℂ) ^ (-s - 4))) with hS4
    set S5 := (∑ j ∈ Finset.Ico n M,
        (∫ x in (j : ℝ)..(j + 1 : ℝ), (B5poly (x - (j : ℝ)) : ℂ) * (x : ℂ) ^ (-s - 5))) with hS5
    set S6 := (∑ j ∈ Finset.Ico n M,
        (∫ x in (j : ℝ)..(j + 1 : ℝ), (B6poly (x - (j : ℝ)) : ℂ) * (x : ℂ) ^ (-s - 6))) with hS6
    set S7 := (∑ j ∈ Finset.Ico n M,
        (∫ x in (j : ℝ)..(j + 1 : ℝ), (B7poly (x - (j : ℝ)) : ℂ) * (x : ℂ) ^ (-s - 7))) with hS7
    set S8 := (∑ j ∈ Finset.Ico n M,
        (∫ x in (j : ℝ)..(j + 1 : ℝ), (B8poly (x - (j : ℝ)) : ℂ) * (x : ℂ) ^ (-s - 8))) with hS8
    -- (1) ∫_n^M with the B2 kernel = the period sum (kernel = B2poly per period)
    have h1 : (∫ x in (n : ℝ)..(M : ℝ), (B2 x : ℂ) * (x : ℂ) ^ (-s - 2))
        = (∑ j ∈ Finset.Ico n M,
            (∫ x in (j : ℝ)..(j + 1 : ℝ), (B2poly j x : ℂ) * (x : ℂ) ^ (-s - 2))) := by
      rw [← sum_integral_adjacent_intervals_Ico (a := fun k : ℕ => (k : ℝ)) hnm]
      apply Finset.sum_congr rfl
      intro j hj
      rw [intervalIntegral.integral_congr (μ := (MeasureTheory.volume : Measure ℝ)) (by
        intro x hx
        have hxIcc : x ∈ Set.Icc (j : ℝ) (j + 1 : ℝ) :=
          ⟨by simpa [show min (j : ℝ) (j + 1 : ℝ) = (j : ℝ) from min_eq_left (by nlinarith)] using hx.1,
            by simpa using hx.2⟩
        dsimp only [B2poly]
        rw [B2_of_Icc_int j hxIcc])]
    -- (2) B2 -> B3 (vanishing B3 boundary): period sum = (s+2)/3 · S3
    have h2 : (∑ j ∈ Finset.Ico n M,
            (∫ x in (j : ℝ)..(j + 1 : ℝ), (B2poly j x : ℂ) * (x : ℂ) ^ (-s - 2)))
        = S3 * ((s + 2 : ℂ) / 3) := by
      have hper : (∑ j ∈ Finset.Ico n M,
              (∫ x in (j : ℝ)..(j + 1 : ℝ), (B2poly j x : ℂ) * (x : ℂ) ^ (-s - 2)))
          = (∑ j ∈ Finset.Ico n M,
              (s + 2 : ℂ) / 3 *
                (∫ x in (j : ℝ)..(j + 1 : ℝ),
                  (B3poly (x - (j : ℝ)) : ℂ) * (x : ℂ) ^ (-s - 3))) := by
        apply Finset.sum_congr rfl
        intro j hj
        have hjpos : 0 < j := by omega
        simpa [B2poly] using (p4_25ae_ibp_b2to3 s hsre j hjpos).symm
      rw [hper, Finset.const_mul_sum (( (s + 2 : ℂ)) / 3)]
      dsimp only [S3]
      ring
    -- (3) B3 -> B4: S3 = B4-boundary·Δu3 + (s+3)/4 · S4
    have h3 : S3 = (((B4poly 0) / 4) : ℂ) *
            (((M : ℝ) : ℂ) ^ (-s - 3) - ((n : ℝ) : ℂ) ^ (-s - 3))
          + S4 * ((s + 3 : ℂ) / 4) := by
      dsimp only [S3, S4]
      have hper : (∑ j ∈ Finset.Ico n M,
              (∫ x in (j : ℝ)..(j + 1 : ℝ), (B3poly (x - (j : ℝ)) : ℂ) * (x : ℂ) ^ (-s - 3)))
          = (∑ j ∈ Finset.Ico n M,
              ((((B4poly 0) / 4) : ℂ) *
                (((j + 1 : ℝ) : ℂ) ^ (-s - 3) - ((j : ℝ) : ℂ) ^ (-s - 3))
                + (s + 3 : ℂ) / 4 *
                    (∫ x in (j : ℝ)..(j + 1 : ℝ),
                      (B4poly (x - (j : ℝ)) : ℂ) * (x : ℂ) ^ (-s - 4)))) := by
        apply Finset.sum_congr rfl
        intro j hj
        have hjpos : 0 < j := by omega
        exact (p4_25ae_ibp_b3to4 s hsre j hjpos).symm
      rw [hper, Finset.sum_add_distrib,
        Finset.const_mul_sum (( ((B4poly 0) / 4) : ℂ)),
        p4_25ae_telescope_pow (-s - 3 : ℂ) n M hnm,
        Finset.const_mul_sum (( (s + 3 : ℂ)) / 4)]
      ring
    -- (4) B4 -> B5 (vanishing B5 boundary): S4 = (s+4)/5 · S5
    have h4 : S4 = S5 * ((s + 4 : ℂ) / 5) := by
      dsimp only [S4, S5]
      have hper : (∑ j ∈ Finset.Ico n M,
              (∫ x in (j : ℝ)..(j + 1 : ℝ), (B4poly (x - (j : ℝ)) : ℂ) * (x : ℂ) ^ (-s - 4)))
          = (∑ j ∈ Finset.Ico n M,
              (s + 4 : ℂ) / 5 *
                (∫ x in (j : ℝ)..(j + 1 : ℝ),
                  (B5poly (x - (j : ℝ)) : ℂ) * (x : ℂ) ^ (-s - 5))) := by
        apply Finset.sum_congr rfl
        intro j hj
        have hjpos : 0 < j := by omega
        simpa using (p4_25ae_ibp_b4to5 s hsre j hjpos).symm
      rw [hper, Finset.const_mul_sum (( (s + 4 : ℂ)) / 5)]
      ring
    -- (5) B5 -> B6: S5 = B6-boundary·Δu5 + (s+5)/6 · S6
    have h5 : S5 = (((B6poly 0) / 6) : ℂ) *
            (((M : ℝ) : ℂ) ^ (-s - 5) - ((n : ℝ) : ℂ) ^ (-s - 5))
          + S6 * ((s + 5 : ℂ) / 6) := by
      dsimp only [S5, S6]
      have hper : (∑ j ∈ Finset.Ico n M,
              (∫ x in (j : ℝ)..(j + 1 : ℝ), (B5poly (x - (j : ℝ)) : ℂ) * (x : ℂ) ^ (-s - 5)))
          = (∑ j ∈ Finset.Ico n M,
              ((((B6poly 0) / 6) : ℂ) *
                (((j + 1 : ℝ) : ℂ) ^ (-s - 5) - ((j : ℝ) : ℂ) ^ (-s - 5))
                + (s + 5 : ℂ) / 6 *
                    (∫ x in (j : ℝ)..(j + 1 : ℝ),
                      (B6poly (x - (j : ℝ)) : ℂ) * (x : ℂ) ^ (-s - 6)))) := by
        apply Finset.sum_congr rfl
        intro j hj
        have hjpos : 0 < j := by omega
        exact (p4_25ae_ibp_b5to6 s hsre j hjpos).symm
      rw [hper, Finset.sum_add_distrib,
        Finset.const_mul_sum (( ((B6poly 0) / 6) : ℂ)),
        p4_25ae_telescope_pow (-s - 5 : ℂ) n M hnm,
        Finset.const_mul_sum (( (s + 5 : ℂ)) / 6)]
      ring
    -- (6) B6 -> B7 (vanishing B7 boundary): S6 = (s+6)/7 · S7
    have h6 : S6 = S7 * ((s + 6 : ℂ) / 7) := by
      dsimp only [S6, S7]
      have hper : (∑ j ∈ Finset.Ico n M,
              (∫ x in (j : ℝ)..(j + 1 : ℝ), (B6poly (x - (j : ℝ)) : ℂ) * (x : ℂ) ^ (-s - 6)))
          = (∑ j ∈ Finset.Ico n M,
              (s + 6 : ℂ) / 7 *
                (∫ x in (j : ℝ)..(j + 1 : ℝ),
                  (B7poly (x - (j : ℝ)) : ℂ) * (x : ℂ) ^ (-s - 7))) := by
        apply Finset.sum_congr rfl
        intro j hj
        have hjpos : 0 < j := by omega
        simpa using (p4_25ae_ibp_b6to7 s hsre j hjpos).symm
      rw [hper, Finset.const_mul_sum (( (s + 6 : ℂ)) / 7)]
      ring
    -- (7) B7 -> B8: S7 = B8-boundary·Δu7 + (s+7)/8 · S8
    have h7 : S7 = (((B8poly 0) / 8) : ℂ) *
            (((M : ℝ) : ℂ) ^ (-s - 7) - ((n : ℝ) : ℂ) ^ (-s - 7))
          + S8 * ((s + 7 : ℂ) / 8) := by
      dsimp only [S7, S8]
      have hper : (∑ j ∈ Finset.Ico n M,
              (∫ x in (j : ℝ)..(j + 1 : ℝ), (B7poly (x - (j : ℝ)) : ℂ) * (x : ℂ) ^ (-s - 7)))
          = (∑ j ∈ Finset.Ico n M,
              ((((B8poly 0) / 8) : ℂ) *
                (((j + 1 : ℝ) : ℂ) ^ (-s - 7) - ((j : ℝ) : ℂ) ^ (-s - 7))
                + (s + 7 : ℂ) / 8 *
                    (∫ x in (j : ℝ)..(j + 1 : ℝ),
                      (B8poly (x - (j : ℝ)) : ℂ) * (x : ℂ) ^ (-s - 8)))) := by
        apply Finset.sum_congr rfl
        intro j hj
        have hjpos : 0 < j := by omega
        exact (p4_25ae_ibp_b7to8 s hsre j hjpos).symm
      rw [hper, Finset.sum_add_distrib,
        Finset.const_mul_sum (( ((B8poly 0) / 8) : ℂ)),
        p4_25ae_telescope_pow (-s - 7 : ℂ) n M hnm,
        Finset.const_mul_sum (( (s + 7 : ℂ)) / 8)]
      ring
    -- (8) assemble the ladder
    calc (∫ x in (n : ℝ)..(M : ℝ), (B2 x : ℂ) * (x : ℂ) ^ (-s - 2))
        _ = (∑ j ∈ Finset.Ico n M,
              (∫ x in (j : ℝ)..(j + 1 : ℝ), (B2poly j x : ℂ) * (x : ℂ) ^ (-s - 2))) := h1
        _ = S3 * ((s + 2 : ℂ) / 3) := h2
        _ = ((s + 2 : ℂ) / 3) *
            ((((B4poly 0) / 4) : ℂ) *
              (((M : ℝ) : ℂ) ^ (-s - 3) - ((n : ℝ) : ℂ) ^ (-s - 3))
              + S4 * ((s + 3 : ℂ) / 4)) := by
            rw [h3, mul_comm S3 _]
        _ = ((s + 2 : ℂ) / 3) *
            ((((B4poly 0) / 4) : ℂ) *
              (((M : ℝ) : ℂ) ^ (-s - 3) - ((n : ℝ) : ℂ) ^ (-s - 3))
              + (S5 * ((s + 4 : ℂ) / 5)) * ((s + 3 : ℂ) / 4)) := by
            rw [h4]
        _ = ((s + 2 : ℂ) / 3) *
            ((((B4poly 0) / 4) : ℂ) *
              (((M : ℝ) : ℂ) ^ (-s - 3) - ((n : ℝ) : ℂ) ^ (-s - 3))
              + (((((B6poly 0) / 6) : ℂ) *
                    (((M : ℝ) : ℂ) ^ (-s - 5) - ((n : ℝ) : ℂ) ^ (-s - 5))
                    + S6 * ((s + 5 : ℂ) / 6)) * ((s + 4 : ℂ) / 5)) * ((s + 3 : ℂ) / 4)) := by
            rw [h5]
        _ = ((s + 2 : ℂ) / 3) *
            ((((B4poly 0) / 4) : ℂ) *
              (((M : ℝ) : ℂ) ^ (-s - 3) - ((n : ℝ) : ℂ) ^ (-s - 3))
              + (((((B6poly 0) / 6) : ℂ) *
                    (((M : ℝ) : ℂ) ^ (-s - 5) - ((n : ℝ) : ℂ) ^ (-s - 5))
                    + (S7 * ((s + 6 : ℂ) / 7)) * ((s + 5 : ℂ) / 6)) * ((s + 4 : ℂ) / 5)) *
                  ((s + 3 : ℂ) / 4)) := by
            rw [h6]
        _ = ((s + 2 : ℂ) / 3) *
            ((((B4poly 0) / 4) : ℂ) *
              (((M : ℝ) : ℂ) ^ (-s - 3) - ((n : ℝ) : ℂ) ^ (-s - 3))
              + (((((B6poly 0) / 6) : ℂ) *
                    (((M : ℝ) : ℂ) ^ (-s - 5) - ((n : ℝ) : ℂ) ^ (-s - 5))
                    + (((( ((B8poly 0) / 8) : ℂ) *
                           (((M : ℝ) : ℂ) ^ (-s - 7) - ((n : ℝ) : ℂ) ^ (-s - 7))
                           + S8 * ((s + 7 : ℂ) / 8)) * ((s + 6 : ℂ) / 7)) *
                      ((s + 5 : ℂ) / 6)) * ((s + 4 : ℂ) / 5)) * ((s + 3 : ℂ) / 4)) := by
            rw [h7]
        _ = ((s + 2 : ℂ) / 3) * (((B4poly 0) / 4) : ℂ) *
                (((M : ℝ) : ℂ) ^ (-s - 3) - ((n : ℝ) : ℂ) ^ (-s - 3))
            + ((s + 2 : ℂ) * (s + 3) * (s + 4) / 60) * (((B6poly 0) / 6) : ℂ) *
                (((M : ℝ) : ℂ) ^ (-s - 5) - ((n : ℝ) : ℂ) ^ (-s - 5))
            + ((s + 2 : ℂ) * (s + 3) * (s + 4) * (s + 5) * (s + 6) / 2520) *
                (((B8poly 0) / 8) : ℂ) *
                (((M : ℝ) : ℂ) ^ (-s - 7) - ((n : ℝ) : ℂ) ^ (-s - 7))
            + ((s + 2 : ℂ) * (s + 3) * (s + 4) * (s + 5) * (s + 6) * (s + 7) / 20160) *
                S8 := by
            ring
        _ = ((s + 2 : ℂ) / 3) * (((B4poly 0) / 4) : ℂ) *
                (((M : ℝ) : ℂ) ^ (-s - 3) - ((n : ℝ) : ℂ) ^ (-s - 3))
            + ((s + 2 : ℂ) * (s + 3) * (s + 4) / 60) * (((B6poly 0) / 6) : ℂ) *
                (((M : ℝ) : ℂ) ^ (-s - 5) - ((n : ℝ) : ℂ) ^ (-s - 5))
            + ((s + 2 : ℂ) * (s + 3) * (s + 4) * (s + 5) * (s + 6) / 2520) *
                (((B8poly 0) / 8) : ℂ) *
                (((M : ℝ) : ℂ) ^ (-s - 7) - ((n : ℝ) : ℂ) ^ (-s - 7))
            + ((s + 2 : ℂ) * (s + 3) * (s + 4) * (s + 5) * (s + 6) * (s + 7) / 20160) *
                (∑ j ∈ Finset.Ico n M,
                  (∫ x in (j : ℝ)..(j + 1 : ℝ),
                    (B8poly (x - (j : ℝ)) : ℂ) * (x : ℂ) ^ (-s - 8))) := by
            dsimp only [S8]
