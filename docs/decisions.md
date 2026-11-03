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

## 3 Nov 2026: The playbook runs on PLAN.md and pull requests too (agreed)
- **What:** the playbook's README is the front door, `PLAN.md` holds every
  feature by state, `docs/STATUS.md` is retired (its next steps moved to
  PLAN.md, its open question here), and playbook work goes through pull
  requests that Claude merges when the tests pass.
- **Why:** the user asked (3 Nov) for the new way of working to apply to the
  playbook itself; it is step 4 of the plan, brought forward.
- **Rejected:** waiting for the pilot (the playbook is where the rules are
  made, so it should use them first).

## 3 Nov 2026 (asked 30 Oct): Apps that don't look AI-made: four choices (proposed)
- **Recommendation** (`specs/distinctive-design.md`, "Decisions for the
  user"): retire `clear` as the automatic default; re-tune `paper`, `ledger`
  and `night` (new font and accent); show the blind test to some who said the
  apps look AI-made, plus a couple who haven't seen them; restyle Sport
  Conditions only, as the trial.
- **Options:** keep `clear` as the default; drop the three styles; restyle
  every app. Recorded here 3 Nov so session start lists it.

## 3 Nov 2026: How we run projects: PLAN.md, pull requests, methods, five-line replies (agreed)
- **What:** step 1 of a plan the user agreed (in a private project, 3 Nov):
  each repo answers each question in one place: README (front door),
  PLAN.md (every feature, grouped Now / Next / Later / Paused / Done /
  Dropped; replaces SPEC.md), specs, decisions.md (every decision and change
  of mind, proposed or agreed) and AGENTS.md (pointers only). Work in
  progress is an open pull request, labelled `paused` when stopped, merged
  by Claude when checked. STATUS.md is retired. Three methods in `methods/`.
  Session start lists open pull requests (soft limit 5, paused included),
  paused ones over two weeks, branches without one at any age, and proposed
  decisions. Replies lead with at most five lines. A "Concise for Leo"
  output style for Mac sessions.
- **Why:** facts were spread over long documents that disagreed, features
  the user wanted got lost from specs, and unfinished branches went
  unnoticed. Each part follows a named practice: README, Scrum's product
  backlog, Now/Next/Later, Definition of Done, decision records (Nygard),
  GitHub flow, Kanban work-in-progress limits, Anthropic's feature list.
- **The end-of-reply check now blocks on the Mac too** (replaces part of the
  27 Oct entry: the Mac only reminded). **Why:** the plan says unfinished
  work must always be visible on GitHub; a reminder was easy to miss.
- **Older projects keep working:** the scripts check SPEC.md and STATUS.md
  until a project has a PLAN.md. **Why:** the plan pilots on one project
  for a week before rolling out; a catch-up moves the others after that.
- **Rejected:** a drag-and-drop GitHub board (only if the list proves too
  hard); draft pull requests (private repos need a paid plan); a hook on
  reply length (the style and the rule first; "too long" tightens them).

## 3 Nov 2026: Agile delivery is written down as a reference page, not a new rule
- **What:** `reference/agile-delivery.md` names how the playbook already works
  (short cycles, an ordered list, done means checked, a look-back) and adds a
  work-in-progress limit, a swap rule and a scheduled look-back. Default: a
  light hybrid. Proposed; adjust after real use.
- **Why:** the user asked to formalise habits the playbook already has; it
  came from a consulting project that needs to reuse it.
- **Rejected:** a line in `ai-dev-rules.md` (it is at 144 of its 150 lines, and
  a change there needs the fixed test tasks run first); full Scrum.

## 2 Nov 2026: No canary or releases for now; projects read the playbook's main
**What:** every project syncs from the playbook's `main` (the default in
`shared/playbook-sync.sh`); one last release (`release-2026-11-02`) moves
projects still on `stable` over. The release machinery stays, unused: a
project's `.claude/playbook-channel` reading `stable` still gets only releases.
**Why:** the user: changes have worked so far, undo (a revert on `main`) is
easy, and waiting for a canary session slowed work down and left changes
unreleased. **Rejected:** deleting `scripts/release.sh` and the channel code
(more change to frozen scripts, and harder to bring back). **Bring releases
back if** a playbook change breaks projects, or the same fix has to be
undone in several projects: change the default channel back to `stable`,
give the canary a `.claude/playbook-channel` reading `main`, and follow the
release steps in this repo's git history (AGENTS.md before 2 Nov). Replaces
the canary/stable part of 27 Oct's releases decision.

## 2 Nov 2026: AGENTS.md is each project's main rules file
**What:** a project's own rules live in `AGENTS.md`; `CLAUDE.md` is one
`@AGENTS.md` import (plus anything only for Claude Code). AGENTS.md tells
other tools to read the synced `.claude/rules/playbook.md` and `owner.md`
too. Templates changed; catch-up `2026-11-02-agents-md` moves existing
projects; the playbook did the same. **Why:** the playbook will be used with
other people and non-Claude AI tools, and Claude Code reads AGENTS.md only
through an import. **Rejected:** a pointer AGENTS.md beside CLAUDE.md (two
files to keep in step); copying the full rules into AGENTS.md through the
sync (a change to frozen scripts, and 144 lines duplicated). **Weak spot:**
other tools must open the two rules files they're pointed to.

## 2 Nov 2026: Rules pruned against Anthropic's best-practices page
**What:** "Using tokens well" rewritten to match Anthropic's "What you can
stop doing": no more "search, don't read whole files; cap output" or
"finish the agreed step in one go"; subagents are for parallel work, noisy
output or a fresh review, not to save context or get a better answer. Bold
emphasis inside sentences removed (the page: emphasis makes Claude
over-apply a rule). ARCHITECTURE.md holds only what the code doesn't show.
150 → 143 lines. **Checked** with four fixed test tasks before and after
(`tests/rule-tasks.md`): 19/20 before, 18/20 after; the one lost point
(task 3, committing before warning about a secret) was lost the same way by
the old rules on a rerun, so it is noise, not the prune.
**Why:** decision 1 of `docs/off-the-shelf-review.md`. **Rejected:** cutting
"Keep the context to what the task needs" entirely (bulk data still goes to a
file: Anthropic still backs keeping noisy output out of the conversation);
moving situational rules out now (that is the skills step, next).

## 2 Nov 2026: Keep the playbook; borrow standards, don't install frameworks
The user decided, from `docs/off-the-shelf-review.md` (a comparison with
off-the-shelf tools, sources checked 2 Nov).
- **Agreed as recommended:** prune the rules against Anthropic's
  best-practices page, with fixed test tasks before and after; then move
  situational rules into skills; freeze the sync scripts and measure what
  each check caught before cutting; review the Google Docs pipeline in the
  project that uses it; don't install Spec Kit, BMAD, Kiro, Superpowers,
  Copier or the `@claude` GitHub workflow; Vale later.
- **AGENTS.md: adopt** (reverses the note's "no"). **Why:** the playbook will
  be used with other people and non-Claude AI tools.
- **Anthropic's best-practices page is checked at every monthly review**
  (`reference/efficient-sessions.md`). **Why:** Anthropic updates it, and it
  already retired some of the rules' token-saving habits.
- **Client work gets a written AI-use and client-data rule** at kick-off
  (`reference/document-projects.md`, SKILL.md). **Why:** professional bodies
  now require one, and client contracts decide which tools may be used.
- **Rejected:** replacing the sync with plugins (cloud sessions don't
  install a project's plugins) or Copier (needs Python 3.10+, run by hand).

## 30 Oct 2026: Six habits from a document-heavy project, on main
The user asked which ways of working from a recent consulting project
(mostly research, position papers and team reviews in Google Docs) would help
every project; they agreed all six (30 Oct).
- **Session start lists people's edits and notes to Claude** (`doc_edits` in
  `shared/session.sh`): a document commit without the "Co-Authored-By:
  Claude" line, in the last 30 days, after Claude's last commit to that file;
  and `> To Claude` lines. Prints nothing when there is nothing, so the
  session-start budget is untouched in most sessions. **Why:** it ran in that
  project for two days and caught edits made on github.com. **Rejected:** a
  separate synced script (another file and hook for every project).
- **`reference/team-review.md`**: review rounds in Google Docs with the repo
  file as master; the "How to edit" line on every Google file Claude makes.
- **`reference/document-projects.md`**: set-up changes for a project that is
  mostly documents; pointed to from the kick-off in SKILL.md.
- **The facts rule covers effort** (rules file, same two lines): estimates
  come from how long similar work took. **Why:** build estimates there were
  3–4 times too high until checked against the git log.
- **A retrospective after a long piece of work** (`reference/efficient-sessions.md`).
- Not taken: brand styles for documents and decks (issue #10 already covers
  it); project-only content.

## 27 Oct 2026: Good UX by default, and a style library, in the playbook
Built from `specs/design-and-styles.md`, with every recommendation in its
"Decisions for the user" (the user: "just do it", 27 Oct).
- **It lives in the playbook, in files read only when needed** (`styles/`,
  `reference/design-method.md`, `design-review.md`, `client-style.md`).
  Nothing is added to the rules file or any description loaded at session
  start. **Rejected:** a separate repo (another thing to attach, sync and
  release, for no saving).
- **A UX method in seven layers** (purpose, structure, patterns, words, look,
  accessibility, checking). The method says how to design; the checklist
  says what to check; no rule is in both. **Why:** apps were getting
  cluttered and technical, and the old checklist only caught that after
  building. The "What's on screen" section in each feature spec sorts
  features into main screen, one tap, Settings or later before building.
- **Six styles in the library, 13 in the gallery.** Claude picked the six
  (`clear`, `paper`, `ledger`, `field`, `nord`, `night`) for variety and
  calm, as the user was asleep; the user can swap any of them by setting
  `in_library` in `styles/candidates.json`. **Rejected:** flashy styles, and
  the warm-cream-and-serif look (the commonest "AI-made" look).
- **One source for styles** (`styles/candidates.json`) with a tool that builds
  the files and checks contrast, run by the tests. The template's colours
  are built from the `clear` style. **Why:** the first check found nine
  colour pairs under 4.5:1 that looked fine by eye.
- **A `--link` colour token**, separate from `--accent`. **Why:** bright
  button colours (amber, emerald) are unreadable as link text on white.
- **Third-party design skills are read, not installed** (Anthropic's
  frontend-design, Vercel's guidelines, Impeccable): their ideas are in the
  method, in our words, with credit. **Why:** nothing unreviewed runs in the
  user's sessions.
- **The page check fetches axe-core with curl from cdnjs, jsdelivr or npm**,
  whichever the network allows. **Why:** cloud environments block different
  hosts; this one blocked both CDNs.
- **The gallery is a private page**, not GitHub Pages. **Why:** publishing
  it needed no settings change, and the user can view it on the phone now.
  GitHub Pages for the playbook stays an option.

## 27 Oct 2026: Second release: tokens used well, a shareable playbook, ideas as issues
Built from `specs/efficient-sessions.md`, the rest of
`specs/shareable-playbook.md` and part 4 of `specs/playbook-releases.md`,
with every recommendation in their "Decisions for the user" (the user's yes, 27 Oct).
- **Cost measured, not counted:** `session.sh busy` reads the transcript and
  compares the latest context with the first; notes at 3× and 6×, and a
  cold-cache note after 55 minutes when over 2×. **Why:** a message count
  said nothing about cost; the ratio doesn't go stale when prices or windows
  change. **Rejected:** absolute token limits (they go stale).
- **Docs checked at push-to-main, not end of reply:** a `PreToolUse` hook
  refuses a push to main without STATUS.md (and SPEC.md if `specs/`
  changed). The end-of-reply check now blocks only for lost work. **Why:**
  the old block forced a whole extra turn; mid-turn, Claude just adds the
  docs. **Rejected:** dropping the docs check (stale docs mislead the next session).
- **Short replies for small changes**; the five-part summary for finished steps.
- **Fix now, stop and tell, or file an issue** (`claude-found`), filed by
  Claude without asking. **Why:** filing while the evidence is at hand is
  cheap, and a later session can batch them on a suitable model.
- **Ideas for the playbook are issues** (`idea`) on the playbook repo, not
  edits from project sessions. **Why:** a project session knows one project,
  not how a change lands in the others; issues get batched and released.
- **`scout` (Haiku) and `checker` (Sonnet) subagents** synced into every
  project, and an `opusplan` trial as the canary's default model. Whether
  project subagents load in cloud sessions is not yet tested: the rules work
  without them (a per-call `model`).
- **Catch-ups print one line each**; Claude reads the entry itself.
- **Rules trimmed to 149 lines**, now a hard 150-line test. Owner details
  moved to `owner/profile.md`, synced as `.claude/rules/owner.md`; the public
  repo and git detail moved to `reference/`. Every rule's place is listed in
  the efficient-sessions spec's Progress section.
- **Shareable:** `shared/` says "the user"; `PLAYBOOK_URL` (top of
  `playbook-sync.sh`) is the only owner line there; MIT licence (the user's
  choice: one licence for code and text); `personal-CLAUDE.md` moved to `owner/`.

## 27 Oct 2026: The session script checks the session's own folder, from the hook's `cwd`
- **What:** `session.sh` reads `cwd` from the hook's JSON input. If it's a
  worktree of the same repo, the checks run there, with that worktree's copy
  of the script. Session start fast-forwards a clean main checkout on `main`.
- **Why:** Claude Code runs hooks from the folder the session started in,
  not the worktree (its docs, checked 27 Oct), so the end check judged the
  wrong files.
- **Rejected:** changing each project's hook command (needs a catch-up in
  every project, and `$CLAUDE_PROJECT_DIR` still wouldn't point at the worktree).

## 27 Oct 2026: Changes reach projects through releases, tried first in a canary
- **What:** projects sync from the playbook's `stable` branch, which only
  moves when `scripts/release.sh` releases `main` (tests pass, a
  `RELEASES.md` note exists, the user says yes). Sport Conditions is the
  canary: its `.claude/playbook-channel` reads `main`, so it gets every change
  first. Releases at most about weekly, after at least one problem-free
  canary session; a broken script is released straight away. Until `stable`
  exists, the sync falls back to `main`, so old and new scripts both work.
  Kept tests (`tests/run.sh`) run on Linux and macOS on every push.
- **Why:** every push used to reach every project at once, untested, one
  change at a time. Details: `specs/playbook-releases.md`.
- **The channel file is added with `git add -f`**, because projects ignore
  `.claude/*`. Rejected: a `!.claude/playbook-channel` line in `setup.txt`,
  which would add a set-up commit to every project for one project's file.
- **The rules-size test is a ratchet for now:** it fails if
  `shared/ai-dev-rules.md` grows past its size on 27 Oct (197 lines). It
  becomes a hard 150-line limit once the rules are trimmed (session 2).
- **Rejected:** version numbers (dates are enough for one owner); an Action
  that pushes into projects (it needs a token that can change every repo).

## 27 Oct 2026: The playbook says "the user"; owner details go in `owner/`
- **What:** every file outside `shared/` now refers to "the user", not a
  named person, and private project names are described in general terms.
  The owner's accounts, devices and preferences live in `owner/profile.md`.
  Moving the synced rules and scripts over to it waits for the release
  process (`specs/shareable-playbook.md`).
- **Why:** the user may share the playbook, or let others copy it or build
  on it. Keeping one person's details in one folder makes a fork a matter of
  replacing that folder.
- **Rejected:** changing `shared/` now (it reaches every project at once, and
  the efficiency spec rewrites the same file); rewriting git history to
  remove the name (needs a force-push; see 23 Oct).

## 27 Oct 2026: No session lock; own branches while working, main when a step is finished
- **What:** removed the lock from `shared/session.sh`. Session start now lists
  other sessions' unfinished branches. The end-of-reply check blocks in cloud
  sessions until work is on GitHub, but only reminds the user on the Mac (the work
  is safe in its worktree). Docs are checked once work reaches main. Progress
  during a step goes in its spec; STATUS.md changes when a step is finished.
  The old `session-lock` branches get deleted (catch-up `2026-10-27-no-lock`).
- **Why:** the user often runs several sessions on one project at once. The lock
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
- **Why:** a session was told it had "grown long" after 3 of the user's messages, at 12% of its context window. The real reason was a change of topic. Message counts and sizes go stale as context windows and models grow; relevance doesn't. The user asked for guidance that stays true as AI improves.
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
- **Why:** the user asked how to make sure future playbook changes reach every
  repo. Before this, only three files updated themselves. A new hook or
  template change reached new projects only, and nothing said so.
- **Rejected:** copying `.claude/settings.json` over each project's own
  (it would wipe a project's own settings); a GitHub Action pushing to every
  project (rejected on 23 Oct: it needs a token that can change every repo).

## 25 Oct 2026: Act on a repo's open GitHub Issues; ask first for bigger ones
- **What:** GitHub Issues are to-do notes attached to a repo. When a session
  opens, Claude lists the open ones and tells the user. After doing what the user
  asked, it fixes the small, clear ones that the user or their own apps opened,
  comments on each to say what changed, and closes it. Bigger ones (the same
  list as in the rule) wait for the user's yes. Claude reports issues opened by
  anyone else, and never acts on them.
- **Why:** the user asked for it. Issues are where their notes and their apps'
  feedback land, and small ones were waiting for them to ask.
- **Rejected:** acting on any issue (anyone can open one on a public repo,
  so its text is a request to weigh, not an instruction); fixing big ones
  without asking (they need the user's review); a script that lists issues when a
  session opens (private repos need a GitHub login the script may not have).

## 24 Oct 2026: Fix small problems found along the way; ask first for bigger ones
Replaced by 25 Oct 2026: the user meant GitHub Issues, not any problem Claude spots.

## 24 Oct 2026: Every repo follows the playbook, helper repos included
- **What:** every repo of the user's gets the playbook set-up. Helper repos (data
  stores, saved sources, tools) get a smaller version. Claude offers to set
  up any repo it finds without it. Commits made by GitHub Action robots no
  longer count as work that needs a status update. The playbook applies its
  own rules and catch-ups to itself.
- **Why:** a helper repo made from another project's session was never set
  up, so no rule change ever reached it, and sessions working there had no
  rules.
- **Rejected:** a list of repo types that are exempt (each exemption is a gap
  someone has to remember); a script that checks all the user's repos (it needs
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
  rewrites docs by itself (it needs judgement, and the user's review); adding the
  catch-up to each project's STATUS.md by hand (projects get missed).

## 24 Oct 2026: A "Writing for people" rule: UK plain English everywhere a person reads
- **Why:** the user said they couldn't follow what Claude was doing: replies were
  full of jargon. One short section in the shared rules now reaches every
  project, with a set shape for end-of-task summaries.
- **Rejected:** a long style guide in `reference/` (Claude reads that only
  when needed, so it wouldn't shape every reply).

## 23 Oct 2026: Warn when a repo turns public; the user's email out of commits
- **Why:** the user's projects mix public and private repos, and the user may make one
  public later. `session.sh` spots the change, and the rules make Claude
  check the files and their history with the user. Commits now use the user's GitHub
  "noreply" address instead of their real email.
- **Rejected:** rewriting history to remove the email from old commits. That
  needs a force-push (overwriting the copy on GitHub) on every repo. It's
  the user's call, and not done.

## 23 Oct 2026: The playbook repo is public
- **Why:** the user's call, so every cloud session can sync the shared rules
  without the playbook being attached. Claude checks each change for private
  details and asks the user before pushing anything doubtful.
- **Rejected:** staying private (phone sessions would often run on an old copy).

## 23 Oct 2026: The shared rules sync into each project as a saved copy
- **Why:** the user wants to update the playbook once and have every project
  follow, on phone and Mac. A copy in `.claude/rules/playbook.md`, refreshed
  by the hook when a session opens, works in cloud sessions and offline, and
  shows in git's history.
- **Rejected:** a Claude Code plugin, an official add-on package (cloud
  sessions don't load plugins); an import line in CLAUDE.md pointing to
  `~/.claude/...` (that folder only exists on the Mac); a GitHub Action
  pushing to every project (it needs a password-like token that can change
  every repo, and more can go wrong).

## 23 Oct 2026: The rules tell Claude to coach the user without being asked (counter replaced by cost notes, 27 Oct)
- **Why:** the user asked for nudges on session length, mixed topics and credit
  use. A message counter in `session.sh` makes the length nudge reliable,
  rather than leaving it to Claude's judgement.
- **Rejected:** a hard block on long sessions (too blunt; the user decides).

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
- **Why:** the user learns by reviewing the work like a colleague's, not by tinkering.
