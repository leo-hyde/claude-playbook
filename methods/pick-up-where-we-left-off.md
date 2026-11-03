# Pick up where we left off

**Version 1.0 · 3 Nov 2026 · Status: in use; first tried in a pilot project**

| | |
|---|---|
| **When to use** | The start of a session, or "where are we?", "what's next?", "carry on" |
| **Inputs** | README.md, PLAN.md, the open pull requests, docs/decisions.md; session start's lines |
| **Output** | A reply of at most five lines: where it stands, what's open, what needs the user, what you suggest next |
| **Done when** | The user can say what the repo must do, how far through it is, and what's open, without opening another file |
| **Record** | Nothing new, unless something was out of date (fix it in its one home) |

Based on Anthropic's advice for long-running agents (a feature list and
progress each session reads) and Kanban (look at the board before pulling
new work).

## Steps
1. **Read README.md and PLAN.md**: the goal, the objectives, and the
   feature list from Now down.
2. **Read the open pull requests** (session start lists them; in a cloud
   session with no GitHub CLI, use the GitHub tools): each description says
   where it got to and what's next. Note any marked `paused`, and paused
   ones over two weeks old.
3. **Read the decisions waiting**: entries marked *proposed* in
   docs/decisions.md (session start lists them).
4. **Check the board matches.** Every Now or Paused line has an open pull
   request, and every open pull request has a line. Session start lists
   branches without a pull request, at any age: say what each holds.
5. **Reply in five lines at most**: where it stands; what's in progress or
   paused (with links); what needs the user (decisions, paused pull
   requests over two weeks to keep or close, branches without a pull
   request); what you suggest next and why; anything you couldn't check.

## Stop and ask the user
- Before picking up a paused pull request, closing one, or deleting a
  branch: these are the user's call.
- Over five open pull requests: suggest which to finish or close first.
