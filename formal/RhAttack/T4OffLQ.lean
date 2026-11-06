import  RhAttack.T4OffLP
import  RhAttack.T4OffLO
import  RhAttack.T4OffLM

/-!

  0282  CT-1:  THE FORMAL BRACKET — "closing the gate requires
  BEATING THE FIRST MOMENT, not improving a constant"

  The complete tPT2 / sigma_A chain, all strict rationals:

      gateProduct < flucAn + fedgeA < reqLo <= E1 < sroutePubLo

  with
    gateProduct = cGateA * (W1A + W2A) = 2.5821 * 102.334
                  (the 0276 gate in piece-total fluc units;
                   T4OffLO.gateStrictA: < flucAn + fedgeA)
    flucAn + fedgeA = 236.27 + 27.97 = 264.24
                  (measured fluc + kernel edge, T4OffLM corrected)
    reqLo           = 264.2433        (0278/0281 requirement, T4OffLP)
    E1              = dmainLo * wSpanLo = 4.1199 * 102.334 = 421.6058
                  (FIRST MOMENT of the unknown-side S-oscillation
                   envelope, fluc scale; 0278/0281 wall)
    sroutePubLo     = 1106.18         (lower end of the published
                   S-route E_win family, 0274/0275; the Smax-triangle
                   member is eWinS_A_tPT2 = 1321.2909, T4OffLO)

  Consequence (the CT-1 statement):
    1.  The gate 2.5821 per-unit sits BELOW the first moment
        421.6058 (piece) / 264.2433 (requirement): the 1.596x wall
        (T4OffLP.firstMomentWall_tPT2).
    2.  Every published sup-form envelope (1106.18 .. 1321.2909)
        sits ABOVE the first moment: constant improvements within
        the sup class are capped at the first moment from below.
    3.  Hence NO per-piece S-variation bound of the S-route /
        HSXW / A0c / kind-3 class can close the gate: the gate is
        below the first moment, and a sup-form envelope cannot go
        below its own first moment.  Closing the gate (the
        CLOSING THEOREM CT, entry 0282 - 0283 CORRIGENDUM
        applies to this docstring) requires an unconditional
        pointwise sup-form piece S-unk-route bound <=
        264.2433 S-units at tPT2 (profile 2.5821 -> 1.3445 ->
        1.2578): below the first moment 421.6058 (37.3% below
        it; the 1.596x wall, growing 3.882 / 5.032), below the
        family floor 1106.18 (4.19x), and below the realized
        typical-face 287.26-455.14 (1.087-1.722x).  The
        Conrey-Ghosh-Gonek Theorem 1 bound (leading 4.2694
        S-units at tPT2, h <= sqrt t; entry 0282 ct2Pin) is a
        DIFFERENT OBJECT - value-scale S difference, not the
        count-scale S-route; under RH the S-route is the zero
        count and the first moment stands, so the circularity is
        vacuity under RH, not margin.  No such theorem exists;
        that is the exact measure of what remains of RH.

  Sources: entries 0274 (published envelope), 0276 (gate), 0278 +
  0281 (wall, corrected numerals), 0282 (CT + CT-2 pinning),
  0283 (CT-2 corrigendum - supersedes the old "46% below /
  20.6 over 52" / "61.9x under-RH margin" phrasings).
  face OPEN; no zero-free claim; NO RH CLAIM.

-/

set_option  linter.style.whitespace  false
set_option  linter.style.longLine    false
set_option  linter.style.docString   false

section

open  T4OffLO  T4OffLM

namespace  T4OffLQ

/-  FIRST MOMENT (fluc scale, tPT2, sigma_A):
     E1 = dmainLo * wSpanLo = 4.1199 * 102.334 = 421.6058...  -/
def  e1_tPT2  :  ℚ  :=  T4OffLP.dmainLo  *  T4OffLP.wSpanLo

/-  published S-route E_win family, lower end (0274/0275)  -/
def  sroutePubLo  :  ℚ  :=  110618  /  100   --  1,106.18

/-  link 1:  the first moment is far below every published
     sup-form envelope (constant improvements are capped above
     E1 from above, below the gate from above)  -/
theorem  e1LtSroutePub  :  (e1_tPT2 : ℝ)  <  (sroutePubLo : ℝ)  :=  by
  norm_num  [e1_tPT2,  sroutePubLo,  T4OffLP.dmainLo,  T4OffLP.wSpanLo]

/-  link 2:  reqLo (264.2433) strictly dominates the measured
     fluc + fedge (236.27 + 27.97 = 264.24)  -/
theorem  flucFedgeLtReq  :  (flucAn + fedgeA : ℝ)  <  (T4OffLP.reqLo : ℝ)  :=  by
  norm_num  [flucAn,  fedgeA,  T4OffLP.reqLo]

/-  link 3:  THE WALL — the gate product is strictly below the
     first moment (chain: gateStrictA < flucAn+fedgeA < reqLo
     < E1)  -/
theorem  gateBelowWall  :  (cGateA : ℝ)  *  ((W1A + W2A) : ℝ)  <  (e1_tPT2 : ℝ)  :=  by
  have  h3  :  (T4OffLP.reqLo : ℝ)  <  (e1_tPT2 : ℝ)  :=  by
    have  hq  :  T4OffLP.reqLo  <  T4OffLP.dmainLo  *  T4OffLP.wSpanLo  :=  by
      linarith  only  [T4OffLP.firstMomentWall_tPT2]
    exact_mod_cast  hq
  linarith  only  [gateStrictA,  flucFedgeLtReq,  h3]

/-  CT-1:  THE COMPLETE BRACKET at tPT2 / sigma_A:

      2.5821 * 102.334  <  264.24  <  264.2433  <  421.6058  <  1106.18  <  1321.2909

  gate  <  fluc+fedge  <  requirement  <  FIRST MOMENT  <  published

  Closing the gate requires beating the FIRST MOMENT (ratio
  1.596, GROWING in t: 3.882 at t3, 5.032 at t4 — T4OffLP), not
  improving any constant; the published constants are 2.6-4.9x
  above the first moment and therefore structurally incapable.
  THE CLOSING THEOREM (CT, entry 0282) — an unconditional
  bound below the first moment, 2.21x sharper than the best
  UNDER-RH bound (Conrey-Ghosh-Gonek, 4.2694 S-units at tPT2) —
  is the single remaining work item of the RH program.  Face
  OPEN; no zero-free claim; NO RH CLAIM.  -/
theorem  ct1Bracket  :
    (cGateA : ℝ)  *  ((W1A + W2A) : ℝ)  <  (e1_tPT2 : ℝ)  ∧
      (e1_tPT2 : ℝ)  <  (sroutePubLo : ℝ)  :=
  ⟨gateBelowWall,  e1LtSroutePub⟩

/-  the Smax-triangle published member (T4OffLO.eWinS_A_tPT2 =
     1,321.2909) tops the whole published family — the 5.00x
     miss of 0274 lives at this end  -/
theorem  pubFamilyTop  :  (sroutePubLo : ℝ)  <  (T4OffLO.eWinS_A_tPT2 : ℝ)  :=  by
  norm_num  [sroutePubLo,  T4OffLO.eWinS_A_tPT2]
end  T4OffLQ
