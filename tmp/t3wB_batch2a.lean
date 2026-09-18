
/---------------------------------------------------------------
25ae Stage 3B.11 — Part B batch 2: structure of the i = 7
numerator (single zero on [13, ∞), via Taylor-at-13 sign pattern
+ strict convexity + Rolle/MVT.
/---------------------------------------------------------------

/-- Taylor coefficients of t3wB_num7 at 13:
    t3wB_num7 (13 + u) = ∑_{k < 18} t3wB_b k * u^k.
    Sympy-verified (scripts/rh/day026_25ae_t3wallB.py):
    b_0 < 0, b_1 < 0, and b_k > 0 for all k ≥ 2. -/
def t3wB_b (k : ℕ) : ℝ :=

  if k = 0 then (-55519170304302480236900400 : ℝ)
  else if k = 1 then (-28036883178529140180290480 : ℝ)
  else if k = 2 then (4514401961248816376413184 : ℝ)
  else if k = 3 then (8389006854442158499609600 : ℝ)
  else if k = 4 then (3684115010285902171198464 : ℝ)
  else if k = 5 then (964289445452503150822400 : ℝ)
  else if k = 6 then (176374465738513174659072 : ℝ)
  else if k = 7 then (24047222295903380307968 : ℝ)
  else if k = 8 then (2525050408927726231552 : ℝ)
  else if k = 9 then (207670353674595688448 : ℝ)
  else if k = 10 then (13468759131499003904 : ℝ)
  else if k = 11 then (687984546391261184 : ℝ)
  else if k = 12 then (27421829717295104 : ℝ)
  else if k = 13 then (836777672966144 : ℝ)
  else if k = 14 then (18908174090240 : ℝ)
  else if k = 15 then (298475061248 : ℝ)
  else if k = 16 then (2941255680 : ℝ)
  else if k = 17 then (13631488 : ℝ)
  else 0

/-- Shifted form of t3wB_num7 at 13 (flat, for ring/norm_num). -/
noncomputable def t3wB_N7shift (u : ℝ) : ℝ :=
  (-55519170304302480236900400 : ℝ)
      + (-28036883178529140180290480 : ℝ) * (u) ^ 1
      + (4514401961248816376413184 : ℝ) * (u) ^ 2
      + (8389006854442158499609600 : ℝ) * (u) ^ 3
      + (3684115010285902171198464 : ℝ) * (u) ^ 4
      + (964289445452503150822400 : ℝ) * (u) ^ 5
      + (176374465738513174659072 : ℝ) * (u) ^ 6
      + (24047222295903380307968 : ℝ) * (u) ^ 7
      + (2525050408927726231552 : ℝ) * (u) ^ 8
      + (207670353674595688448 : ℝ) * (u) ^ 9
      + (13468759131499003904 : ℝ) * (u) ^ 10
      + (687984546391261184 : ℝ) * (u) ^ 11
      + (27421829717295104 : ℝ) * (u) ^ 12
      + (836777672966144 : ℝ) * (u) ^ 13
      + (18908174090240 : ℝ) * (u) ^ 14
      + (298475061248 : ℝ) * (u) ^ 15
      + (2941255680 : ℝ) * (u) ^ 16
      + (13631488 : ℝ) * (u) ^ 17

/-- First derivative of t3wB_N7shift (flat). -/
noncomputable def t3wB_N7f1 (u : ℝ) : ℝ :=
  (-28036883178529140180290480 : ℝ)
      + (9028803922497632752826368 : ℝ) * (u) ^ 1
      + (25167020563326475498828800 : ℝ) * (u) ^ 2
      + (14736460041143608684793856 : ℝ) * (u) ^ 3
      + (4821447227262515754112000 : ℝ) * (u) ^ 4
      + (1058246794431079047954432 : ℝ) * (u) ^ 5
      + (168330556071323662155776 : ℝ) * (u) ^ 6
      + (20200403271421809852416 : ℝ) * (u) ^ 7
      + (1869033183071361196032 : ℝ) * (u) ^ 8
      + (134687591314990039040 : ℝ) * (u) ^ 9
      + (7567830010303873024 : ℝ) * (u) ^ 10
      + (329061956607541248 : ℝ) * (u) ^ 11
      + (10878109748559872 : ℝ) * (u) ^ 12
      + (264714437263360 : ℝ) * (u) ^ 13
      + (4477125918720 : ℝ) * (u) ^ 14
      + (47060090880 : ℝ) * (u) ^ 15
      + (231735296 : ℝ) * (u) ^ 16

/-- Second derivative of t3wB_N7shift (flat; all coefficients positive). -/
noncomputable def t3wB_N7pp (u : ℝ) : ℝ :=
  (9028803922497632752826368 : ℝ)
      + (50334041126652950997657600 : ℝ) * (u) ^ 1
      + (44209380123430826054381568 : ℝ) * (u) ^ 2
      + (19285788909050063016448000 : ℝ) * (u) ^ 3
      + (5291233972155395239772160 : ℝ) * (u) ^ 4
      + (1009983336427941972934656 : ℝ) * (u) ^ 5
      + (141402822899952668966912 : ℝ) * (u) ^ 6
      + (14952265464570889568256 : ℝ) * (u) ^ 7
      + (1212188321834910351360 : ℝ) * (u) ^ 8
      + (75678300103038730240 : ℝ) * (u) ^ 9
      + (3619681522682953728 : ℝ) * (u) ^ 10
      + (130537316982718464 : ℝ) * (u) ^ 11
      + (3441287684423680 : ℝ) * (u) ^ 12
      + (62679762862080 : ℝ) * (u) ^ 13
      + (705901363200 : ℝ) * (u) ^ 14
      + (3707764736 : ℝ) * (u) ^ 15

/-- Polynomial form of the shifted numerator (for smoothness lemmas). -/
noncomputable def t3wB_N7poly : Polynomial ℝ :=
  (Polynomial.C (-55519170304302480236900400 : ℝ))
      + (Polynomial.C (-28036883178529140180290480 : ℝ)) * (Polynomial.X : Polynomial ℝ) ^ 1
      + (Polynomial.C (4514401961248816376413184 : ℝ)) * (Polynomial.X : Polynomial ℝ) ^ 2
      + (Polynomial.C (8389006854442158499609600 : ℝ)) * (Polynomial.X : Polynomial ℝ) ^ 3
      + (Polynomial.C (3684115010285902171198464 : ℝ)) * (Polynomial.X : Polynomial ℝ) ^ 4
      + (Polynomial.C (964289445452503150822400 : ℝ)) * (Polynomial.X : Polynomial ℝ) ^ 5
      + (Polynomial.C (176374465738513174659072 : ℝ)) * (Polynomial.X : Polynomial ℝ) ^ 6
      + (Polynomial.C (24047222295903380307968 : ℝ)) * (Polynomial.X : Polynomial ℝ) ^ 7
      + (Polynomial.C (2525050408927726231552 : ℝ)) * (Polynomial.X : Polynomial ℝ) ^ 8
      + (Polynomial.C (207670353674595688448 : ℝ)) * (Polynomial.X : Polynomial ℝ) ^ 9
      + (Polynomial.C (13468759131499003904 : ℝ)) * (Polynomial.X : Polynomial ℝ) ^ 10
      + (Polynomial.C (687984546391261184 : ℝ)) * (Polynomial.X : Polynomial ℝ) ^ 11
      + (Polynomial.C (27421829717295104 : ℝ)) * (Polynomial.X : Polynomial ℝ) ^ 12
      + (Polynomial.C (836777672966144 : ℝ)) * (Polynomial.X : Polynomial ℝ) ^ 13
      + (Polynomial.C (18908174090240 : ℝ)) * (Polynomial.X : Polynomial ℝ) ^ 14
      + (Polynomial.C (298475061248 : ℝ)) * (Polynomial.X : Polynomial ℝ) ^ 15
      + (Polynomial.C (2941255680 : ℝ)) * (Polynomial.X : Polynomial ℝ) ^ 16
      + (Polynomial.C (13631488 : ℝ)) * (Polynomial.X : Polynomial ℝ) ^ 17

/-- Polynomial form of the first derivative (for smoothness lemmas). -/
noncomputable def t3wB_N7f1poly : Polynomial ℝ :=
  (Polynomial.C (-28036883178529140180290480 : ℝ))
      + (Polynomial.C (9028803922497632752826368 : ℝ)) * (Polynomial.X : Polynomial ℝ) ^ 1
      + (Polynomial.C (25167020563326475498828800 : ℝ)) * (Polynomial.X : Polynomial ℝ) ^ 2
      + (Polynomial.C (14736460041143608684793856 : ℝ)) * (Polynomial.X : Polynomial ℝ) ^ 3
      + (Polynomial.C (4821447227262515754112000 : ℝ)) * (Polynomial.X : Polynomial ℝ) ^ 4
      + (Polynomial.C (1058246794431079047954432 : ℝ)) * (Polynomial.X : Polynomial ℝ) ^ 5
      + (Polynomial.C (168330556071323662155776 : ℝ)) * (Polynomial.X : Polynomial ℝ) ^ 6
      + (Polynomial.C (20200403271421809852416 : ℝ)) * (Polynomial.X : Polynomial ℝ) ^ 7
      + (Polynomial.C (1869033183071361196032 : ℝ)) * (Polynomial.X : Polynomial ℝ) ^ 8
      + (Polynomial.C (134687591314990039040 : ℝ)) * (Polynomial.X : Polynomial ℝ) ^ 9
      + (Polynomial.C (7567830010303873024 : ℝ)) * (Polynomial.X : Polynomial ℝ) ^ 10
      + (Polynomial.C (329061956607541248 : ℝ)) * (Polynomial.X : Polynomial ℝ) ^ 11
      + (Polynomial.C (10878109748559872 : ℝ)) * (Polynomial.X : Polynomial ℝ) ^ 12
      + (Polynomial.C (264714437263360 : ℝ)) * (Polynomial.X : Polynomial ℝ) ^ 13
      + (Polynomial.C (4477125918720 : ℝ)) * (Polynomial.X : Polynomial ℝ) ^ 14
      + (Polynomial.C (47060090880 : ℝ)) * (Polynomial.X : Polynomial ℝ) ^ 15
      + (Polynomial.C (231735296 : ℝ)) * (Polynomial.X : Polynomial ℝ) ^ 16

/-- The shifted identity (sympy-verified flat-vs-flat). -/
theorem t3wB_N7shift_eq (u : ℝ) : t3wB_num7 (13 + u) = t3wB_N7shift u := by
  dsimp only [t3wB_num7, t3wB_N7shift]
  ring

/-- N7shift equals aeval of its polynomial form. -/
theorem t3wB_N7poly_aeval (u : ℝ) : t3wB_N7shift u = t3wB_N7poly.aeval u := by
  dsimp only [t3wB_N7shift, t3wB_N7poly]
  simp
  ring

/-- N7f1 equals aeval of its polynomial form. -/
theorem t3wB_N7f1poly_aeval (u : ℝ) : t3wB_N7f1 u = t3wB_N7f1poly.aeval u := by
  dsimp only [t3wB_N7f1, t3wB_N7f1poly]
  simp
  ring

/-- The shifted numerator is differentiable (polynomial). -/
theorem t3wB_N7shift_diff : Differentiable ℝ (fun u : ℝ => t3wB_N7shift u) := by
  have h : (fun u : ℝ => t3wB_N7shift u) = (fun u : ℝ => t3wB_N7poly.aeval u) := by
    funext u
    exact t3wB_N7poly_aeval u
  rw [h]
  exact Polynomial.differentiable_aeval _

/-- The first derivative is differentiable (polynomial). -/
theorem t3wB_N7f1_diff : Differentiable ℝ (fun u : ℝ => t3wB_N7f1 u) := by
  have h : (fun u : ℝ => t3wB_N7f1 u) = (fun u : ℝ => t3wB_N7f1poly.aeval u) := by
    funext u
    exact t3wB_N7f1poly_aeval u
  rw [h]
  exact Polynomial.differentiable_aeval _

/-- N7(13) < 0 < N7(20) (exact norm_num gates). -/
theorem t3wB_num7_gate : t3wB_num7 13 < 0 ∧ 0 < t3wB_num7 20 := by
  dsimp only [t3wB_num7]
  constructor <;> norm_num

/-- N7shift 0 < 0 (the value at t = 13). -/
theorem t3wB_N7shift_at0_neg : t3wB_N7shift 0 < 0 := by
  dsimp only [t3wB_N7shift]
  norm_num

/-- N7shift 7 > 0 (the value at t = 20). -/
theorem t3wB_N7shift_at7_pos : 0 < t3wB_N7shift 7 := by
  dsimp only [t3wB_N7shift]
  norm_num

/-- f1 0 = b_1 < 0. -/
theorem t3wB_N7f1_at0_neg : t3wB_N7f1 0 < 0 := by
  dsimp only [t3wB_N7f1]
  norm_num
