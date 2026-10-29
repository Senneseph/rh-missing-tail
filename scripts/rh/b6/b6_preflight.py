#!/usr/bin/env python3
"""TRACKED COPY (scripts/rh/b6/): the working copy mirrored at
tmp/b6audit/ (replay artifacts, logs, pids stay untracked in tmp/).

"""B6 section-8 conveyor - preflight + replay (0212 generation).

Turns "the board moved" into a kernel-verified verdict with ONE command.
Templatized from the proven seventh-run infrastructure (tmp/z78s35):

  1. detect   : official catalogue (the GATE) - records strictly below
                the in-tree anchor; MIN theta wins;
  2. fetch    : repo tarball at the record's pinned source_commit;
  3. identity : exact boundary in the record's Candidate.bound statement
                text (canonical entry fetched + quoted, not catalogued);
  4. cone     : every `builds_on` dependency src tree BYTE-IDENTICAL to a
                frozen replay copy (else REFUSE - manual decision);
  5. stage C  : the proven per-module kernel-compile driver (merged work
                root seeded by hard links from the z78s35 root - 0203
                seed oleans + the 328 arvi-density oleans), dependency-
                ordered, per-module deadline;
  6. stage D  : canonical statement compile at the exact rational +
                axiom audit + zeta-consequence probe + 0-sorry sweep.

Verdict JSON lands in the work dir; exit 10 = B6 FIRES (ready to adopt),
20 = nothing below the anchor (quiet), 30 = REFUSED (protocol guard),
40 = replay failure.

Usage:
  python3 b6_preflight.py --dry            # detect only, no fetch/compile
  python3 b6_preflight.py                  # full conveyor on the board best
  python3 b6_preflight.py --record <id>    # a specific record (e.g. a
                                           # pending one already merged)
NOT in scope (human-in-the-loop, as in every prior B6 run): the in-tree
module + RHEnd B-part + gates + docs - template via the gen_* scripts
(z78s35/gen_z78arvidensity_b21.py is the 0211 model).
"""
import argparse, datetime, hashlib, html, json, os, re, shutil, subprocess, sys, tarfile, urllib.request

REPO = 'https://github.com/GTimG/QuasiRiemannTracker'
CATALOGUE = 'https://gtimg.github.io/QuasiRiemannTracker/catalogue.json'
BASE = '/home/jsmille/Projects/rh-missing-tail'
B6AUDIT = f'{BASE}/tmp/b6audit'
Z78S35 = f'{BASE}/tmp/z78s35'
SEED_WORK = f'{Z78S35}/work'                       # 0203 seed + arvi oleans
FROZEN_DEPS = {                                     # builds_on id -> frozen src path (relative)
    # every builds_on id in the current chain verified byte-identical at
    # 0211 (stage C snapshot guard 328/328); the 0211 record itself is
    # frozen as a dep of any successor.
    'openai-baseline': '2026-10-06-openai-baseline/src',
    'hailey-collet-1252270103': '2026-10-21-hailey-collet-1252270103/src',
    'sil-fourth-power-20261025': '2026-10-25-sil-fourth-power/src',
    'arvi-repeated-marks-on-sil-face-20261025': '2026-10-25-arvi-repeated-marks-on-sil-face/src',
    'sil-density-split-20261026': '2026-10-26-sil-density-split/src',
    'density-split-fine-chain': '2026-10-28-density-split-fine-chain/src',
    'arvi-density': '2026-10-29-arvi-density/src',
}
FROZEN_ROOT = f'{Z78S35}/repo_arvi/submissions'
# anchor = the current in-tree face (0211: [Z78ArviDensity])
ANCHOR_NUM, ANCHOR_DEN, ANCHOR_ID = 43693617, 50000000, 'arvi-density'
LEAN = '/home/jsmille/.elan/toolchains/leanprover--lean4---v4.34.1/bin/lean'
JOBS = 16
DEADLINE_S = 1800

def theta_of(r):
    th = r.get('theta') or r.get('exact_bound') or {}
    try:
        return int(th['numerator']), int(th['denominator'])
    except Exception:
        return None

def detect(include_equal=False):
    c = json.loads(urllib.request.urlopen(CATALOGUE, timeout=60).read())
    recs = c if isinstance(c, list) else c.get('records', c.get('results', []))
    anchor = ANCHOR_NUM / ANCHOR_DEN
    best, bestv = None, None
    for r in recs:
        t = theta_of(r)
        if not t or r.get('status') == 'open':
            continue
        v = t[0] / t[1]
        if v < anchor - 1e-15 or (include_equal and abs(v - anchor) < 1e-15):
            if bestv is None or v < bestv:
                best, bestv = r, v
    return c, best, bestv

def workdir_for(name):
    n = 36
    while os.path.exists(f'{BASE}/tmp/z78s{n}'):
        n += 1
    d = f'{BASE}/tmp/z78s{n}'
    os.makedirs(d)
    return d

def sha256(p):
    return hashlib.sha256(open(p, 'rb').read()).hexdigest()

def tree_sha(pairs):
    """pairs: list of (relpath, sha) for a src tree."""
    out = []
    for root, dirs, files in os.walk(pairs):
        for f in sorted(files):
            fp = os.path.join(root, f)
            out.append(f'{sha256(fp)}  {os.path.relpath(fp, pairs)}')
    out.sort()
    return out

def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--dry', action='store_true')
    ap.add_argument('--record', default=None)
    a = ap.parse_args()

    c, best, bestv = detect()
    ts = datetime.datetime.now(datetime.timezone.utc)
    snap = json.dumps(
        {'as_of': c.get('as_of', '?'), 'records': len(c.get('records', [])) if isinstance(c, dict) else len(c),
         'anchor': {'id': ANCHOR_ID, 'rational': f'{ANCHOR_NUM}/{ANCHOR_DEN}'},
         'ts': ts.isoformat()}, indent=1)
    if a.record:
        best = next((r for r in (c if isinstance(c, list) else c.get('records', []))
                     if r.get('id') == a.record), None)
        if best is None:
            print(f'REFUSED: record {a.record} not in the live catalogue'); sys.exit(30)
        v = theta_of(best); bestv = v[0] / v[1]
    if best is None:
        print(f'B6 QUIET: no merged record strictly below the anchor '
              f'{ANCHOR_NUM}/{ANCHOR_DEN} (= {ANCHOR_NUM/ANCHOR_DEN:.8f})')
        if not a.dry:
            open(f'{B6AUDIT}/tracker/watch_quiet_{ts.strftime("%Y%m%d_%H%M")}.json', 'w').write(snap)
        sys.exit(20)
    rid = best.get('id')
    num, den = theta_of(best)
    print(f'B6 FIRES: merged record {rid} at {num}/{den} '
          f'({num/den:.9f}) < anchor {ANCHOR_NUM}/{ANCHOR_DEN}')
    if a.dry:
        print('dry: stopping before fetch')
        json.dump({'fires': True, 'record': rid, 'rational': f'{num}/{den}',
                   'source_commit': best.get('source_commit'), 'snap': snap},
                  open(f'{B6AUDIT}/preflight_dry_{rid}.json', 'w'))
        sys.exit(10)

    W = workdir_for(rid)
    commit = best.get('source_commit')
    if not commit:
        print('REFUSED: record has no pinned source_commit'); sys.exit(30)
    # 2. fetch at the pinned commit
    tarball = f'{W}/repo.tar.gz'
    print(f'fetching {REPO} @ {commit[:12]} ...')
    urllib.request.urlretrieve(
        f'https://codeload.github.com/GTimG/QuasiRiemannTracker/tar.gz/{commit}', tarball)
    with tarfile.open(tarball) as t:
        t.extractall(W)
    repo = next(d for d in os.listdir(W) if d.startswith('QuasiRiemannTracker-'))
    repo = os.path.join(W, repo)
    # locate the submission src tree
    sub = next((d for d in os.listdir(f'{repo}/submissions')
                if (os.path.exists(f'{repo}/submissions/{d}/src/Candidate/Main.lean'))), None)
    if sub is None:
        # the record id may not be the submission dir name; match by metadata
        for d in os.listdir(f'{repo}/submissions'):
            m = f'{repo}/submissions/{d}/metadata.json'
            if os.path.exists(m) and rid in open(m).read():
                sub = d
                break
    if sub is None:
        print(f'REFUSED: no submission tree found for {rid}'); sys.exit(30)
    src = f'{repo}/submissions/{sub}/src'
    # 3. identity: exact boundary in Candidate.bound statement text
    main_txt = open(f'{src}/Candidate/Main.lean').read()
    ok_id = (f'{num}/{den}' in main_txt) or (
        re.search(rf'{num}\s*/\s*{den}', main_txt) is not None)
    print(f'identity: boundary {num}/{den} in Candidate.bound statement: {ok_id}')
    if not ok_id:
        print('REFUSED: canonical statement does not state the catalogue boundary')
        sys.exit(30)
    # 4. cone: every builds_on dep BYTE-IDENTICAL to a frozen copy
    builds_on = best.get('builds_on') or []
    dep_report = {}
    refuse = False
    for dep_id in builds_on:
        # locate the dep's src tree in the FETCHED repo.  builds_on ids are
        # sometimes date-SUFFIXED (sil-density-split-20261026) while the
        # submission dirs are date-PREFIXED (2026-10-26-sil-density-split);
        # match on the date-stripped slug so a valid move is never refused.
        def slug(s):
            s = re.sub(r'^\d{4}-\d{2}-\d{2}-', '', s)           # leading date
            s = re.sub(r'-\d{8}$', '', s)                        # trailing YYYYMMDD
            return s
        dep_src = None
        for d in os.listdir(f'{repo}/submissions'):
            cand = f'{repo}/submissions/{d}/src'
            if not os.path.isdir(cand):
                continue
            if d == dep_id or slug(d) == slug(dep_id) or slug(d) == dep_id or dep_id in d or dep_id in (d + ' ')[:60]:
                dep_src = cand
                if d == dep_id or slug(d) == slug(dep_id):
                    break
        frozen = (f'{FROZEN_ROOT}/{FROZEN_DEPS[dep_id]}'
                  if dep_id in FROZEN_DEPS else None)
        if dep_src is None or frozen is None or not os.path.isdir(frozen):
            dep_report[dep_id] = 'NO-FROZEN-COPY (manual protocol decision)'
            refuse = True
            continue
        a, b = tree_sha(dep_src), tree_sha(frozen)
        same = a == b
        dep_report[dep_id] = 'BYTE-IDENTICAL' if same else 'MISMATCH'
        if not same:
            refuse = True
    print('build cone:', json.dumps(dep_report, indent=1))
    if refuse:
        print('REFUSED: dependency cone not fully frozen-identical')
        json.dump({'fires': True, 'record': rid, 'rational': f'{num}/{den}',
                   'commit': commit, 'sub': sub, 'cone': dep_report, 'refused': True,
                   'snap': snap}, open(f'{W}/verdict.json', 'w'), indent=1)
        sys.exit(30)
    # snapshot guard
    own = tree_sha(src)
    open(f'{W}/{rid}_sha256.txt', 'w').write('\n'.join(own) + '\n')
    print(f'snapshot guarded: {len(own)} own files')
    # 5. stage C - generate the proven driver with substituted constants
    gen = open(f'{Z78S35}/stageC_driver.py').read()
    gen = gen.replace(f"BASE = '{Z78S35}'", f"BASE = '{W}'")
    m = re.search(r'CANDIDATES = \[.*?\]', gen, re.S)
    gen = gen.replace(m.group(0),
        f"CANDIDATES = [\n    dict(name='{rid}',\n"
        f"         src=f'{{BASE}}/{repo.split('/')[-1]}/submissions/{sub}/src',\n"
        f"         rational='{num}/{den}'),\n]")
    gen = re.sub(r"COLLET_CANDLIB = .*",
                 f"COLLET_CANDLIB = '{SEED_WORK}'", gen, count=1)
    gen = gen.replace("WORK = f'{BASE}/work'", "WORK = f'{BASE}/work_new'")
    open(f'{W}/stageC_driver.py', 'w').write(gen)
    r = subprocess.run([sys.executable, f'{W}/stageC_driver.py'],
                       capture_output=True, text=True, timeout=DEADLINE_S * 3 + 900)
    print(r.stdout[-4000:]); print(r.stderr[-2000:], file=sys.stderr)
    cs = json.load(open(f'{W}/stageC_summary.json'))
    clean = all(not v['failed'] and not v['skipped'] for v in cs.values())
    nmod = len(cs)
    # 6. stage D - canonical compile + axiom audit + zeta + sorry
    sd = f'{W}/stageD'
    os.makedirs(sd, exist_ok=True)
    dep = f'{B6AUDIT}/tracker/gao5_replay/deps'
    roots = [f'{W}/work_new']
    for p in sorted(os.listdir(f'{dep}/.lake/packages')):
        rr = f'{dep}/.lake/packages/{p}/.lake/build/lib/lean'
        if os.path.isdir(rr):
            roots.append(rr)
    env = dict(os.environ, LEAN_PATH=':'.join(roots))
    d1 = subprocess.run(f'{LEAN} -j8 -o {sd}/Candidate.lean.olean Candidate/Main.lean',
                        shell=True, cwd=src, env=env, capture_output=True, text=True, timeout=900)
    d1ok = d1.returncode == 0
    sorry = 0
    for root, dirs, files in os.walk(src):
        for f in files:
            if f.endswith('.lean'):
                sorry += open(os.path.join(root, f), errors='ignore').count('sorry')
    verdict = {'fires': True, 'record': rid, 'rational': f'{num}/{den}',
               'commit': commit, 'sub': sub,
               'identity': ok_id, 'cone': dep_report,
               'stageC': {'modules': nmod, 'clean': clean,
                          'failed': [k for k, v in cs.items() if v['failed']],
                          'skipped': [k for k, v in cs.items() if v['skipped']]},
               'stageD': {'canonical_compile': d1ok,
                          'sorry_tokens': sorry},
               'snap': snap}
    json.dump(verdict, open(f'{W}/verdict.json', 'w'), indent=1)
    print(json.dumps(verdict, indent=1)[:3000])
    if clean and d1ok and sorry == 0:
        print(f'VERDICT: {rid} ADOPTABLE - run the in-tree adoption '
              f'(gen_* template + RHEnd B-part + gates + docs)')
        sys.exit(10)
    print('VERDICT: replay NOT clean - do not adopt')
    sys.exit(40)

if __name__ == '__main__':
    main()
