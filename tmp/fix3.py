src = open('RhAttack/P4Limit.lean').read()
old = "def t3wB_den (i : ℕ) (t : ℝ) : ℝ := 16 * t * (13 * t - 8) * \u220f k \u2208 Finset.range (i + 1), (4 * t ^ 2 + (2 * k + 1 : \u0052\u0051) ^ 2)"
# use actual chars
old = ("def t3wB_den (i : ℕ) (t : ℝ) : ℝ := 16 * t * (13 * t - 8) * "
       "∏ k ∈ Finset.range (i + 1), (4 * t ^ 2 + (2 * k + 1 : ℝ) ^ 2)")
assert src.count(old) == 1, "den def"
new = ("def t3wB_den (i : ℕ) (t : ℝ) : ℝ := 128 * t * (13 * t / 8 - 1) * "
       "∏ k ∈ Finset.range (i + 1), (4 * t ^ 2 + (2 * k + 1 : ℝ) ^ 2)")
src = src.replace(old, new)

old = """  have h2 : 0 < (16 * t) * (13 * t - 8) := by
    have ht0 : 0 < t := by linarith [ht]
    have ht8 : 0 < 13 * t - 8 := by nlinarith [ht]
    nlinarith [ht0, ht8]"""
new = """  have h2 : 0 < (128 * t) * (13 * t / 8 - 1) := by
    have ht0 : 0 < t := by linarith [ht]
    have ht8 : 0 < 13 * t / 8 - 1 := by
      nlinarith [show (13 : ℝ) * t ≥ 13 * 13 from by nlinarith [ht]]
    nlinarith [ht0, ht8]"""
assert src.count(old) == 1, "den_pos body"
src = src.replace(old, new)
open('RhAttack/P4Limit.lean','w').write(src)
print("patched")
