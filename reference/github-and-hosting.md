# GitHub, hosting and a Cloudflare Worker: exact steps

What worked for Sport Conditions. `<github-user>` below is the owner's GitHub
account, and the Mac's `gh` path and push command are in `owner/profile.md`
(check the login with `gh auth status`).

## Git basics
```bash
git init -b main
printf '.claude/\n.DS_Store\n' > .gitignore
git add -A && git commit -m "First version"
```
Set the author once per project if git asks:
`git config user.name "<your name>"` and `git config user.email "<the noreply address in owner/profile.md>"`
(GitHub → Settings → Emails → "Keep my email addresses private" shows it, ending
`@users.noreply.github.com`). Never a real email address: public repos show it to anyone.

## Create the GitHub repository and push
Ask the user first: public or private? (Public is needed for free GitHub Pages.
Check nothing private, secret or someone else's data is in it.)

**From a cloud (phone) session, Claude can't create the repository**: the
GitHub connection there is refused (403) for creating repos (Oct 2026). Build
the project locally in the session, then ask the user to create an *empty*
repository on github.com (no README, licence or .gitignore, so the first push
doesn't conflict), and attach it with `add_repo` before pushing.
```bash
/opt/homebrew/bin/gh repo create <github-user>/<name> --private --source . --push
# or: create it on github.com, then
git remote add origin https://github.com/<github-user>/<name>.git
git -c credential.helper= -c credential.helper='!/opt/homebrew/bin/gh auth git-credential' push -u origin main
```
The `-c credential.helper…` part lets git use the GitHub CLI's login without
changing the user's global git settings.

## Free hosting: GitHub Pages
```bash
/opt/homebrew/bin/gh api -X POST repos/<github-user>/<name>/pages -f "source[branch]=main" -f "source[path]=/"
```
The site appears at `https://<github-user>.github.io/<name>/` a minute or two after
each push. Check a build: `gh api repos/<github-user>/<name>/pages/builds/latest --jq .status`.
A custom domain (about £5–12 a year) can point at it for a memorable address.

## GitHub Actions (automatic checks)
`templates/site-check.yml` is the pattern: when a data file changes (even if
edited on github.com from a phone), check it, rebuild what depends on it,
commit the result, and republish Pages. If the check fails, GitHub emails the user.
Pushing workflow files needs the `workflow` token scope (the user's login has it).

## Cloudflare Worker (free)
Use one when the app needs to:
- call a service that **blocks browsers** (no CORS header), e.g. aviationweather.gov,
- use a **secret API key** (stored as a Worker secret, never in the app's code),
- **sync data between devices** (Cloudflare KV storage).

Claude can't create accounts or deploy, so give the user these steps:
1. dash.cloudflare.com → **Workers & Pages → Create → Create Worker** → name → **Deploy**.
2. **Edit code** → replace everything with the Worker file → **Deploy**.
3. Secrets: Worker → **Settings → Variables and Secrets → Add** (type Secret).
4. Storage: **Storage & Databases → KV → Create**, then Worker → **Settings →
   Bindings → Add → KV namespace** with the variable name the code expects.

Rules for Worker code (see `templates/worker.js`):
- Only proxy specific, validated requests (never an open proxy).
- Always return CORS headers, including on errors (wrap in try/catch).
- Cache answers (`caches.default`) to save calls.
- For browser POSTs, send `Content-Type: text/plain` to avoid an extra
  "preflight" request.
- Test with `curl` after the user deploys; "Hello World!" means the code wasn't replaced.

## Giving Claude more reach (Mac vs cloud)
- **Mac (local) sessions** use the user's own logins, so Claude can do more by
  itself: `gh` (create repos, switch on Pages, push workflow files, add
  Actions secrets with `gh secret set`), and Cloudflare via its command-line
  tool: the user runs `npx wrangler login` once (it opens a browser), then Claude
  can deploy Workers with `npx wrangler deploy`. (Wrangler steps from
  Cloudflare's docs; not yet tested in one of the user's projects.) Claude still asks
  before anything public, paid or hard to undo.
- **Cloud sessions** only have the GitHub connection (no repo creation) and
  can't reach most websites. For Cloudflare there, the user creates a narrowly
  scoped API token in the Cloudflare dashboard and adds it to the cloud
  environment's settings (environment menu → Edit → secrets / environment
  variables), never pasted into the chat. Blocked websites: add them under
  the environment's Network access → Allowed domains.
- **GitHub Actions** run on GitHub with open internet whichever device started
  them: the way to fetch web pages on a schedule without the Mac. Their
  secrets live in the repo's Settings → Secrets and variables → Actions.

## When a repo turns public
Session start prints `THIS REPO IS NOW PUBLIC` when GitHub says a repo is
public but `.claude/repo-visibility` still says it was private.
1. Tell the user before anything else.
2. Review the files **and the git history**: deleted files stay in it.
   `git log -p --all | grep -iE '<pattern>'` for each kind of thing that
   shouldn't be public (secrets, keys, email addresses, real names, the
   private topics in `owner/profile.md`, internal web addresses).
3. List the findings with file and line, and propose fixes.
4. Run `scripts/session.sh visibility-ok` only once the user has seen the list.
5. Rewriting history is a force-push: never without the user's explicit go-ahead.

If unsure whether a repo is public, check its page on GitHub signed out.

## Issues and labels
- The rules use two labels: `claude-found` (Claude noticed it outside the
  task) and `idea` (a suggestion for the playbook). If one is missing:
  `gh issue create` fails, so first
  `gh label create claude-found --description "Found by Claude outside the task"`
  (or `idea`).
- No GitHub CLI (cloud sessions): use the GitHub tools to list, create,
  comment on and close issues.

## Working from a phone
- **Remote Control** (Claude desktop app): drive this Mac's session from the
  Claude app on the phone; the Mac must be on and awake.
- **Cloud sessions** (claude.ai/code, with GitHub connected): work on the repo
  with the Mac off. They read the project's CLAUDE.md but not this Mac's
  `~/.claude`, so key rules must be in the project's CLAUDE.md.
- Either way: push after every step, `git pull` before starting.

## Useful free services we've used
| Service | For | Notes |
|---|---|---|
| Open-Meteo | Weather forecasts (many models, incl. Met Office), place search, marine | No key. **10,000 calls/day per internet connection**; each place in a multi-place request counts |
| aviationweather.gov | Live airport reports (METARs) | Needs a Worker (no CORS) |
| UKHO Admiralty Tidal API (Discovery) | Official UK tide times | Free key; needs a Worker to hide it |
| Leaflet + OpenTopoMap | Maps | No key; CARTO tiles now need a key |
| leaflet-velocity | Animated wind particles | Feed it a u/v grid |
| Windy embed / links | Animated map, point forecasts | `windy.com/{lat}/{lon}?wind,{lat},{lon},11` opens a point forecast |
