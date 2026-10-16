#!/usr/bin/env python
"""discovery_sync -- the discovery log reorganization.

docs/discovery/entries/  IS  the  source  of  truth:  every  .json
file  in  it  is  a  valid,  well-formed  entry  (browse  it
straight  through  normal  git  /  GitHub  access  and
permissions).  There  is  no  index  /  manifest  file  --  the
directory  is  the  enumeration.  Each  entry's  unique
identifier  is  its  real  date  +  time  (YYYY-MM-DD  [+T]  HHMM);
the  n  sequence  number  is  only  a  sort  key.  Duplicated
identifiers  are  reported  (fix  by  giving  the  later  entry  a
real  time).

The  root  DISCOVERY_LOG.md  was  migrated  into  the  entries  once
and  is  FROZEN  (archival).  New  entries  are  written  as  fresh
JSON  files  and  this  script  regenerates  the  one  generated
artifact,  the  interactive  view:

  docs/discovery/DISCOVERY.html     self-contained  (entries
                                    embedded),  opens  from  a
                                    double-click  /  file://  with
                                    no  network  and  no  deps

Add-a-new-entry  flow:
  1.  next  number  =  (highest  existing  n)  +  1
  2.  write  entries/NNNN-YYYY-MM-DD[THHMM]-slug.json  with
      {  "n":  ...,  "date":  "...",  "time":  "HHMM",  "title":
      "...",  "body":  "..."  }
      time  =  the  real  wall-clock  time;  whenever  the  date
      already  has  an  entry  it  is  REQUIRED  (the  identifier
      must  be  unique).
  3.  run  python  scripts/rh/discovery_sync.py
  4.  commit  +  push

The  --migrate  flag  re-parses  the  frozen  log  into  the  entry
files  (migrated  range  only;  hand-written  later  entries  are
never  touched).

Parser  notes  (two  generations  of  header  format  in  the
frozen  log):
  -  numbered  era:    "##  5.  Title  (2026-09-11)"
  -  dated  era:       "##  2026-10-15  (pm8c)  TITLE"
      wrapped  title  lines  (a  following  "##  frag"  with
      neither  a  leading  number  nor  a  date)  are  folded  into
      the  title.
  -  sections  1..4  (the  intro  scaffold)  become  entry  0.
"""
import argparse
import json
import os
import re
import sys

ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", ".."))
ENT = os.path.join(ROOT, "docs", "discovery", "entries")
MD = os.path.join(ROOT, "DISCOVERY_LOG.md")
HTML = os.path.join(ROOT, "docs", "discovery", "DISCOVERY.html")

DATE_HDR = re.compile(
    r"^## (\d{4}-\d{2}-\d{2})\s*(\((pm\d*[a-z]?|am\d*[a-z]?)\))?\s*(.*)$")
NUM_HDR = re.compile(r"^## (\d+)\.\s*(.*)$")
WRAP_HDR = re.compile(r"^## ")
TDATE = re.compile(r"\((\d{4}-\d{2}-\d{2})\)")
BARE_TDATE = re.compile(r"\b(\d{4}-\d{2}-\d{2})\b")


def is_hdr(line):
    return bool(DATE_HDR.match(line) or NUM_HDR.match(line))


def clean(bodylines):
    while bodylines and bodylines[-1].strip() in ("", "---"):
        bodylines.pop()
    return "\n".join(bodylines).strip()


def ident(date, time):
    """The  entry's  unique  identifier:  real  date  +  time."""
    if time:
        return "%sT%s" % (date, time)
    return date


def slug(n, date, time, title):
    s = re.sub(r"[^a-z0-9]+", "-", title.lower()).strip("-")[:40].rstrip("-")
    return "%04d-%s%s-%s.json" % (
        n, date or "0000-00-00", ("T" + time) if time else "", s or "entry")


def migrate(lines):
    """Parse  the  frozen  log  ->  chronological  entry  list."""
    entries = []
    i = 0
    # intro  scaffold:  everything  before  the  first  entry
    # header  (the  numbered  era  starts  at  "##  5.";
    # 1..4  are  the  scaffold)
    while i < len(lines):
        m = NUM_HDR.match(lines[i])
        if m and int(m.group(1)) >= 5:
            break
        i += 1
    intro = lines[:i]

    while i < len(lines):
        line = lines[i]
        m = DATE_HDR.match(line) or NUM_HDR.match(line)
        if not m:
            i += 1
            continue
        if DATE_HDR.match(line):
            m2 = DATE_HDR.match(line)
            date, e_time, title = m2.group(1), (m2.group(3) or ""), \
                m2.group(4).strip()
        else:
            e_time = ""
            m2 = NUM_HDR.match(line)
            title = m2.group(2).strip()
            dm = TDATE.search(title) or BARE_TDATE.search(title)
            date = dm.group(1) if dm else ""
            if dm and title[dm.start():dm.start() + 1] == "(":
                # the  whole  parenthetical  group  is  just  the  date
                if title[dm.end():dm.end() + 1] == ")":
                    title = (title[:dm.start()] + " " +
                             title[dm.end() + 1:]).strip()
        i += 1
        # wrapped  title  (a  following  "##  frag"  without  date/number)
        while i < len(lines) and WRAP_HDR.match(lines[i]) and \
                not is_hdr(lines[i]):
            title += " " + lines[i][3:].strip()
            i += 1
        body = []
        while i < len(lines) and not is_hdr(lines[i]):
            body.append(lines[i])
            i += 1
        entries.append({"n": 0, "date": date, "time": e_time,
                        "title": title, "body": clean(body)})

    if intro and any(l.strip() for l in intro):
        entries.insert(0, {
            "n": 0, "date": "", "time": "",
            "title": "The  chronicle:  approach,  pieces,  "
                     "contradictions  (intro  scaffold)",
            "body": clean(intro)})
    for k, e in enumerate(entries):
        e["n"] = k            # file  order  =  chronological  order
    return entries


def load_entries():
    out = []
    if not os.path.isdir(ENT):
        return out
    for f in sorted(os.listdir(ENT)):
        if not f.endswith(".json"):
            continue
        with open(os.path.join(ENT, f)) as fh:
            e = json.load(fh)
        for key in ("n", "date", "time", "title", "body"):
            e.setdefault(key, "" if key != "n" else 0)
        e["file"] = f
        out.append(e)
    out.sort(key=lambda x: (int(x["n"]), x["date"]))
    return out


def assign_idents(entries):
    """Make  every  identifier  (date  [+  time])  unique,
    persisting  the  assignments.  Rules  (in  chronological  n
    order):
      -  an  entry  with  a  time  (real  HHMM  or  a  recorded
        am / pmN  day-marker)  keeps  it  --  those  are  the
        real  identifiers  and  never  collide  in  practice;
      -  the  first  bare-date  entry  of  a  day  keeps  the  bare
        date  as  its  identifier  (date  alone  is  unique  then);
      -  later  bare-date  entries  of  the  same  day  (the
        archive  era  recorded  no  wall-clock  times  on
        multi-entry  days)  are  given  the  deterministic
        sequence  tokens  s2,  s3,  ...  counting  the  bare-date
        entries  of  that  day  in  log  order  (token  s1  is  the
        bare  date  itself).  These  are  order  markers,  NOT
        wall-clock  times;  entries  written  from  the  migration
        onward  always  carry  a  real  HHMM  time  instead.
    Returns  the  list  of  assignments  made."""
    import os as _os
    counts = {}
    made = []
    for e in entries:
        if e["n"] == 0:
            e["time"] = e.get("time", "")
            continue
        d = e["date"] or "undated"
        if not e.get("time"):
            counts[d] = counts.get(d, 0) + 1
            if counts[d] >= 2:
                e["time"] = "s%d" % counts[d]
        # persist  (schema  keys  only,  not  the  working  "file")
        f = e.get("file")
        if f:
            p = _os.path.join(ENT, f)
            with open(p, "w") as fh:
                json.dump({k: e[k] for k in ("n", "date", "time",
                                              "title", "body")},
                          fh, indent=1, ensure_ascii=False)
        # rename  if  the  time  changed  the  slug
        if e.get("file") and e["n"] > 0:
            newf = slug(e["n"], e["date"], e["time"], e["title"])
            oldp = _os.path.join(ENT, e["file"])
            newp = _os.path.join(ENT, newf)
            if newf != e["file"] and _os.path.exists(oldp):
                _os.replace(oldp, newp)
                made.append((e["n"], ident(e["date"], e["time"]), e["title"][:50]))
            e["file"] = newf
    return made


def gen_html(entries):
    data = [{"n": e["n"], "date": e["date"], "time": e["time"],
             "title": e["title"], "body": e["body"]} for e in entries]
    payload = json.dumps(data, ensure_ascii=False).replace(
        "</script", "<\\/script")
    html = HTML_TEMPLATE.replace("__PAYLOAD__", payload)
    with open(HTML, "w") as fh:
        fh.write(html)


HTML_TEMPLATE = r"""<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>rh-missing-tail -- the discovery log</title>
<style>
:root { color-scheme: dark; }
body { margin: 0; background: #0d1117; color: #d8dee9;
  font: 15px/1.5 ui-monospace, "Cascadia Mono", Menlo, Consolas, monospace; }
header { position: sticky; top: 0; background: #161b22ee;
  padding: 10px 14px; border-bottom: 1px solid #30363d; z-index: 5; }
h1 { font-size: 15px; margin: 0 0 8px; color: #58a6ff; }
h1 small { color: #8b949e; font-weight: normal; }
.row { display: flex; gap: 8px; flex-wrap: wrap; align-items: center; }
input, select, button { background: #0d1117; color: #d8dee9;
  border: 1px solid #30363d; border-radius: 6px; padding: 6px 8px;
  font: inherit; }
input:focus { outline: 1px solid #58a6ff; }
#q { flex: 1 1 220px; min-width: 160px; }
.stat { color: #8b949e; font-size: 12px; margin-left: auto; }
main { max-width: 980px; margin: 0 auto; padding: 10px 14px 60px; }
.entry { border: 1px solid #30363d; border-radius: 8px; margin: 10px 0;
  overflow: hidden; }
.entry .hd { display: flex; gap: 10px; padding: 9px 12px; cursor: pointer;
  background: #161b22; }
.entry .hd:hover { background: #1c2330; }
.entry .dt { color: #58a6ff; min-width: 84px; font-size: 13px; }
.entry .tm { color: #8b949e; font-size: 13px; white-space: nowrap; }
.entry .tt { font-weight: 600; }
.entry .bd { display: none; padding: 12px 14px; border-top: 1px solid
  #30363d; white-space: pre-wrap; word-wrap: break-word; max-height: 60vh;
  overflow: auto; background: #0d1117; }
.entry.open .bd { display: block; }
.mark { background: #e3b34133; color: #ffd866; border-radius: 2px; }
code { background: #1c2330; padding: 1px 4px; border-radius: 4px;
  color: #7ee787; }
pre { background: #161b22; border: 1px solid #30363d; border-radius: 6px;
  padding: 8px; overflow: auto; }
pre code { background: none; padding: 0; color: inherit; }
a { color: #58a6ff; }
button.small { padding: 2px 8px; font-size: 12px; }
#topbar { position: fixed; bottom: 14px; right: 14px; }
#topbar button { border-radius: 50px; }
</style>
</head>
<body>
<header>
  <h1>rh-missing-tail -- the discovery log
      <small>source  of  truth:  entries/  (one  JSON  per
      entry);  generated  view</small></h1>
  <div class="row">
    <input id="q" type="search" placeholder="search  title  +  body  ( / )">
    <input id="d1" type="date" title="from date">
    <input id="d2" type="date" title="to date">
    <select id="ord">
      <option value="desc">newest first</option>
      <option value="asc">oldest first</option>
    </select>
    <button id="ex" class="small">expand all</button>
    <button id="co" class="small">collapse all</button>
    <span class="stat" id="stat"></span>
  </div>
</header>
<main id="list"></main>
<div id="topbar"><button onclick="window.scrollTo({top:0,behavior:'smooth'})">top</button></div>
<script id="data" type="application/json">__PAYLOAD__</script>
<script>
const E = JSON.parse(document.getElementById("data").textContent);
const $ = id => document.getElementById(id);
const esc = s => s.replace(/&/g,"&amp;").replace(/</g,"&lt;")
                 .replace(/>/g,"&gt;").replace(/"/g,"&quot;");
function md(src) {  // the  log's  markdown-lite,  html-safe
  const out = [];
  let pre = false;
  for (const line of src.split("\n")) {
    if (/^```/.test(line)) {
      out.push(pre ? "</pre>" : "<pre>");
      pre = !pre;
      continue;
    }
    if (pre) { out.push(esc(line)); continue; }
    let t = esc(line);
    t = t.replace(/`([^`]+)`/g, "<code>$1</code>");
    t = t.replace(/\*\*([^*]+)\*\*/g, "<b>$1</b>");
    t = t.replace(/\*([^*]+)\*/g, "<i>$1</i>");
    t = t.replace(/\[([^\]]+)\]\(([^)]+)\)/g,
      '<a href="$2" target="_blank" rel="noopener">$1</a>');
    out.push(t);
  }
  if (pre) out.push("</pre>");
  return out.join("\n");
}
function hl(t, q) {
  if (!q) return t;
  const eq = q.replace(/[.*+?^${}()|[\]\\]/g, "\\$&");
  return t.replace(new RegExp(eq, "gi"), m => '<span class="mark">' + m + "</span>");
}
let openSet = new Set();
function render() {
  const q = $("q").value.trim();
  const d1 = $("d1").value, d2 = $("d2").value;
  const ord = $("ord").value;
  const rows = E
    .filter(e =>
      (d1 || !e.date || e.date >= d1) &&
      (d2 || !e.date || e.date <= d2) &&
      (!q || (e.title + " " + e.body).toLowerCase().includes(q.toLowerCase())))
    .sort((a, b) => ord === "desc" ? (b.n - a.n) || b.date.localeCompare(a.date)
                                   : (a.n - b.n));
  const list = $("list");
  list.innerHTML = "";
  for (const e of rows) {
    const div = document.createElement("div");
    div.className = "entry" + (openSet.has(e.n) ? " open" : "");
    const hd = document.createElement("div");
    hd.className = "hd";
    hd.innerHTML =
      '<span class="dt">' + (e.date || "n.d.") + "</span>" +
      '<span class="tm">' + (e.time ? (e.time) : "") + "</span>" +
      '<span class="tt">' + hl(esc(e.title), q) + "</span>";
    hd.onclick = () => {
      if (openSet.has(e.n)) openSet.delete(e.n); else openSet.add(e.n);
      div.classList.toggle("open");
    };
    const bd = document.createElement("div");
    bd.className = "bd";
    bd.innerHTML = md(e.body);
    div.appendChild(hd); div.appendChild(bd);
    list.appendChild(div);
  }
  $("stat").textContent =
    rows.length + " of " + E.length + " entries" +
    (!q && !d1 && !d2 ? "" : " (filtered)");
}
["q","d1","d2","ord"].forEach(id => $(id).addEventListener("input", render));
$("ex").onclick = () => { E.forEach(e => openSet.add(e.n)); render(); };
$("co").onclick = () => { openSet.clear(); render(); };
window.addEventListener("keydown", ev => {
  if (ev.key === "/" && document.activeElement !== $("q")) {
    ev.preventDefault(); $("q").focus();
  }
  if (ev.key === "Escape") { $("q").value = ""; render(); }
});
render();
</script>
</body>
</html>
"""


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--migrate", action="store_true",
                    help="parse  the  frozen  log  into  the  entry  "
                         "JSONs  (migrated  range  only)")
    a = ap.parse_args()
    if a.migrate:
        with open(MD) as fh:
            lines = fh.read().split("\n")
        fresh = migrate(lines)
        # assign  the  bare-date  s-tokens  BEFORE  the  files
        # are  written  (no  rename  churn):  fresh  entries
        # have  no  "file"  key,  so  assignment  only  sets
        # times
        assign_idents(fresh)
        os.makedirs(ENT, exist_ok=True)
        # NOTE:  fresh  contains  ONLY  the  log's  entries  (the
        # log  is  frozen)  so  hand-written  later  entries  are
        # never  touched.
        # Stale  migrated  files  from  an  earlier  parse  of  a
        # different  (repaired)  log  are  removed  first  --
        # only  files  that  are  NOT  reproduced  now  get  a
        # check:  every  current  fresh  slug  is  written;
        # leftover  files  whose  n  is  in  the  fresh  range
        # are  stale.
        fresh_n = {e["n"] for e in fresh}
        for f in os.listdir(ENT):
            if not f.endswith(".json"):
                continue
            m = re.match(r"^(\d{4})-", f)
            if m and int(m.group(1)) in fresh_n:
                os.remove(os.path.join(ENT, f))
        wrote = 0
        for e in fresh:
            f = "0000-intro.json" if e["n"] == 0 else \
                slug(e["n"], e["date"], e["time"], e["title"])
            with open(os.path.join(ENT, f), "w") as fh:
                json.dump(e, fh, indent=1, ensure_ascii=False)
            wrote += 1
        print("migrated  %d  entries  from  the  frozen  log  "
              "(%d  written)" % (len(fresh), wrote))
    entries = load_entries()
    made = assign_idents(entries)
    if made:
        for n, k, t in made:
            print("IDENT  n=%d  ->  %s   (%s...)" % (n, k, t))
    else:
        print("identifiers  unique  (no  renames)")
    gen_html(entries)
    print("wrote  %s  (%d  entries)  --  the  entries/  "
          "directory  is  the  source  of  truth" % (HTML, len(entries)))


if __name__ == "__main__":
    sys.exit(main())
