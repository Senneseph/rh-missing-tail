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


/-!  ====  U4(b):  the  discrete  level-1  exact  sieve  band  ====  -/

/-
U4(b)  formal:  the  discrete  level-1  exact  sieve  band  (0181  measured,  now  proved):

      L1(x,  ps)  <=  Phi(x,  ps)  <=  U2(x,  ps)

  for  every  x  and  every  distinct-prime  list  ps,  with

      Phi(x,  ps)  =  phi_list  x  ps              (0180  recursion  =  survivor  count)
      L1(x,  ps)   =  x  -  sum_{p  in  ps}  floor(x  /  p)
      U2(x,  ps)   =  L1(x,  ps)  +  sum_{p  <  q  in  ps}  floor(x  /  (p  q))

  All  in  Z  (the  band  endpoints  can  go  negative  for  dense  prime  lists,
  while  the  survivor  count  stays  non-negative).  Pure  finite  sieve  combinatorics
  over  exact  naturals;  no  analytic  input.  No  RH  claim.
-/


/-!  ====  the  definitions  ====  -/

/-- The  unordered  distinct  prime  pairs  of  ps. -/
def pairset (ps : List ℕ) : Finset (ℕ × ℕ) :=
  (ps.toFinset ×ˢ ps.toFinset).filter (fun ab => ab.1 < ab.2)

/-- The  ordered  distinct  prime  pairs  of  ps. -/
def orderedpairset (ps : List ℕ) : Finset (ℕ × ℕ) :=
  (ps.toFinset ×ˢ ps.toFinset).filter (fun ab => ab.1 ≠ ab.2)

/-- The  number  of  primes  in  ps  dividing  n  (the  covering  count  m(n)). -/
def mcount (ps : List ℕ) (n : ℕ) : ℕ :=
  ((ps.toFinset).filter (fun p => p ∣ n)).card

/-- The  level-1  (odd  partial  IE)  lower  bound,  in  Z. -/
def L1 (x : ℕ) (ps : List ℕ) : ℤ :=
  (x : ℤ) - ∑ p ∈ (ps.toFinset), Int.ofNat (x / p)

/-- The  even  (pairwise)  correction  mass,  in  Z. -/
def U2pair (x : ℕ) (ps : List ℕ) : ℤ :=
  ∑ ab ∈ (pairset ps), Int.ofNat (x / (ab.1 * ab.2))

/-- The  level-2  (even  partial  IE)  upper  bound,  in  Z. -/
def U2 (x : ℕ) (ps : List ℕ) : ℤ := L1 x ps + U2pair x ps

/-- The  off-diagonal  of  the  square  of  the  covering  set  of  n;  its  card
    is  m(n)  *  (m(n)  -  1). -/
def offdiagset (ps : List ℕ) (n : ℕ) : Finset (ℕ × ℕ) :=
  (((ps.toFinset).filter (fun p => p ∣ n)) ×ˢ
     ((ps.toFinset).filter (fun p => p ∣ n))).filter (fun ab => ab.1 ≠ ab.2)

/-!  ====  count  semantics  +  the  exact  bridges  ====  -/

/-- mcount = 0  is  exactly  "no  prime  in  ps  divides  n". -/
theorem mcount_zero_iff (ps : List ℕ) (n : ℕ) :
    (mcount ps n = 0) ↔ (∀ p ∈ ps, ¬ p ∣ n) := by
  constructor
  · intro h0
    intro p hp hpd
    have hmem : p ∈ (ps.toFinset).filter (fun a => a ∣ n) := by
      rw [Finset.mem_filter]
      constructor
      · simpa using hp
      · exact hpd
    have he : (ps.toFinset).filter (fun a => a ∣ n) = ∅ :=
      Finset.card_eq_zero.mp h0
    exfalso
    have h1 : 1 ≤ (∅ : Finset ℕ).card := Finset.card_pos.mpr ⟨p, he ▸ hmem⟩
    have h0 : (∅ : Finset ℕ).card = 0 := by rw [Finset.card_empty]
    omega
  · intro hno
    have hsub : (ps.toFinset).filter (fun a => a ∣ n) = ∅ := by
      ext a
      rw [Finset.mem_filter]
      constructor
      · rintro ⟨hma, hda⟩
        exfalso
        exact (hno a (by simpa using hma)) hda
      · intro he
        exfalso
        have h1 : 1 ≤ (∅ : Finset ℕ).card := Finset.card_pos.mpr ⟨a, he⟩
        have h0 : (∅ : Finset ℕ).card = 0 := by rw [Finset.card_empty]
        omega
    dsimp only [mcount]
    rw [hsub]
    simp

/-- The  survivor  indicator  sum  is  the  recursion  (0180  phi_list_count,
    via  the  mcount = 0  characterization). -/
theorem mcount_zero_sum (x : ℕ) (ps : List ℕ)
    (hprime : ∀ p ∈ ps, Nat.Prime p) (hdistinct : ps.Nodup) :
    (∑ n ∈ (Icc 1 x), (if mcount ps n = 0 then (1 : ℕ) else 0)) = phi_list x ps := by
  have hsum : (∑ n ∈ (Icc 1 x), (if mcount ps n = 0 then (1 : ℕ) else 0)) =
      (#{n ∈ (Icc 1 x) | mcount ps n = 0}) := by
    simpa using (Finset.sum_boole (fun n : ℕ => mcount ps n = 0))
  rw [hsum]
  have h2 : ({n ∈ (Icc 1 x) | mcount ps n = 0} : Finset ℕ) =
      (Icc 1 x).filter (fun n => ∀ p ∈ ps, ¬ p ∣ n) := by
    simpa using (Finset.filter_congr (fun n _ => mcount_zero_iff ps n))
  rw [h2]
  exact phi_list_count x ps hprime hdistinct

/-- The  integer  form  of  the  count  semantics. -/
theorem phi_indicator (x : ℕ) (ps : List ℕ)
    (hprime : ∀ p ∈ ps, Nat.Prime p) (hdistinct : ps.Nodup) :
    (phi_list x ps : ℤ) =
      (∑ n ∈ (Icc 1 x), if mcount ps n = 0 then (1 : ℤ) else 0) := by
  calc (phi_list x ps : ℤ)
      _ = Int.ofNat (∑ n ∈ (Icc 1 x), (if mcount ps n = 0 then 1 else 0)) := by
        rw [← mcount_zero_sum x ps hprime hdistinct]
        norm_cast
      _ = (∑ n ∈ (Icc 1 x), if mcount ps n = 0 then (1 : ℤ) else 0) := by
        norm_cast

/-- The  card  of  the  multiples  of  p  in  [1,  x]  is  the  floor  x / p. -/
theorem card_mulps (x p : ℕ) (hpos : 0 < p) :
    ((Icc 1 x).filter (fun n => p ∣ n)).card = x / p := by
  have hbi : ((Icc 1 x).filter (fun n => p ∣ n)) =
      ((Icc 1 (x / p)).image (fun m => p * m)) := by
    ext n
    rw [Finset.mem_filter, Finset.mem_image]
    constructor
    · intro hn
      obtain ⟨hnC, hpd⟩ := hn
      have h1n : 1 ≤ n := (Finset.mem_Icc.mp hnC).1
      have hnx : n ≤ x := (Finset.mem_Icc.mp hnC).2
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
        rw [Nat.le_div_iff_mul_le hpos]
        have hmul : (n / p) * p = n := by
          have hpm : p * (n / p) = n := Nat.mul_div_cancel' hpd
          rw [Nat.mul_comm]
          exact hpm
        omega
      have hmix : (n / p) ∈ (Icc 1 (x / p)) := by
        rw [Finset.mem_Icc]
        exact ⟨h1k, hkx⟩
      exact ⟨n / p, hmix, hm.symm⟩
    · intro himg
      obtain ⟨m, hm, hmux⟩ := himg
      rw [Finset.mem_Icc] at hm
      obtain ⟨hm1, hml⟩ := hm
      have h1nm : 1 ≤ p * m := by
        have h1p : 1 ≤ p := Nat.succ_le_of_lt hpos
        simpa [Nat.one_mul] using Nat.mul_le_mul h1p hm1
      have hle : p * m ≤ x := by
        have hmul : p * m ≤ p * (x / p) := Nat.mul_le_mul_left p hml
        have hsub : p * (x / p) ≤ x := Nat.mul_div_le x p
        exact le_trans hmul hsub
      exact ⟨by
        rw [Finset.mem_Icc]
        exact ⟨by simpa [hmux] using h1nm, by simpa [hmux] using hle⟩,
        ⟨m, hmux.symm⟩⟩
  rw [hbi]
  rw [Finset.card_image_of_injective ((Icc 1 (x / p))) (fun m m' h =>
      Nat.mul_left_cancel hpos h)]
  rw [Nat.card_Icc]
  exact Nat.add_sub_cancel (x / p) 1

/-- (a)  the  single-count  bridge:  sum_n  m(n)  =  sum_p  floor(x  /  p). -/
theorem mcount_single_sum (x : ℕ) (ps : List ℕ)
    (hprime : ∀ p ∈ ps, Nat.Prime p) (hdistinct : ps.Nodup) :
    (∑ n ∈ (Icc 1 x), mcount ps n) = ∑ p ∈ (ps.toFinset), x / p := by
  --  1.  pointwise  rewrite  of  mcount  as  a  0/1  sum:
  have h1 : (∑ n ∈ (Icc 1 x), mcount ps n) =
      (∑ n ∈ (Icc 1 x), ∑ p ∈ (ps.toFinset), if p ∣ n then 1 else 0) := by
    refine Finset.sum_congr rfl (fun n _ => by
      have hm : mcount ps n = #{p ∈ (ps.toFinset) | p ∣ n} := by
        dsimp only [mcount]
      rw [hm]
      simpa using (Finset.sum_boole (fun p : ℕ => p ∣ n) (ps.toFinset)).symm)
  rw [h1]
  --  2.  swap  the  two  sums  (product  reindex  through  the  swap  map):
  set f := (fun (pr : ℕ × ℕ) => (if pr.2 ∣ pr.1 then 1 else 0 : ℕ)) with hf
  have h2 : (∑ n ∈ (Icc 1 x), ∑ p ∈ (ps.toFinset), if p ∣ n then 1 else 0) =
      ∑ pr ∈ (Icc 1 x) ×ˢ (ps.toFinset), f pr := by
    rw [Finset.sum_product (Icc 1 x) (ps.toFinset) (fun pr => f pr), hf]
  have h3 : ∑ pr ∈ (Icc 1 x) ×ˢ (ps.toFinset), f pr =
      (∑ p ∈ (ps.toFinset), ∑ n ∈ (Icc 1 x), if p ∣ n then 1 else 0) := by
    calc ∑ pr ∈ (Icc 1 x) ×ˢ (ps.toFinset), f pr
        _ = ∑ pr ∈ (ps.toFinset) ×ˢ (Icc 1 x), (fun pr => f (Prod.swap pr)) pr :=
          Finset.sum_bij
            (fun pr _ => Prod.swap pr)
            (fun pr hpr => by
              have hmem : pr.1 ∈ (Icc 1 x) ∧ pr.2 ∈ (ps.toFinset) := by simpa using hpr
              exact Finset.mk_mem_product hmem.2 hmem.1)
            (fun a1 _ a2 _ hsw =>
              Prod.ext (congrArg (fun q : ℕ × ℕ => q.2) hsw)
                       (congrArg (fun q : ℕ × ℕ => q.1) hsw))
            (fun b hb => by
              have hmem : b.1 ∈ (ps.toFinset) ∧ b.2 ∈ (Icc 1 x) := by simpa using hb
              exact ⟨(b.2, b.1), Finset.mk_mem_product hmem.2 hmem.1, by simp [Prod.swap]⟩)
            (fun pr _ => by simp [Prod.swap])
        _ = (∑ p ∈ (ps.toFinset), ∑ n ∈ (Icc 1 x), (fun pr => f (Prod.swap pr)) (p, n)) := by
          rw [Finset.sum_product (ps.toFinset) (Icc 1 x) (fun pr => f (Prod.swap pr))]
        _ = (∑ p ∈ (ps.toFinset), ∑ n ∈ (Icc 1 x), if p ∣ n then 1 else 0) := by
          refine Finset.sum_congr rfl (fun p _ => Finset.sum_congr rfl (fun n _ => by
            rw [hf]
            simp [Prod.swap]))
  rw [h2, h3]
  --  3.  inner  n-sum  =  the  card  of  the  p-multiples  =  the  floor:
  refine Finset.sum_congr rfl (fun p hpF => by
    have hpos : 0 < p := by
      have hp' : p ∈ ps := by simpa using hpF
      exact Nat.Prime.pos (hprime p hp')
    calc (∑ n ∈ (Icc 1 x), (if p ∣ n then (1 : ℕ) else 0))
        _ = #{n ∈ (Icc 1 x) | p ∣ n} := by
          simpa using (Finset.sum_boole (fun n : ℕ => p ∣ n))
        _ = ((Icc 1 x).filter (fun n : ℕ => p ∣ n)).card := by rfl
        _ = x / p := card_mulps x p hpos)

/-!  ====  the  off-diagonal  (pairwise)  bridge  ====  -/

/-- The  off-diagonal  of  the  n-covering  set  is  the  ordered-pair  set
    filtered  by  the  common  divisibility. -/
theorem offdiagset_eq_filter_pairs (ps : List ℕ) (n : ℕ) :
    offdiagset ps n = (orderedpairset ps).filter (fun ab => ab.1 ∣ n ∧ ab.2 ∣ n) := by
  ext ab
  rw [offdiagset, orderedpairset]
  simp [Finset.mem_filter, Finset.mem_product]
  constructor
  · intro h
    tauto
  · intro h
    tauto

/-- Pointwise:  m(n)  *  (m(n)  -  1)  is  the  off-diagonal  card  (the  ordered
    distinct-pair  count). -/
theorem offdiag_pointwise (ps : List ℕ) (n : ℕ) :
    (mcount ps n) * ((mcount ps n) - 1) = (offdiagset ps n).card := by
  set F : Finset ℕ := (ps.toFinset).filter (fun p => p ∣ n) with hF
  have hmc : mcount ps n = F.card := by
    dsimp only [mcount]
  by_cases hm0 : mcount ps n = 0
  · --  zero  case:  both  sides  are  0:
    have hF0 : F = ∅ :=
      Finset.card_eq_zero.mp (by rw [← hmc]; exact hm0)
    have hS : ({p ∈ (ps.toFinset) | p ∣ n} : Finset ℕ) = ∅ := by
      rw [← hF]
      exact hF0
    have hoff0 : offdiagset ps n = ∅ := by
      dsimp only [offdiagset, F]
      rw [hS]
      ext ab
      simp
    rw [hm0, hoff0, Finset.card_empty]
  · --  positive  case:  extract  a  witness  from  F:
    have hwit : ∃ a : ℕ, a ∈ F := by
      have hpos : 0 < mcount ps n := by omega
      have hFpos : 0 < F.card := by rw [← hmc]; exact hpos
      exact Finset.card_pos.mp hFpos
    obtain ⟨a, ha⟩ := hwit
    set diag : Finset (ℕ × ℕ) := (F).image (fun a => (a, a)) with hdiag
    have hdiag0 : (F).card = diag.card :=
      (Finset.card_image_of_injective F (fun u v huv =>
         (congrArg (fun t : ℕ × ℕ => t.1) huv))).symm
    have hcardprod : (F ×ˢ F).card = F.card * F.card := Finset.card_product F F
    have hdisj : Disjoint (offdiagset ps n) diag := by
      rw [show offdiagset ps n = (F ×ˢ F).filter (fun ab => ab.1 ≠ ab.2) from by
        dsimp only [offdiagset]]
      rw [Finset.disjoint_left]
      intro ab ho hd
      rw [Finset.mem_image] at hd
      obtain ⟨c, hc, heq⟩ := hd
      rw [← heq] at ho
      rw [Finset.mem_filter] at ho
      have hne : (c, c).1 ≠ (c, c).2 := ho.2
      exact hne rfl
    have hull : (offdiagset ps n) ∪ diag = (F ×ˢ F) := by
      rw [show offdiagset ps n = (F ×ˢ F).filter (fun ab => ab.1 ≠ ab.2) from by
        dsimp only [offdiagset]]
      ext ab
      constructor
      · intro h
        rw [Finset.mem_union] at h
        obtain (ho | hd) := h
        · rw [Finset.mem_filter] at ho
          exact ho.1
        · rw [Finset.mem_image] at hd
          obtain ⟨c, hc, heq⟩ := hd
          rw [← heq]
          exact Finset.mk_mem_product hc hc
      · intro hf
        rw [Finset.mem_union]
        by_cases heq : ab.1 = ab.2
        · right
          rw [Finset.mem_image]
          use ab.1
          exact ⟨(Finset.mem_product.mp hf).1, by
            apply Prod.ext
            · rfl
            · exact heq⟩
        · left
          simpa [Finset.mem_product] using ⟨Finset.mem_product.mp hf, heq⟩
    have hcardunion : (offdiagset ps n).card + diag.card = (F ×ˢ F).card := by
      have hempty : (offdiagset ps n ∩ diag).card = 0 := by
        have hE : (offdiagset ps n ∩ diag) = ∅ := by
          ext ab
          constructor
          · intro hab
            rw [Finset.disjoint_left] at hdisj
            exfalso
            have ho : ab ∈ (offdiagset ps n) := (Finset.mem_inter.mp hab).1
            have hd : ab ∈ diag := (Finset.mem_inter.mp hab).2
            exact hdisj ho hd
          · intro hd0
            exfalso
            have h1 : 1 ≤ (∅ : Finset (ℕ × ℕ)).card := Finset.card_pos.mpr ⟨ab, hd0⟩
            have h0 : (∅ : Finset (ℕ × ℕ)).card = 0 := by rw [Finset.card_empty]
            omega
        rw [hE, Finset.card_empty]
      calc (offdiagset ps n).card + diag.card
          _ = (offdiagset ps n ∪ diag).card := by
            rw [Finset.card_union (offdiagset ps n) diag, hempty, Nat.sub_zero]
          _ = (F ×ˢ F).card := by rw [hull]
    calc (mcount ps n) * ((mcount ps n) - 1)
        _ = F.card * (F.card - 1) := by simp only [hmc]
        _ = (F.card * F.card) - F.card := by
          rw [Nat.mul_sub_left_distrib, Nat.mul_one]
        _ = (F ×ˢ F).card - diag.card := by
          rw [hcardprod, hdiag0]
        _ = (offdiagset ps n).card := by
          rw [← hcardunion]
          omega

/-- (b)  the  off-diagonal  (pairwise)  bridge:
      sum_n  m(n)(m(n)  -  1)  =  the  ordered-pair  floor  sum. -/
theorem mcount_offdiag_sum (x : ℕ) (ps : List ℕ)
    (hprime : ∀ p ∈ ps, Nat.Prime p) (hdistinct : ps.Nodup) :
    (∑ n ∈ (Icc 1 x), mcount ps n * (mcount ps n - 1)) =
      ∑ ab ∈ (orderedpairset ps), x / (ab.1 * ab.2) := by
  --  1.  pointwise  m(m  -  1)  =  the  off-diagonal  card:
  have h1 : (∑ n ∈ (Icc 1 x), mcount ps n * (mcount ps n - 1)) =
      (∑ n ∈ (Icc 1 x), (offdiagset ps n).card) := by
    refine Finset.sum_congr rfl (fun n _ => offdiag_pointwise ps n)
  rw [h1]
  --  2.  the  off-diagonal  card  =  the  0/1  sum  over  the  ordered  pairs:
  have h2 : (∑ n ∈ (Icc 1 x), (offdiagset ps n).card) =
      (∑ n ∈ (Icc 1 x), ∑ ab ∈ (orderedpairset ps),
         if ab.1 ∣ n ∧ ab.2 ∣ n then 1 else 0) := by
    refine Finset.sum_congr rfl (fun n _ => by
      have hF : (offdiagset ps n) = (orderedpairset ps).filter (fun ab => ab.1 ∣ n ∧ ab.2 ∣ n) :=
        offdiagset_eq_filter_pairs ps n
      rw [hF]
      simpa [Finset.filter] using (Finset.sum_boole (fun ab : ℕ × ℕ => ab.1 ∣ n ∧ ab.2 ∣ n)).symm
    )
  rw [h2]
  --  3.  swap  the  sums  (n  <->  ab)  through  the  swap  bijection:
  set B := (fun (ab : ℕ × ℕ) (n : ℕ) => (if ab.1 ∣ n ∧ ab.2 ∣ n then 1 else 0 : ℕ)) with hB
  have h2b : (∑ n ∈ (Icc 1 x), ∑ ab ∈ (orderedpairset ps),
          (if ab.1 ∣ n ∧ ab.2 ∣ n then 1 else 0)) =
      (∑ n ∈ (Icc 1 x), ∑ ab ∈ (orderedpairset ps), B ab n) := by
    rw [← Finset.sum_product (Icc 1 x) (orderedpairset ps) (fun pr => B pr.2 pr.1)]
  rw [h2b]
  have h3 : (∑ n ∈ (Icc 1 x), ∑ ab ∈ (orderedpairset ps), B ab n) =
      (∑ ab ∈ (orderedpairset ps), ∑ n ∈ (Icc 1 x), B ab n) := by
    calc (∑ n ∈ (Icc 1 x), ∑ ab ∈ (orderedpairset ps), B ab n)
        _ = ∑ pr ∈ (Icc 1 x) ×ˢ (orderedpairset ps), (fun pr => B pr.2 pr.1) pr := by
          rw [Finset.sum_product (Icc 1 x) (orderedpairset ps) (fun pr => B pr.2 pr.1)]
        _ = ∑ pr ∈ (orderedpairset ps) ×ˢ (Icc 1 x), (fun pr => B pr.1 pr.2) pr :=
          Finset.sum_bij
            (fun pr _ => Prod.swap pr)
            (fun pr hpr => by
              have hmem : pr.1 ∈ (Icc 1 x) ∧ pr.2 ∈ (orderedpairset ps) := by simpa using hpr
              exact Finset.mk_mem_product hmem.2 hmem.1)
            (fun a1 _ a2 _ hsw => by
              have h1 : a1.swap = (a1.2, a1.1) := by simp [Prod.swap]
              have h2 : a2.swap = (a2.2, a2.1) := by simp [Prod.swap]
              rw [h1, h2] at hsw
              exact Prod.ext (congrArg (fun q => q.2) hsw)
                              (congrArg (fun q => q.1) hsw))
            (fun b hb => by
              have hmem : b.1 ∈ (orderedpairset ps) ∧ b.2 ∈ (Icc 1 x) := by simpa using hb
              exact ⟨(b.2, b.1), Finset.mk_mem_product hmem.2 hmem.1, by simp [Prod.swap]⟩)
            (fun pr _ => by simp [Prod.swap])
        _ = (∑ ab ∈ (orderedpairset ps), ∑ n ∈ (Icc 1 x), B ab n) := by
          rw [Finset.sum_product (orderedpairset ps) (Icc 1 x) (fun pr => B pr.1 pr.2)]
  rw [h3]
  --  4.  the  inner  n-sum  =  the  floor  x  /  (ab.1  *  ab.2):
  refine Finset.sum_congr rfl (fun ab habP => by
    have hmemb : ab ∈ ((ps.toFinset) ×ˢ (ps.toFinset)).filter (fun ab => ab.1 ≠ ab.2) := by
      simpa [orderedpairset] using habP
    have hpsF : ab.1 ∈ (ps.toFinset) ∧ ab.2 ∈ (ps.toFinset) :=
      Finset.mem_product.mp (Finset.mem_filter.mp hmemb).1
    have hp' : ab.1 ∈ ps := by simpa using hpsF.1
    have hq' : ab.2 ∈ ps := by simpa using hpsF.2
    have hpp : Nat.Prime ab.1 := hprime ab.1 hp'
    have hqq : Nat.Prime ab.2 := hprime ab.2 hq'
    --  the  common-divisibility  condition  =  divisibility  by  the  product
    --  (distinct  primes  are  coprime):
    have hiff : ∀ n, (ab.1 ∣ n ∧ ab.2 ∣ n) ↔ (ab.1 * ab.2 ∣ n) := by
      intro n
      constructor
      · rintro ⟨h1, h2⟩
        obtain ⟨k, hk⟩ := h1
        rw [hk] at h2
        have hd : ab.2 ∣ ab.1 ∨ ab.2 ∣ k := (Nat.Prime.dvd_mul hqq).mp h2
        cases hd with
        | inl hdiv1 =>
          have hq1 : ab.2 = 1 ∨ ab.2 = ab.1 :=
            (Nat.Prime.eq_one_or_self_of_dvd hpp) ab.2 hdiv1
          cases hq1 with
          | inl hone => exact False.elim (Nat.Prime.ne_one hqq hone)
          | inr heq =>
            have hne : ab.1 ≠ ab.2 := by
              have h12 : (ab.1 ∈ (ps.toFinset) ∧ ab.2 ∈ (ps.toFinset)) ∧ ab.1 ≠ ab.2 := by
                simpa using hmemb
              exact h12.2
            exact False.elim (hne heq.symm)
        | inr hdiv2 =>
          obtain ⟨j, hj⟩ := hdiv2
          use j
          rw [hk, hj]
          exact (Nat.mul_assoc ab.1 (ab.2) j).symm
      · intro hb
        have h1 : ab.1 ∣ n := Nat.dvd_trans (Nat.dvd_mul_right ab.1 ab.2) hb
        have h2 : ab.2 ∣ n := Nat.dvd_trans (Nat.dvd_mul_left ab.2 ab.1) hb
        exact ⟨h1, h2⟩
    have hpos : 0 < ab.1 * ab.2 := Nat.mul_pos (Nat.Prime.pos hpp) (Nat.Prime.pos hqq)
    have hsum1 : (∑ n ∈ (Icc 1 x), B ab n) =
        (∑ n ∈ (Icc 1 x), (if ab.1 ∣ n ∧ ab.2 ∣ n then 1 else 0)) := by
      refine Finset.sum_congr rfl (fun n0 _ => by simp [hB])
    have hsum2 : (∑ n ∈ (Icc 1 x), (if ab.1 ∣ n ∧ ab.2 ∣ n then 1 else 0)) =
        (∑ n ∈ (Icc 1 x), (if ab.1 * ab.2 ∣ n then 1 else 0)) := by
      refine Finset.sum_congr rfl (fun n0 _ => by
        by_cases hr : ab.1 * ab.2 ∣ n0
        · simpa [hiff n0, hr] using (by
            have hpq : ab.1 ∣ n0 ∧ ab.2 ∣ n0 := (hiff n0).mpr hr
            simp [hpq, hr])
        · by_cases hpq : ab.1 ∣ n0 ∧ ab.2 ∣ n0
          · have hr' : ab.1 * ab.2 ∣ n0 := (hiff n0).mp hpq
            simpa [hr', hpq] using (by norm_num)
          · simpa [hpq, hr] using (by norm_num))
    calc (∑ n ∈ (Icc 1 x), B ab n)
        _ = (∑ n ∈ (Icc 1 x), (if ab.1 ∣ n ∧ ab.2 ∣ n then 1 else 0)) := hsum1
        _ = (∑ n ∈ (Icc 1 x), (if ab.1 * ab.2 ∣ n then 1 else 0)) := hsum2
        _ = #{n ∈ (Icc 1 x) | ab.1 * ab.2 ∣ n} := by
          simpa using (Finset.sum_boole (fun n : ℕ => ab.1 * ab.2 ∣ n))
        _ = ((Icc 1 x).filter (fun n : ℕ => ab.1 * ab.2 ∣ n)).card := by rfl
        _ = x / (ab.1 * ab.2) := card_mulps x (ab.1 * ab.2) hpos)

/-!  ====  the  ordered  /  unordered  pair  decomposition  ====  -/

/-- The  ordered  distinct  pairs  split  into  the  unordered  half  and  its
    swap. -/
theorem ordered_parts (ps : List ℕ) :
    orderedpairset ps = (pairset ps) ∪ ((pairset ps).image (Prod.swap)) := by
  ext ab
  simp [orderedpairset, pairset]
  constructor
  · rintro ⟨hA, hne⟩
    by_cases hlt : ab.1 < ab.2
    · left
      exact ⟨hA, hlt⟩
    · have hle2 : ab.2 ≤ ab.1 := Nat.le_of_not_lt hlt
      have hlt2 : ab.2 < ab.1 := Nat.lt_of_le_of_ne hle2 (by
        intro h
        exact hne (Eq.symm h))
      right
      use ab.2, ab.1
      exact ⟨⟨⟨hA.2, hA.1⟩, hlt2⟩, rfl⟩
  · rintro (hL | hR)
    case inl =>
      exact ⟨hL.1, fun h => by
        have h2 : ab.1 < ab.1 := by simpa [show ab.1 = ab.2 from h] using hL.2
        exact Nat.lt_irrefl ab.1 h2⟩
    case inr =>
      obtain ⟨aa, bb, hab, heq⟩ := hR
      obtain ⟨⟨ha, hb⟩, hlt⟩ := hab
      have hne : bb ≠ aa := by
        intro h
        have h1 : aa < aa := by simpa [show aa = bb from h.symm] using hlt
        exact Nat.lt_irrefl aa h1
      rw [show ab = (bb, aa) from (heq : (bb, aa) = ab).symm]
      exact ⟨⟨hb, ha⟩, hne⟩

/-- The  disjointness  of  the  unordered  half  and  its  swap. -/
theorem ordered_parts_disjoint (ps : List ℕ) :
    Disjoint (pairset ps) ((pairset ps).image (Prod.swap)) := by
  rw [Finset.disjoint_left]
  intro ab hL hR
  obtain ⟨hLm, hLlt⟩ := by simpa [pairset] using hL
  rw [Finset.mem_image] at hR
  obtain ⟨c, hRc⟩ := hR
  obtain ⟨hc, heq⟩ := hRc
  obtain ⟨hcm, hclt⟩ := by simpa [pairset] using hc
  have h11 : ab.1 = c.2 :=
    (congrArg (fun t : ℕ × ℕ => t.1) heq).symm
  have h12 : ab.2 = c.1 :=
    (congrArg (fun t : ℕ × ℕ => t.2) heq).symm
  have hA : ab.1 < c.1 := by simpa [h12] using hLlt
  have hB : c.1 < ab.1 := by simpa [h11] using hclt
  exact Nat.lt_irrefl ab.1 (Nat.lt_trans hA hB)

/-- The  sum  over  the  ordered  pairs  is  twice  the  sum  over  the
    unordered  ones  (the  summand  is  symmetric  in  the  two  primes). -/
theorem ordered_eq_two_pair (x : ℕ) (ps : List ℕ) :
    (∑ ab ∈ (orderedpairset ps), x / (ab.1 * ab.2)) =
      2 * (∑ ab ∈ (pairset ps), x / (ab.1 * ab.2)) := by
  calc (∑ ab ∈ (orderedpairset ps), x / (ab.1 * ab.2))
      _ = (∑ ab ∈ (pairset ps) ∪ ((pairset ps).image (Prod.swap)),
             (x / (ab.1 * ab.2))) := by
        rw [ordered_parts]
      _ = (∑ ab ∈ (pairset ps), x / (ab.1 * ab.2)) +
          (∑ ab ∈ (pairset ps).image (Prod.swap), x / (ab.1 * ab.2)) := by
        rw [Finset.sum_union (ordered_parts_disjoint ps)]
      _ = (∑ ab ∈ (pairset ps), x / (ab.1 * ab.2)) +
          (∑ ab ∈ (pairset ps), (x / ((Prod.swap ab).1 * (Prod.swap ab).2))) := by
        congr 1
        have hInjOn : Set.InjOn Prod.swap
            (show Set (ℕ × ℕ) from (pairset ps)) := by
          intro a _ b _ heq
          exact Prod.ext (congrArg (fun q : ℕ × ℕ => q.2) heq)
                         (congrArg (fun q : ℕ × ℕ => q.1) heq)
        rw [Finset.sum_image hInjOn]
      _ = (∑ ab ∈ (pairset ps), x / (ab.1 * ab.2)) +
          (∑ ab ∈ (pairset ps), x / (ab.2 * ab.1)) := by
        have hswap : (∑ ab ∈ (pairset ps), x / ((Prod.swap ab).1 * (Prod.swap ab).2)) =
            (∑ ab ∈ (pairset ps), x / (ab.2 * ab.1)) := by
          refine Finset.sum_congr rfl (fun ab _ => by
            have h1 : (Prod.swap ab).1 = ab.2 := by simp [Prod.swap]
            have h2 : (Prod.swap ab).2 = ab.1 := by simp [Prod.swap]
            rw [h1, h2])
        rw [hswap]
      _ = 2 * (∑ ab ∈ (pairset ps), x / (ab.1 * ab.2)) := by
        have hsym : (∑ ab ∈ (pairset ps), (x / (ab.2 * ab.1))) =
            (∑ ab ∈ (pairset ps), x / (ab.1 * ab.2)) := by
          refine Finset.sum_congr rfl (fun ab _ => by
            rw [show x / (ab.2 * ab.1) = x / (ab.1 * ab.2) from by rw [Nat.mul_comm]])
        rw [hsym]
        ring

/-!  ====  the  pointwise  slacks  ====  -/

/-- The  pointwise  lower-bound  slack:  1_{m  =  0}  -  1  +  m  (in  Z).
    It  vanishes  exactly  at  m  =  0  and  m  =  1. -/
def slack_t (m : ℕ) : ℤ :=
  (if m = 0 then (1 : ℤ) else 0) - 1 + (m : ℤ)

/-- The  pointwise  lower-bound  slack  is  non-negative. -/
theorem slack_t_nonneg (m : ℕ) : 0 ≤ slack_t m := by
  cases m with
  | zero =>
    dsimp only [slack_t]
    norm_num
  | succ k =>
    dsimp only [slack_t]
    have hite : (if (Nat.succ k = 0) then (1 : ℤ) else 0) = 0 := by
      rw [if_neg (Nat.succ_ne_zero k)]
    rw [hite]
    have hkz : ((0 : ℤ) - 1 + (Nat.succ k : ℤ)) = (k : ℤ) := by
      have h1 : (Nat.succ k : ℤ) = (k : ℤ) + 1 := by norm_cast
      rw [h1]
      ring
    rw [hkz]
    exact Nat.cast_nonneg k

/-- The  pointwise  doubled  upper-bound  slack:
    m(m  -  1)  -  2m  +  2  -  2 * 1_{m  =  0}  (in  Z).
    It  vanishes  exactly  at  m  =  0,  1,  2  (and  equals
    (m  -  1)(m  -  2)  for  m  ≥  1). -/
def slack_s (m : ℕ) : ℤ :=
  (m : ℤ) * ((m : ℤ) - 1) - 2 * (m : ℤ) + 2 - 2 * (if m = 0 then (1 : ℤ) else 0)

/-- The  pointwise  doubled  upper-bound  slack  is  non-negative. -/
theorem slack_s_nonneg (m : ℕ) : 0 ≤ slack_s m := by
  dsimp only [slack_s]
  by_cases hm0 : m = 0
  · subst hm0
    norm_num
  · by_cases hm2 : m ≤ 2
    · have hm01 : m = 1 ∨ m = 2 := by omega
      rcases hm01 with (rfl | rfl) <;> norm_num
    · have hm3 : 3 ≤ m := by omega
      rw [show (if m = 0 then (1 : ℤ) else 0) = 0 from by simpa using hm0]
      have hf2 : (m : ℤ) * ((m : ℤ) - 1) - 2 * (m : ℤ) + 2 =
          ((m : ℤ) - 1) * ((m : ℤ) - 2) := by ring
      have h1 : 0 ≤ (m : ℤ) - 1 := by
        apply Int.sub_nonneg.mpr
        norm_cast
        omega
      have h2 : 0 ≤ (m : ℤ) - 2 := by
        apply Int.sub_nonneg.mpr
        norm_cast
        omega
      rw [hf2, show (2 : ℤ) * 0 = 0 from by ring, sub_zero]
      exact mul_nonneg h1 h2

/-!  ====  the  level-1  exact  sandwich  (the  main  theorem)  ====  -/

/-- The  integer-form  cardinality  bridge:  x  =  the  sum  of  ones  over
    [1,  x]. -/
private theorem x_ones_sum (x : ℕ) : (x : ℤ) = (∑ n ∈ (Icc 1 x), (1 : ℤ)) := by
  have h1 : (∑ n ∈ (Icc 1 x), (1 : ℤ)) = ((Icc 1 x).card : ℤ) := by
    rw [Finset.sum_const (1 : ℤ)]
    simp
  have h2 : ((Icc 1 x).card : ℤ) = (x : ℤ) := by
    norm_cast
    rw [Nat.card_Icc]
    omega
  calc (x : ℤ)
      _ = ((Icc 1 x).card : ℤ) := h2.symm
      _ = (∑ n ∈ (Icc 1 x), (1 : ℤ)) := h1.symm

/-- The  integer-form  single-count  bridge:  the  floor  sum  =  the
    covering-count  sum  (over  the  integers). -/
private theorem mcount_single_sum_Z (x : ℕ) (ps : List ℕ)
    (hprime : ∀ p ∈ ps, Nat.Prime p) (hdistinct : ps.Nodup) :
    (∑ p ∈ (ps.toFinset), Int.ofNat (x / p)) =
      (∑ n ∈ (Icc 1 x), (mcount ps n : ℤ)) := by
  calc (∑ p ∈ (ps.toFinset), Int.ofNat (x / p))
      _ = (∑ p ∈ (ps.toFinset), (x / p) : ℤ) := by
        refine Finset.sum_congr rfl (fun _ _ => rfl)
      _ = (∑ n ∈ (Icc 1 x), mcount ps n : ℤ) := by
        norm_cast
        rw [mcount_single_sum x ps hprime hdistinct]
      _ = (∑ n ∈ (Icc 1 x), (mcount ps n : ℤ)) := by norm_cast

/-- The  integer-form  off-diagonal  bridge:  the  doubled  pairwise  mass  =
    the  ordered  pair-count  sum. -/
private theorem mcount_offdiag_sum_Z (x : ℕ) (ps : List ℕ)
    (hprime : ∀ p ∈ ps, Nat.Prime p) (hdistinct : ps.Nodup) :
    (2 : ℤ) * (U2pair x ps) =
      (∑ n ∈ (Icc 1 x), (mcount ps n * (mcount ps n - 1) : ℤ)) := by
  calc (2 : ℤ) * (U2pair x ps)
      _ = (2 : ℤ) * (∑ ab ∈ (pairset ps), (x / (ab.1 * ab.2)) : ℤ) := by
        rw [show (U2pair x ps) = (∑ ab ∈ (pairset ps), (x / (ab.1 * ab.2)) : ℤ) from by
          dsimp only [U2pair]
          refine Finset.sum_congr rfl (fun _ _ => rfl)]
      _ = (∑ ab ∈ (orderedpairset ps), (x / (ab.1 * ab.2)) : ℤ) := by
        show (2 : ℤ) * (∑ ab ∈ (pairset ps), (x / (ab.1 * ab.2)) : ℤ) =
             (∑ ab ∈ (orderedpairset ps), (x / (ab.1 * ab.2)) : ℤ)
        norm_cast
        rw [← ordered_eq_two_pair x ps]
      _ = (∑ n ∈ (Icc 1 x), (mcount ps n * (mcount ps n - 1) : ℤ)) := by
        have hL : (∑ ab ∈ (orderedpairset ps), (x / (ab.1 * ab.2)) : ℤ) =
            (∑ ab ∈ (orderedpairset ps), Nat.cast (x / (ab.1 * ab.2))) := by
          refine Finset.sum_congr rfl (fun ab _ => by norm_cast)
        rw [hL]
        have hR : (∑ n ∈ (Icc 1 x), (mcount ps n * (mcount ps n - 1) : ℤ)) =
            (∑ n ∈ (Icc 1 x), Nat.cast (mcount ps n * (mcount ps n - 1))) := by
          refine Finset.sum_congr rfl (fun n _ => by
            by_cases hm : mcount ps n = 0
            · rw [hm]
              norm_num
            · have hm1 : 1 ≤ mcount ps n := by omega
              have hsub : Nat.cast (mcount ps n - 1) = (mcount ps n : ℤ) - 1 :=
                Int.ofNat_sub hm1
              have hmul : Nat.cast (mcount ps n * (mcount ps n - 1)) =
                  (mcount ps n : ℤ) * Nat.cast (mcount ps n - 1) := by
                norm_cast
              rw [hmul, hsub])
        rw [hR]
        rw [← Nat.cast_sum, ← Nat.cast_sum]
        rw [← mcount_offdiag_sum x ps hprime hdistinct]

/-- The  level-1  lower  bound  (exact):  L1  <=  phi. -/
theorem level1_lower (x : ℕ) (ps : List ℕ)
    (hprime : ∀ p ∈ ps, Nat.Prime p) (hdistinct : ps.Nodup) :
    L1 x ps ≤ (phi_list x ps : ℤ) := by
  have hphi : (phi_list x ps : ℤ) =
      (∑ n ∈ (Icc 1 x), if mcount ps n = 0 then (1 : ℤ) else 0) :=
    phi_indicator x ps hprime hdistinct
  have hsum : (∑ p ∈ (ps.toFinset), Int.ofNat (x / p)) =
      (∑ n ∈ (Icc 1 x), (mcount ps n : ℤ)) :=
    mcount_single_sum_Z x ps hprime hdistinct
  --  L1  =  sum_n  (1  -  m(n)):
  have hL1 : L1 x ps = (∑ n ∈ (Icc 1 x), (1 : ℤ)) - (∑ n ∈ (Icc 1 x), (mcount ps n : ℤ)) := by
    rw [L1, x_ones_sum, hsum]
  --  phi  =  L1  +  the  summed  pointwise  slack_t:
  have hsl : (∑ n ∈ (Icc 1 x), slack_t (mcount ps n)) =
      (∑ n ∈ (Icc 1 x), ((if mcount ps n = 0 then (1 : ℤ) else 0) - 1 + (mcount ps n : ℤ))) := by
    refine Finset.sum_congr rfl (fun n _ => by dsimp only [slack_t])
  have hphiL : (phi_list x ps : ℤ) =
      L1 x ps + (∑ n ∈ (Icc 1 x), slack_t (mcount ps n)) := by
    rw [hphi]
    calc (∑ n ∈ (Icc 1 x), (if mcount ps n = 0 then (1 : ℤ) else 0))
        _ = (∑ n ∈ (Icc 1 x),
             ((1 : ℤ) - (mcount ps n : ℤ) +
               ((if mcount ps n = 0 then (1 : ℤ) else 0) - 1 + (mcount ps n : ℤ)))) := by
          refine Finset.sum_congr rfl (fun n _ => by ring)
        _ = (∑ n ∈ (Icc 1 x), ((1 : ℤ) - (mcount ps n : ℤ))) +
            (∑ n ∈ (Icc 1 x), ((if mcount ps n = 0 then (1 : ℤ) else 0) - 1 + (mcount ps n : ℤ))) := by
          rw [Finset.sum_add_distrib (s := (Icc 1 x))]
        _ = ((∑ n ∈ (Icc 1 x), (1 : ℤ)) - (∑ n ∈ (Icc 1 x), (mcount ps n : ℤ))) +
            (∑ n ∈ (Icc 1 x), ((if mcount ps n = 0 then (1 : ℤ) else 0) - 1 + (mcount ps n : ℤ))) := by
          rw [Finset.sum_sub_distrib (s := (Icc 1 x))]
        _ = ((∑ n ∈ (Icc 1 x), (1 : ℤ)) - (∑ n ∈ (Icc 1 x), (mcount ps n : ℤ))) +
            (∑ n ∈ (Icc 1 x), slack_t (mcount ps n)) := by
          rw [hsl.symm]
        _ = L1 x ps + (∑ n ∈ (Icc 1 x), slack_t (mcount ps n)) := by
          rw [hL1]
  have hnonneg : 0 ≤ (∑ n ∈ (Icc 1 x), slack_t (mcount ps n)) := by
    apply Finset.sum_nonneg
    intro n _
    exact slack_t_nonneg (mcount ps n)
  have hsumge : (phi_list x ps : ℤ) ≥ L1 x ps := by
    rw [hphiL]
    exact le_add_of_nonneg_right hnonneg
  exact hsumge

/-- The  level-1  upper  bound  (exact):  phi  <=  U2. -/
theorem level1_upper (x : ℕ) (ps : List ℕ)
    (hprime : ∀ p ∈ ps, Nat.Prime p) (hdistinct : ps.Nodup) :
    (phi_list x ps : ℤ) ≤ U2 x ps := by
  have hphi : (phi_list x ps : ℤ) =
      (∑ n ∈ (Icc 1 x), if mcount ps n = 0 then (1 : ℤ) else 0) :=
    phi_indicator x ps hprime hdistinct
  have hsum : (∑ p ∈ (ps.toFinset), Int.ofNat (x / p)) =
      (∑ n ∈ (Icc 1 x), (mcount ps n : ℤ)) :=
    mcount_single_sum_Z x ps hprime hdistinct
  have hU2pair : (2 : ℤ) * (U2pair x ps) =
      (∑ n ∈ (Icc 1 x), (mcount ps n * (mcount ps n - 1) : ℤ)) :=
    mcount_offdiag_sum_Z x ps hprime hdistinct
  have h2x : (2 : ℤ) * (x : ℤ) = (∑ n ∈ (Icc 1 x), (2 : ℤ)) := by
    calc (2 : ℤ) * (x : ℤ)
        _ = (2 : ℤ) * (∑ n ∈ (Icc 1 x), (1 : ℤ)) := by rw [← x_ones_sum x]
        _ = (∑ n ∈ (Icc 1 x), (2 : ℤ) * (1 : ℤ)) := by
          rw [Finset.mul_sum (Icc 1 x) (fun _ => (1 : ℤ)) (2 : ℤ)]
        _ = (∑ n ∈ (Icc 1 x), (2 : ℤ)) := by
          refine Finset.sum_congr rfl (fun n _ => by norm_num)
  have h2sum : (2 : ℤ) * (∑ p ∈ (ps.toFinset), Int.ofNat (x / p)) =
      (∑ n ∈ (Icc 1 x), 2 * (mcount ps n : ℤ)) := by
    calc (2 : ℤ) * (∑ p ∈ (ps.toFinset), Int.ofNat (x / p))
        _ = (2 : ℤ) * (∑ n ∈ (Icc 1 x), (mcount ps n : ℤ)) := by rw [hsum]
        _ = (∑ n ∈ (Icc 1 x), 2 * (mcount ps n : ℤ)) := by
          rw [Finset.mul_sum (Icc 1 x) (fun n => (mcount ps n : ℤ)) (2 : ℤ)]
  --  2  *  (U2  -  phi)  =  the  summed  doubled  pointwise  slack  slack_s:
  have hU2phi : (2 : ℤ) * (U2 x ps - (phi_list x ps : ℤ)) =
      (∑ n ∈ (Icc 1 x), slack_s (mcount ps n)) := by
    calc (2 : ℤ) * (U2 x ps - (phi_list x ps : ℤ))
        _ = (2 : ℤ) * (L1 x ps + U2pair x ps) -
            (2 : ℤ) * (∑ n ∈ (Icc 1 x), (if mcount ps n = 0 then (1 : ℤ) else 0)) := by
          rw [U2, hphi]
          ring
        _ = ((2 : ℤ) * ((x : ℤ) - (∑ p ∈ (ps.toFinset), Int.ofNat (x / p)))) +
            (2 : ℤ) * (U2pair x ps) -
            (2 : ℤ) * (∑ n ∈ (Icc 1 x), (if mcount ps n = 0 then (1 : ℤ) else 0)) := by
          rw [L1]
          ring
        _ = ((2 : ℤ) * (x : ℤ) - (2 : ℤ) * (∑ p ∈ (ps.toFinset), Int.ofNat (x / p))) +
            (∑ n ∈ (Icc 1 x), (mcount ps n * (mcount ps n - 1) : ℤ)) -
            (2 : ℤ) * (∑ n ∈ (Icc 1 x), (if mcount ps n = 0 then (1 : ℤ) else 0)) := by
          rw [show (2 : ℤ) * ((x : ℤ) - (∑ p ∈ (ps.toFinset), Int.ofNat (x / p))) =
                  (2 : ℤ) * (x : ℤ) - (2 : ℤ) * (∑ p ∈ (ps.toFinset), Int.ofNat (x / p))
              from by ring,
              hU2pair]
        _ = ((2 : ℤ) * (x : ℤ) - (2 : ℤ) * (∑ p ∈ (ps.toFinset), Int.ofNat (x / p))) +
            (∑ n ∈ (Icc 1 x), (mcount ps n * (mcount ps n - 1) : ℤ)) -
            (∑ n ∈ (Icc 1 x), 2 * (if mcount ps n = 0 then (1 : ℤ) else 0)) := by
          rw [Finset.mul_sum (Icc 1 x) (fun n => (if mcount ps n = 0 then (1 : ℤ) else 0)) (2 : ℤ)]
        _ = ((∑ n ∈ (Icc 1 x), (2 : ℤ)) -
              (∑ n ∈ (Icc 1 x), 2 * (mcount ps n : ℤ))) +
            (∑ n ∈ (Icc 1 x), (mcount ps n * (mcount ps n - 1) : ℤ)) -
            (∑ n ∈ (Icc 1 x), 2 * (if mcount ps n = 0 then (1 : ℤ) else 0)) := by
          rw [h2x, h2sum]
        _ = (∑ n ∈ (Icc 1 x), slack_s (mcount ps n)) := by
          --  regroup  pointwise:  2  -  2m  +  m(m  -  1)  -  2*ite  =  slack_s  m:
          set f2 : ℕ → ℤ := fun n => 2 * (mcount ps n : ℤ) with hf2
          have h1 : (∑ n ∈ (Icc 1 x), ((2 : ℤ) - f2 n)) =
              ((∑ n ∈ (Icc 1 x), (2 : ℤ)) - (∑ n ∈ (Icc 1 x), f2 n)) := by
            rw [Finset.sum_sub_distrib]
          rw [← h1]
          have h2 : (∑ n ∈ (Icc 1 x), ((2 : ℤ) - f2 n)) +
              (∑ n ∈ (Icc 1 x), (mcount ps n * (mcount ps n - 1) : ℤ)) =
              (∑ n ∈ (Icc 1 x),
                ((2 : ℤ) - f2 n + (mcount ps n * (mcount ps n - 1) : ℤ))) := by
            rw [Finset.sum_add_distrib]
          rw [h2]
          set f3 : ℕ → ℤ :=
            fun n => (2 : ℤ) - f2 n + (mcount ps n * (mcount ps n - 1) : ℤ) with hf3
          set it2 : ℕ → ℤ :=
            fun n => 2 * (if mcount ps n = 0 then (1 : ℤ) else 0) with hit2
          have h3 : (∑ n ∈ (Icc 1 x), f3 n) - (∑ n ∈ (Icc 1 x), it2 n) =
              (∑ n ∈ (Icc 1 x), (f3 n - it2 n)) := by
            rw [← Finset.sum_sub_distrib]
          rw [h3]
          refine Finset.sum_congr rfl (fun n _ => by
            dsimp only [slack_s, f2, f3, it2]
            have hcast : ((mcount ps n * (mcount ps n - 1)) : ℤ) =
                (mcount ps n : ℤ) * ((mcount ps n : ℤ) - 1) := by
              rfl
            rw [hcast]
            ring)
  have hnonneg : 0 ≤ (∑ n ∈ (Icc 1 x), slack_s (mcount ps n)) := by
    apply Finset.sum_nonneg
    intro n _
    exact slack_s_nonneg (mcount ps n)
  have h2U : 0 ≤ (2 : ℤ) * (U2 x ps - (phi_list x ps : ℤ)) := by
    rw [hU2phi]
    exact hnonneg
  have hU : 0 ≤ U2 x ps - (phi_list x ps : ℤ) := by
    by_contra hn
    have hlt : (2 : ℤ) * (U2 x ps - (phi_list x ps : ℤ)) < 0 := by linarith
    linarith
  linarith

/-- The  level-1  exact  sandwich  (the  main  theorem  of  this  unit  -  the
    discrete  level-1  upper/lower  sieve  property  measured  in  0181):

      L1(x,  ps)  <=  phi(x,  ps)  <=  U2(x,  ps)

    for  every  x  and  every  distinct-prime  list  ps. -/
theorem level1_sandwich (x : ℕ) (ps : List ℕ)
    (hprime : ∀ p ∈ ps, Nat.Prime p) (hdistinct : ps.Nodup) :
    L1 x ps ≤ (phi_list x ps : ℤ) ∧ (phi_list x ps : ℤ) ≤ U2 x ps := by
  exact ⟨level1_lower x ps hprime hdistinct, level1_upper x ps hprime hdistinct⟩

/-!  ====  U4(c):  structural  parity/anchor  statement  (structural,
                     not  a  barrier  theorem)  ====  -/

/-
U4(c)  structural:  the  parity/anchor  correspondence  for  the
level-1  band  (0181  measured  anchors).  The  parity  side  is
the  band  itself  (odd  partial  IE  =  lower  =  L1,  even
partial  IE  =  upper  =  U2  -  level1_sandwich).  The  anchor
side:  the  width  W  =  U2  -  L1  is  exactly  the  pairwise
mass  (the  x  term  and  the  single-prime  terms  cancel
between  the  two  endpoints),  W  >=  0,  and  the  exact  count
sits  inside  the  band  at  a  measurable  position  0  <=
Phi  -  L1  <=  W.  The  0181  measured  numbers  (W  /  (x  V(z))
=  2.10  at  z  =  7  ->  10.12  at  z  =  71;  the  position
rho  =  (Phi  -  L1)  /  W  =  0.84  ->  0.67,  x-stable  and
z-decaying,  above  the  midpoint  at  reachable  z)  are  the
measured  anchors  for  these  statements.  STRUCTURAL,  NOT  A
BARRIER  THEOREM.  No  RH  claim.
-/

/-- (U4c,  structural)  The  level-1  band  width  is  exactly  the
    pairwise  mass:  W  =  U2  -  L1  =  U2pair  (the
    unordered-pair  floor  sum)  -  the  x  term  and  the
    single-prime  terms  cancel  between  the  two  endpoints.
    The  theorem-form  backbone  of  the  0181  width  number.
    Structural,  not  a  barrier  theorem. -/
theorem level1_width_eq_pairwise (x : ℕ) (ps : List ℕ) :
    U2 x ps - L1 x ps = U2pair x ps := by
  rw [U2]
  ring

/-- (U4c,  structural)  The  band  width  is  non-negative  (a  sum  of
    floors).  Structural,  not  a  barrier  theorem. -/
theorem level1_width_nonneg (x : ℕ) (ps : List ℕ) :
    0 ≤ U2 x ps - L1 x ps := by
  rw [level1_width_eq_pairwise x ps]
  refine Finset.sum_nonneg fun ab _ => by
    rw [show Int.ofNat (x / (ab.1 * ab.2)) = (x / (ab.1 * ab.2) : ℤ)
        from by norm_cast]
    exact Nat.cast_nonneg _

/-- (U4c,  structural)  The  exact  count  sits  inside  the  band  at
    a  measurable  position:  0  <=  Phi  -  L1  <=  W.  The  0181
    measured  position  rho  =  (Phi  -  L1)  /  W  (0.84  ->  0.67,
    x-stable  and  z-decaying,  above  the  midpoint  at  reachable
    z)  is  the  measured  anchor  for  this  statement.  Corollary
    of  the  sandwich;  structural,  not  a  barrier  theorem. -/
theorem level1_position_in_band (x : ℕ) (ps : List ℕ)
    (hprime : ∀ p ∈ ps, Nat.Prime p) (hdistinct : ps.Nodup) :
    0 ≤ (phi_list x ps : ℤ) - L1 x ps ∧
      (phi_list x ps : ℤ) - L1 x ps ≤ U2 x ps - L1 x ps := by
  obtain ⟨hl, hu⟩ := level1_sandwich x ps hprime hdistinct
  constructor
  · exact sub_nonneg.mpr hl
  · exact sub_le_sub_right hu (L1 x ps)

/-!  ====  U3c-core:  the  derivation  algebra  (the  "derived"  half  of
    unit  U3c;  discoveries  0193  /  0196)  ======================== 

The  exact  real-algebra  core  of  the  second-orbit  pair-display
mechanism  —  the  part  of  the  U3c  residual  law  that  is  DERIVED
rather  than  fitted:

  (i)    the  paper's  pair-display  constant  c  =  ln(pi/2)  cancels
         against  ln(2/pi)  in  the  N/D  ratio  (0193  constant
         cancellation,  the  core  of  the  "g  smooths  to  ln(L)");
  (ii)   the  census  ratio  (1+delta)/2  with  delta  =  (lnL + c)/(2L)
         is  EXACTLY  the  paper's  (1/2)(1 + u/2 + c/(2L))  display,
         u  :=  lnL/L   (the  N/D  collapse  to  the  census  ratio);
  (iii)  the  basis  re-basing  u*delta  =  u^2/2  +  (c/2)(u/L)  and
         its  two-term  corollary  for  the  0190  R-law  shape
         a*u^2 + b*(u*delta)  =  (a + b/2)*u^2 + (b*c/2)*(u/L)
         (0193:  the  u^2  coefficient  re-bases  to  a + b/2,  NOT
         b/2,  because  delta*u  contributes  +u^2/2);
  (iv)   the  band  scale  order  u/L  <  u^2  for  L  >  e  (0196:
         "the  u/L  term  dominates  but  both  are  below  the  u^2
         truncation  band",  in  theorem  form).

No  measurements  here:  the  ladder  data  (meas,  se,  S)  live  in
the  Python  pipeline  (kcs3c_c  /  kcs3c_h);  the  pinned  numbers
below  are  the  0193  /  0194  /  0196  recorded  values,  display-only
Float  gates  in  the  Z78  pattern.  Structural  flank  work  on  a
mod-4  prime-gap  census  statistic.  No  RH  claim.
-/  namespace U3cCore

variable  (L : ℝ)

/--  The  paper's  pair-display  constant  c  =  ln(pi/2). -/
noncomputable def cConst  :  ℝ  :=  Real.log  (Real.pi  /  2)

/--  u  :=  ln(L)  /  L  (the  0193  /  0196  scale  variable). -/
noncomputable def uVar    (L  :  ℝ)  :  ℝ  :=  Real.log  L  /  L

/--  delta  :=  (ln(L)  +  c)  /  (2L). -/
noncomputable def delta   (L  :  ℝ)  :  ℝ  :=  (Real.log  L  +  cConst)  /  (2  *  L)

/--  (i)   0193  constant  cancellation:  ln(pi/2)  +  ln(2/pi)  =  0. -/
theorem  logPiCancel  :
    cConst  +  Real.log  (2  /  Real.pi)  =  0  :=  by
  have  hpos  :  0  <  Real.pi  /  2  :=  by  linarith  [Real.pi_pos]
  rw  [cConst]
  rw  [show  (2  /  Real.pi  :  ℝ)  =  (Real.pi  /  2)⁻¹  by  field_simp]
  rw  [Real.log_inv]
  ring

/--  (ii)  The  N/D  collapse:  the  paper's  ratio  display  IS  the
          census  ratio  (1+delta)/2.  0193. -/
theorem  ratioCollapse  (hL  :  0  <  L)  :
    (1  /  2)  *  (1  +  uVar  L  /  2  +  cConst  /  (2  *  L))  =
      (1  +  delta  L)  /  2  :=  by
  rw  [uVar,  delta,  cConst]
  field_simp  [hL.ne']
  ring

/--  (iii-a)   The  basis  re-basing:  delta  *  u  =  u^2/2  +
             (c/2)  *  (u/L).  0193  (the  identity  behind  the  R-law
             coefficient  structure). -/
theorem  deltaUBasis  (hL  :  0  <  L)  :
    (uVar  L)  *  (delta  L)  =  (uVar  L)  ^  2  /  2  +
      (cConst  /  2)  *  (uVar  L  /  L)  :=  by
  rw  [uVar,  delta,  cConst]
  field_simp  [hL.ne']

/--  (iii-b)   The  two-term  R-law  shape:  a*u^2  +  b*(u*delta)
             re-bases  to  (a + b/2)*u^2  +  (b*c/2)*(u/L).  The  0190
             law  (a  =  -1.88114,  b  =  3.69471)  therefore  has  its
             u^2  coefficient  at  a + b/2  =  -0.0338,  not  b/2. -/
theorem  rlawRebase  (hL  :  0  <  L)  (a  b  :  ℝ)  :
    a  *  (uVar  L)  ^  2  +  b  *  ((uVar  L)  *  (delta  L))  =
      (a  +  b  /  2)  *  (uVar  L)  ^  2  +
        (b  *  cConst  /  2)  *  (uVar  L  /  L)  :=  by
  rw  [deltaUBasis  L  hL]
  field_simp  [hL.ne']
  ring

/--  (iv)  The  band  scale  order:  for  L  >  e,  u/L  <  u^2  (the
          u/L  correction  lies  below  the  u^2  truncation  band;
          0196  scale  structure). -/
theorem  uOverL_below_uSq  (h  :  Real.exp  1  <  L)  :
    (uVar  L)  /  L  <  (uVar  L)  ^  2  :=  by
  have  hL0  :  0  <  L  :=  lt_trans  (Real.exp_pos  1)  h
  have  hg1  :  1  <  Real.log  L  :=  by
    rw  [show  (1  :  ℝ)  =  Real.log  (Real.exp  1)  by  rw  [Real.log_exp]]
    exact  (Real.log_lt_log_iff  (Real.exp_pos  1)  hL0).2  h
  have  hg0  :  0  <  Real.log  L  :=  lt_trans  zero_lt_one  hg1
  rw  [uVar,  div_pow]
  have  hL2  :  0  <  L  ^  2  :=  pow_pos  hL0  2
  calc
    Real.log  L  /  L  /  L  =  Real.log  L  /  (L  ^  2)  :=  by  ring
    _  <  (Real.log  L)  ^  2  /  (L  ^  2)  :=  by
      rw  [div_lt_div_iff_of_pos_right  hL2]
      nlinarith  [hg1]

/-!  Float  gates  (0193  /  0194  /  0196  pinned  numbers;  display
      only  —  this  file  performs  no  measurement;  the  ladder  data
      live  in  the  kcs3c_c  /  kcs3c_h  Python  pipeline):  -/  

def cPinned              :  Float  :=  0.451583     --  ln(pi/2)  (0193)
def censusRatio3e12     :  Float  :=  0.533150  --  (1+delta)/2  at  3e12  (0196)
def meas3e12              :  Float  :=  0.538446  --  0194  point  (6-digit  round)
def S3e12                   :  Float  :=  0.005296  --  meas  -  census  ratio  (0196)
def band3e12                :  Float  :=  0.013657  --  u^2  at  3e12  (0196)
def band1e13                :  Float  :=  0.012894  --  u^2  at  1e13  (0196)
def S1e13_pred8pt       :  Float  :=  0.004954  --  8-pt  S-form  prediction  (0196)
def S1e13_pred9pt       :  Float  :=  0.004944  --  9-pt  S-form  prediction  (0196)

#eval  cPinned
#eval  censusRatio3e12
#eval  meas3e12
#eval  S3e12
#eval  band3e12
#eval  band1e13
#eval  S1e13_pred8pt
#eval  S1e13_pred9pt

end  U3cCore
end  SieveOrbit
