# Matching a client's style

Read when an app should look like a client's brand instead of a style from
the playbook's library (`styles/`). The result is a style in the same shape
as the library's, so the rest of the design method works unchanged.

## Before starting
- **The client's style lives in the client's project only**, never in the
  playbook (which is public) and never in another client's repo. If that
  project's repo is public, check with the user first: a brand guide may be
  confidential even when the website isn't.
- **Ask the user to confirm the client is happy** for their look to be used
  in this app. Note the answer in the project's `docs/decisions.md`.
- Use the client's own material, in this order: their brand guidelines
  document (best), their live website, screenshots the user sends.

## Steps
1. **Collect the facts, don't guess them.** From the brand guide, copy the
   colour values, fonts and any rules ("logo never on red"). From the website,
   read its stylesheet: the `:root` custom properties (CSS variables) if it has
   them, otherwise the colours and fonts actually used on its main page,
   buttons and links. Save the raw notes to the scratchpad; only the values
   enter the conversation. Use the `scout` subagent if there's a lot.
2. **Map them onto the playbook's tokens** (the names in
   `templates/style.css`): page background, card surface, text, secondary
   text, border, accent (their main brand colour, if it reads well as a
   button), status colours. Brands rarely give all of these: derive the
   missing ones from their palette and say which ones you derived.
3. **Make a dark theme** if the brand has none: darken the neutrals, keep
   the accent recognisable, and say it's derived, not the client's.
4. **Check contrast.** Brand colours often fail as text colours (a pale
   brand colour on white). Keep the brand colour for large areas or buttons
   and use a darker shade for text and links. Check the same pairs as
   `tools/styles.py` (text on page and cards, secondary text, links, button
   text, errors): at least 4.5:1. The quickest way is to add the style to a
   scratch copy of `styles/candidates.json` and run the tool's check there.
5. **Fonts: check the licence.** Many brand fonts are paid and licensed per
   website. If the client can't give a web licence (or font files they're
   allowed to share), use the closest free font from Google Fonts and say
   so. Self-hosting the font files keeps visitors' details from Google;
   linking Google Fonts is simpler. Note which one you chose.
6. **Write the project's files**: replace the token blocks at the top of its
   `style.css` and fill in its `DESIGN.md` (Inspiration: the client and
   where the values came from; tokens; type; do's and don'ts from the brand
   guide). Logos and images only as the client supplies them.
7. **Show one sample screen** (a real screen of the app, or the gallery's
   sample) in light and dark, on phone and desktop, and ask the user to
   check it against the client's site before building more.

## Don't
- Copy the client's look into the playbook, or a client's name into
  anything public.
- Copy another company's brand (logo, name, trademarked look) for a client
  who isn't that company.
