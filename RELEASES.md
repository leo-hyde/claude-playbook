# Playbook releases

Newest first. Each release moves the playbook's `stable` branch, which every
project syncs from, on to `main`. When a project updates, its session start
prints the newest entry's first line, so write that line for the user: what
changes for them, in plain words.

Each entry: a heading with the release tag (`## release-YYYY-MM-DD`, with
`-2`, `-3` for more than one on a day), then two or three plain lines, and a
last line naming any catch-up it brings (or "Catch-up: none").
`scripts/release.sh` refuses to release without one for its tag.

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
