"""day053b: verification of the day053 vector multi-t sweep against
the verified day049f records (7 of the 29 windows,  24 points).

Checks:
  (a) slab unit oracle:  first 40 slabs x 3 t's,  vector slab ==
      D37.slab_budget bit-for-bit;
  (b1) engine f64 chain:  for all 24 day049f points,  the vector
      window tail's per-t engine re/im/nlt must equal the
      day049f stream.eng re/im/nlt BIT-FOR-BIT (f64 equality);
  (b2) 80-bit stream:  vector ld re19/im19 must equal the
      day049f stream.ld re/im to stored precision (|d| <= 1e-15
      absolute);
  (b3) dps-120 ld-exact margin:  the day053 fast_core_120 +
      margin must equal the day049f dps120_ldexact arm mnew
      (deterministic mpmath:  expect exact,  tolerance 1e-9);
  (b4) engine dps-30 margin:  reported per point  (no reference
      exists at the dps-30 arm in day049f,  so this is a
      record,  not a check;  its inputs b1 are bit-verified).
Exit 0 only if all checks pass.  ~15-25 min on 7 cores.
"""
import json
import os
import sys

import numpy as np

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
import day037_h1_3e10 as D37        # noqa: E402
import day053_reissue_696_vec as V  # noqa: E402

D49F = HERE + "/out_day049f_pts"


def main():
    # (a) slab oracle on a mid-band window
    Ts = D37.Tail3E10(verbose=False)
    g0 = D37.nearest_zero(Ts, 6.0e9)
    V.unit_oracle(Ts, np.array([g0 - 3.0, g0, g0 + 3.0]))

    # (b) the 24 day049f points
    refs = []
    for f in sorted(__import__("glob").glob(D49F + "/pt*.res")):
        d = json.load(open(f))
        p = d["point"]
        st = d["stream"]
        m120 = (d.get("dps120_ldexact")
                or d.get("dps120_ldexact_reim"))
        refs.append({"x": p["x"], "k": p["k"], "t": p["t"],
                     "eng_re": st["eng"]["re"], "eng_im": st["eng"]["im"],
                     "eng_nlt": st["eng"]["nlt"],
                     "ld_re": st["ld"]["re"], "ld_im": st["ld"]["im"],
                     "m120": m120["mnew"]})
    assert len(refs) == 24, "expected 24 day049f references"

    # group by window anchor:  x is the window anchor (grid point)
    bywin = {}
    for r in refs:
        bywin.setdefault(round(r["x"], 3), []).append(r)
    T = D37.Tail3E10(verbose=False)
    fails = 0
    for wx, rs in sorted(bywin.items()):
        g = D37.nearest_zero(T, float(rs[0]["x"]))
        engine, ldstream, _ = V.window_tail(T, g)
        for r in rs:
            k = int(r["k"])
            e = engine[k]
            ld = ldstream[k]
            d_re = e["re"] - r["eng_re"]
            d_im = e["im"] - r["eng_im"]
            bit_ok = (e["re"] == r["eng_re"] and e["im"] == r["eng_im"]
                      and e["nlt"] == r["eng_nlt"])
            ld_ok = (abs(float(ld["re19"]) - float(r["ld_re"])) <= 1e-15
                     and abs(float(ld["im19"]) - float(r["ld_im"]))
                     <= 1e-15)
            # b3: the dps-120 ld-exact margin
            fc120 = V.fast_core_120(T, r["t"], g)
            m = V.day050_margin_120(fc120, ld)
            m_ok = abs(m["mnew"] - r["m120"]) <= 1e-9
            print("x=%.2f k=%+3d  eng_bit_exact=%s (d_re=%.3e "
                  "d_im=%.3e nlt=%s)  ld=%s (d=%.1e)  m120=%s "
                  "(d=%.2e)  m30=%.9f"
                  % (wx, k, bit_ok, d_re, d_im,
                     (e["nlt"] == r["eng_nlt"]), ld_ok,
                     max(abs(float(ld["re19"])
                             - float(r["ld_re"])),
                         abs(float(ld["im19"])
                             - float(r["ld_im"]))),
                     m_ok, abs(m["mnew"] - r["m120"]),
                     _m30(T, g, k, e)))
            if not (bit_ok and ld_ok and m_ok):
                fails += 1
    print("VERIFY day053 vector:  %d failures of %d checks"
          % (fails, len(refs)))
    sys.exit(1 if fails else 0)


def _m30(T, g, k, e):
    """record-only:  the engine dps-30 margin (b4)."""
    tf = float(g + k / 2.0)
    (la, ar, _1, _2, _3) = D37.prod_with_budget(tf)
    (qr30, qe30, _a, _b, _c, _d, _e) = D37.quad_pair(T, tf, False)
    p30 = D37.ev_point(tf, g, 30, qr30, qe30, e["re"], e["im"], la, ar)
    dev30 = D37.dev_parts(tf, g, 30)
    pb = float(D37.M.p8_B(D37.mp.mpf(repr(tf)), D37.n4(tf)))
    return float(p30["zabs"] * dev30) / (pb + float(p30["residf"]))


if __name__ == "__main__":
    main()
