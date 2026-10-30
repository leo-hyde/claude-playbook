# Research to a document: the method

**Version 1.0 · 30 Oct 2026, 18:00 (UK time) · Status: proposed; test on the next real deliverable**

Use this for any piece of work where a question has to become a document
people decide or build from: a feature spec, a design note, a decision
paper, a research summary, a plan. It is written for Claude; the user
approves at three points.

- **Summary:** what the method is and what it saves. Half a minute.
- **Plan and decisions:** the steps, who does what, the rules.
- **Detail:** templates, prompts, where it came from, how to test it.

## Summary
- **What it is:** a fixed order of steps from question to finished
  document. Claude works alone for long stretches; the user approves a
  short brief, makes one batch of decisions, and reads the finished
  document once.
- **Why:** in the project it came from, about half the user's time went on
  redoing earlier versions. The main cause was critique arriving after
  several polished versions, and the reader and format being chosen late.
- **What changes:** agree the reader and format first; critique the idea
  while it is a one-page outline; give the user one list of decisions at a
  time; never add a manual step without a reason; write each correction
  down so it is never needed twice.
- **Expected saving:** about 25–50% of the user's time (an estimate, low
  confidence, from one project).

## Plan and decisions

### The steps
Each step ends with a short, named output and says who acts next.

| # | Step | Output | Who acts next |
|---|---|---|---|
| 0 | **Explore** (only when the problem is unclear): talk it through; Claude answers each of the user's points by number and keeps a list of what is settled | ½ page: settled points, open questions | The user says "lock the brief" |
| 1 | **Brief**: the question in the asker's words; who reads the result and what they must do with it; the format; the deadline; the user's first idea in five lines; which checks the job needs (below) | ½ page | The user approves it; Claude goes on alone |
| 2 | **Problem space**: what the problem really is, and how others have solved it. Research runs in parallel (subagents); every source is dated | 1 page: problem statement, "how others solved it" table | Claude alone |
| 3 | **Outline**: the good-enough answer (and the great one, if different) on one page with one picture. For something to build, tag each feature now / later / maybe | 1-page outline | Claude alone |
| 4 | **Critique the outline**: a fresh AI critic with no stake in it asks "is this the best way? what's missing? what's overkill?" Claude makes the clear fixes | Short list: changed / not changed, and why | Claude turns the rest into decisions |
| 5 | **The user decides**: one numbered list, each item with Claude's recommendation | Decision list | The user, in one pass; Claude records answers in `docs/decisions.md` |
| 6 | **Write the document** once, for the named reader, in the agreed format. Then a fresh AI reads it as that reader and flags anything unclear | The document and a short check note | Claude alone; then the user reads it once |
| 7 | **Prove the hardest claim**, when there is one: a small prototype or test | Prototype or test result | Claude alone |
| 8 | **Review by others**, if anyone else must read it, through the project's review route (comments on a shared copy; the repo file stays the master) | Comments, then the updated master | Reviewers; then Claude |

For a **feature spec** in an app project, the output of step 6 is
`specs/<feature>.md` (from `templates/specs/feature.md`) and the SPEC.md row;
step 7 is often a spike, a throwaway test of the riskiest part.

**Scale the checks to the job** (chosen in the brief):
- **Always:** one fresh critic on the outline (step 4) and one reader check
  on the document (step 6).
- **Add a fact-checker** when readers will rely on factual claims (dates,
  figures, names, prices, API fields). It checks each against its source.
- **Add a method checker** only when estimates or a chain of reasoning
  carry the decision.
- **Phase the work (now / later / maybe)** only for something to build.

### Who works alone, and for how long
- **Claude, from an approved brief:** steps 2–4 in one go, stopping only at
  the decision list. From the decisions: steps 6–7 in one go, stopping at
  the finished, checked document. Stop early only for a blocker: a fact
  that can't be sourced, a decision that changes the scope, or anything
  touching private data, money or safety.
- **The user, meanwhile:** talks to colleagues or experts about the open
  questions, gathers sources, or works on something else.
- **Every handoff message** starts with three things only: what changed;
  the decisions needed, numbered, each with a recommendation; what wasn't
  checked. Then a link to the document.

### Two rules for Claude
1. **Automate first.** Propose the fully automated way first. Before
   offering a manual step, try at least two tools or approaches and say
   what failed; write the reason next to the step. People judging or
   deciding are not "manual steps"; they are the point.
2. **Corrections stick.** When the user corrects Claude, write the
   correction down in the same turn where later sessions will read it (a
   project rule: `CLAUDE.md`; one document: its notes; a general lesson: a
   playbook `idea` issue), and say where. Check each new version against
   those corrections before handing it over.

## Detail

### The three-part format
Every spec or decision document has a version line with date and time,
then three parts, each able to stand alone:
- **Summary:** what it is, why, what changes, what's next. Half a minute.
- **Plan and decisions:** the steps, who does what, the rules, and the
  open decisions, each with a recommendation.
- **Detail:** evidence, precise facts, how to test it, out of scope. Never
  cut precise details; they go here.
Change the Detail first, then bring the other two into line in the same
edit. End with a short change log.

### Brief template (step 1)
```
Question (asker's words):
Reader, and what they must do with it:
Format (spec / decision note / report / deck) and length:
Deadline:
First idea (five lines):
Checks: critic + reader [+ fact-checker] [+ method checker] [+ phasing]
Out of scope:
```

### Prompts for the fresh checkers
Run each as a subagent that has not seen the drafting conversation.
- **Critic (step 4):** "Here is a brief and a one-page outline. Is this the
  best way to answer the brief? What is missing? What is overkill? What
  would a sceptical expert say? List at most eight points, most important
  first."
- **Reader check (step 6):** "You are [the named reader]: [what they know,
  what they must do]. Read this document. List anything unclear, any
  jargon, anything you'd need to ask before acting, and the one thing you'd
  take away."
- **Fact-checker:** "List every factual claim (date, figure, name, price,
  field). For each, find the source given and say: matches / differs /
  no source. Don't judge the argument."
- **Method checker:** "Check the estimates and reasoning: are the inputs
  stated, the steps sound, the confidence honest? Say what would change
  the conclusion."

### Where it came from
A consulting project (Oct 2026) where one design document took about nine
rounds with the user. A retrospective of the session transcripts and git
history found:
- **Order caused rework.** The problem statement and critique came after
  six versions of elaboration and polish; the critique's changes then made
  the design too big, which took more rounds to undo. The reader format was
  chosen near the end.
- **Some rework was discovery, not waste.** The problem only became clear
  by working through it. Step 0 allows for this, but caps it.
- **The same point came up twice** on different days.
- **Manual steps were proposed three times** (starting in a spreadsheet by
  hand, adding pictures by hand, building slides by hand); each time an
  automated way existed once the user pushed.
- **A related piece of work went faster** with parallel research, then
  critique and fact-checking before the user read it. The fact-checker made
  about 12 corrections. It was narrower work, so this is a hint, not proof.

| Before | Now |
|---|---|
| Polish (pictures, rationale) from early versions | Polish only at step 6 |
| Critique on a polished version | Critique on the one-page outline |
| Phasing added late to undo complexity | Tagged at the outline, only for builds |
| Reader and format chosen late | Chosen in the brief |
| Long documents handed back to find what changed | A three-line handoff first |
| Points answered loosely | Answered by number; corrections written down |

### How to test it
Run it on a real deliverable and note at each handoff: the user's time;
rounds with the user; points raised twice; features added then cut after
the outline; manual steps proposed and why. **Passes if:** no point raised
twice, nothing added then cut after the outline, and noticeably fewer
rounds than before. A step that proves useless becomes optional, not
deleted. Record the result in this file's change log.

### Out of scope
Packaging this as its own skill (`/research-to-doc`) until it has been
tested on at least one real deliverable.

## Change log
- 1.0 (30 Oct 2026): made general from a project-specific version 0.3;
  project details removed; brief template and checker prompts added;
  feature-spec use added.
