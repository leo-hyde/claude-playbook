# Efficient sessions: good work for fewer tokens

Read on demand. The every-session version is "Using tokens well" in
`shared/ai-dev-rules.md`; this file has the reasons, the numbers and the
monthly review. Why it exists: `specs/efficient-sessions.md`.

## How cost works
- **Every request re-sends the whole context**: the rules, CLAUDE.md, the
  conversation so far, and every file read and command output still in it.
  Each tool call is a request, so one reply can be many requests.
- **Cost is roughly context size × number of requests.** A session whose
  context has grown to 5× a fresh one's pays about 5× for every later
  request, even a tiny one.
- **Caching softens this, for a while.** Re-reading the same context soon
  after costs far less than reading it new. After a break longer than the
  cache lifetime, the next message pays full price for everything again.
- **A bigger context window raises the ceiling, not the price.** Filling it
  is allowed; it isn't free.
- **The durable measure is the ratio** of the current context to a fresh
  session's. It doesn't depend on prices or window sizes, so the rules use it
  and hold no numbers. The session script measures it from the transcript
  (`session.sh busy`) and prints `COST:` lines.

## The assumptions (check these, not the rules, when things change)

| Assumption | Value | Source | Checked |
|---|---|---|---|
| Prompt cache lifetime | about 1 hour on a plan; about 5 minutes on an API key or usage credits | Claude Code docs, best practices | 27 Oct 2026 |
| Context window | 1M tokens on most current models; compaction near the top | same | 27 Oct 2026 |
| `/clear` and `/compact` | `/clear` is free; `/compact` reads the whole conversation (costly when long) | Claude Code docs, costs | 27 Oct 2026 |
| Default effort | medium on the 5.5 models; `/effort` changes it | best practices | 27 Oct 2026 |
| Relative price | strongest model > mid > small; output and thinking cost more than input; cache reads far less than new input | the `/model` picker shows current prices | 27 Oct 2026 |
| Model aliases | `opus`, `sonnet`, `haiku`; `opusplan` = Opus in plan mode, Sonnet once building starts | Claude Code docs, model configuration | 27 Oct 2026 |
| Main session's model | the user's choice: `/model`, the cloud session picker, or `"model"` in `.claude/settings.json`. Claude can't switch it mid-session | same | 27 Oct 2026 |
| A subagent's model | per-call `model` parameter, then the `model:` line in `.claude/agents/<name>.md`, then `CLAUDE_CODE_SUBAGENT_MODEL`, then the main session's | Claude Code docs, subagents | 27 Oct 2026 |
| Transcript fields | `type: assistant` entries carry `message.usage` (input, cache read, cache write tokens), `isSidechain` (subagent) and `timestamp` | a real transcript | 27 Oct 2026 |

The session script's thresholds match this table: `COST_NOTE=3` and
`COST_FIRM=6` (the ratios for the two notes) and `CACHE_MINUTES=55` (just
under the plan's cache lifetime). **When an assumption changes**: update the
table and those numbers, then check whether any habit below needs to change.
The rules rarely do, as they hold no numbers.

## The habits, and why
- **Search, don't read whole files or logs; cap output.** Everything read
  stays in the context and is paid for on every later request.
- **Bulk data goes to a file and is boiled down outside the conversation**
  (a script, or the `scout` subagent). On 27 Oct, raw logs pulled into a
  conversation (about 90,000 tokens) were then carried through 31 requests;
  the same data processed by a script cost almost nothing.
- **One piece of work per session; hand over when the work changes.**
  Analysis, design and build need different context. Save the findings to a
  file (the spec, STATUS.md, notes), then start fresh with a starter prompt.
- **After a break, start fresh rather than resume.** A session resumed the
  next morning re-wrote about 133,000 tokens at full price before any work;
  a fresh one from the handover started at about 60,000.
- **Context nearly full?** Save the state to STATUS.md or the spec before the
  app compacts it: compaction summarises older messages and loses detail.
  For a long task, `/compact <what to keep>` at a natural break is cheaper
  than letting it happen mid-step.
- **After two failed corrections, restart** with a better prompt: a clean
  session with a better prompt almost always beats a long one full of
  corrections.
- **Give Claude a check it can run** (tests, a check script), so it doesn't
  loop guessing.
- **Fewer turns.** Ask questions together, each with a default; finish the
  agreed step in one go; stop background watchers before the last reply
  (each wake-up re-reads the whole session).
- **Short replies for small changes.** A reply is re-read on every later
  message; the five-part summary is for finished steps.
- **Keep CLAUDE.md lean** (under about 100 lines): for each line, "would
  removing this cause a mistake?"
- **A second opinion is cheap**: the `checker` subagent (a mid model, read
  only) before the walkthrough, or `/code-review` in a fresh session.

## Models
- **Starter prompts name a model**, because only the user can pick it:
  planning, design, debugging and unclear problems → the strongest;
  mechanical work against a clear spec (rewording, renames, catch-ups) →
  a cheaper one.
- **Subagents** (`templates/.claude/agents/`, synced into every project):
  - `scout` (Haiku; read and search only): finds files and facts, boils down
    logs and data into a short summary.
  - `checker` (Sonnet; read only): checks a finished step against its spec.
  - Any other delegated job can take a `model` per call. Subagents start
    cold and re-read what they need, so delegate only self-contained work,
    with a budget (searches, sources, summary length).
- **`opusplan`** suits "plan first, then build". On trial as the canary
  project's default from the second release; the monthly review compares
  rework and cost before it's offered elsewhere.

## Phone (cloud) sessions
- A new session is the reset: there's no `/clear` in the same way. Pick the
  model when starting it.
- Cloud sessions have no `~/.claude`: everything they need is in the repo
  (`.claude/rules/`, `.claude/agents/`, CLAUDE.md).

## A retrospective after a long piece of work
When something took more than about three rounds of the user's feedback, or
the user felt it dragged, look back once, in a fresh session, before the next
similar job. Session records show what memory and commits don't.
1. **Collect:** the session transcripts (Mac: `~/.claude/projects/*/*.jsonl`;
   boil them down with the `scout` subagent or a script, not by reading them
   whole) and the git log of the documents or code involved.
2. **Find:** the order things actually happened in; where the turns and the
   user's time went (rough shares, marked as estimates); every correction the
   user made, with a short quote and time; points raised twice; manual steps
   Claude proposed; what was added and later cut.
3. **Say what can't be seen:** phone and cloud sessions leave no transcript on
   the Mac; commit times aren't work times.
4. **Output:** a short file in the project (`docs/retrospective-<topic>.md`),
   and changes to the method or rules it points to, offered to the user
   (playbook lessons in general terms, as `idea` issues or with their yes).

## The monthly review
Once a month, in a fresh session on a cheap model, in the playbook repo.
1. **Collect, outside the conversation.**
   - Mac: the session transcripts are in `~/.claude/projects/*/*.jsonl`.
     Also look at `/usage` (breakdown and recommendations) and `/insights`.
   - Cloud: list the month's sessions and save each one's events to files.
     Each request's `usage` is in its `assistant` events; the final `result`
     event has `total_cost_usd` and the turn count.
2. **Summarise with the script below**, so only a table enters the
   conversation:
   `python3 summarise.py ~/.claude/projects/*/*.jsonl | sort -t'|' -k6 -rn | head -20`
3. **Look for patterns** in the costliest sessions: high ratios, cold
   resumes, housekeeping-only turns, playbook sessions. Compare with the last
   review (27 Oct 2026 baseline: two long sessions used 64% of a week;
   playbook sessions about 13%).
4. **Check the assumptions table** against the docs; update dates.
5. **Output**: up to three ideas, filed as `idea` issues on the playbook
   repo, and a one-paragraph note to the user. No other changes in that
   session.

```python
# summarise.py: one line per transcript. Columns: file | requests | first k |
# peak k | ratio | context-weighted k (sum of every request's context: the cost driver) |
# cold resumes (a gap over 55 minutes with the context over 2x a fresh one's)
import calendar, json, sys, time
for path in sys.argv[1:]:
    first, peak, total, n, cold, prev = 0, 0, 0, 0, 0, None
    for line in open(path, errors="replace"):
        if '"assistant"' not in line:
            continue
        try:
            e = json.loads(line)
        except ValueError:
            continue
        if e.get("type") != "assistant" or e.get("isSidechain"):
            continue
        u = (e.get("message") or {}).get("usage") or {}
        c = sum(u.get(k) or 0 for k in ("input_tokens", "cache_read_input_tokens", "cache_creation_input_tokens"))
        if not c:
            continue
        try:
            t = calendar.timegm(time.strptime(e.get("timestamp", "")[:19], "%Y-%m-%dT%H:%M:%S"))
        except ValueError:
            t = None
        first = first or c
        if prev and t and t - prev > 55 * 60 and c > 2 * first:
            cold += 1
        prev, peak, total, n = t or prev, max(peak, c), total + c, n + 1
    if n:
        print(f"{path.split('/')[-1][:12]} | {n} | {first // 1000} | {peak // 1000} | {peak / first:.1f} | {total // 1000} | {cold}")
```
Several log entries can belong to one request (one per content block), so
"requests" over-counts a little; the ratios and the ranking are what matter.
