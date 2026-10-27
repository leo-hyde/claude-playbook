# Spec: a playbook others can copy

Status: **built** (27 Oct 2026), waiting for the second release.

## Goal
Anyone can read, copy or fork the playbook and use it for their own work.
- The general rules talk about "the user", not a named person.
- Everything specific to one owner (accounts, devices, how they like to
  work) sits in one small folder, `owner/`, that someone copying the repo
  replaces.

## Done (27 Oct 2026)
- Wording made general in the files no project syncs, so they reach no
  project before a release:
  - README, SKILL.md, CLAUDE.md, personal-CLAUDE.md;
  - `docs/`, `reference/`, `templates/`.

  "Leo" became "the user", and private project names became general
  descriptions. Facts and history are unchanged.
- `owner/profile.md` created: the owner's accounts, devices and working
  preferences. Reference files point to it instead of repeating account
  details.

## Still to do (ships in the same release as efficient-sessions)
Changing `shared/` reaches every project, so it waits for the release
process ([playbook-releases.md](playbook-releases.md)). It also touches the
same rules file as the trim, so doing both at once avoids two rewrites.

1. **`shared/ai-dev-rules.md` and the scripts:**
   - "Leo" becomes "the user", and "Tell Leo" in script messages becomes
     "Tell the user".
   - The "About Leo" section moves to `owner/profile.md`.
   - The owner's GitHub noreply address moves there too, as the rule "commit
     with the address in `.claude/rules/owner.md`".
2. **Sync the owner file:** add `owner/profile.md:.claude/rules/owner.md` to
   `FILES` in `playbook-sync.sh`. Claude Code loads every file in
   `.claude/rules/`, so cloud sessions see it.
3. **One place for the playbook's address:** `PLAYBOOK_URL` at the top of
   `playbook-sync.sh` is the only line a fork changes there. The Mac clone
   path `~/.claude/skills/new-app` stays as it is: it's not personal.
4. **Move `personal-CLAUDE.md` to `owner/personal-CLAUDE.md`.** Update the
   Mac set-up command in README, and tell the user to re-copy it.
5. **README, "Using this playbook yourself":** fork it, edit `owner/`, change
   `PLAYBOOK_URL`, set up a project. Plus a line on what the playbook
   assumes: a Mac and phone, GitHub, Claude Code.
6. **The project templates' placeholders** already use `<github-user>`;
   check none are left with the owner's name.

## Out of scope
- Rewriting history to remove the owner's name or email from old commits
  (rejected 23 Oct: needs a force-push on every repo).
- Making the playbook work without GitHub or without a Mac.

## How we'll know it's done
- `grep -rniE 'leo|\bhis\b|\bhe\b'` outside `owner/` and `docs/decisions.md`
  history finds nothing personal.
- A test project synced from the release has `.claude/rules/owner.md`.
- A fork that changes only `owner/` and `PLAYBOOK_URL` syncs from itself.
  (Test it with a local fork in `tests/run.sh`.)

## Decisions for the user
1. **A licence**, if others may copy it. A public repo without one is
   readable, but legally not reusable. Recommended: MIT for the scripts and
   CC BY 4.0 for the text, or MIT for everything to keep it simple. Your
   call.
2. **The example projects** (Sport Conditions, AEC Tech Radar) stay named in
   the README and history as public examples. Private ones are described in
   general terms. Recommended.

## Progress
- 27 Oct 2026: non-synced files made general; `owner/profile.md` created.
- 27 Oct 2026: the rest built on branch `second-release`, for the second
  release. `shared/` says "the user"; "About Leo" and the private-topics list
  are in `owner/profile.md`, synced as `.claude/rules/owner.md`;
  `PLAYBOOK_URL` is the first line of `playbook-sync.sh` and the only one
  naming the owner (the tests check this); `personal-CLAUDE.md` moved to
  `owner/`; README has "Using this playbook yourself"; MIT licence (the
  user's choice). Templates had no owner names left. A test syncs a project
  from a local fork that changed only `owner/` and `PLAYBOOK_URL`.
  The example projects stay named in the README (recommended decision 2).
