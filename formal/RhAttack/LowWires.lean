/- LowWires — the LOW-BAND wire shape of the endpoint, machine-
    proven (the definitional zero wires below the program strip,
    and the squeeze shape they produce).

CONTEXT: the concrete endpoint RHEnd.rh_program78 runs the P1.2
walk spine at the R-residue wires of S4Asm (BwireR / MrR / MfR)
with devProg = S1LowT.devStripMin and the concrete floor floProg
(the unified S2 floor on the covered region, the near pin
elsewhere).  Below the program strip (t0 < 1000) the R-wires are
DEFINITIONALLY zero and the floor is the near pin 0.9975; this
module records those definitional facts and the squeeze shape
they force on the four low-band legs, so the low-band instance of
the walk spine is explicit:

  hs1    Qside >= devStripMin        (Mf = 0: zero side exact)
  hS2low devStripMin >= 0.9975       (the S2 low-band pin datum)
  hs3    Qside <= 0                  (the def-side wires are 0)
  hs4    0 < 0.9975                  (trivial - in body upstream)

which squeeze the zero-side scale at any low-band off-pair:
0.9975 <= devStripMin <= Qside <= 0, a contradiction (the live
engine - discovery 0089; the legs are the checkable data faces,
not a single unsatisfiable hypothesis).

HONESTY LABELS: LEAN-PROVEN (the definitional simplifications +
the squeeze shape).  NO RH claim: the legs themselves (hs1 /
hS2low / hs3) remain the named residual of the endpoint; this
module only pins the wire shape they run on. -/
import Mathlib
import RhAttack.S4Asm
import RhAttack.S1LowT
import RhAttack.RHEnd

open Real

noncomputable section

namespace LowWires

/-! ## Part A - the definitional wire shape below the strip. -/

/-- Below the program strip the R def-side wire BwireR is
    definitionally 0 (its outer regime test 1000 <= t0 fails). -/
theorem bwireR_low_zero (t0 d0 : ℝ) (ht0 : t0 < (1000 : ℝ)) :
    S4A.BwireR t0 d0 = 0 := by
  dsimp only [S4A.BwireR]
  rw [if_neg (fun h => lt_irrefl (1000 : ℝ) (lt_of_le_of_lt h.1 ht0))]

/-- Below the program strip the R M-side wire MrR is definitionally
    0 (same regime test). -/
theorem mrr_low_zero (t0 d0 : ℝ) (ht0 : t0 < (1000 : ℝ)) :
    S4A.MrR t0 d0 = 0 := by
  dsimp only [S4A.MrR]
  rw [if_neg (fun h => lt_irrefl (1000 : ℝ) (lt_of_le_of_lt h.1 ht0))]

/-- The zero-side reduction error wire is definitionally 0
    everywhere (the R form is exact on the zero side; the residual
    is carried by the def-side wires). -/
theorem mfr_zero (p : ℝ × ℝ) : S4A.MfR p = 0 := rfl

/-- The zero-side wire pair sums to 0 below the strip. -/
theorem wireSumLow (t0 d0 : ℝ) (ht0 : t0 < (1000 : ℝ)) :
    S4A.BwireR t0 d0 + S4A.MrR t0 d0 + S4A.MfR (t0, d0) = 0 := by
  dsimp only [S4A.MfR]
  rw [bwireR_low_zero t0 d0 ht0, mrr_low_zero t0 d0 ht0, zero_add, zero_add]

/-- The endpoint deviation wire below the strip is the strip
    deviation (definitional). -/
theorem devProg_low (t0 d0 : ℝ) :
    RHEnd.devProg (t0, d0) = S1LowT.devStripMin t0 d0 := rfl

/-- The endpoint floor below the strip is the near pin 0.9975
    (the covered-region branch of floProg does not fire). -/
theorem floProg_low_pin (t0 d0 : ℝ) (ht0 : t0 < (1000 : ℝ)) :
    RHEnd.floProg (t0, d0) = p8_f_near_pin := by
  dsimp only [RHEnd.floProg]
  rw [if_neg (fun h => lt_irrefl (1000 : ℝ) (lt_of_le_of_lt h.1 ht0))]

/-! ## Part B - the squeeze shape the low-band wires force. -/

/-- The low-band S4 leg is trivial at the pin (the in-body fact
    behind RHEnd's hs4low_pin, stated standalone): the wire sum is
    0, hence strictly below the near pin (0.9975 > 0). -/
theorem s4low_trivial (t0 d0 : ℝ) (ht0 : t0 < (1000 : ℝ)) :
    S4A.BwireR t0 d0 + S4A.MrR t0 d0 + S4A.MfR (t0, d0) < p8_f_near_pin := by
  rw [wireSumLow t0 d0 ht0]
  norm_num [p8_f_near_pin]

/-- THE LOW-BAND SQUEEZE SHAPE: the three nontrivial low-band legs
    (hs1 the zero side, hS2low the floor pin, hs3 the def-side
    wire) squeeze the zero-side scale at any low-band off-pair:
    0.9975 <= devStripMin <= Qside <= 0 - jointly contradictory.
    This is the live engine (discovery 0089): the legs are the
    checkable data faces (C2 >= side / the day-030 pin / the
    zero-wire shape), and their joint inconsistency at an existing
    low-band off-pair is what excludes such pairs. -/
theorem lowBandSqueezeShape (t0 d0 : ℝ)
    (Qside : ℝ × ℝ → ℝ)
    (h1 : S1LowT.devStripMin t0 d0 <= Qside (t0, d0))
    (hpin : p8_f_near_pin <= S1LowT.devStripMin t0 d0)
    (h3 : Qside (t0, d0) <= (0 : ℝ)) : False := by
  have hpos : (0 : ℝ) < p8_f_near_pin := by norm_num [p8_f_near_pin]
  have hchain : p8_f_near_pin <= (0 : ℝ) := by
    calc p8_f_near_pin <= S1LowT.devStripMin t0 d0 := hpin
      _ <= Qside (t0, d0) := h1
      _ <= 0 := h3
  nlinarith [hpos, hchain]

end LowWires
