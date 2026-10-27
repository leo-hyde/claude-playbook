# Live status

Current state of the playbook. Overwrite, don't append; history is `git log`.

## Handover

| | |
|---|---|
| Last session | Mac, 27 Oct 2026 |
| Ended cleanly? | Yes, all pushed to `main` |
| Mid-flight work | None. Done today: removed the session lock (`shared/session.sh`), tested in a throwaway repo; rules, guide, STATUS template and catch-up `2026-10-27-no-lock` updated. Earlier today: session start lists open GitHub Issues |
| Next step | Watch the first sessions in each project under the new script: does `OTHER WORK` list the right branches, and does the Mac reminder show? Then trim `shared/ai-dev-rules.md` (about 185 lines) |
| Check first | Each project's first session applies catch-up `2026-10-27-no-lock` (deletes its `session-lock` branch once it's a day old) |

## Where we are
The shared folder (the rules, the session script and the sync) is copied into
every project when a session opens: Sport Conditions, JobSeekHelper, AEC Tech
Radar and its helper repo. The playbook's own docs are in plain English.
Documents follow "each fact in one place". Claude coaches Leo on sessions
and credits.

## Next steps
1. Leo's Mac: pull the playbook clone and copy personal-CLAUDE.md to ~/.claude/CLAUDE.md (it changed 24 Oct).
2. Watch the first few sessions: are the coaching tips useful or nagging?
   Adjust `COACH_EVERY` in `shared/session.sh` or the Coaching section.

## Open questions
- None.
