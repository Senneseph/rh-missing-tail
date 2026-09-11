"""day014: dps-45 principal-arg 2K tests of the M3 candidates.

Arbiter for delta = 244 vs 246 (the two differ by 2, i.e. by a whole 2*pi
turn of Arg_cont(zeta) — invisible to any float test, to the defective
walk's own S, and to mp.arg(mp.gamma(...)) principal values).

Formula (same as day003_s_arg_mpmath.py, which it generalizes):
    2K = (N - main + 1) - ph/pi   must be an EVEN integer
where ph = PRINCIPAL arg of zeta(1/2+it) and main = x log x - x - 0.125,
x = t/(2pi). Computed in dps so that (N - main + 1) - ph/pi is known to
~1e-11: the even integer is then pin-pointed and N uniquely determined.

Reads "t N" candidate pairs from stdin, prints one verdict line each.
Run:  docker run --rm -i -v "$PWD":/work kainos-dev:dev \
        sh -c "pip -q install mpmath; python3 /work/day014_dps45_arg1e7.py"
"""
import math
import sys

from mpmath import mp

mp.dps = 45

for line in sys.stdin:
    line = line.strip()
    if not line:
        continue
    t_str, n_str = line.split()
    t = float(t_str)
    n = int(n_str)
    ph = mp.arg(mp.zeta(mp.mpf("0.5") + mp.j * mp.mpf(t_str)))
    x = t / (2 * math.pi)
    main = x * math.log(x) - x - 0.125
    s = n - main  # day003 convention: N = main + S
    two_k = (n - main + 1.0) - float(ph) / math.pi
    dist_even = two_k - 2.0 * round(two_k / 2.0)
    verdict = ("EVEN, dist %.3e" % abs(dist_even)) if abs(dist_even) < 1e-6 else \
              ("NOT EVEN, dist-to-even %.6f" % dist_even)
    print("t=%.0f N=%d  ph/pi=%.12f  main=%.6f  2K=%.9f  %s  S=%.6f"
          % (t, n, float(ph) / math.pi, main, two_k, verdict, s))
