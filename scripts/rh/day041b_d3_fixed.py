#!/usr/bin/env python3
# day041b - D3 FIXED:  the S-at-zeros signature  (E11 successor of
# day041;  see  docs/S1-A1-EXPLORATION.md  E11  and  /tmp/d3_diag3.py).
#
# WHAT  day041  got  wrong:
#   its  S pipeline  S_p = (arg_p zeta - th1)/pi,  snapped  mod-2  to
#   s_data,  computed  s_data  +  f(t)  with  f(t)  =  [-th1(t)/pi]
#   centered  mod-2:  a  sawtooth  in  (-1,1)  drifting  at  -main'(t)
#   (exactly:  th1'(t)/pi  =  main'(t),  measured  to  1e-9).  All  110
#   "consistency  failures"  of  day041  were  f(t)-values,  not  RVM
#   errors.  The  old  JUMP  formula  "1 - 2*dmain"  had  the  sawtooth
#   drift  baked  in.
#
# THE  verified  pipeline  (dps-35,  3  points  over  3.6  units,
# agreement  with  s_data  at  <=  6e-6,  dominated  by  the  stored
# zero  location  error  <  1.9e-6  *  main'  =  6.7e-6):
#   S(t)  =  (phi_u(t)  +  step(t))/pi  +  m0
#   phi_u  =  the  incrementally  unwrapped  phase  (1/2) arg chi(s),
#             chi  =  2^s pi^{s-1} sin(pi s/2) Gamma(1-s);
#   step(t)  =  pi  when  Z(t)  <  0,  else  0,  where
#             Z(t)  =  exp(-i phi_u) zeta(1/2+i t)  is  REAL
#             (verified  |Im Z|/|Z|  =  2.6e-27  at  dps-35);
#   m0  =  an  integer  pinned  pointwise  from  s_data  (the  O(1/T)
#             RVM  gap  makes  the  pin  unambiguous).
#   The  RVM  identity  (Titchmarsh,  Thm  10)
#             N(t)  =  main_7/8(t)  +  S(t)  +  O(1/t)
#   is  numerically  verified  at  3e10,  so  s_data  =  N_excl - main
#   is  S  itself  to  ~1e-5;  the  dps-30  zeta  pass  is  the
#   independent  cross-check  (and  what  this  script  reports).
#
# JUMP  (fixed  formula,  verified  to  2e-6  at  top-1):
#   S(t_R)  -  S(t_L)  =  1  -  (main(t_R)  -  main(t_L))
#
# Bounded  job:  same  footprint  as  day041  (a  few  minutes),
# read-only  on  the  band.
#
# Usage:
#   python3 day041b_d3_fixed.py            # real  top-5  from  day040
#   python3 day041b_d3_fixed.py selftest   # mid-band  identity  check
import os
import sys
import time

import mpmath as mp
import numpy as np

R_H = "/home/jsmille/Projects/rh-missing-tail"
BAND = f"{R_H}/scripts/rh/hi3e10/zeros_2999e6_to_30000e6.f64"
TOP100 = f"{R_H}/scripts/rh/out_day040_top100.tsv"
OUT = f"{R_H}/scripts/rh/out_day041b_d3_fixed.txt"

FRONTIER_N = 9061794704            # N(2.999e6),  certified
BAND_END_PIN = 101639672418        # N(30001045999.98),  finish gate
WALK_STEP = mp.mpf("0.25")
N_MIDS = 20
RES_TOL = mp.mpf("1e-3")           # |S_verify - s_data|  (empirical ~6e-6)
JUMP_TOL = mp.mpf("0.02")          # |JUMP - (1 - dmain)|


def log(msg):
    line = "%s %s" % (time.strftime("%F %T"), msg)
    sys.stdout.write(line + "\n")
    sys.stdout.flush()
    with open(OUT, "a") as f:
        f.write(line + "\n")


def main_mp(t):
    u = t / (2 * mp.pi)
    return u * (mp.log(u) - 1) + mp.mpf(7) / 8


def chi_of(t):
    s = mp.mpf("0.5") + mp.mpc(0, t)
    return (2 ** s) * (mp.pi ** (s - 1)) * mp.sin(mp.pi * s / 2) \
        * mp.gamma(1 - s)


def z_of(t):
    return mp.zeta(mp.mpc(mp.mpf("0.5"), t))


def walk_phi(t_start, targets):
    """Unwrapped  phase  phi_u  on  a  grid  covering  t_start
    up  to  max(targets),  with  every  target  landing  exactly
    on  the  grid  (steps  <=  WALK_STEP)."""
    grid = []
    t = t_start
    hi = max(targets)
    while t <= hi:
        grid.append(t)
        for tg in targets:
            if t < tg <= t + WALK_STEP:
                grid.append(tg)
        t += WALK_STEP
    grid = sorted(set(grid))
    prev = chi_of(grid[0])
    phi_u = mp.arg(prev) / 2
    phis = {grid[0]: phi_u}
    for t in grid[1:]:
        ch = chi_of(t)
        phi_u += mp.arg(ch * mp.conj(prev)) / 2
        prev = ch
        phis[t] = phi_u
    return phis


def s_verify(t, phis):
    """(phi_u  +  step)/pi  BEFORE  the  integer  pin."""
    Z = mp.e ** (-1j * phis[t]) * z_of(t)
    step = mp.pi if mp.re(Z) < 0 else mp.mpf(0)
    return (phis[t] + step) / mp.pi, abs(mp.im(Z)) / abs(Z)


def count_below(path, t):
    """Number  of  band  zeros  <  t  (binary  search,  8-byte  reads)."""
    total = os.path.getsize(path) // 8
    lo, hi = 0, total          # invariant:  all  [0,lo)  <  t,
                               #            all  [hi,total)  >=  t
    with open(path, "rb", buffering=0) as f:
        while lo < hi:
            mid = (lo + hi) // 2
            f.seek(mid * 8)
            x = np.frombuffer(f.read(8), dtype="<f8")[0]
            if x < t:
                lo = mid + 1
            else:
                hi = mid
    return int(lo)


def main_probe(j, t0_stored, dn):
    """One  excursion  (band  index  j,  stored  value  t0,  DN=dv)."""
    span = N_MIDS + 3
    a = max(0, j - 2)
    with open(BAND, "rb", buffering=0) as f:
        f.seek(a * 8)
        w = np.frombuffer(f.read((j - a + span) * 8), dtype="<f8")
    t0 = float(w[j - a])
    gL = t0 - float(w[j - a - 1])
    gR = float(w[j - a + 1]) - t0
    delta = 0.25 * min(gL, gR)

    def t_mp(x):
        return mp.mpf(repr(float(x)))

    tL = t_mp(t0 - delta)
    tR = t_mp(t0 + delta)
    mids = [mp.mpf(repr(0.5 * (float(w[j - a + k])
                                + float(w[j - a + k + 1]))))
            for k in range(1, N_MIDS + 1)]
    pts = [("t_L", tL, j - 1), ("t_R", tR, j)]
    pts += [("mid%02d" % k, m, j + k) for k, m in enumerate(mids, 1)]

    phis = walk_phi(tL - mp.mpf("3"),
                    [tL, tR] + mids)
    rows = []
    worst = mp.mpf("0")
    for label, t, left_idx in pts:
        sd = mp.mpf(FRONTIER_N + left_idx + 1) - main_mp(t)
        su, rel_im = s_verify(t, phis)
        m0 = mp.nint(sd - su)
        sv = su + m0
        residual = abs(sv - sd)
        worst = max(worst, residual)
        rows.append((label, float(t), sd, sv, residual, rel_im))
        log("  %-6s  t=%.9f  s_data=%+.9f  S_ver=%+.9f  "
            "res=%.2e  |ImZ|/|Z|=%.1e%s"
            % (label, float(t), float(sd), float(sv),
               float(residual), float(rel_im),
               "" if residual <= RES_TOL else "  << TOL"))
    return tL, tR, rows, float(worst)


def emit():
    if not os.path.exists(TOP100):
        log("FATAL: %s missing" % TOP100)
        return 1
    exc = []
    with open(TOP100) as f:
        hdr = f.readline()
        for line in f:
            p = line.split("\t")
            exc.append((int(p[0]), float(p[1]), int(p[2]),
                        float(p[3]), float(p[4])))
            if len(exc) == 5:
                break
    mp.mp.dps = 30
    worst_all = mp.mpf("0")
    log("D3-FIXED:  top-5  excursions,  S  via  the  verified  "
        "(phi_u + step)/pi  pipeline,  dps-30")
    nres = 0
    for rank, ad, j, t0, dn in exc:
        log("excursion rank=%d  |DN|=%.9f  band_index=%d  t~%.6f"
            % (rank, ad, j, t0))
        tL, tR, rows, wres = main_probe(j, ad, dn)
        nres += len(rows)
        worst_all = max(worst_all, mp.mpf(repr(wres)))
        sd_L = rows[0][2]
        sv_L = rows[0][3]
        sd_R = rows[1][2]
        sv_R = rows[1][3]
        dmain = main_mp(tR) - main_mp(tL)
        jump = sv_R - sv_L
        jexp = mp.mpf(1) - dmain
        jok = abs(jump - jexp) <= JUMP_TOL
        log("  JUMP:  S(t_R)-S(t_L) = %+.9f   expect %+.9f  (1-dmain)  "
            "residual %.2e  %s"
            % (float(jump), float(jexp), float(abs(jump - jexp)),
               "OK" if jok else "<< TOL"))
        s_at_zero = float(rows[1][2])
        mids = rows[2:]
        mx = max(abs(float(r[2])) for r in mids)
        log("  |S| at zero (left  S_data(t_R)):  %+.6f" % s_at_zero)
        log("  |S| max over 20 midpoints:  %.6f   worst label:  %s"
            % (mx, max(mids, key=lambda r: abs(float(r[2])))[0]))
    log("D3-FIXED:  %d  points,  worst  |S_ver - s_data|  =  %.2e"
        "  (empirical  RVM  agreement;  Titchmarsh  Thm  10:  O(1/t))"
        % (nres, worst_all))
    return 0


def selftest():
    """mid-band  identity:  S_verify  vs  s_data  at  the  band
    midpoint,  with  N  from  the  exact  pins  (no  zero  finder,
    no  memory  of  small-t  counts)."""
    global OUT
    OUT = "/tmp/day041b_selftest.txt"
    if os.path.exists(OUT):
        os.remove(OUT)
    mp.mp.dps = 30
    total = BAND_END_PIN - FRONTIER_N
    mid_idx = total // 2
    with open(BAND, "rb", buffering=0) as f:
        f.seek(mid_idx * 8)
        zmid = np.frombuffer(f.read(16), dtype="<f8")
    t0 = 0.5 * (float(zmid[0]) + float(zmid[1]))
    n_below = count_below(BAND, t0)
    sd = mp.mpf(FRONTIER_N + n_below) - main_mp(mp.mpf(repr(t0)))
    phis = walk_phi(mp.mpf(repr(t0 - 1.0)),
                    [mp.mpf(repr(t0))])
    su, rel_im = s_verify(mp.mpf(repr(t0)), phis)
    m0 = mp.nint(sd - su)
    sv = su + m0
    d = abs(sv - sd)
    ok = bool(d < mp.mpf("1e-4"))
    log("selftest:  t=%.9f  N_excl=%d" % (t0, FRONTIER_N + n_below))
    log("selftest:  s_data=%+.9f  S_ver=%+.9f  (m0=%d)  diff=%.2e  "
        "|ImZ|/|Z|=%.1e  %s"
        % (float(sd), float(sv), int(m0), float(d), float(rel_im),
           "PASS" if ok else "FAIL"))
    return ok


if __name__ == "__main__":
    if "selftest" in sys.argv:
        sys.exit(0 if selftest() else 1)
    if os.path.exists(OUT):
        os.remove(OUT)
    sys.exit(emit())
