# W2 Lean plan — the one-sided defect bound (day035, 2026-09-19)

Status: SPEC (written before the Lean work begins).  This is the
formalization target for END_GAME_PLAN 3.6 item 3.  It is the
certificate-essential piece: a LOWER bound on the band-local
defect

    W(t) := sum_{gamma in (G1,G2]} p(g;t) - int_{G1}^{G2} p(g;t) rho(g) dg,

with the real Efull kernel (day023/day029 verbatim)

    p(g;t) = log|g-t| + log(g+t) - log(g^2 + 1/4) + 0.5/(g^2 + 1/4),
    rho(g) = log(g/(2pi))/(2pi),
    N_asym(x) = (x/(2pi)) log(x/(2pi)) - x/(2pi) + 7/8,
    (d/dx N_asym) = rho(x) + 1/(2pi)),

on a FINITE, SORTED, EXPLICIT zero partition  G1 = x_0 < x_1 < ... <
x_M = G2  with t NOT a partition point (the certificate always has
min |gamma - t| bounded away from 0 by the straddle grid: |t-g| is a
half-integer >= 1/2 ... on the quantized straddle grid).

## 0. Online-first survey result (2026-09-19, per owner directive)

SEARCHED ONLINE FIRST.  Prior art found and to be CITED (borrowed
with citation per owner policy; logs make attribution auditable):

- **anthropics/zeta-23-lean** (GitHub, 2026; static research
  artifact, "not maintained, not accepting contributions").
  * `Zeta23/RvM/Statement.lean`: the `RiemannVonMangoldt`
    structure on an abstract `ZeroConfig`, assembled for
    Mathlib's zeta from `rvM_main` (MainTerm.lean) +
    `zetaZeroConfig_local_count` (LocalCount.lean).
  * `Zeta23/RvM/LocalCount.lean`:  **N(t, t+1] <= A_0 log(|t|+3)
    for all real t** (= Titchmarsh Thm 9.2; the disc-argument
    route via `Zeta23.ZeroConfig.N_le_two_mul_half` /
    Halving.lean / Jensen-type `ZerosBound`).
  * `Zeta23/ExplicitFormula.lean` + `Hypotheses.lean`: Weil EF
    in paper form, the `H-EF`/`H-RvM` hypothesis records.
  Use: Zeta23 is the CITED source of the counting statement
  (RH-level |DN| = O(log t) control) for the BEYOND-BAND
  generalization.  We do NOT vendor their files into this
  pinned 4.33.1 build in this step (static artifact, own
  toolchain pin; adoption is a separate decision); we CITE and
  take `K := sup|DN|` as an explicit numeric INPUT to our
  theorem (the honest split: PINNED = 2.503 on
  (1e7, 2.0e9] via S3b/S3d data; CITED = Zeta23-RvM/Backlund
  class beyond).
- Other community RH repos found (RDCbum/RH_demo, jrgochan/prime
  "Cathedral", motanova84/Riemann-adelic, beanapologist/RH,
  alejandrozu/RiemannHypothesis-Formalization,
  zach7036/riemann-hypothesis-research, Alektronnik/M4TH):
  noted for the provenance log; none directly re-used in this
  step.

## 1. The exact statements (to prove in Lean)

### 1.1 Kernel algebra (all exact, no data)

  (K1)  p' decomposition: for g != t,
        p'(g) = 1/(g-t) + q(g),
        q(g) = 1/(g+t) - 2g/(g^2 + 1/4) - g/(g^2 + 1/4)^2.
  (K2)  p strictly INCREASING on (t, G2] and strictly DECREASING
        on [G1, t):  sign of p'(g):
          for g > t:  2g/(g^2-t^2) > 2g/(g^2+1/4) + g/(g^2+1/4)^2
          iff  2(t^2 + 1/4)(g^2 + 1/4) > g^2 - t^2   [crossed]
          iff  2 t^2 g^2 + (3/2) t^2 + 1/2 > 0       TRUE;
          for g < t:  p'(g) < 0  (same algebra, g^2 - t^2 < 0).
  (K3)  N_asym is C^1 on (0, infty), N_asym' = rho + 1/(2pi);
        for x in [G1, G2] (G1 >= 1e7):  0 < N_asym'(x) <= L,
        L := ((log(G2/(2pi)) + 1)/(2pi))  (explicit).
  (K4)  the log-telescoping: for the partition,
        sum_j (log|x_{j+1} - t| - log|x_j - t|)
          = log|G2 - t| - log|G1 - t|.

### 1.2 The telescope (the identity; exact algebra on the partition)

  Define (partition data, NO integrals yet):
      N(x_j) := absolute count at x_j  (N(x_j) = N(x_{j-1}) + 1
                  at each interior zero; x_0 = G1 boundary count
                  N0; the S3b left-endpoint convention),
      DN(x_j) := N(x_j) - N_asym(x_j),
      S1 := sum_j' p(x_j)   (sum over the DATA zeros only,
                  i.e. x_1..x_{M} if x_0 = G1 is the boundary),
      Dc := sum_j DN(x_j) * (p(x_{j+1}) - p(x_j)),
      B  := p(G2)*DN(G2) - p(G1)*DN(G1),
      NasSum := sum_j N_asym(x_j) * (p(x_{j+1}) - p(x_j)).
  (T1)  (the Stieltjes IBP, finite-sum form — S3b GATE0):
          S1 = p(G2)*N(G2) - p(G1)*N0 - sum_j N(x_j)*(p(x_{j+1})-p(x_j)).
  (T2)  (smooth side, finite-sum form):
          R := p(G2)*Nas(G2) - p(G1)*Nas(G1) - NasSum.
  (T3)  W_gap := S1 - R  =  (B - Dc) + (I_np - NasSum),  where
          I_np := the gap-sum of N_asym p' (defined in 1.3);
          equivalently (S3c's main result):
      (T4)  S1 - R = B - I_DN,
          I_DN := the gap-sum of DN p' (1.3):  the Dc cancels.
  (All T's are FINITE-SUM identities — no integrals, no limits.)

### 1.3 The integral side (per-gap, singular-free)

  For each gap j, with the singular-free split (K1) + the
  t-anchored subtraction:
      IG_j := int_{x_j}^{x_{j+1}} N_asym(x) p'(x) dx
            := N_asym(t) * (log|x_{j+1}-t| - log|x_j-t|)
               + int_{x_j}^{x_{j+1}} (N_asym(x) - N_asym(t))/(x-t) dx
               + int_{x_j}^{x_{j+1}} N_asym(x) q(x) dx,
  (the middle integrand has a REMOVABLE singularity at x = t for
  the gap containing t: continuous extension with value
  N_asym'(t); the three terms are all ordinary Bochner-integrable
  on the closed gap).
  I_np := sum_j IG_j.   (S3c computes exactly this; the quad
  spread audit 1e-21 validates the interpretation.)

### 1.4 The bound (the theorem)

  Inputs (explicit):
      K  := sup_j |DN(x_j)|   (PINNED 2.503 on (1e7, 2.0e9];
            CITED class C*log t beyond, per Zeta23-RvM/Backlund),
      L  := K3's explicit slope bound for N_asym on [G1, G2],
      GMAX := max_j (x_{j+1} - x_j)  (PINNED on the data bands;
            CITED via Zeta23 LocalCount A_0 log(|t|+3) beyond).
  (E1)  |Dc| <= K * TV(p; partition),
          TV := [p(t-) side] + [p(t+) side]:  by (K2) monotonicity
          on each side,  TV = p(G2) - p(+) + p(-) - p(G1) with the
          two straddle-adjacent values;  in the BOUND we use
          TV <= 2 * (max|p| endpoint + straddle terms) — explicit.
  (E2)  |B|  <= K * (|p(G1)| + |p(G2)|).
  (E3)  |I_DN - Dc| <= L * sum_j (x_{j+1}-x_j) * |p(x_{j+1})-p(x_j)|
          + K * (straddle remainder),
          — the Riemann-sum error of DN against p on the
          zero partition: for x in the open gap (x_j, x_{j+1}),
          N(x) = N(x_j) (no zeros strictly between the
          partition points), so  DN(x) - DN(x_j) =
          N_asym(x_j) - N_asym(x),  bounded by
          L * |x - x_j| <= L * gap_j;  hence per gap
          |int (DN(x)-DN(x_j)) p'(x) dx| <= L * gap_j * |p(x_{j+1})-p(x_j)|
          (the log-singular part handled by the t-anchored form,
          same estimate with the continuous extension);
          sum_j gap_j * |dp_j| <= GMAX_far * TV far-field
          + straddle-gap term — all explicit.
  (E4)  THE BOUND:
          |W(t)| <= K * (|p(G1)| + |p(G2)| + TV(p))
                    + L * (GMAX_far * TV_far + straddle)
                    + (boundary bookkeeping),
        an ABSOLUTE band constant (no t-growth: log(G2/G1)
        appears, fixed by the band), and the ONE-SIDED form
          W(t) >= -C_explicit(G1, G2, t, K, L, GMAX)
        which is the certificate ingredient (composes with
        margin >= 1 via the S1 wire; the P-0.8 margin budget
        absorbs the explicit slack).

### 1.5 Instantiations (the pins the theorem consumes)

  - band 1 (1e7, G_LAST]:  K = 2.439 (S3b, PINNED), L explicit,
    GMAX = 0.4378 (PINNED min-gap census), p-constants explicit.
  - band 2 (G_LAST, 2.0e9]:  K = 2.503 (S3d, PINNED), etc.
  - (2e9, 3e9] extension:  K to be PINNED by S3e (the stream is
    running); the theorem instantiation follows the same shape.
  - beyond 3e9:  K from the CITED class (Zeta23-RvM/Backlund
    O(log t));  the bound degrades to the classical ceiling —
    HONEST, and that is the documented ceiling.

## 2. Build order (one problem at a time)

  M1  definitions + (K1)-(K4)  — pure kernel algebra.
  M2  (T1)-(T4) — the finite-sum telescope on the partition.
  M3  (1.3) the integral side: IG_j definition, continuity of the
      t-anchored integrands, and the identity I_np = sum IG_j
      (per-gap FTC).
  M4  (E1)-(E4) the bound theorem + the one-sided corollary.
  M5  numeric instantiation as a data-adjacent theorem taking
      the pins as named constants (K := 2.503 etc.), with the
      explicit C evaluated by norm_num.
  M6  wire: compose with the S1 wire + S3a dev bound -> the
      uniform margin statement; re-issue the ceiling report.
