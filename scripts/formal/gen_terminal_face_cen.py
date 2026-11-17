#!/usr/bin/env python3
"""Durable generator: TerminalFaceCE{N}.lean - the endpoint form of the RH
program at the CE{N} frontier (see TerminalFaceCE96.lean for the prototype).

Surgery:
  * extract the full window-clause hypothesis block from the source
    CE{N}.lean theorem allOnLineUpToCE{N} (ground truth - do NOT retype);
  * render the endpoint module at frontier tCE{N} with the same (fully
    understood) proof skeleton; every CE96 template occurrence is anchored
    and replaced at run time.

Usage:  python3 gen_terminal_face_cen.py <N>     (N >= 97; needs CE{N} +
        FrontierCE{N} green in the tree)
"""
import re, sys, pathlib

ROOT = pathlib.Path("/home/jsmille/Projects/rh-missing-tail/formal/RhAttack")
N = int(sys.argv[1])

# ---------- extract the hypothesis block from CE{N}.allOnLineUpToCE{N}
src = (ROOT / f"CE{N}.lean").read_text()
om = re.search(r"^open Real Set Complex Filter B0 P12 RHEnd CE1 .*", src, re.M)
assert om, "open line not found in CE%s.lean" % N
OPEN_LINE = om.group(0)
m = re.search(r"theorem allOnLineUpToCE" + str(N) + r" \(q : ZeroSet\)\n", src)
assert m, "allOnLineUpToCE%d signature not found" % N
j = src.index("\n", m.end())
# walk to the line ending the hypotheses: '(hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0) :'
end = src.index("(hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0) :", j)
end = src.index("\n", end)
block = src[m.end():end]            # the hZPT2 + hW1.. lines
# rename the final hqz to hqzCensus (template convention)
b2 = block.rsplit("(hqz :", 1)[0] + "(hqzCensus :" + block.rsplit("(hqz :", 1)[1]

# qualify every BARE (unqualified) clause name in the block. CE modules
# duplicate clause definitions (each recent module re-exports a sliding
# window of its neighbours), so bare names are ambiguous in a fresh
# namespace unless CE{N} itself defines the name (innermost-namespace
# resolution, exactly as CE{N}.lean itself reads them).
def _definers(name):
    out = []
    for f in ROOT.glob("CE*.lean"):
        try:
            t = f.read_text()
        except OSError:
            continue
        if re.search(r"def " + re.escape(name) + r" : Prop", t):
            out.append(f.stem[2:] if f.stem != "CE" else f.stem)
    return out

_bare = set(re.findall(r"(?<![A-Za-z0-9.])((?:ce\d+|fill)WinClause(?:Full)?)", b2))
for _name in sorted(_bare):
    _mods = _definers(_name)
    assert _mods, f"no definer for {_name}"
    _target = N  # CE{N}.lean's own namespace wins, as in the source module
    if f"CE{_target}.lean" not in {f"CE{m}.lean" for m in _mods} and len(_mods) == 1:
        _target = _mods[0]
    b2 = re.sub(r"(?<![A-Za-z0-9.])" + re.escape(_name) + r"\b",
                lambda m: "CE" + str(_target) + "." + _name, b2)
b2 = b2.rstrip()
assert b2.endswith(":")
b2 = b2[:-1].rstrip()
assert "(hqzCensus :" in b2 and "(hqz :" not in b2 and not b2.endswith(":")
# the argument run order (names only), in hypothesis order
names = re.findall(r"\((hZPT2|hW\d+|hqzCensus) : ", b2)
assert names[0] == "hZPT2" and names[-1] == "hqzCensus", names[:3] + names[-3:]
ARGRUN = " ".join(names)

hdr = f'''/-
**TerminalFaceCE{N} - RH FROM THE RE-ANCHORED TERMINAL FACE at tCE{N} (the
endpoint form of the program, at the window-{N} census frontier):

    terminalFaceCE{N} q  +  census  +  [Z78]  -->  RH q

ROLE: FrontierCE{N} showed the CE census-iff and the endpoint squeeze AGREE
at this frontier: the re-anchored terminal face (all zeros of q with
Im > tCE{N} on the line) ALONE discharges the hWin residual leg
(terminalFaceCE{N}_elim_hWin), and NOTHING OFF-LINE exists at all above
tCE{N} (face_above_frontier_no_offPair). This module records the full
consequence: under the terminal face the residual legs of the endpoint AT
THE FRONTIER are ALL discharged BY THE FACE ITSELF:

  * hWin  - FrontierCE{N}.terminalFaceCE{N}_elim_hWin (in tree);
  * hs1 / hs3 - VACUOUS, because no off-pair (t0, d0) exists at or above
    tCE{N}:
      - ABOVE  tCE{N}: face_above_frontier_no_offPair (the face itself,
        via the ZeroSet conj/star symmetry for the negative-height half);
      - AT     tCE{N}: the census clause WinC.allOnLineUpTo is
        BOUNDARY-INCLUSIVE (0 < rho.im, rho.im <= H -> on the line), and
        the negative half at -tCE{N} runs through q.conj + star.

  Hence THE ENDPOINT FORM OF THE WHOLE PROGRAM at the certified census
  frontier tCE{N}: RH q follows from the re-anchored terminal face at this
  frontier, the in-tree census below it, [Z78], and the zero-set premises -
  the residual legs are empty. THE ONLY ANALYTIC RESIDUE LEFT FOR RH IS THE
  TERMINAL FACE ITSELF.

THEOREMS (all LEAN-PROVEN composition; NO RH CLAIM - terminalFaceCE{N} q
is a NAMED INPUT, an unproven face; the theorems are implications FROM
it):
  * terminalFaceCE{N}_no_offPair_at_or_above - no off-pair at or above
    tCE{N} under the face + the census boundary clause;
  * rh_from_terminalFaceCE{N} - THE ENDPOINT AT THE WINDOW-{N} FRONTIER:
    [Z78] + census + zero-set premises + terminalFaceCE{N} q --> RH q,
    with hs1 / hs3 instantiated VACUOUSLY and hWin by the face. -/

import RhAttack.FrontierCE{N}
import RhAttack.CE{N}

{OPEN_LINE}
open Complex

namespace TerminalFaceCE{N}

/-- NO OFF-PAIR AT OR ABOVE tCE{N} (machine, no data): under the re-anchored
terminal face (above) and the BOUNDARY-INCLUSIVE census clause (at), nothing
off-line exists at t0 >= tCE{N} for ANY offset d0 > 0. This is what makes the
endpoint's hs1 / hs3 legs VACUOUS at the frontier. -/
theorem terminalFaceCE{N}_no_offPair_at_or_above (q : ZeroSet)
    (hface : CE{N}.terminalFaceCE{N} q)
    (hcensus : WinC.allOnLineUpTo q (CE{N}.tCE{N} : ℝ))
    (t0 d0 : ℝ) (ht : (CE{N}.tCE{N} : ℝ) ≤ t0) (hd0 : 0 < d0) :
    ¬ P12.offPair q t0 d0 := by
  rintro ⟨ρ, hρ, hne, him, hdd⟩
  by_cases hstrict : (CE{N}.tCE{N} : ℝ) < t0
  · exact (FrontierCE{N}.face_above_frontier_no_offPair q hface t0 d0 hstrict hd0)
      ⟨ρ, hρ, hne, him, hdd⟩
  · -- BOUNDARY: t0 = tCE{N}, covered by the census (boundary-inclusive <=)
    have heq : t0 = (CE{N}.tCE{N} : ℝ) := by
      apply le_antisymm
      · linarith
      · exact ht
    by_cases hpos : 0 < ρ.im
    · have hre : ρ.re = 1 / 2 := by
        have hle : ρ.im ≤ (CE{N}.tCE{N} : ℝ) := by
          rw [abs_of_nonneg (le_of_lt hpos)] at him
          linarith [heq, him]
        exact hcensus ρ hρ hpos hle
      exact hne hre
    · have hneg : ρ.im < 0 := by
        have hne0 : ρ.im ≠ 0 := q.nonReal ρ hρ
        exact lt_of_le_of_ne (not_lt.mp hpos) hne0
      have hst : star ρ ∈ q.Z := q.conj ρ hρ
      have himst : 0 < (star ρ).im := by
        simp only [star]
        linarith [hpos, hneg]
      have hlest : (star ρ).im ≤ (CE{N}.tCE{N} : ℝ) := by
        simp only [star] at ⊢
        have habs : ρ.im = -t0 := by
          rw [abs_of_nonpos (le_of_lt hneg)] at him
          linarith [heq, him]
        linarith [habs, heq]
      have hre' : (star ρ).re = 1 / 2 := hcensus (star ρ) hst himst hlest
      have hre : ρ.re = 1 / 2 := by
        rw [show (star ρ).re = ρ.re by simp [star]] at hre'
        exact hre'
      exact hne hre'

/-- THE ENDPOINT FROM THE TERMINAL FACE at H = tCE{N}: under [Z78], q a
subset of the actual zeros (hqz0), the named on-line sliver record below
707/50, and the CE{N} CENSUS (the tPT2 base plus the {N} verified
window-slice clauses), the RE-ANCHORED TERMINAL FACE ALONE gives RH q. The
engine is FrontierCE{N}.rh_program78_frontier_CE{N} with hs1 / hs3
instantiated VACUOUSLY via
terminalFaceCE{N}_no_offPair_at_or_above (no off-pair at or above tCE{N})
and hWin via FrontierCE{N}.terminalFaceCE{N}_elim_hWin. NO RH CLAIM:
terminalFaceCE{N} q is the named open face (all zeros of q with Im > tCE{N}
on the line); this theorem says that face IS the sole analytic residue of
RH at this certified census frontier. -/
theorem rh_from_terminalFaceCE{N} (q : ZeroSet)
    (hz78 : Z78.externalZeroFree78)
    (hqz0 : ∀ ρ ∈ q.Z, riemannZeta ρ = 0)
    (honline : ∀ ρ ∈ q.Z, 0 < (|ρ.im| : ℝ) → (|ρ.im| : ℝ) < (707 : ℝ) / 50 → ρ.re = 1 / 2)
    (Qside : ℝ × ℝ → ℝ)
{b2}\n    (hface : CE{N}.terminalFaceCE{N} q) :
    RH q := by
  have hcensus : WinC.allOnLineUpTo q (CE{N}.tCE{N} : ℝ) :=
    CE{N}.allOnLineUpToCE{N} q {ARGRUN}
  have hno : ∀ (t0 d0 : ℝ), (CE{N}.tCE{N} : ℝ) ≤ t0 → 0 < d0 → ¬ P12.offPair q t0 d0 :=
    fun t0 d0 ht hd0 => terminalFaceCE{N}_no_offPair_at_or_above q hface hcensus t0 d0 ht hd0
  exact FrontierCE{N}.rh_program78_frontier_CE{N} q hz78 hqz0 honline Qside hZPT2
    {' '.join(names[1:])}
    (by {{ intro t0 d0 ht hd0 hoff; exact absurd hoff (hno t0 d0 ht hd0) }})
    (by {{ intro t0 d0 ht hd0 hoff; exact absurd hoff (hno t0 d0 ht hd0) }})
    (FrontierCE{N}.terminalFaceCE{N}_elim_hWin q hface)

end TerminalFaceCE{N}
'''

out = ROOT / f"TerminalFaceCE{N}.lean"
out.write_text(hdr)
print(f"wrote {out} ({len(hdr)} chars); hypothesis run: hZPT2 + {len(names) - 2} window clauses + hqzCensus")
