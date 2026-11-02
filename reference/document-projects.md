# Projects that are mostly documents

**Version 1.0 · 30 Oct 2026 · Status: tested on one consulting project
(about a week)**

Some projects are mostly planning, research and documents for other people
(consulting, a proposal, a strategy), with some building later. The playbook's
set-up still applies (the rules, the session script, STATUS.md,
decisions.md); these changes make it fit.

## What changes
- **SPEC.md is the plan, not a software spec:** the goal, the stages and
  their gates, essentials versus extras, the risks. Say so at the top of
  AGENTS.md.
- **`docs/CONTEXT.md`: the facts, each with its source.** Deliverables,
  dates, people, hours, budgets, each with where it came from (document,
  page or section, or "the user, <date>"). Anything else is marked
  "assumption" or "to confirm". Check it before reading a big source again.
- **A table of the source documents in AGENTS.md,** each with its live link
  or file id, read with the connector when needed. Don't copy them into the
  repo; read only what the task needs.
- **Two kinds of document, in two folders.**
  - `positions/`: position papers. Each answers one question with a
    recommended plan. One home per topic: earlier notes are merged in, not
    kept alongside.
  - `specs/`: things to build, and methods.
- **Every question answered with a document follows
  `reference/research-to-doc.md`** and says so in its "How this was made".
- **Decisions: only what a named person agreed.** Each entry in
  `docs/decisions.md` names who agreed it (the user, a client, a manager)
  and where (a call, a comment). Claude's ideas stay marked "proposed" in
  SPEC.md or the paper until then.
- **People who don't use GitHub review in Google Docs:**
  `reference/team-review.md`.
- **Client work gets a written AI-use and client-data rule** at kick-off:
  `positions/ai-use-and-client-data.md`, in five parts: where client
  material lives; which AI tools may read it (only ones whose terms rule out
  training on it, that the contract allows and the client agreed); what the
  client is told (a "How this was made" line and a paragraph in the
  engagement terms); a log of which documents went into which tool; who
  signs off each deliverable. Check which plan each AI tool is on: consumer
  and business plans differ. Professional bodies now require this (for
  example RICS, since March 2026). Until it is agreed, keep client material
  out of AI tools and the repo, even a private one. Summaries of the user's
  own plans are fine.
- **AI meeting notes misspell names** (people, companies, products). Keep
  the correct spellings in CONTEXT.md and fix them when reading notes.

## Several jobs in one project
A project can be several jobs at once, judged differently: delivering for
a client, building something reusable, testing whether there's a business
in it. Name each job in SPEC.md with who it's for and what success means,
and say which wins when they conflict. Otherwise work for one quietly
takes time from another.

## Change log
- 1.1 (2 Nov 2026): client work gets a written AI-use and client-data rule.
- 1.0 (30 Oct 2026): first version, from a consulting project.
