# Catch-ups: rule changes that existing projects must apply

A new rule in `ai-dev-rules.md` shapes new work from then on. Some rules also
change how files a project **already has** should look. Those get an entry
here, so every older project applies them once, not just the one where the
rule was made.

Set-up additions (a new hook, `.gitignore` line or required file) don't
need an entry: add them to `shared/setup.txt`, which the sync checks and
fills in automatically. Removing or renaming set-up does need an entry.

How it works: at session start, `playbook-sync.sh` prints the heading of every entry below
whose id isn't yet mentioned in the project's `docs/playbook-catch-up.md`,
under "CATCH-UP DUE". Claude tells the user, applies it (or offers a separate
session if it's big), then adds a line to that file: id, date, what changed.

Adding an entry: newest last, a heading `## <id>: <title>` (id is the date and
a short slug, no spaces), then a few lines: what to change, in which files,
what to leave alone, how to check. Session start prints only the heading;
Claude reads the entry here when applying it, so the title must say what it is.

## 2026-10-24-plain-english: Rewrite existing docs in UK plain English
- Rewrite the docs a person reads (README, SPEC, DESIGN, `docs/STATUS.md`,
  `docs/decisions.md`, `docs/ARCHITECTURE.md`, specs, reports, the site's own
  text) to the "Writing for people" rules: everyday words, short sentences,
  every technical term explained the first time.
- Change the wording, never the meaning: keep every fact, figure, date,
  source link and decision.
- Leave code, commands and AI-facing files (CLAUDE.md, rules, skills,
  prompts) technical.
- Long research reports or data entries, where a full rewrite could change
  facts: add a plain summary and a short glossary at the top, and offer a
  separate session for the full pass.
- Check: the project's build and tests still pass, and the diff changes
  wording only.

## 2026-10-25-spec-is-the-plan: Make SPEC.md match the current plan
- Read SPEC.md, every file in `specs/`, docs/STATUS.md, docs/decisions.md and
  recent `git log`. Where the plan, goal, scope or steps have moved on, update
  SPEC.md: a step table with each step's status, a link to each spec, and an
  "(updated <date>)" on its status line.
- Any change of plan not yet in decisions.md: add an entry under the date it
  was made (from git log), saying it was recorded late.
- STATUS.md's next steps: point at SPEC.md's step numbers, don't copy them.
- Leave the meaning alone: record what was decided, don't decide anything.
  Anything unclear goes to the user as a question.
- Check: a fresh session reading only the docs would plan the same next step.

## 2026-10-27-no-lock: No session lock; STATUS.md changes when a step finishes
- The lock is gone from `scripts/session.sh` (the sync updates it). Delete
  the old lock branch on GitHub, but only if its last commit is over a day
  old (so no session still runs the old script):
  `git log -1 --format=%cr origin/session-lock`, then
  `git push origin --delete session-lock`. The user agreed (27 Oct).
- In `docs/STATUS.md`: rename the heading to "Handover (overwrite this block
  when a step finishes)", and change any "update after every reply/session"
  wording to match `templates/STATUS.md`.
- In the project's CLAUDE.md and docs: replace any mention of the lock,
  `ANOTHER DEVICE IS WORKING` or "always push to main" with the new rule
  (own branch while working, main when a step is finished). Leave
  everything else.
- Check: `bash scripts/session.sh status` runs and shows no lock.

## 2026-10-27-tokens: Cost notes and a push-to-main docs check replace coaching and the end-of-reply docs check
- The session script changed (the sync updates it): the message counter and
  its `COACH:` lines are gone; `COST:` lines say when each message has grown
  costly. Docs are now checked when work is pushed to `main` (a new
  `PreToolUse` hook, added to `.claude/settings.json` by the set-up check),
  not at the end of every reply.
- In the project's CLAUDE.md and docs: replace any mention of `COACH:`, the
  message counter, "Coaching" or the end-of-reply docs check with the new
  behaviour. Remove any lines that repeat the owner's details now in
  `.claude/rules/owner.md` (accounts, the commit address). Leave the rest.
- Check: `grep -rn 'COACH' CLAUDE.md docs` finds nothing, and
  `.claude/settings.json` has the `push-check` hook.
