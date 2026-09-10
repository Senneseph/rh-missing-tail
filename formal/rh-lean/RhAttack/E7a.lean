/-
  E7a instances — the five certified oracle instances, ported and
  cross-checked.

  PROVENANCE:
    Python oracle : scripts/rh/day006_e7a_action_identity.py
                    (dps-50, 5/5 PASS — residual record:
                     scripts/rh/out_day006_euler_action_identity.txt)
    Port values   : scripts/rh/out_day011_e7a_oracle20.txt — dps-20 LHS of
                    each instance (recorded 2026-09-10 for this port).
    Identity      : RhAttack/EulerAction.lean (eulerAction, proven exact).

  PART 1 — the identity IS the result: eulerAction proves series side =
  action side EXACTLY for every a, b, N ≤ M in every commutative ring.
  Nothing in this file is needed for the theorem.

  PART 2 — ported data (Part A): the integer data the instances are built
  from — the paths chi5 / lcgpm1, the partial sums APart, the segment
  endpoints — is cross-checked by #eval against the oracle's recorded
  values. Any transcription error would show up immediately (exact ℤ).

  PART 3 — the full numeric pipeline (Part B): the left side
      LHS := Σ_{n=N+1}^{M} a(n) · n^(−s)
  is re-evaluated here in LEAN FLOAT64 (Float re/im arithmetic — an
  independent implementation of the same formula exp(−s·Log n), using
  only the kernel-built-in Float.exp/sin/cos/log) and cross-checked
  against the oracle's dps-20 LHS values.  Design note: Mathlib 4.34's
  Complex/Real live over Cauchy quotients and are not #eval-able
  (Complex.exp is noncomputable), so the numeric cross-check runs over
  raw Float pairs instead — the identity itself is unaffected (it is
  exact, over any K).  Expected agreement: ~1e-13 (float64 accumulation
  over ≤1007 terms vs dps-20); a transcription error in any path /
  height / endpoint would show as ~O(0.01..1).
-/
import Mathlib
import RhAttack.EulerAction

set_option linter.style.header false

-- ===========================================================================
-- PART 2A — the ported integer data (exact #eval cross-checks)
-- ===========================================================================

/-- χ₅ — the character mod 5 of the oracle:
    n mod 5 ∈ {1,2,3,4,0} ↦ {1, −1, −1, 1, 0}. -/
def chi5 (n : ℕ) : ℤ :=
  match n % 5 with
  | 1 => 1
  | 2 => -1
  | 3 => -1
  | 4 => 1
  | _ => 0

/-- The oracle's deterministic ±1 pseudo-random path:
    x = (n · 2654435761) mod 2^32;  +1 iff bit 16 of x is 0. -/
def lcgpm1 (n : ℕ) : ℤ :=
  if ((n * 2654435761) % 4294967296 / 65536) % 2 = 0 then 1 else -1

/-- The five oracle heights (s = re + i·im), as in day006_e7a_action_identity.py. -/
def sT10 : (Float × Float) := (0.5, 10)    -- 0.5 + 10i
def sT100 : (Float × Float) := (0.5, 100)  -- 0.5 + 100i
def sT1 : (Float × Float) := (0.5, 1)      -- 0.5 + i
def s25T30 : (Float × Float) := (2.5, 30)  -- 2.5 + 30i

-- A(M), A(N) partial sums — exact integer cross-check of the ported
-- paths (values recorded in out_day011_e7a_oracle20.txt):
#eval (APart chi5 133 : ℤ)    -- oracle: -1
#eval (APart chi5 3 : ℤ)      -- oracle: -1
#eval (APart chi5 307 : ℤ)    -- oracle:  0
#eval (APart chi5 7 : ℤ)      -- oracle:  0
#eval (APart chi5 1012 : ℤ)   -- oracle:  0
#eval (APart chi5 12 : ℤ)     -- oracle:  0
#eval (APart lcgpm1 1007 : ℤ) -- oracle: -5
#eval (APart lcgpm1 7 : ℤ)    -- oracle:  1
#eval (APart lcgpm1 100 : ℤ)  -- oracle:  0
#eval (APart lcgpm1 1 : ℤ)    -- oracle: -1

-- ===========================================================================
-- PART 3 — LEAN FLOAT64 pipeline (independent numeric cross-check)
-- ===========================================================================

/-
  Complex numbers over Float, for the numeric cross-check only.

  Every "complex float64" value below is the plain pair  (re, im) :
  Float × Float  (z.1 = re, z.2 = im).  The built-in product instances
  over Float supply the additive structure (Float has a CommRing
  instance in core), so no hand-rolled class proofs are needed and
  everything stays kernel-computable.
-/

/-- exp for the float64 pipeline: e^(re+i·im) = e^re · (cos im + i·sin im). -/
def Fexp (z : Float × Float) : Float × Float :=
  (Float.exp z.1 * Float.cos z.2, Float.exp z.1 * Float.sin z.2)

/-- Euler-action weight  n^(−s)  =  exp(−s · Log n)  (n ≥ 1, principal log:
    for positive real n, Log n is real, so −s·Log n = (−re·L, −im·L)). -/
def Fwt (s : (Float × Float)) (n : ℕ) : Float × Float :=
  let L : Float := Float.log n.toFloat
  Fexp (-(s.1 * L), -(s.2 * L))

/-- Scalar multiplication (for the path values a(n) ∈ {−1, 0, 1}). -/
def Fscal (r : Float) (z : Float × Float) : Float × Float :=
  (r * z.1, r * z.2)

/-- The identity's LEFT side  Σ_{n=N+1}^{M} a(n)·n^(−s)  in float64.
    Sequential left-to-right float addition — the same order Python's `sum()`
    uses for the oracle's LHS.  (No algebraic type class is involved: Float
    does not carry provable ring axioms, so this is a bare computational
    pipeline, deliberately outside Mathlib's arithmetic layer.) -/
def FLHS (a : ℕ → Int) (s : (Float × Float)) (N M : ℕ) : Float × Float :=
  (M - N).rec (0.0, 0.0) fun L acc =>
    let t := Fscal (Float.ofInt (a (N + L + 1))) (Fwt s (N + L + 1))
    (acc.1 + t.1, acc.2 + t.2)

-- ===========================================================================
-- #eval cross-checks (float64) against out_day011_e7a_oracle20.txt (dps-20)
-- Expected agreement ~1e-13; a transcription error would show as O(1).
-- ===========================================================================

#eval ((FLHS chi5 sT10 3 133).1, (FLHS chi5 sT10 3 133).2)
---- oracle: (-0.3935750655861315 + 0.3218141589220558j)

#eval ((FLHS chi5 sT100 7 307).1, (FLHS chi5 sT100 7 307).2)
---- oracle: (-0.3439223900830738 + 0.5777203771118044j)

#eval ((FLHS chi5 sT1 12 1012).1, (FLHS chi5 sT1 12 1012).2)
---- oracle: (-0.00203485252188889 + 0.01488449530477962j)

#eval ((FLHS lcgpm1 sT10 7 1007).1, (FLHS lcgpm1 sT10 7 1007).2)
---- oracle: (0.4121619834763735 + 0.8997584419239654j)

#eval ((FLHS lcgpm1 s25T30 1 100).1, (FLHS lcgpm1 s25T30 1 100).2)
---- oracle: (-0.04633061976530637 - 0.2694496642335104j)
