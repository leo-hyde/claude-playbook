# Live status

Current state of the playbook. Overwrite, don't append; history is `git log`.

## Handover

| | |
|---|---|
| Last session | Phone (cloud), 25 Oct 2026 |
| Ended cleanly? | Yes, all pushed to `main` |
| Mid-flight work | None. Done today: issues rule; plain-English catch-up; and playbook changes now reach existing projects (set-up check in `shared/setup.txt`, checks of other attached repos, louder "not synced" warning) |
| Next step | Trim `shared/ai-dev-rules.md` back under ~150 lines (it's 167) |
| Check first | The new set-up check reaches each project at its next session start (scripts update themselves, then run their new version) |

## Where we are
The shared folder (the rules, the session lock and the sync) is copied into
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
