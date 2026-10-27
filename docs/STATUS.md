# Live status

Current state of the playbook. Overwrite, don't append; history is `git log`.

## Handover

| | |
|---|---|
| Last session | Mac, 27 Oct 2026 (building the second release) |
| Ended cleanly? | Yes, all pushed to `main` |
| Mid-flight work | None. **`release-2026-10-27-2` released 27 Oct** (the user's yes); every project picks it up at its next session start. The job radar project has it, with its catch-ups applied |
| Next step | Issue #7: session start in a desktop worktree session runs in the main checkout. Found in the job radar project: its pull and sync also left merge commits there that GitHub never got, so the main checkout fell behind and hooks ran an old script (reset by hand, 27 Oct). Idea: the first message's hook runs start in the worktree if it hasn't run there; start in a main checkout that isn't the session's folder pulls fast-forward only and commits nothing |
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
