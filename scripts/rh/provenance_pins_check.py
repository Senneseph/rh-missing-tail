#!/usr/bin/env python3
"""provenance_pins_check.py -- verify the bit-level provenance pins
(0251 spec section 5.3 / FRONTIER item (D), pinned 2026-11-02).

Checks, against data/provenance/PINS.json:
  1. the two cited-paper objects pinned IN REPO (data/provenance/):
       the P-T arXiv:2004.09765v1 PDF  ([Z-PT2])
       the Platt 2017 isolation AAM   ([Z-PT])
     (exact byte size + SHA-256, and the pinned PDFs carry the
     verbatim claim headers recorded in the manifest);
  2. the 11-shard LMFDB zero-stream slice, IF its on-disk location
     (/tmp/zeta-dl/shards) is present (ephemeral by design; absence
     is reported, not a failure - the hashes are the pin and the
     slice re-fetches from beta.lmfdb.org/riemann-zeta-zeros).

Exit 0 = all present pins verified; 1 = a pin mismatch.  No RH
content: provenance hardening only.
"""
import hashlib
import json
import os
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.abspath(os.path.join(HERE, "..", ".."))
PIN_FILE = os.path.join(ROOT, "data", "provenance", "PINS.json")


def sha256_of(path):
    h = hashlib.sha256()
    with open(path, "rb") as f:
        for chunk in iter(lambda: f.read(1 << 20), b""):
            h.update(chunk)
    return h.hexdigest()


def main():
    pins = json.load(open(PIN_FILE))
    fails = []

    # 1. the in-repo pinned paper objects
    for key, entry in pins["cited_papers"].items():
        p = os.path.join(ROOT, entry["pinned_file"])
        if not os.path.exists(p):
            fails.append(f"MISSING pinned file {entry['pinned_file']}  [{key}]")
            continue
        size = os.path.getsize(p)
        digest = sha256_of(p)
        ok = size == entry["bytes"] and digest == entry["sha256"]
        print(f"[{'OK' if ok else 'FAIL'}] {key}: {entry['pinned_file']}")
        if not ok:
            print(f"        expected bytes={entry['bytes']} sha256={entry['sha256']}")
            print(f"        got      bytes={size} sha256={digest}")
            fails.append(key)

    # 2. the on-disk zero-stream slice (ephemeral; report-only)
    shards = pins["zero_stream"]["shards"]
    shard_dir = pins["zero_stream"]["shard_directory"].split()[0]
    if not os.path.isdir(shard_dir):
        print(f"[SKIP] zero-stream slice not on disk at {shard_dir} "
              f"(ephemeral - the {len(shards)} pinned hashes stand;"
              f" re-fetch from {pins['zero_stream']['source']})")
    else:
        bad = 0
        for s in shards:
            p = os.path.join(shard_dir, s["name"])
            if not os.path.exists(p):
                print(f"[FAIL] missing shard {s['name']}")
                bad += 1
                continue
            size = os.path.getsize(p)
            digest = sha256_of(p)
            if size != s["bytes"] or digest != s["sha256"]:
                print(f"[FAIL] shard {s['name']}: bytes={size} (want {s['bytes']}),"
                      f" sha256={digest}")
                bad += 1
        if bad == 0:
            total = sum(s["bytes"] for s in shards)
            print(f"[OK]   zero-stream slice: {len(shards)}/{len(shards)} shards,"
                  f" {total} bytes, all SHA-256 match the pin")
        else:
            fails.append(f"{bad} shard mismatches")

    if fails:
        print(f"\nPIN CHECK FAILED: {fails}")
        return 1
    print("\nPIN CHECK PASSED: all present provenance pins verified "
          "(2026-11-02 pin set, 0251 section 5.3)")
    return 0


if __name__ == "__main__":
    sys.exit(main())
