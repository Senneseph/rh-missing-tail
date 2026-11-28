import RhAttack.OnlineZetaEta6
import RhAttack.OnlineZetaGammaBound

open Complex Real Set Filter MeasureTheory Finset
open scoped Topology

set_option linter.unnecessarySimpa false

/-
honline Phase 1 increment 2 — the right-side (`1 < Re s`) Euler-transform
remainder bound.

This module gives the first explicit ζ-evaluation arc on the disk circle
(`OnlineZetaDiskGeom`): on the arc where `1 < Re s`, the eta/Euler engine of
Phase 2.3.2 (`OnlineZetaEta6`) evaluates `ζ(s)` as a finite explicit sum plus
the remainder `etaRemK s K = 2^{-K} ∫₀^∞ t^{s-1} e^{-t}(1-e^{-t})^K/(1+e^{-t})
dt`. Here the remainder kernel `t ↦ x^{sig-1} e^{-x} (1-e^{-x})^K/(1+e^{-x})`
(`x = e^{-t}`, `sig = Re s > 1`) is dominated on `(0, ∞)` by the piecewise
majorant

    `t^{sig+K-1}` on `(0,1]`,
    `(2 sig)^{sig-1} e^{-t}` on `(1, 2 sig)`,
    `(2 sig)^{sig-1} e^{-sig} e^{-t/2}` on `[2 sig, ∞)`,

whose integral is `1/(sig+K) + (2 sig)^{sig-1} e^{-1} +
2 (2 sig)^{sig-1} e^{-2 sig}` — so `‖etaRemK s K‖ ≤ 2^{-K}` times that
explicit constant. This feeds `N2` (no zero on the circle) via the
`|ζ(s)| ≥ |finite sum| - remainder` separation on the `Re s > 1` arc.

NO RH CLAIM: an intermediate bound on one arc of the disk circle. -/

/-- The right-side Euler-transform remainder bound: for `1 < s.re`,
    `‖etaRemK s K‖ ≤ 2^{-K} (1/(s.re + K) + (2 s.re)^{s.re-1} e^{-1}
    + 2 (2 s.re)^{s.re-1} e^{-2 s.re})`. -/
theorem etaRemK_norm_bound_right (hs : 1 < s.re) (K : ℕ) :
    ‖OnlineZetaEta6.etaRemK s K‖ ≤ (1 / 2 : ℝ) ^ K *
      (1 / (s.re + (K : ℝ)) + (2 * s.re) ^ (s.re - 1) * Real.exp (-1) +
       2 * (2 * s.re) ^ (s.re - 1) * Real.exp (-(2 * s.re))) := by
  set sig := s.re with hσdef
  have hp : -1 < sig + (K : ℝ) - 1 := by linarith
  have hsg : 0 < 2 * sig := by nlinarith [hs]
  set bK := fun x : ℝ => x ^ (sig - 1) * Real.exp (-x) * (1 - Real.exp (-x)) ^ K /
      (1 + Real.exp (-x)) with hbK
  set M := (Ioc (0 : ℝ) 1).indicator (fun x : ℝ => x ^ (sig + (K : ℝ) - 1)) +
      (Ioi (1 : ℝ) ∩ Iio (2 * sig)).indicator (fun x : ℝ => (2 * sig) ^ (sig - 1) * Real.exp (-x)) +
      (Ici (2 * sig)).indicator (fun x : ℝ => (2 * sig) ^ (sig - 1) * Real.exp (-sig) *
        Real.exp (-x / 2)) with hM
  -- (a) M is integrable.
  have hMInt : Integrable M := by
    set f1 := fun x : ℝ => x ^ (sig + (K : ℝ) - 1) with hf1
    have hMIcc : Integrable ((Ioc (0 : ℝ) 1).indicator f1) := by
      rw [integrable_indicator_iff measurableSet_Ioc]
      exact ((intervalIntegrable_iff_integrableOn_Ioc_of_le
        (by norm_num : (0 : ℝ) ≤ 1) :
        IntervalIntegrable f1 volume 0 1 ↔
          IntegrableOn f1 (Ioc (0 : ℝ) 1)).mp
        (intervalIntegral.intervalIntegrable_rpow' hp))
    set f2 := fun x : ℝ => (2 * sig) ^ (sig - 1) * Real.exp (-x) with hf2
    have hI12 : IntegrableOn f2 (Ioi (1 : ℝ) ∩ Iio (2 * sig)) := by
      have h1 : IntegrableOn (fun x : ℝ => Real.exp (-(1 : ℝ) * x)) (Ioi (1 : ℝ) ∩ Iio (2 * sig)) :=
        (exp_neg_integrableOn_Ioi (a := (1 : ℝ)) (b := (1 : ℝ)) (by norm_num)).mono_set
          Set.inter_subset_left
      have h1' : IntegrableOn (fun x : ℝ => Real.exp (-x)) (Ioi (1 : ℝ) ∩ Iio (2 * sig)) := by
        convert h1 using 1
        funext x
        ring_nf
      exact Integrable.const_mul h1'.integrable ((2 * sig) ^ (sig - 1))
    have hMI12 : Integrable ((Ioi (1 : ℝ) ∩ Iio (2 * sig)).indicator f2) := by
      rw [integrable_indicator_iff (measurableSet_Ioi.inter measurableSet_Iio)]
      exact hI12
    set f3 := fun x : ℝ => (2 * sig) ^ (sig - 1) * Real.exp (-sig) * Real.exp (-x / 2) with hf3
    set g2 := fun x : ℝ => Real.exp (-(1 / 2) * x) with hg2
    have hIoi2 : IntegrableOn g2 (Ioi (2 * sig)) :=
      exp_neg_integrableOn_Ioi (a := 2 * sig) (b := 1 / 2) (by norm_num)
    have hIoi2' : IntegrableOn (fun x : ℝ => Real.exp (-x / 2)) (Ioi (2 * sig)) := by
      convert hIoi2 using 1
      funext x
      dsimp only [g2]
      congr
      ring
    have hIci : IntegrableOn f3 (Ici (2 * sig)) := by
      have hIci' : IntegrableOn (fun x : ℝ => Real.exp (-x / 2)) (Ici (2 * sig)) := by
        have hIoi'' : IntegrableOn (fun x : ℝ => Real.exp (-x / 2)) (Ioi (2 * sig)) := hIoi2'
        have hunion : Ici (2 * sig) = Ioi (2 * sig) ∪ {2 * sig} := by
          ext x
          simp only [Set.mem_Ici, Set.mem_Ioi, Set.mem_union, Set.mem_singleton_iff]
          constructor
          · intro h
            by_cases hlt : 2 * sig < x
            · exact Or.inl hlt
            · exact Or.inr (le_antisymm (by
                by_contra hh
                exact hlt (not_le.mp hh)) h)
          · intro h
            rcases h with (h1 | h1)
            · exact le_of_lt h1
            · subst h1
              simp
        have hSing : IntegrableOn (fun x : ℝ => Real.exp (-x / 2)) ({2 * sig} : Set ℝ) :=
          IntegrableOn.of_measure_zero (by
            simpa using measure_singleton (2 * sig))
        rw [hunion]
        exact hIoi''.union hSing
      exact Integrable.const_mul hIci'.integrable
        (((2 * sig) ^ (sig - 1)) * Real.exp (-sig))
    have hMIoi2 : Integrable ((Ici (2 * sig)).indicator f3) := by
      rw [integrable_indicator_iff (measurableSet_Ici)]
      exact hIci
    dsimp only [M]
    exact (hMIcc.add hMI12).add hMIoi2
  -- (b) Pointwise: bK ≤ M on `(0, ∞)`.
  have hbM : ∀ x ∈ Ioi (0 : ℝ), bK x ≤ M x := by
    intro x hpos
    by_cases hle : x ≤ 1
    · -- `x ∈ (0, 1]`: majorant is `x^{sig+K-1}` (same as left side).
      have hA : 0 ≤ 1 - Real.exp (-x) := OnlineZetaEta6.one_sub_exp_neg_nonneg x hpos.le
      have hB : 1 - Real.exp (-x) ≤ x := OnlineZetaEta6.one_sub_exp_neg_le x hpos.le
      have hE : (1 - Real.exp (-x)) ^ K ≤ x ^ K := pow_le_pow_left₀ hA hB K
      have hG : 0 ≤ x ^ (sig - 1) := rpow_nonneg (le_of_lt hpos) _
      have hd : Real.exp (-x) / (1 + Real.exp (-x)) ≤ 1 := by
        apply (div_le_one (by nlinarith [Real.exp_pos (-x)])).2
        nlinarith [Real.exp_pos (-x)]
      have hmid : x ^ (sig - 1) * (Real.exp (-x) / (1 + Real.exp (-x))) *
          (1 - Real.exp (-x)) ^ K ≤ x ^ (sig - 1) * (1 - Real.exp (-x)) ^ K := by
        have hEpos : 0 ≤ (1 - Real.exp (-x)) ^ K := pow_nonneg hA K
        calc x ^ (sig - 1) * (Real.exp (-x) / (1 + Real.exp (-x))) *
            (1 - Real.exp (-x)) ^ K
            _ = x ^ (sig - 1) * ((Real.exp (-x) / (1 + Real.exp (-x))) *
                (1 - Real.exp (-x)) ^ K) := by ring
            _ ≤ x ^ (sig - 1) * (1 * (1 - Real.exp (-x)) ^ K) := by
              apply mul_le_mul_of_nonneg_left
              · apply mul_le_mul_of_nonneg_right hd
                exact hEpos
              · exact hG
            _ = x ^ (sig - 1) * (1 - Real.exp (-x)) ^ K := by ring
      have hfinal : x ^ (sig - 1) * (1 - Real.exp (-x)) ^ K ≤ x ^ (sig + (K : ℝ) - 1) := by
        calc x ^ (sig - 1) * (1 - Real.exp (-x)) ^ K
            _ ≤ x ^ (sig - 1) * x ^ K := by
              apply mul_le_mul_of_nonneg_left hE
              exact hG
            _ = x ^ (sig - 1) * x ^ (K : ℝ) := by
              rw [← Real.rpow_natCast x K]
            _ = x ^ (sig - 1 + (K : ℝ)) := by
              rw [← rpow_add (show 0 < x from hpos)]
            _ = x ^ (sig + (K : ℝ) - 1) := by ring_nf
      have hMval : M x = x ^ (sig + (K : ℝ) - 1) := by
        dsimp only [M]
        have hpos0 : 0 < x := hpos
        have h1 : x ∈ Ioc (0 : ℝ) 1 := ⟨hpos0, hle⟩
        have h2 : x ∉ Ioi (1 : ℝ) ∩ Iio (2 * sig) := by
          intro h
          have hgt : 1 < x := Set.mem_Ioi.mp h.1
          linarith [hgt, hle]
        have h3 : x ∉ Ici (2 * sig) := by
          intro h
          have hge : 2 * sig ≤ x := h
          have hgt1 : 1 < x := by
            calc 1 < 2 * sig := by nlinarith [hs]
              _ ≤ x := hge
          linarith [hgt1, hle]
        simp [h1, h2, h3]
      rw [hMval]
      have hred : x ^ (sig - 1) * Real.exp (-x) * (1 - Real.exp (-x)) ^ K /
          (1 + Real.exp (-x)) =
          x ^ (sig - 1) * (Real.exp (-x) / (1 + Real.exp (-x))) *
            (1 - Real.exp (-x)) ^ K := by
        field_simp
      dsimp only [bK]
      rw [hred]
      calc x ^ (sig - 1) * (Real.exp (-x) / (1 + Real.exp (-x))) *
          (1 - Real.exp (-x)) ^ K
          _ ≤ x ^ (sig - 1) * (1 - Real.exp (-x)) ^ K := hmid
          _ ≤ x ^ (sig + (K : ℝ) - 1) := hfinal
    · by_cases hle2 : x < 2 * sig
      · -- `x ∈ (1, 2 sig)`: majorant is `(2 sig)^{sig-1} e^{-x}`.
        have hgt : 1 < x := by
          by_contra hh
          have hle3 : x ≤ 1 := by linarith
          exact hle hle3
        have hA : 0 ≤ 1 - Real.exp (-x) := OnlineZetaEta6.one_sub_exp_neg_nonneg x (by linarith)
        have hE : (1 - Real.exp (-x)) ^ K ≤ 1 := by
          have he : 1 - Real.exp (-x) ≤ 1 := by linarith [Real.exp_pos (-x)]
          calc (1 - Real.exp (-x)) ^ K ≤ 1 ^ K := pow_le_pow_left₀ hA he K
            _ = 1 := by simp
        have hF : x ^ (sig - 1) ≤ (2 * sig) ^ (sig - 1) := by
          have hbase : x ≤ 2 * sig := by
            by_contra hh
            have hgt2 : 2 * sig < x := by linarith
            linarith [hle2, hgt2]
          exact rpow_le_rpow (le_of_lt hpos) hbase (by linarith [hs])
        have hMval : M x = (2 * sig) ^ (sig - 1) * Real.exp (-x) := by
          dsimp only [M]
          have h1 : x ∉ Ioc (0 : ℝ) 1 := by
            intro h
            have hle3 : x ≤ 1 := h.2
            linarith [hgt, hle3]
          have h2 : x ∈ Ioi (1 : ℝ) ∩ Iio (2 * sig) := ⟨hgt, hle2⟩
          have h3 : x ∉ Ici (2 * sig) := by
            intro h
            have hge : 2 * sig ≤ x := h
            linarith [hge, hle2]
          simp [h1, h2, h3]
        rw [hMval]
        have hred : x ^ (sig - 1) * Real.exp (-x) * (1 - Real.exp (-x)) ^ K /
            (1 + Real.exp (-x)) =
            x ^ (sig - 1) * (Real.exp (-x) * ((1 - Real.exp (-x)) ^ K /
              (1 + Real.exp (-x)))) := by
          field_simp
        dsimp only [bK]
        rw [hred]
        calc x ^ (sig - 1) * (Real.exp (-x) * ((1 - Real.exp (-x)) ^ K /
            (1 + Real.exp (-x))))
            _ ≤ x ^ (sig - 1) * (Real.exp (-x) * 1) := by
              apply mul_le_mul_of_nonneg_left
              · apply mul_le_mul_of_nonneg_left
                · rw [div_le_one (by nlinarith [Real.exp_pos (-x)])]
                  nlinarith [hE, Real.exp_pos (-x)]
                · exact le_of_lt (Real.exp_pos (-x))
              · apply rpow_nonneg
                linarith [hgt]
            _ = x ^ (sig - 1) * Real.exp (-x) := by ring
            _ ≤ (2 * sig) ^ (sig - 1) * Real.exp (-x) := by
              apply mul_le_mul_of_nonneg_right hF
              exact le_of_lt (Real.exp_pos (-x))
      · -- `x ≥ 2 sig`: majorant is `(2 sig)^{sig-1} e^{-sig} e^{-x/2}`.
        have hge : 2 * sig ≤ x := by
          by_contra hh
          have hle3 : x < 2 * sig := by linarith
          exact hle2 hle3
        have hgt : 1 < x := by
          calc 1 < 2 * sig := by nlinarith [hs]
            _ ≤ x := hge
        have hA : 0 ≤ 1 - Real.exp (-x) := OnlineZetaEta6.one_sub_exp_neg_nonneg x (by linarith)
        have hE : (1 - Real.exp (-x)) ^ K ≤ 1 := by
          have he : 1 - Real.exp (-x) ≤ 1 := by linarith [Real.exp_pos (-x)]
          calc (1 - Real.exp (-x)) ^ K ≤ 1 ^ K := pow_le_pow_left₀ hA he K
            _ = 1 := by simp
        set u := x / (2 * sig) with hudef
        have hu0 : 0 < u := by
          rw [hudef]
          apply div_pos
          · exact hpos
          · exact hsg
        have hu1 : 1 ≤ u := by
          rw [hudef, le_div_iff₀ hsg]
          linarith
        have hlog : (sig - 1) * Real.log u ≤ sig * (u - 1) := by
          have hln : Real.log u ≤ u - 1 := Real.log_le_sub_one_of_pos hu0
          have hsub1 : 0 ≤ u - 1 := sub_nonneg_of_le hu1
          have hsubn : 0 ≤ sig - 1 := sub_nonneg.mpr (le_of_lt hs)
          have hmul : (sig - 1) * (u - 1) ≤ sig * (u - 1) :=
            mul_le_mul_of_nonneg_right (by linarith [hs]) hsub1
          calc (sig - 1) * Real.log u ≤ (sig - 1) * (u - 1) :=
            mul_le_mul_of_nonneg_left hln hsubn
            _ ≤ sig * (u - 1) := hmul
        have hexp : u ^ (sig - 1) * Real.exp (-(sig * (u - 1))) ≤ 1 := by
          have hrpow : u ^ (sig - 1) = Real.exp ((sig - 1) * Real.log u) := by
            rw [Real.rpow_def_of_pos hu0]
            ring_nf
          have he : Real.exp ((sig - 1) * Real.log u) ≤ Real.exp (sig * (u - 1)) :=
            exp_le_exp.mpr hlog
          calc u ^ (sig - 1) * Real.exp (-(sig * (u - 1)))
              _ = Real.exp ((sig - 1) * Real.log u) * Real.exp (-(sig * (u - 1))) := by
                rw [hrpow]
              _ = Real.exp ((sig - 1) * Real.log u + (-(sig * (u - 1)))) := by
                rw [← Real.exp_add]
              _ = Real.exp ((sig - 1) * Real.log u - sig * (u - 1)) := by
                ring_nf
              _ ≤ Real.exp 0 := by
                apply Real.exp_le_exp.mpr
                linarith [hlog]
              _ = 1 := Real.exp_zero
        -- `x^{sig-1} e^{-x/2} ≤ (2 sig)^{sig-1} e^{-sig}`.
        have hphi : x ^ (sig - 1) * Real.exp (-x / 2) ≤
            (2 * sig) ^ (sig - 1) * Real.exp (-sig) := by
          have hsub1 : x = (2 * sig) * u := by
            rw [hudef]
            field_simp [hsg.ne']
          calc x ^ (sig - 1) * Real.exp (-x / 2)
              _ = ((2 * sig) * u) ^ (sig - 1) * Real.exp (-((2 * sig) * u) / 2) := by
                rw [hsub1]
              _ = (2 * sig) ^ (sig - 1) * u ^ (sig - 1) *
                  Real.exp (-(sig * u)) := by
                have hmul : ((2 * sig) * u) ^ (sig - 1) =
                    (2 * sig) ^ (sig - 1) * u ^ (sig - 1) := by
                  rw [← mul_rpow (show 0 ≤ 2 * sig from hsg.le) (show 0 ≤ u from hu0.le)]
                have hexparg : Real.exp (-((2 * sig) * u) / 2) =
                    Real.exp (-(sig * u)) := by
                  have heq : -((2 * sig) * u) / 2 = -(sig * u) := by ring
                  rw [heq]
                rw [hmul, hexparg]
              _ = (2 * sig) ^ (sig - 1) * (u ^ (sig - 1) * Real.exp (-(sig * (u - 1)))) *
                  Real.exp (-sig) := by
                have heq : Real.exp (-(sig * u)) =
                    Real.exp (-(sig * (u - 1))) * Real.exp (-sig) := by
                  have heqarg : -(sig * u) = -(sig * (u - 1)) + -sig := by ring
                  rw [heqarg]
                  rw [Real.exp_add]
                rw [heq]
                ring_nf
              _ ≤ (2 * sig) ^ (sig - 1) * 1 * Real.exp (-sig) := by
                apply mul_le_mul_of_nonneg_right
                · apply mul_le_mul_of_nonneg_left hexp
                  exact rpow_nonneg hsg.le (sig - 1)
                · exact le_of_lt (Real.exp_pos (-sig))
              _ = (2 * sig) ^ (sig - 1) * Real.exp (-sig) := by ring
        have hMval : M x = (2 * sig) ^ (sig - 1) * Real.exp (-sig) * Real.exp (-x / 2) := by
          dsimp only [M]
          have h1 : x ∉ Ioc (0 : ℝ) 1 := by
            intro h
            have hle3 : x ≤ 1 := h.2
            linarith [hgt, hle3]
          have h2 : x ∉ Ioi (1 : ℝ) ∩ Iio (2 * sig) := by
            intro h
            have hlt : x < 2 * sig := Set.mem_Iio.mp h.2
            linarith [hlt, hge]
          have h3 : x ∈ Ici (2 * sig) := hge
          simp [h1, h2, h3]
        rw [hMval]
        have hred : x ^ (sig - 1) * Real.exp (-x) * (1 - Real.exp (-x)) ^ K /
            (1 + Real.exp (-x)) =
            x ^ (sig - 1) * (Real.exp (-x) * ((1 - Real.exp (-x)) ^ K /
              (1 + Real.exp (-x)))) := by
          field_simp
        dsimp only [bK]
        rw [hred]
        calc x ^ (sig - 1) * (Real.exp (-x) * ((1 - Real.exp (-x)) ^ K /
            (1 + Real.exp (-x))))
            _ ≤ x ^ (sig - 1) * (Real.exp (-x) * 1) := by
              apply mul_le_mul_of_nonneg_left
              · apply mul_le_mul_of_nonneg_left
                · rw [div_le_one (by nlinarith [Real.exp_pos (-x)])]
                  nlinarith [hE, Real.exp_pos (-x)]
                · exact le_of_lt (Real.exp_pos (-x))
              · apply rpow_nonneg
                linarith [hgt]
            _ = x ^ (sig - 1) * (Real.exp (-x / 2) * Real.exp (-x / 2)) := by
              have heq : Real.exp (-x) = Real.exp (-x / 2) * Real.exp (-x / 2) := by
                have hadd : Real.exp (-x / 2) * Real.exp (-x / 2) =
                    Real.exp (-x / 2 + -x / 2) := by rw [Real.exp_add]
                rw [hadd]
                congr
                ring
              rw [heq]
              ring_nf
            _ = (x ^ (sig - 1) * Real.exp (-x / 2)) * Real.exp (-x / 2) := by ring
            _ ≤ ((2 * sig) ^ (sig - 1) * Real.exp (-sig)) * Real.exp (-x / 2) := by
              apply mul_le_mul_of_nonneg_right hphi
              exact le_of_lt (Real.exp_pos (-x / 2))
            _ = (2 * sig) ^ (sig - 1) * Real.exp (-sig) * Real.exp (-x / 2) := by ring
  -- (c) The majorant integral.
  have hMval : (∫ x in Ioi (0 : ℝ), M x ∂volume) ≤
      1 / (sig + (K : ℝ)) + (2 * sig) ^ (sig - 1) * Real.exp (-1) +
      2 * (2 * sig) ^ (sig - 1) * Real.exp (-(2 * sig)) := by
    set S1 := Ioc (0 : ℝ) 1 with hS1
    set S2 := Ioi (1 : ℝ) ∩ Iio (2 * sig) with hS2
    set S3 := Ici (2 * sig) with hS3
    have hS : S1 ∪ S2 ∪ S3 = Ioi (0 : ℝ) := by
      ext x
      constructor
      · intro h
        dsimp only [S1, S2, S3] at h
        simp only [Set.mem_union, Set.mem_Ioc, Set.mem_Ici] at h
        rcases h with ((⟨h0, _⟩ | ⟨h1, _⟩) | h1)
        · exact h0
        · exact lt_of_lt_of_le (by norm_num : (0 : ℝ) < 1) h1.le
        · have h4 : 0 < x := by
            have h5 : 2 * sig > 0 := by nlinarith [hs]
            linarith [h1, h5]
          exact h4
      · intro hpos
        by_cases hle : x ≤ 1
        · exact Or.inl (Or.inl (Set.mem_Ioc.mpr ⟨hpos, hle⟩))
        · have hgt : 1 < x := not_le.mp hle
          by_cases hlt : x < 2 * sig
          · exact Or.inl (Or.inr (Set.mem_inter hgt hlt))
          · exact Or.inr (Set.mem_Ici.mpr (by
              by_contra hh
              exact hlt (not_le.mp hh)))
    have hds1 : Disjoint S1 S2 := by
      dsimp only [S1, S2]
      rw [Set.disjoint_iff]
      intro x hx
      simp only [Set.mem_empty_iff_false]
      have h1 := Set.mem_Ioc.mp hx.1
      have h2 : 1 < x := Set.mem_Ioi.mp hx.2.1
      linarith [h1.2, h2]
    have hds2 : Disjoint S2 S3 := by
      dsimp only [S2, S3]
      rw [Set.disjoint_iff]
      intro x hx
      simp only [Set.mem_empty_iff_false]
      have h1 : x < 2 * sig := Set.mem_Iio.mp hx.1.2
      have h2 : 2 * sig ≤ x := Set.mem_Ici.mp hx.2
      linarith [h1, h2]
    have hds3 : Disjoint (S1 ∪ S2) S3 := by
      rw [Set.disjoint_iff]
      intro x hx
      simp only [Set.mem_empty_iff_false]
      have h2 : 2 * sig ≤ x := Set.mem_Ici.mp hx.2
      rcases hx.1 with (h1 | h1)
      · have h3 : x ≤ 1 := Set.mem_Ioc.mp h1 |>.2
        have h4 : 2 * sig > 1 := by nlinarith [hs]
        linarith [h2, h3, h4]
      · have h3 : x < 2 * sig := Set.mem_Iio.mp h1.2
        linarith [h2, h3]
    have hM1 : IntegrableOn M S1 := hMInt.integrableOn.mono_set (Set.subset_univ _)
    have hM2 : IntegrableOn M S2 := hMInt.integrableOn.mono_set (Set.subset_univ _)
    have hM3 : IntegrableOn M S3 := hMInt.integrableOn.mono_set (Set.subset_univ _)
    have hI1 : (∫ x in Ioi (0 : ℝ), M x ∂volume) =
        (∫ x in S1, M x ∂volume) + (∫ x in S2, M x ∂volume) +
        (∫ x in S3, M x ∂volume) := by
      have h1 : (∫ x in S1 ∪ S2, M x ∂volume) =
          (∫ x in S1, M x ∂volume) + (∫ x in S2, M x ∂volume) := by
        show _
        exact setIntegral_union hds1 (measurableSet_Ioi.inter measurableSet_Iio) hM1 hM2
      have h2 : (∫ x in S1 ∪ S2 ∪ S3, M x ∂volume) =
          (∫ x in S1 ∪ S2, M x ∂volume) + (∫ x in S3, M x ∂volume) := by
        show _
        exact setIntegral_union hds3 measurableSet_Ici (hM1.union hM2) hM3
      rw [← hS, h2, h1]
    -- Piece 1: `∫ in S1, M = ∫₀¹ x^{sig+K-1} = 1/(sig+K)`.
    set f1 := fun x : ℝ => x ^ (sig + (K : ℝ) - 1) with hf1
    have hv1 : (∫ x in S1, M x ∂volume) = 1 / (sig + (K : ℝ)) := by
      have hcong : ∀ x ∈ S1, M x = S1.indicator f1 x := by
        intro x hx
        dsimp only [M, S1]
        have h1 : x ∈ Ioc (0 : ℝ) 1 := hx
        have h2 : x ∉ Ioi (1 : ℝ) ∩ Iio (2 * sig) := by
          intro h
          have h3 : 1 < x := Set.mem_Ioi.mp h.1
          linarith [Set.mem_Ioc.mp h1 |>.2, h3]
        have h3 : x ∉ Ici (2 * sig) := by
          intro h
          have h4 : 2 * sig ≤ x := h
          have h5 : 2 * sig > 1 := by nlinarith [hs]
          linarith [Set.mem_Ioc.mp h1 |>.2, h4, h5]
        simp [hf1, h1, h2, h3]
      have h1 : ∫ x in S1, M x = ∫ x in S1, S1.indicator f1 x :=
        setIntegral_congr_fun measurableSet_Ioc (fun x hx => hcong x hx)
      have h2 : ∫ x in S1, S1.indicator f1 x = ∫ x in (0 : ℝ)..1, f1 x := by
        rw [setIntegral_indicator measurableSet_Ioc, Set.inter_self, hS1]
        rw [← intervalIntegral.integral_of_le (by norm_num : (0 : ℝ) ≤ 1)]
      rw [h1, h2]
      rw [OnlineZetaEta6.integral_rpow_Icc_0_1 (sig + (K : ℝ) - 1) hp]
      ring
    -- Piece 2: `∫ in S2, M ≤ (2 sig)^{sig-1} ∫ in S2, e^{-x}`.
    set cM := (2 * sig) ^ (sig - 1) with hcM
    have hv2 : (∫ x in S2, M x ∂volume) ≤
        cM * (Real.exp (-1) - Real.exp (-(2 * sig))) := by
      set f2 := fun x : ℝ => cM * Real.exp (-x) with hf2
      have hpoint : ∀ x ∈ S2, M x ≤ f2 x := by
        intro x hx
        dsimp only [M, S2, f2, cM]
        have h1 : x ∈ Ioi (1 : ℝ) ∩ Iio (2 * sig) := hx
        have h2 : x ∉ Ioc (0 : ℝ) 1 := by
          intro h
          have h3 : x ≤ 1 := Set.mem_Ioc.mp h |>.2
          have h4 : 1 < x := Set.mem_Ioi.mp h1.1
          linarith [h3, h4]
        have h3 : x ∉ Ici (2 * sig) := by
          intro h
          have h4 : 2 * sig ≤ x := h
          have h5 : x < 2 * sig := Set.mem_Iio.mp h1.2
          linarith [h4, h5]
        simp [h1, h2, h3]
      have hInt2 : IntegrableOn f2 S2 := by
        have h1 : IntegrableOn (fun x : ℝ => Real.exp (-x)) S2 := by
          have h2 : IntegrableOn (fun x : ℝ => Real.exp (-(1 : ℝ) * x)) (Ioi (1 : ℝ)) :=
            exp_neg_integrableOn_Ioi (a := (1 : ℝ)) (b := (1 : ℝ)) (by norm_num)
          have h3 : IntegrableOn (fun x : ℝ => Real.exp (-x)) (Ioi (1 : ℝ)) := by
            convert h2 using 1
            funext x
            ring_nf
          exact h3.mono_set (Set.inter_subset_left)
        exact Integrable.const_mul h1.integrable cM
      have hmono : ∫ x in S2, M x ≤ ∫ x in S2, f2 x :=
        setIntegral_mono_on hM2 hInt2 (measurableSet_Ioi.inter measurableSet_Iio) hpoint
      have hval : ∫ x in S2, f2 x = cM * (Real.exp (-1) - Real.exp (-(2 * sig))) := by
        have h1 : ∫ x in S2, f2 x = cM * ∫ x in S2, Real.exp (-x) := by
          rw [integral_const_mul (r := cM) (f := fun x : ℝ => Real.exp (-x))]
        rw [h1]
        have h2 : S2 = Ioi (1 : ℝ) \ S3 := by
          ext x
          dsimp only [S2, S3]
          simp only [Set.mem_Ioi, Set.mem_Ici, Set.mem_sdiff]
          constructor
          · rintro ⟨h1, h2⟩
            exact ⟨h1, not_le.mpr h2⟩
          · rintro ⟨h1, h2⟩
            exact ⟨h1, not_le.mp h2⟩
        rw [h2]
        have h3 : IntegrableOn (fun x : ℝ => Real.exp (-x)) (Ioi (1 : ℝ)) := by
          have h4 : IntegrableOn (fun x : ℝ => Real.exp (-(1 : ℝ) * x)) (Ioi (1 : ℝ)) :=
            exp_neg_integrableOn_Ioi (a := (1 : ℝ)) (b := (1 : ℝ)) (by norm_num)
          convert h4 using 1
          funext x
          ring_nf
        have h5 : (∫ x in Ioi (1 : ℝ) \ Ici (2 * sig), Real.exp (-x) ∂volume) =
            (∫ x in Ioi (1 : ℝ), Real.exp (-x) ∂volume) -
            (∫ x in Ici (2 * sig), Real.exp (-x) ∂volume) :=
          setIntegral_sdiff measurableSet_Ici h3 (by
            intro x hx
            exact lt_of_lt_of_le (by nlinarith [hs] : (1 : ℝ) < 2 * sig)
              (Set.mem_Ici.mp hx))
        rw [h5]
        have h6 : ∫ x in Ioi (1 : ℝ), Real.exp (-x) = Real.exp (-1) :=
          integral_exp_neg_Ioi 1
        have h7 : ∫ x in S3, Real.exp (-x) = Real.exp (-(2 * sig)) := by
          have h8 : IntegrableOn (fun x : ℝ => Real.exp (-x)) S3 := by
            have h9 : IntegrableOn (fun x : ℝ => Real.exp (-(1 : ℝ) * x)) (Ioi (2 * sig)) :=
              exp_neg_integrableOn_Ioi (a := 2 * sig) (b := (1 : ℝ)) (by norm_num)
            have h10 : IntegrableOn (fun x : ℝ => Real.exp (-x)) (Ioi (2 * sig)) := by
              convert h9 using 1
              funext x
              ring_nf
            have h11 : IntegrableOn (fun x : ℝ => Real.exp (-x)) S3 := by
              have hunion : S3 = Ioi (2 * sig) ∪ {2 * sig} := by
                ext x
                simp only [S3, Set.mem_Ici, Set.mem_Ioi, Set.mem_union, Set.mem_singleton_iff]
                constructor
                · intro h
                  by_cases hlt : 2 * sig < x
                  · exact Or.inl hlt
                  · exact Or.inr (le_antisymm (by
                      by_contra hh
                      exact hlt (not_le.mp hh)) h)
                · intro h
                  rcases h with (h1 | h1)
                  · exact le_of_lt h1
                  · subst h1
                    simp
              rw [hunion]
              have hSing : IntegrableOn (fun x : ℝ => Real.exp (-x)) ({2 * sig} : Set ℝ) :=
                IntegrableOn.of_measure_zero (by
                  simpa using measure_singleton (2 * sig))
              exact h10.union hSing
            convert h11 using 1
          have h9 : ∫ x in S3, Real.exp (-x) = ∫ x in Ioi (2 * sig), Real.exp (-x) := by
            have h10 : S3 =ᵐ[volume] Ioi (2 * sig) := by
              rw [ae_eq_set]
              refine ⟨?_, ?_⟩
              · have hsub : S3 \ Ioi (2 * sig) ⊆ {2 * sig} := by
                  intro x hx
                  dsimp only [S3] at hx
                  have heq : x = 2 * sig := by
                    apply le_antisymm
                    · by_contra hh
                      exact hx.2 (not_le.mp hh)
                    · exact hx.1
                  rw [heq]
                  simp
                exact measure_mono_null hsub (measure_singleton (2 * sig))
              · have hsub : Ioi (2 * sig) \ S3 = ∅ := by
                  ext x
                  dsimp only [S3]
                  simp only [Set.mem_Ioi, Set.mem_Ici, Set.mem_sdiff,
                    Set.mem_empty_iff_false]
                  constructor
                  · intro ⟨hx, h0⟩
                    have h1 : 2 * sig ≤ x := le_of_lt hx
                    exact h0 h1
                  · intro h
                    exact False.elim h
                rw [hsub]
                simp
            rw [setIntegral_congr_set h10]
          rw [h9]
          have h10 : ∫ x in Ioi (2 * sig), Real.exp (-x) = Real.exp (-(2 * sig)) :=
            integral_exp_neg_Ioi (2 * sig)
          rw [h10]
        rw [h6, h7]
      nlinarith [hmono, hval]
    -- Piece 3: `∫ in S3, M = 2 (2 sig)^{sig-1} e^{-2 sig}`.
    have hv3 : (∫ x in S3, M x ∂volume) = 2 * cM * Real.exp (-(2 * sig)) := by
      set f3 := fun x : ℝ => cM * Real.exp (-sig) * Real.exp (-x / 2) with hf3
      have hpoint : ∀ x ∈ S3, M x = f3 x := by
        intro x hx
        dsimp only [M, S3, f3, cM]
        have h1 : x ∈ Ici (2 * sig) := hx
        have h2 : x ∉ Ioc (0 : ℝ) 1 := by
          intro h
          have h3 : x ≤ 1 := Set.mem_Ioc.mp h |>.2
          have h4 : 2 * sig > 1 := by nlinarith [hs]
          have h5 : 2 * sig ≤ x := Set.mem_Ici.mp h1
          linarith [h5, h3, h4]
        have h3 : x ∉ Ioi (1 : ℝ) ∩ Iio (2 * sig) := by
          intro h
          have h4 : x < 2 * sig := Set.mem_Iio.mp h.2
          have h5 : 2 * sig ≤ x := Set.mem_Ici.mp h1
          linarith [h5, h4]
        simp [h1, h2, h3]
      have h1 : ∫ x in S3, M x = ∫ x in S3, f3 x :=
        setIntegral_congr_fun measurableSet_Ici (fun x hx => hpoint x hx)
      rw [h1]
      have h2 : ∫ x in S3, f3 x =
          cM * Real.exp (-sig) * ∫ x in S3, Real.exp (-x / 2) := by
        rw [integral_const_mul (r := cM * Real.exp (-sig)) (f := fun x : ℝ => Real.exp (-x / 2))]
      rw [h2]
      have h3 : ∫ x in S3, Real.exp (-x / 2) = 2 * Real.exp (-sig) := by
        have h4 : ∫ x in S3, Real.exp (-x / 2) = ∫ x in Ioi (2 * sig), Real.exp (-x / 2) := by
          have h5 : S3 =ᵐ[volume] Ioi (2 * sig) := by
            rw [ae_eq_set]
            refine ⟨?_, ?_⟩
            · have hsub : S3 \ Ioi (2 * sig) ⊆ {2 * sig} := by
                intro x hx
                dsimp only [S3] at hx
                have heq : x = 2 * sig := by
                  apply le_antisymm
                  · by_contra hh
                    exact hx.2 (not_le.mp hh)
                  · exact hx.1
                rw [heq]
                simp
              exact measure_mono_null hsub (measure_singleton (2 * sig))
            · have hsub : Ioi (2 * sig) \ S3 = ∅ := by
                ext x
                dsimp only [S3]
                simp only [Set.mem_Ioi, Set.mem_Ici, Set.mem_sdiff,
                  Set.mem_empty_iff_false]
                constructor
                · intro ⟨hx, h0⟩
                  have h1 : 2 * sig ≤ x := le_of_lt hx
                  exact h0 h1
                · intro h
                  exact False.elim h
              rw [hsub]
              simp
          rw [setIntegral_congr_set h5]
        rw [h4]
        have h5 : ∫ x in Ioi (2 * sig), Real.exp (-x / 2) =
            ∫ x in Ioi (2 * sig), Real.exp (-(1 / 2) * x) := by
          exact setIntegral_congr_fun measurableSet_Ioi (fun x _ => by ring_nf)
        rw [h5]
        have h6 : ∫ x in Ioi (2 * sig), Real.exp (-(1 / 2) * x) =
            2 * Real.exp (-(1 / 2) * (2 * sig)) :=
          OnlineZetaGammaBound.expNegHalfIoi (2 * sig)
        rw [h6]
        have heq : -(1 / 2) * (2 * sig) = -sig := by ring
        rw [heq]
      rw [h3]
      have heq2 : Real.exp (-(2 * sig)) = Real.exp (-sig + -sig) := by
        congr
        ring
      rw [heq2, Real.exp_add]
      ring_nf
    have hfin : cM * (Real.exp (-1) - Real.exp (-(2 * sig))) ≤ cM * Real.exp (-1) := by
      have h1 : Real.exp (-1) - Real.exp (-(2 * sig)) ≤ Real.exp (-1) := by
        have h2 : 0 ≤ Real.exp (-(2 * sig)) := Real.exp_nonneg _
        linarith [h2]
      have h2 : 0 ≤ cM := rpow_nonneg hsg.le (sig - 1)
      nlinarith [h1, h2]
    calc (∫ x in Ioi (0 : ℝ), M x ∂volume)
        _ = (∫ x in S1, M x ∂volume) + (∫ x in S2, M x ∂volume) +
            (∫ x in S3, M x ∂volume) := by rw [hI1]
        _ = 1 / (sig + (K : ℝ)) + (∫ x in S2, M x ∂volume) +
            (∫ x in S3, M x ∂volume) := by rw [hv1]
        _ ≤ 1 / (sig + (K : ℝ)) + cM * (Real.exp (-1) - Real.exp (-(2 * sig))) +
          2 * cM * Real.exp (-(2 * sig)) := by
          have h1 : (∫ x in S2, M x ∂volume) ≤
              cM * (Real.exp (-1) - Real.exp (-(2 * sig))) := hv2
          have h2 : (∫ x in S3, M x ∂volume) = 2 * cM * Real.exp (-(2 * sig)) := hv3
          rw [h2]
          nlinarith [h1]
        _ ≤ 1 / (sig + (K : ℝ)) + cM * Real.exp (-1) +
          2 * cM * Real.exp (-(2 * sig)) := by
          have h1 : cM * (Real.exp (-1) - Real.exp (-(2 * sig))) ≤ cM * Real.exp (-1) := hfin
          nlinarith [h1]
        _ = 1 / (sig + (K : ℝ)) + (2 * sig) ^ (sig - 1) * Real.exp (-1) +
          2 * (2 * sig) ^ (sig - 1) * Real.exp (-(2 * sig)) := by
          dsimp only [cM]
  -- (d) Assemble: norm of the remainder integral → majorant integral.
  have h1 : ‖OnlineZetaEta6.etaRemK s K‖ ≤
      ∫ x : ℝ in Ioi (0 : ℝ), ‖(OnlineZetaEta6.etaRemKernel s K) x‖ := by
    have h1a : ‖OnlineZetaEta6.etaRemK s K‖ ≤
        ∫ x : ℝ, ‖(Ioi (0 : ℝ)).indicator (OnlineZetaEta6.etaRemKernel s K) x‖ := by
      rw [OnlineZetaEta6.etaRemK, ← integral_indicator measurableSet_Ioi]
      exact norm_integral_le_integral_norm (fun x : ℝ =>
        (Ioi (0 : ℝ)).indicator (OnlineZetaEta6.etaRemKernel s K) x)
    have h1b : (∫ x : ℝ, ‖(Ioi (0 : ℝ)).indicator (OnlineZetaEta6.etaRemKernel s K) x‖) =
        (∫ x : ℝ in Ioi (0 : ℝ), ‖(OnlineZetaEta6.etaRemKernel s K) x‖) := by
      have heq : (fun x : ℝ => ‖(Ioi (0 : ℝ)).indicator (OnlineZetaEta6.etaRemKernel s K) x‖) =
          (fun x : ℝ => (Ioi (0 : ℝ)).indicator (fun x : ℝ =>
              ‖(OnlineZetaEta6.etaRemKernel s K) x‖) x) := by
        funext x
        by_cases hx : 0 < x
        · simp [hx, Set.Ioi, Set.indicator]
        · simp [hx, Set.Ioi, Set.indicator]
      rw [heq, integral_indicator measurableSet_Ioi]
    calc ‖OnlineZetaEta6.etaRemK s K‖
        _ ≤ ∫ x : ℝ, ‖(Ioi (0 : ℝ)).indicator (OnlineZetaEta6.etaRemKernel s K) x‖ := h1a
        _ = ∫ x : ℝ in Ioi (0 : ℝ), ‖(OnlineZetaEta6.etaRemKernel s K) x‖ := by rw [h1b]
  have hf : IntegrableOn (fun x : ℝ => ‖(OnlineZetaEta6.etaRemKernel s K) x‖) (Ioi (0 : ℝ)) :=
    (OnlineZetaEta6.etaRemKernel_integrableOn s (by linarith) K).integrable.norm
  have hg : IntegrableOn (fun x : ℝ => (1 / 2 : ℝ) ^ K * M x) (Ioi (0 : ℝ)) :=
    (hMInt.const_mul ((1 / 2 : ℝ) ^ K)).integrableOn.mono_set (Set.subset_univ _)
  have hle : ∫ x : ℝ in Ioi (0 : ℝ), ‖(OnlineZetaEta6.etaRemKernel s K) x‖ ≤
      ∫ x : ℝ in Ioi (0 : ℝ), (1 / 2 : ℝ) ^ K * M x :=
    setIntegral_mono_on hf hg measurableSet_Ioi (fun x hx => by
      have hnorm := OnlineZetaEta6.etaRemKernel_norm s (by linarith) K x hx
      have hnorm2 : ‖(OnlineZetaEta6.etaRemKernel s K) x‖ = (1 / 2 : ℝ) ^ K * bK x := by
        rw [hnorm]
        dsimp only [bK]
        ring
      rw [hnorm2]
      exact mul_le_mul_of_nonneg_left (hbM x hx) (by norm_num))
  have hextr : (∫ x : ℝ in Ioi (0 : ℝ), (1 / 2 : ℝ) ^ K * M x) =
      (1 / 2 : ℝ) ^ K * (∫ x : ℝ in Ioi (0 : ℝ), M x ∂volume) := by
    have hpoint : ∀ x : ℝ, (Ioi (0 : ℝ)).indicator (fun x : ℝ =>
        (1 / 2 : ℝ) ^ K * M x) x = (1 / 2 : ℝ) ^ K *
        (Ioi (0 : ℝ)).indicator (M) x := by
      intro x
      by_cases hx : 0 < x
      · simp [hx, Set.Ioi, Set.indicator]
      · simp [hx, Set.Ioi, Set.indicator]
    have hfun : (fun x : ℝ => (Ioi (0 : ℝ)).indicator (fun x : ℝ =>
        (1 / 2 : ℝ) ^ K * M x) x) =
        (fun x : ℝ => (1 / 2 : ℝ) ^ K * (Ioi (0 : ℝ)).indicator (M) x) := by
      funext x
      by_cases hx : 0 < x
      · simp [hx, Set.Ioi, Set.indicator]
      · simp [hx, Set.Ioi, Set.indicator]
    rw [← integral_indicator measurableSet_Ioi,
      show ∫ x : ℝ, (Ioi (0 : ℝ)).indicator (fun x : ℝ =>
          (1 / 2 : ℝ) ^ K * M x) x =
          ∫ x : ℝ, (1 / 2 : ℝ) ^ K *
          (Ioi (0 : ℝ)).indicator (M) x from congr_arg
        (fun f : ℝ → ℝ => ∫ x : ℝ, f x) hfun,
      integral_const_mul _ _, integral_indicator measurableSet_Ioi]
  calc ‖OnlineZetaEta6.etaRemK s K‖
      _ ≤ ∫ x : ℝ in Ioi (0 : ℝ), ‖(OnlineZetaEta6.etaRemKernel s K) x‖ := h1
      _ ≤ ∫ x : ℝ in Ioi (0 : ℝ), (1 / 2 : ℝ) ^ K * M x := hle
      _ = (1 / 2 : ℝ) ^ K * (∫ x : ℝ in Ioi (0 : ℝ), M x ∂volume) := hextr
      _ ≤ (1 / 2 : ℝ) ^ K *
          (1 / (sig + (K : ℝ)) + (2 * sig) ^ (sig - 1) * Real.exp (-1) +
           2 * (2 * sig) ^ (sig - 1) * Real.exp (-(2 * sig))) := by
        apply mul_le_mul_of_nonneg_left hMval
        exact pow_nonneg (by norm_num : (0 : ℝ) ≤ 1 / 2) K
      _ = (1 / 2 : ℝ) ^ K *
          (1 / (s.re + (K : ℝ)) + (2 * s.re) ^ (s.re - 1) * Real.exp (-1) +
           2 * (2 * s.re) ^ (s.re - 1) * Real.exp (-(2 * s.re))) := by
        dsimp only [sig]

