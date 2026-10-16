# cards/ -- one card per .lean, readable in ONE session

The set in this directory is the whole Lean-work memory, written
to be read in a single fresh-memory session (after compaction or
a new clone) and then reasoned over:  what to keep for the next
go-round.  Budget:  <= ~500 lines total,  72 chars/line,  cards
are the HERE-AND-NOW  --  history lives in git,  not here.

Layout
  <Module>.md   one card per formal/RhAttack/<Module>.lean
                (84 cards;  regenerated,  do not hand-edit)
  _MAP.md       the composition map (read this first)
  README.md     this file

Card format (5 lines,  wrapped at 72)
  # Module.lean  (line count)
  WHAT:   its one role in the proof architecture
  HOW:    the load-bearing definitions / theorems (by name)
  USES:   who imports it (terminal = consumed by the program)
  GOTCHA: the toolchain / API trap that bit us (only if one)

Ground rules
  - a card states only what is TRUE in the current tree
    (sorry-free,  gated);  if a file's role changes,  its card
    changes in the same commit.
  - USES lines are the import map  (regenerate,  do not guess).
  - the pinned toolchain is Lean 4.33.1 / mathlib v4.33.1;
    "ported" cards are ports of anthropics/formal-math
    (Apache-2.0,  commit e1a4e6508154) rebased here.
  - legacy:  formal/RhAttack.lean (root) and formal/rh-lean/
    (the early prototype tree) are NOT carded  --  do not
    extend them;  the RhAttack/ package is live.

Regeneration
  The cards are generated from the hand-kept dataset in
  scripts/rh/make_lean_cards.py (WHAT/HOW/USES/GOTCHA per module;  the
  line counts and file list come from the live tree).  After a
  milestone:
    1. edit the dataset to match the new reality
    2. python scripts/rh/make_lean_cards.py      (rewrites the cards)
    3. the card diff IS the documentation update for the commit

Bootstrap protocol (fresh session,  post-compaction)
  1. read _MAP.md
  2. read the spine cards (listed at the bottom of _MAP)
  3. read any other cards the current task names
  4. reason:  which cards are still load-bearing for THIS task
  5. do not re-derive what a card already settles
