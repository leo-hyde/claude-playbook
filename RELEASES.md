# Playbook releases

Newest first. Each release moves the playbook's `stable` branch, which every
project syncs from, on to `main`. When a project updates, its session start
prints the newest entry's first line, so write that line for the user: what
changes for them, in plain words.

Each entry: a heading with the release tag (`## release-YYYY-MM-DD`, with
`-2`, `-3` for more than one on a day), then two or three plain lines, and a
last line naming any catch-up it brings (or "Catch-up: none").
`scripts/release.sh` refuses to release without one for its tag.

## 3 Nov 2026 (on main; releases are off)
How projects are run changes: each repo gets a PLAN.md with every feature, and work in progress is an open pull request you can see on GitHub.
- New templates (README, PLAN, spec, decisions, AGENTS as pointers) and three written methods in `methods/`: build a feature (list every feature for you to confirm first), research to a document (one growing document, decisions written in it), pick up where we left off.
- Session start lists open pull requests (a warning over five), paused ones over two weeks, branches without a pull request at any age, and decisions waiting on you. The end-of-reply check blocks only on unsaved work, now on the Mac too. A push to main needs PLAN.md (older projects: STATUS.md, until they move over).
- Replies start with at most five lines; a "Concise for Leo" output style for the Mac.
- Catch-up: none yet. Projects move to PLAN.md after a week's pilot on one project.

## release-2026-11-02
The last release: from now on, playbook changes reach your projects at their next session, as soon as they're on the playbook's main.
- Each project's rules move from CLAUDE.md to AGENTS.md, so other AI tools can follow them too; CLAUDE.md becomes one line that imports it.
- Shorter shared rules, pruned against Anthropic's best-practices page; people's edits and notes to Claude listed at session start; a team-review guide (Google Docs), set-up for document projects, estimates from past work, retrospectives, the research-to-doc method.
- Catch-up: 2026-11-02-agents-md.

## release-2026-10-28
New screens are planned and checked for good design: Claude sorts each feature into main screen, one tap away or Settings before building, and new apps pick a look from a style library.
- A design method (`reference/design-method.md`), a fuller UX checklist with the 10 usability heuristics, and a design review after new screens, with a page check for width, button size and accessibility (`tools/page-check.js`).
- A style library (`styles/`): six styles to choose from in a gallery, all contrast-checked; a recipe for matching a client's brand.
- Catch-up: 2026-10-27-design-method.

## release-2026-10-27-2
Sessions should cost less: Claude now notes when a session has grown expensive, checks the docs only when work lands on main, and keeps small replies short.
- Shorter shared rules (149 lines), with "Using tokens well" in place of coaching; two helper subagents, `scout` and `checker`; ideas for the playbook are filed as issues.
- The rules say "the user", and the owner's details come from `.claude/rules/owner.md`, so others can copy the playbook (MIT licence).
- In a desktop worktree session, the per-message and end-of-reply checks look at the session's own worktree (from the hook's `cwd`), not the main checkout. Session start still runs in the main checkout (issue #7).
- Catch-up: 2026-10-27-tokens.

## release-2026-10-27
Playbook changes now reach your projects in tested batches, called releases, instead of with every edit.
- One project (the canary) tries each change first, in real use.
- Catch-up: none.
