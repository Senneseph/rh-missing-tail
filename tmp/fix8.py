src = open('RhAttack/P4Limit.lean').read()
H = '\u211d'

# (a) add Finset.range_zero to the simp lists
oldlist = "simp only [Finset.sum_range_succ, Finset.prod_range_succ, Finset.sum_empty, Finset.prod_empty]"
newlist = "simp only [Finset.sum_range_succ, Finset.prod_range_succ, Finset.sum_empty, Finset.prod_empty, Finset.range_zero]"
n = src.count(oldlist)
print("simp lists:", n)
src = src.replace(oldlist, newlist)

XS = ['1', '9', '25', '49', '81', '121', '169', '225']
def dprod(ks):
    return " * ".join([f"(4 * t ^ 2 + {XS[k]} : {H})" for k in ks])

for ii, numname, alit, ci in [
    (2, "t3wB_num2", "((7/2 : " + H + ") * (13/8 : " + H + "))", 728),
    (4, "t3wB_num4", "((11/2 : " + H + ") * (13/8 : " + H + "))", 1144),
    (6, "t3wB_num6", "((15/2 : " + H + ") * (13/8 : " + H + "))", 1560),
    (7, "t3wB_num7", "((15/2 : " + H + ") * (13/8 : " + H + "))", 1560),
]:
    # (b) step-2 begin: add dsimp of the num def
    anchor = f"      _ = {numname} t := by\n"
    c = src.count(anchor)
    assert c == 1, (ii, c)
    src = src.replace(anchor, f"      _ = {numname} t := by\n        dsimp only [{numname}]\n")

    # (c) replace hC proof
    P = dprod(list(range(ii + 1)))
    Dflat = "128 * t * (13 * t / 8 - 1) * " + P
    old_hc = f"""        have hC : ({alit} / (13 * t / 8 - 1)) * {Dflat} = {ci} * t * {P} := by
          field_simp [(by nlinarith [show (13 : {H}) * t \u2265 13 * 13 from by nlinarith [ht]] : (13 * t / 8 - 1 : {H}) \u2260 0)]
          ring"""
    new_hc = f"""        have hC : ({alit} / (13 * t / 8 - 1)) * {Dflat} = {ci} * t * {P} := by
          have hY : (13 * t / 8 - 1 : {H}) \u2260 0 := by
            nlinarith [show (13 : {H}) * t \u2265 13 * 13 from by nlinarith [ht]]
          rw [show {Dflat} = (13 * t / 8 - 1) * (128 * t * {P}) from by ring]
          rw [\u2190 mul_assoc, div_mul_cancel]
          ring"""
    c = src.count(old_hc)
    assert c == 1, (f"hC {ii}", c)
    src = src.replace(old_hc, new_hc)

open('RhAttack/P4Limit.lean','w').write(src)
print("patched")
