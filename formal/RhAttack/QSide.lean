/- QSide — the zero-side scale Qside of the walk spine, as a NAMED
    DATA FACE (the day-020 audit band).

PURPOSE: the Qside contract (discovery 0088) names ONE concrete
zero-side scale in both S1 and S3 legs of the P1.2 walk:
  S1  hs1Q : Qside (t0, d0) >= devOf (t0, d0) - Mf (t0, d0)
  S3  hs3Q : Qside (t0, d0) <= Bwire (t0, d0) + Mr (t0, d0)
(the S2 floor dominance and S4 squeeze complete the closure -
discovery 0089).  This module pins WHAT Qside IS at the audit band:
the measured |zeta| fill

    Q(t) = resid(t) = |zeta(1/2 + i t) - K_on(t)|,

the section-10 LHS (A0 same-object: identically
|W_n - (K_on - (P_n - I))|) - the |zeta| fill under the
definition-side kernel K_on, measured at scan height t on the line,
straddling the candidate pair height g (window [g - 12, g + 12],
d-grid with d_min = 1/200).  At the same points the record carries
the kernel deviation dev(t) = |K_on(t)| * min_d |R(g,d,t) - 1|,
whose ratio dev/resid is the audit MARGIN (overall worst 112.6).
The A4.3-wired definition side (the S3 leg's bound) is pinned at the
Xval pin (out_day020_xval_pin.txt): the bound xvalPin dominates the
model residual |x| = xPin there with the 206x headroom.

SOURCE RECORDS (script + record, the program's data contract):
  scripts/rh/day020_worstcase.py
     -> scripts/rh/out_day020_worstcase.txt
     (4 candidate pairs g = nearest on-line zero to 980/1000/1020/
       1040; overall worst margin 112.6 at t = 1006.7916 with
       resid = 0.08168, dev = 9.198; "route-A pointwise decision
       resid < dev: HOLDS on the scanned windows")
  scripts/rh/day020_xval_pin.py
     -> scripts/rh/out_day020_xval_pin.txt
     (the Xval pin at t = 1000.041572, band (2000.083144, 1e5]:
       |x| = 0.019253844165493 <= Xval = 3.9665418656908,
       headroom Xval/|x| = 206.013)

RELATION TO THE WALK SPINE: the audit-point margin package
(hZero / hDef / hStrict) is formalized in Closure.lean's C6
(p9_audited_package_strict, p9_closure_at_audit_point) and its
spec (kainos-logos spec/c6-margin-wire-abstract.md).  This module
pins the DATA that package measures - the zero-side fill resid, the
deviation dev, and the A4.3-wired definition side - and
machine-verifies the arithmetic those claims rest on.  It does NOT
re-state the C6 letter mapping (that is Closure.lean's role); it
supplies the gated data face.

HONESTY LABELS:
  LEAN-PROVEN  the arithmetic gates (Parts B, C).
  PINNED       the record decimals (Part A; exact rationals in
               Part B, exact Float in Part C).
  MEASURED     resid / dev / |x| are measurements (mpmath, the
               day-020 scripts); carried as named data, never
               re-derived here.

NO RH claim: this module pins and gates a data face; it changes
nothing about the named residual of the endpoint. -/
import Mathlib

open Real

noncomputable section

namespace QSide

/-! ## Part A - the pinned day-020 constants (exact record
    decimals). -/

/-- The four candidate pair heights (the on-line zeros nearest
    980 / 1000 / 1020 / 1040). -/
def g1 : ℝ := 980.578001
def g2 : ℝ := 999.791572
def g3 : ℝ := 1019.912440
def g4 : ℝ := 1040.264038

/-- The straddle window half-width scanned per candidate. -/
def windowHalf : ℝ := 12

/-- The d-grid minimum of the audit (d = 1/200). -/
def dMin : ℝ := 0.005

/-- The OVERALL worst point (on pair g2, the candidate nearest
    1000), as printed by the record. -/
def tWorst : ℝ := 1006.7916
def residWorst : ℝ := 0.08168   -- the zero-side fill Q at the worst point
def devWorst : ℝ := 9.198       -- the kernel deviation at the worst point
def marginWorst : ℝ := 112.6    -- the audit margin dev/resid (overall worst)

/-- The Xval pin (out_day020_xval_pin.txt), at t = 1000.041572,
    band (2000.083144, 1e5]. -/
def tXval : ℝ := 1000.041572
def xPin : ℝ := 0.019253844165493     -- the model residual |x| at the pin
def xvalPin : ℝ := 3.9665418656908    -- the A4.3-wired bound (b3BoundExplicit RHS)
def headroom : ℝ := 206                -- the record prints headroom 206.013

/-- The audit-band predicate: the scan height lies in the straddle
    window of one of the four candidates. -/
def inAuditBand (t0 : ℝ) : Prop :=
    (t0 ≥ g1 - windowHalf ∧ t0 ≤ g1 + windowHalf) ∨
    (t0 ≥ g2 - windowHalf ∧ t0 ≤ g2 + windowHalf) ∨
    (t0 ≥ g3 - windowHalf ∧ t0 ≤ g3 + windowHalf) ∨
    (t0 ≥ g4 - windowHalf ∧ t0 ≤ g4 + windowHalf)

/-- The closing (overall-worst) scan point is in the audit band
    (pair g2's window). -/
theorem worstInBand : inAuditBand tWorst := by
  right; left; constructor
  · norm_num [tWorst, g2, windowHalf]
  · norm_num [tWorst, g2, windowHalf]

/-! ## Part B - the arithmetic gates (LEAN-PROVEN).  The record's
    arithmetic claims as exact-rational machine facts, C7-style:
    the printed decimals are exact rationals, so norm_num checks
    the claim exactly.  Per-pair rounded values are deliberately
    NOT checked (4-significant-figure print precision - the C7
    precision note applies to them). -/

/-- The overall-worst margin claim: devWorst ≥ marginWorst *
    residWorst, i.e. 9.198 ≥ 112.6 * 0.08168 (C7.1 restated at the
    Qside-face level - the 112.6x audited squeeze gap). -/
theorem gate_worst_margin : devWorst ≥ marginWorst * residWorst := by
  norm_num [residWorst, devWorst, marginWorst]

/-- The Xval headroom claim: xvalPin ≥ headroom * xPin, i.e.
    3.9665418656908 ≥ 206 * 0.019253844165493 (C7.2 restated -
    the |x| ≤ Xval pin PASS with 206x headroom). -/
theorem gate_xval_headroom : xvalPin ≥ headroom * xPin := by
  norm_num [xPin, xvalPin, headroom]

/-- The route-A pointwise decision at the closing point: the
    zero-side fill is positive and strictly below the kernel
    deviation (resid < dev; the band-level verdict "HOLDS on the
    scanned windows" is the data face this point closes on). -/
theorem gate_resid_below_dev : 0 < residWorst ∧ residWorst < devWorst := by
  constructor
  · norm_num [residWorst]
  · norm_num [residWorst, devWorst]

/-- The definition side dominates the band's worst zero-side fill:
    xvalPin > residWorst, i.e. the A4.3-wired bound read at the
    Xval pin exceeds the largest measured fill across the audit
    band (the hDef direction  Q ≤ Bwire + Mr  at the closing point,
    with 48x+ slack). -/
theorem gate_def_dominates_fill : 48 * residWorst ≤ xvalPin := by
  norm_num [residWorst, xvalPin]

/-! ## Part C - the Float gates (the #eval-readable form; per the
    pinned convention the gates are Float literals + Float
    arithmetic - a Real-derived #eval can abort on the sorry-axiom
    dependence).  Verified by inspection of the #eval output at
    gate time. -/

-- The overall-worst margin ratio, in Float: 9.198 / 0.08168.
#eval (9.198 : Float) / (0.08168 : Float)
-- Expected: ~ 112.61 (the record's 112.6 at print precision).

-- The Xval headroom ratio, in Float:
-- 3.9665418656908 / 0.019253844165493.
#eval (3.9665418656908 : Float) / (0.019253844165493 : Float)
-- Expected: ~ 206.01 (the record's 206.013).

-- The definition side over the worst fill, in Float:
#eval (3.9665418656908 : Float) / (0.08168 : Float)
-- Expected: ~ 48.56 (gate_def_dominates_fill pins 48x).

/-! ## Part D - the named data face (the datum, gated). -/

/-- The zero-side Qside datum at the closing audit point: the
    measured |zeta| fill (MEASURED). -/
def qsideWorst : ℝ := residWorst

/-- The kernel deviation at the closing audit point (MEASURED). -/
def devSideWorst : ℝ := devWorst

/-- The A4.3-wired definition-side bound, read at the Xval pin
    (PINNED). -/
def bwireXval : ℝ := xvalPin

/-- THE Qside DATA FACE, gated: at the closing (overall-worst)
    audit point the zero-side fill sits (i) positively below the
    kernel deviation (route-A, gate_resid_below_dev), (ii) below
    the A4.3-wired definition side with 48x+ slack (gate_def_
    dominates_fill), while (iii) the deviation clears the fill by
    the 112.6x audited margin (gate_worst_margin) and (iv) the
    definition side clears the model residual at the pin by 206x
    (gate_xval_headroom).  These four gated facts are the
    arithmetic core the audit-point margin package of Closure.lean
    C6 (hZero / hDef / hStrict) instantiates over; the per-point
    MEASURED values are the day-020 record, and the uniform
    extension of the face beyond the scanned window is the named
    open item, not a claim made here. -/
theorem qsideFaceGated :
    0 < qsideWorst ∧ qsideWorst < devSideWorst ∧
    48 * qsideWorst ≤ bwireXval ∧
    devSideWorst ≥ marginWorst * qsideWorst ∧
    xvalPin ≥ headroom * xPin := by
  refine ⟨gate_resid_below_dev.1, gate_resid_below_dev.2,
    gate_def_dominates_fill, gate_worst_margin, gate_xval_headroom⟩

end QSide
