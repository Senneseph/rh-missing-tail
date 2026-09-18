# 25ae 3B.11 Part A — flat block generator (final)
Q = {
 'A1': {2: (2218821909, 308915776), 4: (17550033412413605, 141167095653376),
        6: (149512256733405629341179, 32254987351648575488), 7: (1536332078500642084460770895, 43608742899428874059776)},
 'A2': {2: (5199, 64), 4: (2661867, 1024), 6: (2210599813, 16384), 7: (75160393639, 65536)},
 'A3': {2: (17499, 32), 4: (22440241, 512), 6: (17964810777, 4096), 7: (3151992477389, 65536)},
 'A4': {2: (144241, 64), 4: (213715271, 512), 6: (701541006115, 8192), 7: (42115838574947, 32768)},
}
R = {
 'A1': {2: (1, 1), 4: (1, 1), 6: (1, 1), 7: (1, 1)},
 'A2': {2: (1, 8), 4: (1, 32), 6: (1, 128), 7: (1, 128)},
 'A3': {2: (1, 432), 4: (1, 15552), 6: (1, 559872), 7: (1, 559872)},
 'A4': {2: (1, 6591), 4: (1, 1113879), 6: (1, 188245551), 7: (1, 188245551)},
}
DEN = {2: 720, 4: 30240, 6: 1209600, 7: 9072000}
POW = {2: '7/2', 4: '11/2', 6: '15/2', 7: '15/2'}
PNAT = {2: 7, 4: 11, 6: 15, 7: 15}
TSTAR = {'A1': '16 / 13', 'A2': '4', 'A3': '8', 'A4': '13'}
HNMIN = {'A1': '1', 'A2': '2', 'A3': '6', 'A4': '13'}
HLO = {'A1': '1', 'A2': '16 / 13', 'A3': '4', 'A4': '8'}
HHLB = {'A1': '35 / 78', 'A2': '35 / 234', 'A3': '35 / 312', 'A4': '35 / 390'}
PROJ = {2: '.1', 4: '.2.1', 6: '.2.2.1', 7: '.2.2.2'}

def QD(b, r):
    a, d = Q[b][r]
    return f'({a} : ℝ) / {d}'

def RD(b, r):
    a, d = R[b][r]
    return f'({a} : ℝ) / {d}'

def QN(b, r):
    return f't3w_q{b}_{r}'

def RN(b, r):
    return f't3w_r{b}_{r}'

L = []
L.append('/- 25ae Stage 3B.11 -- The list-scale wall for the sharpened T3 bound.')
L.append('   Part A (1 <= t <= 13), four bands.  Endpoint constants (records in')
L.append('   scripts/rh/day026_25ae_t3wall.py, exact Fraction + isqrt):')
L.append('   t3w_qB_r = strict rational upper bound of sqrt(t3w_prod t* r) at the band')
L.append('   endpoint t*; t3w_rB_r = strict rational upper bound of (n_min)^(-p_r).')
L.append('   The product indices i in {2,4,6,7} match the four terms of')
L.append('   p4_25ae_T3_bound (3, 5, 7, 8 factors; i = 7 is the |S6|*|s+7| product).')
L.append('   Every comparison closes by norm_num.  Part B (13 <= t <= 1e8): batch 2. -/')
L.append('set_option maxSynthPendingDepth 8')
L.append('')
L.append('/-- t3w_prod t i = prod_{k <= i} (t^2 + (k + 1/2)^2). -/')
L.append('def t3w_prod (t : ℝ) (i : ℕ) : ℝ :=')
L.append('  ∏ k ∈ Finset.range (i + 1), (t ^ 2 + (k + 1 / 2 : ℝ) ^ 2)')
L.append('')
L.append('/-- Powers p_i of the list scale n in term i (7/2, 11/2, 15/2, 15/2). -/')
L.append('def t3w_p (i : ℕ) : ℝ :=')
L.append('  if i = 2 then 7 / 2 else if i = 4 then 11 / 2 else if i = 6 then 15 / 2')
L.append('  else if i = 7 then 15 / 2 else 0')
L.append('')
L.append('/-- Denominators d_i (720, 30240, 1209600, 9072000). -/')
L.append('def t3w_d (i : ℕ) : ℝ :=')
L.append('  if i = 2 then 720 else if i = 4 then 30240 else if i = 6 then 1209600')
L.append('  else if i = 7 then 9072000 else 1')
L.append('')
L.append('/-- Term i of the sharpened T3 bound at list scale: |S_i(t)| * n^{-p_i} / d_i. -/')
L.append('def t3w_term (n : ℕ) (t : ℝ) (i : ℕ) : ℝ :=')
L.append('  Real.sqrt (t3w_prod t i) * (n : ℝ) ^ (-(t3w_p i)) / (t3w_d i)')
L.append('')
L.append('/-- The sharpened 4-term bound. -/')
L.append('def t3w_T3UB (n : ℕ) (t : ℝ) : ℝ :=')
L.append('  t3w_term n t 2 + t3w_term n t 4 + t3w_term n t 6 + t3w_term n t 7')
L.append('')
L.append('/-- t3w_prod is increasing for 0 <= t <= t\u2032. -/')
L.append("theorem t3w_prod_mono {t t' : ℝ} (h0 : 0 <= t) (h : t <= t') (i : ℕ) :")
L.append("    t3w_prod t i <= t3w_prod t' i := by")
L.append('  dsimp only [t3w_prod]')
L.append('  gcongr')
L.append('  all_goals nlinarith [sq_le_sq (by linarith [h0]) (by linarith [h0, h])]')
L.append('')
L.append('/-- n^{-p} <= 1 for n >= 1 and p > 0. -/')
L.append('theorem t3w_invpow_le_one (n : ℕ) (hn : 1 <= n) (p : ℝ) (hp : 0 < p) :')
L.append('    (n : ℝ) ^ (-p) <= 1 := by')
L.append('  have h1p : (1 : ℝ) <= (n : ℝ) ^ p := Real.one_le_rpow (by exact_mod_cast hn) hp.le')
L.append('  calc')
L.append('    (n : ℝ) ^ (-p) = ((n : ℝ) ^ p)⁻¹ := by rw [rpow_neg (Nat.cast_nonneg n)]')
L.append('    _ = 1 / (n : ℝ) ^ p := by rw [inv_eq_one_div]')
L.append('    _ <= 1 / 1 := (one_div_le_one_div (by positivity) (by norm_num : 0 < (1 : ℝ))).mpr h1p')
L.append('    _ = 1 := by norm_num')
L.append('')

for b in ['A1', 'A2', 'A3', 'A4']:
    for r in (2, 4, 6, 7):
        L.append(f'def {QN(b, r)} : ℝ := {QD(b, r)}')
        L.append(f'def {RN(b, r)} : ℝ := {RD(b, r)}')
    ts = f'({TSTAR[b]})'
    L.append('')
    L.append(f'theorem t3w_q{b} :')
    L.append(f'    Real.sqrt (t3w_prod {ts} 2) < {QN(b, 2)} ∧')
    L.append(f'    Real.sqrt (t3w_prod {ts} 4) < {QN(b, 4)} ∧')
    L.append(f'    Real.sqrt (t3w_prod {ts} 6) < {QN(b, 6)} ∧')
    L.append(f'    Real.sqrt (t3w_prod {ts} 7) < {QN(b, 7)} := by')
    cds = ', '.join(f'{QN(b, r)}, {RN(b, r)}' for r in (2, 4, 6, 7))
    L.append(f'  refine ⟨?_, ?_, ?_, ?_⟩')
    L.append(f'  all_goals exact (Real.sqrt_lt\' (by norm_num [{cds}])).mpr (by norm_num [t3w_prod, {cds}])')
    L.append('')

for b in ['A1', 'A2', 'A3', 'A4']:
    ts, nmin, nm, hb, hlb = TSTAR[b], HNMIN[b], int(HNMIN[b]), HLO[b], HHLB[b]
    L.append(f'/-- {b}: {hb} <= t < {ts} (n >= {nmin}). -/')
    L.append(f'theorem t3w_wall_{b} {{t : ℝ}} (ht : {hb} <= t) (htb : t < {ts}) {{n : ℕ}}')
    L.append(f'    (hn : n = ⌊(13 : ℝ) * t / 8⌋₊) :')
    L.append(f'    t3w_T3UB n t < {hlb} := by')
    L.append(f'  have hnmin : {nmin} <= n := by')
    L.append(f'    rw [hn]')
    L.append(f"    exact (Nat.le_floor_iff' (show ({nmin} : ℕ) ≠ 0 from by norm_num)).mpr (by linarith [ht])")
    L.append(f'  have htstar : t <= {ts} := htb.le')
    L.append('  have h0t : 0 <= t := by linarith [ht]')
    for r in (2, 4, 6, 7):
        L.append(f'  have hS{r} : Real.sqrt (t3w_prod t {r}) < {QN(b, r)} := by')
        L.append(f'    exact lt_of_le_of_lt (Real.sqrt_le_sqrt (t3w_prod_mono h0t htstar {r})) t3w_q{b}{PROJ[r]}')
    for r in (2, 4, 6, 7):
        p = POW[r]
        pnat = PNAT[r]
        if b == 'A1':
            L.append(f'  have hR{r} : (n : ℝ) ^ (-( {p} : ℝ)) <= {RN(b, r)} := by')
            L.append('    calc')
            L.append(f'      (n : ℝ) ^ (-( {p} : ℝ)) <= 1 := t3w_invpow_le_one n (by linarith [hnmin]) ({p}) (by norm_num)')
            L.append(f'      _ <= {RN(b, r)} := by norm_num [{RN(b, r)}]')
        else:
            L.append(f'  have hR{r} : (n : ℝ) ^ (-( {p} : ℝ)) < {RN(b, r)} := by')
            L.append('    calc')
            L.append(f'      (n : ℝ) ^ (-( {p} : ℝ)) = 1 / (n : ℝ) ^ ( {p} : ℝ) := by rw [rpow_neg (Nat.cast_nonneg n), inv_eq_one_div]')
            L.append(f'      _ <= 1 / ({nm} : ℝ) ^ ( {p} : ℝ) := by')
            L.append(f'        have hbase : ({nm} : ℝ) <= (n : ℝ) := Nat.cast_le.mpr hnmin')
            L.append('        exact (one_div_le_one_div')
            L.append(f'          (rpow_pos_of_pos (Nat.cast_pos.mpr (show (0 : ℕ) < n from by linarith [hnmin])) ( {p} : ℝ))')
            L.append(f'          (rpow_pos_of_pos (by norm_num : (0 : ℝ) < {nm}) ( {p} : ℝ))).mpr')
            L.append('          (rpow_le_rpow (by norm_num) hbase (by norm_num))')
            L.append(f'      _ < {RN(b, r)} := by')
            L.append(f'        have hrew : ({nm} : ℝ) ^ ( {p} : ℝ) = Real.sqrt (({nm} : ℝ) ^ ({pnat} : ℕ)) := by')
            L.append(f'          have hp2 : ( {p} : ℝ) = ({pnat} : ℝ) / 2 := by norm_num')
            L.append(f'          rw [hp2, show ({nm} : ℝ) ^ (({pnat} : ℝ) / 2) = ({nm} : ℝ) ^ (({pnat} : ℝ) * (1 / 2)) from by norm_num]')
            L.append(f'          rw [Real.rpow_mul (by norm_num : 0 ≤ ({nm} : ℝ)) ({pnat} : ℝ) (1 / 2)]')
            L.append(f'          rw [show ({pnat} : ℝ) = ({pnat} : ℕ) from by norm_num]')
            L.append(f'          rw [Real.rpow_natCast, ← sqrt_eq_rpow]')
            L.append(f'        rw [hrew]')
            L.append(f"        rw [one_div_lt (Real.sqrt_pos.mpr (by norm_num : 0 < ({nm} : ℝ) ^ ({pnat} : ℕ)))")
            L.append(f'                      (by norm_num [{RN(b, r)}] : 0 < {RN(b, r)})]')
            L.append(f'        exact (Real.lt_sqrt (by norm_num [{RN(b, r)}] : 0 ≤ 1 / {RN(b, r)})).mpr (by norm_num [{RN(b, r)}])')
    for r in (2, 4, 6, 7):
        p = POW[r]
        L.append(f'  have hT{r} : t3w_term n t {r} < {QN(b, r)} * {RN(b, r)} / {DEN[r]} := by')
        L.append('    calc')
        L.append(f'      t3w_term n t {r} = Real.sqrt (t3w_prod t {r}) * (n : ℝ) ^ (-( {p} : ℝ)) / {DEN[r]} := by')
        L.append(f'        simp [t3w_term, t3w_p, t3w_d]')
        L.append(f'      _ <= Real.sqrt (t3w_prod t {r}) * ({RN(b, r)} : ℝ) / {DEN[r]} := by')
        L.append('        gcongr')
        L.append(f'        all_goals (try exact hR{r}) <;> (try exact le_of_lt hR{r}) <;> (try norm_num [{RN(b, r)}]) <;> (try positivity)')
        L.append(f'      _ < {QN(b, r)} * ({RN(b, r)} : ℝ) / {DEN[r]} := by')
        L.append('        gcongr')
        L.append(f'        all_goals (try exact hS{r}) <;> (try norm_num [{QN(b, r)}, {RN(b, r)}]) <;> (try positivity)')
    cds = ', '.join(f'{QN(b, r)}, {RN(b, r)}' for r in (2, 4, 6, 7))
    L.append('  calc')
    L.append('    t3w_T3UB n t = t3w_term n t 2 + t3w_term n t 4 + t3w_term n t 6 + t3w_term n t 7 := rfl')
    L.append(f"    _ < {QN(b, 2)} * ({RN(b, 2)} : ℝ) / 720 + {QN(b, 4)} * ({RN(b, 4)} : ℝ) / 30240 +")
    L.append(f"        {QN(b, 6)} * ({RN(b, 6)} : ℝ) / 1209600 + {QN(b, 7)} * ({RN(b, 7)} : ℝ) / 9072000 := by")
    L.append('      gcongr')
    L.append('      all_goals (try exact hT2) <;> (try exact hT4) <;> (try exact hT6) <;> (try exact hT7) <;> (try norm_num) <;> (try positivity)')
    L.append(f'    _ < {hlb} := by norm_num [{cds}]')
    L.append('')

open('/tmp/t3w_blockF.lean', 'w').write('\n'.join(L) + '\n')
print('final block written:', len(L), 'lines')
