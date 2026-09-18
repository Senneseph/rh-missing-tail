import re
src = open('RhAttack/P4Limit.lean').read()
H = '\u211d'

XS = ['1', '9', '25', '49', '81', '121', '169', '225']  # (2k+1)^2
PLIT = {2: '(7/2 : ' + H + ') * (13/8 : ' + H + ')',
        4: '(11/2 : ' + H + ') * (13/8 : ' + H + ')',
        6: '(15/2 : ' + H + ') * (13/8 : ' + H + ')',
        7: '(15/2 : ' + H + ') * (13/8 : ' + H + ')'}
CI = {2: 728, 4: 1144, 6: 1560, 7: 1560}

def xprime(k):
    return f"(4 * t ^ 2 + {XS[k]} : {H})"

def dprod(ks):
    if not ks:
        return "1"
    out = [f"(4 * t ^ 2 + {XS[k]} : {H})" for k in ks]
    return " * ".join(out)

def gen_hid(ii, numname):
    n = ii + 1
    allks = list(range(n))
    dleft = "128 * t * (13 * t / 8 - 1) * " + " * ".join([xprime(k) for k in allks])
    # calc step-1 RHS terms
    kterms = [f"(4 * t / (4 * t ^ 2 + {XS[k]} : {H})) * {dleft}" for k in allks]
    bterm = f"((1/2 : {H}) / t) * {dleft}"
    cterm = f"(({PLIT[ii]}) / (13 * t / 8 - 1)) * {dleft}"
    step1_rhs = " + ".join(kterms + [bterm]) + " - " + cterm
    # step lemmas
    lemmas = []
    for k in allks:
        others = [x for x in allks if x != k]
        rhs = f"512 * t ^ 2 * (13 * t / 8 - 1) * {dprod(others)}"
        lemmas.append(f"""      have hk{k} : (4 * t / (4 * t ^ 2 + {XS[k]} : {H})) * {dleft} = {rhs} := by
        field_simp [show (4 * t ^ 2 + {XS[k]} : {H}) \u2260 0 by positivity]
        ring""")
    rb = f"64 * (13 * t / 8 - 1) * {dprod(allks)}"
    lemmas.append(f"""      have hB : ((1/2 : {H}) / t) * {dleft} = {rb} := by
        field_simp [show (2 * t : {H}) \u2260 0 by
          positivity]
        ring""")
    rc = f"{CI[ii]} * t * {dprod(allks)}"
    lemmas.append(f"""      have hC : (({PLIT[ii]}) / (13 * t / 8 - 1)) * {dleft} = {rc} := by
        field_simp [show (13 * t / 8 - 1 : {H}) \u2260 0 by
          nlinarith [show (13 : {H}) * t \u2265 13 * 13 from by nlinarith [ht]]
        ring""")
    rwlist = ", ".join([f"hk{k}" for k in allks] + ["hB", "hC"])
    body = f"""theorem t3wB_h{ii}_id {{t : {H}}} (ht : 13 \u2264 t) : t3wB_h {ii} t = {numname} t / t3wB_den {ii} t := by
  have ht0 : 0 < t := by linarith [ht]
  have hden : t3wB_den {ii} t \u2260 0 := (t3wB_den_pos ht).ne'
  have hmult : t3wB_h {ii} t * (t3wB_den {ii} t) = {numname} t := by
    dsimp only [t3wB_h, t3wB_den, {numname}]
    norm_num [t3w_p]
    simp only [Finset.sum_range_succ, Finset.prod_range_succ, Finset.sum_empty, Finset.prod_empty]
    calc
      t3wB_h {ii} t * (t3wB_den {ii} t) = {step1_rhs} := by
        ring
      _ = {numname} t := by
{chr(10).join(lemmas)}
        rw [{rwlist}]
        ring
  rw [show {numname} t / (t3wB_den {ii} t) = t3wB_h {ii} t from by rw [\u2190 hmult]; field_simp [hden]]
"""
    return body, f"theorem t3wB_h{ii}_id"

# replace each existing theorem from header to the closing show-line
for ii, numname in [(2, "t3wB_num2"), (4, "t3wB_num4"), (6, "t3wB_num6"), (7, "t3wB_num7")]:
    new, header = gen_hid(ii, numname)
    start = src.index(header)
    # find end: the line "  rw [show ... = t3wB_h ... := by rw [← hmult]; field_simp [hden]]" ends the body
    endpat = f"  rw [show {numname} t / (t3wB_den {ii} t) = t3wB_h {ii} t from by rw [\u2190 hmult]; field_simp [hden]]"
    endi = src.index(endpat, start) + len(endpat)
    src = src[:start] + new + src[endi:]

# also update the h def to the 4-form (mathematically identical)
old_h = ("def t3wB_h (i : ℕ) (t : ℝ) : ℝ :=\n"
         "  (∑ k ∈ Finset.range (i + 1), t / (t ^ 2 + ((k + 1 : ℝ) / 2) ^ 2)) + (1/2 : ℝ) / t -\n"
         "      (t3w_p i) * (13/8 : ℝ) / (13 * t / 8 - 1)")
if old_h in src:
    new_h = ("def t3wB_h (i : ℕ) (t : ℝ) : ℝ :=\n"
             "  (∑ k ∈ Finset.range (i + 1), (4 : ℝ) * t / (4 * t ^ 2 + (2 * k + 1 : ℝ) ^ 2)) +\n"
             "      (1/2 : ℝ) / t - (t3w_p i) * (13/8 : ℝ) / (13 * t / 8 - 1)")
    src = src.replace(old_h, new_h)
    print("h def -> 4-form")
else:
    print("h def not found (checking current form)")
    m = re.search(r"def t3wB_h \(i : ℕ\) \(t : ℝ\) : ℝ :=\n(?:.*\n){0,3}", src)
    print(repr(m.group(0)) if m else "not found at all")

open('RhAttack/P4Limit.lean','w').write(src)
print("patched")
