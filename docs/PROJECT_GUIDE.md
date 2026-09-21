# PROJECT GUIDE — running `rh-missing-tail` from a clean machine

A short orientation for someone new to this repository: what it is, how
to get a working environment (the Docker container, or plain Python),
where the important scripts live, how to download the data the
experiments need (one script does it all), and the basic test commands.

If you want the mathematics, start at [README.md](../README.md) and
[docs/RH-PROOF-OUTLINE.md](RH-PROOF-OUTLINE.md). This page is the
*operating* manual.

---

## 1. What this repository is (two lines)

A working, machine-checkable attack on the Riemann Hypothesis, built in
public. The **Lean** proofs (`formal/`) carry the argument; the
**Python** scripts (`scripts/rh/`) produce and audit the measured data
it runs on. No zero data is committed — every band is regenerable from
the public LMFDB index by a single script (Section 4).

**Honesty note (read this first):** this project does **not** currently
claim the Riemann Hypothesis is proved. What is and is not established,
item by item, is in [docs/KNOWN_LIMITATIONS.md](KNOWN_LIMITATIONS.md)
and the ceiling section of the preprint. Treat that as the contract with
you.

---

## 2. Getting a working environment

### 2a. Docker (recommended, zero local setup)

Build the image once from the repository root:

```sh
docker build -t rh-missing-tail .
```

Run it with your checkout bind-mounted over `/work`:

```sh
docker run --rm -it -v "$PWD":/work rh-missing-tail
```

What is inside:

| piece | version / pin |
|---|---|
| Python | 3.12 (digest-pinned base image) |
| mpmath | 1.4.1 (hash-pinned, `requirements.lock`) |
| numpy | 1.26.4 (hash-pinned) |
| Lean / lake | 4.33.1 via elan (mathlib downloads on the first `lake build`, once) |
| R | base R installed (because you were hoping) |
| editors | `emacs` and `nano`. Also `vi`, `vim`, `ex`, `view` — try them and see what launches |
| misc | git, curl |

The image deliberately runs **nothing** at boot. To run a repo command
from inside, use the `rh-reproduce` wrapper (it `cd`s to the checkout
root for you):

```sh
docker run --rm -v "$PWD":/work rh-missing-tail \
    rh-reproduce python3 scripts/rh/rh_fetch_data.py low
```

### 2b. Plain Python (no Docker)

You need Python 3.12 with the two pinned libraries:

```sh
pip install --require-hashes -r requirements.lock
```

(Lean is only needed for Section 5, item 3; install [elan](https://leanprover.io)
with the `leanprover/lean4:v4.33.1` toolchain if you want `lake build`
to work too.)

---

## 3. Where things are

```
rh-missing-tail/
├── README.md                 the project page (start here for the math)
├── Dockerfile                the reproducibility image (Section 2a)
├── requirements.lock         the hash-pinned Python stack
├── DISCOVERY_LOG.md          the dated working log (the one place dates live)
├── docs/                     the argument, plans, and reports
│   ├── INDEX.md              table of contents for docs/
│   ├── RH-PROOF-OUTLINE.md   the reader-facing exposé of the whole path
│   ├── KNOWN_LIMITATIONS.md  what is NOT established, item by item
│   └── PREPRINT-DRAFT-*.md   the draft (pre-registered outcome language)
├── formal/                   the Lean proof (Lean 4.33.1 + mathlib)
│   ├── RhAttack.lean         the module index
│   └── RhAttack/*.lean       one file per proven piece (W2*, S4*, M6, ...)
└── scripts/rh/               the measured-data engine
    ├── rh_fetch_data.py      THE data entry point (Section 4)
    ├── day024_platt_fast.py  the bit-exact Platt-shard decoder
    ├── day024_band_1e9.sh    the (3.2e7, 1e9] band pipeline
    ├── day035_3e9_stream.sh  the (2e9, 3e9] band pipeline
    ├── day035_t25_orchestrator.py   the 3e10 parallel fetch+decode
    ├── day036_epsilon_sweep.py      the per-gap epsilon data layer
    ├── day036_finish_gates.py       band completion gates
    ├── day037_h1_3e10.py     the H1 full-band certificate engine (CPU)
    ├── day038_h1_3e10_gpu.py the H1 engine with the iGPU slab path (ROCm)
    └── hi1e9/  hi3e9/  hi3e10/   where the data lands (gitignored)
```

The measurement engines read the bands from the `hi1e9/`, `hi3e9/`,
`hi3e10/` subdirectories of `scripts/rh/` — those directories are empty
in git by design (the data is fetched, never committed).

---

## 4. Downloading the data

One script, all bands, resume-safe:

```sh
python3 scripts/rh/rh_fetch_data.py low     # ~1 GB,   a few minutes
python3 scripts/rh/rh_fetch_data.py 1e9     # ~22 GB,  15-45 min
python3 scripts/rh/rh_fetch_data.py 3e9     # ~50 GB,  30-90 min
python3 scripts/rh/rh_fetch_data.py 3e10    # ~740 GB, ~3-7 h   (needs the disk)
python3 scripts/rh/rh_fetch_data.py all     # in that order
python3 scripts/rh/rh_fetch_data.py --check # verify what is already there
```

Source is the public LMFDB zero index (`beta.lmfdb.org`), every shard
md5-verified, every band COUNT-chained against its predecessor, and
each band's completion is gated against the Riemann–von Mangoldt
asymptotic. Interruptions are expected (the network will fail); just
re-run the same command.

The `low` band is all you need for the smoke tests below. `3e10` is the
full-band run (740 GB — plan for it deliberately).

---

## 5. The test commands

In increasing size. From the repository root (or via `rh-reproduce`
inside the container):

### 5.1 Engine self-test — no data, a couple of minutes

```sh
H1CERT_SELFTEST=1 python3 scripts/rh/day037_h1_3e10.py
```

Exercises the H1 certificate engine (slab arithmetic, drift budget, the
dps-30/60 cross-implementation audits) on synthetic data. You want to
see `SELFTEST PASS` twice and the process exit 0. Green here means the
computation core is intact on your machine.

### 5.2 The full smoke-test — small data, a few minutes

```sh
python3 scripts/rh/rh_fetch_data.py low
python3 scripts/rh/day030_lowt_sweep.py
```

Fetches the small band (Section 4) and runs the low-t data-territory
sweep: a real, certified margin computation over 207 test points in the
t0 < 1000 territory, written to `scripts/rh/out_day030_lowt_sweep.txt`.
The result you expect: **margin >= 1 at all points** (the territory is
filled). This is the smallest end-to-end run that touches real zero
data, a real decode, and a real certificate.

### 5.3 The Lean build — 20-60 min the first time

```sh
cd formal && lake build
```

Compiles the proof. First run downloads mathlib (a few GB, once). Exit
0 = every module in the argument compiles. This is the
machine-checking gate: if your environment cannot build this, it has no
claim on the rest.

### 5.4 The big run — what the project is actually doing

After fetching all four bands:

```sh
WORKERS=14 python3 scripts/rh/day037_h1_3e10.py     # CPU engine
```

(On a ROCm machine with real FP64, `day038_h1_3e10_gpu.py` runs the
same certificate with the slab sums on the iGPU and is the faster
engine; it is bit-for-bit the same statistic, with relaxed — never
tighter — rounding envelopes, self-test included:
`H1CERT_SELFTEST=1 python3 scripts/rh/day038_h1_3e10_gpu.py`.)
This is a multi-day, ~100 GB-peak-memory, whole-band certificate run;
use a machine you can afford to leave alone, and 14 of a 16-core box
(the two-core reservation is law here).

### 5.5 Reproduce a number from the paper

Any figure in the docs/ preprint traces to a script + data band in
`scripts/rh/`; the preprint cites each one. `docs/INDEX.md` maps
every document to the artifact behind it.

---

## 6. Small manual of conventions

- **No data in git, ever.** `.f64`/`.dat` files are gitignored; the
  fetch script is the only way in.
- **Dates live in one place** — `DISCOVERY_LOG.md` — by house rule;
  git history is the timestamp authority for everything else.
- **Two cores are reserved.** Any engine you run should leave the box
  usable (`WORKERS=14` on 16 cores is the standing default).
- **Certificates are the output, not the values.** Engines print
  margin/cert rows (`margin_new`, `margin_cert`, `budget_...`);
  `STATUS: C-1` means every point certified. Read
  `docs/KNOWN_LIMITATIONS.md` before interpreting a number.
- If you type `vi` in the container and emacs opens, that is the
  intended behavior. Good luck with `:q`.
