# Live status

Current state of the playbook. Overwrite, don't append; history is `git log`.

## Handover

| | |
|---|---|
| Last session | Phone (cloud), 25 Oct 2026 |
| Ended cleanly? | Yes, all pushed to `main` |
| Mid-flight work | None. Done today: "Keeping the docs true" rule, an end-of-reply check that SPEC.md moves with `specs/`, SPEC/STATUS template changes and catch-up `2026-10-25-spec-is-the-plan` |
| Next step | Trim `shared/ai-dev-rules.md` back under ~150 lines (it's now about 180) |
| Check first | The first session in each project after this: the catch-up should leave SPEC.md matching the plan, and the new check may block once where a spec changed after SPEC.md |

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
