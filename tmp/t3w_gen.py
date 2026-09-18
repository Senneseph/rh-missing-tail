# Generate the corrected ProbeT3w.lean
pre = '''import Mathlib

open Real Finset
open scoped BigOperators

/- 25ae Stage 3B.11 -- The list-scale wall for the sharpened T3 bound.
   Batch 1: Part A (1 <= t < 13), four bands.  Batch 2 (next commit): Part B
   (13 <= t <= 1e8).  Constants: scripts/rh/day026_25ae_t3wall.py. -/

noncomputable section

/-- t3w_prod t i = ∏_{k <= i} (t^2 + (k+1/2)^2) = |S_i(t)|^2. -/
def t3w_prod (t : ℝ) (i : ℕ) : ℝ :=
  ∏ k in Finset.range (i + 1), (t ^ 2 + (k + 1 / 2 : ℝ) ^ 2)

def t3w_p (i : ℕ) : ℝ :=
  if i = 2 then 7 / 2 else if i = 4 then 11 / 2 else if i = 6 then 15 / 2
  else if i = 8 then 15 / 2 else 0

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
  calc
    t3w_prod t i = ∏ k in Finset.range (i + 1), (t ^ 2 + (k + 1 / 2 : ℝ) ^ 2) := rfl
    _ <= ∏ k in Finset.range (i + 1), (t' ^ 2 + (k + 1 / 2 : ℝ) ^ 2) :=
      Finset.prod_le_prod fun k _ => by nlinarith [h, h0]
    _ = t3w_prod t' i := rfl

/-- n^{-p} <= 1 for n >= 1 and p > 0. -/
theorem t3w_invpow_le_one (n : ℕ) (hn : 1 <= n) (p : ℝ) (hp : 0 < p) :
    (n : ℝ) ^ (-p) <= 1 := by
  have hnz : 0 < (n : ℝ) := Nat.cast_pos (Nat.succ_le_of_le hn)
  calc
    (n : ℝ) ^ (-p) = 1 / (n : ℝ) ^ p := by rw [rpow_neg (ne_of_gt hnz)]
    _ <= 1 / 1 := (one_div_le_one_iff (by positivity)).trans (Real.one_le_rpow (by
      exact_mod_cast hn) hp)
    _ = 1 := by norm_num

/-! Endpoint radical upper bounds (strict): sqrt(t3w_prod t* i) < q for
    t* = 16/13, 4, 8, 13, i = 2, 4, 6, 8. -/
theorem t3w_qA1 :
    Real.sqrt (t3w_prod (16 / 13) 2) < (4983772 : ℝ) / 14114211 ∧
    Real.sqrt (t3w_prod (16 / 13) 4) <
        (1502859194746946382456392547 : ℝ) / 39080966454345923952478521520625 ∧
    Real.sqrt (t3w_prod (16 / 13) 6) <
        (116421237610681507751902027148866967117371242851865631999038676718099 : ℝ) /
        848148949534638458986587467545761005268541614173769360528737610758496274625 ∧
    Real.sqrt (t3w_prod (16 / 13) 8) <
        (4673768311994492894219461766745702095382064867279345224670856838556546758433372578 : ℝ) /
        520980157116571205745301652688943660996440696736428251805069850816356165658766328125 := by
  refine ⟨?_, ?_, ?_, ?_⟩
  all_goals apply Real.sqrt_lt (by positivity) <;> norm_num [t3w_prod]

theorem t3w_qA2 :
    Real.sqrt (t3w_prod 4 2) < (1848 : ℝ) / 601 ∧
    Real.sqrt (t3w_prod 4 4) < (51261935390797 : ℝ) / 4806720364854304 ∧
    Real.sqrt (t3w_prod 4 6) < (38321091914035790083 : ℝ) / 142156206932330311680 ∧
    Real.sqrt (t3w_prod 4 8) < (118664095704944357 : ℝ) / 175816752253656248672 := by
  refine ⟨?_, ?_, ?_, ?_⟩
  all_goals apply Real.sqrt_lt (by positivity) <;> norm_num [t3w_prod]

theorem t3w_qA3 :
    Real.sqrt (t3w_prod 8 2) < (1038368 : ℝ) / 100375 ∧
    Real.sqrt (t3w_prod 8 4) < (308865459811845 : ℝ) / 2827340696980896 ∧
    Real.sqrt (t3w_prod 8 6) < (125273133965089553 : ℝ) / 78956970802130749440 ∧
    Real.sqrt (t3w_prod 8 8) < (253032781322650125 : ℝ) / 329540631957371815936 := by
  refine ⟨?_, ?_, ?_, ?_⟩
  all_goals apply Real.sqrt_lt (by positivity) <;> norm_num [t3w_prod]

theorem t3w_qA4 :
    Real.sqrt (t3w_prod 13 2) < (10174728 : ℝ) / 1098505 ∧
    Real.sqrt (t3w_prod 13 4) <
        (9260405786968037082572925 : ℝ) / 3453536683734581692029825084157842881 ∧
    Real.sqrt (t3w_prod 13 6) <
        (26974492172077878447116878758611338947684799 : ℝ) /
        2246822875069249810144953750337536290148726740034515625 ∧
    Real.sqrt (t3w_prod 13 8) <
        (3449285309443320744762575001520288 : ℝ) /
        2341672835847628839254119201950605753331432373046875000 := by
  refine ⟨?_, ?_, ?_, ?_⟩
  all_goals apply Real.sqrt_lt (by positivity) <;> norm_num [t3w_prod]
'''

# A-band template
def band(name, htlo_s, hthi_s, nmin, hlb_s, ql, qref, qfields, hlbs):
    # qref : the q lemma name; qfields : ('.1','.2.1','.2.2.1','.2.2.2')
    # ql : the four constants as display strings
    q2, q4, q6, q8 = ql
    f2, f4, f6, f8 = qfields
    tstar = hthi_s
    return f'''
/-- {name}: {htlo_s} <= t < {hthi_s} (n >= {nmin}). -/
theorem t3w_wall_{name} {{t : ℝ}} (ht : {htlo_s} <= t) (htb : t < {hthi_s}) {{n : ℕ}}
    (hn : n = ⌊(13 : ℝ) * t / 8⌋₊) :
    t3w_T3UB n t < {hlb_s} := by
  have hnmin : {nmin} <= n := by
    rw [hn]
    exact (Nat.le_floor_iff' (show ({nmin} : ℕ) ≠ 0 from by norm_num)).mpr (by linarith [ht])
  have hS2 : Real.sqrt (t3w_prod t 2) < {q2} := by
    exact (Real.sqrt_le_sqrt (t3w_prod_mono (by linarith [ht]) (by linarith [htb]) 2)).trans ({qref}{f2}).le
  have hS4 : Real.sqrt (t3w_prod t 4) < {q4} := by
    exact (Real.sqrt_le_sqrt (t3w_prod_mono (by linarith [ht]) (by linarith [htb]) 4)).trans ({qref}{f4}).le
  have hS6 : Real.sqrt (t3w_prod t 6) < {q6} := by
    exact (Real.sqrt_le_sqrt (t3w_prod_mono (by linarith [ht]) (by linarith [htb]) 6)).trans ({qref}{f6}).le
  have hS8 : Real.sqrt (t3w_prod t 8) < {q8} := by
    exact (Real.sqrt_le_sqrt (t3w_prod_mono (by linarith [ht]) (by linarith [htb]) 8)).trans ({qref}{f8}).le
  have hT2 : t3w_term n t 2 < {q2} / 720 := by
    calc
      t3w_term n t 2 = Real.sqrt (t3w_prod t 2) * (n : ℝ) ^ (-(7 / 2 : ℝ)) / 720 := by
        simp [t3w_term, t3w_p, t3w_d]
      _ <= Real.sqrt (t3w_prod t 2) * 1 / 720 := by
        gcongr
        · exact t3w_invpow_le_one n (by linarith [hnmin]) (7 / 2) (by norm_num)
        · norm_num
      _ < {q2} * 1 / 720 := by gcongr <;> exact hS2
      _ = {q2} / 720 := by ring
  have hT4 : t3w_term n t 4 < {q4} / 30240 := by
    calc
      t3w_term n t 4 = Real.sqrt (t3w_prod t 4) * (n : ℝ) ^ (-(11 / 2 : ℝ)) / 30240 := by
        simp [t3w_term, t3w_p, t3w_d]
      _ <= Real.sqrt (t3w_prod t 4) * 1 / 30240 := by
        gcongr
        · exact t3w_invpow_le_one n (by linarith [hnmin]) (11 / 2) (by norm_num)
        · norm_num
      _ < {q4} * 1 / 30240 := by gcongr <;> exact hS4
      _ = {q4} / 30240 := by ring
  have hT6 : t3w_term n t 6 < {q6} / 1209600 := by
    calc
      t3w_term n t 6 = Real.sqrt (t3w_prod t 6) * (n : ℝ) ^ (-(15 / 2 : ℝ)) / 1209600 := by
        simp [t3w_term, t3w_p, t3w_d]
      _ <= Real.sqrt (t3w_prod t 6) * 1 / 1209600 := by
        gcongr
        · exact t3w_invpow_le_one n (by linarith [hnmin]) (15 / 2) (by norm_num)
        · norm_num
      _ < {q6} * 1 / 1209600 := by gcongr <;> exact hS6
      _ = {q6} / 1209600 := by ring
  have hT8 : t3w_term n t 8 < {q8} / 9072000 := by
    calc
      t3w_term n t 8 = Real.sqrt (t3w_prod t 8) * (n : ℝ) ^ (-(15 / 2 : ℝ)) / 9072000 := by
        simp [t3w_term, t3w_p, t3w_d]
      _ <= Real.sqrt (t3w_prod t 8) * 1 / 9072000 := by
        gcongr
        · exact t3w_invpow_le_one n (by linarith [hnmin]) (15 / 2) (by norm_num)
        · norm_num
      _ < {q8} * 1 / 9072000 := by gcongr <;> exact hS8
      _ = {q8} / 9072000 := by ring
  calc
    t3w_T3UB n t = t3w_term n t 2 + t3w_term n t 4 + t3w_term n t 6 + t3w_term n t 8 := by
      simp [t3w_T3UB]
    _ < {q2} / 720 + {q4} / 30240 + {q6} / 1209600 + {q8} / 9072000 := by
      gcongr
      all_goals (try exact hT2) <;> (try exact hT4) <;> (try exact hT6) <;> (try exact hT8)
    _ < {hlb_s} := by norm_num
'''

bands = [
    ('A1', '1', '16 / 13', 1, '35 / 78',
     (r'(4983772 : ℝ) / 14114211',
      r'\(1502859194746946382456392547 : ℝ\) / 39080966454345923952478521520625',
      r'\(116421237610681507751902027148866967117371242851865631999038676718099 : ℝ\) / 848148949534638458986587467545761005268541614173769360528737610758496274625',
      r'\(4673768311994492894219461766745702095382064867279345224670856838556546758433372578 : ℝ\) / 520980157116571205745301652688943660996440696736428251805069850816356165658766328125'),
     't3w_qA1', ('.1', '.2.1', '.2.2.1', '.2.2.2'), None),
    ('A2', '16 / 13', '4', 2, '35 / 234',
     (r'(1848 : ℝ) / 601',
      r'\(51261935390797 : ℝ\) / 4806720364854304',
      r'\(38321091914035790083 : ℝ\) / 142156206932330311680',
      r'\(118664095704944357 : ℝ\) / 175816752253656248672'),
     't3w_qA2', ('.1', '.2.1', '.2.2.1', '.2.2.2'), None),
    ('A3', '4', '8', 6, '35 / 312',
     (r'(1038368 : ℝ) / 100375',
      r'\(308865459811845 : ℝ\) / 2827340696980896',
      r'\(125273133965089553 : ℝ\) / 78956970802130749440',
      r'\(253032781322650125 : ℝ\) / 329540631957371815936'),
     't3w_qA3', ('.1', '.2.1', '.2.2.1', '.2.2.2'), None),
    ('A4', '8', '13', 13, '35 / 390',
     (r'(10174728 : ℝ) / 1098505',
      r'\(9260405786968037082572925 : ℝ\) / 3453536683734581692029825084157842881',
      r'\(26974492172077878447116878758611338947684799 : ℝ\) / 2246822875069249810144953750337536290148726740034515625',
      r'\(3449285309443320744762575001520288 : ℝ\) / 2341672835847628839254119201950605753331432373046875000'),
     't3w_qA4', ('.1', '.2.1', '.2.2.1', '.2.2.2'), None),
]

body = '\n'.join(band(*b) for b in bands)
tail = '''
/-! Batch 2 (separate commit): Part B (13 <= t <= 1e8) -- see the DISCOVERY_LOG. -/
end
'''
open('/home/jsmille/Projects/rh-missing-tail/formal/RhAttack/ProbeT3w.lean', 'w').write(pre + '\n' + body + tail)
print('generated')
