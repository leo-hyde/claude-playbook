---
name: new-app
description: A playbook for starting and building a new app or website with Claude - kick-off questions, SPEC/DESIGN/CLAUDE.md templates, GitHub + GitHub Pages + Cloudflare Worker setup, the UX/design checklist, and hard-won gotchas. Use when the user starts a new app or project, asks how to set one up, wants a design/UX review of a web app, or types /new-app.
---

# New app playbook

How the user and Claude build apps together, distilled from building Sport
Conditions (github.com/leo-hyde/sport-conditions), a weather-for-sports web app.
It worked well: plan in short documents, build in small visible steps, teach
along the way, push every step to GitHub, check everything in a real browser.

The user is learning to code. Follow `shared/ai-dev-rules.md` (the user's rules for
every project; projects get a synced copy as `.claude/rules/playbook.md`) for
how to work together, explain things and coach the user on using AI well.

## 1. Kick-off: understand before building

Ask (in one message, not a questionnaire drip):
- What problem does it solve, and for whom (just the user, friends, the public)?
  What's the **one main job** someone opens it for? That job owns the main
  screen; everything else is one tap away or in Settings
  (`reference/design-method.md`).
- Phone, computer or both? (Usually both: design phone-first.)
- What data does it need, and from where? (Research free sources yourself;
  check usage limits, keys and whether browsers may fetch them: "CORS".)
- 2–3 apps or sites the user likes the look and feel of, and one the user finds
  annoying, with a word on why. Then **which style?** Link to the style gallery
  (`styles/gallery.html`; list in `styles/README.md`), suggest the closest
  style, and let the user pick. A client's app uses their brand instead
  (`reference/client-style.md`). **Show, don't describe**: The user reacts
  faster to pictures than to written options.
- What's essential for version 1, and what can wait?

Then research what's needed (APIs, existing data, libraries) and say plainly
what's easy, what's hard, and what costs money.

## 2. Agree the plan in three short documents

Copy and fill in the templates in `templates/`:
- **SPEC.md**: what we're building. Key concepts, version 1 as numbered steps
  (each one visible when done), a "Later" list (each item with a line on why it
  waits), open questions.
- **DESIGN.md**: how it looks. Start from the chosen style's
  `styles/<name>/DESIGN.md` (its tokens go in `style.css`:
  `styles/README.md` says how), fill in the user's references. Before
  designing a screen, read `reference/design-method.md`. For anything
  visual, offer 2–3 quick mockups in that style (shown inline) and let the
  user pick or mix.
- **CLAUDE.md**: project-only rules, short. The general rules arrive by
  themselves as `.claude/rules/playbook.md` (set-up step 5), which cloud sessions
  see too; don't copy them in.
- **docs/decisions.md**: one entry per decision (`templates/decisions.md`).
- **docs/ARCHITECTURE.md** (once there's code): the parts, the data flow,
  outside services, safety, weak spots. See `reference/understanding-and-quality.md`
  for why, and how it fits with the other documents.

Ask the user to review them. Build nothing big until they're agreed.

## 3. Set up the project

See `reference/github-and-hosting.md` for exact commands. In order:
1. `git init`, a `.gitignore` (`.claude/`, `.DS_Store`), first commit.
2. Preview: the project folder is under Documents, which macOS blocks the
   preview server from reading, so copy files to the scratchpad and serve with
   `tools/serve.py` (no caching, handles many files at once).
3. GitHub: ask the user whether the repository should be public or private
   (public is needed for free GitHub Pages; check nothing private or
   third-party is in it), create it, push.
4. Hosting: GitHub Pages (free) → `https://<github-user>.github.io/<repo>/ (accounts: `owner/profile.md`)`.
5. **Phone + computer handover and shared rules** (every project):
   `docs/STATUS.md`, the session script and hooks, one branch, and the playbook
   sync. Follow "Setting it up in a project" in `reference/phone-and-computer.md`.
6. Only if needed: a Cloudflare Worker for secrets, sources that block browsers,
   or syncing between devices (`reference/github-and-hosting.md`,
   `templates/worker.js`). The user has a Cloudflare account; Claude can't create
   accounts or deploy to Cloudflare, so give the user click-by-click steps.

## 4. Build in small steps

Bigger features get a spec first (`templates/specs/feature.md` →
`specs/<feature>.md`), built in a fresh session. For each step: (design note
first if it changes the structure) → build →
check with evidence (tests for logic; the browser at phone 375px and desktop,
light and dark) → walkthrough: what changed, files and data flow, key lines,
how it was checked and what wasn't, risks → update ARCHITECTURE.md,
decisions.md and STATUS.md → commit and push. Use made-up data for design work so you don't
burn through a free service's daily limit; a reusable preview script (like
Sport Conditions' `tools/preview.js`) saves writing test code each time.

## 5. Before calling a stage done

Go through `reference/ux-checklist.md`, and check `reference/gotchas.md`. A
step that adds or reworks a screen also gets the design review
(`reference/design-review.md`, usually by the `checker` subagent).
Then push, wait for the live site to update, and check it there too.

## Files here
| File | What it's for |
|---|---|
| `shared/ai-dev-rules.md` | The shared rules for every project; synced into each as `.claude/rules/playbook.md` |
| `shared/catch-up.md` | Rule changes that existing projects must apply once to files they already have; session start lists the ones still due |
| `shared/session.sh`, `shared/playbook-sync.sh` | Session start and end checks, cost notes and the push-to-main docs check; the sync. Also synced into each project's `scripts/` |
| `owner/profile.md`, `owner/personal-CLAUDE.md` | The owner's details (synced into each project as `.claude/rules/owner.md`); a copy of `~/.claude/CLAUDE.md` |
| `templates/.claude/agents/` | The `scout` and `checker` subagents, synced into each project |
| `reference/efficient-sessions.md` | How cost works, the habits, the dated assumptions, the monthly review |
| `templates/SPEC.md`, `DESIGN.md`, `CLAUDE.md`, `decisions.md`, `specs/feature.md` | Starting points for a new project's documents |
| `templates/style.css` | Design tokens (light/dark), buttons, cards, dialogs, phone layout |
| `templates/worker.js` | Cloudflare Worker skeleton: CORS, caching, a secret key, KV sync |
| `templates/site-check.yml` | GitHub Action pattern: check + rebuild data on every change |
| `reference/research-to-doc.md` | Turning a question into a spec or decision document: brief, research, outline, critique, one batch of decisions, write once |
| `reference/design-method.md` | How Claude designs a screen: purpose, structure, patterns, words, look, accessibility, checking |
| `reference/ux-checklist.md` | The design and UX review checklist |
| `reference/design-review.md` | The design pass after a step that changes screens: measure, look, report |
| `reference/client-style.md` | Matching a client's brand instead of a library style |
| `styles/` | The style library: `README.md` (how to choose and apply), `gallery.html` (every style on one sample screen), one folder per style, `candidates.json` (the source) |
| `tools/styles.py` | Builds the style files and gallery from `candidates.json`, and checks contrast |
| `tools/page-check.js` | Measures a page at phone and desktop, light and dark: width, tap targets, accessibility (axe-core), screenshots |
| `reference/github-and-hosting.md` | GitHub, Pages, Actions, Cloudflare Worker, KV: exact steps |
| `reference/gotchas.md` | Things that went wrong before, and their fixes |
| `reference/phone-and-computer.md` | Keeping phone (cloud) and Mac sessions in step: STATUS.md, branches, the session script, hooks |
| `reference/understanding-and-quality.md` | How we make sure AI-built apps are understood, good and safe; using AI efficiently |
| `templates/ARCHITECTURE.md` | Starting point for a project's architecture overview |
| `templates/STATUS.md`, `templates/.claude/settings.json` | The handover kit to copy into a project (with `shared/`) |
| `tools/serve.py` | No-cache preview server for the scratchpad copy |
