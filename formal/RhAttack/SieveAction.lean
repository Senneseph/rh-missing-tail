/-
Copyright: campaign (rh-missing-tail). All rights: the math is the math.

SieveAction.lean — Unit 2 of the KANSAS CITY SHUFFLE program
(docs/KANSAS-CITY-SHUFFLE-SIEVE-ORBIT-PLAN-2026-10-25.md), Lean pass.

The finite Fourier sieve operator.  Measured first (discovery 0172,
scripts/rh/kcs2_fourier_sieve.py + tmp/kcs2_out.txt):

  (i)   per-prime marks 1_{p |/. -} : Z/NZ -> {0,1} are self-adjoint
        idempotents in the pointwise algebra and commute (exact);
  (ii)  the single-prime Fourier symbol is the exact COMB
          F[1_{p |/. -}](a) = N * 1_{a = 0} - (N/p) * 1_{(N/p) | a} ,
        p support points:  N at the origin,  -N/p on the rest of the
        p-torsion (the (N/p)-torsion) subgroup of the character group;
  (iii) the full-sieve symbol is the RAMANUJAN field;  for SQUAREFREE N
        it has FULL support (all N characters nonzero) — the sparse
        per-prime combs convolve into a dense field:  the opacity of the
        second orbit lives in the convolution,  not in any single chime;
  (iv)  Parseval:  (1/N) * sum_a |F[mu](a)|^2 = sum_m mu^2 = phi(N).

This file proves the core of that package in-tree.  No RH claim.

Wave 1 (this build):  the idempotent/commuting marks,  the chime comb
identity (general N,  p | N),  and the prime closed form of the
Ramanujan symbol.  Wave 2 (statements staged at the bottom):
inclusion-exclusion bridge to the Ramanujan field,  multiplicativity,
full support,  the level census,  Parseval.
-/
import Mathlib

open Finset Complex

namespace SieveFourier

/-! ## Setup -/

/-- The standard N-th root of unity:  ζ_N = exp(2 π I / N),  written in
the exact form `isPrimitiveRoot_exp_of_coprime` produces. -/
noncomputable def rou (N : ℕ) : ℂ := exp (2 * Real.pi * I * (1 / (N : ℝ)))

/-- ζ_N is primitive exactly of order N for N ≥ 2 (take i = 1,  coprime
to N). -/
theorem primitive_rou (N : ℕ) (hN : 1 < N) : IsPrimitiveRoot (rou N) N := by
  convert isPrimitiveRoot_exp_of_coprime 1 N (by omega) (Nat.coprime_one_left N)
  ·
    simp only [rou]
    congr
    simp

/-- The character pairing:  m maps to the character a as ζ_N^(ma). -/
noncomputable def char_pow (N : ℕ) (m a : ℕ) : ℂ := (rou N) ^ (m * a)

/-- The Fourier symbol of f : Z/NZ -> C at character a. -/
noncomputable def dft (N : ℕ) (_hN : 1 ≤ N) (f : Fin N → ℂ) (a : Fin N) : ℂ :=
  ∑ m : Fin N, f m * char_pow N m.val a.val

/-- The per-prime mark:  1_{p |/. m}. -/
noncomputable def mark_notdiv (N : ℕ) (_hN : 1 ≤ N) (p : ℕ) (_hpn : p ∣ N) (m : Fin N) : ℂ :=
  if h : p ∣ m.val then 0 else 1

/-! ## The marks:  idempotent,  commuting (measured item (i)) -/

/-- The mark is an INDICATOR:  idempotent in the pointwise algebra. -/
theorem mark_notdiv_idempotent (N : ℕ) (hN : 1 ≤ N) (p : ℕ) (hpn : p ∣ N) (m : Fin N) :
    mark_notdiv N hN p hpn m * mark_notdiv N hN p hpn m = mark_notdiv N hN p hpn m := by
  unfold mark_notdiv
  split_ifs <;> simp

/-- The marks COMMUTE pointwise (the sieve as commuting projections —
the algebraic content of "the hops commute"). -/
theorem mark_notdiv_commute (N : ℕ) (hN : 1 ≤ N) (p q : ℕ)
    (hpn : p ∣ N) (hqn : q ∣ N) (m : Fin N) :
    mark_notdiv N hN p hpn m * mark_notdiv N hN q hqn m =
        mark_notdiv N hN q hqn m * mark_notdiv N hN p hpn m := by
  unfold mark_notdiv
  split_ifs <;> ring_nf

/-! ## The chime comb identity (measured item (ii)) -/

/-- CHIME COMB: for p | N and any character a : Z/NZ,

    sum_{m, p |/. m} ζ_N^(ma)  =  N·1_{a = 0} − (N/p)·1_{(N/p) | a}

The per-prime chime lives EXACTLY on the p-torsion subgroup
{ a : (N/p) | a } of the character group,  with value N − N/p at the
origin and −N/p on the other p − 1 points (p support points total).
No squarefree assumption is needed.  Measured:  max |LHS − RHS| =
8.9e-15 over all a at N = 210 (discovery 0172).
-/
theorem chime_comb {N p : ℕ} (hN : 1 ≤ N) (hp : p.Prime) (hpn : p ∣ N) (a : Fin N) :
    dft N hN (fun m => mark_notdiv N hN p hpn m) a =
        if a.val = 0 then ((N : ℂ) - (N / p : ℂ)) else if (N / p) ∣ a.val then (-(N / p : ℂ)) else 0 := by
  by_cases hN1 : N = 1
  · -- p | 1 is impossible for prime p
    subst hN1
    have hp1 : p ≤ 1 := Nat.le_of_dvd (by omega) hpn
    have h2 : 1 < p := hp.one_lt
    exfalso
    omega
  ·
    set s := N / p with hs
    have hNps : N = p * s := by rw [hs, Nat.mul_div_cancel' hpn]
    have hN2 : 1 < N := by omega
    have hs1 : 0 < s := by
      by_contra h
      have hN0 : 0 < N := by omega
      have hle : p ≤ N := Nat.le_of_dvd hN0 hpn
      have hdiv : 0 < N / p := Nat.div_pos hle hp.pos
      have hs' : 0 < s := by simpa [hs] using hdiv
      exact h hs'
    have hpr : IsPrimitiveRoot (rou N) N := primitive_rou N hN2
    have hroot : (rou N) ^ N = 1 := (hpr.pow_eq_one_iff_dvd N).mpr (dvd_refl N)
    -- the bridge:  (N/p) | k  <->  N | p * k  (cancellation of p > 0)
    have hbridge : ∀ k : ℕ, (N / p) ∣ k ↔ N ∣ p * k := by
      intro k
      constructor
      · rintro ⟨t, ht⟩
        use t
        rw [ht]
        have hdiv : p * (N / p) = N := Nat.mul_div_cancel' hpn
        rw [show p * ((N / p) * t) = (p * (N / p)) * t by ring, hdiv]
      · rintro ⟨t, ht⟩
        have h1 : p * k = p * (t * s) := by rw [ht, hNps]; ring_nf
        have hk' : k = t * s := Nat.eq_of_mul_eq_mul_left hp.pos h1
        rw [hk']
        use t
        ring
    simp only [dft, mark_notdiv, char_pow]
    -- LHS = full sum - p-multiple sum
    have hsplit : ((Finset.univ : Finset (Fin N)).sum (fun m => (if h : p ∣ m.val then 0 else 1) * (rou N) ^ (m.val * a.val))) =
        ((Finset.univ : Finset (Fin N)).sum (fun m => (rou N) ^ (m.val * a.val))) -
        ((Finset.univ : Finset (Fin N)).sum (fun m => (if p ∣ m.val then 1 else 0 : ℂ) * (rou N) ^ (m.val * a.val))) := by
      have hfullsum : ((Finset.univ : Finset (Fin N)).sum (fun m => (rou N) ^ (m.val * a.val))) =
          ((Finset.univ : Finset (Fin N)).sum (fun m => ((if p ∣ m.val then 0 else 1 : ℂ) * (rou N) ^ (m.val * a.val)) + ((if p ∣ m.val then 1 else 0 : ℂ) * (rou N) ^ (m.val * a.val)))) := by
        apply Finset.sum_congr rfl
        intro m
        split_ifs <;> simp [zero_mul, one_mul]
      have hadd : ((Finset.univ : Finset (Fin N)).sum (fun m => ((if p ∣ m.val then 0 else 1 : ℂ) * (rou N) ^ (m.val * a.val)) + ((if p ∣ m.val then 1 else 0 : ℂ) * (rou N) ^ (m.val * a.val)))) =
          ((Finset.univ : Finset (Fin N)).sum (fun m => (if p ∣ m.val then 0 else 1 : ℂ) * (rou N) ^ (m.val * a.val))) +
          ((Finset.univ : Finset (Fin N)).sum (fun m => (if p ∣ m.val then 1 else 0 : ℂ) * (rou N) ^ (m.val * a.val))) := by
        rw [Finset.sum_add_distrib]
      have hsum : ((Finset.univ : Finset (Fin N)).sum (fun m => (rou N) ^ (m.val * a.val))) =
          ((Finset.univ : Finset (Fin N)).sum (fun m => (if p ∣ m.val then 0 else 1 : ℂ) * (rou N) ^ (m.val * a.val))) +
          ((Finset.univ : Finset (Fin N)).sum (fun m => (if p ∣ m.val then 1 else 0 : ℂ) * (rou N) ^ (m.val * a.val))) := by
        rw [hfullsum, hadd]
      have hsubeq : ((Finset.univ : Finset (Fin N)).sum (fun m => (rou N) ^ (m.val * a.val))) -
          ((Finset.univ : Finset (Fin N)).sum (fun m => (if p ∣ m.val then 1 else 0 : ℂ) * (rou N) ^ (m.val * a.val))) =
          ((Finset.univ : Finset (Fin N)).sum (fun m => (if p ∣ m.val then 0 else 1 : ℂ) * (rou N) ^ (m.val * a.val))) := by
        rw [hsum]
        ring
      simpa using hsubeq.symm
    rw [hsplit]
    -- ---- the full geometric sum ------------------------------------
    set R := (rou N) ^ a.val with hR
    have hRpow : R ^ N = 1 := by
      calc
        R ^ N = (rou N) ^ (a.val * N) := by
          rw [hR]
          rw [← pow_mul]
        _ = ((rou N) ^ N) ^ a.val := by
          have he : (a.val * N) = N * a.val := by ring_nf
          rw [he, pow_mul]
        _ = 1 ^ a.val := by rw [hroot]
        _ = 1 := one_pow a.val
    set Rsum := ((Finset.univ : Finset (Fin N)).sum (fun m => (rou N) ^ (m.val * a.val))) with hRsum
    have hfull : Rsum = if a.val = 0 then (N : ℂ) else 0 := by
      have hperm2 : Rsum = ((Finset.range N : Finset ℕ).sum (fun j => R ^ j)) := by
        have hbij : Rsum = ((Finset.range N : Finset ℕ).sum (fun v => (rou N) ^ (v * a.val))) :=
          Finset.sum_bij
            (fun m _ => m.val)
            (fun m _ => by simpa using m.isLt)
            (fun m₁ _ m₂ _ h => Fin.ext h)
            (fun v hv => ⟨Fin.mk v (Finset.mem_range.mp hv), ⟨by simpa using Finset.mem_univ (Fin.mk v (Finset.mem_range.mp hv)), rfl⟩⟩)
            (fun m _ => rfl)
        calc
          Rsum = ((Finset.range N : Finset ℕ).sum (fun v => (rou N) ^ (v * a.val))) := hbij
          _ = (((Finset.range N : Finset ℕ).sum (fun j => R ^ j))) := by
            apply Finset.sum_congr rfl
            intro j _
            rw [Nat.mul_comm, pow_mul, hR]
      rw [hperm2]
      by_cases ha : a.val = 0
      ·
        have hR1 : R = 1 := by simpa [hR, ha] using (pow_zero ((rou N) : ℂ))
        calc
          (((Finset.range N : Finset ℕ).sum (fun j => R ^ j))) = (((Finset.range N : Finset ℕ).sum (fun j => (1 : ℂ) ^ j))) := by
            simp [hR1]
          _ = (N : ℂ) := by
            simp
        rw [ha]
        simp
      ·
        have hRne : R ≠ 1 := by
          intro h
          have hd : N ∣ a.val := (hpr.pow_eq_one_iff_dvd a.val).1 (by
            simpa [hR] using h)
          have hz : a.val = 0 := Nat.eq_zero_of_dvd_of_lt hd (a.isLt)
          exact ha hz
        have hmul : (((Finset.range N : Finset ℕ).sum (fun j => R ^ j))) * (R - 1) = 0 := by
          rw [geom_sum_mul R N, hRpow, sub_self (1 : ℂ)]
        have hsub : R - 1 ≠ 0 := sub_ne_zero.mpr hRne
        have hzero : (((Finset.range N : Finset ℕ).sum (fun j => R ^ j))) = 0 := by
          have hmulc : (R - 1) * (((Finset.range N : Finset ℕ).sum (fun j => R ^ j))) = 0 := by
            simpa [mul_comm] using hmul
          exact (Or.resolve_left (mul_eq_zero.mp hmulc) hsub)
        rw [hzero]
        rw [if_neg ha]
    -- ---- the p-multiple sum -----------------------------------------
    set r := (rou N) ^ (p * a.val) with hr
    have hrpow : r ^ s = 1 := by
      calc
        r ^ s = (rou N) ^ (p * a.val * s) := by
          rw [hr]
          rw [← pow_mul]
        _ = ((rou N) ^ N) ^ a.val := by
          have he : (p * a.val) * s = N * a.val := by
            calc
              (p * a.val) * s = (p * s) * a.val := by ring
              _ = N * a.val := by rw [← hNps]
          rw [he, pow_mul]
        _ = 1 ^ a.val := by rw [hroot]
        _ = 1 := one_pow a.val
    have hpmult : ((Finset.univ : Finset (Fin N)).sum (fun m => (if p ∣ m.val then 1 else 0 : ℂ) * (rou N) ^ (m.val * a.val))) =
        if (N / p) ∣ a.val then (s : ℂ) else 0 := by
      -- reindex the p-multiples {m < N | p | m} <-> {j < s} via j |-> p*j
      set f := fun (m : Fin N) => (rou N) ^ (m.val * a.val) with hf
      have hmem : ∀ (m : Fin N), p ∣ m.val → m.val / p < s := by
        intro m hpm
        have hlt : m.val < p * s := by
          simpa [hNps] using m.isLt
        exact Nat.div_lt_of_lt_mul hlt
      have hmap_memb : ∀ (j : Fin s), p * j.val < N := by
        intro j
        have : p * j.val < p * s := Nat.mul_lt_mul_of_pos_left (j.isLt) hp.pos
        simpa [hNps] using this
      have hbij : ((((Finset.univ : Finset (Fin N)).filter (fun m : Fin N => p ∣ m.val)).sum (fun m => f m))) =
          ((Finset.univ : Finset (Fin s)).sum (fun j => r ^ j.val)) :=
        Finset.sum_bij
          (fun m hm => (Fin.mk (m.val / p) (hmem m (Finset.mem_filter.mp hm).2) : Fin s))
          (fun m _ => by simp)
          (fun m₁ hm₁ m₂ hm₂ h => by
            have hpm1 : p ∣ m₁.val := (Finset.mem_filter.mp hm₁).2
            have hpm2 : p ∣ m₂.val := (Finset.mem_filter.mp hm₂).2
            have hdiv : m₁.val / p = m₂.val / p := by
              simpa using congrArg (Fin.val : Fin s → ℕ) h
            have h1 : m₁.val = p * (m₁.val / p) := (Nat.mul_div_cancel' hpm1).symm
            have h2 : m₂.val = p * (m₂.val / p) := (Nat.mul_div_cancel' hpm2).symm
            have hval : m₁.val = m₂.val := by
              calc
                m₁.val = p * (m₁.val / p) := h1
                _ = p * (m₂.val / p) := by rw [hdiv]
                _ = m₂.val := h2.symm
            exact Fin.ext hval)
          (fun j _ => ⟨(Fin.mk (p * j.val) (hmap_memb j) : Fin N), by
            have hm0 : (Fin.mk (p * j.val) (hmap_memb j) : Fin N) ∈
                Finset.univ.filter (fun m : Fin N => p ∣ m.val) := by
              simp only [Finset.mem_filter, Finset.mem_univ]
              exact ⟨True.intro, Nat.dvd_mul_right p j.val⟩
            have hdiv : (p * j.val) / p = j.val := by
              have hd : p * ((p * j.val) / p) = p * j.val :=
                Nat.mul_div_cancel' (Nat.dvd_mul_right p j.val)
              exact Nat.eq_of_mul_eq_mul_left hp.pos hd
            exact ⟨hm0, Fin.ext hdiv⟩
          ⟩)
          (fun m hm => by
            have hpm : p ∣ m.val := (Finset.mem_filter.mp hm).2
            simp only [f, hr]
            -- flatten the nested RHS power (pow_mul here is flat->nested, so use <-)
            rw [← pow_mul]
            -- now:  (rou N)^(m·a)  =  (rou N)^((p·a)·(m/p));  close via exponent equality
            have hexp : m.val * a.val = (p * a.val) * (m.val / p) := by
              have hdmp : (m.val / p) * p = m.val := Nat.div_mul_cancel hpm
              conv =>
                lhs
                rw [hdmp.symm]
              ring
            rw [hexp])
      -- now:  the Fin s sum  =  the range-s geom sum in r
      have hperm3 : (((Finset.univ : Finset (Fin s)).sum (fun j => r ^ j.val))) = (((Finset.range s : Finset ℕ).sum (fun k => r ^ k))) :=
        Finset.sum_bij
          (fun j _ => j.val)
          (fun j _ => Finset.mem_range.mpr j.isLt)
          (fun j₁ _ j₂ _ h => Fin.ext h)
          (fun k hk => ⟨Fin.mk k (Finset.mem_range.mp hk), by simp⟩)
          (fun j _ => rfl)
      have hpmult_sum : ((Finset.univ : Finset (Fin N)).sum (fun m => (if p ∣ m.val then 1 else 0 : ℂ) * f m)) =
          ((Finset.range s : Finset ℕ).sum (fun k => r ^ k)) := by
        -- indicator sum = filter sum (the indicator is 0 off the filter)
        have h1 : (((Finset.univ : Finset (Fin N)).sum (fun m => (if p ∣ m.val then 1 else 0 : ℂ) * f m))) =
            ((((Finset.univ : Finset (Fin N)) \ ((Finset.univ : Finset (Fin N)).filter (fun m : Fin N => p ∣ m.val))).sum (fun m => (if p ∣ m.val then 1 else 0 : ℂ) * f m))) +
            ((((Finset.univ : Finset (Fin N)).filter (fun m : Fin N => p ∣ m.val)).sum (fun m => (if p ∣ m.val then 1 else 0 : ℂ) * f m))) := by
          rw [Finset.sum_sdiff (Finset.filter_subset (fun m : Fin N => p ∣ m.val) Finset.univ)]
        have h2 : ((((Finset.univ : Finset (Fin N)) \ ((Finset.univ : Finset (Fin N)).filter (fun m : Fin N => p ∣ m.val))).sum (fun m => (if p ∣ m.val then 1 else 0 : ℂ) * f m))) = 0 := by
          apply Finset.sum_eq_zero
          intro m hm
          have hnp : ¬ p ∣ m.val := by
            by_contra h
            have hm2 : m ∈ Finset.filter (fun m : Fin N => p ∣ m.val) Finset.univ :=
                Finset.mem_filter.mpr ⟨by simp, h⟩
            exact (Finset.mem_sdiff.mp hm).2 hm2
          rw [if_neg hnp, zero_mul]
        have h3 : ((((Finset.univ : Finset (Fin N)).filter (fun m : Fin N => p ∣ m.val)).sum (fun m => (if p ∣ m.val then 1 else 0 : ℂ) * f m))) =
            ((((Finset.univ : Finset (Fin N)).filter (fun m : Fin N => p ∣ m.val)).sum (fun m => f m))) := by
          apply Finset.sum_congr rfl
          intro m hm
          have hpm : p ∣ m.val := (Finset.mem_filter.mp hm).2
          simp only [hpm, hm, ite_true, one_mul]
        have h4 : ((Finset.univ : Finset (Fin N)).sum (fun m => (if p ∣ m.val then 1 else 0 : ℂ) * f m)) =
            (((Finset.univ : Finset (Fin N)).sum (fun m => (if p ∣ m.val then 1 else 0 : ℂ) * f m))) := rfl
        rw [h1, h2, h3, hbij, hperm3]
        ring_nf
      -- the p-multiple indicator sum is exactly the goal LHS (definition of f)
      have hgoal : ((Finset.univ : Finset (Fin N)).sum (fun m => (if p ∣ m.val then 1 else 0 : ℂ) * (rou N) ^ (m.val * a.val))) =
          ((Finset.univ : Finset (Fin N)).sum (fun m => (if p ∣ m.val then 1 else 0 : ℂ) * f m)) := by
        simp only [f, hf]
      rw [hgoal, hpmult_sum]
      -- assemble the two cases of the geometric sum
      by_cases hrs : (N / p) ∣ a.val
      ·
        have hr1 : r = 1 := by
          have hd : N ∣ p * a.val := (hbridge a.val).mp hrs
          have := hpr.pow_eq_one_iff_dvd (p * a.val)
          simpa [hr] using this.mpr hd
        have Hsum : (((Finset.range s : Finset ℕ).sum (fun k => r ^ k))) = (s : ℂ) := by
          calc
            (((Finset.range s : Finset ℕ).sum (fun k => r ^ k))) = (((Finset.range s : Finset ℕ).sum (fun k => (1 : ℂ) ^ k))) := by
              simp [hr1]
            _ = (s : ℂ) := by
              simp
        rw [Hsum, if_pos hrs]
      ·
        have hrne : r ≠ 1 := by
          intro h
          have hd : N ∣ p * a.val := (hpr.pow_eq_one_iff_dvd (p * a.val)).1 (by
            simpa [hr] using h)
          have hrs' : (N / p) ∣ a.val := (hbridge a.val).mpr hd
          exact hrs hrs'
        have hmul : (((Finset.range s : Finset ℕ).sum (fun k => r ^ k))) * (r - 1) = 0 := by
          rw [geom_sum_mul r s, hrpow, sub_self (1 : ℂ)]
        have hsub : r - 1 ≠ 0 := sub_ne_zero.mpr hrne
        have hzero : (((Finset.range s : Finset ℕ).sum (fun k => r ^ k))) = 0 := by
          have hmulc : (r - 1) * (((Finset.range s : Finset ℕ).sum (fun k => r ^ k))) = 0 := by
            simpa [mul_comm] using hmul
          exact (Or.resolve_left (mul_eq_zero.mp hmulc) hsub)
        rw [hzero]
        rw [if_neg hrs]
    -- ---- assemble -----------------------------------------------------
    have hnm : (N : ℂ) = (p : ℂ) * (s : ℂ) := by
      rw [hNps, hs]
      simp only [Nat.cast_mul]
    have hPz : (p : ℂ) ≠ 0 := Nat.cast_ne_zero.mpr (show p ≠ 0 by linarith [hp.pos])
    have hdivc : (s : ℂ) = (N : ℂ) / (p : ℂ) := by
      rw [hnm, mul_comm, mul_div_cancel_right₀ (s : ℂ) hPz]
    rw [hfull, hpmult]
    by_cases ha : a.val = 0
    ·
      -- each ite is reduced in its own have (rw only matches one ite occurrence per rule)
      have hLt : (if a.val = 0 then (N : ℂ) else 0) = (N : ℂ) := by rw [if_pos ha]
      have hCt : (if (N / p) ∣ a.val then (s : ℂ) else 0) = (s : ℂ) := by
        rw [if_pos (by simpa [ha] using Nat.dvd_zero (N / p))]
      have hRt : (if a.val = 0 then ((N : ℂ) - (N / p : ℂ)) else if (N / p) ∣ a.val then (-(N / p : ℂ)) else 0) = (N : ℂ) - (N / p : ℂ) := by
        rw [if_pos ha]
      rw [hLt, hCt, hRt, hdivc]
    · by_cases hrs : (N / p) ∣ a.val
      ·
        have hL0 : (if a.val = 0 then (N : ℂ) else 0) = 0 := by rw [if_neg ha]
        have hCs : (if (N / p) ∣ a.val then (s : ℂ) else 0) = (s : ℂ) := by rw [if_pos hrs]
        have hRn : (if a.val = 0 then ((N : ℂ) - (N / p : ℂ)) else if (N / p) ∣ a.val then (-(N / p : ℂ)) else 0) = (-(N / p : ℂ)) := by
          rw [if_neg ha, if_pos hrs]
        rw [hL0, hCs, hRn, zero_sub]
        exact (congrArg (fun x : ℂ => -x) hdivc)
      ·
        have hL0 : (if a.val = 0 then (N : ℂ) else 0) = 0 := by rw [if_neg ha]
        have hC0 : (if (N / p) ∣ a.val then (s : ℂ) else 0) = 0 := by rw [if_neg hrs]
        have hR0 : (if a.val = 0 then ((N : ℂ) - (N / p : ℂ)) else if (N / p) ∣ a.val then (-(N / p : ℂ)) else 0) = 0 := by
          rw [if_neg ha, if_neg hrs]
        rw [hL0, hC0, hR0, sub_zero]

/-! ## The Ramanujan symbol  (measured item (iii),  wave 1:  prime case) -/

/-- The Ramanujan symbol (the full-sieve Fourier symbol):
c_N(a) = sum over unit m < N of ζ_N^(ma). -/
noncomputable def raman (N : ℕ) (_hN : 1 ≤ N) (a : Fin N) : ℂ :=
  ∑ m : Fin N, (if Nat.Coprime m.val N then 1 else 0 : ℂ) *
    char_pow N m.val a.val

/-- PRIME CLOSED FORM:  for prime p and a : Fin p,
c_p(a) = p − 1 if a = 0  and  −1 otherwise.
(Bridge to the measured level-set structure:  the prime chime takes
only the two values p−1 and −1.) -/
theorem raman_prime_closed (p : ℕ) (hp : p.Prime) (a : Fin p) :
    raman p (Nat.le_of_lt hp.one_lt) a =
        if a.val = 0 then (p - 1 : ℂ) else -1 := by
  have hp2 : 1 < p := hp.one_lt
  have hpr : IsPrimitiveRoot (rou p) p := primitive_rou p hp2
  dsimp only [raman, char_pow]
  -- the units mod p among 0..p-1 are exactly 1..p-1
  have hchar : ∀ m : Fin p, (if Nat.Coprime m.val p then 1 else 0 : ℂ) =
      (if m.val = 0 then 0 else 1 : ℂ) := by
    intro m
    by_cases hm0 : m.val = 0
    ·
      have hnot : ¬ Nat.Coprime 0 p := by
        intro h
        exact hp.ne_one (by simpa [Nat.gcd_zero_left] using h)
      simp_all
    ·
      have hc : Nat.Coprime m.val p := by
        by_cases hdvd : p ∣ m.val
        · have hz : m.val = 0 := Nat.eq_zero_of_dvd_of_lt hdvd (m.isLt)
          contradiction
        · exact ((hp.coprime_iff_not_dvd).mpr hdvd).symm
      simp_all [hc]
  -- (sum over all =  the filter sum  +  the m = 0 term,  then drop the singleton)
  have hdisj : Disjoint (Finset.univ.filter (fun m : Fin p => m.val ≠ 0)) {⟨0, hp.pos⟩} := by
    rw [Finset.disjoint_left]
    intro m hm hz
    have hne : m.val ≠ 0 := (Finset.mem_filter.mp hm).2
    have hm0 : m = ⟨0, hp.pos⟩ := by simpa [Finset.mem_singleton] using hz
    subst hm0
    have hx : (⟨0, hp.pos⟩ : Fin p).val = 0 := by simp
    exact hne hx
  have hcomp : (Finset.univ : Finset (Fin p)) =
      Finset.univ.filter (fun m : Fin p => m.val ≠ 0) ∪
      {⟨0, hp.pos⟩} := by
    ext m
    have hsub : (m : Fin p) = ⟨0, hp.pos⟩ ↔ m.val = 0 := by
      constructor
      · intro h
        simp [h]
      · intro h
        exact Fin.ext h
    rw [Finset.mem_union, Finset.mem_filter, Finset.mem_singleton, hsub]
    by_cases hm0 : m.val = 0
    · simp [hm0]
    ·
      simp [hm0]
  have h1 : ((Finset.univ : Finset (Fin p)).sum (fun m => (rou p) ^ (m.val * a.val))) =
      ((((Finset.univ : Finset (Fin p)).filter (fun m : Fin p => m.val ≠ 0)).sum (fun m => (rou p) ^ (m.val * a.val)))) +
      (rou p) ^ ((⟨0, hp.pos⟩ : Fin p).val * a.val) := by
    conv_lhs =>
      rw [show (Finset.univ : Finset (Fin p)) =
          Finset.univ.filter (fun m : Fin p => m.val ≠ 0) ∪ {⟨0, hp.pos⟩} from hcomp]
    rw [Finset.sum_union hdisj]
    rw [Finset.sum_singleton]
  have h2 : ((Finset.univ : Finset (Fin p)).sum (fun m => (if Nat.Coprime m.val p then 1 else 0 : ℂ) * (rou p) ^ (m.val * a.val))) =
      ((((Finset.univ : Finset (Fin p)).filter (fun m : Fin p => m.val ≠ 0)).sum (fun m => (rou p) ^ (m.val * a.val)))) := by
    have h3 : ((Finset.univ : Finset (Fin p)).sum (fun m => (if Nat.Coprime m.val p then 1 else 0 : ℂ) * (rou p) ^ (m.val * a.val))) =
        (((Finset.univ : Finset (Fin p)).sum (fun m => (if m.val = 0 then 0 else 1 : ℂ) * (rou p) ^ (m.val * a.val)))) := by
      apply Finset.sum_congr rfl
      intro m _
      rw [hchar m]
    have h4 : (((Finset.univ : Finset (Fin p)).sum (fun m => (if m.val = 0 then 0 else 1 : ℂ) * (rou p) ^ (m.val * a.val)))) =
        ((((Finset.univ : Finset (Fin p)).filter (fun m : Fin p => m.val ≠ 0)).sum (fun m => (if m.val = 0 then 0 else 1 : ℂ) * (rou p) ^ (m.val * a.val)))) := by
      conv_lhs =>
        rw [show (Finset.univ : Finset (Fin p)) =
            Finset.univ.filter (fun m : Fin p => m.val ≠ 0) ∪ {⟨0, hp.pos⟩} from hcomp]
      rw [Finset.sum_union hdisj]
      rw [Finset.sum_singleton]
      have hzero : ((if (⟨0, hp.pos⟩ : Fin p).val = 0 then 0 else 1 : ℂ) * (rou p) ^ ((⟨0, hp.pos⟩ : Fin p).val * a.val)) = 0 := by
        simp
      rw [hzero, add_zero]
    rw [h3, h4]
    apply Finset.sum_congr rfl
    intro m hm
    have hne : m.val ≠ 0 := (Finset.mem_filter.mp hm).2
    simp only [hne, ite_false, one_mul]
  have hfull : ((Finset.univ : Finset (Fin p)).sum (fun m => (rou p) ^ (m.val * a.val))) = if a.val = 0 then (p : ℂ) else 0 := by
    set R := (rou p) ^ a.val with hR
    have hRpow : R ^ p = 1 := by
      calc
        R ^ p = (rou p) ^ (a.val * p) := by
          rw [hR]
          rw [← pow_mul]
        _ = ((rou p) ^ p) ^ a.val := by
          rw [← pow_mul, Nat.mul_comm]
        _ = 1 ^ a.val := by rw [(hpr.pow_eq_one_iff_dvd p).mpr (dvd_refl p)]
        _ = 1 := one_pow a.val
    have hperm : ((Finset.univ : Finset (Fin p)).sum (fun m => (rou p) ^ (m.val * a.val))) = (((Finset.range p : Finset ℕ).sum (fun j => R ^ j))) := by
      have hbij : ((Finset.univ : Finset (Fin p)).sum (fun m => (rou p) ^ (m.val * a.val))) =
          (((Finset.range p : Finset ℕ).sum (fun v => (rou p) ^ (v * a.val)))) :=
        Finset.sum_bij
          (fun m _ => m.val)
          (fun m _ => by simpa using m.isLt)
          (fun m₁ _ m₂ _ h => Fin.ext h)
          (fun v hv => ⟨Fin.mk v (Finset.mem_range.mp hv), ⟨by simpa using Finset.mem_univ (Fin.mk v (Finset.mem_range.mp hv)), rfl⟩⟩)
          (fun m _ => rfl)
      calc
        ((Finset.univ : Finset (Fin p)).sum (fun m => (rou p) ^ (m.val * a.val))) =
            (((Finset.range p : Finset ℕ).sum (fun v => (rou p) ^ (v * a.val)))) := hbij
        _ = (((Finset.range p : Finset ℕ).sum (fun j => R ^ j))) := by
          apply Finset.sum_congr rfl
          intro j _
          rw [Nat.mul_comm, pow_mul, hR]
    rw [hperm]
    by_cases ha : a.val = 0
    ·
      have hR1 : R = 1 := by simpa [hR, ha] using (pow_zero ((rou p) : ℂ))
      calc
        (((Finset.range p : Finset ℕ).sum (fun j => R ^ j))) = (((Finset.range p : Finset ℕ).sum (fun j => (1 : ℂ) ^ j))) := by
          simp [hR1]
        _ = (p : ℂ) := by
          simp
      rw [ha]
      simp
    ·
      have hRne : R ≠ 1 := by
        intro h
        have hd : p ∣ a.val := (hpr.pow_eq_one_iff_dvd a.val).1 (by
          simpa [hR] using h)
        have hz : a.val = 0 := Nat.eq_zero_of_dvd_of_lt hd (a.isLt)
        exact ha hz
      have hmul : (((Finset.range p : Finset ℕ).sum (fun j => R ^ j))) * (R - 1) = 0 := by
        rw [geom_sum_mul R p, hRpow, sub_self (1 : ℂ)]
      have hsub : R - 1 ≠ 0 := sub_ne_zero.mpr hRne
      have hzero : (((Finset.range p : Finset ℕ).sum (fun j => R ^ j))) = 0 := by
        have hmulc : (R - 1) * (((Finset.range p : Finset ℕ).sum (fun j => R ^ j))) = 0 := by
          simpa [mul_comm] using hmul
        exact (Or.resolve_left (mul_eq_zero.mp hmulc) hsub)
      rw [hzero]
      rw [if_neg ha]
  calc
    raman p (Nat.le_of_lt hp.one_lt) a =
        ((Finset.univ : Finset (Fin p)).sum (fun m => (if Nat.Coprime m.val p then 1 else 0 : ℂ) * (rou p) ^ (m.val * a.val))) := by
      dsimp only [raman, char_pow]
    _ = ((((Finset.univ : Finset (Fin p)).filter (fun m : Fin p => m.val ≠ 0)).sum (fun m => (rou p) ^ (m.val * a.val)))) := h2
    _ = ((Finset.univ : Finset (Fin p)).sum (fun m => (rou p) ^ (m.val * a.val))) - 1 := by
      have h1v : (((Finset.univ : Finset (Fin p)).sum (fun m => (rou p) ^ (m.val * a.val)))) =
          ((((Finset.univ : Finset (Fin p)).filter (fun m : Fin p => m.val ≠ 0)).sum (fun m => (rou p) ^ (m.val * a.val)))) + (1 : ℂ) := by
        simpa [show (⟨0, hp.pos⟩ : Fin p).val * a.val = 0 from by simp, pow_zero, one_mul] using h1
      exact (eq_sub_of_add_eq h1v.symm)
    _ = (if a.val = 0 then (p : ℂ) else 0) - 1 := by rw [hfull]
  by_cases ha0 : a.val = 0
  ·
    rw [if_pos ha0, if_pos ha0]
  ·
    rw [if_neg ha0, if_neg ha0]
    simp

/-! ## Wave 2  (staged;  measured in 0172) -/

-- (A1)  Orthogonality:  a complete period of the additive characters
--        e_N(k .)  sums to  N  iff  N | k,  to  0  otherwise.
theorem rou_sum_orthogonality {N k : ℕ} (hN : 1 < N) :
    (∑ a : Fin N, (rou N) ^ (a.val * k)) = if N ∣ k then (N : ℂ) else 0 := by
  by_cases hd : N ∣ k
  ·
    rw [if_pos hd]
    have hw : ∀ (a : Fin N), (rou N) ^ (a.val * k) = 1 := by
      intro a
      have hp2 : 1 < N := hN
      have hpow : (rou N) ^ k = 1 :=
        (primitive_rou N hp2 |>.pow_eq_one_iff_dvd k).mpr hd
      have hpowk : (rou N) ^ (a.val * k) = ((rou N) ^ k) ^ a.val := by
        rw [show (a.val * k : ℕ) = k * a.val from by ring, pow_mul]
      rw [hpowk, hpow]
      simp
    calc (∑ a : Fin N, (rou N) ^ (a.val * k))
        = ∑ a : Fin N, 1 := by
          apply Finset.sum_congr rfl
          intro a _
          exact hw a
      _ = (N : ℂ) := by
        simp [Finset.sum_const, Finset.card_fin, nsmul_eq_mul, mul_one]
  ·
    rw [if_neg hd]
    have hpr := primitive_rou N hN
    have hw : (rou N) ^ k ≠ 1 := by
      intro h1
      exact hd ((hpr.pow_eq_one_iff_dvd k).mp h1)
    --  flatten the per-term power,  change the Fin N sum to the range N sum,
    --  apply the geometric formula,  close with  (rou N)^N = 1.
    have hflat : (∑ a : Fin N, (rou N) ^ (a.val * k)) =
        ∑ a : Fin N, ((rou N) ^ k) ^ a.val := by
      apply Finset.sum_congr rfl
      intro m _
      rw [show (m.val * k : ℕ) = k * m.val from by ring, pow_mul]
    have hfin : (∑ a : Fin N, ((rou N) ^ k) ^ a.val) =
        (∑ i ∈ Finset.range N, ((rou N) ^ k) ^ i) :=
      Finset.sum_bij
        (fun a _ => a.val)
        (fun a _ => by simpa using a.isLt)
        (fun a₁ _ a₂ _ h => Fin.ext h)
        (fun b hb => ⟨Fin.mk b (Finset.mem_range.mp hb), by simp [Fin.val]⟩)
        (fun a _ => rfl)
    have hωN : ((rou N) ^ k) ^ N = 1 := by
      have hxN : (rou N) ^ N = 1 := hpr.pow_eq_one
      rw [show ((rou N) ^ k) ^ N = (rou N) ^ (k * N) from by rw [pow_mul],
          show (k * N : ℕ) = N * k from by ring,
          show (rou N) ^ (N * k) = ((rou N) ^ N) ^ k from by rw [pow_mul],
          hxN]
      simp
    calc (∑ a : Fin N, (rou N) ^ (a.val * k))
        = (∑ a : Fin N, ((rou N) ^ k) ^ a.val) := hflat
      _ = (∑ i ∈ Finset.range N, ((rou N) ^ k) ^ i) := hfin
      _ = (((rou N) ^ k) ^ N - 1) / ((rou N) ^ k - 1) := by
          rw [geom_sum_eq hw N]
      _ = 0 := by
          rw [show (((rou N) ^ k) ^ N - 1 : ℂ) = 0 from sub_eq_zero.mpr hωN]
          exact zero_div _


-- TODO(wave-2):
--   raman_inclusion_exclusion (N squarefree):
--     raman N a = sum_{d | N} (μ d) * (N / d) * 1_{ (N/d) | a }
--     (the full-sieve symbol is the Ramanujan field)
--   raman_multiplicativity (m, n coprime,  both > 1):
--     c_{mn}(a) = c_m(a mod m) * c_n(a mod n)   (CRT factorization)
--   raman_full_support (N squarefree,  1 < N):  raman N a ≠ 0 for all a
--     (measured:  30030/30030 nonzero at N = 30030)
--   raman_level_census (N squarefree):
--     |{a : N | N / gcd(a, N) = k}| = φ k   (the 64 level sets at N = 30030)
--   parseval_units (N squarefree, 1 < N):
--     sum_a |raman N a|^2 = N * φ N   (measured diff 0.0)


-- (A2.0)  Concrete divisor-sum form of Mobius inversion:
--         sum_{d | n} mu(d)  =  1_{n = 1}.
theorem mobius_sum_nat (n : ℕ) :
    (∑ d ∈ n.divisors, (ArithmeticFunction.moebius d : ℤ)) =
        if n = 1 then (1 : ℤ) else 0 := by
  by_cases hn : n = 0
  · subst n
    simp
  ·
    have hdpos : 0 < n := Nat.pos_of_ne_zero hn
    have hz1 : ∀ x ∈ n.divisorsAntidiagonal,
        ((ArithmeticFunction.zeta : ArithmeticFunction ℤ) x.2) = 1 := by
      intro x hx
      have hmem : x.1 * x.2 = n ∧ n ≠ 0 := Nat.mem_divisorsAntidiagonal.mp hx
      have hx2n0 : x.2 ≠ 0 := by
        intro hx2z
        nlinarith [hmem.1, show 0 < n from hdpos]
      simp [ArithmeticFunction.zeta_apply, hx2n0]
    have hinv : (ArithmeticFunction.moebius * (ArithmeticFunction.zeta : ArithmeticFunction ℤ) :
                ArithmeticFunction ℤ) n = (1 : ArithmeticFunction ℤ) n :=
      congrArg (fun F : ArithmeticFunction ℤ => F n)
        ArithmeticFunction.moebius_mul_coe_zeta
    have hreduce : (∑ x ∈ n.divisorsAntidiagonal,
        (ArithmeticFunction.moebius x.1 : ℤ) * ((ArithmeticFunction.zeta : ArithmeticFunction ℤ) x.2)) =
        (∑ x ∈ n.divisorsAntidiagonal, (ArithmeticFunction.moebius x.1 : ℤ)) := by
      apply Finset.sum_congr rfl
      intro x hx
      rw [hz1 x hx, mul_one]
    have hbij : (∑ x ∈ n.divisorsAntidiagonal, (ArithmeticFunction.moebius x.1 : ℤ)) =
        (∑ d ∈ n.divisors, (ArithmeticFunction.moebius d : ℤ)) :=
      Finset.sum_bij
        (fun x _ => x.1)
        (fun x hx => by
          have hxprod : x.1 * x.2 = n ∧ n ≠ 0 :=
            Nat.mem_divisorsAntidiagonal.mp hx
          have hx1p : 0 < x.1 := by
            by_contra z
            nlinarith [hxprod.1, hdpos]
          exact Nat.mem_divisors.mpr
            ⟨by simpa [hxprod.1] using Nat.dvd_mul_right x.1 x.2, hdpos.ne'⟩)
        (fun x₁ hx₁ x₂ hx₂ hxy => by
          have hxprod : x₁.1 * x₁.2 = n := (Nat.mem_divisorsAntidiagonal.mp hx₁).1
          have hyprod : x₂.1 * x₂.2 = n := (Nat.mem_divisorsAntidiagonal.mp hx₂).1
          have hx1p : 0 < x₁.1 := by
            by_contra z
            nlinarith [hxprod, hdpos]
          have hyprod' : x₁.1 * x₂.2 = n := by simpa [hxy] using hyprod
          have hxyprod : x₁.1 * x₁.2 = x₁.1 * x₂.2 := by nlinarith [hxprod, hyprod']
          have hxy1 : x₁.2 = x₂.2 := Nat.eq_of_mul_eq_mul_left hx1p hxyprod
          exact (Prod.ext hxy hxy1))
        (fun d hd => by
          rw [Nat.mem_divisors] at hd
          have hdd : d ∣ n := hd.1
          exact ⟨(d, n / d),
            ⟨Nat.mem_divisorsAntidiagonal.mpr ⟨Nat.mul_div_cancel' hdd, hdpos.ne'⟩, rfl⟩⟩)
        (fun x _ => rfl)
    have heqL : (∑ d ∈ n.divisors, (ArithmeticFunction.moebius d : ℤ)) =
        (ArithmeticFunction.moebius * (ArithmeticFunction.zeta : ArithmeticFunction ℤ)) n := by
      calc (∑ d ∈ n.divisors, (ArithmeticFunction.moebius d : ℤ))
          = (∑ x ∈ n.divisorsAntidiagonal, (ArithmeticFunction.moebius x.1 : ℤ)) := hbij.symm
        _ = (∑ x ∈ n.divisorsAntidiagonal,
              (ArithmeticFunction.moebius x.1 : ℤ) * ((ArithmeticFunction.zeta : ArithmeticFunction ℤ) x.2)) :=
              hreduce.symm
        _ = (ArithmeticFunction.moebius * (ArithmeticFunction.zeta : ArithmeticFunction ℤ)) n :=
            by rw [ArithmeticFunction.mul_apply]
    rw [heqL, hinv, ArithmeticFunction.one_apply]

-- (A2.1)  The unit indicator as a Mobius sum over the common divisors.
theorem mobius_unit_indicator (m N : ℕ) (hN : 0 < N) :
    (if Nat.Coprime m N then (1 : ℂ) else 0) =
        (∑ d ∈ (Nat.gcd m N).divisors, (ArithmeticFunction.moebius d : ℂ)) := by
  have hz : (∑ d ∈ (Nat.gcd m N).divisors, (ArithmeticFunction.moebius d : ℤ)) =
      if Nat.gcd m N = 1 then (1 : ℤ) else 0 :=
    mobius_sum_nat (Nat.gcd m N)
  have hg : ((if Nat.gcd m N = 1 then (1 : ℤ) else 0) : ℂ) =
      if Nat.Coprime m N then (1 : ℂ) else 0 := by
    simp [Nat.coprime_iff_gcd_eq_one]
    <;> split_ifs <;> simp_all [Int.cast_one, Int.cast_zero]
  have hzcast : (∑ d ∈ (Nat.gcd m N).divisors, (ArithmeticFunction.moebius d : ℂ)) =
      if Nat.gcd m N = 1 then (1 : ℂ) else 0 := by
    rw [← Int.cast_sum (Nat.gcd m N).divisors (fun d => (ArithmeticFunction.moebius d : ℤ))]
    rw [hz]
    by_cases h1 : Nat.gcd m N = 1
    · simp [h1]
    · simp [h1]
  rw [hzcast]

set_option maxHeartbeats 400000
-- (A2.2)  INCLUSION-EXCLUSION (the full-sieve symbol is the Ramanujan

--         field,  in the exact divisor-sum form  verified in 0172):
--
--         raman  N  a  =  sum_{d | N}  mu(d) * (N/d) * 1_{ (N/d) | a }
--
--         (equivalently  sum_{e | (a, N)}  e * mu(N/e)).  No squarefree
--         assumption;  the prime closed form  and  the  squarefree
--         product  are  specializations.
theorem raman_inclusion_exclusion {N : ℕ} (hN : 1 < N) (a : Fin N) :
    raman N (Nat.le_of_lt hN) a =
        (∑ d ∈ N.divisors,
          if (N / d) ∣ a.val then ((N / d : ℕ) : ℂ) * (ArithmeticFunction.moebius d : ℂ) else 0) := by
  change (∑ m : Fin N, (if Nat.Coprime m.val N then (1 : ℂ) else 0) *
      (rou N) ^ (m.val * a.val)) =
    (∑ d ∈ N.divisors,
      if (N / d) ∣ a.val then ((N / d : ℕ) : ℂ) * (ArithmeticFunction.moebius d : ℂ) else 0)
  have hz0 : 0 < N := by omega
  -- the unit Mobius sum  over  (m, N)-divisors  =  the  N-divisor
  --    sum  with  the  1_{d | m}  condition
  have hsumswap (m : Fin N) :
      (∑ d ∈ (Nat.gcd m.val N).divisors, (ArithmeticFunction.moebius d : ℂ)) =
          (∑ d ∈ N.divisors,
            if d ∣ m.val then (ArithmeticFunction.moebius d : ℂ) else 0) := by
    have hgcnz : 0 < Nat.gcd m.val N := by
      by_contra z
      have hg0 : Nat.gcd m.val N = 0 := by omega
      have hdvd : Nat.gcd m.val N ∣ N := Nat.gcd_dvd_right m.val N
      have hdvd0 : 0 ∣ N := by simpa [hg0] using hdvd
      obtain ⟨k, hk⟩ := hdvd0
      have hN0 : N = 0 := by nlinarith [hk]
      exact hz0.ne' hN0
    have hgcnz' : Nat.gcd m.val N ≠ 0 := hgcnz.ne'
    have hfilter : (∑ d ∈ N.divisors,
        (if d ∣ m.val then (ArithmeticFunction.moebius d : ℂ) else 0)) =
        (∑ d ∈ (N.divisors).filter (fun d => d ∣ m.val),
          (ArithmeticFunction.moebius d : ℂ)) := by
      rw [Finset.sum_ite (fun d : ℕ => (ArithmeticFunction.moebius d : ℂ)) (fun _ => (0 : ℂ))]
      have hzero : (∑ d ∈ (N.divisors).filter (fun d => ¬d ∣ m.val), (0 : ℂ)) = 0 := by
        apply Finset.sum_eq_zero
        intro d _
        simp
      rw [hzero, add_zero]
    have hbij : (∑ d ∈ (N.divisors).filter (fun d => d ∣ m.val),
        (ArithmeticFunction.moebius d : ℂ)) =
        (∑ d ∈ (Nat.gcd m.val N).divisors, (ArithmeticFunction.moebius d : ℂ)) :=
      Finset.sum_bij
        (fun d _ => d)
        (fun d hd => by
          have hmem := Finset.mem_filter.mp hd
          have hdM : d ∣ m.val := hmem.2
          have hdN : d ∣ N := by
            rw [Nat.mem_divisors] at hmem
            exact hmem.1.1
          exact Nat.mem_divisors.mpr
            ⟨Nat.dvd_gcd_iff.mpr ⟨hdM, hdN⟩, hgcnz'⟩)
        (fun d₁ _ d₂ _ h => h)
        (fun d hd => by
          have hdg : d ∣ Nat.gcd m.val N := by
            rw [Nat.mem_divisors] at hd
            exact hd.1
          have hmem : d ∈ N.divisors :=
            Nat.mem_divisors.mpr ⟨Nat.dvd_trans hdg (Nat.gcd_dvd_right m.val N), hz0.ne'⟩
          have hdm : d ∣ m.val := Nat.dvd_trans hdg (Nat.gcd_dvd_left m.val N)
          exact ⟨d, ⟨Finset.mem_filter.mpr ⟨hmem, hdm⟩, rfl⟩⟩)
        (fun d _ => rfl)
    rw [hfilter]
    exact hbij.symm
  calc
    (∑ m : Fin N, (if Nat.Coprime m.val N then (1 : ℂ) else 0) *
        (rou N) ^ (m.val * a.val))
        = ∑ m : Fin N, (∑ d ∈ N.divisors,
            (if d ∣ m.val then (ArithmeticFunction.moebius d : ℂ) else 0) *
              (rou N) ^ (m.val * a.val)) := by
          apply Finset.sum_congr rfl
          intro m _
          have hui := mobius_unit_indicator m.val N hz0
          rw [hui, hsumswap m, mul_comm, Finset.mul_sum]
          apply Finset.sum_congr rfl
          intro d _
          ring
    _ = ∑ d ∈ N.divisors,
        (∑ m : Fin N,
          (if d ∣ m.val then (ArithmeticFunction.moebius d : ℂ) else 0) *
            (rou N) ^ (m.val * a.val)) := by
          change (∑ m ∈ (Finset.univ : Finset (Fin N)),
              ∑ d ∈ N.divisors,
                (if d ∣ m.val then (ArithmeticFunction.moebius d : ℂ) else 0) *
                  (rou N) ^ (m.val * a.val)) =
            (∑ d ∈ N.divisors,
              ∑ m ∈ (Finset.univ : Finset (Fin N)),
                (if d ∣ m.val then (ArithmeticFunction.moebius d : ℂ) else 0) *
                  (rou N) ^ (m.val * a.val))
          rw [Finset.sum_comm]
    _ = ∑ d ∈ N.divisors,
        (ArithmeticFunction.moebius d : ℂ) *
          (∑ m : Fin N,
            (if d ∣ m.val then (1 : ℂ) else 0) * (rou N) ^ (m.val * a.val)) := by
          apply Finset.sum_congr rfl
          intro d _
          change (∑ m ∈ (Finset.univ : Finset (Fin N)),
              (if d ∣ m.val then (ArithmeticFunction.moebius d : ℂ) else 0) *
                (rou N) ^ (m.val * a.val)) =
            (ArithmeticFunction.moebius d : ℂ) *
              (∑ m ∈ (Finset.univ : Finset (Fin N)),
                (if d ∣ m.val then (1 : ℂ) else 0) * (rou N) ^ (m.val * a.val))
          have hre : (∑ m ∈ (Finset.univ : Finset (Fin N)),
              (if d ∣ m.val then (ArithmeticFunction.moebius d : ℂ) else 0) *
                (rou N) ^ (m.val * a.val)) =
              (∑ m ∈ (Finset.univ : Finset (Fin N)),
                (ArithmeticFunction.moebius d : ℂ) *
                  ((if d ∣ m.val then (1 : ℂ) else 0) * (rou N) ^ (m.val * a.val))) := by
            apply Finset.sum_congr rfl
            intro m _
            split_ifs <;> ring
          rw [hre, ← Finset.mul_sum]
    _ = ∑ d ∈ N.divisors,
        if (N / d) ∣ a.val then
          ((N / d : ℕ) : ℂ) * (ArithmeticFunction.moebius d : ℂ) else 0 := by
          apply Finset.sum_congr rfl
          intro d hd
          have hdN : d ∣ N := (Nat.mem_divisors.mp hd).1
          have hNps : N = d * (N / d) := (Nat.mul_div_cancel' hdN).symm
          have hdp : 0 < d := by
            by_contra z
            have hd0 : d = 0 := by omega
            subst hd0
            obtain ⟨k, hk⟩ := hdN
            have hN0 : N = 0 := by nlinarith [hk]
            omega
          by_cases hdN0 : d = N
          · subst d
            -- at d = N  only  m = 0  survives,  contributing  1
            have hdiv : ∀ m : Fin N, N ∣ m.val ↔ m.val = 0 := by
              intro m
              constructor
              · intro h
                by_contra hz
                have hzN : 0 < m.val := Nat.pos_of_ne_zero hz
                have hle : N ≤ m.val := Nat.le_of_dvd hzN h
                omega
              · intro h
                rw [h]
                simp
            have hsum1 : (∑ m : Fin N,
                (if m.val = 0 then (1 : ℂ) else 0) * (rou N) ^ (m.val * a.val)) =
                (1 : ℂ) := by
              have h0s : (∑ m : Fin N,
                  (if m.val = 0 then (1 : ℂ) else 0) * (rou N) ^ (m.val * a.val)) =
                  (∑ m ∈ (Finset.univ : Finset (Fin N)).filter
                    (fun m => m.val = 0), (1 : ℂ) * (rou N) ^ (m.val * a.val)) := by
                change (∑ m ∈ (Finset.univ : Finset (Fin N)),
                    (if m.val = 0 then (1 : ℂ) else 0) * (rou N) ^ (m.val * a.val)) =
                    (∑ m ∈ (Finset.univ : Finset (Fin N)).filter
                      (fun m => m.val = 0), (1 : ℂ) * (rou N) ^ (m.val * a.val))
                have hite : (∑ m ∈ (Finset.univ : Finset (Fin N)),
                    (if m.val = 0 then (1 : ℂ) else 0) * (rou N) ^ (m.val * a.val)) =
                    (∑ m ∈ (Finset.univ : Finset (Fin N)),
                      if m.val = 0 then (1 : ℂ) * (rou N) ^ (m.val * a.val) else 0) := by
                  apply Finset.sum_congr rfl
                  intro m _
                  split_ifs <;> ring
                have hw : (∑ m ∈ (Finset.univ : Finset (Fin N)),
                    (if m.val = 0 then (1 : ℂ) else 0) *
                    (rou N) ^ (m.val * a.val)) =
                    (∑ m ∈ (Finset.univ : Finset (Fin N)),
                      if m.val = 0 then (1 : ℂ) * (rou N) ^ (m.val * a.val) else 0)
                    := by
                  apply Finset.sum_congr rfl
                  intro m _
                  split_ifs <;> ring
                have hsumite : (∑ m ∈ (Finset.univ : Finset (Fin N)),
                    if m.val = 0 then (1 : ℂ) * (rou N) ^ (m.val * a.val) else 0) =
                    (∑ m ∈ (Finset.univ : Finset (Fin N)).filter
                      (fun m => m.val = 0), (1 : ℂ) * (rou N) ^ (m.val * a.val)) +
                    (∑ m ∈ (Finset.univ : Finset (Fin N)).filter
                      (fun m => ¬m.val = 0), (0 : ℂ)) :=
                  Finset.sum_ite (fun (m : Fin N) => (1 : ℂ) * (rou N) ^ (m.val * a.val))
                    (fun _ => (0 : ℂ))
                rw [hw, hsumite]
                have hzero : (∑ m ∈ (Finset.univ : Finset (Fin N)).filter
                    (fun m => ¬m.val = 0), (0 : ℂ)) = 0 := by
                  apply Finset.sum_eq_zero
                  intro m _
                  simp
                rw [hzero, add_zero]
              have hfilter0 : (Finset.univ : Finset (Fin N)).filter
                  (fun m => m.val = 0) = {Fin.mk 0 (by omega)} := by
                ext m
                constructor
                · intro h
                  have hmem : m ∈ (Finset.univ : Finset (Fin N)) ∧ m.val = 0 :=
                    Finset.mem_filter.mp h
                  have hv : m.val = 0 := hmem.2
                  have hF : m = Fin.mk 0 (by omega) := (Fin.ext_iff).mpr hv
                  rw [Finset.mem_singleton]
                  exact hF
                · intro h
                  have hF : m = Fin.mk 0 (by omega) := Finset.mem_singleton.mp h
                  have hv : m.val = 0 := by
                    subst hF
                    rfl
                  rw [Finset.mem_filter]
                  exact ⟨Finset.mem_univ _, hv⟩
              rw [h0s, hfilter0, Finset.sum_singleton]
              simp
            have hin : (∑ m : Fin N,
                (if N ∣ m.val then (1 : ℂ) else 0) * (rou N) ^ (m.val * a.val)) =
                (1 : ℂ) := by
              calc _
                  = ∑ m : Fin N, (if m.val = 0 then (1 : ℂ) else 0) *
                      (rou N) ^ (m.val * a.val) := by
                    apply Finset.sum_congr rfl
                    intro m _
                    rw [show (if N ∣ m.val then (1 : ℂ) else 0) =
                            (if m.val = 0 then (1 : ℂ) else 0) from by
                      by_cases hA : N ∣ m.val
                      · have hB : m.val = 0 := (hdiv m).1 hA
                        simp [hA, hB]
                      · have hnotB : ¬m.val = 0 := by
                          intro z
                          exact hA ((hdiv m).2 z)
                        simp [hA, hnotB]]
              _ = 1 := hsum1
            rw [hin, Nat.div_self (show 0 < N from by omega)]
            simp [Nat.one_dvd]
          ·
            have hdlt : d < N := Nat.lt_of_le_of_ne
                (Nat.le_of_dvd hz0 hdN) hdN0
            have hM : 1 < N / d := by
              by_contra hle
              have hl : N / d ≤ 1 := Nat.le_of_not_gt hle
              have hpos : 0 < N / d :=
                Nat.div_pos (Nat.le_of_dvd hz0 hdN) hdp
              have heq1 : N / d = 1 := by omega
              have hN : N = d := by simpa [heq1] using hNps
              subst hN
              exact hdN0 rfl
            -- reindex the d-multiples of  < N  as  m  =  d * j,  j < N/d
            have hreindex : (∑ m : Fin N,
                (if d ∣ m.val then (1 : ℂ) else 0) * (rou N) ^ (m.val * a.val)) =
                (∑ j : Fin (N / d), (rou N) ^ ((d * j.val) * a.val)) := by
              have hst : (∑ m : Fin N,
                  (if d ∣ m.val then (1 : ℂ) else 0) * (rou N) ^ (m.val * a.val)) =
                  (∑ m ∈ (Finset.univ : Finset (Fin N)).filter
                    (fun m => d ∣ m.val), (1 : ℂ) * (rou N) ^ (m.val * a.val)) := by
                change (∑ m ∈ (Finset.univ : Finset (Fin N)),
                    (if d ∣ m.val then (1 : ℂ) else 0) * (rou N) ^ (m.val * a.val)) =
                    (∑ m ∈ (Finset.univ : Finset (Fin N)).filter
                      (fun m => d ∣ m.val), (1 : ℂ) * (rou N) ^ (m.val * a.val))
                have hite : (∑ m ∈ (Finset.univ : Finset (Fin N)),
                    (if d ∣ m.val then (1 : ℂ) else 0) * (rou N) ^ (m.val * a.val)) =
                    (∑ m ∈ (Finset.univ : Finset (Fin N)),
                      if d ∣ m.val then (1 : ℂ) * (rou N) ^ (m.val * a.val) else 0) := by
                  apply Finset.sum_congr rfl
                  intro m _
                  split_ifs <;> ring
                have hsumite : (∑ m ∈ (Finset.univ : Finset (Fin N)),
                    if d ∣ m.val then (1 : ℂ) * (rou N) ^ (m.val * a.val) else 0) =
                    (∑ m ∈ (Finset.univ : Finset (Fin N)).filter
                      (fun m => d ∣ m.val), (1 : ℂ) * (rou N) ^ (m.val * a.val)) +
                    (∑ m ∈ (Finset.univ : Finset (Fin N)).filter
                      (fun m => ¬d ∣ m.val), (0 : ℂ)) :=
                  Finset.sum_ite (fun (m : Fin N) => (1 : ℂ) * (rou N) ^ (m.val * a.val))
                    (fun _ => (0 : ℂ))
                rw [hite, hsumite]
                have hzero : (∑ m ∈ (Finset.univ : Finset (Fin N)).filter
                    (fun m => ¬d ∣ m.val), (0 : ℂ)) = 0 := by
                  apply Finset.sum_eq_zero
                  intro m _
                  simp
                rw [hzero, add_zero]
              rw [hst]
              let hi_map (m : Fin N) (hm : m ∈ (Finset.univ : Finset (Fin N)).filter
                  (fun m => d ∣ m.val)) : Fin (N / d) :=
                (Fin.mk (m.val / d)
                  (((Nat.div_lt_div_right (Nat.ne_of_gt hdp)
                      (Finset.mem_filter.mp hm).2 hdN) :
                     m.val / d < N / d ↔ m.val < N).mpr m.isLt))
              refine Finset.sum_bij hi_map
                (fun m _ => by simp)
                (fun m₁ hm₁ m₂ hm₂ h => by
                  have hv : m₁.val / d = m₂.val / d := by
                    dsimp only [hi_map] at h
                    refine (Fin.ext_iff).mp h
                  refine (Fin.ext_iff).mpr ?_
                  have hm₁d : d ∣ m₁.val := (Finset.mem_filter.mp hm₁).2
                  have hm₂d : d ∣ m₂.val := (Finset.mem_filter.mp hm₂).2
                  have h₁ : m₁.val = d * (m₁.val / d) := (Nat.mul_div_cancel' hm₁d).symm
                  have h₂ : m₂.val = d * (m₂.val / d) := (Nat.mul_div_cancel' hm₂d).symm
                  rw [h₁, h₂]
                  rw [← hv])
                (fun j _ => by
                  have hmN : d * j.val < N :=
                    Nat.lt_of_lt_of_le (Nat.mul_lt_mul_of_pos_left j.isLt hdp)
                      (le_of_eq hNps.symm)
                  have hdiv2 : (d * j.val) / d = j.val := by
                    have hd : d * ((d * j.val) / d) = d * j.val :=
                      Nat.mul_div_cancel' (Nat.dvd_mul_right d j.val)
                    exact Nat.eq_of_mul_eq_mul_left hdp hd
                  exact ⟨Fin.mk (d * j.val) hmN,
                    Finset.mem_filter.mpr ⟨Finset.mem_univ _, Nat.dvd_mul_right d j.val⟩,
                    by
                      dsimp only [hi_map]
                      refine (Fin.ext_iff).mpr ?_
                      simpa [Fin.val] using hdiv2⟩)
                (fun m hm => by
                  have hdM : d ∣ m.val := (Finset.mem_filter.mp hm).2
                  have hdmp : m.val = d * (m.val / d) :=
                    (Nat.mul_div_cancel' hdM).symm
                  have hi : (hi_map m hm : Fin (N / d)).val = m.val / d := by
                    dsimp
                  rw [show (m.val * a.val : ℕ) = (d * (hi_map m hm).val) * a.val from by
                    rw [hdmp, hi]]
                  show (1 : ℂ) * (rou N) ^ ((d * (hi_map m hm).val) * a.val) =
                       (rou N) ^ ((d * (hi_map m hm).val) * a.val)
                  ring)
            rw [hreindex]
            -- collapse  (rou N)^(d*j)  to  (rou (N/d))^j
            have hrouN : (rou N) ^ d = (rou (N / d) : ℂ) := by
              unfold rou
              rw [← Complex.exp_nat_mul]
              apply (congrArg Complex.exp)
              rw [show (d * (2 * Real.pi * I * (1 / (N : ℝ)))) =
                       (2 * Real.pi * I) * (d * (1 / (N : ℝ))) from by ring]
              apply (congrArg fun (x : ℂ) => (2 * Real.pi * I) * x)
              norm_cast
              have hNreal : (N : ℝ) = (d : ℝ) * (↑(N / d : ℕ) : ℝ) := by
                trans ((d * (N / d) : ℕ) : ℝ)
                · exact congrArg (fun x : ℕ => (x : ℝ)) hNps
                · exact Nat.cast_mul d (N / d)
              rw [hNreal]
              field_simp [show (d : ℝ) ≠ 0 by norm_cast; omega,
                show (↑(N / d : ℕ) : ℝ) ≠ 0 by norm_cast; omega,
                show (N : ℝ) ≠ 0 by norm_cast; omega]
            have hroupow : ∀ j : ℕ, (rou N) ^ (d * j) = (rou (N / d) : ℂ) ^ j := by
              intro j
              rw [pow_mul, hrouN]
            rw [show (∑ j : Fin (N / d), (rou N) ^ ((d * j.val) * a.val)) =
                    (∑ j : Fin (N / d), (rou (N / d) : ℂ) ^ (j.val * a.val))
                from by
                  apply Finset.sum_congr rfl
                  intro j _
                  calc (rou N) ^ ((d * j.val) * a.val)
                      = ((rou N) ^ (d * j.val)) ^ a.val := by rw [pow_mul]
                    _ = ((rou (N / d) : ℂ) ^ j.val) ^ a.val :=
                        congrArg (fun x : ℂ => x ^ a.val) (hroupow j.val)
                    _ = (rou (N / d) : ℂ) ^ (j.val * a.val) := by rw [← pow_mul]]
            -- the unit chime at level  N/d
            have hchime : (∑ j : Fin (N / d), (rou (N / d) : ℂ) ^ (j.val * a.val)) =
                if N / d ∣ a.val then (↑(N / d : ℕ) : ℂ) else 0 := by
              by_cases hM1 : N / d = 1
              · rw [hM1]
                have hss : (∑ j : Fin 1, (rou 1 : ℂ) ^ (j.val * a.val)) =
                    (rou 1 : ℂ) ^ (0 * a.val) :=
                  Finset.sum_eq_single (Fin.mk 0 (by norm_num : 0 < 1))
                    (fun k _ hne => by
                      have hkz : k.val = 0 := by omega
                      have hk0 : k = Fin.mk 0 (by norm_num : 0 < 1) := (Fin.ext_iff).mpr hkz
                      exact False.elim (hne hk0))
                    (fun hn => False.elim (hn (Finset.mem_univ _)))
                rw [hss]
                simp [zero_mul, pow_zero, Nat.one_dvd]
              ·
                exact rou_sum_orthogonality (N := N / d) (hN := hM) (k := a.val)
            rw [hchime]
            split_ifs <;> ring
set_option maxHeartbeats 200000





-- (B1) RAMANUJAN MULTIPLICIVITY  (KCS U2 Wave-2 B1)
-- --------------------------------------------------
-- The μ-sum closed form of the Ramanujan sum (see
-- raman_inclusion_exclusion) is multiplicative in the level
-- for coprime levels:  c_{mn}(K) = c_m(K)·c_n(K), K arbitrary.
-- Mechanism:  the divisor bijection d ↦ (d.gcd m, d/(d.gcd m))
-- (mathlib:  Nat.Coprime.mul_injOn_divisors / Nat.divisors_mul)
-- + μ-multiplicativity + the coprime divisibility split.

open scoped Pointwise

set_option maxHeartbeats 400000

/-- Ramanujan-sum multiplicativity (μ-sum form):  with (m,n) = 1,
the μ-sum closed form satisfies
`∑_{d | m·n} [(m·n)/d ∣ K] · (m·n)/d · μ(d)
 = (∑_{d | m} [m/d ∣ K] · (m/d) · μ(d)) · (∑_{d | n} [n/d ∣ K] · (n/d) · μ(d))`
for every K (only K mod m·n matters).  The measured U2 fact, now
machine-checked. -/
theorem raman_multiplicativity {m n K : ℕ} (hm : 0 < m) (hn : 0 < n)
    (hcop : m.Coprime n) :
    (∑ d ∈ (m * n).divisors,
       if (m * n) / d ∣ K then ((m * n / d : ℕ) : ℂ) * (ArithmeticFunction.moebius d : ℂ) else 0) =
    (∑ d ∈ m.divisors,
       if m / d ∣ K then ((m / d : ℕ) : ℂ) * (ArithmeticFunction.moebius d : ℂ) else 0) *
    (∑ d ∈ n.divisors,
       if n / d ∣ K then ((n / d : ℕ) : ℂ) * (ArithmeticFunction.moebius d : ℂ) else 0) := by
  -- pointwise identity:  F (p1·p2) = A p1 · B p2
  have hprod (p1 : ℕ) (hp1 : p1 ∈ m.divisors) (p2 : ℕ) (hp2 : p2 ∈ n.divisors) :
      (if (m * n) / (p1 * p2) ∣ K then ((m * n / (p1 * p2) : ℕ) : ℂ) * (ArithmeticFunction.moebius (p1 * p2) : ℂ) else 0) =
      (if m / p1 ∣ K then ((m / p1 : ℕ) : ℂ) * (ArithmeticFunction.moebius p1 : ℂ) else 0) *
      (if n / p2 ∣ K then ((n / p2 : ℕ) : ℂ) * (ArithmeticFunction.moebius p2 : ℂ) else 0) := by
    obtain ⟨hdm, _⟩ := Nat.mem_divisors.mp hp1
    obtain ⟨hdn, _⟩ := Nat.mem_divisors.mp hp2
    have hmp : m = p1 * (m / p1) := (Nat.mul_div_cancel' hdm).symm
    have hnp : n = p2 * (n / p2) := (Nat.mul_div_cancel' hdn).symm
    -- (m,n) = 1 as a gcd-equation
    have hmn1 : m.gcd n = 1 := by
      change m.Coprime n
      exact hcop
    -- (m·n)/(p1·p2) = (m/p1)·(n/p2)
    have hdiv : (m * n) / (p1 * p2) = (m / p1) * (n / p2) := by
      have hp1p : 0 < p1 := Nat.pos_of_dvd_of_pos hdm (show 0 < m by omega)
      have hp2p : 0 < p2 := Nat.pos_of_dvd_of_pos hdn (show 0 < n by omega)
      have hq : (m / p1) * (n / p2) * (p1 * p2) = m * n := by
        calc (m / p1) * (n / p2) * (p1 * p2)
            = p1 * (m / p1) * (p2 * (n / p2)) := by ring
          _ = m * n := by rw [← hmp, ← hnp]
      exact (Nat.div_eq_of_eq_mul_left (Nat.mul_pos hp1p hp2p) hq.symm)
    -- (p1, p2) = 1  (p1 | m, p2 | n, (m, n) = 1)
    have hcop12 : p1.gcd p2 = 1 := by
      have hpc : p1.gcd p2 ∣ 1 := by
        rw [← hmn1, Nat.dvd_gcd_iff]
        exact ⟨dvd_trans (Nat.gcd_dvd_left _ _) hdm,
               dvd_trans (Nat.gcd_dvd_right _ _) hdn⟩
      exact Nat.dvd_one.mp hpc
    -- μ(p1·p2) = μ(p1)·μ(p2),  cast to ℂ
    have hμ : (ArithmeticFunction.moebius (p1 * p2) : ℂ) =
        (ArithmeticFunction.moebius p1 : ℂ) * (ArithmeticFunction.moebius p2 : ℂ) := by
      have hμi := ArithmeticFunction.isMultiplicative_moebius.map_mul_of_coprime hcop12
      rw [hμi, Int.cast_mul]
    -- (m/p1) | m   (via m = p1 * (m/p1), without rewriting under the division)
    have hxm : (m / p1) ∣ m :=
      (show (m / p1) ∣ p1 * (m / p1) from Nat.dvd_mul_left _ _).trans (dvd_of_eq hmp.symm)
    -- (n/p2) | n
    have hyn : (n / p2) ∣ n :=
      (show (n / p2) ∣ p2 * (n / p2) from Nat.dvd_mul_left _ _).trans (dvd_of_eq hnp.symm)
    -- the coprime divisibility split
    have hxy : (m / p1) * (n / p2) ∣ K ↔ (m / p1) ∣ K ∧ (n / p2) ∣ K := by
      constructor
      · intro h
        exact ⟨dvd_trans (dvd_mul_right _ _) h, dvd_trans (dvd_mul_left _ _) h⟩
      · rintro ⟨h1, h2⟩
        obtain ⟨t, ht⟩ := h1
        rw [ht] at h2
        have hcop21 : (n / p2).Coprime (m / p1) := by
          have hpc : (n / p2).gcd (m / p1) ∣ 1 := by
            rw [← hmn1, Nat.dvd_gcd_iff]
            exact ⟨dvd_trans (Nat.gcd_dvd_right _ _) hxm,
                   dvd_trans (Nat.gcd_dvd_left _ _) hyn⟩
          exact Nat.dvd_one.mp hpc
        obtain ⟨s, hs⟩ := (hcop21.dvd_mul_left).mp h2
        exact ⟨s, by rw [ht, hs]; ring⟩
    rw [show (m * n) / (p1 * p2) = (m / p1) * (n / p2) from hdiv]
    rw [Nat.cast_mul]
    rw [hμ]
    by_cases hxK : (m / p1) * (n / p2) ∣ K
    · have hh := hxy.mp hxK
      simp [hxK, hh.1, hh.2]
      ring
    · by_cases hhx : (m / p1) ∣ K
      · have hny : ¬(n / p2) ∣ K := by
          intro hn2
          exact hxK (hxy.mpr ⟨hhx, hn2⟩)
        simp [hxK, hhx, hny]
      · by_cases hnn : (n / p2) ∣ K
        · simp [hxK, hhx, hnn]
        · simp [hxK, hhx, hnn]
  calc
    (∑ d ∈ (m * n).divisors,
      if (m * n) / d ∣ K then ((m * n / d : ℕ) : ℂ) * (ArithmeticFunction.moebius d : ℂ) else 0)
    _ = ∑ d ∈ m.divisors * n.divisors,
      if (m * n) / d ∣ K then ((m * n / d : ℕ) : ℂ) * (ArithmeticFunction.moebius d : ℂ) else 0 := by
      rw [Nat.divisors_mul]
    _ = ∑ p ∈ m.divisors ×ˢ n.divisors,
      if (m * n) / (p.1 * p.2) ∣ K then ((m * n / (p.1 * p.2) : ℕ) : ℂ) *
          (ArithmeticFunction.moebius (p.1 * p.2) : ℂ) else 0 := by
      rw [Finset.mul_def]
      exact Finset.sum_image (hcop.mul_injOn_divisors)
    _ = ∑ p1 ∈ m.divisors, ∑ p2 ∈ n.divisors,
      if (m * n) / (p1 * p2) ∣ K then ((m * n / (p1 * p2) : ℕ) : ℂ) *
          (ArithmeticFunction.moebius (p1 * p2) : ℂ) else 0 := by
      rw [Finset.sum_product]
    _ = ∑ p1 ∈ m.divisors, ∑ p2 ∈ n.divisors,
      (if m / p1 ∣ K then ((m / p1 : ℕ) : ℂ) * (ArithmeticFunction.moebius p1 : ℂ) else 0) *
        (if n / p2 ∣ K then ((n / p2 : ℕ) : ℂ) * (ArithmeticFunction.moebius p2 : ℂ) else 0) := by
      refine Finset.sum_congr rfl (fun p1 hp1 => ?_)
      exact Finset.sum_congr rfl (fun p2 hp2 => hprod p1 hp1 p2 hp2)
    _ = (∑ d ∈ m.divisors,
      if m / d ∣ K then ((m / d : ℕ) : ℂ) * (ArithmeticFunction.moebius d : ℂ) else 0) *
        (∑ d ∈ n.divisors,
      if n / d ∣ K then ((n / d : ℕ) : ℂ) * (ArithmeticFunction.moebius d : ℂ) else 0) := by
      rw [← Finset.sum_mul_sum]

set_option maxHeartbeats 200000
























-- (B2) FULL-SUPPORT RAMANUJAN FIELD  (KCS U2 Wave-2 B2)
-- ------------------------------------------------------
-- For squarefree level N, the Ramanujan sum never vanishes:
-- c_N(a) ≠ 0 for every a.  (Measured 0172: the full-sieve symbol on
-- a squarefree level is a full-support field; the product closed
-- form c_N(a) = ∏_{p|N} (p−1 if p|a, −1 otherwise) never hits 0.)
-- Proof: multiplicative induction on N via B1 + the prime closed
-- form, + μ(1) = 1 as the base.

set_option maxHeartbeats 400000

/-- Full support:  with N squarefree, the Ramanujan sum is nonzero
for every character a. -/
theorem raman_full_support {N : ℕ} (hN : 1 < N) (hqs : Squarefree N) (a : Fin N) :
    raman N (Nat.le_of_lt hN) a ≠ 0 := by
  have hz0 : 0 < N := Nat.le_of_lt hN
  set μsum := fun (M K : ℕ) =>
      (∑ d ∈ M.divisors,
      if (M / d) ∣ K then ((M / d : ℕ) : ℂ) * (ArithmeticFunction.moebius d : ℂ) else 0)
  -- the base:  μsum 1 K = 1
  have hsum1 (K : ℕ) : μsum 1 K ≠ 0 := by
    dsimp only [μsum]
    have hdiv1 : (1 : ℕ).divisors = {1} := by
      ext d
      simp [Nat.mem_divisors, Nat.dvd_one]
    rw [hdiv1, Finset.sum_singleton]
    simp [ArithmeticFunction.moebius_apply_one, Nat.one_dvd]
  -- the prime closed form:  μsum p K = (p−1) if p ∣ K,  −1 otherwise
  have hprimesum (p : ℕ) (hp : p.Prime) (K : ℕ) :
      μsum p K = if p ∣ K then (p - 1 : ℂ) else -1 := by
    dsimp only [μsum]
    have hp2 : 1 < p := hp.one_lt
    have hdivp : p.divisors = {1, p} := by
      apply Finset.ext
      intro d
      rw [Nat.mem_divisors, Finset.mem_insert, Finset.mem_singleton]
      constructor
      · rintro ⟨hd, -⟩
        rcases (Nat.dvd_prime hp).mp hd with (h1 | h1)
        · simp [h1]
        · simp [h1]
      · rintro (h1 | h1)
        · simp [h1, show (p : ℕ) ≠ 0 from by omega]
        · simp [h1, show (p : ℕ) ≠ 0 from by omega]
    rw [hdivp, Finset.sum_pair (a := 1) (b := p) (Nat.ne_of_lt hp.one_lt)]
    simp [show (p : ℕ) / 1 = p from by simp,
      show (p : ℕ) / p = 1 from Nat.div_self hp.pos,
      ArithmeticFunction.moebius_apply_one,
      ArithmeticFunction.moebius_apply_prime hp, Nat.one_dvd]
    by_cases hK : p ∣ K
    · simp [hK]
      rw [show ((↑(p : ℕ) : ℂ) + (-1 : ℂ)) = (↑(p : ℕ) : ℂ) - 1 from by ring]
    · simp [hK]
  -- the multiplication induction
  have hmain : ∀ M, 0 < M → Squarefree M → ∀ K, μsum M K ≠ 0 := by
    intro M
    apply Nat.strong_induction_on
      (p := fun N => 0 < N → Squarefree N → ∀ K, μsum N K ≠ 0)
      (n := M)
    intro n ihM
    let M := n
    intro hM hqsM K
    by_cases hM1 : M = 1
    · subst hM1
      exact hsum1 K
    · have hM2 : 1 < M := by omega
      obtain ⟨p, hp, hpM⟩ := Nat.ne_one_iff_exists_prime_dvd.mp hM1
      let k := M / p
      have hMk : M = p * k := (Nat.mul_div_cancel' hpM).symm
      have hkm : k < M := by
        show (M / p) < M
        exact Nat.div_lt_self hM hp.one_lt
      have hkM : k ∣ M := by
        rw [hMk]
        exact Nat.dvd_mul_left _ _
      have hkpos : 0 < k := Nat.pos_of_dvd_of_pos hkM hM
      -- p ∤ k  and  k squarefree  (both from M squarefree)
      have hnpk : ¬p ∣ k := by
        intro hpk
        obtain ⟨t, ht⟩ := hpk
        have hp2 : p * p ∣ M := by
          rw [hMk, ht]
          use t
          ring
        exact (Nat.squarefree_iff_prime_squarefree.mp hqsM) p hp hp2
      have hcop : p.Coprime k := (Nat.Prime.coprime_iff_not_dvd hp).mpr hnpk
      have hqsk : Squarefree k := by
        rw [Nat.squarefree_iff_prime_squarefree]
        intro q hq hqk
        have hqM : q * q ∣ M := by
          rw [hMk]
          obtain ⟨t, ht⟩ := hqk
          use p * t
          rw [ht]
          ring
        exact (Nat.squarefree_iff_prime_squarefree.mp hqsM) q hq hqM
      -- multiplicativity (B1) + nonzero factors
      have hsumM : μsum M K = μsum (p * k) K := by
        dsimp only [μsum]
        rw [hMk]
      have heq : μsum (p * k) K = μsum p K * μsum k K :=
        raman_multiplicativity (m := p) (n := k) (K := K) hp.pos hkpos hcop
      rw [hsumM, heq]
      have hpnz : μsum p K ≠ 0 := by
        have hp2 : 1 < p := hp.one_lt
        rw [hprimesum p hp K]
        by_cases hK : p ∣ K
        · have hpnat : p - 1 ≠ 0 := by
            intro hz0
            exact Nat.not_lt_of_le (Nat.sub_eq_zero_iff_le.mp hz0) hp2
          rw [if_pos hK]
          have hbridge : ((p - 1 : ℕ) : ℂ) = (↑p : ℂ) - 1 := by
            rw [Nat.cast_sub hp2.le]
            norm_num
          rw [← hbridge]
          exact Nat.cast_ne_zero.mpr hpnat
        · rw [if_neg hK]
          norm_num
      by_cases hk1 : k = 1
      · exact mul_ne_zero hpnz (by simpa [hk1] using hsum1 K)
      · have hk2 : 1 < k := Nat.lt_of_le_of_ne (Nat.succ_le_of_lt hkpos) (Ne.symm hk1)
        exact mul_ne_zero hpnz (ihM k hkm hkpos hqsk K)
  have hnz : μsum N a.val ≠ 0 := hmain N hz0 hqs a.val
  simpa [μsum, ← raman_inclusion_exclusion hN a] using hnz

set_option maxHeartbeats 200000

-- (C) Wave-2 C: level census + parseval units.
-- Level census: the fiber of a -> N / gcd(a, N) over k (k | N) has
-- exactly phi(k) points: bijection with {u < k : (u, k) = 1} via
-- a = (N/k) * u.

theorem level_census (N k : ℕ) (hN : 1 < N) (hk : k ∣ N) :
    (Finset.filter (fun a : Fin N => N / Nat.gcd a.val N = k) Finset.univ).card =
      Nat.totient k := by
  let g0 := N / k
  have hN0 : 0 < N := by omega
  have hkg : 0 < k := Nat.pos_of_dvd_of_pos hk hN0
  have hNm : N = k * g0 := by
    unfold g0
    exact (Nat.mul_div_cancel' hk).symm
  have hg0 : 0 < g0 := by
    unfold g0
    exact Nat.div_pos (Nat.le_of_dvd hN0 hk) hkg
  let sset : Finset (Fin N) :=
    Finset.filter (fun a => N / Nat.gcd a.val N = k) Finset.univ
  let tset : Finset ℕ :=
    Finset.filter (fun u => Nat.Coprime k u) (Finset.range k)
  -- gcd(a, N) = N / k for every a in the fiber
  have hg0eq (a : Fin N) (ha : a ∈ sset) : Nat.gcd a.val N = g0 := by
    let g := Nat.gcd a.val N
    let hklev := (Finset.mem_filter.mp ha).2
    have hmdc : g * (N / g) = N :=
      Nat.mul_div_cancel' (Nat.gcd_dvd_right a.val N)
    rw [hklev] at hmdc
    have hNm4 : N = k * g := by rw [← hmdc, Nat.mul_comm]
    have heqk : k * g = k * g0 := by rw [← hNm4, hNm]
    exact Nat.mul_left_cancel hkg heqk
  have hbij : sset.card = tset.card :=
    Finset.card_bij
      (fun a (_ha : a ∈ sset) => a.val / g0)
      (fun a ha =>
        let hklev := (Finset.mem_filter.mp ha).2
        have hl : a.val / g0 < k := by
          apply Nat.div_lt_of_lt_mul
          simpa [hNm, Nat.mul_comm] using (a.isLt)
        have hg0dva : g0 ∣ a.val := by
          have hgd : Nat.gcd a.val N ∣ a.val := Nat.gcd_dvd_left a.val N
          rwa [hg0eq a ha] at hgd
        let u := a.val / g0
        have hgu : Nat.gcd (a.val / g0) k = 1 := by
          have hu : a.val = g0 * u := (Nat.mul_div_cancel' hg0dva).symm
          have hbase := hg0eq a ha
          rw [hu] at hbase
          have hbase2 : Nat.gcd (g0 * u) N = g0 := hbase
          have htmp : (g0 * u).gcd N = (g0 * u).gcd (k * g0) :=
            congrArg (Nat.gcd (g0 * u)) hNm
          have hbase3 : (g0 * u).gcd (k * g0) = g0 := by
            rw [← htmp]
            exact hbase2
          rw [show (k * g0 : ℕ) = g0 * k from by ring] at hbase3
          rw [Nat.gcd_mul_left g0 u k] at hbase3
          refine Nat.mul_left_cancel hg0 ?_
          simpa [Nat.mul_one] using hbase3
        have hgu2 : Nat.Coprime k (a.val / g0) := by
          simpa [Nat.gcd_comm] using hgu
        Finset.mem_filter.mpr ⟨Finset.mem_range.mpr hl, hgu2⟩)
      (fun a₁ ha₁ a₂ ha₂ heq => by
        have hgd01 : g0 ∣ a₁.val := by
          have hgd : Nat.gcd a₁.val N ∣ a₁.val := Nat.gcd_dvd_left a₁.val N
          rwa [hg0eq a₁ ha₁] at hgd
        have hgd02 : g0 ∣ a₂.val := by
          have hgd : Nat.gcd a₂.val N ∣ a₂.val := Nat.gcd_dvd_left a₂.val N
          rwa [hg0eq a₂ ha₂] at hgd
        have h1 : a₁.val = g0 * (a₁.val / g0) := (Nat.mul_div_cancel' hgd01).symm
        have h2 : a₂.val = g0 * (a₂.val / g0) := (Nat.mul_div_cancel' hgd02).symm
        have hval : a₁.val = a₂.val := by
          calc a₁.val
            _ = g0 * (a₁.val / g0) := h1
            _ = g0 * (a₂.val / g0) := by rw [heq]
            _ = a₂.val := h2.symm
        exact Fin.ext hval)
      (fun b hb =>
        let hmem := Finset.mem_filter.mp hb
        let a : Fin N :=
          ⟨g0 * b, by
            simpa [hNm, Nat.mul_comm] using
              (Nat.mul_lt_mul_of_pos_left (Finset.mem_range.mp hmem.1) hg0)⟩
        have hgd : Nat.gcd (g0 * b) N = g0 := by
          rw [hNm, show (k * g0 : ℕ) = g0 * k from by ring,
            Nat.gcd_mul_left g0 b k,
            show (b : ℕ).gcd k = 1 from by simpa [Nat.gcd_comm] using hmem.2,
            mul_one]
        have ha : a ∈ sset :=
          Finset.mem_filter.mpr ⟨Finset.mem_univ _, by
            rw [hgd]
            exact Nat.div_eq_of_eq_mul_left hg0 hNm⟩
        ⟨a, ha,
          Nat.mul_left_cancel hg0 (Nat.mul_div_cancel' (Nat.dvd_mul_right g0 b))⟩)
  dsimp only [Nat.totient]
  exact hbij

-- (D) Wave-2 D: Parseval for the DFT.
--   sum_a normSq (dft N f a) = N * sum_m normSq (f m)
-- The kernel is rou_sum_orthogonality plus the fact that the inverse of a
-- root of unity is a positive power (omega^{-k} = omega^{k(N-1)}).
-- Note: in the pinned mathlib `Complex.abs` no longer exists (deprecated in
-- PR #21995, removed later); the norm `‖·‖` is the modern object, with
-- Complex.norm_pow / Complex.normSq_eq_norm_sq / Complex.norm_exp.

theorem parseval_units {N : ℕ} (hN : 1 < N) (f : Fin N → ℂ) :
    (∑ a : Fin N, Complex.normSq (dft N (Nat.le_of_lt hN) f a)) =
      (N : ℝ) * (∑ m : Fin N, Complex.normSq (f m)) := by
  let ω := rou N
  have hprim : IsPrimitiveRoot ω N := primitive_rou N hN
  have hωN1 : ω ^ N = 1 := hprim.pow_eq_one
  let αexp := (2 * Real.pi * I * (1 / (N : ℝ)) : ℂ)
  have hωe : ω = exp αexp := by
    unfold ω
    dsimp only [rou]
    try rfl
  have hω0 : ω ≠ 0 := by simpa [hωe] using Complex.exp_ne_zero αexp
  -- the exponent is pure imaginary
  have hαr : αexp.re = 0 := by
    unfold αexp
    simp [Complex.mul_re, Complex.mul_im, Complex.ofReal_re,
      Complex.ofReal_im, Complex.I_re, Complex.I_im]
    try ring
  -- |omega| = 1 and |omega^k| = 1
  have habsω : ‖(ω : ℂ)‖ = 1 := by
    rw [hωe, Complex.norm_exp, hαr]
    exact Real.exp_zero
  have hnorm1 (k : ℕ) : ‖(ω : ℂ) ^ k‖ = 1 := by
    rw [hωe, ← Complex.exp_nat_mul αexp k, Complex.norm_exp]
    have hkr : (((k : ℂ) * αexp).re : ℝ) = 0 := by
      simp [Complex.mul_re, hαr]
      try ring
    rw [hkr, Real.exp_zero]
  -- inverse of a root of unity is a positive power
  have hinv (k : ℕ) : (ω ^ k : ℂ)⁻¹ = ω ^ (k * (N - 1)) := by
    have hmulone : (ω ^ k) * ω ^ (k * (N - 1)) = 1 := by
      calc (ω ^ k) * ω ^ (k * (N - 1))
        _ = ω ^ (k + k * (N - 1)) := (pow_add ω k (k * (N - 1))).symm
        _ = ω ^ (k * N) := by
          rw [show (k + k * (N - 1) : ℕ) = k * ((N - 1 : ℕ) + 1) from by ring,
            show (k * ((N - 1 : ℕ) + 1) : ℕ) = k * N from by
              rw [Nat.sub_add_cancel (Nat.le_of_lt hN)]]
        _ = ω ^ (N * k) := by rw [show (k * N : ℕ) = N * k from by ring]
        _ = (ω ^ N) ^ k := by rw [pow_mul]
        _ = 1 ^ k := by rw [hωN1]
        _ = 1 := one_pow k
    have hnonz : (ω : ℂ) ^ k ≠ 0 := pow_ne_zero k hω0
    calc (ω ^ k : ℂ)⁻¹
      _ = (ω ^ k : ℂ)⁻¹ * 1 := (mul_one _).symm
      _ = (ω ^ k : ℂ)⁻¹ * ((ω ^ k) * ω ^ (k * (N - 1))) := by rw [hmulone]
      _ = ((ω ^ k : ℂ)⁻¹ * (ω ^ k)) * ω ^ (k * (N - 1)) := by rw [mul_assoc]
      _ = 1 * ω ^ (k * (N - 1)) := by rw [inv_mul_cancel₀ hnonz]
      _ = ω ^ (k * (N - 1)) := one_mul _
  -- star of a root of unity is its inverse (|omega^k| = 1)
  have hstarinv (k : ℕ) : star (ω ^ k) = (ω ^ k : ℂ)⁻¹ := by
    have hnorm1 : ‖(ω : ℂ) ^ k‖ = 1 := hnorm1 k
    have hzre (z : ℂ) : (star z).re = z.re := by
      simp [Complex.conj_re]
    have hzim (z : ℂ) : (star z).im = -z.im := by
      simp [Complex.conj_im]
    have hgen (z : ℂ) : z * star z = (‖z‖ ^ 2 : ℂ) := by
      apply (Complex.ext_iff).mpr
      constructor
      · have h1 : (z * star z).re = z.re * z.re + z.im * z.im := by
          rw [Complex.mul_re, hzre, hzim]
          ring
        have h2 : ((‖z‖ ^ 2 : ℂ)).re = (‖z‖ : ℝ) ^ 2 := by
          rw [pow_two, Complex.mul_re, Complex.ofReal_re, Complex.ofReal_im]
          ring
        rw [h1, h2, Complex.sq_norm z]
        exact (Complex.normSq_apply z).symm
      · have h1 : (z * star z).im = 0 := by
          rw [Complex.mul_im, hzre, hzim]
          ring
        have h2 : ((‖z‖ ^ 2 : ℂ)).im = 0 := by
          rw [pow_two, Complex.mul_im, Complex.ofReal_re, Complex.ofReal_im]
          ring
        rw [h1, h2]
    have hzz : (ω ^ k) * star (ω ^ k) = (‖(ω : ℂ) ^ k‖ ^ 2 : ℂ) :=
      hgen (ω ^ k)
    have hz : (ω ^ k) * star (ω ^ k) = 1 := by
      rw [hzz, hnorm1]
      norm_num
    have hnonz : (ω : ℂ) ^ k ≠ 0 := pow_ne_zero k hω0
    calc star (ω ^ k)
      _ = ((ω ^ k : ℂ)⁻¹ * (ω ^ k)) * star (ω ^ k) := by
        conv_lhs =>
          rw [← one_mul (star (ω ^ k)), ← inv_mul_cancel₀ hnonz]
      _ = (ω ^ k : ℂ)⁻¹ * ((ω ^ k) * star (ω ^ k)) := by rw [mul_assoc]
      _ = (ω ^ k : ℂ)⁻¹ * 1 := by rw [hz]
      _ = (ω ^ k : ℂ)⁻¹ := mul_one _
  -- kernel: sum_a omega^{m a} (omega^{n a})^{-1} = if m = n then N else 0
  have hkernel (m n : Fin N) :
      (∑ a : Fin N, ω ^ (m.val * a.val) * ((ω ^ (n.val * a.val)) : ℂ)⁻¹) =
        if m = n then (N : ℂ) else 0 := by
    let kK := m.val + n.val * (N - 1)
    have hS : (∑ a : Fin N, ω ^ (m.val * a.val) * ((ω ^ (n.val * a.val)) : ℂ)⁻¹) =
        (∑ a : Fin N, ω ^ (kK * a.val)) := by
      apply Finset.sum_congr rfl
      intro a _
      rw [hinv (n.val * a.val)]
      rw [(pow_add ω (m.val * a.val) (n.val * a.val * (N - 1))).symm]
      have hexp : (m.val * a.val + n.val * a.val * (N - 1) : ℕ) =
          (kK * a.val : ℕ) := by
        dsimp only [kK]
        ring
      rw [hexp]
    rw [hS]
    have hthm : (∑ a : Fin N, ω ^ (a.val * kK)) =
        (if (N : ℕ) ∣ kK then (N : ℂ) else 0) := by
      have hthm0 : (∑ a : Fin N, (rou N : ℂ) ^ (a.val * kK)) =
          (if (N : ℕ) ∣ kK then (N : ℂ) else 0) :=
        rou_sum_orthogonality (N := N) (k := kK) hN
      have hsumω : (∑ a : Fin N, (rou N : ℂ) ^ (a.val * kK)) =
          (∑ a : Fin N, ω ^ (a.val * kK)) := by
        apply Finset.sum_congr rfl
        intro a _
        unfold ω
        rfl
      rw [hsumω] at hthm0
      exact hthm0
    have hsumeq : (∑ a : Fin N, ω ^ (kK * a.val)) =
        (∑ a : Fin N, ω ^ (a.val * kK)) := by
      apply Finset.sum_congr rfl
      intro a _
      rw [show (kK * a.val : ℕ) = a.val * kK from by ring]
    rw [hsumeq, hthm]
    by_cases hm : m = n
    · have hd : (N : ℕ) ∣ kK := by
        dsimp only [kK] at *
        rw [hm]
        have hprod : (n.val + n.val * (N - 1) : ℕ) = (n.val * N : ℕ) := by
          rw [show (n.val + n.val * (N - 1) : ℕ) =
            n.val * ((N - 1 : ℕ) + 1) from by ring,
            Nat.sub_add_cancel (Nat.le_of_lt hN)]
        rw [hprod]
        exact Nat.dvd_mul_left N n.val
      rw [if_pos hd]
      rw [if_pos hm]
    · have hnd : ¬(N : ℕ) ∣ kK := by
        dsimp only [kK] at *
        intro h
        obtain ⟨q, hq⟩ := h
        have hqz : ((m.val : ℤ) + (n.val : ℤ) * ((N : ℤ) - 1)) =
            (N : ℤ) * (q : ℤ) := by
          have hq1 : ((m.val + n.val * (N - 1) : ℕ) : ℤ) =
              ((N * q : ℕ) : ℤ) := by exact_mod_cast hq
          have hsplit : ((m.val + n.val * (N - 1) : ℕ) : ℤ) =
              (m.val : ℤ) + (n.val : ℤ) * ((N - 1 : ℕ) : ℤ) := by
            rw [Nat.cast_add (m.val : ℕ) (n.val * (N - 1)),
                Nat.cast_mul (n.val : ℕ) (N - 1)]
          rw [hsplit, Nat.cast_sub (Nat.le_of_lt hN)] at hq1
          rw [Nat.cast_mul (N : ℕ) (q : ℕ)] at hq1
          exact hq1
        have hmod0 : ((m.val : ℤ) + (n.val : ℤ) * ((N : ℤ) - 1)) %
            (N : ℤ) = 0 := by
          rw [hqz]
          rw [Int.mul_emod (N : ℤ) (q : ℤ) (N : ℤ),
              Int.emod_self (a := (N : ℤ)), zero_mul,
              Int.zero_emod (N : ℤ)]
        have hNterm : ((m.val : ℤ) + (n.val : ℤ) * ((N : ℤ) - 1)) =
            ((m.val : ℤ) - (n.val : ℤ)) + ((n.val : ℤ) * (N : ℤ)) := by
          ring
        have hmodN : ((m.val : ℤ) + (n.val : ℤ) * ((N : ℤ) - 1)) %
            (N : ℤ) = ((m.val : ℤ) - (n.val : ℤ)) % (N : ℤ) := by
          rw [hNterm]
          have hNk : ((n.val : ℤ) * (N : ℤ)) % (N : ℤ) = 0 := by
            rw [Int.mul_emod (n.val : ℤ) (N : ℤ) (N : ℤ),
              Int.emod_self (a := (N : ℤ)), mul_zero,
              Int.zero_emod (N : ℤ)]
          rw [Int.add_emod ((m.val : ℤ) - (n.val : ℤ))
            ((n.val : ℤ) * (N : ℤ)) (N : ℤ), hNk, add_zero,
            Int.emod_emod ((m.val : ℤ) - (n.val : ℤ)) (N : ℤ)]
        have hres : ((m.val : ℤ) - (n.val : ℤ)) % (N : ℤ) = 0 := by
          rw [← hmodN, hmod0]
        obtain ⟨t, ht⟩ := (Int.dvd_iff_emod_eq_zero).mpr hres
        have hsmall : Int.natAbs ((m.val : ℤ) - (n.val : ℤ)) < (N : ℕ) := by
          by_cases hmn : (m.val : ℕ) ≥ (n.val : ℕ)
          · rw [Int.natAbs_natCast_sub_natCast_of_ge hmn]
            apply Nat.lt_of_le_of_lt (Nat.sub_le (m.val) (n.val))
            exact m.isLt
          · have hlt : (m.val : ℕ) < (n.val : ℕ) := by
              omega
            have hneg : ((m.val : ℤ) - (n.val : ℤ)) =
                -((n.val : ℤ) - (m.val : ℤ)) := by ring
            rw [hneg, Int.natAbs_neg,
                Int.natAbs_natCast_sub_natCast_of_ge (Nat.le_of_lt hlt)]
            apply Nat.lt_of_le_of_lt (Nat.sub_le (n.val) (m.val))
            exact n.isLt
        have hge : (N : ℕ) ≤ Int.natAbs ((m.val : ℤ) - (n.val : ℤ)) := by
          by_cases htnz : (t : ℤ) = 0
          · rw [htnz, mul_zero] at ht
            have heqmn : (m.val : ℤ) = (n.val : ℤ) := sub_eq_zero.mp ht
            have hmn : m = n := Fin.eq_of_val_eq (Nat.cast_inj.mp heqmn)
            contradiction
          · have habsd : Int.natAbs ((m.val : ℤ) - (n.val : ℤ)) =
              (N : ℕ) * Int.natAbs (t : ℤ) := by
              rw [ht, Int.natAbs_mul]
              have hNN : Int.natAbs (N : ℤ) = (N : ℕ) :=
                Nat.cast_inj.mp (Int.natAbs_of_nonneg (by
                  norm_cast
                  exact Nat.zero_le N))
              rw [hNN]
            have ht1 : 1 ≤ Int.natAbs (t : ℤ) :=
              Nat.succ_le_of_lt (Int.natAbs_pos.mpr htnz)
            calc (N : ℕ)
              _ = N * 1 := by ring
              _ ≤ N * Int.natAbs (t : ℤ) := Nat.mul_le_mul_left N ht1
              _ = Int.natAbs ((m.val : ℤ) - (n.val : ℤ)) := habsd.symm
        exact Nat.lt_irrefl N (Nat.lt_of_le_of_lt hge hsmall)
      rw [if_neg hnd]
      rw [if_neg hm]
  -- dft as a sum in powers of (omega^m)
  have hD (a : Fin N) :
      dft N (Nat.le_of_lt hN) f a = ∑ m : Fin N, f m * (ω ^ m.val) ^ a.val := by
    dsimp only [dft, char_pow]
    unfold ω
    apply Finset.sum_congr rfl
    intro m _
    rw [← pow_mul]
  have hst (a : Fin N) :
      star (∑ m : Fin N, f m * (ω ^ m.val) ^ a.val) =
        ∑ m : Fin N, star (f m) * (star (ω ^ m.val)) ^ a.val := by
    rw [star_sum]
    apply Finset.sum_congr rfl
    intro m _
    rw [star_mul, star_pow, mul_comm]
  -- stage 1: dft * star (dft)
  have hS1 : (∑ a : Fin N, (dft N (Nat.le_of_lt hN) f a) *
      star (dft N (Nat.le_of_lt hN) f a)) =
      (∑ a : Fin N, (∑ m : Fin N, f m * (ω ^ m.val) ^ a.val) *
        (∑ n : Fin N, star (f n) * (star (ω ^ n.val)) ^ a.val)) := by
    apply Finset.sum_congr rfl
    intro a _
    rw [hD a, hst a]
  -- stage 2: expand the product of sums
  let X : Fin N → Fin N → Fin N → ℂ :=
    fun a m n => (f m * (ω ^ m.val) ^ a.val) *
      (star (f n) * (star (ω ^ n.val)) ^ a.val)
  have hS2 : (∑ a : Fin N, (∑ m : Fin N, f m * (ω ^ m.val) ^ a.val) *
      (∑ n : Fin N, star (f n) * (star (ω ^ n.val)) ^ a.val)) =
      (∑ a : Fin N, ∑ m : Fin N, ∑ n : Fin N, X a m n) := by
    apply Finset.sum_congr rfl
    intro a _
    rw [Finset.sum_mul_sum (Finset.univ : Finset (Fin N))
      (Finset.univ : Finset (Fin N))
      (fun m : Fin N => f m * (ω ^ m.val) ^ a.val)
      (fun n : Fin N => star (f n) * (star (ω ^ n.val)) ^ a.val)]
  -- stage 3: change the order of summation
  have hfub : (∑ a : Fin N, ∑ m : Fin N, ∑ n : Fin N, X a m n) =
      (∑ m : Fin N, ∑ n : Fin N, ∑ a : Fin N, X a m n) := by
    have huprod1 : (Finset.univ : Finset (Fin N × Fin N)) =
        (Finset.univ ×ˢ Finset.univ : Finset (Fin N × Fin N)) := by
      ext _
      simp
    have huprod2 : (Finset.univ : Finset (Fin N × (Fin N × Fin N))) =
        (Finset.univ ×ˢ Finset.univ :
          Finset (Fin N × (Fin N × Fin N))) := by
      ext _
      simp
    have huprod3 : (Finset.univ : Finset ((Fin N × Fin N) × Fin N)) =
        (Finset.univ ×ˢ Finset.univ :
          Finset ((Fin N × Fin N) × Fin N)) := by
      ext _
      simp
    -- reindex LHS: nested sum over (a, (m, n))
    have hL : (∑ a : Fin N, ∑ m : Fin N, ∑ n : Fin N, X a m n) =
        (∑ t : Fin N × (Fin N × Fin N), X t.1 t.2.1 t.2.2) := by
      have hL1 : (∑ a : Fin N, ∑ m : Fin N, ∑ n : Fin N, X a m n) =
          (∑ a : Fin N, (∑ p : Fin N × Fin N, X a p.1 p.2)) := by
        apply Finset.sum_congr rfl
        intro a _
        have hmid : (∑ m : Fin N, ∑ n : Fin N, X a m n : ℂ) =
            (∑ p : Fin N × Fin N, X a p.1 p.2) := by
          rw [show (∑ p : Fin N × Fin N, X a p.1 p.2 : ℂ) =
              (∑ p ∈ (Finset.univ ×ˢ Finset.univ : Finset (Fin N × Fin N)),
                X a p.1 p.2) from by
            rw [show (∑ p : Fin N × Fin N, X a p.1 p.2 : ℂ) =
                (∑ p ∈ (Finset.univ : Finset (Fin N × Fin N)),
                  X a p.1 p.2) from by rfl]
            rw [huprod1]
            try rfl]
          rw [Finset.sum_product (Finset.univ : Finset (Fin N))
            (Finset.univ : Finset (Fin N))
            (fun p : Fin N × Fin N => X a p.1 p.2)]
          try rfl
        exact hmid
      have hL2 : (∑ a : Fin N, (∑ p : Fin N × Fin N, X a p.1 p.2)) =
          (∑ t : Fin N × (Fin N × Fin N), X t.1 t.2.1 t.2.2) := by
        rw [show (∑ a : Fin N, (∑ p : Fin N × Fin N, X a p.1 p.2)) =
            (∑ a ∈ (Finset.univ : Finset (Fin N)),
              ∑ p ∈ (Finset.univ : Finset (Fin N × Fin N)),
                (fun ap : Fin N × (Fin N × Fin N) =>
                  X ap.1 ap.2.1 ap.2.2) (a, p)) from by rfl]
        rw [← Finset.sum_product (Finset.univ : Finset (Fin N))
          (Finset.univ : Finset (Fin N × Fin N))
          (fun ap : Fin N × (Fin N × Fin N) => X ap.1 ap.2.1 ap.2.2)]
        rw [show (∑ t : Fin N × (Fin N × Fin N), X t.1 t.2.1 t.2.2 : ℂ) =
            (∑ t ∈ (Finset.univ ×ˢ Finset.univ :
              Finset (Fin N × (Fin N × Fin N))), X t.1 t.2.1 t.2.2) from by
          rw [show (∑ t : Fin N × (Fin N × Fin N), X t.1 t.2.1 t.2.2 : ℂ) =
              (∑ t ∈ (Finset.univ : Finset (Fin N × (Fin N × Fin N))),
                X t.1 t.2.1 t.2.2) from by rfl]
          rw [huprod2]]
      rw [hL1, hL2]
    -- reindex RHS: nested sum over ((m, n), a)
    have hR : (∑ m : Fin N, ∑ n : Fin N, ∑ a : Fin N, X a m n) =
        (∑ t : (Fin N × Fin N) × Fin N, X t.1.2 t.2 t.1.1) := by
      have hR1 : (∑ m : Fin N, ∑ n : Fin N, ∑ a : Fin N, X a m n) =
          (∑ m : Fin N, (∑ p : Fin N × Fin N, X p.2 m p.1)) := by
        apply Finset.sum_congr rfl
        intro m _
        have hmid : (∑ n : Fin N, ∑ a : Fin N, X a m n : ℂ) =
            (∑ p : Fin N × Fin N, X p.2 m p.1) := by
          rw [show (∑ p : Fin N × Fin N, X p.2 m p.1 : ℂ) =
              (∑ p ∈ (Finset.univ ×ˢ Finset.univ : Finset (Fin N × Fin N)),
                X p.2 m p.1) from by
            rw [show (∑ p : Fin N × Fin N, X p.2 m p.1 : ℂ) =
                (∑ p ∈ (Finset.univ : Finset (Fin N × Fin N)),
                  X p.2 m p.1) from by rfl]
            rw [huprod1]
            try rfl]
          rw [Finset.sum_product (Finset.univ : Finset (Fin N))
            (Finset.univ : Finset (Fin N))
            (fun p : Fin N × Fin N => X p.2 m p.1)]
          try rfl
        exact hmid
      have hR2 : (∑ m : Fin N, (∑ p : Fin N × Fin N, X p.2 m p.1)) =
          (∑ t : (Fin N × Fin N) × Fin N, X t.1.2 t.2 t.1.1) := by
        rw [show (∑ m : Fin N, (∑ p : Fin N × Fin N, X p.2 m p.1)) =
            (∑ m ∈ (Finset.univ : Finset (Fin N)),
              ∑ p ∈ (Finset.univ : Finset (Fin N × Fin N)),
                X p.2 m p.1) from by rfl]
        rw [Finset.sum_comm]
        rw [show (∑ p ∈ (Finset.univ : Finset (Fin N × Fin N)),
            (∑ m ∈ (Finset.univ : Finset (Fin N)), X p.2 m p.1)) =
            (∑ p ∈ (Finset.univ : Finset (Fin N × Fin N)),
              (∑ m ∈ (Finset.univ : Finset (Fin N)),
                (fun pm : (Fin N × Fin N) × Fin N =>
                  X pm.1.2 pm.2 pm.1.1) (p, m))) from by
          apply Finset.sum_congr rfl
          intro p _
          apply Finset.sum_congr rfl
          intro m _
          rfl]
        rw [← Finset.sum_product (Finset.univ : Finset (Fin N × Fin N))
          (Finset.univ : Finset (Fin N))
          (fun pm : (Fin N × Fin N) × Fin N => X pm.1.2 pm.2 pm.1.1)]
        rw [show (∑ t : (Fin N × Fin N) × Fin N, X t.1.2 t.2 t.1.1 : ℂ) =
            (∑ t ∈ (Finset.univ ×ˢ Finset.univ :
              Finset ((Fin N × Fin N) × Fin N)), X t.1.2 t.2 t.1.1) from by
          rw [show (∑ t : (Fin N × Fin N) × Fin N, X t.1.2 t.2 t.1.1 : ℂ) =
              (∑ t ∈ (Finset.univ : Finset ((Fin N × Fin N) × Fin N)),
                X t.1.2 t.2 t.1.1) from by rfl]
          rw [huprod3]]
        try apply Finset.sum_congr rfl
        try intro pm _
        try rfl
      rw [hR1, hR2]
    rw [hL, hR]
    apply Finset.sum_bij
      (fun t (_ : t ∈ (Finset.univ : Finset (Fin N × (Fin N × Fin N)))) =>
        ((⟨t.2.2, t.1⟩ : Fin N × Fin N), t.2.1))
    · intro t _
      exact Finset.mem_univ _
    · intro a1 _ a2 _ heq
      have h1 : ((⟨a1.2.2, a1.1⟩ : Fin N × Fin N), a1.2.1) =
                ((⟨a2.2.2, a2.1⟩ : Fin N × Fin N), a2.2.1) := by
        simpa using heq
      have hz : a1.2.2 = a2.2.2 := by
        have := congrArg (fun (w : (Fin N × Fin N) × Fin N) => (w.1).1) h1
        simpa using this
      have hx : a1.1 = a2.1 := by
        have := congrArg (fun (w : (Fin N × Fin N) × Fin N) => (w.1).2) h1
        simpa using this
      have hy : a1.2.1 = a2.2.1 := by
        have := congrArg (fun (w : (Fin N × Fin N) × Fin N) => w.2) h1
        simpa using this
      have hinner : a1.2 = a2.2 := by
        calc (a1.2 : Fin N × Fin N) = (a1.2.1, a1.2.2) := rfl
          _ = (a2.2.1, a1.2.2) := by rw [hy]
          _ = (a2.2.1, a2.2.2) := by rw [hz]
          _ = a2.2 := rfl
      calc a1 = (a1.1, a1.2) := rfl
        _ = (a2.1, a1.2) := by rw [hx]
        _ = (a2.1, a2.2) := by rw [hinner]
        _ = a2 := rfl
    · intro b hb
      refine ⟨(⟨b.1.2, ⟨b.2, b.1.1⟩⟩ : Fin N × (Fin N × Fin N)),
        Finset.mem_univ _, rfl⟩
    · intro a _
      rfl
  -- stage 4: factor the (m, n) part out of the a-sum
  have hS4 : (∑ m : Fin N, ∑ n : Fin N, ∑ a : Fin N, X a m n) =
      (∑ m : Fin N, ∑ n : Fin N, (f m * star (f n)) *
        (∑ a : Fin N, (ω ^ m.val) ^ a.val * (star (ω ^ n.val)) ^ a.val)) := by
    apply Finset.sum_congr rfl
    intro m _
    apply Finset.sum_congr rfl
    intro n _
    have hterm (a : Fin N) : X a m n =
        (f m * star (f n)) * ((ω ^ m.val) ^ a.val * (star (ω ^ n.val)) ^ a.val) := by
      dsimp only [X]
      ring
    rw [show (∑ a : Fin N, X a m n : ℂ) =
        (∑ a : Fin N, (f m * star (f n)) *
          ((ω ^ m.val) ^ a.val * (star (ω ^ n.val)) ^ a.val)) from by
      apply Finset.sum_congr rfl
      intro a _
      rw [hterm a]]
    rw [← (Finset.mul_sum (Finset.univ : Finset (Fin N))
      (fun a : Fin N => (ω ^ m.val) ^ a.val * (star (ω ^ n.val)) ^ a.val)
      ((f m * star (f n)) : ℂ))]
  -- stage 5: rewrite the a-sum in kernel form
  have hS5 : (∑ m : Fin N, ∑ n : Fin N, (f m * star (f n)) *
      (∑ a : Fin N, (ω ^ m.val) ^ a.val * (star (ω ^ n.val)) ^ a.val)) =
      (∑ m : Fin N, ∑ n : Fin N, (f m * star (f n)) *
        (∑ a : Fin N, ω ^ (m.val * a.val) * ((ω ^ (n.val * a.val)) : ℂ)⁻¹)) := by
    apply Finset.sum_congr rfl
    intro m _
    apply Finset.sum_congr rfl
    intro n _
    have hinner : (∑ a : Fin N, (ω ^ m.val) ^ a.val * (star (ω ^ n.val)) ^ a.val) =
        (∑ a : Fin N, ω ^ (m.val * a.val) * ((ω ^ (n.val * a.val)) : ℂ)⁻¹) := by
      apply Finset.sum_congr rfl
      intro a _
      have h1 : (ω ^ m.val : ℂ) ^ a.val = (ω : ℂ) ^ (m.val * a.val) :=
        (pow_mul ω (m.val) (a.val)).symm
      have h2 : (star (ω ^ n.val)) ^ a.val =
          ((ω ^ (n.val * a.val)) : ℂ)⁻¹ := by
        rw [hstarinv n.val, inv_pow (ω ^ n.val : ℂ) (a.val)]
        rw [show ((ω ^ (n.val : ℕ) : ℂ) ^ (a.val : ℕ)) = (ω : ℂ) ^ (n.val * a.val) from
          (pow_mul ω (n.val) (a.val)).symm]
      rw [h1, h2]
    rw [hinner]
  -- stage 6: apply the kernel
  have hS6 : (∑ m : Fin N, ∑ n : Fin N, (f m * star (f n)) *
      (∑ a : Fin N, ω ^ (m.val * a.val) * ((ω ^ (n.val * a.val)) : ℂ)⁻¹)) =
      (∑ m : Fin N, ∑ n : Fin N, (f m * star (f n)) *
        (if m = n then (N : ℂ) else 0)) := by
    apply Finset.sum_congr rfl
    intro m _
    apply Finset.sum_congr rfl
    intro n _
    rw [hkernel m n]
  -- stage 7: collapse the single nonzero (m, n) diagonal
  have hS7 : (∑ m : Fin N, ∑ n : Fin N, (f m * star (f n)) *
      (if m = n then (N : ℂ) else 0)) =
      (∑ m : Fin N, (f m * star (f m)) * (N : ℂ)) := by
    apply Finset.sum_congr rfl
    intro m _
    rw [Finset.sum_eq_single (a := m)
      (fun n _ (hnm : n ≠ m) => by
        by_cases hm : m = n
        · exfalso
          exact hnm hm.symm
        · rw [if_neg hm]
          simp)
      (fun (hnm : m ∉ Finset.univ) => by
        exfalso
        exact hnm (Finset.mem_univ m))]
    rw [if_pos (by rfl)]
  -- the complex Parseval identity
  have hc : (∑ a : Fin N, (dft N (Nat.le_of_lt hN) f a) *
      star (dft N (Nat.le_of_lt hN) f a)) =
      (N : ℂ) * (∑ m : Fin N, f m * star (f m)) := by
    rw [hS1, hS2, hfub, hS4, hS5, hS6, hS7]
    have hs : (∑ m : Fin N, (f m * star (f m)) * (N : ℂ)) =
        (N : ℂ) * (∑ m : Fin N, f m * star (f m)) := by
      rw [show (∑ m : Fin N, (f m * star (f m)) * (N : ℂ) : ℂ) =
          (∑ m : Fin N, (N : ℂ) * (f m * star (f m))) from by
        apply Finset.sum_congr rfl
        intro m _
        rw [mul_comm]]
      rw [Finset.mul_sum (Finset.univ : Finset (Fin N))
        (fun m : Fin N => f m * star (f m)) ((N : ℂ))]
    rw [hs]
  -- star-conjugation component facts for the real-part bridges
  have hzre (z : ℂ) : (star z).re = z.re := by
    simp [Complex.conj_re]
  have hzim (z : ℂ) : (star z).im = -z.im := by
    simp [Complex.conj_im]
  -- take real parts
  have hl : (((∑ a : Fin N, (dft N (Nat.le_of_lt hN) f a) *
      star (dft N (Nat.le_of_lt hN) f a)) : ℂ).re : ℝ) =
      (∑ a : Fin N, Complex.normSq (dft N (Nat.le_of_lt hN) f a)) := by
    rw [Complex.re_sum]
    apply Finset.sum_congr rfl
    intro a _
    rw [show ((dft N (Nat.le_of_lt hN) f a) *
        star (dft N (Nat.le_of_lt hN) f a)).re =
        Complex.normSq (dft N (Nat.le_of_lt hN) f a) from by
      rw [Complex.mul_re, hzre, hzim,
        Complex.normSq_apply (dft N (Nat.le_of_lt hN) f a)]
      ring]
  have hr : (((N : ℂ) * (∑ m : Fin N, f m * star (f m)) : ℂ).re : ℝ) =
      (N : ℝ) * (∑ m : Fin N, Complex.normSq (f m)) := by
    rw [Complex.mul_re,
      show ((N : ℂ) : ℂ).re = (N : ℝ) from by simp,
      show ((N : ℂ) : ℂ).im = (0 : ℝ) from by simp]
    have hSre : ((∑ m : Fin N, f m * star (f m) : ℂ)).re =
        (∑ m : Fin N, (f m * star (f m)).re) := by
      rw [Complex.re_sum]
    rw [hSre]
    have hSre2 : (∑ m : Fin N, (f m * star (f m)).re) =
        (∑ m : Fin N, Complex.normSq (f m)) := by
      apply Finset.sum_congr rfl
      intro m _
      rw [show ((f m * star (f m)).re : ℝ) = Complex.normSq (f m) from by
        rw [Complex.mul_re, hzre, hzim,
          Complex.normSq_apply (f m)]
        ring]
    rw [hSre2]
    ring
  calc (∑ a : Fin N, Complex.normSq (dft N (Nat.le_of_lt hN) f a))
    _ = (((∑ a : Fin N, (dft N (Nat.le_of_lt hN) f a) *
        star (dft N (Nat.le_of_lt hN) f a)) : ℂ).re : ℝ) := hl.symm
    _ = (((N : ℂ) * (∑ m : Fin N, f m * star (f m)) : ℂ).re : ℝ) := by rw [hc]
    _ = (N : ℝ) * (∑ m : Fin N, Complex.normSq (f m)) := hr

end SieveFourier
