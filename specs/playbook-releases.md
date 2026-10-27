# Spec: changing the playbook safely (releases)

Status: **draft for the user's review** (27 Oct 2026). Build this first: the
other specs ship through it.

## Goal
A change to the playbook reaches every project only after it's been tested
and tried in one real project, arrives in batches rather than a trickle, and
can be undone in one step. Making changes should cost fewer sessions, not
more.

## The problem today
- **Every push to `main` reaches every project** at its next session start.
  There's no test stage: a broken script, or a rule that misfires, spreads
  everywhere at once.
- **Changes arrive one by one.** Each push adds another "Playbook: update"
  commit in every project, and can bring in a catch-up.
- **Many writers.** The rules tell any project session to edit the playbook
  when it learns something. On 25 Oct four sessions edited it in parallel,
  and about 13% of the week's usage went on the playbook itself.
- **The rules file only grows**: 155 → 197 lines in four days, against a
  target of about 150. Nothing stops it.
- **Tests are rewritten each time.** Every script change builds its own
  throwaway repo inline, which costs tokens and isn't kept.
- **Nobody sees what changed.** Projects just get new rules.

## The parts

### 1. A `stable` branch that projects sync from
- Work lands on `main` as now. A **release** moves `stable` forward to
  `main` and tags it `release-YYYY-MM-DD` (plus `-2`, `-3` for more than one
  on a day).
- `playbook-sync.sh` reads `origin/stable` instead of `origin/main`,
  everywhere it uses `git show`, `setup.txt` and `catch-up.md`.
  - **Change-over:** if `stable` doesn't exist yet, it falls back to `main`,
    so old and new scripts both keep working.
- **A canary project** sets its channel to `main` in a committed file,
  `.claude/playbook-channel` (one word: `main` or `stable`; missing means
  `stable`). It gets every change first, in real use.
- **Undo:** revert the bad commit on `main` and release again. No
  force-push.

### 2. A kept test suite, run on Linux and macOS
- `tests/run.sh` builds throwaway projects in a temporary folder and checks:
  - session start (output and its size budget);
  - the sync from a local "playbook" with `stable` and `main` branches, and
    the canary channel;
  - setup.txt additions;
  - catch-ups printed as one line each;
  - the end-of-reply check (blocks only for lost work in the cloud);
  - the push-to-main docs check;
  - the cost hook with sample transcripts.
- Budgets checked there too: `shared/ai-dev-rules.md` 150 lines or fewer;
  session-start output under about 1,500 characters.
- A GitHub Action (`.github/workflows/test.yml`) runs it on every push, on
  `ubuntu-latest` and `macos-latest`. macOS covers bash 3.2 and BSD tools,
  which today are only promised, not tested. It's free for public repos.
- Sessions run `bash tests/run.sh` instead of writing tests inline, and add
  a case when they change a script.

### 3. Release notes the user sees once
- `RELEASES.md`, newest first: the release tag, two or three plain lines on
  what changes for the user, and any catch-up it brings.
- When the sync updates a project, it prints the newest note's first line
  (`Playbook: updated to release-2026-11-03: <line>`). Claude passes it on
  in one sentence.

### 4. One way in for ideas
- Replace "Keeping the playbook current" in the rules: a project session
  that learns something general **files it as an issue on the playbook
  repo**. It uses the label `idea`, says what happened (in general terms,
  since the repo is public) and the rule it suggests. If the session can't
  reach the playbook repo, it gives the user a two-line note to paste into
  one.
- **It doesn't edit the playbook**, unless the user asks for it in that
  session.
- The monthly usage review (efficient-sessions spec) files its findings the
  same way.

### 5. How a playbook session works (in the playbook's own CLAUDE.md)
- **One playbook session at a time.** Session start lists open branches.
  The playbook has no hooks, so Claude checks `git branch -r` by hand.
- **Work from the idea issues in a batch.** For each change, write down:
  - the problem, with evidence (what happened, where);
  - what it costs every session (lines added to the rules, start-output
    characters);
  - what it replaces or removes.
- **A rule addition must pay for itself.** If the rules file is at its
  limit, something else gets shorter or moves to `reference/`.
- `bash tests/run.sh` passes, then push to `main` (the canary picks it up).
- **Release when the canary has had at least one real session on it with no
  problems**, at most about once a week. A broken script is the exception:
  fix, test, release straight away.
- **To release:** run `scripts/release.sh`. It runs the tests, checks a new
  `RELEASES.md` entry exists, pushes `main` to `stable` and tags it. It asks
  the user before pushing, because a release reaches every project.

### 6. A dated assumptions table for Claude Code itself
Facts about Claude Code that the playbook relies on: hooks in cloud
sessions, `.claude/rules/` loading, plugins not loading in the cloud, the
cache lifetime, and so on. They go in one table, in
`docs/ARCHITECTURE.md`, each with a source and the date checked. The
monthly review re-checks them. A mismatch becomes an idea issue.

## Out of scope
- Semantic version numbers (dates are enough for one owner).
- A playbook GitHub Action that pushes into projects (rejected 23 Oct: it
  needs a token that can change every repo).
- Rewriting the rules (that's the efficient-sessions spec).

## How we'll know it's done
- A change pushed to `main` reaches the canary and no other project, as
  shown in each project's session-start output. After a release, it reaches
  every project.
- An old project script without the channel logic still syncs, from `main`,
  until it updates itself.
- The tests pass on both runners. A deliberately broken script fails them.
- `scripts/release.sh` refuses without passing tests or a release note.

## Decisions for the user
1. **Which project is the canary?** Recommended: Sport Conditions. It's
   public, used often, and the least harm if a session misbehaves.
2. **Release cadence**: at most about weekly, with broken scripts as the
   exception. Recommended.
3. **Ideas as issues on the playbook repo** (public, so written in general
   terms) rather than direct edits from project sessions. Recommended.

## Progress
- 27 Oct 2026: spec drafted.
