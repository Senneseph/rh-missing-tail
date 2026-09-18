import mpmath as mp
mp.mp.dps = 40

def Bk(u, k):
    P = {
        2: lambda u: u*u - u + mp.mpf(1)/6,
        3: lambda u: u**3 - (mp.mpf(3)/2)*u**2 + (mp.mpf(1)/2)*u,
        4: lambda u: u**4 - 2*u**3 + u**2 - mp.mpf(1)/30,
        5: lambda u: u**5 - (mp.mpf(5)/2)*u**4 + (mp.mpf(5)/3)*u**3 - (mp.mpf(1)/6)*u,
        6: lambda u: u**6 - 3*u**5 + (mp.mpf(5)/2)*u**4 - (mp.mpf(1)/2)*u**2 + mp.mpf(1)/42,
        7: lambda u: u**7 - (mp.mpf(7)/2)*u**6 + (mp.mpf(7)/2)*u**5 - (mp.mpf(7)/6)*u**3 + (mp.mpf(1)/6)*u,
        8: lambda u: (u**8 - 4*u**7 + (mp.mpf(14)/3)*u**6 - (mp.mpf(7)/3)*u**4
                      + (mp.mpf(2)/3)*u**2 - mp.mpf(1)/30),
    }
    return P[k](u)

t = mp.mpf(20)
s = mp.mpf(1)/2 + t*1j
n0 = 2
M0 = 30   # only 28 periods: tail past 30 is ~30^-8.5*... tiny; and I_k ~ n^-k-0.5 scale

def I_k(k, a, b):
    # per-period quad: smooth on each [j, j+1] endpoint-inclusive
    tot = mp.mpc(0)
    for j in range(a, b):
        f = lambda x, j=j, k=k: mp.mpc(Bk(mp.mpf(x-j), k)) * mp.mpc(x)**(-s-k)
        tot += mp.quad(f, [j, j+1])
    return tot

one = mp.mpc(1)
res = {}
for k in range(2, 9):
    I = {}
    for kk in range(k, 9):
        I[kk] = I_k(kk, n0, M0)
    # IBP: I_k = B_{k+1}(0)/(k+1)*(M^{-s-k} - n^{-s-k}) + (s+k)/(k+1)*I_{k+1}   [B_{k+1}({n})=B_{k+1}(0), B_{k+1}({M})=B_{k+1}(0)]
    bk1 = Bk(mp.mpf(0), k+1)
    rhs = bk1/(k+1)*(mp.mpf(M0)**(-s-k) - mp.mpf(n0)**(-s-k)) + (s+k)/(k+1)*I[k+1]
    res[k] = abs(I[k] - rhs)
    print(f"step k={k}: resid = {res[k]}   |I_k| = {abs(I[k])}")

# now solve for the TRUE effective n-boundary coefficient at step k:
#   I_k = c_k * n^{-s-k} + (s+k)/(k+1) * I_{k+1}   (ignore M term, tiny but subtract it)
print()
for k in range(2, 9):
    I = {}
    for kk in range(k, 9):
        I[kk] = I_k(kk, n0, M0)
    bk1 = Bk(mp.mpf(0), k+1)
    Mterm = bk1/(k+1)*mp.mpf(M0)**(-s-k)
    d = I[k] - (s+k)/(k+1)*I[k+1] + Mterm
    c = d / mp.mpf(n0)**(-s-k)
    pred = -bk1/(k+1)
    print(f"k={k}: solved c_k = {c}   predicted -B({k+1})(0)/{(k+1)} = {pred}   resid = {abs(c-pred)}")
