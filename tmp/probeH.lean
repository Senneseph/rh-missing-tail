import Mathlib
open Real
def c4sq : ℝ := 62000000 * 62000000
noncomputable def G4 (t : ℝ) : ℝ := 62000000 * t ^ 4
def w (t : ℝ) : ℝ := t * t + 1 / 4
lemma st_c4sq_pos : 0 < c4sq := by norm_num [c4sq]
lemma st_G4pos (t : ℝ) (ht : 1000 ≤ t) : 0 < G4 t := by
  rw [G4]
  apply mul_pos (by norm_num)
  exact pow_pos (by linarith) 4
lemma st_hpos1 (t : ℝ) (ht : 1000 ≤ t) : 0 < 2 * (G4 t * G4 t + 1 / 4) := by
  nlinarith [st_G4pos t ht]
lemma st_G4sq (t : ℝ) : G4 t * G4 t = c4sq * t ^ 8 := by
  rw [G4, c4sq]
  ring
example (t : ℝ) (ht : 1000 ≤ t) : 1 / (2 * (G4 t * G4 t + 1 / 4)) ≤ 1 / (t * t) / (c4sq * t ^ 6) := by
  have hu : 0 < G4 t * G4 t + 1 / 4 := by nlinarith [st_G4pos t ht]
  calc 1 / (2 * (G4 t * G4 t + 1 / 4)) ≤ 1 / (G4 t * G4 t + 1 / 4) := by
    rw [div_le_iff₀ (st_hpos1 t ht)]
    field_simp
    norm_num
  _ ≤ 1 / (c4sq * t ^ 8) := by
    rw [div_le_iff₀ hu]
    field_simp [st_c4sq_pos.ne', show (0 : ℝ) < t from by linarith]
    nlinarith [show G4 t * G4 t = c4sq * t ^ 8 from st_G4sq t]
  _ = 1 / (t * t) / (c4sq * t ^ 6) := by
    field_simp [st_c4sq_pos.ne', show (0 : ℝ) < t from by linarith]
    ring
