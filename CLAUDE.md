# Instructions for Claude (the playbook itself)

This repo is the user's playbook for building apps with AI. It's also a Claude Code
skill (`new-app`) on the user's Mac, at `~/.claude/skills/new-app`. How it works:
[docs/ARCHITECTURE.md](docs/ARCHITECTURE.md). Where we are:
[docs/STATUS.md](docs/STATUS.md). Why: [docs/decisions.md](docs/decisions.md).

@shared/ai-dev-rules.md
@owner/profile.md

## Working on the playbook
- **`shared/` reaches every project at its next release** (the canary
  project gets it as soon as it's on `main`). A mistake there spreads
  everywhere, so: keep `ai-dev-rules.md` short (every line is read in every
  session of every project; the tests fail it over 150 lines); run `bash tests/run.sh`
  before pushing, and add a case to it when you change a script (don't
  write throwaway tests inline); scripts must work on macOS (bash 3.2, BSD
  tools) and Linux. The GitHub Action runs the tests on both.
- Projects' copies must not be edited there; this repo is the source.
- Templates (`templates/`) are copied once into new projects and don't update,
  except the hooks in `templates/.claude/settings.json`, which every session
  checks through `shared/setup.txt`, and the subagents in
  `templates/.claude/agents/`, which the sync copies like `shared/`. So any other template change that
  existing projects need also gets a catch-up entry.
  `reference/` is read on demand, so detail belongs there, not in `shared/`.
- **The rules apply here too.** This repo has no session hooks: update
  docs/STATUS.md by hand after each step, commit and push to `main`
  (`git push origin HEAD:main`). A new catch-up in `shared/catch-up.md` is
  applied here as well, and recorded in `docs/playbook-catch-up.md`.
- `owner/personal-CLAUDE.md` mirrors `~/.claude/CLAUDE.md` on the Mac.

## How a playbook session works
- **One playbook session at a time.** This repo has no hooks, so at the
  start run `git fetch -q origin && git branch -r` and check for other open
  branches. If there are any, tell the user before changing anything.
- **Work from the `idea` issues, in a batch.** For each change, write down:
  the problem, with evidence (what happened, where); what it costs every
  session (lines added to the rules, characters added to session start);
  what it replaces or removes.
- **A rule addition must pay for itself.** If the rules file is at its
  limit, something else gets shorter or moves to `reference/`.
- `bash tests/run.sh` passes, then push to `main`. Only the canary project
  (its `.claude/playbook-channel` reads `main`) picks it up.
- **Release when the canary has had at least one real session on the change
  with no problems**, at most about once a week. A broken script is the
  exception: fix, test, release straight away. Undo is the same: revert the
  bad commit on `main` and release again, never a force-push.
- **To release:** add the `RELEASES.md` entry, push it to `main`, then run
  `scripts/release.sh --check`. Show the user what's going out and ask; only
  after their yes run `scripts/release.sh --yes`. It runs the tests, checks
  the note, pushes `main` to `stable` and tags it. A release reaches every
  project.
