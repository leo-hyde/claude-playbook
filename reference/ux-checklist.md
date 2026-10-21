# UX and design checklist

From the Sport Conditions design review. Go through it before calling a
stage done, on a phone-sized screen (375px) and desktop, in light and dark.

## Glance first
- [ ] The first screen answers the main question in under 2 seconds
      (Sport Conditions: a "Next good session" headline card). Detail comes on tap.
- [ ] Summaries before detail: long lists show the near future (e.g. today and
      tomorrow) with "Show all" to expand, and a hint of what's hidden
      ("3h good later").
- [ ] One clear primary action per screen.

## Colour carries meaning
- [ ] Bright colours only for what matters (good/OK). "No"/empty/past states
      are calm greys, so the important things pop. (A pink "no" everywhere
      made the screen shout.)
- [ ] Never colour alone: also words, symbols (✓ ~ ✕), shape or brightness
      (about 1 in 12 men are red–green colour-blind).
- [ ] A colour key wherever colours carry meaning.
- [ ] Text contrast at least 4.5:1 (check muted text on tinted backgrounds).
- [ ] Different kinds of thing look different (round site pins vs square
      "LIVE" tags for live readings), with a map key.

## Phone first
- [ ] **Nothing wider than the screen.** One row that doesn't wrap makes the
      phone zoom out the whole page, so it looks like a shrunken desktop site.
      Check `document.documentElement.scrollWidth === innerWidth` at 375px.
- [ ] Main navigation is a bottom tab bar with icons on phones; tabs at the top
      on desktop.
- [ ] Tap targets at least 44px (small chips at least 32px).
- [ ] Inputs at least 16px font (smaller makes iPhones zoom in).
- [ ] Dialogs are bottom sheets on phones: grab handle, scroll inside,
      max-height ~92vh, primary button always visible (sticky action bar).
- [ ] Long names wrap rather than being cut off where they matter.
- [ ] Wide tables scroll sideways with the first column fixed.

## Structure and wording
- [ ] Headings match the tab or button that leads there ("My sites" → "My sites").
- [ ] Settings grouped into short labelled sections; Save always in reach.
- [ ] Units always shown (and switchable if people differ: mph/km/h/knots).
- [ ] Removing things is one tap with **Undo** rather than a "Are you sure?" box.

## States
- [ ] Loading: something visibly happening (e.g. the refresh button spins;
      respect "reduce motion").
- [ ] Errors explain what happened and what to do, in plain words, not a
      page of grey (e.g. "The free forecast service has reached its daily
      limit… try tomorrow or mobile data").
- [ ] Empty states say how to get started.
- [ ] Old data is better than no data: show the last saved copy, labelled.

## Visual system
- [ ] Colours, spacing and corner sizes come from design tokens (CSS
      variables) in one place, with a dark-mode set that follows the device.
- [ ] System font; `tabular-nums` for numbers that line up.
- [ ] Spacing in multiples of 4px; soft shadows (light mode only).
- [ ] Charts: one axis (never two), thin lines, a legend for 2+ series, a
      readout that follows your finger, and a table view.

## References
- Apple Human Interface Guidelines (tap targets, hierarchy, legibility)
- *Refactoring UI* (spacing, contrast, restraint)
- WCAG 2.2 (contrast, don't rely on colour alone)
