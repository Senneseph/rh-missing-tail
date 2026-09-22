#!/usr/bin/env python3
# day041 - D3:  the S-at-zeros signature  (S1-A1-EXPLORATION E5 item
# D3,  raised to top priority by E7's zero/drift dichotomy).
#
# At the top-5 |DN| excursion zeros (from the day040 top-100 table),
# evaluate the continuous S at dps-30 via mpmath  (analytic,
#  independent of the census)  and compare against the DATA-side
#  prediction  S(t) = N_excl(t) - main(t)   (N_excl from the band
#  count,  main = (t/2pi) log(t/(2pi e)) + 7/8  in mpmath precision).
#
# The measured S-pipeline:
#   S_p(t) = (arg_p zeta(1/2+it) - th1(t)) / pi
#   where  arg_p  = principal argument  and
#          th1(t) = Im log Gamma(1/4 + i t/2) - (t/2) log pi
#          (the classical Riemann-Siegel theta,  principal branch).
#   RVM gives  S(t) = N_excl(t) - main(t)  exactly (up to the RVM
#   remainder  |R(t)| <= log^2(t)/(pi sqrt(t))  ~ 1e-3  at t = 3e10),
#   and  S  is determined by S_p  mod 2  (both the arg wrap and the
#   log-gamma branch cut shift S_p by EVEN integers),  so the family
#   is uniquely fixed by an O(1) anchor:
#      S_meas = S_p - 2*nint((S_p - S_data)/2).
#
# NOTE (selftest-caught):  do NOT use the functional-equation phase
#      theta(t) = (1/2) arg chi(s),  chi = 2^s pi^{s-1} sin(pi s/2)
#      Gamma(1-s)  (for which  exp(-i theta) zeta IS real)  in the
#   S-pipeline  —  that realness identity is a different clock.
#
# Per excursion zero gamma_j  (band index j,  DN value v):
#   t_L = gamma_j - delta,  t_R = gamma_j + delta,
#   delta = 0.25 * min(adjacent gaps)   (the stored f64 zero is off
#   the true zero by < 1.9e-6  (half ulp),  min delta 5.7e-6  =>
#   the side is unambiguous).
#   -  S_meas(t_L)  vs  S_data(t_L)      (gap before the zero)
#   -  S_meas(t_R)  vs  S_data(t_R)      (gap after the zero)
#   -  JUMP:  S_meas(t_R) - S_meas(t_L) ~ 1 - 2*(main(t_R)-main(t_L))
#     (the +1 step at the zero  minus  the in-gap S drift  on each
#     side of the window;  a genuine simple real zero.  A census
#     glitch would show ~0 instead).
#   -  20 GAP MIDPOINTS after gamma_j:  |S| vs the at-zero  |S|
#     (E7:  "tame at the zeros,  possibly wilder between").
#
# S conventions (exact,  E7 derivation):
#   S_left(gamma_j)  =  DN(j) - 7/8 + o(1),
#   S_right(gamma_j) =  DN(j) + 1/8 + o(1)    (simple zero).
#
# Bounded job:  ~110 dps-30 evaluations  (a couple of minutes),
#  ~10 random seeks on the band.  Read-only.
#
# Usage:
#   python3 day041_d3_dps30.py            # real top-5 from day040
#   python3 day041_d3_dps30.py selftest   # pipeline check at small t
import os
import sys
import time

import mpmath as mp
import numpy as np

R_H = "/home/jsmille/Projects/rh-missing-tail"
BAND = f"{R_H}/scripts/rh/hi3e10/zeros_2999e6_to_30000e6.f64"
TOP100 = f"{R_H}/scripts/rh/out_day040_top100.tsv"
OUT = f"{R_H}/scripts/rh/out_day041_d3.txt"

FRONTIER_N = 9061794704
DPS = 30
TOL = 0.01
N_MIDS = 20


def log(msg):
    line = "%s %s" % (time.strftime("%F %T"), msg)
    sys.stdout.write(line + "\n")
    sys.stdout.flush()
    if OUT:
        with open(OUT, "a") as f:
            f.write(line + "\n")


def main_mp(t):
    # Classical RVM main term,  exact in the current mp precision:
    #   (t/2pi) log(t/(2pi e)) + 7/8
    u = t / (2 * mp.pi)
    return u * (mp.log(u) - 1) + mp.mpf(7) / 8


def th1_mp(t):
    # Classical Riemann-Siegel theta (principal branch of log gamma).
    return mp.im(mp.loggamma(mp.mpf("0.25") + mp.mpc(0, t / 2))
                 ) - (t / 2) * mp.log(mp.pi)


def phi_mp(t):
    # Functional-equation phase (principal):  (1/2) arg chi(s),
    #   chi(s) = 2^s pi^{s-1} sin(pi s/2) Gamma(1-s);
    #   exp(-i CONTINUOUS_phi/2) zeta is real.
    s = mp.mpf("0.5") + mp.mpc(0, t)
    chi = (2 ** s) * (mp.pi ** (s - 1)) * mp.sin(mp.pi * s / 2) \
        * mp.gamma(1 - s)
    return mp.arg(chi) / 2


def z_of(t):
    return mp.zeta(mp.mpc(mp.mpf("0.5"), t))


def s_measure(t, s_data):
    """S measured from arg zeta at t,  anchored to the O(1) family
    of s_data  (S_p determines S only mod 2)."""
    sp = (mp.arg(z_of(t)) - th1_mp(t)) / mp.pi
    return sp - 2 * mp.nint((sp - s_data) / 2)


def window_zeros(path, j, span):
    total = os.path.getsize(path) // 8
    a = max(0, j - span)
    b = min(total - 1, j + span)
    with open(path, "rb", buffering=0) as f:
        f.seek(a * 8)
        w = np.frombuffer(f.read((b - a + 1) * 8), dtype="<f8")
    return w, j - a


def probe_abs(path, j, v):
    """Probe at absolute band index j.  Returns (rows, t0, gL, gR).
    rows:  list of (label, t, s_data, s_meas)."""
    rows = []
    w, i0 = window_zeros(path, j, N_MIDS + 2)
    t0 = float(w[i0])
    gL = t0 - float(w[i0 - 1])
    gR = float(w[i0 + 1]) - t0
    delta = 0.25 * min(gL, gR)
    tL = mp.mpf(repr(t0)) - mp.mpf(repr(delta))
    tR = mp.mpf(repr(t0)) + mp.mpf(repr(delta))

    def data_s(t, left_zero_idx):
        # S(t) = N_excl(t) - main(t);  for t in the gap AFTER zero
        # left_zero_idx:  N_excl(t) = FRONTIER_N + left_zero_idx + 1.
        return (FRONTIER_N + left_zero_idx + 1) - main_mp(t)

    sd_L = data_s(tL, j - 1)
    rows.append(("t_L", float(tL), sd_L, s_measure(tL, sd_L)))
    sd_R = data_s(tR, j)
    rows.append(("t_R", float(tR), sd_R, s_measure(tR, sd_R)))
    for k in range(1, N_MIDS + 1):
        mid = mp.mpf(repr(0.5 * (float(w[i0 + k])
                                 + float(w[i0 + k + 1]))))
        sd = data_s(mid, j + k)
        rows.append(("mid%02d" % k, float(mid), sd,
                     s_measure(mid, sd)))
    return rows, t0, gL, gR


def zeta_count_below(tmax, step="0.05"):
    """Count zeros below tmax by sign changes of the REAL function
    Z(t) = exp(-i phi_cont/2) zeta(1/2+it),  where the phase is
    unwrapped incrementally  (the principal arg would wrap 2pi and
    flip Z's sign  =>  spurious sign changes)."""
    t = mp.mpf("0.1")
    step = mp.mpf(step)
    phi = phi_mp(t)                    # near 0.1 the phase is small
    chi_prev = None
    s = mp.mpf("0.5") + mp.mpc(0, t)
    chi_prev = (2 ** s) * (mp.pi ** (s - 1)) \
        * mp.sin(mp.pi * s / 2) * mp.gamma(1 - s)
    Zr = mp.re(mp.e ** (-1j * phi) * z_of(t))
    n = 0
    prevZ = Zr
    t += step
    while t <= tmax:
        s = mp.mpf("0.5") + mp.mpc(0, t)
        chi = (2 ** s) * (mp.pi ** (s - 1)) \
            * mp.sin(mp.pi * s / 2) * mp.gamma(1 - s)
        dphi = mp.arg(chi * mp.conj(chi_prev)) / 2      # phase of Z
        phi += dphi
        Zr = mp.re(mp.e ** (-1j * phi) * z_of(t))
        if prevZ * Zr < 0:
            n += 1
        prevZ = Zr
        chi_prev = chi
        t += step
    return n


def selftest():
    global OUT
    OUT = "/tmp/day041_selftest.txt"
    if os.path.exists(OUT):
        os.remove(OUT)
    ok = True

    # 1)  Z-realness of the functional-equation phase  (dps 30):
    mp.mp.dps = 30
    for ts in (15.0, 50.0, 100.0, 150.05):
        t = mp.mpf(repr(ts))
        ph = phi_mp(t)                  # principal  =>  phase parity
        Z = mp.e ** (-1j * ph) * z_of(t)        # can be sign-flipped,
        rel = abs(mp.im(Z)) / abs(Z)            # still must be REAL
        good = rel < mp.mpf("1e-18")
        ok = ok and good
        log("selftest Z-real@%7.2f:  |Im Z|/|Z| = %.3e  %s"
            % (ts, float(rel), "OK" if good else "FAIL"))

    # 2)  zero count below 150.05  (unwrapped phase,  dps 15 grid):
    mp.mp.dps = 15
    t0 = time.time()
    n = zeta_count_below(mp.mpf("150.05"))
    log("selftest zero count below 150.05:  N = %d  (%.1f s)"
        % (n, time.time() - t0))

    # 3)  the S-pipeline at t = 150.05,  anchored  (S_meas is the
    #     exact analytic S at this general point  —  no RVM error):
    #     (a)  known fact  |S(t)| < 1 for t < 280  (Milino's
    #         computational anchor,  verified this session);
    #     (b)  RVM consistency  |S_meas - (N - main)| < 0.5  (the
    #         RVM remainder at this small t is bounded by a small
    #         O(1) amount;  at the production height 3e10 it is
    #         ~1e-3 and the tolerance there is 0.01).
    mp.mp.dps = 30
    t = mp.mpf("150.05")
    sd = mp.mpf(n) - main_mp(t)
    sm = s_measure(t, sd)
    dev = abs(sm - sd)
    good3 = abs(sm) < 1
    good4 = dev < mp.mpf("0.5")
    ok = ok and good3 and good4
    log("selftest S_meas(150.05) = %+.9f  (known: |S|<1 for t<280)"
        "  %s" % (float(sm), "OK" if good3 else "FAIL"))
    log("selftest RVM consistency:  S_data = %+.9f  N = %d  "
        "dev = %.3e  %s" % (float(sd), n, float(dev),
                            "OK" if good4 else "FAIL"))

    # 5)  jump structure:  locate a zero in (30, 100) from a fine
    #     re-scan,  then verify S_p jumps by exactly +1  (mod 2)
    #     across it.  (This is the analytic twin of the production
    #     JUMP test on the D-band excursion zeros.)
    mp.mp.dps = 20
    step = mp.mpf("0.02")
    t = mp.mpf("0.1")
    phi = phi_mp(t)
    s_ = mp.mpf("0.5") + mp.mpc(0, t)
    chi_prev = (2 ** s_) * (mp.pi ** (s_ - 1)) \
        * mp.sin(mp.pi * s_ / 2) * mp.gamma(1 - s_)
    prevZ = mp.re(mp.e ** (-1j * phi) * z_of(t))
    prev_t = t
    t += step
    zeros = []
    while t <= mp.mpf("150.05"):
        s_ = mp.mpf("0.5") + mp.mpc(0, t)
        chi = (2 ** s_) * (mp.pi ** (s_ - 1)) \
            * mp.sin(mp.pi * s_ / 2) * mp.gamma(1 - s_)
        phi += mp.arg(chi * mp.conj(chi_prev)) / 2
        Zr = mp.re(mp.e ** (-1j * phi) * z_of(t))
        if prevZ * Zr < 0:
            zeros.append((prev_t + t) / 2)
        prevZ = Zr
        chi_prev = chi
        prev_t = t
        t += step
    gaps = []
    for k in range(len(zeros) - 1):
        gaps.append((float(zeros[k + 1]) - float(zeros[k]),
                     0.5 * (float(zeros[k]) + float(zeros[k + 1]))))
    gaps.sort(reverse=True)
    mp.mp.dps = 30
    # Jump structure:  S_p must jump by exactly +1  (mod 2)  at a
    # zero.  Pick a found zero with 30 < t < 100  and compare
    # S_p across it at +/-.05.
    cands = [float(z) for z in zeros if 30.0 < float(z) < 100.0]
    g = cands[len(cands) // 2]
    a = mp.mpf(repr(g - 0.05))
    b = mp.mpf(repr(g + 0.05))
    dS = ((mp.arg(z_of(b)) - th1_mp(b))
          - (mp.arg(z_of(a)) - th1_mp(a))) / mp.pi
    # expected  (VERIFIED to 1e-5 at 3 spans in this session):
    #   dS = +1  (the zero's step)  -  2*(main(b) - main(a))  (the
    #   in-gap S drift  -main'  on each side of the window)  + O(1/t)
    exp = 1 - 2 * (main_mp(b) - main_mp(a))
    dS2 = dS - 2 * mp.nint((dS - exp) / 2)
    good = abs(dS2 - exp) < mp.mpf("0.01")
    ok = ok and good
    log("selftest jump @ %.4f:  dS_p mod 2 = %.6f  expect %.6f  %s"
        % (g, float(dS2), float(exp), "OK" if good else "FAIL"))

    log("SELFTEST-%s" % ("PASS" if ok else "FAIL"))
    return ok


def main():
    if len(sys.argv) > 1 and sys.argv[1] == "selftest":
        sys.exit(0 if selftest() else 1)
    if not os.path.exists(TOP100):
        log("D41 ABORT:  %s not found  (run day040 first)" % TOP100)
        sys.exit(2)
    if os.path.exists(OUT):
        os.remove(OUT)
    mp.mp.dps = DPS
    with open(TOP100) as f:
        f.readline()
        rows_in = []
        for line in f:
            p = line.split("\t")
            rows_in.append((float(p[1]), int(p[2]), float(p[3]),
                            float(p[4])))
            if len(rows_in) == 5:
                break
    log("D41 start:  top-%d excursions,  dps=%d,  tol=%.3f,  "
        "%d midpoints each" % (len(rows_in), DPS, TOL, N_MIDS))
    worst_dev = mp.mpf(0)
    n_pts = 0
    all_ok = True
    for rank, (adn, j, t_val, v) in enumerate(rows_in, 1):
        rows, t0, gL, gR = probe_abs(BAND, j, v)
        delta = 0.25 * min(gL, gR)
        smL = smR = None
        log("D41 top-%d:  band_idx=%d  t=%.6f  DN=%+.9f  |DN|=%.9f"
            % (rank, j, t0, v, adn))
        log("   gaps:  left=%.9f  right=%.9f  (delta=%.9f)"
            % (gL, gR, delta))
        for (lab, t, sd, sm) in rows:
            n_pts += 1
            dev = abs(sm - sd)
            good = dev < mp.mpf(repr(TOL))
            all_ok = all_ok and good
            if dev > worst_dev:
                worst_dev = dev
            log("   %-5s t=%.6f  S_data=%+.9f  S_meas=%+.9f  "
                "dev=%.2e  %s" % (lab, t, float(sd), float(sm),
                                  float(dev), "OK" if good
                                  else "FAIL"))
            if lab == "t_L":
                smL = sm
            elif lab == "t_R":
                smR = sm
        jump = smR - smL
        # Expected:  the +1 step at the zero  MINUS  the in-gap S
        # drift (-main') accumulated on each side of the window:
        #   1 - 2*(main(t_R) - main(t_L))   (verified form,  +O(1/t))
        exp_jump = 1 - 2 * (main_mp(tR) - main_mp(tL))
        good = abs(jump - exp_jump) < mp.mpf(repr(TOL))
        all_ok = all_ok and good
        log("   JUMP  S_meas(t_R) - S_meas(t_L) = %+.9f  expect"
            " %+.9f (1 - 2*dmain)  %s" % (float(jump), float(exp_jump),
                                           "OK" if good else "FAIL"))
        mids = [r for r in rows if r[0].startswith("mid")]
        max_mid = max(abs(r[3]) for r in mids)
        s_right = mp.mpf(repr(v)) + mp.mpf(1) / 8
        log("   |S| at zero (S_right = DN + 1/8) = %.9f ;  max |S|"
            " over next %d midpoints = %.9f"
            % (float(abs(s_right)), len(mids), float(max_mid)))
    log("D41 DONE:  worst |S_meas - S_data| = %.3e over %d points;  "
        "ALL %s" % (float(worst_dev), n_pts, "OK" if all_ok
                    else "FAILED"))


if __name__ == "__main__":
    main()
