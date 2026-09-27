rh-final-data -- H1 3e10 fleet: final results + evidence
Snapshot: 2026-09-27 (5900X engine still running; its log/pts are a snapshot)

4090-box/   8x RTX 4090 vast box (finished 2026-09-27, windows 0-28)
  out_day038_full_pts.txt  =  ASSEMBLED FINAL OUTPUT (all certified pts)
  out_day038_full_{a..h}.log = per-instance full logs (699 certified lines)
  6/8 slices FULL-DONE; exceptions: window1 x=3.491e9 (1 k-offset),
  window18 x=1.292e10 (2 k-offsets) -- cert-gate failures, not faults.

5900x/      local 5900X+3090Ti engine (windows 1-11, 166+ certified at snapshot)
  out_day038_full.log      = results log (grows while engine runs)
  out_day045.log           = supervisor log
  ckpt/                    = window checkpoints (resume state)
  *.pts (if present)       = in-flight point files (transient by design)

evidence/   destroy verdict (node 52294870, all bands md5-identical),
  5900x band md5 records, strix byte-identity chain, data-layout doc.

Bands (A/B/C/D 814GB) are NOT in this folder by design: they live on
Pirana (5900X) and the 4090 box volume, md5-verified identical;
regenerable from LMFDB via rh_fetch_data.py.
