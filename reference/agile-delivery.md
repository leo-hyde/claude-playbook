# Agile delivery: running a project in short cycles, on purpose

**Version 0.1 · 3 Nov 2026 · Status: proposed; tried first on one consulting
project, adjust after real use**

Use this when planning how a project will run over time: an app, a project
that is mostly documents, or a consulting engagement for a client.

- **Summary:** what the approach is. Half a minute.
- **Plan and decisions:** the loop and the rules.
- **Detail:** what the playbook already does, limits, where it came from.

## Summary
- The playbook already works in short cycles: plan first, build in small
  steps that each end with something visible, check with evidence, record
  what changed. This page names that and adds what was missing, so a
  project chooses its way of working instead of drifting into one.
- **Default: a light hybrid.** Anything fixed from outside (a contract's
  scope, dates and acceptance) stays fixed and plan-driven. Inside it, work
  in short cycles with one visible list, a working result each cycle, and a
  look-back at each gate.
- **Not full Scrum.** Its roles and meetings cost too much for one person
  with Claude, or a small part-time team. Add a piece only when a real
  problem calls for it.

## Plan and decisions

### Pick the mode
| Situation | Mode |
|---|---|
| Nobody yet knows the right answer, and a small result will teach you | Iterative: cycles and a list |
| Scope, dates and acceptance fixed by a client or contract | Hybrid: gates outside, cycles inside (the default) |
| Steps fixed by law, safety or a regulator | Plan-driven, with a check at each step |

### One cycle
Length: one week for a team; one step (a few days) for one person with
Claude. Pick one and keep it for four cycles before changing it.
1. **Pick** the next items from the list, ordered by value, essentials
   first. Each names who it serves and by when. Keep **no more than three
   open at once** (a starting number).
2. **Build small.** Write a spec first for anything bigger than a small
   step (`specs/<feature>.md`).
3. **Show** something working to the people it is for. If it isn't used,
   stop or change it.
4. **Check.** Done means checked with evidence (the "How to check" in the
   spec), not "built".
5. **Record** in the same commit: the list's status, `docs/decisions.md` for
   a choice; the PLAN.md line moves to Done as the pull request merges.
6. **Look back** at each gate or stage end, and monthly in a long project:
   what slowed us, what to keep. A general lesson becomes an `idea` issue.

### Where each part lives
| Part | Where |
|---|---|
| The ordered list | PLAN.md's feature list, Now / Next / Later (`SPEC.md` in older projects). For a team, a shared tracker people really use; PLAN.md links to it |
| What "done" means | The spec's "how to check it's done" |
| The handover | The open pull requests (`docs/STATUS.md` in older projects) |
| Changes and look-backs | `docs/decisions.md`; general lessons as playbook `idea` issues |

### Rules
1. Essentials before extras. Nothing in "extras" or "maybe" starts until the
   essentials work.
2. Limit work in progress. Start at three; adjust from evidence.
3. Every item names who it serves and by when.
4. Done means checked, not built.
5. Show something every cycle. Cancel the meeting in a week with nothing to
   show.
6. Change by swapping: new work comes in only if something of similar size
   goes out, and the swap is recorded.
7. Look back at each gate, and write down what changes.

### With a client contract
The contract's phases, dates and acceptance stay visible and unchanged;
agile applies to how the team works inside them, not to what was promised.
If the client's own word for a phase is "sprint", use a different word for
the work loop ("cycle") so the two are never confused.

## Detail

### What the playbook already does
Plan first and small steps ending in something visible (`ai-dev-rules.md`,
"How we work"); a spec before building; checking with evidence; pull requests
as the handover (once STATUS.md); `decisions.md` for choices; a monthly review in
`efficient-sessions.md`; the research-to-doc method's approval points
(`methods/research-to-doc.md`). What this page adds: an ordered list the whole team
can see, a work-in-progress limit, a swap rule, and a scheduled look-back.

### What not to copy
Daily stand-ups, story points and velocity, and fixed roles. They suit a
full-time team working on one product. Add one only to fix a named problem.

### Why short cycles
In the consulting project this came from, a large share of one person's
time went on redoing earlier versions, mainly because critique arrived
after several polished versions (`research-to-doc.md`). Showing small results early, and
checking them, brings that critique forward.

### Terms (from general knowledge; not freshly checked)
Agile Manifesto (2001): people and working results over process and plans;
responding to change over following a plan. Scrum: fixed-length sprints of a
month or less, with planning, a daily check, a review and a retrospective.
Kanban: a visible board and a limit on work in progress. "Hybrid": a fixed
plan with iterative work inside it.

### Change log
| Version | Date | Change |
|---|---|---|
| 0.1 | 3 Nov 2026 | First version, from a consulting project's position paper; checked by a fresh reader |
