lines = open('RhAttack/P4Limit.lean').readlines()
out = []
i = 0
while i < len(lines):
    l = lines[i]
    # remove mangled hlo have-lines (2 lines each)
    if 'have hlo : 13 * t / 8 - 1' in l and ('0 := by' in l or ':=' in l):
        i += 2
        continue
    if l.strip() == 'change Real.sqrt (t3w_prod t i) * ((13 * t / 8 - 1 : ℝ)) ^ (-(t3w_p i)) * M * N =':
        i += 2
        continue
    if 'dsimp only [Mdef, Ndef, Ydef, Zdef]' in l:
        l = l.replace('dsimp only [Mdef, Ndef, Ydef, Zdef]', 'simp only [Mdef, Ndef, Ydef, Zdef]')
    if 'from by rw [← rpow_add hbase]; ring,' in l:
        l = l.replace('from by rw [← rpow_add hbase]; ring,', 'from by rw [← rpow_add hbase],')
    out.append(l)
    i += 1
open('RhAttack/P4Limit.lean','w').writelines(out)
print("done")
