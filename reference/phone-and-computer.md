# Working from phone and computer on the same project

Leo switches between his phone (Claude Code cloud sessions at claude.ai/code)
and his Mac. **Neither session can see the other's conversation. The GitHub
repository is the only shared memory.** This page is how we keep the two in
step. It was worked out on JobSeekHelper (Oct 2026), after a phone session and
a desktop session ran at the same time and the phone's work never reached
GitHub.

## The four parts

1. **`docs/STATUS.md`**, the live record (template: `templates/STATUS.md`).
   - A **Handover block** at the top that every session *overwrites*: which
     device, did it end cleanly, anything half-done, the next step.
   - Where we are, next steps and open questions for Leo. **Current state
     only**: decisions go in `docs/decisions.md`, history is `git log`.
     (Until Oct 2026 it also held a session log; it grew to 100+ lines that
     every session re-read, so it was dropped.)
   - Read it at the start of every session; update it after every finished
     step, not just at the end.
2. **One branch: `main`.** Cloud sessions start on their own branch
   (`claude/...` or `ccr-...`). Land work on main with
   `git push origin HEAD:main`, and say so. If the harness also insists on its
   own branch being pushed, push both.
3. **A session lock** (`shared/session.sh`). It means **"Claude is
   working on a reply right now"**, not "a session is open": an idle or closed
   session holds no lock. It's a small file on its own `session-lock` branch,
   so it doesn't clutter main's history or republish the site. It works
   because GitHub refuses a push that doesn't build on the latest version of
   a branch, so two devices can't both claim it.
   - `session.sh start` (session opens): pulls main, **warns if the other
     device is mid-reply**, prints the Handover block. Claims nothing.
   - `session.sh busy` (Leo sends a message): pulls main, warns or claims the lock.
   - `session.sh check` (a reply finishes): refuses to let it finish with
     uncommitted work, commits not on GitHub, or work done since STATUS.md
     was last updated; otherwise **releases the lock**.
   - `session.sh end`: releases it by hand if a reply was cut off.
   - A busy lock older than 2 hours is treated as left behind by a crash.
   - `busy` also counts Leo's messages and every 15 prints a `COACH:` line,
     so Claude suggests a fresh session when one gets long.
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
3. Copy `templates/.claude/settings.json` to `.claude/settings.json`, and make
   sure `.gitignore` has `.claude/*`, `!.claude/settings.json`,
   `!.claude/rules/` and `.session/`, so the hooks and rules are shared but
   local Claude files and the session's scratch files aren't.
4. Trim the project's CLAUDE.md to project-only rules (`templates/CLAUDE.md`):
   the generic ones now come from `.claude/rules/playbook.md`.
5. Commit and push to main.

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
  Leo has connected them, read-only use first. Never paste API keys into the
  chat; they go in GitHub → Settings → Secrets.
- **Don't sit waiting on a slow job.** If an Action takes minutes, start a
  background watcher, carry on with other work, and tell Leo what's running.
- **`pkill -f <pattern>` can kill your own shell** if the pattern appears in
  the command itself. Stop servers by port or job instead.
- **The Mac runs its own (possibly old) copy of `session.sh` before pulling**,
  so a session started with an outdated script can put back things the new
  one removed (an old lock file reappeared on main). Ignore `.session/` in
  `.gitignore` so old scripts can't commit it.
- **A lock held for the whole session was too blunt** (Sport Conditions,
  22 Oct): a Mac session left open blocked the phone all morning. Holding it
  only during a reply fixed that, and each message also pulls the latest main.
- **A phone session started while the desktop was active** caught the
  overlap via the lock warning. Respect it: read-only work is fine, changes wait
  for Leo's go-ahead.
