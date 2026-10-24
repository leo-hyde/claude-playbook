# How Leo and Claude work together (Leo's Mac)

Personal instructions, loaded in every Claude Code session on this Mac.
A copy lives in github.com/leo-hyde/claude-playbook (`personal-CLAUDE.md`):
after changing either, copy it over the other.

## The shared rules
Leo's rules for every project (how we work, explaining and checking the work,
the phone/Mac handover, coaching on sessions and credits) live in the
playbook's `shared/ai-dev-rules.md`, cloned at `~/.claude/skills/new-app`.
- Projects set up with the playbook load them automatically as
  `.claude/rules/playbook.md`, refreshed at each session start.
- **In any other project, read `~/.claude/skills/new-app/shared/ai-dev-rules.md`
  at the start of the session and follow it**, and offer to set the repo up
  with the playbook (every repo of Leo's should be).
- Learned something that applies to all projects? Update the playbook (see
  "Keeping the playbook current" in those rules), not just this project.

## Leo's Mac
- GitHub account `leo-hyde`; the GitHub CLI is at `/opt/homebrew/bin/gh`
  (may not be on PATH). Push with:
  `git -c credential.helper= -c credential.helper='!/opt/homebrew/bin/gh auth git-credential' push`
- Projects live in `~/Documents/Documents - Leo’s MacBook Air/…`. macOS blocks
  the preview server from reading there, so copy files to the scratchpad and
  serve from there (the `/new-app` skill's `tools/serve.py`, no caching).
- No Node.js or Homebrew Python tools assumed: plain HTML/CSS/JS and Python 3.9.
