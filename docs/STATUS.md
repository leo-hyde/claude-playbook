# Live status

Current state of the playbook. Overwrite, don't append; history is `git log`.

## Handover

| | |
|---|---|
| Last session | Mac, 3 Nov 2026: added `reference/agile-delivery.md` (running a project in short cycles; proposed, from a consulting project) and its row in SKILL.md. Before that: Mac, 2 Nov 2026: merged the off-the-shelf review; pruned the rules against Anthropic's best-practices page, checked with four fixed test tasks (`tests/rule-tasks.md`); AGENTS.md is now each project's main rules file (templates, catch-up `2026-11-02-agents-md`, this repo too); canary and releases switched off, projects read `main` (decisions.md, 2 Nov); idea issue #12 |
| Ended cleanly? | Yes, on `main`. **`release-2026-11-02` released 2 Nov** (the user's yes): the last release; every project now moves to reading `main`. Tags `release-2026-10-28` and `release-2026-11-02` are on GitHub |
| Mid-flight work | None. The style gallery is a private page: https://claude.ai/artifact/7VcWzzwMK3gVXiWHgGDE7b |
| Next step | Sport Conditions issue #13 (priority): fix the nine design-review findings, the first real use of the design method. Then playbook issue #9: tick favourite styles on the gallery page instead of editing `styles/candidates.json`. Proposed, waiting for the user's decisions: `specs/distinctive-design.md` (apps that don't look AI-made) |
| Check first | Each project's next session: it applies catch-up `2026-11-02-agents-md` (CLAUDE.md becomes `@AGENTS.md`) and its rules still load. If a playbook change breaks projects, recommend bringing releases back (AGENTS.md) |

## Where we are
The shared folder (the rules, the session script and the sync) is copied into
every project when a session opens: Sport Conditions, a private project, AEC
Tech Radar and its helper repo. Projects get changes only when the user
pushes them to `main` (no releases since 2 Nov 2026).
Kept tests (114 cases) run on Linux and macOS on every push.

Released in `release-2026-10-28` (`specs/design-and-styles.md`):
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
- **From the 2 Nov review (decisions.md), each its own playbook session, in
  this order:** (a) ~~prune the rules~~ done 2 Nov; (b) ~~adopt AGENTS.md~~ done 2 Nov (AGENTS.md is the main file); (c) move situational rules into skills, synced like the subagents;
  (d) freeze the sync scripts and count, from projects' history, what each
  check has caught before cutting anything.
0. Released 2 Nov with the 30 Oct additions. Now the consulting project that first had the edits check can drop its own `scripts/doc-edits.sh` and hook, or it will print twice.
1. Sport Conditions issue #13, then playbook issue #9 (see Handover). Delete the merged
   `second-release` branch.
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
