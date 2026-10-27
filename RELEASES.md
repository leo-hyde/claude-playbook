# Playbook releases

Newest first. Each release moves the playbook's `stable` branch, which every
project syncs from, on to `main`. When a project updates, its session start
prints the newest entry's first line, so write that line for the user: what
changes for them, in plain words.

Each entry: a heading with the release tag (`## release-YYYY-MM-DD`, with
`-2`, `-3` for more than one on a day), then two or three plain lines, and a
last line naming any catch-up it brings (or "Catch-up: none").
`scripts/release.sh` refuses to release without one for its tag.

## release-2026-10-27
Playbook changes now reach your projects in tested batches, called releases, instead of with every edit.
- One project (the canary) tries each change first, in real use.
- Catch-up: none.
