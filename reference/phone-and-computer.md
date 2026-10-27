# Working from phone and computer on the same project

The user switches between their phone (Claude Code cloud sessions at claude.ai/code)
and their Mac, and often runs several sessions on one project at once (Mac
sessions each in their own worktree, a separate copy of the files). **Neither session can see the other's conversation. The GitHub
repository is the only shared memory.** This page is how we keep the two in
step. It was worked out on a private project (Oct 2026), after a phone session and
a desktop session ran at the same time and the phone's work never reached
GitHub.

## The four parts

1. **`docs/STATUS.md`**, the live record (template: `templates/STATUS.md`).
   - A **Handover block** at the top, *overwritten* when a step finishes:
     which device, did it end cleanly, anything half-done, the next step.
     Progress during a step goes in the step's spec instead, so parallel
     sessions don't clash over this file.
   - Where we are, next steps and open questions for the user. **Current state
     only**: decisions go in `docs/decisions.md`, history is `git log`.
     (Until Oct 2026 it also held a session log; it grew to 100+ lines that
     every session re-read, so it was dropped.)
   - Read it at the start of every session; update it after every finished
     step, not just at the end.
2. **Own branch while working, `main` when finished.** Every session works on
   its own branch (cloud: `claude/...` or `ccr-...`; Mac: its worktree's
   branch) and pushes it as it goes. A finished step is merged into main
   (`git push origin HEAD:main`), and Claude says so. Git does the safety
   work: GitHub refuses a push that would overwrite newer work, so Claude
   merges and tries again.
3. **The session script** (`shared/session.sh`).
   - `session.sh start` (session opens): pulls main, lists **other unfinished
     work** (`OTHER WORK`: branches with commits not on main, touched in the
     last 14 days, including other Mac worktrees' unpushed ones), syncs the
     playbook, lists open issues, prints the Handover block.
   - `session.sh busy` (the user sends a message): counts the user's messages and every
     15 prints a `COACH:` line, so Claude suggests a fresh session when it helps.
   - `session.sh check` (a reply finishes): in a **cloud** session, refuses
     to finish with uncommitted work or commits on no branch on GitHub (they'd
     be lost when the session closes). On the **Mac** it shows the user a reminder
     instead: the work is safe in its folder. Wherever the work has reached
     **main**, it refuses to finish until STATUS.md (and SPEC.md, if `specs/`
     changed) is updated.
   - `session.sh end`: the same checks, printed, before the user switches device.
4. **Hooks** (`templates/.claude/settings.json`) make Claude Code run
   `start` when a session opens, `busy` on every message and `check` at the
   end of every reply, so nobody has to remember. The rules Claude follows
   around them are in `shared/ai-dev-rules.md` ("Git and the phone/Mac handover").

## Setting it up in a project

The shared files (`shared/` in the playbook) are copied in once and then keep
themselves up to date: `session.sh start` runs `scripts/playbook-sync.sh`,
which fetches the playbook's latest `main` and commits any changes as
"Playbook: update shared files…". See `docs/ARCHITECTURE.md` in the playbook.

1. Copy `templates/STATUS.md` to `docs/STATUS.md` and `templates/decisions.md`
   to `docs/decisions.md`, and fill them in.
2. Copy `shared/session.sh` and `shared/playbook-sync.sh` into `scripts/`
   (`chmod +x scripts/*.sh`), then run `bash scripts/playbook-sync.sh` once:
   it adds `.claude/rules/playbook.md` (the shared rules).
   For a **new** project, also create `docs/playbook-catch-up.md` listing
   every id in the playbook's `shared/catch-up.md` as "not needed: started
   under this rule", so session start doesn't ask for catch-ups it was born
   with. An **existing** project skips this: the catch-ups are due.
3. Copy `templates/.claude/settings.json` to `.claude/settings.json`, and make
   sure `.gitignore` has `.claude/*`, `!.claude/settings.json`,
   `!.claude/rules/` and `.session/`, so the hooks and rules are shared but
   local Claude files and the session's scratch files aren't.
   From then on, every session start checks these against the playbook's
   `shared/setup.txt` and adds any missing hook or line itself.
4. Trim the project's CLAUDE.md to project-only rules (`templates/CLAUDE.md`):
   the generic ones now come from `.claude/rules/playbook.md`.
5. Commit and push to main.

**Helper repos** (a data store, saved sources, a tool, often written mostly
by a GitHub Action) get the same set-up, just smaller: every repo of the user's
follows the playbook, so a session there knows the rules. Skip SPEC, DESIGN
and ARCHITECTURE unless it needs them. CLAUDE.md says in a few lines what the
repo is, which project it serves, and what must never happen (for example
"private: never copy this into the public repo"). STATUS.md can be short.
Commits by Action bots (`…[bot]@…` authors) don't count as unrecorded work,
so a daily data run doesn't make every session update STATUS.md.

**Sessions with several repos.** Hooks only run in the repo the session was
opened in. Run `bash scripts/session.sh start` in each other repo before
changing it, so it pulls and syncs the playbook.

## Things we learned the hard way

- **Cloud sessions can't see the Mac's `~/.claude`, and don't load plugins**
  (Claude Code docs, Oct 2026). Anything Claude must know on the phone goes in
  the project's repo: its CLAUDE.md, or the synced `.claude/rules/playbook.md`.
- **The playbook repo is public** so any cloud session can sync from it.
  Keep private details out of it (see "Keeping the playbook current" in
  `shared/ai-dev-rules.md`).
- **Hooks may not fire in a cloud session that started before they were
  added**, and the device detection depends on `CLAUDE_CODE_REMOTE`. If there's
  no "Session start" output, run `scripts/session.sh start` by hand
  (on the phone: `CLAUDE_CODE_REMOTE=true bash scripts/session.sh start`).
- **Cloud sessions may be blocked from ordinary websites** by the
  environment's network policy (403 on connect). GitHub, package managers and
  connectors still work. If a project needs to fetch from the web, do the
  fetching in a **GitHub Action** (its runners have open internet) and have it
  commit results; the cloud session then just reads the repo.
- **A scheduled Action pushing to main** will make your next push fail with
  "fetch first". That's the bot, not the other device: `git fetch` + merge,
  then push.
- **Connectors** (Gmail, Google Drive, Calendar) work in cloud sessions if
  the user has connected them, read-only use first. Never paste API keys into the
  chat; they go in GitHub → Settings → Secrets.
- **Don't sit waiting on a slow job.** If an Action takes minutes, start a
  background watcher, carry on with other work, and tell the user what's running.
- **`pkill -f <pattern>` can kill your own shell** if the pattern appears in
  the command itself. Stop servers by port or job instead.
- **The Mac runs its own (possibly old) copy of `session.sh` before pulling**,
  so a session started with an outdated script can put back things the new
  one removed (an old lock file reappeared on main). Ignore `.session/` in
  `.gitignore` so old scripts can't commit it.
- **A lock between devices didn't survive parallel sessions** (Oct 2026).
  First a lock for the whole session blocked the phone all morning; then a
  lock held only during a reply worked for one phone and one Mac session. But
  it tracked devices, not sessions, so two Mac sessions never saw each other
  and one could free the lock while the other was mid-reply. And forcing
  every reply to push to main and rewrite STATUS.md made parallel sessions
  clash. Worktrees, own branches and git's refused pushes do the real job;
  the script now just shows other sessions' branches and checks nothing is
  lost. The original problem (a phone session's work never reached GitHub)
  is caught by the end-of-reply check, not a lock.
