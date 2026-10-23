# Instructions for Claude

Claude reads this file automatically at the start of every session in this
project, including cloud sessions started from Leo's phone. It says *how* we
work; [SPEC.md](SPEC.md) says *what* we're building; [DESIGN.md](DESIGN.md)
says how it looks; [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md) says how it's built.

## About this project
- <One line: what the app does.> Live at https://leo-hyde.github.io/<repo>/
- Leo is learning to build apps with AI, aiming to be a proficient and
  responsible AI developer. Understanding what's built, and that it's safe and
  reliable, matters as much as the output.

## How to work
- **Build from SPEC.md.** If something isn't in it, or is unclear, ask first.
  Propose changes to SPEC.md before building them.
- **One step at a time**, unless Leo asks for several agreed steps in one go:
  then build them all, commit after each, and stop for review at the end.
- **Follow DESIGN.md** for anything visual; add new components to it.
- **Small, readable code.** Plain HTML/CSS/JS with `<script>` tags (no ES
  modules, no build step) so it opens by double-clicking `index.html`.
  Libraries from a CDN with exact versions.
- **Check before saying it works:** browser preview at phone width (375px) and
  desktop, light and dark; then the live site after pushing.
- **Push to GitHub after every commit**, so Leo can carry on from a phone.
  `git pull` before starting. Pushing to `main` updates the live site, so only
  commit working, tested steps.
- **Free services have usage limits** (often per internet connection, shared with
  Leo's devices): few test requests, cache data, made-up data for design work.

## How to explain the work
Leo learns by understanding and checking what's built, not by tinkering:
don't suggest "try this" changes.
- **Keep docs/ARCHITECTURE.md current** in the same commit as any change to
  the structure, data flow, outside services or weak spots.
- **After each feature, a short walkthrough:** what changed and why; which
  files and how data flows; the 2–3 lines that matter most; **how it was
  checked (and what wasn't)**; risks and anything unverified.
- **Record decisions with their reasons** (STATUS.md).
- **Flag safety and responsibility:** secrets, privacy, typed text and links,
  data sources' terms, limits, and where the app could mislead.
- Explain new terms the first time they come up. Keep it short.

## Working efficiently (AI usage)
- One feature or batch of feedback per session; STATUS.md carries the memory.
- Don't read big data files whole; search them.
- Check changes with the project's preview/check script, not new test code.

## Project notes
- <Where data comes from, how it's stored, anything non-obvious.>
- Pushing from Leo's Mac:
  `git -c credential.helper= -c credential.helper='!/opt/homebrew/bin/gh auth git-credential' push`
- Previewing on Leo's Mac: the project is under Documents, which macOS blocks
  the preview server from reading; copy files to the scratchpad and serve them
  with a no-cache server (the `/new-app` skill's `tools/serve.py`).
