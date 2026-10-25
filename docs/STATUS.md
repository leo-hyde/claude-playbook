# Live status

Current state of the playbook. Overwrite, don't append; history is `git log`.

## Handover

| | |
|---|---|
| Last session | Phone (cloud), 25 Oct 2026 |
| Ended cleanly? | Yes, all pushed to `main` |
| Mid-flight work | None. Done today: a rule to act on a repo's open GitHub Issues (replacing the "fix small problems" rule), and the plain-English catch-up for the playbook's own docs (see `docs/playbook-catch-up.md`) |
| Next step | Trim `shared/ai-dev-rules.md` back under ~150 lines (it's 163) |
| Check first | Sport Conditions and JobSeekHelper still have the old sync script, so their next session shows "CATCH-UP DUE" one session late, once (Leo is bringing them up to date himself) |

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
