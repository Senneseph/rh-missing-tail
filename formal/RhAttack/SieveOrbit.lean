/-
Copyright: campaign (rh-missing-tail).  All rights:  the math is the math.

SieveOrbit.lean  —  KCS plan  unit  U4a  (docs/KANSAS-CITY-SHUFFLE-SIEVE-ORBIT-PLAN-2026-10-25.md):
the  LEGENDRE  EXACT  identity  in  theorem  form  (the  second-orbit  sieve
action,  zeta-free  face).

   φ(x, z)  =  Σ_{d | P(z)}  μ(d) ⌊x / d⌋

where  the  sieve  level  z  is  represented  by  the  explicit  list  ps  of
distinct  primes  (P  :=  ∏ ps).  The  statement  is  the  ℤ form
   (phi_list x ps : ℤ)  =  Σ_{d | ∏ ps}  (μ d : ℤ) · (x / d),
μ  taking  negative  values;  legendre_count_eq  then  bridges  the  sum  to
the  exact  count  of  n ∈ [1, x]  coprime  to  ∏ ps.

The  proof  is  by  induction  on  ps.  The  engine  in  the  step  is  the
coprime  split  of  μ  over  the  divisor  product  (m·n  with  m, n  coprime):
(p·P).divisors  =  p.divisors ×ˢ P.divisors  (Nat.Coprime.mul_injOn_divisors,
the  same  reindex  structure  as  raman_multiplicativity  in  SIEVEACT-010),
μ(p·d)  =  μ p · μ d  =  −μ d,  and  the  two  halves  of  the  sum  are
exactly  the  two  sides  of  the  Legendre  recursion.

Contents:
  phi_list                        the  Legendre  recursion  (def)
  nodup_prime_split               nodup-list  head/tail  decomposition
  phi_list_count                  the  recursion  IS  the  count  (semantics)
  phi_list_mono                   monotonicity  in  x  (used  for  the  lift)
  prime_dvd_prod_of_prime_list    p prime  ⊢  p | ∏ ls  →  p ∈ ls
  legendre_identity               THE  identity  (U4a)
  legendre_count_eq               sum  =  count  bridge

Pure  finite  combinatorics  over  ℕ/ℤ.  No  analysis,  no  axioms,  no
external  provenance,  no  RH  claim.
-/
import Mathlib
open Finset

namespace SieveOrbit



def phi_list (x : ℕ) (ps : List ℕ) : ℕ :=
  match ps with
  | [] => x
  | (p :: ps') => phi_list x ps' - phi_list (x / p) ps'

/-- The `p` in the head of a nodup prime list is not in the tail,  and the
    tail is nodup.  (Pairwise is the core inductive:  cons carries  the
    head-vs-tail  hypothesis  and  the  tail.) -/
theorem nodup_prime_split {p : ℕ} {ps' : List ℕ} (h : (p :: ps').Nodup) :
    (∀ q ∈ ps', p ≠ q) ∧ ps'.Nodup :=
  match h with
  | List.Pairwise.cons head tail => ⟨head, tail⟩

/- The counting semantics of the recursion:  phi_list x ps is exactly the
   number of n ∈ [1, x] not divisible by any prime in ps. -/
theorem phi_list_count (x : ℕ) (ps : List ℕ)
    (hprime : ∀ p ∈ ps, Nat.Prime p) (hdistinct : ps.Nodup) :
    ((Icc 1 x).filter (fun n => ∀ p ∈ ps, ¬ p ∣ n)).card = phi_list x ps := by
  induction ps generalizing x with
  | nil =>
    have htriv : (Icc 1 x).filter (fun n => ∀ p ∈ ([] : List ℕ), ¬ p ∣ n) = Icc 1 x := by
      ext n
      simp
    rw [htriv]
    unfold phi_list
    rw [Nat.card_Icc]
    omega
  | cons p ps' ih =>
    unfold phi_list
    obtain ⟨hnotp, hdistinct'⟩ := nodup_prime_split hdistinct
    have hprime' : ∀ q ∈ ps', Nat.Prime q := fun q hq => hprime q (List.mem_cons_of_mem p hq)
    have hp : Nat.Prime p := hprime p List.mem_cons_self
    let Cset := (Icc 1 x).filter (fun n => ∀ q ∈ ps', ¬ q ∣ n)
    let A := Cset.filter (fun n => p ∣ n)
    let B := Cset.filter (fun n => ¬ p ∣ n)
    -- the goal's filter set is exactly  B
    have hgoalset : ((Icc 1 x).filter (fun n => ∀ q ∈ p :: ps', ¬ q ∣ n)) = B := by
      ext n
      dsimp only [A, B, Cset]
      simp only [Finset.mem_filter]
      constructor
      · rintro ⟨hI, hF⟩
        have hall : ∀ q ∈ ps', ¬ q ∣ n := fun q hq => hF q (List.mem_cons_of_mem p hq)
        have hnp : ¬ p ∣ n := hF p List.mem_cons_self
        exact ⟨⟨hI, hall⟩, hnp⟩
      · intro h
        obtain ⟨hXY, hnp⟩ := h
        obtain ⟨hI, hall⟩ := hXY
        refine ⟨hI, fun q hq' => ?_⟩
        cases (Classical.em (q = p)) with
        | inl hqp =>
          rw [hqp]
          exact hnp
        | inr hqp =>
          have hqm : q ∈ ps' := Or.resolve_left (List.mem_cons.mp hq') hqp
          exact hall q hqm
    --  Cset  =  A ∪ B  and  A ∩ B = ∅  (split on  p | n)
    have hU : A ∪ B = Cset := by
      ext n
      dsimp only [A, B, Cset]
      cases (Classical.em (p ∣ n)) with
      | inl hpn => simp [hpn]
      | inr hpn => simp [hpn]
    have hD : A ∩ B = ∅ := by
      ext n
      dsimp only [A, B, Cset]
      cases (Classical.em (p ∣ n)) with
      | inl hpn => simp [hpn]
      | inr hpn => simp [hpn]
    have hCadd : Cset.card = A.card + B.card := by
      have h1 : (A ∪ B).card + (A ∩ B).card = A.card + B.card :=
        Finset.card_union_add_card_inter A B
      have h0 : (A ∩ B).card = 0 := by
        rw [hD]
        simp
      rw [← hU]
      omega
    --  the p-multiples  set  A  is the image of  m ↦ p · m  over the  x / p  tail set;
    --  both  directions  are  written  at  the  raw  Finset level
    have hAimg : A = image (fun m => p * m) ((Icc 1 (x / p)).filter (fun m => ∀ q ∈ ps', ¬ q ∣ m)) := by
      ext n
      simp only [Finset.mem_image]
      constructor
      · intro h
        --  h  :  n ∈ A  =  n ∈ Cset.filter  (p | ·)
        rw [Finset.mem_filter] at h
        obtain ⟨hnC, hpd⟩ := h
        rw [Finset.mem_filter, Finset.mem_Icc] at hnC
        obtain ⟨h12, hC⟩ := hnC
        obtain ⟨h1n, hnx⟩ := h12
        have hm : n = p * (n / p) := (Nat.mul_div_cancel' hpd).symm
        have h1k : 1 ≤ n / p := by
          by_contra hlt
          have hl0 : n / p ≤ 0 := by
            have hk1 : n / p < 1 := Nat.not_le.mp hlt
            exact Nat.le_of_lt_succ hk1
          have hk0 : n / p = 0 := Nat.le_antisymm hl0 (Nat.zero_le (n / p))
          have hn0 : n = 0 := by
            rw [hm]
            simpa [hk0, Nat.mul_zero]
          have hcontra : 1 ≤ 0 := by simpa [hn0] using h1n
          omega
        have hkx : n / p ≤ x / p := by
          rw [Nat.le_div_iff_mul_le (Nat.Prime.pos hp)]
          have hmul : (n / p) * p = n := by
            have hpm : p * (n / p) = n := Nat.mul_div_cancel' hpd
            rw [Nat.mul_comm]
            exact hpm
          omega
        use n / p
        constructor
        · rw [Finset.mem_filter, Finset.mem_Icc]
          constructor
          · exact ⟨h1k, hkx⟩
          · intro q hq
            have hhq : Nat.Prime q := hprime' q hq
            have hqnp : ¬ q ∣ p := by
              intro hqd
              have hq1o : q = 1 ∨ q = p := Nat.Prime.eq_one_or_self_of_dvd hp q hqd
              cases hq1o with
              | inl hq1 => exact hhq.ne_one hq1
              | inr hq1 => exact (hnotp q hq).symm hq1
            have hqm : q ∣ p * (n / p) ↔ q ∣ p ∨ q ∣ (n / p) := Nat.Prime.dvd_mul hhq
            intro hk
            have hCq : ¬ q ∣ n := hC q hq
            have hqdn : q ∣ n := by
              rw [hm]
              exact hqm.mpr (Or.inr hk)
            exact hCq hqdn
        · exact hm.symm
      · intro h
        obtain ⟨m, hm, hmux⟩ := h
        rw [Finset.mem_filter] at hm
        obtain ⟨hmI, hCm⟩ := hm
        rw [Finset.mem_Icc] at hmI
        obtain ⟨hm1, hml⟩ := hmI
        have h1nm : 1 ≤ p * m := by
          have h1p : 1 ≤ p := Nat.succ_le_of_lt (Nat.Prime.pos hp)
          simpa [Nat.one_mul] using Nat.mul_le_mul h1p hm1
        have hle : p * m ≤ x := by
          have hmul : p * m ≤ p * (x / p) := Nat.mul_le_mul_left p hml
          have hsub : p * (x / p) ≤ x := Nat.mul_div_le x p
          exact le_trans hmul hsub
        have hnotq : ∀ q ∈ ps', ¬ q ∣ p * m := by
          intro q hq
          have hhq : Nat.Prime q := hprime' q hq
          have hqnp : ¬ q ∣ p := by
            intro hqd
            have hq1o : q = 1 ∨ q = p := Nat.Prime.eq_one_or_self_of_dvd hp q hqd
            cases hq1o with
            | inl hq1 => exact hhq.ne_one hq1
            | inr hq1 => exact (hnotp q hq).symm hq1
          have hqm : q ∣ p * m ↔ q ∣ p ∨ q ∣ m := Nat.Prime.dvd_mul hhq
          intro hnq
          have := hqm.1 hnq
          cases this with
          | inl hh => exact hqnp hh
          | inr hh => exact (hCm q hq) hh
        exact show n ∈ A from by
          rw [Finset.mem_filter, Finset.mem_filter, Finset.mem_Icc]
          constructor
          · constructor
            · constructor
              · rw [← hmux]
                exact h1nm
              · rw [← hmux]
                exact hle
            · intro q hq hnq
              have hnm : q ∣ p * m := by
                rw [← hmux] at hnq
                exact hnq
              exact (hnotq q hq) hnm
          · exact ⟨m, hmux.symm⟩
    have hIHtail : Cset.card = phi_list x ps' :=
      ih x hprime' hdistinct'
    have hIHdiv : ((Icc 1 (x / p)).filter (fun m => ∀ q ∈ ps', ¬ q ∣ m)).card =
        phi_list (x / p) ps' :=
      ih (x / p) hprime' hdistinct'
    have hAcard : A.card = phi_list (x / p) ps' := by
      rw [hAimg]
      have hfinjective : Function.Injective (fun m : ℕ => p * m) := by
        intro m m' h
        exact Nat.mul_left_cancel (Nat.Prime.pos hp) h
      rw [Finset.card_image_of_injective ((Icc 1 (x / p)).filter (fun m => ∀ q ∈ ps', ¬ q ∣ m))
        hfinjective]
      exact hIHdiv
    --  the  not-multiples  count  is  the  tail  count  minus  the  p-multiples  count
    have hB : B.card = Cset.card - A.card := by
      omega
    rw [hgoalset, hB, hIHtail, hAcard]

/- Monotonicity in x  (the count of survivors never decreases). -/
theorem phi_list_mono (x y : ℕ) (hxy : x ≤ y) (ps : List ℕ)
    (hprime : ∀ p ∈ ps, Nat.Prime p) (hdistinct : ps.Nodup) :
    phi_list x ps ≤ phi_list y ps := by
  have hx : ((Icc 1 x).filter (fun n => ∀ p ∈ ps, ¬ p ∣ n)).card = phi_list x ps :=
    phi_list_count x ps hprime hdistinct
  have hy : ((Icc 1 y).filter (fun n => ∀ p ∈ ps, ¬ p ∣ n)).card = phi_list y ps :=
    phi_list_count y ps hprime hdistinct
  have hsub : (Icc 1 x).filter (fun n => ∀ p ∈ ps, ¬ p ∣ n) ⊆
      (Icc 1 y).filter (fun n => ∀ p ∈ ps, ¬ p ∣ n) := by
    intro n hn
    obtain ⟨hn1, hF⟩ := by simpa using hn
    have h1n : 1 ≤ n := hn1.1
    have hnx : n ≤ x := hn1.2
    rw [Finset.mem_filter]
    constructor
    · rw [Finset.mem_Icc]
      exact ⟨h1n, by omega⟩
    · exact hF
  rw [← hx, ← hy]
  exact Finset.card_mono hsub

/- A  prime  in  a  product  of  primes:  if  p (prime)  divides  the  product  of  a  list  of
   primes,  then  p  appears  in  the  list.  (Engine  for  the  p-Coprime  P  fact  below.) -/
theorem prime_dvd_prod_of_prime_list (p : ℕ) (hp : Nat.Prime p) (ls : List ℕ)
    (hprime : ∀ q ∈ ls, Nat.Prime q) (hdiv : p ∣ ls.prod) : p ∈ ls := by
  induction ls with
  | nil =>
    rw [List.prod_nil] at hdiv
    have hle : p ≤ 1 := Nat.le_of_dvd (Nat.one_pos) hdiv
    have htwo : 2 ≤ p := Nat.Prime.two_le hp
    omega
  | cons q qs ihq =>
    rw [List.prod_cons] at hdiv
    cases (Nat.Prime.dvd_mul hp).mp hdiv with
    | inl hq =>
      have hp1o : p = 1 ∨ p = q :=
        Nat.Prime.eq_one_or_self_of_dvd (hprime q List.mem_cons_self) p hq
      cases hp1o with
      | inl hp1 => exact (hp.ne_one hp1).elim
      | inr hpq =>
        rw [hpq]
        exact List.mem_cons_self
    | inr hqs =>
      have hprimeqs : ∀ q' ∈ qs, Nat.Prime q' :=
        fun q' hq' => hprime q' (List.mem_cons_of_mem q hq')
      exact List.mem_cons_of_mem q (ihq hprimeqs hqs)

/- U4(a)  proper:  the  Möbius  divisor-sum  identity.
   The recursion  phi_list  (the  Legendre sieve)  equals  the  exact  inclusion-exclusion
   sum  over  the  divisors  of  P  :=  prod  ps:   phi  =  Σ_{d|P}  μ(d)⌊x/d⌋.  (ℤ  form
   because  μ  takes  negative  values.)  The  engine  is  the  coprime  multiplicative
   split  of  μ  over  the  divisor  product  (the  same   Nat.Coprime.mul_injOn_divisors
   structure  as  raman_multiplicativity  in  SieveAction.lean). -/
theorem legendre_identity (x : ℕ) (ps : List ℕ)
    (hprime : ∀ p ∈ ps, Nat.Prime p) (hdistinct : ps.Nodup) :
    (phi_list x ps : ℤ) = ∑ d ∈ (ps.prod).divisors, (ArithmeticFunction.moebius d : ℤ) * Int.ofNat (x / d) := by
  induction ps generalizing x with
  | nil =>
    rw [phi_list, List.prod_nil, Nat.divisors_one]
    rw [Finset.sum_singleton]
    rw [ArithmeticFunction.moebius_apply_one, Nat.div_one, one_mul]
    rfl
  | cons p ps' ih =>
    obtain ⟨hnotp, hdistinct'⟩ := nodup_prime_split hdistinct
    have hprime' : ∀ q ∈ ps', Nat.Prime q := fun q hq => hprime q (List.mem_cons_of_mem p hq)
    have hp : Nat.Prime p := hprime p List.mem_cons_self
    have hnotdivP : ¬ p ∣ ps'.prod := by
      intro hdiv
      exact (hnotp p (prime_dvd_prod_of_prime_list p hp ps' hprime' hdiv)) (Eq.refl p)
    let P : ℕ := ps'.prod
    have hP : (p :: ps').prod = p * P := by
      rw [List.prod_cons]
    have hcop : p.Coprime P :=
      (Nat.Prime.coprime_iff_not_dvd hp).mpr hnotdivP
    have hIHx : (phi_list x ps' : ℤ) = ∑ d ∈ P.divisors, (ArithmeticFunction.moebius d : ℤ) * Int.ofNat (x / d) :=
      ih x hprime' hdistinct'
    have hIHd : (phi_list (x / p) ps' : ℤ) =
        ∑ d ∈ P.divisors, (ArithmeticFunction.moebius d : ℤ) * Int.ofNat ((x / p) / d) :=
      ih (x / p) hprime' hdistinct'
    simp only [phi_list]
    -- the  difference  lifts  to  the  ℤ difference  (monotone  recursion  gives  the  order):
    have hmono : phi_list (x / p) ps' ≤ phi_list x ps' :=
      phi_list_mono (x / p) x (Nat.div_le_self x p) ps' hprime' hdistinct'
    have hcast : ↑(phi_list x ps' - phi_list (x / p) ps') =
        (phi_list x ps' : ℤ) - (phi_list (x / p) ps' : ℤ) :=
      Int.ofNat_sub hmono
    rw [hcast, hIHx, hIHd]
    -- the  x / p  summand  is  x / (p · d):
    have hG : ∑ d ∈ P.divisors, (ArithmeticFunction.moebius d : ℤ) * Int.ofNat ((x / p) / d) =
        ∑ d ∈ P.divisors, (ArithmeticFunction.moebius d : ℤ) * Int.ofNat (x / (p * d)) := by
      refine Finset.sum_congr rfl (fun d _ => by
        rw [← Nat.div_div_eq_div_mul])
    rw [hG]
    -- build  the  divisor  sum  over  p · P  and  show  it  is  the  same  difference:
    have hright : ∑ e ∈ (p :: ps').prod.divisors, (ArithmeticFunction.moebius e : ℤ) * Int.ofNat (x / e) =
        (∑ d ∈ P.divisors, (ArithmeticFunction.moebius d : ℤ) * Int.ofNat (x / d)) -
        (∑ d ∈ P.divisors, (ArithmeticFunction.moebius d : ℤ) * Int.ofNat (x / (p * d))) := by
      rw [hP]
      rw [Nat.divisors_mul p P]
      rw [Finset.mul_def]
      rw [Finset.sum_image (hcop.mul_injOn_divisors)]
      rw [Finset.sum_product]
      rw [Nat.Prime.divisors hp]
      rw [Finset.sum_pair hp.ne_one.symm]
      -- the  a = 1  term  is  T  :=  ∑_d  μ(d)(x/d):
      have hF1 : (∑ d ∈ P.divisors, (ArithmeticFunction.moebius (1 * d) : ℤ) * Int.ofNat (x / (1 * d))) =
          ∑ d ∈ P.divisors, (ArithmeticFunction.moebius d : ℤ) * Int.ofNat (x / d) := by
        refine Finset.sum_congr rfl (fun d _ => by
          rw [one_mul])
      -- the  a = p  term  is  −S'  with  S'  :=  ∑_d  μ(d)(x/(p·d)):
      have hFp : (∑ d ∈ P.divisors, (ArithmeticFunction.moebius (p * d) : ℤ) * Int.ofNat (x / (p * d))) =
          -(∑ d ∈ P.divisors, (ArithmeticFunction.moebius d : ℤ) * Int.ofNat (x / (p * d))) := by
        have hS : -(∑ d ∈ P.divisors, (ArithmeticFunction.moebius d : ℤ) * Int.ofNat (x / (p * d))) =
            ∑ d ∈ P.divisors, -((ArithmeticFunction.moebius d : ℤ) * Int.ofNat (x / (p * d))) :=
          (Finset.sum_neg_distrib fun d => (ArithmeticFunction.moebius d : ℤ) * Int.ofNat (x / (p * d))).symm
        rw [hS]
        refine Finset.sum_congr rfl (fun d hd => by
          obtain ⟨hdp, hPnz⟩ := Nat.mem_divisors.mp hd
          have hddcop : p.gcd d = 1 := by
            have hnotpd : ¬ p ∣ d := by
              intro h
              exact hnotdivP (Nat.dvd_trans h hdp)
            rw [← Nat.coprime_iff_gcd_eq_one]
            exact (Nat.Prime.coprime_iff_not_dvd hp).mpr hnotpd
          have hmul : ArithmeticFunction.moebius (p * d) =
              ArithmeticFunction.moebius p * ArithmeticFunction.moebius d :=
            ArithmeticFunction.IsMultiplicative.map_mul_of_coprime
              ArithmeticFunction.isMultiplicative_moebius hddcop
          rw [hmul, ArithmeticFunction.moebius_apply_prime hp]
          ring)
      rw [hF1, hFp]
      ring
    exact hright.symm

/- Bridge:  the  ℤ  divisor-sum  equals  the  count  (both  views  agree). -/
theorem legendre_count_eq (x : ℕ) (ps : List ℕ)
    (hprime : ∀ p ∈ ps, Nat.Prime p) (hdistinct : ps.Nodup) :
    (∑ d ∈ (ps.prod).divisors, (ArithmeticFunction.moebius d : ℤ) * Int.ofNat (x / d)) =
      ↑((Icc 1 x).filter (fun n => ∀ p ∈ ps, ¬ p ∣ n)).card := by
  have h1 := legendre_identity x ps hprime hdistinct
  have h2 := phi_list_count x ps hprime hdistinct
  rw [h1.symm, ← h2]

end SieveOrbit
