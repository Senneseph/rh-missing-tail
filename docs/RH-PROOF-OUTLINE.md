# The Riemann Hypothesis: A Path, and Its Current State

*What this is.* This document presents a complete path toward a proof of the
Riemann Hypothesis, written so that a reader with a background in analysis
can follow it start to finish. It is a mathematical exposition, not a
journal of the project's internal work.

*Honesty of status — read this first.* The path is a **complete argument
skeleton**. Some of its pieces are **proven and machine-checked** (Lean 4 +
mathlib). Some are **classical facts** we take from the literature. Some are
**measured to high precision** but not yet proven. One part — the residual
floor of §10 — is **open**, and the full theorem is conditional on it.
Nothing in this document claims that the Riemann Hypothesis has been proved.
Every computed number cited here carries provenance to a script and data file
committed alongside it. The project discloses AI co-development of its
instruments.

*How to read it.* §1–2 state the hypothesis and the counting language we use.
§3 is the broad strategy in one page. §4–7 walk through each ingredient, in
the order the argument uses it. §8 closes the loop. §9 states exactly what is
proven, measured, and open. §10 is the residual floor — the one open piece —
and the two routes intended to close it. §11 lists the classical sources.

***

**Current-state note (current:  post-3e10 data layer — read before §9–§10).**  The
status tables of §9 (§10's STATUS line) are the day-023/029 snapshot of the
original eight-part skeleton.  Since then the argument has been carried to
its end-game form:  a machine-verified verification chain (the W2 telescope
and one-sided noise floors;  the S3a algebraic detector;  the S1LowT / S4
wire squeezes;  the M6 composition) closed onto the **actual** zero set as
one named theorem — `ZetaZeroSet.rhIfMarginZeta` (`formal/`),  whose
docstring maps every leg to its supplier — with the data side at
3×10¹⁰ zeros (the 3×10⁹ spine as of the day035 entry:  N(3×10⁹) =
9,064,192,826 exact and audited,  the tail walk bounded by 2.503 on
(10⁷, 2×10⁹],  2.4772 on (10⁷, 2.9992×10⁹] —  plus the 3×10¹⁰ band:
N(3×10¹⁰) = 101,635,962,231 exact and audited,  sup|DN| = 2.615067 on
(10⁷, 3×10¹⁰] —  the walk keeps its shape through the decade,  and the
per-gap ε layer of the [S1] walk bound certified over it,  A2-class).  The
  PROVEN finite-height result, named and machine-verified (discovery 0287),
  is `RHEnd.rh_no_offline_pair_to_growth_frontier`: under `[Z78]` + the 3e10
  census + the Trudgian / Platt–Trudgian growth-wire frontier, NO OFF-LINE
  ZERO PAIR up to 3 × 10¹² — the certified 3e10 data frontier (tPT =
  30,610,046,000) plus the finite height the growth wire reaches (tPT2 =
  3,000,175,332,800) — a finite-height theorem.  And the EXACT residual is
  pinned (discovery 0288): all-heights RH  iff  the cited census  AND  the
  TERMINAL FACE (`RHEnd.terminalFace`, no off-line zero with positive
  height above 3 × 10¹²) — ONE named open object, the heart of RH
  (thesis-level; absolute A1 clause OPEN / PROBABLY FALSE).  All-heights
  RH remains the explicit open goal.  The residual
floor of §10 as a single open piece has been SUPERSEDED by the two-leg
map of the front page:  the **[S1] uniform walk bound** (the W2-beyond
research item —  its drift reduction in Lean,  W2Beyond0 / W2Beyond1;
the open content is the analytic A1 bound,  its restatement and the
current exploration state in docs/S1-A1-EXPLORATION.md) and the
**measured [S3/S4] fills** (named wire hypotheses with the pinned data
as their fills;  the owner-selected route is grade (i) H1-full on the
3e10 census —  engine built and self-tested,  profile-gated);
  the low-t sliver and the d = 1/2
edge are closed as named items (SliverEdge).  Nothing here claims RH;
the authoritative current state is docs/CEILING-REPORT-DAY035.md
(with its post-data addendum) and docs/S1-A1-EXPLORATION.md (the
research log).

**0289 note (option B launched — the direct attack on the terminal
face, 2026-11-11).**  The attack is now a machine-verified program, not
a restatement: (1) **face identity** — `RHEnd.terminalFace` (0288) is
the endpoint's own unified38 face in BOTH directions
(`faceIdentity_z78_plus_unified38`,
`faceIdentity_terminalFace_gives_unified38`): [Z78] + "no off-pair in
0 < d0 ≤ 3/8 above 3×10¹²" ⟺ the terminal face (± the census at the
boundary height).  (2) **wire dead end** —
`A1G.a1_wire_no_uniform_defect_bound`: the W2/A1 wire's far-side defect
bound at the data-free growth ceiling, (G_explicit g + 1)·(17/8), has no
uniform all-heights form; the W2 wire is a FINITE-HEIGHT machine and
cannot close the face.  (3) **the reframe** — the face (what RH reduces
to) is *probably true*; the absolute A1 clause (the wire's required
input) is *probably false* — goal vs. method, the 0286 identity kept as
a theorem, the truth-value attribution corrected.  (4) **the face-menu**
named with 2026 audits: M1 0276-gate (in-tree, mechanism dead); M2
θ=∞ lane (alive: Ratios → θ=∞ → RH, Bettin–Gonek 2017,
arXiv:1604.02740; the Levinson-type asymptotic for arbitrary polynomial
mollifier length is the named research target); M3 S-route (dead: the
true maximal order of S grows); M4 zero-free regions (dead: wrong
side); M5 frontier extension (the only machine-verified *shrinking*
lane — the next unit).  Record: docs/ROUTE-B-FINAL-RECORD-2026-11-04.md §19;
discovery 0289; S1-A1-EXPLORATION.md E20.

**0290 note (the θ = ∞ lane, named and wired — option B, unit 2,
2026-11-11).**  Lane M2 is no longer a name: it is a formal module with
machine-verified wiring onto the 0288 terminal face
(`RhAttack.ThetaInf`, build green, full tree green).  The Levinson
mollifier and mollified second moment are defined self-contained; the
θ=∞ conjecture is stated in its EXACT form (1.2) of Bettin–Gonek
(arXiv:1604.02740, re-pulled verbatim — "lim I_{T^θ}(0,T)/T = 1 + 1/θ
for EVERY θ > 0", proven only for 0 < θ < 1/2); the cited inputs are
Theorem 1's antecedent (`thetaBounded θ`), its consequence (zero-free in
BOTH flanks of Re = 1/2 at distance 1/(2θ), the left flank via the
functional equation), and the conjecture-implies-RH implication (Farmer
κ = 1 + Theorem 1 particular case, one Z78-pattern input).  Two
LEAN-proven implications: `terminalFace_of_thetaInf` (cited inputs
⟹ terminalFace — the lane's CLOSING) and `terminalFace_of_bgShrink`
(any cited θ > 0 SHRINKS the face from 0 < d0 ≤ 3/8 to 0 < d0 ≤
1/(2θ); θ = 4 already excludes the route-(b) face zero).
The analytic research target is now precisely one statement: extend
the Levinson–Conrey asymptotic beyond θ = 1/2 (frontier:
Conrey–Chandee–Farb–Young; the unconditional record is ≥ 2/3 of the
zeros on the line; the lane is active in 2026 via arXiv:2605.24363).
NO RH CLAIM.  Record: docs/ROUTE-B-FINAL-RECORD-2026-11-04.md §20;
discovery 0290; S1-A1-EXPLORATION.md E21.  **Corrigendum (0291,
2026-11-11):** the proportion line above is corrected — the
accepted Levinson-lineage record is κ ≥ 0.417293962 (PRZZ 2020,
with multiplicity); the “≥ 2/3” (0.6725…) figure is an
August-2026 unrefereed result for distinct/simple on-line zeros
(Anthropic preprint; Ainta to 0.673008528; independent proof by
Lamzouri); the CCFY attribution is retracted.  Record: §21.3;
discovery 0291.

**0291 note (the M5 re-anchor — the certified frontier moves,
2026-11-11).**  Lane M5 (the only machine-verified shrinking lane)
now works end-to-end on a fresh 2026 cited artifact: Murphy’s
October-2026 certified window (20,000 zeros between the Gram points
a = 12,363,153,437,130 and b = 12,363,153,457,130, all simple and
on the line; g_b ≈ 3,000,175,337,471.51 — Zenodo 23486195/6196,
128-bit Arb ball arithmetic, Lean-kernel-checked Riemann–Siegel
remainder, independent audit) extends the verified region strictly
above the Platt–Trudgian height.  `RhAttack.CE1` (build green, full
tree green): the new cited clause [CE1] + [Z-PT2] ⟹ the census up
to **tCE1 := 3,000,175,337,471** (machine-verified); the 0288
exact residual is RE-PINNED (`rh_split_at_CE1`: RH q iff census up
to tCE1 ∧ `terminalFaceCE1 q`); the two face formulations are
equivalent under [CE1] (`terminalFaceCE1_iff_face0` — the shrink is
a certificate, not a logical move); headline
`rh_reanchored_CE1`: all-heights RH ⟺ the re-anchored face given
[Z-PT2] + [CE1]; the 0290 M2 closing lands directly at the new
frontier (`terminalFaceCE1_of_thetaInf`).  The height domain of the
face shrank by exactly 4671 units (~1.6·10⁻⁹ relative); NO RH
CLAIM — the face remains the same open object, certified one 4671-
unit band higher; every future window above H0 re-anchors by the
same two-line composition.  Record: docs/ROUTE-B-FINAL-RECORD-
2026-11-04.md §21; discovery 0291; S1-A1-EXPLORATION.md E22.

**0292 note (the 2026 mechanism seal — M2 target pinned, lane M6
audited, face-menu COMPLETE, 2026-11-11).**  (1) **M2 target**:
the analytic gap is exactly “(1.2) beyond θ = 1/2”; the 1/2
barrier is real and named in the leading work (PRZZ §1.3: B-C-H-B
pushed the length “past the 1/2 barrier to 9/17” via higher-degree
test functions; §9(3) generic-coefficient ceiling 17/33 − ε; §9(4)
open question: the degree-d vs truncation-ℓ balance); PRZZ on
θ = ∞ itself: “Bettin–Gonek proved … RH would follow (not just
100%). **Of course, we are very far away from such lengths of
mollifiers.**”  (2) **Lane M6 (new)**: the 2026 proportion-
certificate family (Alpöge–Furman ≥ 2/3 simple-and-on-line, Gabor-
frame Gram certificate; Ainta 0.673008528; clipped-Gram
66812491/99194876 ≈ 0.67354780502… with multiplicity — highest;
results STAND as unconditional mathematics) is audited
**structurally blind**: the spectral-twin theorem (rStation paper
109, Nov 2026) — a lattice of reflected off-line pairs at spacing
≤ the frame step has EXACTLY the Gram matrix of on-line double
zeros, **at every depth**, every length-L window; the extremal
certificate data are reproduced by a configuration with a third of
its zeros at any depth (model corollaries, caveat recorded
verbatim); no zero-density information beyond the trivial.  The
lane is closed as a face-closer; its proportion results stand.
(3) **Face-menu terminal state (M1–M6)**: M1 dead (0284); M2
wired + target pinned (0290/0292); M3 dead walls (0278–0283); M4
wrong side (0285); M5 **working** (0291 — re-anchor or detect);
M6 audited blind (0292).  The two proven structural allies of the
sparse face (zero-density 0285; spectral twin 0292) make a
pervasive face impossible at two independent levels while leaving
the sparse face untouched.  Record-level unit (0280/0285 pattern);
NO RH CLAIM.  Record: docs/ROUTE-B-FINAL-RECORD-2026-11-04.md
§22; discovery 0292; S1-A1-EXPLORATION.md E23.

**0293 note (THE LEVINSON WALL `[LEV-WALL]` — the exact gap
object of lane M2, named and closed off in-tree; Lean:
RhAttack.LevWall, GREEN, 17454-job full tree, 2026-11-11).**
The (1.2) asymptotic at a fixed θ is now stated **exactly, in
tree** (`LevWall.asympAt θ`, over the 0290 `thetaIMoment`);
`thetaInfConjecture ↔ ∀θ>0, asympAt θ` (machine, definitional).
The named open input **[LEV-WALL]** `levWallAt θ := asympAt θ`
carries the published reach **0 < θ < 4/7** (Levinson 1974:
0 < θ < 1/2, original mollifier, κ > 1/3; Conrey 1989: θ < 4/7,
variant mollifier, κ > 2/5 — both quoted verbatim from
Bettin–Gonek §1, re-pulled) and is **OPEN for θ > 4/7**.  The
gap set `{θ | 4/7 < θ}` is machine-proven **nonempty (θ = 1)
and unbounded** (the θ=∞ target has no finite endpoint);
`1/2 < 4/7 < 1` machine-proven.  The HISTORICAL FLIP pinned
(BG §1 verbatim): (1.2) was “initially believed” to fail for
θ > 1; Farmer’s heuristic suggests it for **every** θ > 0 — the
gap is the intended domain of the conjecture.  The M2 CLOSING
wire is re-stated **with the gap object named**:
`terminalFace_of_levWall` — `[zeta membership]` + `[cited BG
implication]` + `[LEV-WALL at every θ > 0]` ⇒ `terminalFace`
(0288).  Closing the face via M2 = proving `levWallAt θ` for
all θ in `levWallGap`.  The two θ's are kept distinct from here
on: the **asymp θ** (published to 4/7, target ∞) vs the
**proportion θ_F** (standard 1/2−ε, the **named “1/2 barrier”**;
B-C-H-B 9/17 degree-2; PRZZ 4/7, κ ≥ 0.417293962 record).  The
in-tree wall is defined by its PUBLISHED REACH, deliberately not
by a memory-recomputed diagonal/off-diagonal split (fabrication
red line).  NO RH CLAIM.  Record: ROUTE-B-FINAL-RECORD §23;
discovery 0293; S1-A1-EXPLORATION.md E24.

**0294 note (the RADZIWILL LIMITATION + the WALL SHARPENED —
the gap object is the SHARP residual asymptotic `1/θ`; Lean:
RhAttack.LevWall2, GREEN, 17454-job full tree, 2026-11-11).**
Radziwiłł, *Limitations to mollifying ζ(s)* (arXiv:1207.6583,
pulled primary) says: the residual `ℐ(𝔐) = (1/T)∫_T^{2T}
|1−M_T(1/2+it)ζ(1/2+it)|² dt` obeys, **unconditionally for
every θ > 0**, the limitation `∫ ≥ (c/θ)T` (ineffective
c > 0) — via Prop A (a Sobolev inequality **on the zeros**,
all θ) + Prop B (the B-C-H-B/Soundararajan explicit
**off-diagonal** quadratic form, θ ≤ 1/2, where the SHARP
constant lives).  The **sharp** asymptotic `residual/T → 1/θ`
(c = 1) is **published only for 0 < θ < 1/2**; Conrey's 4/7 is
the (1.2) *moment* frontier (corollary of the
sharp-residual machinery in range).  Hence: the universal
limitation is a **constraint on every solution** (no mollifier
route beats 1/θ — mollifier improvement alone can never close
the face), while the **named frontier obstruction** of M2 is
now **[BARRIER-ASYMP] `levSharp θ` at θ > 1/2** = new
off-diagonal control at longer sums.  Machine bridge
(LevWall2, all PROVEN): `residPointwise` (‖1−w‖² = 1 + ‖w‖²
− 2 Re w), `wThetaNormEqMoment` (‖w‖² = exactly the
(1.2)-moment integrand), `residExpand` (interval linearity of
the residual), and the **wall theorem** `residSharp`:
`[ASYMP-2T θ]` + `[MOZ-MAIN θ]` ⇒ `levSharp θ` — ANY proof of
(1.2) past the frontier must make the residual achieve
**exactly** 1/θ.  Range ordering PROVEN: `1/2 < 9/17 (B-C-H-B
length) < 4/7 (Conrey frontier) < 1`.  NO RH CLAIM.  Record:
ROUTE-B-FINAL-RECORD §24; discovery 0294; S1-A1-EXPLORATION.md E25.

**0295 note (the wall, UNIFIED — one gap set; 2025–2026
audit: the off-diagonal barrier is UNMOVED; Lean:
RhAttack.LevWall3, GREEN, 17454-job full tree,
2026-11-11).**  The 0294 `residSharp` theorem (the sharp
residual 1/θ is a logical corollary of (1.2) + the main
term) means `[BARRIER-ASYMP]` reaches the **Conrey
frontier 4/7**, not Radziwiłł's stated Prop-B range 1/2
(his conservative limitation-theorem range).  The 0293
moment wall and the 0294 residual wall are **one wall with
one gap set** `unifiedGap = {θ | 4/7 < θ}` (machine
PROVEN set equality with `LevWall.levWallGap`; nested
arithmetic `1/2 < 9/17 < 4/7` PROVEN): the unified wall is
the *smaller* obligation — (1.2) past 4/7 automatically
carries the sharp residual via the corollary.  The 2025–
2026 literature audit (primary sources, 2026-11-11): Lin
2025 (arXiv:2508.11108) optimizes the *derivative
combination* (Q-side) — "combining beats lengths when
short" — the length-θ frontier is not moved; the
zero-free-region papers move VK *constants*, not
exponents; the Farmer-1993 / Bettin–Gonek-2017
citation chain for the θ = ∞ lane is independently
re-confirmed (MO 515314).  **The off-diagonal barrier is
UNMOVED to end-of-2026**; the single named open
requirement of the M2 lane is `[UNIFIED-WALL]`:  the (1.2)
asymptotic for every θ > 4/7.  NO RH CLAIM.  Record:
ROUTE-B-FINAL-RECORD §25; discovery 0295; S1-A1-EXPLORATION.md E26.

**0296 note (THE SECOND FACE-CLOSING DOOR + THE RATIOS
AUDIT; Lean: RhAttack.LevWall4, GREEN, 17454-job full
tree, 2026-11-11).**  Ratios audit (negative, 0280
pattern): the ratios conjecture (Farmer 1993 (7.4), first
zeta case) is the **heuristic parent** of the θ = ∞
conjecture — the ratios support for (1.2)@all-θ is
*conjectural* in 1993, BG 2017 never mentions ratios, and
the 2023–2026 ratios literature proves *special* means
only — **no published "ratios-2 ⟹ (1.2) at θ > 4/7"
implication exists** (as of 2026-11-11).  The PUBLISHED
direction is the reverse: (1.2)@all-θ ⟹ κ = 1 (100%
on-line, Farmer 1993, proven).  Ratios = a *sibling*
conjecture, not a citable shortcut.  The second door
(machine): BG 2017 Theorem 1's "In particular" clause
(proven inside that note): the Theorem-1 antecedent
`I_N(0,T) ≪_ε T^{1+ε}` for `2 ≤ N ≤ T^θ` **with θ
arbitrarily large** ⟹ RH — now named in-tree as
`[BG-ANT-ALL]` (`thetaBoundedAll`) + `[BG-T1-ARB]`
(`bgArbImpliesAllOnLine`, cited), wired by
`terminalFace_of_bgArb` (machine).  **The face has exactly
two named sufficient input families** — door 1 = the
(1.2) asymptotic at every θ (unified wall, gap θ > 4/7);
door 2 = the uniform-boundedness antecedent at every θ
(range-uniform shape — strictly stronger than the
pointwise asymptotic; the two doors NOT linked in-tree by
proof, honesty).  Plus machine: `thetaFacesCover` — the
0290 θ-face family `{0 < d0 ≤ 1/(2θ) : θ > 0}` *covers*
the whole off-line range (collectivity; no single θ
closes the face, θ → ∞ does).  NO RH CLAIM.  Record:
ROUTE-B-FINAL-RECORD §26; discovery 0296;
S1-A1-EXPLORATION.md E27.

**0298 note (DOOR-2 DECOMPOSITION — the two doors are
the SAME WALL — 2026-11-11).**  Record-level audit
(0280 pattern; no Lean): the BG Theorem-1 antecedent
`I_N(0,T) ≪_ε T^{1+ε}` uniformly over `2 ≤ N ≤ T^θ`
**decomposes** into (A) `N ≤ T^{ε/3}`: STANDARD —
`|M_N(1/2+it)| ≤ C√N` + the HARDY–LITTLEWOOD pointwise
second moment `∫_0^T |ζ(1/2+it)|²dt = T·log(T/2π) + O(T)`
(cited, classical) ⇒ `I_N ≤ C·N·T·log T`; (B)
`T^{ε/3} ≤ N ≤ T^θ`: the (1.2) asymptotic on
`[ε/3, θ]` (compact-uniform reading, standard) ⇒
`I_N = O_ε(T)`.  Parts A+B = exactly the antecedent's
shape.  Consequences: **door 2 at θ = door 1 on
`[δ, θ]` + classical estimates** (the uniform shape adds
no analytic content; no reverse implication — door 1 is
the canonical/stronger form); **door 2's published reach
UPGRADES from the 0296 conservative `1/2` to `4/7`**;
**the two doors' gaps coincide = `{θ | 4/7 < θ}`** —
three names, one object: (1.2) / `levSharp` (0294
machine bridge) / `thetaBounded` (door 2).  No RH claim;
inputs cited; compact-uniform reading flagged
interpretive.  Record: ROUTE-B-FINAL-RECORD §28;
discovery 0298; S1-A1-EXPLORATION.md E29.

**0297 note (M5 FRONTIER EXTENSION, SECOND RUN — our own
window — 2026-11-11).**  The M5 shrinking lane produced a FRESH
certified window in-house (Murphy's Apache-2.0 pipeline, zenodo
23486196, run on this machine: 28 workers, 33,268 ball evaluations,
42.5 min): the **19,999 zeros with g_a2 < Im s ≤ g_b2 are all
simple and on the line** (19,999 = b − a certified sign changes;
Rosser runs 47/50 ≥ K = 12; 0 failures; b snapped to Gram point
12,363,153,477,129).  g_b2 = 3,000,175,342,144.2115353245153768…
(recorded dyadic ball, radius ~1.3e-26); the seam g_a2 = CE1's g_b
is seamless to the 128-bit record.  Three verification layers:
Murphy's own certificate re-verified in our environment, the
pipeline's independent verifier (CERTIFIED: true), and an
independent mpmath spot-check (third R-S implementation: endpoints
reproduced; certified signs agree — count in the record).  Machine
(`formal/RhAttack/CE2`, tree green 17454): new cited frontier
**tCE2 = 3,000,175,342,144** (strictly below the certified g_b2
ball); `allOnLineUpToCE2` = [Z-PT2] + [CE1-WIN] + [CE2-WIN]
(the two window clauses as named cited Inputs; the seam split is
machine logic); `terminalFaceCE2`; `rh_reanchored_CE2`
(all-heights RH ↔ terminalFaceCE2 given the three cited census
Inputs); `rh_of_terminalFaceCE2`; `terminalFaceCE2_of_thetaInf`
(the 0290 lane lands directly at the new frontier); face shrank a
further **4,673** units; frontier 9,344 units above H0 (9,344.2115
certified).  No RH claim; the face is the same open object,
certified 9,344 units higher.  Record: ROUTE-B-FINAL-RECORD §27;
discovery 0297; S1-A1-EXPLORATION.md E28.

**0299 note (PHASE PACKAGE, option B 0289→0298 — the complete
map — 2026-11-11).**  The phase mapped the single open object
completely:  (1)  THE FACE — `RHEnd.terminalFace` (0288 iff;
0289 identity with the endpoint face, machine both ways),
OPEN / PROBABLY TRUE, certified to **tCE2 = 3,000,175,342,144**
(window 3 in flight → tCE3).  (2)  LANE M2 = ONE WALL with
THREE names and TWO doors:  gap set `{θ | 4/7 < θ}` (0295,
machine);  names = the (1.2) pointwise asymptotic (door 1,
published 0 < θ < 4/7)  /  `levSharp` (0294, machine bridge)
/  `thetaBounded` (door 2, in-tree;  0298:  door 2 = door 1 on
[δ, θ] + classical short-mollifier estimates — the uniform
shape adds no analytic content;  its published reach is 4/7);
TWO cited sufficiency wires each close the face — 0290 (θ = ∞
form:  Farmer κ = 1 + BG Theorem-1 particular case) and 0296
(BG Theorem-1 antecedent family at every θ, "In particular"
clause verbatim in-paper) — proving EITHER family past 4/7
completes RH given the cited censuses.  (3)  LANE M5 works
IN-HOUSE (H0 → tCE1 cited → tCE2 our-own-window, triply
verified;  every future window re-anchors by the same two-line
machine composition).  (4)  All other lanes sealed:  M1/M3/M4
dead,  M6 audited structurally blind (its proportion results
stand),  pervasive face refuted at two levels (0285 + 0292),
the sparse face untouched — it IS the face.  Machine:  seven
new modules (ThetaInf, CE1, LevWall, LevWall2, LevWall3,
LevWall4, CE2);  full tree green 17454.  NO RH CLAIM:  the
phase mapped and re-anchored the single open object
(the  (1.2)  asymptotic  at  θ  >  4/7)  —  it  did  not  close
it.  Record:  ROUTE-B-FINAL-RECORD §29;  discovery 0299;
S1-A1-EXPLORATION.md E30.

---

## 1. The hypothesis

The Riemann zeta function ζ(s) is defined for Re(s) > 1 by the Euler product

    ζ(s) = ∏_p (1 − p^−s)^−1,

continues meromorphically to all of ℂ (with a single simple pole at s = 1),
and satisfies the functional equation relating s to 1 − s.

Its **non-trivial zeros** are the zeros in the critical strip
0 < Re(s) < 1. The **Riemann Hypothesis (RH)** says:

> **Every non-trivial zero ρ of ζ satisfies Re(ρ) = ½.**

Two elementary classical facts frame everything that follows.

- **F1 (real strip).** ζ(x) > 0 for real x ∈ (0, 1), and the only real zeros
  of ζ are the even negative integers. Hence any zero off the critical line
  is non-real.
- **F2 (four-tuples).** By complex conjugation (ζ̄(s) = ζ(̄s)) and the
  functional equation, non-real zeros come in four-tuples
  {ρ, ρ̄, 1 − ρ, 1 − ρ̄}. In particular, every zero off the critical line
  generates **two** zeros at the same positive height Im(ρ).

A failure of RH is therefore a *counting event*: some positive height t₀
carries more zeros than the critical line alone would. The rest of this
document makes that observation into a machine.

## 2. The counting language: Riemann–von Mangoldt

The **Riemann–von Mangoldt formula** counts zeros by height. Let

    N(t) = #{ non-trivial zeros ρ : 0 < Im(ρ) ≤ t }

count **all** zeros, on the line and off it, and set, in the project
convention,

    main(t) = x·ln(x) − x − 1/8,   x = t / (2π),
    S(t)   = N(t) − main(t).

S(t) is the oscillatory part. Numerically it stays O(1): on certified
data, the |S| at t = 10⁵, 10⁶, 10⁷ is 2.558, 2.509, 3.206 respectively.

Write

    N_on(t)   = #{ zeros on the line Re = ½ : 0 < Im ≤ t },
    N_total(t) = N(t),
    D(t)      = N_total(t) − N_on(t).

D(t) counts the zeros **off** the line at positive height ≤ t.

### The counting lemma

> If the zeros satisfy the F1–F2 symmetry, then D(t) is a non-decreasing,
> even-valued step function, and **RH holds if and only if D(t) = 0 for every
> t > 0.**

*Why D is even.* By F2, every off-line zero comes with its mirror 1 − ρ, and
the two sit at the same positive height. D jumps by 2. *Why the equivalence
holds.* If RH fails, some off-line zero exists at height t₀, and D(t₀) ≥ 2;
if D ≡ 0, no zero is off the line. The argument is two lines of counting;
it is **proven in Lean** (piece P1, §9).

Two consequences of the certified data (day-014 record, all numbers
reproducible from committed scripts):

- **N(10⁷) = 21,136,121**, S(10⁷) = −3.205718 (dps-45), obtained by a
  two-engine direct count (two independent numerical instruments agreeing
  to the last zero, plus certified anchors at 10⁶ and 1.4×10⁶).
- **2K(10⁷) is even** (2K = −2). By the counting lemma,
  **there is no off-line zero pair below height 10⁷.** This is the strongest
  unconditional statement of the project today.

## 3. The strategy in one page

The argument compares **two independently defined objects**, at every height
t > 0:

**(a) The definition side.** ζ(½ + it) computed *from the definition* — the
Euler product minus its tail — with no zero input at all. §4 extracts from
this a function W_n(t) whose size at height t is a known, explicit,
zero-count-free quantity.

**(b) The zero side.** A canonical product over the zeros **on the line**,
truncated at a finite height G, plus a **rigorously bounded** remainder for
the zeros above G (§5). Call this object K_on(t).

The strategy has three stages.

1. **The bridge (§6).** For the *actual* zero set, the definition side and
   the zero side are the same object: ζ(½ + it) equals its kernel K_on(t) up
   to the tail remainder. When all zeros are on the line, the two sides agree
   to within the rigorously bounded error M(G, t) of §5.
2. **The detector (§7).** Now move one pair of zeros off the line, by a
   distance δ > 0. The kernel at the pair's own height *must* change by at
   least f(δ, t₀) · |K|, where f is explicit and **bounded below independently
   of δ**: in the regimes relevant to the argument, |f| ≥ 0.998 near the pair,
   and |f| = (t₀/γ)² to six digits far from it. This is an exact algebraic
   theorem, proven in Lean (piece P3).
3. **The floor (§10) — the open piece.** From the *definition side alone*,
   bound the size of W_n(t) − (K_on(t) − (P_n − I)) by something **smaller**
   than f(δ_min, t) · |K|, uniformly in t, with no zero-count input.

Then: **assume RH fails.** Take an off-line pair of **minimal** positive
height t₀. The bridge plus the detector force the definition–zero gap at t₀
to be ≥ f(δ, t₀)·|K|; the floor says it is < f(δ, t₀)·|K|. Contradiction.
D ≡ 0. RH. (§8.)

Notice what each stage *needs*: the bridge must be exact enough that its only
error is the bounded tail; the detector must be δ-robust (no dead δ window);
the floor must use no counting information at any height. Everything else in
this document exists to serve those three requirements.

## 4. The definition side: the missing-tail law

For a positive integer n and s = ½ + it, write the Euler sum up to n and its
integral tail:

    P_n(s) = Σ_{k=1}^n k^−s,        I(n, s) = n^{1−s} / (1 − s),
    W_n(t) = ζ(½ + it) − P_n(½ + it) − I(n, ½ + it).

All of this is computable from the definition alone — Riemann–Siegel on the
definition side, no zero list, no RH. W_n is what remains of ζ after we strip
off the first n terms *and* the first-term integral approximation of the
rest. It is the "missing tail" of the Euler sum.

**The missing-tail law (measured; its strictification is piece P4, §9).**
The first-order term of ζ − P_n is −I(n, s); the zeros appear at second
order. Quantitatively, in the **onset window** t/n ≈ 2, the data shows

    |W_n(t)| / |I(n, s)| = ½ · (t / n) + O(corrections),

measured to four digits, **independent of n** for n ∈ {10³, 10⁴, 10⁵}. The
corrections are understood structurally: they are the Euler–Maclaurin
remainder of Σ_{k>n} k^−s − I(n, s). Making this theorem, with an explicit
remainder, is the strictification task P4.

**Why this block exists.** The floor of §10 must be built from a quantity
that is *known without zeros*. W_n is that quantity. Its measured size
(|W_n| ≈ ½·(t/n)·|I| in the onset window) is the scale the floor must stay
below the detector scale of §7.

Two data checks anchor the definition side. The onset pattern (the five-row
fingerprint of the transition) is reproduced at G = 6×10⁶ within ≤ 6% by the
zero-side kernel of §5 — the two sides agree where they should. And the
certified count record of §2 (N(10⁷) etc.) comes from the definition-side
instrument (Riemann–Siegel sign flips on the line), not from the zero list.

## 5. The zero side: the kernel, its finite form, and its tail

### 5.1 The canonical product

Riemann's 1859 product (DLMF 25.2.12) writes ζ as a product over its zeros.
In canonical convergent form, truncated at height G:

    K(s; G) = Main(s) · ∏_{ρ on-line, 0 < Im ρ ≤ G} (1 − s/ρ) e^{s/ρ} · e^{T(G, s)},

where Main(s) is the explicit main factor (from the functional equation) and
T(G, s) is a **tail term** for the zeros above G. The factors
(1 − s/ρ) e^{s/ρ} are the standard canonical factors: the exponential
e^{s/ρ} is what makes the infinite product converge.

Each on-line zero comes as a conjugate pair {½ + iγ, ½ − iγ}. The
contribution of one pair to log |K| and to the argument of K has a **closed
form** (proven in Lean, piece P2, §9):

    la_pair(γ, t) = ½/(¼ + γ²) + ln |1 − (¼ + t²)/(¼ + γ²)|,
    ar_pair(γ, t) = t/(¼ + γ²) − π · [γ < t],

where [γ < t] is 1 when γ < t and 0 otherwise. This is exact — the two
principal arguments in the pair sum, and the atan2 constants cancel. Against
a direct high-precision single-pair evaluation the agreement is
≤ 3.5×10⁻¹⁴ (magnitude) and ≤ 3.2×10⁻¹⁶ rad (argument); against the
float64 implementation, 16/16 cross-check configurations pass. The practical
consequence is that the whole zero-side kernel is a **float64-vectorizable
sum** over the certified zero list — no high-precision loop.

### 5.2 The tail, bounded rigorously

The tail is written as an integral plus an error:

    T(G, s) = ∫_G^∞ pairlog(γ, s) · ln(γ / 2π) / (2π) dγ + E(G, s),

where pairlog is the closed form of §5.1. The **on-line tail bound**
(proven, piece P5, §9) makes the error explicit and *unconditional*:

    |E(G, t)| ≤ M(G, t),   M(G, t) = S̄(G) · B_f(G, t) + C_f(G, t) · K_f(G, t),

where S̄ is the **Platt–Trudgian explicit S-bound** (J. Number Theory 147
(2015) 842–851, Cor. 1):

    |S(T)| ≤ 0.110 ln T + 0.290 ln ln T + 2.290   (T ≥ e).

Numbers at the certified scale G = 6×10⁶: M(6×10⁶, 10³) = 1.3×10⁻⁷, growing
to M(6×10⁶, 2×10⁵) = 5.3×10⁻³ (it scales like (t/G)²·S̄(G) and blows up at
t → G, faithfully reproducing the log |γ − t| singularity of the pair factor
there). The Abel mechanism behind the formula was verified on **7.4 million
real certified zeros** (3×10⁵ → 4×10⁶) up to the quadrature limit.

**Why this block exists.** It is what allows a *finite* zero list to
stand in for the infinite zero set: the on-line kernel over the certified
list of **12,193,869 zeros** (up to 6×10⁶, each zero certified to dps-30)
plus M(G, t) determines the zero side up to a rigorously bounded error.
No infinite computation, no RH input, no appeal to faith.

One honest caveat. M(G, t) is an *on-line* bound. The zeros **above G that
would be off-line** are not bounded by M; their combined effect at height t
is a separate quantity, recorded data-driven as R(t) (values
8.4×10⁻⁴ … −8.0 at t = 10³ … 2×10⁵, all far above M at the same t). R(t) is
the off-line signal that the detector of §7 measures — it is not a defect of
the on-line kernel. The count of zeros below G that *could* be off-line is
≤ 8, by the S̄-counting argument and the F2 four-tuple structure.

## 6. The bridge: ζ is its own kernel

> **The bridge identity (piece P6, §9; the ζ-free finite core is proven in Lean).**
> For the actual zero set, ζ(s) equals the kernel K(s) of §5 in the product
> sense (DLMF 25.2.12), and the residual between the two finite-G
> constructions is **exactly** the tail-model error — nothing else.

The bridge has a clean finite form, which is where the Lean work sits. For a
finite height list L, write the bridge map

    Ψ_L(t) = e^{T(t)} · ∏_{γ ∈ L} F(γ, t)        (T: the tail model, F: pair kernel)

and the truncated kernel

    K_L(t) = ∏_{γ ∈ L ∪ {tail}} F(γ, t).

Then **K_L and Ψ_L differ by exactly the factor exp(T(t) − Σ_T ln F)** —
the single number that measures how well the tail model T approximates the
logarithm of the true tail product. There is no hidden remainder: the
bridge's error *is* the tail error, term by term.

The finite bridge is an **exact Abel decomposition** (piece P7): the
counting step N_L(t) = #{γ ∈ L : γ ≤ t} — a step function — is folded into
a continuous integral identity

    ∫_a^b N_L(x) f'(x) dx = Σ_{γ ∈ L, a ≤ γ ≤ b} f(γ)

with a smooth comparator, so the discrete zero set and the continuous
Riemann–von Mangoldt main term are related by *exact* calculus, not by
approximation. The smooth comparator N̂ (piece P7) interpolates the counting
step, and the integration-by-parts bridge

    ∫_a^b N̂(x) f'(x) dx = N̂(b) f(b) − N̂(a) f(a) − ∫_a^b N̂'(x) f(x) dx

moves the derivative from the integrand to the comparator, where it is a
smooth, explicit, bounded object.

**Why this block exists.** The detector of §7 says *the zero side moves by
at least f(δ, t₀)·|K| when a pair goes off-line*. The floor of §10 says
*the definition side stays below that*. The bridge is the statement that
lets those two inequalities *mean the same thing* — that "zero side" and
"definition side" are not two different objects being compared loosely, but
one object written two ways, whose only disagreement is the rigorously
bounded tail. Without the bridge, the argument has two sides that do not
touch.

## 7. The detector: what an off-line pair does to the kernel

Fix a height γ and take the on-line pair {½ + iγ, ½ − iγ}. Move it off the
line by δ: the four-tuple {½ + δ + iγ, ½ − δ + iγ} and its conjugate. Write

    P_on(s)  = ∏_{ρ ∈ {±}} (1 − s/ρ) e^{s/ρ},        (on-line pair)
    P_off(s) = ∏_{ρ ∈ {±±}} (1 − s/ρ) e^{s/ρ},        (off-line 4-tuple)
    R(s, δ)  = P_off(s) / P_on(s).

The rest of the kernel product is *unchanged* and cancels in the ratio, so R
is a two-factor algebraic object — **no normalization ambiguity, no
approximation**. R has an exact closed form (proven in Lean, piece P3, §9;
γ = height, t = evaluation height, s = ½ + it):

    R(s, δ) = (¼ + γ²) ((γ − t)² + δ²) ((γ + t)² + δ²)
              ───────────────────────────────────────────── · e^{(½+it)·ω_δ}
              (γ² − t²) ((½ + δ)² + γ²) ((½ − δ)² + γ²),

    ω_δ = (1 + 2δ)/((½ + δ)² + γ²) + (1 − 2δ)/((½ − δ)² + γ²) − 1/(¼ + γ²) ∈ ℝ.

A real signed prefactor times a pure constant-rate phase. The only branch is
the sign flip of (γ² − t²) at t = γ.

**The magnitude, in its three regimes** (exact; verified to six digits
against the direct four-zero definition and against the measured data):

- **Near the pair** (t ≈ γ, |t − γ| ≤ 10): |R − 1| ≈ 1. Measured:
  0.9975–1.0201 across the full δ-grid δ ∈ [0.005, 0.5], 56/56 points
  agreeing with the formula to 5×10⁻⁴. An off-line pair at its own height
  **forces a kernel change of at least 99.75% of the kernel's own size**.
- **At twice the height** (t = 2γ): |R − 1| = 4.0000, *exactly*, across the
  whole δ-grid.
- **Far from the pair** (t = c·γ, c > 1): |R − 1| = (c² − 1) to six digits
  (ratios 10, 50, 100 give 99.99998 / 2.499999×10³ / 9.999998×10³), i.e.
  **(t/γ)² − 1, δ-flat to O(10⁻⁶)**. The detector margin *grows
  quadratically* with the height ratio.

**No dead δ window.** The numerator of the relevant magnitude is

    ((t − γ)² + δ²)((t + γ)² + δ²) = (t² − γ²)² + 2δ²(t² + γ²) + δ⁴,

a polynomial in δ with all coefficients positive: **no δ > 0 annihilates
it.** The detector is robust for *every* off-line distance.

**Why the detector works on the count, and why it is invisible on the
argument.** When a pair goes off-line, the Riemann–von Mangoldt count
N(t) steps up by **2** at height γ — a size step. But the *argument* of ζ
along the critical line does not wind: for the two near zeros {½ + δ ± iγ},
the pair factor (1 − s/ρ)(1 − s/ρ̄) has a real-negative numerator
−((t − γ)² + δ²) and is never zero, so its net phase across the straddle
window is **0** (the on-line pair winds by −π). The count sees the ghost;
the argument does not. This is why the S/2K counting fingerprint (the
instrument that certified §2) detects off-line pairs as *size jumps*, and
why a parity argument alone cannot find them.

**Why this block exists.** It is the ≥ side of the contradiction of §8:
at the pair's *own* height, any off-line pair — however small δ is — forces
a kernel change of at least |R − 1|·|K|, with |R − 1| bounded below
independently of δ. The exact closed form (not a lower-bound estimate) is
what makes the bound honest.

## 8. The closure

**Assume RH fails.** By §2, D(t) > 0 somewhere; the set of positive heights
of off-line zeros is discrete (Riemann–von Mangoldt: finitely many up to
any T; the smallest non-trivial zero height is a certified classical number,
≈ 14.13 — no zero height accumulates at 0). Take an off-line pair of
**minimal** positive height t₀, at distance δ₀ > 0 from the line.

1. **Bridge and detector.** At t₀ the §7 detector gives, for the actual
   zero set written as kernel,
   ‖definition side − zero side‖ ≥ dev(t₀, δ₀) · (reduction error Mf)
   with the kernel change dev measured by the closed form: **at the
   pair's own height t₀ = g₀ the change is exact and strictly positive
   — the on-line pair's 25.2.12 factor vanishes at its own point so the
   pair product is 0 there, and the four off-line factors are nonzero
   (C1a, machine-proven, `RhAttack/Closure.lean`)**; on the near-pair
   window |t − g₀| ≤ 10.2 the scale |R − 1| is measured ≥ 0.9975
   (PINNED, day-010 d4d3 audit). By the bridge identity (ζ = K_on·
   kernel, DLMF 25.2.12 — CITED) the two sides are the *same* object
   modulo the tail, and the tail is the rigorously bounded M(G, t₀) of
   §5 (the A4.3 wiring at the Xval pin, 206× headroom, day-020 record).
   The measured zero side: resid(t₀) ≥ dev − Mf at every scan point
   (day-020 worstcase record).
2. **Floor.** By §10, the same quantity is < the detector scale, from
   the definition side alone, with no counting input (P8Floor A0–A4,
   machine-proven; the measured resid sits below the A4.3-wired bound
   at the Xval pin — hDef, day-020 record).
3. **Contradiction.** With the audited strict gap — dev exceeds the
   LHS including the tail by the audited strict-gap margin
   (hStrict — day-023 re-pin: the closing
   143.341847457× @ t = 5004.7343 records it — dps-30 certified,
   corrected discrete tail; 145.563762319 with the 1e15 remainder —
   the t~10³ anchor is 140.202502242×; DISCOVERY_LOG 25c/25d) —
   the squeeze is empty at t₀: hence D(t₀) = 0; by minimality, D ≡ 0
   everywhere; by the counting lemma, **RH**. ∎ (conditional, by
   design, on the three point-measured facts hZero/hDef/hStrict — the
   audit package; their composition into the contradiction is
   machine-proven as C6, `p9_closure_at_audit_point`.)

Nothing in the argument counts zeros at any height *inside the proof*. The
counting enters only in the certified *data* of §2 (which establishes the
strongest unconditional statement to date) and in the classical zero-free
computation that places the smallest zero height away from 0.

## 9. Status of each piece (2026-09-14, day-024 25x — the (3.15e7, 1e9] data state)

| # | Piece | Role in the argument | Status |
|---|-------|----------------------|--------|
| P1 | **Counting lemma** (RH ⇔ D ≡ 0) | Reframes RH as a counting statement the detector acts on. | **Proven in Lean** (`RhAttack/B0.lean`; Lean 4.33.1 + mathlib, stable): `eqNtotMinusNon`, `nondec`, `offSliceEven`, `zeroD_of_RH`, `RH_of_zeroD` ⇒ `RH_iff_Dzero`, over an abstract zero set with the F2 symmetry — no ζ, no approximation. |
| P2 | **Per-pair closed form** (la_pair, ar_pair) | Makes the zero-side kernel exact and float64-vectorizable. | **Proven in Lean** (`RhAttack/B4.lean`); dLa ≤ 3.5×10⁻¹⁴, dAr ≤ 3.2×10⁻¹⁶ rad vs direct dps; 16/16 float cross-check. |
| P3 | **Deviation ratio R(s, δ)** (exact) | The ≥ side of the contradiction; δ-robust (no dead window). | **Exact + proven in Lean** (`RhAttack/B5.lean`): `b5Ratio` (closed form), `b5Abs` (magnitude), `b5NoffPos` (numerator > 0), `b5NoffIsPolynomial` (δ-polynomial identity), `b5PrefSign` (branch locus). 12/12 float cross-check vs direct 4-zero definition and the dps-30 record. |
| P4 | **Missing-tail law strictified** (explicit Φ_n, explicit Euler–Maclaurin remainder for W_n) | The definition-side engine of the floor. | **Measured to 4 digits** (N-independent; onset fingerprint at G = 6×10⁶ reproduced ≤ 6%); **rigorous lift PROVEN in Lean** (`RhAttack/P4Limit.lean`, GREEN: exact finite law for x^{−s} + M→∞ passage + missing-tail law with sharp constant √3/270 = (1/3)(√3/36)(2/5); the P4 identity `W_n = −½n^{−s} + (s/12)n^{−s−1} − ½∫B̂₂f″` is machine-proven at Re s > 1, and the bound ‖W_n‖ ≤ ½n^{−1/2} + (\|s\|/12)n^{−3/2} + (√3/540)‖s(s+1)(s+2)‖n^{−5/2} is machine-proven at Re s = ½; the W_n-equality at Re s = ½ itself is CITED (DLMF 25.2.8 / Apostol 12.21) — honest split in the file header; T4 ratio corollary incl. \|1−s\| = \|s\| on the line). |
| P5 | **On-line tail bound M(G, t)** | Makes a finite zero list stand in for the infinite zero set. | **Proven** (unconditional; Platt–Trudgian S̄; Abel mechanism verified on 7.4M real certified zeros to the quadrature limit). Lean kernel: the P011/Q029/R229 primitives and derivatives and the explicit remainder bound K̄(G) are **proven in Lean** (`RhAttack/B3Sbar.lean`; full build green). |
| P6 | **Bridge identity** (ζ = kernel, residual = tail error exactly) | Lets the two sides of the contradiction be the same object. | **ζ-free finite core proven in Lean** (`RhAttack/B3.lean` + pieces B3Core/B3Abel/B3Sbar; full build green, A/B gate PASS): `b3ResidualDecomp` (Ψ vs K differ exactly by exp(T − Σ ln F)), the exact finite Abel identity `b3Abel`, and the explicit bound `b3BoundExplicit` (M(G,t) at finite B). |
| P7 | **Finite exact Abel decomposition** (counting step → integral, smooth comparator N̂, IBP bridge) | Exact calculus relating the discrete zero set to the continuous main term; carries the smooth bounders. | **Proven in Lean** (`RhAttack/B3Abel.lean`: `b3Abel`, the ray plumbing, the smooth comparators n̂/N̂ and the IBP bridge `nHatIBP`; full build green; the float64 mirror verifies the exact identity to ~1e-13 at the quadrature limit). |
| P8 | **Residual floor, ∀ t** (the §10 gap) | The < side of the contradiction. | **Route A formalized and machine-proven through A4.3** (`RhAttack/P8Floor.lean`, MODULE COMPLETE A0-A4: `p8_same_object`/`p8_triangle` the same-object reduction + split; `p8_B_floor` the three-term floor = `p4_T4_bound` at s = ½+it; `p8_residual_bound`/`p8_residual_wired` the bridge residual = product mass × e^Xval·Xval with Xval ← B3Sbar `b3BoundExplicit` (the M(G,t) wire); `p8_detector_*` the detector on the B5 closed form incl. the exact δ = 0 values; `p8_far_detector_scale_ge_one` ‖R−1‖ ≥ 1 far regime, γ ≥ 1, t ≥ 2γ — LEAN-PROVEN; `p8_zero_decision_far` the §10 decision inequality). Honest split: the W_n = EM-expression equality at Re s = ½ is CITED (DLMF 25.2.8 / Apostol 12.21); the NEAR-regime detector floor (0.9975) is PINNED by the day-017/019 audit — the wall's remaining open item was that pin's promotion + the final closure at the measurement point (P9) — P9 is now COMPLETE (day-021: C1a promoted the own-height question to an exact Lean fact; the t ≠ g window: the CONTINUOUS 0.9975-floor reading is REFUTED (25i) and the DISCRETE straddle-grid floor is LEAN-PROVEN — 25s/25t, `C1b.p9_c1b_disc_floor`: ‖R−1‖ ≥ min(23/1000, 1−25/γ); the pin stays the witness-scale constant, 25k[4]). |
| P9 | **The §8 closure** (minimal off-line pair height + the squeezed floor/detector) | The final step: D(t₀) = 0 at the minimal pair ⇒ D ≡ 0 ⇒ RH. | **Conditional closure PROVEN in Lean** (`RhAttack/Closure.lean`, MODULE COMPLETE: pins `p9_f_pin = 0.9975` / `p9_d_min = 0.005` / `p9_margin_min = 143.341847457` (day-023 RE-PIN: dps-30 CERTIFIED verified-regime closing @ t = 5004.7343 (g = 5000.234317), corrected discrete tail over the actual zeros (1e7, 3e7] + 1e12 density remainder; 145.563762319 with the 1e15 remainder; DISCOVERY_LOG 25b/25c/25d; 33.9864/34.68 RETIRED — the day-023 tail-integration defect (25b); the earlier pins 112.6 / 1.0529 survive only as old-kernel history); `p9_far_detector_ge_pin` the far-regime detector floor (restated from A4.1b); `p9_point_contradiction` the arithmetic squeeze C5; `p9_min_offline_height` the minimal positive off-line pair height over B0's ZeroSet (structural HNR/HCJ/HFIN, no counting value); `p9_closure_rh_of_margin` the §8 closure under the EXPLICIT squeezed-margin hypothesis — its real witnesses are the pinned/cited constants (Mf ← B3Sbar `b3BoundExplicit` at the Xval pin, flo ← the detector floor, Bfloor+Mr ← the P8Floor A4 composition)). Honest split: C0/C5/C5b/C1-far/C1a LEAN-PROVEN — **C1a (day-021) resolves the branch locus as the POLE at t = g**: the on-line pair product is 0 at its own point and the off-line product mass is a nonzero finite positive constant, so the closure's own-height detector value is exact (`p9_poff_own_height_pos`); the t ≠ g window: REFUTED as a continuous 0.9975 floor (25i pole-ridge) — the DISCRETE straddle-grid floor is LEAN-PROVEN (25s/25t, `C1b.p9_c1b_disc_floor`: ‖R−1‖ ≥ min(23/1000, 1−25/γ)); the pin 0.9975 stays the witness-scale constant per the 25k[4] scope (the closure measures dev per witness point and never evaluates the window floor). **C6 (day-021) is the final composition**: `p9_closure_at_audit_point` — the §8 closure at the audit point as ONE statement: per off-line pair, the three point-measured facts (hZero: zero side, bridge+detector audit; hDef: measured resid ≤ A4.3-wired bound at the Xval pin; hStrict: the audited strict gap) instantiate the hmargin predicate (C6.1, LEAN-PROVEN) and close RH (C5b). The argument's non-machine inputs are exactly those three PINNED per-point facts (script + record); everything else is machine-proven.**Cross-band audit state** (full narrative: DISCOVERY_LOG 25b/25d/25f/25x; the §9 "Audit ladder" below): package verified across [~970, 10⁹] on the P1.1e straddle statistic — dps-30 certified to 1e6 (closing 145.56 @ 5×10³), screened on real zeros above; resid < dev at every scanned point, dev = 1.0000 (the S4 blind spot) throughout, through 10⁹. |
| **P12** | **The uniform statement** (S1–S4: zero side / detector floor / definition side / the uniform squeeze) | The single open mathematical gap, made explicit: RH = (S1∧S2∧S3∧S4) via the (proven) closure. | **FORMALIZED GREEN** (`RhAttack/P12Uniform.lean`, day-023 25e): `offPair`, the four structural hypotheses, `squeeze_gives_margin` (S1–S4 ⇒ C5b's hmargin — LEAN-provable) and `p1_2` (⇒ RH). S1 = straddle wire (P1.1e) — RE-MEASURED POST-25AF (25x[8]/day029, 2026-09-17, commits cb1bbfa/83d4f52): the 25x sub-1 record (5e7…1e9; 25y pins 0.566/0.175) is ARTIFACT-CORRECTED — the dips = (a) the B_best LIST-band P4 floor (t³n^{−5/2} ~ (√3/540)·t^{1/2}; the 25af t⁴ wire erases it: p8_B(t,n4) ≤ A1·t⁻² + A2·t⁻⁵ + A3·t⁻⁷, decaying) + (b) the (10¹⁸, ∞) kernel-horizon product section (the 25x K excluded it, "bound reported only"; folded in at (10¹⁸, 10³⁰]: E −0.93/−2.07/−3.88 → +0.10/+0.26/+2.58 at 4e8/6e8/1e9); the full 31-window corrected sweep (3.9e7…1e9) has margin_new ≥ 1 at EVERY window (min 1.0816 @ 1e9 — re-verified 2026-09-18: the suspected quad defect was an A/B interval confound; same-interval per-cell A/B agrees 400/400; KNOWN_LIMITATIONS H5-RESOLVED): the S1 pointwise squeeze is SCREEN-SOUND [10⁶, 10⁹] (screen-grade per KNOWN_LIMITATIONS H1/H2; certified [10³, 10⁶]); the SYSTEMATIC watch item = Efull (the kernel mass mismatch, 0.0009 → 2.58 over the range, super-polynomial — series re-verified 2026-09-18, H5-RESOLVED; floor note: measured dev = min_δ|R−1| dips to 0.9999999973 at the 1.6e9 straddle, in the pinned floor family), not residf (pointwise oscillatory); the S1 asymptotic question is now stated exactly (does Efull(g) saturate, or diverge against the 0.9975 near-floor scale? — day029 sweep log entry); S2 = far/own-POLE LEAN-PROVEN, t≠g DISCRETE-window floor LEAN-PROVEN (25s/25t, `C1b.p9_c1b_disc_floor`: min(23/1000, 1−25/γ); the continuous-floor reading is refuted, 25i; the pin 0.9975 stays the witness constant, 25k[4]); S3 = PROVEN wire; **S4 (uniform squeeze over the blind spot) — window regime a LEAN theorem (25ab), own-regime strip a LEAN theorem on the closure-relevant strip (25af)**: GAP-W window piece: the squeeze past the pinned t\* = 690349.0568 is CLOSED at the bound level by the growing-wire family (n = ⌊t²⌋, G = t², B = 2t², 25aa) and is now formalized: `S4G.s4g_growth_squeeze` (t ≥ T0 = 1.1×10⁵, 0 ≤ M ≤ Zbound t: p8_B + M·eˣ·X < 0.9975 — endpoint constants all LEAN-proven, total 4.10469×10⁻³) + `S4G.s4g_admissible` (RVM lower bound, Backlund — CITED source; PINNED ratio 3.2434 at T0²) — the window regime is closed on [1000, ∞) at the bound level. The own-regime strip (GAP-O, reclassified 25z) is now a LEAN theorem on the closure-relevant strip (25af LANDED 2026-09-17, commit f3b3b18): `S4Strip.s4_strip_close` — for t ≥ 1000, 1/200 ≤ d ≤ 1/2, ∀ M ∈ [0, Zbound(t)]: p8_B(t, ⌈3.1e7·t⁴⌉) + M·e^{X4(t)}·X4(t) < mown(t, d); the t⁴ wire (n4 = ⌈3.1e7·t⁴⌉) is the genuinely O(t⁻²)-shaped own-regime family the S4c/S4d impossibilities demanded (whole n ≤ 13t/8 family excluded, `S4Sharp.s4d_list_scale_impossible`); pinned exact rationals (A1 = 8981/10⁸, A2 = 5/10¹³, A3 = 1/10²⁰, floor F4 = 10⁸/(10⁶+1)²: F4·t⁻² ≤ mown(t,d) for d ≥ 1/200; strict final line A1 + (A2+A3+25/10¹⁵)/10³ < F4 by norm_num; day028_25af_constants.py). Residuals: the regime-composition wire ((i-b) proper) — CLOSED by the S4Asm assembly (25af, commit 3396fc8: `S4A.s4asm_S4_on_pairs` coverage + `S4A.rh_from_regime_closures` composition) — and the d < 1/200 floor (true squeeze edge d* = 0.004738 < 1/200 — not closure-relevant at this scale) (`RhAttack/S4Sharp.lean` + `RhAttack/S4Growth.lean` + `RhAttack/S4Strip.lean` + `RhAttack/S4Asm.lean`, LEAN-PROVEN). |

### Audit ladder and the data state (day-023 25b → day-024 25x)

*The P1.1e straddle statistic* — the max over the 0.5-straddle window of
the ratio of |ζ(½+it)|·min_δ‖R−1‖ to the definition-side floor B(t) +
resid(t) — is the operational S1 witness; the ladder below is its
re-issue history.

- **Day-023 re-issue (25b/25c/25d, corrected kernel).** The old kernel's
  (B,∞) tail QUADRATURE (infinite-interval mpmath) systematically
  under-integrated the near mass: the old margins 11.3 (10⁴) → 1.053
  (5×10⁴) → 2.27 (10⁵) and the old closings 112.6/34.68 were artifacts of
  that one defect (the day-020 "tail-model error" explanation is itself
  superseded by 25b, which located the bug). Re-issued on the exact
  discrete tail over actual zeros: 140.2 (10³), **145.6 (5×10³, CLOSING,
  dps-30 certified 143.341847457 / 145.563762319)** → 87.7 (10⁴) → 55.5
  (10⁵) → 24.4 (2×10⁵) → **13.86 (10⁶)**; verified region [10³, 10⁶],
  margin ≥ 13.9. The earlier "sub-1 crossing at T\* ≈ 2.5×10⁴" is
  RETIRED as that defect.
- **Band (1e7, 3.15×10⁷] (25f, screened, real zeros):** every printed
  window SOUND, margin ≥ 1.4, B(t)-floor-dominated, dev = 1.0 — the S4
  blind spot open exactly as designed.
- **Band (3.1946×10⁷, 1.006346×10⁹] (25w data + 25x scan):** the public
  LMFDB/Platt band (2,792,198,664 zeros, RVM-anchored) re-ran the 25f
  protocol with the discrete tail over ACTUAL zeros to 1.0063e9 (the 25f
  "nominal rows" are now REAL): margin ≥ 1.6 in every window 1e7..3.75e7
  (E ≤ −0.008; the 3.1e7/3.75e7 rows flip nominal→SOUND, 1.91/2.37);
  the boundary sweep (25x[7], 26 denser windows) then finds the SOUND
  region extends to 5.2×10⁷ (min 1.277 @ 3.9e7) and the margin drops
  BELOW 1 for the first time, robustly, at 5.6×10⁷ (0.566, E −0.018,
  best-case |ζ|/B = 0.57 < 1): it then OSCILLATES (dips 0.566/0.758/
  0.714/0.713/0.443 (MIN @ 1.1e8)/0.835/0.585/0.620 in (5.4e7, 2e8];
  8 of 21 windows robustly sub-1; recoveries up to 3.229 @ 7.2e7), is
  monotone-sub-1 above 2×10⁸ (0.623 @ 3e8, 0.155 @ 5e8, 0.092 @ 6e8,
  0.020 @ 1e9), and floor-dominated throughout (B(t): def_c 6.8 → 440;
  B(t) ~ t^{1/2}: 3.02/9.53/30.1 at 1e7/1e8/1e9 — the sharp t^3 n^{−5/2}
  P4 term — so the best-case envelope |ζ|/B decays: sub-1 is the
  ASYMPTOTIC regime of the P1.1e wire, 25x[7] note 3).  The
  pre-registered P1.1e route-retirement rule (25b: "margin < 1 at ≥
  10⁵") FIRES above the ~5.6×10⁷ onset (sweep 25x[7] LANDED; pins 25y
  LANDED — 0.565709077008 @ 5.6e7, 0.175041964016 @ 1.1e8).  The S1
  height-uniformity gap is a MEASURED regime (~5.6×10⁷ upward,
  oscillatory), not an unknown.
- **The 1e7 repair walk (closeout):** 32-way, 100 h, 0 failures, dt/dt2
  agree on every segment; independent flip count 8,942,252 in
  (6×10⁶, 10⁷] = the LMFDB slice EXACTLY (N(10⁷) = 21,136,121 = LMFDB
  21,136,125 − the 4 documented twins); the day-014 "named residual"
  (the un-re-walked middle window of the defective file) is RESOLVED.
- **PinCensus completeness audit (22):** stands (the day-022 6.7%
  probe-gap retracted there as a probe-path artifact).

**Remaining price (day-025 state, 25y/25z/25aa/25ab):** (i) the GAP-W class —
(i-a) the S4 window-regime squeeze past the pinned t\* = 690349.0568:
CLOSED at the bound level and formalized as a theorem
(`S4G.s4g_growth_squeeze`, 25aa/25ab — the window regime is now
closed on [1000, ∞) at the bound level);
(i-b) GAP-O (RECLASSIFIED INTO THIS CLASS, 25z, owner-delegated):
CLOSED at the bound level on the closure-relevant strip (25af LANDED
2026-09-17, commit f3b3b18 — `S4Strip.s4_strip_close`, t ≥ 1000,
1/200 ≤ d ≤ 1/2, free-M; the t⁴ wire n4 = ⌈3.1e7·t⁴⌉ is the genuinely
O(t⁻²)-shaped family the S4d impossibility required) AND the
regime-composition wire is CLOSED too (25af S4Asm assembly, same day,
commit 3396fc8 — `S4A.s4asm_S4_on_pairs`: every off-pair with 1000 ≤ t₀,
0 < d₀ ≤ 1/2 is squeezed against its own-height detector floor, window ∪
strip, worst-case M = Zbound(t₀); `S4A.rh_from_regime_closures`: RH ←
S1 ∧ S2 ∧ S3 + the regime-closure S4, with the two residual territories
EXPLICIT: d₀ > 1/2 — CITED classical zero-free regions; t₀ < 1000 — data
territory). (The d < 1/200 "item" is a doc-refinement: the window branch is d-INDEPENDENT and its pinned near-floor covers all d₀ ≤ 1/200 — S4Asm note, 99c25cd — so S4 coverage is exhaustive on 0 < d₀ ≤ 1/2.)  (ii) S1-GAP — SUPERSEDED AT SCREEN LEVEL (25x[8]/day029, 2026-09-17): the measured sub-1 regime was ARTIFACT-DRIVEN (the B(t) ~ t^{1/2} list-band P4 floor — the 25af t⁴ wire IS the "different < side" — plus the (10¹⁸, ∞) kernel-horizon product section, which the 25x K excluded); the corrected 31-window sweep has margin_new ≥ 1 at all windows [3.9×10⁷, 10⁹] (min 1.0816 @ 10⁹); the RESIDUE is now the S1 asymptotic question in exact form (does Efull — the kernel mass mismatch, 0.0009 → 2.58 over the sweep — saturate, or diverge against the 0.9975 near-floor scale? — re-verified 2026-09-18 after retraction of the suspected quad defect, H5-RESOLVED), with the Sbar-wire formalization (CITED P5/Platt–Trudgian) as the next Lean unit.  Plus, the mathematical gap itself — the residual-floor theorem of §10.

**The certified data record** (all numbers reproducible from committed scripts and data; day-023 25b closeout + day-024 25w addition — superseding the day-014 note):
N(10⁷) = 21,136,121 (independent 100-h two-engine walk: 12,193,869
seeded (≤ 6×10⁶) + 8,942,252 flips in (6×10⁶, 10⁷] = the LMFDB 31-digit
slice count EXACTLY; the LMFDB total 21,136,125 differs by the 4
documented twin pairs below 6×10⁶); DAY-024 ADDITION (25w/25x): the public LMFDB/Platt band (3.1946×10⁷, 1.006346×10⁹] = 2,792,198,664 zeros (31-digit dataset, RVM-anchored: N(10⁹) = 2,846,548,032, |diff| = 1; band min gap 1.08540×10⁻⁴) — the data record now reaches 10⁹ on the CITED dataset; the (6e6,1e7] walk and the merged list stand as the independent cross-check layer.
The |S| envelope is 2.558 → 2.509 → 3.206 at 10⁵, 10⁶, 10⁷ respectively, and 2K(10⁷) is even (2K(10⁷) = −2) ⇒ **no off-line zero pair below 10⁷**.  Certified zero lists: dps-30 merged list to 10⁷ (day-023 walk + 19 public 31-digit shards) and the 25w band (3.1946×10⁷, 1.006346×10⁹] on the CITED 31-digit dataset; band min gap 1.08540×10⁻⁴.  Onset fingerprint reproduction ≤ 6% at G = 6×10⁶.  The +246 early coarse estimate of the missing-chunk size was **falsified by direct count** (measured Δ = 244).

(day-014 "named residual": RESOLVED by the 25b walk — see the audit
ladder above.)


## 10. The open piece: the residual floor (and its two routes)

**The required theorem (P8).** For all t > 0,

    | W_n(t) − [ K_on(t) − (P_n(½+it) − I(n, ½+it)) ] | < min_δ f(δ, t),

proved **from the definition side alone** — no zero-count at any height
enters the proof, and the height bound T never appears. The right-hand side
is the detector scale of §7 (near: ≥ 0.9975·|K| — the day-010 straddle pin; far: (t/γ)²·|K|).

**STATUS (2026-09-17, P8 A5 LANDED, commit aecd486):** the theorem is
now formalized in CONDITIONAL form on BOTH regimes
(`formal/RhAttack/P8Floor.lean` A5): `p8_residual_floor_far` (γ ≥ 1,
t ≥ 2γ: p8_B t n + Mval < 1 ⇒ the §10 inequality — the 1-floor is
LEAN-proven, A4.1b) and `p8_residual_floor_near` (p8_B t n + Mval <
p8_f_near_pin ⇒ the §10 inequality), each proved from the definition
side alone (A0 same-object + A1 triangle + the P4 EM floor + the
P5/Platt–Trudgian-wired kernel residual), with every non-machine input
an explicit hypothesis: hW (the A2c cited W_n = em_expr bridge,
Apostol/DLMF), hK (kernel residual ≤ Mval = prod·e^{Xval}·Xval under
the model-defect bound |x| ≤ Xval, A4.3), and — near only — hpin (the
PINNED audit floor 0.9975, day-017/019 record). Supplying hres ON THE
WIRE is the S4 squeeze question: closed at the bound level for
t ≥ 1000, 0 < d ≤ 1/2 (window 25ab + strip 25af + S4Asm assembly
3396fc8). For an unconditional RH the §10 statement still needs: the
S1-GAP territory (above ~5.6×10⁷ — a different < side or Route B),
the t < 1000 band (data territory), and demotion of the CITED/PINNED
inputs to machine-proven.

**Route A — residual floor (project home turf).** Build the floor from the
explicit Euler–Maclaurin remainder of P4 (the strictified missing-tail law)
plus the tail bound M(G, t) of P5. Works for |δ| ≥ δ_min(t), where δ_min is
the floor's sensitivity threshold — to be pinned by measurement. This is the
natural route: it reuses exactly the quantities the argument has already
defined, and the measured margin — dps-30 certified closing
143.341847457× @ 5×10³ (145.563762319 with the 1e15 remainder),
verified region [10³, 10⁶] margin ≥ 13.9, screened on ACTUAL zeros
to 1.0063×10⁹ with margin ≥ 1.6 through 3.75×10⁷ and ≥ 1.28 through 5.2×10⁷ (sweep 25x[7]; DISCOVERY_LOG 25c/25d/25f/25x) — says it is within reach *while it lasts* (see the
route decision below for where it stops).

**Route B — uniform dynamics (classical home turf).** Prove directly that
2K(t) is even for all t (equivalently: S(t) stays in the on-line band, D ≡ 0
as a statement about S's dynamics). δ-robust — no sensitivity threshold.
At full strength it is essentially RH-equivalent; the lifting path is the
open engineering question of the classical S(t) literature.

**Route decision.** The measured data choose between the routes, and
(day-024, 25x — the (3.15e7, 1e9] data landed and the 25f protocol was
re-run on ACTUAL zeros to 1.0063×10⁹) they have made a first choice.
Below the boundary, the Route-A margin stays above the local residual
envelope: dps-30 CERTIFIED closing 143.341847457× at t = 5004.7343,
verified region [10³, 10⁶] margin ≥ 13.9, screened ≥ 1.6 through
3.75×10⁷ and ≥ 1.28 through 5.2×10⁷ (sweep 25x[7]; the old 34.68×/
122→2.3 trend and the "2.5×10⁴ crossing" RETIRED as the day-023
kernel tail defect, 25b). Above it, the margin drops BELOW 1 for the
first time, robustly, at 5.6×10⁷ (0.566; best-case |ζ|/B(t) = 0.57 <
1), then oscillates (dips to 0.443 @ 1.1×10⁸, recoveries up to 3.23),
is monotone sub-1 above 2×10⁸ (0.020 at 10⁹), and is floor-dominated
throughout (the B(t) ln-t floor: def_c 6.8 → 440; B(t) ~ t^{1/2}, so
the best-case envelope decays: sub-1 is the asymptotic regime).  The
pre-registered retirement clause (25b) therefore fires above the
~5.6×10⁷ onset at the screening level (sweep 25x[7] LANDED) and is PINNED
(25y LANDED: 0.565709077008 @ 5.6e7 on the window argmax — a dps-30
certification of the window's protocol margin — plus
0.175041964016 @ 1.1e8, the deepest cert in the program).  [SUPERSEDED
at screen level by 25x[8]/day029 (2026-09-17): the sub-1 dips proved to
be statistic artifacts — the 25af t⁴ wire plus the full-horizon kernel
give margin_new ≥ 1 at ALL 31 windows of [3.9×10⁷, 10⁹] (min 1.0816 @
10⁹, t = 999999994.62); the 25x record stands as history of that
statistic, the pins 25y as certified facts of it.]  The decomposition
of the remainder follows:
*(i)* on [10³, ~5.6×10⁷], Route A stands (above t\* = 690349.0568
the S4 squeeze bound is now PROVEN — 25ab, `S4G.s4g_growth_squeeze`; and
the S4 own-regime strip 1/200 ≤ d ≤ 1/2 is now PROVEN as well — 25af,
`S4Strip.s4_strip_close`, 2026-09-17);
*(ii)* on (~5.6×10⁷, ∞): SUPERSEDED AT SCREEN LEVEL (25x[8]/day029,
2026-09-17) — the "B(t) ~ t^{1/2}" was exactly the list-band P4
floor, and the 25af t⁴ wire is the different < side (its P4 floor
decays: A1·t⁻² + A2·t⁻⁵ + A3·t⁻⁷); with it plus the full-horizon
kernel (the 25x K excluded the (10¹⁸, ∞) product section) the
corrected margin is ≥ 1 at every window of [3.9×10⁷, 10⁹]
(pre-registered verdict A-1; min 1.0816 @ 10⁹); the open asymptotic
question is now the Efull (kernel mass mismatch)
saturation-vs-divergence question against the 0.9975 near-floor scale
(re-verified 2026-09-18: the suspected quad defect was an A/B interval
confound, H5-RESOLVED; recorded values stand), with the
Sbar-wire formalization (CITED P5/Platt–Trudgian) as the next Lean
unit; *(iii)* the S4
own-regime wire requirement (GAP-O → GAP-W class (i-b), 25v/25z) is
a named pure-mathematics item, the decision shape resolved by the 25z
reclassification.
Either way, the open piece is *stated, bounded below, localized, and
named* — not a missing ingredient whose shape is unknown.

## 11. Classical sources

- Riemann (1859): the product representation (DLMF 25.2.12).
- Riemann–von Mangoldt formula; θ(t) and the S(t) convention (DLMF 25.10).
- Functional equation; ζ̄(s) = ζ(̄s); the four-tuple structure.
- ζ(x) > 0 on (0, 1); trivial zeros (standard; citation to be filed).
- Platt & Trudgian, "Explicit formulae and bounds for the Riemann zeta
  function," J. Number Theory **147** (2015) 842–851, Cor. 1
  (the S-bound used by P5; read from the original PDF).

*Provenance policy.* Every certified number in this document is produced by
a committed script and stored with its data file (dps level, engine,
dt/dt2-stability verdict). The Lean artifacts are machine-checked against
mathlib on a pinned stable toolchain (Lean 4.33.1); nothing is "known by
memory," and no measured value stands in for a theorem except where this
document says so explicitly.

**0300 note (2025-2026 literature re-sweep — the wall UNMOVED — 2026-11-11).**
Post-0299 sweep:  no off-diagonal advance past 4/7 in the (1.2)
family  (published-reach lattice  1/2  <  9/17  <  6/11  (Feng,
1706.04593)  <  4/7  stands).  PROVENANCE REFINEMENT:
arXiv:2608.13637  (Alpoge-Furman,  13 Aug 2026)  is the exact
arXiv identity of the "Aug-2026 Anthropic preprint" of the
0291/0292  proportion corrigendum  (>= 2/3  with multiplicity;
>= 5/6 distinct;  0.6725/0.8362  Montgomery-Taylor window;
"discovered and written by Claude, ... authors verified";
accompanying Lean 4).  New record in the audited-blind M6 lane
(0292 audit stands  -  maximally blind:  counts simple OFF-line
zeros as good):  arXiv:2610.23467  Cobeli-Zaharescu  >  8/9
simple-OR-on-line  (Lamzouri  0.88762  ->  ~0.88893).  Tool-level
infrastructure recorded:  2608.14852  (short-interval twisted
second-moment reciprocity),  2606.27323  (amplified moments),
2603.25961  (Mobius double sum).  NO RH CLAIM;  wall
{theta | 4/7 < theta}  UNCHANGED.  Record:  ROUTE-B-FINAL-RECORD
§30;  discovery 0300.

**0301 note (M5 run 3:  window 3 landed,  frontier tCE3 — 2026-11-11).**
Window  3  (Murphy pipeline,  seamless  a  =  CE2's  b):
19 999  zeros certified in  (g_a3, g_b3],  all simple on the
line  (verifier  "CERTIFIED: true",  Rosser  48/49  >=  K = 12);
the recorded g_a3 exact-dyadic ball is **BIT-IDENTICAL** to
CE2's  g_b2  ball  (seam audit,  this machine).  New frontier
**tCE3  =  3,000,175,346,816**:  4 672  past  tCE2,  14 016
above  Platt-Trudgian  H0;  59 998  certified zeros over
(g_a1, g_b3].  Machine  (`RhAttack.CE3`):  bandOfWindows3  (splits
at  gA2Hi  and  gB2Lo;  ce3WinClause  covers  (gB2Lo, tCE3]
by the union of the window-2 and window-3 certified regions  -
the true Gram point sits inside its recorded ball,  no rational
split needed);  rh_reanchored_CE3  (RH  <->  terminalFaceCE3
under the four cited census inputs);  tree green  17454.  NO
RH  CLAIM.  Record:  ROUTE-B-FINAL-RECORD  §31;  discovery  0301;
S1-A1-EXPLORATION.md  E31.

**0302 note (the scoped weighted-variant attempt — SEALED at the
published boundary;  the wall algebra now weight-agnostic —
2026-11-11).**  The  0280-pattern  scoped  attempt  on  the
wall:  the smooth reweighting family  M_{a,Y}  (classical
a  =  1).  Machine  (`RhAttack.LevWall5`,  new):  the
WEIGHT-AGNOSTIC  wall  kernel  —  for  ANY  mollifier  family
W,  the interval expansion and the sharp  1/theta  limit
algebra  hold  (continuity only),  and  the  classical  0294
wall  theorem  is  proved  to  be  the  Wlev  instance
(`residSharp_is_instance`).  Audit  (exponents):  smooth
reweighting  is  an  AMPLITUDE-LEVEL  lever  —  it  changes
only  the  O_a(1)  bound  constant  of  the  Conrey-type
off-diagonal  double  sum,  none  of  the  exponents;  the
published  reach  lattice  (1/2,  9/17,  6/11,  4/7)  is  a
pure  exponent  constraint  (Deshouillers-Iwaniec  /
Kloosterman  range)  =>  NO  smooth  reweighting  moves  the
wall  past  4/7  —  SEALED.  The genuine remaining knob is
the  degree/truncation  trade-off  (0292-PRZZ)  —  next  scoped
attempt  0303:  the  degree-2  test  function  at  the  (1.2)
level.  Tree  green  17454.  NO  RH  CLAIM.  Record:
ROUTE-B-FINAL-RECORD  §32;  discovery  0302;  S1-A1-EXPLORATION.md
E32.

**0303 note (the 4/7 wall's exact published obstruction, pinned —
2026-11-11).**  Primary source:  PRZZ  (arXiv:1802.10521,
Res.  Math.  Sci.  7  (2020))  Theorem  4.1  —  the
twisted  second  moment  (N  =  T^theta)  by
coefficient  regime:  Case  1  (arbitrary  coefficients)
:  E  =  T^{3/20} N^{33/20}  +  ...  ->  theta  <
17/33  (Bettin-Chandee-Radziwill  trilinear  Kloosterman
ingredient);  Case  2  (mu² · degree-D):  E  =
T^eps(N^{11/6} + N^{11/12} T^{1/2})  ->  theta  <  6/11
(=  the  2017  Feng-variant  1706.04593);  Case  3
(degree-D  family,  contains  Levinson's  mu  at  D  =
0):  E  =  T^eps(N^{7/4} + N^{7/8} T^{1/2})  ->
theta  <  4/7  -  verbatim  "taking  N  =  T^{4/7-eps}
is  permissible".  THE  EXACT  OBSTRUCTION  (machine,
`RhAttack.LevWall6`):  the  Case-3  exponents  (7/4,
7/8)  SATURATE  SIMULTANEOUSLY  at  theta  =  4/7;
admissible  iff  theta  <  4/7;  **wallGapFailsObstruction**
(every  wall  theta  fails  the  published  o(T)
condition)  +  boundary47Fails  (4/7  itself  fails  -
sharp);  admissible  set  =  [0,  4/7).  THE  LADDER
REFINED  (machine-ordered):  1/2  (B-C-H-B  1985)  <
17/33  (PRZZ  generic)  <  9/17  (B-C-H-B  (1.3)
coefficients  b_C  =  μ(n)n^{σ₀−1/2}P(log(y/n)/log y),
Vaughan  +  Weil  -  the  degree-2  entry)  <  6/11
(PRZZ  Case  2)  <  4/7  (PRZZ  Case  3).  MOVING  THE
WALL  =  changing  the  exponents  7/4 /  7/8  (sharper
bilinear  Kloosterman  estimate,  better  balance
W  ≠  U^{1/4},  or  new  decomposition)  —  none
published  (0300  sweep);  the  GENUINE  LEVER  is
PRZZ's  own  open  question:  the  degree  d  vs
truncation  ℓ  balance  (section  9,  verbatim).  Tree
green  17454.  NO  RH  CLAIM  —  wall  UNMOVED,  now
pinned  at  its  exact  published  obstruction.  Record:
ROUTE-B-FINAL-RECORD  §33;  discovery  0303;
S1-A1-EXPLORATION.md  E33.

**0304 note (the d-l lever audited - KAPPA lever, not wall
lever  -  2026-11-06).**  PRZZ's  own  open  question
(section  9  item  4):  "What  would  be  a  good
balance  between  the  degree  d  and  the
truncation  ℓ?"  -  audited  against  the  full
primary  text:  the  5/12  theorem  itself  is  already
AT  θ  =  4/7  -  eps  (d  =  1,  truncation  K  =  3,
R  =  1.3036,  degree-5  Q,  κ  ≥  0.417293962);  the
A*  error  bound  is  UNIFORM  in  the  coefficient
family  (Λ_k  =  mu  *  log^k;  ℓ  =  k₁  +  ...  +
k_D)  -  the  d-l  choice  enters  the  MAIN  TERM
(κ),  not  the  error  exponents;  large  ℓ₁  at  d  =
1  mimics  higher  degree  (products  of  logs  of
distinct  primes)  =  more  main-term  freedom  =
better  κ;  the  "1/d"  in  A*  ≪  (T^eps/d)(T^{1/2}N^{7/8}
+  N^{7/4})  is  a  DIVISOR  (h  |  d^infty,  U  =
N1/(d h))  internal  to  the  (7/4,  7/8)  endpoint
-  the  "make  d  large"  reading  is  a  MISREADING;
the  extraction  is  FORCED  (h-powers  <  U-powers
for  the  h-sum;  W  =  U^{1/4}).  JUDGMENT:  d-l  is
a  proportion  lever  (face-blind,  0285/0292
logic);  the  wall  levers  remain  the  0303  menu
(L1  /  L2  /  L3).  MACHINE  (RhAttack.LevWall7,
new):  **DOUBLE  WASTE  THEOREM**  (improving
EITHER  published  error  exponent  ALONE,  by  ANY
amount,  does  NOT  move  the  wall  -  the
unimproved  term  binds  at  4/7;  BOTH  must
move)  +  **wallUnderBothImprovements**  (the  wall
=  EXACTLY  4/7  +  min(8δ/7,  4δ2/7)  under  (δ,
δ2)  improvements)  +  simultaneousShiftBindsSecond
(equal  δ  >  0  ->  4/7  +  4δ/7,  N^{7/4}  side
binds)  +  publishedStateIsCorner  (δ  =  δ2  =  0
⟺  the  LevWall6  corner)  +  wallShiftDemo
(1/7  on  the  7/4  side  moves  the  wall
28/49  ->  32/49).  Any  future  wall  movement  must
carry  BOTH  exponents;  the  N^{7/4}  (bilinear
Kloosterman)  side  is  the  binding  side  -  L1  is
the  best  lever.  Lean  pitfall  recorded:  the
draft  "single-side  shift"  theorem  was
mathematically  wrong  before  build  (linarith
refused);  corrected  to  the  double  waste
theorem.  Tree  green  17454.  NO  RH  CLAIM  -  wall
UNMOVED;  the  option-B  analytic  menu  is
EXHAUSTED  at  the  published  frontier  (map
0286-0304  complete).  Record:  ROUTE-B-FINAL-RECORD
§34;  discovery  0304;  S1-A1-EXPLORATION.md  E34.

**0306 (M5 run 4, 2026-11-06):** the seamless chain
extends AGAIN - our window-4 certification (20 000 zeros,
one first-quota block rescued by the pipeline's
documented union refinement, independently verified) moves
the certified frontier to **tCE4 = 3 000 175 351 489**
(18 689 above Platt-Trudgian H0; 79 998 zeros over
(g_a1, g_b4]); NEW formal module RhAttack.CE4
(24 decls): RH <-> terminalFaceCE4 under the cited
inputs; 0297 spot-check scope confirmed (window 2:
13 155/13 155/0 at dps-30). Tree green 17454. NO RH
CLAIM - face OPEN / PROBABLY TRUE; M2 wall UNMOVED
((1.2) full family); next named direction: 0307
candidate (0305's Kintali Theorem 2.2 primary reading).
