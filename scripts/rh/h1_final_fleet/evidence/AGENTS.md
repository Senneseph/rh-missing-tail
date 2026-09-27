# Agent working rules (owner-mandated, 2026-09-25)

## Communication
- Lead with the ANSWER: exact, 1-2 plain sentences. Supporting detail after.
- **All times to the owner use the 5900X local zone (America/New_York, e.g. EDT). Never report UTC** unless the owner asks. Boxes log in their own zones/UTC; convert before reporting (UTC-4 in EDT).
- Itemize. **Bold key words/phrases.** Don't overdecorate — no walls of
  bullets, dashes, or colons; plain sentences carry the substance.
- No long blocking operations: no multi-minute polling loops. Arm watches on
  the boxes themselves and report short plain updates.
- Qualified uncertainty is permitted and welcome for SUPPLEMENTAL statements
  (info not central to the main request, not a direct factor in the answer):
  qualify them — "I think", "can't quite remember", "I don't know right
  now, but I can find out". Exact recall beyond the certainty threshold is
  not worth the context burden; the owner will chase it if it matters.
  Central claims must be fetched or clearly flagged as not-yet-fetched —
  qualification is a signal, not a pass.

## Evidence before reasoning (owner doctrine)
Identify and FETCH the information that definitively answers the question
BEFORE designing any solution:
1. Ask "what information would definitively answer this?" — not "what is the
   problem?" and not "how do I fix it?"
2. Fetch it immediately (it takes seconds), without yet reasoning about the
   full solution.
3. The fetched data either supports ~3 seconds of reasoning into the answer,
   or it points at the next source: "which file or resource narrows this
   further?" / "the information didn't tell me what was wrong — who do I ask
   next?" Keep walking the chain.
4. Only once the chain ends in a real root cause (RCA) do you reason about
   addressing, creating, or changing anything.
Never design a fix or spec from a hypothesis that has not been fetched.

## Hard fleet rules
- No git commits or pushes from this repo, ever.
- Instance 51143332 (Ollama box) is never touched.
- No new rentals or spending without explicit owner approval.
- Docker tags: plain `vN` and `latest` only.
- Fleet status: run `scripts/rh/fleet_status.sh` and report its output; do
  not reconstruct status from memory.

## Fleet data rule (2026-09-25, after the 8-GPU staging incident)
- A fresh box is fed by SHIPPING the dataset from the newest staged box
  (`scripts/rh/h1-ship-data.sh`, ~1.5-2 h, idempotent, md5-verified).
  Self-stage from LMFDB is the FALLBACK only.
- The 8-GPU 4090 box (all 4 bands on its NVMe volume) is the standing
  shipping source; the 5900X (Pirana) is the second source of record.
