/-
# (SliverEdge)  Low-t bookkeeping closure:  the sliver pin record and
the d = 1/2 edge atom.

The two remaining pinned low-t residuals of the S1LowT wire (ceiling
report, section 3 item 3) are now recorded EXPLICITLY in Lean, so the
wire consumes named records instead of anonymous functions:

SLIVER (0 < t0 < 707/50):  the C1b proven regime starts at 707/50 =
14.14, just above the first critical-line zero 14.134725...;  the
sliver below it carries NO zero of the line except the first one.
  - firstZeroPin:  the dps-30 recorded value (21 digits) of the first
    zero, as a safe rational pin of the day030 slice record.
  - sliverOnCount:  the pinned on-line zero count inside the sliver
    (= 1, the first zero;  the slice record's claim, data-adjacent).
  - The sliver window floor is carried by the P8Floor pinned family:
    p8_f_near_pin = 0.9975 (the measured near-detector minimum, the
    day-010 family;  KNOWN_LIMITATIONS H3:  a finite audit used as a
    universal constant — labeled MEASURED here, not a claim of
    uniformity) and p8_f_far_floor = 1.
  - SliverFacts:  the arithmetic record (proven by norm_num), in the
    S1LowT.SliceFacts pattern:  the wire takes it as a named
    hypothesis and the data claims ride on the pinned record.

EDGE (d0 = 1/2):  C1a's own-height atom is strict d < 1/2;  at the
edge the off-line candidate pair sits exactly on the lines Re = 1
and Re = 0 (edgePairAtZeroOne, PROVEN).  For the ACTUAL zero set of
zeta those positions are void by the classical zero-free regions
(hReZeroFree, CITED:  Hadamard / de la Vallée Poussin on Re = 1;
  the functional equation on Re = 0) — so the off-pair at the edge
is never a zero of the actual set (edgeVoid, PROVEN from the two):
  the strict-d<1/2 atoms cover everything the actual set can
present, and the edge remains a named hypothesis of the ABSTRACT
wire only (S4Asm pattern).

Honesty labels:  LEAN-PROVEN (norm_num record, edge geometry,
edgeVoid), PINNED (firstZeroPin, sliverOnCount, the P8Floor family —
sourced from the day030 slice record / day-010 audit), CITED (the
classical zero-free regions, per-reference docstrings).  NO RH claim.
Lean 4.33.1 + mathlib v4.33.1.
-/
import Mathlib
import RhAttack.B0
import RhAttack.B4
import RhAttack.B5
import RhAttack.P8Floor

namespace SliverEdge


/-- The safe rational pin of the first critical-line zero (the
    dps-30 recorded value 14.134725141734693790457, day030 slice
    record, 21 digits;  the record's noise floor is max |zeta|
    1.96e-12, far below the last kept digit's weight). -/
def firstZeroPin : ℚ := 14134725141734693790457 / 10 ^ 21

/-- The pinned on-line zero count inside the sliver (0, 707/50):
    exactly one (the first zero).  The day030 slice record's claim
    (data-adjacent;  the record is the 813-zero slice of S1LowT with
    first zero 14.134725.. and no zero below it). -/
def sliverOnCount : ℕ := 1

/-- The sliver's right edge:  the C1b proven regime starts here
    (707/50 = 14.14, just above the first zero). -/
def sliverEdge : ℚ := 707 / 50

/-- (PROVEN, norm_num)  the pin record:  the first-zero pin sits
    inside the sliver (14 < pin < 707/50),  the on-line count is 1,
    and the pinned floor family is ordered 0 < 0.9975 < 1 (the near
    pin below the far floor). -/
theorem sliverFacts :
    (14 : ℚ) < firstZeroPin ∧ firstZeroPin < sliverEdge ∧
    sliverOnCount = 1 ∧
    (0 : ℝ) < p8_f_near_pin ∧
    p8_f_near_pin < p8_f_far_floor :=
  ⟨by norm_num [firstZeroPin, sliverEdge], by norm_num [firstZeroPin, sliverEdge],
    rfl, by norm_num [p8_f_near_pin, p8_f_far_floor],
    by norm_num [p8_f_near_pin, p8_f_far_floor]⟩

/-- The sliver record as a NAMED proposition (the S1LowT.SliceFacts
    pattern):  the wire takes this as an explicit named hypothesis;
    the data claims (one zero on the line in the sliver, the floor
    family) ride on the pinned record. -/
def SliverRecord : Prop :=
    (14 : ℚ) < firstZeroPin ∧ firstZeroPin < sliverEdge ∧
    sliverOnCount = 1 ∧
    (0 : ℝ) < p8_f_near_pin ∧
    p8_f_near_pin < p8_f_far_floor

theorem sliverRecord : SliverRecord := sliverFacts

/-! ### The d = 1/2 edge -/

/-- (PROVEN)  the off-line candidate pair at offset d around the
    pole height γ sits at Re = 1/2 ± d:  at the edge d = 1/2 the two
    off-line points are exactly on the lines Re = 1 and Re = 0. -/
theorem edgePairAtZeroOne (γ : ℝ) :
    Complex.re (rhoPP γ (1 / 2)) = 1 ∧ Complex.re (rhoNP γ (1 / 2)) = 0 := by
  dsimp only [rhoPP, rhoNP, halfR]
  constructor
  · simp
    norm_num
  · simp

/-- (CITED, classical — named form by project discipline)  no member
    of the actual zero set of zeta lies on the lines Re = 0 or
    Re = 1.  References:  Re = 1 — Hadamard (1896) and de la Vallée
    Poussin (1900), the zero-free region used in the primary proof
    of the PNT (any standard reference, e.g. Titchmarsh,
    "The Theory of Number Theory", ch. II.6);  Re = 0 — a
    corollary of the functional equation
    ζ(s) = 2^s π^{s−1} sin(πs/2) Γ(1−s) ζ(1−s):  for s = it (t a
    nonzero real) the sine factor is i·sinh(πt/2) (never zero) and
    the remaining factors are nonzero, so ζ(it) = 0 would imply
    ζ(1 − it) = 0 — impossible by the Re = 1 result;  and
    ζ(0) = −1/2 ≠ 0 (Euler product at s = 0 via the functional
    equation, or the series evaluation). -/
def EdgeZeroFree (q : ZeroSet) : Prop :=
    ∀ ρ ∈ q.Z, ρ.re ≠ 0 ∧ ρ.re ≠ 1

/-- (PROVEN from the cited zero-free + the edge geometry)  at the
    edge d = 1/2 the off-line candidate pair is never a zero of the
    actual set:  the two off-line points sit on Re = 1 and Re = 0,
    both zero-free.  Hence the S2 window at the edge is VACUOUS for
    the actual set of zeta — the strict d < 1/2 own-height atoms
    cover everything the actual set can present. -/
theorem edgeVoid (q : ZeroSet) (hfree : EdgeZeroFree q) (γ : ℝ) :
    rhoPP γ (1 / 2) ∉ q.Z ∧ rhoNP γ (1 / 2) ∉ q.Z := by
  obtain ⟨hPP, hNP⟩ := edgePairAtZeroOne γ
  constructor
  · intro hPPz
    have hf := hfree _ hPPz
    have h2 : (rhoPP γ (1 / 2)).re ≠ 1 := hf.2
    rw [hPP] at h2
    exact h2 rfl
  · intro hNPz
    have hf := hfree _ hNPz
    have h2 : (rhoNP γ (1 / 2)).re ≠ 0 := hf.1
    rw [hNP] at h2
    exact h2 rfl

end SliverEdge
