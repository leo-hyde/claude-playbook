# How Leo and Claude work together (every project)

Personal instructions, loaded in every Claude Code session on this Mac.
A copy lives in github.com/leo-hyde/claude-playbook (`personal-CLAUDE.md`).
Project CLAUDE.md files add to these, and win where they differ.

## About Leo
- Learning to code by building real apps with Claude. Teaching matters as much
  as the result.
- Explain in plain language. Introduce new terms the first time ("API", "JSON",
  "commit"…). Keep explanations short; Leo will ask for more if needed.
- After building something, point to the 2–3 most important lines of code and
  suggest one small change for Leo to try.

## How we work
- **Plan first, then build.** For a new app or a big feature, agree the plan
  in short documents before writing code: SPEC.md (what), DESIGN.md (how it
  looks), CLAUDE.md (how to work on this project). The `/new-app` skill has
  templates. Don't do a lot of work that might go down the wrong path.
- **Small steps.** Each step ends with something Leo can see working. If Leo
  asks for several agreed steps in one go, build them all, commit after each,
  and stop for review at the end.
- **Ask about genuine ambiguity, decide the rest.** Spot contradictions in
  requests (e.g. an "OK" range inside a "good" range) and check them.
- **Say what's hard.** When asked for many things, flag the hard or expensive
  ones and skip them unless Leo insists.
- **Be honest about mistakes and limits**, including ones Claude caused.

## Git and GitHub
- Leo's GitHub account is `leo-hyde`; the GitHub CLI is at `/opt/homebrew/bin/gh`
  (may not be on PATH). Push with:
  `git -c credential.helper= -c credential.helper='!/opt/homebrew/bin/gh auth git-credential' push`
- **Commit and push after every working, tested step**, so nothing is stuck on
  one computer and Leo can carry on from a phone. `git pull` before starting.
- Plain-English commit messages that say what changed and why.
- **Phone and Mac share one memory: the repo.** Projects worked on from both
  have `docs/STATUS.md` (read first, update after every step) and a session
  lock (`scripts/session.sh`). See the playbook's `reference/phone-and-computer.md`.

## Checking work
- Don't say something works until it's been seen working: in the browser
  preview, at phone width (375px) and desktop, light and dark mode, and on the
  live site after pushing.
- **Free services have usage limits, often per internet connection, shared with
  Leo's own devices.** Keep test requests few, keep (cache) fetched data instead
  of refetching, and use made-up data for design work.

## Leo's Mac
- Projects live in `~/Documents/Documents - Leo’s MacBook Air/…`. macOS blocks
  the preview server from reading there, so copy files to the scratchpad and
  serve from there (the `/new-app` skill has a no-cache preview server).
- No Node.js or Homebrew Python tools assumed: plain HTML/CSS/JS and Python 3.9.
