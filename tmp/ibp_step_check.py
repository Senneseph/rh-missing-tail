import mpmath as mp
mp.mp.dps = 50

def Bk(u, k):
    # Bernoulli polynomial B_k(u) for k up to 8 (standard, B2 = u^2-u+1/6)
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

def frac(x): return x - mp.floor(x)

t = mp.mpf(20)
s = mp.mpf(1)/2 + t*1j
n = mp.mpf(2)
M = mp.mpf(400)
step = mp.mpf('0.001')   # 1000 pts/period for a cleaner floor

def integ(f, a, b):
    N = int(mp.ceil((b-a)/step))
    h = (b-a)/N
    tot = mp.mpc(0.5)*(f(a)+f(b))
    for k in range(1, N):
        tot += f(a+k*h)
    return tot*h

I = {}
for k in range(2, 9):
    I[k] = integ(lambda x, k=k: mp.mpc(Bk(frac(x), k)) * mp.mpc(x)**(-s-k), n, M)

one = mp.mpc(1)
print("step1: I2  vs  (s+2)/3 * I3:")
print("  resid:", abs(I[2] - (s+2)/3*I[3]))
print("step2: I3  vs  -B4(0)/4*n^{-s-3} + (s+3)/4*I4:")
print("  resid:", abs(I[3] - (mp.mpf(1)/30/4)*n**(-s-3) + (s+3)/4*I[4]))
print("        [sign check: -B4(0)/4 = +1/120]")
print("step3: I4  vs  -B5(0)/20*n^{-s-4} + (s+4)/20*I5:")
print("  resid:", abs(I[4] - (mp.mpf(0)/20)*n**(-s-4) + (s+4)/20*I[5]))
print("step4: I5  vs  -B6(0)/120*n^{-s-5} + (s+5)/120*I6:")
print("  resid:", abs(I[5] - (-mp.mpf(1)/42/120)*n**(-s-5) + (s+5)/120*I[6]))
print("step5: I6  vs  -B7(0)/840*n^{-s-6} + (s+6)/840*I7:")
print("  resid:", abs(I[6] - (mp.mpf(0)/840)*n**(-s-6) + (s+6)/840*I[7]))
print("step6: I7  vs  -B8(0)/6720*n^{-s-7} + (s+7)/6720*I8:")
print("  resid:", abs(I[7] - (mp.mpf(1)/30/6720)*n**(-s-7) + (s+7)/6720*I[8]))
print()
print("|I2| =", abs(I[2]), " |I3| =", abs(I[3]), " |I4| =", abs(I[4]))
print("|I5| =", abs(I[5]), " |I6| =", abs(I[6]), " |I7| =", abs(I[7]))
# boundary-value sanity
for k in range(2, 9):
    print(f"B{k}(0) = {Bk(mp.mpf(0), k)}   B{k}(1) = {Bk(mp.mpf(1), k)}")
