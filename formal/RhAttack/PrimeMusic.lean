import Mathlib

/-
[PrimeMusic]  (side-quest certificate - the PATTERN-DIAGONAL / turned-away
meditation of 2026-10-28; docs/IDEA-SEED-PRIME-PATTERN-DIAGONAL-2026-10-28.md,
sections 7, 10, 11.)

STATUS: SIDE-QUEST FORMAL AIR, no rh claim. This module is OFF the RH
critical path (it does not import or feed RHEnd). It carries the
number-theoretic STRUCTURAL half of the turned-away meditation: the
8-band = +-1 lattice of {2,3}; the twin -2 block ("one short of the
line") exactly, with the first-prime exception; 2 halving the music; the
owner's exact 5-ledger; the 10 distinct five-grams below 47.

The MEASURED half of the meditation belongs to the data ledger (plan
file sections 7/10/11, probes scripts/rh/prime_pattern_diag_probe*.py,
scripts/rh/pattern_groove_*.py), NOT to this file:
  sum_{p<=2e6} 1/p = ln ln(2e6) + B1 + 4.97e-5          (B1 = 0.2614972128476...)
  prod_{p<=2e6} (1 - 1/p) = 0.99995030 * e^(-gamma)/ln(2e6)   (Mertens III)
  sum_{p<=2e6} (-ln(1 - 1/p) - 1/p) = 0.31571844 = gamma - B1 to 1e-8
  twin -2 block: twin share in the blocked class 0.000000/0.000000/0.000040/
    0.000000/0.000081 for q = 3,5,7,11,13 (the two tiny entries are exactly
    the first primes of the 7- and 13-lines: 5 -> 7, 11 -> 13)
  distance-one score D(p) (q <= 43): twin share 0.0424 (D=1) .. 0.1789 (D=9)
    at 1e8, monotone; the 24-word is scale-invariant 2e6 -> 1e8
    (the same 13 gap-letters, the same 114 2-grams, the same 962 3-grams)
  the void's axiom (retrocausal gain) holds: +0.06% at 2e6 (clean split),
    +0.26% at 1e8 (clean split, scale-free target) - both sub-2%
-/

open Nat Finset

namespace PrimeMusic

/-- The eight bands: the prime residues mod the 24-wheel. -/
def bands8 : Finset ℕ := {1, 5, 7, 11, 13, 17, 19, 23}

/-- The eight bands are exactly the residues coprime to 24 in (0, 24):
    the wheel's music spectrum. -/
theorem bands8_coprime : (Finset.Ico 1 24).filter (fun b => Nat.gcd b 24 = 1) = bands8 := by
  unfold bands8
  decide

/-- The eight bands form EXACTLY the +-1 lattice of the first two lines
    {2, 3}: every band is 1 (mod 2) and +-1 (mod 3) - zero exceptions at any
    scale (the meditation's piece (d): "it loses division by 2, the only even
    prime, by +1 or -1"). -/
theorem bands8_pm1_lattice :
    ([1, 5, 7, 11, 13, 17, 19, 23] : List ℕ).all
      (fun b => b % 2 = 1 ∧ (b % 3 = 1 ∨ b % 3 = 2)) := by
  decide

/- The twin -2 block: "one short of the line". The twin +2 step is blocked
   exactly when it lands ON a line (a multiple of a prime q); the only
   exception is the line's FIRST prime (p + 2 = q, i.e. the quotient k = 1:
   the line admits its first prime). Both halves, as pure number theory. -/

theorem twinMinusTwoBlocked (p q k : ℕ) (hq3 : 3 ≤ q) (hk : 2 ≤ k) (heq : p + 2 = q * k) :
    ¬ Nat.Prime (p + 2) := by
  intro hp2
  have hd : q ∣ p + 2 := by
    simp [heq]
  rcases hp2.eq_one_or_self_of_dvd q hd with (hq1 | hq2)
  · linarith
  · have hk1 : k = 1 := by
      have hq0 : 0 < q := by linarith
      nlinarith
    linarith

/-- The twin block has exactly ONE escape: k = 1, the line's first prime
    (p + 2 = q). If the +2 step lands on the q-line with quotient >= 2 it is
    blocked; if the landing IS the line's first note the step is the prime
    q itself. (The 5 -> 7 and 11 -> 13 twins at 2e6 are precisely this case.) -/
theorem twinEscapeFirstPrime (p q : ℕ) (hq : Nat.Prime q) (heq : p + 2 = q) :
    Nat.Prime (p + 2) := by
  simpa [heq.symm] using hq

/-- The -2 class of the 3-line, restricted to the bands: {1, 7, 13, 19}. -/
theorem minusTwoClass3 : bands8.filter (fun b => b % 3 = 1) = {1, 7, 13, 19} := by
  unfold bands8
  decide

/-- The -2 class of the 5-line, restricted to the bands: {13, 23}
    (the meditation's "5 blocks twins at 23/13"). -/
theorem minusTwoClass5 : bands8.filter (fun b => b % 5 = 3) = {13, 23} := by
  unfold bands8
  decide

/- The 2-halving and the owner's exact 5-ledger (from his 5 - 3 - 2 example):
    2 turns away 1/2 of the field (2 IS the line); 3 turns away 1/3 of the
    survivors = 1/6 of the field; 5 turns away 1/5 of the survivors =
    1/15 of the field; the survivors after 2,3,5 = 4/15. And the music
    halving: the factor (1 - 1/2) of the turned-away product is EXACTLY 1/2,
    so 2 halves the melody (the odd-only product = 2 x the full product). -/

theorem turnedAway2 : 1 - (1 : ℚ) / 2 = 1 / 2 := by norm_num

/-- The survivors after the lines {2, 3} are 1/3 of the field = the 8 bands
    out of 24. -/
theorem survivors23 : (1 - (1 : ℚ) / 2) * (1 - 1 / 3) = 1 / 3 := by
  norm_num
/-- The exact 5-ledger of the owner's example (5 - 3 - 2), stated cleanly: -/
theorem fiveLedgerSurvivors : (1 - (1 : ℚ) / 2) * (1 - 1 / 3) * (1 - 1 / 5) = 4 / 15 := by
  norm_num

theorem fiveLedgerMasses :
    (1 : ℚ) / 2 = 1 / 2 ∧ (1 / 2) * (1 / 3) = 1 / 6 ∧ (1 / 2) * (1 / 3) * (1 / 5) = 1 / 15 := by
  norm_num

theorem musicHalvingBy2 : ∀ (oddProduct : ℚ), (1 - (1 : ℚ) / 2) * oddProduct = oddProduct / 2 := by
  intro r
  ring

/- Five-gram witness (probe-0 C, re-derived 2026-10-28): the ten five-grams
    of the first fourteen primes (all primes below 47) are distinct - the
    prime word has no repeat at 5-gram scale below 47. -/

theorem fivegramsDistinct :
    List.Nodup [(2, 3, 5, 7, 11), (3, 5, 7, 11, 13), (5, 7, 11, 13, 17), (7, 11, 13, 17, 19),
      (11, 13, 17, 19, 23), (13, 17, 19, 23, 29), (17, 19, 23, 29, 31), (19, 23, 29, 31, 37),
      (23, 29, 31, 37, 41), (29, 31, 37, 41, 43)] := by
  decide

end PrimeMusic
