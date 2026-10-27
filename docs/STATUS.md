# Live status

Current state of the playbook. Overwrite, don't append; history is `git log`.

## Handover

| | |
|---|---|
| Last session | Cloud, 27 Oct 2026 (overnight: building `specs/design-and-styles.md`) |
| Ended cleanly? | Yes, all pushed to `main` |
| Mid-flight work | None. Good UX by default and the style library are built and on `main`, so only the canary (Sport Conditions) has them. Not released. The style gallery is a private page: https://claude.ai/artifact/7VcWzzwMK3gVXiWHgGDE7b |
| Next step | The user looks at the gallery and swaps any of the six library styles they don't like (`in_library` in `styles/candidates.json`, then `python3 tools/styles.py build`). Then a Sport Conditions session that adds or reworks a screen, using the design method and review; then release (the user's yes) |
| Check first | That canary session: does it read `reference/design-method.md`, fill in "What's on screen", and run the design review? Sport Conditions' own findings from the trial review are in the spec's Progress notes |

## Where we are
The shared folder (the rules, the session script and the sync) is copied into
every project when a session opens: Sport Conditions, a private project, AEC
Tech Radar and its helper repo. Projects get changes only when the user
releases them; Sport Conditions (the canary) gets them first, from `main`.
Kept tests (107 cases) run on Linux and macOS on every push.

On `main`, not yet released (`specs/design-and-styles.md`):
- a UX method (`reference/design-method.md`), a rewritten checklist with the
  10 usability heuristics, a "What's on screen" section in feature specs,
  and a design review (`reference/design-review.md`) run by the `checker`;
- a style library (`styles/`): 13 candidate styles in a gallery, 6 in the
  library, built and contrast-checked by `tools/styles.py`; the template's
  colours come from the `clear` style, with a new `--link` token;
- `tools/page-check.js`: page width, tap targets, input text size and
  axe-core at phone and desktop, light and dark, with screenshots;
- a recipe for clients' brands (`reference/client-style.md`), and catch-up
  `2026-10-27-design-method`.

On `main`, not yet released (`specs/efficient-sessions.md`,
`specs/shareable-playbook.md`, part 4 of `specs/playbook-releases.md`):
- the rules are 149 lines, with "Using tokens well" in place of coaching,
  "fix now or file an issue", and ideas for the playbook filed as issues;
  the tests now fail them over 150 lines;
- `COST:` notes measured from the transcript, a push-to-main docs check, and
  an end-of-reply check that blocks only for lost work;
- catch-ups print one line each; `scout` and `checker` subagents synced;
- `shared/` says "the user", owner details come from `owner/` (synced as
  `.claude/rules/owner.md`), `PLAYBOOK_URL` is the one line a fork changes,
  MIT licence.

## Next steps
1. The design release: the user reviews the gallery and the six picks; a
   Sport Conditions session on a screen (the canary); then the RELEASES.md
   entry and `scripts/release.sh --check`, and `--yes` after the user's yes.
   Also delete the merged `second-release` branch.
2. Test in a cloud session that project subagents (`.claude/agents/`) load
   there. If not, stop syncing them (`FILES` in `shared/playbook-sync.sh`).
3. A week after the release: the first monthly review
   (`reference/efficient-sessions.md`), comparing with the 27 Oct figures,
   and whether the canary's `opusplan` trial holds up.
4. Open issues on the playbook: #1–#4 and #6 (the user's ideas) in a batch in their
   own session; #5 (the paused worktree change) is merged and can be closed;
   #7 (session start in a desktop worktree) from the canary.
5. Sport Conditions: delete its old `session-lock` branch once it's over a
   day old (`git push origin --delete session-lock`).
6. The user's Mac: reset the playbook clone at `~/.claude/skills/new-app` to
   `origin/main` (its one unpushed commit is now on `main`) and copy
   `owner/personal-CLAUDE.md` to `~/.claude/CLAUDE.md`.

## Open questions
- None open in the specs: every decision was taken as recommended (27 Oct).
