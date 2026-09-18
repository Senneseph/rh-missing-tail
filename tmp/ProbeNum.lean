import Mathlib

noncomputable def t3wB_num7 (t : ℝ) : ℝ :=
  13631488*t^17 - 71303168*t^16 - 10695475200*t^14 - 152887361536*t^13 - 611549446144*t^12 -
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
  dsimp only [t3wB_R, t3wB_target]
  set Y := (13 * t / 8 : ℝ) ^ (1/2 : ℝ) with Ydef
  set Z := (13 * t / 8 : ℝ) ^ (-(1/2 : ℝ)) with Zdef
  set M := 2 * Y * (78/70 : ℝ) / (t3w_d i) with Mdef
  set N := (1/2 : ℝ) * Z * (35/39 : ℝ) with Ndef
  have hbase : 0 < (13 * t / 8 : ℝ) := by
    apply div_pos (by nlinarith [ht]) (by norm_num)
  have hpair : Y * Z = 1 := by
    rw [Ydef, Zdef, show (13 * t / 8 : ℝ) ^ (1/2 : ℝ) * (13 * t / 8 : ℝ) ^ (-(1/2 : ℝ)) =
          ((13 * t / 8 : ℝ)) ^ ((1/2 : ℝ) + (-(1/2 : ℝ))) from by rw [← rpow_add hbase],
        show (1/2 : ℝ) + (-(1/2 : ℝ)) = 0 from by norm_num, Real.rpow_zero _]
  have hMN : M * N = Y * Z * ((2 : ℝ) * (1/2) * ((78/70 : ℝ) * (35/39 : ℝ))) / t3w_d i := by
    simp only [Mdef, Ndef, Ydef, Zdef]
    ring
  have hconst : (2 : ℝ) * (1/2) * ((78/70 : ℝ) * (35/39 : ℝ)) = 1 := by norm_num
  have hre : Real.sqrt (t3w_prod t i) * ((13 * t / 8 - 1 : ℝ)) ^ (-(t3w_p i)) * M * N =
      Real.sqrt (t3w_prod t i) * ((13 * t / 8 - 1 : ℝ)) ^ (-(t3w_p i)) * (M * N) := by ring
  rw [hre, hMN, hpair, hconst]
  ring

theorem t3wB_den_pos {i : ℕ} {t : ℝ} (ht : 13 ≤ t) : 0 < t3wB_den i t := by
  dsimp only [t3wB_den]
  have h2 : 0 < (128 * t) * (13 * t / 8 - 1) := by
    have ht0 : 0 < t := by linarith [ht]
    have ht8 : 0 < 13 * t / 8 - 1 := by
      nlinarith [show (13 : ℝ) * t ≥ 13 * 13 from by nlinarith [ht]]
    nlinarith [ht0, ht8]
  have hprod : 0 < ∏ k ∈ Finset.range (i + 1), (4 * t ^ 2 + (2 * k + 1 : ℝ) ^ 2) := by
    apply Finset.prod_pos
    intro k hk
    have ht0 : 0 < t := by linarith [ht]
    nlinarith [show (0 : ℝ) < 4 * t ^ 2 from by nlinarith [show (0 : ℝ) < t ^ 2 from by nlinarith [ht0]],
      show (0 : ℝ) ≤ (2 * k + 1 : ℝ)^2 from sq_nonneg _]
  nlinarith [h2, hprod]

/-- h_i = Num_i / Den_i (i = 2). -/
theorem t3wB_h2_id {t : ℝ} (ht : 13 ≤ t) : t3wB_h 2 t = t3wB_num2 t / t3wB_den 2 t := by
  have ht0 : 0 < t := by linarith [ht]
  have hden : t3wB_den 2 t ≠ 0 := (t3wB_den_pos ht).ne'
  set Dfull := (128 * t * (13 * t / 8 - 1) * (4 * t ^ 2 + 1 : ℝ) * (4 * t ^ 2 + 9 : ℝ) * (4 * t ^ 2 + 25 : ℝ)) with Dfulldef
  have hmult : t3wB_h 2 t * (t3wB_den 2 t) = t3wB_num2 t := by
    calc
      t3wB_h 2 t * (t3wB_den 2 t) = (4 * t / (4 * t ^ 2 + 1 : ℝ)) * Dfull + (4 * t / (4 * t ^ 2 + 9 : ℝ)) * Dfull + (4 * t / (4 * t ^ 2 + 25 : ℝ)) * Dfull + ((1/2 : ℝ) / t) * Dfull - (((7/2 : ℝ) * (13/8 : ℝ)) / (13 * t / 8 - 1)) * Dfull := by
        dsimp only [t3wB_h, t3wB_den]
        norm_num [t3w_p]
        simp only [Finset.sum_range_succ, Finset.prod_range_succ, Finset.sum_empty, Finset.prod_empty, Finset.range_zero]
        norm_num
        rw [show (128 * t * (13 * t / 8 - 1) * ((4 * t ^ 2 + 1 : ℝ) * (4 * t ^ 2 + 9 : ℝ) * (4 * t ^ 2 + 25 : ℝ))) = Dfull from by ring]
        ring
      _ = t3wB_num2 t := by
        dsimp only [t3wB_num2]
        have hk0 : (4 * t / (4 * t ^ 2 + 1 : ℝ)) * Dfull = 512 * t ^ 2 * (13 * t / 8 - 1) * (4 * t ^ 2 + 9 : ℝ) * (4 * t ^ 2 + 25 : ℝ) := by
          rw [Dfulldef]
          field_simp [(by positivity : (4 * t ^ 2 + 1 : ℝ) ≠ 0)]
          ring
        have hk1 : (4 * t / (4 * t ^ 2 + 9 : ℝ)) * Dfull = 512 * t ^ 2 * (13 * t / 8 - 1) * (4 * t ^ 2 + 1 : ℝ) * (4 * t ^ 2 + 25 : ℝ) := by
          rw [Dfulldef]
          field_simp [(by positivity : (4 * t ^ 2 + 9 : ℝ) ≠ 0)]
          ring
        have hk2 : (4 * t / (4 * t ^ 2 + 25 : ℝ)) * Dfull = 512 * t ^ 2 * (13 * t / 8 - 1) * (4 * t ^ 2 + 1 : ℝ) * (4 * t ^ 2 + 9 : ℝ) := by
          rw [Dfulldef]
          field_simp [(by positivity : (4 * t ^ 2 + 25 : ℝ) ≠ 0)]
          ring
        have hB : ((1/2 : ℝ) / t) * Dfull = 64 * (13 * t / 8 - 1) * (4 * t ^ 2 + 1 : ℝ) * (4 * t ^ 2 + 9 : ℝ) * (4 * t ^ 2 + 25 : ℝ) := by
          rw [Dfulldef]
          field_simp [(by positivity : (2 * t : ℝ) ≠ 0)]
          ring
        have hC : (((7/2 : ℝ) * (13/8 : ℝ)) / (13 * t / 8 - 1)) * Dfull = 728 * t * (4 * t ^ 2 + 1 : ℝ) * (4 * t ^ 2 + 9 : ℝ) * (4 * t ^ 2 + 25 : ℝ) := by
          have hY : (13 * t / 8 - 1 : ℝ) ≠ 0 := ne_of_gt (by linarith [ht])
          rw [Dfulldef]
          rw [show (((7/2 : ℝ) * (13/8 : ℝ)) / (13 * t / 8 - 1)) * (128 * t * (13 * t / 8 - 1) * (4 * t ^ 2 + 1 : ℝ) * (4 * t ^ 2 + 9 : ℝ) * (4 * t ^ 2 + 25 : ℝ)) =
                (((7/2 : ℝ) * (13/8 : ℝ)) : ℝ) * ((13 * t / 8 - 1 : ℝ)⁻¹ * (13 * t / 8 - 1)) * (128 * t * ((4 * t ^ 2 + 1 : ℝ) * (4 * t ^ 2 + 9 : ℝ) * (4 * t ^ 2 + 25 : ℝ))) from by ring]
          rw [show (13 * t / 8 - 1 : ℝ)⁻¹ * (13 * t / 8 - 1) = 1 from by
            field_simp [hY, ne_of_gt (show (13 * t - 8 : ℝ) > 0 by linarith [ht])]]
          ring
        rw [hk0, hk1, hk2, hB, hC]
        ring
  rw [show t3wB_num2 t / (t3wB_den 2 t) = t3wB_h 2 t from by rw [← hmult]; field_simp [hden]]










/-- h_i = Num_i / Den_i (i = 4). -/
theorem t3wB_h4_id {t : ℝ} (ht : 13 ≤ t) : t3wB_h 4 t = t3wB_num4 t / t3wB_den 4 t := by
  have ht0 : 0 < t := by linarith [ht]
  have hden : t3wB_den 4 t ≠ 0 := (t3wB_den_pos ht).ne'
  set Dfull := (128 * t * (13 * t / 8 - 1) * (4 * t ^ 2 + 1 : ℝ) * (4 * t ^ 2 + 9 : ℝ) * (4 * t ^ 2 + 25 : ℝ) * (4 * t ^ 2 + 49 : ℝ) * (4 * t ^ 2 + 81 : ℝ)) with Dfulldef
  have hmult : t3wB_h 4 t * (t3wB_den 4 t) = t3wB_num4 t := by
    calc
      t3wB_h 4 t * (t3wB_den 4 t) = (4 * t / (4 * t ^ 2 + 1 : ℝ)) * Dfull + (4 * t / (4 * t ^ 2 + 9 : ℝ)) * Dfull + (4 * t / (4 * t ^ 2 + 25 : ℝ)) * Dfull + (4 * t / (4 * t ^ 2 + 49 : ℝ)) * Dfull + (4 * t / (4 * t ^ 2 + 81 : ℝ)) * Dfull + ((1/2 : ℝ) / t) * Dfull - (((11/2 : ℝ) * (13/8 : ℝ)) / (13 * t / 8 - 1)) * Dfull := by
        dsimp only [t3wB_h, t3wB_den]
        norm_num [t3w_p]
        simp only [Finset.sum_range_succ, Finset.prod_range_succ, Finset.sum_empty, Finset.prod_empty, Finset.range_zero]
        norm_num
        rw [show (128 * t * (13 * t / 8 - 1) * ((4 * t ^ 2 + 1 : ℝ) * (4 * t ^ 2 + 9 : ℝ) * (4 * t ^ 2 + 25 : ℝ) * (4 * t ^ 2 + 49 : ℝ) * (4 * t ^ 2 + 81 : ℝ))) = Dfull from by ring]
        ring
      _ = t3wB_num4 t := by
        dsimp only [t3wB_num4]
        have hk0 : (4 * t / (4 * t ^ 2 + 1 : ℝ)) * Dfull = 512 * t ^ 2 * (13 * t / 8 - 1) * (4 * t ^ 2 + 9 : ℝ) * (4 * t ^ 2 + 25 : ℝ) * (4 * t ^ 2 + 49 : ℝ) * (4 * t ^ 2 + 81 : ℝ) := by
          rw [Dfulldef]
          field_simp [(by positivity : (4 * t ^ 2 + 1 : ℝ) ≠ 0)]
          ring
        have hk1 : (4 * t / (4 * t ^ 2 + 9 : ℝ)) * Dfull = 512 * t ^ 2 * (13 * t / 8 - 1) * (4 * t ^ 2 + 1 : ℝ) * (4 * t ^ 2 + 25 : ℝ) * (4 * t ^ 2 + 49 : ℝ) * (4 * t ^ 2 + 81 : ℝ) := by
          rw [Dfulldef]
          field_simp [(by positivity : (4 * t ^ 2 + 9 : ℝ) ≠ 0)]
          ring
        have hk2 : (4 * t / (4 * t ^ 2 + 25 : ℝ)) * Dfull = 512 * t ^ 2 * (13 * t / 8 - 1) * (4 * t ^ 2 + 1 : ℝ) * (4 * t ^ 2 + 9 : ℝ) * (4 * t ^ 2 + 49 : ℝ) * (4 * t ^ 2 + 81 : ℝ) := by
          rw [Dfulldef]
          field_simp [(by positivity : (4 * t ^ 2 + 25 : ℝ) ≠ 0)]
          ring
        have hk3 : (4 * t / (4 * t ^ 2 + 49 : ℝ)) * Dfull = 512 * t ^ 2 * (13 * t / 8 - 1) * (4 * t ^ 2 + 1 : ℝ) * (4 * t ^ 2 + 9 : ℝ) * (4 * t ^ 2 + 25 : ℝ) * (4 * t ^ 2 + 81 : ℝ) := by
          rw [Dfulldef]
          field_simp [(by positivity : (4 * t ^ 2 + 49 : ℝ) ≠ 0)]
          ring
        have hk4 : (4 * t / (4 * t ^ 2 + 81 : ℝ)) * Dfull = 512 * t ^ 2 * (13 * t / 8 - 1) * (4 * t ^ 2 + 1 : ℝ) * (4 * t ^ 2 + 9 : ℝ) * (4 * t ^ 2 + 25 : ℝ) * (4 * t ^ 2 + 49 : ℝ) := by
          rw [Dfulldef]
          field_simp [(by positivity : (4 * t ^ 2 + 81 : ℝ) ≠ 0)]
          ring
        have hB : ((1/2 : ℝ) / t) * Dfull = 64 * (13 * t / 8 - 1) * (4 * t ^ 2 + 1 : ℝ) * (4 * t ^ 2 + 9 : ℝ) * (4 * t ^ 2 + 25 : ℝ) * (4 * t ^ 2 + 49 : ℝ) * (4 * t ^ 2 + 81 : ℝ) := by
          rw [Dfulldef]
          field_simp [(by positivity : (2 * t : ℝ) ≠ 0)]
          ring
        have hC : (((11/2 : ℝ) * (13/8 : ℝ)) / (13 * t / 8 - 1)) * Dfull = 1144 * t * (4 * t ^ 2 + 1 : ℝ) * (4 * t ^ 2 + 9 : ℝ) * (4 * t ^ 2 + 25 : ℝ) * (4 * t ^ 2 + 49 : ℝ) * (4 * t ^ 2 + 81 : ℝ) := by
          have hY : (13 * t / 8 - 1 : ℝ) ≠ 0 := ne_of_gt (by linarith [ht])
          rw [Dfulldef]
          rw [show (((11/2 : ℝ) * (13/8 : ℝ)) / (13 * t / 8 - 1)) * (128 * t * (13 * t / 8 - 1) * (4 * t ^ 2 + 1 : ℝ) * (4 * t ^ 2 + 9 : ℝ) * (4 * t ^ 2 + 25 : ℝ) * (4 * t ^ 2 + 49 : ℝ) * (4 * t ^ 2 + 81 : ℝ)) =
                (((11/2 : ℝ) * (13/8 : ℝ)) : ℝ) * ((13 * t / 8 - 1 : ℝ)⁻¹ * (13 * t / 8 - 1)) * (128 * t * ((4 * t ^ 2 + 1 : ℝ) * (4 * t ^ 2 + 9 : ℝ) * (4 * t ^ 2 + 25 : ℝ) * (4 * t ^ 2 + 49 : ℝ) * (4 * t ^ 2 + 81 : ℝ))) from by ring]
          rw [show (13 * t / 8 - 1 : ℝ)⁻¹ * (13 * t / 8 - 1) = 1 from by
            field_simp [hY, ne_of_gt (show (13 * t - 8 : ℝ) > 0 by linarith [ht])]]
          ring
        rw [hk0, hk1, hk2, hk3, hk4, hB, hC]
        ring
  rw [show t3wB_num4 t / (t3wB_den 4 t) = t3wB_h 4 t from by rw [← hmult]; field_simp [hden]]










/-- h_i = Num_i / Den_i (i = 6). -/
theorem t3wB_h6_id {t : ℝ} (ht : 13 ≤ t) : t3wB_h 6 t = t3wB_num6 t / t3wB_den 6 t := by
  have ht0 : 0 < t := by linarith [ht]
  have hden : t3wB_den 6 t ≠ 0 := (t3wB_den_pos ht).ne'
  set Dfull := (128 * t * (13 * t / 8 - 1) * (4 * t ^ 2 + 1 : ℝ) * (4 * t ^ 2 + 9 : ℝ) * (4 * t ^ 2 + 25 : ℝ) * (4 * t ^ 2 + 49 : ℝ) * (4 * t ^ 2 + 81 : ℝ) * (4 * t ^ 2 + 121 : ℝ) * (4 * t ^ 2 + 169 : ℝ)) with Dfulldef
  have hmult : t3wB_h 6 t * (t3wB_den 6 t) = t3wB_num6 t := by
    calc
      t3wB_h 6 t * (t3wB_den 6 t) = (4 * t / (4 * t ^ 2 + 1 : ℝ)) * Dfull + (4 * t / (4 * t ^ 2 + 9 : ℝ)) * Dfull + (4 * t / (4 * t ^ 2 + 25 : ℝ)) * Dfull + (4 * t / (4 * t ^ 2 + 49 : ℝ)) * Dfull + (4 * t / (4 * t ^ 2 + 81 : ℝ)) * Dfull + (4 * t / (4 * t ^ 2 + 121 : ℝ)) * Dfull + (4 * t / (4 * t ^ 2 + 169 : ℝ)) * Dfull + ((1/2 : ℝ) / t) * Dfull - (((15/2 : ℝ) * (13/8 : ℝ)) / (13 * t / 8 - 1)) * Dfull := by
        dsimp only [t3wB_h, t3wB_den]
        norm_num [t3w_p]
        simp only [Finset.sum_range_succ, Finset.prod_range_succ, Finset.sum_empty, Finset.prod_empty, Finset.range_zero]
        norm_num
        rw [show (128 * t * (13 * t / 8 - 1) * ((4 * t ^ 2 + 1 : ℝ) * (4 * t ^ 2 + 9 : ℝ) * (4 * t ^ 2 + 25 : ℝ) * (4 * t ^ 2 + 49 : ℝ) * (4 * t ^ 2 + 81 : ℝ) * (4 * t ^ 2 + 121 : ℝ) * (4 * t ^ 2 + 169 : ℝ))) = Dfull from by ring]
        ring
      _ = t3wB_num6 t := by
        dsimp only [t3wB_num6]
        have hk0 : (4 * t / (4 * t ^ 2 + 1 : ℝ)) * Dfull = 512 * t ^ 2 * (13 * t / 8 - 1) * (4 * t ^ 2 + 9 : ℝ) * (4 * t ^ 2 + 25 : ℝ) * (4 * t ^ 2 + 49 : ℝ) * (4 * t ^ 2 + 81 : ℝ) * (4 * t ^ 2 + 121 : ℝ) * (4 * t ^ 2 + 169 : ℝ) := by
          rw [Dfulldef]
          field_simp [(by positivity : (4 * t ^ 2 + 1 : ℝ) ≠ 0)]
          ring
        have hk1 : (4 * t / (4 * t ^ 2 + 9 : ℝ)) * Dfull = 512 * t ^ 2 * (13 * t / 8 - 1) * (4 * t ^ 2 + 1 : ℝ) * (4 * t ^ 2 + 25 : ℝ) * (4 * t ^ 2 + 49 : ℝ) * (4 * t ^ 2 + 81 : ℝ) * (4 * t ^ 2 + 121 : ℝ) * (4 * t ^ 2 + 169 : ℝ) := by
          rw [Dfulldef]
          field_simp [(by positivity : (4 * t ^ 2 + 9 : ℝ) ≠ 0)]
          ring
        have hk2 : (4 * t / (4 * t ^ 2 + 25 : ℝ)) * Dfull = 512 * t ^ 2 * (13 * t / 8 - 1) * (4 * t ^ 2 + 1 : ℝ) * (4 * t ^ 2 + 9 : ℝ) * (4 * t ^ 2 + 49 : ℝ) * (4 * t ^ 2 + 81 : ℝ) * (4 * t ^ 2 + 121 : ℝ) * (4 * t ^ 2 + 169 : ℝ) := by
          rw [Dfulldef]
          field_simp [(by positivity : (4 * t ^ 2 + 25 : ℝ) ≠ 0)]
          ring
        have hk3 : (4 * t / (4 * t ^ 2 + 49 : ℝ)) * Dfull = 512 * t ^ 2 * (13 * t / 8 - 1) * (4 * t ^ 2 + 1 : ℝ) * (4 * t ^ 2 + 9 : ℝ) * (4 * t ^ 2 + 25 : ℝ) * (4 * t ^ 2 + 81 : ℝ) * (4 * t ^ 2 + 121 : ℝ) * (4 * t ^ 2 + 169 : ℝ) := by
          rw [Dfulldef]
          field_simp [(by positivity : (4 * t ^ 2 + 49 : ℝ) ≠ 0)]
          ring
        have hk4 : (4 * t / (4 * t ^ 2 + 81 : ℝ)) * Dfull = 512 * t ^ 2 * (13 * t / 8 - 1) * (4 * t ^ 2 + 1 : ℝ) * (4 * t ^ 2 + 9 : ℝ) * (4 * t ^ 2 + 25 : ℝ) * (4 * t ^ 2 + 49 : ℝ) * (4 * t ^ 2 + 121 : ℝ) * (4 * t ^ 2 + 169 : ℝ) := by
          rw [Dfulldef]
          field_simp [(by positivity : (4 * t ^ 2 + 81 : ℝ) ≠ 0)]
          ring
        have hk5 : (4 * t / (4 * t ^ 2 + 121 : ℝ)) * Dfull = 512 * t ^ 2 * (13 * t / 8 - 1) * (4 * t ^ 2 + 1 : ℝ) * (4 * t ^ 2 + 9 : ℝ) * (4 * t ^ 2 + 25 : ℝ) * (4 * t ^ 2 + 49 : ℝ) * (4 * t ^ 2 + 81 : ℝ) * (4 * t ^ 2 + 169 : ℝ) := by
          rw [Dfulldef]
          field_simp [(by positivity : (4 * t ^ 2 + 121 : ℝ) ≠ 0)]
          ring
        have hk6 : (4 * t / (4 * t ^ 2 + 169 : ℝ)) * Dfull = 512 * t ^ 2 * (13 * t / 8 - 1) * (4 * t ^ 2 + 1 : ℝ) * (4 * t ^ 2 + 9 : ℝ) * (4 * t ^ 2 + 25 : ℝ) * (4 * t ^ 2 + 49 : ℝ) * (4 * t ^ 2 + 81 : ℝ) * (4 * t ^ 2 + 121 : ℝ) := by
          rw [Dfulldef]
          field_simp [(by positivity : (4 * t ^ 2 + 169 : ℝ) ≠ 0)]
          ring
        have hB : ((1/2 : ℝ) / t) * Dfull = 64 * (13 * t / 8 - 1) * (4 * t ^ 2 + 1 : ℝ) * (4 * t ^ 2 + 9 : ℝ) * (4 * t ^ 2 + 25 : ℝ) * (4 * t ^ 2 + 49 : ℝ) * (4 * t ^ 2 + 81 : ℝ) * (4 * t ^ 2 + 121 : ℝ) * (4 * t ^ 2 + 169 : ℝ) := by
          rw [Dfulldef]
          field_simp [(by positivity : (2 * t : ℝ) ≠ 0)]
          ring
        have hC : (((15/2 : ℝ) * (13/8 : ℝ)) / (13 * t / 8 - 1)) * Dfull = 1560 * t * (4 * t ^ 2 + 1 : ℝ) * (4 * t ^ 2 + 9 : ℝ) * (4 * t ^ 2 + 25 : ℝ) * (4 * t ^ 2 + 49 : ℝ) * (4 * t ^ 2 + 81 : ℝ) * (4 * t ^ 2 + 121 : ℝ) * (4 * t ^ 2 + 169 : ℝ) := by
          have hY : (13 * t / 8 - 1 : ℝ) ≠ 0 := ne_of_gt (by linarith [ht])
          rw [Dfulldef]
          rw [show (((15/2 : ℝ) * (13/8 : ℝ)) / (13 * t / 8 - 1)) * (128 * t * (13 * t / 8 - 1) * (4 * t ^ 2 + 1 : ℝ) * (4 * t ^ 2 + 9 : ℝ) * (4 * t ^ 2 + 25 : ℝ) * (4 * t ^ 2 + 49 : ℝ) * (4 * t ^ 2 + 81 : ℝ) * (4 * t ^ 2 + 121 : ℝ) * (4 * t ^ 2 + 169 : ℝ)) =
                (((15/2 : ℝ) * (13/8 : ℝ)) : ℝ) * ((13 * t / 8 - 1 : ℝ)⁻¹ * (13 * t / 8 - 1)) * (128 * t * ((4 * t ^ 2 + 1 : ℝ) * (4 * t ^ 2 + 9 : ℝ) * (4 * t ^ 2 + 25 : ℝ) * (4 * t ^ 2 + 49 : ℝ) * (4 * t ^ 2 + 81 : ℝ) * (4 * t ^ 2 + 121 : ℝ) * (4 * t ^ 2 + 169 : ℝ))) from by ring]
          rw [show (13 * t / 8 - 1 : ℝ)⁻¹ * (13 * t / 8 - 1) = 1 from by
            field_simp [hY, ne_of_gt (show (13 * t - 8 : ℝ) > 0 by linarith [ht])]]
          ring
        rw [hk0, hk1, hk2, hk3, hk4, hk5, hk6, hB, hC]
        ring
  rw [show t3wB_num6 t / (t3wB_den 6 t) = t3wB_h 6 t from by rw [← hmult]; field_simp [hden]]










/-- h_i = Num_i / Den_i (i = 7). -/
theorem t3wB_h7_id {t : ℝ} (ht : 13 ≤ t) : t3wB_h 7 t = t3wB_num7 t / t3wB_den 7 t := by
  have ht0 : 0 < t := by linarith [ht]
  have hden : t3wB_den 7 t ≠ 0 := (t3wB_den_pos ht).ne'
  set Dfull := (128 * t * (13 * t / 8 - 1) * (4 * t ^ 2 + 1 : ℝ) * (4 * t ^ 2 + 9 : ℝ) * (4 * t ^ 2 + 25 : ℝ) * (4 * t ^ 2 + 49 : ℝ) * (4 * t ^ 2 + 81 : ℝ) * (4 * t ^ 2 + 121 : ℝ) * (4 * t ^ 2 + 169 : ℝ) * (4 * t ^ 2 + 225 : ℝ)) with Dfulldef
  have hmult : t3wB_h 7 t * (t3wB_den 7 t) = t3wB_num7 t := by
    calc
      t3wB_h 7 t * (t3wB_den 7 t) = (4 * t / (4 * t ^ 2 + 1 : ℝ)) * Dfull + (4 * t / (4 * t ^ 2 + 9 : ℝ)) * Dfull + (4 * t / (4 * t ^ 2 + 25 : ℝ)) * Dfull + (4 * t / (4 * t ^ 2 + 49 : ℝ)) * Dfull + (4 * t / (4 * t ^ 2 + 81 : ℝ)) * Dfull + (4 * t / (4 * t ^ 2 + 121 : ℝ)) * Dfull + (4 * t / (4 * t ^ 2 + 169 : ℝ)) * Dfull + (4 * t / (4 * t ^ 2 + 225 : ℝ)) * Dfull + ((1/2 : ℝ) / t) * Dfull - (((15/2 : ℝ) * (13/8 : ℝ)) / (13 * t / 8 - 1)) * Dfull := by
        dsimp only [t3wB_h, t3wB_den]
        norm_num [t3w_p]
        simp only [Finset.sum_range_succ, Finset.prod_range_succ, Finset.sum_empty, Finset.prod_empty, Finset.range_zero]
        norm_num
        rw [show (128 * t * (13 * t / 8 - 1) * ((4 * t ^ 2 + 1 : ℝ) * (4 * t ^ 2 + 9 : ℝ) * (4 * t ^ 2 + 25 : ℝ) * (4 * t ^ 2 + 49 : ℝ) * (4 * t ^ 2 + 81 : ℝ) * (4 * t ^ 2 + 121 : ℝ) * (4 * t ^ 2 + 169 : ℝ) * (4 * t ^ 2 + 225 : ℝ))) = Dfull from by ring]
        ring
      _ = t3wB_num7 t := by
        dsimp only [t3wB_num7]
        have hk0 : (4 * t / (4 * t ^ 2 + 1 : ℝ)) * Dfull = 512 * t ^ 2 * (13 * t / 8 - 1) * (4 * t ^ 2 + 9 : ℝ) * (4 * t ^ 2 + 25 : ℝ) * (4 * t ^ 2 + 49 : ℝ) * (4 * t ^ 2 + 81 : ℝ) * (4 * t ^ 2 + 121 : ℝ) * (4 * t ^ 2 + 169 : ℝ) * (4 * t ^ 2 + 225 : ℝ) := by
          rw [Dfulldef]
          field_simp [(by positivity : (4 * t ^ 2 + 1 : ℝ) ≠ 0)]
          ring
        have hk1 : (4 * t / (4 * t ^ 2 + 9 : ℝ)) * Dfull = 512 * t ^ 2 * (13 * t / 8 - 1) * (4 * t ^ 2 + 1 : ℝ) * (4 * t ^ 2 + 25 : ℝ) * (4 * t ^ 2 + 49 : ℝ) * (4 * t ^ 2 + 81 : ℝ) * (4 * t ^ 2 + 121 : ℝ) * (4 * t ^ 2 + 169 : ℝ) * (4 * t ^ 2 + 225 : ℝ) := by
          rw [Dfulldef]
          field_simp [(by positivity : (4 * t ^ 2 + 9 : ℝ) ≠ 0)]
          ring
        have hk2 : (4 * t / (4 * t ^ 2 + 25 : ℝ)) * Dfull = 512 * t ^ 2 * (13 * t / 8 - 1) * (4 * t ^ 2 + 1 : ℝ) * (4 * t ^ 2 + 9 : ℝ) * (4 * t ^ 2 + 49 : ℝ) * (4 * t ^ 2 + 81 : ℝ) * (4 * t ^ 2 + 121 : ℝ) * (4 * t ^ 2 + 169 : ℝ) * (4 * t ^ 2 + 225 : ℝ) := by
          rw [Dfulldef]
          field_simp [(by positivity : (4 * t ^ 2 + 25 : ℝ) ≠ 0)]
          ring
        have hk3 : (4 * t / (4 * t ^ 2 + 49 : ℝ)) * Dfull = 512 * t ^ 2 * (13 * t / 8 - 1) * (4 * t ^ 2 + 1 : ℝ) * (4 * t ^ 2 + 9 : ℝ) * (4 * t ^ 2 + 25 : ℝ) * (4 * t ^ 2 + 81 : ℝ) * (4 * t ^ 2 + 121 : ℝ) * (4 * t ^ 2 + 169 : ℝ) * (4 * t ^ 2 + 225 : ℝ) := by
          rw [Dfulldef]
          field_simp [(by positivity : (4 * t ^ 2 + 49 : ℝ) ≠ 0)]
          ring
        have hk4 : (4 * t / (4 * t ^ 2 + 81 : ℝ)) * Dfull = 512 * t ^ 2 * (13 * t / 8 - 1) * (4 * t ^ 2 + 1 : ℝ) * (4 * t ^ 2 + 9 : ℝ) * (4 * t ^ 2 + 25 : ℝ) * (4 * t ^ 2 + 49 : ℝ) * (4 * t ^ 2 + 121 : ℝ) * (4 * t ^ 2 + 169 : ℝ) * (4 * t ^ 2 + 225 : ℝ) := by
          rw [Dfulldef]
          field_simp [(by positivity : (4 * t ^ 2 + 81 : ℝ) ≠ 0)]
          ring
        have hk5 : (4 * t / (4 * t ^ 2 + 121 : ℝ)) * Dfull = 512 * t ^ 2 * (13 * t / 8 - 1) * (4 * t ^ 2 + 1 : ℝ) * (4 * t ^ 2 + 9 : ℝ) * (4 * t ^ 2 + 25 : ℝ) * (4 * t ^ 2 + 49 : ℝ) * (4 * t ^ 2 + 81 : ℝ) * (4 * t ^ 2 + 169 : ℝ) * (4 * t ^ 2 + 225 : ℝ) := by
          rw [Dfulldef]
          field_simp [(by positivity : (4 * t ^ 2 + 121 : ℝ) ≠ 0)]
          ring
        have hk6 : (4 * t / (4 * t ^ 2 + 169 : ℝ)) * Dfull = 512 * t ^ 2 * (13 * t / 8 - 1) * (4 * t ^ 2 + 1 : ℝ) * (4 * t ^ 2 + 9 : ℝ) * (4 * t ^ 2 + 25 : ℝ) * (4 * t ^ 2 + 49 : ℝ) * (4 * t ^ 2 + 81 : ℝ) * (4 * t ^ 2 + 121 : ℝ) * (4 * t ^ 2 + 225 : ℝ) := by
          rw [Dfulldef]
          field_simp [(by positivity : (4 * t ^ 2 + 169 : ℝ) ≠ 0)]
          ring
        have hk7 : (4 * t / (4 * t ^ 2 + 225 : ℝ)) * Dfull = 512 * t ^ 2 * (13 * t / 8 - 1) * (4 * t ^ 2 + 1 : ℝ) * (4 * t ^ 2 + 9 : ℝ) * (4 * t ^ 2 + 25 : ℝ) * (4 * t ^ 2 + 49 : ℝ) * (4 * t ^ 2 + 81 : ℝ) * (4 * t ^ 2 + 121 : ℝ) * (4 * t ^ 2 + 169 : ℝ) := by
          rw [Dfulldef]
          field_simp [(by positivity : (4 * t ^ 2 + 225 : ℝ) ≠ 0)]
          ring
        have hB : ((1/2 : ℝ) / t) * Dfull = 64 * (13 * t / 8 - 1) * (4 * t ^ 2 + 1 : ℝ) * (4 * t ^ 2 + 9 : ℝ) * (4 * t ^ 2 + 25 : ℝ) * (4 * t ^ 2 + 49 : ℝ) * (4 * t ^ 2 + 81 : ℝ) * (4 * t ^ 2 + 121 : ℝ) * (4 * t ^ 2 + 169 : ℝ) * (4 * t ^ 2 + 225 : ℝ) := by
          rw [Dfulldef]
          field_simp [(by positivity : (2 * t : ℝ) ≠ 0)]
          ring
        have F0 : 512 * t ^ 2 * (13 * t / 8 - 1) * (4 * t ^ 2 + 9 : ℝ) * (4 * t ^ 2 + 25 : ℝ) * (4 * t ^ 2 + 49 : ℝ) * (4 * t ^ 2 + 81 : ℝ) * (4 * t ^ 2 + 121 : ℝ) * (4 * t ^ 2 + 169 : ℝ) * (4 * t ^ 2 + 225 : ℝ) = (13631488) * t ^ 17 + (-8388608) * t ^ 16 + (2313945088) * t ^ 15 + (-1423966208) * t ^ 14 + (152308875264) * t ^ 13 + (-93728538624) * t ^ 12 + (4953356222464) * t ^ 11 + (-3048219213824) * t ^ 10 + (84037764149248) * t ^ 9 + (-51715547168768) * t ^ 8 + (721038758888448) * t ^ 7 + (-443716159315968) * t ^ 6 + (2768900161248000) * t ^ 5 + (-1703938560768000) * t ^ 4 + (3418546851720000) * t ^ 3 + (-2103721139520000) * t ^ 2 := by
          ring
        have F1 : 512 * t ^ 2 * (13 * t / 8 - 1) * (4 * t ^ 2 + 1 : ℝ) * (4 * t ^ 2 + 25 : ℝ) * (4 * t ^ 2 + 49 : ℝ) * (4 * t ^ 2 + 81 : ℝ) * (4 * t ^ 2 + 121 : ℝ) * (4 * t ^ 2 + 169 : ℝ) * (4 * t ^ 2 + 225 : ℝ) = (13631488) * t ^ 17 + (-8388608) * t ^ 16 + (2286682112) * t ^ 15 + (-1407188992) * t ^ 14 + (147742326784) * t ^ 13 + (-90918354944) * t ^ 12 + (4659013206016) * t ^ 11 + (-2867085049856) * t ^ 10 + (74793323491328) * t ^ 9 + (-46026660610048) * t ^ 8 + (573763222070272) * t ^ 7 + (-353085059735552) * t ^ 6 + (1658192601312000) * t ^ 5 + (-1020426216192000) * t ^ 4 + (379838539080000) * t ^ 3 + (-233746793280000) * t ^ 2 := by
          ring
        have F2 : 512 * t ^ 2 * (13 * t / 8 - 1) * (4 * t ^ 2 + 1 : ℝ) * (4 * t ^ 2 + 9 : ℝ) * (4 * t ^ 2 + 49 : ℝ) * (4 * t ^ 2 + 81 : ℝ) * (4 * t ^ 2 + 121 : ℝ) * (4 * t ^ 2 + 169 : ℝ) * (4 * t ^ 2 + 225 : ℝ) = (13631488) * t ^ 17 + (-8388608) * t ^ 16 + (2232156160) * t ^ 15 + (-1373634560) * t ^ 14 + (138936385536) * t ^ 13 + (-85499314176) * t ^ 12 + (4123081031680) * t ^ 11 + (-2537280634880) * t ^ 10 + (59506846756864) * t ^ 9 + (-36619598004224) * t ^ 8 + (370130407695360) * t ^ 7 + (-227772558581760) * t ^ 6 + (635844802874112) * t ^ 5 + (-391289109460992) * t ^ 4 + (136741874068800) * t ^ 3 + (-84148845580800) * t ^ 2 := by
          ring
        have F3 : 512 * t ^ 2 * (13 * t / 8 - 1) * (4 * t ^ 2 + 1 : ℝ) * (4 * t ^ 2 + 9 : ℝ) * (4 * t ^ 2 + 25 : ℝ) * (4 * t ^ 2 + 81 : ℝ) * (4 * t ^ 2 + 121 : ℝ) * (4 * t ^ 2 + 169 : ℝ) * (4 * t ^ 2 + 225 : ℝ) = (13631488) * t ^ 17 + (-8388608) * t ^ 16 + (2150367232) * t ^ 15 + (-1323302912) * t ^ 14 + (126545362944) * t ^ 13 + (-77874069504) * t ^ 12 + (3441252745216) * t ^ 11 + (-2117693997056) * t ^ 10 + (43120757075968) * t ^ 9 + (-26535850508288) * t ^ 8 + (213818925745152) * t ^ 7 + (-131580877381632) * t ^ 6 + (329878010592000) * t ^ 5 + (-203001852672000) * t ^ 4 + (69766262280000) * t ^ 3 + (-42933084480000) * t ^ 2 := by
          ring
        have F4 : 512 * t ^ 2 * (13 * t / 8 - 1) * (4 * t ^ 2 + 1 : ℝ) * (4 * t ^ 2 + 9 : ℝ) * (4 * t ^ 2 + 25 : ℝ) * (4 * t ^ 2 + 49 : ℝ) * (4 * t ^ 2 + 121 : ℝ) * (4 * t ^ 2 + 169 : ℝ) * (4 * t ^ 2 + 225 : ℝ) = (13631488) * t ^ 17 + (-8388608) * t ^ 16 + (2041315328) * t ^ 15 + (-1256194048) * t ^ 14 + (111550726144) * t ^ 13 + (-68646600704) * t ^ 12 + (2732531236864) * t ^ 11 + (-1681557684224) * t ^ 10 + (29942345658368) * t ^ 9 + (-18426058866688) * t ^ 8 + (135715700343808) * t ^ 7 + (-83517354057728) * t ^ 6 + (200916919008000) * t ^ 5 + (-123641180928000) * t ^ 4 + (42204282120000) * t ^ 3 + (-25971865920000) * t ^ 2 := by
          ring
        have F5 : 512 * t ^ 2 * (13 * t / 8 - 1) * (4 * t ^ 2 + 1 : ℝ) * (4 * t ^ 2 + 9 : ℝ) * (4 * t ^ 2 + 25 : ℝ) * (4 * t ^ 2 + 49 : ℝ) * (4 * t ^ 2 + 81 : ℝ) * (4 * t ^ 2 + 169 : ℝ) * (4 * t ^ 2 + 225 : ℝ) = (13631488) * t ^ 17 + (-8388608) * t ^ 16 + (1905000448) * t ^ 15 + (-1172307968) * t ^ 14 + (95261097984) * t ^ 13 + (-58622214144) * t ^ 12 + (2109785227264) * t ^ 11 + (-1298329370624) * t ^ 10 + (21455100080128) * t ^ 9 + (-13203138510848) * t ^ 8 + (93031422501888) * t ^ 7 + (-57250106155008) * t ^ 6 + (134959320288000) * t ^ 5 + (-83051889408000) * t ^ 4 + (28252453320000) * t ^ 3 + (-17386125120000) * t ^ 2 := by
          ring
        have F6 : 512 * t ^ 2 * (13 * t / 8 - 1) * (4 * t ^ 2 + 1 : ℝ) * (4 * t ^ 2 + 9 : ℝ) * (4 * t ^ 2 + 25 : ℝ) * (4 * t ^ 2 + 49 : ℝ) * (4 * t ^ 2 + 81 : ℝ) * (4 * t ^ 2 + 121 : ℝ) * (4 * t ^ 2 + 225 : ℝ) = (13631488) * t ^ 17 + (-8388608) * t ^ 16 + (1741422592) * t ^ 15 + (-1071644672) * t ^ 14 + (79312257024) * t ^ 13 + (-48807542784) * t ^ 12 + (1640490582016) * t ^ 11 + (-1009532665856) * t ^ 10 + (15965376114688) * t ^ 9 + (-9824846839808) * t ^ 8 + (67511059080192) * t ^ 7 + (-41545267126272) * t ^ 6 + (96817604832000) * t ^ 5 + (-59580064512000) * t ^ 4 + (20228087880000) * t ^ 3 + (-12448054080000) * t ^ 2 := by
          ring
        have F7 : 512 * t ^ 2 * (13 * t / 8 - 1) * (4 * t ^ 2 + 1 : ℝ) * (4 * t ^ 2 + 9 : ℝ) * (4 * t ^ 2 + 25 : ℝ) * (4 * t ^ 2 + 49 : ℝ) * (4 * t ^ 2 + 81 : ℝ) * (4 * t ^ 2 + 121 : ℝ) * (4 * t ^ 2 + 169 : ℝ) = (13631488) * t ^ 17 + (-8388608) * t ^ 16 + (1550581760) * t ^ 15 + (-954204160) * t ^ 14 + (65667137536) * t ^ 13 + (-40410546176) * t ^ 12 + (1297656954880) * t ^ 11 + (-798558126080) * t ^ 10 + (12282899492864) * t ^ 9 + (-7558707380224) * t ^ 8 + (51135103452160) * t ^ 7 + (-31467755970560) * t ^ 6 + (72810281786112) * t ^ 5 + (-44806327252992) * t ^ 4 + (15193541563200) * t ^ 3 + (-9349871731200) * t ^ 2 := by
          ring
        have FB : 64 * (13 * t / 8 - 1) * (4 * t ^ 2 + 1 : ℝ) * (4 * t ^ 2 + 9 : ℝ) * (4 * t ^ 2 + 25 : ℝ) * (4 * t ^ 2 + 49 : ℝ) * (4 * t ^ 2 + 81 : ℝ) * (4 * t ^ 2 + 121 : ℝ) * (4 * t ^ 2 + 169 : ℝ) * (4 * t ^ 2 + 225 : ℝ) = (6815744) * t ^ 17 + (-4194304) * t ^ 16 + (1158676480) * t ^ 15 + (-713031680) * t ^ 14 + (76443680768) * t ^ 13 + (-47042265088) * t ^ 12 + (2495716720640) * t ^ 11 + (-1535825674240) * t ^ 10 + (42638051602432) * t ^ 9 + (-26238800986112) * t ^ 8 + (371024099962880) * t ^ 7 + (-228322523054080) * t ^ 6 + (1474579925485056) * t ^ 5 + (-907433800298496) * t ^ 4 + (2055385946016000) * t ^ 3 + (-1264852889856000) * t ^ 2 + (427318356465000) * t ^ 1 + -262965142440000 := by
          ring
        have FC : 1560 * t * (4 * t ^ 2 + 1 : ℝ) * (4 * t ^ 2 + 9 : ℝ) * (4 * t ^ 2 + 25 : ℝ) * (4 * t ^ 2 + 49 : ℝ) * (4 * t ^ 2 + 81 : ℝ) * (4 * t ^ 2 + 121 : ℝ) * (4 * t ^ 2 + 169 : ℝ) * (4 * t ^ 2 + 225 : ℝ) = (102236160) * t ^ 17 + (17380147200) * t ^ 15 + (1146655211520) * t ^ 13 + (37435750809600) * t ^ 11 + (639570774036480) * t ^ 9 + (5565361499443200) * t ^ 7 + (22118698882275840) * t ^ 5 + (30830789190240000) * t ^ 3 + (6409775346975000) * t ^ 1 := by
          ring
        have hC : (((15/2 : ℝ) * (13/8 : ℝ)) / (13 * t / 8 - 1)) * Dfull = 1560 * t * (4 * t ^ 2 + 1 : ℝ) * (4 * t ^ 2 + 9 : ℝ) * (4 * t ^ 2 + 25 : ℝ) * (4 * t ^ 2 + 49 : ℝ) * (4 * t ^ 2 + 81 : ℝ) * (4 * t ^ 2 + 121 : ℝ) * (4 * t ^ 2 + 169 : ℝ) * (4 * t ^ 2 + 225 : ℝ) := by
          have hY : (13 * t / 8 - 1 : ℝ) ≠ 0 := ne_of_gt (by linarith [ht])
          rw [Dfulldef]
          rw [show (((15/2 : ℝ) * (13/8 : ℝ)) / (13 * t / 8 - 1)) * (128 * t * (13 * t / 8 - 1) * (4 * t ^ 2 + 1 : ℝ) * (4 * t ^ 2 + 9 : ℝ) * (4 * t ^ 2 + 25 : ℝ) * (4 * t ^ 2 + 49 : ℝ) * (4 * t ^ 2 + 81 : ℝ) * (4 * t ^ 2 + 121 : ℝ) * (4 * t ^ 2 + 169 : ℝ) * (4 * t ^ 2 + 225 : ℝ)) =
                (((15/2 : ℝ) * (13/8 : ℝ)) : ℝ) * ((13 * t / 8 - 1 : ℝ)⁻¹ * (13 * t / 8 - 1)) * (128 * t * ((4 * t ^ 2 + 1 : ℝ) * (4 * t ^ 2 + 9 : ℝ) * (4 * t ^ 2 + 25 : ℝ) * (4 * t ^ 2 + 49 : ℝ) * (4 * t ^ 2 + 81 : ℝ) * (4 * t ^ 2 + 121 : ℝ) * (4 * t ^ 2 + 169 : ℝ) * (4 * t ^ 2 + 225 : ℝ))) from by ring]
          rw [show (13 * t / 8 - 1 : ℝ)⁻¹ * (13 * t / 8 - 1) = 1 from by
            field_simp [hY, ne_of_gt (show (13 * t - 8 : ℝ) > 0 by linarith [ht])]]
          ring
        rw [hk0, hk1, hk2, hk3, hk4, hk5, hk6, hk7, hB, hC, F0, F1, F2, F3, F4, F5, F6, F7, FB, FC]
        ring
  rw [show t3wB_num7 t / (t3wB_den 7 t) = t3wB_h 7 t from by rw [← hmult]; field_simp [hden]]










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
  rw [t3wB_h2_id ht]
  exact div_neg_of_neg_of_pos (t3wB_num2_neg ht0) hden
  · rcases hi with (rfl | hi)
    rw [t3wB_h4_id ht]
    exact div_neg_of_neg_of_pos (t3wB_num4_neg ht0) hden
    · rcases hi with rfl
      rw [t3wB_h6_id ht]
      exact div_neg_of_neg_of_pos (t3wB_num6_neg ht0) hden



-- ---------------------------------------------------------------
-- 25ae Stage 3B.11 — Part B batch 2: structure of the i = 7
-- numerator (single zero on [13, ∞), via Taylor-at-13 sign pattern
-- + strict convexity + Rolle/MVT.
-- ---------------------------------------------------------------

/-- Taylor coefficients of t3wB_num7 at 13:
    t3wB_num7 (13 + u) = ∑_{k < 18} t3wB_b k * u^k.
    Sympy-verified (scripts/rh/day026_25ae_t3wallB.py):
    b_0 < 0, b_1 < 0, and b_k > 0 for all k ≥ 2. -/
def t3wB_b (k : ℕ) : ℝ :=

  if k = 0 then (-55519170304302480236900400 : ℝ)
  else if k = 1 then (-28036883178529140180290480 : ℝ)
  else if k = 2 then (4514401961248816376413184 : ℝ)
  else if k = 3 then (8389006854442158499609600 : ℝ)
  else if k = 4 then (3684115010285902171198464 : ℝ)
  else if k = 5 then (964289445452503150822400 : ℝ)
  else if k = 6 then (176374465738513174659072 : ℝ)
  else if k = 7 then (24047222295903380307968 : ℝ)
  else if k = 8 then (2525050408927726231552 : ℝ)
  else if k = 9 then (207670353674595688448 : ℝ)
  else if k = 10 then (13468759131499003904 : ℝ)
  else if k = 11 then (687984546391261184 : ℝ)
  else if k = 12 then (27421829717295104 : ℝ)
  else if k = 13 then (836777672966144 : ℝ)
  else if k = 14 then (18908174090240 : ℝ)
  else if k = 15 then (298475061248 : ℝ)
  else if k = 16 then (2941255680 : ℝ)
  else if k = 17 then (13631488 : ℝ)
  else 0

/-- Shifted form of t3wB_num7 at 13 (flat, for ring/norm_num). -/
noncomputable def t3wB_N7shift  (-55519170304302480236900400 : ℝ)
      + (-28036883178529140180290480 : ℝ) * (u) ^ 1
      + (4514401961248816376413184 : ℝ) * (u) ^ 2
      + (8389006854442158499609600 : ℝ) * (u) ^ 3
      + (3684115010285902171198464 : ℝ) * (u) ^ 4
      + (964289445452503150822400 : ℝ) * (u) ^ 5
      + (176374465738513174659072 : ℝ) * (u) ^ 6
      + (24047222295903380307968 : ℝ) * (u) ^ 7
      + (2525050408927726231552 : ℝ) * (u) ^ 8
      + (207670353674595688448 : ℝ) * (u) ^ 9
      + (13468759131499003904 : ℝ) * (u) ^ 10
      + (687984546391261184 : ℝ) * (u) ^ 11
      + (27421829717295104 : ℝ) * (u) ^ 12
      + (836777672966144 : ℝ) * (u) ^ 13
      + (18908174090240 : ℝ) * (u) ^ 14
      + (298475061248 : ℝ) * (u) ^ 15
      + (2941255680 : ℝ) * (u) ^ 16
      + (13631488 : ℝ) * (u) ^ 17


-- T1: flat identity via dsimp + ring (boosted hearts)
set_option maxHeartbeats 600000 in
theorem T1 {u : Real} : t3wB_num7 (13 + u) = t3wB_N7shift u := by
  dsimp only [t3wB_N7shift, t3wB_num7]
  ring

-- T2: via ring_nf + rfl
set_option maxHeartbeats 600000 in
theorem T2 {u : Real} : t3wB_num7 (13 + u) = t3wB_N7shift u := by
  have hw : 13 + (u) = 13 + u := rfl
  dsimp only [t3wB_N7shift, t3wB_num7]
  ring_nf
  norm_num
