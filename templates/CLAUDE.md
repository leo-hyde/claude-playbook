# Instructions for Claude

Claude reads this file at the start of every session in this project,
including cloud sessions started from the user's phone. **Keep it short (under ~100
lines) and stable**: only what's specific to this project and that Claude
would get wrong without it. The user's general rules (how we work, explaining,
checking, the phone/Mac handover, coaching) are in `.claude/rules/playbook.md`,
synced from github.com/leo-hyde/claude-playbook: don't repeat them here.

What we're building: [SPEC.md](SPEC.md). How it looks: [DESIGN.md](DESIGN.md).
How it's built: [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md). Where we are:
[docs/STATUS.md](docs/STATUS.md). Why: [docs/decisions.md](docs/decisions.md).

## About this project
- <One line: what the app does.> Live at https://<github-user>.github.io/<repo>/

## Commands
- Check: <the project's test / preview / check command>

## Conventions
- Plain HTML/CSS/JS with `<script>` tags (no ES modules, no build step) so it
  opens by double-clicking `index.html`. Libraries from a CDN, exact versions.
- **Follow DESIGN.md** for anything visual; add new components to it.
- **Build from SPEC.md**; propose changes to it before building them.
- Pushing to `main` updates the live site, so only push working, tested steps.

## Gotchas
- <Usage limits of the data sources, odd behaviours, things that went wrong.>
- Pushing and previewing on the Mac: see the owner's notes (playbook
  `owner/profile.md`).
