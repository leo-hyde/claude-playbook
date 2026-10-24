# Live status

Current state of the playbook. Overwrite, don't append; history is `git log`.

## Handover

| | |
|---|---|
| Last session | Phone (cloud, several repos attached), 24 Oct 2026 |
| Ended cleanly? | Yes, all pushed to `main` |
| Mid-flight work | None. Done: the sync runs its new self after updating itself (no more one-session delay for new checks); rule "every repo follows the playbook" (helper repos too) and "fix small problems you find, ask for bigger ones"; Action bots' commits don't need a STATUS update; the playbook records its own catch-ups |
| Next step | The plain-English catch-up for the playbook's own docs (`docs/playbook-catch-up.md`): its own session |
| Check first | Sport Conditions and JobSeekHelper still have the old sync script, so their next session shows "CATCH-UP DUE" one session late, once (Leo is bringing them up to date himself) |

## Where we are
`shared/` (rules, session lock, sync) is synced into every project at each
session start: Sport Conditions, JobSeekHelper, AEC Tech Radar and its helper
repo. `shared/ai-dev-rules.md` is 160 lines, over the ~150 aim. Documents
follow "each fact in one place". Claude coaches Leo on sessions and credits.

## Next steps
1. Leo's Mac: pull the playbook clone and copy personal-CLAUDE.md to ~/.claude/CLAUDE.md (it changed 24 Oct).
2. Watch the first few sessions: are the coaching tips useful or nagging?
   Adjust `COACH_EVERY` in `shared/session.sh` or the Coaching section.

## Open questions
- None.
