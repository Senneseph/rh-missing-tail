#!/usr/bin/env python3
"""0275: I_unk quadrature refinement at tPT2 and t3 = 1000*tPT2 (sigma_A).

day075 measured the t3 closure FAIL: fluc(t3) = +10,052,394.5 (sigma-
independent to 0.6) vs B(t3; G1cut) = 19,754..21,072 (A0 = 3.4) and
B_rig = 471,744..503,200 (A0_rig = 81.19, Zeta23 machine-checked).

S stream error < 0.2 (9e9 terms, values 14..70).  phi term verified
sound at t3 via the Stirling cross-check (day077 FE run: C matches
Stirling to print precision).  L = log|zeta| has an at-most-1.35
functional-equation defect at 3e15 (day077) - irrelevant vs 1e7.
THE SUSPECT IS I_unk: the day072 main quad puts 401 log points over
(u0..128) in u = g/t: near u = 1 that is ~5% log spacing = 1.5e14 in g
at t3, so each dip flank (t+60 .. next log point) is ONE tanhsinh
interval over a 1.5e14 span with a log-cusped integrand.  A ~4e-9
relative error THERE is ~1e7 absolute at t3 (matches the closure gap
exactly), and at tPT2 would be ~1e4 (hidden under the 16,158 slack).

Variants (sigma_A, g0 = GLAST, dip window at t, YC = 128, corr 128..
8.8e12, exact c4 tail; only the main grid + window change):
  V0  401 log pts   + window 60/0.01   (day072 as-is)
  V1  4001 log pts  + window 60/0.01   (finer main grid)
  V2  4001 log pts  + window 600/0.01  (wider window: flanks inside)
  V3  4001 log pts  + window 4000/0.001 (both)
  V4  4001 log pts  + window 40000/0.001 (max)
Printed: values, spreads, runtime.  If V3~V4~(stable) and differ from V0
by O(1e7) at t3 (and O(1e4) at tPT2): quadrature is the 1e7, the t3
closure is re-judged with the refined I_unk, and the tPT2 fluc 9,052
carries an error bar of Delta_I(tPT2).

No RH claim.
"""
import time
import mpmath as mpm
import day072_face_U_repair as D72

TPT2 = D72.TPT2
T3 = TPT2 * 1000
GLAST = D72.GLAST
SR = "0.1252270103"
YC = mpm.mpf(128)
Y2 = YC * mpm.mpf(2) ** 36


def I_variant(t, nlog, W, step, dps=60, tag=""):
    mpm.mp.dps = dps
    tM = mpm.mpf(str(t))
    srM = mpm.mpf(SR)
    a = mpm.mpf("0.5") - srM
    c4 = a * a - mpm.mpf("0.25") - tM * tM + srM
    f = lambda g: D72.f_mpmath(g, srM, tM, a)
    rho = lambda g: D72.rho_mpmath(g)
    F = lambda y: f(tM * y) * rho(tM * y)

    y0 = mpm.mpf(str(GLAST)) / tM

    t0 = time.time()
    pts = []
    for j in range(nlog + 1):
        pts.append(y0 * (YC / y0) ** (mpm.mpf(j) / nlog))
    # dip window (uniform in g -> /t in y)
    if y0 < 1 < YC:
        w0 = (tM - mpm.mpf(W)) / tM
        w1 = (tM + mpm.mpf(W)) / tM
        nw = int(mpm.mpf(2 * W) / step)
        pts += [(tM + mpm.mpf(k) * step - mpm.mpf(W)) / tM for k in range(nw + 1)]
    pts = sorted(set(p for p in pts if y0 <= p <= YC))
    if pts[0] != y0:
        pts.insert(0, y0)
    if pts[-1] != YC:
        pts.append(YC)
    main = mpm.quad(F, pts)
    t_main = time.time() - t0

    t0 = time.time()
    ptsC = [YC * (Y2 / YC) ** (mpm.mpf(j) / 80) for j in range(81)]
    corr = mpm.quad(lambda y: (f(tM * y) - c4 / (tM * tM * y * y)) * rho(tM * y), ptsC)
    tail = (c4 / (2 * mpm.pi)) * (1 + mpm.log(tM * YC / (2 * mpm.pi))) / (tM * YC)
    t_corr = time.time() - t0

    I = tM * main + tM * corr + tail
    print(f"  {tag:16s} I = {float(I):+.12e}   "
          f"main={t_main:6.0f}s corr={t_corr:5.0f}s "
          f"(nlog={nlog}, W={W}/{step}, {len(pts)} main pts)", flush=True)
    return float(I)


def run_all(t, label):
    print(f"--- {label}  t = {t}", flush=True)
    I0 = I_variant(t, 401, 60, 0.01, tag="V0 coarse")
    I1 = I_variant(t, 4001, 60, 0.01, tag="V1 grid4001")
    I2 = I_variant(t, 4001, 600, 0.01, tag="V2 win600")
    I3 = I_variant(t, 4001, 4000, 0.001, tag="V3 win4000")
    if label.startswith("t3"):
        I4 = I_variant(t, 4001, 40000, 0.001, tag="V4 win40000")
    else:
        I4 = None
    print(f"  {label}: V1-V0 = {I1-I0:+.6e}   V2-V1 = {I2-I1:+.6e}   "
          f"V3-V2 = {I3-I2:+.6e}"
          + (f"   V4-V3 = {I4-I3:+.6e}" if I4 is not None else ""), flush=True)
    ref = I4 if I4 is not None else I3
    return {"V0": I0, "V1": I1, "V2": I2, "V3": I3, "ref": ref}


if __name__ == "__main__":
    out = open("/tmp/day077b_results.txt", "w")
    import sys

    def P(*a):
        s = " ".join(str(x) for x in a)
        print(s, flush=True)
        out.write(s + "\n")
        out.flush()

    r3 = run_all(T3, "t3 ")
    rp = run_all(TPT2, "tPT2")
    P("")
    P("SUMMARY (sigma_A):")
    P(f"  t3  : ref(I) = {r3['ref']:+.12e}")
    P(f"        V0-Vref = {r3['V0']-r3['ref']:+.6e}")
    P(f"        V1-Vref = {r3['V1']-r3['ref']:+.6e}")
    P(f"        V2-Vref = {r3['V2']-r3['ref']:+.6e}")
    P(f"        V3-Vref = {r3['V3']-r3['ref']:+.6e}")
    P(f"  tPT2: ref(I) = {rp['ref']:+.12e}")
    P(f"        V0-Vref = {rp['V0']-rp['ref']:+.6e}")
    P(f"        V1-Vref = {rp['V1']-rp['ref']:+.6e}")
    P(f"        V2-Vref = {rp['V2']-rp['ref']:+.6e}")
    P(f"        V3-Vref = {rp['V3']-rp['ref']:+.6e}")
    P("day075 usub c4pin(t3) = -2.356599941959e+15 / -2.356599952011e+15")
    P("day075 fluc(t3) = +10,052,394.685 (V0-based); S(t3) = +267,745,707,462.354")
    P("quad refinement complete - no RH claim")
