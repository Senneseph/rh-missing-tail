#!/usr/bin/env python3
"""0275 (probe, part 2): published explicit per-unit zero laws at face height.

Cited law (the 0275 A0 audit result):
  Hasanalizade, Shen, Wong, "Counting zeros of the Riemann zeta function",
  J. Number Theory 235 (2022) 219-241 (arXiv:2112.02923).
    Cor. 1.2 (two-sided, ALL T >= e):
      | N(T) - (T/2pi) log(T/2pi e) | <= 0.1038 log T + 0.2573 log log T + 9.3675
    Cor. 1.4 (two-sided, ALL T >= e):
      |S(T)| <= min{ 0.1038 log T + 0.2573 log log T + 8.3675,
                    0.1095 log T + 0.2042 log log T + 3.0305 }
  Proof structure: analytic route for T >= T0 = 30610046000 (subconvexity-based
  explicit machinery) + verified zero database |S(T)| <= 2.5167 for T <= 30610046000
  below T0.  Hence both corridors hold at EVERY t >= e, in particular at
  tPT2 = 3.0001753328e12 and t3 = 3.0001753328e15 (both > T0: purely analytic).

Consequences derived here (dps-60, exact formulas, no data):
  1. Per-unit count law (u >= e):  N(u+1)-N(u) <= B1_H(u) := dmain(u) + E(u+1)+E(u)
       where dmain(u) = (1/2pi)[(u+1)ln((u+1)/(2pi e)) - u ln(u/(2pi e))].
  2. Per-unit S-route fluctuation law: the unknown-side fluctuation
       fluc = sum_{g>GLAST} f(g) - int f rho = -int e(x) f'(x) dx  (e(GLAST)=0)
     is controlled by e(x) = S(x) - S(GLAST) + O(1/x)  ->  |e(x)| <= Smax(x)+S0.
     Window envelope (0274 g2-cut kernel shape, monotonicity asserted in
     day073/day075 200k-grid checks):
       E_win_S(t) = (Smax(t)+S0)*(|f(g2)| + (f(g2)-f(t-1)))
                  + (Smax(t+1)+S0)*2*|f(t+1)|
  3. Certified window counts W = (t-1, t+1] (all 0 < beta < 1):
       raw S-route:  N(t+1)-N(t-1) <= 2*dmain(t) + Smax(t+1)+Smax(t-1)
       kernel S-route: k_max = floor((E_win_S - fluc)/|f_edge|)  (k_max < 0 -> 0)
  4. Structural row: E_win_S(t) grows like (ln t)(ln t + O(1)) while fluc is
     t-frozen (day074, dK'/dt = -3.006e-9): the per-unit S/count laws cannot
     exclude the frontier window at ANY single t under these published bounds.

No RH claim.  Face at tPT2 remains OPEN under every certified bound computed.
"""
import mpmath as mpm
import re

mpm.mp.dps = 60
TPT2 = mpm.mpf("3000175332800")
T3 = TPT2 * 1000
GLAST = mpm.mpf("3001345999.873009")
GDATA = mpm.mpf("30001045999.981976")
SIGS = [mpm.mpf("0.1252270103"), mpm.mpf("0.25"), mpm.mpf("0.40"), mpm.mpf("0.49")]
SMNAME = ["sigA", "sigQ", "sigF", "sigN"]

# corrected face values at tPT2, G1 cut (day072c, dual-validated main term):
FLUC_TPT2 = [mpm.mpf("229.063294"), mpm.mpf("229.141074"),
             mpm.mpf("229.363934"), mpm.mpf("229.787251")]
# 0274 g2-cut window values (A0_cite = 3.4 route): E_win, f_edge:
EWINS_TPT2 = [mpm.mpf("9995.99"), mpm.mpf("10006.37"),
              mpm.mpf("10013.79"), mpm.mpf("10015.23")]
FEDGE_TPT2 = [mpm.mpf("27.9708"), mpm.mpf("28.0062"),
              mpm.mpf("28.0316"), mpm.mpf("28.0365")]
B1_CITE_TPT2 = mpm.mpf("3.4") * mpm.log(TPT2)


def E_hsxw(T):
    """HSXW Cor 1.2: |N(T)-main(T)| bound, T >= e."""
    if T < mpm.e:
        raise ValueError("T < e")
    return mpm.mpf("0.1038") * mpm.log(T) + mpm.mpf("0.2573") * mpm.log(mpm.log(T)) \
        + mpm.mpf("9.3675")


def Smax(T):
    """HSXW Cor 1.4: two-sided S bound (min of the two published branches)."""
    if T < mpm.e:
        raise ValueError("T < e")
    b1 = mpm.mpf("0.1038") * mpm.log(T) + mpm.mpf("0.2573") * mpm.log(mpm.log(T)) \
        + mpm.mpf("8.3675")
    b2 = mpm.mpf("0.1095") * mpm.log(T) + mpm.mpf("0.2042") * mpm.log(mpm.log(T)) \
        + mpm.mpf("3.0305")
    return min(b1, b2)


def dmain(u):
    """Exact main-term increment of one unit (Riemann-von Mangoldt main term)."""
    return (1 / (2 * mpm.pi)) * ((u + 1) * mpm.log((u + 1) / (2 * mpm.pi * mpm.e))
                                 - u * mpm.log(u / (2 * mpm.pi * mpm.e)))


def B1_hsxw(u):
    """Per-unit count law N(u+1)-N(u) (HSXW Cor 1.2, worst-case two-sided)."""
    return dmain(u) + E_hsxw(u + 1) + E_hsxw(u)


def kernel_mpf(sr, t, g):
    a = mpm.mpf("0.5") - sr
    g2 = g * g + mpm.mpf("0.25")
    A = (a * a + (g - t) ** 2) / g2
    B = (a * a + (g + t) ** 2) / g2
    return 0.5 * (mpm.log(A) + mpm.log(B)) + sr / g2


def fprime_mpf(sr, t, g):
    """Analytic derivative of the kernel (exact log-derivative form).
    f(g) = 0.5 ln((a^2+(g-t)^2)/(1/4+g^2)) + 0.5 ln((a^2+(g+t)^2)/(1/4+g^2))
           + sr/(1/4+g^2)
    f'(g) = (g-t)/(a^2+(g-t)^2) - g/(1/4+g^2)
           + (g+t)/(a^2+(g+t)^2) - g/(1/4+g^2) - 2 sr g/(1/4+g^2)^2
    """
    a = mpm.mpf("0.5") - sr
    q = g * g + mpm.mpf("0.25")
    return ((g - t) / (a * a + (g - t) ** 2) - g / q
            + (g + t) / (a * a + (g + t) ** 2) - g / q
            - 2 * sr * g / (q * q))


def e_win_s(sr, t, g2):
    """S-route window envelope (0274 g2-cut kernel shape):
    (Smax(t)+S0)*(|f(g2)| + (f(g2)-f(t-1))) + (Smax(t+1)+S0)*2|f(t+1)|."""
    S0 = Smax(GLAST)
    fG2 = kernel_mpf(sr, t, g2)
    ftm1 = kernel_mpf(sr, t, t - 1)
    ftp1 = kernel_mpf(sr, t, t + 1)
    part1 = (Smax(t) + S0) * (abs(fG2) + (fG2 - ftm1))
    part2 = (Smax(t + 1) + S0) * (2 * abs(ftp1))
    return part1 + part2, fG2, ftm1, ftp1


def raw_window_s(t):
    """Raw two-unit S-route window count N(t+1)-N(t-1)."""
    return 2 * dmain(t) + Smax(t + 1) + Smax(t - 1)


def full_envelope_s(sr, t, g1):
    """Full (g1, inf) S-route envelope:
    (Smax(t)+S0)*(|f(g1)| + TV1) + int_t^inf (Smax(g)+S0)*f'(g) dg
    (f increasing on [t, inf), f -> 0; f' > 0; f' ~ 2(-c4)/g^3)."""
    S0 = Smax(GLAST)
    fG = kernel_mpf(sr, t, g1)
    ft = kernel_mpf(sr, t, t)
    TV1 = fG - ft
    piece1 = (Smax(t) + S0) * (abs(fG) + TV1)
    # tail: quad [t, 4096t] + analytic-ish quad [4096t, 1e8 t] (decays ~ g^-3)
    g4 = 4096 * t
    h = lambda g: (Smax(g) + S0) * fprime_mpf(sr, t, g)
    tail1 = mpm.quad(h, [t, 4 * t, 64 * t, g4], limit=200)
    tail2 = mpm.quad(h, [g4, 16384 * t, 65536 * t], limit=200)
    # beyond 65536 t: |f'| <= 2(-c4)/g^3 (1 + O(1/t^2)); bound the remainder
    c4 = (mpm.mpf("0.5") - sr) ** 2 - mpm.mpf("0.25") - t * t + sr
    gfar = 65536 * t
    Sfar = Smax(gfar) + S0
    # int_gfar^inf 2(-c4)/g^3 dg = (-c4)/gfar^2 (c4 < 0); x(1+1e-6) safety
    rem = Sfar * ((-c4) / gfar ** 2) * (1 + mpm.mpf("1e-6"))
    return piece1 + tail1 + tail2 + rem, piece1, float(S0)


def main():
    print("0275 probe part 2: HSXW 2022 explicit per-unit laws (no data, no RH claim)")
    print(f"tPT2 = {TPT2} ; t3 = {float(T3):.6e} ; GLAST = {GLAST} ; g2 = gData = {GDATA}")
    print(f"Smax(GLAST) = {Smax(GLAST):.6f} ; E_hsxw(GLAST) = {E_hsxw(GLAST):.6f}")
    for t, tag in [(TPT2, "tPT2"), (T3, "t3")]:
        print(f"\n--- height {tag} = {float(t):.9g} ---")
        print(f"  dmain = {dmain(t):.6f} /unit ; E_hsxw(t) = {E_hsxw(t):.6f}")
        print(f"  B1_H (count law, /unit) = {B1_hsxw(t):.6f}   "
              f"(A0_cite route: {float(mpm.mpf('3.4') * mpm.log(t)):.6f}/unit)")
        print(f"  Smax(t) = {Smax(t):.6f} ; S-diff per unit = {2*Smax(t):.6f}")
        print(f"  raw 2-unit window count N(t+1)-N(t-1) <= {raw_window_s(t):.4f} "
              f"-> <= {int(raw_window_s(t))}")
        if tag == "tPT2":
            for i, sr in enumerate(SIGS):
                fluc = FLUC_TPT2[i]
                Ew34 = EWINS_TPT2[i]
                kernel34 = Ew34 / B1_CITE_TPT2
                EwS, fG2, ftm1, ftp1 = e_win_s(sr, t, GDATA)
                EwH = kernel34 * B1_hsxw(t)          # count-law kernel envelope
                EwS, fG2, ftm1, ftp1 = e_win_s(sr, t, GDATA)
                kcount = int((Ew34 - fluc) / FEDGE_TPT2[i]) if fluc < Ew34 else -1
                kS = int((EwS - fluc) / FEDGE_TPT2[i]) if fluc < EwS else -1
                kH = int((EwH - fluc) / FEDGE_TPT2[i]) if fluc < EwH else -1
                exclS = "EXCLUDED" if fluc + FEDGE_TPT2[i] > EwS else "open"
                print(f"  {SMNAME[i]}: fluc={fluc:.6f}  kernel34={float(kernel34):.4f}")
                print(f"      count-law(A0c): E_win={float(Ew34):.2f} k_max={kcount}  "
                      f"| count-law(HSXW): E_win={float(EwH):.2f} k_max={kH}")
                print(f"      S-route(HSXW):  E_win={float(EwS):.2f}  k_max={kS}  "
                      f"window {exclS}  (raw 2-unit S: <= {int(raw_window_s(t))})")
                Bfull, p1, S0 = full_envelope_s(sr, t, GLAST)
                print(f"      full S-route envelope = {float(Bfull):.2f}  "
                      f"|fluc|<=B: {'yes' if abs(fluc) <= Bfull else 'NO-!'}  "
                      f"(slack {float(abs(Bfull)-abs(fluc)):.2f})")
    print()
    # structural row at t3 (kernel from day075b output if present, else scale estimate)
    print("--- structural row (window exclusion under published per-unit S laws) ---")
    try:
        txt = open("out_day075b_cell_corrected.txt").read()
        rows = re.findall(
            r"^(\d\.\d+)\s*\|\s*([+\-]?\d[\d.,]*\d)\s*\|\s*([+\-]?\d[\d.,]*\d)\s*\|\s*"
            r"([+\-]?\d[\d.,]*\d)\s*\|\s*([+\-]?\d[\d.,]*\d)\s*\|\s*([+\-]?\d[\d.,]*\d)\s*\|\s*"
            r"([+\-]?\d[\d.,]*\d)\s*\|\s*([+\-]?\d[\d.,]*\d)\s*\|\s*\w+\s*\|\s*"
            r"([+\-]?\d[\d.,]*\d)\s*\|\s*([+\-]?\d[\d.,]*\d)\s*\|\s*([+\-]?\d[\d.,]*\d)\s*\|\s*"
            r"(-?\d+)\s*$",
            txt, re.M)
        B1t3 = mpm.mpf("3.4") * mpm.log(T3)
        print(f"  t3 rows parsed: {len(rows)}")
        for r in rows:
            # groups: 1 sigma,2 S,3 I_unk,4 -Rephi,5 K,6 B(t3),7 log|z|,8 fluc,
            #         9 B-fluc,10 E_win,11 fedge,12 k_max
            sm = mpm.mpf(r[0]); fl = mpm.mpf(r[7]); Ew = mpm.mpf(r[10]); fedge = mpm.mpf(r[11])
            k34 = int((Ew - fl) / (-fedge)) if fl < Ew else -1
            EwS, fG2, ftm1, ftp1 = e_win_s(sm, T3, GDATA)
            kS = int((EwS - fl) / (-fedge)) if fl < EwS else -1
            excl = "EXCLUDED" if fl + fedge > EwS else "open"
            print(f"  {sm}: fluc={float(fl):.3f}  E_win(A0c)={float(Ew):.1f} (k={k34})  "
                  f"E_win(S)={float(EwS):.1f} (k={kS})  window {excl}  "
                  f"raw 2-unit S <= {int(raw_window_s(T3))}")
    except FileNotFoundError:
        print("  t3 table not ready yet (day075b still running)")
        EwS_A = None
        for sm in SIGS:
            EwS_A, *_ = e_win_s(sm, T3, GDATA)
            break
        print(f"  S-route kernel envelope at t3 (kernel from 0274 g2 cut, HSXW Smax): "
              f"~ {float(EwS_A):.1f} (sigA) vs fluc ~ 158 estimate -> open; "
              f"raw 2-unit S <= {int(raw_window_s(T3))}")
    print()
    print("Conclusions (record):")
    print("  * HSXW 2022 Cor 1.2/1.4 are the first PUBLISHED explicit two-sided R-vM/S")
    print("    bounds valid at all T >= e (analytic above 3.061e10, database-verified")
    print("    below) -> they apply at tPT2 and t3 WITHOUT any in-repo data.")
    print("  * Count-law per unit at tPT2: 30.71/unit (3.18x sharper than 3.4*ln form).")
    print("  * S-route per-unit at tPT2: 2*Smax ~ 13.7/unit (sharpest certified).")
    print("  * Certified window count W=(tPT2-1,tPT2+1]: <= 22 (raw S-route, 8.9x below")
    print("    the 195 raw A0_cite count); kernel-refined k_max per sigma in table.")
    print("  * The 0274 '33/33/34/34' window count is RETRACTED (c4pin bias artifact:")
    print("    fluc was overstated by +8823.29; corrected fluc ~ 229 at tPT2).")
    print("  * Window exclusion at tPT2: NOT achieved under any published per-unit law;")
    print("    structural: E_win_S ~ (ln t)*kernel ~ (ln t)^2 growth vs t-frozen fluc.")
    print("  * Face at tPT2 and at t3: OPEN.  No RH claim.")


if __name__ == "__main__":
    main()
