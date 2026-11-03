# Build or change a feature

**Version 1.0 · 3 Nov 2026 · Status: in use; first tried in a pilot project**

| | |
|---|---|
| **When to use** | Any new feature, or a change to one, in a project with a PLAN.md |
| **Inputs** | The user's request in their own words; README.md, PLAN.md, the feature's spec if it has one, the open pull requests |
| **Output** | The work merged into main, its PLAN.md line under Done, the branch and working copy gone |
| **Done when** | It passed the feature's checks (its spec's "Done when", or the ones agreed in chat) |
| **Record** | PLAN.md line; a change of mind in `docs/decisions.md` (was, now, why); structure in `docs/ARCHITECTURE.md` |

Based on GitHub flow (a branch and pull request per change, deleted on
merge), Kanban (open work visible and limited) and the Scrum Definition of
Done. Step 1 is our own rule.

## Steps
1. **List the whole objective first.** Before writing or changing a spec,
   list **every** feature under that objective in PLAN.md, built or not, each
   with what it should do now. **Stop and ask:** "Is anything missing or
   changed?" Write the answer into PLAN.md; any change of mind also goes in
   decisions.md.
2. **Spec it, if it's bigger than a small step** (`templates/specs/feature.md`
   → `specs/<feature>.md`): the whole feature, built parts and new, and the
   checks that say it's done. Before writing, check the playbook's
   `reference/` for a tested route to anything it relies on. **Stop and ask**
   for any decision only the user can make; write it in decisions.md as
   proposed, with your recommendation.
3. **Open a pull request early** (a proposed change, shown on GitHub until
   merged or closed), from a branch of its own, after the first commit. Its
   description: what it's for (link the PLAN.md line or spec), where it got
   to, what's next. Move the PLAN.md line to Now, with the link. Keep the
   description current as you go: it is how the next session picks up.
4. **Build in small commits, pushed each time.** Over five open pull requests
   in the repo (paused ones count)? Say so, and suggest finishing or closing
   one before starting another.
5. **Stopping before it's done is fine.** Leave the pull request open with
   the `paused` label (create it if missing), its description saying where it
   got to and what's next, and the PLAN.md line under Paused.
6. **Check with evidence** against the feature's checks: tests, pages at
   phone width and desktop, light and dark, then the live site. Say what
   wasn't checked. A bigger step: ask the `checker` subagent first.
7. **Finish in one go, without being asked:** move the PLAN.md line to Done
   (with the date and how it was checked), update ARCHITECTURE.md or
   decisions.md if they changed, merge the pull request, delete its branch
   (GitHub does this if "automatically delete head branches" is on) and
   remove the session's working copy. Say it landed, in the five-line reply.

## Stop and ask the user
- Step 1: is the feature list complete?
- Any decision that changes scope, data, money, privacy or what users see.
- A check fails and the fix would change the agreed feature.
