# Instructions for AI assistants

<One line: what this repo is.> **Read [README.md](README.md) and
[PLAN.md](PLAN.md) first**, then the open pull requests.

Every AI tool working here reads this file (Claude Code through `CLAUDE.md`,
which imports it). The user's general rules load separately
(`.claude/rules/playbook.md`, `.claude/rules/owner.md`): don't repeat them.

<!-- Pointers, not copies: if a fact has a home elsewhere (README, PLAN.md,
specs/, docs/decisions.md, docs/ARCHITECTURE.md, DESIGN.md), link to it and
never restate it. No plans, status, history or descriptions of the code.
About 50-80 lines. -->

## Commands
- Check: <the project's test / preview / check command>
- Run: <how to open or run the app>

## Rules and traps for this repo
Only what lives nowhere else and an assistant would get wrong without it.
- <e.g. "pushing to main updates the live site", "a bot saves data to main daily">
- <Usage limits of the data sources, odd behaviours, things that went wrong.>
- Anything visual follows [DESIGN.md](DESIGN.md).

## Methods (written ways of doing recurring work)
From the playbook (`methods/`): build or change a feature
(`build-a-feature.md`), research to a document (`research-to-doc.md`), pick up
where we left off (`pick-up-where-we-left-off.md`).
This repo's own:
- <none yet. Add one after doing a job twice: when to use it, inputs, steps
  with "stop and ask" points, output, done check. Over three: a `methods/` folder.>

## Always / ask first / never
- **Always:** <e.g. run the check before opening a pull request>
- **Ask first:** <e.g. anything that changes what users' saved data looks like>
- **Never:** <e.g. hard-code the API key>
