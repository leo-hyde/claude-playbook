---
name: new-app
description: Leo's playbook for starting and building a new app or website with Claude - kick-off questions, SPEC/DESIGN/CLAUDE.md templates, GitHub + GitHub Pages + Cloudflare Worker setup, the UX/design checklist, and hard-won gotchas. Use when Leo starts a new app or project, asks how to set one up, wants a design/UX review of a web app, or types /new-app.
---

# New app playbook

How Leo and Claude build apps together, distilled from building Sport
Conditions (github.com/leo-hyde/sport-conditions), a weather-for-sports web app.
It worked well: plan in short documents, build in small visible steps, teach
along the way, push every step to GitHub, check everything in a real browser.

Leo is learning to code. Follow `~/.claude/CLAUDE.md` (also in this folder as
`personal-CLAUDE.md`) for how to explain things and work together.

## 1. Kick-off: understand before building

Ask (in one message, not a questionnaire drip):
- What problem does it solve, and for whom (just Leo, friends, the public)?
- Phone, computer or both? (Usually both: design phone-first.)
- What data does it need, and from where? (Research free sources yourself;
  check usage limits, keys and whether browsers may fetch them: "CORS".)
- 2–3 apps or sites Leo likes the look and feel of, and one Leo finds
  annoying, with a word on why. **Show, don't describe**: Leo reacts faster to
  pictures than to written options.
- What's essential for version 1, and what can wait?

Then research what's needed (APIs, existing data, libraries) and say plainly
what's easy, what's hard, and what costs money.

## 2. Agree the plan in three short documents

Copy and fill in the templates in `templates/`:
- **SPEC.md**: what we're building. Key concepts, version 1 as numbered steps
  (each one visible when done), a "Later" list (each item with a line on why it
  waits), open questions.
- **DESIGN.md**: how it looks. Start from the template's principles and tokens;
  fill in Leo's references. For anything visual, offer 2–3 quick mockups
  (shown inline) and let Leo pick or mix.
- **CLAUDE.md**: how to work on this project. **Include the key rules from
  `personal-CLAUDE.md`** so cloud sessions (which can't see this Mac's
  `~/.claude`) follow them too.
- **docs/ARCHITECTURE.md** (once there's code): the parts, the data flow,
  outside services, safety, weak spots. See `reference/understanding-and-quality.md`
  for why, and how it fits with the other documents.

Ask Leo to review them. Build nothing big until they're agreed.

## 3. Set up the project

See `reference/github-and-hosting.md` for exact commands. In order:
1. `git init`, a `.gitignore` (`.claude/`, `.DS_Store`), first commit.
2. Preview: the project folder is under Documents, which macOS blocks the
   preview server from reading, so copy files to the scratchpad and serve with
   `tools/serve.py` (no caching, handles many files at once).
3. GitHub: ask Leo whether the repository should be public or private
   (public is needed for free GitHub Pages; check nothing private or
   third-party is in it), create it, push.
4. Hosting: GitHub Pages (free) → `https://leo-hyde.github.io/<repo>/`.
5. **Phone + computer handover** (every project Leo works on from both):
   `docs/STATUS.md`, a session lock and hooks, one branch. Follow
   `reference/phone-and-computer.md`; templates are in `templates/`.
6. Only if needed: a Cloudflare Worker for secrets, sources that block browsers,
   or syncing between devices (`reference/github-and-hosting.md`,
   `templates/worker.js`). Leo has a Cloudflare account; Claude can't create
   accounts or deploy to Cloudflare, so give Leo click-by-click steps.

## 4. Build in small steps

For each step: (design note first if it changes the structure) → build →
check with evidence (tests for logic; the browser at phone 375px and desktop,
light and dark) → walkthrough: what changed, files and data flow, key lines,
how it was checked and what wasn't, risks → update ARCHITECTURE.md and
CHANGELOG.md → commit and push. Use made-up data for design work so you don't
burn through a free service's daily limit; a reusable preview script (like
Sport Conditions' `tools/preview.js`) saves writing test code each time.

## 5. Before calling a stage done

Go through `reference/ux-checklist.md`, and check `reference/gotchas.md`.
Then push, wait for the live site to update, and check it there too.

## Files here
| File | What it's for |
|---|---|
| `personal-CLAUDE.md` | Copy of `~/.claude/CLAUDE.md` (how we work, every project) |
| `templates/SPEC.md`, `DESIGN.md`, `CLAUDE.md` | Starting points for a new project's documents |
| `templates/style.css` | Design tokens (light/dark), buttons, cards, dialogs, phone layout |
| `templates/worker.js` | Cloudflare Worker skeleton: CORS, caching, a secret key, KV sync |
| `templates/site-check.yml` | GitHub Action pattern: check + rebuild data on every change |
| `reference/ux-checklist.md` | The design and UX review checklist |
| `reference/github-and-hosting.md` | GitHub, Pages, Actions, Cloudflare Worker, KV: exact steps |
| `reference/gotchas.md` | Things that went wrong before, and their fixes |
| `reference/phone-and-computer.md` | Keeping phone (cloud) and Mac sessions in step: STATUS.md, session lock, hooks |
| `reference/understanding-and-quality.md` | How we make sure AI-built apps are understood, good and safe; using AI efficiently |
| `templates/ARCHITECTURE.md` | Starting point for a project's architecture overview |
| `templates/STATUS.md`, `templates/scripts/session.sh`, `templates/.claude/settings.json` | The handover kit to copy into a project |
| `tools/serve.py` | No-cache preview server for the scratchpad copy |
