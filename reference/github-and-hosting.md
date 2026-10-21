# GitHub, hosting and a Cloudflare Worker: exact steps

What worked for Sport Conditions. `gh` is at `/opt/homebrew/bin/gh` and Leo is
logged in as `leo-hyde` (check with `/opt/homebrew/bin/gh auth status`).

## Git basics
```bash
git init -b main
printf '.claude/\n.DS_Store\n' > .gitignore
git add -A && git commit -m "First version"
```
Set the author once per project if git asks:
`git config user.name "Leo Hyde"` and `git config user.email "leo@luanlabs.com"`.

## Create the GitHub repository and push
Ask Leo first: public or private? (Public is needed for free GitHub Pages.
Check nothing private, secret or someone else's data is in it.)
```bash
/opt/homebrew/bin/gh repo create leo-hyde/<name> --private --source . --push
# or: create it on github.com, then
git remote add origin https://github.com/leo-hyde/<name>.git
git -c credential.helper= -c credential.helper='!/opt/homebrew/bin/gh auth git-credential' push -u origin main
```
The `-c credential.helper…` part lets git use the GitHub CLI's login without
changing Leo's global git settings.

## Free hosting: GitHub Pages
```bash
/opt/homebrew/bin/gh api -X POST repos/leo-hyde/<name>/pages -f "source[branch]=main" -f "source[path]=/"
```
The site appears at `https://leo-hyde.github.io/<name>/` a minute or two after
each push. Check a build: `gh api repos/leo-hyde/<name>/pages/builds/latest --jq .status`.
A custom domain (about £5–12 a year) can point at it for a memorable address.

## GitHub Actions (automatic checks)
`templates/site-check.yml` is the pattern: when a data file changes (even if
edited on github.com from a phone), check it, rebuild what depends on it,
commit the result, and republish Pages. If the check fails, GitHub emails Leo.
Pushing workflow files needs the `workflow` token scope (Leo's login has it).

## Cloudflare Worker (free)
Use one when the app needs to:
- call a service that **blocks browsers** (no CORS header), e.g. aviationweather.gov,
- use a **secret API key** (stored as a Worker secret, never in the app's code),
- **sync data between devices** (Cloudflare KV storage).

Claude can't create accounts or deploy, so give Leo these steps:
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
- Test with `curl` after Leo deploys; "Hello World!" means the code wasn't replaced.

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
