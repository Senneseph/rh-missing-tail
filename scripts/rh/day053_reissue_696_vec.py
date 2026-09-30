"""day053: full-696 re-issue of the 3e10 H1 ledger -- vector
multi-t sweep.  STATUS (2026-09-30):  DEAD END,  kept for the
verified slab oracle and provenance.

Why dead:  (1) memory infeasible --  one slab is SUB = 2^25
elements,  so the (24, SUB) per-slab arrays are ~6.4 GB each
before temporaries,  and the 24 x day049f-style chunk
streams would need ~38 GB per worker (the day049f stream
passed ONE t's 99-million-chunk 80-bit arrays per point);
(2) no win even if it fit --  the per-point cost is the
813 GB band read (one full (1e7, G_LAST] file per point,
I/O-dominated at the ~70 min measured 14-way pace),  so
sharing one read across 24 t's cannot beat the I/O floor
and the 24x element compute exceeds the saved time.
The honest 696 re-issue is sequential per-point sweeps:
day052b (2-3 days wall at 14 of 16 cores).

Why:  one band sweep (the (1e7, G_LAST] tail,  ~70 min at 14-way
concurrency,  the measured cost of the day049f stream pass) is
dominated by the Python slab loop + one read of the band;  the
per-element math is only ~1/20 of that.  All 24 straddle t's of
a window (t = g + k/2,  k = -12..-1, +1..+12) differ by < 12
against a 1e10-magnitude tail,  so ONE sweep can serve all 24:
per slab we form the (24, m) arrays of the per-zeta-zero
contributions and accumulate,  for EVERY t,  exactly the chain
of operations the sequential engine performs
(   per-slab:  float of np.sum of the contiguous (m,) row
    (the engine's bit-exact pairwise f64 sum),
    budget terms with the same ld-sums,
    per-slab:  longdouble accumulator chain across slabs,
    same slab order,  same count_below per t).
Per-t bit-exactness argument:  every element of row j is
produced by the SAME elementwise numpy ops on the SAME input
arrays as the engine's (m,) array (shape does not change
per-element ufunc results);  every row is a CONTIGUOUS (m,)
view (we build (24, m) C-order,  not (m, 24)),  so the per-row
np.sum / ld chunk sums / fsum tail run the identical
reduction.  Verification before trust:
  (a) per-slab unit oracle:  first 40 slabs x 3 t's,  the
      vector slab contribution must equal
      D37.slab_budget(...) bit-for-bit (sub_re, sub_im, B_re,
      B_im, s_abs_re, dmin);
  (b) the 24 day049f points (7 of the 29 windows already
      have verified high-precision reference values):  the
      vector engine f64 re/im must equal the day049f
      stream.eng re/im bit-for-bit;  the vector 80-bit
      stream must agree with day049f stream.ld to stored
      precision;  margins must agree at the expected
      f64-tail level (~1e-7).
If (a) and (b) hold,  the 696 vector rows are as good as the
sequential engine's rows (which the forensics pass
established as the clean reference assembly).

Outputs (own dir,  never touches the artifact files):
  out_day053_696/led696_vec_3e10.pts      fleet 21-column
                                          rows via D37._point_row
  out_day053_696/windows.jsonl            per-window resume
                                          checkpoint (appended
                                          BEFORE the .pts view)
  out_day053_696/pt_*.json                per-point extras
                                          (streams + dps-120
                                          ld-exact margin)

Launch:  taskset -c 0-13 env OMP_NUM_THREADS=1 nohup
  python3 day053_reissue_696_vec.py > out_day053_696.log 2>&1 &
"""
import json
import math
import os
import sys
import time

import numpy as np

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
import h1merge_ingest as M           # noqa: E402
import day037_h1_3e10 as D37         # noqa: E402  (fixed engine)

OUTDIR = HERE + "/out_day053_696"
os.makedirs(OUTDIR, exist_ok=True)
JSONL = OUTDIR + "/windows.jsonl"
PTS = OUTDIR + "/led696_vec_3e10.pts"
WORKERS = min(int(os.environ.get("WORKERS", "14")), 14)
CH = 1024                            # day049f 80-bit chunk size
KLIST = [k for k in range(-12, 13) if k != 0]


def _T():
    return D37.Tail3E10(verbose=False)


# ----------------------------------------------------------------------
# (a) per-slab unit oracle:  vector slab == D37.slab_budget bit-exact
# ----------------------------------------------------------------------
def vector_slab(c, tfs64, i, extra_idx):
    """One slab,  all t's.  Returns per-t rows (arrays of len 24):
    sub_re, sub_im, B_re, B_im, s_abs_re, dmin  -- each row must
    equal D37.slab_budget(c, tf, tf*tf, m, i, extra_idx)
    element-for-element for that tf."""
    m = c.size
    nt = tfs64.size
    t2 = np.array([tf * tf for tf in tfs64], dtype=np.float64)
    g2 = c * c
    A = g2 + 0.25
    GT2 = g2[None, :] - t2[:, None]              # (nt, m)
    AB = np.abs(GT2)
    RE = np.log(AB) - np.log(A)[None, :] + (0.5 / A)[None, :]
    IM = tfs64[:, None] / A[None, :]
    U64 = D37.U64
    k = int(math.ceil(math.log2(m))) if m > 1 else 0
    sub_re = np.empty(nt)
    sub_im = np.empty(nt)
    B_re = np.empty(nt)
    B_im = np.empty(nt)
    s_abs_re = np.empty(nt)
    dmin = np.empty(nt)
    dg = U64 * np.abs(c)
    invA = 1.0 / A
    dredg = (2.0 * c[None, :] / np.maximum(AB, 1e-30)
             + 2.0 * c[None, :] * invA[None, :]
             + c[None, :] * invA[None, :] ** 2)
    dimdg = (tfs64[:, None] * 2.0 * c[None, :] * invA[None, :] ** 2)
    ABS_RE = np.abs(RE)   # the integrand's absolute value (NOT |g2-t2|)
    SSCALE = np.maximum(ABS_RE, (0.5 / A)[None, :])
    for j in range(nt):
        row = RE[j]                       # contiguous (m,)
        sub_re[j] = float(np.sum(row))    # the engine's exact sum
        sub_im[j] = float(np.sum(IM[j]))
        s_ar = float(np.abs(row).astype(np.longdouble).sum())
        s_sc = float(SSCALE[j].astype(np.longdouble).sum())
        s_ai = float(IM[j].astype(np.longdouble).sum())
        dgr = float((dg[None, :] * dredg[j]).astype(np.longdouble).sum())
        dimr = float((dg[None, :] * dimdg[j]).astype(np.longdouble).sum())
        B_re[j] = (D37.GAM10_64 * s_sc + k * 2.0 * U64 * s_ar + dgr)
        B_im[j] = (D37.GAM1_64 * s_ai + k * 2.0 * U64 * s_ai + dimr)
        if extra_idx is not None and extra_idx.size:
            lo_ = int(np.searchsorted(extra_idx, i, side="left"))
            hi_ = int(np.searchsorted(extra_idx, i + m, side="right"))
            if hi_ > lo_:
                loc = extra_idx[lo_:hi_] - i
                B_re[j] += 2.0 * float((dg[loc] * dredg[j, loc])
                                       .astype(np.longdouble).sum())
                B_im[j] += 2.0 * float((dg[loc] * dimdg[j, loc])
                                       .astype(np.longdouble).sum())
        s_abs_re[j] = s_ar
        dmin[j] = float(np.min(np.abs(c - tfs64[j])))
    return {"sub_re": sub_re, "sub_im": sub_im, "B_re": B_re,
            "B_im": B_im, "s_abs_re": s_abs_re, "dmin": dmin,
            "RE": RE, "IM": IM, "AB": AB}


def unit_oracle(T, tfs64, nslab=40):
    """Compare vector_slab against D37.slab_budget on the first
    nslab slabs for each tf.  Any mismatch is a hard failure."""
    T.restart()
    n = T.n_tail
    SUB = D37.SUB
    i = 0
    checked = 0
    for js in range(nslab):
        m = min(SUB, n - i)
        c = T.read_slab(m)
        vs = vector_slab(c, tfs64, i, getattr(T, "extra_idx", None))
        for j, tf in enumerate(tfs64):
            (sr, si, br, bi, s_ar, dm) = D37.slab_budget(
                c, tf, tf * tf, m, i, getattr(T, "extra_idx", None))
            for name, a, b in (
                    ("sub_re", vs["sub_re"][j], sr),
                    ("sub_im", vs["sub_im"][j], si),
                    ("B_re", vs["B_re"][j], br),
                    ("B_im", vs["B_im"][j], bi),
                    ("s_abs_re", vs["s_abs_re"][j], s_ar),
                    ("dmin", vs["dmin"][j], dm)):
                if a != b:
                    raise AssertionError(
                        "SLAB ORACLE MISMATCH slab=%d t=%.6f %s: "
                        "vector=%.17g engine=%.17g"
                        % (js, tf, name, a, b))
            checked += 1
        i += m
        del c
    print("SLAB ORACLE: %d (slab, t) pairs bit-exact (40 slabs x %d t)"
          % (checked, len(tfs64)), flush=True)
    return True


# ----------------------------------------------------------------------
# vector window tail:  all 24 t's,  engine f64 chain + 80-bit stream
# ----------------------------------------------------------------------
def window_tail(T, g):
    """One band sweep serving all 24 straddles of window g.
    Returns (engine, ldstream):  per-k dicts.
      engine[k] = {re, im, nlt, B_re, B_im, dmin}  -- the values
          tail_with_budget(T, tf) would return,  accumulated with
          the engine's exact chain per t;
      ldstream[k] = {re19, im19, nlt}  -- the day049f 80-bit
          chunked-exact stream,  per t."""
    tfs64 = np.array([g + k / 2.0 for k in KLIST], dtype=np.float64)
    T.restart()
    n = T.n_tail
    SUB = D37.SUB
    nchunk = (n + CH - 1) // CH
    U64 = D37.U64
    re_ld = {k: np.longdouble(0) for k in KLIST}
    im_ld = {k: np.longdouble(0) for k in KLIST}
    B_re = {k: 0.0 for k in KLIST}
    B_im = {k: 0.0 for k in KLIST}
    sa = {k: np.longdouble(0) for k in KLIST}
    dmin = {k: float("inf") for k in KLIST}
    ck_re = {k: np.empty(nchunk, dtype=np.longdouble) for k in KLIST}
    ck_im = {k: np.empty(nchunk, dtype=np.longdouble) for k in KLIST}
    ci = {k: 0 for k in KLIST}
    i = 0
    nsub = 0
    t0 = time.time()
    while i < n:
        m = min(SUB, n - i)
        c = T.read_slab(m)
        vs = vector_slab(c, tfs64, i, getattr(T, "extra_idx", None))
        RE = vs["RE"]
        IM = vs["IM"]
        for jj, k in enumerate(KLIST):
            sub_re_j = float(np.sum(RE[jj]))
            sub_im_j = float(np.sum(IM[jj]))
            re_ld[k] += np.longdouble(sub_re_j)
            im_ld[k] += np.longdouble(sub_im_j)
            B_re[k] += vs["B_re"][jj]
            B_im[k] += vs["B_im"][jj]
            sa[k] += np.longdouble(vs["s_abs_re"][jj])
            dm = vs["dmin"][jj]
            if dm < dmin[k]:
                dmin[k] = dm
            # day049f 80-bit chunked stream (contiguous (m,) rows)
            full = (m // CH) * CH
            row_r = RE[jj]
            row_i = IM[jj]
            if full:
                ck_re[k][ci[k]:ci[k] + full // CH] = (
                    row_r[:full].reshape(full // CH, CH).sum(
                        axis=1, dtype=np.longdouble))
                ck_im[k][ci[k]:ci[k] + full // CH] = (
                    row_i[:full].reshape(full // CH, CH).sum(
                        axis=1, dtype=np.longdouble))
                ci[k] += full // CH
            if m > full:
                ck_re[k][ci[k]] = math.fsum(row_r[full:].tolist())
                ck_im[k][ci[k]] = math.fsum(row_i[full:].tolist())
                ci[k] += 1
        del c, vs, RE, IM
        nsub += 1
        i += m
        if nsub % 500 == 0:
            print("  ...window g=%.6g tail sweep %.0f%% (%d pieces)"
                  % (g, 100.0 * i / n, nsub), flush=True)
    U128 = D37.U128
    engine = {}
    ldstream = {}
    for k in KLIST:
        tf = float(g + k / 2.0)
        nlt = T.count_below(tf)
        re_f = float(re_ld[k])
        # the engine's exact form: im_ld + (nlt * np.pi) with the
        # product in f64 (int * float64), then promoted to 80-bit
        im_f = float(im_ld[k] + float(nlt * np.pi))
        Bre = float(B_re[k] + nsub * 2.0 * U128 * float(sa[k]))
        Bim = float(B_im[k] + nsub * 2.0 * U128 * float(sa[k])
                    + 12.0 * U64 * abs(im_f))
        engine[k] = {"re": re_f, "im": im_f, "nlt": int(nlt),
                     "B_re": Bre, "B_im": Bim, "dmin": dmin[k]}
        assert ci[k] == nchunk, "chunk count mismatch k=%+d" % k

        def tree(a):
            a = a.astype(np.longdouble, copy=False)
            while a.size > 1:
                if a.size % 2:
                    a = np.concatenate([a[:-1].reshape(-1, 2).sum(
                        axis=1, dtype=np.longdouble), a[-1:]])
                else:
                    a = a.reshape(-1, 2).sum(axis=1,
                                             dtype=np.longdouble)
            return a.item()
        ld_re = tree(ck_re[k])
        ld_im = tree(ck_im[k])
        ldstream[k] = {"re19": format(float(ld_re), ".16f"),
                       "im19": format(float(ld_im), ".16f"),
                       "nlt": int(nlt)}
    elapsed = time.time() - t0
    print("  window g=%.6g: 24-t vector sweep done in %.1f min"
          % (g, elapsed / 60.0), flush=True)
    return engine, ldstream, tfs64


# ----------------------------------------------------------------------
# per-t mpmath + margins (the cert_point arithmetic,  verbatim)
# ----------------------------------------------------------------------
def _ev(tf, g, dps, qrem, qext, re, im, la, ar):
    return D37.ev_point(tf, g, dps, qrem, qext, re, im, la, ar)


def point_row(T, g, x, k, eng, fc120, ldrow, prod):
    tf = float(g + k / 2.0)
    re, im, nlt = eng["re"], eng["im"], eng["nlt"]
    (la, ar, B_la, B_ar, dmin_g) = prod
    audit = (k == -12)
    (qrem30, qext30, qrem60, qext60, B_qrem, B_qext, aud) = \
        D37.quad_pair(T, tf, audit)
    p30 = _ev(tf, g, 30, qrem30, qext30, re, im, la, ar)
    p60 = _ev(tf, g, 60, qrem60, qext60, re, im, la, ar)
    dev30 = D37.dev_parts(tf, g, 30)
    dev60 = D37.dev_parts(tf, g, 60)
    B_dev = float(abs(dev30 - dev60))
    B_lm = float(abs(p30["lm"] - p60["lm"]))
    B_z = float(abs(p30["z"] - p60["z"]))
    dmin = min(eng["dmin"], dmin_g)
    L = abs(p30["Kfull"])
    zabs30 = float(p30["zabs"])
    bad_asm = (L < 0.05 * zabs30) or (L > 50.0 * zabs30)
    flag = (dmin < D37.NLT_GUARD) or bad_asm
    Bexp = (eng["B_re"] + B_la
            + float(abs(D37.mp.re(B_qrem) + D37.mp.re(B_qext))) + B_lm)
    Bph = (eng["B_im"] + B_ar
           + float(abs(D37.mp.im(B_qrem) + D37.mp.im(B_qext))))
    env = math.exp(Bexp)
    dK = L * (env - 1.0 + env * Bph)
    pb = float(D37.M.p8_B(D37.mp.mpf(repr(tf)), D37.n4(tf)))
    residf30 = float(p30["residf"])
    mnew = zabs30 * float(dev30) / (pb + residf30)
    residf_cert = residf30 + dK + B_z
    dev_cert = max(0.0, float(dev30) - B_dev)
    z_cert = max(0.0, zabs30 - B_z)
    mcert = z_cert * dev_cert / (pb + residf_cert)
    Efull = float(D37.mp.log(abs(p30["z"]))
                  - D37.mp.re(D37.mp.log(p30["Kfull"])))
    p = {"t": tf, "g": g, "mnew": mnew, "mcert": mcert,
         "residf": residf30, "zeta": zabs30, "dev": float(dev30),
         "Efull": Efull, "Bexp": Bexp, "Bph": Bph, "Bz": B_z,
         "Bdev": B_dev, "Btail_re": eng["B_re"], "Btail_im": eng["B_im"],
         "Bprod_re": B_la, "Bprod_im": B_ar,
         "Bqrem": float(abs(B_qrem)), "Bqext": float(abs(B_qext)),
         "dmin": dmin, "nlt": nlt, "flag": flag, "audit": aud}
    # dps-120 ld-exact margin (the day048/049f verification layer);
    # computed only when a fast_core_120 is supplied  --  the
    # remaining 696 points get it in the band-free second pass
    # (day053c) from the stored 80-bit streams
    m120 = day050_margin_120(fc120, ldrow) if fc120 is not None else None
    return p, m120


def day050_margin_120(fc120, ldrow):
    mp = D37.mp
    mp.dps = 120
    # day048/049f m2 convention:  the 80-bit stream +  nlt*pi  with
    # the nlt*pi product in f64 (int * math.pi),  exact binary mpf
    Kfull = mp.e ** (fc120["lm"] + mp.mpf(repr(fc120["la"]))
                     + 1j * mp.mpf(repr(fc120["ar"]))
                     + mp.mpf(ldrow["re19"])
                     + 1j * (mp.mpf(ldrow["im19"])
                             + mp.mpf(repr(int(ldrow["nlt"])
                                           * math.pi))))
    Kfull = Kfull * mp.e ** fc120["qrem"]
    Kfull = Kfull * mp.e ** fc120["qext"]
    residf = abs(fc120["z"] - Kfull)
    zabs = abs(fc120["z"])
    pb = float(D37.M.p8_B(mp.mpf(repr(fc120["t"])),
                          D37.n4(fc120["t"])))
    mnew = float(zabs * fc120["dev"]) / (pb + float(residf))
    return {"mnew": mnew, "residf": float(residf), "zabs": float(zabs),
            "Kfull_abs": float(abs(Kfull))}


def fast_core_120(T, tf, g):
    from mpmath import mp
    mp.dps = 120
    s = mp.mpc(0.5, mp.mpf(repr(tf)))
    z = mp.zeta(s)
    lm = D37.logmain25212(s)
    qrem = D37.quad_section(D37._kint(s), repr(T.G_LAST),
                            D37.REMHI, 400, 120)
    qext = D37.quad_section(D37._kint(s), D37.REMHI, D37.REMHI2,
                            400, 120)
    dev = D37.dev_parts(tf, g, 120)
    (la, ar, _b1, _b2, _dm) = D37.prod_with_budget(tf)
    return {"z": z, "lm": lm, "qrem": qrem, "qext": qext,
            "dev": dev, "la": la, "ar": ar, "t": tf}


# ----------------------------------------------------------------------
# day049f reference loading + in-run verification
# ----------------------------------------------------------------------
def load_refs():
    """The 24 verified day049f points,  keyed by window anchor."""
    refs = {}
    import glob as _g
    for f in sorted(_g.glob(HERE + "/out_day049f_pts/pt*.res")):
        d = json.load(open(f))
        p = d["point"]
        st = d["stream"]
        m120 = (d.get("dps120_ldexact")
                or d.get("dps120_ldexact_reim"))
        wx = round(p["x"], 3)
        eng = st.get("engine_real")   # only the two verify points
        refs.setdefault(wx, {})[int(p["k"])] = {
            "t": p["t"],
            "eng_re": eng["re"] if eng else None,
            "eng_im": eng["im"] if eng else None,
            "eng_nlt": eng["nlt"] if eng else None,
            "ld_re": st["ld"]["re"], "ld_im": st["ld"]["im"],
            "m120": m120["mnew"]}
    return refs


def check_window(w, refs_for_win):
    """Compare this window's vector values against the verified
    day049f records for its points.  Returns  {k: {...checks}}."""
    out = {}
    for k, r in refs_for_win.items():
        e = w["eng_cache"][k]
        ld = w["ld_cache"][k]
        m120 = w["m120_cache"][k]
        d_re = e["re"] - r["eng_re"] if r["eng_re"] is not None else 0.0
        d_im = e["im"] - r["eng_im"] if r["eng_im"] is not None else 0.0
        eng_bit = None
        if r["eng_re"] is not None:
            eng_bit = (e["re"] == r["eng_re"]
                       and e["im"] == r["eng_im"]
                       and e["nlt"] == r["eng_nlt"])
        c = {
            "eng_bit_exact": eng_bit,   # None = no reference stored
            "d_re": d_re, "d_im": d_im,
            "ld_ok": (abs(float(ld["re19"]) - float(r["ld_re"]))
                      <= 1e-15
                      and abs(float(ld["im19"]) - float(r["ld_im"]))
                      <= 1e-15),
            "m120_ok": abs(m120 - r["m120"]) <= 1e-9,
            "d_m120": m120 - r["m120"],
        }
        out[str(k)] = c
        if not (c["eng_bit_exact"] in (True, None)
                and c["ld_ok"] and c["m120_ok"]):
            print("VERIFY FAIL window x=%.6g k=%+d: %s"
                  % (w["x"], k, c), flush=True)
    return out


# ----------------------------------------------------------------------
# window worker (module-level for pickling)
# ----------------------------------------------------------------------
_TG = None


def _wT():
    global _TG
    if _TG is None:
        _TG = D37.Tail3E10(verbose=False)
    return _TG


def worker_window(x, refs_for_win=None):
    T = _wT()
    g = D37.nearest_zero(T, x)
    t0 = time.time()
    engine, ldstream, _ = window_tail(T, g)
    pts = []
    extras = {}
    for k in KLIST:
        tf = float(g + k / 2.0)
        prod = D37.prod_with_budget(tf)
        # the dps-120 layer only for the verification points;  the
        # rest get it band-free in day053c from the stored streams
        need120 = refs_for_win is not None and int(k) in refs_for_win
        fc120 = fast_core_120(T, tf, g) if need120 else None
        p, m120 = point_row(T, g, x, k, engine[k], fc120, ldstream[k],
                            prod)
        pts.append(p)
        extras[str(k)] = {
            "m120_ld": m120,
            "eng": {"re": engine[k]["re"], "im": engine[k]["im"],
                    "nlt": engine[k]["nlt"]},
            "ld": ldstream[k],
        }
        m120_str = ("%.6f" % m120["mnew"]) if m120 else "-"
        print("  pt x=%.4g t=%.5f mnew=%.6f mcert=%.6f bexp=%.2e m120=%s"
              % (x, p["t"], p["mnew"], p["mcert"], p["Bexp"], m120_str),
              flush=True)
    w = {"x": x, "g": g, "pts": pts, "extras": extras,
         "wall_min": (time.time() - t0) / 60.0}
    if refs_for_win:
        w["verify"] = check_window(
            {"x": x, "eng_cache": {k: engine[k] for k in refs_for_win},
             "ld_cache": {k: ldstream[k] for k in refs_for_win},
             "m120_cache": {k: extras[str(k)]["m120_ld"]["mnew"]
                            for k in refs_for_win}},
            refs_for_win)
    return w


def load_done():
    done = {}
    if os.path.exists(JSONL):
        with open(JSONL) as fh:
            for ln in fh:
                w = json.loads(ln)
                done[float(w["x"])] = w
    return done


def main():
    import concurrent.futures as cf
    ok_oracle = os.environ.get("H1V3_ORACLE") != "0"
    T = D37.Tail3E10(verbose=False)
    if ok_oracle:
        # three t's straddling the band (low / mid / high)
        gs = D37.nearest_zero(T, 4.0e9)
        st0 = time.time()
        Vgs = gs
        unit_oracle(T, np.array([Vgs - 3.0, Vgs, Vgs + 3.0]))
        print("oracle %.1f s" % (time.time() - st0), flush=True)
    refs = load_refs() if os.environ.get("H1V3_VERIFY") != "0" \
        else {}
    xs = D37.grid()
    done = load_done()
    pending = [x for x in xs if x not in done]
    # gate order:  windows with verified day049f refs go FIRST;  the
    # remaining windows are submitted only after every check passes
    verify_x = [x for x in pending
                if round(x, 3) in refs and round(x, 3) not in done]
    rest_x = [x for x in pending if x not in verify_x]
    print("day053: %d windows, %d points, workers=%d, pending=%d, "
          "verify-first=%d" % (len(xs), len(xs) * 24, WORKERS,
                               len(pending), len(verify_x)), flush=True)
    fo = open(PTS, "a")
    fo.write("# day053 vector re-issue 696 %s workers=%d %s\n"
             % ("RESUME" if done else "FRESH", WORKERS,
                time.strftime("%Y-%m-%d %H:%M:%S")))
    fo.flush()
    t0 = time.time()
    new = []
    gate = True
    if pending:
        with cf.ProcessPoolExecutor(max_workers=WORKERS) as ex:
            if verify_x:
                vrefs = {x: refs[round(x, 3)] for x in verify_x}
                futs = {ex.submit(worker_window, x, vrefs[x]): x
                        for x in verify_x}
                for fu in cf.as_completed(futs):
                    w = fu.result()
                    okw = all(
                        c["eng_bit_exact"] in (True, None)
                        and c["ld_ok"] and c["m120_ok"]
                        for c in w.get("verify", {}).values())
                    if not okw:
                        gate = False
                    with open(JSONL, "a") as jf:
                        jf.write(json.dumps(w) + "\n")
                    for p in w["pts"]:
                        fo.write(D37._point_row(w["x"], p))
                    fo.flush()
                    print("WINDOW x=%.6g VERIFY-GATE %s (%.1f min)"
                          % (w["x"], "PASS" if okw else "FAIL",
                             w["wall_min"]), flush=True)
                    new.append(w)
            if not gate:
                print("VERIFY GATE FAILED -- not submitting the "
                      "remaining %d windows" % len(rest_x), flush=True)
                fo.close()
                sys.exit(1)
            if rest_x:
                futs = {ex.submit(worker_window, x, None): x
                        for x in rest_x}
                for fu in cf.as_completed(futs):
                    w = fu.result()
                    with open(JSONL, "a") as jf:
                        jf.write(json.dumps(w) + "\n")
                    for p in w["pts"]:
                        fo.write(D37._point_row(w["x"], p))
                    fo.flush()
                    print("WINDOW x=%.6g done (%.1f min)"
                          % (w["x"], w["wall_min"]), flush=True)
                    new.append(w)
    fo.close()
    allw = [done[float(x)] for x in xs if float(x) in done] + new
    allw.sort(key=lambda r: r["x"])
    npts = sum(len(w["pts"]) for w in allw)
    dt = time.time() - t0
    print("== day053 re-issue: %d windows / %d points, wall %.1f s =="
          % (len(allw), npts, dt), flush=True)
    D37._summary(allw, dt, "REISSUE-696-VEC")


if __name__ == "__main__":
    main()
