# Persisted from /tmp/e7a_action.py (day-006, re-runnable E7a identity check).
# Regenerates out_day006_euler_action_identity.txt pattern (5/5, dps-50).
from mpmath import mp
mp.dps = 50

def chi5(n):
    r = n % 5
    return {1: mp.mpf(1), 2: mp.mpf(-1), 3: mp.mpf(-1), 4: mp.mpf(1), 0: mp.mpf(0)}[r]

A = lambda n: sum(chi5(k) for k in range(1, n + 1))  # exact path (small n only)

def action_identity(a, N, M, s, label):
    t_ = a if callable(a) else lambda n: a[n]
    path = {}
    def Aof(n):
        if n not in path:
            path[n] = sum(t_(j) for j in range(1, n + 1))
        return path[n]
    lhs = sum(t_(n) * n ** (-s) for n in range(N + 1, M + 1))
    integral = mp.fsum(Aof(m) * (m ** (-s) - (m + 1) ** (-s)) / s for m in range(N, M))
    rhs = Aof(M) * M ** (-s) - Aof(N) * N ** (-s) + s * integral
    print(f"{label}: LHS-RHS = {mp.nstr(lhs - rhs, 6)}   (N={N}, M={M})")

s = mp.mpf("0.5") + 10 * mp.j
# chi_5 path, N=3, M=133 (26 full periods from N: 133-3 = 130 = 26*5)
action_identity(chi5, 3, 133, s, "chi5 t=10")
s2 = mp.mpf("0.5") + 100 * mp.j
action_identity(chi5, 7, 307, s2, "chi5 t=100")
s3 = mp.mpf("0.5") + 1 * mp.j
action_identity(chi5, 12, 1012, s3, "chi5 t=1")

# random +-1 path (tests flatness for a generic, non-periodic path)
def rnd(n):  # deterministic LCG pseudo-random, ±1
    x = (n * 2654435761) % 4294967296
    return mp.mpf(1 if (x >> 16) % 2 == 0 else -1)
action_identity(rnd, 7, 1007, mp.mpf("0.5") + 10 * mp.j, "random +-1 t=10")
action_identity(rnd, 1, 100, mp.mpf("2.5") + 30 * mp.j, "random +-1 t=30 s=2.5+30i")
