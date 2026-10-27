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

## 28 Oct 2026: Good UX by default, and a style library, in the playbook
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
