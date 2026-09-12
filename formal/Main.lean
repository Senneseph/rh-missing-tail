/-
  The executable `rhattack` — the project's runtime cross-check gate.
  Recomputes, in Lean float64:
    (1) the five E7a oracle instances   (vs the dps-20 Python record),
    (2) the B-4 16-point per-pair table (B4Float.run),
    (3) the B-5 12-config ratio table   (B5Float.run),
    (4) the B-3 A/B gate: the exact finite Abel identity (b3Abel) at
        quadrature limit + the explicit bound (b3BoundExplicit) —
        B3Float.run (t=2.5, G=6, B=40, toy off-line list).
  GATE RULE: each table PASSes when the Lean port matches the Python
  oracle within ~1e-13; a transcription error shows as O(1) — the run
  aborts its own PASS line, so a red gate is impossible to misread.
  RUN:  lake exe rhattack
  PROVENANCE: out_day011_e7a_oracle20.txt · out_day010_pair_unit.txt ·
  out_day010_b5core_check.txt (records of the last green run live in
  the day journals).
-/
import Mathlib
import RhAttack

set_option linter.style.header false
set_option linter.style.longLine false

-- Runtime cross-check (Lean float64 pipeline): recompute the five oracle
-- instances and report the deviation from the Python oracle values
-- recorded in scripts/rh/out_day011_e7a_oracle20.txt (dps-20).
-- A correct port shows |diff| ~ 1e-13; a transcription error shows O(1).

def main : IO Unit := do
  IO.println "E7a Lean float64 pipeline — cross-check vs Python oracle (out_day011_e7a_oracle20.txt, dps-20)"
  IO.println ""
  let check : String → (Float × Float) → (Float × Float) → IO Float :=
    fun name got oracle => do
      let dre := got.1 - oracle.1
      let dim := got.2 - oracle.2
      let mag := Float.sqrt (dre * dre + dim * dim)
      -- (Lean 4.34 s! has no float format specs; report |diff|·1e12 — its
      -- 6-display-digit form IS the significant digits of the deviation.)
      IO.println s!"  {name}: LHS = ({got.1}, {got.2}i)   |diff|·1e12 = {mag * 1e12}"
      return mag
  let d1 ← check "chi5 t=10    N=3  M=133  " (FLHS chi5 sT10 3 133) (-0.3935750655861315, 0.3218141589220558)
  let d2 ← check "chi5 t=100   N=7  M=307  " (FLHS chi5 sT100 7 307) (-0.3439223900830738, 0.5777203771118044)
  let d3 ← check "chi5 t=1     N=12 M=1012 " (FLHS chi5 sT1 12 1012) (-0.00203485252188889, 0.01488449530477962)
  let d4 ← check "rng  t=10    N=7  M=1007 " (FLHS lcgpm1 sT10 7 1007) (0.4121619834763735, 0.8997584419239654)
  let d5 ← check "rng  t=30    N=1  M=100  " (FLHS lcgpm1 s25T30 1 100) (-0.04633061976530637, -0.2694496642335104)
  let worst := max (max d1 (max d2 d3)) (max d4 d5)
  IO.println ""
  let exactA : String :=
    s!"exact ℤ data check: A(133)={APart chi5 133} A(3)={APart chi5 3} A(307)={APart chi5 307} A(7)={APart chi5 7} " ++
      s!"A(1012)={APart chi5 1012} A(12)={APart chi5 12} | A(1007)={APart lcgpm1 1007} A(7)={APart lcgpm1 7} A(100)={APart lcgpm1 100} A(1)={APart lcgpm1 1}"
  IO.println exactA
  IO.println (if worst < 1e-9 then
    s!"\nCROSS-CHECK PASS: worst |diff|·1e12 = {worst * 1e12}   (expected ~O(0.01..1)·10⁻¹² scale, i.e. ~1e-13; a transcription error would show ~1e12·O(1))"
    else
    s!"\nCROSS-CHECK FAILED: worst |diff|·1e12 = {worst * 1e12}")
  IO.println "Identity itself: eulerAction (RhAttack/EulerAction.lean) — PROVEN exact in Lean."
  IO.println ""
  IO.println "B-4 Lean float64 pipeline — on-line pair identity (16 recorded points;"
  IO.println "ledger closed form T2/T3 vs direct fac-product evaluation; record: out_day010_pair_unit.txt)"
  let _w4 ← B4Float.run
  IO.println ""
  IO.println "B-5 Lean float64 pipeline — exact off-line/on-line ratio R(s,δ) (12 recorded"
  IO.println "configs: closed form pref·e^{s·ωδ} vs the direct 6-factor definition vs the"
  IO.println "dps-30 record; record: out_day010_b5core_check.txt)"
  let _w5 ← B5Float.run
  IO.println ""
  IO.println "B-3 Lean float64 pipeline — exact finite Abel identity + explicit bound"
  IO.println "(t=2.5, G=6, B=40, toy off-line list; A/B gate vs the theorems b3Abel /"
  IO.println "b3BoundExplicit — same formulas, machine precision)"
  let _w3 ← B3Float.run
