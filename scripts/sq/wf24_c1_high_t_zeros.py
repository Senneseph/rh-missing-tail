#!/usr/bin/env python3
# WF-24 C1: the predictive-power test IN THE LIVE REGION.
# The settled hole (t <= 404) is flat across zero heights (0214). The live
# second wave appears for t >= 800 (imH reversing, amp ~0.05-0.07). C1 asks:
# on t in [400, 1200] (813 certified zeros up to 1.2e3), does the hole wave
# H(t) = v(r0+12)-v(r0) (F_24, class r0 = 1) differ AT the zero heights from
# matched OFF-ZERO controls (gamma +/- 0.1 * local spacing)?
#   signals tested: (1) mean |imH|/|reH| zeros vs matched controls + 95% CI
#                   (bootstrap over zeros);
#                   (2) local-density bins: |imH - 21/t| vs local 1/spacing;
#                   (3) per-zero paired test: |imH(g_k)| > max(|imH(g_k+/-d)|)?
#       (zero-peak rate; 50% = null, > 75% = signal)
# OFF-BOARD side quest. No RH claim. Single-threaded (4 cores open).

import sys
sys.path.insert(0, "scripts/sq")
from mpmath import mp, mpf, mpc
mp.dps = 30

import wf24_wavefront as W

CELL = W.fib_cell_24()
P = W.cumrow(CELL)
R0, RF = 1, 13
GPATH = "scripts/rh/lowt/zeros_0_to_1p2e3.dec20.txt"

def h_at(t):
    S = mpf("0.5") + mp.j * t
    ZA = W.zeta_lattice(S)
    v = W.readings_at(CELL, P, ZA, S)
    pole = sum(v) / 24
    return (v[RF] - pole) - (v[R0] - pole)   # H = W_fut - W_past

def main():
    out = []
    def rep(s=""):
        print(s)
        out.append(s)

    gams = []
    with open(GPATH) as f:
        for line in f:
            g = mpf(line.strip())
            if mpf("398") <= g <= mpf("1202"):
                gams.append(g)
    rep(f"WF-24 C1: live-region zero test (F_24, class {R0}->{RF}, N={W.L})")
    rep(f"  zeros in [398, 1202]: {len(gams)} (first {W.nstr(gams[0],6)}, "
        f"last {W.nstr(gams[-1],6)})")

    zs, cs = [], []   # (t, reH, imH) at zeros / at matched controls
    for k in range(len(gams)):
        g = gams[k]
        lo = gams[k - 1] if k > 0 else g - mpf(1.2)
        hi = gams[k + 1] if k < len(gams) - 1 else g + mpf(1.2)
        d = min(g - lo, hi - g) * mpf("0.1")
        offmin = max(d, mpf("0.02"))
        # controls: symmetric offsets 0.1 * local half-spacing, capped 0.3
        off = min(mpf("0.1")*mpf("0.5")*min(g - lo, hi - g), mpf("0.3"))
        hz = h_at(g)
        zs.append((g, hz.real, hz.imag))
        for sgn in (-1, +1):
            hc = h_at(g + sgn*off)
            cs.append((g + sgn*off, hc.real, hc.imag))

    rep(f"  samples: zeros {len(zs)}, matched controls {len(cs)}")

    # (1) means + bootstrap CI on the ratio of |imH| (zeros vs controls)
    zm = [abs(i) for _, _, i in zs]
    cm = [abs(i) for _, _, i in cs]
    zmean, cmean = sum(zm)/len(zm), sum(cm)/len(cm)
    rep(f"  (1) mean |imH|: zeros = {W.nstr(zmean,7)}  controls = {W.nstr(cmean,7)}"
        f"  ratio = {W.nstr(zmean/cmean,6)}")
    import random
    random.seed(42)
    ratios = []
    for _ in range(2000):
        zz = [zm[random.randrange(len(zm))] for _ in range(len(zm))]
        cc = [cm[random.randrange(len(cm))] for _ in range(len(zm))]
        m1 = sum(zz)/len(zz); m2 = sum(cc)/len(cc)
        if m2 > 0:
            ratios.append(m1/m2)
    ratios.sort()
    lo95, hi95 = ratios[int(0.025*len(ratios))], ratios[int(0.975*len(ratios))]
    rep(f"      ratio 95% CI (bootstrap 2000, size {len(zm)}): "
        f"[{W.nstr(lo95,6)}, {W.nstr(hi95,6)}]")
    # re part
    zr = sum(abs(r) for _, r, _ in zs)/len(zs)
    cr = sum(abs(r) for _, r, _ in cs)/len(cs)
    rep(f"      mean |reH|: zeros = {W.nstr(zr,7)}  controls = {W.nstr(cr,7)}"
        f"  ratio = {W.nstr(zr/cr,6)}")

    # (2) local density bins on |imH - 21/t| (settled-transient law subtracted)
    rows = []
    for k in range(len(gams)):
        g = gams[k]
        lo = gams[k-1] if k > 0 else g - mpf(1.2)
        hi = gams[k+1] if k < len(gams)-1 else g + mpf(1.2)
        sp = (hi - lo)/2
        hz = h_at(g)
        res = abs(hz.imag - mpf("21")/g)
        re_res = hz.real - (mpf("42") + mpf("0.00038")*(g - mpf("400"))/mpf("4"))
        rows.append((1/sp, res, g, re_res))
    rows.sort(key=lambda x: -x[0])
    n3 = len(rows)//3
    bins = [("high density", rows[:n3]), ("mid", rows[n3:2*n3]), ("low density", rows[2*n3:])]
    rep(f"  (2) |imH - 21/t| at zeros by local zero density (bin size {n3}):")
    for nm, b in bins:
        m = sum(x[1] for x in b)/len(b)
        sd = mp.sqrt(sum((x[1]-m)**2 for x in b)/len(b))
        rep(f"      {nm:>12}: mean = {W.nstr(m,6)}  sd = {W.nstr(sd,6)}  "
            f"(1/spacing ~ {W.nstr(sum(x[0] for x in b)/len(b),5)})")
    # re residual vs density
    rep(f"      reH residual (H_re - drift) by density:")
    for nm, b in bins:
        m = sum(x[3] for x in b)/len(b)
        rep(f"      {nm:>12}: mean = {W.nstr(m,6)}")

    # (3) per-zero paired peak test on |imH - 21/t|
    peak = 0
    for k in range(1, len(gams)-1):
        g = gams[k]
        lo = gams[k-1]; hi = gams[k+1]
        d = min(g-lo, hi-g)*mpf("0.5")
        off = min(d*mpf("0.2"), mpf("0.3"))
        hz = h_at(g)
        h1 = h_at(g - off); h2 = h_at(g + off)
        rz = abs(hz.imag - mpf("21")/g)
        r1 = abs(h1.imag - mpf("21")/(g-off))
        r2 = abs(h2.imag - mpf("21")/(g+off))
        if rz > r1 and rz > r2:
            peak += 1
    n = len(gams) - 2
    rep(f"  (3) per-zero peak rate |resH(g)| > both neighbors: {peak}/{n} "
        f"= {W.nstr(mpf(peak)/n,5)}  (null ~0.333; > 0.60 = strong signal)")

    rep("\nDONE C1.")
    with open("tmp/sq24/wf24_c1_out.txt", "w") as f:
        f.write("\n".join(out) + "\n")

if __name__ == "__main__":
    main()
