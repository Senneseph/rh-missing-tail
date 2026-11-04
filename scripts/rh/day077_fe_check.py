#!/usr/bin/env python3
"""0275: functional-equation audit of L = log|zeta(s)| at t3 = 1000*tPT2.

day075 measured the xi-product closure at t3 FAIL:
  fluc = L - K' = +10,052,394.685  vs  B(t3) = 19,754.84 (A0 = 3.4)
  (rigorous Zeta23 constant A0_rig = 81.19 would give B_rig ~ 4.7e5:
   still 21x below fluc).
The Zeta23 local-count theorem is machine-checked and UNCONDITIONAL, so
the actual zero configuration MUST satisfy the law. Hence the measured
fluc carries a ~1e7 systematic error in ONE of:
  (a) L     = log|zeta(s)|  (mpmath Riemann-Siegel at 3e15, dps-40)
  (b) S     = sum over known zeros (float64, est. error < 0.2)
  (c) I_unk = unknown-side main term (dual integrators agree to rel
      4.27e-9 = ABS 1.0e7  <-- shared-model-error suspect)
  (d) phi   = Re log[0.5 s (s-1) pi^{-s/2} Gamma(s/2)] (dps-60 mp)

This script tests (a) decisively:
  FE identity:  log|zeta(s)| + log|zeta(1-s)|
      = Re s ln2 + Re(s-1) ln pi + log|sin(pi s/2)| + Re log Gamma(1-s)
  with log|sin(pi s/2)| = pi*t/2 - ln 2 to dps (correction e^{-2 pi t}).

If L40 ~ L60 and FE closes to < 1e-3: L is SOLID, the ~1e7 error is in
K' (suspect I_unk shared model), proceed to a third independent I_unk
integrator + onset-height bisection.
If FE fails by O(1e7): mpmath's R-S/Laguerre at 3e15 is the culprit.
No RH claim. Audit only.
"""
import time
import mpmath as mpm

TPT2 = 3000175332800
T3 = TPT2 * 1000
SR = "0.1252270103"
T = mpm.mpf(str(T3))
SRM = mpm.mpf(SR)

def audit(dps):
    mpm.mp.dps = dps
    s = SRM + 1j*T
    t0 = time.time()
    L = mpm.re(mpm.log(mpm.zeta(s)))
    dt = time.time() - t0
    L1ms = mpm.re(mpm.log(mpm.zeta(1 - s)))
    dt2 = time.time() - t0
    # FE right-hand side
    C = (SRM * mpm.log(2)
         + (SRM - 1) * mpm.log(mpm.pi)
         + (T / 2) * mpm.pi - mpm.log(2)      # log|sin(pi s/2)|, corr ~ e^{-2 pi t}
         + mpm.re(mpm.loggamma(1 - s)))
    return float(L), float(L1ms), float(C), dt, dt2

print("t3 =", T3, " sigma =", SR)
L40, L40b, C40, t40, t40b = audit(40)
L60, L60b, C60, t60, t60b = audit(60)
print(f"dps-40:  L       = {L40:+.10f}   ({t40:.0f}s)")
print(f"dps-40:  L(1-s)  = {L40b:+.10f}   ({t40b-t40:.0f}s more)")
print(f"dps-40  FE resid = {L40 + L40b - C40:+.4e}")
print(f"dps-60:  L       = {L60:+.10f}   ({t60:.0f}s)")
print(f"dps-60:  L(1-s)  = {L60b:+.10f}   ({t60b-t60:.0f}s more)")
print(f"dps-60  FE resid = {L60 + L60b - C60:+.4e}")
print(f"L40 - L60        = {L40 - L60:+.4e}")
print(f"day075 L (sigmaA) = +11.991412 (reprint for comparison)")
print("FE test done - no RH claim")
