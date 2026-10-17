import mpmath as mp
t = 15000522999990989000  # 5e8G f64 exact int
a, n = 1, 10**7
for prec in (60, 77, 100, 143, 200, 400):
    mp.mp.prec = prec
    s = mp.mpc(0, t)
    xs, ys = mp.mp._zetasum_fast(s, a, n, [0], False)
    v = xs[0]
    print("prec=%3d  S1_partial(1..1e7) = (%.14f, %.14f)"
          % (prec, float(mp.re(v)), float(mp.im(v))), flush=True)
