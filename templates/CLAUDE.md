# Instructions for Claude

Claude reads this file automatically at the start of every session in this
project, including cloud sessions started from Leo's phone. It says *how* we
work; [SPEC.md](SPEC.md) says *what* we're building; [DESIGN.md](DESIGN.md)
says how it looks.

## About this project
- <One line: what the app does.> Live at https://leo-hyde.github.io/<repo>/
- Leo is learning to code while building it. Teaching matters as much as the output.

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

## How to teach
- After each step, explain in plain language what was added and why, pointing
  to the 2–3 most important lines of code.
- Suggest one small change Leo can try.
- Explain new terms the first time they come up. Keep it short.

## Project notes
- <Where data comes from, how it's stored, anything non-obvious.>
- Pushing from Leo's Mac:
  `git -c credential.helper= -c credential.helper='!/opt/homebrew/bin/gh auth git-credential' push`
- Previewing on Leo's Mac: the project is under Documents, which macOS blocks
  the preview server from reading; copy files to the scratchpad and serve them
  with a no-cache server (the `/new-app` skill's `tools/serve.py`).
