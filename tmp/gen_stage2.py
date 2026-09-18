import io

path = '/home/jsmille/Projects/rh-missing-tail/formal/RhAttack/P4Limit.lean'
s = open(path).read()

TPL = r'''
  -- ({num}) step {k}: B{k} -> B{k1} ({bndnote})
  theorem {name} {{s : ℂ}} (hsre : s.re = 1 / 2) (j : ℕ) (hj : 0 < j) :
      (∫ x in (j : ℝ)..(j + 1 : ℝ),
          (B{k}poly (x - (j : ℝ)) : ℂ) * (x : ℂ) ^ (-s - {k}))
          = {bnd}
              + (s + {k} : ℂ) / {k1} *
                  (∫ x in (j : ℝ)..(j + 1 : ℝ),
                    (B{k1}poly (x - (j : ℝ)) : ℂ) * (x : ℂ) ^ (-s - {k1})) := by
    set u : ℝ → ℂ := fun (x : ℝ) => (x : ℂ) ^ (-s - {k}) with hu
    set v : ℝ → ℂ := fun (x : ℝ) => ((B{k1}poly (x - (j : ℝ))) / {k1} : ℂ) with hv
    have hU : ∀ x ∈ Set.uIcc (j : ℝ) (j + 1 : ℝ),
        HasDerivAt u ((-s - {k}) * (x : ℂ) ^ (-s - {k1})) x := by
      intro x hx
      have hx0 : x ≠ 0 := by
        intro h
        have hxge : (j : ℝ) ≤ x := by
          simpa [show min (j : ℝ) (j + 1 : ℝ) = (j : ℝ) from min_eq_left (by nlinarith)]
            using hx.1
        linarith [(Nat.cast_pos (α := ℝ)).mpr hj, hxge, h]
      have hsc : -s - {k} ≠ 0 := by
        intro h
        have hre0 : (-(s : ℂ) - {k}).re = 0 := by simpa [h]
        rw [show (-(s : ℂ) - {k} : ℂ) = -((s : ℂ) + {k}) from by ring,
          Complex.neg_re, Complex.add_re,
          show ({k} : ℂ).re = {k} from by norm_num] at hre0
        linarith [hsre]
      have hexp : (-s - {k} : ℂ) - 1 = -s - {k1} := by ring
      simpa [hexp] using hasDerivAt_ofReal_cpow_const hx0 hsc
    have hV : ∀ x ∈ Set.uIcc (j : ℝ) (j + 1 : ℝ),
        HasDerivAt v ((B{k}poly (x - (j : ℝ))) : ℂ) x := by
      intro x _
      have hU1 : HasDerivAt (fun t : ℝ => t - (j : ℝ)) 1 x := by
        have hsub : HasDerivAt ((id : ℝ → ℝ) - (fun _ : ℝ => (j : ℝ))) (1 - 0) x := by
          simpa using (hasDerivAt_id x).sub (hasDerivAt_const x (j : ℝ))
        have hfun : (id : ℝ → ℝ) - (fun _ : ℝ => (j : ℝ)) = (fun t : ℝ => t - (j : ℝ)) := by
          funext t
          dsimp
        simpa [hfun] using hsub
      have hW0 := HasDerivAt.comp x (B{k1}poly_hasDerivAt (x - (j : ℝ))) hU1
      have hfun : (B{k1}poly ∘ (fun t : ℝ => t - (j : ℝ))) =
          (fun t : ℝ => B{k1}poly (t - (j : ℝ))) := by funext t; dsimp
      have hder : {k1} * B{k}poly (x - (j : ℝ)) * 1 = {k1} * B{k}poly (x - (j : ℝ)) := by ring
      have hW : HasDerivAt (fun t : ℝ => B{k1}poly (t - (j : ℝ)))
          ({k1} * B{k}poly (x - (j : ℝ))) x := by
        simpa [hfun, hder] using hW0
      have hW2 : HasDerivAt (fun t : ℝ => (B{k1}poly (t - (j : ℝ))) / {k1})
          (B{k}poly (x - (j : ℝ))) x := by
        simpa using hW.div_const {k1}
      simpa using HasDerivAt.ofReal_comp hW2
    have hCpowCO : ContinuousOn (fun x : ℝ => (x : ℂ) ^ (-s - {k1}))
        (Set.uIcc (j : ℝ) (j + 1 : ℝ)) := by
      intro x hx
      have hxge : (j : ℝ) ≤ x := by
        simpa [show min (j : ℝ) (j + 1 : ℝ) = (j : ℝ) from min_eq_left (by nlinarith)]
          using hx.1
      have hpos : 0 < x := by
        nlinarith [(Nat.cast_pos (α := ℝ)).mpr hj, hxge]
      exact (Complex.continuousAt_ofReal_cpow_const x (-s - {k1})
          (Or.inr (ne_of_gt hpos))).continuousWithinAt
    have hUint : IntervalIntegrable (fun x : ℝ => (-s - {k}) * (x : ℂ) ^ (-s - {k1}))
        volume (j : ℝ) (j + 1 : ℝ) :=
      ((continuousOn_const : ContinuousOn (fun x : ℝ => (-s - {k} : ℂ))
          (Set.uIcc (j : ℝ) (j + 1 : ℝ))).mul hCpowCO).intervalIntegrable
    have hVint : IntervalIntegrable (fun x : ℝ => (B{k}poly (x - (j : ℝ)) : ℂ))
        volume (j : ℝ) (j + 1 : ℝ) := by
      have hm : ContinuousOn (fun x : ℝ => (B{k}poly (x - (j : ℝ)) : ℂ))
          (Set.uIcc (j : ℝ) (j + 1 : ℝ)) := by fun_prop
      exact hm.intervalIntegrable
    have H : (∫ x in (j : ℝ)..(j + 1 : ℝ),
              u x * ((B{k}poly (x - (j : ℝ))) : ℂ)) =
        u (j + 1 : ℝ) * v (j + 1 : ℝ) - u (j : ℝ) * v (j : ℝ) -
          (∫ x in (j : ℝ)..(j + 1 : ℝ),
            ((-s - {k}) * (x : ℂ) ^ (-s - {k1})) * v x) :=
      (intervalIntegral.integral_mul_deriv_eq_deriv_mul
        (fun x hx => hU x hx)
        (fun x hx => hV x hx)
        hUint hVint : _ = _)
    calc (∫ x in (j : ℝ)..(j + 1 : ℝ),
            (B{k}poly (x - (j : ℝ)) : ℂ) * (x : ℂ) ^ (-s - {k}))
        _ = (∫ x in (j : ℝ)..(j + 1 : ℝ),
              u x * ((B{k}poly (x - (j : ℝ))) : ℂ)) := by
            have hEqU : EqOn
                (fun x : ℝ => u x * ((B{k}poly (x - (j : ℝ))) : ℂ))
                (fun x : ℝ =>
                  ((B{k}poly (x - (j : ℝ)) : ℂ) * (x : ℂ) ^ (-s - {k})))
                (Set.uIcc (j : ℝ) (j + 1 : ℝ)) := by
              intro x _
              dsimp only [u]
              ring
            exact (intervalIntegral.integral_congr
                (μ := (MeasureTheory.volume : Measure ℝ)) hEqU).symm
        _ = u (j + 1 : ℝ) * v (j + 1 : ℝ) - u (j : ℝ) * v (j : ℝ) -
            (∫ x in (j : ℝ)..(j + 1 : ℝ),
              ((-s - {k}) * (x : ℂ) ^ (-s - {k1})) * v x) := H
{bndcalc}
        _ = {bndtail}
            + ((s + {k} : ℂ) / {k1}) *
              (∫ x in (j : ℝ)..(j + 1 : ℝ),
                (B{k1}poly (x - (j : ℝ)) : ℂ) * (x : ℂ) ^ (-s - {k1})) := by
            have hX : (∫ x in (j : ℝ)..(j + 1 : ℝ),
                      ((-s - {k}) * (x : ℂ) ^ (-s - {k1})) * v x) =
                (-(s + {k} : ℂ)) / {k1} *
                  (∫ x in (j : ℝ)..(j + 1 : ℝ),
                    (B{k1}poly (x - (j : ℝ)) : ℂ) * (x : ℂ) ^ (-s - {k1})) := by
              have hEq : EqOn
                  (fun x : ℝ => ((-s - {k}) * (x : ℂ) ^ (-s - {k1})) * v x)
                  (fun x : ℝ => (-(s + {k} : ℂ)) / {k1} *
                    ((B{k1}poly (x - (j : ℝ)) : ℂ) * (x : ℂ) ^ (-s - {k1})))
                  (Set.uIcc (j : ℝ) (j + 1 : ℝ)) := by
                intro x _
                dsimp only [v]
                ring
              exact (intervalIntegral.integral_congr
                  (μ := (MeasureTheory.volume : Measure ℝ)) hEq).trans
                (by
                  rw [intervalIntegral.integral_const_mul (-(s + {k} : ℂ) / {k1})])
            rw [hX]
            ring
'''

def gen(K, num, name):
    k = K - 1
    zero = K in (5, 7)
    if zero:
        bnd = "0"
        bndnote = "vanishing boundary"
        bndcalc = (
            "        _ = - (∫ x in (j : ℝ)..(j + 1 : ℝ),\n"
            "                ((-s - %d : ℂ) * (x : ℂ) ^ (-s - %d)) * v x) := by\n"
            "            have hvb1 : v (j + 1 : ℝ) = 0 := by\n"
            "              dsimp only [v]\n"
            "              rw [show (j + 1 : ℝ) - (j : ℝ) = 1 from by ring, B%dpoly_at_1]\n"
            "              norm_num\n"
            "            have hvb0 : v (j : ℝ) = 0 := by\n"
            "              dsimp only [v]\n"
            "              rw [show (j : ℝ) - (j : ℝ) = 0 from by ring, B%dpoly_at_0]\n"
            "              norm_num\n"
            "            rw [hvb1, hvb0]\n"
            "            ring" % (k, K, K, K))
        bndtail = "0"
    else:
        bnd_expr = ("((B%dpoly 0 / %d : ℝ) : ℂ) * "
                    "(((j + 1 : ℝ) : ℂ) ^ (-s - %d) - ((j : ℝ) : ℂ) ^ (-s - %d))" % (K, K, k, k))
        bnd = bnd_expr
        bndnote = "boundary from B%d(0) = B%d(1)" % (K, K)
        bndcalc = (
            "        _ = ((B%dpoly 0 / %d : ℝ) : ℂ) *\n"
            "                (((j + 1 : ℝ) : ℂ) ^ (-s - %d) - ((j : ℝ) : ℂ) ^ (-s - %d)) -\n"
            "                (∫ x in (j : ℝ)..(j + 1 : ℝ),\n"
            "                  ((-s - %d : ℂ) * (x : ℂ) ^ (-s - %d)) * v x) := by\n"
            "            have hvb1 : v (j + 1 : ℝ) = ((B%dpoly 1 / %d : ℝ) : ℂ) := by\n"
            "              dsimp only [v]\n"
            "              rw [show (j + 1 : ℝ) - (j : ℝ) = 1 from by ring]\n"
            "            have hvb0 : v (j : ℝ) = ((B%dpoly 0 / %d : ℝ) : ℂ) := by\n"
            "              dsimp only [v]\n"
            "              rw [show (j : ℝ) - (j : ℝ) = 0 from by ring]\n"
            "            rw [hvb1, hvb0]\n"
            "            have hB%d : (B%dpoly 1 : ℝ) / %d = (B%dpoly 0 : ℝ) / %d := by\n"
            "              rw [B%dpoly_at_1, B%dpoly_at_0]\n"
            "            rw [hB%d]\n"
            "            ring" % (K, K, k, k, k, K, K, K, K, K, K, K, K, K, K, K, K, K))
        bndtail = bnd_expr
    out = TPL.replace("{name}", name).replace("{num}", num).replace("{bndnote}", bndnote)
    out = out.replace("{k1}", str(K)).replace("{k}", str(k))
    out = out.replace("{bnd}", bnd).replace("{bndcalc}", bndcalc).replace("{bndtail}", bndtail)
    if K == 4:
        w = "(x - (j : ℝ))"
        exp = "4 * (%s) ^ 3 - 2 * (3 * (%s) ^ 2) + 2 * (%s) - 0" % (w, w, w)
        old_v = (
            "      have hder : 4 * B3poly (x - (j : ℝ)) * 1 = 4 * B3poly (x - (j : ℝ)) := by ring\n"
            "      have hW : HasDerivAt (fun t : ℝ => B4poly (t - (j : ℝ)))\n"
            "          (4 * B3poly (x - (j : ℝ))) x := by\n"
            "        simpa [hfun, hder] using hW0\n"
            "      have hW2 : HasDerivAt (fun t : ℝ => (B4poly (t - (j : ℝ))) / 4)\n"
            "          (B3poly (x - (j : ℝ))) x := by\n"
            "        simpa using hW.div_const 4")
        new_v = (
            "      have hder : (%s) * 1 = %s := by ring\n"
            "      have hW : HasDerivAt (fun t : ℝ => B4poly (t - (j : ℝ)))\n"
            "          (%s) x := by\n"
            "        simpa [hfun, hder] using hW0\n"
            "      have hW2a : HasDerivAt (fun t : ℝ => (B4poly (t - (j : ℝ))) / 4)\n"
            "          ((%s) / 4) x := by\n"
            "        simpa using hW.div_const 4\n"
            "      have hE : (%s) / 4 = B3poly (x - (j : ℝ)) := by\n"
            "        dsimp only [B3poly]\n"
            "        ring\n"
            "      have hW2 : HasDerivAt (fun t : ℝ => (B4poly (t - (j : ℝ))) / 4)\n"
            "          (B3poly (x - (j : ℝ))) x := by\n"
            "        simpa [hE] using hW2a") % (exp, exp, exp, exp, exp)
        assert out.count(old_v) == 1, "K4 v-block not found"
        out = out.replace(old_v, new_v, 1)
    return out

block = (gen(4, "ii", "p4_25ae_ibp_b3to4") +
         gen(5, "iii", "p4_25ae_ibp_b4to5") +
         gen(6, "iv", "p4_25ae_ibp_b5to6") +
         gen(7, "v", "p4_25ae_ibp_b6to7") +
         gen(8, "vi", "p4_25ae_ibp_b7to8"))

pos = s.rindex('\nend\n')
assert 'p4_25ae_ibp_b3to4' not in s
s = s[:pos] + "\n" + block + s[pos:]
open(path, 'w').write(s)
print('inserted 5 atoms; lines:', s.count('\n'))
