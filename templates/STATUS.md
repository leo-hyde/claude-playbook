# Live status

The current state of the project, shared between the user's phone and computer
sessions. **Every Claude session reads this first and updates it when a step
is finished** (as the work lands on main). Progress during a step goes in that
step's spec, so sessions working in parallel don't clash here. Current state only: overwrite, don't
append. History is in `git log`; decisions are in `docs/decisions.md`.

## Handover (overwrite this block when a step finishes)

| | |
|---|---|
| Last session | <Phone (cloud) or Desktop (Mac)>, <date, time of day> |
| Ended cleanly? | <Yes, all pushed to `main` / No: what's unsaved> |
| Mid-flight work | <None / which branches hold unfinished work; their progress is in their specs> |
| Next step | <the one thing to do next> |
| Check first | <files or results to look at before starting> |
| Note | <anything surprising, e.g. a limit of cloud sessions> |

## Where we are

<Two or three sentences: what works, what doesn't yet.>

## Next steps

1. <The next one or two, by their number in SPEC.md's steps; don't copy the
   whole plan here. Big ones get a spec in `specs/` and their own session.>

## Open questions

- <Things only the user can decide.>
