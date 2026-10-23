# Claude playbook

How Leo and Claude build apps together, learned while building
[Sport Conditions](https://github.com/leo-hyde/sport-conditions).

This folder is a Claude Code **skill** called `new-app`. On Leo's Mac it lives
at `~/.claude/skills/new-app/`, so any Claude Code session can use it: type
`/new-app`, or just say you're starting a new app.

| File | What it's for |
|---|---|
| `shared/` | **Goes to every project automatically**: the shared rules (`ai-dev-rules.md`), the session lock script and the sync script |
| `SKILL.md` | The playbook: kick-off, plan documents, set-up, building, checking |
| `personal-CLAUDE.md` | Mac-only notes; a copy of `~/.claude/CLAUDE.md` |
| `templates/` | One-off starting points: SPEC, DESIGN, CLAUDE.md, STATUS, decisions, feature spec, style.css, a Cloudflare Worker, a GitHub Action |
| `reference/` | UX checklist, GitHub/hosting/Cloudflare steps, gotchas, phone + computer handover, understanding and quality |
| `tools/serve.py` | No-cache preview server |
| `docs/` | How this playbook itself works (ARCHITECTURE), its decisions and status |

## Change it once, every project follows
Edit `shared/ai-dev-rules.md` (or the scripts next to it), commit and push to
`main`. At each project's next session start, `scripts/playbook-sync.sh`
copies the new version into the project (`.claude/rules/playbook.md`) and
commits it. It works the other way too: when a session in any project learns
something general, the rules tell Claude to add it here. How it works, and its
limits: `docs/ARCHITECTURE.md`.

Projects using it: [Sport Conditions](https://github.com/leo-hyde/sport-conditions),
JobSeekHelper.

## Using it somewhere else
- **Another Mac:**
  `git clone https://github.com/leo-hyde/claude-playbook ~/.claude/skills/new-app`
  then `cp ~/.claude/skills/new-app/personal-CLAUDE.md ~/.claude/CLAUDE.md`
- **A cloud session from a phone** (claude.ai/code): it can't see the Mac's
  `~/.claude`. Each project carries the shared rules in
  `.claude/rules/playbook.md`, synced from here. To use the full playbook, start with: *"Read
  github.com/leo-hyde/claude-playbook (SKILL.md and the files it points to) and
  follow it."*
- **Working on one project from both phone and Mac:** see
  `reference/phone-and-computer.md`. To add it to an existing project, tell
  that project's session: *"Read reference/phone-and-computer.md in
  github.com/leo-hyde/claude-playbook and set this project up that way."*

## Keeping it up to date
Rules every session needs: `shared/ai-dev-rules.md` (keep it short; it's read
in every session of every project). Longer know-how: `reference/`. If you
change `~/.claude/CLAUDE.md`, copy it over `personal-CLAUDE.md` too.
