# Instructions for AI assistants (the playbook itself)

This repo is the user's playbook for building apps with AI, and a Claude Code
skill (`new-app`) on the user's Mac. **Read [README.md](README.md) and
[PLAN.md](PLAN.md) first**, then the open pull requests. How it works:
[docs/ARCHITECTURE.md](docs/ARCHITECTURE.md). Why, and what waits on the
user: [docs/decisions.md](docs/decisions.md).

The rules every project follows apply here too:
[shared/ai-dev-rules.md](shared/ai-dev-rules.md) and
[owner/profile.md](owner/profile.md), loaded through `CLAUDE.md`.

## Commands
- Tests: `bash tests/run.sh` (must pass before merging; the GitHub Action
  runs them on macOS and Linux).
- Push from the Mac: see `owner/profile.md`.

## Rules and traps for this repo
- **`shared/` reaches every project at its next session once it's on
  `main`.** A mistake there spreads everywhere: keep `ai-dev-rules.md` short
  (the tests fail it over 150 lines); add a test case when you change a
  script (no throwaway tests inline); scripts work on macOS (bash 3.2, BSD
  tools) and Linux. A change to `ai-dev-rules.md` runs the fixed test tasks
  in `tests/rule-tasks.md` before and after.
- **This repo has no session hooks.** At the start, by hand: `git fetch -q
  origin && git branch -r` and `gh pr list`; tell the user about other open
  branches or pull requests before changing anything (one playbook session
  at a time). Nothing blocks a reply's end here, so push every step.
- **Public repo:** general terms only; nothing from the owner's "Never
  public" list or other people's projects.
- Projects' copies are never edited there; this repo is the source.
- Templates are copied once and don't update, except the hooks
  (`templates/.claude/settings.json`, through `shared/setup.txt`) and the
  subagents (`templates/.claude/agents/`, synced). Any other template change
  that existing projects need gets a catch-up in `shared/catch-up.md`, which
  is applied here too and recorded in `docs/playbook-catch-up.md`.
- Detail goes in `reference/` or `methods/` (read on demand), not `shared/`.
- `owner/personal-CLAUDE.md` mirrors `~/.claude/CLAUDE.md` on the Mac.
- **Releases are off** (2 Nov 2026) but kept. If a playbook change ever
  breaks projects, or the same fix is undone in several, recommend bringing
  them back (decisions.md, 2 Nov, says how). Undo now: revert on `main`.

## Methods
- Playbook changes: `methods/build-a-feature.md`, working from the `idea`
  issues in a batch. For each change write down the problem with evidence,
  what it costs every session (rule lines, session-start characters), and
  what it replaces. A rule addition must pay for itself.
- `methods/research-to-doc.md`, `methods/pick-up-where-we-left-off.md`.

## Always / ask first / never
- **Always:** a pull request per change; merge it when the tests pass, and
  move its PLAN.md line in the same pull request.
- **Ask first:** deleting branches, closing others' issues, anything that
  changes what projects' files must look like.
- **Never:** force-push; edit a project's synced copies.
