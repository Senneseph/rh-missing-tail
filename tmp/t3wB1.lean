
/- 25ae Stage 3B.11 -- Part B (13 <= t <= 1e8): the list-scale wall band, log-derivative method.
   Records: scripts/rh/day026_25ae_t3wallB.py (exact sympy/Fraction; out_day026_25ae_t3wallB.txt).

   For term index i in {2,4,6,7} (products with 3,5,7,8 factors; p_i = 7/2,11/2,15/2,15/2;
   d_i = 720,30240,1209600,9072000), term i of the sharpened T3 bound at list scale with
   n = floor(13t/8) satisfies
     t3w_term i n t <= t3wB_R i t * t3wB_target t
   with the continuous (floor-lower-bound) ratio bound
     t3wB_R i t = sqrt(t3w_prod t i) * (13t/8 - 1)^(-p_i) * 2*(13t/8)^(1/2)*(78/70)/d_i
   whose exact-scale target is t3wB_target t = (1/2)*(13t/8)^(-1/2)*(35/39) (so that
   t3wB_R i t * t3wB_target t = sqrt(t3w_prod t i)*(13t/8 - 1)^(-p_i)/d_i exactly,
   t3wB_Rtarget).  h_i = d/dt log R_i is the rational function t3wB_h i = Num_i / Den_i
   with integer Num_i (t3wB_num*, all-negative for i in {2,4,6}; the i=7 numerator has the
   b_0<0, b_1<0, b_k>0 (k>=2) shifted-at-13 structure of the later lemmas).  Consequences:
   R_2,R_4,R_6 strictly decreasing on [13,1e8] (h_i < 0); R_7 strictly decreasing then
   increasing with a unique crossing c in (13,100) (Den_7 > 0), so R_7(t) < t3wB_K7 on
   [13,1e8].  Endpoint constants (strict rational sqrt bounds):
   R_i(t) <= K_i with K_i in t3wB_K2,K4,K6,K7 and K2+K4+K6+K7 < 1 (margin ~0.178).  Hence
   sum_i R_i(t) < 1 and the wall bound t3w_T3UB n t < (1/2)*n^(-1/2)*(35/39) on 13 <= t <= 1e8
   (t3w_wall_B; combined with the Part A bands by p4_25ae_wall_list_scale). -/

/-- Exact-scale wall target at height t: (1/2) * (13t/8)^(-1/2) * (35/39). -/
def t3wB_target (t : ℝ) : ℝ :=
  (1/2 : ℝ) * ((13 * t / 8 : ℝ)) ^ (-(1/2 : ℝ)) * (35/39)

/-- Continuous (floor-lower-bound) ratio bound for term index i. -/
def t3wB_R (i : ℕ) (t : ℝ) : ℝ :=
  Real.sqrt (t3w_prod t i) * ((13 * t / 8 - 1 : ℝ)) ^ (-(t3w_p i)) *
      (2 * ((13 * t / 8 : ℝ)) ^ (1/2 : ℝ) * (78/70) / (t3w_d i))

/-- Log-derivative of t3wB_R i (rational form, no rpow). -/
def t3wB_h (i : ℕ) (t : ℝ) : ℝ :=
  (∑ k ∈ Finset.range (i + 1), t / (t ^ 2 + (k + 1/2 : ℝ) ^ 2)) + 1 / (2*t) -
      (t3w_p i) * (13/8 : ℝ) / (13 * t / 8 - 1)

/-- Structured positive denominator: 16*t*(13t-8)*∏_{k≤i} (4t^2 + (2k+1)^2). -/
def t3wB_den (i : ℕ) (t : ℝ) : ℝ :=
  16 * t * (13 * t - 8) * ∏ k ∈ Finset.range (i + 1), (4 * t ^ 2 + (2 * k + 1 : ℝ) ^ 2)

/-- Numerator of h_2: all coefficients negative. -/
def t3wB_num2 (t : ℝ) : ℝ :=
  -28672*t^6 - 116480*t^5 - 179200*t^4 - 430976*t^3 - 198912*t^2 - 140400*t - 14400

/-- Numerator of h_4: all coefficients negative. -/
def t3wB_num4 (t : ℝ) : ℝ :=
  -720896*t^10 - 8785920*t^9 - 24330240*t^8 - 233705472*t^7 - 251682816*t^6 -
      1725335040*t^5 - 884787200*t^4 - 3518431488*t^3 - 811945728*t^2 - 928746000*t - 57153600

/-- Numerator of h_6: all coefficients negative. -/
def t3wB_num6 (t : ℝ) : ℝ :=
  -15728640*t^14 - 387645440*t^13 - 1550581760*t^12 - 32833568768*t^11 - 55564500992*t^10 -
      973242716160*t^9 - 898377891840*t^8 - 12282899492864*t^7 - 6613868957696*t^6 -
      63918879315200*t^5 - 19667347481600*t^4 - 109215422679168*t^3 - 16802372719872*t^2 -
      26588697735600*t - 1168733966400

/-- Numerator of h_7: deg 17; b_0<0, b_1<0, b_k>0 (k>=2) after shifting to t = 13 (t3wB_b*). -/
def t3wB_num7 (t : ℝ) : ℝ :=
  13631488*t^17 - 71303168*t^15 - 10695475200*t^14 - 152887361536*t^13 - 611549446144*t^12 -
      9982866882560*t^11 - 16894082416640*t^10 - 255828309614592*t^9 - 236149208875008*t^8 -
      2968192799703040*t^7 - 1598257661378560*t^6 - 14745799254850560*t^5 - 4537169001492480*t^4 -
      24664631352192000*t^3 - 3794558669568000*t^2 - 5982456990510000*t - 262965142440000

/-- Strict rational upper bound of R_2 at 13. -/
def t3wB_K2 : ℝ := (69379921 : ℝ) / 76684038375
/-- Strict rational upper bound of R_4 at 13. -/
def t3wB_K4 : ℝ := (58741168772 : ℝ) / 5963180876155125
/-- Strict rational upper bound of R_6 at 13. -/
def t3wB_K6 : ℝ := (134976489576526 : ℝ) / 1082001280435718965875
/-- Strict rational upper bound of R_7 at 10^8. -/
def t3wB_K7 : ℝ :=
  (27152220160000230793871360000541788613017600365952532275199977013110761687 : ℝ) /
    33069018044903324635418068668593060916969864823485826249274579824803840000
/-- Strict rational upper bound of R_7 at 13. -/
def t3wB_B7_13 : ℝ := (20257718354549507 : ℝ) / 81150096032678922440625
/-- Strict rational lower bound of R_7 at 10^8. -/
def t3wB_LB7_1e8 : ℝ :=
  (6733653333333390569386666666801028301866666757421583733333327632667137 : ℝ) /
    8202284797567284397844418484928766708131679846895918262781258670080000

/-- sqrt upper bound factors (each strict). -/
def t3wB_S2 : ℝ := (144241 : ℝ) / 64
def t3wB_I2 : ℝ := (4096 : ℝ) / 146064835
def t3wB_T2 : ℝ := (37 : ℝ) / 4
def t3wB_S4 : ℝ := (213715271 : ℝ) / 512
def t3wB_I4 : ℝ := (262144 : ℝ) / 3786146588035
def t3wB_T4 : ℝ := (37 : ℝ) / 4
def t3wB_S6 : ℝ := (701541006115 : ℝ) / 8192
def t3wB_I6 : ℝ := (16777216 : ℝ) / 98140705708455235
def t3wB_T6 : ℝ := (37 : ℝ) / 4
def t3wB_S7_13 : ℝ := (42115838574947 : ℝ) / 32768
def t3wB_I7_13 : ℝ := (16777216 : ℝ) / 98140705708455235
def t3wB_T7_13 : ℝ := (37 : ℝ) / 4
def t3wB_S7_1e8 : ℝ :=
  (655360000000005570560000000013076889600000008832819199999999445176577 : ℝ) / 65536
def t3wB_I7_1e8 : ℝ :=
  (1 : ℝ) / 38140073382553740273378989139471030626096447015170749712487253
def t3wB_T7_1e8 : ℝ := (25496 : ℝ) / 1
def t3wB_SL7_1e8 : ℝ :=
  (2560000000000021760000000000051081600000000034503199999999997832721 : ℝ) / 256
def t3wB_IL7_1e8 : ℝ :=
  (1 : ℝ) / 38143065464877624617952094888991660659094493335639500849987252
def t3wB_TL7_1e8 : ℝ := (25494 : ℝ) / 1

/-- The (78/70)*(35/39)*(1/2)*2 = 1 cancellation: R_i * target = the floor-lower-bound term. -/
theorem t3wB_Rtarget (i : ℕ) {t : ℝ} (ht : 13 ≤ t) :
    t3wB_R i t * t3wB_target t =
        Real.sqrt (t3w_prod t i) * ((13 * t / 8 - 1 : ℝ)) ^ (-(t3w_p i)) / (t3w_d i) := by
  have hbase : 0 < (13 * t / 8 : ℝ) := by
    apply div_pos (by norm_num : (0 : ℝ) < 13)
    nlinarith [ht]
  have hcancel : ((13 * t / 8 : ℝ)) ^ (1/2 : ℝ) * ((13 * t / 8 : ℝ)) ^ (-(1/2 : ℝ)) = 1 := by
    rw [← rpow_add hbase (1/2 : ℝ) (-(1/2 : ℝ)),
        show (1/2 : ℝ) + (-(1/2 : ℝ)) = 0 from by norm_num]
    exact Real.rpow_zero _
  dsimp only [t3wB_R, t3wB_target]
  field_simp [hcancel]
  ring

/-- t3wB_den is positive for t >= 13. -/
theorem t3wB_den_pos {i : ℕ} {t : ℝ} (ht : 13 ≤ t) : 0 < t3wB_den i t := by
  dsimp only [t3wB_den]
  have ht8 : 0 < 13 * t - 8 := by nlinarith [ht]
  have h2 : 0 < (16 * t) * (13 * t - 8) := by
    have ht0 : 0 < t := by linarith [ht]
    nlinarith [ht0, ht8]
  refine lt_mul_of_pos_of_pos h2 ?_
  apply Finset.prod_pos
  intro k hk
  have ht0 : 0 < t := by linarith [ht]
  nlinarith [pos_pow_two ht0, show (0 : ℝ) ≤ (2 * k + 1 : ℝ)^2 from sq_nonneg _]

/-- h_i = Num_i / Den_i (i = 2). -/
theorem t3wB_h2_id {t : ℝ} (ht : 13 ≤ t) : t3wB_h 2 t = t3wB_num2 t / t3wB_den 2 t := by
  have ht0 : 0 < t := by linarith [ht]
  simp only [t3wB_h, t3wB_den, t3w_p, t3w_d] at *
  field_simp [ht0.ne', show (13 * t / 8 - 1 : ℝ) ≠ 0 from by
    have hlo : 13 * t / 8 - 1 > 0 := by
      have : (13 : ℝ) * t / 8 ≥ 13 * 13 / 8 := gcongr <;> linarith [ht]
      norm_num at this ⊢
      linarith
  ]
  ring
  <;> norm_num

/-- h_i = Num_i / Den_i (i = 4). -/
theorem t3wB_h4_id {t : ℝ} (ht : 13 ≤ t) : t3wB_h 4 t = t3wB_num4 t / t3wB_den 4 t := by
  have ht0 : 0 < t := by linarith [ht]
  simp only [t3wB_h, t3wB_den, t3w_p, t3w_d] at *
  field_simp [ht0.ne', show (13 * t / 8 - 1 : ℝ) ≠ 0 from by
    have hlo : 13 * t / 8 - 1 > 0 := by
      have : (13 : ℝ) * t / 8 ≥ 13 * 13 / 8 := gcongr <;> linarith [ht]
      norm_num at this ⊢
      linarith
  ]
  ring
  <;> norm_num

/-- h_i = Num_i / Den_i (i = 6). -/
theorem t3wB_h6_id {t : ℝ} (ht : 13 ≤ t) : t3wB_h 6 t = t3wB_num6 t / t3wB_den 6 t := by
  have ht0 : 0 < t := by linarith [ht]
  simp only [t3wB_h, t3wB_den, t3w_p, t3w_d] at *
  field_simp [ht0.ne', show (13 * t / 8 - 1 : ℝ) ≠ 0 from by
    have hlo : 13 * t / 8 - 1 > 0 := by
      have : (13 : ℝ) * t / 8 ≥ 13 * 13 / 8 := gcongr <;> linarith [ht]
      norm_num at this ⊢
      linarith
  ]
  ring
  <;> norm_num

/-- h_i = Num_i / Den_i (i = 7). -/
theorem t3wB_h7_id {t : ℝ} (ht : 13 ≤ t) : t3wB_h 7 t = t3wB_num7 t / t3wB_den 7 t := by
  have ht0 : 0 < t := by linarith [ht]
  simp only [t3wB_h, t3wB_den, t3w_p, t3w_d] at *
  field_simp [ht0.ne', show (13 * t / 8 - 1 : ℝ) ≠ 0 from by
    have hlo : 13 * t / 8 - 1 > 0 := by
      have : (13 : ℝ) * t / 8 ≥ 13 * 13 / 8 := gcongr <;> linarith [ht]
      norm_num at this ⊢
      linarith
  ]
  ring
  <;> norm_num

/-- t3wB_num2 t < 0 for t > 0 (all coefficients negative). -/
theorem t3wB_num2_neg {t : ℝ} (ht : 0 < t) : t3wB_num2 t < 0 := by
  dsimp only [t3wB_num2]
  have h1 : 0 < t^1 := by positivity
  have h2 : 0 < t^2 := by positivity
  have h3 : 0 < t^3 := by positivity
  have h4 : 0 < t^4 := by positivity
  have h5 : 0 < t^5 := by positivity
  have h6 : 0 < t^6 := by positivity
  nlinarith [h1, h2, h3, h4, h5, h6]

/-- t3wB_num4 t < 0 for t > 0 (all coefficients negative). -/
theorem t3wB_num4_neg {t : ℝ} (ht : 0 < t) : t3wB_num4 t < 0 := by
  dsimp only [t3wB_num4]
  have h1 : 0 < t^1 := by positivity
  have h2 : 0 < t^2 := by positivity
  have h3 : 0 < t^3 := by positivity
  have h4 : 0 < t^4 := by positivity
  have h5 : 0 < t^5 := by positivity
  have h6 : 0 < t^6 := by positivity
  have h7 : 0 < t^7 := by positivity
  have h8 : 0 < t^8 := by positivity
  have h9 : 0 < t^9 := by positivity
  have h10 : 0 < t^10 := by positivity
  nlinarith [h1, h2, h3, h4, h5, h6, h7, h8, h9, h10]

/-- t3wB_num6 t < 0 for t > 0 (all coefficients negative). -/
theorem t3wB_num6_neg {t : ℝ} (ht : 0 < t) : t3wB_num6 t < 0 := by
  dsimp only [t3wB_num6]
  have h1 : 0 < t^1 := by positivity
  have h2 : 0 < t^2 := by positivity
  have h3 : 0 < t^3 := by positivity
  have h4 : 0 < t^4 := by positivity
  have h5 : 0 < t^5 := by positivity
  have h6 : 0 < t^6 := by positivity
  have h7 : 0 < t^7 := by positivity
  have h8 : 0 < t^8 := by positivity
  have h9 : 0 < t^9 := by positivity
  have h10 : 0 < t^10 := by positivity
  have h11 : 0 < t^11 := by positivity
  have h12 : 0 < t^12 := by positivity
  have h13 : 0 < t^13 := by positivity
  have h14 : 0 < t^14 := by positivity
  nlinarith [h1, h2, h3, h4, h5, h6, h7, h8, h9, h10, h11, h12, h13, h14]

/-- h_i < 0 for all t >= 13, i in {2,4,6} (Num_i < 0, Den_i > 0). -/
theorem t3wB_h_neg_246 {i : ℕ} (hi : i = 2 ∨ i = 4 ∨ i = 6) {t : ℝ} (ht : 13 ≤ t) :
    t3wB_h i t < 0 := by
  have ht0 : 0 < t := by linarith [ht]
  have hden : 0 < t3wB_den i t := t3wB_den_pos ht
  rcases hi with (rfl | hi)
  · rw [t3wB_h2_id ht, t3wB_num2_neg ht0, t3wB_den_pos ht]
    apply (div_neg_iff hden).2
    norm_num
  · rcases hi with (rfl | hi)
    · rw [t3wB_h4_id ht, t3wB_num4_neg ht0, t3wB_den_pos ht]
      apply (div_neg_iff hden).2
      norm_num
    · rcases hi with rfl
      rw [t3wB_h6_id ht, t3wB_num6_neg ht0, t3wB_den_pos ht]
      apply (div_neg_iff hden).2
      norm_num
