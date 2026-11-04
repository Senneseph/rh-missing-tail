import Mathlib.Data.Real.Basic
import Mathlib.Tactic.NormNum
import RhAttack.T4OffLM
import RhAttack.T4OffLO

set_option linter.style.whitespace false
set_option linter.style.longLine false
set_option linter.style.docString false

namespace T4OffLS
open T4OffLO
open T4OffLM

/-
  0284  ============  CT-5:  THE S-DIFF GATE IS STRUCTURALLY DEAD
      (for the uniform face claim over all t >= tPT2)  ============

  The 0276 gate says: IF, for every t >= tPT2, the unknown-side
  per-piece S-difference obeys c1(t) <= cGate  and  c2(t) <= cGate
  with cGate a FIXED FINITE threshold (2.5821 at tPT2, decaying
  1.3445 at t3, 1.2578 at t4), THEN every face window W(t) =
  (t-1, t+1] is empty.  This audits the uniform (all-t) form of
  that mechanism.  Result - it is impossible, for three reasons:

  (L1)  THE MEASURED ENVELOPE EXCEEDS THE GATE AT EVERY t.
        The per-piece S-diff constant on the (gData, t-1] piece is
        c1 = Smax(t) + Smax(GLAST) (0274 g2 envelope, HSXW 2022
        form;  0276 published input 12.9117 = 6.862091 + 6.049376).
        Its FIXED part is Smax(GLAST) = 6.049376, the measured
        S-maximum level at the data cut, independent of t.  But
        6.049376 > 2.5847 = cGateN = max(cGateA, cGateQ, cGateF,
        cGateN), the STRONGEST gate constant, and the profile
        decays below it.  Violation 2.34x at tPT2, diverging as
        t grows.  The published 12.9117 "5.00x miss" (0275-0278)
        is therefore not an asymptotic constant gap but a
        STRUCTURAL violation: one fixed measured number alone
        exceeds the whole gate.

  (L2)  THE ACTUAL S-DIFFERENCE IS UNBOUNDED in t (published).
        Unconditionally, S(t) = Omega±((ln t / ln ln t)^(1/3))
        (Ramachandra; standard Omega-lower bound, as recorded in
        Conrey's RH survey), so |S| is unbounded on every tail.
        With gData fixed, the piece S-diff
            |S(t-1) - S(gData)| >= |S(t-1)| - |S(gData)|
        is unbounded in t: for EVERY C there is t >= tPT2 with
        |S(t-1) - S(gData)| >= C.  Any VALID per-piece S-diff
        bound c1(t) must be at least this diff, hence unbounded;
        the gate threshold is fixed and finite.  The gate's
        ANTECEDENT (for all t >= tPT2, c1(t) <= cGate) is
        therefore FALSE for every uniform finite threshold
        profile.  The gate is a one-way sufficient criterion
        (hypothesis true => window empty), so it CANNOT close
        the face for all t >= tPT2: arbitrarily large t exist at
        which its hypothesis fails.  This is a theorem ABOUT THE
        METHOD - it makes no statement about the face itself.

  (L3)  CORRIGENDUM (0281/0282 CT framing).  "CT = a uniform
        all-t S-diff theorem below the first moment" does not
        exist: the statement is FALSE, given unbounded S.  The
        uniform gate route is dead.  A face exclusion, IF TRUE,
        must come from a NON-gate mechanism (t-adaptive, or
        direct zero-count machinery from the 1e15 census and
        R-vM, or a different reduction).  No such mechanism is
        available in present mathematics.  The S-route avenue of
        the program is now terminally closed THREE ways:
        measured (0283 realized wall), statistical (0278/0281
        first-moment wall), structural (this unit: antecedent
        false by the published unboundedness of S).

  Axioms (published, cited; the only non-derivable inputs):
    SUnbounded : for every C > 0 and every t0, some t >= t0 has
                 |S(t)| >= C.
                 [consequence of S(t) = Omega±((ln t / ln ln t)^(1/3)),
                  Ramachandra, unconditional.]
    SGdataBounded : |S(gData)| <= SmaxGLAST.
                 [SmaxGLAST = certified S-max on [0, GLAST],
                  0276 published input 6.049376 (measured).]

  face OPEN;  no zero-free claim;  NO RH CLAIM.  -/

variable (S : ℝ → ℝ)

/-  constants  (0276 published input;  day078)  -/
def  SmaxGLAST : ℚ := 6049376 / 10 ^ 6        --  6.049376
def  SmaxTPt2  : ℚ := 6862091 / 10 ^ 6        --  6.862091
def  sdiffPub  : ℚ := 129117  / 10 ^ 4        --  12.9117  (=  SmaxTPt2 + SmaxGLAST,  day078)
def  tPT2h     : ℝ := 3000175332800           --  frontier height (S4WinGate.WinC.tPT2)
def  gDataR    : ℝ := (gData : ℝ)             --  data cut (T4OffLM.gData)

axiom  SUnbounded  (C t0 : ℝ)  (hC : 0 < C)  :
    ∃  t : ℝ,  t >= t0  ∧  |S t| >= C

axiom  SGdataBounded  :
    |S gDataR|  <=  (SmaxGLAST : ℝ)

/-  (L1a)  the fixed measured S level alone exceeds the gate  -/
theorem  smaxExceedsGateN : (SmaxGLAST : ℝ) > (cGateN : ℝ)  := by
  norm_num  [SmaxGLAST,  cGateN]

theorem  smaxExceedsGateAll :
    (SmaxGLAST : ℝ) > (cGateA : ℝ)  ∧  (SmaxGLAST : ℝ) > (cGateQ : ℝ)  ∧
      (SmaxGLAST : ℝ) > (cGateF : ℝ)  ∧  (SmaxGLAST : ℝ) > (cGateN : ℝ)  :=
  ⟨by  norm_num  [SmaxGLAST,  cGateA],
   by  norm_num  [SmaxGLAST,  cGateQ],
   by  norm_num  [SmaxGLAST,  cGateF],
   smaxExceedsGateN⟩

/-  (L1b)  the published per-piece input exceeds 5x the gate  -/
theorem  sdiffPubAbove5Gate : (sdiffPub : ℝ) > 5 * (cGateA : ℝ)  := by
  norm_num  [sdiffPub,  cGateA]

/-  (L2a)  the piece S-diff is unbounded in t  -/
theorem  pieceSdiffUnbounded  (C : ℝ)  (hC : 0 < C)  :
    ∃  t : ℝ,  t >= tPT2h  ∧  |S (t - 1) - S gDataR| >= C  := by
  have  hsm0  :  (0 : ℝ) < SmaxGLAST  :=  by  norm_num  [SmaxGLAST]
  have  hCplus  :  0 < C + (SmaxGLAST : ℝ)  :=  by  linarith  [hC,  hsm0]
  obtain ⟨u, hu, hs⟩ := SUnbounded  S  (C + (SmaxGLAST : ℝ))  tPT2h  hCplus
  have  hsg  :  |S gDataR| <= (SmaxGLAST : ℝ)  :=  SGdataBounded  S
  use  u + 1
  constructor
  ·  have  h1  :  u + 1 >= tPT2h + 1  :=  by  linarith  [hu]
     have  h2  :  tPT2h + 1 > tPT2h  :=  by  norm_num  [tPT2h]
     linarith  [h1,  h2]
  ·  have  htri  :  |S u| <= |S u - S gDataR| + |S gDataR|  :=  by
        rw  [abs_le]
        constructor
        ·  linarith  [neg_le_abs  (S u - S gDataR),  neg_le_abs  (S gDataR)]
        ·  linarith  [le_abs_self  (S u - S gDataR),  le_abs_self  (S gDataR)]
     have  hlo  :  |S u - S gDataR| >= |S u| - |S gDataR|  :=  by  linarith  [htri]
     have  hsg2  :  |S u| - |S gDataR| >= C  :=  by  linarith  [hs,  hsg]
     rw  [show (u + 1) - 1 = u  from  by  ring]
     linarith  [hlo,  hsg2]

/-  (L2b)  the gate antecedent is FALSE (uniform,  every finite threshold)  -/
/-  GateHolds(T)  =  the 0276 gate antecedent for S-stream T:
      for all t >= tPT2h,  the piece S-diff |T(t-1) - T(gData)|
      is bounded by the gate constant cGateN.  -/
def  GateHolds  (T : ℝ → ℝ)  :  Prop  :=
    ∀  t : ℝ,  t >= tPT2h  →  |T (t - 1) - T gDataR| <= (cGateN : ℝ)

theorem  gateAntecedentFalse  :  ¬  GateHolds  S  := by
  intro  h
  have  hC  :  0 < (cGateN : ℝ) + 1  :=  by  norm_num  [cGateN]
  obtain ⟨t, ht, hd⟩ := pieceSdiffUnbounded  S  ((cGateN : ℝ) + 1)  hC
  have  hgt  :  (cGateN : ℝ) + 1 > (cGateN : ℝ)  :=  by  norm_num  [cGateN]
  have  hneq  :  |S (t - 1) - S gDataR| > (cGateN : ℝ)  :=  by  linarith  [hd,  hgt]
  exact  (not_le_of_gt  hneq)  (h  t  ht)

/-  (L2c)  the profile decays,  so the violation is uniform in the
    threshold:  exceeding cGateN (the tPT2 max) violates every
    profile gate (cGate4A < cGate3A < cGateA,  0281).  -/
theorem  profileDecays : (cGate4A : ℝ) < (cGate3A : ℝ)  ∧  (cGate3A : ℝ) < (cGateA : ℝ)  :=
  ⟨by  norm_num  [cGate4A,  cGate3A],  T4OffLO.cGate3tight⟩

/-  ============  CT-5  COMPOSITE  ============
    The S-diff gate cannot close the face for all t >= tPT2:
    (1) the measured envelope input already violates the gate at
        every t (fixed SmaxGLAST = 6.049376 > all gate constants),
        and at 5x the tPT2 gate;
    (2) the actual piece S-diff is unbounded in t (published
        unboundedness of S), so the gate antecedent is false for
        every uniform finite threshold;
    (3) the gate profile decays, so no profile gate is escape-able.
    The face stays OPEN;  this is a theorem about the METHOD.
    face OPEN;  no zero-free claim;  NO RH CLAIM.  -/
theorem  ct5GateDeath  :
    (SmaxGLAST : ℝ) > (cGateN : ℝ)  ∧
      (sdiffPub : ℝ) > 5 * (cGateA : ℝ)  ∧
        (¬  GateHolds  S)  ∧
          ((cGate4A : ℝ) < (cGate3A : ℝ)  ∧  (cGate3A : ℝ) < (cGateA : ℝ))  :=
  ⟨smaxExceedsGateN,  sdiffPubAbove5Gate,  gateAntecedentFalse  S,  profileDecays⟩

end T4OffLS
