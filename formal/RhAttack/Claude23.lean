import Mathlib
import RhAttack.B0
import RhAttack.P12Uniform
import RhAttack.WinCount
import Zeta23.Unconditional
import Zeta23.FinalMult

set_option linter.style.whitespace false
set_option linter.style.longLine false
set_option linter.style.docString false

open Real Set Complex

/-!
**Claude23 — the 2026 Claude 2/3 result as an IN-TREE MACHINE PROOF
(borrowed, 0308; the formal kappa-register bridge).**

PROVENANCE (full record:  discovery 0307 / 0308):
  PAPER:  "More than two thirds of the zeros of the Riemann
  zeta function are simple and on the critical line"  (2026-08-10).
  Author line  CLAUDE  ANTHROPIC  -  "the  author  of  this  paper
  is  a  large  language  model  developed  by  Anthropic";
  J.  Sumner  posed  the  problem  ("in  every  meaningful  sense
  the  paper's  human  co-author");  R.  Furman  and  L.  Alpöge
  re-derived  the  argument  independently  and  take  responsibility
  for  its  communication.  arXiv:2608.13637  (Alpöge-Furman)  per
  project  unit  0300.
  LEAN:  github.com/anthropics/zeta-23-lean  tag  v1.0  (Apache-2.0;
  LICENSE  and  NOTICE  retained  in  the  vendor  directory),
  toolchain  v4.33.0-rc2,  Mathlib  pin  51e6992efd06  -  a  DIRECT
  ANCESTOR  of  our  Mathlib  pin  (95  commits  behind  ours,
  merge-base  verified  2026-11-11).
  VENDORED:  formal/vendor/zeta23  (316  files,  ~102  k  lines)
  with  ONE  local  patch  (trailing  spaces  in  a  docstring
  in  Analytic/Stirling.lean  -  style  linter  only).  Built
  green  in  our  tree:  "lake  build  Zeta23"  =  9019  jobs.
  THEIR  AUDIT  (AUDIT.md):  #print  axioms  on  each  headline
  declaration  returns  only  propext  /  Classical.choice  /
  Quot.sound;  no  sorry.  The  counting  functions  are  defined
  DIRECTLY  against  Mathlib's  riemannZeta  (Zeta23/Statement.lean):
    IsNontrivialZero  ρ  ↔  riemannZeta  ρ  =  0  ∧  0  <  ρ.re  <  1,
    zeroMult  via  analyticOrderAt,  Ncount / Ndist / N0 /
    N0star  /  N0simple  /  Nsimple.

WHAT  THIS  MODULE  IS  (scope  and  honesty):
  The  KAPPA-REGISTER  BRIDGE  -  the  headline  proportion
  theorems  installed  as  named  declarations  of  our
  register,  together  with  the  FACE-BLINDNESS  framing:
  these  are  proportion  statements  over  (T,  2T];  the
  inputs  are  INSSENSITIVE  TO  o(N)  OFF-LINE  ZEROS  (paper
  sec.  1.4:  the  same  argument  holds  for  Davenport-Heilbronn
  and  Epstein  zeta  functions,  for  which  the  analogue  of
  RH  is  FALSE).  In  particular  they  DO  NOT  (a)  close  the
  all-heights  terminal  face,  and  (b)  touch  the  (1.2)
  Levinson  wall  (the  argument  uses  NO  mollifier  and  no
  Levinson  length;  the  wall  {θ |  4/7  <  θ}  is  UNMOVED).
  NO  RH  CLAIM.  -/

namespace Claude23
open Zeta23

/-! ### 1.  The headline proportion theorems (machine, vendored proof)
-/
/-- [MACHINE,  VENDORED  PROOF,  THEOREM  A]  for  every  ε  >  0
    there  is  T₀  such  that  for  all  T  >=  T₀,  at  least
    (2/3  −  ε)  of  the  nontrivial  zeros  counted  with
    multiplicity  in  (T,  2T]  lie  ON  THE  CRITICAL  LINE
    (as  distinct  points:  N0star).  Montgomery's  RH-conditional
    2/3  constant,  now  UNCONDITIONAL.  -/
theorem kappa23_onLine :
    ∀ ε > 0, ∃ T₀ : ℝ, ∀ T ≥ T₀, (2 / 3 - ε) * (Ncount T (2 * T) : ℝ) ≤ N0star T (2 * T) :=
  Zeta23.two_thirds_on_critical_line

/-- [MACHINE,  VENDORED  PROOF]  THE  CUMULATIVE  FORM  over
    (0,  T].  -/
theorem kappa23_onLine_cumulative :
    ∀ ε > 0, ∃ T₀ : ℝ, ∀ T ≥ T₀, (2 / 3 - ε) * (Ncount 0 T : ℝ) ≤ N0star 0 T :=
  Zeta23.two_thirds_on_critical_line_cumulative

/-- [MACHINE,  VENDORED  PROOF,  THEOREM  B₀]  at  least
    (2/3  −  ε)  of  the  zeros  (with  multiplicity)  in  (T,  2T]
    are  SIMPLE  AND  ON  THE  LINE  (N0simple).  -/
theorem kappa23_simpleOnLine :
    ∀ ε > 0, ∃ T₀ : ℝ, ∀ T ≥ T₀, (2 / 3 - ε) * (Ncount T (2 * T) : ℝ) ≤ N0simple T (2 * T) :=
  Zeta23.thmB₀_mult

/-- [MACHINE,  VENDORED  PROOF]  THE  CUMULATIVE  FORM  of
    kappa23_simpleOnLine.  -/
theorem kappa23_simpleOnLine_cumulative :
    ∀ ε > 0, ∃ T₀ : ℝ, ∀ T ≥ T₀, (2 / 3 - ε) * (Ncount 0 T : ℝ) ≤ N0simple 0 T :=
  Zeta23.thmB₀_mult_cumulative

/-- [MACHINE,  VENDORED  PROOF,  THEOREM  C₀]  at  least
    (5/6  −  ε)  of  the  zeros  in  (T,  2T]  are  DISTINCT
    (Ndist).  Unconditional;  the  previous  record  was
    0.6603  (Wu  2015).  -/
theorem kappa23_distinct :
    ∀ ε > 0, ∃ T₀ : ℝ, ∀ T ≥ T₀, (5 / 6 - ε) * (Ncount T (2 * T) : ℝ) ≤ Ndist T (2 * T) :=
  Zeta23.thmC₀_mult

/-- [MACHINE,  VENDORED  PROOF]  THE  CUMULATIVE  FORM  of
    kappa23_distinct.  -/
theorem kappa23_distinct_cumulative :
    ∀ ε > 0, ∃ T₀ : ℝ, ∀ T ≥ T₀, (5 / 6 - ε) * (Ncount 0 T : ℝ) ≤ Ndist 0 T :=
  Zeta23.thmC₀_mult_cumulative

/-! ### 2.  Refinements available in-tree (named, not aliased)
-/
/- MONTGOMERY-TAYLOR  WINDOW  refinement  (constants
    0.67250...  simple-on-line  and  0.83625...  distinct):
    the  in-tree  declarations  are
    Zeta23.thmD₀_simple_mult  (constant  HD  1)  and
    Zeta23.thmD₀_dist_mult  (constant  GD  1),  with
    HD  lam  :=  2  −  1/cStar(lam),  GD  lam  :=  3/2
    −  cStar(lam)⁻¹/2  (Zeta23/ThmD/).  The  bandwidth-one
    ceiling  of  the  method  (~0.682)  is  formalised  at
    Zeta23.PairCeiling.CeilingLaw256  (interval enclosures
    at  tag  v1.0  are  interval-arithmetic  certified,  not
    kernel  checked  -  as  recorded  in  the  paper).  -/

/- ZEROS  OF  ξ'  (Remark  7.1  of  the  paper):  the  same
    argument  gives  unconditionally  >=  85.838%  of  the
    zeros  of  ξ'  simple  and  on  the  critical  line
    (flat  window)  and  >=  92.919%  distinct;  formalised
    in  Zeta23.XiPrime.  -/

/-! ### 3.  Face-blindness (the register's honesty clause)
-/
/- REGISTER  NOTE  (machine-level):  the  theorems  of
    sections  1-2  are  PROPORTION  statements  over  (T,
    2T].  They  imply  NOTHING  about  (a)  the  all-heights
    terminal  face  (every  zero  above  a  certified
    frontier  on  the  line)  -  which  remains  OPEN
    (PROBABLY  TRUE)  -  or  (b)  the  (1.2)  Levinson  wall
    {θ  |  4/7  <  θ}  (UNMOVED;  the  argument  uses  no
    mollifier  and  no  Levinson  length).  This  is  the
    paper's  own  sec.  1.4  at  mechanism  level:  the
    inputs  are  insensitive  to  o(N)  off-line  zeros  and
    the  same  argument  holds  for  Epstein  zeta
    functions,  for  which  the  analogue  of  RH  is
    FALSE.  NO  RH  CLAIM.  -/

end Claude23
