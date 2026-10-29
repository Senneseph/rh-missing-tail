#!/usr/bin/env python3
"""0212-generation frontier board watcher for the [Z78ArviDensity]
supersession watch (B6 section 8, seventh supersession anchor).

Supersedes tracker_watch.py (0143-generation, anchor 0142) — kept in
place for history. Same exit contract:
  0  = nothing strictly stronger than the adopted face merged
  10 = a STRICTLY STRONGER MERGED record exists (B6 FIRES; run the
       section-8 conveyor: fetch at pinned commit, identity-check,
       byte-identity, stage C/D, in-tree module + B-part)
  11 = an OPEN PR / leaderboard entry claims a strictly stronger bound
       (PENDING; its merge triggers exit 10)

Channels:
  (1) merged board: official live catalogue (the GATE; string-fraction
      theta values - int() them; LOWER theta = better, MIN wins);
  (2) open PRs: any open PR declaring QRH-Bound: num/den (tracker API);
  (3) early signal: the bigospeedrun leaderboard (lags the official
      catalogue in the other direction - it shows open PRs before merge;
      informational, never the gate).

Alerts (0212 addition): on level-1/2 events a machine-readable alert is
written to WATCHER_ALERT.json (plus a B6-FIRED-<utc> marker file) so a
continuing agent turn can act once without re-deriving state.
"""
import json, urllib.request, datetime, os, sys, re, time

T = '/home/jsmille/Projects/rh-missing-tail/tmp/b6audit/tracker'
CATALOGUE = 'https://gtimg.github.io/QuasiRiemannTracker/catalogue.json'
PULLS = 'https://api.github.com/repos/GTimG/QuasiRiemannTracker/pulls?state=open&per_page=100'
LEADER = 'https://bigospeedrun.com/other/quasi-riemann'
ADOPTED = 43693617 / 50000000        # [Z78ArviDensity] arvi-density PR #94 (0211)
ADOPTED_ID = 'arvi-density'
SEEN_PRS = os.path.join(T, 'watcher_seen_prs.json')
ALERT = os.path.join(T, 'WATCHER_ALERT.json')

def now_iso():
    return datetime.datetime.now(datetime.timezone.utc).strftime('%Y-%m-%dT%H:%M:%SZ')

def val(r):
    b = r.get('theta') or r.get('exact_bound') or {}
    try:
        return int(b['numerator']) / int(b['denominator'])
    except Exception:
        return None

def pr_bound(body):
    m = re.search(r'QRH-Bound:\s*(\d+)\s*/\s*(\d+)', body or '')
    return int(m.group(1)) / int(m.group(2)) if m else None

def alert(level, summary, detail):
    """level 1 = merged stronger (B6 fires); level 2 = pending stronger."""
    payload = {
        'level': level, 'ts': now_iso(),
        'anchor': {'id': ADOPTED_ID, 'theta': ADOPTED,
                   'rational': '43693617/50000000'},
        'summary': summary, 'detail': detail,
        'action': ('run the B6 section-8 conveyor '
                   '(tmp/z78s35 pipeline: fetch at pinned source_commit, '
                   'identity-check Candidate.bound, dependency byte-identity '
                   'vs frozen copies, stage C per-module kernel compile, '
                   'stage D statement/axiom/zeta/sorry, in-tree module + '
                   'B-part, gates, docs, push)' if level == 1 else
                   'watch only: pending supersession (open PR); a MERGED '
                   'catalogue record below the anchor is what fires B6'),
    }
    json.dump(payload, open(ALERT, 'w'), indent=1)
    marker = os.path.join(T, f"B6{'-FIRED' if level == 1 else '-PENDING'}-"
                             + now_iso().replace(':', ''))
    open(marker, 'w').write(json.dumps(payload))
    return payload

def scan_leaderboard(f):
    """Channel 3: bigospeedrun early signal (raw HTML Astro table.
    Per row: <td class="rank">N</td>, bound in a katex annotation,
    merge state in the description text).  The OFFICIAL catalogue
    remains the gate; this is early signal only.
    Returns (top_bound, top_is_merged)."""
    try:
        html = urllib.request.urlopen(LEADER, timeout=60).read().decode(
            errors='ignore')
    except Exception as e:
        f.write(f'leaderboard: fetch failed ({e}); channel 3 skipped\n')
        return None, None
    rows = re.findall(r'<tr[^>]*>(?:(?!</tr>).)*</tr>', html, re.S)
    top = None
    top_merged = None
    for r in rows:
        mrank = re.search(r'class="rank"[^>]*>(=\d+|\d+)<', r)
        mbound = re.search(
            r'annotation encoding="application/x-tex">([\d.]+)<', r)
        if not mrank or not mbound:
            continue
        bound = float(mbound.group(1))
        t = re.sub(r'<[^>]+>', ' ', r)
        t = re.sub(r'\s+', ' ', t).lower()
        if 'open and not merged' in t or 'pr is open' in t:
            merged = False
        elif re.search(r'merged (the )?pull request|tracker merged pr|merged the pr|merged pr #?\d+', t):
            merged = True
        else:
            merged = None        # unknown state
        f.write(f'  lb row {mrank.group(1)}: bound={bound:.9f} '
                f'({"merged" if merged else "open" if merged is False
                    else "state-unknown"})\n')
        if top is None or bound < top:
            top, top_merged = bound, merged
    if top is not None:
        f.write(f'  leaderboard top: {top:.9f} ({"merged" if top_merged
                    else "open" if top_merged is False else "state-unknown"})\n')
    else:
        f.write('  leaderboard: no rank rows parsed; channel 3 skipped\n')
    return top, top_merged

def scan_open_prs(f):
    """Channel 2: open PRs declaring QRH-Bound (exact rational)."""
    try:
        prs = json.loads(urllib.request.urlopen(PULLS, timeout=60).read())
    except Exception as e:
        f.write(f'open-PR scan: fetch failed ({e}); channel 2 skipped\n')
        return 0
    seen = {}
    if os.path.exists(SEEN_PRS):
        seen = json.load(open(SEEN_PRS))
    flags = 0
    f.write(f'open PRs: {len(prs)} total\n')
    for p in prs:
        num = p.get('number')
        title = (p.get('title') or '')[:80]
        bound = pr_bound(p.get('body'))
        newmark = '' if str(num) in seen else '  ** NEW PR **'
        strongmark = ''
        if bound is not None and bound < ADOPTED - 1e-15:
            strongmark = '   *** PENDING SUPERSESSION: stronger than adopted (OPEN) ***'
            flags += 1
        if bound is not None:
            f.write(f'  PR #{num}  bound={bound:.12f}  {title}{newmark}{strongmark}\n')
        else:
            f.write(f'  PR #{num}  (no QRH-Bound)  {title}{newmark}\n')
        seen[str(num)] = {'title': title, 'bound': bound, 'first_seen': now_iso()}
    json.dump(seen, open(SEEN_PRS, 'w'), indent=1)
    return flags


def main():
    now = datetime.datetime.now(datetime.timezone.utc).strftime('%Y%m%d_%H%M')
    c = json.loads(urllib.request.urlopen(CATALOGUE, timeout=60).read())
    recs = c if isinstance(c, list) else c.get('records', c.get('results', []))
    rows = [(val(r), r.get('id'), (r.get('merged_at') or '')[:19]) for r in recs]
    rows = [x for x in rows if x[0] is not None]
    rows.sort(key=lambda x: x[0])
    top = rows[0] if rows else (None, None, '')

    lb_top, lb_merged = None, None
    with open(f'{T}/watch_{now}.txt', 'w') as f:
        f.write(f'frontier watch {now}Z — adopted [Z78ArviDensity] = '
                f'{ADOPTED:.8f} (43693617/50000000)\n')
        f.write(f'catalogue as_of {c.get("as_of", "?")} (dict) / '
                f'board: {len(rows)} records with numeric bounds\n')
        for v, rid, m in rows[:12]:
            mark = ' ** STRONGER THAN ADOPTED **' if v < ADOPTED - 1e-15 else ''
            f.write(f'  {v:.12f}  {rid}  merged={m}{mark}\n')
        f.write(f'  (merged-board gate: official catalogue as_of '
                f'{c.get("as_of", "?")})\n')
        lb_top, lb_merged = scan_leaderboard(f)
        pr_flags = scan_open_prs(f)
    stronger = [r for r in rows if r[0] < ADOPTED - 1e-15]
    print(f'[watch] board: {len(rows)} records; top = {top[0]:.12f} '
          f'({top[1]}, merged {top[2]})')
    if stronger:
        print(f'[watch] !!! B6 FIRES: {len(stronger)} MERGED record(s) '
              f'strictly below the adopted face:')
        for v, rid, m in stronger:
            print(f'[watch]     {v:.12f}  {rid}  merged={m}')
        alert(1, f'{len(stronger)} merged record(s) below the anchor; '
                 f'top {stronger[0][0]:.12f} ({stronger[0][1]})',
              [{'theta': v, 'id': i, 'merged': m} for v, i, m in stronger])
        sys.exit(10)
    pending = []
    if pr_flags:
        pending.append(('open-PR', None,
                        'open PR declares a QRH-Bound below the anchor'))
    if lb_top is not None and lb_top < ADOPTED - 1e-15 and lb_merged is False:
        pending.append(('leaderboard', lb_top, 'open PR at board rank 1'))
    print(f'[watch] no merged record below the anchor; [Z78ArviDensity] '
          f'remains the in-tree face.')
    if pending:
        for src, b, why in pending:
            print(f'[watch]   PENDING early signal: {src} {b:.9f} ({why})')
        alert(2, f'pending stronger bound (' +
                 (f'{pending[0][1]:.9f} ' if pending[0][1] is not None else '') +
                 f'({pending[0][2]})', pending)
        sys.exit(11)
    sys.exit(0)

if __name__ == '__main__':
    main()
