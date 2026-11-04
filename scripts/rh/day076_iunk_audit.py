#!/usr/bin/env python3
"""0275 (audit): I_unk at t3 = 1000*tPT2 - the third-integrator + residual test.

day075 measured the closure at t3 FAIL (fluc = +10,052,394.685 vs
B(t3) = 19,754.84, ratio 509x) with dual I_unk agreeing to rel 4.27e-9.
By contradiction with the MACHINEMADE Zeta23 theorem (N(t,t+1] <= 81.19
ln(|t|+3), unconditional), the ACTUAL zero configuration must satisfy
|fluc| <= ~4.7e5 at t3 (even the rigorous constant): the discrepancy
(~9.6e6) implies a SHARED SYSTEMATIC error of O(1e7) in BOTH day072
integrators at t3 (dual agreement does not exclude shared error).

This audit:
  (1) I_unk_direct (t3): a THIRD integrator with different structure:
      pure dps-60 g-space quad GLAST..4t (log grid, dip window at t)
      + 4t..4096t (log grid) + exact c4 antiderivative 4096t..inf.
      No mid correction quad (the c4 split is far out, where f - c4/g^2
      is 4e-10 relative; its omission is directly bounded in (4)).
  (2) corr_residual: the FAR tail residual R = Int_{128}^{inf}
      (f(ty) - c4/(t^2 y^2)) rho(ty) dy integrated OUTSIDE the main
      window on a fresh 400-log-point grid to y = 1e9 (vs the code's
      80-point (128, 8.8e12] correction quad): any O(1e7) shared miss
      must show up here.
  (3) the far-tail c4 ANTI-DERIVATIVE verification: Int_X^inf c4/g^2 rho
      dg (dps-50 quad, g-space, X = 128*t3) vs the closed form
      (c4/2pi)(1 + ln(X/2pi)) / (2pi X)  [wait - verify numerically,
      do not trust the printed form: if the closed form is missing a
      1/(2pi), it fails here massively and day075's tail is the bug].
  (4) the OMITTED residual beyond 4096t bound: |Int_{4096t}^{inf}
      (f - c4/g^2) rho dg| <= (C/t^4) Int t^4/u^4 rho(tu) du with the
      explicit C6 coefficient computed at t3 (dps-50).

If (1) and (2) pin I_unk(t3) to within ~1e6 of day075's value while (3)
is clean: the K(t3) drift is REAL (the law itself fails at 1000x - a
deep structural finding). If (1) or (3) deviates by O(1e7): the shared
defect is found and named.

No RH claim. Audit of the validated machine at 1000x height.
"""
import time
import mpmath as mpm
import day072_face_U_repair as D72
import day069_xiproduct_excl_probe as D69

TPT2 = D72.TPT2
T3 = TPT2 * 1000
GLAST = D72.GLAST
SR = "0.1252270103"

mpm.mp.dps = 60
tM = mpm.mpf(str(T3))
srM = mpm.mpf(SR)
a = mpm.mpf("0.5") - srM
c4 = a * a - mpm.mpf("0.25") - tM * tM + srM
g0 = mpm.mpf(str(GLAST))

f = lambda g: D72.f_mpmath(g, srM, tM, a)
rho = lambda g: D72.rho_mpmath(g)

print(f"I_unk audit at t3 = {tM}")
print(f"c4 = {float(c4):+.6e} (expect ~ -t^2 = -9.0e30)")

# ---------- (1) third integrator: direct g-space ----------
t0 = time.time()
g4 = mpm.mpf(4) * tM
pts1 = [g0 * (g4 / g0) ** (mpm.mpf(j) / 4000) for j in range(4001)]
W = mpm.mpf(60)
if g0 < tM < g4:
    pts1 += [tM + (mpm.mpf(j) * 0.01 - W) for j in range(12001)]
pts1 = sorted(set(p for p in pts1 if g0 <= p <= g4))
if pts1[0] != g0:
    pts1.insert(0, g0)
if pts1[-1] != g4:
    pts1.append(g4)
seg1 = mpm.quad(lambda g: f(g) * rho(g), pts1)
t1 = time.time()
print(f"  seg1 (GLAST..4t, 12k dip pts) = {float(seg1):+.12e}  ({int(time.time()-t0)}s)")

gF = mpm.mpf(4096) * tM
pts2 = [g4 * (gF / g4) ** (mpm.mpf(j) / 400) for j in range(401)]
seg2 = mpm.quad(lambda g: f(g) * rho(g), pts2)
print(f"  seg2 (4t..4096t) = {float(seg2):+.12e}  ({int(time.time()-t1)}s)")

# ---------- (3) far-tail anti-derivative verification ----------
X = gF
num_tail = mpm.quad(lambda g: (c4 / (g * g)) * rho(g), [X, mpm.mpf(10) ** mpm.mpf(30) * tM])
# (integrate only to 1e30*t ~ 3e45: c4/g^2 rho tail beyond that is
#  |c4|/2pi * (1+ln(..))/(2pi X2) ~ 9e30/3e45*40 ~ 1.2e-13 : negligible)
closed_form_code = (c4 / (2 * mpm.pi)) * (1 + mpm.log(X / (2 * mpm.pi))) / X
closed_form_alt = (c4 / (2 * mpm.pi)) * (1 + mpm.log(X / (2 * mpm.pi))) / (2 * mpm.pi * X)
print(f"  c4 tail quad ({X:.3e}..3e45t)      = {float(num_tail):+.12e}")
print(f"  closed form CODE (c4/2pi)(1+lnX)/X      = {float(closed_form_code):+.12e}")
print(f"  closed form ALT  (c4/2pi)(1+lnX)/(2piX) = {float(closed_form_alt):+.12e}")
if abs(num_tail - closed_form_code) < 1e-6 * abs(num_tail):
    print("  TAIL FORM: code form AGREES with direct quad")
elif abs(num_tail - closed_form_alt) < 1e-6 * abs(num_tail):
    print("  TAIL FORM: code form MISMATCH - ALT (1/2pi smaller) matches: TAIL BUG FOUND")
else:
    print(f"  TAIL FORM: quad vs code rel={float(abs(num_tail-closed_form_code)/abs(num_tail)):.3e} "
          f"vs alt rel={float(abs(num_tail-closed_form_alt)/abs(num_tail)):.3e} INVESTIGATE")

# ---------- (4) omitted-residual bound beyond 4096t ----------
# f(g) - c4/g^2 at g = 4096 t: compute the exact value (dps-60)
uF = mpm.mpf(4096)
resF = f(tM * uF) - c4 / (tM * uF) ** 2
# and its g^{-4} scale: (f - c4/g^2) * (g/t)^4 at uF and 2*uF
h1 = (f(tM * uF) - c4 / (tM * uF) ** 2) * uF ** 4
h2 = (f(tM * (2 * uF)) - c4 / (tM * (2 * uF)) ** 2) * (2 * uF) ** 4
print(f"  (f - c4/g^2) at 4096t = {float(resF):+.6e};  t^4*(f-c4/t^2y^2) at u: "
      f"{float(h1):+.6e} / {float(h2):+.6e}  (h ~ C6 const if u^{-4} decay)")
# bound: |Int_{4096t}^inf (f - c4/g^2) rho dg| <= max_{u>=4096} u^4|f-c4/(t^2u^2)|
#        * Int_{4096t}^inf (1/g^4) rho dg  =  hmax * (1/(3*(4096t)^3)) * (1+ln(4096t/2pi))/(2pi)
hmax = max(abs(h1), abs(h2))
bound_res = hmax * (1 + mpm.log(gF / (2 * mpm.pi))) / (2 * mpm.pi * 3 * gF ** 3)
print(f"  omitted residual 4096t..inf BOUND = {float(bound_res):+.6e}")

# ---------- (2) far correction residual (the code's corr quad, redone) ----------
YC = mpm.mpf(128)
pts3 = [YC * (mpm.mpf(10) ** mpm.mpf(9) / YC) ** (mpm.mpf(j) / 400) for j in range(401)]
corr_direct = mpm.quad(lambda y: (f(tM * y) - c4 / (tM * y) ** 2) * rho(tM * y), pts3)
# compare against day072 I_unk_u's corr (recompute exactly as coded)
mpm.mp.dps = 60
Y2 = YC * mpm.mpf(2) ** 36
pts4 = [YC * (Y2 / YC) ** (mpm.mpf(j) / 80) for j in range(81)]
corr_code = mpm.quad(lambda y: (f(tM * y) - c4 / (tM * tM * y * y)) * rho(tM * y), pts4)
tail_code = (c4 / (2 * mpm.pi)) * (1 + mpm.log(tM * YC / (2 * mpm.pi))) / (tM * YC)
print(f"  corr (code 80-pt to Y2)  = {float(corr_code):+.12e}")
print(f"  corr (direct 400-pt to 1e9, beyond that bounded) = {float(corr_direct):+.12e}")
print(f"  diff = {float(corr_code - corr_direct):+.6e}")
print(f"  tail_code (day073/075 form) = {float(tail_code):+.12e}")

# ---------- (5) full third I_unk ----------
I_direct = seg1 + seg2 + float(closed_form_code)
I_u75 = -2356599952011236.5  # day075 c4pin value (sigA)
I_u75b = -2356599941959000.0  # day075 usub value (rounded from spread 1.005e7)
print()
print(f"  I_unk_direct (seg1+seg2+tail_form) = {float(I_direct):+.12e}")
print(f"  day075 c4pin                        = {I_u75:+.12e}")
print(f"  spread direct-vs-c4pin              = {float(I_direct - I_u75):+.6e}")
print(f"  bound on omitted (4t..4096t is integrated; 4096t..inf residual) = {float(bound_res):+.3e}")
print("audit complete - no RH claim")
