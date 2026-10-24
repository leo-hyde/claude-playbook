# Live status

Current state of the playbook. Overwrite, don't append; history is `git log`.

## Handover

| | |
|---|---|
| Last session | Cloud (from AEC Tech Radar), 24 Oct 2026 |
| Ended cleanly? | Yes, all pushed to `main` |
| Mid-flight work | None. Added "Writing for people" (UK plain English, plain end-of-task summaries) to shared/ai-dev-rules.md, and "Giving Claude more reach" to reference/github-and-hosting.md |
| Next step | On the Mac: `git -C ~/.claude/skills/new-app pull`, then `cp ~/.claude/skills/new-app/personal-CLAUDE.md ~/.claude/CLAUDE.md` |
| Check first | Do replies now read as plain English? If not, tighten the "Writing for people" section |

## Where we are
`shared/` (rules, session lock, sync) is synced into Sport Conditions and
JobSeekHelper at each session start (and AEC Tech Radar, set up 23 Oct). Documents follow "each fact in one
place" (STATUS current state only, decisions.md, specs/). Claude coaches Leo
on sessions and credits unprompted.

## Next steps
1. Leo's Mac: pull the playbook clone and copy personal-CLAUDE.md (above).
2. Watch the first few sessions: are the coaching tips useful or nagging?
   Adjust `COACH_EVERY` in `shared/session.sh` or the Coaching section.

## Open questions
- None.
