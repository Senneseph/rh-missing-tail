import mpmath as mp, json, math
for dps in (25, 45):
    mp.mp.dps = dps
    t0 = mp.mpf("3232170976.1122"); step = mp.mpf("0.025"); n = 40
    prev = None; ds = []
    for i in range(n+1):
        t = t0 + step*i
        a = mp.arg(mp.zeta(mp.mpf(0.5)+1j*t))
        if prev is not None:
            da = a - prev
            if da > mp.pi: da -= 2*mp.pi
            if da < -mp.pi: da += 2*mp.pi
            ds.append(float(da))
        prev = a
    ad = sorted(abs(d) for d in ds)
    big = [(i+1, float(d)) for i, d in enumerate(ds) if abs(d) > 0.5]
    print(f"dps={dps}: n={len(ds)} median|dS|={ad[len(ad)//2]:.6f} mean|dS|={sum(ad)/len(ad):.6f} max={ad[-1]:.6f} big={[(i, round(v,3)) for i,v in big]}")
