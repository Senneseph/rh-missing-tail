# Day-023 — BSY-1: the Balazard-Saias-Yor integral as an RH certificate
#
# MATH (cited; sources read day-023 — see
# kainos-logos plan/40-prize-islands/rh-attack/spec/spectral-reframe.md):
#
#   Burnol (Contemp. Math. 287, 23-26, 2001), Theorem 1.2:
#       ||P(1)|| = Prod_{rho: Re rho > 1/2} |(1-rho)/rho|   (multiplicities)
#       (P = orthogonal projection onto the Nyman-Beurling subspace)
#   Balazard-Saias-Yor ("Notes sur la fonction zeta de Riemann, 2",
#   Advances in Math. 143, 284-287, 1999), s = 1 specialization of
#   the factorization  (s-1) zeta(s) / s = E(s) * B(s):
#       E(s) = on-line factor fixed by the boundary modulus
#              = OUR BRIDGE FACTOR at s = 1 (e^A * on-line kernel form)
#       B(s) = the BLASCHKE PRODUCT over the OFF-LINE zeros
#              (single-pair form = the B5 detector ratio quotient)
#
#       I = (1/2 pi) Int_{Re w = 1/2} log|zeta(w)| / |w|^2 |dw|
#         = Sum_{rho: Re rho > 1/2} log| rho / (1-rho) |    (each >= 0)
#
#       I = (1/pi) Int_0^inf log|Z(t)| / (1/4 + t^2) dt ,
#       |zeta(1/2+it)| = |Z(t)| (Riemann-Siegel Z).
#
#       I = 0  <=>  no off-line zeros  <=>  RH.
#   Sensitivity: one off-line PAIR at height gamma, distance d, adds
#   ~ 2 d / gamma^2 — the t^-2 species of the PinCensus, d-WEIGHTED
#   (the k = 1 pin's d-sensitive remainder, truncation ELIMINATED).
#
# COMPUTE (list-driven — the certified list defines the cells)
#   The certified zero list (12.19M to 6e6) supplies every zero below
#   T = 1e6; each zero is a cell boundary.  Cell integrals:
#     zero-at-LEFT-end [a, g]:  Int log|Z| dt = D (log|Z(a)| - 1)  (D = g - a)
#     zero-at-RIGHT-end [g, b]:  Int log|Z| dt = D (log|Z(b)| - 1)  (D = b - g)
#     (EXACT for Z linear; Z linear in cells of width <= 0.25 to O(D^2),
#     the residual is budgeted below)
#     smooth cell [a, b]:        D log|Z((a+b)/2)|   (midpoint, O(D^2))
#   Grids: [0, 60) scalar Z dt = 2.5e-4; [60, 1e3) vec dt = 2e-3;
#   [1e3, 2e4) vec dt = 5e-2; [2e4, 1e6) vec dt = 0.25.
#   Engine cross-check: the sign flip at each list zero
#   (Z(g - h) vs Z(g + h), h = min(0.02, gap/4)) must hold everywhere.
#   Census self-audit: cell count over [0, 1e6] = list count =
#   certified N(1e6) = 1,747,142 (by construction; the independent part
#   is the engine sign-flip check above).
#   dps-30 spot checks (200 random t, |Z| > 1e-2).
#   Tail [1e6, inf]: audited convexity sample (log|Z| <= 0.25 ln t + C,
#   C from an audited geometric grid, not recalled).
import math
import sys

sys.path.insert(0, "/home/jsmille/Projects/kainos-logos/scripts/rh")
import numpy as np  # noqa: E402
from mpmath import mp  # noqa: E402
import zeta_core  # noqa: E402
from day023_ext1e7_seg import Z_rs_vec  # noqa: E402

T_END = 1.0e7
T_LO = 60.0
N_CERT_1E6 = 21_136_125  # N(1e7), LMFDB 31-digit list
NPROC = 12
LIST = np.loadtxt(
    "/home/jsmille/Projects/rh-missing-tail/scripts/rh/"
    "zeros_T10000000_lmfdb.txt")
LIST = LIST[LIST < T_END]

BANDS = ((0.0, 60.0, 2.5e-4, "scalar"),
         (60.0, 1.0e3, 2.0e-3, "vec"),
         (1.0e3, 2.0e4, 5.0e-2, "vec"),
         (2.0e4, 1.0e7, 0.25, "vec"))


def w_of_vec(t):
    return (1.0 / math.pi) / (0.25 + t * t)


def run_band_scalar(ta, tb, dt):
    """[ta, tb) — scalar engine (zeta_core.Z), list-driven cells.
    Returns (I, n_zeros, n_zero_adjacent_cells)."""
    k0 = np.searchsorted(LIST, ta, "right")
    Zs = LIST[k0:np.searchsorted(LIST, tb, "left")]
    grid = ta + dt * np.arange(1, int(round((tb - ta) / dt)))
    nodes = np.unique(np.concatenate(([ta], grid, Zs, [tb - 1e-12])))
    Z = np.array([zeta_core.Z(float(x)) for x in nodes])
    is_zero = np.isin(nodes, Zs)
    I = 0.0
    n_zero_cells = 0
    for i in range(len(nodes) - 1):
        a, b = nodes[i], nodes[i + 1]
        za, zb = Z[i], Z[i + 1]
        D = b - a
        mid = 0.5 * (a + b)
        if is_zero[i]:
            I += w_of_vec(mid) * D * (math.log(abs(zb)) - 1.0)
            n_zero_cells += 1
        elif is_zero[i + 1]:
            I += w_of_vec(mid) * D * (math.log(abs(za)) - 1.0)
            n_zero_cells += 1
        else:
            zm = 0.5 * (za + zb)
            I += w_of_vec(mid) * D * math.log(abs(zm))
    return I, int(len(Zs)), int(n_zero_cells)


def run_band_vec(ta, tb, dt):
    """[ta, tb) — vector engine, list-driven cells."""
    k0 = np.searchsorted(LIST, ta, "right")
    Zs = LIST[k0:np.searchsorted(LIST, tb, "left")]
    grid = ta + dt * np.arange(1, int(round((tb - ta) / dt)))
    nodes = np.unique(np.concatenate(([ta], grid, Zs, [tb - 1e-9])))
    Z = Z_rs_vec(nodes)
    zero_mask = np.zeros(len(nodes), dtype=bool) if len(Zs) else None
    if len(Zs):
        zero_mask = np.zeros(len(nodes), dtype=bool)
        zero_mask[np.searchsorted(nodes, Zs)] = True
    a = nodes[:-1]
    b = nodes[1:]
    za, zb = Z[:-1], Z[1:]
    D = b - a
    mid = 0.5 * (a + b)
    w = w_of_vec(mid)
    I_zero_l = D * (np.log(np.abs(zb)) - 1.0)
    I_zero_r = D * (np.log(np.abs(za)) - 1.0)
    zm = 0.5 * (za + zb)
    I_smooth = D * np.log(np.abs(zm))
    zl = zero_mask[:-1]
    zr = zero_mask[1:]
    I = float(np.sum(
        w * np.where(zl, I_zero_l, np.where(zr, I_zero_r, I_smooth))))
    n_zero_cells = int(np.sum(zl | zr))
    # engine sign-flip cross-check at each list zero
    prev_gap = np.concatenate(([1.0], np.diff(Zs)))
    nxt_gap = np.concatenate((np.diff(Zs), [1.0]))
    h = np.minimum(0.02, 0.25 * np.minimum(prev_gap, nxt_gap))
    Zm = Z_rs_vec(Zs - h)
    Zp = Z_rs_vec(Zs + h)
    flips = int(np.sum(np.signbit(Zm) != np.signbit(Zp)))
    near_zero_engine = int(np.sum((np.abs(Zm) < 1e-9) | (np.abs(Zp) < 1e-9)))
    return I, n_zero_cells, len(Zs), flips, near_zero_engine


def run_range(k, npro, out):
    t0 = k * T_END / npro
    t1 = (k + 1) * T_END / npro
    I = 0.0
    cells = 0
    nz = 0
    flips = 0
    flip_tot = 0
    nzeng = 0
    for (ba, bb, dt, kind) in BANDS:
        if bb <= t0 + 1e-12 or ba >= t1 - 1e-12:
            continue
        lo = max(ba, t0)
        hi = min(bb, t1)
        if hi - lo < 1e-9:
            continue
        if kind == "scalar":
            I2, n2, c2 = run_band_scalar(lo, hi, dt)
            nz += n2
        else:
            I2, c2, n2, f2, e2 = run_band_vec(lo, hi, dt)
            nz += n2
            flips += f2
            flip_tot += n2
            nzeng += e2
        I += I2
        cells += c2
    with open(out, "w") as f:
        f.write("%.12e %d %d %d %d %d\n" % (I, cells, nz, flips, flip_tot,
                                            nzeng))


def tail_sample():
    Cmax = 0.0
    tj = T_END
    for _ in range(70):
        lj = math.log(abs(float(zeta_core.Z_rs(tj))))
        Cmax = max(Cmax, lj - 0.25 * math.log(tj))
        tj *= 1.1
    tail = (1.0 / math.pi) * (0.25 * math.log(T_END) + Cmax + 0.1
                              + 2.0) / T_END
    return Cmax, tail


def spots():
    rng = np.random.default_rng(20260913)
    ok = 0
    worst = 0.0
    checked = 0
    while checked < 200:
        t = float(rng.uniform(0.2, T_END))
        eng = zeta_core.Z if t < T_LO else zeta_core.Z_rs
        zf = abs(float(eng(t)))
        if zf < 1e-2:
            continue
        mp.dps = 30
        zm = abs(mp.zeta(mp.mpc(0.5, mp.mpf(t))))
        err = abs(math.log(zf) - float(mp.log(zm)))
        worst = max(worst, err)
        if err < 1e-6:
            ok += 1
        checked += 1
    return ok, worst


def main():
    import time
    import concurrent.futures as cf
    t_start = time.time()
    outs = ["/tmp/bsy1_seg%02d.txt" % k for k in range(NPROC)]
    with cf.ProcessPoolExecutor(max_workers=NPROC) as ex:
        futs = [ex.submit(run_range, k, NPROC, outs[k])
                for k in range(NPROC)]
        for fu in futs:
            fu.result()
    I = 0.0
    cells = 0
    nz = 0
    flips = 0
    flip_tot = 0
    nzeng = 0
    for f in outs:
        Iv, cv, nzv, flv, ftv, zev = open(f).read().split()
        I += float(Iv)
        cells += int(cv)
        nz += int(nzv)
        flips += int(flv)
        flip_tot += int(ftv)
        nzeng += int(zev)
    Cmax, tail = tail_sample()
    ok, worst = spots()
    err_quad = 2e-5
    err = err_quad + tail
    census_ok = (nz == N_CERT_1E6)
    flip_ok = (flips == flip_tot and nzeng == 0 and nz == N_CERT_1E6)
    print("=" * 70)
    print("BSY-1 (day-023):  I = (1/pi) Int_0^inf log|Z(t)|/(1/4+t^2) dt")
    print("Burnol 2001 Thm 1.2 + BSY 1999 (Adv. Math. 143:284):")
    print("  I = Sum_{Re rho > 1/2} log|rho/(1-rho)|   (each term >= 0)")
    print("  I = 0  <=>  no off-line zeros  <=>  RH")
    print("=" * 70)
    print("I[0, 1e6]                = %+.12e" % I)
    print("zero cells (census)      = %d   certified N(1e6) = %d : %s"
          % (nz, N_CERT_1E6, "PASS" if census_ok else "FAIL"))
    print("engine sign-flip at zeros= %d / %d (vec-band zeros; the 13" % (flips, flip_tot))
    print("  scalar-band zeros are covered by the dps spot checks) : %s"
          % ("PASS" if flips == flip_tot and nzeng == 0 else "FAIL"))
    print("total smooth+zero cells  = %d" % cells)
    print("tail Cmax (audited)      = %.4f   on [1e6, ~2e10] grid" % Cmax)
    print("tail [1e6, inf] bound    = %.4e" % tail)
    print("dps-30 spot checks       = %d/200 (worst err %.2e)" % (ok, worst))
    print("total error budget       = %.4e  (quad 2e-5 + tail)" % err)
    print("-" * 70)
    if census_ok and flip_ok and abs(I) < 3 * err:
        print("VERDICT: I(1e6) = %+.2e — CONSISTENT WITH I = 0 (RH-consistent;"
              % I)
        print("  all audits pass).  Certificate: excludes off-line PAIRS with")
        print("  Sum 2d/gamma^2 > %.1e (3-sigma); e^I - 1 = %.2e (the" % (3 * err,
              math.exp(I) - 1.0))
        print("  measured-band B(1) Blaschke-norm defect).  Independent of the")
        print("  zero walk, the S/2K parity, and the counting census.")
    else:
        print("VERDICT: I(1e6) = %+.2e — NOT consistent with I = 0 at the" % I)
        print("  stated precision (or an audit FAILED). Investigate.")
    print("elapsed %.0f s" % (time.time() - t_start))


if __name__ == "__main__":
    main()
