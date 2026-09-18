Q = {
 'A1': {2: (2218821909, 308915776), 4: (17550033412413605, 141167095653376),
        6: (149512256733405629341179, 32254987351648575488), 8: (1114978187651465145192020070463, 3684938775001739858051072)},
 'A2': {2: (5199, 64), 4: (2661867, 1024), 6: (2210599813, 16384), 8: (2824271179937, 262144)},
 'A3': {2: (17499, 32), 4: (22440241, 512), 6: (17964810777, 4096), 8: (73584005291547, 131072)},
 'A4': {2: (144241, 64), 4: (213715271, 512), 6: (701541006115, 8192), 8: (5233221300591837, 262144)},
}
R = {
 'A1': {2: (1, 1), 4: (1, 1), 6: (1, 1), 8: (1, 1)},
 'A2': {2: (1, 8), 4: (1, 32), 6: (1, 128), 8: (1, 128)},
 'A3': {2: (1, 432), 4: (1, 15552), 6: (1, 559872), 8: (1, 559872)},
 'A4': {2: (1, 6591), 4: (1, 1113879), 6: (1, 188245551), 8: (1, 188245551)},
}
D = {2: '720', 4: '30240', 6: '1209600', 8: '9072000'}
P = {2: '7/2', 4: '11/2', 6: '15/2', 8: '15/2'}
PK = {2: '7', 4: '11', 6: '15', 8: '15'}      # 2k+1 = odd numerator of power p (for sqrt form)
TSTAR = {'A1': '16 / 13', 'A2': '4', 'A3': '8', 'A4': '13'}
HNMIN = {'A1': '1', 'A2': '2', 'A3': '6', 'A4': '13'}
HLO = {'A1': '1', 'A2': '16 / 13', 'A3': '4', 'A4': '8'}
HHLB = {'A1': '35 / 78', 'A2': '35 / 234', 'A3': '35 / 312', 'A4': '35 / 390'}

def qname(name, r): return f't3w_q{name}_{r}'
def rname(name, r): return f't3w_r{name}_{r}'
def qdef(name, r):
    a, b = Q[name][r]
    return f'def {qname(name, r)} : ℝ := ({a} : ℝ) / {b}'
def rdef(name, r):
    a, b = R[name][r]
    return f'def {rname(name, r)} : ℝ := ({a} : ℝ) / {b}'

out = '''/- 25ae Stage 3B.11 -- The list-scale wall for the sharpened T3 bound.
   Part A (1 <= t <= 13), four bands.  Endpoint constants (scripts/rh/day026_25ae_t3wall.py,
   exact Fraction + isqrt):  t3w_qB_r = strict rational sqrt upper bound of
   t3w_prod t* r (endpoint t* of band B);  t3w_rB_r = strict rational upper
   bound of (n_min)^(-p_r).  Every comparison closes by norm_num.
   Part B (13 <= t <= 1e8): batch 2. -/
set_option maxSynthPendingDepth 8

'''
out += '''/-- t3w_prod t i = prod_{k <= i} (t^2 + (k + 1/2)^2) = |S_i(t)|^2. -/
def t3w_prod (t : ℝ) (i : ℕ) : ℝ :=
  prod k in Finset.range (i + 1), (t ^ 2 + (k + 1 / 2 : ℝ) ^ 2)
'''
out += '''
/-- Powers p_i of the list scale n in term i (7/2, 11/2, 15/2, 15/2). -/
def t3w_p (i : ℕ) : ℝ :=
  if i = 2 then 7 / 2 else if i = 4 then 11 / 2 else if i = 6 then 15 / 2
  else if i = 8 then 15 / 2 else 0

/-- Denominators d_i (720, 30240, 1209600, 9072000). -/
def t3w_d (i : ℕ) : ℝ :=
  if i = 2 then 720 else if i = 4 then 30240 else if i = 6 then 1209600
  else if i = 8 then 9072000 else 1

/-- Term i of the sharpened T3 bound at list scale: |S_i(t)| * n^{-p_i} / d_i. -/
def t3w_term (n : ℕ) (t : ℝ) (i : ℕ) : ℝ :=
  Real.sqrt (t3w_prod t i) * (n : ℝ) ^ (-(t3w_p i)) / (t3w_d i)

/-- The sharpened 4-term bound. -/
def t3w_T3UB (n : ℕ) (t : ℝ) : ℝ :=
  t3w_term n t 2 + t3w_term n t 4 + t3w_term n t 6 + t3w_term n t 8

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
'''
for name in ['A1', 'A2', 'A3', 'A4']:
    ts = f'({TSTAR[name]})'
    for r in (2, 4, 6, 8):
        out += qdef(name, r) + '\n' + rdef(name, r) + '\n'
    cds = ', '.join(f'{qname(name, r)}, {rname(name, r)}' for r in (2, 4, 6, 8))
    out += f'''
theorem t3w_q{name} :
    Real.sqrt (t3w_prod {ts} 2) < {qname(name, 2)} ∧
    Real.sqrt (t3w_prod {ts} 4) < {qname(name, 4)} ∧
    Real.sqrt (t3w_prod {ts} 6) < {qname(name, 6)} ∧
    Real.sqrt (t3w_prod {ts} 8) < {qname(name, 8)} := by
  refine ⟨?_, ?_, ?_, ?_⟩
  all_goals exact (Real.sqrt_lt' (by norm_num [{cds}])).mpr (by norm_num [t3w_prod, {cds}])
'''
proj = {2: '.1', 4: '.2.1', 6: '.2.2.1', 8: '.2.2.2'}
for name in ['A1', 'A2', 'A3', 'A4']:
    ts, nmin, hb, hlb = TSTAR[name], HNMIN[name], HLO[name], HHLB[name]
    L = [f'''
/-- {name}: {hb} <= t < {ts} (n >= {nmin}). -/
theorem t3w_wall_{name} {{t : ℝ}} (ht : {hb} <= t) (htb : t < {ts}) {{n : ℕ}}
    (hn : n = ⌊(13 : ℝ) * t / 8⌋₊) :
    t3w_T3UB n t < {hlb} := by
  have hnmin : {nmin} <= n := by
    rw [hn]
    exact (Nat.le_floor_iff' (show ({nmin} : ℕ) ≠ 0 from by norm_num)).mpr (by linarith [ht])
  have htstar : t <= {ts} := htb.le
  have h0t : 0 <= t := by linarith [ht]''']
    for r in (2, 4, 6, 8):
        L.append(f'  have hS{r} : Real.sqrt (t3w_prod t {r}) < {qname(name, r)} := by\n    '
                 f'exact lt_of_le_of_lt (Real.sqrt_le_sqrt (t3w_prod_mono h0t htstar {r})) t3w_q{name}{proj[r]}')
    for r in (2, 4, 6, 8):
        if name == 'A1':
            L.append(f'  have hR{r} : (n : ℝ) ^ (-( {P[r]} : ℝ)) <= {rname(name, r)} :=\n    t3w_invpow_le_one n (by linarith [hnmin]) ({P[r]}) (by norm_num)')
        else:
            k = PK[r]  # 2k+1
            nminc = int(nmin)
            L.append(f'''  have hR{r} : (n : ℝ) ^ (-( {P[r]} : ℝ)) <= {rname(name, r)} := by
    calc
      (n : ℝ) ^ (-( {P[r]} : ℝ)) = 1 / (n : ℝ) ^ ( {P[r]} : ℝ) := by rw [rpow_neg (Nat.cast_nonneg n)]
      _ <= 1 / ({nminc} : ℝ) ^ ( {P[r]} : ℝ) := by
        gcongr
        all_goals (try exact hRtmp) <;> (try norm_num)
      _ < {rname(name, r)} := by sorry''')
    out += '\n'.join(L) + '\n'
open('/tmp/t3w_final2_block.lean', 'w').write(out)
print('draft (hR for A2-A4 has sorry placeholder) written')
