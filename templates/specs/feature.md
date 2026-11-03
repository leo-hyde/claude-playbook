# <Feature name>

Only for a bigger feature. Copy to `specs/<feature-name>.md`; link it from
its PLAN.md line. Built in a fresh session that reads README.md, PLAN.md and
this file (playbook method: `methods/build-a-feature.md`).

## Goal
<One or two sentences, in the user's own words where possible: what they
will be able to do, and why it matters.>

## The whole feature
<!-- The whole thing, not just the change: a reader must not think the core
is missing. Mark each part built or new. -->
1. <Part> (built)
2. <Part> (new)

## What's on screen
(For anything the user sees. See the playbook's `reference/design-method.md`.)
- **The screen's one job:** <the question it answers, or the task it does>
- **Main screen** (used every time): <the answer, the one main action>
- **One tap away** (used now and then): <detail, "Show all", secondary actions>
- **Settings** (set once, rarely changed): <preferences, with sensible defaults>
- **Later / not building:** <moved to PLAN.md's Later group>

## Parts involved
- <Files that change, new files, outside services, data.>

## Out of scope
- <What this feature deliberately doesn't do.>

## Done when (the checks it must pass)
- <Tests to add or run, the check script, what to look at on the page
  (phone 375px and desktop, light and dark), the live site.>

## Risks and open questions
- <Anything unverified, a usage limit. Decisions for the user also go in
  docs/decisions.md as proposed.>

## Progress
<!-- Notes while it's built: where it got to. The pull request says the same
in a line or two. -->
