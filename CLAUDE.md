# Instructions for Claude (the playbook itself)

This repo is the user's playbook for building apps with AI. It's also a Claude Code
skill (`new-app`) on the user's Mac, at `~/.claude/skills/new-app`. How it works:
[docs/ARCHITECTURE.md](docs/ARCHITECTURE.md). Where we are:
[docs/STATUS.md](docs/STATUS.md). Why: [docs/decisions.md](docs/decisions.md).

@shared/ai-dev-rules.md

## Working on the playbook
- **`shared/` reaches every project at its next session start.** A mistake
  there spreads everywhere, so: keep `ai-dev-rules.md` short (every line is
  read in every session of every project; aim under ~150 lines); run
  `bash -n` on the scripts and test a changed script in a throwaway git repo
  before pushing; scripts must work on macOS (bash 3.2, BSD tools) and Linux.
- Projects' copies must not be edited there; this repo is the source.
- Templates (`templates/`) are copied once into new projects and don't update,
  except the hooks in `templates/.claude/settings.json`, which every session
  checks through `shared/setup.txt`. So any other template change that
  existing projects need also gets a catch-up entry.
  `reference/` is read on demand, so detail belongs there, not in `shared/`.
- **The rules apply here too.** This repo has no session hooks: update
  docs/STATUS.md by hand after each step, commit and push to `main`
  (`git push origin HEAD:main`). A new catch-up in `shared/catch-up.md` is
  applied here as well, and recorded in `docs/playbook-catch-up.md`.
- `personal-CLAUDE.md` mirrors `~/.claude/CLAUDE.md` on the Mac.
