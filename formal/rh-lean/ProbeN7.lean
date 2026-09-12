/- ProbeN7 — day-016: building `g =ᶠ[𝓝[s] x] f` (EventuallyEq) in 4.33.1.
   CONTEXT: B3Sbar's `rw [hd]` under a lambda binder failed; the intended
   fix was ContinuousWithinAt.congr_of_eventuallyEq_of_mem, which needs
   the =ᶠ. 
   RED PIN (the failing form, per probe standard): from a POINTWISE
   point-set equality `hfg : ∀ y ∈ s, g y = f y`, the construction
       show g =ᶠ[nhdsWithin x s] f from by simpa using hfg
   FAILS: "Expected a function because this term is being applied to
   the argument x". (4.33.1: no simp path from set-pointwise to
   eventuallyEq.)
   WORKING (green): `EventuallyEq.of_eq` from a FULL function equality.
   B3Sbar never needed this — it worked around the whole transfer by
   re-targeting the integrands (hf'pt/hf'bound end at the fTp form via
   congr_arg abs (hf'eq x hx)) and assembling continuity as
   ContinuousOn.mul + ContinuousOn.comp (Continuous, continuousOn)
   MapsTo-(fun _ _ => Set.mem_univ _). -/
import Mathlib

open Set Filter

example (s : Set ℝ) (x : ℝ) (g f : ℝ → ℝ) (heq : g = f) :
    g =ᶠ[nhdsWithin x s] f := by  -- 4.33.1: `𝓝[s] x` notation leaves ?m; long form
  exact Filter.EventuallyEq.of_eq heq
