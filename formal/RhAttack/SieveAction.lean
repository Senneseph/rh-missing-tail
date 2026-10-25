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

end SieveFourier
