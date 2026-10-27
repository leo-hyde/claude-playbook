# UX and design checklist

What to check; how to design is in `reference/design-method.md`. Started
from the Sport Conditions design review. Go through it before calling a
stage done, on a phone-sized screen (375px) and desktop, in light and dark.
Lines marked *(measured)* are checked by `tools/page-check.js`; don't
re-check them by eye.

## Purpose and structure
- [ ] The app's one job, and each screen's one job, can be said in a sentence.
- [ ] The first screen answers the main question in under 2 seconds
      (Sport Conditions: a "Next good session" headline card). Detail comes on tap.
- [ ] One clear primary action per screen.
- [ ] Every item on the main screen is needed every time; things needed now
      and then are one tap away; set-once things are in Settings with a
      default. Matches the spec's "What's on screen".
- [ ] Summaries before detail: long lists show the near future (e.g. today and
      tomorrow) with "Show all" to expand, and a hint of what's hidden
      ("3h good later").
- [ ] No dead ends: every screen offers a next step or a way back.

## Words on screen
- [ ] Things are named by what they mean to the person, not how they're
      built; no jargon or abbreviations a newcomer wouldn't know.
- [ ] Buttons start with a verb and say what happens ("Save walk", not
      "Submit" or "OK"), in sentence case. The same action keeps the same
      word through the flow (button "Save walk", message "Walk saved").
- [ ] Headings match the tab or button that leads there ("My sites" → "My sites").
- [ ] Short: one idea per line, everyday words. Read it aloud: it should
      sound like something a person would say.
- [ ] Units always shown (and switchable if people differ: mph/km/h/knots);
      dates, times and numbers in the user's local format (UK: 27 Oct, 14:05).

## Common patterns
- [ ] Navigation: a bottom tab bar with icons and words on phones (3–5 tabs);
      tabs at the top on desktop.
- [ ] Forms: one column, a label above each field (not just placeholder
      text), the right keyboard for the field (number, email), long forms
      split into short steps (one question per page).
- [ ] Form errors appear next to the field, and the first one gets focus.
- [ ] Settings grouped into short labelled sections; Save always in reach.
- [ ] Dialogs are bottom sheets on phones: grab handle, scroll inside,
      max-height ~92vh, primary button always visible (sticky action bar).
- [ ] Removing things is one tap with **Undo** rather than an "Are you sure?" box.
- [ ] Loading: something visibly happening (e.g. the refresh button spins;
      respect "reduce motion"); a button that's working keeps its label and
      can't be pressed twice.
- [ ] Errors say what happened and what to do, plainly, without "sorry",
      "please", "oops", "invalid" or error codes (e.g. "The free forecast
      service has reached its daily limit… try tomorrow or mobile data"),
      not a page of grey.
- [ ] Empty states say how to get started.
- [ ] Old data is better than no data: show the last saved copy, labelled.

## Colour carries meaning
- [ ] Bright colours only for what matters (good/OK). "No"/empty/past states
      are calm greys, so the important things pop. (A pink "no" everywhere
      made the screen shout.)
- [ ] Never colour alone: also words, symbols (✓ ~ ✕), shape or brightness
      (about 1 in 12 men are red–green colour-blind).
- [ ] A colour key wherever colours carry meaning.
- [ ] Text contrast at least 4.5:1 (check muted text on tinted backgrounds).
      *(measured; the library styles are checked by `tools/styles.py`)*
- [ ] Different kinds of thing look different (round site pins vs square
      "LIVE" tags for live readings), with a map key.

## Phone first
- [ ] **Nothing wider than the screen.** One row that doesn't wrap makes the
      phone zoom out the whole page, so it looks like a shrunken desktop site.
      *(measured: `scrollWidth` at 375px)*
- [ ] Tap targets at least 44px on phones (small chips at least 32px) and
      24px on desktop: bigger, closer targets are quicker to hit (Fitts's
      law). *(measured)*
- [ ] Inputs at least 16px font (smaller makes iPhones zoom in). *(measured)*
- [ ] Never block zooming or pasting.
- [ ] Long names wrap rather than being cut off where they matter; layouts
      cope with very short and very long text.
- [ ] Wide tables scroll sideways with the first column fixed.

## Accessible to everyone
- [ ] Real HTML elements: `button` for actions, `a` for links, a `label` for
      every input; buttons with only an icon have a name (`aria-label`).
- [ ] Headings in order (one `h1`, then `h2`…); the page `<title>` says
      where you are.
- [ ] Everything works with a keyboard, with a visible focus ring.
- [ ] Toasts and updates that appear by themselves are announced to screen
      readers (`aria-live="polite"`).
- [ ] axe-core finds no serious problems. *(measured)*

## Visual system
- [ ] Colours, spacing, corners and fonts come from the app's style tokens
      (CSS variables) in one place, with a dark-mode set that follows the
      device. No one-off values.
- [ ] Numbers that line up use `tabular-nums`.
- [ ] Spacing in multiples of 4px; inner corners no rounder than the box
      around them.
- [ ] Charts: one axis (never two), thin lines, a legend for 2+ series, a
      readout that follows your finger, a table view, and colours that work
      for colour-blind people.

## Not generic (the common tells of AI-made design)
- [ ] One memorable thing per screen; everything else quiet.
- [ ] None of these unless the style or the user asks for them: all-capitals
      labels above headings; one word in a headline picked out in another
      colour or italics; everything chopped into identical rounded cards
      with the same grey shadow; gradient washes as decoration; numbered
      markers (01 / 02) on things that aren't steps; "→" on every link;
      fade-in animations on every section.
- [ ] Cards and borders only around things that are separate objects.

## The 10 usability heuristics (Nielsen Norman Group), as a final scan
1. **Visibility of system status**: people can see what's happening
   (loading, saved, last updated).
2. **Match between the system and the real world**: their words and
   order, not the system's.
3. **User control and freedom**: an easy way back, cancel and undo.
4. **Consistency and standards**: the same word and look for the same
   thing; usual conventions.
5. **Error prevention**: good defaults and constraints before error messages.
6. **Recognition rather than recall**: options visible; nothing to remember
   between screens.
7. **Flexibility and efficiency of use**: quick paths for frequent use
   that don't get in a newcomer's way.
8. **Aesthetic and minimalist design**: nothing on screen that isn't
   needed now.
9. **Help users recognise, diagnose and recover from errors**: plain
   message, the cause, the fix.
10. **Help and documentation**: a short hint where people get stuck, not a
    manual.
