# Claude playbook

How the user and Claude build apps together. We learned it while building
[Sport Conditions](https://github.com/leo-hyde/sport-conditions).

## What this is
This folder is a set of instructions and starting files for Claude Code, the
AI coding tool. Claude Code calls a folder like this a **skill**: a packaged
set of instructions it can load when needed. This one is called `new-app`.

On the user's Mac it lives at `~/.claude/skills/new-app/`, so any Claude Code
session there can use it. Type `/new-app`, or just say you're starting a new
app.

## What's in it

| Folder or file | What it's for |
|---|---|
| `shared/` | **Copied into every project automatically.** The shared rules for Claude (`ai-dev-rules.md`), plus two small programs (scripts): one keeps sessions in step and checks nothing is lost, the other keeps each project's copy up to date |
| `SKILL.md` | The playbook itself: first questions, planning documents, setting up, building, checking |
| `personal-CLAUDE.md` | Notes for Claude that only apply on the user's Mac. A copy of `~/.claude/CLAUDE.md` |
| `templates/` | Starting points copied once into a new project: the plan (SPEC), the look (DESIGN), Claude's instructions (CLAUDE.md), the status page, the decisions log, a feature plan, a style sheet, a Cloudflare Worker (a small program that runs online) and a GitHub Action (a job GitHub runs for you) |
| `reference/` | Know-how Claude reads when it needs it: a design checklist, GitHub and hosting steps, past mistakes and their fixes, working from phone and Mac, and making sure AI-built work is understood and safe |
| `owner/` | Everything specific to the playbook's owner (accounts, devices, how they like to work). Someone copying the playbook replaces this folder |
| `specs/` | Plans for changes to the playbook itself, agreed before they're built |
| `tools/serve.py` | A small program that shows a project in the browser on the Mac, always with the latest files |
| `docs/` | How this playbook works, the decisions behind it, and where it's up to |

## Change it once, every project follows
The shared rules live in one file here: `shared/ai-dev-rules.md`. To change them,
edit that file and save the change to GitHub. (In git terms: **commit**, a
saved snapshot of the files, and **push**, sending it to GitHub's `main`, the
one main copy.)

Each project then picks up the change by itself. When a Claude session opens
in a project, a script there (`scripts/playbook-sync.sh`) copies the new
rules in as `.claude/rules/playbook.md`, and saves that change in the project.

It works the other way too. When a session in any project learns something
that would help every project, the rules tell Claude to add it here. How this
works, and where it can fail: [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md).

Projects using it: [Sport Conditions](https://github.com/leo-hyde/sport-conditions),
a private project, [AEC Tech Radar](https://github.com/leo-hyde/AECTechRadar) and
its helper repo. Every repo (project folder on GitHub) of the user's should use it:
see `shared/ai-dev-rules.md`.

## Using it somewhere else
- **On another Mac:** copy the playbook into place, then copy the Mac notes:
  `git clone https://github.com/leo-hyde/claude-playbook ~/.claude/skills/new-app`
  then `cp ~/.claude/skills/new-app/personal-CLAUDE.md ~/.claude/CLAUDE.md`
- **In a cloud session from the user's phone** (claude.ai/code): the session runs
  on Anthropic's computers, so it can't see the Mac's `~/.claude` folder.
  Each project carries its own copy of the rules instead
  (`.claude/rules/playbook.md`). To use the whole playbook, start the session
  with: *"Read github.com/leo-hyde/claude-playbook (SKILL.md and the files it
  points to) and follow it."*
- **Working on one project from both phone and Mac:** see
  `reference/phone-and-computer.md`. To set an existing project up that way,
  tell a session in that project: *"Read reference/phone-and-computer.md in
  github.com/leo-hyde/claude-playbook and set this project up that way."*

## Keeping it up to date
Rules every session needs go in `shared/ai-dev-rules.md`. Keep it short:
every session of every project reads all of it. Longer know-how goes in
`reference/`, which Claude reads only when needed. If you change
`~/.claude/CLAUDE.md` on the Mac, copy it over `personal-CLAUDE.md` too.
