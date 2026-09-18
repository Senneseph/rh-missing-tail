
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

/-- HasDerivAt for the shifted numerator (monomial-by-monomial). -/
noncomputable theorem t3wB_N7shift_hasDerivAt (x : ℝ) :
    HasDerivAt (fun (u : ℝ) => t3wB_N7shift u) (t3wB_N7f1 x) x := by
        have h0 : HasDerivAt (fun (_ : ℝ) => (-55519170304302480236900400 : ℝ)) 0 x :=
          hasDerivAt_const (-55519170304302480236900400 : ℝ) x
        have h1 : HasDerivAt ((fun (_ : ℝ) => (-28036883178529140180290480 : ℝ)) * (fun (u : ℝ) => (u) ^ 1)) ((-28036883178529140180290480 * 1 : ℝ) * (x) ^ 0) x := by
          refine ((hasDerivAt_const (-28036883178529140180290480 : ℝ) x).mul (hasDerivAt_pow 1 x)).congr_deriv ?_
          norm_num
          ring
        have h2 : HasDerivAt ((fun (_ : ℝ) => (4514401961248816376413184 : ℝ)) * (fun (u : ℝ) => (u) ^ 2)) ((4514401961248816376413184 * 2 : ℝ) * (x) ^ 1) x := by
          refine ((hasDerivAt_const (4514401961248816376413184 : ℝ) x).mul (hasDerivAt_pow 2 x)).congr_deriv ?_
          norm_num
          ring
        have h3 : HasDerivAt ((fun (_ : ℝ) => (8389006854442158499609600 : ℝ)) * (fun (u : ℝ) => (u) ^ 3)) ((8389006854442158499609600 * 3 : ℝ) * (x) ^ 2) x := by
          refine ((hasDerivAt_const (8389006854442158499609600 : ℝ) x).mul (hasDerivAt_pow 3 x)).congr_deriv ?_
          norm_num
          ring
        have h4 : HasDerivAt ((fun (_ : ℝ) => (3684115010285902171198464 : ℝ)) * (fun (u : ℝ) => (u) ^ 4)) ((3684115010285902171198464 * 4 : ℝ) * (x) ^ 3) x := by
          refine ((hasDerivAt_const (3684115010285902171198464 : ℝ) x).mul (hasDerivAt_pow 4 x)).congr_deriv ?_
          norm_num
          ring
        have h5 : HasDerivAt ((fun (_ : ℝ) => (964289445452503150822400 : ℝ)) * (fun (u : ℝ) => (u) ^ 5)) ((964289445452503150822400 * 5 : ℝ) * (x) ^ 4) x := by
          refine ((hasDerivAt_const (964289445452503150822400 : ℝ) x).mul (hasDerivAt_pow 5 x)).congr_deriv ?_
          norm_num
          ring
        have h6 : HasDerivAt ((fun (_ : ℝ) => (176374465738513174659072 : ℝ)) * (fun (u : ℝ) => (u) ^ 6)) ((176374465738513174659072 * 6 : ℝ) * (x) ^ 5) x := by
          refine ((hasDerivAt_const (176374465738513174659072 : ℝ) x).mul (hasDerivAt_pow 6 x)).congr_deriv ?_
          norm_num
          ring
        have h7 : HasDerivAt ((fun (_ : ℝ) => (24047222295903380307968 : ℝ)) * (fun (u : ℝ) => (u) ^ 7)) ((24047222295903380307968 * 7 : ℝ) * (x) ^ 6) x := by
          refine ((hasDerivAt_const (24047222295903380307968 : ℝ) x).mul (hasDerivAt_pow 7 x)).congr_deriv ?_
          norm_num
          ring
        have h8 : HasDerivAt ((fun (_ : ℝ) => (2525050408927726231552 : ℝ)) * (fun (u : ℝ) => (u) ^ 8)) ((2525050408927726231552 * 8 : ℝ) * (x) ^ 7) x := by
          refine ((hasDerivAt_const (2525050408927726231552 : ℝ) x).mul (hasDerivAt_pow 8 x)).congr_deriv ?_
          norm_num
          ring
        have h9 : HasDerivAt ((fun (_ : ℝ) => (207670353674595688448 : ℝ)) * (fun (u : ℝ) => (u) ^ 9)) ((207670353674595688448 * 9 : ℝ) * (x) ^ 8) x := by
          refine ((hasDerivAt_const (207670353674595688448 : ℝ) x).mul (hasDerivAt_pow 9 x)).congr_deriv ?_
          norm_num
          ring
        have h10 : HasDerivAt ((fun (_ : ℝ) => (13468759131499003904 : ℝ)) * (fun (u : ℝ) => (u) ^ 10)) ((13468759131499003904 * 10 : ℝ) * (x) ^ 9) x := by
          refine ((hasDerivAt_const (13468759131499003904 : ℝ) x).mul (hasDerivAt_pow 10 x)).congr_deriv ?_
          norm_num
          ring
        have h11 : HasDerivAt ((fun (_ : ℝ) => (687984546391261184 : ℝ)) * (fun (u : ℝ) => (u) ^ 11)) ((687984546391261184 * 11 : ℝ) * (x) ^ 10) x := by
          refine ((hasDerivAt_const (687984546391261184 : ℝ) x).mul (hasDerivAt_pow 11 x)).congr_deriv ?_
          norm_num
          ring
        have h12 : HasDerivAt ((fun (_ : ℝ) => (27421829717295104 : ℝ)) * (fun (u : ℝ) => (u) ^ 12)) ((27421829717295104 * 12 : ℝ) * (x) ^ 11) x := by
          refine ((hasDerivAt_const (27421829717295104 : ℝ) x).mul (hasDerivAt_pow 12 x)).congr_deriv ?_
          norm_num
          ring
        have h13 : HasDerivAt ((fun (_ : ℝ) => (836777672966144 : ℝ)) * (fun (u : ℝ) => (u) ^ 13)) ((836777672966144 * 13 : ℝ) * (x) ^ 12) x := by
          refine ((hasDerivAt_const (836777672966144 : ℝ) x).mul (hasDerivAt_pow 13 x)).congr_deriv ?_
          norm_num
          ring
        have h14 : HasDerivAt ((fun (_ : ℝ) => (18908174090240 : ℝ)) * (fun (u : ℝ) => (u) ^ 14)) ((18908174090240 * 14 : ℝ) * (x) ^ 13) x := by
          refine ((hasDerivAt_const (18908174090240 : ℝ) x).mul (hasDerivAt_pow 14 x)).congr_deriv ?_
          norm_num
          ring
        have h15 : HasDerivAt ((fun (_ : ℝ) => (298475061248 : ℝ)) * (fun (u : ℝ) => (u) ^ 15)) ((298475061248 * 15 : ℝ) * (x) ^ 14) x := by
          refine ((hasDerivAt_const (298475061248 : ℝ) x).mul (hasDerivAt_pow 15 x)).congr_deriv ?_
          norm_num
          ring
        have h16 : HasDerivAt ((fun (_ : ℝ) => (2941255680 : ℝ)) * (fun (u : ℝ) => (u) ^ 16)) ((2941255680 * 16 : ℝ) * (x) ^ 15) x := by
          refine ((hasDerivAt_const (2941255680 : ℝ) x).mul (hasDerivAt_pow 16 x)).congr_deriv ?_
          norm_num
          ring
        have h17 : HasDerivAt ((fun (_ : ℝ) => (13631488 : ℝ)) * (fun (u : ℝ) => (u) ^ 17)) ((13631488 * 17 : ℝ) * (x) ^ 16) x := by
          refine ((hasDerivAt_const (13631488 : ℝ) x).mul (hasDerivAt_pow 17 x)).congr_deriv ?_
          norm_num
          ring
  refine (((((((((((((((((h0.add h1).add h2).add h3).add h4).add h5).add h6).add h7).add h8).add h9).add h10).add h11).add h12).add h13).add h14).add h15).add h16).add h17).congr_deriv ?_
  dsimp only [t3wB_N7f1]
  ring

/-- HasDerivAt for the first derivative. -/
noncomputable theorem t3wB_N7f1_hasDerivAt (x : ℝ) :
    HasDerivAt (fun (u : ℝ) => t3wB_N7f1 u) (t3wB_N7pp x) x := by
        have h0 : HasDerivAt (fun (_ : ℝ) => (-28036883178529140180290480 : ℝ)) 0 x :=
          hasDerivAt_const (-28036883178529140180290480 : ℝ) x
        have h1 : HasDerivAt ((fun (_ : ℝ) => (9028803922497632752826368 : ℝ)) * (fun (u : ℝ) => (u) ^ 1)) ((9028803922497632752826368 * 1 : ℝ) * (x) ^ 0) x := by
          refine ((hasDerivAt_const (9028803922497632752826368 : ℝ) x).mul (hasDerivAt_pow 1 x)).congr_deriv ?_
          norm_num
          ring
        have h2 : HasDerivAt ((fun (_ : ℝ) => (25167020563326475498828800 : ℝ)) * (fun (u : ℝ) => (u) ^ 2)) ((25167020563326475498828800 * 2 : ℝ) * (x) ^ 1) x := by
          refine ((hasDerivAt_const (25167020563326475498828800 : ℝ) x).mul (hasDerivAt_pow 2 x)).congr_deriv ?_
          norm_num
          ring
        have h3 : HasDerivAt ((fun (_ : ℝ) => (14736460041143608684793856 : ℝ)) * (fun (u : ℝ) => (u) ^ 3)) ((14736460041143608684793856 * 3 : ℝ) * (x) ^ 2) x := by
          refine ((hasDerivAt_const (14736460041143608684793856 : ℝ) x).mul (hasDerivAt_pow 3 x)).congr_deriv ?_
          norm_num
          ring
        have h4 : HasDerivAt ((fun (_ : ℝ) => (4821447227262515754112000 : ℝ)) * (fun (u : ℝ) => (u) ^ 4)) ((4821447227262515754112000 * 4 : ℝ) * (x) ^ 3) x := by
          refine ((hasDerivAt_const (4821447227262515754112000 : ℝ) x).mul (hasDerivAt_pow 4 x)).congr_deriv ?_
          norm_num
          ring
        have h5 : HasDerivAt ((fun (_ : ℝ) => (1058246794431079047954432 : ℝ)) * (fun (u : ℝ) => (u) ^ 5)) ((1058246794431079047954432 * 5 : ℝ) * (x) ^ 4) x := by
          refine ((hasDerivAt_const (1058246794431079047954432 : ℝ) x).mul (hasDerivAt_pow 5 x)).congr_deriv ?_
          norm_num
          ring
        have h6 : HasDerivAt ((fun (_ : ℝ) => (168330556071323662155776 : ℝ)) * (fun (u : ℝ) => (u) ^ 6)) ((168330556071323662155776 * 6 : ℝ) * (x) ^ 5) x := by
          refine ((hasDerivAt_const (168330556071323662155776 : ℝ) x).mul (hasDerivAt_pow 6 x)).congr_deriv ?_
          norm_num
          ring
        have h7 : HasDerivAt ((fun (_ : ℝ) => (20200403271421809852416 : ℝ)) * (fun (u : ℝ) => (u) ^ 7)) ((20200403271421809852416 * 7 : ℝ) * (x) ^ 6) x := by
          refine ((hasDerivAt_const (20200403271421809852416 : ℝ) x).mul (hasDerivAt_pow 7 x)).congr_deriv ?_
          norm_num
          ring
        have h8 : HasDerivAt ((fun (_ : ℝ) => (1869033183071361196032 : ℝ)) * (fun (u : ℝ) => (u) ^ 8)) ((1869033183071361196032 * 8 : ℝ) * (x) ^ 7) x := by
          refine ((hasDerivAt_const (1869033183071361196032 : ℝ) x).mul (hasDerivAt_pow 8 x)).congr_deriv ?_
          norm_num
          ring
        have h9 : HasDerivAt ((fun (_ : ℝ) => (134687591314990039040 : ℝ)) * (fun (u : ℝ) => (u) ^ 9)) ((134687591314990039040 * 9 : ℝ) * (x) ^ 8) x := by
          refine ((hasDerivAt_const (134687591314990039040 : ℝ) x).mul (hasDerivAt_pow 9 x)).congr_deriv ?_
          norm_num
          ring
        have h10 : HasDerivAt ((fun (_ : ℝ) => (7567830010303873024 : ℝ)) * (fun (u : ℝ) => (u) ^ 10)) ((7567830010303873024 * 10 : ℝ) * (x) ^ 9) x := by
          refine ((hasDerivAt_const (7567830010303873024 : ℝ) x).mul (hasDerivAt_pow 10 x)).congr_deriv ?_
          norm_num
          ring
        have h11 : HasDerivAt ((fun (_ : ℝ) => (329061956607541248 : ℝ)) * (fun (u : ℝ) => (u) ^ 11)) ((329061956607541248 * 11 : ℝ) * (x) ^ 10) x := by
          refine ((hasDerivAt_const (329061956607541248 : ℝ) x).mul (hasDerivAt_pow 11 x)).congr_deriv ?_
          norm_num
          ring
        have h12 : HasDerivAt ((fun (_ : ℝ) => (10878109748559872 : ℝ)) * (fun (u : ℝ) => (u) ^ 12)) ((10878109748559872 * 12 : ℝ) * (x) ^ 11) x := by
          refine ((hasDerivAt_const (10878109748559872 : ℝ) x).mul (hasDerivAt_pow 12 x)).congr_deriv ?_
          norm_num
          ring
        have h13 : HasDerivAt ((fun (_ : ℝ) => (264714437263360 : ℝ)) * (fun (u : ℝ) => (u) ^ 13)) ((264714437263360 * 13 : ℝ) * (x) ^ 12) x := by
          refine ((hasDerivAt_const (264714437263360 : ℝ) x).mul (hasDerivAt_pow 13 x)).congr_deriv ?_
          norm_num
          ring
        have h14 : HasDerivAt ((fun (_ : ℝ) => (4477125918720 : ℝ)) * (fun (u : ℝ) => (u) ^ 14)) ((4477125918720 * 14 : ℝ) * (x) ^ 13) x := by
          refine ((hasDerivAt_const (4477125918720 : ℝ) x).mul (hasDerivAt_pow 14 x)).congr_deriv ?_
          norm_num
          ring
        have h15 : HasDerivAt ((fun (_ : ℝ) => (47060090880 : ℝ)) * (fun (u : ℝ) => (u) ^ 15)) ((47060090880 * 15 : ℝ) * (x) ^ 14) x := by
          refine ((hasDerivAt_const (47060090880 : ℝ) x).mul (hasDerivAt_pow 15 x)).congr_deriv ?_
          norm_num
          ring
        have h16 : HasDerivAt ((fun (_ : ℝ) => (231735296 : ℝ)) * (fun (u : ℝ) => (u) ^ 16)) ((231735296 * 16 : ℝ) * (x) ^ 15) x := by
          refine ((hasDerivAt_const (231735296 : ℝ) x).mul (hasDerivAt_pow 16 x)).congr_deriv ?_
          norm_num
          ring
  refine ((((((((((((((((h0.add h1).add h2).add h3).add h4).add h5).add h6).add h7).add h8).add h9).add h10).add h11).add h12).add h13).add h14).add h15).add h16).congr_deriv ?_
  dsimp only [t3wB_N7pp]
  ring

/-- Pointwise derivative identities. -/
theorem t3wB_N7shift_deriv (x : ℝ) : deriv (fun u : ℝ => t3wB_N7shift u) x = t3wB_N7f1 x := by
  exact (t3wB_N7shift_hasDerivAt x).deriv_eq

theorem t3wB_N7f1_deriv (x : ℝ) : deriv (fun u : ℝ => t3wB_N7f1 u) x = t3wB_N7pp x := by
  exact (t3wB_N7f1_hasDerivAt x).deriv_eq

/-- Second-derivative identity (flat positive form). -/
theorem t3wB_N7_second_deriv (x : ℝ) :
    deriv (deriv (fun u : ℝ => t3wB_N7shift u)) x = t3wB_N7pp x := by
  have hf : (fun y : ℝ => deriv (fun u : ℝ => t3wB_N7shift u) y) = (fun y : ℝ => t3wB_N7f1 y) := by
    funext y
    rw [t3wB_N7shift_deriv y]
  rw [hf]
  exact (t3wB_N7f1_deriv x).deriv_eq

/-- The second derivative is strictly positive for u ≥ 0 (all flat coeffs positive). -/
theorem t3wB_N7pp_pos (x : ℝ) (hx : 0 ≤ x) : 0 < t3wB_N7pp x := by
  dsimp only [t3wB_N7pp]
  positivity

/-- f1 is strictly increasing on [0, ∞) (MVT + second derivative > 0). -/
theorem t3wB_N7f1_strict_inc (a b : ℝ) (hab : a < b) (ha : 0 ≤ a) :
    t3wB_N7f1 a < t3wB_N7f1 b := by
  have hcont : ContinuousOn (fun u : ℝ => t3wB_N7f1 u) (Set.Icc a b) := by
    apply ContinuousOn.mono t3wB_N7f1_diff.continuous.continuousOn
    exact (Set.Icc_subset_iff.mpr ⟨le_refl a, le_of_lt hab⟩)
  have hdiff : DifferentiableOn ℝ (fun u : ℝ => t3wB_N7f1 u) (Set.Ioo a b) := by
    apply DifferentiableOn.mono t3wB_N7f1_diff.differentiableOn
    exact Set.Ioo_subset_Icc_self
  obtain ⟨s, hs, hds⟩ := Set.exists_deriv_eq_slope hab hcont hdiff
  rw [t3wB_N7f1_deriv s, sub_zero] at hds
  field_simp [ne_of_gt (by linarith : 0 < b - a)] at hds
  have hder : t3wB_N7f1 b - t3wB_N7f1 a = t3wB_N7pp s * (b - a) := by
    simpa [mul_comm, mul_assoc, mul_left_comm] using hds
  have hpp : 0 < t3wB_N7pp s := t3wB_N7pp_pos s (by linarith [ha, hs.1])
  have hden : 0 < b - a := by linarith
  have hnum : 0 < t3wB_N7f1 b - t3wB_N7f1 a := by nlinarith [hder, hpp, hden]
  linarith [hnum]

/-- t3wB_num7 has at most one zero on [13, ∞).
    (Rolle + strict increase of f1 + valley at f'(s) = 0.) -/
theorem t3wB_num7_single_zero :
    ∀ (t1 t2 : ℝ), 13 ≤ t1 → t1 < t2 → t3wB_num7 t1 = 0 → t3wB_num7 t2 = 0 → False := by
  intro t1 t2 ht1 ht12 z1 z2
  set u1 := t1 - 13 with u1def
  set u2 := t2 - 13 with u2def
  have hu1 : 0 ≤ u1 := by rw [u1def]; linarith
  have hu2 : u1 < u2 := by rw [u1def, u2def]; linarith
  have hz1 : t3wB_N7shift u1 = 0 := by
    rw [← t3wB_N7shift_eq u1, show (13 : ℝ) + u1 = t1 from by rw [u1def]; ring]
    exact z1
  have hz2 : t3wB_N7shift u2 = 0 := by
    rw [← t3wB_N7shift_eq u2, show (13 : ℝ) + u2 = t2 from by rw [u2def]; ring]
    exact z2
  have hcont : ContinuousOn (fun u : ℝ => t3wB_N7shift u) (Set.Icc u1 u2) := by
    apply ContinuousOn.mono t3wB_N7shift_diff.continuous.continuousOn
    exact (Set.Icc_subset_iff.mpr ⟨le_refl u1, le_of_lt hu2⟩)
  have hdiff : DifferentiableOn ℝ (fun u : ℝ => t3wB_N7shift u) (Set.Ioo u1 u2) := by
    apply DifferentiableOn.mono t3wB_N7shift_diff.differentiableOn
    exact Set.Ioo_subset_Icc_self
  obtain ⟨s, hs, hds⟩ := Set.exists_deriv_eq_slope hu2 hcont hdiff
  rw [t3wB_N7shift_deriv s, sub_zero] at hds
  have hzero : (t3wB_N7shift u2 - t3wB_N7shift u1) / (u2 - u1) = 0 := by
    rw [hz2, hz1, sub_self, zero_div]
  have hs0 : t3wB_N7f1 s = 0 := by
    rw [hzero] at hds
    exact hds
  have hspos : 0 < s := by linarith [hu1, hs.1]
  have hf1u1 : t3wB_N7f1 u1 < 0 := by
    simpa [hs0] using t3wB_N7f1_strict_inc u1 s hs.1 hu1
  by_cases hu1z : u1 = 0
  · rw [hu1z] at hz1
    have hb0 : t3wB_N7shift 0 < 0 := t3wB_N7shift_at0_neg
    linarith [hb0, hz1]
  · have hu1pos : 0 < u1 := by linarith [hu1, hu1z]
    have hcont2 : ContinuousOn (fun u : ℝ => t3wB_N7shift u) (Set.Icc 0 u1) := by
      apply ContinuousOn.mono t3wB_N7shift_diff.continuous.continuousOn
      exact (Set.Icc_subset_iff.mpr ⟨le_refl (0 : ℝ), le_of_lt hu1pos⟩)
    have hdiff2 : DifferentiableOn ℝ (fun u : ℝ => t3wB_N7shift u) (Set.Ioo 0 u1) := by
      apply DifferentiableOn.mono t3wB_N7shift_diff.differentiableOn
      exact Set.Ioo_subset_Icc_self
    obtain ⟨w, hw, hwd⟩ := Set.exists_deriv_eq_slope hu1pos hcont2 hdiff2
    rw [t3wB_N7shift_deriv w, sub_zero] at hwd
    field_simp [ne_of_gt hu1pos] at hwd
    have hmt : t3wB_N7shift u1 - t3wB_N7shift 0 = t3wB_N7f1 w * u1 := by
      simpa [mul_comm, mul_assoc, mul_left_comm] using hwd
    have hwneg : t3wB_N7f1 w < 0 :=
      (t3wB_N7f1_strict_inc w u1 hw.2 hw.1).trans hf1u1
    have hneg : t3wB_N7shift u1 - t3wB_N7shift 0 < 0 := by
      rw [hmt]
      apply mul_neg_of_neg_of_pos hwneg hu1pos
    have hun : t3wB_N7shift u1 < 0 := by linarith [hneg, t3wB_N7shift_at0_neg]
    linarith [hun, hz1]
