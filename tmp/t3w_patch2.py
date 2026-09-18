s = open('/tmp/t3w_final3b.py').read()
TQ = chr(39) * 3  # '''

# FIX 1: A1 hR
old1 = "            L.append(f'  have hR{r} : (n : ℝ) ^ (-( {P[r]} : ℝ)) <= {rn(b, r)} :=\\n'\n                     f'    t3w_invpow_le_one n (by linarith [hnmin]) ({P[r}]) (by norm_num)\\n')"
old1 = "            L.append(f'  have hR{r} : (n : ℝ) ^ (-( {P[r]} : ℝ)) <= {rn(b, r)} :=\\n'\n                     f'    t3w_invpow_le_one n (by linarith [hnmin]) ({P[r]}) (by norm_num)\\n')"
new1 = ("            L.append(f'  have hR{r} : (n : ℝ) ^ (-( {P[r]} : ℝ)) <= {rn(b, r)} := by\\n'\n"
        "                     f'    calc\\n'\n"
        "                     f'      (n : ℝ) ^ (-( {P[r]} : ℝ)) <= 1 := t3w_invpow_le_one n (by linarith [hnmin]) ({P[r]}) (by norm_num)\\n'\n"
        "                     f'      _ <= {rn(b, r)} := by norm_num [{rn(b, r)}]\\n')")
assert s.count(old1) == 1, 'FIX1 count %d' % s.count(old1)
s = s.replace(old1, new1)

# FIX 2: A2-A4 hR branch
start_marker = '        else:\n            pn, k = PNUM[r], PK[r]\n'
end_marker = '    for r in (2, 4, 6, 7):\n        L.append(f' + TQ + '  have hT'
i1 = s.index(start_marker)
i2 = s.index(end_marker)
body_lines = [
    '  have hR{r} : (n : ℝ) ^ (-( {P[r]} : ℝ)) < {rn(b, r)} := by',
    '    calc',
    '      (n : ℝ) ^ (-( {P[r]} : ℝ)) = 1 / (n : ℝ) ^ ( {P[r]} : ℝ) := by rw [rpow_neg (Nat.cast_nonneg n), inv_eq_one_div]',
    '      _ <= 1 / ({nmini} : ℝ) ^ ( {P[r]} : ℝ) := by',
    '        have hbase : ({nmini} : ℝ) <= (n : ℝ) := Nat.cast_le.mpr hnmin',
    '        exact (one_div_le_one_div (rpow_pos_of_pos (by norm_num : (0 : ℝ) < {nmini}) ( {P[r]} : ℝ))',
    '          (rpow_pos_of_pos (Nat.cast_pos.mpr (show (0 : ℕ) < n from by linarith [hnmin])) ( {P[r]} : ℝ))).mpr',
    '          (rpow_le_rpow (by norm_num) hbase (by norm_num))',
    '      _ < {rn(b, r)} := by',
    '        have hrew : ({nmini} : ℝ) ^ ( {P[r]} : ℝ) = Real.sqrt (({nmini} : ℝ) ^ ({pn} : ℕ)) := by',
    '          have hp2 : ( {P[r]} : ℝ) = ({pn} : ℝ) / 2 := by norm_num',
    '          rw [hp2, show ({nmini} : ℝ) ^ (({pn} : ℝ) / 2) = ({nmini} : ℝ) ^ (({pn} : ℝ) * (1 / 2)) from by norm_num]',
    '          rw [Real.rpow_mul (by norm_num : 0 ≤ ({nmini} : ℝ)) ({pn} : ℝ) (1 / 2)]',
    '          rw [show ({pn} : ℝ) = ({pn} : ℕ) from by norm_num]',
    '          rw [Real.rpow_natCast, ← sqrt_eq_rpow]',
    '        rw [hrew]',
    '        rw [one_div_lt (by positivity) (by norm_num : 0 < {rn(b, r)})]',
    '        exact (Real.lt_sqrt (by positivity)).mpr (by norm_num)',
]
nb = start_marker + '            L.append(f' + TQ + '\n' + '\n'.join(body_lines) + '\n' + TQ + ')\n'
s = s[:i1] + nb + s[i2:]

# FIX 3: gcongr closers
a = 'all_goals (try exact hR{r}) <;> (try norm_num)'
b = 'all_goals (try exact hR{r}) <;> (try exact le_of_lt hR{r}) <;> (try norm_num) <;> (try positivity)'
assert s.count(a) == 1, 'FIX3a'
s = s.replace(a, b)
a = 'all_goals (try exact hS{r}) <;> (try norm_num)'
b = 'all_goals (try exact hS{r}) <;> (try norm_num) <;> (try positivity)'
assert s.count(a) == 1, 'FIX3b'
s = s.replace(a, b)
a = '(try exact hT6) <;> (try exact hT7) <;> (try norm_num)'
b = '(try exact hT6) <;> (try exact hT7) <;> (try norm_num) <;> (try positivity)'
assert s.count(a) == 1, 'FIX3c'
s = s.replace(a, b)

open('/tmp/t3w_final3c.py', 'w').write(s)
print('all fixes applied')
