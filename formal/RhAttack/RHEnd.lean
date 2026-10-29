/- RHEnd  --  THE  ENDPOINT  (the  actual  zeta  zero  set,  [Z78]
   woven  in,  MAXIMAL  CONCRETIZATION).

   What  this  module  is
   ----------------------
   The  program's  one-clause  endpoint,  stated  on  the  ACTUAL
   zero  set  under  the  named  external  input  [Z78]  (Re  s
   >  7/8  zero-free;  kernel-verified,  human  review  in
   progress),  with  the  wire  of  the  contraction  made
   CONCRETE  everywhere  it  can  be,  and  the  residual  named
   exactly.  The  engine  is  S4A.rh_from_regime_closures
   (P1.2  with  S4  supplied  by  the  regime  closures);  the
   instantiation  here:

     Mf     :=  Z78P12.MfP      (the  residue  tail  =  0)
     devOf  :=  devProg  =  S1LowT.devStripMin   (the  concrete
                 strip  detector)
     Bwire  :=  Z78P12.BwireP,  Mr  :=  Z78P12.MrP
                 (the  concrete  residue  wires)
     flo    :=  floProg  =  floStripMin  on  the  covered
                 region  (1000  <=  t0,  d0  <=  1/2)  and  the
                 near  pin  0.9975  elsewhere.

   PROVEN  IN  THE  BODY  (no  hypothesis):
     *  S2  on  the  covered  region  -  s2ActualFullBand
        (FloorUnif,  the  unified  S2  floor  for  the  actual
        set)  against  the  unified  floor.
     *  S4  on  the  covered  STRIP  band  -  s4StripUnifiedFloor
        (the  squeeze  and  the  S2  floor  are  ONE  object  on
        1/200  <=  d0  <=  1/2).
     *  S4  on  the  LOW  band  -  TRIVIAL:  the  residue  wires
        are  0  below  1000  and  the  floor  is  the  pin
        (0  <  0.9975).
     *  the  FAR  region  -  VACUOUS  from  [Z78]  alone
        (offPairFarEmpty:  d0  <=  3/8  <  1/2).

   NAMED  RESIDUAL  (exactly  the  program's  open  legs,  with
   the  shape  and  support  recorded):  the  Q  of  the  S1/S3
   legs  is  ONE  CONCRETE  SCALE  Qside  (the  measured  |zeta|
   fill  under  the  A4.3  residual  wire)  -  the  2026-10-16
   re-typing  of  the  walk  spine  (the  old  exists-Q  /
   for-all-Q  form  decoupled  the  legs  and  made  S3
   unsatisfiable  for  any  finite  wire):
     *  hs1  -  the  S1  zero-side  witness:  Qside  >=  devProg
        at  every  off-pair  (Mf  =  0  -  the  E1  content,
        whose  uniform  face  is  S1Uniform;  the  data  clauses
        are  E1ClauseV3  q  7000  above  G  and  E1Clause  q  2
        below  G).  The  scale  Qside  is  a  named  parameter
        (concretized  by  the  |zeta|-fill  data  face).
     *  hs3  -  the  S3  definition-side  wire:  the  same  Qside
        is  below  BwireP  +  MrP.
     *  hWin  -  the  S4  WINDOW-PIN  residual  (1000  <=  t0,
        0  <  d0  <  1/200):  the  25m/25ab  window  closure
        s4asm_window_region_S4  is  pinned  at  the  near  pin
        0.9975,  while  the  unified  S2  floor  there  is
        floStripMin  <=  own  mass  <=  6e-4  -  the  gap
        between  the  two  (Part  C  gate)  is  the  shape  of
        the  bound-level  residue.
     *  hS2low  -  the  S2  LOW-BAND  pin  (0  <  t0  <  1000):
        devProg  >=  0.9975  -  the  H6  pin  regime  (the
        C1b  window  floor  dies  for  t0  <  25,  so  the  low
        band  runs  on  the  pin);  data-verified  territory
        per  the  program  chart;  the  sliver  part
        (t0  <  707/50)  is  VACUOUS  under  the  named
        on-line  record  honline  (sliverOffPairsEmpty).
        (LowExcl:  the  three  low-band  legs  hs1  /  hs3  /
        hS2low  are  JOINTLY  contradictory  at  any  low-band
        point  for  ANY  Qside,  ANY  devProg  -  so  the
        obligation  to  support  them  at  EVERY  off-pair
        SELF-EXCLUDES  low-band  off-pairs  by  pure  logic;
        the  data  program  feeds  the  legs  only  at  1000
        and  above.)

   PART  B7  (discovery  0119):  the  machined  stripfront
        endpoint  (rh_program78_stripfront_mach  /  _PT2):
        G-hs3  in  the  strip  band  above  the  frontier  is
        MACHINED  to  the  LIFTED  wires  -  the  S3  face  now
        carries  the  OFF-LINE  EM  wall  (t4o_sOff,  n4
        schedule)  plus  the  OFF-LINE  lifted  M-wire
        (t4m_MwireOff,  the  CITED  1.6  convexity  mass  of
        T4OffM),  the  S3  leg  closes  in  body  from  the
        face  +  T4OffD  (wall  <=  strip  B-wire),  and  the
        S4  strip  leg  is  t4m_margin  (lifted  wire  <
        floStripMin,  in  body).  The  named  residue  of  the
        stripfront  endpoint  is  thus  G-hs1  (open,  as
        before),  the  window  zero-exclusion  face  (open,  as
        before),  and  the  machined  hs3  face  -  whose
        content  is  the  CITED  classical  1.6  convexity
        mass,  not  an  analytic  barrier  in  the  tree.

   PART  B8  (discovery  0120):  G-hs1  restated  over  the
        strip  band  as  the  PIN  FAMILY  at  the  witness
        zero  (the  B2  shape  restricted  to  1/200  <=  d0
        <=  1/2):  rh_program78_stripfront_mach_s1pins  (+
        _PT2)  -  the  hs1  scale  face  is  entered  as  the
        P1  fill  /  P2  kernel-magnitude  /  P3  A4.3  mass
        /  P4  absorption  pins  at  the  strip-band  witness,
        derived  in  body  via  S1Face.hs1AtZero.  No  RH
        claim.

   PART  B9  (discovery  0122):  the  hs3  face  SPLIT  BY
        FLANK  (rh_program78_stripfront_mach_left  /  _PT2):
        the  off-pair  (t0,  d0)  records  no  flank  -  the
        B7/B8  machinery  lives  at  the  RIGHT  canonical
        point  (t4o_sOff,  re  =  1/2  +  d0).  At  the  LEFT
        flank  (re  =  1/2  -  d0)  T4OffL  (discovery  0121)
        records  that  the  uniform  n^4  wire  CANNOT  carry
        the  same  load  -  the  first  T4  term  at  the  left
        point  exceeds  the  endpoint  floor  on  the  band
        edge  for  t  >=  10^10  and  is  above  the  half-floor
        at  EVERY  schedule  at  sigma  =  0.  Part  B9  states
        the  endpoint  with  the  face  split:  right  =  the
        machine-closable  shape  (wall  at  t4o_sOff  +  lifted
        M-wire,  T4OffD  in  body  -  the  B7  premise  restricts
        to  it,  t4l_rightFaceOfSingle);  left  =  the  PAIR-
        LEVEL  S3  squeeze  (Qside  <=  Bwire  +  Mr)  -  the
        named  analytic  face  G-hs3-left.  The  residual  of
        the  split  endpoint  is  EXACTLY  the  four-face
        ledger  of  discovery  0121.  No  RH  claim.

   Honesty  (locked):  this  is  a  composition  around  the
   named  items;  NOTHING  new  is  claimed  -  the  residual
   is  the  SAME  residual  the  chart  carries  (S1  witness,
   S3  wire,  low  band,  window  pin),  now  stated  ONCE,  at
   the  concrete  wire,  as  the  single  endpoint  theorem
   rh_program78.  No  RH  claim.  -/
import Mathlib
import RhAttack.B0
import RhAttack.S4Asm
import RhAttack.S1LowT
import RhAttack.FloorUnif
import RhAttack.Z78Strip
import RhAttack.Z78P12
import RhAttack.Z78Liu
import RhAttack.Z78Track
import RhAttack.Z78Gao
import RhAttack.Z78Collet
import RhAttack.Z78Sil30
import RhAttack.Z78Arvi31
import RhAttack.Z78Sil32
import RhAttack.Z78FineChain
import RhAttack.Z78DensityRefined
import RhAttack.W2Beyond0
import RhAttack.A1Growth
import RhAttack.W2Telescope
import RhAttack.S4WinCap
import RhAttack.WinCount
import RhAttack.P4Limit
import RhAttack.S1Face
import RhAttack.P8Floor
import RhAttack.S4Strip
import RhAttack.T4OffD
import RhAttack.T4OffM

set_option linter.style.docString false
set_option linter.style.longLine false

namespace RHEnd

open Real B0 P12

/-  ##  The  concrete  wire  of  the  endpoint  -/
/--  The  concrete  detector  (the  strip  detector,  pair
    form  -  the  engine  wants  functions  of  ℝ  x  ℝ).  -/
noncomputable def devProg (p : ℝ × ℝ) : ℝ :=
    S1LowT.devStripMin p.1 p.2

/--  The  concrete  squeeze  floor:  the  UNIFIED  S2  floor
    on  the  covered  region  (where  the  squeeze  runs),  the
    near  pin  elsewhere  (the  residue  wires  are  0  there -
    the  low  band  and  the  far  region  -  so  any  positive
    floor  works;  the  pin  is  the  program's  H6  datum).  -/
noncomputable def floProg (p : ℝ × ℝ) : ℝ :=
    if 1000 ≤ p.1 ∧ p.2 ≤ 1 / 2 then S1LowT.floStripMin p.1 p.2
    else p8_f_near_pin

/-  ##  The  in-body  closures  -/
/--  S2  on  the  covered  region  (the  unified  floor):
    devProg  >=  floProg  is  exactly  s2ActualFullBand.  -/
private theorem hs2_covered (q : ZeroSet)
    (honline : ∀ ρ ∈ q.Z, 0 < (|ρ.im| : ℝ) → (|ρ.im| : ℝ) <
      (707 : ℝ) / 50 → ρ.re = 1 / 2)
    (t0 d0 : ℝ) (ht0 : 0 < t0) (ht0k : 1000 ≤ t0) (hd0 : 0 < d0)
    (hd0u : d0 ≤ 1 / 2) (hp : offPair q t0 d0) :
    devProg (t0, d0) ≥ floProg (t0, d0) := by
  dsimp only [devProg, floProg]
  rw [if_pos ⟨ht0k, hd0u⟩]
  exact FUnif.s2ActualFullBand q honline t0 d0 ht0 hd0 hd0u hp

/--  S4  on  the  LOW  band  against  the  pin  floor:  the
    residue  wires  are  0  below  1000,  so  this  is
    0  <  0.9975.  -/
private theorem hs4low_pin (q : ZeroSet) (t0 d0 : ℝ)
    (_ht0 : 0 < t0) (ht0u : t0 < 1000) (_hd0 : 0 < d0)
    (_hd0u : d0 ≤ 1 / 2) (_hp : offPair q t0 d0) :
    Z78P12.BwireP (t0, d0) + Z78P12.MrP (t0, d0) +
      Z78P12.MfP (t0, d0) < floProg (t0, d0) := by
  have hnotcov : ¬ (1000 ≤ t0 ∧ d0 ≤ 1 / 2) :=
    fun h => by linarith [h.1, ht0u]
  dsimp only [Z78P12.BwireP, Z78P12.MrP, Z78P12.MfP, floProg,
    S4A.BwireR, S4A.MrR, S4A.MfR]
  try rw [if_neg hnotcov]
  try rw [if_neg hnotcov]
  try rw [if_neg hnotcov]
  try rw [if_neg hnotcov]
  try rw [if_neg hnotcov]
  try rw [add_zero]
  try rw [add_zero]
  have hpin : p8_f_near_pin = (0.9975 : ℝ) := rfl
  rw [hpin]
  norm_num

/-  ##  THE  ENDPOINT  -/
/--  rh_program78  -  THE  ENDPOINT  OF  THE  PROGRAM  on  the
    actual  zeta  zero  set:  under  [Z78],  q  a  subset  of
    the  actual  zeros,  the  named  on-line  sliver  record,
    and  EXACTLY  the  named  residual  (hs1  the  S1  witness,
    hs3  the  S3  wire,  hWin  the  S4  window-pin  shape,
    hS2low  the  S2  low-band  pin),  RH  holds  for  q.
    Everything  else  -  S2  covered,  S4  strip,  S4  low,
    the  far  region  -  is  PROVEN  IN  THE  BODY.
    No  RH  claim:  the  named  items  are  open  (data  and
    bound-level,  as  the  chart  records).  -/
theorem rh_program78 (q : ZeroSet)
    (hz78 : Z78.externalZeroFree78)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0)
    (honline : ∀ ρ ∈ q.Z, 0 < (|ρ.im| : ℝ) →
      (|ρ.im| : ℝ) < (707 : ℝ) / 50 → ρ.re = 1 / 2)
    (Qside : ℝ × ℝ → ℝ)
    (hs1 : ∀ (t0 d0 : ℝ), 0 < t0 → 0 < d0 →
      offPair q t0 d0 → Qside (t0, d0) ≥ devProg (t0, d0))
    (hs3 : ∀ (t0 d0 : ℝ), 0 < t0 → 0 < d0 →
      offPair q t0 d0 →
      Qside (t0, d0) ≤ Z78P12.BwireP (t0, d0) + Z78P12.MrP (t0, d0))
    (hWin : ∀ (t0 d0 : ℝ), 1000 ≤ t0 → 0 < d0 → d0 < 1 / 200 →
      offPair q t0 d0 →
      Z78P12.BwireP (t0, d0) + Z78P12.MrP (t0, d0) +
        Z78P12.MfP (t0, d0) < S1LowT.floStripMin t0 d0)
    (hS2low : ∀ (t0 d0 : ℝ), 0 < t0 → t0 < 1000 →
      0 < d0 → d0 ≤ 1 / 2 → offPair q t0 d0 →
      devProg (t0, d0) ≥ p8_f_near_pin) :
    RH q := by
  refine S4A.rh_from_regime_closures q Qside Z78P12.MfP devProg
    Z78P12.BwireP Z78P12.MrP floProg
    ?_ ?_ ?_ ?_ ?_ ?_
  · --  S1  witness  leg  (Mf  =  0:  devProg  -  0  =  devProg):
    intro t0 d0 ht0 hd0 hp
    have hzm : Z78P12.MfP (t0, d0) = 0 := rfl
    simpa only [hzm, sub_zero] using hs1 t0 d0 ht0 hd0 hp
  · --  S2  leg:  covered  =  in  body;  low  band  =  hS2low;
    --    far  =  vacuous  from  [Z78].
    intro t0 d0 ht0 hd0 hp
    by_cases hd0h : d0 ≤ (1 / 2 : ℝ)
    · by_cases ht0k : 1000 ≤ t0
      · exact hs2_covered q honline t0 d0 ht0 ht0k hd0 hd0h hp
      · have hif : floProg (t0, d0) = p8_f_near_pin := by
          dsimp only [floProg]
          try rw [if_neg (fun h => ht0k h.1)]
          try rfl
        simpa only [hif] using
          hS2low t0 d0 ht0 (not_le.mp ht0k) hd0 hd0h hp
    · exact False.elim (
        Z78P12.offPairFarEmpty q hz78 hqz t0 d0
          (not_le.mp hd0h) hp)
  · --  S3  wire  leg  (as  stated):
    assumption
  · --  S4  covered:  strip  band  in  body  (unified  floor),
    --    window  pin  =  named  shape.
    intro t0 d0 ht0 hd0 hd0u hp
    have hif : floProg (t0, d0) = S1LowT.floStripMin t0 d0 := by
      dsimp only [floProg]
      rw [if_pos ⟨ht0, hd0u⟩]
    by_cases hdw : (1 / 200 : ℝ) ≤ d0
    · simpa [hif, Z78P12.BwireP, Z78P12.MrP, Z78P12.MfP] using
        FUnif.s4StripUnifiedFloor t0 d0 ht0 hdw hd0u
    · simpa [hif] using hWin t0 d0 ht0 hd0 (not_le.mp hdw) hp
  · --  S4  low  band:  trivial  at  the  pin  (in  body):
    intro t0 d0 ht0 ht0u hd0 hd0u hp
    exact hs4low_pin q t0 d0 ht0 ht0u hd0 hd0u hp
  · --  S4  far  region:  VACUOUS  from  [Z78]  (in  body):
    intro t0 d0 ht0 hd0 hd0f hp
    exact False.elim (
      Z78P12.offPairFarEmpty q hz78 hqz t0 d0 hd0f hp)

/-  ##  Part  C  -  the  window-pin  residual  gate  (Float)

  The  shape  of  hWin  recorded  numerically:  the  window
  closure  is  pinned  at  the  near  pin,  while  the
  unified  S2  floor  in  the  window  region  is  the  own
  mass  (capped  at  6e-4  by  mownBelowFloWinCap)  -  the
  squeeze  sits  ~  1600  x  ABOVE  the  floor  it  needs  to
  beat.  No  RH  claim.  -/
def nearPinData : Float := 0.9975
def mownCapData : Float := 0.0006
def floWinCapData : Float := 0.023
#eval nearPinData
#eval mownCapData
#eval nearPinData / mownCapData

/-  ##  Part  B2  -  the  endpoint  with  the  hs1  FACE  RESTATED

  The  bare  hs1  scale  inequality  (Qside  >=  devProg)  is  not
  an  indecomposable  premise:  at  an  ACTUAL  off-pair  zero  it  is
  a  consequence  of  the  S1Face  structure  (discovery  0094)  plus
  FOUR  pin  families  over  the  witness  zero  (all  data-supported;
  uniformity  in  the  height  is  the  open  measured  track,
  NOT  claimed):
      P1  fill      Qside  (t0,  d0)  =  the  A0  fill  at  the
                    witness  zero  (=  |K|  once  zeta  =  0)
      P2  kernel    devFacePt  <=  |W_n|  at  the  witness  (the
                    S1Ge  hW  pin:  the  deviation  face  reads
                    the  zero-side  kernel  magnitude)
      P3  mass      |K  -  (P_n  -  I)|  <=  mvalFace  at  the
                    witness  (the  A4.3  wired  mass  premise)
      P4  absorb    devProg  +  mvalFace  <=  devFacePt  at  the
                    pair  (the  spine's  deviation  is  dominated
                    by  the  deviation  face  less  the  mass)
  rh_program78_s1pins  is  rh_program78  with  hs1  DERIVED  from
  the  pins  -  the  endpoint's  residual  narrows:  the  hs1  scale
  inequality  is  replaced  by  the  pin  family.  Same  honesty  as
  rh_program78:  composition  around  the  named  items;  no  RH
  claim.  -/

/--  rh_program78_s1pins  -  THE  ENDPOINT  WITH  THE  HS1  FACE
    RESTATED  (discovery  0095):  under  [Z78],  q  a  subset  of
    the  actual  zeros,  the  named  on-line  sliver  record,  and
    the  NAMED  RESIDUAL  with  hs1  entered  as  the  PIN  FAMILY
    (P1  fill  =  the  A0  fill  at  the  witness;  P2  kernel
    magnitude  pin;  P3  the  A4.3  mass  pin;  P4  the  absorption
    pin)  instead  of  the  bare  scale  inequality,  plus  hs3
    (the  S3  wire),  hWin  (the  S4  window-pin  shape),  hS2low
    (the  S2  low-band  pin),  RH  holds  for  q.  The  hs1  leg  is
    DERIVED  IN  THE  BODY  from  the  pins  via  S1Face.hs1AtZero
    (A0  collapse  at  the  zero  +  S1Ge  pointwise  atom).
    No  RH  claim:  the  pins  are  data  faces  (measured,
    uniformity  open),  exactly  as  the  chart  records.  -/
theorem rh_program78_s1pins (q : ZeroSet)
    (hz78 : Z78.externalZeroFree78)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0)
    (honline : ∀ ρ ∈ q.Z, 0 < (|ρ.im| : ℝ) →
      (|ρ.im| : ℝ) < (707 : ℝ) / 50 → ρ.re = 1 / 2)
    (Qside : ℝ × ℝ → ℝ)
    (n : ℕ)
    (Kfun : ℂ → ℂ)
    (mvalFace : ℝ × ℝ → ℝ)
    (devFacePt : ℂ → ℝ)
    (hFill : ∀ (t0 d0 : ℝ) (ρ : ℂ), 0 < t0 → 0 < d0 →
      ρ ∈ q.Z → ρ.re ≠ (1 / 2 : ℝ) → (|ρ.im| : ℝ) = t0 →
      |(ρ.re : ℝ) - 1 / 2| = d0 →
      Qside (t0, d0) = ‖riemannZeta ρ - Kfun ρ‖)
    (hDev : ∀ (t0 d0 : ℝ) (ρ : ℂ), 0 < t0 → 0 < d0 →
      ρ ∈ q.Z → ρ.re ≠ (1 / 2 : ℝ) → (|ρ.im| : ℝ) = t0 →
      |(ρ.re : ℝ) - 1 / 2| = d0 →
      devFacePt ρ ≤ ‖p4_Wn ρ n‖)
    (hMass : ∀ (t0 d0 : ℝ) (ρ : ℂ), 0 < t0 → 0 < d0 →
      ρ ∈ q.Z → ρ.re ≠ (1 / 2 : ℝ) → (|ρ.im| : ℝ) = t0 →
      |(ρ.re : ℝ) - 1 / 2| = d0 →
      ‖Kfun ρ - (p4_P n ρ - p4_I n ρ)‖ ≤ mvalFace (t0, d0))
    (hAbsorb : ∀ (t0 d0 : ℝ) (ρ : ℂ), 0 < t0 → 0 < d0 →
      ρ ∈ q.Z → ρ.re ≠ (1 / 2 : ℝ) → (|ρ.im| : ℝ) = t0 →
      |(ρ.re : ℝ) - 1 / 2| = d0 →
      devProg (t0, d0) + mvalFace (t0, d0) ≤ devFacePt ρ)
    (hs3 : ∀ (t0 d0 : ℝ), 0 < t0 → 0 < d0 →
      offPair q t0 d0 →
      Qside (t0, d0) ≤ Z78P12.BwireP (t0, d0) + Z78P12.MrP (t0, d0))
    (hWin : ∀ (t0 d0 : ℝ), 1000 ≤ t0 → 0 < d0 → d0 < 1 / 200 →
      offPair q t0 d0 →
      Z78P12.BwireP (t0, d0) + Z78P12.MrP (t0, d0) +
        Z78P12.MfP (t0, d0) < S1LowT.floStripMin t0 d0)
    (hS2low : ∀ (t0 d0 : ℝ), 0 < t0 → t0 < 1000 →
      0 < d0 → d0 ≤ 1 / 2 → offPair q t0 d0 →
      devProg (t0, d0) ≥ p8_f_near_pin) :
    RH q := by
  refine rh_program78 q hz78 hqz honline Qside ?hs1 hs3 hWin hS2low
  intro t0 d0 ht0 hd0 hp
  obtain ⟨ρ, hrho, hrhooff, hint0, hd0eq⟩ := hp
  have hzero := hqz ρ hrho
  have hfill : Qside (t0, d0) = ‖riemannZeta ρ - Kfun ρ‖ :=
    hFill t0 d0 ρ ht0 hd0 hrho hrhooff hint0 hd0eq
  have hdev : devFacePt ρ ≤ ‖p4_Wn ρ n‖ :=
    hDev t0 d0 ρ ht0 hd0 hrho hrhooff hint0 hd0eq
  have hmas : ‖Kfun ρ - (p4_P n ρ - p4_I n ρ)‖ ≤ mvalFace (t0, d0) :=
    hMass t0 d0 ρ ht0 hd0 hrho hrhooff hint0 hd0eq
  have habsb : devProg (t0, d0) + mvalFace (t0, d0) ≤ devFacePt ρ :=
    hAbsorb t0 d0 ρ ht0 hd0 hrho hrhooff hint0 hd0eq
  --  the  hs1  leg  at  the  witness  zero:  S1Face  (A0  collapse
  --  at  the  zero  +  the  S1Ge  pointwise  atom)
  have hf := S1Face.hs1AtZero ρ n (Kfun ρ) (mvalFace (t0, d0)) (devFacePt ρ)
    hmas hdev hzero
  have hfillK : ‖riemannZeta ρ - Kfun ρ‖ = ‖Kfun ρ‖ := by
    rw [hzero]
    simp [norm_neg]
  have habs : devProg (t0, d0) ≤ devFacePt ρ - mvalFace (t0, d0) :=
    (le_sub_iff_add_le).mpr habsb
  have hmain : Qside (t0, d0) ≥ devProg (t0, d0) := by
    calc Qside (t0, d0)
        _ = ‖riemannZeta ρ - Kfun ρ‖ := hfill
        _ = ‖Kfun ρ‖ := hfillK
        _ ≥ devFacePt ρ - mvalFace (t0, d0) := hf
        _ ≥ devProg (t0, d0) := habs
  have hmfp : Z78P12.MfP (t0, d0) = 0 := rfl
  simpa [hmfp, sub_zero] using hmain

/-  ##  Part  B3  -  the  endpoint  with  the  hWin  FACE  SHRUNK

  The  hWin  hypothesis  of  rh_program78  is  not  indecomposable
  either:  the  S4WinCap  face  identity  (discovery  0105)  says
  the  face  IS  zero-exclusion  of  off-line  zeros  on  [1000,
  inf)  x  (0,  1/200);  and  under  the  CITED  classical
  frontier  [Z-PT]  (every  non-trivial  zero  with  0  <  Im  <=
  tPT  =  30,610,046,000  is  on  the  line  -  the  rigorous,
  interval-verified  zero-isolation  record,  interval  precision
  +-  2^-102,  the  end  of  the  public  LMFDB  stream;  cited
  like  [Z78])  that  zero-exclusion  splits  EXACTLY  at  the
  frontier  (WinCount.faceSplit):  no  off-pairs  below  it  follow
  from  [Z-PT]  alone,  and  the  residue  is  zero-exclusion  of
  (tPT,  inf)  x  (0,  1/200).  rh_program78_winpt  is
  rh_program78  with  hWin  DERIVED  IN  THE  BODY  from  [Z-PT]  +
  the  residual:  the  endpoint  premise  narrows  from  "the
  window  squeeze  holds  on  [1000,  inf)"  to  "no  off-line
  zeros  in  (tPT,  inf)  x  (0,  1/200)"  -  the  open  height
  interval  of  the  hWin  residual  at  the  endpoint  shrinks  by
  a  factor  of  about  3e7.  The  3e9  record  shadow
  (WinCount.offExcessBound:  with  the  pinned  record  counts  and
  the  record's  +-3  tolerance,  the  off-line  excess  below  3e9
  is  0  or  2)  is  an  independent  constraint  on  the  same  open
  region,  record-derived,  and  does  not  appear  in  the
  endpoint  premises.  Same  honesty  as  rh_program78:  [Z-PT]  is
  CITED  (classical,  docstring  reference);  the  residual  is
  OPEN  (no  instrument  in  the  tree  reaches  (tPT,  inf)  x
  (0,  1/200));  no  RH  claim.  -/

/--  rh_program78_winpt  -  THE  ENDPOINT  WITH  THE  HWIN  FACE
    SHRUNK  (discovery  0106):  under  [Z78],  q  a  subset  of
    the  actual  zeros,  the  named  on-line  sliver  record,  and
    the  NAMED  RESIDUAL  with  hWin  entered  as  the  CITED
    classical  frontier  [Z-PT]  (all  non-trivial  zeros  with
    0  <  Im  <=  tPT  on  the  line)  plus  the  residual  face
    (zero-exclusion  of  off-line  zeros  on  (tPT,  inf)  x  (0,
    1/200)),  together  with  hs1  (the  S1  witness),  hs3  (the
    S3  wire),  hS2low  (the  S2  low-band  pin),  RH  holds  for
    q.  The  hWin  leg  is  DERIVED  IN  THE  BODY  from
    S4WinCap's  face  identity  and  WinCount.faceSplit  (no
    off-pairs  on  [1000,  tPT]  from  [Z-PT];  the  residue  is
    the  asserted  face).  No  RH  claim:  the  residual  is  open
    (its  content  is  where  no  instrument  in  the  tree
    reaches).  -/
theorem rh_program78_winpt (q : ZeroSet)
    (hz78 : Z78.externalZeroFree78)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0)
    (honline : ∀ ρ ∈ q.Z, 0 < (|ρ.im| : ℝ) →
      (|ρ.im| : ℝ) < (707 : ℝ) / 50 → ρ.re = 1 / 2)
    (Qside : ℝ × ℝ → ℝ)
    (hs1 : ∀ (t0 d0 : ℝ), 0 < t0 → 0 < d0 →
      offPair q t0 d0 → Qside (t0, d0) ≥ devProg (t0, d0))
    (hs3 : ∀ (t0 d0 : ℝ), 0 < t0 → 0 < d0 →
      offPair q t0 d0 →
      Qside (t0, d0) ≤ Z78P12.BwireP (t0, d0) + Z78P12.MrP (t0, d0))
    (hPT : WinC.allOnLineUpTo q WinC.tPT)
    (hres : WinC.hWinFaceResidual q)
    (hS2low : ∀ (t0 d0 : ℝ), 0 < t0 → t0 < 1000 →
      0 < d0 → d0 ≤ 1 / 2 → offPair q t0 d0 →
      devProg (t0, d0) ≥ p8_f_near_pin) :
    RH q := by
  have hface : S4WC.hWinFace q := (WinC.faceSplit q hPT).mpr hres
  refine rh_program78 q hz78 hqz honline Qside hs1 hs3 hface hS2low

/-  ##  Part  B4  -  the  endpoint  COLLAPSES  TO  THE  FRONTIER

  Every  named  residual  of  rh_program78  is  quantified  over
  OFF-PAIR  zeros  (hs1:  the  S1  witness;  hs3:  the  S3  wire;
  hWin:  the  S4  window  pin;  hS2low:  the  S2  low-band  pin).
  And  for  a  zero  set  consistent  with  the  CITED  classical
  frontier  [Z-PT]  (all  non-trivial  zeros  up  to  tPT  =
  30,610,046,000  on  the  line  -  the  rigorous  interval-verified
  zero-isolation  record),  there  are  NO  off-line  zeros  below
  tPT  at  ANY  offset  (WinCount.noOffLineBelowPT:  the  t0  =  0
  case  by  non-realness,  the  0  <  t0  case  by  the  sign
  argument  with  the  conjugate  twin).  So  below  the  frontier
  ALL  FOUR  residuals  are  VACUOUS  -  and  above  it  only  the
  bound-level  content  remains:  hs1  and  hs3  as  wire
  inequalities  at  hypothetical  off-pairs  (no  measured  data
  can  speak  there  -  no  zero  list  past  the  frontier  in
  the  tree),  and  the  hWin  residual  face  (zero-exclusion  on
  (tPT,  inf)  x  (0,  1/200));  hS2low  DISAPPEARS  ENTIRELY  (its
  height  domain  (0,  1000)  sits  below  the  frontier  and  is
  vacuous  under  [Z-PT]).  rh_program78_frontier  is  the
  composition:  the  endpoint  holds  for  q  from  [Z-PT]  plus
  the  ABOVE-FRONTIER  versions  of  hs1  and  hs3  plus  the
  hWin  residual  face  -  the  entire  residue  of  the  endpoint
  (all  four  named  residuals  on  (0,  inf)  x  (0,  1/2))
  reduces  to  content  STRICTLY  ABOVE  tPT.  No  RH  claim:  the
  open  content  is  exactly  the  above-frontier  bound-level
  faces  -  where  no  instrument  in  the  tree  reaches  (the
  classical  zero-free  regions  stop  at  Re  >  1  -  c/ln  t,
  nowhere  near  Re  =  1/2  +-  1/200).  -/

/--  rh_program78_frontier  -  THE  ENDPOINT  COLLAPSED  TO  THE
    CITED  FRONTIER  (discovery  0110):  under  [Z78],  q  a
    subset  of  the  actual  zeros,  the  named  on-line  sliver
    record,  and  [Z-PT]  (all  non-trivial  zeros  with
    0  <  Im  <=  tPT  on  the  line  -  CITED,  like  [Z78]),
    the  endpoint  holds  from  the  ABOVE-FRONTIER  residual:
    hs1  and  hs3  restricted  to  t0  >=  tPT,  plus  the  hWin
    residual  face  (zero-exclusion  of  off-line  zeros  on
    (tPT,  inf)  x  (0,  1/200)).  The  other  three  named
    residuals  of  rh_program78  are  DERIVED  IN  THE  BODY:
    below  tPT  all  four  residuals  are  vacuous  (no  off-line
    zeros  below  the  frontier  at  any  offset),  and  hS2low
    vacuously  holds  on  its  whole  domain  (0  <  t0  <  1000
    <=  tPT).  Same  honesty  as  the  other  variants:  [Z-PT]
    is  CITED  (classical,  docstring  reference);  the
    above-frontier  faces  are  OPEN  (no  instrument  in  the
    tree  reaches  above  the  frontier);  no  RH  claim.  -/
theorem rh_program78_frontier (q : ZeroSet)
    (hz78 : Z78.externalZeroFree78)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0)
    (honline : ∀ ρ ∈ q.Z, 0 < (|ρ.im| : ℝ) →
      (|ρ.im| : ℝ) < (707 : ℝ) / 50 → ρ.re = 1 / 2)
    (Qside : ℝ × ℝ → ℝ)
    (hPT : WinC.allOnLineUpTo q WinC.tPT)
    (hs1PT : ∀ (t0 d0 : ℝ), WinC.tPT <= t0 → 0 < d0 →
      offPair q t0 d0 → Qside (t0, d0) ≥ devProg (t0, d0))
    (hs3PT : ∀ (t0 d0 : ℝ), WinC.tPT <= t0 → 0 < d0 →
      offPair q t0 d0 →
      Qside (t0, d0) ≤ Z78P12.BwireP (t0, d0) + Z78P12.MrP (t0, d0))
    (hWinPT : WinC.hWinFaceResidual q) :
    RH q := by
  refine rh_program78 q hz78 hqz honline Qside ?hs1 ?hs3 ?hWin ?hS2low
  · --  hs1:  vacuous  below  the  frontier,  the  asserted  face
      --  above  it.
    intro t0 d0 ht0 hd0 hp
    by_cases hle : t0 <= WinC.tPT
    · exact False.elim ((WinC.noOffLineBelowPT q WinC.tPT hPT t0
        (le_of_lt ht0) hle) d0 hp)
    · exact hs1PT t0 d0 (le_of_lt (not_le.mp hle)) hd0 hp
  · --  hs3:  the  same  decomposition.
    intro t0 d0 ht0 hd0 hp
    by_cases hle : t0 <= WinC.tPT
    · exact False.elim ((WinC.noOffLineBelowPT q WinC.tPT hPT t0
        (le_of_lt ht0) hle) d0 hp)
    · exact hs3PT t0 d0 (le_of_lt (not_le.mp hle)) hd0 hp
  · --  hWin:  the  face  identity  +  the  split  (Part  B3).
    exact (WinC.faceSplit q hPT).mpr hWinPT
  · --  hS2low:  its  whole  domain  (0,  1000)  sits  below  the
      --  frontier:  vacuous.
    intro t0 d0 ht0 ht0u hd0 hd0u hp
    have hmid : (1000 : ℝ) <= WinC.tPT := by norm_num [WinC.tPT]
    have hle : t0 <= WinC.tPT := le_trans (le_of_lt ht0u) hmid
    exact False.elim ((WinC.noOffLineBelowPT q WinC.tPT hPT t0
      (le_of_lt ht0) hle) d0 hp)

/-  ##  Part  B5  -  the  endpoint  over  the  STRIP  FRONTIER

  Where  the  above-frontier  faces  actually  live,  and  what
  is  BEHIND  them  (the  lever-1  investigation,  discovery  0111):

  In  the  strip  band  (t0  >=  1000,  1/200  <=  d0  <=  1/2)  the
  four  closure  legs  form  a  CONTRADICTION  at  any  off-pair
  zero  -  S1:  Qside  >=  devProg;  S2:  devProg  >=  floStripMin
  (IN  BODY,  s2ActualFullBand,  no  height  cap);  S3:  Qside  <=
  Bwire  +  Mr;  S4:  Bwire  +  Mr  <  floStripMin  (IN  BODY,
  s4StripUnifiedFloor,  no  height  cap).  The  two  in-body  legs
  are  closed-form  in  (t0,  d0)  and  hold  at  every  height,
  so  above  the  frontier  the  squeeze  cycle  needs  ONLY  the
  two  SCALE  faces  (hs1,  hs3)  on  that  band.  In  the  window
  band  (d0  <  1/200)  the  in-body  S4  leg  does  NOT  close
  (that  is  the  window-pin  shape)  -  but  there  the  hWin
  residual  face  (zero-exclusion  above  the  frontier)  kills
  every  off-pair  directly,  so  hs1/hs3  are  VACUOUS  there
  for  t0  >  tPT.  rh_program78_stripfront  is  the  composition:
  the  hs1/hS3  premises  of  the  frontier  endpoint  shrink  from
  all  d0  in  (0,  1/2]  to  the  STRIP  BAND  1/200  <=  d0  <=
  1/2  above  tPT.

  What  is  BEHIND  the  two  strip  faces  (the  named  gaps  the
  tree  does  NOT  close  in  body  -  no  RH  claim):
      G-hs3  (scale  UPPER  bound):  at  a  hypothetical  off-line
      zero  rho  (Re  =  1/2  +-  d0,  t0  >=  tPT)  the  kernel
      scale  <=  p8_B(t0,  nGrow)  +  Mr.  The  tree's  B-wire  is
      a  CRITICAL-LINE  bound:  p8_B_floor  instantiates
      p4_T4_bound  at  Re  s  =  1/2,  and  an  off-pair  zero  has
      Re  rho  >=  d0  >  0  from  the  line  by  definition  -
      p8_B  is  not  applied  at  rho.  G-hs3  is  the  off-line
      LIFT  of  the  T4  wire  (an  analytic  statement  about
      exponential  sums  away  from  the  line;  nothing  in  the
      tree  bounds  <<p4_Wn  rho  n>>  or  the  mass  gap  at  off-line
      points  -  the  P3  mass  pin  is  a  premise  by  design).
      G-hs1  (scale  LOWER  bound):  at  the  same  zero  the
      kernel  scale  >=  devStripMin(t0,  d0)  (anti-degeneracy:
      the  zero-side  scale  does  not  die  below  the  48-straddle
      detector  minimum).  The  body  has  UPPER  bounds  on  the
      kernel  (p8_B  on  the  line,  the  E1/E2  EM  bounds)  and
      LOWER  bounds  on  the  DETECTOR  (p8_far_detector_mag_ge_two,
      strideU_floor)  -  no  lower  bound  on  the  kernel  scale  at
      off-line  points.  Its  measured  shadow  is  exactly  the
      S1Marg  margin  track  (25  certified  candidates,  >=  1  to
      2.8e7,  the  exploratory  signal  below  1  from  3.1e7  -
      the  composite  degrading  with  height).
  Together  G-hs1  +  G-hs3  on  (tPT,  inf)  x  [1/200,  1/2]
  ARE  the  strip-band  zero-exclusion  (the  cycle  contradicts
  every  off-pair),  so  the  entire  above-frontier  residue  of
  the  endpoint  is  named:  two  analytic  gap  statements  in
  the  strip  band  plus  the  window  zero-exclusion  face;  the
  below-frontier  half  is  closed  by  [Z-PT].  -/

/--  rh_program78_stripfront  -  THE  ENDPOINT  OVER  THE  STRIP
    FRONTIER  (discovery  0111):  under  [Z78],  q  a  subset  of
    the  actual  zeros,  the  named  on-line  sliver  record,  and
    [Z-PT],  the  endpoint  holds  from  (i)  the  WINDOW  face
    (zero-exclusion  of  off-line  zeros  on  (tPT,  inf)  x
    (0,  1/200)  -  the  hWin  residual)  and  (ii)  the  two
    STRIP-BAND  scale  faces  restricted  to  t0  >=  tPT,  1/200
    <=  d0  <=  1/2  (G-hs1:  scale  >=  devProg;  G-hs3:  scale
    <=  Bwire  +  Mr).  All  other  legs  of  rh_program78  are
    DERIVED  IN  THE  BODY:  below  tPT  everything  is  vacuous
    (no  off-line  zeros  below  the  frontier  at  any  offset);
    in  the  window  band  above  tPT  the  window  face  kills
    every  off-pair;  in  the  far  region  [Z78]  kills  every
    off-pair;  hS2low  is  vacuous  on  its  whole  domain;
    hWin  is  the  face  identity  +  the  split.  No  RH  claim:
    the  named  gaps  G-hs1/G-hs3  (docstring)  are  the  open
    analytic  content,  measured  shadows  in  S1Marg  and  the
    line-bound  T4  wire.  -/
theorem rh_program78_stripfront (q : ZeroSet)
    (hz78 : Z78.externalZeroFree78)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0)
    (honline : ∀ ρ ∈ q.Z, 0 < (|ρ.im| : ℝ) →
      (|ρ.im| : ℝ) < (707 : ℝ) / 50 → ρ.re = 1 / 2)
    (Qside : ℝ × ℝ → ℝ)
    (hPT : WinC.allOnLineUpTo q WinC.tPT)
    (hs1Strip : ∀ (t0 d0 : ℝ), WinC.tPT <= t0 → (1 / 200 : ℝ) <= d0 →
      d0 <= 1 / 2 → offPair q t0 d0 → Qside (t0, d0) ≥ devProg (t0, d0))
    (hs3Strip : ∀ (t0 d0 : ℝ), WinC.tPT <= t0 → (1 / 200 : ℝ) <= d0 →
      d0 <= 1 / 2 → offPair q t0 d0 →
      Qside (t0, d0) ≤ Z78P12.BwireP (t0, d0) + Z78P12.MrP (t0, d0))
    (hWinPT : WinC.hWinFaceResidual q) :
    RH q := by
  refine rh_program78 q hz78 hqz honline Qside ?hs1 ?hs3 ?hWin ?hS2low
  · --  hs1:  far  =  [Z78]  empty;  below  the  frontier  =
      --  vacuous;  window  band  above  =  the  window  face
      --  empty;  strip  band  above  =  the  asserted  G-hs1.
    intro t0 d0 ht0 hd0 hp
    by_cases hfar : d0 <= 1 / 2
    · by_cases hle : t0 <= WinC.tPT
      · exact False.elim ((WinC.noOffLineBelowPT q WinC.tPT hPT t0
          (le_of_lt ht0) hle) d0 hp)
      · by_cases hdw : (1 / 200 : ℝ) <= d0
        · exact hs1Strip t0 d0 (le_of_lt (not_le.mp hle)) hdw hfar hp
        · exact False.elim ((hWinPT t0 d0
            (le_trans (by norm_num [WinC.tPT]) (le_of_lt (not_le.mp hle)))
            (not_le.mp hle) hd0 (not_le.mp hdw)) hp)
    · exact False.elim (Z78P12.offPairFarEmpty q hz78 hqz t0 d0
        (not_le.mp hfar) hp)
  · --  hs3:  the  same  decomposition  (G-hs3  on  the  strip
      --  band  above  the  frontier).
    intro t0 d0 ht0 hd0 hp
    by_cases hfar : d0 <= 1 / 2
    · by_cases hle : t0 <= WinC.tPT
      · exact False.elim ((WinC.noOffLineBelowPT q WinC.tPT hPT t0
          (le_of_lt ht0) hle) d0 hp)
      · by_cases hdw : (1 / 200 : ℝ) <= d0
        · exact hs3Strip t0 d0 (le_of_lt (not_le.mp hle)) hdw hfar hp
        · exact False.elim ((hWinPT t0 d0
            (le_trans (by norm_num [WinC.tPT]) (le_of_lt (not_le.mp hle)))
            (not_le.mp hle) hd0 (not_le.mp hdw)) hp)
    · exact False.elim (Z78P12.offPairFarEmpty q hz78 hqz t0 d0
        (not_le.mp hfar) hp)
  · --  hWin:  the  face  identity  +  the  split  (Part  B3).
    exact (WinC.faceSplit q hPT).mpr hWinPT
  · --  hS2low:  its  whole  domain  (0,  1000)  sits  below  the
      --  frontier:  vacuous.
    intro t0 d0 ht0 ht0u hd0 hd0u hp
    have hmid : (1000 : ℝ) <= WinC.tPT := by norm_num [WinC.tPT]
    have hle : t0 <= WinC.tPT := le_trans (le_of_lt ht0u) hmid
    exact False.elim ((WinC.noOffLineBelowPT q WinC.tPT hPT t0
      (le_of_lt ht0) hle) d0 hp)


/-  ##  Part  B6  -  THE  ENDPOINT  AT  ANY  FRONTIER,  AND  AT  THE
    PLATT-TRUDGIAN  VERIFIED  FRONTIER  (discovery  0115)

  The  bodies  of  rh_program78_frontier  (part  B4)  and
  rh_program78_stripfront  (part  B5)  are  UNIFORM  in  the
  frontier  H:  below  H  every  named  residual  is  vacuous
  (noOffLineBelowPT),  and  above  H  only  the  residual  faces
  are  asserted.  This  part  writes  them  once  with  H  as  a
  PARAMETER  (hH:  1000  <=  H  -  for  the  hS2low  vacuity)  and
  instantiates  at  BOTH  cited  frontiers:

      tPT  =  30,610,046,000       (Platt  isolation  record,
                                    the  record's  own  frontier;
                                    [Z-PT])
      tPT2 =  3,000,175,332,800    (Platt-Trudgian,
                                    arXiv:2004.09765,  Theorem  1;
                                    rigorous  interval  arithmetic;
                                    independently  verifies  the
                                    tPT  record;  [Z-PT2])

  At  the  stronger  frontier  the  entire  residue  of  the
  endpoint  (G-hs1,  G-hs3,  the  window  zero-exclusion  face)
  lives  STRICTLY  ABOVE  3,000,175,332,800  instead  of  above
  30,610,046,000  -  the  open  height  interval  shrinks  by  a
  factor  of  about  100  at  ZERO  COMPUTATIONAL  COST  (the
  citation  is  a  published,  rigorous,  independently
  verifiable  record;  no  new  zero  walk  is  claimed).  The
  monotonicity  (WinC.faceResidualMonotone)  says  exactly  how
  the  two  variants  relate:  the  tPT  residual  face  implies
  the  tPT2  residual  face  (same  for  the  hs  faces,  by
  the  same  interval  inclusion);  the  gap  (tPT2,  ...  )  -
  content  BELOW  tPT2  but  ABOVE  tPT  -  is  NOT  closed  by
  either  citation  in  the  tree  beyond  what  [Z-PT2]  says.
  Same  honesty  as  every  earlier  variant:  [Z-PT]  /  [Z-PT2]
  CITED  (classical,  docstring  references);  the  above-
  frontier  faces  OPEN;  no  RH  claim.  -/

/--  THE  ENDPOINT  COLLAPSED  TO  AN  ARBITRARY  CITED  FRONTIER  H
    (the  part  B4  body  with  H  as  a  parameter):  under  [Z-H]
    (all  non-trivial  zeros  with  0  <  Im  <=  H  on  the
    line),  the  endpoint  holds  from  hs1  and  hs3  restricted
    to  t0  >=  H  and  the  hWin  residual  face  at  H
    (zero-exclusion  of  (H,  inf)  x  (0,  1/200)).  Below  H
    all  four  named  residuals  are  vacuous;  hS2low  vacuously
    holds  on  its  whole  domain  (0  <  t0  <  1000  <=  H).  No
    RH  claim.  -/
theorem rh_program78_frontierH (q : ZeroSet)
    (hz78 : Z78.externalZeroFree78)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0)
    (honline : ∀ ρ ∈ q.Z, 0 < (|ρ.im| : ℝ) →
      (|ρ.im| : ℝ) < (707 : ℝ) / 50 → ρ.re = 1 / 2)
    (Qside : ℝ × ℝ → ℝ)
    (H : ℝ) (hH : 1000 ≤ H)
    (hPT : WinC.allOnLineUpTo q H)
    (hs1H : ∀ (t0 d0 : ℝ), H <= t0 → 0 < d0 →
      offPair q t0 d0 → Qside (t0, d0) ≥ devProg (t0, d0))
    (hs3H : ∀ (t0 d0 : ℝ), H <= t0 → 0 < d0 →
      offPair q t0 d0 →
      Qside (t0, d0) ≤ Z78P12.BwireP (t0, d0) + Z78P12.MrP (t0, d0))
    (hWinH : WinC.hWinFaceResidualH q H) :
    RH q := by
  refine rh_program78 q hz78 hqz honline Qside ?hs1 ?hs3 ?hWin ?hS2low
  · --  hs1:  vacuous  below  the  frontier,  the  asserted  face
      --  above  it.
    intro t0 d0 ht0 hd0 hp
    by_cases hle : t0 <= H
    · exact False.elim ((WinC.noOffLineBelowPT q H hPT t0
        (le_of_lt ht0) hle) d0 hp)
    · exact hs1H t0 d0 (le_of_lt (not_le.mp hle)) hd0 hp
  · --  hs3:  the  same  decomposition.
    intro t0 d0 ht0 hd0 hp
    by_cases hle : t0 <= H
    · exact False.elim ((WinC.noOffLineBelowPT q H hPT t0
        (le_of_lt ht0) hle) d0 hp)
    · exact hs3H t0 d0 (le_of_lt (not_le.mp hle)) hd0 hp
  · --  hWin:  the  face  identity  +  the  split  at  H.
    exact (WinC.faceSplitH q H hPT).mpr hWinH
  · --  hS2low:  its  whole  domain  (0,  1000)  sits  below  the
      --  frontier:  vacuous.
    intro t0 d0 ht0 ht0u hd0 hd0u hp
    have hle : t0 <= H := le_trans (le_of_lt ht0u) hH
    exact False.elim ((WinC.noOffLineBelowPT q H hPT t0
      (le_of_lt ht0) hle) d0 hp)

/--  THE  ENDPOINT  AT  THE  PLATT-TRUDGIAN  FRONTIER  (the
    [Z-PT2]  variant  of  rh_program78_frontier):  under  [Z78],
    q  a  subset  of  the  actual  zeros,  the  named  on-line
    sliver  record,  and  [Z-PT2]  (all  non-trivial  zeros  with
    0  <  Im  <=  tPT2  on  the  line  -  arXiv:2004.09765,
    CITED),  the  endpoint  holds  from  hs1  and  hs3  restricted
    to  t0  >=  tPT2  plus  the  hWin  residual  face  at  tPT2
    (zero-exclusion  on  (tPT2,  inf)  x  (0,  1/200)).  The
    residue  lives  STRICTLY  ABOVE  3,000,175,332,800.  No  RH
    claim.  -/
theorem rh_program78_frontier_PT2 (q : ZeroSet)
    (hz78 : Z78.externalZeroFree78)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0)
    (honline : ∀ ρ ∈ q.Z, 0 < (|ρ.im| : ℝ) →
      (|ρ.im| : ℝ) < (707 : ℝ) / 50 → ρ.re = 1 / 2)
    (Qside : ℝ × ℝ → ℝ)
    (hPT2 : WinC.allOnLineUpTo q WinC.tPT2)
    (hs1PT2 : ∀ (t0 d0 : ℝ), WinC.tPT2 <= t0 → 0 < d0 →
      offPair q t0 d0 → Qside (t0, d0) ≥ devProg (t0, d0))
    (hs3PT2 : ∀ (t0 d0 : ℝ), WinC.tPT2 <= t0 → 0 < d0 →
      offPair q t0 d0 →
      Qside (t0, d0) ≤ Z78P12.BwireP (t0, d0) + Z78P12.MrP (t0, d0))
    (hWinPT2 : WinC.hWinFaceResidualH q WinC.tPT2) :
    RH q :=
  rh_program78_frontierH q hz78 hqz honline Qside WinC.tPT2
    (by norm_num [WinC.tPT2]) hPT2 hs1PT2 hs3PT2 hWinPT2

/--  THE  ENDPOINT  OVER  THE  STRIP  FRONTIER  AT  AN  ARBITRARY
    CITED  FRONTIER  H  (the  part  B5  body  with  H  as  a
    parameter):  under  [Z-H],  the  endpoint  holds  from  (i)
    the  WINDOW  face  (zero-exclusion  of  off-line  zeros  on
    (H,  inf)  x  (0,  1/200))  and  (ii)  the  two  STRIP-BAND
    scale  faces  (G-hs1:  scale  >=  devProg;  G-hs3:  scale  <=
    Bwire  +  Mr)  restricted  to  t0  >=  H,  1/200  <=  d0  <=
    1/2.  All  other  legs  of  rh_program78  are  DERIVED  IN
    THE  BODY:  below  H  everything  is  vacuous;  in  the
    window  band  above  H  the  window  face  kills  every
    off-pair;  in  the  far  region  [Z78]  kills  every  off-
    pair;  hS2low  is  vacuous  on  its  whole  domain  (0  <  t0
    <  1000  <=  H);  hWin  is  the  face  identity  +  the
    split.  No  RH  claim:  G-hs1/G-hs3  are  the  open  analytic
    content.  -/
theorem rh_program78_stripfrontH (q : ZeroSet)
    (hz78 : Z78.externalZeroFree78)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0)
    (honline : ∀ ρ ∈ q.Z, 0 < (|ρ.im| : ℝ) →
      (|ρ.im| : ℝ) < (707 : ℝ) / 50 → ρ.re = 1 / 2)
    (Qside : ℝ × ℝ → ℝ)
    (H : ℝ) (hH : 1000 ≤ H)
    (hPT : WinC.allOnLineUpTo q H)
    (hs1StripH : ∀ (t0 d0 : ℝ), H <= t0 → (1 / 200 : ℝ) <= d0 →
      d0 <= 1 / 2 → offPair q t0 d0 → Qside (t0, d0) ≥ devProg (t0, d0))
    (hs3StripH : ∀ (t0 d0 : ℝ), H <= t0 → (1 / 200 : ℝ) <= d0 →
      d0 <= 1 / 2 → offPair q t0 d0 →
      Qside (t0, d0) ≤ Z78P12.BwireP (t0, d0) + Z78P12.MrP (t0, d0))
    (hWinH : WinC.hWinFaceResidualH q H) :
    RH q := by
  refine rh_program78 q hz78 hqz honline Qside ?hs1 ?hs3 ?hWin ?hS2low
  · --  hs1:  far  =  [Z78]  empty;  below  the  frontier  =
      --  vacuous;  window  band  above  =  the  window  face
      --  empty;  strip  band  above  =  the  asserted  G-hs1.
    intro t0 d0 ht0 hd0 hp
    by_cases hfar : d0 <= 1 / 2
    · by_cases hle : t0 <= H
      · exact False.elim ((WinC.noOffLineBelowPT q H hPT t0
          (le_of_lt ht0) hle) d0 hp)
      · by_cases hdw : (1 / 200 : ℝ) <= d0
        · exact hs1StripH t0 d0 (le_of_lt (not_le.mp hle)) hdw hfar hp
        · exact False.elim ((hWinH t0 d0
            (le_trans hH (le_of_lt (not_le.mp hle)))
            (not_le.mp hle) hd0 (not_le.mp hdw)) hp)
    · exact False.elim (Z78P12.offPairFarEmpty q hz78 hqz t0 d0
        (not_le.mp hfar) hp)
  · --  hs3:  the  same  decomposition  (G-hs3  on  the  strip
      --  band  above  the  frontier).
    intro t0 d0 ht0 hd0 hp
    by_cases hfar : d0 <= 1 / 2
    · by_cases hle : t0 <= H
      · exact False.elim ((WinC.noOffLineBelowPT q H hPT t0
          (le_of_lt ht0) hle) d0 hp)
      · by_cases hdw : (1 / 200 : ℝ) <= d0
        · exact hs3StripH t0 d0 (le_of_lt (not_le.mp hle)) hdw hfar hp
        · exact False.elim ((hWinH t0 d0
            (le_trans hH (le_of_lt (not_le.mp hle)))
            (not_le.mp hle) hd0 (not_le.mp hdw)) hp)
    · exact False.elim (Z78P12.offPairFarEmpty q hz78 hqz t0 d0
        (not_le.mp hfar) hp)
  · --  hWin:  the  face  identity  +  the  split  at  H.
    exact (WinC.faceSplitH q H hPT).mpr hWinH
  · --  hS2low:  its  whole  domain  (0,  1000)  sits  below  the
      --  frontier:  vacuous.
    intro t0 d0 ht0 ht0u hd0 hd0u hp
    have hle : t0 <= H := le_trans (le_of_lt ht0u) hH
    exact False.elim ((WinC.noOffLineBelowPT q H hPT t0
      (le_of_lt ht0) hle) d0 hp)

/--  THE  ENDPOINT  OVER  THE  STRIP  FRONTIER  AT  THE  PLATT-
    TRUDGIAN  FRONTIER  (the  [Z-PT2]  variant  of
    rh_program78_stripfront):  under  [Z-PT2],  the  endpoint
    holds  from  the  window  face  at  tPT2  and  the  two  strip
    scale  faces  on  t0  >=  tPT2,  1/200  <=  d0  <=  1/2  -
    the  entire  named  residue  (G-hs1,  G-hs3,  the  window
    zero-exclusion  face)  lives  STRICTLY  ABOVE
    3,000,175,332,800.  No  RH  claim.  -/
theorem rh_program78_stripfront_PT2 (q : ZeroSet)
    (hz78 : Z78.externalZeroFree78)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0)
    (honline : ∀ ρ ∈ q.Z, 0 < (|ρ.im| : ℝ) →
      (|ρ.im| : ℝ) < (707 : ℝ) / 50 → ρ.re = 1 / 2)
    (Qside : ℝ × ℝ → ℝ)
    (hPT2 : WinC.allOnLineUpTo q WinC.tPT2)
    (hs1StripPT2 : ∀ (t0 d0 : ℝ), WinC.tPT2 <= t0 → (1 / 200 : ℝ) <= d0 →
      d0 <= 1 / 2 → offPair q t0 d0 → Qside (t0, d0) ≥ devProg (t0, d0))
    (hs3StripPT2 : ∀ (t0 d0 : ℝ), WinC.tPT2 <= t0 → (1 / 200 : ℝ) <= d0 →
      d0 <= 1 / 2 → offPair q t0 d0 →
      Qside (t0, d0) ≤ Z78P12.BwireP (t0, d0) + Z78P12.MrP (t0, d0))
    (hWinPT2 : WinC.hWinFaceResidualH q WinC.tPT2) :
    RH q :=
  rh_program78_stripfrontH q hz78 hqz honline Qside WinC.tPT2
    (by norm_num [WinC.tPT2]) hPT2 hs1StripPT2 hs3StripPT2 hWinPT2

/-  ##  Part  B7  -  THE  ENDPOINT  WITH  G-hs3  MACHINED
    (discovery  0118)

  The  strip-band  hs3  face  of  rh_program78_stripfront  (the  S3
  wire  scale  upper  bound  at  the  off-pair)  is  now  MACHINED:
  its  off-line  content  is  carried  by  the  T4OffD  wall
  domination  (the  off-line  EM  wall  is  termwise  below  the
  strip  B-wire)  plus  the  T4OffM  lifted  Mr  wire  (the  P6
  finite-kernel  gap  at  the  CITED  1.6  convexity  mass,
  sigma-independent  b3  correction).  Concretely:

  (1)  the  scale  at  an  off-pair  in  the  strip  band  is
      bounded  by  the  OFF-LINE  EM  wall  at  the  canonical
      point  (t4o_sOff,  the  n4  schedule)  plus  the
      OFF-LINE  lifted  M-wire  (t4m_MwireOff)  -  the
      only  non-machine  content  anywhere  in  this  face  is
      the  classical  1.6  convexity  mass  inside  the  wire
      (CITED  in  the  T4OffM  header);  the  wall  side  has
      NO  non-machine  content  (T4OffD  is  all  machine  on
      top  of  the  CITED  classical  T4  bound);
  (2)  T4OffD  then  dominates  the  wall  by  p8_B  t0  (n4  t0),
      which  IS  the  strip  branch  of  BwireP  -  so  the  S3
      leg  closes  in  body  from  the  face  plus  T4OffD;
  (3)  the  S4  strip  leg  must  match  the  LIFTED  wire:  the
      regime  closure  is  called  with  Mr  :=  MrLift  (the
      on-line  MrR  outside  the  strip  band,  t4m_MwireOff
      inside  it),  and  the  strip  case  is  t4m_margin
      (p8_B  +  MwireOff  <  floStripMin,  in  body,  corner
      margin  ~16  orders)  instead  of  the  on-line
      s4StripUnifiedFloor;  the  window  case  keeps  the
      on-line  wire  (MrLift  =  MrR  there)  and  the  window
      face  via  faceSplitH,  as  before.

  The  named  residual  of  rh_program78_stripfront_mach  is
  thus:  G-hs1  (open,  as  before),  the  window  zero-
  exclusion  face  (open,  as  before),  and  the  machined
  hs3  face  -  whose  content  is  a  CITED  classical
  convexity  mass  (1.6  constant),  not  an  analytic
  barrier  in  the  tree.  No  RH  claim:  the  citation  is
  the  same  classical  bound  the  tree  already  uses  on
  the  line.  -/

/-- The  lifted  Mr  wire  of  the  endpoint  (discovery  0118):
    the  OFF-LINE  M-wire  (T4OffM,  CITED  1.6  convexity  mass)
    in  the  strip  band,  the  on-line  S4A.MrR  wire  everywhere
    else  (so  the  window/low/far  legs  keep  their  on-line
    shape  and  proofs).  -/
noncomputable def MrLift (t0 d0 : ℝ) : ℝ :=
    if 1000 ≤ t0 ∧ d0 ≤ 1 / 2 ∧ (1 / 200 : ℝ) ≤ d0
    then t4m_MwireOff t0 d0
    else S4A.MrR t0 d0

/--  THE  ENDPOINT  OVER  THE  STRIP  FRONTIER  WITH  G-hs3
    MACHINED  AT  AN  ARBITRARY  CITED  FRONTIER  H  (discovery
    0118):  under  [Z-H],  the  endpoint  holds  from  (i)  the
    WINDOW  face  (zero-exclusion  of  (H,  inf)  x  (0,  1/200)
    -  open,  as  before),  (ii)  G-hs1  on  the  strip  band
    (open,  as  before),  and  (iii)  the  MACHINED  hs3  face:
    the  scale  at  the  off-pair  in  the  strip  band  is
    bounded  by  the  OFF-LINE  EM  wall  (T4OffD  wall,  n4
    schedule)  plus  the  OFF-LINE  lifted  M-wire  (T4OffM,
    CITED  1.6  convexity  mass).  Everything  else  is  IN
    BODY:  below  H  vacuous;  window  band  killed  by  the
    window  face;  far  region  by  [Z78];  S1  from  the  face,
    S2  covered  /  low-vacuous  /  far;  S3  from  machined
    face  +  T4OffD  (wall  <=  strip  B-wire);  S4  strip  from
    t4m_margin  (lifted  wire  <  floor)  and  S4  window
    from  the  face  via  faceSplitH;  hS2low  vacuous  on  its
    domain  (0  <  t0  <  1000  <=  H).  No  RH  claim.  -/
theorem rh_program78_stripfront_mach (q : ZeroSet)
    (hz78 : Z78.externalZeroFree78)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0)
    (honline : ∀ ρ ∈ q.Z, 0 < (|ρ.im| : ℝ) →
      (|ρ.im| : ℝ) < (707 : ℝ) / 50 → ρ.re = 1 / 2)
    (Qside : ℝ × ℝ → ℝ)
    (H : ℝ) (hH : 1000 ≤ H)
    (hPT : WinC.allOnLineUpTo q H)
    (hs1StripH : ∀ (t0 d0 : ℝ), H <= t0 → (1 / 200 : ℝ) <= d0 →
      d0 <= 1 / 2 → offPair q t0 d0 → Qside (t0, d0) ≥ devProg (t0, d0))
    (hs3MachH : ∀ (t0 d0 : ℝ), H <= t0 → (1 / 200 : ℝ) <= d0 →
      d0 <= 1 / 2 → offPair q t0 d0 →
      Qside (t0, d0) ≤
        ‖p4_em_expr (t4o_sOff t0 d0) (S4Strip.n4 t0)‖ +
        t4m_MwireOff t0 d0)
    (hWinH : WinC.hWinFaceResidualH q H) :
    RH q := by
  refine S4A.rh_from_regime_closures q Qside Z78P12.MfP devProg
    Z78P12.BwireP (fun p => MrLift p.1 p.2) floProg
    ?_ ?_ ?_ ?_ ?_ ?_
  · --  S1  witness  leg:  far  =  [Z78];  below  H  =  vacuous;
      --  window  above  =  window  face;  strip  above  =  face.
    intro t0 d0 ht0 hd0 hp
    by_cases hfar : d0 ≤ (1 / 2 : ℝ)
    · by_cases hle : t0 ≤ H
      · exact False.elim ((WinC.noOffLineBelowPT q H hPT t0
          (le_of_lt ht0) hle) d0 hp)
      · by_cases hdw : (1 / 200 : ℝ) ≤ d0
        · have hzm : Z78P12.MfP (t0, d0) = 0 := rfl
          simpa only [hzm, sub_zero] using
            hs1StripH t0 d0 (le_of_lt (not_le.mp hle)) hdw hfar hp
        · exact False.elim ((hWinH t0 d0
            (le_trans hH (le_of_lt (not_le.mp hle)))
            (not_le.mp hle) hd0 (not_le.mp hdw)) hp)
    · exact False.elim (Z78P12.offPairFarEmpty q hz78 hqz t0 d0
        (not_le.mp hfar) hp)
  · --  S2  leg:  covered  =  in  body;  low  band  =  vacuous
      --  below  H;  far  =  [Z78].
    intro t0 d0 ht0 hd0 hp
    by_cases hd0h : d0 ≤ (1 / 2 : ℝ)
    · by_cases ht0k : 1000 ≤ t0
      · exact hs2_covered q honline t0 d0 ht0 ht0k hd0 hd0h hp
      · have hle : t0 ≤ H := le_trans (le_of_lt (not_le.mp ht0k)) hH
        exact False.elim ((WinC.noOffLineBelowPT q H hPT t0
          (le_of_lt ht0) hle) d0 hp)
    · exact False.elim (Z78P12.offPairFarEmpty q hz78 hqz t0 d0
        (not_le.mp hd0h) hp)
  · --  S3  leg:  below  H  =  vacuous;  window  above  =  window
      --  face;  strip  above  =  machined  face  +  T4OffD  (the
      --  off-line  wall  is  dominated  by  the  strip  B-wire);
      --  far  =  [Z78].
    intro t0 d0 ht0 hd0 hp
    by_cases hfar : d0 ≤ (1 / 2 : ℝ)
    · by_cases hle : t0 ≤ H
      · exact False.elim ((WinC.noOffLineBelowPT q H hPT t0
          (le_of_lt ht0) hle) d0 hp)
      · by_cases hdw : (1 / 200 : ℝ) ≤ d0
        · have ht01000 : 1000 ≤ t0 :=
            le_trans hH (le_of_lt (not_le.mp hle))
          have hwall : ‖p4_em_expr (t4o_sOff t0 d0)
              (S4Strip.n4 t0)‖ ≤ p8_B t0 (S4Strip.n4 t0) :=
            t4wall_offline_le_bwires t0 d0 ht01000 hdw hfar
          have hstrip : Qside (t0, d0) ≤
              p8_B t0 (S4Strip.n4 t0) + t4m_MwireOff t0 d0 :=
            le_trans
              (hs3MachH t0 d0 (le_of_lt (not_le.mp hle)) hdw hfar hp)
              (add_le_add hwall le_rfl)
          have hbw : Z78P12.BwireP (t0, d0) = p8_B t0 (S4Strip.n4 t0) := by
            dsimp only [Z78P12.BwireP, S4A.BwireR]
            rw [if_pos ⟨ht01000, hfar⟩, if_pos hdw]
          have hml : MrLift t0 d0 = t4m_MwireOff t0 d0 := by
            dsimp only [MrLift]
            rw [if_pos ⟨ht01000, hfar, hdw⟩]
          simpa only [hbw, hml] using hstrip
        · exact False.elim ((hWinH t0 d0
            (le_trans hH (le_of_lt (not_le.mp hle)))
            (not_le.mp hle) hd0 (not_le.mp hdw)) hp)
    · exact False.elim (Z78P12.offPairFarEmpty q hz78 hqz t0 d0
        (not_le.mp hfar) hp)
  · --  S4  covered:  strip  band  =  t4m_margin  (lifted  wire
      --  <  floor,  in  body);  window  band  =  the  face  shape
      --  via  faceSplitH  (on-line  wire  there:  MrLift  =  MrR).
    intro t0 d0 ht0 hd0 hd0u hp
    have hif : floProg (t0, d0) = S1LowT.floStripMin t0 d0 := by
      dsimp only [floProg]
      rw [if_pos ⟨ht0, hd0u⟩]
    by_cases hdw : (1 / 200 : ℝ) ≤ d0
    · have hml : MrLift t0 d0 = t4m_MwireOff t0 d0 := by
        dsimp only [MrLift]
        rw [if_pos ⟨ht0, hd0u, hdw⟩]
      have hbw : Z78P12.BwireP (t0, d0) = p8_B t0 (S4Strip.n4 t0) := by
        dsimp only [Z78P12.BwireP, S4A.BwireR]
        rw [if_pos ⟨ht0, hd0u⟩, if_pos hdw]
      have hM0 : S4A.MfR (t0, d0) = 0 := rfl
      simpa only [hif, hbw, hml, Z78P12.MfP, hM0, add_zero] using
        t4m_margin t0 d0 ht0 hdw hd0u
    · have hna : ¬ (1000 ≤ t0 ∧ d0 ≤ 1 / 2 ∧ (1 / 200 : ℝ) ≤ d0) :=
        fun h' => by linarith [hdw, h'.2.2]
      have hml : MrLift t0 d0 = S4A.MrR t0 d0 := by
        dsimp only [MrLift]
        rw [if_neg hna]
      have hwinshp : Z78P12.BwireP (t0, d0) + Z78P12.MrP (t0, d0) +
          Z78P12.MfP (t0, d0) < S1LowT.floStripMin t0 d0 :=
        ((WinC.faceSplitH q H hPT).mpr hWinH) t0 d0 ht0 hd0
          (not_le.mp hdw) hp
      simpa only [hif, hml, Z78P12.MrP] using hwinshp
  · --  S4  low  band:  its  whole  domain  (0,  1000)  sits  below
      --  the  frontier:  vacuous.
    intro t0 d0 ht0 ht0u hd0 hd0u hp
    have hle : t0 ≤ H := le_trans (le_of_lt ht0u) hH
    exact False.elim ((WinC.noOffLineBelowPT q H hPT t0
      (le_of_lt ht0) hle) d0 hp)
  · --  S4  far  region:  [Z78].
    intro t0 d0 ht0 hd0 hd0f hp
    exact False.elim (Z78P12.offPairFarEmpty q hz78 hqz t0 d0 hd0f hp)

/--  THE  MACHINED  STRIPFRONT  ENDPOINT  AT  THE  PLATT-TRUDGIAN
    FRONTIER  (the  [Z-PT2]  instantiation):  the  entire  named
    residue  lives  STRICTLY  ABOVE  3,000,175,332,800,  and  the
    hs3  leg  of  that  residue  is  CARRY  of  the  CITED  1.6
    convexity  mass  (T4OffM),  not  an  analytic  barrier.  No
    RH  claim.  -/
theorem rh_program78_stripfront_mach_PT2 (q : ZeroSet)
    (hz78 : Z78.externalZeroFree78)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0)
    (honline : ∀ ρ ∈ q.Z, 0 < (|ρ.im| : ℝ) →
      (|ρ.im| : ℝ) < (707 : ℝ) / 50 → ρ.re = 1 / 2)
    (Qside : ℝ × ℝ → ℝ)
    (hPT2 : WinC.allOnLineUpTo q WinC.tPT2)
    (hs1StripPT2 : ∀ (t0 d0 : ℝ), WinC.tPT2 <= t0 → (1 / 200 : ℝ) <= d0 →
      d0 <= 1 / 2 → offPair q t0 d0 → Qside (t0, d0) ≥ devProg (t0, d0))
    (hs3MachPT2 : ∀ (t0 d0 : ℝ), WinC.tPT2 <= t0 → (1 / 200 : ℝ) <= d0 →
      d0 <= 1/2 → offPair q t0 d0 →
      Qside (t0, d0) ≤
        ‖p4_em_expr (t4o_sOff t0 d0) (S4Strip.n4 t0)‖ +
        t4m_MwireOff t0 d0)
    (hWinPT2 : WinC.hWinFaceResidualH q WinC.tPT2) :
    RH q :=
  rh_program78_stripfront_mach q hz78 hqz honline Qside WinC.tPT2
    (by norm_num [WinC.tPT2]) hPT2 hs1StripPT2 hs3MachPT2 hWinPT2


/-  ##  Part  B8  -  G-hs1  AS  THE  PIN  FAMILY  OVER  THE  STRIP
    BAND  ABOVE  THE  FRONTIER  (discovery  0120)

  The  B2  restatement  (rh_program78_s1pins,  discovery  0095)
  showed  that  the  bare  hs1  scale  inequality  is  the
  PIN  FAMILY  at  the  witness  zero  (P1  fill  =  the  A0
  fill,  P2  kernel  magnitude,  P3  the  A4.3  mass,  P4
  absorption),  with  the  hs1  leg  derived  in  body  via
  S1Face.hs1AtZero.  Part  B8  does  the  same  for  the
  MACHINED  stripfront  endpoint:  G-hs1  on  the  strip  band
  above  the  frontier  is  entered  as  the  pin  family
  restricted  to  strip-band  off-pair  zeros  (1/200  <=  d0
  <=  1/2),  and  the  S1  leg  is  derived  in  the  body  the
  same  way  (the  window  branch  keeps  the  window  face,
  below  the  frontier  is  vacuous,  the  far  region  is
  [Z78]).  The  residual  shape  of  G-hs1  narrows  from  the
  bare  scale  inequality  to  the  checkable  witness-level
  pin  family;  the  pins  are  data  faces  (measured  where
  data  reach;  citation  content  above  the  verified
  frontier,  exactly  like  [Z-PT2]).  No  RH  claim.  -/

theorem rh_program78_stripfront_mach_s1pins (q : ZeroSet)
    (hz78 : Z78.externalZeroFree78)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0)
    (honline : ∀ ρ ∈ q.Z, 0 < (|ρ.im| : ℝ) →
      (|ρ.im| : ℝ) < (707 : ℝ) / 50 → ρ.re = 1 / 2)
    (Qside : ℝ × ℝ → ℝ)
    (H : ℝ) (hH : 1000 ≤ H)
    (hPT : WinC.allOnLineUpTo q H)
    (n : ℕ)
    (Kfun : ℂ → ℂ)
    (mvalFace : ℝ × ℝ → ℝ)
    (devFacePt : ℂ → ℝ)
    (hFill : ∀ (t0 d0 : ℝ) (ρ : ℂ), 0 < t0 → (1 / 200 : ℝ) ≤ d0 →
      d0 ≤ 1 / 2 → ρ ∈ q.Z → ρ.re ≠ (1 / 2 : ℝ) →
      (|ρ.im| : ℝ) = t0 → |(ρ.re : ℝ) - 1 / 2| = d0 →
      Qside (t0, d0) = ‖riemannZeta ρ - Kfun ρ‖)
    (hDev : ∀ (t0 d0 : ℝ) (ρ : ℂ), 0 < t0 → (1 / 200 : ℝ) ≤ d0 →
      d0 ≤ 1 / 2 → ρ ∈ q.Z → ρ.re ≠ (1 / 2 : ℝ) →
      (|ρ.im| : ℝ) = t0 → |(ρ.re : ℝ) - 1 / 2| = d0 →
      devFacePt ρ ≤ ‖p4_Wn ρ n‖)
    (hMass : ∀ (t0 d0 : ℝ) (ρ : ℂ), 0 < t0 → (1 / 200 : ℝ) ≤ d0 →
      d0 ≤ 1 / 2 → ρ ∈ q.Z → ρ.re ≠ (1 / 2 : ℝ) →
      (|ρ.im| : ℝ) = t0 → |(ρ.re : ℝ) - 1 / 2| = d0 →
      ‖Kfun ρ - (p4_P n ρ - p4_I n ρ)‖ ≤ mvalFace (t0, d0))
    (hAbsorb : ∀ (t0 d0 : ℝ) (ρ : ℂ), 0 < t0 → (1 / 200 : ℝ) ≤ d0 →
      d0 ≤ 1 / 2 → ρ ∈ q.Z → ρ.re ≠ (1 / 2 : ℝ) →
      (|ρ.im| : ℝ) = t0 → |(ρ.re : ℝ) - 1 / 2| = d0 →
      devProg (t0, d0) + mvalFace (t0, d0) ≤ devFacePt ρ)
    (hs3MachH : ∀ (t0 d0 : ℝ), H <= t0 → (1 / 200 : ℝ) <= d0 →
      d0 <= 1 / 2 → offPair q t0 d0 →
      Qside (t0, d0) ≤
        ‖p4_em_expr (t4o_sOff t0 d0) (S4Strip.n4 t0)‖ +
        t4m_MwireOff t0 d0)
    (hWinH : WinC.hWinFaceResidualH q H) :
    RH q := by
  refine rh_program78_stripfront_mach q hz78 hqz honline Qside
    H hH hPT ?hs1 hs3MachH hWinH
  --  the  G-hs1  face  over  the  strip  band  above  the
  --  frontier:  the  pin  family  at  the  witness  zero  +
  --  S1Face  (the  B2  derivation,  restricted).
  intro t0 d0 ht0F hdlo hdh hp
  have ht0 : 0 < t0 := by linarith [hH, ht0F]
  obtain ⟨ρ, hrho, hrhooff, hint0, hd0eq⟩ := hp
  have hzero := hqz ρ hrho
  have hfill : Qside (t0, d0) = ‖riemannZeta ρ - Kfun ρ‖ :=
    hFill t0 d0 ρ ht0 hdlo hdh hrho hrhooff hint0 hd0eq
  have hdev : devFacePt ρ ≤ ‖p4_Wn ρ n‖ :=
    hDev t0 d0 ρ ht0 hdlo hdh hrho hrhooff hint0 hd0eq
  have hmas : ‖Kfun ρ - (p4_P n ρ - p4_I n ρ)‖ ≤
      mvalFace (t0, d0) :=
    hMass t0 d0 ρ ht0 hdlo hdh hrho hrhooff hint0 hd0eq
  have habsb : devProg (t0, d0) + mvalFace (t0, d0) ≤
      devFacePt ρ :=
    hAbsorb t0 d0 ρ ht0 hdlo hdh hrho hrhooff hint0 hd0eq
  have hf := S1Face.hs1AtZero ρ n (Kfun ρ) (mvalFace (t0, d0))
    (devFacePt ρ) hmas hdev hzero
  have hfillK : ‖riemannZeta ρ - Kfun ρ‖ = ‖Kfun ρ‖ := by
    rw [hzero]
    simp [norm_neg]
  have habs : devProg (t0, d0) ≤ devFacePt ρ - mvalFace (t0, d0) :=
    (le_sub_iff_add_le).mpr habsb
  calc Qside (t0, d0)
      _ = ‖riemannZeta ρ - Kfun ρ‖ := hfill
      _ = ‖Kfun ρ‖ := hfillK
      _ ≥ devFacePt ρ - mvalFace (t0, d0) := hf
      _ ≥ devProg (t0, d0) := habs

/-  ##  THE  [Z-PT2]  INSTANCES  (discovery  0120)  -/
--  (the  two  theorems  below  instantiate  the  frontier  at
--   tPT2;  the  whole  residual  lives  strictly  above
--   3,000,175,332,800.)

/--  THE  MACHINED  STRIPFRONT  ENDPOINT  AT  tPT2  -  HS3  AS
    THE  LIFTED-WIRE  FACE  (discovery  0119,  this  file  part
    B7  -  see  rh_program78_stripfront_mach_PT2  above).  -/
theorem rh_program78_stripfront_mach_s1pins_PT2 (q : ZeroSet)
    (hz78 : Z78.externalZeroFree78)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0)
    (honline : ∀ ρ ∈ q.Z, 0 < (|ρ.im| : ℝ) →
      (|ρ.im| : ℝ) < (707 : ℝ) / 50 → ρ.re = 1 / 2)
    (Qside : ℝ × ℝ → ℝ)
    (hPT2 : WinC.allOnLineUpTo q WinC.tPT2)
    (n : ℕ)
    (Kfun : ℂ → ℂ)
    (mvalFace : ℝ × ℝ → ℝ)
    (devFacePt : ℂ → ℝ)
    (hFill : ∀ (t0 d0 : ℝ) (ρ : ℂ), 0 < t0 → (1 / 200 : ℝ) ≤ d0 →
      d0 ≤ 1 / 2 → ρ ∈ q.Z → ρ.re ≠ (1 / 2 : ℝ) →
      (|ρ.im| : ℝ) = t0 → |(ρ.re : ℝ) - 1 / 2| = d0 →
      Qside (t0, d0) = ‖riemannZeta ρ - Kfun ρ‖)
    (hDev : ∀ (t0 d0 : ℝ) (ρ : ℂ), 0 < t0 → (1 / 200 : ℝ) ≤ d0 →
      d0 ≤ 1 / 2 → ρ ∈ q.Z → ρ.re ≠ (1 / 2 : ℝ) →
      (|ρ.im| : ℝ) = t0 → |(ρ.re : ℝ) - 1 / 2| = d0 →
      devFacePt ρ ≤ ‖p4_Wn ρ n‖)
    (hMass : ∀ (t0 d0 : ℝ) (ρ : ℂ), 0 < t0 → (1 / 200 : ℝ) ≤ d0 →
      d0 ≤ 1 / 2 → ρ ∈ q.Z → ρ.re ≠ (1 / 2 : ℝ) →
      (|ρ.im| : ℝ) = t0 → |(ρ.re : ℝ) - 1 / 2| = d0 →
      ‖Kfun ρ - (p4_P n ρ - p4_I n ρ)‖ ≤ mvalFace (t0, d0))
    (hAbsorb : ∀ (t0 d0 : ℝ) (ρ : ℂ), 0 < t0 → (1 / 200 : ℝ) ≤ d0 →
      d0 ≤ 1 / 2 → ρ ∈ q.Z → ρ.re ≠ (1 / 2 : ℝ) →
      (|ρ.im| : ℝ) = t0 → |(ρ.re : ℝ) - 1 / 2| = d0 →
      devProg (t0, d0) + mvalFace (t0, d0) ≤ devFacePt ρ)
    (hs3MachPT2 : ∀ (t0 d0 : ℝ), WinC.tPT2 <= t0 → (1 / 200 : ℝ) <= d0 →
      d0 <= 1/2 → offPair q t0 d0 →
      Qside (t0, d0) ≤
        ‖p4_em_expr (t4o_sOff t0 d0) (S4Strip.n4 t0)‖ +
        t4m_MwireOff t0 d0)
    (hWinPT2 : WinC.hWinFaceResidualH q WinC.tPT2) :
    RH q :=
  rh_program78_stripfront_mach_s1pins q hz78 hqz honline Qside
    WinC.tPT2 (by norm_num [WinC.tPT2]) hPT2
    n Kfun mvalFace devFacePt hFill hDev hMass hAbsorb
    hs3MachPT2 hWinPT2


/-  ##  Part  B9  -  THE  HS3  FACE  SPLIT  BY  FLANK
    (discovery  0122,  after  T4OffL,  discovery  0121)

  The  off-pair  (t0,  d0)  =  (|im  rho|,  |re  rho  -  1/2|)
  records  no  FLANK.  The  G-hs3  machinery  of  Parts  B7/
  B8  lives  at  the  RIGHT  canonical  point  t4o_sOff  (re
  =  1/2  +  d0:  wall  <=  strip  B-wire,  T4OffD,  machine).
  T4OffL  (discovery  0121)  records  the  left-flank  barrier:
  at  the  LEFT  point  t4l_sOffL  (re  =  1/2  -  d0)  the
  first  T4  term  of  the  wall  is  (1/2)*n^-(1/2-d0)  -  it
  exceeds  the  endpoint  floor  on  the  band  edge  for
  t  >=  10^10  (t4l_barrier_edge)  and  is  above  the  half-
  floor  at  EVERY  schedule  n  at  sigma  =  0  (t4l_barrier_
  sigma0).  So  the  B7  face,  stated  with  the  right-point
  wall  as  its  bound,  CANNOT  be  machine-produced  for  left-
  flank  off-pairs  beyond  the  barrier  region.

  Part  B9  states  the  endpoint  with  the  face  SPLIT  by
  the  flank  of  the  witness  (t4l_flankSplit):  right  =
  the  machine-closable  B7  shape  (T4OffD  in  body);  left
  =  the  PAIR-LEVEL  S3  squeeze  Qside  <=  Bwire  +  Mr  -
  the  named  analytic  face  G-hs3-left  (the  squeeze  side
  at  a  left-flank  off-pair;  per-point  closure  needs  a
  left-tuned  schedule,  no  uniform  one  covers  the  band).
  The  residual  of  the  split  endpoint  is  exactly  the
  four-face  ledger  of  discovery  0121:  G-hs1,  window  zero-
  exclusion,  hs3  at  the  RIGHT  witness  (machined,  cited
  1.6  mass),  G-hs3-left.  No  RH  claim.  -/

/--  RIGHT-FLANK  WITNESS  (discovery  0122):  a  zero  of  q
    of  pair  shape  (t0,  d0)  with  re  =  1/2  +  d0.  -/
def t4l_rightWitness (q : ZeroSet) (t0 d0 : ℝ) (ρ : ℂ) : Prop :=
    ρ ∈ q.Z ∧ (|ρ.im| : ℝ) = t0 ∧ |(ρ.re : ℝ) - 1 / 2| = d0 ∧
      ρ.re = 1 / 2 + d0

/--  LEFT-FLANK  WITNESS  (discovery  0122):  a  zero  of  q  of
    pair  shape  (t0,  d0)  with  re  =  1/2  -  d0.  -/
def t4l_leftWitness (q : ZeroSet) (t0 d0 : ℝ) (ρ : ℂ) : Prop :=
    ρ ∈ q.Z ∧ (|ρ.im| : ℝ) = t0 ∧ |(ρ.re : ℝ) - 1 / 2| = d0 ∧
      ρ.re = 1 / 2 - d0

/--  RIGHT-  /  LEFT-FLANK  OFF-PAIRS  (discovery  0122).  -/
def t4l_rightOffPair (q : ZeroSet) (t0 d0 : ℝ) : Prop :=
    ∃ ρ, t4l_rightWitness q t0 d0 ρ
def t4l_leftOffPair (q : ZeroSet) (t0 d0 : ℝ) : Prop :=
    ∃ ρ, t4l_leftWitness q t0 d0 ρ

/--  FLANK  SPLIT  (discovery  0122):  an  off-pair  with  d0  ≠
    0  splits  by  the  flank  of  the  witness  -  the  |.|-shape
    of  the  pair  gives  re  =  1/2  +-  d0  exactly.  -/
theorem t4l_flankSplit (q : ZeroSet) (t0 d0 : ℝ) (hd0 : d0 ≠ 0) :
    offPair q t0 d0 ↔ t4l_rightOffPair q t0 d0 ∨ t4l_leftOffPair q t0 d0 := by
  constructor
  · rintro ⟨ρ, hr, hrne, him, hre⟩
    have hd0n : 0 ≤ d0 := by
      rw [← hre]
      exact abs_nonneg ((ρ.re : ℝ) - 1 / 2)
    rcases (abs_eq hd0n).mp hre with (h | h)
    · exact Or.inl ⟨ρ, ⟨hr, him, hre, by linarith [h]⟩⟩
    · exact Or.inr ⟨ρ, ⟨hr, him, hre, by linarith [h]⟩⟩
  · intro h
    rcases h with (hro | hlo)
    · obtain ⟨ρ, hz, him, hre, hrw⟩ := hro
      refine ⟨ρ, hz, ?_, him, hre⟩
      intro heq
      have hd00 : d0 = 0 := by linarith [hrw, heq]
      exact hd0 hd00
    · obtain ⟨ρ, hz, him, hre, hlr⟩ := hlo
      refine ⟨ρ, hz, ?_, him, hre⟩
      intro heq
      have hd00 : d0 = 0 := by linarith [hlr, heq]
      exact hd0 hd00

/--  THE  B7  SINGLE-FACE  PREMISE  RESTRICTS  TO  THE  RIGHT-
    FLANK  FACE  (discovery  0122):  a  right-flank  witness  is
    an  off-pair  witness  (d0  >=  1/200  >  0  keeps  re  ≠
    1/2)  -  so  the  flank-split  endpoint  never  asks  more  of
    the  right  flank  than  the  B7  endpoint  did.  The  dual
    NEGATIVE  -  that  the  B7  premise  does  NOT  imply  the
    left  face  beyond  the  barrier  region  -  is  exactly  the
    T4OffL  barrier  (discovery  0121),  recorded  there,  not
    here  (it  is  an  inequality  between  explicit  machine
    wires,  not  an  implication  between  premises).  -/
theorem t4l_rightFaceOfSingle (q : ZeroSet) (Qside : ℝ × ℝ → ℝ) (H : ℝ)
    (hs3MachH : ∀ (t0 d0 : ℝ), H <= t0 → (1 / 200 : ℝ) <= d0 →
      d0 <= 1 / 2 → offPair q t0 d0 →
      Qside (t0, d0) <=
        ‖p4_em_expr (t4o_sOff t0 d0) (S4Strip.n4 t0)‖ + t4m_MwireOff t0 d0)
    (t0 d0 : ℝ) (ht0 : H <= t0) (hdlo : (1 / 200 : ℝ) <= d0)
    (hdh : d0 <= 1 / 2) (hro : t4l_rightOffPair q t0 d0) :
    Qside (t0, d0) <=
      ‖p4_em_expr (t4o_sOff t0 d0) (S4Strip.n4 t0)‖ + t4m_MwireOff t0 d0 := by
  obtain ⟨ρ, hz, him, hre, hrw⟩ := hro
  have hpair : offPair q t0 d0 := by
    refine ⟨ρ, hz, ?_, him, hre⟩
    intro heq
    linarith [hrw, heq, hdlo]
  exact hs3MachH t0 d0 ht0 hdlo hdh hpair

/--  THE  FLANK-SPLIT  MACHINED  STRIPFRONT  ENDPOINT  AT  AN
    ARBITRARY  FRONTIER  H  (discovery  0122,  Part  B9):
    rh_program78_stripfront_mach  with  the  hs3  face  SPLIT  by
    the  flank  of  the  off-pair  witness.
    (i)   G-hs1  (open,  as  before);
    (ii)  the  window  zero-exclusion  face  (open,  as  before);
    (iii)  hs3  at  a  RIGHT-FLANK  witness  (t4l_rightOffPair)  -
          the  machine-closable  shape:  the  OFF-LINE  EM  wall
          at  the  RIGHT  canonical  point  t4o_sOff  on  the  n4
          schedule  plus  the  lifted  M-wire;  the  S3  leg
          closes  in  body  via  T4OffD  (wall  <=  strip  B-wire);
    (iv)  G-hs3-left  -  hs3  at  a  LEFT-FLANK  witness
          (t4l_leftOffPair),  stated  at  pair  level  (Qside  <=
          Bwire  +  Mr):  the  analytic  face  T4OffL  (discovery
          0121)  shows  the  n4  machine  cannot  produce  from
          wall  +  wire  at  the  left  point.  The  S4  leg  is
          t4m_margin  on  the  strip  band  (FLANK-INDEPENDENT:
          it  is  a  statement  about  the  wire  and  the  floor
          only).  The  residual  is  exactly  the  four-face
          ledger  of  discovery  0121.  No  RH  claim.  -/
theorem rh_program78_stripfront_mach_left (q : ZeroSet)
    (hz78 : Z78.externalZeroFree78)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0)
    (honline : ∀ ρ ∈ q.Z, 0 < (|ρ.im| : ℝ) →
      (|ρ.im| : ℝ) < (707 : ℝ) / 50 → ρ.re = 1 / 2)
    (Qside : ℝ × ℝ → ℝ)
    (H : ℝ) (hH : 1000 ≤ H)
    (hPT : WinC.allOnLineUpTo q H)
    (hs1StripH : ∀ (t0 d0 : ℝ), H <= t0 → (1 / 200 : ℝ) <= d0 →
      d0 <= 1 / 2 → offPair q t0 d0 → Qside (t0, d0) ≥ devProg (t0, d0))
    (hs3RightH : ∀ (t0 d0 : ℝ), H <= t0 → (1 / 200 : ℝ) <= d0 →
      d0 <= 1 / 2 → t4l_rightOffPair q t0 d0 →
      Qside (t0, d0) <=
        ‖p4_em_expr (t4o_sOff t0 d0) (S4Strip.n4 t0)‖ + t4m_MwireOff t0 d0)
    (hs3LeftH : ∀ (t0 d0 : ℝ), H <= t0 → (1 / 200 : ℝ) <= d0 →
      d0 <= 1 / 2 → t4l_leftOffPair q t0 d0 →
      Qside (t0, d0) <=
        Z78P12.BwireP (t0, d0) + (fun p => MrLift p.1 p.2) (t0, d0))
    (hWinH : WinC.hWinFaceResidualH q H) :
    RH q := by
  refine S4A.rh_from_regime_closures q Qside Z78P12.MfP devProg
    Z78P12.BwireP (fun p => MrLift p.1 p.2) floProg
    ?_ ?_ ?_ ?_ ?_ ?_
  · --  S1  witness  leg:  far  =  [Z78];  below  H  =  vacuous;
      --  window  above  =  window  face;  strip  above  =  face.
    intro t0 d0 ht0 hd0 hp
    by_cases hfar : d0 ≤ (1 / 2 : ℝ)
    · by_cases hle : t0 ≤ H
      · exact False.elim ((WinC.noOffLineBelowPT q H hPT t0
          (le_of_lt ht0) hle) d0 hp)
      · by_cases hdw : (1 / 200 : ℝ) ≤ d0
        · have hzm : Z78P12.MfP (t0, d0) = 0 := rfl
          simpa only [hzm, sub_zero] using
            hs1StripH t0 d0 (le_of_lt (not_le.mp hle)) hdw hfar hp
        · exact False.elim ((hWinH t0 d0
            (le_trans hH (le_of_lt (not_le.mp hle)))
            (not_le.mp hle) hd0 (not_le.mp hdw)) hp)
    · exact False.elim (Z78P12.offPairFarEmpty q hz78 hqz t0 d0
        (not_le.mp hfar) hp)
  · --  S2  leg:  covered  =  in  body;  low  band  =  vacuous
      --  below  H;  far  =  [Z78].
    intro t0 d0 ht0 hd0 hp
    by_cases hd0h : d0 ≤ (1 / 2 : ℝ)
    · by_cases ht0k : 1000 ≤ t0
      · exact hs2_covered q honline t0 d0 ht0 ht0k hd0 hd0h hp
      · have hle : t0 ≤ H := le_trans (le_of_lt (not_le.mp ht0k)) hH
        exact False.elim ((WinC.noOffLineBelowPT q H hPT t0
          (le_of_lt ht0) hle) d0 hp)
    · exact False.elim (Z78P12.offPairFarEmpty q hz78 hqz t0 d0
        (not_le.mp hd0h) hp)
  · --  S3  leg:  the  FLANK  SPLIT  (the  content  of  Part  B9).
      --  below  H  =  vacuous;  window  above  =  window  face;
      --  far  =  [Z78];  strip  above  =  right  (machined,
      --  T4OffD  in  body)  or  left  (the  G-hs3-left  face).
    intro t0 d0 ht0 hd0 hp
    by_cases hfar : d0 ≤ (1 / 2 : ℝ)
    · by_cases hle : t0 ≤ H
      · exact False.elim ((WinC.noOffLineBelowPT q H hPT t0
          (le_of_lt ht0) hle) d0 hp)
      · by_cases hdw : (1 / 200 : ℝ) ≤ d0
        · obtain ⟨ρ, hρ, hρne, hρim, hρd⟩ := hp
          have hd0n : 0 ≤ d0 := by linarith [hdw]
          have hht0 : 1000 ≤ t0 :=
            le_trans hH (le_of_lt (not_le.mp hle))
          rcases (abs_eq hd0n).mp hρd with (hdir | hdir)
          · --  RIGHT  FLANK:  the  machined  B7  shape.
            have hrw : ρ.re = 1 / 2 + d0 := by linarith [hdir]
            have hroff : t4l_rightOffPair q t0 d0 :=
              ⟨ρ, ⟨hρ, hρim, hρd, hrw⟩⟩
            have hface : Qside (t0, d0) <=
                ‖p4_em_expr (t4o_sOff t0 d0) (S4Strip.n4 t0)‖ +
                t4m_MwireOff t0 d0 :=
              hs3RightH t0 d0 (le_of_lt (not_le.mp hle)) hdw hfar hroff
            have hwall : ‖p4_em_expr (t4o_sOff t0 d0)
                (S4Strip.n4 t0)‖ <= p8_B t0 (S4Strip.n4 t0) :=
              t4wall_offline_le_bwires t0 d0 hht0 hdw hfar
            have hstrip : Qside (t0, d0) <=
                p8_B t0 (S4Strip.n4 t0) + t4m_MwireOff t0 d0 :=
              le_trans hface (add_le_add hwall le_rfl)
            have hbw : Z78P12.BwireP (t0, d0) = p8_B t0 (S4Strip.n4 t0) := by
              dsimp only [Z78P12.BwireP, S4A.BwireR]
              rw [if_pos ⟨hht0, hfar⟩, if_pos hdw]
            have hml : (fun p => MrLift p.1 p.2) (t0, d0) =
                t4m_MwireOff t0 d0 := by
              simp only [MrLift]
              rw [if_pos ⟨hht0, hfar, hdw⟩]
            simpa only [hbw, hml] using hstrip
          · --  LEFT  FLANK:  the  named  G-hs3-left  face.
            have hlr : ρ.re = 1 / 2 - d0 := by linarith [hdir]
            have hloff : t4l_leftOffPair q t0 d0 :=
              ⟨ρ, ⟨hρ, hρim, hρd, hlr⟩⟩
            exact hs3LeftH t0 d0 (le_of_lt (not_le.mp hle))
              hdw hfar hloff
        · exact False.elim ((hWinH t0 d0
            (le_trans hH (le_of_lt (not_le.mp hle)))
            (not_le.mp hle) hd0 (not_le.mp hdw)) hp)
    · exact False.elim (Z78P12.offPairFarEmpty q hz78 hqz t0 d0
        (not_le.mp hfar) hp)
  · --  S4  covered:  strip  band  =  t4m_margin  (FLANK-INDEPENDENT:
      --  a  statement  about  the  wire  and  the  floor  only);
      --  window  band  =  the  face  shape  via  faceSplitH.
    intro t0 d0 ht0 hd0 hd0u hp
    have hif : floProg (t0, d0) = S1LowT.floStripMin t0 d0 := by
      dsimp only [floProg]
      rw [if_pos ⟨ht0, hd0u⟩]
    by_cases hdw : (1 / 200 : ℝ) ≤ d0
    · have hml : MrLift t0 d0 = t4m_MwireOff t0 d0 := by
        dsimp only [MrLift]
        rw [if_pos ⟨ht0, hd0u, hdw⟩]
      have hbw : Z78P12.BwireP (t0, d0) = p8_B t0 (S4Strip.n4 t0) := by
        dsimp only [Z78P12.BwireP, S4A.BwireR]
        rw [if_pos ⟨ht0, hd0u⟩, if_pos hdw]
      have hM0 : S4A.MfR (t0, d0) = 0 := rfl
      simpa only [hif, hbw, hml, Z78P12.MfP, hM0, add_zero] using
        t4m_margin t0 d0 ht0 hdw hd0u
    · have hna : ¬ (1000 ≤ t0 ∧ d0 ≤ 1 / 2 ∧ (1 / 200 : ℝ) ≤ d0) :=
        fun h' => by linarith [hdw, h'.2.2]
      have hml : MrLift t0 d0 = S4A.MrR t0 d0 := by
        dsimp only [MrLift]
        rw [if_neg hna]
      have hwinshp : Z78P12.BwireP (t0, d0) + Z78P12.MrP (t0, d0) +
          Z78P12.MfP (t0, d0) < S1LowT.floStripMin t0 d0 :=
        ((WinC.faceSplitH q H hPT).mpr hWinH) t0 d0 ht0 hd0
          (not_le.mp hdw) hp
      simpa only [hif, hml, Z78P12.MrP] using hwinshp
  · --  S4  low  band:  its  whole  domain  (0,  1000)  sits  below
      --  the  frontier:  vacuous.
    intro t0 d0 ht0 ht0u hd0 hd0u hp
    have hle : t0 ≤ H := le_trans (le_of_lt ht0u) hH
    exact False.elim ((WinC.noOffLineBelowPT q H hPT t0
      (le_of_lt ht0) hle) d0 hp)
  · --  S4  far  region:  [Z78].
    intro t0 d0 ht0 hd0 hd0f hp
    exact False.elim (Z78P12.offPairFarEmpty q hz78 hqz t0 d0 hd0f hp)

/--  THE  FLANK-SPLIT  MACHINED  STRIPFRONT  ENDPOINT  AT  THE
    PLATT-TRUDGIAN  FRONTIER  (the  [Z-PT2]  instantiation,
    discovery  0122):  the  entire  named  residue  lives  STRICTLY
    ABOVE  3,000,175,332,800  -  G-hs1,  window  zero-exclusion,
    hs3  at  the  right  witness  (machined,  cited  1.6  mass),
    and  G-hs3-left  (the  analytic  face).  No  RH  claim.  -/
theorem rh_program78_stripfront_mach_left_PT2 (q : ZeroSet)
    (hz78 : Z78.externalZeroFree78)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0)
    (honline : ∀ ρ ∈ q.Z, 0 < (|ρ.im| : ℝ) →
      (|ρ.im| : ℝ) < (707 : ℝ) / 50 → ρ.re = 1 / 2)
    (Qside : ℝ × ℝ → ℝ)
    (hPT2 : WinC.allOnLineUpTo q WinC.tPT2)
    (hs1StripPT2 : ∀ (t0 d0 : ℝ), WinC.tPT2 <= t0 → (1 / 200 : ℝ) <= d0 →
      d0 <= 1 / 2 → offPair q t0 d0 → Qside (t0, d0) ≥ devProg (t0, d0))
    (hs3RightPT2 : ∀ (t0 d0 : ℝ), WinC.tPT2 <= t0 → (1 / 200 : ℝ) <= d0 →
      d0 <= 1/2 → t4l_rightOffPair q t0 d0 →
      Qside (t0, d0) <=
        ‖p4_em_expr (t4o_sOff t0 d0) (S4Strip.n4 t0)‖ +
        t4m_MwireOff t0 d0)
    (hs3LeftPT2 : ∀ (t0 d0 : ℝ), WinC.tPT2 <= t0 → (1 / 200 : ℝ) <= d0 →
      d0 <= 1/2 → t4l_leftOffPair q t0 d0 →
      Qside (t0, d0) <=
        Z78P12.BwireP (t0, d0) + (fun p => MrLift p.1 p.2) (t0, d0))
    (hWinPT2 : WinC.hWinFaceResidualH q WinC.tPT2) :
    RH q :=
  rh_program78_stripfront_mach_left q hz78 hqz honline Qside
    WinC.tPT2 (by norm_num [WinC.tPT2]) hPT2
    hs1StripPT2 hs3RightPT2 hs3LeftPT2 hWinPT2



/-  ##  Part  B10  -  THE  BAND  SQUEEZE  WINDOW  IS  EMPTY  IN
    BODY,  AND  THE  STRIP  FACE  BUNDLE  COLLAPSES  TO  ONE
    ZERO-EXCLUSION  FACE  (discovery  0125  follow-through,
    after  the  S8  /  S35B  pre-check)

  Part  B9  left  the  endpoint's  strip-band  residual  as  a
  THREE-face  bundle:  G-hs1  (Qside  >=  devProg),  hs3  at
  the  RIGHT  witness  (Qside  <=  off-line  EM  wall  +  Mr,
  the  machined  B7  shape),  and  G-hs3-left  (Qside  <=
  Bwire  +  Mr  at  a  left-flank  witness).  Part  B10  shows
  the  bundle  is  JOINTLY  EMPTY  in  body  (flank-
  independent,  no  numerics):

  (B10.1)  t4l_bandWireBelow:  on  the  strip  band  (1000  <=
    t0,  1/200  <=  d0  <=  1/2)  at  any  off-pair,  the
    endpoint  wire  +  mass  sits  STRICTLY  BELOW  the  S1
    floor:  BwireP  +  MrLift  <  devProg  -  t4m_margin  (the
    S4  in-body  closure,  discovery  0118)  composed  with
    S2  in  body  (FUnif.s2ActualFullBand:  devStripMin  >=
    floStripMin  on  the  band).
  (B10.2)  t4l_bandEmpty:  no  scale  Qside  can  satisfy  BOTH
    squeeze  legs  (S1:  Qside  >=  devProg;  S3:  Qside  <=
    Bwire  +  Mr)  at  a  band  off-pair  -  the  squeeze
    window  is  EMPTY.  The  S35B  pre-check  (tmp/
    s35b_leftflank_precheck.py)  measured  the  actual  size
    of  this  body  gap:  devProg  /  (p8_B  +  MrLift)  >=
    1.1136  at  the  band  edge  d0  =  1/200,  growing  to
    ~1.1e4  by  d0  =  1/2.
  (B10.3)  t4l_stripFacesEmpty:  the  three  strip  faces  of
    the  B9  endpoint  are  jointly  CONTRADICTORY  at  every
    band  off-pair  (right  branch  via  the  T4OffD  wall  in
    body;  left  branch  direct)  -  G-hs3-left  and  its  right-
    flank  twin  dissolve  as  INDEPENDENT  faces:  they  are
    components  of  the  strip-band  ZERO-EXCLUSION  face,
    which  the  squeeze  certificate  above  certifies  in
    body  from  the  S1  data  side  (the  pin  family  of
    Part  B8).
  (B10.4)  rh_program78_stripfront_mach_vacant  (+  _PT2):  the
    endpoint  with  the  strip  face  bundle  replaced  by  ONE
    band-zero-exclusion  face  (hNoStrip).  The  residual  in
    the  unverified  region  is  now  exactly  two  zero-
    exclusion  faces  (band  +  window)  plus  [Z78]  plus
    the  below-frontier  record  -  no  analytic  face  remains
    inside  the  tree.
  (B10.5)  rh_program78_stripfront_mach_vacant_ofB9  (+  _PT2):
    the  B9  endpoint  (three  strip  faces  +  window  +
    [Z78])  implies  the  vacant  endpoint  (band  exclusion  +
    window  +  [Z78])  in  body  -  the  face  bundle  is
    equivalent,  for  the  endpoint,  to  the  single  zero-
    exclusion  face  it  encodes.

  No  RH  claim:  B10.1-B10.3  are  inequalities  between  named
  explicit  scales  (pure  body  composition  of  the  0118  S4
  wire  margin  and  the  S2  floor  closure);  hNoStrip  is  a
  zero-exclusion  face  in  the  unverified  region,  exactly  on
  record  footing  with  the  window  face  and  the  [Z-PT2]
  record.  -/

/--  B10.1  THE  BAND  WIRE  SITS  STRICTLY  BELOW  THE  S1
    FLOOR  (in  body,  FLANK-INDEPENDENT):  on  the  strip  band
    (1000  <=  t0,  1/200  <=  d0  <=  1/2),  at  any  off-
    pair,  the  endpoint  wire  +  mass  is  strictly  below
    devProg.  t4m_margin  (S4  in  body:  wire  +  Mr  <  floor)
    composed  with  S2  in  body  (floor  <=  devProg).  -/
theorem t4l_bandWireBelow (q : ZeroSet)
    (honline : ∀ ρ ∈ q.Z, 0 < (|ρ.im| : ℝ) → (|ρ.im| : ℝ) <
      (707 : ℝ) / 50 → ρ.re = 1 / 2)
    (t0 d0 : ℝ) (ht0 : 1000 ≤ t0) (hdlo : (1 / 200 : ℝ) ≤ d0)
    (hdh : d0 ≤ 1 / 2) (hp : offPair q t0 d0) :
    Z78P12.BwireP (t0, d0) + (fun p => MrLift p.1 p.2) (t0, d0) <
      devProg (t0, d0) := by
  have hbt0 : 0 < t0 := by linarith [ht0]
  have hbd0 : 0 < d0 := by linarith [hdlo]
  have hbw : Z78P12.BwireP (t0, d0) = p8_B t0 (S4Strip.n4 t0) := by
    dsimp only [Z78P12.BwireP, S4A.BwireR]
    rw [if_pos ⟨ht0, hdh⟩, if_pos hdlo]
  have hml : (fun p => MrLift p.1 p.2) (t0, d0) = t4m_MwireOff t0 d0 := by
    dsimp only [MrLift]
    rw [if_pos ⟨ht0, hdh, hdlo⟩]
  have hwire : Z78P12.BwireP (t0, d0) +
      (fun p => MrLift p.1 p.2) (t0, d0) < S1LowT.floStripMin t0 d0 := by
    simpa only [hbw, hml] using t4m_margin t0 d0 ht0 hdlo hdh
  have hs2 : S1LowT.devStripMin t0 d0 ≥ S1LowT.floStripMin t0 d0 :=
    FUnif.s2ActualFullBand q honline t0 d0 hbt0 hbd0 hdh hp
  dsimp only [devProg]
  linarith

/--  B10.2  JOINT  VACUITY  (in  body,  BOTH  FLANKS):  no  scale
    Qside  can  satisfy  BOTH  squeeze  legs  -  S1  (Qside  >=
    devProg)  and  S3  (Qside  <=  Bwire  +  Mr)  -  at  a  strip-
    band  off-pair:  the  squeeze  window  is  EMPTY.  -/
theorem t4l_bandEmpty (q : ZeroSet)
    (honline : ∀ ρ ∈ q.Z, 0 < (|ρ.im| : ℝ) → (|ρ.im| : ℝ) <
      (707 : ℝ) / 50 → ρ.re = 1 / 2)
    (Qside : ℝ × ℝ → ℝ)
    (t0 d0 : ℝ) (ht0 : 1000 ≤ t0) (hdlo : (1 / 200 : ℝ) ≤ d0)
    (hdh : d0 ≤ 1 / 2) (hp : offPair q t0 d0) :
    ¬ (Qside (t0, d0) ≥ devProg (t0, d0) ∧
       Qside (t0, d0) <=
         Z78P12.BwireP (t0, d0) + (fun p => MrLift p.1 p.2) (t0, d0)) := by
  intro hs
  have hw := t4l_bandWireBelow q honline t0 d0 ht0 hdlo hdh hp
  have hdevlewire : devProg (t0, d0) <=
      Z78P12.BwireP (t0, d0) + (fun p => MrLift p.1 p.2) (t0, d0) :=
    le_trans hs.1 hs.2
  linarith [hw]

/--  B10.3  THE  B9  STRIP  FACE  BUNDLE  IS  JOINTLY  EMPTY  (in
    body):  the  three  strip  faces  of  the  Part  B9  endpoint
    -  G-hs1  (Qside  >=  devProg),  hs3  at  the  RIGHT  witness
    (the  machined  B7  shape),  G-hs3-left  (hs3  at  the  LEFT
    witness)  -  are  jointly  CONTRADICTORY  at  every  strip-
    band  off-pair  at  or  above  the  frontier.  G-hs3-left
    (and  its  right-flank  twin)  dissolve  as  INDEPENDENT
    faces:  they  are  components  of  the  strip-band  zero-
    exclusion  face  (B10.4),  which  the  squeeze  certificate
    (B10.1)  certifies  in  body.  Right  branch:  the  B7  wall
    in  body  (T4OffD:  wall  <=  Bwire).  Left  branch:  the
    face  IS  the  Bwire  +  Mr  bound,  direct.  -/
theorem t4l_stripFacesEmpty (q : ZeroSet)
    (honline : ∀ ρ ∈ q.Z, 0 < (|ρ.im| : ℝ) → (|ρ.im| : ℝ) <
      (707 : ℝ) / 50 → ρ.re = 1 / 2)
    (Qside : ℝ × ℝ → ℝ)
    (H : ℝ) (hH : 1000 ≤ H)
    (hs1StripH : ∀ (t0 d0 : ℝ), H <= t0 → (1 / 200 : ℝ) <= d0 →
      d0 <= 1 / 2 → offPair q t0 d0 → Qside (t0, d0) ≥ devProg (t0, d0))
    (hs3RightH : ∀ (t0 d0 : ℝ), H <= t0 → (1 / 200 : ℝ) <= d0 →
      d0 <= 1 / 2 → t4l_rightOffPair q t0 d0 →
      Qside (t0, d0) <=
        ‖p4_em_expr (t4o_sOff t0 d0) (S4Strip.n4 t0)‖ + t4m_MwireOff t0 d0)
    (hs3LeftH : ∀ (t0 d0 : ℝ), H <= t0 → (1 / 200 : ℝ) <= d0 →
      d0 <= 1 / 2 → t4l_leftOffPair q t0 d0 →
      Qside (t0, d0) <=
        Z78P12.BwireP (t0, d0) + (fun p => MrLift p.1 p.2) (t0, d0))
    (t0 d0 : ℝ) (ht0 : H <= t0) (hdlo : (1 / 200 : ℝ) <= d0)
    (hdh : d0 <= 1 / 2) (hp : offPair q t0 d0) :
    False := by
  have htt0 : 1000 ≤ t0 := le_trans hH ht0
  have hs1 : Qside (t0, d0) ≥ devProg (t0, d0) :=
    hs1StripH t0 d0 ht0 hdlo hdh hp
  obtain ⟨ρ, hz, hne, him, hd⟩ := hp
  have hp2 : offPair q t0 d0 := ⟨ρ, hz, hne, him, hd⟩
  have hd0n : 0 ≤ d0 := by linarith [hdlo]
  rcases (abs_eq hd0n).mp hd with (hdir | hdir)
  · --  RIGHT  FLANK:  the  B7  shape  +  the  wall  in  body.
    have hrw : ρ.re = 1 / 2 + d0 := by linarith [hdir]
    have hroff : t4l_rightOffPair q t0 d0 := ⟨ρ, ⟨hz, him, hd, hrw⟩⟩
    have hface : Qside (t0, d0) <=
        ‖p4_em_expr (t4o_sOff t0 d0) (S4Strip.n4 t0)‖ +
        t4m_MwireOff t0 d0 :=
      hs3RightH t0 d0 ht0 hdlo hdh hroff
    have hwall : ‖p4_em_expr (t4o_sOff t0 d0) (S4Strip.n4 t0)‖ <=
        p8_B t0 (S4Strip.n4 t0) :=
      t4wall_offline_le_bwires t0 d0 htt0 hdlo hdh
    have hstrip : Qside (t0, d0) <=
        p8_B t0 (S4Strip.n4 t0) + t4m_MwireOff t0 d0 :=
      le_trans hface (add_le_add hwall le_rfl)
    have hbw : Z78P12.BwireP (t0, d0) = p8_B t0 (S4Strip.n4 t0) := by
      dsimp only [Z78P12.BwireP, S4A.BwireR]
      rw [if_pos ⟨htt0, hdh⟩, if_pos hdlo]
    have hml : (fun p => MrLift p.1 p.2) (t0, d0) = t4m_MwireOff t0 d0 := by
      dsimp only [MrLift]
      rw [if_pos ⟨htt0, hdh, hdlo⟩]
    have hwire : Qside (t0, d0) <=
        Z78P12.BwireP (t0, d0) + (fun p => MrLift p.1 p.2) (t0, d0) := by
      simpa only [hbw, hml] using hstrip
    exact (t4l_bandEmpty q honline Qside t0 d0 htt0 hdlo hdh hp2)
      ⟨hs1, hwire⟩
  · --  LEFT  FLANK:  the  face  is  the  Bwire  +  Mr  bound.
    have hlr : ρ.re = 1 / 2 - d0 := by linarith [hdir]
    have hloff : t4l_leftOffPair q t0 d0 := ⟨ρ, ⟨hz, him, hd, hlr⟩⟩
    have hwire : Qside (t0, d0) <=
        Z78P12.BwireP (t0, d0) + (fun p => MrLift p.1 p.2) (t0, d0) :=
      hs3LeftH t0 d0 ht0 hdlo hdh hloff
    exact (t4l_bandEmpty q honline Qside t0 d0 htt0 hdlo hdh hp2)
      ⟨hs1, hwire⟩

/--  B10.4  THE  VACANT  STRIPFRONT  ENDPOINT:  the  Part  B9
    endpoint  with  the  strip  face  BUNDLE  replaced  by  ONE
    band-zero-exclusion  face  (hNoStrip).  The  S4  strip  case
    no  longer  needs  t4m_margin  (the  exclusion  is  stronger
    than  the  wire  margin).  The  residual  in  the  unverified
    region  is  now  exactly  TWO  zero-exclusion  faces  (band,
    window)  plus  [Z78]  plus  the  below-frontier  record.
    No  RH  claim.  -/
theorem rh_program78_stripfront_mach_vacant (q : ZeroSet)
    (hz78 : Z78.externalZeroFree78)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0)
    (honline : ∀ ρ ∈ q.Z, 0 < (|ρ.im| : ℝ) → (|ρ.im| : ℝ) <
      (707 : ℝ) / 50 → ρ.re = 1 / 2)
    (Qside : ℝ × ℝ → ℝ)
    (H : ℝ) (hH : 1000 ≤ H)
    (hPT : WinC.allOnLineUpTo q H)
    (hNoStrip : ∀ (t0 d0 : ℝ), H ≤ t0 → (1 / 200 : ℝ) ≤ d0 →
      d0 ≤ 1 / 2 → ¬ offPair q t0 d0)
    (hWinH : WinC.hWinFaceResidualH q H) :
    RH q := by
  refine S4A.rh_from_regime_closures q Qside Z78P12.MfP devProg
    Z78P12.BwireP (fun p => MrLift p.1 p.2) floProg
    ?_ ?_ ?_ ?_ ?_ ?_
  · --  S1  witness  leg:  below  H  =  vacuous;  band  =
      --  excluded;  window  above  =  window  face;  far  =
      --  [Z78].
    intro t0 d0 ht0 hd0 hp
    by_cases hfar : d0 ≤ (1 / 2 : ℝ)
    · by_cases hle : t0 ≤ H
      · exact False.elim ((WinC.noOffLineBelowPT q H hPT t0
          (le_of_lt ht0) hle) d0 hp)
      · by_cases hdw : (1 / 200 : ℝ) ≤ d0
        · exact False.elim (hNoStrip t0 d0
            (le_of_lt (not_le.mp hle)) hdw hfar hp)
        · exact False.elim ((hWinH t0 d0
            (le_trans hH (le_of_lt (not_le.mp hle)))
            (not_le.mp hle) hd0 (not_le.mp hdw)) hp)
    · exact False.elim (Z78P12.offPairFarEmpty q hz78 hqz t0 d0
        (not_le.mp hfar) hp)
  · --  S2  leg:  covered  =  in  body;  low  band  =  vacuous
      --  below  H;  far  =  [Z78].
    intro t0 d0 ht0 hd0 hp
    by_cases hd0h : d0 ≤ (1 / 2 : ℝ)
    · by_cases ht0k : 1000 ≤ t0
      · exact hs2_covered q honline t0 d0 ht0 ht0k hd0 hd0h hp
      · have hle : t0 ≤ H := le_trans (le_of_lt (not_le.mp ht0k)) hH
        exact False.elim ((WinC.noOffLineBelowPT q H hPT t0
          (le_of_lt ht0) hle) d0 hp)
    · exact False.elim (Z78P12.offPairFarEmpty q hz78 hqz t0 d0
        (not_le.mp hd0h) hp)
  · --  S3  leg:  below  H  =  vacuous;  band  =  excluded;
      --  window  above  =  window  face;  far  =  [Z78].
    intro t0 d0 ht0 hd0 hp
    by_cases hfar : d0 ≤ (1 / 2 : ℝ)
    · by_cases hle : t0 ≤ H
      · exact False.elim ((WinC.noOffLineBelowPT q H hPT t0
          (le_of_lt ht0) hle) d0 hp)
      · by_cases hdw : (1 / 200 : ℝ) ≤ d0
        · exact False.elim (hNoStrip t0 d0
            (le_of_lt (not_le.mp hle)) hdw hfar hp)
        · exact False.elim ((hWinH t0 d0
            (le_trans hH (le_of_lt (not_le.mp hle)))
            (not_le.mp hle) hd0 (not_le.mp hdw)) hp)
    · exact False.elim (Z78P12.offPairFarEmpty q hz78 hqz t0 d0
        (not_le.mp hfar) hp)
  · --  S4  covered:  band  =  excluded  (stronger  than  the
      --  t4m_margin  wire  margin);  window  band  =  the  face
      --  shape  via  faceSplitH  (on-line  wire  there:
      --  MrLift  =  MrR).
    intro t0 d0 ht0 hd0 hd0u hp
    by_cases hdw : (1 / 200 : ℝ) ≤ d0
    · by_cases hle : t0 ≤ H
      · exact False.elim ((WinC.noOffLineBelowPT q H hPT t0
          (by linarith [ht0]) hle) d0 hp)
      · exact False.elim (hNoStrip t0 d0
          (le_of_lt (not_le.mp hle)) hdw hd0u hp)
    · have hna : ¬ (1000 ≤ t0 ∧ d0 ≤ 1 / 2 ∧ (1 / 200 : ℝ) ≤ d0) :=
        fun h' => by linarith [hdw, h'.2.2]
      have hml : MrLift t0 d0 = S4A.MrR t0 d0 := by
        dsimp only [MrLift]
        rw [if_neg hna]
      have hif : floProg (t0, d0) = S1LowT.floStripMin t0 d0 := by
        dsimp only [floProg]
        rw [if_pos ⟨ht0, hd0u⟩]
      have hwinshp : Z78P12.BwireP (t0, d0) + Z78P12.MrP (t0, d0) +
          Z78P12.MfP (t0, d0) < S1LowT.floStripMin t0 d0 :=
        ((WinC.faceSplitH q H hPT).mpr hWinH) t0 d0 ht0 hd0
          (not_le.mp hdw) hp
      simpa only [hif, hml, Z78P12.MrP] using hwinshp
  · --  S4  low  band:  its  whole  domain  (0,  1000)  sits  below
      --  the  frontier:  vacuous.
    intro t0 d0 ht0 ht0u hd0 hd0u hp
    have hle : t0 ≤ H := le_trans (le_of_lt ht0u) hH
    exact False.elim ((WinC.noOffLineBelowPT q H hPT t0
      (le_of_lt ht0) hle) d0 hp)
  · --  S4  far  region:  [Z78].
    intro t0 d0 ht0 hd0 hd0f hp
    exact False.elim (Z78P12.offPairFarEmpty q hz78 hqz t0 d0 hd0f hp)

/--  B10.4  THE  VACANT  ENDPOINT  AT  THE  PLATT-TRUDGIAN
    FRONTIER  (the  [Z-PT2]  instantiation):  the  entire  named
    residue  lives  STRICTLY  ABOVE  3,000,175,332,800,  as
    exactly  two  zero-exclusion  faces  (band,  window)  plus
    [Z78].  No  RH  claim.  -/
theorem rh_program78_stripfront_mach_vacant_PT2 (q : ZeroSet)
    (hz78 : Z78.externalZeroFree78)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0)
    (honline : ∀ ρ ∈ q.Z, 0 < (|ρ.im| : ℝ) → (|ρ.im| : ℝ) <
      (707 : ℝ) / 50 → ρ.re = 1 / 2)
    (Qside : ℝ × ℝ → ℝ)
    (hPT2 : WinC.allOnLineUpTo q WinC.tPT2)
    (hNoStripPT2 : ∀ (t0 d0 : ℝ), WinC.tPT2 ≤ t0 →
      (1 / 200 : ℝ) ≤ d0 → d0 ≤ 1 / 2 → ¬ offPair q t0 d0)
    (hWinPT2 : WinC.hWinFaceResidualH q WinC.tPT2) :
    RH q :=
  rh_program78_stripfront_mach_vacant q hz78 hqz honline Qside
    WinC.tPT2 (by norm_num [WinC.tPT2]) hPT2 hNoStripPT2 hWinPT2

/--  B10.5  THE  B9  ENDPOINT  IMPLIES  THE  VACANT  ENDPOINT
    (in  body):  the  strip  face  BUNDLE  of  the  Part  B9
    endpoint  implies  the  band  zero-exclusion  face  -
    B10.3  at  every  strip-band  off-pair.  For  the  endpoint
    the  three-face  bundle  (G-hs1,  hs3  right,  G-hs3-left)
    is  EQUIVALENT  to  the  single  zero-exclusion  face  it
    encodes:  no  analytic  content  is  lost  in  the  collapse.
    No  RH  claim.  -/
theorem rh_program78_stripfront_mach_vacant_ofB9 (q : ZeroSet)
    (hz78 : Z78.externalZeroFree78)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0)
    (honline : ∀ ρ ∈ q.Z, 0 < (|ρ.im| : ℝ) → (|ρ.im| : ℝ) <
      (707 : ℝ) / 50 → ρ.re = 1 / 2)
    (Qside : ℝ × ℝ → ℝ)
    (H : ℝ) (hH : 1000 ≤ H)
    (hPT : WinC.allOnLineUpTo q H)
    (hs1StripH : ∀ (t0 d0 : ℝ), H <= t0 → (1 / 200 : ℝ) <= d0 →
      d0 <= 1 / 2 → offPair q t0 d0 → Qside (t0, d0) ≥ devProg (t0, d0))
    (hs3RightH : ∀ (t0 d0 : ℝ), H <= t0 → (1 / 200 : ℝ) <= d0 →
      d0 <= 1 / 2 → t4l_rightOffPair q t0 d0 →
      Qside (t0, d0) <=
        ‖p4_em_expr (t4o_sOff t0 d0) (S4Strip.n4 t0)‖ + t4m_MwireOff t0 d0)
    (hs3LeftH : ∀ (t0 d0 : ℝ), H <= t0 → (1 / 200 : ℝ) <= d0 →
      d0 <= 1 / 2 → t4l_leftOffPair q t0 d0 →
      Qside (t0, d0) <=
        Z78P12.BwireP (t0, d0) + (fun p => MrLift p.1 p.2) (t0, d0))
    (hWinH : WinC.hWinFaceResidualH q H) :
    RH q := by
  refine rh_program78_stripfront_mach_vacant q hz78 hqz honline
    Qside H hH hPT ?_ hWinH
  intro t0 d0 ht0 hdlo hdh hp
  exact t4l_stripFacesEmpty q honline Qside H hH hs1StripH
    hs3RightH hs3LeftH t0 d0 ht0 hdlo hdh hp

/--  B10.5  THE  B9  ENDPOINT  AT  tPT2  IMPLIES  THE  VACANT
    ENDPOINT  AT  tPT2  (the  [Z-PT2]  instantiation  of  the
    collapse  above).  No  RH  claim.  -/
theorem rh_program78_stripfront_mach_vacant_PT2_ofB9 (q : ZeroSet)
    (hz78 : Z78.externalZeroFree78)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0)
    (honline : ∀ ρ ∈ q.Z, 0 < (|ρ.im| : ℝ) → (|ρ.im| : ℝ) <
      (707 : ℝ) / 50 → ρ.re = 1 / 2)
    (Qside : ℝ × ℝ → ℝ)
    (hPT2 : WinC.allOnLineUpTo q WinC.tPT2)
    (hs1StripPT2 : ∀ (t0 d0 : ℝ), WinC.tPT2 <= t0 → (1 / 200 : ℝ) <= d0 →
      d0 <= 1 / 2 → offPair q t0 d0 → Qside (t0, d0) ≥ devProg (t0, d0))
    (hs3RightPT2 : ∀ (t0 d0 : ℝ), WinC.tPT2 <= t0 → (1 / 200 : ℝ) <= d0 →
      d0 <= 1/2 → t4l_rightOffPair q t0 d0 →
      Qside (t0, d0) <=
        ‖p4_em_expr (t4o_sOff t0 d0) (S4Strip.n4 t0)‖ +
        t4m_MwireOff t0 d0)
    (hs3LeftPT2 : ∀ (t0 d0 : ℝ), WinC.tPT2 <= t0 → (1 / 200 : ℝ) <= d0 →
      d0 <= 1/2 → t4l_leftOffPair q t0 d0 →
      Qside (t0, d0) <=
        Z78P12.BwireP (t0, d0) + (fun p => MrLift p.1 p.2) (t0, d0))
    (hWinPT2 : WinC.hWinFaceResidualH q WinC.tPT2) :
    RH q :=
  rh_program78_stripfront_mach_vacant_ofB9 q hz78 hqz honline Qside
    WinC.tPT2 (by norm_num [WinC.tPT2]) hPT2
    hs1StripPT2 hs3RightPT2 hs3LeftPT2 hWinPT2


/-  ##  Part  B11  -  THE  UNIFIED  OFF-LINE  EXCLUSION  FACE:
    THE  ENDPOINT  RESIDUAL  ABOVE  THE  FRONTIER  IS  ONE  FACE
    (discovery  0126  close-out)

  Part  B10  left  the  unverified-region  residual  as  TWO
  zero-exclusion  faces:  the  band  face  hNoStrip  (no  off-
  pair  on  [H,  inf)  x  [1/200,  1/2])  and  the  window
  face  hWinH  (no  off-pair  on  [H,  inf)  x  (0,  1/200)).
  They  have  the  IDENTICAL  form  -  zero-exclusion  above
  the  frontier,  the  1/200  boundary  being  a  proof  artifact
  (the  squeeze  cycle's  band/window  split),  not  a  face
  boundary  -  and  the  far  region  d0  >  1/2  is  closed  in
  body  from  [Z78]  (Z78P12.offPairFarEmpty).  Part  B11
  unifies  the  two  into  ONE  face:

      hOffLineEmptyH  q  H  :
        forall  (t0  d0),  H  <=  t0  ->  0  <  d0  ->
          d0  <=  1/2  ->  not  offPair  q  t0  d0

  and  states  the  endpoint  with  that  single  face  plus
  the  record  below  the  frontier  plus  [Z78].  The  named
  residue  above  the  frontier  is  now  EXACTLY:  no  off-line
  zero  above  the  frontier  in  the  strip  0  <  d0  <=  1/2
  (the  remainder  of  the  off-line  region,  d0  >  1/2,  is
  excluded  in  body  from  [Z78])  -  one  record-footing
  exclusion  statement,  with  the  far  region  already  in
  the  tree.

  B11.1/B11.2:  the  unified  endpoint  rh_program78_
  stripfront_mach_unified  (+  _PT2  at  the  Platt-Trudgian
  frontier).  B11.3/B11.4:  the  B10  endpoint  (band  face  +
  window  face)  implies  the  unified  endpoint  in  body  -
  the  unification  loses  nothing.  No  RH  claim:  the  face
  is  a  zero-exclusion  statement  in  the  unverified  region,
  on  record  footing  with  the  window  face  and  the  [Z-PT2]
  record,  as  before.  -/

/--  B11.1  THE  UNIFIED  OFF-LINE  EXCLUSION  ENDPOINT:  the
    Part  B10  endpoint  with  the  band  face  and  the  window
    face  MERGED  into  the  single  face  hOff  (no  off-pair
    above  the  frontier  in  the  strip  0  <  d0  <=  1/2).
    The  1/200  boundary  no  longer  appears.  Residual  above
    the  frontier:  exactly  hOff  plus  [Z78]  (the  far
    region  d0  >  1/2  is  closed  in  body  from  [Z78]).
    No  RH  claim.  -/
theorem rh_program78_stripfront_mach_unified (q : ZeroSet)
    (hz78 : Z78.externalZeroFree78)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0)
    (honline : ∀ ρ ∈ q.Z, 0 < (|ρ.im| : ℝ) → (|ρ.im| : ℝ) <
      (707 : ℝ) / 50 → ρ.re = 1 / 2)
    (Qside : ℝ × ℝ → ℝ)
    (H : ℝ) (hH : 1000 ≤ H)
    (hPT : WinC.allOnLineUpTo q H)
    (hOff : ∀ (t0 d0 : ℝ), H ≤ t0 → 0 < d0 → d0 ≤ 1 / 2 →
      ¬ offPair q t0 d0) :
    RH q := by
  refine S4A.rh_from_regime_closures q Qside Z78P12.MfP devProg
    Z78P12.BwireP (fun p => MrLift p.1 p.2) floProg
    ?_ ?_ ?_ ?_ ?_ ?_
  · --  S1  witness  leg:  below  H  =  vacuous  (the  record);
      --  above  H  =  the  unified  face;  far  =  [Z78].
    intro t0 d0 ht0 hd0 hp
    by_cases hfar : d0 ≤ (1 / 2 : ℝ)
    · by_cases hle : t0 ≤ H
      · exact False.elim ((WinC.noOffLineBelowPT q H hPT t0
          (le_of_lt ht0) hle) d0 hp)
      · exact False.elim ((hOff t0 d0
          (le_of_lt (not_le.mp hle)) hd0 hfar) hp)
    · exact False.elim (Z78P12.offPairFarEmpty q hz78 hqz t0 d0
        (not_le.mp hfar) hp)
  · --  S2  leg:  covered  =  in  body;  low  band  =  vacuous
      --  below  H;  far  =  [Z78].
    intro t0 d0 ht0 hd0 hp
    by_cases hd0h : d0 ≤ (1 / 2 : ℝ)
    · by_cases ht0k : 1000 ≤ t0
      · exact hs2_covered q honline t0 d0 ht0 ht0k hd0 hd0h hp
      · have hle : t0 ≤ H := le_trans (le_of_lt (not_le.mp ht0k)) hH
        exact False.elim ((WinC.noOffLineBelowPT q H hPT t0
          (le_of_lt ht0) hle) d0 hp)
    · exact False.elim (Z78P12.offPairFarEmpty q hz78 hqz t0 d0
        (not_le.mp hd0h) hp)
  · --  S3  leg:  below  H  =  vacuous  (the  record);  above
      --  H  =  the  unified  face;  far  =  [Z78].
    intro t0 d0 ht0 hd0 hp
    by_cases hfar : d0 ≤ (1 / 2 : ℝ)
    · by_cases hle : t0 ≤ H
      · exact False.elim ((WinC.noOffLineBelowPT q H hPT t0
          (le_of_lt ht0) hle) d0 hp)
      · exact False.elim ((hOff t0 d0
          (le_of_lt (not_le.mp hle)) hd0 hfar) hp)
    · exact False.elim (Z78P12.offPairFarEmpty q hz78 hqz t0 d0
        (not_le.mp hfar) hp)
  · --  S4  covered:  below  H  =  vacuous  (the  record);
      --  above  H  =  the  unified  face.  (No  t4m_margin,
      --  no  face  shape,  no  1/200  boundary:  the
      --  exclusion  is  stronger  than  the  wire  margin.)
    intro t0 d0 ht0 hd0 hd0u hp
    by_cases hle : t0 ≤ H
    · exact False.elim ((WinC.noOffLineBelowPT q H hPT t0
        (by linarith [ht0]) hle) d0 hp)
    · exact False.elim ((hOff t0 d0
        (le_of_lt (not_le.mp hle)) hd0 hd0u) hp)
  · --  S4  low  band:  its  whole  domain  (0,  1000)  sits
      --  below  the  frontier:  vacuous.
    intro t0 d0 ht0 ht0u hd0 hd0u hp
    have hle : t0 ≤ H := le_trans (le_of_lt ht0u) hH
    exact False.elim ((WinC.noOffLineBelowPT q H hPT t0
      (le_of_lt ht0) hle) d0 hp)
  · --  S4  far  region:  [Z78].
    intro t0 d0 ht0 hd0 hd0f hp
    exact False.elim (Z78P12.offPairFarEmpty q hz78 hqz t0 d0 hd0f hp)

/--  B11.1  THE  UNIFIED  ENDPOINT  AT  THE  PLATT-TRUDGIAN
    FRONTIER  (the  [Z-PT2]  instantiation):  the  entire  named
    residue  lives  STRICTLY  ABOVE  3,000,175,332,800,  as
    ONE  zero-exclusion  face  (no  off-pair  in  the  strip
    0  <  d0  <=  1/2  above  the  frontier)  plus  [Z78].
    No  RH  claim.  -/
theorem rh_program78_stripfront_mach_unified_PT2 (q : ZeroSet)
    (hz78 : Z78.externalZeroFree78)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0)
    (honline : ∀ ρ ∈ q.Z, 0 < (|ρ.im| : ℝ) → (|ρ.im| : ℝ) <
      (707 : ℝ) / 50 → ρ.re = 1 / 2)
    (Qside : ℝ × ℝ → ℝ)
    (hPT2 : WinC.allOnLineUpTo q WinC.tPT2)
    (hOffPT2 : ∀ (t0 d0 : ℝ), WinC.tPT2 ≤ t0 → 0 < d0 →
      d0 ≤ 1 / 2 → ¬ offPair q t0 d0) :
    RH q :=
  rh_program78_stripfront_mach_unified q hz78 hqz honline Qside
    WinC.tPT2 (by norm_num [WinC.tPT2]) hPT2 hOffPT2

/--  B11.3  THE  B10  ENDPOINT  IMPLIES  THE  UNIFIED  ENDPOINT
    (in  body):  the  band  face  (1/200  <=  d0)  and  the
    window  face  (d0  <  1/200)  jointly  yield  the  unified
    face  -  the  record  handles  the  boundary  t0  =  H.  The
    unification  loses  nothing;  the  1/200  boundary  was  a
    proof  artifact.  No  RH  claim.  -/
theorem rh_program78_stripfront_mach_unified_ofB10 (q : ZeroSet)
    (hz78 : Z78.externalZeroFree78)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0)
    (honline : ∀ ρ ∈ q.Z, 0 < (|ρ.im| : ℝ) → (|ρ.im| : ℝ) <
      (707 : ℝ) / 50 → ρ.re = 1 / 2)
    (Qside : ℝ × ℝ → ℝ)
    (H : ℝ) (hH : 1000 ≤ H)
    (hPT : WinC.allOnLineUpTo q H)
    (hNoStrip : ∀ (t0 d0 : ℝ), H ≤ t0 → (1 / 200 : ℝ) ≤ d0 →
      d0 ≤ 1 / 2 → ¬ offPair q t0 d0)
    (hWinH : WinC.hWinFaceResidualH q H) :
    RH q := by
  refine rh_program78_stripfront_mach_unified q hz78 hqz honline
    Qside H hH hPT ?_
  intro t0 d0 ht0 hd0 hd0u hp
  by_cases hle : t0 ≤ H
  · exact False.elim ((WinC.noOffLineBelowPT q H hPT t0
      (by linarith [ht0]) hle) d0 hp)
  · by_cases hdw : (1 / 200 : ℝ) ≤ d0
    · exact False.elim ((hNoStrip t0 d0
        (le_of_lt (not_le.mp hle)) hdw hd0u) hp)
    · exact False.elim ((hWinH t0 d0
        (le_trans hH (le_of_lt (not_le.mp hle)))
        (not_le.mp hle) hd0 (not_le.mp hdw)) hp)

/--  B11.4  THE  B10  ENDPOINT  AT  tPT2  IMPLIES  THE  UNIFIED
    ENDPOINT  AT  tPT2  (the  [Z-PT2]  instantiation  of  the
    unification  above).  No  RH  claim.  -/
theorem rh_program78_stripfront_mach_unified_PT2_ofB10 (q : ZeroSet)
    (hz78 : Z78.externalZeroFree78)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0)
    (honline : ∀ ρ ∈ q.Z, 0 < (|ρ.im| : ℝ) → (|ρ.im| : ℝ) <
      (707 : ℝ) / 50 → ρ.re = 1 / 2)
    (Qside : ℝ × ℝ → ℝ)
    (hPT2 : WinC.allOnLineUpTo q WinC.tPT2)
    (hNoStripPT2 : ∀ (t0 d0 : ℝ), WinC.tPT2 ≤ t0 →
      (1 / 200 : ℝ) ≤ d0 → d0 ≤ 1 / 2 → ¬ offPair q t0 d0)
    (hWinPT2 : WinC.hWinFaceResidualH q WinC.tPT2) :
    RH q :=
  rh_program78_stripfront_mach_unified_ofB10 q hz78 hqz honline
    Qside WinC.tPT2 (by norm_num [WinC.tPT2]) hPT2
    hNoStripPT2 hWinPT2


/-!  PART B12  (discovery  0129).

   B11  left  the  open  face  hOff  on  (t0,  d0)  with  H  <=  t0,
   0  <  d0  <=  1/2.  But  [Z78]  ITSELF  excludes  the  outer  slice:
   for  an  actual-set  zero  set,  every  off-pair  satisfies
   d0  <=  3/8  (Z78.offPairD0le  -  zero-free  at  Re  >  7/8  plus
   the  functional  equation  put  zeros  in  the  strip  [1/8,  7/8],
   sharp).  So  the  slice  (3/8,  1/2]  is  closed  IN  BODY  FROM
   [Z78],  and  the  endpoint's  open  face  shrinks  to  0  <  d0
   <=  3/8  -  EXACTLY  the  region  where  the  external  inputs  are
   silent  (zeros  may  live  in  the  strip  interior).  No  RH
   claim:  the  face  is  a  zero-exclusion  statement  in  the
   unverified  region,  now  as  narrow  as  [Z78]  can  make  it.  -/

/--  B12.1  THE  OUTER  SLICE  IS  CLOSED  IN  BODY  FROM  [Z78]:
    for  an  actual-set  zero  set,  no  off-pair  with  3/8  <  d0
    (of  any  height  t0  >  0):  offPairD0le  already  bounds  every
    off-pair  to  d0  <=  3/8.  The  slice  (3/8,  1/2]  of  the  B11
    face  -  including  the  d0  =  1/2  edge  -  needs  no  face  at
    all.  No  RH  claim.  -/
theorem rhend_slice38Excl (q : ZeroSet)
    (hz78 : Z78.externalZeroFree78)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0)
    (t0 d0 : ℝ) (ht0 : 0 < t0) (hd0 : 0 < d0) (h38 : 3 / 8 < d0) :
    ¬ offPair q t0 d0 := by
  intro hp
  have hle := Z78.offPairD0le q hz78 hqz t0 d0 ht0 hd0 hp
  linarith

/--  B12.2  THE  3/8-UNIFIED  ENDPOINT:  the  B11  endpoint  with
    the  face  shrunk  to  0  <  d0  <=  3/8  (the  [Z78]-SHARP
    strip  interior).  Above  H,  any  off-pair  has  d0  <=  3/8  BY
    [Z78]  (offPairD0le)  before  the  face  is  applied  -  the  d0
    <=  1/2  split  of  B11  disappears  entirely  in  the  S1/S3
    legs  and  in  the  S4-covered  leg.  No  RH  claim.  -/
theorem rh_program78_stripfront_mach_unified38 (q : ZeroSet)
    (hz78 : Z78.externalZeroFree78)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0)
    (honline : ∀ ρ ∈ q.Z, 0 < (|ρ.im| : ℝ) → (|ρ.im| : ℝ) <
      (707 : ℝ) / 50 → ρ.re = 1 / 2)
    (Qside : ℝ × ℝ → ℝ)
    (H : ℝ) (hH : 1000 ≤ H)
    (hPT : WinC.allOnLineUpTo q H)
    (hOff38 : ∀ (t0 d0 : ℝ), H ≤ t0 → 0 < d0 → d0 ≤ 3 / 8 →
      ¬ offPair q t0 d0) :
    RH q := by
  refine S4A.rh_from_regime_closures q Qside Z78P12.MfP devProg
    Z78P12.BwireP (fun p => MrLift p.1 p.2) floProg
    ?_ ?_ ?_ ?_ ?_ ?_
  · --  S1  witness  leg:  below  H  =  vacuous  (the  record);
      --  above  H:  [Z78]  bounds  d0  to  3/8,  the  face  kills.
    intro t0 d0 ht0 hd0 hp
    by_cases hle : t0 ≤ H
    · exact False.elim ((WinC.noOffLineBelowPT q H hPT t0
        (le_of_lt ht0) hle) d0 hp)
    · have h38 : d0 ≤ 3 / 8 := Z78.offPairD0le q hz78 hqz t0 d0
        ht0 hd0 hp
      exact False.elim ((hOff38 t0 d0
        (le_of_lt (not_le.mp hle)) hd0 h38) hp)
  · --  S2  leg:  covered  =  in  body;  low  band  =  vacuous
      --  below  H;  far  =  [Z78].
    intro t0 d0 ht0 hd0 hp
    by_cases hd0h : d0 ≤ (1 / 2 : ℝ)
    · by_cases ht0k : 1000 ≤ t0
      · exact hs2_covered q honline t0 d0 ht0 ht0k hd0 hd0h hp
      · have hle : t0 ≤ H := le_trans (le_of_lt (not_le.mp ht0k)) hH
        exact False.elim ((WinC.noOffLineBelowPT q H hPT t0
          (le_of_lt ht0) hle) d0 hp)
    · exact False.elim (Z78P12.offPairFarEmpty q hz78 hqz t0 d0
        (not_le.mp hd0h) hp)
  · --  S3  leg:  below  H  =  vacuous  (the  record);  above  H:
      --  [Z78]  bounds  d0  to  3/8,  the  face  kills.
    intro t0 d0 ht0 hd0 hp
    by_cases hle : t0 ≤ H
    · exact False.elim ((WinC.noOffLineBelowPT q H hPT t0
        (le_of_lt ht0) hle) d0 hp)
    · have h38 : d0 ≤ 3 / 8 := Z78.offPairD0le q hz78 hqz t0 d0
        ht0 hd0 hp
      exact False.elim ((hOff38 t0 d0
        (le_of_lt (not_le.mp hle)) hd0 h38) hp)
  · --  S4  covered:  below  H  =  vacuous  (the  record);
      --  above  H:  [Z78]  bounds  d0  to  3/8,  the  face  kills.
    intro t0 d0 ht0 hd0 hd0u hp
    by_cases hle : t0 ≤ H
    · exact False.elim ((WinC.noOffLineBelowPT q H hPT t0
        (by linarith [ht0]) hle) d0 hp)
    · have h38 : d0 ≤ 3 / 8 := Z78.offPairD0le q hz78 hqz t0 d0
        (show 0 < t0 from by linarith [ht0]) hd0 hp
      exact False.elim ((hOff38 t0 d0
        (le_of_lt (not_le.mp hle)) hd0 h38) hp)
  · --  S4  low  band:  its  whole  domain  (0,  1000)  sits
      --  below  the  frontier:  vacuous.
    intro t0 d0 ht0 ht0u hd0 hd0u hp
    have hle : t0 ≤ H := le_trans (le_of_lt ht0u) hH
    exact False.elim ((WinC.noOffLineBelowPT q H hPT t0
      (le_of_lt ht0) hle) d0 hp)
  · --  S4  far  region:  [Z78].
    intro t0 d0 ht0 hd0 hd0f hp
    exact False.elim (Z78P12.offPairFarEmpty q hz78 hqz t0 d0 hd0f hp)

/--  B12.2  THE  3/8-UNIFIED  ENDPOINT  AT  THE  PLATT-TRUDGIAN
    FRONTIER  (the  [Z-PT2]  instantiation):  the  entire  named
    residue  lives  STRICTLY  ABOVE  3,000,175,332,800,  as  ONE
    zero-exclusion  face  (no  off-pair  in  0  <  d0  <=  3/8
    above  the  frontier  -  the  [Z78]-sharp  strip  interior)
    plus  [Z78]  itself  (which  closes  (3/8,  inf)  in  body).
    No  RH  claim.  -/
theorem rh_program78_stripfront_mach_unified38_PT2 (q : ZeroSet)
    (hz78 : Z78.externalZeroFree78)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0)
    (honline : ∀ ρ ∈ q.Z, 0 < (|ρ.im| : ℝ) → (|ρ.im| : ℝ) <
      (707 : ℝ) / 50 → ρ.re = 1 / 2)
    (Qside : ℝ × ℝ → ℝ)
    (hPT2 : WinC.allOnLineUpTo q WinC.tPT2)
    (hOff38PT2 : ∀ (t0 d0 : ℝ), WinC.tPT2 ≤ t0 → 0 < d0 →
      d0 ≤ 3 / 8 → ¬ offPair q t0 d0) :
    RH q :=
  rh_program78_stripfront_mach_unified38 q hz78 hqz honline Qside
    WinC.tPT2 (by norm_num [WinC.tPT2]) hPT2 hOff38PT2

/--  B12.3  THE  B11  FORM  IMPLIES  THE  3/8  FORM  (in  body):
    the  1/2-face  restricts  to  the  3/8-face  (3/8  <  1/2).
    No  RH  claim.  -/
theorem rh_program78_stripfront_mach_unified38_ofB11 (q : ZeroSet)
    (hz78 : Z78.externalZeroFree78)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0)
    (honline : ∀ ρ ∈ q.Z, 0 < (|ρ.im| : ℝ) → (|ρ.im| : ℝ) <
      (707 : ℝ) / 50 → ρ.re = 1 / 2)
    (Qside : ℝ × ℝ → ℝ)
    (H : ℝ) (hH : 1000 ≤ H)
    (hPT : WinC.allOnLineUpTo q H)
    (hOff : ∀ (t0 d0 : ℝ), H ≤ t0 → 0 < d0 → d0 ≤ 1 / 2 →
      ¬ offPair q t0 d0) :
    RH q := by
  refine rh_program78_stripfront_mach_unified38 q hz78 hqz honline
    Qside H hH hPT ?_
  intro t0 d0 ht0 hd0 hd038 hp
  exact False.elim ((hOff t0 d0 ht0 hd0 (by linarith)) hp)

/--  B12.4  THE  3/8  FORM  IMPLIES  THE  B11  FORM  (in  body,
    FROM  [Z78]):  the  slice  (3/8,  1/2]  of  the  B11  face  is
    closed  in  body  by  offPairD0le  -  so  the  two  forms  are
    EQUIVALENT  in  body  (each  implies  the  other),  and  the
    3/8-form  is  the  NATURAL  one:  its  face  is  exactly  what
    the  external  inputs  cannot  already  close.  No  RH  claim.  -/
theorem rh_program78_stripfront_mach_unified_ofB12 (q : ZeroSet)
    (hz78 : Z78.externalZeroFree78)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0)
    (honline : ∀ ρ ∈ q.Z, 0 < (|ρ.im| : ℝ) → (|ρ.im| : ℝ) <
      (707 : ℝ) / 50 → ρ.re = 1 / 2)
    (Qside : ℝ × ℝ → ℝ)
    (H : ℝ) (hH : 1000 ≤ H)
    (hPT : WinC.allOnLineUpTo q H)
    (hOff38 : ∀ (t0 d0 : ℝ), H ≤ t0 → 0 < d0 → d0 ≤ 3 / 8 →
      ¬ offPair q t0 d0) :
    RH q := by
  refine rh_program78_stripfront_mach_unified q hz78 hqz honline
    Qside H hH hPT ?_
  intro t0 d0 ht0 hd0 hd0u hp
  by_cases hle : t0 ≤ H
  · exact False.elim ((WinC.noOffLineBelowPT q H hPT t0
      (by linarith [ht0]) hle) d0 hp)
  · have h38 : d0 ≤ 3 / 8 := Z78.offPairD0le q hz78 hqz t0 d0
      (show 0 < t0 from by linarith [ht0, hH]) hd0 hp
    exact False.elim ((hOff38 t0 d0
      (le_of_lt (not_le.mp hle)) hd0 h38) hp)

/--  B12.5  THE  [Z-PT2]  INSTANCES  OF  THE  EQUIVALENCE
    (3/8-form  at  tPT2  ->  1/2-form  at  tPT2).  No  RH  claim.  -/
theorem rh_program78_stripfront_mach_unified_PT2_ofB12 (q : ZeroSet)
    (hz78 : Z78.externalZeroFree78)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0)
    (honline : ∀ ρ ∈ q.Z, 0 < (|ρ.im| : ℝ) → (|ρ.im| : ℝ) <
      (707 : ℝ) / 50 → ρ.re = 1 / 2)
    (Qside : ℝ × ℝ → ℝ)
    (hPT2 : WinC.allOnLineUpTo q WinC.tPT2)
    (hOff38PT2 : ∀ (t0 d0 : ℝ), WinC.tPT2 ≤ t0 → 0 < d0 →
      d0 ≤ 3 / 8 → ¬ offPair q t0 d0) :
    RH q :=
  rh_program78_stripfront_mach_unified_ofB12 q hz78 hqz honline
    Qside WinC.tPT2 (by norm_num [WinC.tPT2]) hPT2 hOff38PT2

theorem rh_program78_stripfront_mach_unified38_PT2_ofB11 (q : ZeroSet)
    (hz78 : Z78.externalZeroFree78)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0)
    (honline : ∀ ρ ∈ q.Z, 0 < (|ρ.im| : ℝ) → (|ρ.im| : ℝ) <
      (707 : ℝ) / 50 → ρ.re = 1 / 2)
    (Qside : ℝ × ℝ → ℝ)
    (hPT2 : WinC.allOnLineUpTo q WinC.tPT2)
    (hOffPT2 : ∀ (t0 d0 : ℝ), WinC.tPT2 ≤ t0 → 0 < d0 →
      d0 ≤ 1 / 2 → ¬ offPair q t0 d0) :
    RH q :=
  rh_program78_stripfront_mach_unified38_ofB11 q hz78 hqz honline
    Qside WinC.tPT2 (by norm_num [WinC.tPT2]) hPT2 hOffPT2

/-!  PART  B13  (discovery  0131).

   0129  left  the  open  face  hOff38  on  H  <=  t0,  0  <  d0
   <=  3/8  --  the  [Z78]-sharp  strip  interior.  [Z78L]
   (Liu,  "Slightly  improved  zero-free  half-planes  for  the
   quasi-Riemann  hypothesis",  arXiv  2610.12234;  the  human
   Lean  formalization  with  a  recorded  strict  replay  PASS,
   312  audited  declarations,  axioms  exactly  propext  /
   Classical.choice  /  Quot.sound  --  see  the  Z78Liu  module
   header)  is  a  STRICT  STRENGTHENING  of  [Z78]  at  the
   certified  boundary  liuBUpper
   =  874957019420098947/10^18  <  7/8  (extLiu_implies_ext78):
   zeros  of  an  actual  set  sit  in  [1  -  liuBUpper,
   liuBUpper],  so  every  off-pair  satisfies  d0  <=
   liuD0max  =  liuBUpper  -  1/2  =
   374957019420098947/10^18  <  3/8  (offPairD0leLiu,  sharp).
   The  open  face  shrinks  accordingly  --  from  (0,  3/8]
   to  (0,  liuD0max],  the  [Z78L]-sharp  strip  interior  --
   and  the  slice  (liuD0max,  3/8]  of  the  old  face  is
   closed  IN  BODY  from  [Z78L]  itself.  No  RH  claim:  the
   face  is  a  zero-exclusion  statement  in  the  unverified
   region,  now  as  narrow  as  the  strongest  available
   kernel-verified  external  input  can  make  it.  (The  input
   class  is  unchanged  in  kind  from  [Z78]  --  an  external
   zero-free  half-plane,  still  far  from  1/2  --  only  its
   certified  boundary  moved  (7/8  -  liuBUpper  =
   4.298e-8;  the  face  shrank  by  3/8  -  liuD0max  =
   4.298e-5).  -/

/--  B13.1  THE  OUTER  SLICE  OF  THE  OLD  FACE  IS  CLOSED
    IN  BODY  FROM  [Z78L]:  for  an  actual-set  zero  set,  no
    off-pair  with  d0  >  liuD0max  (of  any  height  t0  >  0):
    offPairD0leLiu  already  bounds  every  off-pair  to  d0
    <=  liuD0max.  In  particular  the  slice  (liuD0max,  3/8]
    of  the  B12  face  needs  no  face  at  all.  No  RH  claim.  -/
theorem rhend_sliceLiuExcl (q : ZeroSet)
    (hzL : Z78Liu.externalZeroFree78Liu)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0)
    (t0 d0 : ℝ) (ht0 : 0 < t0) (hd0 : 0 < d0)
    (hL : Z78Liu.liuD0max < d0) :
    ¬ offPair q t0 d0 := by
  intro hp
  have hle := Z78Liu.offPairD0leLiu q hzL hqz t0 d0 ht0 hd0 hp
  linarith

/--  B13.2  THE  LIU-UNIFIED  ENDPOINT:  the  B12  endpoint  with
    the  external  input  upgraded  [Z78]  ->  [Z78L]  and  the
    face  shrunk  to  0  <  d0  <=  liuD0max  (the  [Z78L]-sharp
    strip  interior).  Above  H,  any  off-pair  has  d0  <=
    liuD0max  BY  [Z78L]  (offPairD0leLiu)  before  the  face  is
    applied  -  the  d0  <=  1/2  split  of  B11  stays  away  in
    the  S1/S3  legs  and  in  the  S4-covered  leg;  the  far
    region  (d0  >  1/2)  is  closed  by  the  [Z78]  derived
    from  [Z78L].  No  RH  claim.  -/
theorem rh_program78_stripfront_mach_unifiedLiu (q : ZeroSet)
    (hzL : Z78Liu.externalZeroFree78Liu)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0)
    (honline : ∀ ρ ∈ q.Z, 0 < (|ρ.im| : ℝ) → (|ρ.im| : ℝ) <
      (707 : ℝ) / 50 → ρ.re = 1 / 2)
    (Qside : ℝ × ℝ → ℝ)
    (H : ℝ) (hH : 1000 ≤ H)
    (hPT : WinC.allOnLineUpTo q H)
    (hOffL : ∀ (t0 d0 : ℝ), H ≤ t0 → 0 < d0 →
      d0 ≤ Z78Liu.liuD0max → ¬ offPair q t0 d0) :
    RH q := by
  have hz78 : Z78.externalZeroFree78 := Z78Liu.extLiu_implies_ext78 hzL
  refine S4A.rh_from_regime_closures q Qside Z78P12.MfP devProg
    Z78P12.BwireP (fun p => MrLift p.1 p.2) floProg
    ?_ ?_ ?_ ?_ ?_ ?_
  · --  S1  witness  leg:  below  H  =  vacuous  (the  record);
      --  above  H:  [Z78L]  bounds  d0  to  liuD0max,  the  face
      --  kills.
    intro t0 d0 ht0 hd0 hp
    by_cases hle : t0 ≤ H
    · exact False.elim ((WinC.noOffLineBelowPT q H hPT t0
        (le_of_lt ht0) hle) d0 hp)
    · have hL : d0 ≤ Z78Liu.liuD0max :=
        Z78Liu.offPairD0leLiu q hzL hqz t0 d0 ht0 hd0 hp
      exact False.elim ((hOffL t0 d0
        (le_of_lt (not_le.mp hle)) hd0 hL) hp)
  · --  S2  leg:  covered  =  in  body;  low  band  =  vacuous
      --  below  H;  far  =  [Z78]  (from  [Z78L]).
    intro t0 d0 ht0 hd0 hp
    by_cases hd0h : d0 ≤ (1 / 2 : ℝ)
    · by_cases ht0k : 1000 ≤ t0
      · exact hs2_covered q honline t0 d0 ht0 ht0k hd0 hd0h hp
      · have hle : t0 ≤ H := le_trans (le_of_lt (not_le.mp ht0k)) hH
        exact False.elim ((WinC.noOffLineBelowPT q H hPT t0
          (le_of_lt ht0) hle) d0 hp)
    · exact False.elim (Z78P12.offPairFarEmpty q hz78 hqz t0 d0
        (not_le.mp hd0h) hp)
  · --  S3  leg:  below  H  =  vacuous  (the  record);  above  H:
      --  [Z78L]  bounds  d0  to  liuD0max,  the  face  kills.
    intro t0 d0 ht0 hd0 hp
    by_cases hle : t0 ≤ H
    · exact False.elim ((WinC.noOffLineBelowPT q H hPT t0
        (le_of_lt ht0) hle) d0 hp)
    · have hL : d0 ≤ Z78Liu.liuD0max :=
        Z78Liu.offPairD0leLiu q hzL hqz t0 d0 ht0 hd0 hp
      exact False.elim ((hOffL t0 d0
        (le_of_lt (not_le.mp hle)) hd0 hL) hp)
  · --  S4  covered:  below  H  =  vacuous  (the  record);
      --  above  H:  [Z78L]  bounds  d0  to  liuD0max,  the  face
      --  kills.
    intro t0 d0 ht0 hd0 hd0u hp
    by_cases hle : t0 ≤ H
    · exact False.elim ((WinC.noOffLineBelowPT q H hPT t0
        (by linarith [ht0]) hle) d0 hp)
    · have hL : d0 ≤ Z78Liu.liuD0max :=
        Z78Liu.offPairD0leLiu q hzL hqz t0 d0
        (show 0 < t0 from by linarith [ht0]) hd0 hp
      exact False.elim ((hOffL t0 d0
        (le_of_lt (not_le.mp hle)) hd0 hL) hp)
  · --  S4  low  band:  its  whole  domain  (0,  1000)  sits
      --  below  the  frontier:  vacuous.
    intro t0 d0 ht0 ht0u hd0 hd0u hp
    have hle : t0 ≤ H := le_trans (le_of_lt ht0u) hH
    exact False.elim ((WinC.noOffLineBelowPT q H hPT t0
      (le_of_lt ht0) hle) d0 hp)
  · --  S4  far  region:  [Z78]  (from  [Z78L]).
    intro t0 d0 ht0 hd0 hd0f hp
    exact False.elim (Z78P12.offPairFarEmpty q hz78 hqz t0 d0 hd0f hp)

/--  B13.3  THE  LIU  ENDPOINT  AT  THE  PLATT-TRUDGIAN
    FRONTIER  (the  [Z-PT2]  instantiation):  the  entire  named
    residue  lives  STRICTLY  ABOVE  3,000,175,332,800,  as  ONE
    zero-exclusion  face  (no  off-pair  in  0  <  d0  <=
    liuD0max  above  the  frontier  -  the  [Z78L]-sharp  strip
    interior)  plus  [Z78L]  itself  (which  closes  d0  >
    liuD0max  in  body).  No  RH  claim.  -/
theorem rh_program78_stripfront_mach_unifiedLiu_PT2 (q : ZeroSet)
    (hzL : Z78Liu.externalZeroFree78Liu)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0)
    (honline : ∀ ρ ∈ q.Z, 0 < (|ρ.im| : ℝ) → (|ρ.im| : ℝ) <
      (707 : ℝ) / 50 → ρ.re = 1 / 2)
    (Qside : ℝ × ℝ → ℝ)
    (hPT2 : WinC.allOnLineUpTo q WinC.tPT2)
    (hOffLPT2 : ∀ (t0 d0 : ℝ), WinC.tPT2 ≤ t0 → 0 < d0 →
      d0 ≤ Z78Liu.liuD0max → ¬ offPair q t0 d0) :
    RH q :=
  rh_program78_stripfront_mach_unifiedLiu q hzL hqz honline Qside
    WinC.tPT2 (by norm_num [WinC.tPT2]) hPT2 hOffLPT2

/--  B13.4  THE  OLD  3/8  ENDPOINT  UNDER  [Z78L]:  from  the
    [Z78L]  input  and  the  SMALLER  face  (0,  liuD0max],  the
    0129  endpoint  (3/8  face,  named  input  [Z78])  follows  --
    the  input  by  extLiu_implies_ext78,  the  face  by
    restriction  (d0  <=  liuD0max)  or  the  slice  exclusion
    (liuD0max  <  d0  <=  3/8,  closed  in  body  from  [Z78L]).
    The  0129  terminal  statement  is  thus  a  THEOREM  of  the
    0131  one.  No  RH  claim.  -/
theorem rh_program78_stripfront_mach_unified38_ofLiu (q : ZeroSet)
    (hzL : Z78Liu.externalZeroFree78Liu)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0)
    (honline : ∀ ρ ∈ q.Z, 0 < (|ρ.im| : ℝ) → (|ρ.im| : ℝ) <
      (707 : ℝ) / 50 → ρ.re = 1 / 2)
    (Qside : ℝ × ℝ → ℝ)
    (H : ℝ) (hH : 1000 ≤ H)
    (hPT : WinC.allOnLineUpTo q H)
    (hOffL : ∀ (t0 d0 : ℝ), H ≤ t0 → 0 < d0 →
      d0 ≤ Z78Liu.liuD0max → ¬ offPair q t0 d0) :
    RH q := by
  apply rh_program78_stripfront_mach_unified38 q
    (Z78Liu.extLiu_implies_ext78 hzL) hqz honline Qside H hH hPT
  intro t0 d0 ht0 hd0 hd038 hp
  by_cases hleL : d0 ≤ Z78Liu.liuD0max
  · exact False.elim ((hOffL t0 d0 ht0 hd0 hleL) hp)
  · exact False.elim (rhend_sliceLiuExcl q hzL hqz t0 d0
      (by linarith [ht0, hH]) hd0 (not_le.mp hleL) hp)

/--  B13.5  THE  [Z-PT2]  INSTANCE  OF  B13.4  (the  0129
    terminal  statement  at  tPT2  is  a  theorem  of  the  0131
    endpoint  with  the  [Z-PT2]  record).  No  RH  claim.  -/
theorem rh_program78_stripfront_mach_unified38_PT2_ofLiu (q : ZeroSet)
    (hzL : Z78Liu.externalZeroFree78Liu)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0)
    (honline : ∀ ρ ∈ q.Z, 0 < (|ρ.im| : ℝ) → (|ρ.im| : ℝ) <
      (707 : ℝ) / 50 → ρ.re = 1 / 2)
    (Qside : ℝ × ℝ → ℝ)
    (hPT2 : WinC.allOnLineUpTo q WinC.tPT2)
    (hOffLPT2 : ∀ (t0 d0 : ℝ), WinC.tPT2 ≤ t0 → 0 < d0 →
      d0 ≤ Z78Liu.liuD0max → ¬ offPair q t0 d0) :
    RH q :=
  rh_program78_stripfront_mach_unified38_ofLiu q hzL hqz honline
    Qside WinC.tPT2 (by norm_num [WinC.tPT2]) hPT2 hOffLPT2

/-!  PART  B14  (discovery  0133).

   0131  left  the  open  face  hOffL  on  H  <=  t0,  0  <
   d0  <=  liuD0max  --  the  [Z78L]-sharp  strip  interior.
   [Z78T]  (QuasiRiemannTracker  record
   two-level-affine-20261019,  PR  #67,  ArviFoxy,  MERGED
   2026-10-20;  the  kernel-verified  ALL-DIRICHLET  zero-free
   half-plane  at  the  certified  rational  boundary
   qxUpper  =  174963413/200000000  =  0.874817065,  whose
   class  bound  the  record  proves  in  kernel  to  lie  in
   [0.874817064464,  0.874817064465]  --  Comparator  plus
   Lean  /  NanoDa  /  con-ron  in  the  tracker's  pinned
   sandbox;  see  the  Z78Track  module  header  for  the
   full  provenance  and  the  snapshot  caveat)  is  a  STRICT
   STRENGTHENING  of  [Z78L]  at  qxUpper  <  liuBUpper
   (extTrack_implies_extLiu,  transitively
   extTrack_implies_ext78):  zeros  of  an  actual  set  sit
   in  [1  -  qxUpper,  qxUpper],  so  every  off-pair
   satisfies  d0  <=  qxD0max  =  qxUpper  -  1/2  =
   74963413/200000000  =  0.374817065  <  liuD0max
   (offPairD0leTrack,  sharp).  The  open  face  shrinks
   accordingly  --  from  (0,  liuD0max]  to  (0,  qxD0max],
   the  [Z78T]-sharp  strip  interior  --  and  the  slice
   (qxD0max,  liuD0max]  of  the  old  face  is  closed  IN
   BODY  from  [Z78T]  itself.  The  step  removes
   liuD0max  -  qxD0max  =  1.39954e-4  of  face
   width  --  3.3x  the  0131  input  step  (4.298e-5),
   the  second-largest  shrink  of  the  chain  after
   0129's  1/2  ->  3/8  step.  No  RH  claim:
   the  face  is  a  zero-exclusion  statement  in  the
   unverified  region;  the  input  class  is  unchanged  in
   kind  from  [Z78]  --  an  external  zero-free  half-plane,
   still  far  from  1/2  --  only  its  certified  boundary
   moved,  and  the  chain  stays  a  REPEATABLE  MECHANISM
   (B6  packet  section  8):  a  newer  verified  snapshot  of
   the  tracker  frontier  supersedes  this  part
   mechanically.  -/

/--  B14.1  THE  OUTER  SLICE  OF  THE  OLD  FACE  IS  CLOSED
    IN  BODY  FROM  [Z78T]:  for  an  actual-set  zero  set,
    no  off-pair  with  d0  >  qxD0max  (of  any  height  t0
    >  0):  offPairD0leTrack  already  bounds  every  off-pair
    to  d0  <=  qxD0max.  In  particular  the  slice  (qxD0max,
    liuD0max]  of  the  B13  face  --  and  a  fortiori  (qxD0max,
    3/8]  of  the  B12  face  --  needs  no  face  at  all.
    No  RH  claim.  -/
theorem rhend_sliceTrackExcl (q : ZeroSet)
    (hzT : Z78Track.externalZeroFree78Track)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0)
    (t0 d0 : ℝ) (ht0 : 0 < t0) (hd0 : 0 < d0)
    (hT : Z78Track.qxD0max < d0) :
    ¬ offPair q t0 d0 := by
  intro hp
  have hle := Z78Track.offPairD0leTrack q hzT hqz t0 d0 ht0 hd0 hp
  linarith

/--  B14.2  THE  TRACK-UNIFIED  ENDPOINT:  the  B12  endpoint  with
    the  external  input  upgraded  [Z78]  ->  [Z78T]  and  the
    face  shrunk  to  0  <  d0  <=  qxD0max  (the  [Z78T]-sharp
    strip  interior).  Above  H,  any  off-pair  has  d0  <=
    qxD0max  BY  [Z78T]  (offPairD0leLiu)  before  the  face  is
    applied  -  the  d0  <=  1/2  split  of  B11  stays  away  in
    the  S1/S3  legs  and  in  the  S4-covered  leg;  the  far
    region  (d0  >  1/2)  is  closed  by  the  [Z78]  derived
    from  [Z78T].  No  RH  claim.  -/
theorem rh_program78_stripfront_mach_unifiedTrack (q : ZeroSet)
    (hzT : Z78Track.externalZeroFree78Track)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0)
    (honline : ∀ ρ ∈ q.Z, 0 < (|ρ.im| : ℝ) → (|ρ.im| : ℝ) <
      (707 : ℝ) / 50 → ρ.re = 1 / 2)
    (Qside : ℝ × ℝ → ℝ)
    (H : ℝ) (hH : 1000 ≤ H)
    (hPT : WinC.allOnLineUpTo q H)
    (hOffT : ∀ (t0 d0 : ℝ), H ≤ t0 → 0 < d0 →
      d0 ≤ Z78Track.qxD0max → ¬ offPair q t0 d0) :
    RH q := by
  have hz78 : Z78.externalZeroFree78 := Z78Track.extTrack_implies_ext78 hzT
  refine S4A.rh_from_regime_closures q Qside Z78P12.MfP devProg
    Z78P12.BwireP (fun p => MrLift p.1 p.2) floProg
    ?_ ?_ ?_ ?_ ?_ ?_
  · --  S1  witness  leg:  below  H  =  vacuous  (the  record);
      --  above  H:  [Z78T]  bounds  d0  to  qxD0max,  the  face
      --  kills.
    intro t0 d0 ht0 hd0 hp
    by_cases hle : t0 ≤ H
    · exact False.elim ((WinC.noOffLineBelowPT q H hPT t0
        (le_of_lt ht0) hle) d0 hp)
    · have hL : d0 ≤ Z78Track.qxD0max :=
        Z78Track.offPairD0leTrack q hzT hqz t0 d0 ht0 hd0 hp
      exact False.elim ((hOffT t0 d0
        (le_of_lt (not_le.mp hle)) hd0 hL) hp)
  · --  S2  leg:  covered  =  in  body;  low  band  =  vacuous
      --  below  H;  far  =  [Z78]  (from  [Z78T]).
    intro t0 d0 ht0 hd0 hp
    by_cases hd0h : d0 ≤ (1 / 2 : ℝ)
    · by_cases ht0k : 1000 ≤ t0
      · exact hs2_covered q honline t0 d0 ht0 ht0k hd0 hd0h hp
      · have hle : t0 ≤ H := le_trans (le_of_lt (not_le.mp ht0k)) hH
        exact False.elim ((WinC.noOffLineBelowPT q H hPT t0
          (le_of_lt ht0) hle) d0 hp)
    · exact False.elim (Z78P12.offPairFarEmpty q hz78 hqz t0 d0
        (not_le.mp hd0h) hp)
  · --  S3  leg:  below  H  =  vacuous  (the  record);  above  H:
      --  [Z78T]  bounds  d0  to  qxD0max,  the  face  kills.
    intro t0 d0 ht0 hd0 hp
    by_cases hle : t0 ≤ H
    · exact False.elim ((WinC.noOffLineBelowPT q H hPT t0
        (le_of_lt ht0) hle) d0 hp)
    · have hL : d0 ≤ Z78Track.qxD0max :=
        Z78Track.offPairD0leTrack q hzT hqz t0 d0 ht0 hd0 hp
      exact False.elim ((hOffT t0 d0
        (le_of_lt (not_le.mp hle)) hd0 hL) hp)
  · --  S4  covered:  below  H  =  vacuous  (the  record);
      --  above  H:  [Z78T]  bounds  d0  to  qxD0max,  the  face
      --  kills.
    intro t0 d0 ht0 hd0 hd0u hp
    by_cases hle : t0 ≤ H
    · exact False.elim ((WinC.noOffLineBelowPT q H hPT t0
        (by linarith [ht0]) hle) d0 hp)
    · have hL : d0 ≤ Z78Track.qxD0max :=
        Z78Track.offPairD0leTrack q hzT hqz t0 d0
        (show 0 < t0 from by linarith [ht0]) hd0 hp
      exact False.elim ((hOffT t0 d0
        (le_of_lt (not_le.mp hle)) hd0 hL) hp)
  · --  S4  low  band:  its  whole  domain  (0,  1000)  sits
      --  below  the  frontier:  vacuous.
    intro t0 d0 ht0 ht0u hd0 hd0u hp
    have hle : t0 ≤ H := le_trans (le_of_lt ht0u) hH
    exact False.elim ((WinC.noOffLineBelowPT q H hPT t0
      (le_of_lt ht0) hle) d0 hp)
  · --  S4  far  region:  [Z78]  (from  [Z78T]).
    intro t0 d0 ht0 hd0 hd0f hp
    exact False.elim (Z78P12.offPairFarEmpty q hz78 hqz t0 d0 hd0f hp)

/--  B14.3  THE  TRACK  ENDPOINT  AT  THE  PLATT-TRUDGIAN
    FRONTIER  (the  [Z-PT2]  instantiation):  the  entire  named
    residue  lives  STRICTLY  ABOVE  3,000,175,332,800,  as  ONE
    zero-exclusion  face  (no  off-pair  in  0  <  d0  <=
    qxD0max  above  the  frontier  -  the  [Z78T]-sharp  strip
    interior)  plus  [Z78T]  itself  (which  closes  d0  >
    qxD0max  in  body).  No  RH  claim.  -/
theorem rh_program78_stripfront_mach_unifiedTrack_PT2 (q : ZeroSet)
    (hzT : Z78Track.externalZeroFree78Track)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0)
    (honline : ∀ ρ ∈ q.Z, 0 < (|ρ.im| : ℝ) → (|ρ.im| : ℝ) <
      (707 : ℝ) / 50 → ρ.re = 1 / 2)
    (Qside : ℝ × ℝ → ℝ)
    (hPT2 : WinC.allOnLineUpTo q WinC.tPT2)
    (hOffTPT2 : ∀ (t0 d0 : ℝ), WinC.tPT2 ≤ t0 → 0 < d0 →
      d0 ≤ Z78Track.qxD0max → ¬ offPair q t0 d0) :
    RH q :=
  rh_program78_stripfront_mach_unifiedTrack q hzT hqz honline Qside
    WinC.tPT2 (by norm_num [WinC.tPT2]) hPT2 hOffTPT2

/--  B14.4  THE  0131  LIU  ENDPOINT  AS  A  THEOREM  OF  THE
    [Z78T]  ENDPOINT  (in  body):  given  the  [Z78T]  input
    and  its  terminal  face  hOffT  on  0  <  d0  <=
    qxD0max,  the  older  Liu-form  endpoint  follows  --  the
    Liu  face  (0  <  d0  <=  liuD0max)  splits  into  the
    qxD0max  half  (the  hOffT  face)  and  the  slice
    (qxD0max,  liuD0max]  (closed  in  body  from  [Z78T]).
    The  0131  terminal  statement  is  thus  a  THEOREM  of
    the  0133  one.  No  RH  claim.  -/
theorem rh_program78_stripfront_mach_unifiedLiu_ofTrack (q : ZeroSet)
    (hzT : Z78Track.externalZeroFree78Track)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0)
    (honline : ∀ ρ ∈ q.Z, 0 < (|ρ.im| : ℝ) → (|ρ.im| : ℝ) <
      (707 : ℝ) / 50 → ρ.re = 1 / 2)
    (Qside : ℝ × ℝ → ℝ)
    (H : ℝ) (hH : 1000 ≤ H)
    (hPT : WinC.allOnLineUpTo q H)
    (hOffT : ∀ (t0 d0 : ℝ), H ≤ t0 → 0 < d0 →
      d0 ≤ Z78Track.qxD0max → ¬ offPair q t0 d0) :
    RH q := by
  have hzL : Z78Liu.externalZeroFree78Liu :=
    Z78Track.extTrack_implies_extLiu hzT
  apply rh_program78_stripfront_mach_unifiedLiu q hzL hqz honline
    Qside H hH hPT
  intro t0 d0 ht0 hd0 hd0L hp
  by_cases hleT : d0 ≤ Z78Track.qxD0max
  · exact False.elim ((hOffT t0 d0 ht0 hd0 hleT) hp)
  · exact False.elim (rhend_sliceTrackExcl q hzT hqz t0 d0
      (by linarith [ht0, hH]) hd0 (not_le.mp hleT) hp)

/--  B14.5  THE  [Z-PT2]  INSTANCE  OF  B14.4  (the  0131
    terminal  statement  at  tPT2  is  a  theorem  of  the
    0133  endpoint  with  the  [Z-PT2]  record).  No  RH
    claim.  -/
theorem rh_program78_stripfront_mach_unifiedLiu_PT2_ofTrack (q : ZeroSet)
    (hzT : Z78Track.externalZeroFree78Track)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0)
    (honline : ∀ ρ ∈ q.Z, 0 < (|ρ.im| : ℝ) → (|ρ.im| : ℝ) <
      (707 : ℝ) / 50 → ρ.re = 1 / 2)
    (Qside : ℝ × ℝ → ℝ)
    (hPT2 : WinC.allOnLineUpTo q WinC.tPT2)
    (hOffTPT2 : ∀ (t0 d0 : ℝ), WinC.tPT2 ≤ t0 → 0 < d0 →
      d0 ≤ Z78Track.qxD0max → ¬ offPair q t0 d0) :
    RH q :=
  rh_program78_stripfront_mach_unifiedLiu_ofTrack q hzT hqz honline
    Qside WinC.tPT2 (by norm_num [WinC.tPT2]) hPT2 hOffTPT2

/-!  PART  B15  (discovery  0142).

   0133  left  the  open  face  hOffT  on  H  <=  t0,  0  <
   d0  <=  qxD0max  --  the  [Z78T]-sharp  strip  interior.
   The  tracker  board  moved  one  day  after  the  0141
   ceiling  analysis  of  the  cycle63  family  predicted
   would  be  the  only  way  it  could  move:  [Z78G]
   (QuasiRiemannTracker  record
   gao-five-step-affine-20261020,  PR  #68,  Zhongpai  Gao,
   MERGED  2026-10-21,  first  verified  2026-10-21T02:06:55Z;
   the  kernel-verified  ALL-DIRICHLET  zero-free  half-plane
   at  the  certified  rational  boundary
   gaoUpper  =  8748087/10^7  =  0.8748087,  comparator  plus
   Lean  /  nanoda  /  con-ron  in  the  tracker's  pinned
   sandbox  AND  this  program's  independent  second-party
   replay  --  see  the  Z78Gao  module  header  for  the  full
   provenance,  the  replay  record  and  the  snapshot
   caveat)  is  a  STRICT  STRENGTHENING  of  [Z78T]  at
   gaoUpper  <  qxUpper  (extGao_implies_extTrack,
   transitively  extGao_implies_extLiu  /  _ext78):  it  is  a
   FIVE-step  affine  record  building  ON  two-level-affine,
   i.e.  a  genuine  new  structural  cycle,  exactly  the
   species  0141  identified  as  the  only  route  past  the
   cycle63  ceiling.  Zeros  of  an  actual  set  sit  in
   [1  -  gaoUpper,  gaoUpper],  so  every  off-pair
   satisfies  d0  <=  gaoD0max  =  gaoUpper  -  1/2  =
   3748087/10^7  =  0.3748087  <  qxD0max
   (offPairD0leGao,  sharp).  The  open  face  shrinks
   accordingly  --  from  (0,  qxD0max]  to  (0,
   gaoD0max],  the  [Z78G]-sharp  strip  interior  --  and  the
   slice  (gaoD0max,  qxD0max]  of  the  B14  face  is  closed
   IN  BODY  from  [Z78G]  itself.  The  step  removes
   qxD0max  -  gaoD0max  =  8.365e-6  of  face  width
   (about  one-fifteenth  of  the  0133  step).  No  RH
   claim:  the  face  is  a  zero-exclusion  statement  in  the
   unverified  region;  the  input  class  is  unchanged  in
   kind  --  an  external  zero-free  half-plane,  still  far
   from  1/2  --  and  the  chain  stays  a  REPEATABLE
   MECHANISM  (B6  packet  section  8,  now  demonstrated  on
   a  SECOND  supersession):  a  newer  verified  snapshot  of
   the  tracker  frontier  supersedes  this  part
   mechanically.  -/

/--  B15.1  THE  OUTER  SLICE  OF  THE  OLD  FACE  IS  CLOSED
    IN  BODY  FROM  [Z78G]:  for  an  actual-set  zero  set,
    no  off-pair  with  d0  >  gaoD0max  (of  any  height  t0
    >  0):  offPairD0leGao  already  bounds  every  off-pair
    to  d0  <=  gaoD0max.  In  particular  the  slice
    (gaoD0max,  qxD0max]  of  the  B14  face  --  and  a
    fortiori  (gaoD0max,  liuD0max]  of  the  B13  face  and
    (gaoD0max,  3/8]  of  the  B12  face  --  needs  no  face
    at  all.  No  RH  claim.  -/
theorem rhend_sliceGaoExcl (q : ZeroSet)
    (hzG : Z78Gao.externalZeroFree78Gao)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0)
    (t0 d0 : ℝ) (ht0 : 0 < t0) (hd0 : 0 < d0)
    (hG : Z78Gao.gaoD0max < d0) :
    ¬ offPair q t0 d0 := by
  intro hp
  have hle := Z78Gao.offPairD0leGao q hzG hqz t0 d0 ht0 hd0 hp
  linarith

/--  B15.2  THE  FIVE-STEP-UNIFIED  ENDPOINT:  the  B12
    endpoint  with  the  external  input  upgraded
    [Z78]  ->  [Z78G]  and  the  face  shrunk  to  0  <  d0
    <=  gaoD0max  (the  [Z78G]-sharp  strip  interior).
    Above  H,  any  off-pair  has  d0  <=  gaoD0max  BY
    [Z78G]  (offPairD0leGao)  before  the  face  is  applied  -
    the  d0  <=  1/2  split  of  B11  stays  away  in  the
    S1/S3  legs  and  in  the  S4-covered  leg;  the  far
    region  (d0  >  1/2)  is  closed  by  the  [Z78]  derived
    from  [Z78G].  No  RH  claim.  -/
theorem rh_program78_stripfront_mach_unifiedGao (q : ZeroSet)
    (hzG : Z78Gao.externalZeroFree78Gao)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0)
    (honline : ∀ ρ ∈ q.Z, 0 < (|ρ.im| : ℝ) → (|ρ.im| : ℝ) <
      (707 : ℝ) / 50 → ρ.re = 1 / 2)
    (Qside : ℝ × ℝ → ℝ)
    (H : ℝ) (hH : 1000 ≤ H)
    (hPT : WinC.allOnLineUpTo q H)
    (hOffG : ∀ (t0 d0 : ℝ), H ≤ t0 → 0 < d0 →
      d0 ≤ Z78Gao.gaoD0max → ¬ offPair q t0 d0) :
    RH q := by
  have hz78 : Z78.externalZeroFree78 := Z78Gao.extGao_implies_ext78 hzG
  refine S4A.rh_from_regime_closures q Qside Z78P12.MfP devProg
    Z78P12.BwireP (fun p => MrLift p.1 p.2) floProg
    ?_ ?_ ?_ ?_ ?_ ?_
  · --  S1  witness  leg:  below  H  =  vacuous  (the  record);
      --  above  H:  [Z78G]  bounds  d0  to  gaoD0max,  the  face
      --  kills.
    intro t0 d0 ht0 hd0 hp
    by_cases hle : t0 ≤ H
    · exact False.elim ((WinC.noOffLineBelowPT q H hPT t0
        (le_of_lt ht0) hle) d0 hp)
    · have hL : d0 ≤ Z78Gao.gaoD0max :=
        Z78Gao.offPairD0leGao q hzG hqz t0 d0 ht0 hd0 hp
      exact False.elim ((hOffG t0 d0
        (le_of_lt (not_le.mp hle)) hd0 hL) hp)
  · --  S2  leg:  covered  =  in  body;  low  band  =  vacuous
      --  below  H;  far  =  [Z78]  (from  [Z78G]).
    intro t0 d0 ht0 hd0 hp
    by_cases hd0h : d0 ≤ (1 / 2 : ℝ)
    · by_cases ht0k : 1000 ≤ t0
      · exact hs2_covered q honline t0 d0 ht0 ht0k hd0 hd0h hp
      · have hle : t0 ≤ H := le_trans (le_of_lt (not_le.mp ht0k)) hH
        exact False.elim ((WinC.noOffLineBelowPT q H hPT t0
          (le_of_lt ht0) hle) d0 hp)
    · exact False.elim (Z78P12.offPairFarEmpty q hz78 hqz t0 d0
        (not_le.mp hd0h) hp)
  · --  S3  leg:  below  H  =  vacuous  (the  record);  above  H:
      --  [Z78G]  bounds  d0  to  gaoD0max,  the  face  kills.
    intro t0 d0 ht0 hd0 hp
    by_cases hle : t0 ≤ H
    · exact False.elim ((WinC.noOffLineBelowPT q H hPT t0
        (le_of_lt ht0) hle) d0 hp)
    · have hL : d0 ≤ Z78Gao.gaoD0max :=
        Z78Gao.offPairD0leGao q hzG hqz t0 d0 ht0 hd0 hp
      exact False.elim ((hOffG t0 d0
        (le_of_lt (not_le.mp hle)) hd0 hL) hp)
  · --  S4  covered:  below  H  =  vacuous  (the  record);
      --  above  H:  [Z78G]  bounds  d0  to  gaoD0max,  the  face
      --  kills.
    intro t0 d0 ht0 hd0 hd0u hp
    by_cases hle : t0 ≤ H
    · exact False.elim ((WinC.noOffLineBelowPT q H hPT t0
        (by linarith [ht0]) hle) d0 hp)
    · have hL : d0 ≤ Z78Gao.gaoD0max :=
        Z78Gao.offPairD0leGao q hzG hqz t0 d0
        (show 0 < t0 from by linarith [ht0]) hd0 hp
      exact False.elim ((hOffG t0 d0
        (le_of_lt (not_le.mp hle)) hd0 hL) hp)
  · --  S4  low  band:  its  whole  domain  (0,  1000)  sits
      --  below  the  frontier:  vacuous.
    intro t0 d0 ht0 ht0u hd0 hd0u hp
    have hle : t0 ≤ H := le_trans (le_of_lt ht0u) hH
    exact False.elim ((WinC.noOffLineBelowPT q H hPT t0
      (le_of_lt ht0) hle) d0 hp)
  · --  S4  far  region:  [Z78]  (from  [Z78G]).
    intro t0 d0 ht0 hd0 hd0f hp
    exact False.elim (Z78P12.offPairFarEmpty q hz78 hqz t0 d0 hd0f hp)

/--  B15.3  THE  FIVE-STEP  ENDPOINT  AT  THE  PLATT-TRUDGIAN
    FRONTIER  (the  [Z-PT2]  instantiation):  the  entire  named
    residue  lives  STRICTLY  ABOVE  3,000,175,332,800,  as  ONE
    zero-exclusion  face  (no  off-pair  in  0  <  d0  <=
    gaoD0max  above  the  frontier  -  the  [Z78G]-sharp  strip
    interior)  plus  [Z78G]  itself  (which  closes  d0  >
    gaoD0max  in  body).  No  RH  claim.  -/
theorem rh_program78_stripfront_mach_unifiedGao_PT2 (q : ZeroSet)
    (hzG : Z78Gao.externalZeroFree78Gao)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0)
    (honline : ∀ ρ ∈ q.Z, 0 < (|ρ.im| : ℝ) → (|ρ.im| : ℝ) <
      (707 : ℝ) / 50 → ρ.re = 1 / 2)
    (Qside : ℝ × ℝ → ℝ)
    (hPT2 : WinC.allOnLineUpTo q WinC.tPT2)
    (hOffGPT2 : ∀ (t0 d0 : ℝ), WinC.tPT2 ≤ t0 → 0 < d0 →
      d0 ≤ Z78Gao.gaoD0max → ¬ offPair q t0 d0) :
    RH q :=
  rh_program78_stripfront_mach_unifiedGao q hzG hqz honline Qside
    WinC.tPT2 (by norm_num [WinC.tPT2]) hPT2 hOffGPT2

/--  B15.4  THE  0133  TRACK  ENDPOINT  AS  A  THEOREM  OF  THE
    [Z78G]  ENDPOINT  (in  body):  given  the  [Z78G]  input
    and  its  terminal  face  hOffG  on  0  <  d0  <=
    gaoD0max,  the  older  track-form  endpoint  follows  --  the
    track  face  (0  <  d0  <=  qxD0max)  splits  into  the
    gaoD0max  half  (the  hOffG  face)  and  the  slice
    (gaoD0max,  qxD0max]  (closed  in  body  from  [Z78G]).
    The  0133  terminal  statement  is  thus  a  THEOREM  of
    the  0142  one.  No  RH  claim.  -/
theorem rh_program78_stripfront_mach_unifiedTrack_ofGao (q : ZeroSet)
    (hzG : Z78Gao.externalZeroFree78Gao)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0)
    (honline : ∀ ρ ∈ q.Z, 0 < (|ρ.im| : ℝ) → (|ρ.im| : ℝ) <
      (707 : ℝ) / 50 → ρ.re = 1 / 2)
    (Qside : ℝ × ℝ → ℝ)
    (H : ℝ) (hH : 1000 ≤ H)
    (hPT : WinC.allOnLineUpTo q H)
    (hOffG : ∀ (t0 d0 : ℝ), H ≤ t0 → 0 < d0 →
      d0 ≤ Z78Gao.gaoD0max → ¬ offPair q t0 d0) :
    RH q := by
  have hzT : Z78Track.externalZeroFree78Track :=
    Z78Gao.extGao_implies_extTrack hzG
  apply rh_program78_stripfront_mach_unifiedTrack q hzT hqz
    honline Qside H hH hPT
  intro t0 d0 ht0 hd0 hd0T hp
  by_cases hleG : d0 ≤ Z78Gao.gaoD0max
  · exact False.elim ((hOffG t0 d0 ht0 hd0 hleG) hp)
  · exact False.elim (rhend_sliceGaoExcl q hzG hqz t0 d0
      (by linarith [ht0, hH]) hd0 (not_le.mp hleG) hp)

/--  B15.5  THE  [Z-PT2]  INSTANCE  OF  B15.4  (the  0133
    terminal  statement  at  tPT2  is  a  theorem  of  the
    0142  endpoint  with  the  [Z-PT2]  record).  No  RH
    claim.  -/
theorem rh_program78_stripfront_mach_unifiedTrack_PT2_ofGao (q : ZeroSet)
    (hzG : Z78Gao.externalZeroFree78Gao)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0)
    (honline : ∀ ρ ∈ q.Z, 0 < (|ρ.im| : ℝ) → (|ρ.im| : ℝ) <
      (707 : ℝ) / 50 → ρ.re = 1 / 2)
    (Qside : ℝ × ℝ → ℝ)
    (hPT2 : WinC.allOnLineUpTo q WinC.tPT2)
    (hOffGPT2 : ∀ (t0 d0 : ℝ), WinC.tPT2 ≤ t0 → 0 < d0 →
      d0 ≤ Z78Gao.gaoD0max → ¬ offPair q t0 d0) :
    RH q :=
  rh_program78_stripfront_mach_unifiedTrack_ofGao q hzG hqz
    honline Qside WinC.tPT2 (by norm_num [WinC.tPT2]) hPT2
    hOffGPT2

/-!
ADOPTED 2026-10-23 (discovery 0162).  PR #69 (Hailey Collet /
HaileyStorm) merged; merge identity verified against the frozen-head
replay: merged head = frozen head ac76d5ef6008d976a7b8f3c1d921af2317e79ce9,
merge commit 2cbdbe7c14e926c1eb33fea0919e561038a27880, and the
full merged submission tree is blob-SHA-identical to the replayed
frozen copy (3549/3549 files, 2026-10-23).  See the Z78Collet module
header for the complete provenance record.
-/

/-!
**Part B16 — the tracker board moved AGAIN: [Z78C] supersedes [Z78G].**

The B6 section-8 mechanism (demonstrated in 0133 and 0142) runs a
third time: [Z78C] (QuasiRiemannTracker PR #69, record
hailey-collet-1252270103, Hailey Collet / HaileyStorm; the kernel-
verified all-Dirichlet zero-free half-plane at the certified rational
colletUpper = 8747729897/10^10 = 0.8747729897 — see the Z78Collet
module header for the full provenance: frozen-head identity ac76d5ef,
this program's independent 6474/6474-module second-party replay PASS
2026-10-21 at [propext, Classical.choice, Quot.sound] with 0 sorry,
and the pending gates: merge identity check, standalone paper,
catalogue record) is a STRICT STRENGTHENING of [Z78G] at
colletUpper < gaoUpper (extColet_implies_extGao; transitively
extColet_implies_extTrack/_extLiu/_ext78).  It is a NEW structural
cycle — "finite ordinary source moments": the accepted PR67 input
(= the [Z78T] record) plus 64 seed source faces, an intermediate
return, 221 derived source faces and a final return over a 301-node
finite source DAG — exactly the species the 0141/0144/0145 ceiling
line forecast: a new cycle, not tuning.  Zeros of an actual set sit
in [1 - colletUpper, colletUpper], so every off-pair satisfies
d0 <= colletD0max = colletUpper - 1/2 = 3747729897/10^10 =
0.3747729897 < gaoD0max (offPairD0leCollet, sharp).  The open face
shrinks from (0, gaoD0max] to (0, colletD0max], the [Z78C]-sharp
strip interior, and the slice (colletD0max, gaoD0max] of the B15
face is closed IN BODY from [Z78C] itself.  The step removes
gaoD0max - colletD0max = 3.57103e-5 of face width (4.3x the 0142
step).  No RH claim: the face is a zero-exclusion statement in the
unverified region; the input class is unchanged in kind — an external
zero-free half-plane, still far from 1/2 — and the chain stays a
REPEATABLE MECHANISM (B6 packet section 8, now demonstrated on a
THIRD supersession): a newer verified snapshot of the tracker
frontier supersedes this part mechanically.  Ceiling note (0147):
the record sits 2.116e-4 above its own family's named-margin corner
(0.8745613585650727), so a fourth supersession from the same family
is plausible; the engine is input-uniform.  -/

/--  B16.1  THE  OUTER  SLICE  OF  THE  OLD  FACE  IS  CLOSED  IN
    BODY  FROM  [Z78C]:  for  an  actual-set  zero  set,  no  off-pair
    with  d0  >  colletD0max  (of  any  height  t0  >  0):
    offPairD0leCollet  already  bounds  every  off-pair  to
    d0  <=  colletD0max.  In  particular  the  slice
    (colletD0max,  gaoD0max]  of  the  B15  face  --  and  a  fortiori
    (colletD0max,  qxD0max],  (colletD0max,  liuD0max],  (colletD0max,
    3/8]  --  needs  no  face  at  all.  No  RH  claim.  -/
theorem rhend_sliceColletExcl (q : ZeroSet)
    (hzC : Z78Collet.externalZeroFree78Collet)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0)
    (t0 d0 : ℝ) (ht0 : 0 < t0) (hd0 : 0 < d0)
    (hC : Z78Collet.colletD0max < d0) :
    ¬ offPair q t0 d0 := by
  intro hp
  have hle := Z78Collet.offPairD0leCollet q hzC hqz t0 d0 ht0 hd0 hp
  linarith

/--  B16.2  THE  SOURCE-MOMENTS-UNIFIED  ENDPOINT:  the  B12
    endpoint  with  the  external  input  upgraded
    [Z78]  ->  [Z78C]  and  the  face  shrunk  to  0  <  d0
    <=  colletD0max  (the  [Z78C]-sharp  strip  interior).
    Above  H,  any  off-pair  has  d0  <=  colletD0max  BY
    [Z78C]  (offPairD0leCollet)  before  the  face  is  applied  -
    the  d0  <=  1/2  split  of  B11  stays  away  in  the
    S1/S3  legs  and  in  the  S4-covered  leg;  the  far
    region  (d0  >  1/2)  is  closed  by  the  [Z78]  derived
    from  [Z78C].  No  RH  claim.  -/
theorem rh_program78_stripfront_mach_unifiedCollet (q : ZeroSet)
    (hzC : Z78Collet.externalZeroFree78Collet)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0)
    (honline : ∀ ρ ∈ q.Z, 0 < (|ρ.im| : ℝ) → (|ρ.im| : ℝ) <
      (707 : ℝ) / 50 → ρ.re = 1 / 2)
    (Qside : ℝ × ℝ → ℝ)
    (H : ℝ) (hH : 1000 ≤ H)
    (hPT : WinC.allOnLineUpTo q H)
    (hOffC : ∀ (t0 d0 : ℝ), H ≤ t0 → 0 < d0 →
      d0 ≤ Z78Collet.colletD0max → ¬ offPair q t0 d0) :
    RH q := by
  have hz78 : Z78.externalZeroFree78 := Z78Collet.extColet_implies_ext78 hzC
  refine S4A.rh_from_regime_closures q Qside Z78P12.MfP devProg
    Z78P12.BwireP (fun p => MrLift p.1 p.2) floProg
    ?_ ?_ ?_ ?_ ?_ ?_
  · --  S1  witness  leg:  below  H  =  vacuous  (the  record);
      --  above  H:  [Z78C]  bounds  d0  to  colletD0max,  the  face
      --  kills.
    intro t0 d0 ht0 hd0 hp
    by_cases hle : t0 ≤ H
    · exact False.elim ((WinC.noOffLineBelowPT q H hPT t0
        (le_of_lt ht0) hle) d0 hp)
    · have hL : d0 ≤ Z78Collet.colletD0max :=
        Z78Collet.offPairD0leCollet q hzC hqz t0 d0 ht0 hd0 hp
      exact False.elim ((hOffC t0 d0
        (le_of_lt (not_le.mp hle)) hd0 hL) hp)
  · --  S2  leg:  covered  =  in  body;  low  band  =  vacuous
      --  below  H;  far  =  [Z78]  (from  [Z78C]).
    intro t0 d0 ht0 hd0 hp
    by_cases hd0h : d0 ≤ (1 / 2 : ℝ)
    · by_cases ht0k : 1000 ≤ t0
      · exact hs2_covered q honline t0 d0 ht0 ht0k hd0 hd0h hp
      · have hle : t0 ≤ H := le_trans (le_of_lt (not_le.mp ht0k)) hH
        exact False.elim ((WinC.noOffLineBelowPT q H hPT t0
          (le_of_lt ht0) hle) d0 hp)
    · exact False.elim (Z78P12.offPairFarEmpty q hz78 hqz t0 d0
        (not_le.mp hd0h) hp)
  · --  S3  leg:  below  H  =  vacuous  (the  record);  above  H:
      --  [Z78C]  bounds  d0  to  colletD0max,  the  face  kills.
    intro t0 d0 ht0 hd0 hp
    by_cases hle : t0 ≤ H
    · exact False.elim ((WinC.noOffLineBelowPT q H hPT t0
        (le_of_lt ht0) hle) d0 hp)
    · have hL : d0 ≤ Z78Collet.colletD0max :=
        Z78Collet.offPairD0leCollet q hzC hqz t0 d0 ht0 hd0 hp
      exact False.elim ((hOffC t0 d0
        (le_of_lt (not_le.mp hle)) hd0 hL) hp)
  · --  S4  covered:  below  H  =  vacuous  (the  record);
      --  above  H:  [Z78C]  bounds  d0  to  colletD0max,  the  face
      --  kills.
    intro t0 d0 ht0 hd0 hd0u hp
    by_cases hle : t0 ≤ H
    · exact False.elim ((WinC.noOffLineBelowPT q H hPT t0
        (by linarith [ht0]) hle) d0 hp)
    · have hL : d0 ≤ Z78Collet.colletD0max :=
        Z78Collet.offPairD0leCollet q hzC hqz t0 d0
        (show 0 < t0 from by linarith [ht0]) hd0 hp
      exact False.elim ((hOffC t0 d0
        (le_of_lt (not_le.mp hle)) hd0 hL) hp)
  · --  S4  low:  covered  low  band  below  H;  the  d0  <= 1/2  part
      --  of  the  low  band  is  vacuous  (the  record)  below  H;
      --  above  H  the  face  covers  (colletD0max  <  1/2).
    intro t0 d0 ht0 ht0u hd0 hd0u hp
    by_cases hle : t0 ≤ H
    · exact False.elim ((WinC.noOffLineBelowPT q H hPT t0
        (le_of_lt ht0) hle) d0 hp)
    · have hL : d0 ≤ Z78Collet.colletD0max :=
        Z78Collet.offPairD0leCollet q hzC hqz t0 d0 ht0 hd0 hp
      exact False.elim ((hOffC t0 d0
        (le_of_lt (not_le.mp hle)) hd0 hL) hp)
  · --  S4  far:  [Z78]  (from  [Z78C]).
    intro t0 d0 ht0 hd0 hd0f hp
    exact False.elim (Z78P12.offPairFarEmpty q hz78 hqz t0 d0
      hd0f hp)

/--  B16.3  THE  SOURCE-MOMENTS  ENDPOINT  AT  THE  PLATT-TRUDGIAN
    FRONTIER  (the  [Z-PT2]  instantiation):  the  entire  named
    residue  lives  STRICTLY  ABOVE  3,000,175,332,800,  as  ONE
    zero-exclusion  face  (no  off-pair  in  0  <  d0  <=
    colletD0max  above  the  frontier  -  the  [Z78C]-sharp  strip
    interior)  plus  [Z78C]  itself  (which  closes  d0  >
    colletD0max  in  body).  No  RH  claim.  -/
theorem rh_program78_stripfront_mach_unifiedCollet_PT2 (q : ZeroSet)
    (hzC : Z78Collet.externalZeroFree78Collet)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0)
    (honline : ∀ ρ ∈ q.Z, 0 < (|ρ.im| : ℝ) → (|ρ.im| : ℝ) <
      (707 : ℝ) / 50 → ρ.re = 1 / 2)
    (Qside : ℝ × ℝ → ℝ)
    (hPT2 : WinC.allOnLineUpTo q WinC.tPT2)
    (hOffCPT2 : ∀ (t0 d0 : ℝ), WinC.tPT2 ≤ t0 → 0 < d0 →
      d0 ≤ Z78Collet.colletD0max → ¬ offPair q t0 d0) :
    RH q :=
  rh_program78_stripfront_mach_unifiedCollet q hzC hqz honline Qside
    WinC.tPT2 (by norm_num [WinC.tPT2]) hPT2 hOffCPT2

/--  B16.4  THE  0142  GA  O  ENDPOINT  AS  A  THEOREM  OF  THE
    [Z78C]  ENDPOINT  (in  body):  given  the  [Z78C]  input  and
    its  terminal  face  hOffC  on  0  <  d0  <=  colletD0max,  the
    older  five-step-form  endpoint  follows  --  the  gao  face
    (0  <  d0  <=  gaoD0max)  splits  into  the  colletD0max  half
    (the  hOffC  face)  and  the  slice  (colletD0max,  gaoD0max]
    (closed  in  body  from  [Z78C]).  The  0142  terminal
    statement  is  thus  a  THEOREM  of  the  0148  one.  No  RH
    claim.  -/
theorem rh_program78_stripfront_mach_unifiedGao_ofColet (q : ZeroSet)
    (hzC : Z78Collet.externalZeroFree78Collet)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0)
    (honline : ∀ ρ ∈ q.Z, 0 < (|ρ.im| : ℝ) → (|ρ.im| : ℝ) <
      (707 : ℝ) / 50 → ρ.re = 1 / 2)
    (Qside : ℝ × ℝ → ℝ)
    (H : ℝ) (hH : 1000 ≤ H)
    (hPT : WinC.allOnLineUpTo q H)
    (hOffC : ∀ (t0 d0 : ℝ), H ≤ t0 → 0 < d0 →
      d0 ≤ Z78Collet.colletD0max → ¬ offPair q t0 d0) :
    RH q := by
  have hzG : Z78Gao.externalZeroFree78Gao :=
    Z78Collet.extColet_implies_extGao hzC
  apply rh_program78_stripfront_mach_unifiedGao q hzG hqz
    honline Qside H hH hPT
  intro t0 d0 ht0 hd0 hd0G hp
  by_cases hleC : d0 ≤ Z78Collet.colletD0max
  · exact False.elim ((hOffC t0 d0 ht0 hd0 hleC) hp)
  · exact False.elim (rhend_sliceColletExcl q hzC hqz t0 d0
      (by linarith [ht0, hH]) hd0 (not_le.mp hleC) hp)

/--  B16.5  THE  [Z-PT2]  INSTANCE  OF  B16.4  (the  0142  terminal
    statement  at  tPT2  is  a  theorem  of  the  0148  endpoint  with
    the  [Z-PT2]  record).  No  RH  claim.  -/
theorem rh_program78_stripfront_mach_unifiedGao_PT2_ofColet (q : ZeroSet)
    (hzC : Z78Collet.externalZeroFree78Collet)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0)
    (honline : ∀ ρ ∈ q.Z, 0 < (|ρ.im| : ℝ) → (|ρ.im| : ℝ) <
      (707 : ℝ) / 50 → ρ.re = 1 / 2)
    (Qside : ℝ × ℝ → ℝ)
    (hPT2 : WinC.allOnLineUpTo q WinC.tPT2)
    (hOffCPT2 : ∀ (t0 d0 : ℝ), WinC.tPT2 ≤ t0 → 0 < d0 →
      d0 ≤ Z78Collet.colletD0max → ¬ offPair q t0 d0) :
    RH q :=
  rh_program78_stripfront_mach_unifiedGao_ofColet q hzC hqz
    honline Qside WinC.tPT2 (by norm_num [WinC.tPT2]) hPT2
    hOffCPT2

/-!  -/

/-!
**Part B17 - the tracker board moved AGAIN: [Z78SIL32] supersedes
[Z78C] (and, with it, the whole 2026-10-24 frontier map).**

The B6 section-8 mechanism (demonstrated in 0133, 0142, 0162) runs a
FOURTH time.  The 2026-10-27 catalogue pull (as_of 2026-10-27, 33
records) shows SIX new framework-verified, MERGED records since the
2026-10-24 sweep, every one strictly stronger than [Z78C]:
PR #70 lewko-acyclic-bootstrap 0.874772906; PR #71
slayer-recost 0.87477290596; PR #73 arvi-repeated-marks 0.8747289;
PR #74 sil-fourth-power 0.8746935 ([S30] = Z78Sil30); PR #76
arvi-repeated-marks-on-sil-face 0.8746075 ([A31] = Z78Arvi31);
PR #83 sil-density-split 0.873995 ([S32] = Z78Sil32) - the current
BOARD BEST, merged 2026-10-27 06:11Z.  This program second-party
replayed #74/#76/#83 in full (Stage C: independent per-module kernel
compilation, 478/478, 699/699, 537/537 modules clean; Stage D:
canonical statement at the exact rational, axiom audit, 0 sorry;
dependency trees byte-identical to the 0148 frozen replay copies -
see the three module headers for the complete provenance records).
[Z78SIL32] (record sil-density-split-20261026, Sil; a density-split
common-divisor bootstrap on the fourth-power source face) is the
strongest: the all-Dirichlet zero-free half-plane at
sil32Upper = 174799/200000 = 0.873995, a STRICT STRENGTHENING of
[Z78C] (extSil32a_implies_extCollet; transitively of [Z78G],
[Z78T], [Z78L], [Z78] - and of [S30]/[A31]).  Zeros of an actual
set sit in [1 - sil32Upper, sil32Upper], so every off-pair
satisfies d0 <= sil32D0max = sil32Upper - 1/2 = 74799/200000 =
0.373995 < colletD0max (offPairD0leSil32, sharp).  The open face
shrinks from (0, colletD0max] to (0, sil32D0max], the
[Z78SIL32]-sharp strip interior, and the slice (sil32D0max,
colletD0max] of the B16 face is closed IN BODY from [Z78SIL32]
itself.  The step removes colletD0max - sil32D0max =
7.779897e-4 of face width - the LARGEST in-tree face shrink of
this program (21.8x the 0162 step of 3.57103e-5).  No RH claim:
the face is a zero-exclusion statement in the unverified region;
the input class is unchanged in kind - an external zero-free
half-plane, still 0.373995 away from 1/2 - and the chain stays a
REPEATABLE MECHANISM (B6 packet section 8, now demonstrated on a
FOURTH supersession): a newer verified snapshot of the tracker
frontier supersedes this part mechanically.
-/

/--  B17.1  THE  OUTER  SLICE  OF  THE  B16  FACE  IS  CLOSED  IN
    BODY  FROM  [Z78SIL32]:  for  an  actual-set  zero  set,  no
    off-pair with  d0  >  sil32D0max  (of  any  height  t0  >  0):
    offPairD0leSil32  already  bounds  every  off-pair  to
    d0  <=  sil32D0max.  In  particular  the  slice
    (sil32D0max,  colletD0max]  of  the  B16  face  --  and  a
    fortiori  (sil32D0max,  gaoD0max],  (sil32D0max,  qxD0max],
    (sil32D0max,  liuD0max],  (sil32D0max,  3/8]  --  needs  no
    face  at  all.  No  RH  claim.  -/
theorem rhend_sliceSil32Excl (q : ZeroSet)
    (hz32 : Z78Sil32.externalZeroFree78Sil32)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0)
    (t0 d0 : ℝ) (ht0 : 0 < t0) (hd0 : 0 < d0)
    (hC : Z78Sil32.sil32D0max < d0) :
    ¬ offPair q t0 d0 := by
  intro hp
  have hle := Z78Sil32.offPairD0leSil32 q hz32 hqz t0 d0 ht0 hd0 hp
  linarith

/--  B17.2  THE  DENSITY-SPLIT-UNIFIED  ENDPOINT:  the  B12
    endpoint  with  the  external  input  upgraded
    [Z78]  ->  [Z78SIL32]  and  the  face  shrunk  to  0  <  d0
    <=  sil32D0max  (the  [Z78SIL32]-sharp  strip  interior,
    sil32D0max = 74799/200000 = 0.373995).  Above  H,  any
    off-pair  has  d0  <=  sil32D0max  BY  [Z78SIL32]
    (offPairD0leSil32)  before  the  face  is  applied  -  the
    d0  <=  1/2  split  of  B11  stays  away  in  the  S1/S3
    legs  and  in  the  S4-covered  leg;  the  far  region  (d0
    >  1/2)  is  closed  by  the  [Z78]  derived  from
    [Z78SIL32].  No  RH  claim.  -/
theorem rh_program78_stripfront_mach_unifiedSil32 (q : ZeroSet)
    (hz32 : Z78Sil32.externalZeroFree78Sil32)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0)
    (honline : ∀ ρ ∈ q.Z, 0 < (|ρ.im| : ℝ) → (|ρ.im| : ℝ) <
      (707 : ℝ) / 50 → ρ.re = 1 / 2)
    (Qside : ℝ × ℝ → ℝ)
    (H : ℝ) (hH : 1000 ≤ H)
    (hPT : WinC.allOnLineUpTo q H)
    (hOffC : ∀ (t0 d0 : ℝ), H ≤ t0 → 0 < d0 →
      d0 ≤ Z78Sil32.sil32D0max → ¬ offPair q t0 d0) :
    RH q := by
  have hz78 : Z78.externalZeroFree78 := Z78Sil32.extSil32a_implies_ext78 hz32
  refine S4A.rh_from_regime_closures q Qside Z78P12.MfP devProg
    Z78P12.BwireP (fun p => MrLift p.1 p.2) floProg
    ?_ ?_ ?_ ?_ ?_ ?_
  · --  S1  witness  leg:  below  H  =  vacuous  (the  record);
      --  above  H:  [Z78SIL32]  bounds  d0  to  colletD0max,  the  face
      --  kills.
    intro t0 d0 ht0 hd0 hp
    by_cases hle : t0 ≤ H
    · exact False.elim ((WinC.noOffLineBelowPT q H hPT t0
        (le_of_lt ht0) hle) d0 hp)
    · have hL : d0 ≤ Z78Sil32.sil32D0max :=
        Z78Sil32.offPairD0leSil32 q hz32 hqz t0 d0 ht0 hd0 hp
      exact False.elim ((hOffC t0 d0
        (le_of_lt (not_le.mp hle)) hd0 hL) hp)
  · --  S2  leg:  covered  =  in  body;  low  band  =  vacuous
      --  below  H;  far  =  [Z78]  (from  [Z78SIL32]).
    intro t0 d0 ht0 hd0 hp
    by_cases hd0h : d0 ≤ (1 / 2 : ℝ)
    · by_cases ht0k : 1000 ≤ t0
      · exact hs2_covered q honline t0 d0 ht0 ht0k hd0 hd0h hp
      · have hle : t0 ≤ H := le_trans (le_of_lt (not_le.mp ht0k)) hH
        exact False.elim ((WinC.noOffLineBelowPT q H hPT t0
          (le_of_lt ht0) hle) d0 hp)
    · exact False.elim (Z78P12.offPairFarEmpty q hz78 hqz t0 d0
        (not_le.mp hd0h) hp)
  · --  S3  leg:  below  H  =  vacuous  (the  record);  above  H:
      --  [Z78SIL32]  bounds  d0  to  colletD0max,  the  face  kills.
    intro t0 d0 ht0 hd0 hp
    by_cases hle : t0 ≤ H
    · exact False.elim ((WinC.noOffLineBelowPT q H hPT t0
        (le_of_lt ht0) hle) d0 hp)
    · have hL : d0 ≤ Z78Sil32.sil32D0max :=
        Z78Sil32.offPairD0leSil32 q hz32 hqz t0 d0 ht0 hd0 hp
      exact False.elim ((hOffC t0 d0
        (le_of_lt (not_le.mp hle)) hd0 hL) hp)
  · --  S4  covered:  below  H  =  vacuous  (the  record);
      --  above  H:  [Z78SIL32]  bounds  d0  to  colletD0max,  the  face
      --  kills.
    intro t0 d0 ht0 hd0 hd0u hp
    by_cases hle : t0 ≤ H
    · exact False.elim ((WinC.noOffLineBelowPT q H hPT t0
        (by linarith [ht0]) hle) d0 hp)
    · have hL : d0 ≤ Z78Sil32.sil32D0max :=
        Z78Sil32.offPairD0leSil32 q hz32 hqz t0 d0
        (show 0 < t0 from by linarith [ht0]) hd0 hp
      exact False.elim ((hOffC t0 d0
        (le_of_lt (not_le.mp hle)) hd0 hL) hp)
  · --  S4  low:  covered  low  band  below  H;  the  d0  <= 1/2  part
      --  of  the  low  band  is  vacuous  (the  record)  below  H;
      --  above  H  the  face  covers  (colletD0max  <  1/2).
    intro t0 d0 ht0 ht0u hd0 hd0u hp
    by_cases hle : t0 ≤ H
    · exact False.elim ((WinC.noOffLineBelowPT q H hPT t0
        (le_of_lt ht0) hle) d0 hp)
    · have hL : d0 ≤ Z78Sil32.sil32D0max :=
        Z78Sil32.offPairD0leSil32 q hz32 hqz t0 d0 ht0 hd0 hp
      exact False.elim ((hOffC t0 d0
        (le_of_lt (not_le.mp hle)) hd0 hL) hp)
  · --  S4  far:  [Z78]  (from  [Z78SIL32]).
    intro t0 d0 ht0 hd0 hd0f hp
    exact False.elim (Z78P12.offPairFarEmpty q hz78 hqz t0 d0
      hd0f hp)

/--  B17.3  THE  DENSITY-SPLIT  ENDPOINT  AT  THE  PLATT-TRUDGIAN
    FRONTIER  (the  [Z-PT2]  instantiation):  the  entire  named
    residue  lives  STRICTLY  ABOVE  3,000,175,332,800,  as  ONE
    zero-exclusion  face  (no  off-pair  in  0  <  d0  <=
    sil32D0max  above  the  frontier  -  the  [Z78SIL32]-sharp
    strip  interior)  plus  [Z78SIL32]  itself  (which  closes
    d0  >  sil32D0max  in  body).  No  RH  claim.  -/
theorem rh_program78_stripfront_mach_unifiedSil32_PT2 (q : ZeroSet)
    (hz32 : Z78Sil32.externalZeroFree78Sil32)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0)
    (honline : ∀ ρ ∈ q.Z, 0 < (|ρ.im| : ℝ) → (|ρ.im| : ℝ) <
      (707 : ℝ) / 50 → ρ.re = 1 / 2)
    (Qside : ℝ × ℝ → ℝ)
    (hPT2 : WinC.allOnLineUpTo q WinC.tPT2)
    (hOffCPT2 : ∀ (t0 d0 : ℝ), WinC.tPT2 ≤ t0 → 0 < d0 →
      d0 ≤ Z78Sil32.sil32D0max → ¬ offPair q t0 d0) :
    RH q :=
  rh_program78_stripfront_mach_unifiedSil32 q hz32 hqz honline Qside
    WinC.tPT2 (by norm_num [WinC.tPT2]) hPT2 hOffCPT2

/--  B17.4  THE  0142  GA  O  ENDPOINT  AS  A  THEOREM  OF  THE
    [Z78SIL32]  ENDPOINT  (in  body):  given  the  [Z78SIL32]
    input  and  its  terminal  face  hOffC  on  0  <  d0  <=
    sil32D0max,  the  older  five-step-form  endpoint  follows
    --  the  gao  face  (0  <  d0  <=  gaoD0max)  splits  into
    the  sil32D0max  half  (the  hOffC  face)  and  the  slice
    (sil32D0max,  gaoD0max]  (closed  in  body  from
    [Z78SIL32]).  The  0142  terminal  statement  is  thus  a
    THEOREM  of  the  B17  one.  No  RH  claim.  -/
theorem rh_program78_stripfront_mach_unifiedGao_ofSil32 (q : ZeroSet)
    (hz32 : Z78Sil32.externalZeroFree78Sil32)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0)
    (honline : ∀ ρ ∈ q.Z, 0 < (|ρ.im| : ℝ) → (|ρ.im| : ℝ) <
      (707 : ℝ) / 50 → ρ.re = 1 / 2)
    (Qside : ℝ × ℝ → ℝ)
    (H : ℝ) (hH : 1000 ≤ H)
    (hPT : WinC.allOnLineUpTo q H)
    (hOffC : ∀ (t0 d0 : ℝ), H ≤ t0 → 0 < d0 →
      d0 ≤ Z78Sil32.sil32D0max → ¬ offPair q t0 d0) :
    RH q := by
  have hzG : Z78Gao.externalZeroFree78Gao :=
    Z78Sil32.extSil32a_implies_extGao hz32
  apply rh_program78_stripfront_mach_unifiedGao q hzG hqz
    honline Qside H hH hPT
  intro t0 d0 ht0 hd0 hd0G hp
  by_cases hleC : d0 ≤ Z78Sil32.sil32D0max
  · exact False.elim ((hOffC t0 d0 ht0 hd0 hleC) hp)
  · exact False.elim (rhend_sliceSil32Excl q hz32 hqz t0 d0
      (by linarith [ht0, hH]) hd0 (not_le.mp hleC) hp)

/--  B17.5  THE  [Z-PT2]  INSTANCE  OF  B17.4  (the  0142
    terminal  statement  at  tPT2  is  a  theorem  of  the  B17
    endpoint  with  the  [Z-PT2]  record).  No  RH  claim.  -/
theorem rh_program78_stripfront_mach_unifiedGao_PT2_ofSil32 (q : ZeroSet)
    (hz32 : Z78Sil32.externalZeroFree78Sil32)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0)
    (honline : ∀ ρ ∈ q.Z, 0 < (|ρ.im| : ℝ) → (|ρ.im| : ℝ) <
      (707 : ℝ) / 50 → ρ.re = 1 / 2)
    (Qside : ℝ × ℝ → ℝ)
    (hPT2 : WinC.allOnLineUpTo q WinC.tPT2)
    (hOffCPT2 : ∀ (t0 d0 : ℝ), WinC.tPT2 ≤ t0 → 0 < d0 →
      d0 ≤ Z78Sil32.sil32D0max → ¬ offPair q t0 d0) :
    RH q :=
  rh_program78_stripfront_mach_unifiedGao_ofSil32 q hz32 hqz
    honline Qside WinC.tPT2 (by norm_num [WinC.tPT2]) hPT2
    hOffCPT2



/-!  -/

/-!
**Part B18 - the tracker board moved AGAIN: [Z78FineChain] supersedes
[Z78FineChain] (and, with it, the 2026-10-27 frontier map).**

The B6 section-8 mechanism (demonstrated in 0133, 0142, 0162, 0195) runs a
FIFTH time.  The 2026-10-28 catalogue pull (as_of 2026-10-28, 35 records)
shows TWO new framework-verified, MERGED records since the 2026-10-27
sweep: PR #84 density-split-third 0.873985 (Rohan Arun, merged
2026-10-27 14:48Z) and PR #86 density-split-fine-chain 0.8739558 (Jacob
Sussman, AI-assisted (Claude), merged 2026-10-28 04:30Z) - the latter the
current BOARD BEST.  This program second-party replayed #86 in full
(Stage C: independent per-module kernel compilation, 93/93 modules clean;
Stage D: canonical statement at the exact rational, axiom audit, zeta
consequence, 0 sorry; all five dependency trees byte-identical to the
frozen 0195 replay copies - see the module header for the complete
provenance record).  #84 is strictly subsumed by #86 (0.873985 >
0.8739558: its face d0 <= 74797/200000 contains fineChainD0max) and is
not adopted separately.  [Z78FineChain] (record density-split-fine-chain;
Sil's density-split bootstrap with a 30-native-step + 46-transition
source chain and retuned all-shift return) is the strongest: the
all-Dirichlet zero-free half-plane at fineChainUpper = 4369779/5000000 =
0.8739558, a STRICT STRENGTHENING of [Z78SIL32] (extFineChain_implies_
extSil32; transitively of [Z78C], [Z78G], [Z78T], [Z78L], [Z78]).
Zeros of an actual set sit in [1 - fineChainUpper, fineChainUpper], so
every off-pair satisfies d0 <= fineChainD0max = fineChainUpper - 1/2 =
1869779/5000000 = 0.3739558 < sil32D0max (offPairD0leFineChain, sharp).
The open face shrinks from (0, sil32D0max] to (0, fineChainD0max], the
[Z78FineChain]-sharp strip interior, and the slice (fineChainD0max,
fineChainD0max] of the B17 face - which includes the entire face of the
subsumed #84 record - is closed IN BODY from [Z78FineChain] itself.
The step removes sil32D0max - fineChainD0max = 196/5000000 = 3.92e-5 of
face width.  No RH claim: the face is a zero-exclusion statement in the
unverified region; the input class is unchanged in kind - an external
zero-free half-plane, still 0.3739558 away from 1/2 - and the chain
stays a REPEATABLE MECHANISM (B6 packet section 8, now demonstrated on a
FIFTH supersession): a newer verified snapshot of the tracker frontier
supersedes this part mechanically.
-/

/--  B18.1  THE  OUTER  SLICE  OF  THE  pre-B17  FACE  IS  CLOSED  IN
    BODY  FROM  [Z78FineChain]:  for  an  actual-set  zero  set,  no
    off-pair with  d0  >  fineChainD0max  (of  any  height  t0  >  0):
    offPairD0leFineChain  already  bounds  every  off-pair  to
    d0  <=  fineChainD0max.  In  particular  the  slice
    (fineChainD0max,  sil32D0max]  of  the pre-B17 face  --  and  a
    fortiori  (fineChainD0max,  gaoD0max],  (fineChainD0max,  qxD0max],
    (fineChainD0max,  liuD0max],  (fineChainD0max,  3/8]  --  needs  no
    face  at  all.  No  RH  claim.  -/
theorem rhend_sliceFineChainExcl (q : ZeroSet)
    (hzF : Z78FineChain.externalZeroFree78FineChain)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0)
    (t0 d0 : ℝ) (ht0 : 0 < t0) (hd0 : 0 < d0)
    (hC : Z78FineChain.fineChainD0max < d0) :
    ¬ offPair q t0 d0 := by
  intro hp
  have hle := Z78FineChain.offPairD0leFineChain q hzF hqz t0 d0 ht0 hd0 hp
  linarith

/--  B18.2  THE  DENSITY-SPLIT-UNIFIED  ENDPOINT:  the  B12
    endpoint  with  the  external  input  upgraded
    [Z78]  ->  [Z78FineChain]  and  the  face  shrunk  to  0  <  d0
    <=  fineChainD0max  (the  [Z78FineChain]-sharp  strip  interior,
    fineChainD0max = 1869779/5000000 = 0.3739558).  Above  H,  any
    off-pair  has  d0  <=  fineChainD0max  BY  [Z78FineChain]
    (offPairD0leFineChain)  before  the  face  is  applied  -  the
    d0  <=  1/2  split  of  B11  stays  away  in  the  S1/S3
    legs  and  in  the  S4-covered  leg;  the  far  region  (d0
    >  1/2)  is  closed  by  the  [Z78]  derived  from
    [Z78FineChain].  No  RH  claim.  -/
theorem rh_program78_stripfront_mach_unifiedFineChain (q : ZeroSet)
    (hzF : Z78FineChain.externalZeroFree78FineChain)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0)
    (honline : ∀ ρ ∈ q.Z, 0 < (|ρ.im| : ℝ) → (|ρ.im| : ℝ) <
      (707 : ℝ) / 50 → ρ.re = 1 / 2)
    (Qside : ℝ × ℝ → ℝ)
    (H : ℝ) (hH : 1000 ≤ H)
    (hPT : WinC.allOnLineUpTo q H)
    (hOffC : ∀ (t0 d0 : ℝ), H ≤ t0 → 0 < d0 →
      d0 ≤ Z78FineChain.fineChainD0max → ¬ offPair q t0 d0) :
    RH q := by
  have hz78 : Z78.externalZeroFree78 := Z78FineChain.extFineChain_implies_ext78 hzF
  refine S4A.rh_from_regime_closures q Qside Z78P12.MfP devProg
    Z78P12.BwireP (fun p => MrLift p.1 p.2) floProg
    ?_ ?_ ?_ ?_ ?_ ?_
  · --  S1  witness  leg:  below  H  =  vacuous  (the  record);
      --  above  H:  [Z78FineChain]  bounds  d0  to  fineChainD0max,  the  face
      --  kills.
    intro t0 d0 ht0 hd0 hp
    by_cases hle : t0 ≤ H
    · exact False.elim ((WinC.noOffLineBelowPT q H hPT t0
        (le_of_lt ht0) hle) d0 hp)
    · have hL : d0 ≤ Z78FineChain.fineChainD0max :=
        Z78FineChain.offPairD0leFineChain q hzF hqz t0 d0 ht0 hd0 hp
      exact False.elim ((hOffC t0 d0
        (le_of_lt (not_le.mp hle)) hd0 hL) hp)
  · --  S2  leg:  covered  =  in  body;  low  band  =  vacuous
      --  below  H;  far  =  [Z78]  (from  [Z78FineChain]).
    intro t0 d0 ht0 hd0 hp
    by_cases hd0h : d0 ≤ (1 / 2 : ℝ)
    · by_cases ht0k : 1000 ≤ t0
      · exact hs2_covered q honline t0 d0 ht0 ht0k hd0 hd0h hp
      · have hle : t0 ≤ H := le_trans (le_of_lt (not_le.mp ht0k)) hH
        exact False.elim ((WinC.noOffLineBelowPT q H hPT t0
          (le_of_lt ht0) hle) d0 hp)
    · exact False.elim (Z78P12.offPairFarEmpty q hz78 hqz t0 d0
        (not_le.mp hd0h) hp)
  · --  S3  leg:  below  H  =  vacuous  (the  record);  above  H:
      --  [Z78FineChain]  bounds  d0  to  fineChainD0max,  the  face  kills.
    intro t0 d0 ht0 hd0 hp
    by_cases hle : t0 ≤ H
    · exact False.elim ((WinC.noOffLineBelowPT q H hPT t0
        (le_of_lt ht0) hle) d0 hp)
    · have hL : d0 ≤ Z78FineChain.fineChainD0max :=
        Z78FineChain.offPairD0leFineChain q hzF hqz t0 d0 ht0 hd0 hp
      exact False.elim ((hOffC t0 d0
        (le_of_lt (not_le.mp hle)) hd0 hL) hp)
  · --  S4  covered:  below  H  =  vacuous  (the  record);
      --  above  H:  [Z78FineChain]  bounds  d0  to  fineChainD0max,  the  face
      --  kills.
    intro t0 d0 ht0 hd0 hd0u hp
    by_cases hle : t0 ≤ H
    · exact False.elim ((WinC.noOffLineBelowPT q H hPT t0
        (by linarith [ht0]) hle) d0 hp)
    · have hL : d0 ≤ Z78FineChain.fineChainD0max :=
        Z78FineChain.offPairD0leFineChain q hzF hqz t0 d0
        (show 0 < t0 from by linarith [ht0]) hd0 hp
      exact False.elim ((hOffC t0 d0
        (le_of_lt (not_le.mp hle)) hd0 hL) hp)
  · --  S4  low:  covered  low  band  below  H;  the  d0  <= 1/2  part
      --  of  the  low  band  is  vacuous  (the  record)  below  H;
      --  above  H  the  face  covers  (colletD0max  <  1/2).
    intro t0 d0 ht0 ht0u hd0 hd0u hp
    by_cases hle : t0 ≤ H
    · exact False.elim ((WinC.noOffLineBelowPT q H hPT t0
        (le_of_lt ht0) hle) d0 hp)
    · have hL : d0 ≤ Z78FineChain.fineChainD0max :=
        Z78FineChain.offPairD0leFineChain q hzF hqz t0 d0 ht0 hd0 hp
      exact False.elim ((hOffC t0 d0
        (le_of_lt (not_le.mp hle)) hd0 hL) hp)
  · --  S4  far:  [Z78]  (from  [Z78FineChain]).
    intro t0 d0 ht0 hd0 hd0f hp
    exact False.elim (Z78P12.offPairFarEmpty q hz78 hqz t0 d0
      hd0f hp)

/--  B18.3  THE  DENSITY-SPLIT  ENDPOINT  AT  THE  PLATT-TRUDGIAN
    FRONTIER  (the  [Z-PT2]  instantiation):  the  entire  named
    residue  lives  STRICTLY  ABOVE  3,000,175,332,800,  as  ONE
    zero-exclusion  face  (no  off-pair  in  0  <  d0  <=
    fineChainD0max  above  the  frontier  -  the  [Z78FineChain]-sharp
    strip  interior)  plus  [Z78FineChain]  itself  (which  closes
    d0  >  fineChainD0max  in  body).  No  RH  claim.  -/
theorem rh_program78_stripfront_mach_unifiedFineChain_PT2 (q : ZeroSet)
    (hzF : Z78FineChain.externalZeroFree78FineChain)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0)
    (honline : ∀ ρ ∈ q.Z, 0 < (|ρ.im| : ℝ) → (|ρ.im| : ℝ) <
      (707 : ℝ) / 50 → ρ.re = 1 / 2)
    (Qside : ℝ × ℝ → ℝ)
    (hPT2 : WinC.allOnLineUpTo q WinC.tPT2)
    (hOffCPT2 : ∀ (t0 d0 : ℝ), WinC.tPT2 ≤ t0 → 0 < d0 →
      d0 ≤ Z78FineChain.fineChainD0max → ¬ offPair q t0 d0) :
    RH q :=
  rh_program78_stripfront_mach_unifiedFineChain q hzF hqz honline Qside
    WinC.tPT2 (by norm_num [WinC.tPT2]) hPT2 hOffCPT2

/--  B18.4  THE  0142  GA  O  ENDPOINT  AS  A  THEOREM  OF  THE
    [Z78FineChain]  ENDPOINT  (in  body):  given  the  [Z78FineChain]
    input  and  its  terminal  face  hOffC  on  0  <  d0  <=
    fineChainD0max,  the  older  five-step-form  endpoint  follows
    --  the  gao  face  (0  <  d0  <=  gaoD0max)  splits  into
    the  fineChainD0max  half  (the  hOffC  face)  and  the  slice
    (fineChainD0max,  gaoD0max]  (closed  in  body  from
    [Z78FineChain]).  The  0142  terminal  statement  is  thus  a
    THEOREM  of  the  B18  one.  No  RH  claim.  -/
theorem rh_program78_stripfront_mach_unifiedGao_ofFineChain (q : ZeroSet)
    (hzF : Z78FineChain.externalZeroFree78FineChain)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0)
    (honline : ∀ ρ ∈ q.Z, 0 < (|ρ.im| : ℝ) → (|ρ.im| : ℝ) <
      (707 : ℝ) / 50 → ρ.re = 1 / 2)
    (Qside : ℝ × ℝ → ℝ)
    (H : ℝ) (hH : 1000 ≤ H)
    (hPT : WinC.allOnLineUpTo q H)
    (hOffC : ∀ (t0 d0 : ℝ), H ≤ t0 → 0 < d0 →
      d0 ≤ Z78FineChain.fineChainD0max → ¬ offPair q t0 d0) :
    RH q := by
  have hzG : Z78Gao.externalZeroFree78Gao :=
    Z78FineChain.extFineChain_implies_extGao hzF
  apply rh_program78_stripfront_mach_unifiedGao q hzG hqz
    honline Qside H hH hPT
  intro t0 d0 ht0 hd0 hd0G hp
  by_cases hleC : d0 ≤ Z78FineChain.fineChainD0max
  · exact False.elim ((hOffC t0 d0 ht0 hd0 hleC) hp)
  · exact False.elim (rhend_sliceFineChainExcl q hzF hqz t0 d0
      (by linarith [ht0, hH]) hd0 (not_le.mp hleC) hp)

/--  B18.5  THE  [Z-PT2]  INSTANCE  OF  B18.4  (the  0142
    terminal  statement  at  tPT2  is  a  theorem  of  the  B18
    endpoint  with  the  [Z-PT2]  record).  No  RH  claim.  -/
theorem rh_program78_stripfront_mach_unifiedGao_PT2_ofFineChain (q : ZeroSet)
    (hzF : Z78FineChain.externalZeroFree78FineChain)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0)
    (honline : ∀ ρ ∈ q.Z, 0 < (|ρ.im| : ℝ) → (|ρ.im| : ℝ) <
      (707 : ℝ) / 50 → ρ.re = 1 / 2)
    (Qside : ℝ × ℝ → ℝ)
    (hPT2 : WinC.allOnLineUpTo q WinC.tPT2)
    (hOffCPT2 : ∀ (t0 d0 : ℝ), WinC.tPT2 ≤ t0 → 0 < d0 →
      d0 ≤ Z78FineChain.fineChainD0max → ¬ offPair q t0 d0) :
    RH q :=
  rh_program78_stripfront_mach_unifiedGao_ofFineChain q hzF hqz
    honline Qside WinC.tPT2 (by norm_num [WinC.tPT2]) hPT2
    hOffCPT2

/-!
**Part B19 - the tracker board moved AGAIN: [Z78DensityRefined]
supersedes [Z78FineChain] (and, with it, the 2026-10-28 morning frontier
map).**

The B6 section-8 mechanism (demonstrated in 0133, 0142, 0162, 0195, 0200)
runs a SIXTH time.  The 2026-10-28 evening catalogue pull (as_of 2026-10-28,
37 records + 1 historical) shows TWO new framework-verified, MERGED records
since the 0200 snapshot: PR #85 density-split-fourth 0.873981 (Rohan Arun,
merged 2026-10-28 10:29Z) - strictly WEAKER than [Z78FineChain]
(0.873981 > 0.8739558), subsumed, NOT adopted - and PR #90
density-refined 0.8739461 (SovereignSteak, AI-assisted (OpenAI Codex),
merged 2026-10-28 19:48Z) - the current BOARD BEST.  This program
second-party replayed #90 in full (Stage C: independent per-module kernel
compilation, 119/119 modules clean; Stage D: canonical statement at the
exact rational, axiom audit, zeta consequence, 0 sorry; all six dependency
trees byte-identical to the frozen 0200 replay copies - see the module
header for the complete provenance record).  [Z78DensityRefined] (record
density-refined; the PR86 fine chain refined by 59 exact count-source
transitions, each decrementing Lambda by 1/400, on the widened density
interface of PR89, reaching
G(488842537/500000000, 4388001/2000000, 1/10)) is the strongest: the
all-Dirichlet zero-free half-plane at denRefinedUpper = 8739461/10000000 =
0.8739461, a STRICT STRENGTHENING of [Z78FineChain]
(extDenRefined_implies_extFineChain; transitively of [Z78SIL32], [Z78C],
[Z78G], [Z78T], [Z78L], [Z78]).  Zeros of an actual set sit in
[1 - denRefinedUpper, denRefinedUpper], so every off-pair satisfies
d0 <= denRefinedD0max = denRefinedUpper - 1/2 = 3739461/10000000 =
0.3739461 < fineChainD0max (offPairD0leDenRefined, sharp).  The open face
shrinks from (0, fineChainD0max] to (0, denRefinedD0max], the
[Z78DensityRefined]-sharp strip interior, and the slice
(denRefinedD0max, fineChainD0max] of the B18 face is closed IN BODY from
[Z78DensityRefined] itself.  The step removes fineChainD0max -
denRefinedD0max = 97/10000000 = 9.7e-6 of face width.  No RH claim: the
face is a zero-exclusion statement in the unverified region; the input
class is unchanged in kind - an external zero-free half-plane, still
0.3739461 away from 1/2 - and the chain stays a REPEATABLE MECHANISM (B6
packet section 8, now demonstrated on a SIXTH supersession): a newer
verified snapshot of the tracker frontier supersedes this part
mechanically.
-/

/--  B19.1  THE  OUTER  SLICE  OF  THE  pre-B17  FACE  IS  CLOSED  IN
    BODY  FROM  [Z78DensityRefined]:  for  an  actual-set  zero  set,  no
    off-pair with  d0  >  denRefinedD0max  (of  any  height  t0  >  0):
    offPairD0leDenRefined  already  bounds  every  off-pair  to
    d0  <=  denRefinedD0max.  In  particular  the  slice
    (denRefinedD0max,  fineChainD0max]  of  the pre-B19 face  --  and  a
    fortiori  (denRefinedD0max,  gaoD0max],  (denRefinedD0max,  qxD0max],
    (denRefinedD0max,  liuD0max],  (denRefinedD0max,  3/8]  --  needs  no
    face  at  all.  No  RH  claim.  -/
theorem rhend_sliceDensityRefinedExcl (q : ZeroSet)
    (hzF : Z78DensityRefined.externalZeroFree78DenRefined)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0)
    (t0 d0 : ℝ) (ht0 : 0 < t0) (hd0 : 0 < d0)
    (hC : Z78DensityRefined.denRefinedD0max < d0) :
    ¬ offPair q t0 d0 := by
  intro hp
  have hle := Z78DensityRefined.offPairD0leDenRefined q hzF hqz t0 d0 ht0 hd0 hp
  linarith

/--  B19.2  THE  DENSITY-SPLIT-UNIFIED  ENDPOINT:  the  B12
    endpoint  with  the  external  input  upgraded
    [Z78]  ->  [Z78DensityRefined]  and  the  face  shrunk  to  0  <  d0
    <=  denRefinedD0max  (the  [Z78DensityRefined]-sharp  strip  interior,
    denRefinedD0max = 3739461/10000000 = 0.3739461).  Above  H,  any
    off-pair  has  d0  <=  denRefinedD0max  BY  [Z78DensityRefined]
    (offPairD0leDenRefined)  before  the  face  is  applied  -  the
    d0  <=  1/2  split  of  B11  stays  away  in  the  S1/S3
    legs  and  in  the  S4-covered  leg;  the  far  region  (d0
    >  1/2)  is  closed  by  the  [Z78]  derived  from
    [Z78DensityRefined].  No  RH  claim.  -/
theorem rh_program78_stripfront_mach_unifiedDenRefined (q : ZeroSet)
    (hzF : Z78DensityRefined.externalZeroFree78DenRefined)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0)
    (honline : ∀ ρ ∈ q.Z, 0 < (|ρ.im| : ℝ) → (|ρ.im| : ℝ) <
      (707 : ℝ) / 50 → ρ.re = 1 / 2)
    (Qside : ℝ × ℝ → ℝ)
    (H : ℝ) (hH : 1000 ≤ H)
    (hPT : WinC.allOnLineUpTo q H)
    (hOffC : ∀ (t0 d0 : ℝ), H ≤ t0 → 0 < d0 →
      d0 ≤ Z78DensityRefined.denRefinedD0max → ¬ offPair q t0 d0) :
    RH q := by
  have hz78 : Z78.externalZeroFree78 := Z78DensityRefined.extDenRefined_implies_ext78 hzF
  refine S4A.rh_from_regime_closures q Qside Z78P12.MfP devProg
    Z78P12.BwireP (fun p => MrLift p.1 p.2) floProg
    ?_ ?_ ?_ ?_ ?_ ?_
  · --  S1  witness  leg:  below  H  =  vacuous  (the  record);
      --  above  H:  [Z78DensityRefined]  bounds  d0  to  denRefinedD0max,  the  face
      --  kills.
    intro t0 d0 ht0 hd0 hp
    by_cases hle : t0 ≤ H
    · exact False.elim ((WinC.noOffLineBelowPT q H hPT t0
        (le_of_lt ht0) hle) d0 hp)
    · have hL : d0 ≤ Z78DensityRefined.denRefinedD0max :=
        Z78DensityRefined.offPairD0leDenRefined q hzF hqz t0 d0 ht0 hd0 hp
      exact False.elim ((hOffC t0 d0
        (le_of_lt (not_le.mp hle)) hd0 hL) hp)
  · --  S2  leg:  covered  =  in  body;  low  band  =  vacuous
      --  below  H;  far  =  [Z78]  (from  [Z78DensityRefined]).
    intro t0 d0 ht0 hd0 hp
    by_cases hd0h : d0 ≤ (1 / 2 : ℝ)
    · by_cases ht0k : 1000 ≤ t0
      · exact hs2_covered q honline t0 d0 ht0 ht0k hd0 hd0h hp
      · have hle : t0 ≤ H := le_trans (le_of_lt (not_le.mp ht0k)) hH
        exact False.elim ((WinC.noOffLineBelowPT q H hPT t0
          (le_of_lt ht0) hle) d0 hp)
    · exact False.elim (Z78P12.offPairFarEmpty q hz78 hqz t0 d0
        (not_le.mp hd0h) hp)
  · --  S3  leg:  below  H  =  vacuous  (the  record);  above  H:
      --  [Z78DensityRefined]  bounds  d0  to  denRefinedD0max,  the  face  kills.
    intro t0 d0 ht0 hd0 hp
    by_cases hle : t0 ≤ H
    · exact False.elim ((WinC.noOffLineBelowPT q H hPT t0
        (le_of_lt ht0) hle) d0 hp)
    · have hL : d0 ≤ Z78DensityRefined.denRefinedD0max :=
        Z78DensityRefined.offPairD0leDenRefined q hzF hqz t0 d0 ht0 hd0 hp
      exact False.elim ((hOffC t0 d0
        (le_of_lt (not_le.mp hle)) hd0 hL) hp)
  · --  S4  covered:  below  H  =  vacuous  (the  record);
      --  above  H:  [Z78DensityRefined]  bounds  d0  to  denRefinedD0max,  the  face
      --  kills.
    intro t0 d0 ht0 hd0 hd0u hp
    by_cases hle : t0 ≤ H
    · exact False.elim ((WinC.noOffLineBelowPT q H hPT t0
        (by linarith [ht0]) hle) d0 hp)
    · have hL : d0 ≤ Z78DensityRefined.denRefinedD0max :=
        Z78DensityRefined.offPairD0leDenRefined q hzF hqz t0 d0
        (show 0 < t0 from by linarith [ht0]) hd0 hp
      exact False.elim ((hOffC t0 d0
        (le_of_lt (not_le.mp hle)) hd0 hL) hp)
  · --  S4  low:  covered  low  band  below  H;  the  d0  <= 1/2  part
      --  of  the  low  band  is  vacuous  (the  record)  below  H;
      --  above  H  the  face  covers  (colletD0max  <  1/2).
    intro t0 d0 ht0 ht0u hd0 hd0u hp
    by_cases hle : t0 ≤ H
    · exact False.elim ((WinC.noOffLineBelowPT q H hPT t0
        (le_of_lt ht0) hle) d0 hp)
    · have hL : d0 ≤ Z78DensityRefined.denRefinedD0max :=
        Z78DensityRefined.offPairD0leDenRefined q hzF hqz t0 d0 ht0 hd0 hp
      exact False.elim ((hOffC t0 d0
        (le_of_lt (not_le.mp hle)) hd0 hL) hp)
  · --  S4  far:  [Z78]  (from  [Z78DensityRefined]).
    intro t0 d0 ht0 hd0 hd0f hp
    exact False.elim (Z78P12.offPairFarEmpty q hz78 hqz t0 d0
      hd0f hp)

/--  B19.3  THE  DENSITY-SPLIT  ENDPOINT  AT  THE  PLATT-TRUDGIAN
    FRONTIER  (the  [Z-PT2]  instantiation):  the  entire  named
    residue  lives  STRICTLY  ABOVE  3,000,175,332,800,  as  ONE
    zero-exclusion  face  (no  off-pair  in  0  <  d0  <=
    denRefinedD0max  above  the  frontier  -  the  [Z78DensityRefined]-sharp
    strip  interior)  plus  [Z78DensityRefined]  itself  (which  closes
    d0  >  denRefinedD0max  in  body).  No  RH  claim.  -/
theorem rh_program78_stripfront_mach_unifiedDenRefined_PT2 (q : ZeroSet)
    (hzF : Z78DensityRefined.externalZeroFree78DenRefined)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0)
    (honline : ∀ ρ ∈ q.Z, 0 < (|ρ.im| : ℝ) → (|ρ.im| : ℝ) <
      (707 : ℝ) / 50 → ρ.re = 1 / 2)
    (Qside : ℝ × ℝ → ℝ)
    (hPT2 : WinC.allOnLineUpTo q WinC.tPT2)
    (hOffCPT2 : ∀ (t0 d0 : ℝ), WinC.tPT2 ≤ t0 → 0 < d0 →
      d0 ≤ Z78DensityRefined.denRefinedD0max → ¬ offPair q t0 d0) :
    RH q :=
  rh_program78_stripfront_mach_unifiedDenRefined q hzF hqz honline Qside
    WinC.tPT2 (by norm_num [WinC.tPT2]) hPT2 hOffCPT2

/--  B19.4  THE  0142  GA  O  ENDPOINT  AS  A  THEOREM  OF  THE
    [Z78DensityRefined]  ENDPOINT  (in  body):  given  the  [Z78DensityRefined]
    input  and  its  terminal  face  hOffC  on  0  <  d0  <=
    denRefinedD0max,  the  older  five-step-form  endpoint  follows
    --  the  gao  face  (0  <  d0  <=  gaoD0max)  splits  into
    the  denRefinedD0max  half  (the  hOffC  face)  and  the  slice
    (denRefinedD0max,  gaoD0max]  (closed  in  body  from
    [Z78DensityRefined]).  The  0142  terminal  statement  is  thus  a
    THEOREM  of  the  B19  one.  No  RH  claim.  -/
theorem rh_program78_stripfront_mach_unifiedGao_ofDenRefined (q : ZeroSet)
    (hzF : Z78DensityRefined.externalZeroFree78DenRefined)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0)
    (honline : ∀ ρ ∈ q.Z, 0 < (|ρ.im| : ℝ) → (|ρ.im| : ℝ) <
      (707 : ℝ) / 50 → ρ.re = 1 / 2)
    (Qside : ℝ × ℝ → ℝ)
    (H : ℝ) (hH : 1000 ≤ H)
    (hPT : WinC.allOnLineUpTo q H)
    (hOffC : ∀ (t0 d0 : ℝ), H ≤ t0 → 0 < d0 →
      d0 ≤ Z78DensityRefined.denRefinedD0max → ¬ offPair q t0 d0) :
    RH q := by
  have hzG : Z78Gao.externalZeroFree78Gao :=
    Z78DensityRefined.extDenRefined_implies_extGao hzF
  apply rh_program78_stripfront_mach_unifiedGao q hzG hqz
    honline Qside H hH hPT
  intro t0 d0 ht0 hd0 hd0G hp
  by_cases hleC : d0 ≤ Z78DensityRefined.denRefinedD0max
  · exact False.elim ((hOffC t0 d0 ht0 hd0 hleC) hp)
  · exact False.elim (rhend_sliceDensityRefinedExcl q hzF hqz t0 d0
      (by linarith [ht0, hH]) hd0 (not_le.mp hleC) hp)

/--  B19.5  THE  [Z-PT2]  INSTANCE  OF  B19.4  (the  0142
    terminal  statement  at  tPT2  is  a  theorem  of  the  B19
    endpoint  with  the  [Z-PT2]  record).  No  RH  claim.  -/
theorem rh_program78_stripfront_mach_unifiedGao_PT2_ofDenRefined (q : ZeroSet)
    (hzF : Z78DensityRefined.externalZeroFree78DenRefined)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0)
    (honline : ∀ ρ ∈ q.Z, 0 < (|ρ.im| : ℝ) → (|ρ.im| : ℝ) <
      (707 : ℝ) / 50 → ρ.re = 1 / 2)
    (Qside : ℝ × ℝ → ℝ)
    (hPT2 : WinC.allOnLineUpTo q WinC.tPT2)
    (hOffCPT2 : ∀ (t0 d0 : ℝ), WinC.tPT2 ≤ t0 → 0 < d0 →
      d0 ≤ Z78DensityRefined.denRefinedD0max → ¬ offPair q t0 d0) :
    RH q :=
  rh_program78_stripfront_mach_unifiedGao_ofDenRefined q hzF hqz
    honline Qside WinC.tPT2 (by norm_num [WinC.tPT2]) hPT2
    hOffCPT2

/-!
**Part B20 - the A1 assembly face moved IN-TREE (0209): the endpoint's
external input surface is restated.**

Not a tracker event: no new board record has appeared since the B19
snapshot (live re-pull, as_of 2026-10-28, 37/37 records parsed; the
density-side board best is still [Z78DensityRefined] 0.8739461 - the
record this file's B19 endpoint is built on - so B6 does NOT fire).
What moved is the A1 lane of this program: the A1 assembly of
W2Beyond3 consumes a GRID-RESTRICTED clause (one uniform K for the
finite zero grid x 0 ... x M - that is its own signature), and 0209
closed that clause data-free at the certified 3e10 frontier:
`A1G.dn_defect_to_sbridge` reduces the clause to exactly the two
standing CITED theorems - (A) Trudgian (2012), A1G-5: |S u| <=
G_explicit u for u >= e, and (B) the Riemann-von Mann identity with
explicit residual: |DN j - S (x j) - 1/8| <= 1/x j (Titchmarsh Thm.
9.7-type; its 0204 in-tree object identity, whose exact 7/8 - 3/4
shift is `W2SAtZeros.rvmShiftCore`) - and `A1G.a1_grid_clause_exhibit`
exhibits the uniform K = 33206/5000 = 6.6412 on every grid point of
[4, 3e10], while `A1G.a1_zerofree_frontier` carries the full frontier
wire |S1Sum - RSum| < 16.  With the 0206-0208 premise-free numeric
pins (every numeric input of the data flank now proved in-tree,
TransNums/A1Growth), the A1 lane's external surface is exactly: two
peer-reviewed theorems + e < 4 (the module's standing one-line
analysis fact).  What remains NAMED and OPEN, and is NOT what the
W2Beyond3 assembly consumes, is the STRONGER absolute clause (one K
over ALL zeros, unbounded): `A1G.face_unbounded` proves the data-free
growth G outruns every K, and the literature scan (F1/F2) finds no
live theorem there.  No RH claim: the B19 endpoint's external input
(the zero-free half-plane record [Z78DensityRefined]) and its
terminal face hOffC on 0 < d0 <= 3739461/10000000 are unchanged by
this part; B20 is a state record, and the B6 mechanism (B6 packet
section 8) remains the named route for future board motion.
-/

/--  B20.1  THE  0209  A1  GRID  CLAUSE,  NAMED  IN  THE  RECORD:  the
    clause  the  W2Beyond3  A1  assembly  consumes  --  one  uniform
    K  over  the  zero  grid  --  holds  at  the  certified  3e10
    frontier  from  exactly  the  two  standing  CITED  theorems
    (Trudgian  A1G-5;  the  RvM  identity  with  explicit  residual)
    plus  e  <  4,  with  K  =  33206/5000  =  6.6412.  No  RH
    claim.  -/
theorem a1GridClauseNamed (M N0 : ℕ) (Nas x : ℕ → ℝ) (S : ℝ → ℝ)
    (hgrid : ∀ j ≤ M, 4 <= x j ∧ x j <= 30000000000)
    (hE : exp 1 < 4)
    (hRVM : ∀ j ≤ M, |W2T.DN N0 Nas j - S (x j) - 1/8| <= 1 / x j)
    (hTrudgian : ∀ u, exp 1 <= u -> |S u| <= A1G.G_explicit u) :
    ∃ K : ℝ, (∀ j ≤ M, |W2T.DN N0 Nas j| <= K) ∧
      K = (33206 : ℝ) / 5000 := by
  refine ⟨(33206 : ℝ) / 5000, ?_, rfl⟩
  simpa using A1G.a1_grid_clause_exhibit M N0 Nas x S hE hgrid hRVM hTrudgian

end RHEnd