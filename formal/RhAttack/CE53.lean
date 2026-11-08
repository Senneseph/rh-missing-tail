import Mathlib
import RhAttack.B0
import RhAttack.P12Uniform
import RhAttack.WinCount
import RhAttack.RHEnd
import RhAttack.ThetaInf
import RhAttack.CE1
import RhAttack.CE2
import RhAttack.CE3
import RhAttack.CE4
import RhAttack.CE5
import RhAttack.CE6
import RhAttack.CE7
import RhAttack.CE8
import RhAttack.CE9
import RhAttack.CE10
import RhAttack.CE11
import RhAttack.CE12
import RhAttack.CE13
import RhAttack.CE14
import RhAttack.CE15
import RhAttack.CE16
import RhAttack.CE17
import RhAttack.CE18
import RhAttack.CE19
import RhAttack.CE20
import RhAttack.CE21
import RhAttack.CE22
import RhAttack.CE23
import RhAttack.CE24
import RhAttack.CE25
import RhAttack.CE26
import RhAttack.CE27
import RhAttack.CE28
import RhAttack.CE29
import RhAttack.CE30
import RhAttack.CE31
import RhAttack.CE32
import RhAttack.CE33
import RhAttack.CE34
import RhAttack.CE35
import RhAttack.CE36
import RhAttack.CE37
import RhAttack.CE38
import RhAttack.CE39
import RhAttack.CE40
import RhAttack.CE41
import RhAttack.CE42
import RhAttack.CE42B
import RhAttack.CE43
import RhAttack.CE44
import RhAttack.CE45
import RhAttack.CE46
import RhAttack.CE47
import RhAttack.CE48
import RhAttack.CE49
import RhAttack.CE50
import RhAttack.CE51
import RhAttack.CE52

set_option linter.style.whitespace false
set_option linter.style.longLine false
set_option linter.style.docString false

open Real Set Complex Filter B0 P12 RHEnd CE1 CE2 CE3 CE4 CE5 CE6 CE7 CE8 CE9 CE10 CE11 CE12 CE13 CE14 CE15 CE16 CE17 CE18 CE19 CE20 CE21 CE22 CE23 CE24 CE25 CE26 CE27 CE28 CE29 CE30 CE31 CE32 CE33 CE34 CE35 CE36 CE37 CE38 CE39 CE40 CE41 CE42 CE42B CE43 CE44 CE45 CE46 CE47 CE48 CE49 CE50 CE51 CE52
open scoped Topology

/-!
**CE53 — the  terminal  face  re-anchored  at  the
FIFTY-THIRD  certified  window  (0359,
option  B,
unit
72
-
lane
M5).
MILESTONE
UNIT:
the
250
000-unit
frontier
mark
is
CROSSED
-
tCE53
-
tPT2
=
252
334
>
250
000,
proven
in-tree
as
frontierPast250k
(the
round-mark
sequence
above
H0
is
100
000
@
CE22,
125
000
@
CE27,
150
000
@
CE33,
175
000
@
CE38,
200
000
@
CE42B,
225
000
@
CE48,
250
000
@
CE53).
NON-SNAPPED
WINDOW
(width
b
-
a
=
20
000
-
the
two-in-a-row
snapped
streak  of
window  51
and
window  52
ENDS
here;
the
snapped-width
family
remains
2,
3,
8,
11,
17,
18,
19,
21,
31
(width
19
999),
40
(width
19
998),
51,
52
(width
19
999)).
THREE
ROSSER-BLOCK
EXCEPTIONS
INSIDE,
ALL
RESCUED,
QUOTA-MET,
and
RECORDED
(not
suppressed):
block
1
[12
363
154
499
170,
12
363
154
499
172]
(need
2,
found
0,
129
points,
m
=
64)
-
>
union
[12
363
154
499
169,
12
363
154
499
173]
(need
4,
FOUND
4,
m
=
4);
block
2
[12
363
154
507
862,
12
363
154
507
864]
(need
2,
found
0,
129
points,
m
=
64)
-
>
union
[12
363
154
507
861,
12
363
154
507
866]
(need
5,
FOUND
5,
m
=
8);
block
3
[12
363
154
510
768,
12
363
154
510
770]
(need
2,
found
0,
129
points,
m
=
64)
-
>
union
[12
363
154
510
767,
12
363
154
510
772]
(need
5,
FOUND
5,
m
=
2).
The
independent
verifier
RECOMPUTES
the
WINDOW
TOTAL
(sign_changes_inside
=
20
000
=
b
-
a)
and
the
two
end
Rosser
runs
(47
/
49)
-
the
only
quantities
that
enter
the
Turing
step;
all
three
rescued
blocks
are
interior
and
do
not
affect
either.
Cumulative
certified
count
=
1
079
987
over
(g_a1,
g_b53]
(1
059
987
at
w52's
end
+
20
000
-
no
snap,
full
width;
the
1
000
000
mark
[w50]
is
carried).
Corrected
chain
continues:
w42
->
w42b
->
w43
->
w44
->
w45
->
w46
->
w47
->
w48
->
w49
->
w50
->
w51
->
w52
->
w53,
every
seam
bit-identical
(window
53
launched
from
b52
correctly;
the
seam
audit
passed
bit-identically
BEFORE
this
module
was
written).
NO
RH
CLAIM.
-/

/- PROVENANCE
(our
run,
2026-11-08;
pipeline
=
Murphy's
Apache-2.0
deposit,
same
as
CE1-CE52):
RUN
PARAMETERS:
a
=
12
363
154
497
117
(=
b52,
window
52's
SNAPPED
final
b
-
launched
correctly
from
the
chain
frontier,
per
the
0348
process
rule),
b
requested
=
a
+
20
000
=
12
363
154
517
117,
b
ACTUAL
=
12
363
154
517
117
(NON-SNAPPED
-
the
requested
endpoint
WAS
a
good
Gram
point
at
working
precision;
a
and
b
both
good),
M
=
60,
C_R
=
1,
28
workers,
34
037
evaluations,
2554.0
s.
CERTIFICATE
(window53_b53.json):
the
b
-
a
=
20
000
zeros
of
zeta
with
g_a53
<
Im
s
<=
g_b53
are
ALL
SIMPLE
and
on
the
line,
where
g_a53
(recorded
exact
dyadic
ball,
this
run's
a)
=
113343428831147822184536190820181931
x
2^-75,
radius
16777217
x
2^-110
(i.e.
3
000
175
580
461.099121093750
+
or
-
1.29e-26),
and
this
ball
is
BIT-IDENTICAL
to
CE52's
recorded
g_b52
(exact
dyadic
tuple
comparison,
2026-11-08)
-
the
seam
audit
PASSED
BEFORE
this
module
was
written
(the
0348
process
rule);
g_b53
=
3
000
175
585
134.034179687500
+
or
-
1.29e-26
(exact
dyadic
tuple
as
recorded:
[29015917825967697847748600342133254453,
-83,
16777217,
-110]);
the
floor
tCE53
sits
0.0342
above
the
previous
integer
-
robust
to
the
1.29e-26
radius
by
many
orders
of
magnitude;
the
standard
two-decimal
lower
bound
gB53Lo
has
a
margin
of
~4.2e-3;
the
two-decimal
round-down
(0.03)
does
not
equal
the
floor,
so
no
CASING
is
needed,
window
38
/
CE38
remaining
the
only
CASING
case
so
far.
Turing
runs
of
consecutive
good
Rosser
blocks:
47
left
of
g_a53,
49
right
of
g_b53
(both
>=
K
=
12);
0
cross-check
failures
(all
34
037
records);
0
undetermined
Gram
signs.
INTERNAL
ROSSER-BLOCK
EXCEPTIONS
(recorded,
not
suppressed):
THREE
blocks
failed
the
initial
quota,
each
RESCUED
by
a
union
interval,
QUOTA
MET
in
all:
(1)
[12
363
154
499
170,
12
363
154
499
172]
(need
2,
found
0,
129
points,
m
=
64,
determined
=
true)
-
>
union
[12
363
154
499
169,
12
363
154
499
173]
(need
4,
FOUND
4,
m
=
4);
(2)
[12
363
154
507
862,
12
363
154
507
864]
(need
2,
found
0,
129
points,
m
=
64,
determined
=
true)
-
>
union
[12
363
154
507
861,
12
363
154
507
866]
(need
5,
FOUND
5,
m
=
8);
(3)
[12
363
154
510
768,
12
363
154
510
770]
(need
2,
found
0,
129
points,
m
=
64,
determined
=
true)
-
>
union
[12
363
154
510
767,
12
363
154
510
772]
(need
5,
FOUND
5,
m
=
2).
The
independent
verifier
RECOMPUTES
the
WINDOW
TOTAL
and
the
two
end
Rosser
runs
-
the
only
quantities
that
enter
the
Turing
step;
all
three
exceptions
are
recorded
in
this
header
and
in
discovery
0359.
VERIFICATION
(three
layers,
same
as
CE2-CE52):
(1)
ENVIRONMENT
REPEAT
(Murphy's
window-1
certificate
re-verified
-
see
CE2
header);
(2)
PIPELINE
VERIFIER
on
window53_b53.json:
"CERTIFIED:
true",
points_checked
=
34
037,
sign_changes_inside
=
20
000
=
b
-
a,
roesser_failures_inside
=
3
(the
three
recorded,
quota-met
rescues
above),
turing_ok
=
true,
K_conservative
=
12
(K_required:
Trudgian
Cor2.3
=
[5.71899
+
or
-
1.23e-6],
doubled
=
[11.4380
+
or
-
1.76e-5],
Amberger
Thm2.3
=
[9.14967
+
or
-
4.14e-6]
-
all
below
12),
endpoints
recomputed
and
matched;
(3)
SEAM
AUDIT
(this
run):
the
recorded
g_a53
ball
is
bit-identical
to
CE52's
recorded
g_b52
ball
(exact
dyadic
decode,
2026-11-08;
audit
performed
BEFORE
this
module
was
written).
FRONTIER
ARITHMETIC
(machine,
below):
tCE53
=
3
000
175
585
134,
tCE53
-
tCE52
=
4
673
(the
22nd
increment
-
the
4
673
pace
since
the
one-shot
4
672
break
at
w45->46;
no
periodicity
assumed),
tCE53
-
tPT2
=
252
334
(THE
250
000-UNIT
MILESTONE:
the
round
mark
250
000
is
CROSSED
in
this
window,
proven
in-tree
as
frontierPast250k;
the
next
round
mark
275
000
sits
22
666
ahead
-
at
the
~4
673/window
pace,
expected
in
window
59
or
60),
CERTIFIED
COUNT
(pipeline
data,
machine-tracked
over
the
chain):
over
(g_a1,
g_b53]
=
1
059
987
+
20
000
=
1
079
987
(the
1
000
000
mark
[w50,
0356]
is
carried;
no
snap
cost
this
window);
counts
are
consumed
as
citations,
not
re-derived
in-tree.
HONESTY
(trust
base):
as
CE2-CE52
-
the
pipeline's
own
controls,
its
kernel-checked
Lean
remainder
theorem,
and
our
three
verification
layers;
a
RE-RUN
of
a
third-party
pipeline,
not
a
from-scratch
independent
certification.
The
Rosser
rescues
are
RECORDED,
not
suppressed.
NO
RH
CLAIM.
-/

namespace CE53


/-! ### 1.  The  certified  constants
-/
/-- Certified  LOWER
    bound
    for
    g_b53
    (the
    recorded
    ball
    is
    3
    000
    175
    585
    134.034179687500
    with
    radius
    ~=
    1.29e-26;
    this
    rational
    rounds
    the
    bottom
    down
    at
    two
    decimals,
    margin
    ~4.2e-3;
    window
    53
    is
    NON-SNAPPED
    -
    see
    the
    header).
    -/
def gB53Lo : ℚ := 300017558513403 / 100

/-- THE
    NEW
    CERTIFIED
    CENSUS
    FRONTIER:
    an
    integer
    strictly
    below
    the
    certified
    lower
    bound
    gB53Lo:
    tCE53
    =
    3
    000
    175
    585
    134.
    -/
def tCE53 : ℕ := 3000175585134

theorem tCE53_lt_gB53Lo : (tCE53 : ℝ) < (gB53Lo : ℝ) := by
  norm_num [gB53Lo, tCE53]

theorem tCE52_lt_tCE53 : (tCE52 : ℝ) < (tCE53 : ℝ) := by
  norm_num [CE52.tCE52, tCE53]

/-- Record:
    the
    seam
    order
    gB52Lo
    <
    tCE53
    (the
    band
    (gB52Lo,
    tCE53]
    is
    nonempty
    and
    lies
    above
    window
    52's
    frontier
    tCE52).
    -/
theorem gB52Lo_lt_tCE53 : (gB52Lo : ℝ) < (tCE53 : ℝ) := by
  norm_num [CE52.gB52Lo, tCE53]

/-- The
    face
    height
    shrank
    by
    a
    FURTHER
    4
    673
    units
    past
    tCE52:
    the
    4
    673
    pace
    since
    the
    one-shot
    4
    672
    break
    at
    w45  →  w46
    (the
    22nd
    increment
    is
    4
    673)
    -
    the
    Gram
    spacings
    wobble
    by
    units,
    not
    periodic;
    recorded
    honestly,
    no
    pattern
    assumed.
    -/
theorem faceShrinkCE53 : (tCE53 : ℝ) - (tCE52 : ℝ) = 4673 := by
  norm_num [tCE53, CE52.tCE52]

/-- THE
    EXTENDED
    GEAR
    (machine):
    the
    new
    frontier
    stands
    252
    334
    units
    above
    the
    Platt-Trudgian
    frontier
    H0
    (window
    53
    is
    NON-SNAPPED,
    width
    20
    000
    -
    the
    snapped
    streak
    of
    w51/w52
    ENDS;
    THE
    250
    000-UNIT
    MILESTONE
    IS
    CROSSED
    HERE
    -
    proven
    as
    frontierPast250k;
    the
    round-mark
    sequence
    is
    100
    000
    @
    CE22,
    125
    000
    @
    CE27,
    150
    000
    @
    CE33,
    175
    000
    @
    CE38,
    200
    000
    @
    CE42B,
    225
    000
    @
    CE48,
    250
    000
    @
    CE53;
    the
    next
    round
    mark
    275
    000
    sits
    22
    666
    ahead
    -
    at
    the
    ~4
    673/window
    pace,
    expected
    in
    window
    59
    or
    60;
    compute
    the
    floor
    when
    it
    lands,
    do
    not
    pre-announce).
    -/
theorem frontierGapAboveH0 : (tCE53 : ℝ) - WinC.tPT2 = 252334 := by
  norm_num [tCE53, WinC.tPT2]

/-- MILESTONE
    CARRY
    (machine):
    tCE53
    −
    tPT2
    =
    252
    334
    exceeds
    200
    000
    (crossed
    at
    the
    fill
    CE42B).
    -/
theorem frontierPast200k : (tCE53 : ℝ) - WinC.tPT2 > 200000 := by
  have h : (tCE53 : ℝ) - WinC.tPT2 = 252334 := frontierGapAboveH0
  linarith [h]

/-- MILESTONE
    CARRY
    (machine):
    tCE53
    −
    tPT2
    =
    252
    334
    exceeds
    175
    000
    (the
    CE38
    mark).
    -/
theorem frontierPast175k : (tCE53 : ℝ) - WinC.tPT2 > 175000 := by
  have h : (tCE53 : ℝ) - WinC.tPT2 = 252334 := frontierGapAboveH0
  linarith [h]


/-- MILESTONE
    CARRY
    (machine,
    PROVEN):
    tCE53
    −
    tPT2
    =
    252
    334
    exceeds
    225
    000
    -
    the
    225
    000-unit
    mark
    (crossed
    in
    window
    48,
    the
    CE48
    MILESTONE
    unit)
    is
    carried
    at
    the
    new
    frontier;
    the
    250
    000-unit
    mark
    was
    CROSSED
    in
    THIS
    window
    -
    see
    frontierPast250k
    (THE
    250
    000-UNIT
    MILESTONE
    UNIT);
    the
    1
    000
    000-certified-zero
    mark
    (window
    50,
    0356)
    is
    also
    carried
    —
    counts
    are
    pipeline
    data,
    recorded
    in
    the
    header,
    not
    in-tree
    arithmetic.
    -/
theorem frontierPast225k : (tCE53 : ℝ) - WinC.tPT2 > 225000 := by
  have h : (tCE53 : ℝ) - WinC.tPT2 = 252334 := frontierGapAboveH0
  linarith [h]

/-- MILESTONE  (machine,
PROVEN):
tCE53
-
tPT2
=
252
334
exceeds
250
000
-
THE
250
000-UNIT
MILESTONE:
the
round
mark
250
000
is
CROSSED
in
window
53
(exactly
where
the
~4
673/window
pace
predicted
-
2
339
short
at
w52's
end,
the
next
4
673
carries
it).
The
round-mark
sequence
above
H0
is
now
100
000
@
CE22,
125
000
@
CE27,
150
000
@
CE33,
175
000
@
CE38,
200
000
@
CE42B,
225
000
@
CE48,
250
000
@
CE53.
The
next
round
mark,
275
000,
sits
22
666
ahead
-
at
the
~4
673/window
pace,
expected
in
window
59
or
60
(compute
from
the
decoded
endpoint,
do
not
pre-announce).
-/
theorem frontierPast250k : (tCE53 : ℝ) - WinC.tPT2 > 250000 := by
  have h : (tCE53 : ℝ) - WinC.tPT2 = 252334 := frontierGapAboveH0
  linarith [h]
/-- Record:
    the
    rationalized
    slice
    caps
    are
    well
    ordered
    (gB52Lo
    <
    gB53Lo)
    -
    the
    window-53
    band
    (gB52Lo,
    gB53Lo]
    lies
    strictly
    above
    window
    52's
    certified
    region
    (gB51Lo,
    gB52Lo].
    -/
theorem gB52Lo_lt_gB53Lo : (gB52Lo : ℝ) < (gB53Lo : ℝ) := by
  norm_num [CE52.gB52Lo, gB53Lo]

/-! ### 2.  The  cited  window  clauses  (Z78  pattern)
-/
/-- [CITED,
    OUR
    WINDOW-52
    RUN
    (window52_b52.json),
    FULL
    SLICE
    -
    re-cited
    at
    the
    CE53
    level]
    every
    zeta
    zero
    with
    gB51Lo
    <
    Im
    ρ
    <=
    gB52Lo
    is
    on
    the
    critical
    line.
    Derivation
    (recorded):
    for
    t0
    =
    Im
    ρ
    in
    (gB51Lo,
    gB52Lo],
    either
    t0
    <=
    g_b51
    (g_a52
    =
    g_b51
    -
    the
    chain
    seam,
    recorded
    exact
    dyadic
    tuple
    [116063670942328987203539826434559195545,
    -85,
    16777217,
    -110],
    audit
    PASSED
    BEFORE
    CE52
    was
    written)
    -
    then
    t0
    sits
    in
    window
    51's
    certified
    region
    (g_a51,
    g_b51]
    -
    or
    t0
    >
    g_b51
    =
    g_a52,
    in
    which
    case
    t0
    <=
    gB52Lo
    <=
    g_b52
    puts
    t0
    in
    window
    52's
    certified
    region
    (g_a52,
    g_b52]
    (window
    52
    is
    SNAPPED,
    width
    19
    999,
    two
    recorded
    quota-met
    rescues
    -
    see
    the
    CE52
    header).
    The
    two
    certified
    regions
    union
    to
    (g_a51,
    g_b52]
    which
    contains
    (gB51Lo,
    gB52Lo]
    (machine:
    gB51Lo
    <
    tCE52
    <
    gB52Lo,
    from
    CE52).
    Named
    Prop
    consumed
    as
    a
    hypothesis;
    not
    proven
    in-tree.
    -/
def ce52WinClauseFull : Prop :=
    ∀ (ρ : ℂ), riemannZeta ρ = 0 → (gB51Lo : ℝ) < ρ.im →
      ρ.im ≤ (gB52Lo : ℝ) → ρ.re = 1 / 2

/-- [CITED,
    OUR
    WINDOW-53
    RUN
    (window53_b53.json),
    SLICE]
    every
    zeta
    zero
    with
    gB52Lo
    <
    Im
    ρ
    <=
    tCE53
    is
    on
    the
    critical
    line.
    Derivation
    (recorded):
    for
    t0
    =
    Im
    ρ
    in
    (gB52Lo,
    tCE53],
    either
    t0
    <=
    g_b52
    (the
    true
    Gram
    point
    -
    g_a53
    =
    g_b52,
    recorded
    exact
    dyadic
    tuple
    [113343428831147822184536190820181931,
    -75,
    16777217,
    -110],
    i.e.
    3
    000
    175
    580
    461.099121093750
    +
    or
    -
    1.29e-26,
    BIT-IDENTICAL
    in
    both
    certificates
    -
    the
    chain
    seam,
    audit
    PASSED
    BEFORE
    this
    module
    was
    written
    per
    the
    0348
    process
    rule;
    gB52Lo
    <
    g_b52)
    -
    then
    t0
    sits
    in
    window
    52's
    certified
    region
    (g_a52,
    g_b52]
    -
    or
    t0
    >
    g_b52
    =
    g_a53,
    in
    which
    case
    t0
    <=
    tCE53
    <
    gB53Lo
    <=
    g_b53
    puts
    t0
    in
    window
    53's
    certified
    region
    (g_a53,
    g_b53]
    (window
    53
    is
    NON-SNAPPED,
    width
    20
    000;
    THREE
    recorded
    quota-met
    Rosser
    rescues
    -
    see
    the
    header).
    The
    two
    certified
    regions
    union
    to
    (g_a52,
    g_b53]
    which
    contains
    (gB52Lo,
    tCE53]
    (machine:
    gB52Lo
    <
    tCE53
    <
    gB53Lo).
    Named
    Prop
    consumed
    as
    a
    hypothesis;
    not
    proven
    in-tree.
    -/
def ce53WinClause : Prop :=
    ∀ (ρ : ℂ), riemannZeta ρ = 0 → (gB52Lo : ℝ) < ρ.im →
      ρ.im ≤ (tCE53 : ℝ) → ρ.re = 1 / 2

/-- THE
    COMPOSITE
    BAND
    CLAUSE
    (machine):
    zeros
    in
    (tPT2,
    tCE53]
    are
    on
    the
    line,
    given
    the
    fifty-four
    window
    clauses
    (windows
    1
    through
    42,
    the
    fill,
    windows
    43
    through
    52
    [full
    slices],
    and
    window
    53
    [terminal
    slice])
    -
    the
    splits
    at
    gA2Hi,
    gB2Lo,
    ...,
    gB42Lo,
    gB42BLo,
    gB43Lo,
    gB44Lo,
    gB45Lo,
    gB46Lo,
    gB47Lo,
    gB48Lo,
    gB49Lo,
    gB50Lo,
    gB51Lo,
    gB52Lo
    are
    pure
    case
    splits.
    -/
theorem bandOfWindows53 (h1 : CE2.ce1WinClause)
    (h2 : CE3.ce2WinClauseFull) (h3 : CE4.ce3WinClauseFull)
    (h4 : CE5.ce4WinClauseFull) (h5 : CE6.ce5WinClauseFull)
    (h6 : CE7.ce6WinClauseFull) (h7 : CE8.ce7WinClauseFull)
    (h8 : CE9.ce8WinClauseFull) (h9 : CE10.ce9WinClauseFull)
    (h10 : CE11.ce10WinClauseFull) (h11 : CE12.ce11WinClauseFull)
    (h12 : CE13.ce12WinClauseFull) (h13 : CE14.ce13WinClauseFull)
    (h14 : CE15.ce14WinClauseFull) (h15 : CE16.ce15WinClauseFull)
    (h16 : CE17.ce16WinClauseFull) (h17 : CE18.ce17WinClauseFull)
    (h18 : CE19.ce18WinClauseFull) (h19 : CE20.ce19WinClauseFull)
    (h20 : CE21.ce20WinClauseFull) (h21 : CE22.ce21WinClauseFull)
    (h22 : CE23.ce22WinClauseFull) (h23 : CE24.ce23WinClauseFull)
    (h24 : CE25.ce24WinClauseFull) (h25 : CE26.ce25WinClauseFull)
    (h26 : CE27.ce26WinClauseFull) (h27 : CE28.ce27WinClauseFull)
    (h28 : CE29.ce28WinClauseFull) (h29 : CE30.ce29WinClauseFull)
    (h30 : CE31.ce30WinClauseFull)
    (h31 : CE32.ce31WinClauseFull)
    (h32 : CE33.ce32WinClauseFull)
    (h33 : CE34.ce33WinClauseFull)
    (h34 : CE35.ce34WinClauseFull)
    (h35 : CE36.ce35WinClauseFull)
    (h36 : CE37.ce36WinClauseFull)
    (h37 : CE38.ce37WinClauseFull)
    (h38 : CE39.ce38WinClauseFull)
    (h39 : CE40.ce39WinClauseFull)
    (h40 : CE41.ce40WinClauseFull)
    (h41 : ce41WinClauseFull)
    (h42 : ce42WinClauseFull) (h43 : CE44.fillWinClauseFull) (h44 : CE44.ce43WinClauseFull) (h45 : CE45.ce44WinClauseFull) (h46 : CE46.ce45WinClauseFull) (h47 : CE47.ce46WinClauseFull) (h48 : CE48.ce47WinClauseFull) (h49 : CE49.ce48WinClauseFull) (h50 : CE50.ce49WinClauseFull) (h51 : CE51.ce50WinClauseFull) (h52 : CE52.ce51WinClauseFull) (h53 : ce52WinClauseFull) (h54 : ce53WinClause) :
    ∀ (ρ : ℂ), riemannZeta ρ = 0 → WinC.tPT2 < ρ.im →
      ρ.im ≤ (tCE53 : ℝ) → ρ.re = 1 / 2 := by
  intro ρ hz ht htH
  by_cases hseam1 : ρ.im ≤ (gA2Hi : ℝ)
  · exact h1 ρ hz ht hseam1
  · by_cases hseam2 : ρ.im ≤ (gB2Lo : ℝ)
    · exact h2 ρ hz (not_le.mp hseam1) hseam2
    · by_cases hseam3 : ρ.im ≤ (gB3Lo : ℝ)
      · exact h3 ρ hz (not_le.mp hseam2) hseam3
      · by_cases hseam4 : ρ.im ≤ (gB4Lo : ℝ)
        · exact h4 ρ hz (not_le.mp hseam3) hseam4
        · by_cases hseam5 : ρ.im ≤ (gB5Lo : ℝ)
          · exact h5 ρ hz (not_le.mp hseam4) hseam5
          · by_cases hseam6 : ρ.im ≤ (gB6Lo : ℝ)
            · exact h6 ρ hz (not_le.mp hseam5) hseam6
            · by_cases hseam7 : ρ.im ≤ (gB7Lo : ℝ)
              · exact h7 ρ hz (not_le.mp hseam6) hseam7
              · by_cases hseam8 : ρ.im ≤ (gB8Lo : ℝ)
                · exact h8 ρ hz (not_le.mp hseam7) hseam8
                · by_cases hseam9 : ρ.im ≤ (gB9Lo : ℝ)
                  · exact h9 ρ hz (not_le.mp hseam8) hseam9
                  · by_cases hseam10 : ρ.im ≤ (gB10Lo : ℝ)
                    · exact h10 ρ hz (not_le.mp hseam9) hseam10
                    · by_cases hseam11 : ρ.im ≤ (gB11Lo : ℝ)
                      · exact h11 ρ hz (not_le.mp hseam10) hseam11
                      · by_cases hseam12 : ρ.im ≤ (gB12Lo : ℝ)
                        · exact h12 ρ hz (not_le.mp hseam11) hseam12
                        · by_cases hseam13 : ρ.im ≤ (gB13Lo : ℝ)
                          · exact h13 ρ hz (not_le.mp hseam12) hseam13
                          · by_cases hseam14 : ρ.im ≤ (gB14Lo : ℝ)
                            · exact h14 ρ hz (not_le.mp hseam13) hseam14
                            · by_cases hseam15 : ρ.im ≤ (gB15Lo : ℝ)
                              · exact h15 ρ hz (not_le.mp hseam14) hseam15
                              · by_cases hseam16 : ρ.im ≤ (gB16Lo : ℝ)
                                · exact h16 ρ hz (not_le.mp hseam15) hseam16
                                · by_cases hseam17 : ρ.im ≤ (gB17Lo : ℝ)
                                  · exact h17 ρ hz (not_le.mp hseam16) hseam17
                                  · by_cases hseam18 : ρ.im ≤ (gB18Lo : ℝ)
                                    · exact h18 ρ hz (not_le.mp hseam17) hseam18
                                    · by_cases hseam19 : ρ.im ≤ (gB19Lo : ℝ)
                                      · exact h19 ρ hz (not_le.mp hseam18) hseam19
                                      · by_cases hseam20 : ρ.im ≤ (gB20Lo : ℝ)
                                        · exact h20 ρ hz (not_le.mp hseam19) hseam20
                                        · by_cases hseam21 : ρ.im ≤ (gB21Lo : ℝ)
                                          · exact h21 ρ hz (not_le.mp hseam20) hseam21
                                          · by_cases hseam22 : ρ.im ≤ (gB22Lo : ℝ)
                                            · exact h22 ρ hz (not_le.mp hseam21) hseam22
                                            · by_cases hseam23 : ρ.im ≤ (gB23Lo : ℝ)
                                              · exact h23 ρ hz (not_le.mp hseam22) hseam23
                                              · by_cases hseam24 : ρ.im ≤ (gB24Lo : ℝ)
                                                · exact h24 ρ hz (not_le.mp hseam23) hseam24
                                                · by_cases hseam25 : ρ.im ≤ (gB25Lo : ℝ)
                                                  · exact h25 ρ hz (not_le.mp hseam24) hseam25
                                                  · by_cases hseam26 : ρ.im ≤ (gB26Lo : ℝ)
                                                    · exact h26 ρ hz (not_le.mp hseam25) hseam26
                                                    · by_cases hseam27 : ρ.im ≤ (gB27Lo : ℝ)
                                                      · exact h27 ρ hz (not_le.mp hseam26) hseam27
                                                      · by_cases hseam28 : ρ.im ≤ (gB28Lo : ℝ)
                                                        · exact h28 ρ hz (not_le.mp hseam27) hseam28
                                                        · by_cases hseam29 : ρ.im ≤ (gB29Lo : ℝ)
                                                          · exact h29 ρ hz (not_le.mp hseam28) hseam29
                                                          · by_cases hseam30 : ρ.im ≤ (gB30Lo : ℝ)
                                                            · exact h30 ρ hz (not_le.mp hseam29) hseam30
                                                            · by_cases hseam31 : ρ.im ≤ (gB31Lo : ℝ)
                                                              · exact h31 ρ hz (not_le.mp hseam30) hseam31
                                                              · by_cases hseam32 : ρ.im ≤ (gB32Lo : ℝ)
                                                                · exact h32 ρ hz (not_le.mp hseam31) hseam32
                                                                · by_cases hseam33 : ρ.im ≤ (gB33Lo : ℝ)
                                                                  · exact h33 ρ hz (not_le.mp hseam32) hseam33
                                                                  · by_cases hseam34 : ρ.im ≤ (gB34Lo : ℝ)
                                                                    · exact h34 ρ hz (not_le.mp hseam33) hseam34
                                                                    · by_cases hseam35 : ρ.im ≤ (gB35Lo : ℝ)
                                                                      · exact h35 ρ hz (not_le.mp hseam34) hseam35
                                                                      · by_cases hseam36 : ρ.im ≤ (gB36Lo : ℝ)
                                                                        · exact h36 ρ hz (not_le.mp hseam35) hseam36
                                                                        · by_cases hseam37 : ρ.im ≤ (gB37Lo : ℝ)
                                                                          · exact h37 ρ hz (not_le.mp hseam36) hseam37
                                                                          · by_cases hseam38 : ρ.im ≤ (gB38Lo : ℝ)
                                                                            · exact h38 ρ hz (not_le.mp hseam37) hseam38
                                                                            · by_cases hseam39 : ρ.im ≤ (gB39Lo : ℝ)
                                                                              · exact h39 ρ hz (not_le.mp hseam38) hseam39
                                                                              · by_cases hseam40 : ρ.im ≤ (gB40Lo : ℝ)
                                                                                · exact h40 ρ hz (not_le.mp hseam39) hseam40
                                                                                · by_cases hseam41 : ρ.im ≤ (gB41Lo : ℝ)
                                                                                  · exact h41 ρ hz (not_le.mp hseam40) hseam41
                                                                                  · by_cases hseam42 : ρ.im ≤ (gB42Lo : ℝ)
                                                                                    · exact h42 ρ hz (not_le.mp hseam41) hseam42
                                                                                    · by_cases hseam43 : ρ.im ≤ (gB42BLo : ℝ)
                                                                                      · exact h43 ρ hz (not_le.mp hseam42) hseam43
                                                                                      · by_cases hseam44 : ρ.im ≤ (gB43Lo : ℝ)
                                                                                        · exact h44 ρ hz (not_le.mp hseam43) hseam44
                                                                                        · by_cases hseam45 : ρ.im ≤ (gB44Lo : ℝ)
                                                                                          · exact h45 ρ hz (not_le.mp hseam44) hseam45
                                                                                          · by_cases hseam46 : ρ.im ≤ (gB45Lo : ℝ)
                                                                                            · exact h46 ρ hz (not_le.mp hseam45) hseam46
                                                                                            · by_cases hseam47 : ρ.im ≤ (gB46Lo : ℝ)
                                                                                              · exact h47 ρ hz (not_le.mp hseam46) hseam47
                                                                                              · by_cases hseam48 : ρ.im ≤ (gB47Lo : ℝ)
                                                                                                · exact h48 ρ hz (not_le.mp hseam47) hseam48
                                                                                                · by_cases hseam49 : ρ.im ≤ (gB48Lo : ℝ)
                                                                                                  · exact h49 ρ hz (not_le.mp hseam48) hseam49
                                                                                                  · by_cases hseam50 : ρ.im ≤ (gB49Lo : ℝ)
                                                                                                    · exact h50 ρ hz (not_le.mp hseam49) hseam50
                                                                                                    · by_cases hseam51 : ρ.im ≤ (gB50Lo : ℝ)
                                                                                                      · exact h51 ρ hz (not_le.mp hseam50) hseam51
                                                                                                      · by_cases hseam52 : ρ.im ≤ (gB51Lo : ℝ)
                                                                                                        · exact h52 ρ hz (not_le.mp hseam51) hseam52
                                                                                                        · by_cases hseam53 : ρ.im ≤ (gB52Lo : ℝ)
                                                                                                          · exact h53 ρ hz (not_le.mp hseam52) hseam53
                                                                                                          · exact h54 ρ hz (not_le.mp hseam53) htH

/-! ### 3.  The  machine-verified  re-anchoring
-/
/-- M5
    ·
    THE
    FRONTIER
    MOVED
    AGAIN
    (window
    53
    -
    THE
    250
    000-UNIT
    MILESTONE
    UNIT):
    [Z-PT2]
    +
    the
    fifty-four
    cited
    window
    clauses
    =>
    the
    on-line
    census
    holds
    up
    to
    tCE53.
    -/
theorem allOnLineUpToCE53 (q : ZeroSet)
    (hZPT2 : WinC.allOnLineUpTo q WinC.tPT2)
    (hW1 : CE2.ce1WinClause) (hW2 : CE3.ce2WinClauseFull)
    (hW3 : CE4.ce3WinClauseFull) (hW4 : CE5.ce4WinClauseFull)
    (hW5 : CE6.ce5WinClauseFull) (hW6 : CE7.ce6WinClauseFull)
    (hW7 : CE8.ce7WinClauseFull) (hW8 : CE9.ce8WinClauseFull)
    (hW9 : CE10.ce9WinClauseFull) (hW10 : CE11.ce10WinClauseFull)
    (hW11 : CE12.ce11WinClauseFull) (hW12 : CE13.ce12WinClauseFull)
    (hW13 : CE14.ce13WinClauseFull) (hW14 : CE15.ce14WinClauseFull)
    (hW15 : CE16.ce15WinClauseFull) (hW16 : CE17.ce16WinClauseFull)
    (hW17 : CE18.ce17WinClauseFull) (hW18 : CE19.ce18WinClauseFull)
    (hW19 : CE20.ce19WinClauseFull) (hW20 : CE21.ce20WinClauseFull)
    (hW21 : CE22.ce21WinClauseFull) (hW22 : CE23.ce22WinClauseFull)
    (hW23 : CE24.ce23WinClauseFull) (hW24 : CE25.ce24WinClauseFull)
    (hW25 : CE26.ce25WinClauseFull) (hW26 : CE27.ce26WinClauseFull)
    (hW27 : CE28.ce27WinClauseFull) (hW28 : CE29.ce28WinClauseFull)
    (hW29 : CE30.ce29WinClauseFull)
    (hW30 : CE31.ce30WinClauseFull)
    (hW31 : CE32.ce31WinClauseFull)
    (hW32 : CE33.ce32WinClauseFull)
    (hW33 : CE34.ce33WinClauseFull)
    (hW34 : CE35.ce34WinClauseFull)
    (hW35 : CE36.ce35WinClauseFull)
    (hW36 : CE37.ce36WinClauseFull)
    (hW37 : CE38.ce37WinClauseFull)
    (hW38 : CE39.ce38WinClauseFull)
    (hW39 : CE40.ce39WinClauseFull)
    (hW40 : CE41.ce40WinClauseFull)
    (hW41 : ce41WinClauseFull)
    (hW42 : ce42WinClauseFull) (hW43 : CE44.fillWinClauseFull) (hW44 : CE44.ce43WinClauseFull) (hW45 : CE45.ce44WinClauseFull) (hW46 : CE46.ce45WinClauseFull) (hW47 : CE47.ce46WinClauseFull) (hW48 : CE48.ce47WinClauseFull) (hW49 : CE49.ce48WinClauseFull) (hW50 : CE50.ce49WinClauseFull) (hW51 : CE51.ce50WinClauseFull) (hW52 : CE52.ce51WinClauseFull) (hW53 : ce52WinClauseFull) (hW54 : ce53WinClause)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0) :
    WinC.allOnLineUpTo q (tCE53 : ℝ) := by
  have hband := bandOfWindows53 hW1 hW2 hW3 hW4 hW5 hW6 hW7 hW8 hW9 hW10 hW11 hW12 hW13 hW14 hW15 hW16 hW17 hW18 hW19 hW20 hW21 hW22 hW23 hW24 hW25 hW26 hW27 hW28 hW29 hW30 hW31 hW32 hW33 hW34 hW35 hW36 hW37 hW38 hW39 hW40 hW41 hW42 hW43 hW44 hW45 hW46 hW47 hW48 hW49 hW50 hW51 hW52 hW53 hW54
  intro ρ hρ ht htH
  by_cases hmid : ρ.im ≤ WinC.tPT2
  · exact hZPT2 ρ hρ ht hmid
  · exact hband ρ (hqz ρ hρ) (not_le.mp hmid) htH

/-- M5
    ·
    THE
    RE-ANCHORED
    FACE
    (window
    53):
    no
    off-line
    zero
    with
    positive
    height
    above
    tCE53.
    -/
def terminalFaceCE53 (q : ZeroSet) : Prop :=
    ∀ (ρ : ℂ), ρ ∈ q.Z → (tCE53 : ℝ) < ρ.im → ρ.re = 1 / 2

/-- Pure
    logic:
    the
    CE52
    face
    implies
    the
    CE53
    face
    (tCE53
    >
    tCE52).
    -/
theorem faceCE52_implies_faceCE53 (q : ZeroSet)
    (hface : CE52.terminalFaceCE52 q) :
    terminalFaceCE53 q := by
  intro ρ hρ ht
  exact hface ρ hρ (by linarith [tCE52_lt_tCE53, ht])

/-- M5
    ·
    THE
    TWO
    FACE
    FORMULATIONS,
    EQUIVALENT
    UNDER
    THE
    BAND:
    the
    extra
    band
    (tCE52,
    tCE53]
    is
    certified
    empty
    (window
    52
    full
    slice
    +
    window
    53
    together
    -
    window
    52
    was
    SNAPPED
    and
    window
    53
    is
    NON-SNAPPED
    with
    THREE
    recorded
    quota-met
    Rosser
    rescues;
    see
    the
    header)
    -
    re-anchoring
    is
    a
    CERTIFICATE,
    not
    a
    logical
    move
    (the
    face
    is
    the
    same
    open
    object,
    now
    certified
    4
    673
    higher;
    the
    225
    000-unit
    mark
    [CE48]
    is
    carried
    and
    the
    250
    000-unit
    mark
    is
    CROSSED
    HERE
    —
    see
    frontierPast250k,
    THE
    250
    000-UNIT
    MILESTONE
    UNIT;
    the
    1
    000
    000-certified-zero
    mark
    [window
    50]
    is
    also
    carried
    —
    counts
    are
    pipeline
    data,
    not
    in-tree
    arithmetic).
    -/
theorem terminalFaceCE53_iff_faceCE52 (q : ZeroSet)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0)
    (hW53 : ce52WinClauseFull) (hW54 : ce53WinClause) :
    terminalFaceCE53 q ↔ CE52.terminalFaceCE52 q := by
  constructor
  · intro hface ρ hρ ht
    by_cases hmid : ρ.im ≤ (tCE53 : ℝ)
    · by_cases hseam53 : ρ.im ≤ (gB52Lo : ℝ)
      · exact hW53 ρ (hqz ρ hρ) (by linarith [ht, CE52.gB51Lo_lt_tCE52, tCE52_lt_tCE53]) hseam53
      · exact hW54 ρ (hqz ρ hρ) (not_le.mp hseam53) hmid
    · exact hface ρ hρ (not_le.mp hmid)
  · exact faceCE52_implies_faceCE53 q

/-- M5  ·  THE  0288  EXACT  RESIDUAL,  RE-PINNED  AT
    tCE53
    (pure  logic).  -/
theorem rh_split_at_CE53 (q : ZeroSet) :
    RH q ↔ WinC.allOnLineUpTo q (tCE53 : ℝ) ∧ terminalFaceCE53 q := by
  constructor
  · intro hRH
    exact ⟨fun ρ hρ him himH => hRH ρ hρ, fun ρ hρ himgt => hRH ρ hρ⟩
  · rintro ⟨hCensus, hFace⟩ ρ hρ
    by_cases hpos : 0 < ρ.im
    · by_cases hle : ρ.im ≤ (tCE53 : ℝ)
      · exact hCensus ρ hρ hpos hle
      · exact hFace ρ hρ (not_le.mp hle)
    · have hneg : ρ.im < 0 := by
        have hle0 : ρ.im ≤ 0 := not_lt.mp hpos
        have hne0 : ρ.im ≠ 0 := q.nonReal ρ hρ
        exact lt_of_le_of_ne hle0 hne0
      have hst : star ρ ∈ q.Z := q.conj ρ hρ
      have hstpos : 0 < (star ρ).im := by
        have h : (star ρ).im = -ρ.im := by rfl
        rw [h]
        exact neg_pos.mpr hneg
      have hstRe : (star ρ).re = 1 / 2 := by
        by_cases hle : (star ρ).im ≤ (tCE53 : ℝ)
        · exact hCensus _ hst hstpos hle
        · exact hFace _ hst (not_le.mp hle)
      have hreEq : (star ρ).re = ρ.re := by rfl
      simpa [hreEq] using hstRe

/-- M5
    ·
    HEADLINE
    (window
    53
    -
    THE
    250
    000-UNIT
    MILESTONE
    IS
    CROSSED,
    non-snapped
    WIDTH
    20
    000
    with
    THREE
    recorded
    quota-met
    Rosser
    rescues;
    the
    1
    000
    000-certified-zero
    mark
    [window
    50]
    and
    the
    225
    000-unit
    frontier
    mark
    [CE48]
    are
    carried):
    given
    [Z-PT2]
    +
    the
    fifty-four
    cited
    window
    clauses
    ([CE1-WIN],
    [CE2-WIN-FULL],
    ...
    [CE49-WIN-FULL],
    [CE50-WIN-FULL],
    [CE51-WIN-FULL],
    [CE52-WIN-FULL],
    [CE53-WIN]),
    all-heights
    RH
    <->
    terminalFaceCE53.
    NO
    RH
    CLAIM.
    -/
theorem rh_reanchored_CE53 (q : ZeroSet)
    (hZPT2 : WinC.allOnLineUpTo q WinC.tPT2)
    (hW1 : CE2.ce1WinClause) (hW2 : CE3.ce2WinClauseFull)
    (hW3 : CE4.ce3WinClauseFull) (hW4 : CE5.ce4WinClauseFull)
    (hW5 : CE6.ce5WinClauseFull) (hW6 : CE7.ce6WinClauseFull)
    (hW7 : CE8.ce7WinClauseFull) (hW8 : CE9.ce8WinClauseFull)
    (hW9 : CE10.ce9WinClauseFull) (hW10 : CE11.ce10WinClauseFull)
    (hW11 : CE12.ce11WinClauseFull) (hW12 : CE13.ce12WinClauseFull)
    (hW13 : CE14.ce13WinClauseFull) (hW14 : CE15.ce14WinClauseFull)
    (hW15 : CE16.ce15WinClauseFull) (hW16 : CE17.ce16WinClauseFull)
    (hW17 : CE18.ce17WinClauseFull) (hW18 : CE19.ce18WinClauseFull)
    (hW19 : CE20.ce19WinClauseFull) (hW20 : CE21.ce20WinClauseFull)
    (hW21 : CE22.ce21WinClauseFull) (hW22 : CE23.ce22WinClauseFull)
    (hW23 : CE24.ce23WinClauseFull) (hW24 : CE25.ce24WinClauseFull)
    (hW25 : CE26.ce25WinClauseFull) (hW26 : CE27.ce26WinClauseFull)
    (hW27 : CE28.ce27WinClauseFull) (hW28 : CE29.ce28WinClauseFull)
    (hW29 : CE30.ce29WinClauseFull)
    (hW30 : CE31.ce30WinClauseFull)
    (hW31 : CE32.ce31WinClauseFull)
    (hW32 : CE33.ce32WinClauseFull)
    (hW33 : CE34.ce33WinClauseFull)
    (hW34 : CE35.ce34WinClauseFull)
    (hW35 : CE36.ce35WinClauseFull)
    (hW36 : CE37.ce36WinClauseFull)
    (hW37 : CE38.ce37WinClauseFull)
    (hW38 : CE39.ce38WinClauseFull)
    (hW39 : CE40.ce39WinClauseFull)
    (hW40 : CE41.ce40WinClauseFull)
    (hW41 : ce41WinClauseFull)
    (hW42 : ce42WinClauseFull) (hW43 : CE44.fillWinClauseFull) (hW44 : CE44.ce43WinClauseFull) (hW45 : CE45.ce44WinClauseFull) (hW46 : CE46.ce45WinClauseFull) (hW47 : CE47.ce46WinClauseFull) (hW48 : CE48.ce47WinClauseFull) (hW49 : CE49.ce48WinClauseFull) (hW50 : CE50.ce49WinClauseFull) (hW51 : CE51.ce50WinClauseFull) (hW52 : CE52.ce51WinClauseFull) (hW53 : ce52WinClauseFull) (hW54 : ce53WinClause)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0) :
    RH q ↔ terminalFaceCE53 q := by
  have hcensus := allOnLineUpToCE53 q hZPT2 hW1 hW2 hW3 hW4 hW5 hW6 hW7 hW8 hW9 hW10 hW11 hW12 hW13 hW14 hW15 hW16 hW17 hW18 hW19 hW20 hW21 hW22 hW23 hW24 hW25 hW26 hW27 hW28 hW29 hW30 hW31 hW32 hW33 hW34 hW35 hW36 hW37 hW38 hW39 hW40 hW41 hW42 hW43 hW44 hW45 hW46 hW47 hW48 hW49 hW50 hW51 hW52 hW53 hW54 hqz
  have hsplit := rh_split_at_CE53 q
  constructor
  · exact fun hRH => (hsplit.mp hRH).2
  · exact fun hFace => hsplit.mpr ⟨hcensus, hFace⟩

/-- M5  ·  THE  FINAL  NAMED  STEP  AT  THE  NEW  FRONTIER:
    given  the  cited  census  inputs  and  a  closing  of
    the  re-anchored  face,  all-heights  RH  holds.  NO  RH
    CLAIM:  no  closing  is  supplied.  -/
theorem rh_of_terminalFaceCE53 (q : ZeroSet)
    (hZPT2 : WinC.allOnLineUpTo q WinC.tPT2)
    (hW1 : CE2.ce1WinClause) (hW2 : CE3.ce2WinClauseFull)
    (hW3 : CE4.ce3WinClauseFull) (hW4 : CE5.ce4WinClauseFull)
    (hW5 : CE6.ce5WinClauseFull) (hW6 : CE7.ce6WinClauseFull)
    (hW7 : CE8.ce7WinClauseFull) (hW8 : CE9.ce8WinClauseFull)
    (hW9 : CE10.ce9WinClauseFull) (hW10 : CE11.ce10WinClauseFull)
    (hW11 : CE12.ce11WinClauseFull) (hW12 : CE13.ce12WinClauseFull)
    (hW13 : CE14.ce13WinClauseFull) (hW14 : CE15.ce14WinClauseFull)
    (hW15 : CE16.ce15WinClauseFull) (hW16 : CE17.ce16WinClauseFull)
    (hW17 : CE18.ce17WinClauseFull) (hW18 : CE19.ce18WinClauseFull)
    (hW19 : CE20.ce19WinClauseFull) (hW20 : CE21.ce20WinClauseFull)
    (hW21 : CE22.ce21WinClauseFull) (hW22 : CE23.ce22WinClauseFull)
    (hW23 : CE24.ce23WinClauseFull) (hW24 : CE25.ce24WinClauseFull)
    (hW25 : CE26.ce25WinClauseFull) (hW26 : CE27.ce26WinClauseFull)
    (hW27 : CE28.ce27WinClauseFull) (hW28 : CE29.ce28WinClauseFull)
    (hW29 : CE30.ce29WinClauseFull)
    (hW30 : CE31.ce30WinClauseFull)
    (hW31 : CE32.ce31WinClauseFull)
    (hW32 : CE33.ce32WinClauseFull)
    (hW33 : CE34.ce33WinClauseFull)
    (hW34 : CE35.ce34WinClauseFull)
    (hW35 : CE36.ce35WinClauseFull)
    (hW36 : CE37.ce36WinClauseFull)
    (hW37 : CE38.ce37WinClauseFull)
    (hW38 : CE39.ce38WinClauseFull)
    (hW39 : CE40.ce39WinClauseFull)
    (hW40 : CE41.ce40WinClauseFull)
    (hW41 : ce41WinClauseFull)
    (hW42 : ce42WinClauseFull) (hW43 : CE44.fillWinClauseFull) (hW44 : CE44.ce43WinClauseFull) (hW45 : CE45.ce44WinClauseFull) (hW46 : CE46.ce45WinClauseFull) (hW47 : CE47.ce46WinClauseFull) (hW48 : CE48.ce47WinClauseFull) (hW49 : CE49.ce48WinClauseFull) (hW50 : CE50.ce49WinClauseFull) (hW51 : CE51.ce50WinClauseFull) (hW52 : CE52.ce51WinClauseFull) (hW53 : ce52WinClauseFull) (hW54 : ce53WinClause)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0)
    (hFace : terminalFaceCE53 q) :
    RH q :=
  (rh_reanchored_CE53 q hZPT2 hW1 hW2 hW3 hW4 hW5 hW6 hW7 hW8 hW9 hW10 hW11 hW12 hW13 hW14 hW15 hW16 hW17 hW18 hW19 hW20 hW21 hW22 hW23 hW24 hW25 hW26 hW27 hW28 hW29 hW30 hW31 hW32 hW33 hW34 hW35 hW36 hW37 hW38 hW39 hW40 hW41 hW42 hW43 hW44 hW45 hW46 hW47 hW48 hW49 hW50 hW51 hW52 hW53 hW54 hqz).mpr hFace

/-- M5  ×  M2  ·  the  0290  lane  closing  lands  DIRECTLY  at
    the  new  frontier.  -/
theorem terminalFaceCE53_of_thetaInf (q : ZeroSet)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0)
    (hInf : ThetaInf.thetaInfImpliesAllOnLine)
    (hC : ThetaInf.thetaInfConjecture) :
    terminalFaceCE53 q := by
  intro ρ hρ ht
  have hall := hInf hC
  exact hall ρ (hqz ρ hρ)

end CE53
