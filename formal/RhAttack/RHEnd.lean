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
import RhAttack.P8Floor

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

end RHEnd
