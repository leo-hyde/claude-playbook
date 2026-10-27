# The style library

How a new app looks. Pick a style at the kick-off, copy it in once, and from
then on the app's own `style.css` and `DESIGN.md` are the truth (styles
here don't sync into apps). Claude reads this file only when choosing or
applying a style.

**See them:** `gallery.html` shows the same sample screen in every candidate
style, in light and dark. Open it by double-clicking, or ask Claude to
publish it as a private page to view on a phone.

## In the library
| Style | Feel | Good for |
|---|---|---|
| `clear` | Cool grey, white cards, one blue (the default) | Glanceable utility apps |
| `paper` | White, warm greys, thin lines, airy | Notes, lists, mostly text |
| `ledger` | Pale blue-grey, navy text, vivid indigo | Money, bookings, forms |
| `field` | Warm greige, amber button, sturdy | Hobby and outdoor apps, logs |
| `nord` | Muted snow and arctic blue, restful | Habits, reading, calm dashboards |
| `night` | Dark first, charcoal layers, lavender-blue | Long sessions, dark-mode apps |

The gallery also has candidates not in the library (`indigo`, `ink`,
`market`, `calendar`, `mint`, `winter`, `corporate`). To move one in or out,
set `"in_library"` in `candidates.json`, write its `DESIGN.md` if it's new
(same shape as the others), and run `python3 tools/styles.py build`.

## Applying a style to an app
1. Copy `<style>/tokens.css` over the two token blocks at the top of the
   app's `style.css` (from `templates/style.css`).
2. If the tokens file names a web font, add its `<link>` to `index.html`.
   Google Fonts is simplest; it tells Google each visitor's address, so for a
   public app that matters, download the font files and serve them with the
   app instead.
3. Start the app's `DESIGN.md` from `templates/DESIGN.md`: set its
   **Style** line, put the style's principles into "Principles" (after the
   template's own), and fill the tokens table from `tokens.css`.
4. Show the user one real screen in light and dark before building more.

A client's brand instead of a library style: `reference/client-style.md`.

## Changing a style
Edit `candidates.json` (the one source), then `python3 tools/styles.py build`
and `python3 tools/styles.py check`. The check fails any colour pair under
4.5:1 contrast (text, secondary text, links, button text, errors, status
labels) and any file out of date with the source. The playbook's tests run
it. Every value in `candidates.json` says, in its `notes`, which came from the
source and which were adjusted or derived.

## Where they come from (all free)
- **awesome-design-md** (VoltAgent, MIT licence): descriptions of well-known
  sites' design systems, `github.com/VoltAgent/awesome-design-md`. The styles
  based on them are *inspired by* those sites: plain names, no logos or
  brand names in apps, paid fonts swapped for free ones. They aren't
  affiliated with, or endorsed by, those companies.
- **daisyUI** themes (version 5.7.47, MIT licence, © Pouya Saadeghi):
  colours converted from OKLCH (a colour format) to hex.
- `clear`: the playbook's own, from Sport Conditions.
