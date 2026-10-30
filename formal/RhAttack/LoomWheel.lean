/-
LoomWheel (LOOM track, 0238) - the FIRST TRUE THEOREM of the loom track.

PROVENANCE (off-board measurement origin):
The mod-3 support constraint was MEASURED at X = 1e8 by
scripts/sq/loom19.py + scripts/sq/loom19b_mod3.py (discovery 0236-0238,
docs/LOOM-PENROSE-SIDE-QUEST-2026-10-29.md, "TRANSFER (0236)" /
"TRANSFER-2 (0237)" / "TRANSFER-3 (0238)"): for consecutive odd primes
p < p' < p'' with L = p'-p-1 >= 2 composites in the current gap, the
next-gap length L_next = p''-p'-1 NEVER lands in one row-wise
forbidden residue class mod 3 - **0 hits on the forbidden residue over
3,776,589 gaps** across every mass row tested.  The arithmetic
explanation (and this module's content) is that p'' = p + L + L_next + 2
is prime, hence not divisible by 3, which forces exactly that class to
be vacant row by row.

MEASURED ROLE (0237/0238, no RH claim): this ONE BIT (p mod 3) carries
+0.16667 of the +0.20877 nats/step exact-value next-gap gain
(79.8%, z = +92856 against the within-L shuffle null): the coarse
"pair family" table P(L_next | L) mixes the two mod-3 families and
therefore puts positive mass on exactly-vacant bins; conditioning on
p mod 3 zeroes them.  The ceiling the loom track measured across
0225/0228/0233 is, at its core, the shadow of this constraint.

SCOPE: elementary modular arithmetic only.  OFF-BOARD side-quest
module - it sits in the loom family (WheelTile pattern: measure first,
anchor second); it is NOT part of the RH endgame face and carries no
RH claim.
-/
import Mathlib.Tactic
import Mathlib.Data.Nat.ModEq

open Nat

/-- composites between p and p' (the loom gap length). -/
def loomL (p p' : ℕ) : ℕ := p' - p - 1

/-- composites between p' and p'' (the next loom gap length). -/
def loomLn (p' p'' : ℕ) : ℕ := p'' - p' - 1

/-- p' = p + 1 + L with L >= 1 gives L = p' - p - 1 back; the
    bookkeeping identity used below: p'' = p + L + Ln + 2 when
    L = loomL p p', Ln = loomLn p' p'', p < p' < p''. -/
theorem loom_summation {p p' p'' L Ln : ℕ}
    (hL : L = p' - p - 1) (hLn : Ln = p'' - p' - 1)
    (hlt : p < p') (hlt' : p' < p'') :
    p + L + Ln + 2 = p'' := by
  subst hL hLn
  have hp1 : p + 1 ≤ p' := Nat.succ_le_of_lt hlt
  have hp1' : p' + 1 ≤ p'' := Nat.succ_le_of_lt hlt'
  omega

/-- a prime strictly above 3 is not divisible by 3. -/
theorem prime_gt3_not_dvd_3 (hp'' : Nat.Prime p'') (hpp' : 3 < p'') : p'' % 3 ≠ 0 := by
  intro h
  have hdv : 3 ∣ p'' := Nat.dvd_of_mod_eq_zero h
  have h1 := Nat.Prime.eq_one_or_self_of_dvd hp'' 3 hdv
  cases h1 with
  | inl h0 => omega
  | inr h0 => omega

/-- CORE 1 (the OT row rule, 0238): p = 1 (mod 3), p'' prime above 3,
    p'' = p + L + L_next + 2  =>  L + L_next != 0 (mod 3). -/
theorem loom3mod3_rule1 {p L Ln p'' : ℕ}
    (hsum : p'' = p + L + Ln + 2)
    (hp'' : Nat.Prime p'') (hpp' : 3 < p'')
    (hp1 : p % 3 = 1) :
    (L + Ln) % 3 ≠ 0 := by
  have hmod : (p + L + Ln + 2) % 3 = (L + Ln) % 3 := by
    simp [Nat.add_mod, hp1]
    omega
  have hp'': p'' % 3 ≠ 0 := prime_gt3_not_dvd_3 hp'' hpp'
  intro h
  have : p'' % 3 = 0 := by
    subst hsum
    omega
  exact hp'' this

/-- CORE 2 (the TW row rule, 0238): p = 2 (mod 3), as above
    =>  L + L_next + 1 != 0 (mod 3). -/
theorem loom3mod3_rule2 {p L Ln p'' : ℕ}
    (hsum : p'' = p + L + Ln + 2)
    (hp'' : Nat.Prime p'') (hpp' : 3 < p'')
    (hp2 : p % 3 = 2) :
    (L + Ln + 1) % 3 ≠ 0 := by
  have hmod : (p + L + Ln + 2) % 3 = (L + Ln + 1) % 3 := by
    simp [Nat.add_mod, hp2]
    omega
  have hp'': p'' % 3 ≠ 0 := prime_gt3_not_dvd_3 hp'' hpp'
  intro h
  have : p'' % 3 = 0 := by
    subst hsum
    omega
  exact hp'' this

/-- GAP FORM (the measured statement, 0238): for primes
    p < p' < p'' with p'' > 3 and p not a multiple of 3, the row-wise
    forbidden residue class of the next gap is vacant.  p = 2 is the
    only even prime (p % 3 = 2); for odd prime p the classes are
    {1, 2} mod 3. -/
theorem loom3mod3_gap {p p' p'' : ℕ}
    (hp'' : Nat.Prime p'') (hpp' : 3 < p'')
    (hlt : p < p') (hlt' : p' < p'')
    (hp : p = 2 ∨ p % 3 = 1 ∨ p % 3 = 2) :
    let L := loomL p p'
    let Ln := loomLn p' p''
    if (p % 3 = 2) then (L + Ln + 1) % 3 ≠ 0
    else (L + Ln) % 3 ≠ 0 := by
  intro L Ln
  have hsum : p + L + Ln + 2 = p'' := loom_summation rfl rfl hlt hlt'
  by_cases h2 : p % 3 = 2
  · rw [if_pos h2]
    exact loom3mod3_rule2 (hsum.symm) hp'' hpp' h2
  · rw [if_neg h2]
    have h1' : p % 3 = 1 := by
      rcases hp with h0 | h0 | h0
      · -- p = 2 gives p % 3 = 2, excluded by h2
        rw [h0] at h2
        simp at h2
      · exact h0
      · omega
    exact loom3mod3_rule1 (hsum.symm) hp'' hpp' h1'

/-# Sanity battery (the measured rows, re-derived by the kernel) -/

/-- the p = 7 row of the 1e8 census: L = 3, L_next = 1, p % 3 = 1:
    3 + 1 = 4 = 1 mod 3 =/= 0 (allowed; this gap exists: 7, 11, 13). -/
example : (3 + 1) % 3 ≠ 0 := by decide

/-- the forbidden mate of that row: L = 3, L_next = 3 would put
    p'' = 7 + 3 + 3 + 2 = 15 (composite): the theorem's hypothesis
    fails, as it must.  7 + 15 - 1 is not prime: -/
example : ¬ Nat.Prime 15 := by decide

/-- the L = 3, L_next = 5 row (residue 2, allowed): 3 + 5 = 8 = 2 mod 3. -/
example : (3 + 5) % 3 ≠ 0 := by decide

/-- TW sanity: p = 5 (≡ 2), L = 3 (gap 5,11? no: 5,7 twin, L=1; the
    census row L=3 after a TW prime, e.g. p = 5 -> p' must be 5+4=9:
    not prime; use the identity directly): L = 1, L_next = 1 gives
    L + Ln + 1 = 3 = 0 mod 3 - FORBIDDEN for TW: the corresponding
    p'' = 5 + 1 + 1 + 2 = 9 is indeed composite. -/
example : (1 + 1 + 1) % 3 = 0 := by decide
example : ¬ Nat.Prime 9 := by decide
