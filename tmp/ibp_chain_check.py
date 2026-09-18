import mpmath as mp
mp.mp.dps = 50

def B2(u): return u*u - u + mp.mpf(1)/6
def B8(u):
    return (u**8 - 4*u**7 + mp.mpf(14)/3*u**6 - mp.mpf(7)/3*u**4
            + mp.mpf(2)/3*u**2 - mp.mpf(1)/30)

def frac(x): return x - mp.floor(x)

t = mp.mpf(20)
s = mp.mpf(1)/2 + t*1j
n = mp.mpf(2)
M = mp.mpf(400)
step = mp.mpf('0.002')

def integ(f, a, b):
    N = int(mp.ceil((b-a)/step))
    h = (b-a)/N
    tot = mp.mpc(0.5)*(f(a)+f(b))
    for k in range(1, N):
        tot += f(a+k*h)
    return tot*h

J  = integ(lambda x: mp.mpc(B2(frac(x))) * mp.mpc(x)**(-s-2), n, M)
J8 = integ(lambda x: mp.mpc(B8(frac(x))) * mp.mpc(x)**(-s-8), n, M)
one = mp.mpc(1)

# candidate A: hand-derived 4-step chain (boundaries 1/120, -1/5040, 1/201600)
I4 = mp.mpc(1)/201600*n**(-s-7) + (s+7)/6720*J8
I3 = -one/5040*n**(-s-5) + (s+5)/120*I4
I2 = (s+4)/20*I3
I1 = one/120*n**(-s-3) + (s+3)/4*I2
candA = (s+2)/3*I1

# candidate B: anchor-coefficient form (from F1): T3 = -1/2 s(s+1) J,
# anchor: T3 = -S2 n^{-s-3}/720 + S4 n^{-s-5}/30240 - S6 n^{-s-7}/1209600
#         - S6(s+7)/40320 I8.  Solve for J.
S2 = s*(s+1)*(s+2)
S4 = S2*(s+3)*(s+4)
S6 = S4*(s+5)*(s+6)
anchT3 = -S2*n**(-s-3)/720 + S4*n**(-s-5)/30240 - S6*n**(-s-7)/1209600 \
         - S6*(s+7)*J8/40320
candB = anchT3/(-one/2*s*(s+1))

T3num = -one/2*s*(s+1)*J
print("J       =", J)
print("candA   resid =", abs(J-candA))
print("candB   resid =", abs(J-candB))
print("T3num   =", T3num)
print("anchT3  resid =", abs(T3num-anchT3))
print("ratio candA/candB =", candA/candB)
