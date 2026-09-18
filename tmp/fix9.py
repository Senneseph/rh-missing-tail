src = open('RhAttack/P4Limit.lean').read()
H = '\u211d'
XS = ['1', '9', '25', '49', '81', '121', '169', '225']
XS_T = [f"(4 * t ^ 2 + {x} : {H})" for x in XS]
PLIT = {2: "((7/2 : " + H + ") * (13/8 : " + H + "))",
        4: "((11/2 : " + H + ") * (13/8 : " + H + "))",
        6: "((15/2 : " + H + ") * (13/8 : " + H + "))",
        7: "((15/2 : " + H + ") * (13/8 : " + H + "))"}
CI = {2: 728, 4: 1144, 6: 1560, 7: 1560}

def dleft(ks):
    out = "128 * t * (13 * t / 8 - 1)"
    for k in ks:
        out += " * " + XS_T[k]
    return out

def dspine(ks):
    # the prod factor appears as a left-nested parenthesized product
    return "128 * t * (13 * t / 8 - 1) * (" + " * ".join([XS_T[k] for k in ks]) + ")"

def gen(ii, numname):
    n = ii + 1
    ks = list(range(n))
    Df = dleft(ks)
    Dn = dspine(ks)
    kterms = [f"(4 * t / {XS_T[k]}) * Dfull" for k in ks]
    step1_rhs = " + ".join(kterms + ["((1/2 : " + H + ") / t) * Dfull"]) + " - " + f"({PLIT[ii]} / (13 * t / 8 - 1)) * Dfull"
    lemmas = []
    for k in ks:
        others = [j for j in ks if j != k]
        prod_rhs = " * ".join([XS_T[j] for j in others])
        lemmas.append(f"""        have hk{k} : (4 * t / {XS_T[k]}) * Dfull = 512 * t ^ 2 * (13 * t / 8 - 1) * {prod_rhs} := by
          rw [Dfulldef]
          field_simp [(by positivity : {XS_T[k]} \u2260 0)]
          ring""")
    prod_all = " * ".join([XS_T[j] for j in ks])
    lemmas.append(f"""        have hB : ((1/2 : {H}) / t) * Dfull = 64 * (13 * t / 8 - 1) * {prod_all} := by
          rw [Dfulldef]
          field_simp [(by positivity : (2 * t : {H}) \u2260 0)]
          ring""")
    P = prod_all
    flat7 = None
    if ii == 7:
        import json as _json
        flat7 = _json.load(open("/tmp/flat7.json"))
        for k in ks:
            others = " * ".join([XS_T[j] for j in ks if j != k])
            lemmas.append(f"""        have F{k} : 512 * t ^ 2 * (13 * t / 8 - 1) * {others} = {flat7[f"F{k}"]} := by
          ring""")
        lemmas.append(f"""        have FB : 64 * (13 * t / 8 - 1) * {P} = {flat7["FB"]} := by
          ring""")
        lemmas.append(f"""        have FC : 1560 * t * {P} = {flat7["FC"]} := by
          ring""")
    lemmas.append(f"""        have hC : ({PLIT[ii]} / (13 * t / 8 - 1)) * Dfull = {CI[ii]} * t * {P} := by
          have hY : (13 * t / 8 - 1 : {H}) \u2260 0 := ne_of_gt (by linarith [ht])
          rw [Dfulldef]
          rw [show ({PLIT[ii]} / (13 * t / 8 - 1)) * (128 * t * (13 * t / 8 - 1) * {P}) =
                ({PLIT[ii]} : {H}) * ((13 * t / 8 - 1 : {H})\u207b¹ * (13 * t / 8 - 1)) * (128 * t * ({P})) from by ring]
          rw [show (13 * t / 8 - 1 : {H})\u207b¹ * (13 * t / 8 - 1) = 1 from by
            field_simp [hY, ne_of_gt (show (13 * t - 8 : {H}) > 0 by linarith [ht])]]
          ring""")
    rwlist = ", ".join([f"hk{k}" for k in ks] + ["hB", "hC"] + ([f"F{k}" for k in ks] + ["FB", "FC"] if ii == 7 else []))
    body = f"""theorem t3wB_h{ii}_id {{t : {H}}} (ht : 13 \u2264 t) : t3wB_h {ii} t = {numname} t / t3wB_den {ii} t := by
  have ht0 : 0 < t := by linarith [ht]
  have hden : t3wB_den {ii} t \u2260 0 := (t3wB_den_pos ht).ne'
  set Dfull := ({Df}) with Dfulldef
  have hmult : t3wB_h {ii} t * (t3wB_den {ii} t) = {numname} t := by
    calc
      t3wB_h {ii} t * (t3wB_den {ii} t) = {step1_rhs} := by
        dsimp only [t3wB_h, t3wB_den]
        norm_num [t3w_p]
        simp only [Finset.sum_range_succ, Finset.prod_range_succ, Finset.sum_empty, Finset.prod_empty, Finset.range_zero]
        norm_num
        rw [show ({Dn}) = Dfull from by ring]
        ring
      _ = {numname} t := by
        dsimp only [{numname}]
{chr(10).join(lemmas)}
        rw [{rwlist}]
        ring
  rw [show {numname} t / (t3wB_den {ii} t) = t3wB_h {ii} t from by rw [\u2190 hmult]; field_simp [hden]]
"""
    return body, f"theorem t3wB_h{ii}_id"

for ii, numname in [(2, "t3wB_num2"), (4, "t3wB_num4"), (6, "t3wB_num6"), (7, "t3wB_num7")]:
    new, header = gen(ii, numname)
    start = src.index(header)
    endpat = f"  rw [show {numname} t / (t3wB_den {ii} t) = t3wB_h {ii} t from by rw [\u2190 hmult]; field_simp [hden]]"
    endi = src.index(endpat, start) + len(endpat)
    src = src[:start] + new + src[endi:]

open('RhAttack/P4Limit.lean','w').write(src)
print("regenerated 4 theorems")
