# Live status

Current state of the playbook. Overwrite, don't append; history is `git log`.

## Handover

| | |
|---|---|
| Last session | Phone (cloud), 23 Oct 2026 |
| Ended cleanly? | Yes, all pushed to `main` |
| Mid-flight work | None |
| Next step | On the Mac: `git -C ~/.claude/skills/new-app pull`, then `cp ~/.claude/skills/new-app/personal-CLAUDE.md ~/.claude/CLAUDE.md` (it's now short and points to `shared/ai-dev-rules.md`) |
| Check first | The repo is now public (Leo, 23 Oct): the shared rules make Claude check playbook changes for private details and ask first |

## Where we are
`shared/` (rules, session lock, sync) is synced into Sport Conditions and
JobSeekHelper at each session start. Documents follow "each fact in one
place" (STATUS current state only, decisions.md, specs/). Claude coaches Leo
on sessions and credits unprompted.

## Next steps
1. Leo's Mac: pull the playbook clone and copy personal-CLAUDE.md (above).
2. Watch the first few sessions: are the coaching tips useful or nagging?
   Adjust `COACH_EVERY` in `shared/session.sh` or the Coaching section.

## Open questions
- None.
