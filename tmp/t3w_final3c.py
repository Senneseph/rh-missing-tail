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
D = {2: '720', 4: '30240', 6: '1209600', 7: '9072000'}
P = {2: '7/2', 4: '11/2', 6: '15/2', 7: '15/2'}
PNUM = {2: '7', 4: '11', 6: '15', 7: '15'}    # 2k+1
PK   = {2: '3', 4: '5', 6: '7', 7: '7'}      # k
TSTAR = {'A1': '16 / 13', 'A2': '4', 'A3': '8', 'A4': '13'}
HNMIN = {'A1': '1', 'A2': '2', 'A3': '6', 'A4': '13'}
HNMINI = {'A1': 1, 'A2': 2, 'A3': 6, 'A4': 13}
HLO = {'A1': '1', 'A2': '16 / 13', 'A3': '4', 'A4': '8'}
HHLB = {'A1': '35 / 78', 'A2': '35 / 234', 'A3': '35 / 312', 'A4': '35 / 390'}
PROJ = {2: '.1', 4: '.2.1', 6: '.2.2.1', 7: '.2.2.2'}

def qn(n, r): return f't3w_q{n}_{r}'
def rn(n, r): return f't3w_r{n}_{r}'

o = []
o.append('''/- 25ae Stage 3B.11 -- The list-scale wall for the sharpened T3 bound.
   Part A (1 <= t <= 13), four bands.  Endpoint constants (records in
   scripts/rh/day026_25ae_t3wall.py, exact Fraction + isqrt):
   t3w_qB_r = strict rational upper bound of sqrt(t3w_prod t* r) at the band
   endpoint t*; t3w_rB_r = strict rational upper bound of (n_min)^(-p_r).
   Every comparison closes by norm_num.  Part B (13 <= t <= 1e8): batch 2. -/
set_option maxSynthPendingDepth 8

/-- t3w_prod t i = prod_{k <= i} (t^2 + (k + 1/2)^2) = |S_i(t)|^2. -/
def t3w_prod (t : ℝ) (i : ℕ) : ℝ :=
  ∏ k ∈ Finset.range (i + 1), (t ^ 2 + (k + 1 / 2 : ℝ) ^ 2)

/-- Powers p_i of the list scale n in term i (7/2, 11/2, 15/2, 15/2). -/
def t3w_p (i : ℕ) : ℝ :=
  if i = 2 then 7 / 2 else if i = 4 then 11 / 2 else if i = 6 then 15 / 2
  else if i = 7 then 15 / 2 else 0

/-- Denominators d_i (720, 30240, 1209600, 9072000). -/
def t3w_d (i : ℕ) : ℝ :=
  if i = 2 then 720 else if i = 4 then 30240 else if i = 6 then 1209600
  else if i = 7 then 9072000 else 1

/-- Term i of the sharpened T3 bound at list scale: |S_i(t)| * n^{-p_i} / d_i. -/
def t3w_term (n : ℕ) (t : ℝ) (i : ℕ) : ℝ :=
  Real.sqrt (t3w_prod t i) * (n : ℝ) ^ (-(t3w_p i)) / (t3w_d i)

/-- The sharpened 4-term bound. -/
def t3w_T3UB (n : ℕ) (t : ℝ) : ℝ :=
  t3w_term n t 2 + t3w_term n t 4 + t3w_term n t 6 + t3w_term n t 7

/-- t3w_prod is increasing for 0 <= t <= t'. -/
theorem t3w_prod_mono {t t' : ℝ} (h0 : 0 <= t) (h : t <= t') (i : ℕ) :
    t3w_prod t i <= t3w_prod t' i := by
  dsimp only [t3w_prod]
  gcongr
  all_goals nlinarith [sq_le_sq (by linarith [h0]) (by linarith [h0, h])]

/-- n^{-p} <= 1 for n >= 1 and p > 0. -/
theorem t3w_invpow_le_one (n : ℕ) (hn : 1 <= n) (p : ℝ) (hp : 0 < p) :
    (n : ℝ) ^ (-p) <= 1 := by
  have h1p : (1 : ℝ) <= (n : ℝ) ^ p := Real.one_le_rpow (by exact_mod_cast hn) hp.le
  calc
    (n : ℝ) ^ (-p) = ((n : ℝ) ^ p)⁻¹ := by rw [rpow_neg (Nat.cast_nonneg n)]
    _ = 1 / (n : ℝ) ^ p := by rw [inv_eq_one_div]
    _ <= 1 / 1 := (one_div_le_one_div (by positivity) (by norm_num : 0 < (1 : ℝ))).mpr h1p
    _ = 1 := by norm_num

''')
for b in ['A1', 'A2', 'A3', 'A4']:
    ts = f'({TSTAR[b]})'
    for r in (2, 4, 6, 7):
        a, bb = Q[b][r]
        o.append(f'def {qn(b, r)} : ℝ := ({a} : ℝ) / {bb}\n')
        a, bb = R[b][r]
        o.append(f'def {rn(b, r)} : ℝ := ({a} : ℝ) / {bb}\n')
    cds = ', '.join(f'{qn(b, r)}, {rn(b, r)}' for r in (2, 4, 6, 7))
    o.append(f'''
theorem t3w_q{b} :
    Real.sqrt (t3w_prod {ts} 2) < {qn(b, 2)} ∧
    Real.sqrt (t3w_prod {ts} 4) < {qn(b, 4)} ∧
    Real.sqrt (t3w_prod {ts} 6) < {qn(b, 6)} ∧
    Real.sqrt (t3w_prod {ts} 7) < {qn(b, 7)} := by
  refine ⟨?_, ?_, ?_, ?_⟩
  all_goals exact (Real.sqrt_lt' (by norm_num [{cds}])).mpr (by norm_num [t3w_prod, {cds}])
''')
for b in ['A1', 'A2', 'A3', 'A4']:
    ts, nmin, nmini, hb, hlb = TSTAR[b], HNMIN[b], HNMINI[b], HLO[b], HHLB[b]
    L = []
    L.append(f'''
/-- {b}: {hb} <= t < {ts} (n >= {nmin}). -/
theorem t3w_wall_{b} {{t : ℝ}} (ht : {hb} <= t) (htb : t < {ts}) {{n : ℕ}}
    (hn : n = ⌊(13 : ℝ) * t / 8⌋₊) :
    t3w_T3UB n t < {hlb} := by
  have hnmin : {nmin} <= n := by
    rw [hn]
    exact (Nat.le_floor_iff' (show ({nmin} : ℕ) ≠ 0 from by norm_num)).mpr (by linarith [ht])
  have htstar : t <= {ts} := htb.le
  have h0t : 0 <= t := by linarith [ht]''')
    for r in (2, 4, 6, 7):
        L.append(f'  have hS{r} : Real.sqrt (t3w_prod t {r}) < {qn(b, r)} := by\n'
                 f'    exact lt_of_le_of_lt (Real.sqrt_le_sqrt (t3w_prod_mono h0t htstar {r})) t3w_q{b}{PROJ[r]}\n')
    for r in (2, 4, 6, 7):
        if b == 'A1':
            L.append(f'  have hR{r} : (n : ℝ) ^ (-( {P[r]} : ℝ)) <= {rn(b, r)} := by\n'
                     f'    calc\n'
                     f'      (n : ℝ) ^ (-( {P[r]} : ℝ)) <= 1 := t3w_invpow_le_one n (by linarith [hnmin]) ({P[r]}) (by norm_num)\n'
                     f'      _ <= {rn(b, r)} := by norm_num [{rn(b, r)}]\n')
        else:
            pn, k = PNUM[r], PK[r]
            L.append(f'''
  have hR{r} : (n : ℝ) ^ (-( {P[r]} : ℝ)) < {rn(b, r)} := by
    calc
      (n : ℝ) ^ (-( {P[r]} : ℝ)) = 1 / (n : ℝ) ^ ( {P[r]} : ℝ) := by rw [rpow_neg (Nat.cast_nonneg n), inv_eq_one_div]
      _ <= 1 / ({nmini} : ℝ) ^ ( {P[r]} : ℝ) := by
        have hbase : ({nmini} : ℝ) <= (n : ℝ) := Nat.cast_le.mpr hnmin
        exact (one_div_le_one_div (rpow_pos_of_pos (by norm_num : (0 : ℝ) < {nmini}) ( {P[r]} : ℝ))
          (rpow_pos_of_pos (Nat.cast_pos.mpr (show (0 : ℕ) < n from by linarith [hnmin])) ( {P[r]} : ℝ))).mpr
          (rpow_le_rpow (by norm_num) hbase (by norm_num))
      _ < {rn(b, r)} := by
        have hrew : ({nmini} : ℝ) ^ ( {P[r]} : ℝ) = Real.sqrt (({nmini} : ℝ) ^ ({pn} : ℕ)) := by
          have hp2 : ( {P[r]} : ℝ) = ({pn} : ℝ) / 2 := by norm_num
          rw [hp2, show ({nmini} : ℝ) ^ (({pn} : ℝ) / 2) = ({nmini} : ℝ) ^ (({pn} : ℝ) * (1 / 2)) from by norm_num]
          rw [Real.rpow_mul (by norm_num : 0 ≤ ({nmini} : ℝ)) ({pn} : ℝ) (1 / 2)]
          rw [show ({pn} : ℝ) = ({pn} : ℕ) from by norm_num]
          rw [Real.rpow_natCast, ← sqrt_eq_rpow]
        rw [hrew]
        rw [one_div_lt (by positivity) (by norm_num : 0 < {rn(b, r)})]
        exact (Real.lt_sqrt (by positivity)).mpr (by norm_num)
''')
    for r in (2, 4, 6, 7):
        L.append(f'''  have hT{r} : t3w_term n t {r} < {qn(b, r)} * {rn(b, r)} / {D[r]} := by
    calc
      t3w_term n t {r} = Real.sqrt (t3w_prod t {r}) * (n : ℝ) ^ (-( {P[r]} : ℝ)) / {D[r]} := by
        simp [t3w_term, t3w_p, t3w_d]
      _ <= Real.sqrt (t3w_prod t {r}) * ({rn(b, r)} : ℝ) / {D[r]} := by
        gcongr
        all_goals (try exact hR{r}) <;> (try exact le_of_lt hR{r}) <;> (try norm_num) <;> (try positivity)
      _ < {qn(b, r)} * ({rn(b, r)} : ℝ) / {D[r]} := by
        gcongr
        all_goals (try exact hS{r}) <;> (try norm_num) <;> (try positivity)
''')
    cds = ', '.join(f'{qn(b, r)}, {rn(b, r)}' for r in (2, 4, 6, 7))
    L.append(f'''  calc
    t3w_T3UB n t = t3w_term n t 2 + t3w_term n t 4 + t3w_term n t 6 + t3w_term n t 7 := rfl
    _ < {qn(b, 2)} * ({rn(b, 2)} : ℝ) / 720 + {qn(b, 4)} * ({rn(b, 4)} : ℝ) / 30240 +
        {qn(b, 6)} * ({rn(b, 6)} : ℝ) / 1209600 + {qn(b, 8)} * ({rn(b, 8)} : ℝ) / 9072000 := by
      gcongr
      all_goals (try exact hT2) <;> (try exact hT4) <;> (try exact hT6) <;> (try exact hT7) <;> (try norm_num) <;> (try positivity)
    _ < {hlb} := by norm_num [{cds}]
''')
    o.append('\n'.join(L) + '\n')
open('/tmp/t3w_block3.lean', 'w').write(''.join(o))
print('block written:', len(''.join(o)))
