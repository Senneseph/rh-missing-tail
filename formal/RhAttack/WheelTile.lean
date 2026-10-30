/-
# WheelTile — the wheel / 120120 tiled-pattern anchor (Loom side-quest)

Formal anchor for the WHEEL and the TILED PATTERN it pops out of, in the
Loom/Wheel side-quest (docs/LOOM-PENROSE-SIDE-QUEST-2026-10-29.md).

Objects (all finite and explicit):
  * smallPrimes = 30030 = 2*3*5*7*11*13; wheel point = coprime to it.
  * firstStep r = first d in 1..22 with r + d on the wheel (dite chain;
    0 marks the mathematically empty case, unreachable on the wheel).
  * whole-base (30030) tab facts: tabBounded, tabSurvivor, tabNoEarlier.
  * gcdShift / firstStepMod / firstStepPeriodic: the step sees only mod 30030.
  * firstSurvivor p = p + firstStep p; firstSurvivorPeriodic: period 120120.
  * laneHistogram L: full-period (120120) count of phases whose first
    survivor lands in mod-24 lane L — the TILED PATTERN the wheel pops out of.
  * sharp witness: firstStep 9439 = 22 (9440..9460 off wheel, 9461 on).

DATA CROSS-CHECK: scripts/sq/loom13_tile.py -> tmp/loom/loom13_out.txt.

SCOPE: off-board side-quest anchor. Does not touch the RH endpoint; no RH claim.
TCB: 30030/120120-domain facts use `native_decide` (trusted native-runtime
evaluation of closed computations); structural theorems are ordinary proofs.
-/
import Mathlib
set_option autoImplicit false
set_option maxHeartbeats 400000

namespace WheelTile

def smallPrimes : Nat := 30030

def wheelPeriod : Nat := 120120

def isWheelPoint (n : Nat) : Prop := Nat.Coprime n smallPrimes

/-- first `d` in 1..22 with `r + d` coprime to 30030 (always exists; bound 22;
    0 marks the unreachable empty case) -/
def firstStep (r : Nat) : Nat :=
  if Nat.Coprime (r + 1) smallPrimes then 1 else
    if Nat.Coprime (r + 2) smallPrimes then 2 else
      if Nat.Coprime (r + 3) smallPrimes then 3 else
        if Nat.Coprime (r + 4) smallPrimes then 4 else
          if Nat.Coprime (r + 5) smallPrimes then 5 else
            if Nat.Coprime (r + 6) smallPrimes then 6 else
              if Nat.Coprime (r + 7) smallPrimes then 7 else
                if Nat.Coprime (r + 8) smallPrimes then 8 else
                  if Nat.Coprime (r + 9) smallPrimes then 9 else
                    if Nat.Coprime (r + 10) smallPrimes then 10 else
                      if Nat.Coprime (r + 11) smallPrimes then 11 else
                        if Nat.Coprime (r + 12) smallPrimes then 12 else
                          if Nat.Coprime (r + 13) smallPrimes then 13 else
                            if Nat.Coprime (r + 14) smallPrimes then 14 else
                              if Nat.Coprime (r + 15) smallPrimes then 15 else
                                if Nat.Coprime (r + 16) smallPrimes then 16 else
                                  if Nat.Coprime (r + 17) smallPrimes then 17 else
                                    if Nat.Coprime (r + 18) smallPrimes then 18 else
                                      if Nat.Coprime (r + 19) smallPrimes then 19 else
                                        if Nat.Coprime (r + 20) smallPrimes then 20 else
                                          if Nat.Coprime (r + 21) smallPrimes then 21 else
                                            if Nat.Coprime (r + 22) smallPrimes then 22 else 0

/-- the first on-wheel point strictly after `p` -/
def firstSurvivor (p : Nat) : Nat := p + firstStep p

/-- mod-24 lane of the first survivor after `p` -/
def survivorLane (p : Nat) : Nat := firstSurvivor p % 24

/-- full-period count of phases whose first survivor lands in lane L -/
def laneHistogram (L : Nat) : Nat :=
  Finset.card ((Finset.Ico 0 wheelPeriod).filter (fun p => (p + firstStep p) % 24 = L))

/-! ## whole-base (30030) tab facts — `native_decide` -/

/-- every base residue finds its survivor within 22 steps -/
theorem tabBounded : ∀ r < smallPrimes, 1 ≤ firstStep r ∧ firstStep r ≤ 22 := by native_decide

/-- the tabular survivor is on the wheel -/
theorem tabSurvivor : ∀ r < smallPrimes, Nat.Coprime (r + firstStep r) smallPrimes := by native_decide

/-- nothing earlier in 1..(step-1) is on the wheel -/
theorem tabNoEarlier :
    ∀ r < smallPrimes, ∀ k ∈ Finset.Ico 1 (firstStep r), ¬ Nat.Coprime (r + k) smallPrimes := by native_decide

/-! ## structural proofs -/

/-- the wheel only sees the residue mod 30030 (for d < 30030) -/
theorem gcdShift (r d : Nat) (hd : d < smallPrimes) :
    Nat.Coprime (r + d) smallPrimes ↔ Nat.Coprime (r % smallPrimes + d) smallPrimes := by
  have hw0 : r + d = (r % 30030 + d) + (r / 30030) * 30030 := by omega
  have hW : smallPrimes = 30030 := rfl
  have hw : r + d = (r % smallPrimes + d) + (r / smallPrimes) * smallPrimes := by simpa [hW] using hw0
  unfold Nat.Coprime
  rw [hw,
      Nat.gcd_comm ((r % smallPrimes + d) + (r / smallPrimes) * smallPrimes) smallPrimes,
      Nat.gcd_add_mul_right_right (m := smallPrimes),
      Nat.gcd_comm smallPrimes (r % smallPrimes + d)]

/-- the step only sees the residue mod 30030 -/
theorem firstStepMod (r : Nat) : firstStep r = firstStep (r % smallPrimes) := by
  let q := r % smallPrimes
  have hqB : q < smallPrimes := Nat.mod_lt r (by decide : 0 < smallPrimes)
  have hQb : 1 ≤ firstStep q ∧ firstStep q ≤ 22 := tabBounded q hqB
  have hQs : Nat.Coprime (q + firstStep q) smallPrimes := tabSurvivor q hqB
  have hQn : ∀ k ∈ Finset.Ico 1 (firstStep q), ¬ Nat.Coprime (q + k) smallPrimes := tabNoEarlier q hqB
  have hCr : ∀ d, 1 ≤ d → d ≤ 22 → Nat.Coprime (r + d) smallPrimes → Nat.Coprime (q + d) smallPrimes := by
    intro d d1 d22 hp
    have hdW : d < smallPrimes := by
      unfold smallPrimes
      exact lt_of_le_of_lt d22 (by decide : 22 < 30030)
    simpa [q] using (gcdShift r d hdW).mp hp
  have hCq : ∀ d, 1 ≤ d → d ≤ 22 → Nat.Coprime (q + d) smallPrimes → Nat.Coprime (r + d) smallPrimes := by
    intro d d1 d22 hp
    have hdW : d < smallPrimes := by
      unfold smallPrimes
      exact lt_of_le_of_lt d22 (by decide : 22 < 30030)
    simpa [q] using (gcdShift r d hdW).mpr hp
  -- minimality: a candidate c with P(c) and no earlier P is the q-step
  have hcAt : ∀ c, 1 ≤ c → c ≤ 22 →
      (∀ k, 1 ≤ k → k < c → ¬ Nat.Coprime (r + k) smallPrimes) →
      Nat.Coprime (r + c) smallPrimes → c = firstStep q := by
    intro c c1 c22 hctx hctxc
    have hle : firstStep q ≤ c := by
      by_contra hc
      have hlt : c < firstStep q := Nat.not_le.mp hc
      have him : c ∈ Finset.Ico 1 (firstStep q) := by
        simp [Finset.mem_Ico]
        exact ⟨c1, hlt⟩
      have hno : ¬ Nat.Coprime (q + c) smallPrimes := hQn c him
      have hq : Nat.Coprime (q + c) smallPrimes := hCr c c1 c22 hctxc
      contradiction
    have hge : c ≤ firstStep q := by
      by_contra hc
      have hlt : firstStep q < c := Nat.not_le.mp hc
      have him : firstStep q ∈ Finset.Ico 1 c := by
        simp [Finset.mem_Ico]
        exact ⟨hQb.1, hlt⟩
      have hno : ¬ Nat.Coprime (r + firstStep q) smallPrimes := hctx (firstStep q) hQb.1 hlt
      have hnoq : ¬ Nat.Coprime (q + firstStep q) smallPrimes := fun hq => hno (hCq (firstStep q) hQb.1 hQb.2 hq)
      exact hnoq hQs
    omega
  unfold firstStep
  by_cases h1 : Nat.Coprime (r + 1) smallPrimes
  · have ht : (if Nat.Coprime (r + 1) smallPrimes then 1 else if Nat.Coprime (r + 2) smallPrimes then 2 else if Nat.Coprime (r + 3) smallPrimes then 3 else if Nat.Coprime (r + 4) smallPrimes then 4 else if Nat.Coprime (r + 5) smallPrimes then 5 else if Nat.Coprime (r + 6) smallPrimes then 6 else if Nat.Coprime (r + 7) smallPrimes then 7 else if Nat.Coprime (r + 8) smallPrimes then 8 else if Nat.Coprime (r + 9) smallPrimes then 9 else if Nat.Coprime (r + 10) smallPrimes then 10 else if Nat.Coprime (r + 11) smallPrimes then 11 else if Nat.Coprime (r + 12) smallPrimes then 12 else if Nat.Coprime (r + 13) smallPrimes then 13 else if Nat.Coprime (r + 14) smallPrimes then 14 else if Nat.Coprime (r + 15) smallPrimes then 15 else if Nat.Coprime (r + 16) smallPrimes then 16 else if Nat.Coprime (r + 17) smallPrimes then 17 else if Nat.Coprime (r + 18) smallPrimes then 18 else if Nat.Coprime (r + 19) smallPrimes then 19 else if Nat.Coprime (r + 20) smallPrimes then 20 else if Nat.Coprime (r + 21) smallPrimes then 21 else if Nat.Coprime (r + 22) smallPrimes then 22 else 0) = 1 := (ite_eq_left_iff (p := Nat.Coprime (r + 1) smallPrimes)).mpr (fun hnp => False.elim (hnp h1))
    rw [ht]
    exact hcAt 1 (by omega) (by omega) (fun k hk1 hk2 => by omega) h1
  have hf : (if Nat.Coprime (r + 1) smallPrimes then 1 else if Nat.Coprime (r + 2) smallPrimes then 2 else if Nat.Coprime (r + 3) smallPrimes then 3 else if Nat.Coprime (r + 4) smallPrimes then 4 else if Nat.Coprime (r + 5) smallPrimes then 5 else if Nat.Coprime (r + 6) smallPrimes then 6 else if Nat.Coprime (r + 7) smallPrimes then 7 else if Nat.Coprime (r + 8) smallPrimes then 8 else if Nat.Coprime (r + 9) smallPrimes then 9 else if Nat.Coprime (r + 10) smallPrimes then 10 else if Nat.Coprime (r + 11) smallPrimes then 11 else if Nat.Coprime (r + 12) smallPrimes then 12 else if Nat.Coprime (r + 13) smallPrimes then 13 else if Nat.Coprime (r + 14) smallPrimes then 14 else if Nat.Coprime (r + 15) smallPrimes then 15 else if Nat.Coprime (r + 16) smallPrimes then 16 else if Nat.Coprime (r + 17) smallPrimes then 17 else if Nat.Coprime (r + 18) smallPrimes then 18 else if Nat.Coprime (r + 19) smallPrimes then 19 else if Nat.Coprime (r + 20) smallPrimes then 20 else if Nat.Coprime (r + 21) smallPrimes then 21 else if Nat.Coprime (r + 22) smallPrimes then 22 else 0) = if Nat.Coprime (r + 2) smallPrimes then 2 else if Nat.Coprime (r + 3) smallPrimes then 3 else if Nat.Coprime (r + 4) smallPrimes then 4 else if Nat.Coprime (r + 5) smallPrimes then 5 else if Nat.Coprime (r + 6) smallPrimes then 6 else if Nat.Coprime (r + 7) smallPrimes then 7 else if Nat.Coprime (r + 8) smallPrimes then 8 else if Nat.Coprime (r + 9) smallPrimes then 9 else if Nat.Coprime (r + 10) smallPrimes then 10 else if Nat.Coprime (r + 11) smallPrimes then 11 else if Nat.Coprime (r + 12) smallPrimes then 12 else if Nat.Coprime (r + 13) smallPrimes then 13 else if Nat.Coprime (r + 14) smallPrimes then 14 else if Nat.Coprime (r + 15) smallPrimes then 15 else if Nat.Coprime (r + 16) smallPrimes then 16 else if Nat.Coprime (r + 17) smallPrimes then 17 else if Nat.Coprime (r + 18) smallPrimes then 18 else if Nat.Coprime (r + 19) smallPrimes then 19 else if Nat.Coprime (r + 20) smallPrimes then 20 else if Nat.Coprime (r + 21) smallPrimes then 21 else if Nat.Coprime (r + 22) smallPrimes then 22 else 0 := (ite_eq_right_iff (p := Nat.Coprime (r + 1) smallPrimes)).mpr (fun hp => False.elim (h1 hp))
  rw [hf]
  by_cases h2 : Nat.Coprime (r + 2) smallPrimes
  · have ht : (if Nat.Coprime (r + 2) smallPrimes then 2 else if Nat.Coprime (r + 3) smallPrimes then 3 else if Nat.Coprime (r + 4) smallPrimes then 4 else if Nat.Coprime (r + 5) smallPrimes then 5 else if Nat.Coprime (r + 6) smallPrimes then 6 else if Nat.Coprime (r + 7) smallPrimes then 7 else if Nat.Coprime (r + 8) smallPrimes then 8 else if Nat.Coprime (r + 9) smallPrimes then 9 else if Nat.Coprime (r + 10) smallPrimes then 10 else if Nat.Coprime (r + 11) smallPrimes then 11 else if Nat.Coprime (r + 12) smallPrimes then 12 else if Nat.Coprime (r + 13) smallPrimes then 13 else if Nat.Coprime (r + 14) smallPrimes then 14 else if Nat.Coprime (r + 15) smallPrimes then 15 else if Nat.Coprime (r + 16) smallPrimes then 16 else if Nat.Coprime (r + 17) smallPrimes then 17 else if Nat.Coprime (r + 18) smallPrimes then 18 else if Nat.Coprime (r + 19) smallPrimes then 19 else if Nat.Coprime (r + 20) smallPrimes then 20 else if Nat.Coprime (r + 21) smallPrimes then 21 else if Nat.Coprime (r + 22) smallPrimes then 22 else 0) = 2 := (ite_eq_left_iff (p := Nat.Coprime (r + 2) smallPrimes)).mpr (fun hnp => False.elim (hnp h2))
    rw [ht]
    exact hcAt 2 (by omega) (by omega) (fun k hk1 hk2 => by interval_cases k <;> assumption) h2
  have hf : (if Nat.Coprime (r + 2) smallPrimes then 2 else if Nat.Coprime (r + 3) smallPrimes then 3 else if Nat.Coprime (r + 4) smallPrimes then 4 else if Nat.Coprime (r + 5) smallPrimes then 5 else if Nat.Coprime (r + 6) smallPrimes then 6 else if Nat.Coprime (r + 7) smallPrimes then 7 else if Nat.Coprime (r + 8) smallPrimes then 8 else if Nat.Coprime (r + 9) smallPrimes then 9 else if Nat.Coprime (r + 10) smallPrimes then 10 else if Nat.Coprime (r + 11) smallPrimes then 11 else if Nat.Coprime (r + 12) smallPrimes then 12 else if Nat.Coprime (r + 13) smallPrimes then 13 else if Nat.Coprime (r + 14) smallPrimes then 14 else if Nat.Coprime (r + 15) smallPrimes then 15 else if Nat.Coprime (r + 16) smallPrimes then 16 else if Nat.Coprime (r + 17) smallPrimes then 17 else if Nat.Coprime (r + 18) smallPrimes then 18 else if Nat.Coprime (r + 19) smallPrimes then 19 else if Nat.Coprime (r + 20) smallPrimes then 20 else if Nat.Coprime (r + 21) smallPrimes then 21 else if Nat.Coprime (r + 22) smallPrimes then 22 else 0) = if Nat.Coprime (r + 3) smallPrimes then 3 else if Nat.Coprime (r + 4) smallPrimes then 4 else if Nat.Coprime (r + 5) smallPrimes then 5 else if Nat.Coprime (r + 6) smallPrimes then 6 else if Nat.Coprime (r + 7) smallPrimes then 7 else if Nat.Coprime (r + 8) smallPrimes then 8 else if Nat.Coprime (r + 9) smallPrimes then 9 else if Nat.Coprime (r + 10) smallPrimes then 10 else if Nat.Coprime (r + 11) smallPrimes then 11 else if Nat.Coprime (r + 12) smallPrimes then 12 else if Nat.Coprime (r + 13) smallPrimes then 13 else if Nat.Coprime (r + 14) smallPrimes then 14 else if Nat.Coprime (r + 15) smallPrimes then 15 else if Nat.Coprime (r + 16) smallPrimes then 16 else if Nat.Coprime (r + 17) smallPrimes then 17 else if Nat.Coprime (r + 18) smallPrimes then 18 else if Nat.Coprime (r + 19) smallPrimes then 19 else if Nat.Coprime (r + 20) smallPrimes then 20 else if Nat.Coprime (r + 21) smallPrimes then 21 else if Nat.Coprime (r + 22) smallPrimes then 22 else 0 := (ite_eq_right_iff (p := Nat.Coprime (r + 2) smallPrimes)).mpr (fun hp => False.elim (h2 hp))
  rw [hf]
  by_cases h3 : Nat.Coprime (r + 3) smallPrimes
  · have ht : (if Nat.Coprime (r + 3) smallPrimes then 3 else if Nat.Coprime (r + 4) smallPrimes then 4 else if Nat.Coprime (r + 5) smallPrimes then 5 else if Nat.Coprime (r + 6) smallPrimes then 6 else if Nat.Coprime (r + 7) smallPrimes then 7 else if Nat.Coprime (r + 8) smallPrimes then 8 else if Nat.Coprime (r + 9) smallPrimes then 9 else if Nat.Coprime (r + 10) smallPrimes then 10 else if Nat.Coprime (r + 11) smallPrimes then 11 else if Nat.Coprime (r + 12) smallPrimes then 12 else if Nat.Coprime (r + 13) smallPrimes then 13 else if Nat.Coprime (r + 14) smallPrimes then 14 else if Nat.Coprime (r + 15) smallPrimes then 15 else if Nat.Coprime (r + 16) smallPrimes then 16 else if Nat.Coprime (r + 17) smallPrimes then 17 else if Nat.Coprime (r + 18) smallPrimes then 18 else if Nat.Coprime (r + 19) smallPrimes then 19 else if Nat.Coprime (r + 20) smallPrimes then 20 else if Nat.Coprime (r + 21) smallPrimes then 21 else if Nat.Coprime (r + 22) smallPrimes then 22 else 0) = 3 := (ite_eq_left_iff (p := Nat.Coprime (r + 3) smallPrimes)).mpr (fun hnp => False.elim (hnp h3))
    rw [ht]
    exact hcAt 3 (by omega) (by omega) (fun k hk1 hk2 => by interval_cases k <;> assumption) h3
  have hf : (if Nat.Coprime (r + 3) smallPrimes then 3 else if Nat.Coprime (r + 4) smallPrimes then 4 else if Nat.Coprime (r + 5) smallPrimes then 5 else if Nat.Coprime (r + 6) smallPrimes then 6 else if Nat.Coprime (r + 7) smallPrimes then 7 else if Nat.Coprime (r + 8) smallPrimes then 8 else if Nat.Coprime (r + 9) smallPrimes then 9 else if Nat.Coprime (r + 10) smallPrimes then 10 else if Nat.Coprime (r + 11) smallPrimes then 11 else if Nat.Coprime (r + 12) smallPrimes then 12 else if Nat.Coprime (r + 13) smallPrimes then 13 else if Nat.Coprime (r + 14) smallPrimes then 14 else if Nat.Coprime (r + 15) smallPrimes then 15 else if Nat.Coprime (r + 16) smallPrimes then 16 else if Nat.Coprime (r + 17) smallPrimes then 17 else if Nat.Coprime (r + 18) smallPrimes then 18 else if Nat.Coprime (r + 19) smallPrimes then 19 else if Nat.Coprime (r + 20) smallPrimes then 20 else if Nat.Coprime (r + 21) smallPrimes then 21 else if Nat.Coprime (r + 22) smallPrimes then 22 else 0) = if Nat.Coprime (r + 4) smallPrimes then 4 else if Nat.Coprime (r + 5) smallPrimes then 5 else if Nat.Coprime (r + 6) smallPrimes then 6 else if Nat.Coprime (r + 7) smallPrimes then 7 else if Nat.Coprime (r + 8) smallPrimes then 8 else if Nat.Coprime (r + 9) smallPrimes then 9 else if Nat.Coprime (r + 10) smallPrimes then 10 else if Nat.Coprime (r + 11) smallPrimes then 11 else if Nat.Coprime (r + 12) smallPrimes then 12 else if Nat.Coprime (r + 13) smallPrimes then 13 else if Nat.Coprime (r + 14) smallPrimes then 14 else if Nat.Coprime (r + 15) smallPrimes then 15 else if Nat.Coprime (r + 16) smallPrimes then 16 else if Nat.Coprime (r + 17) smallPrimes then 17 else if Nat.Coprime (r + 18) smallPrimes then 18 else if Nat.Coprime (r + 19) smallPrimes then 19 else if Nat.Coprime (r + 20) smallPrimes then 20 else if Nat.Coprime (r + 21) smallPrimes then 21 else if Nat.Coprime (r + 22) smallPrimes then 22 else 0 := (ite_eq_right_iff (p := Nat.Coprime (r + 3) smallPrimes)).mpr (fun hp => False.elim (h3 hp))
  rw [hf]
  by_cases h4 : Nat.Coprime (r + 4) smallPrimes
  · have ht : (if Nat.Coprime (r + 4) smallPrimes then 4 else if Nat.Coprime (r + 5) smallPrimes then 5 else if Nat.Coprime (r + 6) smallPrimes then 6 else if Nat.Coprime (r + 7) smallPrimes then 7 else if Nat.Coprime (r + 8) smallPrimes then 8 else if Nat.Coprime (r + 9) smallPrimes then 9 else if Nat.Coprime (r + 10) smallPrimes then 10 else if Nat.Coprime (r + 11) smallPrimes then 11 else if Nat.Coprime (r + 12) smallPrimes then 12 else if Nat.Coprime (r + 13) smallPrimes then 13 else if Nat.Coprime (r + 14) smallPrimes then 14 else if Nat.Coprime (r + 15) smallPrimes then 15 else if Nat.Coprime (r + 16) smallPrimes then 16 else if Nat.Coprime (r + 17) smallPrimes then 17 else if Nat.Coprime (r + 18) smallPrimes then 18 else if Nat.Coprime (r + 19) smallPrimes then 19 else if Nat.Coprime (r + 20) smallPrimes then 20 else if Nat.Coprime (r + 21) smallPrimes then 21 else if Nat.Coprime (r + 22) smallPrimes then 22 else 0) = 4 := (ite_eq_left_iff (p := Nat.Coprime (r + 4) smallPrimes)).mpr (fun hnp => False.elim (hnp h4))
    rw [ht]
    exact hcAt 4 (by omega) (by omega) (fun k hk1 hk2 => by interval_cases k <;> assumption) h4
  have hf : (if Nat.Coprime (r + 4) smallPrimes then 4 else if Nat.Coprime (r + 5) smallPrimes then 5 else if Nat.Coprime (r + 6) smallPrimes then 6 else if Nat.Coprime (r + 7) smallPrimes then 7 else if Nat.Coprime (r + 8) smallPrimes then 8 else if Nat.Coprime (r + 9) smallPrimes then 9 else if Nat.Coprime (r + 10) smallPrimes then 10 else if Nat.Coprime (r + 11) smallPrimes then 11 else if Nat.Coprime (r + 12) smallPrimes then 12 else if Nat.Coprime (r + 13) smallPrimes then 13 else if Nat.Coprime (r + 14) smallPrimes then 14 else if Nat.Coprime (r + 15) smallPrimes then 15 else if Nat.Coprime (r + 16) smallPrimes then 16 else if Nat.Coprime (r + 17) smallPrimes then 17 else if Nat.Coprime (r + 18) smallPrimes then 18 else if Nat.Coprime (r + 19) smallPrimes then 19 else if Nat.Coprime (r + 20) smallPrimes then 20 else if Nat.Coprime (r + 21) smallPrimes then 21 else if Nat.Coprime (r + 22) smallPrimes then 22 else 0) = if Nat.Coprime (r + 5) smallPrimes then 5 else if Nat.Coprime (r + 6) smallPrimes then 6 else if Nat.Coprime (r + 7) smallPrimes then 7 else if Nat.Coprime (r + 8) smallPrimes then 8 else if Nat.Coprime (r + 9) smallPrimes then 9 else if Nat.Coprime (r + 10) smallPrimes then 10 else if Nat.Coprime (r + 11) smallPrimes then 11 else if Nat.Coprime (r + 12) smallPrimes then 12 else if Nat.Coprime (r + 13) smallPrimes then 13 else if Nat.Coprime (r + 14) smallPrimes then 14 else if Nat.Coprime (r + 15) smallPrimes then 15 else if Nat.Coprime (r + 16) smallPrimes then 16 else if Nat.Coprime (r + 17) smallPrimes then 17 else if Nat.Coprime (r + 18) smallPrimes then 18 else if Nat.Coprime (r + 19) smallPrimes then 19 else if Nat.Coprime (r + 20) smallPrimes then 20 else if Nat.Coprime (r + 21) smallPrimes then 21 else if Nat.Coprime (r + 22) smallPrimes then 22 else 0 := (ite_eq_right_iff (p := Nat.Coprime (r + 4) smallPrimes)).mpr (fun hp => False.elim (h4 hp))
  rw [hf]
  by_cases h5 : Nat.Coprime (r + 5) smallPrimes
  · have ht : (if Nat.Coprime (r + 5) smallPrimes then 5 else if Nat.Coprime (r + 6) smallPrimes then 6 else if Nat.Coprime (r + 7) smallPrimes then 7 else if Nat.Coprime (r + 8) smallPrimes then 8 else if Nat.Coprime (r + 9) smallPrimes then 9 else if Nat.Coprime (r + 10) smallPrimes then 10 else if Nat.Coprime (r + 11) smallPrimes then 11 else if Nat.Coprime (r + 12) smallPrimes then 12 else if Nat.Coprime (r + 13) smallPrimes then 13 else if Nat.Coprime (r + 14) smallPrimes then 14 else if Nat.Coprime (r + 15) smallPrimes then 15 else if Nat.Coprime (r + 16) smallPrimes then 16 else if Nat.Coprime (r + 17) smallPrimes then 17 else if Nat.Coprime (r + 18) smallPrimes then 18 else if Nat.Coprime (r + 19) smallPrimes then 19 else if Nat.Coprime (r + 20) smallPrimes then 20 else if Nat.Coprime (r + 21) smallPrimes then 21 else if Nat.Coprime (r + 22) smallPrimes then 22 else 0) = 5 := (ite_eq_left_iff (p := Nat.Coprime (r + 5) smallPrimes)).mpr (fun hnp => False.elim (hnp h5))
    rw [ht]
    exact hcAt 5 (by omega) (by omega) (fun k hk1 hk2 => by interval_cases k <;> assumption) h5
  have hf : (if Nat.Coprime (r + 5) smallPrimes then 5 else if Nat.Coprime (r + 6) smallPrimes then 6 else if Nat.Coprime (r + 7) smallPrimes then 7 else if Nat.Coprime (r + 8) smallPrimes then 8 else if Nat.Coprime (r + 9) smallPrimes then 9 else if Nat.Coprime (r + 10) smallPrimes then 10 else if Nat.Coprime (r + 11) smallPrimes then 11 else if Nat.Coprime (r + 12) smallPrimes then 12 else if Nat.Coprime (r + 13) smallPrimes then 13 else if Nat.Coprime (r + 14) smallPrimes then 14 else if Nat.Coprime (r + 15) smallPrimes then 15 else if Nat.Coprime (r + 16) smallPrimes then 16 else if Nat.Coprime (r + 17) smallPrimes then 17 else if Nat.Coprime (r + 18) smallPrimes then 18 else if Nat.Coprime (r + 19) smallPrimes then 19 else if Nat.Coprime (r + 20) smallPrimes then 20 else if Nat.Coprime (r + 21) smallPrimes then 21 else if Nat.Coprime (r + 22) smallPrimes then 22 else 0) = if Nat.Coprime (r + 6) smallPrimes then 6 else if Nat.Coprime (r + 7) smallPrimes then 7 else if Nat.Coprime (r + 8) smallPrimes then 8 else if Nat.Coprime (r + 9) smallPrimes then 9 else if Nat.Coprime (r + 10) smallPrimes then 10 else if Nat.Coprime (r + 11) smallPrimes then 11 else if Nat.Coprime (r + 12) smallPrimes then 12 else if Nat.Coprime (r + 13) smallPrimes then 13 else if Nat.Coprime (r + 14) smallPrimes then 14 else if Nat.Coprime (r + 15) smallPrimes then 15 else if Nat.Coprime (r + 16) smallPrimes then 16 else if Nat.Coprime (r + 17) smallPrimes then 17 else if Nat.Coprime (r + 18) smallPrimes then 18 else if Nat.Coprime (r + 19) smallPrimes then 19 else if Nat.Coprime (r + 20) smallPrimes then 20 else if Nat.Coprime (r + 21) smallPrimes then 21 else if Nat.Coprime (r + 22) smallPrimes then 22 else 0 := (ite_eq_right_iff (p := Nat.Coprime (r + 5) smallPrimes)).mpr (fun hp => False.elim (h5 hp))
  rw [hf]
  by_cases h6 : Nat.Coprime (r + 6) smallPrimes
  · have ht : (if Nat.Coprime (r + 6) smallPrimes then 6 else if Nat.Coprime (r + 7) smallPrimes then 7 else if Nat.Coprime (r + 8) smallPrimes then 8 else if Nat.Coprime (r + 9) smallPrimes then 9 else if Nat.Coprime (r + 10) smallPrimes then 10 else if Nat.Coprime (r + 11) smallPrimes then 11 else if Nat.Coprime (r + 12) smallPrimes then 12 else if Nat.Coprime (r + 13) smallPrimes then 13 else if Nat.Coprime (r + 14) smallPrimes then 14 else if Nat.Coprime (r + 15) smallPrimes then 15 else if Nat.Coprime (r + 16) smallPrimes then 16 else if Nat.Coprime (r + 17) smallPrimes then 17 else if Nat.Coprime (r + 18) smallPrimes then 18 else if Nat.Coprime (r + 19) smallPrimes then 19 else if Nat.Coprime (r + 20) smallPrimes then 20 else if Nat.Coprime (r + 21) smallPrimes then 21 else if Nat.Coprime (r + 22) smallPrimes then 22 else 0) = 6 := (ite_eq_left_iff (p := Nat.Coprime (r + 6) smallPrimes)).mpr (fun hnp => False.elim (hnp h6))
    rw [ht]
    exact hcAt 6 (by omega) (by omega) (fun k hk1 hk2 => by interval_cases k <;> assumption) h6
  have hf : (if Nat.Coprime (r + 6) smallPrimes then 6 else if Nat.Coprime (r + 7) smallPrimes then 7 else if Nat.Coprime (r + 8) smallPrimes then 8 else if Nat.Coprime (r + 9) smallPrimes then 9 else if Nat.Coprime (r + 10) smallPrimes then 10 else if Nat.Coprime (r + 11) smallPrimes then 11 else if Nat.Coprime (r + 12) smallPrimes then 12 else if Nat.Coprime (r + 13) smallPrimes then 13 else if Nat.Coprime (r + 14) smallPrimes then 14 else if Nat.Coprime (r + 15) smallPrimes then 15 else if Nat.Coprime (r + 16) smallPrimes then 16 else if Nat.Coprime (r + 17) smallPrimes then 17 else if Nat.Coprime (r + 18) smallPrimes then 18 else if Nat.Coprime (r + 19) smallPrimes then 19 else if Nat.Coprime (r + 20) smallPrimes then 20 else if Nat.Coprime (r + 21) smallPrimes then 21 else if Nat.Coprime (r + 22) smallPrimes then 22 else 0) = if Nat.Coprime (r + 7) smallPrimes then 7 else if Nat.Coprime (r + 8) smallPrimes then 8 else if Nat.Coprime (r + 9) smallPrimes then 9 else if Nat.Coprime (r + 10) smallPrimes then 10 else if Nat.Coprime (r + 11) smallPrimes then 11 else if Nat.Coprime (r + 12) smallPrimes then 12 else if Nat.Coprime (r + 13) smallPrimes then 13 else if Nat.Coprime (r + 14) smallPrimes then 14 else if Nat.Coprime (r + 15) smallPrimes then 15 else if Nat.Coprime (r + 16) smallPrimes then 16 else if Nat.Coprime (r + 17) smallPrimes then 17 else if Nat.Coprime (r + 18) smallPrimes then 18 else if Nat.Coprime (r + 19) smallPrimes then 19 else if Nat.Coprime (r + 20) smallPrimes then 20 else if Nat.Coprime (r + 21) smallPrimes then 21 else if Nat.Coprime (r + 22) smallPrimes then 22 else 0 := (ite_eq_right_iff (p := Nat.Coprime (r + 6) smallPrimes)).mpr (fun hp => False.elim (h6 hp))
  rw [hf]
  by_cases h7 : Nat.Coprime (r + 7) smallPrimes
  · have ht : (if Nat.Coprime (r + 7) smallPrimes then 7 else if Nat.Coprime (r + 8) smallPrimes then 8 else if Nat.Coprime (r + 9) smallPrimes then 9 else if Nat.Coprime (r + 10) smallPrimes then 10 else if Nat.Coprime (r + 11) smallPrimes then 11 else if Nat.Coprime (r + 12) smallPrimes then 12 else if Nat.Coprime (r + 13) smallPrimes then 13 else if Nat.Coprime (r + 14) smallPrimes then 14 else if Nat.Coprime (r + 15) smallPrimes then 15 else if Nat.Coprime (r + 16) smallPrimes then 16 else if Nat.Coprime (r + 17) smallPrimes then 17 else if Nat.Coprime (r + 18) smallPrimes then 18 else if Nat.Coprime (r + 19) smallPrimes then 19 else if Nat.Coprime (r + 20) smallPrimes then 20 else if Nat.Coprime (r + 21) smallPrimes then 21 else if Nat.Coprime (r + 22) smallPrimes then 22 else 0) = 7 := (ite_eq_left_iff (p := Nat.Coprime (r + 7) smallPrimes)).mpr (fun hnp => False.elim (hnp h7))
    rw [ht]
    exact hcAt 7 (by omega) (by omega) (fun k hk1 hk2 => by interval_cases k <;> assumption) h7
  have hf : (if Nat.Coprime (r + 7) smallPrimes then 7 else if Nat.Coprime (r + 8) smallPrimes then 8 else if Nat.Coprime (r + 9) smallPrimes then 9 else if Nat.Coprime (r + 10) smallPrimes then 10 else if Nat.Coprime (r + 11) smallPrimes then 11 else if Nat.Coprime (r + 12) smallPrimes then 12 else if Nat.Coprime (r + 13) smallPrimes then 13 else if Nat.Coprime (r + 14) smallPrimes then 14 else if Nat.Coprime (r + 15) smallPrimes then 15 else if Nat.Coprime (r + 16) smallPrimes then 16 else if Nat.Coprime (r + 17) smallPrimes then 17 else if Nat.Coprime (r + 18) smallPrimes then 18 else if Nat.Coprime (r + 19) smallPrimes then 19 else if Nat.Coprime (r + 20) smallPrimes then 20 else if Nat.Coprime (r + 21) smallPrimes then 21 else if Nat.Coprime (r + 22) smallPrimes then 22 else 0) = if Nat.Coprime (r + 8) smallPrimes then 8 else if Nat.Coprime (r + 9) smallPrimes then 9 else if Nat.Coprime (r + 10) smallPrimes then 10 else if Nat.Coprime (r + 11) smallPrimes then 11 else if Nat.Coprime (r + 12) smallPrimes then 12 else if Nat.Coprime (r + 13) smallPrimes then 13 else if Nat.Coprime (r + 14) smallPrimes then 14 else if Nat.Coprime (r + 15) smallPrimes then 15 else if Nat.Coprime (r + 16) smallPrimes then 16 else if Nat.Coprime (r + 17) smallPrimes then 17 else if Nat.Coprime (r + 18) smallPrimes then 18 else if Nat.Coprime (r + 19) smallPrimes then 19 else if Nat.Coprime (r + 20) smallPrimes then 20 else if Nat.Coprime (r + 21) smallPrimes then 21 else if Nat.Coprime (r + 22) smallPrimes then 22 else 0 := (ite_eq_right_iff (p := Nat.Coprime (r + 7) smallPrimes)).mpr (fun hp => False.elim (h7 hp))
  rw [hf]
  by_cases h8 : Nat.Coprime (r + 8) smallPrimes
  · have ht : (if Nat.Coprime (r + 8) smallPrimes then 8 else if Nat.Coprime (r + 9) smallPrimes then 9 else if Nat.Coprime (r + 10) smallPrimes then 10 else if Nat.Coprime (r + 11) smallPrimes then 11 else if Nat.Coprime (r + 12) smallPrimes then 12 else if Nat.Coprime (r + 13) smallPrimes then 13 else if Nat.Coprime (r + 14) smallPrimes then 14 else if Nat.Coprime (r + 15) smallPrimes then 15 else if Nat.Coprime (r + 16) smallPrimes then 16 else if Nat.Coprime (r + 17) smallPrimes then 17 else if Nat.Coprime (r + 18) smallPrimes then 18 else if Nat.Coprime (r + 19) smallPrimes then 19 else if Nat.Coprime (r + 20) smallPrimes then 20 else if Nat.Coprime (r + 21) smallPrimes then 21 else if Nat.Coprime (r + 22) smallPrimes then 22 else 0) = 8 := (ite_eq_left_iff (p := Nat.Coprime (r + 8) smallPrimes)).mpr (fun hnp => False.elim (hnp h8))
    rw [ht]
    exact hcAt 8 (by omega) (by omega) (fun k hk1 hk2 => by interval_cases k <;> assumption) h8
  have hf : (if Nat.Coprime (r + 8) smallPrimes then 8 else if Nat.Coprime (r + 9) smallPrimes then 9 else if Nat.Coprime (r + 10) smallPrimes then 10 else if Nat.Coprime (r + 11) smallPrimes then 11 else if Nat.Coprime (r + 12) smallPrimes then 12 else if Nat.Coprime (r + 13) smallPrimes then 13 else if Nat.Coprime (r + 14) smallPrimes then 14 else if Nat.Coprime (r + 15) smallPrimes then 15 else if Nat.Coprime (r + 16) smallPrimes then 16 else if Nat.Coprime (r + 17) smallPrimes then 17 else if Nat.Coprime (r + 18) smallPrimes then 18 else if Nat.Coprime (r + 19) smallPrimes then 19 else if Nat.Coprime (r + 20) smallPrimes then 20 else if Nat.Coprime (r + 21) smallPrimes then 21 else if Nat.Coprime (r + 22) smallPrimes then 22 else 0) = if Nat.Coprime (r + 9) smallPrimes then 9 else if Nat.Coprime (r + 10) smallPrimes then 10 else if Nat.Coprime (r + 11) smallPrimes then 11 else if Nat.Coprime (r + 12) smallPrimes then 12 else if Nat.Coprime (r + 13) smallPrimes then 13 else if Nat.Coprime (r + 14) smallPrimes then 14 else if Nat.Coprime (r + 15) smallPrimes then 15 else if Nat.Coprime (r + 16) smallPrimes then 16 else if Nat.Coprime (r + 17) smallPrimes then 17 else if Nat.Coprime (r + 18) smallPrimes then 18 else if Nat.Coprime (r + 19) smallPrimes then 19 else if Nat.Coprime (r + 20) smallPrimes then 20 else if Nat.Coprime (r + 21) smallPrimes then 21 else if Nat.Coprime (r + 22) smallPrimes then 22 else 0 := (ite_eq_right_iff (p := Nat.Coprime (r + 8) smallPrimes)).mpr (fun hp => False.elim (h8 hp))
  rw [hf]
  by_cases h9 : Nat.Coprime (r + 9) smallPrimes
  · have ht : (if Nat.Coprime (r + 9) smallPrimes then 9 else if Nat.Coprime (r + 10) smallPrimes then 10 else if Nat.Coprime (r + 11) smallPrimes then 11 else if Nat.Coprime (r + 12) smallPrimes then 12 else if Nat.Coprime (r + 13) smallPrimes then 13 else if Nat.Coprime (r + 14) smallPrimes then 14 else if Nat.Coprime (r + 15) smallPrimes then 15 else if Nat.Coprime (r + 16) smallPrimes then 16 else if Nat.Coprime (r + 17) smallPrimes then 17 else if Nat.Coprime (r + 18) smallPrimes then 18 else if Nat.Coprime (r + 19) smallPrimes then 19 else if Nat.Coprime (r + 20) smallPrimes then 20 else if Nat.Coprime (r + 21) smallPrimes then 21 else if Nat.Coprime (r + 22) smallPrimes then 22 else 0) = 9 := (ite_eq_left_iff (p := Nat.Coprime (r + 9) smallPrimes)).mpr (fun hnp => False.elim (hnp h9))
    rw [ht]
    exact hcAt 9 (by omega) (by omega) (fun k hk1 hk2 => by interval_cases k <;> assumption) h9
  have hf : (if Nat.Coprime (r + 9) smallPrimes then 9 else if Nat.Coprime (r + 10) smallPrimes then 10 else if Nat.Coprime (r + 11) smallPrimes then 11 else if Nat.Coprime (r + 12) smallPrimes then 12 else if Nat.Coprime (r + 13) smallPrimes then 13 else if Nat.Coprime (r + 14) smallPrimes then 14 else if Nat.Coprime (r + 15) smallPrimes then 15 else if Nat.Coprime (r + 16) smallPrimes then 16 else if Nat.Coprime (r + 17) smallPrimes then 17 else if Nat.Coprime (r + 18) smallPrimes then 18 else if Nat.Coprime (r + 19) smallPrimes then 19 else if Nat.Coprime (r + 20) smallPrimes then 20 else if Nat.Coprime (r + 21) smallPrimes then 21 else if Nat.Coprime (r + 22) smallPrimes then 22 else 0) = if Nat.Coprime (r + 10) smallPrimes then 10 else if Nat.Coprime (r + 11) smallPrimes then 11 else if Nat.Coprime (r + 12) smallPrimes then 12 else if Nat.Coprime (r + 13) smallPrimes then 13 else if Nat.Coprime (r + 14) smallPrimes then 14 else if Nat.Coprime (r + 15) smallPrimes then 15 else if Nat.Coprime (r + 16) smallPrimes then 16 else if Nat.Coprime (r + 17) smallPrimes then 17 else if Nat.Coprime (r + 18) smallPrimes then 18 else if Nat.Coprime (r + 19) smallPrimes then 19 else if Nat.Coprime (r + 20) smallPrimes then 20 else if Nat.Coprime (r + 21) smallPrimes then 21 else if Nat.Coprime (r + 22) smallPrimes then 22 else 0 := (ite_eq_right_iff (p := Nat.Coprime (r + 9) smallPrimes)).mpr (fun hp => False.elim (h9 hp))
  rw [hf]
  by_cases h10 : Nat.Coprime (r + 10) smallPrimes
  · have ht : (if Nat.Coprime (r + 10) smallPrimes then 10 else if Nat.Coprime (r + 11) smallPrimes then 11 else if Nat.Coprime (r + 12) smallPrimes then 12 else if Nat.Coprime (r + 13) smallPrimes then 13 else if Nat.Coprime (r + 14) smallPrimes then 14 else if Nat.Coprime (r + 15) smallPrimes then 15 else if Nat.Coprime (r + 16) smallPrimes then 16 else if Nat.Coprime (r + 17) smallPrimes then 17 else if Nat.Coprime (r + 18) smallPrimes then 18 else if Nat.Coprime (r + 19) smallPrimes then 19 else if Nat.Coprime (r + 20) smallPrimes then 20 else if Nat.Coprime (r + 21) smallPrimes then 21 else if Nat.Coprime (r + 22) smallPrimes then 22 else 0) = 10 := (ite_eq_left_iff (p := Nat.Coprime (r + 10) smallPrimes)).mpr (fun hnp => False.elim (hnp h10))
    rw [ht]
    exact hcAt 10 (by omega) (by omega) (fun k hk1 hk2 => by interval_cases k <;> assumption) h10
  have hf : (if Nat.Coprime (r + 10) smallPrimes then 10 else if Nat.Coprime (r + 11) smallPrimes then 11 else if Nat.Coprime (r + 12) smallPrimes then 12 else if Nat.Coprime (r + 13) smallPrimes then 13 else if Nat.Coprime (r + 14) smallPrimes then 14 else if Nat.Coprime (r + 15) smallPrimes then 15 else if Nat.Coprime (r + 16) smallPrimes then 16 else if Nat.Coprime (r + 17) smallPrimes then 17 else if Nat.Coprime (r + 18) smallPrimes then 18 else if Nat.Coprime (r + 19) smallPrimes then 19 else if Nat.Coprime (r + 20) smallPrimes then 20 else if Nat.Coprime (r + 21) smallPrimes then 21 else if Nat.Coprime (r + 22) smallPrimes then 22 else 0) = if Nat.Coprime (r + 11) smallPrimes then 11 else if Nat.Coprime (r + 12) smallPrimes then 12 else if Nat.Coprime (r + 13) smallPrimes then 13 else if Nat.Coprime (r + 14) smallPrimes then 14 else if Nat.Coprime (r + 15) smallPrimes then 15 else if Nat.Coprime (r + 16) smallPrimes then 16 else if Nat.Coprime (r + 17) smallPrimes then 17 else if Nat.Coprime (r + 18) smallPrimes then 18 else if Nat.Coprime (r + 19) smallPrimes then 19 else if Nat.Coprime (r + 20) smallPrimes then 20 else if Nat.Coprime (r + 21) smallPrimes then 21 else if Nat.Coprime (r + 22) smallPrimes then 22 else 0 := (ite_eq_right_iff (p := Nat.Coprime (r + 10) smallPrimes)).mpr (fun hp => False.elim (h10 hp))
  rw [hf]
  by_cases h11 : Nat.Coprime (r + 11) smallPrimes
  · have ht : (if Nat.Coprime (r + 11) smallPrimes then 11 else if Nat.Coprime (r + 12) smallPrimes then 12 else if Nat.Coprime (r + 13) smallPrimes then 13 else if Nat.Coprime (r + 14) smallPrimes then 14 else if Nat.Coprime (r + 15) smallPrimes then 15 else if Nat.Coprime (r + 16) smallPrimes then 16 else if Nat.Coprime (r + 17) smallPrimes then 17 else if Nat.Coprime (r + 18) smallPrimes then 18 else if Nat.Coprime (r + 19) smallPrimes then 19 else if Nat.Coprime (r + 20) smallPrimes then 20 else if Nat.Coprime (r + 21) smallPrimes then 21 else if Nat.Coprime (r + 22) smallPrimes then 22 else 0) = 11 := (ite_eq_left_iff (p := Nat.Coprime (r + 11) smallPrimes)).mpr (fun hnp => False.elim (hnp h11))
    rw [ht]
    exact hcAt 11 (by omega) (by omega) (fun k hk1 hk2 => by interval_cases k <;> assumption) h11
  have hf : (if Nat.Coprime (r + 11) smallPrimes then 11 else if Nat.Coprime (r + 12) smallPrimes then 12 else if Nat.Coprime (r + 13) smallPrimes then 13 else if Nat.Coprime (r + 14) smallPrimes then 14 else if Nat.Coprime (r + 15) smallPrimes then 15 else if Nat.Coprime (r + 16) smallPrimes then 16 else if Nat.Coprime (r + 17) smallPrimes then 17 else if Nat.Coprime (r + 18) smallPrimes then 18 else if Nat.Coprime (r + 19) smallPrimes then 19 else if Nat.Coprime (r + 20) smallPrimes then 20 else if Nat.Coprime (r + 21) smallPrimes then 21 else if Nat.Coprime (r + 22) smallPrimes then 22 else 0) = if Nat.Coprime (r + 12) smallPrimes then 12 else if Nat.Coprime (r + 13) smallPrimes then 13 else if Nat.Coprime (r + 14) smallPrimes then 14 else if Nat.Coprime (r + 15) smallPrimes then 15 else if Nat.Coprime (r + 16) smallPrimes then 16 else if Nat.Coprime (r + 17) smallPrimes then 17 else if Nat.Coprime (r + 18) smallPrimes then 18 else if Nat.Coprime (r + 19) smallPrimes then 19 else if Nat.Coprime (r + 20) smallPrimes then 20 else if Nat.Coprime (r + 21) smallPrimes then 21 else if Nat.Coprime (r + 22) smallPrimes then 22 else 0 := (ite_eq_right_iff (p := Nat.Coprime (r + 11) smallPrimes)).mpr (fun hp => False.elim (h11 hp))
  rw [hf]
  by_cases h12 : Nat.Coprime (r + 12) smallPrimes
  · have ht : (if Nat.Coprime (r + 12) smallPrimes then 12 else if Nat.Coprime (r + 13) smallPrimes then 13 else if Nat.Coprime (r + 14) smallPrimes then 14 else if Nat.Coprime (r + 15) smallPrimes then 15 else if Nat.Coprime (r + 16) smallPrimes then 16 else if Nat.Coprime (r + 17) smallPrimes then 17 else if Nat.Coprime (r + 18) smallPrimes then 18 else if Nat.Coprime (r + 19) smallPrimes then 19 else if Nat.Coprime (r + 20) smallPrimes then 20 else if Nat.Coprime (r + 21) smallPrimes then 21 else if Nat.Coprime (r + 22) smallPrimes then 22 else 0) = 12 := (ite_eq_left_iff (p := Nat.Coprime (r + 12) smallPrimes)).mpr (fun hnp => False.elim (hnp h12))
    rw [ht]
    exact hcAt 12 (by omega) (by omega) (fun k hk1 hk2 => by interval_cases k <;> assumption) h12
  have hf : (if Nat.Coprime (r + 12) smallPrimes then 12 else if Nat.Coprime (r + 13) smallPrimes then 13 else if Nat.Coprime (r + 14) smallPrimes then 14 else if Nat.Coprime (r + 15) smallPrimes then 15 else if Nat.Coprime (r + 16) smallPrimes then 16 else if Nat.Coprime (r + 17) smallPrimes then 17 else if Nat.Coprime (r + 18) smallPrimes then 18 else if Nat.Coprime (r + 19) smallPrimes then 19 else if Nat.Coprime (r + 20) smallPrimes then 20 else if Nat.Coprime (r + 21) smallPrimes then 21 else if Nat.Coprime (r + 22) smallPrimes then 22 else 0) = if Nat.Coprime (r + 13) smallPrimes then 13 else if Nat.Coprime (r + 14) smallPrimes then 14 else if Nat.Coprime (r + 15) smallPrimes then 15 else if Nat.Coprime (r + 16) smallPrimes then 16 else if Nat.Coprime (r + 17) smallPrimes then 17 else if Nat.Coprime (r + 18) smallPrimes then 18 else if Nat.Coprime (r + 19) smallPrimes then 19 else if Nat.Coprime (r + 20) smallPrimes then 20 else if Nat.Coprime (r + 21) smallPrimes then 21 else if Nat.Coprime (r + 22) smallPrimes then 22 else 0 := (ite_eq_right_iff (p := Nat.Coprime (r + 12) smallPrimes)).mpr (fun hp => False.elim (h12 hp))
  rw [hf]
  by_cases h13 : Nat.Coprime (r + 13) smallPrimes
  · have ht : (if Nat.Coprime (r + 13) smallPrimes then 13 else if Nat.Coprime (r + 14) smallPrimes then 14 else if Nat.Coprime (r + 15) smallPrimes then 15 else if Nat.Coprime (r + 16) smallPrimes then 16 else if Nat.Coprime (r + 17) smallPrimes then 17 else if Nat.Coprime (r + 18) smallPrimes then 18 else if Nat.Coprime (r + 19) smallPrimes then 19 else if Nat.Coprime (r + 20) smallPrimes then 20 else if Nat.Coprime (r + 21) smallPrimes then 21 else if Nat.Coprime (r + 22) smallPrimes then 22 else 0) = 13 := (ite_eq_left_iff (p := Nat.Coprime (r + 13) smallPrimes)).mpr (fun hnp => False.elim (hnp h13))
    rw [ht]
    exact hcAt 13 (by omega) (by omega) (fun k hk1 hk2 => by interval_cases k <;> assumption) h13
  have hf : (if Nat.Coprime (r + 13) smallPrimes then 13 else if Nat.Coprime (r + 14) smallPrimes then 14 else if Nat.Coprime (r + 15) smallPrimes then 15 else if Nat.Coprime (r + 16) smallPrimes then 16 else if Nat.Coprime (r + 17) smallPrimes then 17 else if Nat.Coprime (r + 18) smallPrimes then 18 else if Nat.Coprime (r + 19) smallPrimes then 19 else if Nat.Coprime (r + 20) smallPrimes then 20 else if Nat.Coprime (r + 21) smallPrimes then 21 else if Nat.Coprime (r + 22) smallPrimes then 22 else 0) = if Nat.Coprime (r + 14) smallPrimes then 14 else if Nat.Coprime (r + 15) smallPrimes then 15 else if Nat.Coprime (r + 16) smallPrimes then 16 else if Nat.Coprime (r + 17) smallPrimes then 17 else if Nat.Coprime (r + 18) smallPrimes then 18 else if Nat.Coprime (r + 19) smallPrimes then 19 else if Nat.Coprime (r + 20) smallPrimes then 20 else if Nat.Coprime (r + 21) smallPrimes then 21 else if Nat.Coprime (r + 22) smallPrimes then 22 else 0 := (ite_eq_right_iff (p := Nat.Coprime (r + 13) smallPrimes)).mpr (fun hp => False.elim (h13 hp))
  rw [hf]
  by_cases h14 : Nat.Coprime (r + 14) smallPrimes
  · have ht : (if Nat.Coprime (r + 14) smallPrimes then 14 else if Nat.Coprime (r + 15) smallPrimes then 15 else if Nat.Coprime (r + 16) smallPrimes then 16 else if Nat.Coprime (r + 17) smallPrimes then 17 else if Nat.Coprime (r + 18) smallPrimes then 18 else if Nat.Coprime (r + 19) smallPrimes then 19 else if Nat.Coprime (r + 20) smallPrimes then 20 else if Nat.Coprime (r + 21) smallPrimes then 21 else if Nat.Coprime (r + 22) smallPrimes then 22 else 0) = 14 := (ite_eq_left_iff (p := Nat.Coprime (r + 14) smallPrimes)).mpr (fun hnp => False.elim (hnp h14))
    rw [ht]
    exact hcAt 14 (by omega) (by omega) (fun k hk1 hk2 => by interval_cases k <;> assumption) h14
  have hf : (if Nat.Coprime (r + 14) smallPrimes then 14 else if Nat.Coprime (r + 15) smallPrimes then 15 else if Nat.Coprime (r + 16) smallPrimes then 16 else if Nat.Coprime (r + 17) smallPrimes then 17 else if Nat.Coprime (r + 18) smallPrimes then 18 else if Nat.Coprime (r + 19) smallPrimes then 19 else if Nat.Coprime (r + 20) smallPrimes then 20 else if Nat.Coprime (r + 21) smallPrimes then 21 else if Nat.Coprime (r + 22) smallPrimes then 22 else 0) = if Nat.Coprime (r + 15) smallPrimes then 15 else if Nat.Coprime (r + 16) smallPrimes then 16 else if Nat.Coprime (r + 17) smallPrimes then 17 else if Nat.Coprime (r + 18) smallPrimes then 18 else if Nat.Coprime (r + 19) smallPrimes then 19 else if Nat.Coprime (r + 20) smallPrimes then 20 else if Nat.Coprime (r + 21) smallPrimes then 21 else if Nat.Coprime (r + 22) smallPrimes then 22 else 0 := (ite_eq_right_iff (p := Nat.Coprime (r + 14) smallPrimes)).mpr (fun hp => False.elim (h14 hp))
  rw [hf]
  by_cases h15 : Nat.Coprime (r + 15) smallPrimes
  · have ht : (if Nat.Coprime (r + 15) smallPrimes then 15 else if Nat.Coprime (r + 16) smallPrimes then 16 else if Nat.Coprime (r + 17) smallPrimes then 17 else if Nat.Coprime (r + 18) smallPrimes then 18 else if Nat.Coprime (r + 19) smallPrimes then 19 else if Nat.Coprime (r + 20) smallPrimes then 20 else if Nat.Coprime (r + 21) smallPrimes then 21 else if Nat.Coprime (r + 22) smallPrimes then 22 else 0) = 15 := (ite_eq_left_iff (p := Nat.Coprime (r + 15) smallPrimes)).mpr (fun hnp => False.elim (hnp h15))
    rw [ht]
    exact hcAt 15 (by omega) (by omega) (fun k hk1 hk2 => by interval_cases k <;> assumption) h15
  have hf : (if Nat.Coprime (r + 15) smallPrimes then 15 else if Nat.Coprime (r + 16) smallPrimes then 16 else if Nat.Coprime (r + 17) smallPrimes then 17 else if Nat.Coprime (r + 18) smallPrimes then 18 else if Nat.Coprime (r + 19) smallPrimes then 19 else if Nat.Coprime (r + 20) smallPrimes then 20 else if Nat.Coprime (r + 21) smallPrimes then 21 else if Nat.Coprime (r + 22) smallPrimes then 22 else 0) = if Nat.Coprime (r + 16) smallPrimes then 16 else if Nat.Coprime (r + 17) smallPrimes then 17 else if Nat.Coprime (r + 18) smallPrimes then 18 else if Nat.Coprime (r + 19) smallPrimes then 19 else if Nat.Coprime (r + 20) smallPrimes then 20 else if Nat.Coprime (r + 21) smallPrimes then 21 else if Nat.Coprime (r + 22) smallPrimes then 22 else 0 := (ite_eq_right_iff (p := Nat.Coprime (r + 15) smallPrimes)).mpr (fun hp => False.elim (h15 hp))
  rw [hf]
  by_cases h16 : Nat.Coprime (r + 16) smallPrimes
  · have ht : (if Nat.Coprime (r + 16) smallPrimes then 16 else if Nat.Coprime (r + 17) smallPrimes then 17 else if Nat.Coprime (r + 18) smallPrimes then 18 else if Nat.Coprime (r + 19) smallPrimes then 19 else if Nat.Coprime (r + 20) smallPrimes then 20 else if Nat.Coprime (r + 21) smallPrimes then 21 else if Nat.Coprime (r + 22) smallPrimes then 22 else 0) = 16 := (ite_eq_left_iff (p := Nat.Coprime (r + 16) smallPrimes)).mpr (fun hnp => False.elim (hnp h16))
    rw [ht]
    exact hcAt 16 (by omega) (by omega) (fun k hk1 hk2 => by interval_cases k <;> assumption) h16
  have hf : (if Nat.Coprime (r + 16) smallPrimes then 16 else if Nat.Coprime (r + 17) smallPrimes then 17 else if Nat.Coprime (r + 18) smallPrimes then 18 else if Nat.Coprime (r + 19) smallPrimes then 19 else if Nat.Coprime (r + 20) smallPrimes then 20 else if Nat.Coprime (r + 21) smallPrimes then 21 else if Nat.Coprime (r + 22) smallPrimes then 22 else 0) = if Nat.Coprime (r + 17) smallPrimes then 17 else if Nat.Coprime (r + 18) smallPrimes then 18 else if Nat.Coprime (r + 19) smallPrimes then 19 else if Nat.Coprime (r + 20) smallPrimes then 20 else if Nat.Coprime (r + 21) smallPrimes then 21 else if Nat.Coprime (r + 22) smallPrimes then 22 else 0 := (ite_eq_right_iff (p := Nat.Coprime (r + 16) smallPrimes)).mpr (fun hp => False.elim (h16 hp))
  rw [hf]
  by_cases h17 : Nat.Coprime (r + 17) smallPrimes
  · have ht : (if Nat.Coprime (r + 17) smallPrimes then 17 else if Nat.Coprime (r + 18) smallPrimes then 18 else if Nat.Coprime (r + 19) smallPrimes then 19 else if Nat.Coprime (r + 20) smallPrimes then 20 else if Nat.Coprime (r + 21) smallPrimes then 21 else if Nat.Coprime (r + 22) smallPrimes then 22 else 0) = 17 := (ite_eq_left_iff (p := Nat.Coprime (r + 17) smallPrimes)).mpr (fun hnp => False.elim (hnp h17))
    rw [ht]
    exact hcAt 17 (by omega) (by omega) (fun k hk1 hk2 => by interval_cases k <;> assumption) h17
  have hf : (if Nat.Coprime (r + 17) smallPrimes then 17 else if Nat.Coprime (r + 18) smallPrimes then 18 else if Nat.Coprime (r + 19) smallPrimes then 19 else if Nat.Coprime (r + 20) smallPrimes then 20 else if Nat.Coprime (r + 21) smallPrimes then 21 else if Nat.Coprime (r + 22) smallPrimes then 22 else 0) = if Nat.Coprime (r + 18) smallPrimes then 18 else if Nat.Coprime (r + 19) smallPrimes then 19 else if Nat.Coprime (r + 20) smallPrimes then 20 else if Nat.Coprime (r + 21) smallPrimes then 21 else if Nat.Coprime (r + 22) smallPrimes then 22 else 0 := (ite_eq_right_iff (p := Nat.Coprime (r + 17) smallPrimes)).mpr (fun hp => False.elim (h17 hp))
  rw [hf]
  by_cases h18 : Nat.Coprime (r + 18) smallPrimes
  · have ht : (if Nat.Coprime (r + 18) smallPrimes then 18 else if Nat.Coprime (r + 19) smallPrimes then 19 else if Nat.Coprime (r + 20) smallPrimes then 20 else if Nat.Coprime (r + 21) smallPrimes then 21 else if Nat.Coprime (r + 22) smallPrimes then 22 else 0) = 18 := (ite_eq_left_iff (p := Nat.Coprime (r + 18) smallPrimes)).mpr (fun hnp => False.elim (hnp h18))
    rw [ht]
    exact hcAt 18 (by omega) (by omega) (fun k hk1 hk2 => by interval_cases k <;> assumption) h18
  have hf : (if Nat.Coprime (r + 18) smallPrimes then 18 else if Nat.Coprime (r + 19) smallPrimes then 19 else if Nat.Coprime (r + 20) smallPrimes then 20 else if Nat.Coprime (r + 21) smallPrimes then 21 else if Nat.Coprime (r + 22) smallPrimes then 22 else 0) = if Nat.Coprime (r + 19) smallPrimes then 19 else if Nat.Coprime (r + 20) smallPrimes then 20 else if Nat.Coprime (r + 21) smallPrimes then 21 else if Nat.Coprime (r + 22) smallPrimes then 22 else 0 := (ite_eq_right_iff (p := Nat.Coprime (r + 18) smallPrimes)).mpr (fun hp => False.elim (h18 hp))
  rw [hf]
  by_cases h19 : Nat.Coprime (r + 19) smallPrimes
  · have ht : (if Nat.Coprime (r + 19) smallPrimes then 19 else if Nat.Coprime (r + 20) smallPrimes then 20 else if Nat.Coprime (r + 21) smallPrimes then 21 else if Nat.Coprime (r + 22) smallPrimes then 22 else 0) = 19 := (ite_eq_left_iff (p := Nat.Coprime (r + 19) smallPrimes)).mpr (fun hnp => False.elim (hnp h19))
    rw [ht]
    exact hcAt 19 (by omega) (by omega) (fun k hk1 hk2 => by interval_cases k <;> assumption) h19
  have hf : (if Nat.Coprime (r + 19) smallPrimes then 19 else if Nat.Coprime (r + 20) smallPrimes then 20 else if Nat.Coprime (r + 21) smallPrimes then 21 else if Nat.Coprime (r + 22) smallPrimes then 22 else 0) = if Nat.Coprime (r + 20) smallPrimes then 20 else if Nat.Coprime (r + 21) smallPrimes then 21 else if Nat.Coprime (r + 22) smallPrimes then 22 else 0 := (ite_eq_right_iff (p := Nat.Coprime (r + 19) smallPrimes)).mpr (fun hp => False.elim (h19 hp))
  rw [hf]
  by_cases h20 : Nat.Coprime (r + 20) smallPrimes
  · have ht : (if Nat.Coprime (r + 20) smallPrimes then 20 else if Nat.Coprime (r + 21) smallPrimes then 21 else if Nat.Coprime (r + 22) smallPrimes then 22 else 0) = 20 := (ite_eq_left_iff (p := Nat.Coprime (r + 20) smallPrimes)).mpr (fun hnp => False.elim (hnp h20))
    rw [ht]
    exact hcAt 20 (by omega) (by omega) (fun k hk1 hk2 => by interval_cases k <;> assumption) h20
  have hf : (if Nat.Coprime (r + 20) smallPrimes then 20 else if Nat.Coprime (r + 21) smallPrimes then 21 else if Nat.Coprime (r + 22) smallPrimes then 22 else 0) = if Nat.Coprime (r + 21) smallPrimes then 21 else if Nat.Coprime (r + 22) smallPrimes then 22 else 0 := (ite_eq_right_iff (p := Nat.Coprime (r + 20) smallPrimes)).mpr (fun hp => False.elim (h20 hp))
  rw [hf]
  by_cases h21 : Nat.Coprime (r + 21) smallPrimes
  · have ht : (if Nat.Coprime (r + 21) smallPrimes then 21 else if Nat.Coprime (r + 22) smallPrimes then 22 else 0) = 21 := (ite_eq_left_iff (p := Nat.Coprime (r + 21) smallPrimes)).mpr (fun hnp => False.elim (hnp h21))
    rw [ht]
    exact hcAt 21 (by omega) (by omega) (fun k hk1 hk2 => by interval_cases k <;> assumption) h21
  have hf : (if Nat.Coprime (r + 21) smallPrimes then 21 else if Nat.Coprime (r + 22) smallPrimes then 22 else 0) = if Nat.Coprime (r + 22) smallPrimes then 22 else 0 := (ite_eq_right_iff (p := Nat.Coprime (r + 21) smallPrimes)).mpr (fun hp => False.elim (h21 hp))
  rw [hf]
  by_cases h22 : Nat.Coprime (r + 22) smallPrimes
  · have ht : (if Nat.Coprime (r + 22) smallPrimes then 22 else 0) = 22 := (ite_eq_left_iff (p := Nat.Coprime (r + 22) smallPrimes)).mpr (fun hnp => False.elim (hnp h22))
    rw [ht]
    exact hcAt 22 (by omega) (by omega) (fun k hk1 hk2 => by interval_cases k <;> assumption) h22
  -- the else branch is unreachable: the tab facts at q transfer to r
  exfalso
  let a := firstStep q
  have hasm : Nat.Coprime (r + a) smallPrimes := hCq a hQb.1 hQb.2 hQs
  have hal : 1 ≤ a := hQb.1
  have hau : a ≤ 22 := hQb.2
  interval_cases a
  all_goals
    · contradiction
/-- the step has period 30030 -/
theorem firstStepPeriodic (r : Nat) : firstStep (r + smallPrimes) = firstStep r := by
  have hA : firstStep (r + smallPrimes) = firstStep ((r + smallPrimes) % smallPrimes) := firstStepMod (r + smallPrimes)
  have hB : (r + smallPrimes) % smallPrimes = r % smallPrimes := by
    rw [Nat.add_mod, Nat.mod_self smallPrimes, Nat.add_zero, Nat.mod_mod r smallPrimes]
  have hC : firstStep ((r + smallPrimes) % smallPrimes) = firstStep (r % smallPrimes) := by rw [hB]
  have hD : firstStep (r % smallPrimes) = firstStep r := (firstStepMod r).symm
  exact (hA.trans hC).trans hD

/-- every step lands on the wheel, for every p (whole domain) -/
theorem firstStepGlobalSurvivor (p : Nat) : Nat.Coprime (p + firstStep p) smallPrimes := by
  let q := p % smallPrimes
  have h1 : firstStep p = firstStep q := by simpa [q] using firstStepMod p
  have hpos : 0 < smallPrimes := by decide
  have hq : q < smallPrimes := Nat.mod_lt p hpos
  have hdW : firstStep p < smallPrimes := by
    have hb := tabBounded q hq
    have hb2 : firstStep p ≤ 22 := by simpa [h1] using hb.2
    unfold smallPrimes
    exact lt_of_le_of_lt hb2 (by decide : 22 < 30030)
  have hsurv : Nat.Coprime (q + firstStep p) smallPrimes := by simpa [h1] using tabSurvivor q hq
  exact (gcdShift p (firstStep p) hdW).mpr hsurv

/-- the survivor map is periodic with period 120120 — the tile -/
theorem firstSurvivorPeriodic (p : Nat) :
    firstSurvivor (p + wheelPeriod) = firstSurvivor p + wheelPeriod := by
  have hwP : wheelPeriod % smallPrimes = 0 := by decide
  have h1 : firstStep (p + wheelPeriod) = firstStep p := by
    have hA : firstStep (p + wheelPeriod) = firstStep ((p + wheelPeriod) % smallPrimes) := firstStepMod (p + wheelPeriod)
    have hB : (p + wheelPeriod) % smallPrimes = p % smallPrimes := by
      rw [Nat.add_mod, hwP, Nat.add_zero, Nat.mod_mod p smallPrimes]
    have hC : firstStep ((p + wheelPeriod) % smallPrimes) = firstStep (p % smallPrimes) := by rw [hB]
    have hD : firstStep (p % smallPrimes) = firstStep p := (firstStepMod p).symm
    exact (hA.trans hC).trans hD
  unfold firstSurvivor
  rw [h1]
  ring

/-- the full-period survivor lanes lie in the eight 30030-wheel lanes (certified) -/
theorem fullLaneCoverage :
    Finset.card ((Finset.Ico 0 wheelPeriod).filter (fun p =>
      (p + firstStep p) % 24 ∈ [1, 5, 7, 11, 13, 17, 19, 23])) = 120120 := by native_decide

/-! ## pinned constants (data cross-check with loom13) -/

/-- the sharp witness: 9439 on wheel, 9440..9460 off-wheel, 9461 on -/
theorem sharpWitnessOn : Nat.Coprime 9439 smallPrimes := by decide
theorem sharpWitnessNoEarlier : ∀ k, 1 ≤ k → k ≤ 21 → ¬ Nat.Coprime (9439 + k) smallPrimes := by
  intro k hk1 hk21
  interval_cases k <;> decide

theorem sharpWitnessHit : Nat.Coprime 9461 smallPrimes := by decide

/-- the step from 9439 runs the full 22-tile -/
theorem firstStep9439 : firstStep 9439 = 22 := by native_decide

/-- wheel-point counts -/
theorem wheelCountBase :
    Finset.card ((Finset.Ico 0 smallPrimes).filter (fun p => Nat.Coprime p smallPrimes)) = 5760 := by native_decide

theorem wheelCountPeriod :
    Finset.card ((Finset.Ico 0 wheelPeriod).filter (fun p => Nat.Coprime p smallPrimes)) = 23040 := by native_decide

theorem periodCount : Finset.card (Finset.Ico 0 wheelPeriod) = 120120 := by native_decide

/-! — the TILED PATTERN: full-period survivor-lane histogram — -/
theorem laneHistogram_1 : laneHistogram 1 = 13204 := by native_decide
theorem laneHistogram_5 : laneHistogram 5 = 16826 := by native_decide
theorem laneHistogram_7 : laneHistogram 7 = 13204 := by native_decide
theorem laneHistogram_11 : laneHistogram 11 = 16826 := by native_decide
theorem laneHistogram_13 : laneHistogram 13 = 13204 := by native_decide
theorem laneHistogram_17 : laneHistogram 17 = 16826 := by native_decide
theorem laneHistogram_19 : laneHistogram 19 = 13204 := by native_decide
theorem laneHistogram_23 : laneHistogram 23 = 16826 := by native_decide

/-! ## #eval cross-checks (values = loom13 data) -/
#eval (firstStep 0 : Nat)  -- 1
#eval (firstStep 9439 : Nat)  -- 22
#eval (firstSurvivor 9439 : Nat)  -- 9461
#eval (survivorLane 9439 : Nat)  -- 5
#eval (laneHistogram 1 : Nat)  -- 13204
#eval (laneHistogram 23 : Nat)  -- 16826
end WheelTile
