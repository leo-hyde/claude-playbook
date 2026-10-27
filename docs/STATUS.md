# Live status

Current state of the playbook. Overwrite, don't append; history is `git log`.

## Handover

| | |
|---|---|
| Last session | Mac, 27 Oct 2026 (building the second release) |
| Ended cleanly? | Yes, all pushed to `main` |
| Mid-flight work | The second release is built and on `main`, so only Sport Conditions (the canary) has it. The canary's first session on it went through (27 Oct): catch-ups applied, `opusplan` trial set, push check and `scout` worked. Its three small findings are fixed. Not released: waiting for the user's yes |
| Next step | Release it (`RELEASES.md` entry `release-2026-10-27-2` is written; rename it if released another day), after the user's yes |
| Check first | Sport Conditions' next sessions: `COST:` notes and the `opusplan` trial (ends about 3 Nov). Issue #7: in a desktop worktree session, session start ran in the main checkout |

## Where we are
The shared folder (the rules, the session script and the sync) is copied into
every project when a session opens: Sport Conditions, a private project, AEC
Tech Radar and its helper repo. Projects get changes only when the user
releases them; Sport Conditions (the canary) gets them first, from `main`.
Kept tests (103 cases) run on Linux and macOS on every push.

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
1. Release the second release after the user's yes: `scripts/release.sh --yes`.
   Then delete the `second-release` branch.
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
