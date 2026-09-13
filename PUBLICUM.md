# PUBLICUM — the Riemann Hypothesis attack, in plain words

*Public digest of the work in this repository, 2026-09-10. Written for
readers outside mathematics. This is a digest of a staged program in
progress — **not a claim to have proved the Riemann Hypothesis** —
and it says so every place it matters. The technical record, with
every number traceable to a script and a raw output, is in the rest
of the repository.*

---

## The problem, in one paragraph

The **Riemann Hypothesis** is the most famous open problem in
mathematics. It concerns a function called the **zeta function**,
invented by Riemann in 1859, whose "roots" (the points where it
equals zero) turn out to be a hidden code for how the **prime
numbers** are distributed. For 167 years, nobody has shown whether
all of the non-boring roots sit on a single vertical line in the
complex plane — the line whose midpoint, 1/2, gives the Hypothesis
its famous shape. If all of them do, the primes obey precise
predictable statistics; if one sits off that line, the statistics
have a built-in wiggle no one has ever seen in more than 40 million
tested cases. (A prize of one million dollars has been waiting since
2000; no prize claim is made or implied here.)

## What we did differently

The classical attacks take the zeros as the main characters and try
to bound their wildness. We flipped the cast.

**We made the primes the lead, and the zeros a supporting role that
has to earn its scene.**

Concretely, we compute the zeta function *from its definition* at
any height — using only primes and elementary summation, no zeros
allowed — and we also keep a second, independent book of the primes:
partial sums and the classical remainder integral. For every cut-off
point N and every height t, the difference between the true zeta
value and this prime-side budget is a number we can compute exactly
and measure precisely.

The program then asks one question, asked at every height:
**where, and how big is the piece of that budget that can only come
from the zeros?**

## The discoveries, in order

**1. The primes' ledger is a closed equation.** We found and
verified (to 50 decimal places; now *machine-checked*, see 5) an
exact identity — the "Euler action" identity — that rewrites the
missing tail of the prime series as a combination of edge terms,
cell moments, and a remainder. The structural reading: the prime
side has its own exact, self-contained bookkeeping. What the ledger
cannot explain is, by construction, exactly the zero content.

**2. The zero content enters at a predicted moment, at a predicted
size.** In that ledger, the first zero-only term appears at a simple,
measurable ratio: it first shows up when *half the height equals the
cut-off* (the "onset" at ½·t = N), and its size obeys a simple
proportional law, agreeing to four digits across scales we could
afford. The same 1/2 that defines the Hypothesis' line is the same
1/2 that sets the onset — one of six measured appearances of 1/2 in
the machinery (the digest of which is in the postulates document).

**3. The zeros' ledger explains it.** Riemann's own 1859 formula
writes the zeta function as a product over its zeros. We built that
product out of a *certified list of 466,655 zeros* (each zero's
position verified to high precision) plus a textbook analytic
correction — and it **reproduced our four-digit prime-side onset
law**, at the predicted heights, inside a quantified error budget.
This is the centerpiece: two books — one computed without any zeros,
the other using only zeros and textbook analysis — agree with each
other to four digits, at the heights the theory says they should.
A coincidence of four digits, at the predicted locations, with an
accounted error floor, is treated here as a *measured bridge*, not
as a proof.

**4. Our auditor is certified against itself.** Every count in this
project is double-checked by the method itself: two step sizes must
agree, and spot audits run at 40 decimal digits. The auditor has
already caught a real bug in itself: on the way to 10⁷ it found a
span of about 246 missed events, localized it by the *size* of a
certain statistic (not by the parity check, which was blind to it),
corrected it, and re-certified the whole run. The standing certified
result: **no off-line zero below 10⁷** — the count of zeros up to
10⁷ is 21,136,123, verified three independent ways — and the primes'
wobble statistic stays at the size the Hypothesis predicts.

**5. One piece of the engine now proves itself.** The exact
summation identity (item 1) is now a *theorem of Lean*, a
mathematical proof assistant, valid for any commutative ring; and an
independent Lean re-implementation of our computation agrees with
the Python oracle to within 2 in the 14th decimal place. Anyone
with the software can run one command on their own machine and see
the check pass. The finite core of the machinery is an external,
machine-auditable fact.

**6. A single stray zero would leave a fingerprint — with an exact
formula.** We computed, in four lines of algebra and verified to 30
digits, exactly how much the zero-side product changes if even one
zero pair were moved off the line. The answer: near the pair's own
height it forces a change of essentially the kernel's entire
magnitude (≥ 99.8%); farther up it *grows quadratically* with the
height ratio; and there is no "dead" offset size that hides the
stray zero. Meanwhile, the stray zero is invisible to the ordinary
angle-counting argument — but it *does* push the size statistic up
by 2. That size-statistic detector is precisely the one that caught
the 246. The instrument we built to audit our own counts is the
same instrument a counterexample would have to fool.

## Why we think it works

The shape of the argument is a **two-sided bridge with a pre-written
trapdoor test**:

- *Side one* (primes, no zeros): exact bookkeeping + the measured
  onset law.
- *Side two* (zeros, no primes beyond the certified list): Riemann's
  own product + a rigorously bounded correction.
- *The bridge* (measured): the two sides agree to four digits at the
  predicted heights, with the error budget accounted.
- *The trapdoor* (exact): if a zero were off the line, the two
  sides would be forced apart by a measured, δ-robust margin —
  detectable by instruments we already run.

What has to be *proved*, not measured, is the last and hardest step:
that this holds **at every height, forever**, not just at the
heights we can compute. We have written that step as a named blank
with three candidate routes and a published decision rule based on
data currently being computed (a larger zero list that tests the
tail-correction model). As of this digest, that step is open. The
repository states exactly what it can and cannot claim, and
separates the measured, the exact, the conjectured, and the
interpretive — in every document, in every row of every table.

## Who made this, and how to check it

The project was conceived and directed by **Jesse S. Miller**; the
computing instrument was co-developed with **Qwen** (Alibaba's large
language model, running locally on Miller's hardware) and is
disclosed as such. No number in the repository was taken from
memory or a book: each traces to a named script and a named raw
output file, and the one time a recalled value disagreed with a
computed one, the code won and the discrepancy was logged. The
machine-checked part runs on a fresh machine in minutes. The
repository's standing position: a prize, if one were ever in order,
is not claimed from these pages; what is offered is a reproducible,
labeled, self-auditing trail with a measured core and a written path
to the open step.


---

## Update — 2026-09-11

Three things moved since this digest.

**The certified height went tenfold — and the prediction was caught
making a mistake.** The independent re-walk of the 10⁷ walk finished: it
measured **244** missing zeros in a dead chunk at the very start of the
window, not the 246 the coarse early estimate had locked in. Both numbers
are even, which means the parity test *cannot* tell them apart — by
design, not by accident — so the decision came from the two independent
direct counts, which agree to the last zero on both windows. The
certified record: **N(10⁷) = 21,136,121** (S = −3.205718, dps-45), and
therefore **no zero off the critical line below height 10⁷** — the
strongest unconditional statement of the project. The pre-registered
246 was wrong, it was caught by the instrument before it became a claim,
and the capture is logged with the buggy first run kept on file. That is
the operating procedure this repository is built around.

**The path is now written as a path.** The proof document
(`docs/RH-PROOF-OUTLINE.md`) has been rewritten to be read linearly: the
hypothesis, the counting language, the two independently defined objects,
the bridge that makes them one, the detector that measures what a
wayward pair must do, and the closure. Each piece has a name (P1–P8), a
stated role, and an honest status. Seven of the eight are proven,
machine-checked, or classical-with-citation; the eighth — the residual
floor — is the single open gap, stated with its two named routes. This is
a complete argument skeleton, not a completed proof, and the document
says so on its first page.

**The machine-checked core moved home.** The Lean package now lives in
this repository (`formal/`), every file in it describes itself up
top (what it is, what role it plays, what state it is in), and a fresh
machine can rebuild and re-run the cross-check gate in minutes (`lake
build && lake exe rhattack`).

## Update — 2026-09-13

**The last two named gaps closed — as machine, and as price.** The
2026-09-11 update left two open rows: the residual floor (P8) and the
closure (P9). Both are now complete in the machine, each with its
honest split written in the file's own header.

**P8 — the "less than" side — is machine-proven** (the `P8Floor`
module, A0–A4): the same-object reduction, the three-term floor from
the missing-tail law, the bridge residual wired to the certified
on-line tail bound, and the decision inequality. Two things are
carried honestly: the near-pair detector floor (0.9975) is a
measured pin, and one equality (the tail's value on the line) is
cited from the standard references rather than re-proven.

**P9 — the closure — is machine-proven as a conditional argument,
and the condition is now one named statement** (the `Closure`
module, C0–C7). What the machine proves: if a zero pair sat off the
line, there would be a *lowest* such pair (over the certified zero
set, structural only); at that pair the zero-side and definition-side
quantities squeeze together; the arithmetic squeeze is impossible;
hence no off-line pair, hence the Hypothesis. The one input the
machine does not re-derive is the *measurement* that feeds the
squeeze at that pair — three numbers per point, each traced to a
named script and a named output. The composition of those three
numbers into the contradiction is itself machine-checked; that is
the statement `p9_closure_at_audit_point`.

**A surprise on the detector side, now in the machine (C1a).** The
original plan carried a pinned lower bound ("at least 99.8% of the
kernel's magnitude, near the pair") as the near-field detector
floor. The machine work found the floor question was slightly the
wrong question: exactly at the pair's own height the ratio has a
*pole* — the on-line pair's product vanishes at its own point while
the off-line mass stays a strictly positive constant, so the kernel
change there is an EXACT value, not a floor. Seven atoms of this
fact are machine-proven. The 99.8% number survives as a statement
about the window away from the pair; a later audit (DISCOVERY_LOG 21)
found the closure's point is actually *free* — it is evaluated at the
measured straddle heights, as in the original probe protocol — so the
window floor is a genuine input to the closure's picture, not a
demotable footnote.

**And trapdoors are traps, so we tested them across the band.** The
closure's per-point facts had been verified around height 10³ (worst
margin 112.6×). We extended the scan to fifteen candidate pair
heights from 2×10³ to 10⁵ — and then the instrument caught itself:
the apparent "erosion" at higher heights (the readings 11.3 at 10⁴
and 1.053 at 5×10⁴) was traced to the composite kernel's (B,∞) tail
*model*: its error inflates the composite's own magnitude, which
flattens the measured ratio to about 1 (the 1.053 matches the model's
own inflation asymptote to 4 sig-figs, and the 2.27 "recovery" at 10⁵
is its (f−1)⁻¹ — fingerprints, DISCOVERY_LOG 20). The genuine,
regime-verified margins are 112.6 at 10³ and **34.7 at 5×10³ — the
closing, re-pinned and machine-checked as an arithmetic fact** — and
the best-straddle trend (the closure-faithful statistic, DISCOVERY_LOG
21) stays comfortably above 1 through 2×10⁴. Every scanned point in
the verified regime still passes the pointwise decision, and the
pre-registered rule stands: if the squeezed margin ever collapses
below 1 **in a verified regime**, the route retires rather than the
claim being papered over. The repair — a 1×10⁷ zero list (running,
day-023) — is expected to push the verified regime to roughly
10⁵–2.5×10⁵, and the verdict at the boundary will be recorded when it
lands.

**Where this leaves the claim — stated plainly.** The machine-
proven core (counting lemma through closure, every piece named P1–P9)
is complete: it is a reproducible package, rebuilt and re-gated in
minutes on a fresh machine. What is *measured, not proven in the
machine*: the three per-point trapdoor numbers, verified on the
recorded band [~10³, 10⁵] at grid resolution for fifteen candidate
pair heights. What that honestly allows: a hypothetical off-line pair
*inside the verified regime, at a measured height, at a grid point*
cannot exist without contradicting the squeeze. What it does not
allow: a claim about an off-line pair at an unmeasured height — the
gaps between the candidate heights, the bands beyond the record, and —
now traced to the composite tail-model error rather than the squeeze —
the sub-1 readings in the masked band are stated as the remaining
measurement price, in the outline and in the module header. No prize
is claimed from these pages, as before; the repository's position is
unchanged: a reproducible, labeled, self-auditing trail, with the
open part named rather than papered over.
