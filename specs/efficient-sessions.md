# Spec: efficient sessions (using tokens well)

Status: **draft for the user's review** (27 Oct 2026). Nothing here is built
yet. Builds after [playbook-releases.md](playbook-releases.md), so it ships
as a tested release, not straight to every project.

## Goal
Get the same quality of work for fewer tokens, with guidance that stays true
when prices, models and context windows change. The playbook's own overhead
(rules, hooks, housekeeping) must cost less than it saves.

## What a week of real use showed (27 Oct 2026)
A review of one week of cloud sessions across four projects. Costs are the
logs' own list-price estimates, used here only to compare sessions.
- **Two long sessions used 64% of the week.** In the biggest, every message
  re-read about 500,000 tokens of context; a fresh session starts at about
  60,000–75,000. Late messages in it cost about 7× a fresh session's.
- **Sessions about the playbook itself: about 13%.** Six sessions, four of
  them in parallel on one night, editing the same repos.
- **The playbook's fixed load is small:** about 5,000–7,000 tokens per
  session start (rules file about 3,200, project CLAUDE.md 1,000–2,000, the
  session-start output about 1,000, plus about 1,000 per catch-up still due).
  That's about 5% of a typical message, re-read on every one.
- **Its behaviour costs more than its size:**
  - turns spent only on housekeeping, such as pushing a session branch to
    match main, or re-running a stalled check;
  - background tasks waking an idle session just to say "nothing to do";
  - the end-of-reply check blocking a reply, which forces another full turn;
  - the full five-part summary on every reply, which is re-read on every
    later message.
- **What worked:** handover docs let new sessions start small, and sessions
  offered starter prompts. The cost came from not taking them.

## Why the guidance must be durable
The 26 Oct decision dropped message counts and percentages of the context
window, because those go stale. That holds. But relevance alone didn't stop
a 500,000-token session. The durable measure is the **ratio of the current
context to a fresh session's**: what each message costs compared with
starting again. It doesn't depend on the price list or the window size. Any
absolute figures (cache lifetime, prices, defaults) live in **one assumptions
table** with a source and a date, never in the rules.

## The parts

### 1. A new rules section, "Using tokens well" (replaces "Coaching")
In `shared/ai-dev-rules.md`. About 25 lines, AI-facing, drafted below.
Detail goes in a new `reference/efficient-sessions.md` (part 4).

```markdown
## Using tokens well
Every model request re-sends the whole context: rules, conversation, every
file read and command output. Cost is roughly context size × requests, and
each tool call is a request. A bigger context window raises the ceiling,
not the price. Cached re-reads are cheaper, but after a break the cache
expires and the next message pays full price for everything. Never trade
correctness for tokens: a check that catches a mistake is cheaper than rework.
- **Keep the context to what this task needs.** Search, don't read whole
  files or logs; cap command output (`| tail -40`, quiet flags); write long
  output to a file and grep it; send wide searches to a subagent that
  returns a short summary.
- **One piece of work per session.** When the work changes, or the hook
  prints `COST:`, at the next natural break save state (the step's spec or
  STATUS.md) and give a starter prompt, with one line on why ("each message
  now costs about 4× a fresh session's"). Stay if the history is still
  needed; say so.
- **Fewer turns.** Finish the agreed step in one go. Ask questions together,
  each with a default. Stop background servers and watchers before the last
  reply: each wake-up re-reads the whole session.
- **Replies as short as the reader needs.** A small change gets two or three
  lines; the full summary shape is for a finished step. A reply is paid for
  again on every later message.
- **Every starter prompt names a model.** Planning, design, debugging,
  unclear problems: the strongest model. Mechanical work against a clear
  spec (rewording, renames, catch-ups, applying an agreed change): a cheaper
  one. Subagents that search or collect: the cheapest. Effort: the default,
  higher only for subtle bugs.
- **Research and subagents get a budget**: how many searches or sources, and
  how long the summary back.
- **Coach the user, unasked, one line each ("Tip:")**: several unrelated
  topics in one message (do one, starter prompts for the rest); the same
  problem corrected twice (a fresh session with a better prompt); a vague
  request (suggest a narrower one); no way to check the work (suggest a
  test first). Don't repeat a tip the user declined this session.
A starter prompt names the repo, the goal, what to read first (CLAUDE.md,
docs/STATUS.md), what's out of scope, how to check it's done, and the model,
in a code block. Detail: playbook `reference/efficient-sessions.md`.
```

### 2. A cost hook that measures, not counts
Replace the message counter in `session.sh busy` (the hook that runs on each
user message; keep the command name so existing settings still work).
- Read the transcript Claude Code passes in (`transcript_path`). Take the
  token usage of the first and the latest main-conversation request (skip
  subagent entries, `isSidechain`). Context = input + cache read + cache
  write tokens. Checked against a real transcript on 27 Oct: the fields are
  there.
- **Ratio = latest ÷ first.** Print `COST: each message now re-reads about
  <N>k tokens, about <R>× a fresh session's.` once when the ratio passes
  `COST_NOTE` (3), and again past `COST_FIRM` (6). Silent otherwise.
- **Cold cache:** if the last request was more than `CACHE_MINUTES` (55) ago
  and the ratio is above 2, print `COST: the cache has likely expired; this
  message re-processes about <N>k tokens at full price.` A natural moment to
  start fresh.
- The three numbers sit at the top of `session.sh`, each with a comment
  pointing at the assumptions table. Needs `python3`; without it, silent.

### 3. Quieter housekeeping
- **The end-of-reply check blocks only for lost work** (cloud: uncommitted
  or unpushed). Docs checks move to the moment of landing: a `PreToolUse`
  hook on `git push` to `main` refuses the push until STATUS.md (and SPEC.md
  if `specs/` changed) is part of what's being pushed. Claude is mid-turn
  then, so no extra turn is spent. (Needs a new hook in
  `templates/.claude/settings.json`; `setup.txt` adds it everywhere.)
- **Once work is on main, the session's own branch doesn't need to match.**
  Add one line to the git rules, so no turn is spent syncing it.
- **Catch-ups print one line each** (id and title), not the whole entry.
  Claude reads the entry from the playbook when applying it.
- **Session-start output stays short.** Target under about 1,500 characters
  without catch-ups. A test enforces it (see the releases spec).
- **Mac reminders stay as they are** (no extra turn: they're shown to the
  user, not to Claude).

### 4. `reference/efficient-sessions.md` (read on demand)
Replaces section 6 of `reference/understanding-and-quality.md`.
- How cost works, in plain words, with the dated assumptions table:

  | Assumption | Value | Source | Checked |
  |---|---|---|---|
  | Prompt cache lifetime | about 1 hour on a plan; about 5 minutes on API key or usage credits | Claude Code docs, best practices | 27 Oct 2026 |
  | Context window | 1M on most current models; compaction near the top | same | 27 Oct 2026 |
  | `/clear` | free; `/compact` reads the whole conversation (costly when long) | Claude Code docs, costs | 27 Oct 2026 |
  | Default effort | medium on the 5.5 models | best practices | 27 Oct 2026 |
  | Relative price | strongest model > mid > small; output and thinking cost more than input; cache reads far less than new input | `/model` picker shows current prices | 27 Oct 2026 |

- Habits with the reason for each (from the rules section, expanded).
- **Phone (cloud) sessions:** can't `/clear` the same way; a new session is
  the reset. Pick the model when starting it.
- **The monthly review** (part 5), step by step.
- When an assumption changes: update the table and the hook's numbers, then
  check whether any habit needs to change. The rules don't hold numbers, so
  they rarely need to.

### 5. A monthly usage review
A short recipe in the reference file, run in a fresh session on a cheap
model:
- Cloud: list the month's sessions; read each one's final `result` event
  (`total_cost_usd`, the first request's input tokens, and the turn count).
- Mac: `/usage` (breakdown and recommendations) and `/insights`.
- Rank the costliest sessions and look for patterns. Check the assumptions
  table against the docs.
- Output: up to three playbook ideas, filed as issues (see the releases
  spec), and a one-paragraph note to the user. No changes made in that
  session.

### 6. Trim `shared/ai-dev-rules.md` to 150 lines or fewer
It's about 197 lines now. Every line is re-read in every message of every
session, so each must earn its place.
- Move the detail of "Public repos", the git and branch handover and
  "Keeping the playbook current" into `reference/`, keeping one or two
  trigger lines each in the rules.
- Owner-specific lines move to the owner file
  ([shareable-playbook.md](shareable-playbook.md)).
- Merge "Each feature" and "Keeping the docs true" where they repeat.
- Before and after: list every rule, so none is lost (in the commit message
  or a table in this spec's Progress section).
- A test enforces the limit (releases spec).

## Out of scope
- Changing what any rule asks for, other than the wording above.
- Per-project changes: projects get these through the sync and setup.txt.
- Automatic model switching. Claude can't switch its own model mid-session;
  it can only recommend one in starter prompts.

## How we'll know it's done
- Tests (releases spec) pass on Linux and macOS:
  - the cost hook prints at the right ratios and is silent otherwise;
  - a push to main without STATUS.md is refused, and with it allowed;
  - the end-of-reply check blocks only for lost work;
  - the rules file is 150 lines or fewer;
  - the session-start output is within budget.
- The canary project runs a week on the new release with no stuck sessions.
- **The first monthly review after release** compares against this week's
  figures: share of usage in sessions above 3×, housekeeping-only turns,
  and playbook-meta sessions. All three should fall. If not, revisit.

## Decisions for the user
1. **Ratios 3× and 6×** for the cost notes, and 55 minutes for "cache
   cold". Recommended as a start; the monthly review tunes them.
2. **Moving the docs check from end-of-reply to push-to-main.** Recommended.
   Docs are still checked before work lands, without the extra turn.
3. **Short replies for small changes**, with the five-part summary only for
   finished steps. Recommended. You'd see shorter answers to quick asks.

## Progress
- 27 Oct 2026: spec drafted; usage data and the hook's transcript fields
  checked in the session that wrote it.
