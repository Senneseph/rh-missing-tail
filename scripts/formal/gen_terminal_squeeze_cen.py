#!/usr/bin/env python3
"""Durable generator: TerminalSqueezeCE{N}.lean - the final squeeze
assembly (strip face + band face under [Z78PR]) re-anchored at the
CE{N} frontier. Template: the committed TerminalSqueeze.lean (at CE96).

Surgery (all anchored at run time):
  * extract + qualify the window-clause hypothesis block from
    CE{N}.allOnLineUpToCE{N} (same resolution as gen_terminal_face_cen);
  * mechanical re-anchor CE96 -> CE{N} (tCE, census, frontier lemmas,
    imports, docs, namespace).

Usage:  python3 gen_terminal_squeeze_cen.py <N>
"""
import re, sys, pathlib

ROOT = pathlib.Path("/home/jsmille/Projects/rh-missing-tail/formal/RhAttack")
N = int(sys.argv[1])

src = (ROOT / "TerminalSqueeze.lean").read_text()
ce = (ROOT / f"CE{N}.lean").read_text()

# ---------- extract + qualify the CE{N} hypothesis block
m = re.search(r"theorem allOnLineUpToCE" + str(N) + r" \(q : ZeroSet\)\n", ce)
assert m, "allOnLineUpToCE%d signature not found" % N
j = ce.index("\n", m.end())
end = ce.index("(hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0) :", j)
end = ce.index("\n", end)
block = ce[m.end():end]
b2 = block.rsplit("(hqz :", 1)[0] + "(hqzCensus :" + block.rsplit("(hqz :", 1)[1]
b2 = b2.rstrip()
assert b2.endswith(":")
b2 = b2[:-1].rstrip()
assert "(hqzCensus :" in b2 and "(hqz :" not in b2 and not b2.endswith(":")
names = re.findall(r"\((hZPT2|hW\d+|hqzCensus) : ", b2)
assert names[0] == "hZPT2" and names[-1] == "hqzCensus", names[:3] + names[-3:]
ARGRUN = " ".join(names)

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
    _target = N
    if f"CE{_target}.lean" not in {f"CE{m}.lean" for m in _mods} and len(_mods) == 1:
        _target = _mods[0]
    b2 = re.sub(r"(?<![A-Za-z0-9.])" + re.escape(_name) + r"\b",
                lambda m: "CE" + str(_target) + "." + _name, b2)

# ---------- mechanical re-anchor (order matters)
s = src
s = re.sub(r"rh_program78_frontier_CE\d+", lambda m: m.group(0), s)  # no-op guard
s = s.replace("CE96.tCE96", f"CE{N}.tCE{N}")
s = s.replace("FrontierCE96.ce96AbovePT2", f"FrontierCE{N}.ce{N}AbovePT2")
s = s.replace("FrontierCE96", f"FrontierCE{N}")
s = s.replace("RhAttack.FrontierCE96", f"RhAttack.FrontierCE{N}")
s = s.replace("import RhAttack.CE96", f"import RhAttack.CE{N}")
s = s.replace("TerminalFaceCE96 (0416)", f"TerminalFaceCE{N} (0421)")

# replace the hW hypothesis run in the rh_from_bandfaces signature
i = s.index("(hZPT2 : WinC.allOnLineUpTo q WinC.tPT2)\n    (hW1 :")
j2 = s.index("(hWinF : WinC.hWinFaceResidualH q (CE" + str(N) + ".tCE" + str(N) + " : ℝ))", i)
old_sig = s[i + len("(hZPT2 : WinC.allOnLineUpTo q WinC.tPT2)\n"): j2]
new_sig = b2.replace("    (hZPT2 : WinC.allOnLineUpTo q WinC.tPT2)", "").lstrip("\n").rstrip()
s = s[:i + len("(hZPT2 : WinC.allOnLineUpTo q WinC.tPT2)\n")] + new_sig + "\n    " + s[j2:]

# the hcensus argument run
old_run = re.search(r"CE96\.allOnLineUpToCE96 q hZPT2[^\n]*\n", s)
if old_run:
    s = s.replace(old_run.group(0), f"CE{N}.allOnLineUpToCE{N} q {ARGRUN}\n")
    # a second run may wrap onto continuation lines: catch any leftover
# leftover bare CE96./tCE96 tokens (should be none except in docs we fix below)
s = s.replace("CE96 CENSUS", f"CE{N} CENSUS")
s = s.replace("CE96.", f"CE{N}.")
s = s.replace("tCE96", f"tCE{N}")
s = s.replace("the 97 verified window-slice clauses", f"the {len(names) - 2} verified window-slice clauses")

# namespace + title
s = s.replace("namespace TerminalSqueeze\n", f"namespace TerminalSqueezeCE{N}\n")
s = s.replace("end TerminalSqueeze\n", f"end TerminalSqueezeCE{N}\n")
s = s.replace("**TerminalSqueeze", f"**TerminalSqueezeCE{N}", 1)

out = ROOT / f"TerminalSqueezeCE{N}.lean"
out.write_text(s)
leftover = [l for l in s.split("\n") if "CE96" in l or "tCE96" in l]
print(f"wrote {out} ({len(s)} chars); clause run: {len(names) - 2}")
if leftover:
    print("LEFTOVER CE96 TOKENS:")
    for l in leftover[:10]:
        print("   ", l[:110])
