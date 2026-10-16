# discovery/ -- the living chronicle (one JSON per entry)

`entries/`  IS  the  source  of  truth:  every  .json  file  in  it
is  a  valid,  well-formed  entry,  readable  straight  through
normal  git  /  GitHub  access  and  permissions.  There  is  no
index  or  manifest  file  --  the  directory  itself  is  the
enumeration.  The  root  DISCOVERY_LOG.md  (the  old  single  file)
is  FROZEN  as  the  archival  record  from  its  migration  point.

The  one  generated  artifact  is  `DISCOVERY.html`:  the
interactive  view  (search  title+body,  date-range  filter,
sort,  expand/collapse).  It  embeds  the  entries  at generation
time,  so  it  opens  from  a  double-click  /  `file://`  with
no  network  and  no  dependencies.  Never  edit  it  by  hand;
regenerate  it  with  the  sync  script.

## Entry  schema

    {
      "n": 79,
      "date": "2026-10-16",
      "time": "0148",
      "title": "short headline",
      "body": "markdown-lite body  (**bold**,  *italic*,
               `code`,  fenced  blocks,  links)"
    }

The  `n`  sequence  is  only  a  chronological  sort  key  (intro
scaffold  =  0);  it  is  the  filename  prefix  `NNNN-`  and  is
NOT  the  identifier.  Filenames  carry  the  identifier  after
the  prefix:  `NNNN-YYYY-MM-DD[THHMM|TsN]-slug.json`.

The  entry's  unique  identifier  is  its  real  date  +  time
(`date`,  `time`;  new  entries  use  24h  wall-clock  HHMM).
From  the  migration  onward  a  real  `time`  is  mandatory
whenever  the  date  already  appears  (the  identifier  must
be  unique);  the  sync  script  enforces  uniqueness.

Archive-era  note:  the  old  log  recorded  no  wall-clock
times  for  multi-entry  days.  Where  the  log  had  a
day-marker  (am / pm1..pmN)  it  is  kept  as  the  `time`
field;  remaining  bare-date  collisions  got  deterministic
sequence  tokens  `s2`,  `s3`,  ...  (counting  the  bare-date
entries  of  that  day  in  log  order,  where  `s1`  is  the
bare  date  itself).  Those  tokens  are  order  markers,  NOT
wall-clock  times  --  the  recorded  times  they  replace
live  in  the  entry  bodies  where  the  old  log  had  them
(e.g.  "~11:00  EDT").  No  new  entry  ever  takes  an
`s`-token;  it  always  carries  a  real  time.

## Add-a-new-entry  flow

1.  next  number  =  (highest  existing  n)  +  1
    (check  with:  ls  entries/  |  tail  -1)
2.  write  entries/NNNN-YYYY-MM-DD[THHMM]-slug.json
3.  run  python  scripts/rh/discovery_sync.py
4.  commit  +  push

`scripts/rh/discovery_sync.py  --migrate`  re-parses  the  frozen
archive  (idempotent  for  the  migrated  range;  hand-written
entries  are  never  touched).
