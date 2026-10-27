# Live status

Current state of the playbook. Overwrite, don't append; history is `git log`.

## Handover

| | |
|---|---|
| Last session | Cloud, 27 Oct 2026 (building the releases spec) |
| Ended cleanly? | Yes, all pushed to `main` |
| Mid-flight work | Releases built (`specs/playbook-releases.md`, Progress): the sync reads `stable` (falls back to `main`), canary channel file, `tests/run.sh`, the test Action on Linux and macOS, `RELEASES.md`, `scripts/release.sh`, "How a playbook session works" in CLAUDE.md. Waiting for the user's yes on two steps (below) |
| Next step | With the user's yes: commit `.claude/playbook-channel` (`main`) in Sport Conditions; then the first release (`scripts/release.sh`), which creates `stable` |
| Check first | `stable` doesn't exist yet, so every project still reads `main`. Don't release before the canary's channel file is pushed, or the canary would be frozen on `stable` too |

## Where we are
The shared folder (the rules, the session script and the sync) is copied into
every project when a session opens: Sport Conditions, a private project, AEC
Tech Radar and its helper repo. From the first release on, projects get
changes only when the user releases them, and Sport Conditions (the canary)
gets them first. Kept tests run on every push. The playbook's own docs are in
plain English and refer to "the user"; the synced rules and scripts still
name the owner until the shareable spec ships. Claude coaches the user on
sessions and credits.

## Next steps
1. Canary channel file, then the first release (both need the user's yes).
2. Build `specs/efficient-sessions.md` and the rest of
   `specs/shareable-playbook.md` together, as the second release (both
   rewrite `shared/ai-dev-rules.md`; this also covers trimming it under 150
   lines, part 4 of the releases spec (ideas as issues), catch-ups printed
   one line each, and making the rules-size test a hard 150-line limit).
3. The user's Mac: pull the playbook clone and copy personal-CLAUDE.md to
   ~/.claude/CLAUDE.md (it changed 24 Oct).

## Open questions
- The decisions listed at the end of each spec.
