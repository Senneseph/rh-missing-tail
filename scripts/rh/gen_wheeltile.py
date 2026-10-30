#!/usr/bin/env python3
# gen_wheeltile.py (v8, final)
#
# Emits formal/RhAttack/WheelTile.lean — the Lean 4 / Mathlib anchor for the
# WHEEL-TILE object of the Loom/Wheel/tile side-quest:
#
#   - the wheel = residues coprime to smallPrimes = 30030 = 2*3*5*7*11*13
#   - firstStep r = first d in 1..22 with r + d on the wheel (22-deep dite;
#     0-sentinel for the mathematically empty case)
#   - whole-base (30030) tab facts: bounded / survivor / no-earlier
#   - gcdShift / firstStepMod / firstStepPeriodic (the step sees only mod 30030)
#   - firstSurvivor p = p + firstStep p; firstSurvivorPeriodic (period 120120)
#   - laneHistogram L: full-period (120120) count of phases whose first
#     survivor lands in mod-24 lane L — the TILED PATTERN the wheel pops out of
#   - the sharp witness 9439 -> 22 (a full 22-tile: 9440..9460 off wheel)
#
# DATA CROSS-CHECK: scripts/sq/loom13_tile.py -> tmp/loom/loom13_out.txt
#
# SCOPE: off-board measurement/formal anchor for the side-quest object.
#   This module does NOT touch the RH endpoint (RHEnd) and makes no RH claim.
# TCB NOTE: the 30030/120120-domain tab, histogram and pinned-value facts use
#   `native_decide` (trusted native-runtime evaluation of closed computations);
#   the structural theorems (gcdShift, firstStepMod, periodicity, witnesses)
#   are ordinary proofs.
#
# Lean-syntax pitfalls discovered and worked around on this toolchain (4.33.1)
# via online docs + probes:
#   - `intro` / lambda-binder elaboration breaks on `<=` binders whose
#     consequence is an `Iff` (toolchain bug, reproduced standalone):
#     firstStepMod carries Coprime-consequence lemmas instead.
#   - `by decide` cannot synthesize through a user def at predicate position:
#     closed facts are stated with core `Nat.Coprime`, not `isWheelPoint`.
#   - `rw` with an `Iff` fails on dite predicates (dite carries a Decidable
#     instance argument; the motive is not type-correct): firstStepMod
#     reasons with pointwise forward lemmas + a minimality lemma instead.
#   - `Finset.toList` is noncomputable in this Mathlib: firstStep stays a
#     dite chain (pure to #eval, no sorrier).
#   - doc blocks must not precede `import`; plain comments in the header.

LANES = [1, 5, 7, 11, 13, 17, 19, 23]


def main():
    W = 30030
    P = 120120

    # ---- python simulation (source of the pinned values) ----
    def gcd(a, b):
        while b:
            a, b = b, a % b
        return a

    def isw(n):
        return gcd(n, W) == 1

    def first_step(r):
        for d in range(1, 23):
            if isw(r + d):
                return d
        return 0

    def first_survivor(r):
        return r + first_step(r)

    lanes_val = {}
    for L in LANES:
        lanes_val[L] = sum(1 for p in range(P) if first_survivor(p) % 24 == L)
    coverage = sum(lanes_val.values())
    wb = sum(1 for p in range(W) if isw(p))
    wp = sum(1 for p in range(P) if isw(p))
    assert coverage == P, coverage
    assert lanes_val == {1: 13204, 5: 16826, 7: 13204, 11: 16826,
                         13: 13204, 17: 16826, 19: 13204, 23: 16826}, lanes_val
    assert wb == 5760, wb
    assert wp == 23040, wp
    assert first_step(9439) == 22
    assert first_survivor(9439) == 9461
    assert isw(9439) and isw(9461)
    for k in range(1, 22):
        assert not isw(9439 + k)

    # ---- firstStep dite chain (0 sentinel) ----
    dite_lines = []
    for d in range(1, 23):
        indent = "  " * d
        if d == 22:
            dite_lines.append(indent + "if Nat.Coprime (r + " + str(d) + ") smallPrimes then "
                             + str(d) + " else 0")
        else:
            dite_lines.append(indent + "if Nat.Coprime (r + " + str(d) + ") smallPrimes then "
                             + str(d) + " else")
    firststep_def = "def firstStep (r : Nat) : Nat :=\n" + "\n".join(dite_lines)

    # ---- firstStepMod: O(n) dite peeling (split_ifs blows up on 22-dites) ----
    def inner(d):
        if d >= 22:
            return "0"
        t = "if Nat.Coprime (r + 22) smallPrimes then 22 else 0"
        for e in range(21, d, -1):
            t = "if Nat.Coprime (r + " + str(e) + ") smallPrimes then " + str(e) + " else " + t
        return t

    def head(d):
        if d < 22:
            return "(if Nat.Coprime (r + " + str(d) + ") smallPrimes then " + str(d) + " else " + inner(d) + ")"
        return "(if Nat.Coprime (r + 22) smallPrimes then 22 else 0)"

    bullets = []
    for c in range(1, 23):
        bullets.append("  by_cases h%d : Nat.Coprime (r + %d) smallPrimes" % (c, c))
        bullets.append("  · have ht : " + head(c) + " = " + str(c) +
                       " := (ite_eq_left_iff (p := Nat.Coprime (r + " + str(c)
                       + ") smallPrimes)).mpr (fun hnp => False.elim (hnp h%d))" % c)
        bullets.append("    rw [ht]")
        if c == 1:
            hctx = "(fun k hk1 hk2 => by omega)"
        else:
            hctx = "(fun k hk1 hk2 => by interval_cases k <;> assumption)"
        bullets.append("    exact hcAt " + str(c) + " (by omega) (by omega) " + hctx + " h%d" % c)
        if c < 22:
            bullets.append("  have hf : " + head(c) + " = " + inner(c)
                           + " := (ite_eq_right_iff (p := Nat.Coprime (r + "
                           + str(c) + ") smallPrimes)).mpr (fun hp => False.elim (h%d hp))" % c)
            bullets.append("  rw [hf]")

    HDR = """/-
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
""" + firststep_def + """

/-- the first on-wheel point strictly after `p` -/
def firstSurvivor (p : Nat) : Nat := p + firstStep p

/-- mod-24 lane of the first survivor after `p` -/
def survivorLane (p : Nat) : Nat := firstSurvivor p % 24

/-- full-period count of phases whose first survivor lands in lane L -/
def laneHistogram (L : Nat) : Nat :=
  Finset.card ((Finset.Ico 0 wheelPeriod).filter (fun p => (p + firstStep p) % 24 = L))
"""

    BASE = """
/-! ## whole-base (30030) tab facts — `native_decide` -/

/-- every base residue finds its survivor within 22 steps -/
theorem tabBounded : ∀ r < smallPrimes, 1 ≤ firstStep r ∧ firstStep r ≤ 22 := by native_decide

/-- the tabular survivor is on the wheel -/
theorem tabSurvivor : ∀ r < smallPrimes, Nat.Coprime (r + firstStep r) smallPrimes := by native_decide

/-- nothing earlier in 1..(step-1) is on the wheel -/
theorem tabNoEarlier :
    ∀ r < smallPrimes, ∀ k ∈ Finset.Ico 1 (firstStep r), ¬ Nat.Coprime (r + k) smallPrimes := by native_decide
"""

    GCD = """
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
"""

    fsm = [
        "",
        "/-- the step only sees the residue mod 30030 -/",
        "theorem firstStepMod (r : Nat) : firstStep r = firstStep (r % smallPrimes) := by",
        "  let q := r % smallPrimes",
        "  have hqB : q < smallPrimes := Nat.mod_lt r (by decide : 0 < smallPrimes)",
        "  have hQb : 1 ≤ firstStep q ∧ firstStep q ≤ 22 := tabBounded q hqB",
        "  have hQs : Nat.Coprime (q + firstStep q) smallPrimes := tabSurvivor q hqB",
        "  have hQn : ∀ k ∈ Finset.Ico 1 (firstStep q), ¬ Nat.Coprime (q + k) smallPrimes := tabNoEarlier q hqB",
        "  have hCr : ∀ d, 1 ≤ d → d ≤ 22 → Nat.Coprime (r + d) smallPrimes → Nat.Coprime (q + d) smallPrimes := by",
        "    intro d d1 d22 hp",
        "    have hdW : d < smallPrimes := by",
        "      unfold smallPrimes",
        "      exact lt_of_le_of_lt d22 (by decide : 22 < 30030)",
        "    simpa [q] using (gcdShift r d hdW).mp hp",
        "  have hCq : ∀ d, 1 ≤ d → d ≤ 22 → Nat.Coprime (q + d) smallPrimes → Nat.Coprime (r + d) smallPrimes := by",
        "    intro d d1 d22 hp",
        "    have hdW : d < smallPrimes := by",
        "      unfold smallPrimes",
        "      exact lt_of_le_of_lt d22 (by decide : 22 < 30030)",
        "    simpa [q] using (gcdShift r d hdW).mpr hp",
        "  -- minimality: a candidate c with P(c) and no earlier P is the q-step",
        "  have hcAt : ∀ c, 1 ≤ c → c ≤ 22 →",
        "      (∀ k, 1 ≤ k → k < c → ¬ Nat.Coprime (r + k) smallPrimes) →",
        "      Nat.Coprime (r + c) smallPrimes → c = firstStep q := by",
        "    intro c c1 c22 hctx hctxc",
        "    have hle : firstStep q ≤ c := by",
        "      by_contra hc",
        "      have hlt : c < firstStep q := Nat.not_le.mp hc",
        "      have him : c ∈ Finset.Ico 1 (firstStep q) := by",
        "        simp [Finset.mem_Ico]",
        "        exact ⟨c1, hlt⟩",
        "      have hno : ¬ Nat.Coprime (q + c) smallPrimes := hQn c him",
        "      have hq : Nat.Coprime (q + c) smallPrimes := hCr c c1 c22 hctxc",
        "      contradiction",
        "    have hge : c ≤ firstStep q := by",
        "      by_contra hc",
        "      have hlt : firstStep q < c := Nat.not_le.mp hc",
        "      have him : firstStep q ∈ Finset.Ico 1 c := by",
        "        simp [Finset.mem_Ico]",
        "        exact ⟨hQb.1, hlt⟩",
        "      have hno : ¬ Nat.Coprime (r + firstStep q) smallPrimes := hctx (firstStep q) hQb.1 hlt",
        "      have hnoq : ¬ Nat.Coprime (q + firstStep q) smallPrimes := fun hq => hno (hCq (firstStep q) hQb.1 hQb.2 hq)",
        "      exact hnoq hQs",
        "    omega",
        "  unfold firstStep",
    ]
    fsm.extend(bullets)
    fsm.append("  -- the else branch is unreachable: the tab facts at q transfer to r")
    fsm.append("  exfalso")
    fsm.append("  let a := firstStep q")
    fsm.append("  have hasm : Nat.Coprime (r + a) smallPrimes := hCq a hQb.1 hQb.2 hQs")
    fsm.append("  have hal : 1 ≤ a := hQb.1")
    fsm.append("  have hau : a ≤ 22 := hQb.2")
    fsm.append("  interval_cases a")
    fsm.append("  all_goals")
    fsm.append("    · contradiction")
    FSM = "\n".join(fsm)

    PERIOD = """
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
"""

    PINNED_head = """
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
"""

    lane_theorems = []
    for L in LANES:
        lane_theorems.append(
            "theorem laneHistogram_" + str(L) + " : laneHistogram " + str(L)
            + " = " + str(lanes_val[L]) + " := by native_decide")

    evals = [
        "",
        "/-! ## #eval cross-checks (values = loom13 data) -/",
        "#eval (firstStep 0 : Nat)  -- " + str(first_step(0)),
        "#eval (firstStep 9439 : Nat)  -- 22",
        "#eval (firstSurvivor 9439 : Nat)  -- 9461",
        "#eval (survivorLane 9439 : Nat)  -- " + str(first_survivor(9439) % 24),
        "#eval (laneHistogram 1 : Nat)  -- " + str(lanes_val[1]),
        "#eval (laneHistogram 23 : Nat)  -- " + str(lanes_val[23]),
    ]

    lean = (HDR + BASE + GCD + FSM + PERIOD + PINNED_head
            + "\n".join(lane_theorems) + "\n" + "\n".join(evals)
            + "\nend WheelTile\n")

    import os
    out = os.path.normpath(os.path.join(
        os.path.dirname(os.path.abspath(__file__)), "..", "..", "formal", "RhAttack", "WheelTile.lean"))
    with open(out, "w", encoding="utf-8") as f:
        f.write(lean)
    print("wrote %s: %d chars" % (out, len(lean)))


if __name__ == "__main__":
    main()
