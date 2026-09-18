import RhAttack.P8Floor

theorem probe_goal (t γ : ℝ) (n : ℕ) (K : ℂ) :
    ‖p4_Wn (((1 / 2 : ℝ) : ℂ) + (t : ℂ) * Complex.I) n - 0‖ < ‖Rratio γ 0 t - 1‖ := by
  set s : ℂ := ((1 / 2 : ℝ) : ℂ) + (t : ℂ) * Complex.I with hs
  print hs
  exact fun _ _ => by
    change ‖p4_Wn s n - 0‖ < ‖Rratio γ 0 t - 1‖
    exact absurd rfl (by norm_num)
