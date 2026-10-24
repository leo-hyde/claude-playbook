# Decisions

One entry per decision, newest first. If one is reversed, add a new entry and
mark the old one "Replaced by <date>".

## 24 Oct 2026: Every repo follows the playbook, helper repos included
- **What:** every repo of Leo's gets the playbook set-up, with a smaller
  version for helper repos (data stores, saved sources, tools). Claude offers
  to set up any repo it finds without it. Action bots' commits no longer count
  as work needing a STATUS update. The playbook applies its own rules and
  catch-ups to itself.
- **Why:** a helper repo made from another project's session was never set
  up, so no rule change ever reached it; sessions working there had no rules.
- **Rejected:** a list of "exempt" repo types (each exemption is a gap that
  has to be remembered); a script that checks all Leo's repos (needs GitHub
  access a session may not have; the rule plus the offer covers it).

## 24 Oct 2026: Fix small problems found along the way; ask first for bigger ones
- **What:** Claude fixes small problems it finds (broken link, stale doc,
  typo, failing check) in their own commit and lists them; anything that
  changes behaviour, deletes data, costs money, touches secrets or public
  content, undoes a decision, or is more than a small step waits for Leo.
- **Why:** Leo asked for it (24 Oct 2026): obvious fixes shouldn't wait a
  round trip, but bigger changes still need his review.
- **Rejected:** fixing everything found (big changes need Leo's review);
  only reporting (wastes a round trip on obvious fixes).

## 24 Oct 2026: The sync runs its new self after updating itself
- **Why:** the catch-up check arrived in a new version of the sync script,
  but the old version ran that session, so the reminder came one session late.
- **Rejected:** a rule telling Claude to re-run it (costs a line in every
  session for a one-off).

## 24 Oct 2026: Catch-ups, so a new rule reaches files projects already have
- **What:** `shared/catch-up.md` lists rule changes that existing files need
  too. At session start, `playbook-sync.sh` prints any entry a project hasn't
  recorded in its `docs/playbook-catch-up.md`, until it does.
- **Why:** the plain-English rule synced into every project but only changed
  what Claude wrote next; nobody rewrote the existing docs, because the rule
  read as a style for new writing and nothing asked for the old files.
- **Rejected:** relying on Claude to remember (it didn't); a script that
  rewrites docs by itself (needs judgement, and Leo's review); writing the
  catch-up into each project's STATUS.md by hand (misses projects).

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
