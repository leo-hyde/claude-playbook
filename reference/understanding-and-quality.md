# Understanding what AI builds, and building it well

How professional teams make sure software is understood, good and safe,
scaled down for one person building with Claude. Use these because they work,
not as paperwork: every document is short and kept current, and none is
written "just in case".

## 1. The documents

What professionals use, and the lightweight version we keep in each project.

| Industry practice | The question it answers | Ours |
|---|---|---|
| Product spec / requirements, with acceptance criteria | What are we building, for whom, and how do we know a step is done? | `SPEC.md`: numbered steps, each visible when done; `specs/<feature>.md` for bigger features (`templates/specs/feature.md`) |
| Architecture overview (the "C4 model": a context diagram and a containers diagram) | What are the parts, how does data flow, what do we depend on? | `docs/ARCHITECTURE.md`, with a diagram GitHub draws from text ("Mermaid") |
| Architecture Decision Records ("ADRs") | Why did we choose X over Y? | `docs/decisions.md`: date, decision, why, what was rejected (`templates/decisions.md`) |
| Design system | How does it look and behave? | `DESIGN.md` |
| Threat model / security review | What could go wrong, and who could misuse it? | "Safety and security" in ARCHITECTURE.md; a `/security-review` before big releases |
| Automated tests, and a test plan | Does it still work after a change? | Tests for the core rules; a preview script with made-up data |
| Background ("the why") | Why does this project exist, for whom, what came before? | `docs/CONTEXT.md`, only where a project needs one |
| Changelog / release notes | What changed, when? | Commit messages; a `CHANGELOG.md` only where the user needs one (Sport Conditions: for feedback) |
| Runbook | How is it deployed and kept running? | "Outside services" in ARCHITECTURE.md; `reference/github-and-hosting.md` |
| Code review (pull requests) | Did a second person check it before it went live? | Claude's walkthrough; a fresh session reviewing with `/code-review` |

Template: `templates/ARCHITECTURE.md`.

## 2. The loop for each feature

1. **Spec it** in SPEC.md or `specs/<feature>.md`, including what's out of
   scope and how we'll know it's done. Then build it in a **fresh session**
   (Anthropic's best-practice guide: write the spec, then run it in a new session).
2. **Design note first** for anything structural: which files change, how
   data flows, any new outside service, risks. Agree it before code.
3. **Build in small commits**, each one working.
4. **Verify with evidence, not assurances.** Automated tests for logic; the
   preview at phone and desktop size, light and dark; the live site after
   pushing. "It works" from an AI isn't evidence; a check you can see is.
5. **Walkthrough:** what changed and why, which files, how data flows, the
   2–3 lines that matter, **how it was checked and what wasn't**, risks.
6. **Record:** update the docs the change touched, in the same commit:
   SPEC.md if the plan, scope or a step's status changed; `docs/decisions.md`
   for a choice; ARCHITECTURE.md for structure; always STATUS.md ("Keeping
   the docs true" in `shared/ai-dev-rules.md`).

## 3. Telling good AI code from junk

AI is fast and usually right, but it can invent things confidently
("hallucinate"). Defences:

- **"How do you know?"** Facts about outside services (an API's fields, its
  terms, its limits) should come from their documentation or a real test.
  When Claude can't check, it should say so and mark the data as unverified
  (e.g. surf spot details "from Claude's general knowledge").
- **Watch for invented specifics:** web addresses, IDs, API fields, library
  functions. Claude should look them up or leave a clear gap (e.g. a search
  link instead of a made-up Surfline page address).
- **Tests catch quiet breakage**, especially in rules that decide something
  (like ratings). Without them, a change can re-colour results wrongly and
  nobody notices.
- **Small changes are reviewable; huge rewrites are a warning sign.**
- **A second opinion:** a fresh session (or `/code-review`, `/security-review`)
  reads the code without the builder's assumptions.
- **If it can't be explained simply, be suspicious.** Every line should have a
  plain reason to exist.
- **Few dependencies, exact versions.** Each library is code you trust blindly.

## 4. Responsible by default

- **Secrets** (API keys, tokens) never go in browser code or the repository:
  they go in the server's (Worker's) secrets or GitHub secrets.
- **People's data:** collect the minimum, say where it goes, and remember a
  public repository is public (e.g. feedback issues).
- **People's input:** "escape" typed text before showing it; check links
  (no `javascript:` links); check anything a server accepts.
- **Other people's data:** respect sources' terms, limits and credits (link
  to Surfline rather than copying it; ask Flybubble before publishing).
- **Accessibility:** contrast, never colour alone, big enough tap targets.
- **Honesty in the product:** label approximate data, show what a rating is
  based on, and say plainly when something (like a forecast) can be wrong,
  especially for risky activities.
- **Reliability:** cache answers, cope with failures, show old data labelled
  as old rather than nothing.

## 5. Becoming proficient

- Read each project's ARCHITECTURE.md; ask Claude to walk through one file
  or one data flow at a time.
- Learn the core ideas as they come up: how the web works (requests,
  HTTP, APIs, JSON), browser vs server, CORS, caching, git (commits,
  branches, pull requests), testing.
- Add professional habits one at a time, as projects grow: automated
  tests → tests running on every push (CI, with GitHub Actions) → changes
  through pull requests with a review → a staging copy of the site.

## 6. Using AI efficiently

Moved to [efficient-sessions.md](efficient-sessions.md) (27 Oct 2026): how
cost works, the habits and why, the dated assumptions, the monthly review.
