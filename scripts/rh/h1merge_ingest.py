#!/usr/bin/env python3
"""h1merge_ingest — bulletproof fleet-ledger union for the 3e10 H1 fill.

Reads per-window checkpoint files (`widxNN_x{X}.pts`) from ONE OR MANY
machines and produces, per window x, the union of their point rows
deduped by k, materialized into a single ckpt directory as
`widx99_x{X}.pts` files (the widx99 prefix is this tool's namespace;
it never writes any other file).  The engine's cross-slice resume
scan (commit e180eae) unions every widxNN file carrying the same x,
so a final full-grid launch assembles 696/696 from this materialization
with no re-keying and no touch of any pre-existing file.

SAFETY INVARIANTS (the reasons this tool exists):
  * sources are opened READ-ONLY: never renamed, truncated, written;
  * the only files this tool writes are widx99_* files in the
    explicit --target directory; a widx99 file that already exists
    with different content HALTS (owner decides, no silent overwrite);
  * target == any source directory (or nested in/out of it) is
    refused (exit 4);
  * the same (x,k) certified on two machines with DIFFERENT bytes is
    a HALT (exit 2) with a full report — never silently pick one;
  * corruption anywhere but the last line is a HALT (exit 3);
    a torn last line is dropped and reported (that k recomputes);
  * every run prints a manifest (file, k-count, state) so the result
    is checkable after the fact.

Modes:
  selftest
      synthetic end-to-end test of every rule above (no real data)
  census DIR...
      read-only report: per x, k coverage per machine
  ingest SRC_DIR... --target CKPT_DIR [--dry-run]
      union + conflict check + materialize widx99 files
"""
import os
import sys

NPW = 24  # points per window (k in [-12,12], k != 0)


def _k_of_row(f_):
    # f_ = the 21 comma fields; k from t - g (Sterbenz-exact, as the
    # engine's _k_set)
    return round(2.0 * (float(f_[2]) - float(f_[3])))


def parse_pts(path):
    """Parse a .pts checkpoint file.

    Returns (rows, dropped_torn, corrupt):
      rows         list of (k, raw_line) for complete ok,/FLAG, rows
      dropped_torn 1 if the final line was incomplete (dropped) else 0
      corrupt      (line_no, reason) on non-tail corruption, else None
    The last nonempty line is the only torn-tail-tolerated line,
    matching the engine's _parse_wk_file_path semantics.  audit,
    rows are skipped (attached metadata, not merged)."""
    rows, dropped, corrupt = [], 0, None
    nonempty = [ln for ln in open(path).read().split("\n") if ln]
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
            else:
                corrupt = (idx + 1,
                           "field count %d != 21 (non-tail)" % len(f_))
                break
            continue
        try:
            k = _k_of_row(f_)
        except (ValueError, IndexError):
            if idx == len(nonempty) - 1:
                dropped = 1
                continue
            corrupt = (idx + 1, "unparseable t/g fields")
            break
        rows.append((k, ln))
    return rows, dropped, corrupt


def iter_pts_files(d):
    for fn in sorted(os.listdir(d)):
        if fn.startswith("widx") and fn.endswith(".pts") and "_x" in fn:
            yield os.path.join(d, fn)


def load_all(d):
    """dir -> {x: {k: [(raw_line, machine_dir, filename), ...]}}"""
    per = {}
    for p in iter_pts_files(d):
        rows, dropped, corrupt = parse_pts(p)
        if corrupt:
            sys.stderr.write(
                "CORRUPT %s line %d: %s -- HALT (never guess)\n"
                % (p, corrupt[0], corrupt[1]))
            sys.exit(3)
        if dropped:
            sys.stderr.write(
                "note: dropped torn-tail line in %s (recomputes)\n" % p)
            continue
        # x from the filename (same %.10g format as the writer)
        base = os.path.basename(p)
        x = float(base.split("_x", 1)[1][:-4])
        for k, raw in rows:
            per.setdefault(x, {}).setdefault(k, []).append(
                (raw, d, os.path.basename(p)))
    return per


def union_dirs(dirs):
    """dirs -> (x -> {k: raw_line}, conflicts, provenance)"""
    xkraw, conflicts, prov = {}, [], {}
    for d in dirs:
        per = load_all(d)
        for x, km in per.items():
            uk = xkraw.setdefault(x, {})
            for k, entries in km.items():
                if k in uk:
                    base = uk[k]
                    for raw, _md, fn in entries:
                        if raw.rstrip("\n") != base.rstrip("\n"):
                            conflicts.append((x, k, base, raw, fn))
                    prov.setdefault((x, k), []).append(entries[0][2])
                else:
                    uk[k] = entries[0][0]
                    prov.setdefault((x, k), []).append(entries[0][2])
    return xkraw, conflicts, prov


def xname(x):
    return "%.10g" % x


def run_ingest(srcs, target, dry):
    src_abs = {os.path.abspath(s) for s in srcs}
    t_abs = os.path.abspath(target)
    for s in src_abs:
        if (t_abs == s or t_abs.startswith(s + os.sep)
                or s.startswith(t_abs + os.sep)):
            sys.stderr.write(
                "refuse: target %s overlaps source %s\n" % (target, s))
            sys.exit(4)
    xkraw, conflicts, prov = union_dirs(srcs)
    if conflicts:
        sys.stderr.write(
            "\nCONFLICTS: same (x,k) certified differently\n")
        for x, k, a, b, fn in conflicts:
            sys.stderr.write("  x=%s k=%+d\n    A: %s\n    B: %s (%s)\n"
                             % (xname(x), k, a, b, fn))
        sys.stderr.write(
            "HALT: two machines certified the same point differently.\n"
            "Do NOT merge; investigate code versions / band files\n"
            "before any retry.\n")
        sys.exit(2)
    manifest = []
    for x in sorted(xkraw):
        km = xkraw[x]
        name = "widx99_x%s.pts" % xname(x)
        path = os.path.join(target, name)
        payload = "".join(
            km[k].rstrip("\n") + "\n" for k in sorted(km))
        existing = None
        if os.path.exists(path):
            existing = open(path).read()
        if existing == payload:
            manifest.append((name, len(km), "identical (no write)"))
            continue
        if existing is not None:
            sys.stderr.write(
                "HALT: %s exists with DIFFERENT content (prior run).\n"
                "Owner decides (inspect, then delete it) -- never\n"
                "overwrite silently.\n" % name)
            sys.exit(5)
        if not dry:
            with open(path, "w") as f:
                f.write(payload)
                f.flush()
                os.fsync(f.fileno())
        manifest.append((name, len(km), "dry" if dry else "written"))
    print("h1merge_ingest manifest%s:" % (" (dry-run)" if dry else ""))
    for name, cnt, st in manifest:
        print("  %-28s %2d/24  %s" % (name, cnt, st))
    full = sum(1 for _, c, _ in manifest if c == NPW)
    print("windows at 24/24: %d / %d" % (full, len(manifest)))
    if full < len(manifest):
        print("NOTE: some windows are incomplete in the union; the\n"
              "engine's resume banner names them on the final launch.")


def run_census(dirs):
    for d in dirs:
        per = load_all(d)
        tot = 0
        print("== %s" % d)
        for x in sorted(per):
            ks = sorted(per[x])
            tot += len(ks)
            print("  x=%s  %2d/24  k=%+d..%+d"
                  % (xname(x), len(ks), ks[0], ks[-1]))
        print("  total points: %d" % tot)


def selftest():
    import tempfile
    d = tempfile.mkdtemp()
    A, B, T = [os.path.join(d, s) for s in ("A", "B", "target")]
    for s in (A, B, T):
        os.makedirs(s)

    def row(x, k, extra=""):
        t = x + k / 2.0
        g = x
        return ("ok,%r,%r,%r,1.0,1.0,1e-05,1.0,1e-06,1e-06,1e-06,1e-06,"
                "1e-06,1e-06,1e-06,1e-06,1e-06,1e-06,1e-06,7,%s%d"
                % (x, t, g, extra, abs(k)))

    XA, XB, XC = 1.0e9, 2.0e9, 3.0e9
    # A: x=XA k=-12..-1 ; B: x=XA k=1..12  -> union 24
    ra = "".join(row(XA, k) + "\n" for k in range(-12, 0))
    rb = "".join(row(XA, k) + "\n" for k in range(1, 13))
    open(A + "/widx00_x%.10g.pts" % XA, "w").write(ra)
    open(B + "/widx00_x%.10g.pts" % XA, "w").write(rb)
    # x=XB: same k on both machines, IDENTICAL rows -> dedup, no conflict
    r1 = row(XB, 5)
    open(A + "/widx01_x%.10g.pts" % XB, "w").write(r1 + "\n")
    open(B + "/widx01_x%.10g.pts" % XB, "w").write(r1 + "\n")
    # x=XC: same k on both machines, DIFFERENT rows -> conflict
    open(A + "/widx02_x%.10g.pts" % XC, "w").write(row(XC, 7) + "\n")
    open(B + "/widx02_x%.10g.pts" % XC,
         "w").write(row(XC, 7, "DIFF") + "\n")

    ok = True
    # 1: union of A,B flags exactly one conflict (x=XC)
    xk, conf, _prov = union_dirs([A, B])
    ok &= (len(conf) == 1 and xname(conf[0][0]) == xname(XC))
    # 2: union of just A -> no conflicts, x=XA has 12 k
    xk2, conf2, _p2 = union_dirs([A])
    ok &= (not conf2 and len(xk2[XA]) == 12)
    # 3: A (k=-12..-1) + C (k=1..12 at XA) -> clean union 24 at XA
    C = os.path.join(d, "C")
    os.makedirs(C)
    open(C + "/widx00_x%.10g.pts" % XA, "w").write(rb)
    xk3, conf3, _p3 = union_dirs([A, C])
    ok &= (not conf3 and len(xk3[XA]) == 24)
    # 4: materialization writes only widx99 files (exactly the 3 union
    #     windows); the XA file has 24 rows
    run_ingest([A, C], T, dry=False)
    tfiles = sorted(os.listdir(T))
    ok &= (tfiles == ["widx99_x%.10g.pts" % w for w in (XA, XB, XC)]
           and len(open(T + "/widx99_x%.10g.pts" % XA).read()
                   .splitlines()) == 24)
    # 5: idempotent re-run (identical content) succeeds
    run_ingest([A, C], T, dry=False)
    # 6: target == source refused (exit 4)
    try:
        run_ingest([T], T, dry=True)
        ok = False
    except SystemExit as e:
        ok &= (e.code == 4)
    # 7: corruption mid-file is reported by the parser...
    D = os.path.join(d, "D")
    os.makedirs(D)
    good = row(XA, 1)
    open(D + "/widx05_x%.10g.pts" % XA,
         "w").write(good + "\nok,BROKEN\n" + good + "\n")
    _r, _dr, corr = parse_pts(D + "/widx05_x%.10g.pts" % XA)
    ok &= (corr is not None)
    # ...and load_all HALTS with exit 3 on the same file
    try:
        load_all(D)
        ok = False
    except SystemExit as e:
        ok &= (e.code == 3)
    # 8: torn tail is dropped, not a corruption
    open(D + "/widx06_x%.10g.pts" % XA,
         "w").write(good + "\nok,1.0,2.0,")
    r2, dr2, corr2 = parse_pts(D + "/widx06_x%.10g.pts" % XA)
    ok &= (corr2 is None and dr2 == 1 and len(r2) == 1)
    # 9: a pre-existing widx99 file with DIFFERENT content halts (5)
    open(T + "/widx99_x%.10g.pts" % XA,
         "w").write("ok,9,9,9,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1\n")
    try:
        run_ingest([A, C], T, dry=False)
        ok = False
    except SystemExit as e:
        ok &= (e.code == 5)
    print("selftest:", "PASS" if ok else "FAIL")
    sys.exit(0 if ok else 1)


def main():
    if len(sys.argv) < 2:
        sys.stderr.write(__doc__)
        sys.exit(1)
    mode = sys.argv[1]
    if mode == "selftest":
        selftest()
    elif mode == "census":
        run_census(sys.argv[2:])
    elif mode == "ingest":
        rest = sys.argv[2:]
        dry = "--dry-run" in rest
        rest = [a for a in rest if a != "--dry-run"]
        if "--target" not in rest:
            sys.stderr.write("ingest needs --target CKPT_DIR\n")
            sys.exit(1)
        i = rest.index("--target")
        run_ingest(rest[:i], rest[i + 1], dry)
    else:
        sys.stderr.write("unknown mode %s\n" % mode)
        sys.exit(1)


if __name__ == "__main__":
    main()
