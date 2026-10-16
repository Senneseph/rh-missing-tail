# discovery/ -- the living chronicle (one JSON per entry)

The discovery log moved out of the giant root DISCOVERY_LOG.md
(frozen as an archive from its migration point) into this
directory:  the source of truth for the history is now
`entries/`,  one JSON file per entry,  and `DISCOVERY.html` is
the interactive view generated from them.

## Layout

```
entries/NNNN-YYYY-MM-DD-slug.json   one file per entry
index.json                          generated manifest
DISCOVERY.html                      generated interactive view
                                    (self-contained:  opens from a
                                    double-click,  no network,
                                    no dependencies)
```

## Entry schema

```json
{
  "n": 97,
  "date": "2026-10-16",
  "time": "pm1",
  "title": "short headline",
  "body": "markdown-lite body (the same style the old log used:
           **bold**, *italic*, `code`, fenced blocks, links)"
}
```

`n` is the chronological sequence number (intro scaffold = 0).
`time` is optional.  `date` is the only dated field in the whole
repo outside this directory  (the old single-file rule,  carried
over per file).

## Add-a-new-entry flow

1.  next number = (highest existing n) + 1
    (check with:  ls entries/ | tail -1)
2.  write  entries/NNNN-YYYY-MM-DD-slug.json
3.  run  python scripts/rh/discovery_sync.py
4.  commit  +  push

The HTML is generated content  --  never edit it by hand;  the
entry JSON is the source.  `scripts/rh/discovery_sync.py
--migrate` re-parses the frozen archive (idempotent for the
migrated range;  hand-written entries are never touched).

## What the view does

-  search over title + body  (press  /  to focus,  Esc to clear)
-  date-range filter,  newest/oldest sort
-  click an entry to expand its body;  expand/collapse all
-  everything client-side,  fully offline
