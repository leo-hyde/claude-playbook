# Claude playbook

How Leo and Claude build apps together, learned while building
[Sport Conditions](https://github.com/leo-hyde/sport-conditions).

This folder is a Claude Code **skill** called `new-app`. On Leo's Mac it lives
at `~/.claude/skills/new-app/`, so any Claude Code session can use it: type
`/new-app`, or just say you're starting a new app.

| File | What it's for |
|---|---|
| `SKILL.md` | The playbook: kick-off, plan documents, set-up, building, checking |
| `personal-CLAUDE.md` | How we work together; a copy of `~/.claude/CLAUDE.md` (loaded in every session on the Mac) |
| `templates/` | Starting points: SPEC.md, DESIGN.md, CLAUDE.md, style.css, a Cloudflare Worker, a GitHub Action |
| `reference/` | UX checklist, GitHub/hosting/Cloudflare steps, gotchas, phone + computer handover, understanding and quality |
| `tools/serve.py` | No-cache preview server |

## Using it somewhere else
- **Another Mac:**
  `git clone https://github.com/leo-hyde/claude-playbook ~/.claude/skills/new-app`
  then `cp ~/.claude/skills/new-app/personal-CLAUDE.md ~/.claude/CLAUDE.md`
- **A cloud session from a phone** (claude.ai/code): it can't see the Mac's
  `~/.claude`. Each project's own CLAUDE.md carries the key rules, which the
  playbook copies in. To use the full playbook, start with: *"Read
  github.com/leo-hyde/claude-playbook (SKILL.md and the files it points to) and
  follow it."*
- **Working on one project from both phone and Mac:** see
  `reference/phone-and-computer.md`. To add it to an existing project, tell
  that project's session: *"Read reference/phone-and-computer.md in
  github.com/leo-hyde/claude-playbook and set this project up that way."*

## Keeping it up to date
When we learn something new, edit the files here, then commit and push. If you
change `~/.claude/CLAUDE.md`, copy it over `personal-CLAUDE.md` too.
