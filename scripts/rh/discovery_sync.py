#!/usr/bin/env python
"""discovery_sync -- the discovery log reorganization.

The chronicle (root DISCOVERY_LOG.md) was migrated once into JSON:
one file per entry under  docs/discovery/entries/.  After migration
the MD is FROZEN;  new entries are written as fresh JSON files into
that directory and this script regenerates:

  docs/discovery/index.json         machine manifest
  docs/discovery/DISCOVERY.html     the interactive view
                                    (self-contained:  the entries are
                                    embedded,  so it opens from a
                                    double-click / file:// with no
                                    network and no dependencies)

Add-a-new-entry flow:
  1.  next number  =  (highest existing n)  +  1
  2.  write  docs/discovery/entries/NNNN-YYYY-MM-DD-slug.json  with
      { "n": ..., "date": "...", "time": "", "title": "...",
        "body": "..." }
  3.  run  python scripts/rh/discovery_sync.py
  4.  commit  +  push  (the HTML is generated content;  the entry
      JSON is the source).

The  --migrate  flag  parses  the  frozen  DISCOVERY_LOG.md  and  re
writes  the  entry  files  for  the  migrated  range  (entries with
n  <=  the  highest  n  present  in  the  log;  hand-written  later
entries  survive  untouched).

Parser  notes  (two  generations  of  header  format  in  the  log):
  -  numbered  era:    "## 5.  Title  (2026-09-11)"
  -  dated  era:       "## 2026-10-15  (pm8c)  TITLE"
      wrapped  title  lines  (a  following  "## frag"  with  neither
      a  leading  number  nor  a  date)  are  folded  into  the  title.
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
IDX = os.path.join(ROOT, "docs", "discovery", "index.json")

DATE_HDR = re.compile(
    r"^## (\d{4}-\d{2}-\d{2})\s*(\((pm\d+[a-z]?|am\d+[a-z]?)\))?\s*(.*)$")
NUM_HDR = re.compile(r"^## (\d+)\.\s*(.*)$")
WRAP_HDR = re.compile(r"^## ")
TDATE = re.compile(r"\((\d{4}-\d{2}-\d{2})\)")


def is_hdr(line):
    return bool(DATE_HDR.match(line) or NUM_HDR.match(line))


def clean(bodylines):
    while bodylines and bodylines[-1].strip() in ("", "---"):
        bodylines.pop()
    return "\n".join(bodylines).strip()


def slug(n, date, title):
    s = re.sub(r"[^a-z0-9]+", "-", title.lower()).strip("-")[:44].rstrip("-")
    return "%04d-%s-%s.json" % (n, date or "0000-00-00", s or "entry")


def migrate(lines):
    """Parse the frozen log  ->  chronological entry list (intro = 0)."""
    entries = []
    i = 0
    # intro scaffold:  everything before the first entry header
    # (the numbered era starts at "## 5.";  1..4  are the scaffold)
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
            dm = TDATE.search(title)
            date = dm.group(1) if dm else ""
            if dm:
                title = (title[:dm.start()] + " " + title[dm.end():]).strip()
        i += 1
        # wrapped title (a following "## frag" without date/number)
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
            "title": "The chronicle: approach, pieces, "
                     "contradictions (intro scaffold)",
            "body": clean(intro)})
    for k, e in enumerate(entries):
        e["n"] = k            # file order  =  chronological order
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


def gen_index(entries):
    dates = [e["date"] for e in entries if e["date"]]
    os.makedirs(os.path.dirname(IDX), exist_ok=True)
    man = {
        "generated_from": "docs/discovery/entries/ "
                          "(frozen archive DISCOVERY_LOG.md, migrated)",
        "count": len(entries),
        "date_min": min(dates) if dates else "",
        "date_max": max(dates) if dates else "",
        "entries": [
            {"n": e["n"], "date": e["date"], "time": e["time"],
             "title": e["title"], "file": e.get("file", ""),
             "chars": len(e["body"])}
            for e in entries],
    }
    with open(IDX, "w") as fh:
        json.dump(man, fh, indent=1)
    return man


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
      <small>one JSON per entry (docs/discovery/entries);  generated view</small></h1>
  <div class="row">
    <input id="q" type="search" placeholder="search title + body  ( / )">
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
function md(src) {  // the log's markdown-lite,  html-safe
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
      '<span class="tm">' + (e.time ? "(" + e.time + ")" : "") + "</span>" +
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
                    help="parse the frozen log into the entry JSONs "
                         "(migrated range only)")
    a = ap.parse_args()
    if a.migrate:
        with open(MD) as fh:
            lines = fh.read().split("\n")
        fresh = migrate(lines)
        os.makedirs(ENT, exist_ok=True)
        # NOTE:  fresh  contains  ONLY  the  log's  entries  (the  log
        # is  frozen  at  migration)  so  hand-written  later  entries
        # (n  beyond  the  log's  range)  are  never  touched.
        wrote = 0
        for e in fresh:
            f = "0000-intro.json" if e["n"] == 0 else \
                slug(e["n"], e["date"], e["title"])
            with open(os.path.join(ENT, f), "w") as fh:
                json.dump(e, fh, indent=1, ensure_ascii=False)
            wrote += 1
        print("migrated %d entries from the frozen log "
              "(%d written)" % (len(fresh), wrote))
    entries = load_entries()
    gen_index(entries)
    gen_html(entries)
    print("wrote %s (%d entries)  and  %s" % (HTML, len(entries), IDX))


if __name__ == "__main__":
    sys.exit(main())
