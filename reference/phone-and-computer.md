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
   - Where we are, decisions (with why), open questions for Leo, and a
     **session log** with one line per session (date, device, what happened).
   - Read it at the start of every session; update it after every finished
     step, not just at the end.
2. **One branch: `main`.** Cloud sessions start on their own branch
   (`claude/...` or `ccr-...`). Land work on main with
   `git push origin HEAD:main`, and say so. If the harness also insists on its
   own branch being pushed, push both.
3. **A session lock** (`templates/scripts/session.sh`). It means **"Claude is
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
4. **Hooks** (`templates/.claude/settings.json`) make Claude Code run
   `start` when a session opens, `busy` on every message and `check` at the
   end of every reply, so nobody has to remember.

## Setting it up in a project

1. Copy `templates/STATUS.md` to `docs/STATUS.md` and fill it in.
2. Copy `templates/scripts/session.sh` to `scripts/session.sh`
   (`chmod +x scripts/session.sh`).
3. Copy `templates/.claude/settings.json` to `.claude/settings.json`, and make
   sure `.gitignore` has `.claude/*` then `!.claude/settings.json`, so the
   hooks are shared but local Claude files aren't.
4. Add the "Every session" section below to the project's CLAUDE.md.
5. Commit and push to main.

## Paste into the project's CLAUDE.md

```markdown
## Every session: start and finish with STATUS.md
Leo switches between his phone (cloud sessions) and his Mac. Neither can see
the other's conversation; the repo is the only shared memory.
`scripts/session.sh` enforces this, run automatically by hooks in `.claude/settings.json`.
- **The lock means "Claude is working on a reply right now".** It's claimed when
  Leo sends a message and released when the reply finishes cleanly, so an
  idle or closed session holds no lock. It lives on its own `session-lock` branch.
- If a message comes with `ANOTHER DEVICE IS WORKING`, **tell Leo straight
  away**; read-only work is fine, but change nothing until Leo confirms that
  reply has finished. Then run `scripts/session.sh busy --force`.
- If a push is rejected or a merge conflicts, stop and tell Leo. Never force-push.
  (Exception: a push rejected because the project's own GitHub Action pushed
  results is expected; pull/merge and carry on, and say so.)
- One branch: `main`. Push with `git push origin HEAD:main`.
- After every finished step: overwrite the Handover block in `docs/STATUS.md`,
  update "Where we are", decisions and open questions, add a session log line,
  commit, push.
- The lock frees itself at the end of each reply. `scripts/session.sh end`
  releases it by hand if a reply was cut off.
- If the hooks didn't run (no "Session start" output), run `scripts/session.sh start` yourself.
```

## Things we learned the hard way

- **Cloud sessions can't see the Mac's `~/.claude`.** Anything Claude must
  know on the phone goes in the project's own CLAUDE.md (or STATUS.md).
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
- **A lock held for the whole session was too blunt** (Sport Conditions,
  22 Oct): a Mac session left open blocked the phone all morning. Holding it
  only during a reply fixed that, and each message also pulls the latest main.
- **A phone session started while the desktop was active** caught the
  overlap via the lock warning. Respect it: read-only work is fine, changes wait
  for Leo's go-ahead.
