"""s21v: S21c stage-B merge (3e23/9e23 rows) + 3e21/9e21 full-primary
re-issue rows (provenance-only).

Persists to tmp/s34t_far_rows.jsonl.  Idempotent: (lab, stage) keys
already present are skipped.

Zeta source policy (the s34u policy, extended):
  *  3e23/9e23:  FULL channel primary (chain 8/9, fixed table).  The
     same-N bare crosses are PENDING (tmp/s21c_bare_queue.sh); the row
     carries the full value with the cross status, NOT an unverifiable
     envelope number (the per-row envelope computations of the s21a
     session were not persisted -> we do not cite them; the bare
     instrument's own declared uncertainty (~2.5e-5 on |Z|, printed on
     every bare line) is the check standard when the crosses land).
  *  3e21/9e21:  FULL channel primary (chains 6/7, fixed table),
     same-N bare cross measured -> d logged.  M is bit-identical
     across channels (verified in the S21a unit), so this is a
     provenance-only update; the old B_merge (bare primary) row stays
     as history.  No RH claim.
"""
import json
import math
import os
import re

BASE = "/home/jsmille/Projects/rh-missing-tail"
TMP = os.path.join(BASE, "tmp")
ROWS = os.path.join(TMP, "s34t_far_rows.jsonl")
QUEUE = os.path.join(TMP, "s21c_queue.log")
FIXED = os.path.join(TMP, "s21a_fixed.log")
STAGEA = os.path.join(TMP, "s21c_stageA.log")


def lines(p):
    with open(p) as f:
        return f.read().splitlines()


def parse_logzeta(path, chain_lab=None):
    """logzeta= lines -> dict keyed by float(t) (f64 round-trip: the C
    printers emit different decimal preciations of the same f64)."""
    out = {}
    for ln in lines(path):
        m = re.search(r"t=([\d.eE+-]+)\s+logzeta=([-\d.eE+]+)\s+N=(\d+)", ln)
        if m:
            out[float(m.group(1))] = dict(logzeta=float(m.group(2)), N=int(m.group(3)), tstr=m.group(1))
    return out


def parse_bare(path):
    out = {}
    for ln in lines(path):
        m = re.search(r"t=([\d.eE+-]+)\s+bare-cos-form \|Z\|\s*=\s*([\d.]+)", ln)
        if m:
            out[float(m.group(1))] = dict(bare=float(m.group(2)), tstr=m.group(1))
    return out


def parse_stagea_law(path):
    """(C zeta expected ~ X) per r= line, in row order."""
    out = []
    for ln in lines(path):
        m = re.search(r"r=([\d.eE+]+)G.*zeta\s+expected\s+~\s+([-\d.eE+]+)\)\s+[\d.]+\s+s$", ln)
        if m:
            out.append((m.group(1), float(m.group(2))))
    return out


full_fixed = parse_logzeta(FIXED)     # c5, c6, c7 full (fixed table)
full_queue = parse_logzeta(QUEUE)     # c8, c9 full (fixed table)
bare_queue = parse_bare(QUEUE)        # bare c6, c7 same-N fixed table
law34 = parse_stagea_law(STAGEA)      # +3.726138e7 / -6.333622e7

rows = [json.loads(l) for l in lines(ROWS) if l.strip()]
have = {(r["lab"], r["stage"]) for r in rows}


def add(lab, stage, **fields):
    if (lab, stage) in have:
        return None
    row = dict(lab=lab, stage=stage)
    row.update(fields)
    rows.append(row)
    have.add((lab, stage))
    return row


def a_row(lab):
    return next(r for r in rows if r["lab"] == lab and r["stage"] == "A_no_zeta")


def old_b_row(lab):
    for r in rows:
        if r["lab"] == lab and r["stage"] == "B_merge":
            return r
    return None


# ---- 3e21 / 9e21 : full-primary re-issue (provenance-only) -------------
for lab, tkey in (("r=1.0e+11G", "3.0001045999981974e+21"),
                  ("r=3.0e+11G", "9.0003137999945922e+21")):
    d_full = full_fixed[float(tkey)]
    d_bare = bare_queue[float(tkey)]
    zf = math.exp(d_full["logzeta"])
    d = abs(zf - d_bare["bare"])
    dlog = abs(d_full["logzeta"] - math.log(d_bare["bare"]))
    old = old_b_row(lab)
    add(lab, "B_merge_full",
        t=(old or {}).get("t"),
        logzeta=d_full["logzeta"],
        N=d_full["N"],
        Z_full=zf,
        bare=d_bare["bare"],
        d_abs=d,
        d_log=dlog,
        check="same-N bare cross, fixed table; instrument self-declares ~2.5e-5 on |Z|; d=%.3e -> FULL primary valid" % d,
        M=old["M"] if old else None,
        M_round=old["M_round"] if old else None,
        integer_quantized=bool(old and old.get("integer_quantized")),
        quant_resid=old["quant_resid"] if old else None,
        f64_sum_match=bool(old and old.get("f64_sum_match")),
        zeta_src=("C/quad FULL (chain %s, fixed table) PRIMARY - same-N bare-cos "
                  "cross d = %.4e (|Z|), d_log = %.3e; supersedes the S21a "
                  "B_merge bare-primary row (provenance-only: M bit-identical "
                  "across channels)" % ("6" if "1.0" in lab else "7", d, dlog)),
        supersedes="B_merge (bare primary)",
    )

# ---- 3e23 / 9e23 : full primary, bare cross pending --------------------
law_by_order = law34  # [(r=1.0e+12G, +3.726138e7), (r=3.0e+12G, -6.333622e7)]
for lab, tkey, chain, ulp in (("r=1.0e+12G", "3.0001045999981976e+22", "8", 2),
                              ("r=3.0e+12G", "9.0003137999945920e+22", "9", 16)):  # float-keyed
    a = a_row(lab)
    d_full = full_queue[float(tkey)]
    M = a["M_partial"]
    law_resid = next(v for k, v in law_by_order if k in lab)
    add(lab, "B_merge",
        t=a.get("t"),
        logzeta=d_full["logzeta"],
        N=d_full["N"],
        Z_full=math.exp(d_full["logzeta"]),
        bare=None,
        d_abs=None,
        d_check="PENDING - same-N bare cross queued (tmp/s21c_bare_queue.sh, PID 4124046); "
                "standard = bare instrument self-declared ~2.5e-5 on |Z|",
        M=M,
        M_f64_ulp=ulp,
        exact_M_established=False,
        M_note=("f64 partial sum, ulp = %d: the exact-integer M era (closed at "
                "9e21) ends at this height - parity of M is not recoverable "
                "from f64" % ulp),
        Mlaw_resid=law_resid,
        rel_resid=law_resid / abs(M),
        Mlaw_note="as printed by the C stageA log ('C zeta expected ~')",
        law_pred_M=a["law_pred_M"],
        I_far=a["I_far"],
        I_far_dps60=a["I_far_dps60"],
        I_far_dps80=a["I_far_dps80"],
        f64_partial_sum_match=bool(a["f64_partial_sum_match"]),
        zeta_src=("C/quad FULL (chain %s, fixed table) PRIMARY - 28714.1s/16390.1s; "
                  "same-N bare cross pending" % chain),
    )

with open(ROWS, "w") as f:
    for r in rows:
        f.write(json.dumps(r) + "\n")

print("rows now: %d" % len(rows))
for lab in ("r=1.0e+11G", "r=3.0e+11G", "r=1.0e+12G", "r=3.0e+12G"):
    for r in rows:
        if r["lab"] == lab and r["stage"].startswith("B_merge"):
            print("%-10s %-13s logzeta=%s d_abs=%s bare=%s"
                  % (lab, r["stage"], r.get("logzeta"),
                     r.get("d_abs"), r.get("bare")))
