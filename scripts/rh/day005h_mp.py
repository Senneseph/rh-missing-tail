
import sys
from mpmath import mp
mp.dps = 45
for line in sys.stdin:
    line = line.strip()
    if not line:
        continue
    t, N = line.split()
    tv = mp.mpf(t)
    g = mp.arg(mp.gamma(0.25 + tv/2*mp.j)) - tv/2*mp.log(mp.pi)
    main_ = mp.floor(tv/(2*mp.pi)*mp.log(tv/(2*mp.pi)) - tv/(2*mp.pi) + mp.mpf("0.25"))
    twoK = (mp.mpf(N) - main_ + 1) - g/mp.pi
    twoK_even = twoK - 2*mp.floor(twoK/2 + mp.mpf("0.5"))
    S = mp.mpf(N) - (main_ - 1 + g/mp.pi)
    print(f"t={t} N={N}:  2K = {mp.nstr(twoK, 22)}  (dist-to-even-integer = {mp.nstr(twoK_even, 8)})  S = {mp.nstr(S, 16)}")
