# Live status

Current state of the playbook. Overwrite, don't append; history is `git log`.

## Handover

| | |
|---|---|
| Last session | Cloud, 27 Oct 2026 (usage review and specs) |
| Ended cleanly? | Yes, all pushed to `main` |
| Mid-flight work | None. Three specs drafted for the user's review (efficient-sessions updated with the 27 Oct morning sessions , "fix now or file an issue" and part 8, the right model for each job): `specs/playbook-releases.md`, `specs/efficient-sessions.md`, `specs/shareable-playbook.md`. Wording made general ("the user") in every file no project syncs; `owner/profile.md` created. `shared/` untouched |
| Next step | Build in order (below), each in a fresh session, using the recommended answer to each "Decisions for the user" unless the user said otherwise |
| Check first | Earlier today (Mac): the session lock was removed (catch-up `2026-10-27-no-lock`); watch that projects apply it |

## Where we are
The shared folder (the rules, the session script and the sync) is copied into
every project when a session opens: Sport Conditions, a private project, AEC
Tech Radar and its helper repo. The playbook's own docs are in plain English
and refer to "the user", not a named person; the synced rules and scripts
still name the owner until the shareable spec ships. Documents follow "each
fact in one place". Claude coaches the user on sessions and credits.

## Next steps
1. The specs are agreed (27 Oct): recommended options unless the starter prompt says otherwise.
2. Build `specs/playbook-releases.md`: a `stable` branch, a canary project,
   kept tests on Linux and macOS, release notes, ideas as issues.
3. Build `specs/efficient-sessions.md` and the rest of
   `specs/shareable-playbook.md` together, as the first release (both rewrite
   `shared/ai-dev-rules.md`; this also covers trimming it under 150 lines).
4. The user's Mac: pull the playbook clone and copy personal-CLAUDE.md to
   ~/.claude/CLAUDE.md (it changed 24 Oct).

## Open questions
- The decisions listed at the end of each spec.
