# Gotchas: things that went wrong, and the fixes

## Free usage limits
- Open-Meteo allows 10,000 calls a day **per internet connection**. Heavy
  testing (map with ~100 places per pan, plus a 144-point wind grid, reloaded
  many times) used it all up, and blocked Leo's own devices on that wifi
  until the next day. Fixes now standard:
  - keep (cache) answers for ~30 minutes in the browser's Cache Storage;
    show old copies if the service refuses;
  - after a "daily limit" refusal, stop asking until the user presses refresh;
    don't auto-retry it;
  - only fetch extras (nearby places, wind grids) once zoomed in, in batches;
  - use made-up data for design reviews; open the page once, not repeatedly.
- Explain refusals in the app, in plain words. A page of grey dots with no
  reason looked like a bug.

## Preview and browsers
- macOS blocks the preview server from reading `~/Documents`. Copy the site
  to the scratchpad and serve it with `tools/serve.py`.
- Python's basic server queues only 5 connections, so pages with many files
  randomly failed ("connection reset"); `serve.py` raises that and turns off
  caching. Without that, the browser kept showing old files.
- The preview pane's "hidden" ≠ closed: ask Leo to press Cmd+Shift+B to see it.
- A CSS `display: …` rule overrides the `hidden` attribute; add
  `[hidden] { display: none !important; }`.
- Two buttons with the same `aria-label` on a page: scope test selectors to
  the dialog you mean.

## Layout
- One non-wrapping row (e.g. two dropdowns side by side) made the page 557px
  wide, so phones zoomed out and it looked like a desktop site. Always let rows
  wrap and check scroll width at 375px.

## JavaScript (plain script tags)
- All `<script>` files share one global scope: two files declaring the same
  name (e.g. a variable and a function both called `directionRatings`) breaks
  the later file. Pick distinct names.
- A variable called `window` shadows the browser's `window`.
- `dialog.showModal()` on an already-open dialog throws; check `dialog.open`.
- User-typed text going into `innerHTML` must be escaped.
- Keep the site openable by double-clicking `index.html`: no ES modules,
  libraries from a CDN with exact versions.

## Data and APIs
- Check a source works from a browser (CORS) before planning around it:
  `curl -sI <url> -H "Origin: http://localhost:8000" | grep -i access-control`.
- Map tile and data providers change terms (CARTO now needs a key).
- Check unknown URL formats before linking to them (e.g. that a link really
  opens the right place).
- Times from APIs: note the time zone (Admiralty sends UTC; the app works in
  UK time).

## Working together
- Leo's messages are sometimes quick or cut off: confirm the unclear bit
  instead of guessing (e.g. a sentence ending "on the overview").
- Sites/data saved "in the browser" are per device: say so up front, and offer
  sync if it matters.
- Using third-party data (e.g. a site list from another website): flag it
  before publishing it publicly, and let Leo decide.
