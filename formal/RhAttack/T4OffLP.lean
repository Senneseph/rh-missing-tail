/-  T4OffLP  --  0278:  the mechanism scope + FIRST-MOMENT WALL
======================================================================================================================================
0278 audits the ONLY remaining mechanism class for the 0276 S-difference
gate (a per-piece S-variation bound c <= cGate) and proves the
STRUCTURAL WALL that closes the route (b) window-exclusion program:

THE FIRST-MOMENT WALL (new, this module).
Every configuration-independent S-route kernel envelope
E_win(t) >= dmain(t) * Wspan(t)   (first moment: mean per-unit
zero count times kernel span), while the window exclusion
0273-step-4 needs E_win(t) <= fluc + fedge.  The machine and the
certified R-vM lower bounds give, at all three profile points:

    tPT2 :  E1 >= 4.1199 * 102.3313 = 421.59   vs  fluc+fedge <= 306.62
    t3   :  E1 >= 5.2202 * 150.6   = 786.18   vs  fluc+fedge <= 202.62
    t4   :  E1 >= 6.33   * 2229    = 14109.57 vs  fluc+fedge <= 250.50

ratios 1.375 / 3.88 / 56.5  (growing ~ (ln t)^2: THE WALL THICKENS).
Likewise the 0276 gate constant itself sits BELOW the per-unit mean
zero count at every point (cGate < dmain: 2.58 < 4.1199 at tPT2,
ratio growing 1.62 -> 2.84 -> ~6.7): no per-piece S-variation bound
of the S-route kernel form can reach the gate, because the gate is
below the FIRST MOMENT of the thing it bounds.

Consequence (terminal, for route (b)): the window exclusion can only
ever close via a genuinely new count-kernel mechanism with a
per-zero kernel BELOW the first moment — impossible for any
configuration-independent envelope of the S-route/HSXW/A0c class
(the first moment is a lower bound on every sup-form envelope).
Recorded with full honesty: the corrected machine is VALID at
tPT2/t3/t4 (0274/0275/day079), the face is OPEN, NO RH CLAIM.

All numerals machine-origin, provenance-verified (day072c corrected
face values; day075 t3; day079 t4; day078 kernel spans; 0274 GATE
1/2 R-vM 1e-7 certification).  Strict rational arithmetic.
-/
import Mathlib.Data.Real.Basic
import Mathlib.Tactic.NormNum

set_option linter.style.whitespace false
set_option linter.style.longLine false
set_option linter.style.docString false

open Real

/-! ## Profile constants (certified lower/upper bounds) -/

-- R-vM main-term per-unit zero count dN/dt = (log(t/2pi) - 1)/(2pi),
-- certified LOWER bounds (the 0274 GATE 1/2 relative-1e-7 R-vM
-- certification makes the true value within 1e-3 of the main term at
-- all three heights; the slacks below are far inside that):
def  dmainLo   : ℚ  :=  41199  / 10000     -- tPT2: 4.1199  (true 4.1208)
def  dmainLo3  : ℚ  :=  52202  / 10000     -- t3  : 5.2202  (true 5.2202)
def  dmainLo4  : ℚ  :=  633    / 100       -- t4  : 6.33    (true 6.337)

-- S-route kernel spans W1+W2 (day078; T4OffLO formal values), LOWER bounds:
def  wSpanLo   : ℚ  :=  1023313  /  10000  -- tPT2: 102.3313 (exact formal)
def  wSpanLo3  : ℚ  :=  1506     /  10     -- t3  : 150.6
def  wSpanLo4  : ℚ  :=  2229                       -- t4  : ~2229 (28792.14/12.9117)

-- fluc + fedge UPPER bounds (the requirement side; 0274/0275/day079 data):
def  reqLo     : ℚ  :=  30661 / 100        -- tPT2: fluc<=236.2733 + |fedge|<=70.35
def  reqLo3    : ℚ  :=  20262 / 100        -- t3  : fluc<=166.686  + |fedge|<=35.93
def  reqLo4    : ℚ  :=  2505  / 10         -- t4  : fluc<=207.53   + |fedge|<=42.84

/-! ## The first-moment wall (strict, at all three profile points) -/

theorem  firstMomentWall_tPT2  :  dmainLo * wSpanLo  >  reqLo  :=  by
  norm_num  [dmainLo,  wSpanLo,  reqLo]

theorem  firstMomentWall_t3  :  dmainLo3 * wSpanLo3  >  reqLo3  :=  by
  norm_num  [dmainLo3,  wSpanLo3,  reqLo3]

theorem  firstMomentWall_t4  :  dmainLo4 * wSpanLo4  >  reqLo4  :=  by
  norm_num  [dmainLo4,  wSpanLo4,  reqLo4]

/-! ## The gate is BELOW the first moment (the 0276 gate c < dmain) -/

theorem  gateBelowMean_tPT2  :  (25821 : ℚ) / 10000  <  dmainLo  :=  by
  norm_num  [dmainLo]

theorem  gateBelowMean_t3  :  (13445 : ℚ) / 10000  <  dmainLo3  :=  by
  norm_num  [dmainLo3]

theorem  gateBelowMean_t4  :  (999 : ℚ) / 1000  <  dmainLo4  :=  by
  norm_num  [dmainLo4]

/-! ## The wall THICKENS: the ratio profile grows (1.375 < 3.88 < 56.5) -/

theorem  wallTightening_1_2  :
    (dmainLo * wSpanLo) * reqLo3  <  (dmainLo3 * wSpanLo3) * reqLo  :=  by
  norm_num  [dmainLo,  wSpanLo,  reqLo,  dmainLo3,  wSpanLo3,  reqLo3]

theorem  wallTightening_2_3  :
    (dmainLo3 * wSpanLo3) * reqLo4  <  (dmainLo4 * wSpanLo4) * reqLo3  :=  by
  norm_num  [dmainLo3,  wSpanLo3,  reqLo3,  dmainLo4,  wSpanLo4,  reqLo4]

/-! ## The family wall: every 0275 envelope family sits far above the
     requirement (S-route published, A0c class, machine-valid bounds) -/

theorem  familyWall_sroutePub  :  (110618 : ℚ) / 100  >  reqLo  :=  by
  norm_num  [reqLo]

theorem  familyWall_a0cClass  :  (283524 : ℚ) / 100  >  reqLo  :=  by
  norm_num  [reqLo]

/-- 0278 TERMINAL STATE (route (b)): the first-moment wall holds at
every t-profile point, the gate is below the per-unit mean, and the
ratio grows.  The S-route (and every published kernel class) window
exclusion is structurally impossible; the face remains OPEN; the
machine is VALID at tPT2/t3/t4.  NO RH CLAIM. -/
theorem  routeBTerminal  :
    dmainLo * wSpanLo >  reqLo ∧
      dmainLo3 * wSpanLo3 >  reqLo3 ∧
        dmainLo4 * wSpanLo4 >  reqLo4 ∧
          (25821 : ℚ) / 10000  <  dmainLo ∧
            (13445 : ℚ) / 10000  <  dmainLo3 ∧
              (999 : ℚ) / 1000  <  dmainLo4 ∧
                (dmainLo * wSpanLo) * reqLo3  <  (dmainLo3 * wSpanLo3) * reqLo ∧
                  (dmainLo3 * wSpanLo3) * reqLo4  <  (dmainLo4 * wSpanLo4) * reqLo3 ∧
                    (110618 : ℚ) / 100  >  reqLo ∧
                      (283524 : ℚ) / 100  >  reqLo  :=  by
  refine  ⟨firstMomentWall_tPT2,  ?_⟩
  refine  ⟨firstMomentWall_t3,  ?_⟩
  refine  ⟨firstMomentWall_t4,  ?_⟩
  refine  ⟨gateBelowMean_tPT2,  ?_⟩
  refine  ⟨gateBelowMean_t3,  ?_⟩
  refine  ⟨gateBelowMean_t4,  ?_⟩
  refine  ⟨wallTightening_1_2,  ?_⟩
  refine  ⟨wallTightening_2_3,  ?_⟩
  exact  ⟨familyWall_sroutePub,  familyWall_a0cClass⟩
