/- ProbeMargin6 — standalone cross-check of the squeeze-wire
   contradiction arithmetic (the p9_point_contradiction content,
   re-proved here with NO RhAttack imports, Mathlib only).

   THE FACT: the squeeze 6-tuple

     Q >= dev - Mf  /\  dev >= flo  /\  Q <= Bf + Mr  /\
     Bf + Mr + Mf < flo

   is jointly UNSATISFIABLE for all real values: from
     Bf + Mr + Mf < flo <= dev   and   dev <= Q + Mf
   one gets Bf + Mr < Q, contradicting Q <= Bf + Mr.

   ROLE (NOT a dead-form finding): this unsatisfiability is the
   DESIGNED CORE of the live squeeze engine.  The P1.2 walk spine
   (P12Uniform.p1_2, after the 2026-10-16 Qside re-typing -
   discovery 0088) carries the SAME six reals as WIRE FUNCTIONS
   (Qside, devOf, flo, Mf, Bwire, Mr, each R x R -> R), evaluated
   at an off-pair (t0, d0).  The four legs are individually
   checkable data faces:
     hs1  zero side:        Qside >= devOf - Mf
     hs2  floor dominance:  devOf >= flo
     hs3  definition side:  Qside <= Bwire + Mr
     hs4  the squeeze:      Bwire + Mr + Mf < flo
   and their joint contradiction AT AN EXISTING off-pair is exactly
   what P9's closure (p9_closure_rh_of_margin, via
   p9_point_contradiction) uses: assume an off-line zero exists,
   take the minimum-height one, the wire hypothesis at its pair
   materializes this 6-tuple, and the arithmetic forces False -
   hence no off-line zero exists, i.e. RH.

   Contrast with the OLD dead form (pre-re-typing, discovery 0088):
   S3 was a standalone 'for-all (Q : R), Q <= Bwire + Mr'
   hypothesis - unsatisfiable inside the leg for ANY finite wire,
   independently of the other legs and of any off-pair - so no
   data could ever satisfy it (a tautological premise).  The
   re-typed form makes the contradiction JOINT across four
   checkable legs, which is the live squeeze.

   THIS file only re-verifies the arithmetic, independently. -/
import Mathlib

open Real

/-- The squeeze 6-tuple is jointly unsatisfiable (the
    p9_point_contradiction content, standalone). -/
theorem margin6_unsat (Q dev flo Mf Bf Mr : ℝ) :
    ¬ (Q >= dev - Mf ∧ dev >= flo ∧ Q <= Bf + Mr ∧ Bf + Mr + Mf < flo) := by
  intro h
  obtain ⟨hQ, hd, hB, hflo⟩ := h
  -- Bf + Mr + Mf < flo <= dev
  have hA : Bf + Mr + Mf < dev := lt_of_lt_of_le hflo hd
  -- dev <= Q + Mf  (from Q >= dev - Mf)
  have hBb : dev <= Q + Mf := by linarith [hQ]
  -- hence Bf + Mr + Mf < Q + Mf,  i.e. Bf + Mr < Q
  have hC : Bf + Mr < Q := by nlinarith [hA, hBb]
  -- but Q <= Bf + Mr
  exact lt_irrefl (Bf + Mr) (lt_of_lt_of_le hC hB)
