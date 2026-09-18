s = open('/tmp/t3w_final3c.py').read()

# FIX A: sum line q/r 8 -> 7 (template text)
a = "6)} * ({rn(b, 6)} : ℝ) / 1209600 + {qn(b, 8)} * ({rn(b, 8)} : ℝ) / 9072000 := by"
b = "6)} * ({rn(b, 6)} : ℝ) / 1209600 + {qn(b, 7)} * ({rn(b, 7)} : ℝ) / 9072000 := by"
assert s.count(a) == 1, 'A count %d' % s.count(a)
s = s.replace(a, b)

# FIX B: one_div_le_one_div arg order in hR (a := n^p, b := nmin^p)
a = ("'        exact (one_div_le_one_div (rpow_pos_of_pos (by norm_num : (0 : ℝ) < {nmini}) ( {P[r]} : ℝ))\n"
     "          (rpow_pos_of_pos (Nat.cast_pos.mpr (show (0 : ℕ) < n from by linarith [hnmin])) ( {P[r]} : ℝ))).mpr\n'")
b = ("'        exact (one_div_le_one_div (rpow_pos_of_pos (Nat.cast_pos.mpr (show (0 : ℕ) < n from by linarith [hnmin])) ( {P[r]} : ℝ))\n"
     "          (rpow_pos_of_pos (by norm_num : (0 : ℝ) < {nmini}) ( {P[r]} : ℝ))).mpr\n'")
assert s.count(a) == 1, 'B count %d' % s.count(a)
s = s.replace(a, b)

# FIX C: gcongr closers with explicit norm_num [defs]
a = "all_goals (try exact hR{r}) <;> (try exact le_of_lt hR{r}) <;> (try norm_num) <;> (try positivity)"
b = "all_goals (try exact hR{r}) <;> (try exact le_of_lt hR{r}) <;> (try norm_num [{rn(b, r)}]) <;> (try positivity)"
assert s.count(a) == 1, 'C1'
s = s.replace(a, b)
a = "all_goals (try exact hS{r}) <;> (try norm_num) <;> (try positivity)"
b = "all_goals (try exact hS{r}) <;> (try norm_num [{qn(b, r)}, {rn(b, r)}]) <;> (try positivity)"
assert s.count(a) == 1, 'C2'
s = s.replace(a, b)

# FIX D: hrew tail — explicit sqrt_pos and norm_num with defs
a = ("'        rw [one_div_lt (by positivity) (by norm_num : 0 < {rn(b, r)})]\n"
     "'        exact (Real.lt_sqrt (by positivity)).mpr (by norm_num)\n'")
b = ("'        rw [one_div_lt (Real.sqrt_pos.mpr (by norm_num : 0 < ({nmini} : ℝ) ^ ({pn} : ℕ))) (by norm_num [{rn(b, r)}] : 0 < {rn(b, r)})]\n"
     "'        exact (Real.lt_sqrt (by norm_num [{rn(b, r)}] : 0 ≤ 1 / {rn(b, r)})).mpr (by norm_num [{rn(b, r)}])\n'")
assert s.count(a) == 1, 'D count %d' % s.count(a)
s = s.replace(a, b)

open('/tmp/t3w_final3d.py', 'w').write(s)
print('patch 3 applied')
