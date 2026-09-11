/-
  BtF — the `B3Float` float layer for the B-3 bridge (outline pieces
  P6/P7): F, Fp (pair-kernel magnitude and its derivative in float64)
  plus the cross-check scaffolding — the Lean image of the float64
  kernel the TS engine evaluates. Not part of the proven set until
  the B-3 float cross-check lands (day-015 queue).
-/
namespace B3Float

def piF : Float := 3.141592653589793

def myAbs (x : Float) : Float := if x < 0 then -x else x
def myMax (a b : Float) : Float := if a < b then b else a

def F (t x : Float) : Float :=
    (1 : Float) / (2 * (x * x + (1 : Float) / 4)) +
      Float.log (1 - (t * t + (1 : Float) / 4) / (x * x + (1 : Float) / 4))

def Fp (t x : Float) : Float :=
    -x / (x * x + (1 : Float) / 4) ^ 2 +
      2 * x * (t * t + (1 : Float) / 4) /
        ((x * x + (1 : Float) / 4) * (x * x - t * t))

def nF (x : Float) : Float :=
    Float.log (x / (2 * piF)) / (2 * piF)

def NHatF (x : Float) : Float :=
    x / (2 * piF) * (Float.log (x / (2 * piF)) - 1) + (7 : Float) / 8

def sBarF (x : Float) : Float :=
    (0.110 : Float) * Float.log x + (0.290 : Float) * Float.log (Float.log x) +
      (2.290 : Float)

def BfF (t G : Float) : Float :=
    (1 : Float) / (2 * (G * G + (1 : Float) / 4)) +
      (t * t + (1 : Float) / 4) / (G * G + (1 : Float) / 4) /
        (1 - (t * t + (1 : Float) / 4) / (G * G + (1 : Float) / 4)) +
      t / (G * G + (1 : Float) / 4)

def CfF (t G : Float) : Float :=
    1 + 2 * (t * t + (1 : Float) / 4) * (G * G) / (G * G - t * t)

def KbarF (G : Float) : Float :=
    ((0.110 : Float) * (Float.log G + (1 : Float) / 2) +
        (0.290 : Float) * (Float.log (Float.log G) + (1 : Float) / 2) + (2.290 : Float)) /
      (2 * G * G)

/-- N_L(x) = #{g ∈ L : g ≤ x} (foldl counter — List-fold discipline). -/
def nListF (L : List Float) (x : Float) : Float :=
    L.foldl (fun (a : Float) g => a + (if g <= x then (1 : Float) else 0)) 0

-- 8-node Gauss–Legendre on [-1, 1] (standard table; exact for degree ≤ 15)
-- Table COMPUTED 2026-09-14 with mpmath-50dps (roots of P8,
-- w_i = 2/((1-x_i^2) P8'(x_i)^2)), verified against the moment
-- identites to 50 digits; the runtime glMomErr self-check (< 1e-12)
-- re-verifies it in Float64.  "constants computed, never recalled".
def gln : Array Float := #[
    -0.9602898564975363, -0.7966664774136267, -0.525532409916329, -0.1834346424956498,
     0.1834346424956498,  0.525532409916329,  0.7966664774136267,  0.9602898564975363]

def glw : Array Float := #[
     0.10122853629037626, 0.22238103445337448, 0.31370664587788727, 0.362683783378362,
     0.362683783378362,   0.31370664587788727, 0.22238103445337448, 0.10122853629037626]

/-- One 8-node Gauss–Legendre segment [a, b], composed over 8 sub-segments
    (composite order 16 for smooth integrands; no nodes beyond the table). -/
def glInt (a b : Float) (f : Float → Float) : Float :=
    let h := (b - a) / 8
    let seg (a0 : Float) : Float :=
      let m2 := h / 2
      let c  := a0 + h / 2
      (gln.zip glw).foldl (fun (s : Float) (x : Float × Float) =>
        s + m2 * x.2 * f (m2 * x.1 + c)) 0
    [1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0] |>.foldl (fun (acc : Float) k =>
      acc + seg (a + h * (k - 1))) 0

/-- Moment self-check of the table: |Σw − 2| + |Σwξ² − 2/3| + |Σwξ⁶ − 2/7|
    (odd moments vanish by symmetry; must be < 1e-12 in Float64). -/
def glMomErr : Float :=
    let (m0, m2, m6) := gln.zip glw |>.foldl (fun (acc : Float × Float × Float) (x : Float × Float) =>
      let (a, b, c) := acc
      let x2 := x.1 * x.1
      (a + x.2, b + x.2 * x2, c + x.2 * x2 * x2 * x2)) (0, 0, 0)
    myAbs (m0 - 2) + myAbs (m2 - (2 : Float) / 3) + myAbs (m6 - (2 : Float) / 7)

/-- Segment the interval at every zero height strictly inside [a, b]. -/
def splitIntR (a b : Float) (rest : List Float) (f : Float → Float) : Float :=
    match rest with
    | [] => glInt a b f
    | g :: gs =>
      if g <= a ∨ g >= b then
        splitIntR a b gs f
      else
        glInt a g f + splitIntR g b gs f

def splitInt (a b : Float) (L : List Float) (f : Float → Float) : Float :=
    splitIntR a b (L.filter (fun g => g > a && g < b)) f

/-! The A/B run (B4Float style): prints both checks, returns
    (abelRelativeError, boundMargin) — margin strictly positive iff (2) holds. -/
def run : IO (Float × Float) := do
    let tF : Float := 2.5
    let G  : Float := 6
    let B  : Float := 40
    let L  : List Float := [7.3, 12.1, 19.4, 27.8, 33.0]
    let f  : Float → Float := F tF
    -- (1) exact finite Abel identity:
    --     ∫_G^B N_L f' = f(B)·N_L(B) − f(G)·N_L(G) − Σ_{g: G<g≤B} f(g)
    let LsumF := L.foldl (fun (a : Float) g =>
      a + (if G < g && g <= B then f g else 0)) 0
    let Iabel := splitInt G B L (fun x => nListF L x * Fp tF x)
    let NRHS  := f B * nListF L B - f G * nListF L G - LsumF
    let abelRel := myAbs (Iabel - NRHS) / myMax (myAbs Iabel) (myAbs NRHS)
    IO.println "  check 1 — exact finite Abel identity (int N_L f' vs fB·NB − fG·NG − Sum f):"
    IO.println s!"    rel-err·1e12 = {abelRel * 1e12}"
    -- (2) explicit bound: |Sum f − int nF·f| ≤ Bf·(S̄ B + S̄ G) + Cf·K̄(G)
    let Ikernel := splitInt G B L (fun x => nF x * f x)
    let lhs2 := myAbs (LsumF - Ikernel)
    let rhs2 := BfF tF G * (sBarF B + sBarF G) + CfF tF G * KbarF G
    let margin := (rhs2 - lhs2) / rhs2
    IO.println "  check 2 — explicit bound |Sum f − int nF·f| ≤ Bf·(SbarB + SbarG) + Cf·Kbar(G):"
    IO.println s!"    margin·1e3 = {margin * 1e3}     (bound LHS·1e3={lhs2 * 1e3}, RHS·1e3={rhs2 * 1e3})"
    IO.println s!"    gl-mom-err·1e12 = {glMomErr * 1e12}     (table self-check, must be < 1e9)"
    if abelRel < 1e-9 && margin > 0 && glMomErr < 1e-12 then
      IO.println "B-3 CROSS-CHECK PASS"
    else
      IO.println "B-3 CROSS-CHECK FAIL"
    pure (abelRel, margin)

end B3Float

#eval! (do _ <- B3Float.run; pure ())
