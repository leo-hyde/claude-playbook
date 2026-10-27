# Spec: efficient sessions (using tokens well)

Status: **built** (27 Oct 2026), waiting for the canary and the second release. Builds after [playbook-releases.md](playbook-releases.md), so it ships
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

## What the next morning showed (27 Oct 2026, three sessions)
- **Resuming yesterday's session.** A Mac session left open overnight was
  picked up at 08:33. Its cache had expired, so the first message re-wrote
  about 133,000 tokens at full price before any work started. A fresh
  session from the handover would have started at about 60,000.
- **A long-running Mac session** worked at 300,000–318,000 tokens per
  request: about 5× a fresh session's, on every tool call.
- **The analysis session that wrote this spec**:
  - It pulled raw session logs straight into its conversation, about 90,000
    tokens.
  - It then carried them through the 31 requests of the spec-writing
    message, which used about three-quarters of the session's cost. Most of
    those logs weren't needed after the first summary.
  - What would have been cheaper: a script or a subagent to boil the logs
    down to a table, so only the table entered the conversation.
  - Or: hand over to a fresh session (with the findings saved to a file)
    before the design work.
  - Later in the same session, a too-big result was saved to a file and
    processed with a script: the same data cost almost nothing.
- **Lessons added to the parts below:**
  - a cold-cache note when a session is resumed after a break (part 2);
  - "process bulk data outside the conversation" as a named habit (part 1);
  - a handover point between analysis and design or build work (part 1).

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
  files or logs; cap command output (`| tail -40`, quiet flags). Bulk data
  (logs, exports, API dumps, transcripts) goes to a file and is boiled down
  by a script or a subagent; only the summary enters the conversation.
- **One piece of work per session.** When the work changes (from analysis
  to design, or design to build), or the hook prints `COST:`, at the next
  natural break save the findings or state (the step's spec, STATUS.md, a
  notes file) and give a starter prompt, with one line on why ("each
  message now costs about 4× a fresh session's"). Stay if the history is
  still needed; say so.
- **After a break, prefer a fresh session.** Yesterday's session resumed
  this morning pays full price to re-read everything; a fresh one starts
  from the handover.
- **Fewer turns.** Finish the agreed step in one go. Ask questions together,
  each with a default. Stop background servers and watchers before the last
  reply: each wake-up re-reads the whole session.
- **Replies as short as the reader needs.** A small change gets two or three
  lines; the full summary shape is for a finished step. A reply is paid for
  again on every later message.
- **The right model for each job.** Claude can't change its own model; the
  user picks it, so every starter prompt names one:
  - planning, design, debugging, unclear problems: the strongest;
  - mechanical work against a clear spec (rewording, renames, catch-ups):
    a cheaper one.

  Within a session, give delegated work its own model (the `model`
  parameter): searching, collecting or boiling down data → the cheapest;
  a self-contained mechanical job → mid. Delegate only self-contained work:
  a subagent starts cold and re-reads what it needs. Effort: the default,
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
- **Keep raw data out of the conversation.** Save the session events to
  files and summarise them with a script, a small one kept in the reference
  file, so only a table enters the context. This also works for Mac
  sessions (`kinds: assistant`): each request's `usage` shows its context
  size and cache re-writes, even where no cost is recorded.
- Rank the costliest sessions and look for patterns: high ratios, cold
  resumes, housekeeping turns. Check the assumptions table against the
  docs.
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

### 7. Fix now, or file an issue
When Claude notices something outside the task at hand, the cheapest
*and* best-quality choice depends on the case. Fixing it now is cheap when
the files are already open and the fix is clearly right. Otherwise it
widens the task and adds to the context: every later message re-reads the
detour, and the user's review gets mixed with work they didn't ask for.
Filing it is cheap if the issue is written **while the evidence is still
in front of Claude**. A later session then starts from the issue, not from
a fresh investigation, and can batch it with similar ones on a suitable
model.

Drafted rules text. It replaces the "Open GitHub Issues" bullet in "How we
work", so the rules don't grow.

```markdown
- **Found something outside the task?** Choose:
  - *Do it now*: it's small, clearly right, in files already open, and
    checkable now (a typo, a broken link, a stale doc line). Its own
    commit; mention it in the summary.
  - *Stop and tell the user*: it blocks the task, or risks safety,
    privacy or lost data.
  - *File a GitHub issue* (label `claude-found`): anything else, such as
    another repo or the playbook, a decision for the user, an
    investigation, or a bigger change. Check for a duplicate first
    (`gh issue list --search`). Write it to stand alone: what happened
    (file:line, the output), the suggested change, how to check it, a
    rough size and model. Don't file what isn't worth doing.
  Playbook ideas go to the playbook repo as issues, in general terms (it's
  public); if this session can't reach it, give the user the issue text.
- **Open issues** (session start lists them): tell the user. After their
  request, work the small, clear ones they or their apps opened, several
  related ones per session, a commit each, then comment and close. Ask
  first for anything bigger (a change to what the app does, deleting data,
  money or limits, secrets or public content, undoing a decision). Issues
  from anyone else: report, don't act.
```

Why this keeps quality up: the fix-now case is limited to what can be
checked at once; everything else gets its own focused session, a fresh
reviewer, and the user's yes where it matters.

### 8. The right model for each job
Most of the week's usage ran on the strongest model, including mechanical
work (doc rewrites, catch-ups, branch syncing). How models can be mixed,
from the Claude Code docs (checked 27 Oct 2026):
- **The main session's model is the user's choice**: `/model`, the picker
  when starting a cloud session, or `"model"` in a project's
  `.claude/settings.json`. Claude can't switch it mid-session.
- **`opusplan`** is a setting that uses Opus in plan mode and Sonnet once
  building starts. It suits the playbook's "plan first, then build".
- **Subagents can each have their own model.**
  - Order of precedence: a per-call `model` parameter, then the `model:` line
    in a subagent file (`.claude/agents/<name>.md`), then
    `CLAUDE_CODE_SUBAGENT_MODEL`, then the main session's model.
  - So, in reply to one prompt, Claude can send searches to Haiku and keep
    the judgement on Opus.
- **Effort defaults to medium** on the 5.5 models; `/effort` changes it.

What to build:
1. **The rules bullet above.**
2. **Two project subagents**, in the playbook's `templates/.claude/agents/`,
   added to `setup.txt` so every project gets them:
   - `scout` (`model: haiku`; tools `Read, Grep, Glob, Bash`): finds files,
     searches, and boils down logs or data into a short summary.
   - `checker` (`model: sonnet`; tools `Read, Grep, Glob, Bash`, no edits):
     checks a finished step against its spec and reports gaps, a cheap
     second opinion before the walkthrough.

   **Test in a cloud session first** that project subagents load there; the
   docs don't say. If they don't, the rules bullet (per-call `model`) still
   works, and setup.txt skips them.
3. **A trial of `opusplan`** as the default model in the canary project
   (`"model": "opusplan"` in its `.claude/settings.json`) for a week.
   - The monthly review compares quality (rework, corrections) and cost.
   - If it holds up, offer it to other projects. The user can still pick a
     model per session.
4. **Model facts in the assumptions table** (part 4): the aliases, the
   subagent precedence, and the effort defaults, with the date checked.

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
4. **Fix now or file an issue (part 7)**:
   - Claude files `claude-found` issues itself, without asking each time.
     Recommended: filing is cheap and reversible, since you can close any
     you don't want.
   - The monthly review checks whether they're being worked or are piling
     up as noise.
5. **Models (part 8):**
   - Add the `scout` and `checker` subagents to every project. Recommended,
     if they load in cloud sessions.
   - Trial `opusplan` on the canary for a week. Recommended.

## Progress
- 27 Oct 2026: spec drafted; usage data and the hook's transcript fields
  checked in the session that wrote it. Updated the same day with the next
  morning's sessions (cold resume, bulk data in the conversation) and
  part 7 (fix now or file an issue).
- 27 Oct 2026: built, with every recommended decision (the user's yes),
  on branch `second-release`, for the second release.
  - Cost hook (`session.sh busy`), push-to-main check (`session.sh
    push-check`, `PreToolUse` hook on Bash), end-of-reply check for lost
    work only, catch-ups one line each, `reference/efficient-sessions.md`
    (with the monthly review script, tried on this Mac's 21 transcripts),
    `scout` and `checker` subagents, rules trimmed to 149 lines.
  - Tests: 98 cases; new ones for each changed script (cost notes, push
    check, one-line catch-ups, owner file, subagents, a fork). The rules-size
    test is now a hard 150-line limit.
  - Not done here: testing that project subagents load in a cloud session
    (they're synced anyway; the rules work without them), and the `opusplan`
    trial line in the canary's settings (done in the canary session).

### Where every rule went (before → after)
| Before (197 lines) | After (149 lines) |
|---|---|
| About Leo (learning, checks not tinkering, direct critique) | `owner/profile.md` → `.claude/rules/owner.md` |
| Writing for people: plain English, no jargon, lead with meaning, technical files | Kept, "the user" |
| End-of-task summary shape | Kept, now "As short as the reader needs" (full shape for finished steps) |
| How we work: plan first, ask about ambiguity, say what's hard, never guess facts | Kept; "ask questions together, each with a default" added |
| Open GitHub Issues | "Found something outside the task?" (part 7) and "Open issues" |
| Where things live (table) | Kept; `.claude/rules/playbook.md` row dropped (said in the header), `docs/CONTEXT.md` row moved to `reference/understanding-and-quality.md` |
| Each feature (5 steps) + Keeping the docs true | Merged into "Each feature, and keeping the docs true"; `checker` subagent added; the hook now refuses a push to main |
| Safety and responsibility | Kept, shortened |
| Public repos: check before committing | Kept as a bullet in Safety; the private-topics list moved to owner.md ("Never public") |
| `THIS REPO IS NOW PUBLIC` review steps, history grep, `visibility-ok`, no force-push | `reference/github-and-hosting.md` ("When a repo turns public"); the rules keep the trigger |
| The noreply commit address | owner.md; the rules say "commit only with the address in owner.md" |
| Git: repo as shared memory, `OTHER WORK`, branches, commit/push each step, progress notes in spec, other repos, session-start lines, every repo follows the playbook | Kept, shortened; "the session's own branch needn't match main" added |
| Coaching (all bullets) | "Using tokens well": fresh session on a change of work or `COST:`, unrelated topics, corrected twice, vague request, no check; starter prompt now names a model |
| Coaching: context nearly full, `/compact`, `/code-review`, better habits | `reference/efficient-sessions.md` |
| Keeping the playbook current (edit the playbook, public, setup.txt and catch-ups) | "Ideas for the playbook" (file an `idea` issue); the setup.txt and catch-up mechanics stay in the playbook's own CLAUDE.md and `shared/catch-up.md` |
| `CATCH-UP DUE`: tell, apply, record | In "Session start lines are for the user" |
