src = open('RhAttack/P4Limit.lean').read()
H = '\u211d'   # ℝ

def facs(i):
    out = []
    for k in range(i + 1):
        if k == 0:
            out.append("(show (t ^ 2 + (1/2 : " + H + ") ^ 2) \u2260 0 from by positivity)")
        else:
            num = 2 * k + 1
            out.append(f"(show (t ^ 2 + ({num} : {H})/2 ^ 2) \u2260 0 from by positivity)")
    return out

specs = [(2, "t3wB_num2"), (4, "t3wB_num4"), (6, "t3wB_num6"), (7, "t3wB_num7")]

for ii, numname in specs:
    old = f"""theorem t3wB_h{ii}_id {{t : {H}}} (ht : 13 \u2264 t) : t3wB_h {ii} t = {numname} t / t3wB_den {ii} t := by
  have ht0 : 0 < t := by linarith [ht]
  have h8nz : (13 * t - 8 : {H}) \u2260 0 := by
    have : 13 * t - 8 > 0 := by nlinarith [show (13 : {H}) * t \u2265 13 * 13 from by nlinarith [ht]]
    linarith
  have hnlo : (13 * t / 8 - 1 : {H}) \u2260 0 := by
    have : 13 * t / 8 - 1 > 0 := by nlinarith [show (13 : {H}) * t \u2265 13 * 13 from by nlinarith [ht]]
    linarith
  simp only [t3wB_h, t3wB_den]
  norm_num [t3w_p]
  simp only [Finset.sum_range_succ, Finset.prod_range_succ, Finset.sum_empty, Finset.prod_empty]
  field_simp [ht0.ne', h8nz, hnlo]
  ring"""
    assert src.count(old) == 1, f"h{ii}_id"
    flist = ', '.join(["(show (2 * t : " + H + ") \u2260 0 from by positivity)"] + facs(ii))
    new = f"""theorem t3wB_h{ii}_id {{t : {H}}} (ht : 13 \u2264 t) : t3wB_h {ii} t = {numname} t / t3wB_den {ii} t := by
  have ht0 : 0 < t := by linarith [ht]
  have hnlo : (13 * t / 8 - 1 : {H}) \u2260 0 := by
    have : 13 * t / 8 - 1 > 0 := by nlinarith [show (13 : {H}) * t \u2265 13 * 13 from by nlinarith [ht]]
    linarith
  have hden : t3wB_den {ii} t \u2260 0 := (t3wB_den_pos ht).ne'
  have hmult : t3wB_h {ii} t * (t3wB_den {ii} t) = {numname} t := by
    dsimp only [t3wB_h, t3wB_den, {numname}]
    norm_num [t3w_p]
    simp only [Finset.sum_range_succ, Finset.prod_range_succ, Finset.sum_empty, Finset.prod_empty]
    ring
    field_simp [{flist}]
    ring
  rw [show {numname} t / (t3wB_den {ii} t) = t3wB_h {ii} t from by rw [\u2190 hmult]; field_simp [hden]]"""
    src = src.replace(old, new)

for ii, numname in [(2, "t3wB_num2"), (4, "t3wB_num4"), (6, "t3wB_num6")]:
    oldb = f"  have h{ii}_id : t3wB_h {ii} t = {numname} t / t3wB_den {ii} t := t3wB_h{ii}_id ht"
    newb = f"""  rw [t3wB_h{ii}_id ht]
  exact div_neg_of_neg_of_pos ({numname}_neg ht0) (t3wB_den_pos ht)"""
    count = src.count(oldb)
    assert count == 1, f"hneg {ii}: {count}"
    src = src.replace(oldb, newb)

open('RhAttack/P4Limit.lean','w').write(src)
print("patched")
