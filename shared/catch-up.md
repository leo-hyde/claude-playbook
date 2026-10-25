# Catch-ups: rule changes that existing projects must apply

A new rule in `ai-dev-rules.md` shapes new work from then on. Some rules also
change how files a project **already has** should look. Those get an entry
here, so every older project applies them once, not just the one where the
rule was made.

Set-up additions (a new hook, `.gitignore` line or required file) don't
need an entry: add them to `shared/setup.txt`, which the sync checks and
fills in automatically. Removing or renaming set-up does need an entry.

How it works: at session start, `playbook-sync.sh` prints every entry below
whose id isn't yet mentioned in the project's `docs/playbook-catch-up.md`,
under "CATCH-UP DUE". Claude tells Leo, applies it (or offers a separate
session if it's big), then adds a line to that file: id, date, what changed.

Adding an entry: newest last, a heading `## <id>: <title>` (id is the date and
a short slug, no spaces), then a few lines: what to change, in which files,
what to leave alone, how to check. Keep each entry short; it's printed in full.

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
  Anything unclear goes to Leo as a question.
- Check: a fresh session reading only the docs would plan the same next step.
