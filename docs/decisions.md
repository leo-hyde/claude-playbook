# Decisions

One entry per decision, newest first. If one is reversed, add a new entry and
mark the old one "Replaced by <date>".

## 24 Oct 2026: A "Writing for people" rule: UK plain English everywhere a person reads
- **Why:** Leo said he couldn't follow what Claude was doing: replies were
  full of jargon. One short section in the shared rules now reaches every
  project, with a fixed shape for end-of-task summaries.
- **Rejected:** a long style guide in `reference/` (read on demand, so it
  wouldn't shape every reply).

## 23 Oct 2026: Warn when a repo turns public; Leo's email out of commits
- **Why:** Leo's projects mix public and private repos and he may make one
  public later. `session.sh` detects the change and the rules make Claude
  review files and history with Leo. Commits use Leo's GitHub noreply address.
- **Rejected:** rewriting history to remove the email from old commits (a
  force-push on every repo; Leo's call, not done).

## 23 Oct 2026: The playbook repo is public
- **Why:** Leo's call, so every cloud session can sync the shared rules
  without the repo being attached. Claude checks each change for private
  details and asks Leo before pushing anything doubtful.
- **Rejected:** staying private (phone sessions would often run on an old copy).

## 23 Oct 2026: Shared rules sync into each project as a committed copy
- **Why:** Leo wants to update the playbook once and have every project
  follow, on phone and Mac. A copy in `.claude/rules/playbook.md`, refreshed
  by the session-start hook, works in cloud sessions, offline, and is visible
  in git.
- **Rejected:** a Claude Code plugin (cloud sessions don't load plugins);
  `@~/.claude/...` imports (Mac only); a GitHub Action pushing to every
  project (needs a token with write access to all repos, more to go wrong).

## 23 Oct 2026: The rules tell Claude to coach Leo unprompted
- **Why:** Leo asked for proactive nudges on session length, mixed topics and
  credit use. A message counter in `session.sh` makes the length nudge
  reliable rather than left to Claude's judgement.
- **Rejected:** a hard block on long sessions (too blunt; Leo decides).

## 23 Oct 2026: Documents follow "each fact in one place"
- **Why:** Anthropic's best-practice guide: keep CLAUDE.md short and stable;
  spec first, then build in a fresh session. STATUS.md becomes current state
  only (no session log; git log is the history); decisions move to
  `docs/decisions.md`; bigger features get `specs/<feature>.md`.
- **Rejected:** a hand-kept changelog everywhere (commit messages do the job;
  Sport Conditions keeps its own for feedback).

## 22 Oct 2026: The session lock is held only while Claude is replying
- **Why:** a Mac session left open blocked the phone all morning.
- **Rejected:** a lock for the whole session.

## 22 Oct 2026: Explain the work by walkthroughs and ARCHITECTURE.md, not "try this"
- **Why:** Leo learns by reviewing the work like a colleague's, not by tinkering.
