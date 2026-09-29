#!/usr/bin/env python3
"""h1_verify_all -- read-only, exhaustive verification of the 3e10 H1
fill data currently in hand.  Answers, before the cloud box is turned
off, the exact question: do we hold (locally + on the drive copy now
in git) every certified point the fleet produced, and does the union
cover all 29 windows with k = -12..+12 (k != 0)?

READ-ONLY: every open goes through h1merge_ingest.rdopen (O_RDONLY).
Writes nothing.

Sources audited (all on this machine, in git or the git-copied drive
delivery):
  STRIX   scripts/rh/ckpt_h1_3e10/widx*.pts
  C4090   scripts/rh/h1_final_fleet/4090-box/out_day038_full_pts.txt
  X5900   scripts/rh/h1_final_fleet/5900x/ckpt/widx*.pts   (snapshot)
Plus log forensics on the 4090-box instance logs a-h and the 5900x
engine logs (completion banners, per-point lines, gate failures).
"""
import glob
import os
import re
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
import h1merge_ingest as M   # noqa: E402  (parser + O_RDONLY only)

ROOT = os.path.dirname(os.path.dirname(HERE))
CKPT = os.path.join(ROOT, "scripts", "rh", "ckpt_h1_3e10")
FLEET = os.path.join(ROOT, "scripts", "rh", "h1_final_fleet")

K_ALL = set(range(-12, 13)) - {0}


def canon_x(xf):
    return "%.10f" % xf


WITHIN_DUP_DIFF = []  # (xkey, k, raw1, raw2, file1, file2) same-machine


def parse_pts_lenient(path):
    """Same as h1merge_ingest.parse_pts but skips '#' comment header
    lines (only the engine's ASSEMBLED files carry them; raw widx
    checkpoint files never do).  Read-only (O_RDONLY)."""
    rows, dropped, corrupt = [], 0, None
    with M.rdopen(path) as f:
        text = f.read()
    nonempty = [ln for ln in text.split("\n") if ln
                and not ln.startswith("#")]
    for idx, ln in enumerate(nonempty):
        if ln.startswith("audit,"):
            continue
        f_ = ln.split(",")
        if f_[0].strip() not in ("ok", "FLAG"):
            corrupt = (idx + 1, "unexpected row prefix " + repr(f_[0][:8]))
            break
        if len(f_) != 21:
            if idx == len(nonempty) - 1:
                dropped = 1
                continue
            corrupt = (idx + 1, "field count %d != 21 (non-tail)" % len(f_))
            break
        try:
            k = M._k_of_row(f_)
        except (ValueError, IndexError):
            if idx == len(nonempty) - 1:
                dropped = 1
                continue
            corrupt = (idx + 1, "unparseable t/g")
            break
        rows.append((k, ln))
    return rows, dropped, corrupt


def load_source(name, paths, lenient=False):
    """paths -> {xkey: {k: (source, rawline, path)}}; problems too."""
    parser = parse_pts_lenient if lenient else M.parse_pts
    xk = {}
    problems = []
    torn = 0
    for p in sorted(paths):
        rows, dropped, corrupt = parser(p)
        if corrupt:
            problems.append("CORRUPT %s line %s: %s" % (p, corrupt[0],
                                                       corrupt[1]))
        torn += dropped
        for rec in rows:
            # rec = (k, raw_line) per h1merge_ingest.parse_pts
            k, raw = rec
            f_ = raw.split(",")
            xk_ = canon_x(float(f_[1]))
            d = xk.setdefault(xk_, {})
            if k in d:
                problems.append(
                    "DUP within source %s: x=%s k=%d (%s vs %s) %s"
                    % (name, xk_, k, os.path.basename(d[k][2]),
                       os.path.basename(p),
                       "rows DIFFER" if d[k][1] != raw
                       else "rows byte-identical"))
                if d[k][1] != raw:
                    WITHIN_DUP_DIFF.append((xk_, k, d[k][1], raw,
                                            d[k][2], p))
            else:
                d[k] = (name, raw, p)
            if k in d and d[k][1] != raw:
                pass  # keep first occurrence for the union
    return xk, problems, torn


def main():
    # ---------------------------------------------------------------- load
    s_strix, p_strix, t_strix = load_source(
        "STRIX", glob.glob(os.path.join(CKPT, "widx*.pts")))
    s_c4090, p_c4090, t_c4090 = load_source(
        "C4090", [os.path.join(FLEET, "4090-box",
                               "out_day038_full_pts.txt")],
        lenient=True)
    s_x5900, p_x5900, t_x5900 = load_source(
        "X5900", glob.glob(os.path.join(FLEET, "5900x", "ckpt",
                                        "widx*.pts")))
    problems = p_strix + p_c4090 + p_x5900

    # ------------------------------------------------- union coverage map
    union = {}   # xkey -> {k: {src: raw}}
    for src, xk in (("STRIX", s_strix), ("C4090", s_c4090),
                    ("X5900", s_x5900)):
        for xkey, kd in xk.items():
            u = union.setdefault(xkey, {})
            for k, rec in kd.items():
                s, raw, _p = rec
                u.setdefault(k, {})[s] = raw

    # ------------------------------------------- grid from log banners
    # "H1_WINDOWS:  running  windows  A[-B]  (N  of  29)"
    # "resume:  window   N  (x=V)  C/24  points  on disk"
    grid = {}    # xint -> set of claimed global indices
    banner_f = {}  # xint -> [(global, banner_float)]
    slices = {}  # (logfile, instance) -> (A, B, n)
    logs = (sorted(glob.glob(os.path.join(FLEET, "4090-box",
                                          "out_day038_full_?.log")))
            + [os.path.join(FLEET, "5900x", "out_day038_full.log")])
    for lg in logs:
        txt = open(lg).read()
        m = re.search(r"running\s+windows\s+(\d+)(?:-(\d+))?", txt)
        A = int(m.group(1)) if m else None
        for mm in re.finditer(
                r"resume:\s+window\s+(\d+)\s+\(x=([0-9.eE+-]+)\)", txt):
            idx, xfl = int(mm.group(1)), float(mm.group(2))
            if A is not None:
                grid.setdefault(round(xfl), set()).add(A + idx)
                banner_f.setdefault(round(xfl), []).append((A + idx, xfl))
        if "4090-box" in lg:
            inst = os.path.basename(lg).replace(
                "out_day038_full_", "").replace(".log", "")
        else:
            inst = "5900x"
        if m:
            slices[inst] = (A, int(m.group(2) or "0"))

    # --------------------------------- per-point rows in the 4090 logs
    # "  pt win=N k=+M x=... t=... mnew=... mcert=..."
    ptlines = {}  # inst -> {win: set(k)}
    banners = {}  # inst -> final banner text
    for lg in sorted(glob.glob(os.path.join(FLEET, "4090-box",
                                            "out_day038_full_?.log"))):
        inst = os.path.basename(lg).replace("out_day038_full_", "") \
            .replace(".log", "")
        d = ptlines.setdefault(inst, {})
        with open(lg) as f:
            lines = f.readlines()
        for ln in lines:
            pm = re.match(r"\s*pt win=(\d+) k=([+-])(\d+)", ln)
            if pm:
                w = int(pm.group(1))
                kk = int(pm.group(2) + pm.group(3))
                d.setdefault(w, set()).add(kk)
        for ln in lines:
            if "FULL-DONE" in ln or "INCOMPLETE" in ln:
                banners[inst] = " ".join(ln.split())

    # --------------------------------------- cross-source byte agreement
    agree = 0
    disagree = []
    for xkey, kd in sorted(union.items(), key=lambda kv: float(kv[0])):
        for k, sr in sorted(kd.items()):
            if len(sr) < 2:
                continue
            raws = list(sr.values())
            if all(r == raws[0] for r in raws[1:]):
                agree += 1
            else:
                bad_fields = []
                fs = [r.split(",") for r in raws]
                for i in range(21):
                    if len({f[i] for f in fs}) > 1:
                        bad_fields.append(i)
                disagree.append((xkey, k, sorted(sr), bad_fields))

    # ------------------------------------------------- sanity of every row
    rowcount = 0
    mcert_bad = []
    flag_rows = []
    for xkey, kd in union.items():
        for k, sr in kd.items():
            for s, raw in sr.items():
                rowcount += 1
                f_ = raw.split(",")
                if abs(float(f_[1]) - float(xkey)) > 1e-6:
                    problems.append("x field != file key: %s k=%d" % (xkey, k))
                if k not in K_ALL:
                    problems.append("k out of range: %s k=%d" % (xkey, k))
                if float(f_[5]) < 1.0:
                    mcert_bad.append((xkey, k, s, f_[5]))
                if f_[0].strip() == "FLAG":
                    flag_rows.append((xkey, k, s))

    # ------------------------------------------------------------- report
    print("=" * 66)
    print("H1 3e10 FLEET DATA VERIFICATION  (read-only audit)")
    print("=" * 66)
    print("\n--- parse integrity")
    for src, pr, tn in (("STRIX", p_strix, t_strix),
                        ("C4090", p_c4090, t_c4090),
                        ("X5900", p_x5900, t_x5900)):
        print("  %-6s problems=%d torn-tail-lines-dropped=%d"
              % (src, len(pr), tn))
    for p in problems:
        print("   !! " + p)
    print("\n--- grid reconstruction (from log resume banners)")
    xs = sorted(set(x for s in grid.values() for x in s))
    print("  distinct grid x claimed: %d (expect exactly 29)" % len(xs))
    mult = {xint: s for xint, s in grid.items() if len(s) > 1}
    if mult:
        print("  !! x claimed with different indices: %s" % mult)
    else:
        print("  no index disagreement across machines")

    print("\n--- coverage per window (union of STRIX+C4090+X5900-in-hand)")
    complete, partial = [], []
    # map grid (banner) ints to union keys: nearest match, tolerance 10
    # (banner x is %.10g of the true x -> up to ~5 off at 1e10 scale)
    int2key = {}
    for xint, gl in banner_f.items():
        cand = min(union, key=lambda k: abs(float(k) - gl[0][1]),
                   default=None)
        if cand is not None and abs(float(cand) - gl[0][1]) < 10.0:
            int2key[xint] = cand
    for gi in range(29):
        xint = next((xi for xi, s in grid.items() if gi in s), None)
        if xint is None:
            print("  window %2d: X-VALUE NOT SEEN IN ANY LOG (gap in grid "
                  "reconstruction)" % gi)
            continue
        k = int2key.get(xint)
        if k is None:
            print("  window %2d (x=%d): NO ROWS IN HAND" % (gi, xint))
            continue
        kd = union[k]
        miss = sorted(K_ALL - set(kd))
        srcset = sorted({s for sr in kd.values() for s in sr})
        st = "COMPLETE" if not miss else "PARTIAL(%2d)" % len(miss)
        if not miss:
            complete.append(gi)
        else:
            partial.append((gi, miss))
        print("  window %2d (x=%d): %2d/24  %s  src:%s%s"
              % (gi, xint, len(kd), st, "+".join(srcset),
                 ("  missing k=%s" % miss) if miss else ""))

    print("\n--- cross-machine agreement on identical points")
    print("  (x,k) known from 2+ machines: %d, byte-identical: %d, "
          "differing: %d" % (agree + len(disagree), agree, len(disagree)))
    if disagree:
        fm = {4: "mnew", 5: "mcert", 6: "residf", 9: "Bexp",
              10: "Bph", 13: "Btail_re", 14: "Btail_im", 17: "Bqrem"}

        def rel_of(rmap, bf):
            out = {}
            for i in bf:
                vals = [abs(float(r.split(",")[i])) for r in rmap.values()]
                nz = [v for v in vals if v > 0]
                rel = ((max(vals) - min(vals)) / min(nz)) if nz else 0.0
                out[i] = out.get(i, 0.0) if (i in out and out[i] > rel) \
                    else rel
            return out

        relmax = {}
        for xkey, k, sr, bf in disagree:
            for i, rel in rel_of(union[xkey][k], bf).items():
                relmax[i] = max(relmax.get(i, 0.0), rel)
        print("  max RELATIVE diff per field (cross-machine pairs):")
        for i in sorted(relmax):
            print("    f_%2d %-8s rel-diff %.3e" % (i, fm.get(i, "?"),
                                                   relmax[i]))
        xkey, k, sr, bf = max(disagree, key=lambda d: len(d[3]))
        print("  sample pair (most fields differing): x=%s k=%d" % (xkey,
                                                                    k))
        for s, raw in union[xkey][k].items():
            print("    %s: %s" % (s, raw))
        if WITHIN_DUP_DIFF:
            wrel = {}
            for xkey, k, r1, r2, f1, f2 in WITHIN_DUP_DIFF:
                bf = [i for i in range(21)
                      if r1.split(",")[i] != r2.split(",")[i]]
                out = rel_of({"a": r1, "b": r2}, bf)
                for i, rel in out.items():
                    wrel[i] = max(wrel.get(i, 0.0), rel)
            print("  same-box dup pairs, differing rows: %d ; "
                  "max RELATIVE diff per field:" % len(WITHIN_DUP_DIFF))
            for i in sorted(wrel):
                print("    f_%2d %-8s rel-diff %.3e" % (i, fm.get(i, "?"),
                                                       wrel[i]))
            xkey, k, r1, r2, f1, f2 = WITHIN_DUP_DIFF[0]
            print("  sample same-box dup pair: x=%s k=%d (%s vs %s)"
                  % (xkey, k, os.path.basename(f1), os.path.basename(f2)))
            print("    file1: %s" % r1)
            print("    file2: %s" % r2)
    for xkey, k, sr, bf in disagree[:6]:
        print("   !! x=%s k=%d sources=%s differing fields=%s"
              % (xkey, k, sr, bf))

    print("\n--- certified-margin sanity (mcert field, 0-indexed 5)")
    print("  rows checked: %d ; mcert < 1.0: %d ; FLAG rows: %d"
          % (rowcount, len(mcert_bad), len(flag_rows)))
    for r in mcert_bad[:10]:
        print("   !! mcert<1: x=%s k=%d src=%s mcert=%s" % r)
    for r in flag_rows[:10]:
        print("   !! FLAG row: x=%s k=%d src=%s" % r)

    print("\n--- 4090-box instance forensics (from the 8 logs)")
    for inst in sorted(slices):
        A, B = slices[inst]
        b = banners.get(inst, "(no FINAL banner line found)")
        ptw = ptlines.get(inst, {})
        perwin = ("; ".join("w%d:%d/24%s" % (w, len(ks),
                                              (" missing k=%s"
                                               % sorted(K_ALL - ks))
                                              if ks != K_ALL else "")
                           for w, ks in sorted(ptw.items()))
                  if ptw else "no pt lines")
        print("  %s: slice %d-%d | %s | %s"
              % (inst, A, B, b[:100], perwin))
    print("\n--- 5900x snapshot state (ckpt on the drive copy)")
    for xkey, kd in sorted(s_x5900.items()):
        miss = sorted(K_ALL - set(kd))
        print("  x=%s: %2d/24%s" % (xkey, len(kd),
                                    ("  missing k=%s" % miss) if miss
                                    else ""))

    print("\n--- verdict inputs")
    print("  windows COMPLETE in hand: %s" % complete)
    x5900_slice = slices.get("5900x")
    print("  5900x slice (its own run, still in progress locally): %s"
          % (x5900_slice,))
    c4090 = [(A, B) for i, (A, B) in slices.items() if len(i) == 1]
    c4090_span = (min(A for A, _ in c4090),
                  max(B for _, B in c4090)) if c4090 else None
    print("  4090-box slice span across its 8 instances: %s" % (c4090_span,))
    print("  STRIX windows: %d files -> distinct x=%d"
          % (len(glob.glob(os.path.join(CKPT, "widx*.pts"))),
             len(s_strix)))


if __name__ == "__main__":
    main()
