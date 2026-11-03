# The playbook: the plan

Updated 3 Nov 2026. The one place that says what the playbook is for, what's
done and what's next. In progress or paused: the open
[pull requests](https://github.com/leo-hyde/claude-playbook/pulls). Why, and
what's waiting on the user: [docs/decisions.md](docs/decisions.md).

<!-- Rules for this file (for Claude): every feature, built or not, one line
each, grouped by state; it moves between groups, never deleted. Change it
with the work (the pull request that does it). A change of mind also goes in
docs/decisions.md. Before changing a spec, list every feature under its
objective and ask the user to confirm nothing is missing. -->

## Goal
The user builds apps and documents with Claude that they understand, that
are safe and good, and that cost little, the same way in every repo, from a
phone or a Mac. Success: in any repo, the user can say in two minutes what it
must do, how far through it is and what's open.

## Objectives
1. **One way of working everywhere:** shared rules and checks reach every
   repo by themselves, and every repo follows them.
2. **Phone and Mac in step:** several sessions at once never lose or hide work.
3. **Clear, short documents and replies:** each question has one home; the
   user can follow everything.
4. **Good apps:** screens are designed on purpose and checked.
5. **Sessions cost little:** context kept small, the right model for the job.
6. **Anyone can copy it:** owner details apart, public-safe, MIT licence.

## Features
Each line: **name** (objective): what it should do. Links to the spec or issue.

### Now
- **How we run projects, step 2: pilot** (3): one project runs on README,
  PLAN.md and pull requests for about a week; then step 3, a look-back and a
  catch-up that moves the other projects over. Includes testing whether a
  cloud session loads an output style kept in the repo.

### Next
- **Tidy old branches and working copies** (2): one repo at a time, with the
  user's yes each time; turn on "delete branch after merge". Includes Sport
  Conditions' old `session-lock` branch, this repo's merged branches, and the
  consulting project's own `scripts/doc-edits.sh` hook (now in the playbook).
- **Overconfidence check in research-to-doc** (3): before a document goes
  out. [#13](https://github.com/leo-hyde/claude-playbook/issues/13)
- **Public-repo secret check as a hook** (6): not just a rule.
  [#12](https://github.com/leo-hyde/claude-playbook/issues/12)
- **Push check sees doc changes inside a merge commit** (1).
  [#11](https://github.com/leo-hyde/claude-playbook/issues/11)
- **Session start in the desktop app's worktree** (2): runs in the main
  checkout today. [#7](https://github.com/leo-hyde/claude-playbook/issues/7)
- **Cloud subagents** (5): test that `.claude/agents/` load in a cloud
  session; if not, stop syncing them.
- **Monthly cost review** (5): the first one, against the 27 Oct figures
  (`reference/efficient-sessions.md`).
- **The Mac's notes** (1): copy `owner/personal-CLAUDE.md` over
  `~/.claude/CLAUDE.md` (they differ), keeping the Mac's real folder path.

### Later
- **Situational rules as skills** (5): move rules only some sessions need
  into skills, synced like the subagents (2 Nov review).
- **Count what each check has caught** (1): from projects' history, before
  cutting any (2 Nov review).
- **Pick library styles by ticking the gallery** (4).
  [#9](https://github.com/leo-hyde/claude-playbook/issues/9)
- **Design guide for documents and slide decks** (3): a deep-dive session.
  [#10](https://github.com/leo-hyde/claude-playbook/issues/10)
- **Apps that don't look AI-made** (4): proposed, waiting on the user's
  answers (decisions.md). [spec](specs/distinctive-design.md)
- **Self-improving playbook** (1): check and update itself.
  [#2](https://github.com/leo-hyde/claude-playbook/issues/2),
  [#3](https://github.com/leo-hyde/claude-playbook/issues/3),
  [#8](https://github.com/leo-hyde/claude-playbook/issues/8)
- **Running out of credits mid-session** (5): what to do.
  [#6](https://github.com/leo-hyde/claude-playbook/issues/6)
- **Remove defunct content** (1): a sweep for anything no longer used.
  [#1](https://github.com/leo-hyde/claude-playbook/issues/1)

### Paused
- (none)

### Done
- **How we run projects, step 1** (3): templates (README, PLAN, spec,
  decisions, AGENTS as pointers), `methods/`, pull requests at session start,
  PLAN.md checks, five-line replies, the "Concise for Leo" output style.
  Checked 3 Nov: 130 tests, the fixed rule tasks.
- **The playbook runs this way itself** (3): README as front door, this
  PLAN.md, STATUS.md retired, work through pull requests. 3 Nov.
  [#4](https://github.com/leo-hyde/claude-playbook/issues/4)
- **Research to a document** (3): one growing document, decisions in it,
  topic names; spec rules from a rejected spec. 3 Nov.
  [#14](https://github.com/leo-hyde/claude-playbook/issues/14),
  [#15](https://github.com/leo-hyde/claude-playbook/issues/15)
- **Agile delivery reference** (3): short cycles on purpose. 3 Nov.
- **AGENTS.md as each project's rules file** (1): CLAUDE.md imports it. 2 Nov.
- **Rules pruned against Anthropic's best practices** (5): fixed rule tasks
  before and after. 2 Nov.
- **Design method and style library** (4): UX method, checklist, design
  review, page check, six styles, client brands. 28 Oct.
  [spec](specs/design-and-styles.md)
- **Efficient sessions** (5): cost notes from the transcript, push-to-main
  docs check, `scout` and `checker` subagents. 27 Oct.
  [spec](specs/efficient-sessions.md)
- **Shareable playbook** (6): `owner/` apart, "the user" in `shared/`, MIT
  licence. 27 Oct. [spec](specs/shareable-playbook.md)
- **The sync, set-up check and catch-ups** (1): every project copies the
  shared files at session start, fills in missing hooks, and lists rule
  changes to apply once. Oct.
- **Session script and hooks** (2): start, cost notes, end-of-reply check
  for unsaved work, people's edits and notes to Claude listed. Oct.
- **Public-or-private check** (6): warns when a repo turns public. Oct.
- **Kept tests on Linux and macOS** (1): `tests/run.sh`, run on every push.

### Dropped
- **Session lock** (2): replaced by own branches and git (27 Oct).
  [#5](https://github.com/leo-hyde/claude-playbook/issues/5)
- **Canary and releases** (1): switched off, kept (2 Nov); bring back if a
  change breaks projects twice. [spec](specs/playbook-releases.md)
- **STATUS.md** (3): replaced by PLAN.md, pull requests and proposed
  decisions (3 Nov).
