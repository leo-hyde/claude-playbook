# Decisions

One entry per decision, newest first. Each says what we decided, why, and
what we turned down, so a later session doesn't undo it by accident. If a
decision is reversed, add a new entry and mark the old one "Replaced by
<date>".

Words used here: a **repo** is a project's folder on GitHub; a **commit** is a
saved snapshot of the files; to **push** is to send commits to GitHub; the
**sync** is the script that copies the playbook's rules into each project when
a session opens; a **hook** makes Claude Code run a script automatically at a
set moment. More in [ARCHITECTURE.md](ARCHITECTURE.md).

## 27 Oct 2026: No session lock; own branches while working, main when a step is finished
- **What:** removed the lock from `shared/session.sh`. Session start now lists
  other sessions' unfinished branches. The end-of-reply check blocks in cloud
  sessions until work is on GitHub, but only reminds Leo on the Mac (the work
  is safe in its worktree). Docs are checked once work reaches main. Progress
  during a step goes in its spec; STATUS.md changes when a step is finished.
  The old `session-lock` branches get deleted (catch-up `2026-10-27-no-lock`).
- **Why:** Leo often runs several sessions on one project at once. The lock
  tracked devices, not sessions, so it couldn't see two Mac sessions, and one
  could free it while another was mid-reply. Forcing every reply to push to
  main and rewrite STATUS.md made parallel sessions clash. Git (worktrees,
  own branches, refused out-of-date pushes) already does the safety work, and
  Claude Code has no built-in cross-device lock.
- **Rejected:** a lock per session (still needs everyone to respect it, and
  costs two GitHub round trips on every message); one STATUS.md file per
  session (too many files to read).

## 26 Oct 2026: Suggest a fresh session for a change of work or clutter, not for length
- **What:** the Coaching rules now judge whether the conversation still helps the work at hand. A fresh session is suggested for a new piece of work or a cluttered context; a long but focused session carries on. The `COACH:` hook line asks Claude to judge rather than to suggest wrapping up. New: save state to STATUS.md before the app compacts the conversation.
- **Why:** a session was told it had "grown long" after 3 of Leo's messages, at 12% of its context window. The real reason was a change of topic. Message counts and sizes go stale as context windows and models grow; relevance doesn't. Leo asked for guidance that stays true as AI improves.
- **Rejected:** a higher message count or a context-percentage threshold (both go stale); dropping the hook (a periodic prompt to judge is still useful).

## 25 Oct 2026: Keep the docs true: a rule for which doc each change updates, and a check
- **What:** a "Keeping the docs true" section in the rules: each kind of
  change (plan, choice, step, structure) names the doc it updates, in the
  same commit. SPEC.md is now "the plan, in one place", with every step's
  status. The end-of-reply check blocks when `specs/` changed but SPEC.md
  didn't. A catch-up makes every project's SPEC.md match its plan once.
- **Why:** in AEC Tech Radar the plan changed (a new direction, written as a
  spec in `specs/`), but SPEC.md and decisions.md weren't updated. The rules
  listed what to record after a step, but not SPEC.md, and treated a spec as
  something written before building, not as the plan. Only STATUS.md was
  checked automatically, so that was the only doc kept current.
- **Rejected:** a separate Claude-only notes file (it would be a second copy
  of the plan, and drift the same way: the shared docs already are Claude's
  memory); blocking whenever any code changes without a doc change (too many
  false alarms, so it would be ignored); a scheduled doc audit (costs credits
  every time, and finds the problem late rather than stopping it).

## 25 Oct 2026: Every playbook change must reach existing projects
- **What:** a set-up list (`shared/setup.txt`) checked at every session
  start, which adds missing hooks and `.gitignore` lines itself. Checks of
  other repos attached to a cloud session. A louder warning when the sync
  can't reach GitHub. And a rule: any other change that existing files need
  gets a catch-up entry.
- **Why:** Leo asked how to make sure future playbook changes reach every
  repo. Before this, only three files updated themselves. A new hook or
  template change reached new projects only, and nothing said so.
- **Rejected:** copying `.claude/settings.json` over each project's own
  (it would wipe a project's own settings); a GitHub Action pushing to every
  project (rejected on 23 Oct: it needs a token that can change every repo).

## 25 Oct 2026: Act on a repo's open GitHub Issues; ask first for bigger ones
- **What:** GitHub Issues are to-do notes attached to a repo. When a session
  opens, Claude lists the open ones and tells Leo. After doing what Leo
  asked, it fixes the small, clear ones that Leo or his own apps opened,
  comments on each to say what changed, and closes it. Bigger ones (the same
  list as in the rule) wait for Leo's yes. Claude reports issues opened by
  anyone else, and never acts on them.
- **Why:** Leo asked for it. Issues are where his notes and his apps'
  feedback land, and small ones were waiting for him to ask.
- **Rejected:** acting on any issue (anyone can open one on a public repo,
  so its text is a request to weigh, not an instruction); fixing big ones
  without asking (they need Leo's review); a script that lists issues when a
  session opens (private repos need a GitHub login the script may not have).

## 24 Oct 2026: Fix small problems found along the way; ask first for bigger ones
Replaced by 25 Oct 2026: Leo meant GitHub Issues, not any problem Claude spots.

## 24 Oct 2026: Every repo follows the playbook, helper repos included
- **What:** every repo of Leo's gets the playbook set-up. Helper repos (data
  stores, saved sources, tools) get a smaller version. Claude offers to set
  up any repo it finds without it. Commits made by GitHub Action robots no
  longer count as work that needs a status update. The playbook applies its
  own rules and catch-ups to itself.
- **Why:** a helper repo made from another project's session was never set
  up, so no rule change ever reached it, and sessions working there had no
  rules.
- **Rejected:** a list of repo types that are exempt (each exemption is a gap
  someone has to remember); a script that checks all Leo's repos (it needs
  GitHub access a session may not have; the rule plus the offer covers it).

## 24 Oct 2026: The sync runs its new version straight after updating itself
- **Why:** the catch-up check came in a new version of the sync script, but
  the old version was the one running that session. So the reminder came one
  session late.
- **Rejected:** a rule telling Claude to run it again (that would cost a line
  in every session, for a one-off).

## 24 Oct 2026: Catch-ups, so a new rule reaches files projects already have
- **What:** `shared/catch-up.md` lists rule changes that existing files need
  too. When a session opens, the sync prints any entry the project hasn't
  yet recorded in its `docs/playbook-catch-up.md`, until it does.
- **Why:** the plain-English rule reached every project, but it only changed
  what Claude wrote next. Nobody rewrote the existing docs: the rule read as
  a style for new writing, and nothing asked for the old files.
- **Rejected:** relying on Claude to remember (it didn't); a script that
  rewrites docs by itself (it needs judgement, and Leo's review); adding the
  catch-up to each project's STATUS.md by hand (projects get missed).

## 24 Oct 2026: A "Writing for people" rule: UK plain English everywhere a person reads
- **Why:** Leo said he couldn't follow what Claude was doing: replies were
  full of jargon. One short section in the shared rules now reaches every
  project, with a set shape for end-of-task summaries.
- **Rejected:** a long style guide in `reference/` (Claude reads that only
  when needed, so it wouldn't shape every reply).

## 23 Oct 2026: Warn when a repo turns public; Leo's email out of commits
- **Why:** Leo's projects mix public and private repos, and he may make one
  public later. `session.sh` spots the change, and the rules make Claude
  check the files and their history with Leo. Commits now use Leo's GitHub
  "noreply" address instead of his real email.
- **Rejected:** rewriting history to remove the email from old commits. That
  needs a force-push (overwriting the copy on GitHub) on every repo. It's
  Leo's call, and not done.

## 23 Oct 2026: The playbook repo is public
- **Why:** Leo's call, so every cloud session can sync the shared rules
  without the playbook being attached. Claude checks each change for private
  details and asks Leo before pushing anything doubtful.
- **Rejected:** staying private (phone sessions would often run on an old copy).

## 23 Oct 2026: The shared rules sync into each project as a saved copy
- **Why:** Leo wants to update the playbook once and have every project
  follow, on phone and Mac. A copy in `.claude/rules/playbook.md`, refreshed
  by the hook when a session opens, works in cloud sessions and offline, and
  shows in git's history.
- **Rejected:** a Claude Code plugin, an official add-on package (cloud
  sessions don't load plugins); an import line in CLAUDE.md pointing to
  `~/.claude/...` (that folder only exists on the Mac); a GitHub Action
  pushing to every project (it needs a password-like token that can change
  every repo, and more can go wrong).

## 23 Oct 2026: The rules tell Claude to coach Leo without being asked
- **Why:** Leo asked for nudges on session length, mixed topics and credit
  use. A message counter in `session.sh` makes the length nudge reliable,
  rather than leaving it to Claude's judgement.
- **Rejected:** a hard block on long sessions (too blunt; Leo decides).

## 23 Oct 2026: Documents follow "each fact in one place"
- **Why:** Anthropic's best-practice guide says: keep CLAUDE.md short and
  stable; plan first, then build in a fresh session. So STATUS.md holds the
  current state only (no session diary: git's history is the record),
  decisions move to `docs/decisions.md`, and bigger features get their own
  plan in `specs/<feature>.md`.
- **Rejected:** a hand-kept changelog in every project (commit messages do
  the job; Sport Conditions keeps its own for feedback).

## 22 Oct 2026: The session lock is held only while Claude is replying
- **Replaced by 27 Oct** (no lock at all).
- **Why:** a Mac session left open blocked the phone all morning.
- **Rejected:** a lock for the whole session.

## 22 Oct 2026: Explain the work with walkthroughs and ARCHITECTURE.md, not "try this"
- **Why:** Leo learns by reviewing the work like a colleague's, not by tinkering.
