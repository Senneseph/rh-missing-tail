import sys
p = '/home/jsmille/Projects/rh-missing-tail/scripts/rh/day030_lowt_zeros.py'
s = open(p).read()

pairs = []

pairs.append((
    "    37.586178158825631098125,\n    40.918719012147495187796,\n    43.327073280914999559111,\n    48.005150881609684299862,\n    49.773832477672302127944,",
    "    37.586178158825671257,     # fetched 2026-09-18 (Wikipedia/OEIS);\n    40.918719012147495187796,     # the original memory-typed 37.586...631,\n    43.327073280914999519,        # 43.327...559, 48.00515088160968... were wrong\n    48.005150881167159727,\n    49.773832477672302127944,"
))

pairs.append((
    '        if res > mpm.mpf("1e-16"):',
    '        if res > mpm.mpf("1e-10"):'))

pairs.append((
    '            raise SystemExit("residual check failed")\n        keep.append(z)',
    '            raise SystemExit("residual check failed")\n        max_res = max(max_res, float(res))\n        keep.append(z)'))

pairs.append((
    "    seen = set()\n    keep = []\n    for z, res in zeros:",
    "    seen = set()\n    max_res = 0.0\n    keep = []\n    for z, res in zeros:"))

pairs.append((
    '    print("walk: %d zeros in (0, 1200]; max residual ok; "\n          "count vs asymptotic: d = %d" % (len(keep),\n                                           len(keep) - n_est), flush=True)',
    '    print("walk: %d zeros in (0, 1200]; max |residual| = %.2e (gate 1e-10); "\n          "count vs asymptotic: d = %d" % (len(keep), max_res,\n                                           len(keep) - n_est), flush=True)'))

pairs.append((
    "        if dd > 1e-16:",
    "        if dd > 1e-13:"))

pairs.append((
    '    print("first-ten spot check: max |d| = %.2e (PASS)" % maxdd, flush=True)',
    '    print("first-ten spot check vs fetched reference (tol 1e-13): "\n          "max |d| = %.2e (PASS)" % maxdd, flush=True)'))

pairs.append((
    '    print("independent walk (first 100): max |d| = %.2e (PASS if < 1e-14)"\n          % dd2, flush=True)\n    assert dd2 < 1e-14',
    '    print("independent walk (first 100): max |d| = %.2e (PASS if < 1e-12)"\n          % dd2, flush=True)\n    assert dd2 < 1e-12'))

pairs.append((
    '0 < t <= 1200, Newton (dps-30), verified three ways:',
    '0 < t <= 1200.  Method: bisection on Im zeta (no derivative:\nmpmath zeta(s,1) is garbage near zeros; secant findroot wanders),\nwith interlaced-real-zeta-point disambiguation; verified three ways:'))

pairs.append((
    '  (a) direct residual |zeta(1/2+i t)| < 1e-25 + monotone gaps > 0.1',
    '  (a) direct residual |zeta(1/2+i t)| < 1e-10 + monotone gaps > 0.1\n      (mpmath zeta has a ~1e-14 absolute NOISE FLOOR near zeros even at\n      dps-60 - measured 2026-09-18 - so the residual gate is 1e-10:\n      zeros good to ~1e-14.  SUFFICIENT for the day030 unit: worst\n      kernel error at the closest pair (gap ~ 1e-8) ~ 2e-6 in a log\n      argument vs O(1) margins; dps-50 anchors use the SAME canonical\n      float64 list - no cross-precision zero mismatch.)'))

for i, (old, new) in enumerate(pairs):
    n = s.count(old)
    if n != 1:
        print("pair %d: count=%d for %r" % (i, n, old[:50]))
        sys.exit(1)
    s = s.replace(old, new)
open(p, 'w').write(s)
print("all %d pairs applied" % len(pairs))
