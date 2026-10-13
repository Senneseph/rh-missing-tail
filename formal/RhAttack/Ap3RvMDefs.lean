/-
Rh-missing-tail, D4 argument-principle line (ap4) -- the RvM main-term assembly
identity, in-house port.

Ported from https://github.com/anthropics/formal-math (the former
zeta-23-lean), commit e1a4e6508154, Apache License 2.0:
  * Copyright (c) 2026 Anthropic, PBC.
  * Copyright the PrimeNumberTheoremAnd contributors
    (https://github.com/AlexKontorovich/PrimeNumberTheoremAnd).
Provenance and license preserved per the project borrow rule; the port
is cited in formal/RH-LEAN-PROVENANCE.md.

Changes in this port (mechanical, per project convention):
  * `import Mathlib` (whole library) in place of per-file import
    lists;
  * content namespaced under `Ap2`;
  * intra-project imports redirected to RhAttack.Ap1*/Ap2*;
  * the Zeta23.Hypotheses import dropped where the part actually
    ported does not use the paper inputs (the definitions + the seam
    need no paper hypotheses).
-/
import Mathlib
import RhAttack.Ap2CountByIntegral
import RhAttack.Ap3Hypotheses
set_option linter.style.header false

namespace Ap3

open Ap2


open Complex

noncomputable section

namespace Ap3

/-- T is a zero-free ordinate: no nontrivial zero of ζ has Im ρ = T. -/
def GoodHeight (T : ℝ) : Prop := ∀ ρ : ℂ, IsNontrivialZero ρ → ρ.im ≠ T

/-- The right half-contour L = [½+iT₁ → 2+iT₁ → 2+iT₂ → ½+iT₂] integral of F, as three interval
integrals (bottom rightwards, right side upwards with ds = i dt, top leftwards). -/
def halfContour (F : ℂ → ℂ) (T₁ T₂ : ℝ) : ℂ :=
  (∫ σ in (1/2:ℝ)..2, F (σ + T₁ * I)) + (∫ t in T₁..T₂, F (2 + t * I)) * I
    - ∫ σ in (1/2:ℝ)..2, F (σ + T₂ * I)

lemma halfContour_add (F G : ℂ → ℂ) (T₁ T₂ : ℝ)
    (hb : IntervalIntegrable (fun σ : ℝ => F (σ + T₁ * I)) MeasureTheory.volume (1/2) 2)
    (hb' : IntervalIntegrable (fun σ : ℝ => G (σ + T₁ * I)) MeasureTheory.volume (1/2) 2)
    (hr : IntervalIntegrable (fun t : ℝ => F (2 + t * I)) MeasureTheory.volume T₁ T₂)
    (hr' : IntervalIntegrable (fun t : ℝ => G (2 + t * I)) MeasureTheory.volume T₁ T₂)
    (ht : IntervalIntegrable (fun σ : ℝ => F (σ + T₂ * I)) MeasureTheory.volume (1/2) 2)
    (ht' : IntervalIntegrable (fun σ : ℝ => G (σ + T₂ * I)) MeasureTheory.volume (1/2) 2) :
    halfContour (fun s => F s + G s) T₁ T₂ = halfContour F T₁ T₂ + halfContour G T₁ T₂ := by
  unfold halfContour
  rw [intervalIntegral.integral_add hb hb', intervalIntegral.integral_add hr hr',
    intervalIntegral.integral_add ht ht']
  ring

end Ap3

end Ap3
