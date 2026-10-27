# Design review (the checker's design pass)

Read by the `checker` subagent, or by Claude itself, when a step **adds or
reworks a screen**. A small visual tweak gets Claude's own look against
`reference/ux-checklist.md` instead. The review reports; the user decides.
It never edits.

## 1. Measure first, with the script
Run the page check once, on a local preview with made-up data if there is
one (a free service's daily limit is shared with the user's own devices);
otherwise on the live site:

    node <playbook>/tools/page-check.js <file or address> <scratchpad>/page-check

`<playbook>` is wherever this file is: `~/.claude/skills/new-app` on the
Mac, a clone next to the project, or the project's `.session/playbook`. The
script checks phone and desktop width in light and dark: nothing wider than
the screen, tap targets, input text size, and axe-core (a free
accessibility checker: contrast, labels, headings, names for buttons). It
saves a screenshot of each to the folder and prints a short summary. If it
prints `SKIPPED` (no Node.js or Playwright, usual on the Mac) or `COULD NOT
LOAD` (the address is blocked or down), say the measured checks weren't run
and why. With no screenshots either, report "not reviewed" and stop: don't
judge a page you haven't seen.

Don't re-check by eye what the script measured.

## 2. Look, for judgement only
Look at **at most 6 screenshots**: the changed screens at phone width
(light, then dark), and desktop if the layout differs. Each image costs
about as much as a page of text. Judge only what a script can't:
- **Purpose and structure**: is the screen's one job obvious in two
  seconds? Is anything on the main screen that belongs one tap away or in
  Settings? (The step's spec says what it should be: "What's on screen".
  No spec: judge against the app's main job in SPEC.md or its first screen.)
- **Words on screen**: plain, specific, no jargon; buttons say what happens.
- **Hierarchy and calm**: one main action; bright colour only where it
  carries meaning; consistent with DESIGN.md and its style.
- **The 10 usability heuristics** (in the checklist), as a scan, not an essay.

## 3. Report
Lead with what matters most. For each finding: the screen and screenshot,
what's wrong in one line, the heuristic or checklist line it breaks, and a
suggested fix. Then the script's problems (only those it found), then
"Not checked" (anything skipped, and why). At most about 10 findings; no
praise, no style nits the checklist doesn't cover.
