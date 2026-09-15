#!/usr/bin/env python3
"""day024 (25x sweep) — sharpen the S1-gap boundary the 17-window scan found.

The 17-window 25x scan (hi1e9/screen_25x.log) showed: SOUND (margin >= 1.4)
through the 3.75e7 window, margin < 1 at 5e7 / 7.5e7 (E ~ 0.015-0.03:
kernel-robust, best-case E->0 still < 1: 0.954 / 0.73), a local recovery at
1e8 (1.45), then < 1 again (1.5e8 ... 1e9).  This sweep densifies the
(3.75e7, 2e9] decade grid to locate the boundary windows.  Same protocol,
same tail (actual zeros to 1.006346e9), screening level.
"""
import os
import concurrent.futures as cf
import day024_band1e9_screen as S

SWEEP = [(3.9e7, "3.9e7"), (4.0e7, "4.0e7"), (4.25e7, "4.25e7"),
         (4.4e7, "4.4e7"), (4.6e7, "4.6e7"), (4.8e7, "4.8e7"),
         (5.2e7, "5.2e7"), (5.6e7, "5.6e7"), (6.0e7, "6.0e7"),
         (6.4e7, "6.4e7"), (6.8e7, "6.8e7"), (7.2e7, "7.2e7"),
         (7.8e7, "7.8e7"), (8.4e7, "8.4e7"), (9.0e7, "9.0e7"),
         (9.6e7, "9.6e7"), (1.05e8, "1.05e8"), (1.1e8, "1.1e8"),
         (1.2e8, "1.2e8"), (1.3e8, "1.3e8"), (1.4e8, "1.4e8"),
         (1.6e8, "1.6e8"), (1.8e8, "1.8e8"), (2.0e8, "2.0e8"),
         (3.0e8, "3.0e8"), (5.0e8, "5.0e8")]


def run():
    work = int(os.environ.get("WORKERS", "12"))
    T = S.TH.tail()
    print("25x sweep: %d windows, same protocol/tail; G_LAST %.6f"
          % (len(SWEEP), T.G_LAST), flush=True)
    with cf.ProcessPoolExecutor(max_workers=work) as ex:
        futs = [ex.submit(S.scan_one, x, lab) for (x, lab) in SWEEP]
        results = [fu.result() for fu in futs]
    results.sort(key=lambda r: float(r["t"]))
    print("%-10s %10s %9s %9s %9s %9s %9s %9s  %-9s %s" %
          ("g", "t_best", "margin", "def_c", "resid", "zeta", "dev", "E",
           "bound", "label"))
    for r in results:
        deff = r["B"] + r["resid"]
        print("%-10.4f %10.4f %9.4f %9.5f %9.5f %9.4f %9.4f %9.6f  %-9.3f %s"
              % (float(r["g"]), float(r["t"]), float(r["margin"]),
                 float(deff), float(r["resid"]), float(r["zeta"]),
                 float(r["dev"]), float(r["E"]), float(r["bound"]),
                 r["label"]))


if __name__ == "__main__":
    run()
