CONSTS = {
 'A1': {'2': ('4983772', '14114211'),
        '4': ('1502859194746946382456392547', '39080966454345923952478521520625'),
        '6': ('116421237610681507751902027148866967117371242851865631999038676718099', '848148949534638458986587467545761005268541614173769360528737610758496274625'),
        '8': ('4673768311994492894219461766745702095382064867279345224670856838556546758433372578', '520980157116571205745301652688943660996440696736428251805069850816356165658766328125')},
 'A2': {'2': ('1848', '601'),
        '4': ('51261935390797', '4806720364854304'),
        '6': ('38321091914035790083', '142156206932330311680'),
        '8': ('118664095704944357', '175816752253656248672')},
 'A3': {'2': ('1038368', '100375'),
        '4': ('308865459811845', '2827340696980896'),
        '6': ('125273133965089553', '78956970802130749440'),
        '8': ('253032781322650125', '329540631957371815936')},
 'A4': {'2': ('10174728', '1098505'),
        '4': ('9260405786968037082572925', '3453536683734581692029825084157842881'),
        '6': ('26974492172077878447116878758611338947684799', '2246822875069249810144953750337536290148726740034515625'),
        '8': ('3449285309443320744762575001520288', '2341672835847628839254119201950605753331432373046875000')},
}
D = {'2': '720', '4': '30240', '6': '1209600', '8': '9072000'}
P = {'2': '7/2', '4': '11/2', '6': '15/2', '8': '15/2'}
TSTAR = {'A1': '16 / 13', 'A2': '4', 'A3': '8', 'A4': '13'}
HNMIN = {'A1': '1', 'A2': '2', 'A3': '6', 'A4': '13'}
HLO = {'A1': '1', 'A2': '16 / 13', 'A3': '4', 'A4': '8'}
HHLB = {'A1': '35 / 78', 'A2': '35 / 234', 'A3': '35 / 312', 'A4': '35 / 390'}

def const(name, i):
    a, b = CONSTS[name][i]
    return f'({a} : ℝ) / {b}'

out = []
out.append('''/- 25ae Stage 3B.11 -- The list-scale wall for the sharpened T3 bound.
   Part A (1 <= t < 13), four bands.  Endpoint constants: strict rational
   upper bounds computed in scripts/rh/day026_25ae_t3wall.py (isqrt + 1);
   every comparison closes by norm_num.  Part B (13 <= t <= 1e8): batch 2. -/
set_option maxSynthPendingDepth 8

''')
out.append('''/-- t3w_prod t i = ∏_{k <= i} (t^2 + (k + 1/2)^2) = |S_i(t)|^2. -/
def t3w_prod (t : ℝ) (i : ℕ) : ℝ :=
  ∏ k ∈ Finset.range (i + 1), (t ^ 2 + (k + 1 / 2 : ℝ) ^ 2)

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

''')
# constant defs + q theorems
for name in ['A1', 'A2', 'A3', 'A4']:
    ts = TSTAR[name]
    tsq = f'({ts})'
    for i in ['2', '4', '6', '8']:
        out.append(f'def t3w_q{name}_{i} : ℝ := {const(name, i)}\n')
    cs = ', '.join(f't3w_q{name}_{i}' for i in ['2', '4', '6', '8'])
    out.append(f'''
theorem t3w_q{name} :
    Real.sqrt (t3w_prod {tsq} 2) < t3w_q{name}_2 ∧
    Real.sqrt (t3w_prod {tsq} 4) < t3w_q{name}_4 ∧
    Real.sqrt (t3w_prod {tsq} 6) < t3w_q{name}_6 ∧
    Real.sqrt (t3w_prod {tsq} 8) < t3w_q{name}_8 := by
  refine ⟨?_, ?_, ?_, ?_⟩
  all_goals exact (Real.sqrt_lt' (by norm_num [{cs}])).mpr (by norm_num [t3w_prod, {cs}])
''')
# bands
for name in []:
    pass

def proj(j):
    if j == 1: return '.1'
    return '.2.' + str(proj(j-1-1)).lstrip('.') if False else None
def projstr(k):
    # k: 1 -> .1 ; 2 -> .2.1 ; 3 -> .2.2.1 ; 4 -> .2.2.2
    return {1: '.1', 2: '.2.1', 3: '.2.2.1', 4: '.2.2.2'}[k]

for name in ['A1', 'A2', 'A3', 'A4']:
    ts = TSTAR[name]
    nmin = HNMIN[name]
    hb = HLO[name]
    hlb = HHLB[name]
    qf = [projstr(k) for k in (1, 2, 3, 4)]
    L = []
    L.append(f'''
/-- {name}: {hb} <= t < {ts} (n >= {nmin}). -/
theorem t3w_wall_{name} {{t : ℝ}} (ht : {hb} <= t) (htb : t < {ts}) {{n : ℕ}}
    (hn : n = ⌊(13 : ℝ) * t / 8⌋₊) :
    t3w_T3UB n t < {hlb} := by
  have hnmin : {nmin} <= n := by
    rw [hn]
    exact (Nat.le_floor_iff' (show ({nmin} : ℕ) ≠ 0 from by norm_num)).mpr (by linarith [ht])
  have htstar : t <= {ts} := htb.le
  have h0t : 0 <= t := by linarith [ht]''')
    idx = {'2': 1, '4': 2, '6': 3, '8': 4}
    for i in ['2', '4', '6', '8']:
        L.append(f"  have hS{i} : Real.sqrt (t3w_prod t {i}) < t3w_q{name}_{i} := by\n"
                 f"    exact lt_of_le_of_lt (Real.sqrt_le_sqrt (t3w_prod_mono h0t htstar {i})) t3w_q{name}{qf[idx[i]-1]}")
    for i in ['2', '4', '6', '8']:
        L.append(f"  have hinv{i} : (n : ℝ) ^ (-( {P[i]} : ℝ)) <= 1 := t3w_invpow_le_one n (by linarith [hnmin]) ({P[i]}) (by norm_num)")
    for i in ['2', '4', '6', '8']:
        L.append(f'''  have hT{i} : t3w_term n t {i} < t3w_q{name}_{i} / {D[i]} := by
    calc
      t3w_term n t {i} = Real.sqrt (t3w_prod t {i}) * (n : ℝ) ^ (-( {P[i]} : ℝ)) / {D[i]} := by
        simp [t3w_term, t3w_p, t3w_d]
      _ <= Real.sqrt (t3w_prod t {i}) * (1 : ℝ) / {D[i]} := by
        gcongr
        all_goals (try exact hinv{i}) <;> (try norm_num)
      _ = Real.sqrt (t3w_prod t {i}) / {D[i]} := by ring
      _ < t3w_q{name}_{i} / {D[i]} := by
        gcongr
        all_goals (try exact hS{i}) <;> (try norm_num)''')
    L.append(f'''  calc
    t3w_T3UB n t = t3w_term n t 2 + t3w_term n t 4 + t3w_term n t 6 + t3w_term n t 8 := rfl
    _ < t3w_q{name}_2 / 720 + t3w_q{name}_4 / 30240 + t3w_q{name}_6 / 1209600 + t3w_q{name}_8 / 9072000 := by
      gcongr <;> (try exact hT2) <;> (try exact hT4) <;> (try exact hT6) <;> (try exact hT8)
    _ < {hlb} := by norm_num [t3w_q{name}_2, t3w_q{name}_4, t3w_q{name}_6, t3w_q{name}_8]
''')
    out.append('\n'.join(L))
open('/tmp/t3w_final_block.lean', 'w').write('\n'.join(out))
print('written', len(''.join(out)))
