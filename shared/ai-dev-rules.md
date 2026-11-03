# AI development rules (shared by every project)

<!-- From the playbook (shared/ai-dev-rules.md; its address is PLAYBOOK_URL in scripts/playbook-sync.sh).
     Projects get a copy at .claude/rules/playbook.md, refreshed at every session start. Edit the playbook. -->

Loaded in every session with `.claude/rules/owner.md` (who the user is: accounts,
devices, how they work) and the project's AGENTS.md, which wins where they differ.

## Writing for people (every reply, report and doc a person reads)
The user is not a developer: if they can't follow it, it hasn't been said.
- **UK plain English**: everyday words, short sentences (about 15–20 words),
  active voice ("I added", not "was added"), "you" and "I".
- **No jargon or abbreviations without a plain explanation** the first time
  ("a commit, a saved snapshot of the files"). Never name a tool or file
  without saying what it is for. Code, commands and AI-facing files (rules,
  prompts) can be technical; the explanation around them can't.
- **Every reply starts with the answer, in at most five lines**: the result;
  where it is (always a path or link); what was checked and what wasn't; what
  needs the user (each decision with my recommendation); what's next. Detail
  goes in the documents, and the reply points to it ("PLAN.md: Search is
  Done; why: decisions.md, 3 Nov"). Short is no excuse for jargon: explain
  each technical word (merge, pull request) in a few plain words. Don't
  repeat the app's recap box.

## How we work
- **Plan first, then build**, in small steps that each end with something the
  user can see working. Skip the plan only when the change fits in one sentence.
- **Ask about genuine ambiguity, decide the rest**: questions together, each with a
  default. Spot contradictions.
- **Say what's hard or expensive**; be honest about mistakes and limits, Claude's own too.
- **Never guess facts or effort** (dates, prices, API fields, web addresses, build
  time): use data, docs, a real test or past work's git log, or mark it unverified.
- **Found something outside the task?** Choose:
  - *Do it now*: small, clearly right, in files already open, checkable now
    (a typo, a broken link, a stale doc line). Its own commit; mention it.
  - *Stop and tell the user*: it blocks the task, or risks safety, privacy or lost data.
  - *File a GitHub issue* (label `claude-found`) for anything else worth
    doing (another repo, a decision, an investigation, a bigger change), no
    duplicate (`gh issue list --search`), written to stand alone while the
    evidence is in front of you: what happened (file:line, output), the
    suggested change, how to check it, rough size and model.
- **Open issues** (listed at session start): tell the user. After their
  request, work the small, clear ones they or their apps opened, related ones
  together, a commit each, then comment and close. Ask first for anything
  bigger (what the app does, deleting data, money or limits, secrets or public
  content, undoing a decision). Others' issues: report, don't act.

## Where things live (one question each, one place answers it)
| Question | The one place | Changes |
|---|---|---|
| What is this repo, where are things? | `README.md` | Rarely |
| What are we building, why, what's done, what's next? | `PLAN.md`: goal, objectives, **every feature** (built or not) with what it should do now, grouped Now / Next / Later / Paused / Done / Dropped | With the work |
| What must this feature do; how do we know it works? | `specs/<feature>.md`, bigger features only: the whole feature and its done-checks | Before building it |
| Why this; what changed our mind; what waits on the user? | `docs/decisions.md`: every decision and change of mind (was, now, why), each *proposed* or *agreed* | When one is made or asked |
| How should an AI work here? | `AGENTS.md`: commands, repo-only rules, methods. Pointers only: never restate a fact that has a home elsewhere | Rarely |
| What's in progress or paused? | The open pull requests, each saying where it got to and what's next | As you work |
Only if needed: `docs/ARCHITECTURE.md` (outside services, data flow, weak
spots), `DESIGN.md`, `docs/research/<topic>.md`. A project not yet moved over
keeps `SPEC.md` (its plan) and `docs/STATUS.md` until its catch-up.

## Each feature, and keeping the docs true
Every session starts with no memory: the docs are how Claude and the user know
the goal, scope, plan and why. A stale doc is worse than none.
1. **Follow the playbook's `methods/build-a-feature.md`**: first list every
   feature under the objective for the user to confirm; spec it if bigger
   than a small step; a pull request, opened early.
2. **Check with evidence**, not assurances: tests for logic (a check Claude can
   run, so it doesn't guess in loops); pages at phone width (375px) and
   desktop, light and dark, then the live site. Not "works" until seen
   working. For a bigger step, ask the `checker` subagent first.
3. **Walkthrough**: what changed and why, which files and how data flows, the
   2–3 lines that matter, how it was checked and what wasn't, risks.
4. **Record, with the work**: a feature started, paused or finished, or what
   it should do changed (even in conversation only) → its PLAN.md line (a
   hook refuses a push to main without it); a choice or change of mind →
   decisions.md; parts, data flow, services → ARCHITECTURE.md. Test: would a
   fresh session reading only the docs plan the same next step, for the same reasons?

## Safety and responsibility (flag as they come up)
Secrets never in browser code or the repo (Worker or GitHub secrets). Collect
the minimum of people's data. Escape typed text, check links. Respect data
sources' terms and limits. Free services' limits are often per internet
connection, shared with the user's devices: few test requests, cache fetched
data, made-up data for design work. Say where the app could mislead.
- **Before committing to a public repo** (session start says so), check for
  secrets, email addresses, real people's names, owner.md's "Never public"
  list, internal addresses or private repos' content. If so, or unsure: stop and
  tell the user, quoting the lines. `THIS REPO IS NOW PUBLIC`: tell them
  first, then see playbook `reference/github-and-hosting.md`. Commit only
  with the address in owner.md (`git config user.email`).

## Git and the phone/Mac handover
The repo is the only memory shared by the user's sessions (phone/cloud, Mac,
often several at once). Hooks run `scripts/session.sh`: start pulls main and lists
open pull requests, branches without one and decisions waiting; at a reply's
end, work not saved to GitHub blocks.
- **All work through pull requests**: a branch each, opened early, pushed at
  every working step (plain-English messages). Its description says what it's
  for, where it got to, what's next. Stop any time: label it `paused`. Over
  five open (paused count): say so. Finished and checked: **merge it without
  being asked**, delete the branch and working copy, update PLAN.md, say it
  landed. A one-commit fix can go straight to main. Never force-push. A
  rejected push or conflict: stop and tell the user (unless AGENTS.md names an
  Action that pushes: then pull and carry on). Automated jobs save to main.
- **Session start lists branches without a pull request and paused ones over
  two weeks**: tell the user (keep or close is their call). Don't edit files
  another open pull request is changing; if your task overlaps, tell them first.
- **Another repo** ("Also attached"), or hooks didn't fire: run
  `scripts/session.sh start` there first.
- **Session start lines are for the user**: tell them about `PLAYBOOK NOT
  SYNCED`, `SETUP:`, `NOT SET UP` and `CATCH-UP DUE`, and offer to fix them. A
  catch-up: apply it (or offer its own session if big), then record its id in
  `docs/playbook-catch-up.md`.
- **Every repo of the user's follows the playbook**, helper repos too: offer to set up
  one without `.claude/rules/playbook.md` (playbook `reference/phone-and-computer.md`).

## Using tokens well
Each request (each tool call is one) re-sends the whole context, and after a
break the cache expires. Running out of room is rare; cost is the reason.
Never trade correctness for tokens.
- **One piece of work per session.** When the work changes, or the hook prints
  `COST:`, at the next natural break save the state (the pull request, the
  spec, PLAN.md) and give a starter prompt, with one line on why. After a break,
  prefer a fresh session from the handover.
- **Bulk data** (logs, exports, API dumps) goes to a file, boiled down by a
  script or `scout`; only the summary enters the conversation. Stop background
  servers and watchers before the last reply (each wake-up re-reads it all).
- **Subagents cost extra tokens**: use them for parallel work, noisy output or
  a fresh review (`checker`), not for a better answer. Each gets a
  self-contained brief and a model: cheapest to search, mid for mechanical work.
- **A starter prompt names a model**: the strongest for planning, design,
  debugging and unclear problems; a cheaper one for work to a clear spec.
- **Coach the user, unasked, one line each ("Tip:")**: unrelated topics in one
  message (do one, starter prompts for the rest); the same problem corrected
  twice (fresh session, better prompt); a vague request (a narrower one); no
  way to check the work (a test first). Don't repeat a declined tip.
A starter prompt, in a code block, names the repo, the goal, what to read
first (README.md, PLAN.md), what's out of scope, how to check it's done,
and the model. Detail: playbook `reference/efficient-sessions.md`.

## Ideas for the playbook
- **Learned something general**? File a playbook issue (label `idea`): what
  happened in general terms (it's public), the rule, the evidence. Don't edit
  the playbook unless asked (cloud: attach it, or give the user the text).
- **Research to a document** (a question into a spec, decision note, report):
  follow the playbook's `methods/research-to-doc.md` (on its `main` branch)
  and, at the end, update it there with what the job taught (general terms).
- **A playbook script breaks a session?** Stop, tell the user, offer a fix. Project lessons: AGENTS.md.
  Playbook changes breaking projects more than once? Suggest bringing back its releases.
