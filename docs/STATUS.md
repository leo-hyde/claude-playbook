# Live status

Current state of the playbook. Overwrite, don't append; history is `git log`.

## Handover

| | |
|---|---|
| Last session | Cloud, 27 Oct 2026 (building the releases spec) |
| Ended cleanly? | Yes, all pushed to `main` |
| Mid-flight work | None. Releases are live: first release `release-2026-10-27` (`stable` at `9873c28`), Sport Conditions is the canary (reads `main`). The tag itself wasn't pushed: cloud sessions can't push tags (see next steps) |
| Next step | Session 2: `specs/efficient-sessions.md` with the rest of `specs/shareable-playbook.md`, as the second release (below) |
| Check first | Every project except Sport Conditions now reads `stable`: a push to `main` reaches only the canary until `scripts/release.sh` runs |

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
1. On the Mac, add the missing tag: in the playbook, `git fetch origin stable &&
   git tag release-2026-10-27 9873c28 && git push origin release-2026-10-27`.
   Also delete the leftover branches `ci-broken-check` and `releases` (cloud
   sessions can't delete branches), and check whether the six older `ccr-*`
   and `claude/*` branches hold anything not already on `main`.
2. Sport Conditions: apply the `2026-10-27-no-lock` catch-up (its own short
   session; deleting `session-lock` needs the Mac or GitHub's website).
3. Build `specs/efficient-sessions.md` and the rest of
   `specs/shareable-playbook.md` together, as the second release (both
   rewrite `shared/ai-dev-rules.md`; this also covers trimming it under 150
   lines, part 4 of the releases spec (ideas as issues), catch-ups printed
   one line each, and making the rules-size test a hard 150-line limit).
4. The user's Mac: pull the playbook clone and copy personal-CLAUDE.md to
   ~/.claude/CLAUDE.md (it changed 24 Oct).

## Open questions
- The decisions listed at the end of each spec.
