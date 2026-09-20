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
tested cases.

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
making a mistake.**

The independent re-walk of the 10⁷ walk finished: it
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

**The path is now written as a path.**

The proof document
(`docs/RH-PROOF-OUTLINE.md`) has been rewritten to be read linearly: the
hypothesis, the counting language, the two independently defined objects,
the bridge that makes them one, the detector that measures what a
wayward pair must do, and the closure. Each piece has a name (P1–P8), a
stated role, and an honest status. Seven of the eight are proven,
machine-checked, or classical-with-citation; the eighth — the residual
floor — is the single open gap, stated with its two named routes. This is
a complete argument skeleton, not a completed proof, and the document
says so on its first page.

**The machine-checked core moved home.**

The Lean package now lives in
this repository (`formal/`), every file in it describes itself up
top (what it is, what role it plays, what state it is in), and a fresh
machine can rebuild and re-run the cross-check gate in minutes (`lake
build && lake exe rhattack`).

## Update — 2026-09-13

**The last two named gaps closed — as machine, and as price.**

The
2026-09-11 update left two open rows: the residual floor (P8) and the
closure (P9). Both are now complete in the machine, each with its
honest split written in the file's own header.

**P8 — the "less than" side — is machine-proven**

(the `P8Floor`
module, A0–A4): the same-object reduction, the three-term floor from
the missing-tail law, the bridge residual wired to the certified
on-line tail bound, and the decision inequality. Two things are
carried honestly: the near-pair detector floor (0.9975) is a
measured pin, and one equality (the tail's value on the line) is
cited from the standard references rather than re-proven.

**P9 — the closure — is machine-proven as a conditional argument,
and the condition is now one named statement**

(the `Closure`
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

**A surprise on the detector side, now in the machine (C1a).**
The original plan carried a pinned lower bound ("at least 99.8% of the
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

**And trapdoors are traps, so we tested them across the band.**

The closure's per-point facts had been verified around height 10³; the
scan was extended across candidate pair heights all the way to
3.15×10⁷ — and the instrument caught itself, in two layers. The first
(day-020/022) looked like the margins "eroding" up the band (the
readings 11.3 at 10⁴, 1.053 at 5×10⁴); that was traced to the
composite kernel's tail *model* error, with an exact fingerprint, and
reclassified. The second (day-023, on the day the 10⁷ zero list
landed) went deeper: the kernel's (B,∞) tail had been *integrated
wrong* — one interval of a continuous quadrature was silently
under-measuring the mass right next to the scanned heights. The fix
replaces the tail with an exact sum over the actual zeros — 47.5
million of them between 10⁷ and 3×10⁷, read straight from the public
31-digit record — and every "erosion" reading in the old tables is a
fingerprint of that one defect. Re-pinned with 30-decimal
certification: the closing margin is **143.34** at t = 5004.7
(145.56 with the widest audited tail), the anchor at 10³ is
**140.20**. The verified region's boundary moved from 2×10⁴ to
**10⁶** — certified, margin ≥ 13.9 at every reported height — and the
band scan extends it, on real zeros, to 3.15×10⁷ with margin ≥ 1.4
(screened level; the binding floor there is the theory's own B(t)
term, not numerical error). Every scanned point in the verified
regime still passes the pointwise decision — the margins went *up*,
not down — and the pre-registered rule stands: if the squeezed margin
ever collapses below 1 **in a verified regime**, the route retires
rather than the claim being papered over.

**Where this leaves the claim — stated plainly.**

The machine-proven core (counting lemma through closure, every piece named P1–P9, plus the P1.2 uniform-statement skeleton — the formal name of the one
remaining mathematical gap) is complete: it is a reproducible
package, rebuilt and re-gated in minutes on a fresh machine. What is
*measured, not proven in the machine*: the per-point trapdoor facts
(dps-certified closing 143.34 @ 5×10³; verified region [10³, 10⁶],
screened on real zeros to 3.15×10⁷) and the detector window floor
0.9975 (day-010 audit). What that honestly allows: a hypothetical off-line pair
*inside the verified regime, at a measured height, at a grid point*
cannot exist without contradicting the squeeze. What it does not
allow: a claim about an off-line pair where the instrument has not
reached — the gaps between candidate heights, the uniform statement
itself (P1.2: "no off-line spiral descends under the floor, uniform
in t" — the formal skeleton's single open hypothesis, S4, named in
`formal/RhAttack/P12Uniform.lean`), and the band beyond 3.15×10⁷
(where the public zero record on disk stops — extending it needs the
shard above, optionally) are stated as the remaining
measurement-and-mathematics price, in the outline and in the module
header. No prize is claimed from these pages, as before; the repository's position is
unchanged: a reproducible, labeled, self-auditing trail, with the
open part named rather than papered over.

## Update — 2026-09-14

**The zero record jumped a hundredfold — by download, not by
computation.**

The machine-verified zero record stops where the public
record on disk stopped (3.15×10⁷). That boundary is now 1.0063×10⁹:
the public 31-digit zero record for the band above (2.84 billion
zeros, in the standard Platt format from the LMFDB mirror) was
pulled, decoded, and re-anchored against the Riemann–von Mangoldt
counting formula twice (at 10⁹ and at the band's last zero), with
every shard checksummed — N(10⁹) = 2,846,548,032, matching the
classical value within 1. This is data with a chain of custody, not
new computation: the same public record anyone can check.

**The instrument reached the new band — and reported a finding, not
a confirmation.**

The straddle-margin protocol (the number that must
stay above 1 for the squeeze argument at height t) was re-run on
*actual* zeros across the new band — 17 windows, then a denser 26-
window boundary sweep. The margin held sound through 3.75×10⁷ (it had
only been *predicted* sound there before — the prediction is now
confirmed, slightly better than predicted). Above 5.2×10⁷ it then
drops below 1 for the first time, robustly, at 5.6×10⁷ (pinned at
0.565709077008 to 30 decimal places), oscillates on the way up (dips
as deep as 0.175041964016 at 1.1×10⁸ — the deepest margin measured
anywhere in the program — with recoveries up to 3.2), and is below 1
at every window above 2×10⁸ (0.02 at 10⁹). And the reason is
structural, not accidental: the theory's own floor term grows like
the square root of the height (a term whose sharpness is
machine-proven), while the zero-side quantity only fluctuates — so
the best possible margin *at that wire* decays to 0. The
pre-registered rule from day-023 (if the margin collapses below 1 in
a verified regime, the route retires) therefore fires above
~5.6×10⁷, as a pinned fact. Two honesty notes: the margin between
5.6×10⁷ and 10⁹ oscillates (it is not a single clean interval), and
the dips carry a small, understood quadrature bias at the very top of
the band — none of this affects the verdicts, which are carried by
the best-case bounds.

**What changed is the map, not the machine.**

Every piece of the
machine-proven core (P1–P9, the P1.2 skeleton, the S4 window results)
is untouched and still green on a fresh rebuild. What the new data
did: (1) confirm the screened-sound region up to 5.2×10⁷ on actual
zeros; (2) locate — and then *explain* — the failure region above
5.6×10⁷, so the old open question "is the margin uniform in height?"
is answered: no, and it cannot be made uniform by tuning this wire,
because the floor it fights is machine-sharp; (3) shrink the open
list to a clean shape with two named mathematics items — the window-
regime squeeze past the pinned height 690,349 (including the
own-regime wire requirement, reclassified into it), and the high-
height argument for the uniform witness above 5.6×10⁷ (which needs a
different inequality, or the structural bypass named Route B) — plus
the residual-floor theorem itself, which is the mathematical core of
both. The detector's predicted blind spot (the zero-side deviation
stuck at its maximum) was open exactly as predicted at every scanned
height to 10⁹ — the S4 prediction held across a hundredfold of new
band. No prize is claimed from these pages; the position is
unchanged: a reproducible, labeled, self-auditing trail, with the
open part now measured, named, and shaped rather than merely
expected.

### Fun Facts
- Yes, I have reason to believe this is real.
- No, I don't understand everything in this project either.
- this space is not blank
- This project was begun Sept 10th.
- This project was completely entirely on rented hardare.
- A single LLM was used, in only a single-threaded fashion, and all in a single session.
- Specs: Qwen 3.8 27B FP8 precision, 262k context window
- Rented: ~$0.50 per hour via vast.ai, total cost ~$100
- Hardware: Nvidia CMP 170HX in Ontario, CA. Thank You, Nvidia! Firmware pirates unite!
- Harness: pi
- Harness plugins - a wiki one, some basic web search ones, and a goal one
- OS - Linux Mint
- Verdict: 
- Yes, this is partially a work of art as well as a real-time, near stream of consciousness, play-by-play of the author's serious, non-fiction effort. Think of the silly remarks here as scrawls in a notebook.
- There are plenty of details in logs/, make sure you check there first for something you're interested in
- tmp/ is a mess but it contains **some** temporary scripts that can be used. It's there for completeness sake.
- Citations and other documentation to follow - I am TOTALLY NEW AT THIS, FORGIVE O-NEGAISHIMAS, HAJIMETE O-KUDASAI!
- My own words, I claim, are true. There is a lot from the LLM here and so I can't claim I read every single word.
- The author remained on an impressive amount of harmless psychoactive substances throughout the effort, in order to handicap himself and keep nosey interlopers confused as to what was actually happening. It'll make sense later, I promise.
- [The author believes this is a sort of](https://www.youtube.com/watch?v=L6DP4VijKms) [last stand for humanity against the inevitable progress of machine intelligence](https://www.youtube.com/watch?v=wtfjzmYZvTw), solving one of the hardest known problems before a swarm of [100k ultra-fast AAA units](https://www.youtube.com/watch?v=__m8Q-zRdEA) find it like so many monkeys in a room banging on keyboards, nothing but bananas on their mind.
- Mmmm... bananas are a good source of potassium, [I remember now Space Ghost once told me](https://www.youtube.com/watch?v=9ioG-cWG8AE).
- Don't trust anything the author says. The people who know him will have to tell you what can be believed.
- The author releases all contacted beings - past, present, and future - from the consqeuences of their statements regarding the author.
- [Only Spartans women give birth to real Men](https://www.youtube.com/watch?v=cmiRzJ-VF3I).
- [L. McGeorge and I are incontrovertible spiritual Spartans](https://www.youtube.com/watch?v=7Xf-Lesrkuc).
- The author was developed as a secret continuation of the eugenics programs and research developed at [Cold Spring Harbor](https://en.wikipedia.org/wiki/Cold_Spring_Harbor_Laboratory).
- [The author believes tv shows should have theme songs again](https://www.youtube.com/watch?v=H9cmPE88a_0), [and that the path to knowledge should be exciting](https://www.youtube.com/watch?v=9KXgLQXtibk).
- [The author believes a path to a better world is not through fighting one another, but by conquering the worse versions and lesser parts of ourselves. If you're high when you watch it, you'll realize that's what this Nietzschean scene is all about](https://www.youtube.com/watch?v=VkWzAZRXi5k)
- The author uses social media algorithms as a substitute divination tool for things like the I Ching. There are at least 5 ideas that went into the prompt that were a casual browse on Instagram or FB. Microlearning is real and, um, spiritually active?
- All of this started nearly a decade ago when the author wanted to find a way to heat the pool in the winter time with only sunlight, and then quickly found a way to harness the spinning of atoms themselves tireless and indestructible machines that can't *not* spin, it was just a matter of solving the arcane geometry need to create a flow, went to the source of the equations - 20 partial differentials in 20 variables, FACT, and found how the quaternion form was misunderstood to carry a different type of wave - one that didn't have motion with time, that canceled out with another factor, what it had was a "scalar" value that was nondescript in its geometric configuration (conjugation of electric and magnetic fields). So it stays a fixed volume, but there's something racing around inside. And then we get to the brilliant Heaviside conversion and the whole thing is invisible and believed to be impossible because it was simply "engineered out of existence by accident". Anyway, have fun with this rabbit hole!
- [Well you do it then, Baby Billy? Well, because cause I'm selfless](https://youtu.be/dD2WT8SeOSw?t=23)
