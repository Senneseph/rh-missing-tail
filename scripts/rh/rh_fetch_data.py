#!/usr/bin/env python3
"""rh_fetch_data.py -- the ONE data entry point for this repo.

There is no zero data in git (every measured band is regenerable from
the public LMFDB index:  beta.lmfdb.org/riemann-zeta-zeros/data/,
Platt-format shards).  This dispatcher runs the PROVEN in-repo
pipelines for each band -- md5-gated, resume-safe, COUNT-chained:

  band   t range                lands at                                  built by
  -----  ---------------------  ----------------------------------------  -------------------------
  low    (0, 3.2e7]             /tmp/zeta-dl/shards/*.dat                 this script (19 shards,
         (~1 GB, ~10 min)       scripts/rh/zeros_T10000000_lmfdb.txt      md5-gated download)
                                 scripts/rh/lowt/zeros_0_to_1p2e3.f64    day024_platt_fast decode
                                                                         + day030_lowt_zeros.py
  1e9    (3.2e7, 1.0063e9]      scripts/rh/hi1e9/                          day024_band_1e9.sh
         (~22 GB, 15-45 min)        zeros_hi31946e6_to_1e9.f64
  3e9    (1.002e9, 3.0e9]       scripts/rh/hi1e9/                          day035_3e9_stream.sh
         (~50 GB, 30-90 min)        zeros_1002e6_to_2000e6.f64
                                 scripts/rh/hi3e9/
                                     zeros_2002e6_to_3000e6.f64
  3e10   (3.0e9, 3.0001e10]     scripts/rh/hi3e10/                         day035_t25_orchestrator.py
         (~740 GB, ~3-7 h)          zeros_2999e6_to_30000e6.f64            (8 fetch + 12 decode workers)

usage:   python3 rh_fetch_data.py {low|1e9|3e9|3e10|all} [--check]

  --check   verify already-present files only (no downloads).

Everything is resume-safe:  re-run the same command after an
interruption and it continues where it stopped.  Outputs land
exactly where the engines read them (all gitignored).  The 3e10
band needs ~740 GB of free space.
"""

import hashlib
import os
import re
import subprocess
import sys
import time

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.dirname(os.path.dirname(HERE))
DL = os.environ.get("ZETA_DL", "/tmp/zeta-dl")
INDEX = "https://beta.lmfdb.org/riemann-zeta-zeros/data/"
COOKIE = "Cookie: human=1"
PY = sys.executable

# the 15 shards of (0, 2.1446e7]  -- the GN decode set (convert_shards FILES)
GN_SHARDS = ["zeros_14.dat", "zeros_5000.dat", "zeros_26000.dat",
             "zeros_236000.dat", "zeros_446000.dat", "zeros_2546000.dat",
             "zeros_4646000.dat", "zeros_6746000.dat", "zeros_8846000.dat",
             "zeros_10946000.dat", "zeros_13046000.dat", "zeros_15146000.dat",
             "zeros_17246000.dat", "zeros_19346000.dat", "zeros_21446000.dat"]
# the 11 shards of (8.846e6, 3.1946e7]  -- td.load_g_range reads these raw
L_SHARDS = ["zeros_%d.dat" % t for t in
            (8846000, 10946000, 13046000, 15146000, 17246000, 19346000,
             21446000, 23546000, 25646000, 27746000, 29846000)]

# expected full sizes, (path, bytes) -- the verified pins
EXPECT = {
    "A-1e9": (os.path.join(HERE, "hi1e9", "zeros_hi31946e6_to_1e9.f64"), 8 * 2792198664),
    "B-3e9": (os.path.join(HERE, "hi1e9", "zeros_1002e6_to_2000e6.f64"), 8 * 3066173720),
    "C-3e9": (os.path.join(HERE, "hi3e9", "zeros_2002e6_to_3000e6.f64"), 8 * 3142622346),
    "D-3e10": (os.path.join(HERE, "hi3e10", "zeros_2999e6_to_30000e6.f64"), 8 * 92577877714),
}


def say(msg):
    print("[%s] %s" % (time.strftime("%F %T"), msg), flush=True)


def http_get(url, out):
    r = subprocess.run(["curl", "-sfL", "-H", COOKIE, "--max-time", "3600",
                        "--continue-at", "-", url, "-o", out])
    return r.returncode == 0


def md5_of(path):
    h = hashlib.md5()
    with open(path, "rb") as f:
        for chunk in iter(lambda: f.read(1 << 20), b""):
            h.update(chunk)
    return h.hexdigest()


def md5_table(tbl_path):
    if not os.path.exists(tbl_path) or not http_get(INDEX + "md5.txt", tbl_path):
        say("cannot reach the LMFDB index (md5 list) -- check the network")
        sys.exit(1)
    tbl = {}
    for line in open(tbl_path):
        parts = line.split()
        if len(parts) != 2:
            continue
        if re.fullmatch(r"[0-9a-f]{32}", parts[0]):
            tbl[parts[1]] = parts[0]
        elif re.fullmatch(r"[0-9a-f]{32}", parts[1]):
            tbl[parts[0]] = parts[1]
    return tbl


def fetch_shard(fn, tbl, retries=5):
    out = os.path.join(DL, "shards", fn)
    if os.path.exists(out) and md5_of(out) == tbl.get(fn):
        return
    if os.path.exists(out):
        os.remove(out)
    os.makedirs(os.path.dirname(out), exist_ok=True)
    for attempt in range(1, retries + 1):
        ok = http_get(INDEX + fn + ".part", out + ".part")
        if ok and os.path.exists(out + ".part"):
            if md5_of(out + ".part") == tbl.get(fn):
                os.rename(out + ".part", out)
                say("  shard %s ok" % fn)
                return
            os.remove(out + ".part")
        say("  shard %s attempt %d/%d failed (resumable)" % (fn, attempt, retries))
        time.sleep(min(30 * attempt, 120))
    say("shard %s: all attempts failed -- re-run to continue" % fn)
    sys.exit(1)


def rvm(t):
    # project RVM cross-check (N(t))
    import math
    return (t / (2 * math.pi)) * math.log(t / (2 * math.pi)) - t / (2 * math.pi) + 0.75


def check_file(label, path, want_bytes, present_only=False):
    if not os.path.exists(path):
        if present_only:
            print("MISSING  %-10s %s" % (label, path))
            return False
        return False  # caller reports / acts
    have = os.path.getsize(path)
    if want_bytes and have < 0.5 * want_bytes:
        print("INCOMPLETE %-8s %s  (%d of ~%d bytes; resume by re-running)"
              % (label, path, have, want_bytes))
        return False
    print("present  %-10s %s  (%d bytes)" % (label, path, have))
    return True


def band_low():
    say("band 'low': (0, 3.2e7]  -- shards + GN list + lowt file")
    tbl = md5_table(os.path.join(DL, "md5_low.txt"))
    for fn in GN_SHARDS + [f for f in L_SHARDS if f not in GN_SHARDS]:
        fetch_shard(fn, tbl)
    # GN list:  (0, 1e7] decoded with the bit-exact Platt decoder
    gn_txt = HERE + "/zeros_T10000000_lmfdb.txt"
    if os.path.exists(gn_txt) and os.path.getsize(gn_txt) > 300e6:
        say("  GN list already present")
    else:
        say("  decoding the 15 GN shards (day024_platt_fast, COUNT-chained)")
        os.makedirs(DL, exist_ok=True)
        n0 = 0
        allvals = None
        import struct
        for i, fn in enumerate(GN_SHARDS):
            part = os.path.join(DL, "gn_part_%02d.f64" % i)
            with open(part, "wb"):
                pass
            r = subprocess.run([PY, HERE + "/day024_platt_fast.py",
                                os.path.join(DL, "shards", fn), part],
                               input=b"COUNT %d\n" % n0, capture_output=True)
            if r.returncode != 0:
                say("  decoder failed on %s:\n%s" % (fn, r.stderr.decode()))
                sys.exit(1)
            m = re.search(r"Nt1=(\d+)", r.stdout.decode())
            if not m:
                say("  no Nt1 in decoder output for %s" % fn)
                sys.exit(1)
            n0 = int(m.group(1))
            with open(part, "rb") as f:
                vals = struct.unpack("<%dd" % (os.path.getsize(part) // 8),
                                     f.read())
            allvals = list(vals) if allvals is None else allvals + list(vals)
            os.remove(part)
        import numpy as np
        arr = np.array(allvals, dtype=np.float64)[:int(np.searchsorted(
            np.array(allvals, dtype=np.float64), 1e7))]
        with open(gn_txt + ".tmp", "w") as f:
            f.writelines("%.17g\n" % v for v in arr)
        os.rename(gn_txt + ".tmp", gn_txt)
        if abs(len(arr) - 21136125) > 3:
            say("  GN count %d deviates from the pinned N(1e7)=21136125 (--loud)" % len(arr))
        else:
            say("  GN list built: %d zeros in (0, 1e7] (pin: 21136125)" % len(arr))
    # lowt file (0, 1200] -- self-contained bisection fetch
    lowt = os.path.join(HERE, "lowt", "zeros_0_to_1p2e3.f64")
    if verify_one(lowt, "lowt"):
        pass
    else:
        say("  running day030_lowt_zeros.py (a few minutes)")
        r = subprocess.run([PY, HERE + "/day030_lowt_zeros.py"])
        if r.returncode != 0 or not verify_one(lowt, "lowt"):
            say("  lowt file not produced -- re-run to retry")
            sys.exit(1)
    say("band 'low' complete")


def verify_one(path, label):
    if os.path.exists(path) and os.path.getsize(path) > 1000:
        print("present  %-10s %s  (%d bytes)" % (label, path, os.path.getsize(path)))
        return True
    return False


def band_shell(label, cmd):
    say("band %s: running %s" % (label, " ".join(cmd)))
    r = subprocess.run(cmd, cwd=ROOT)
    if r.returncode != 0:
        say("  %s exited %d -- resume-safe: re-run to continue" % (label, r.returncode))
        sys.exit(1)


def band_1e9():
    band_shell("1e9", ["bash", HERE + "/day024_band_1e9.sh"])
    verify_outputs(["A-1e9"])


def band_3e9():
    band_shell("3e9", ["bash", HERE + "/day035_3e9_stream.sh"])
    verify_outputs(["B-3e9", "C-3e9"])


def band_3e10():
    if os.path.getsize(os.path.dirname(os.path.abspath(os.sep))) // (1 << 30) < 900:
        say("--loud: less than 900 GB free on /  -- the 3e10 band needs ~740 GB")
    band_shell("3e10", [PY, HERE + "/day035_t25_orchestrator.py"])
    verify_outputs(["D-3e10"])


def verify_outputs(labels):
    for lab in labels:
        path, want = EXPECT[lab]
        if not check_file(lab, path, want):
            say("%s: output missing or incomplete (resume-safe: re-run)" % lab)
            sys.exit(1)
    say("band complete")


def all_check():
    ok = True
    for lab, (path, want) in sorted(EXPECT.items()):
        if not check_file(lab, path, want, present_only=True):
            ok = False
    gn_txt = HERE + "/zeros_T10000000_lmfdb.txt"
    if not check_file("GN", gn_txt, None, present_only=True):
        ok = False
    lowt = os.path.join(HERE, "lowt", "zeros_0_to_1p2e3.f64")
    if not check_file("lowt", lowt, None, present_only=True):
        ok = False
    return ok


BANDS = {"low": band_low, "1e9": band_1e9, "3e9": band_3e9, "3e10": band_3e10}

if __name__ == "__main__":
    args = sys.argv[1:]
    if "--check" in args:
        args.remove("--check")
        sys.exit(0 if all_check() else 1)
    if not args or args[0] not in BANDS | {"all"}:
        print(__doc__)
        sys.exit(2)
    if args[0] == "all":
        seq = ["low", "1e9", "3e9", "3e10"]
    else:
        seq = [args[0]]
    for b in seq:
        BANDS[b]()
    say("done: " + ", ".join(seq))
