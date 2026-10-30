# Spec: apps that don't look AI-made

Status: **proposed** (30 Oct 2026). Not started. Needs the user's answers to
"Decisions for the user" at the end.

## Goal
People who see the user's apps should not think "an AI made this". Each app
should look like someone chose its look on purpose, for its subject, while
staying as easy to use as now.

## The problem, with evidence
**What happened:** many people the user showed the apps to said they look
like every other AI-built app.

### Why AI-built apps look the same (outside research)
- **Models pick the most common choice.** Anthropic calls it "distributional
  convergence": without direction, the model samples from "the
  high-probability center" of its training data. For web pages that centre
  is the Inter font, purple gradients on white and little motion.
  (Anthropic, "Improving frontend design through Skills", 12 Nov 2025.)
- **The centre is one framework's defaults.** Tailwind CSS (the most popular
  styling kit) used indigo for every button in its paid examples. Most
  developers never changed it, so a huge amount of public code shares that
  look. Tailwind's creator joked about it on X in August 2025. AI-built sites
  that go live become new training data, so the loop tightens. (Several blog
  write-ups; the post itself is reported second-hand.)
- **Banning things only moves the default.** Anthropic's own guide says
  that even when told to avoid Inter, the model then reaches for the next
  common choice (Space Grotesk). Their fix is a positive direction ("commit
  to a cohesive aesthetic"), not just a list of don'ts.
- **The "anti-AI" look is becoming its own tell**: cream backgrounds, a
  serif headline, a terracotta accent. Swapping one default for another
  doesn't solve it.

### Why our playbook produces it (in our own files)
The playbook already says "avoid the generic AI look"
(`reference/design-method.md` §5, the checklist's "Not generic"), but its
own defaults are the generic look:
- **The default style is Tailwind's palette.** `clear` (`styles/clear/`,
  copied into `templates/style.css`) uses `#2563eb`, `#111827`, `#22c55e`,
  `#fbbf24` and `#f87171`: Tailwind's blue-600, gray-900, green-500,
  amber-400 and red-400, exactly. Plus the device's system font, 14px
  corners, a soft grey shadow and white cards on pale grey.
- **Half the library is Inter and indigo.** `paper`, `ledger` and `night`
  all use Inter, and their accents (`#5645d4`, `#533afd`, `#5e6ad2`) are
  indigo or violet: the two strongest tells. The library came from daisyUI
  (a Tailwind add-on) and from descriptions of famous software companies'
  sites, which are the most copied looks on the web.
- **Styles change colours, not shape.** Every style shares one stylesheet:
  rounded cards for everything, pill-shaped tabs, a bottom tab bar with
  emoji icons (`.tab-icon`, a 20px character), bottom sheets, a toast. So
  every app has the same silhouette whatever its colours.
- **The anti-generic rules are a list of don'ts, checked after building.**
  That's the approach Anthropic found only shifts the default.
- **Nothing ties the look to the app's subject.** DESIGN.md's principles
  ("Glance first", "Phone first") are good usability rules, but they're the
  same for every app, so they can't make one look different from another.

## Is it possible? Yes, mostly
- **High confidence**: a large share of the generic look comes from our own
  defaults (above). Changing them is cheap and fully in our control.
- **Medium confidence**: giving each app a look drawn from its own subject,
  chosen by the user from a few options, will make apps read as
  human-designed to most people. This is what designers do, and what
  Anthropic's guide recommends, but there's no hard evidence it works for
  outsiders. So the spec ends with a blind test.
- **What it can't do**: an AI can't have taste of its own, and it's weak at
  original illustration and photography. The user's pick between options is
  the "human" part; real photos or drawings, when an app needs them, come
  from people.
- **What we keep**: familiar patterns (bottom tabs, forms, undo) stay. People
  should recognise how the app *works*; what should be distinctive is how
  it *looks and talks*. Accessibility and contrast checks stay as they are.

"Looks human-made" here means **looks chosen**: specific to its subject,
consistent, with one thing worth remembering, and nothing that's there only
because it's the default.

## The change, in five parts

### 1. Stop shipping the generic look as the default
- `clear` stops being Tailwind's palette: new values, still calm and
  glanceable. And it stops being the automatic default (part 3 replaces it).
- `paper`, `ledger`, `night`: swap Inter for other free fonts that suit
  them; move accents away from indigo and violet. Drop the gallery's
  `indigo` candidate.
- `tools/styles.py check` also fails a style that uses a font on a short
  "overused" list (Inter, Roboto, Arial, Open Sans, Lato, Poppins,
  Montserrat, Space Grotesk), an accent in the indigo–violet range (a hue
  band; the exact range is a judgement, written in the tool), or an exact
  Tailwind default colour. A test case is added to `tests/run.sh`.

### 2. Let a style change shape, not just colour
Move the shape decisions out of the shared stylesheet into each style's
tokens (the named values at the top of `style.css`), with a few variants in
`templates/style.css`:
- **Surfaces**: boxed cards, ruled lists (thin lines between rows, no
  boxes), or flat sections. Cards stay only for separate objects.
- **Corners and edges**: corner size, border weight, shadow or none.
- **Type**: a heading font distinct from the body font, a size step between
  them (the main answer at least twice the body size), case and weight.
- **Tabs**: underline, block or pill.
- **Icons**: simple drawn icons (inline SVG, a drawing written as code) in
  one consistent set chosen for the style, not emoji.
Each library style then sets these, so `field` and `paper` look different
even in grey.

### 3. Give each app a look from its own world
A new short step in `reference/design-method.md` §5, used at the kick-off
(`SKILL.md`) and recorded in the app's DESIGN.md:
1. Claude writes **three directions**, each borrowed from something
   physical in the app's subject, not from other websites. For a tide app: a
   printed tide table, an Admiralty chart, a harbour noticeboard. For a dog
   walk app: an Ordnance Survey map, a field notebook.
2. Each direction says: the reference; two fonts (free, from Google Fonts or
   self-hosted); 3–5 colours taken from that reference; a surface and
   corner choice (part 2); **one signature element** (the memorable thing:
   a big typographic answer, a tide curve as the header, a stamped label);
   and the voice of the words on screen.
3. Claude shows each as a mockup of the app's **real main screen** with
   realistic made-up data, in light and dark, on a private page.
4. The user picks one (or mixes). A library style can be the starting point
   for a direction, but the direction wins.
5. DESIGN.md gets an **"Identity"** section (reference, signature element,
   voice, "never looks like"), above "Principles".
6. **To stop all the user's apps converging on one new look**, the playbook
   keeps `styles/directions-used.md`: one line per app with its fonts,
   accent and reference, no app names (the repo is public). New directions
   must differ from the last few.

### 4. Positive details, and an updated list of tells
Add to the checklist's "Not generic" section, as things to do:
- The main screen has one layout move that's specific to the app (a
  timeline, a chart or a single big answer as the centrepiece), not a stack
  of equal cards.
- Words on screen sound like the app's subject, not like software ("High
  water 14:05", not "Next event").
- Proper typography: real quote marks and dashes, numbers that line up,
  a clear size step from answer to detail.
- A favicon and app name that match the direction.
Add to the tells to avoid: emoji as icons; grey-bordered, rounded,
small-grey-text panels everywhere; badges and pills on everything; gradient
text; frosted glass; a centred title with two buttons and three feature
cards; sparkle icons for anything AI; the cream, serif and terracotta
"anti-AI" look unless the subject calls for it.

### 5. Measure what can be measured
`tools/page-check.js` adds warnings (not failures) for: a computed font on
the overused list; an accent in the indigo–violet band; more than half the
visible blocks having both rounded corners and a shadow; only one corner
size used everywhere; emoji inside buttons or tabs; gradient backgrounds.
The design review (`reference/design-review.md`) reports them under "Looks
generic", with the checker's one-line view of whether a designer would
guess it was AI-made, and why. An AI judging AI is weak evidence, so the
real test is people (below).

## Cost per session
- Rules file: **0 lines** (it's at its limit). Session start: **0
  characters**.
- When designing: `design-method.md` grows by about 30 lines (about 500
  tokens), read once per design session.
- At an app's kick-off: one extra round of three mockups, a one-off cost of
  a few thousand tokens.

## What it replaces
- "Pick a style from the gallery" as the main way to choose a look: styles
  become starting points for a direction.
- `clear` as the automatic default.
- The look rules that are only a list of don'ts: kept, but led by the
  positive identity.

## Out of scope
- Changing how apps work (navigation, forms, patterns): they stay standard.
- AI-generated images or illustrations.
- Restyling existing apps automatically. Templates don't update in projects;
  a restyle is offered per app, in its own session (see decisions).
- Paid fonts or design tools.

## How to check it's done
1. `bash tests/run.sh` passes, including the new style check: no library
   style uses an overused font, an indigo–violet accent or a Tailwind default.
2. The gallery shows the library styles with different shapes, not only
   different colours, at 375px and desktop, light and dark.
3. **The blind test** (the one that matters): take one real main screen
   (Sport Conditions' is the obvious choice) and build it twice: as it is
   now, and with a direction from part 3. Show both, in random order, on a
   private page to at least five people who haven't seen either, and ask:
   "Which looks more like an AI made it?" and "Which would you rather use?"
   **Done** when fewer than half pick the new one as AI-made, and no more
   than half prefer the old one to use.
4. A fresh session asked to start a test app writes three directions from
   its subject, records the chosen one in DESIGN.md's "Identity", and
   checks `styles/directions-used.md`.

## Order of work, and which model
1. Parts 1 and 5 (defaults, the style check, page-check warnings): small,
   mechanical to this spec. A mid-priced model.
2. Part 2 (shape tokens and template variants): design judgement. The
   strongest model.
3. Parts 3 and 4 (the direction step, checklist, DESIGN.md template, kick-off
   text): the strongest model.
4. The blind test, on Sport Conditions' main screen. Then release.

Each is a separate session. Parts 1 and 5 can go first and are useful on
their own.

## Risks
- **A new house look.** If every direction drifts to the same "tasteful"
  look, we've only moved the default. `directions-used.md` and the user's
  pick are the guard; the blind test would show it.
- **Distinctive at the cost of usable.** Bold fonts or colours can hurt
  reading and contrast. The existing contrast checks and page check still
  apply to every direction.
- **More choosing for the user**: one extra pick at each app's start. Three
  options, with a recommendation, keeps it small.
- **Fonts from Google tell Google each visitor's address.** The style README
  already covers self-hosting for public apps.

## Decisions for the user
1. **Retire `clear` as the automatic default**, so every new app gets a
   direction? *Recommendation: yes.* It's the most generic look we have.
2. **Re-tune or drop the Inter and indigo styles** (`paper`, `ledger`,
   `night`)? *Recommendation: re-tune* (new font and accent, same feel), so
   the library keeps six.
3. **Who sees the blind test?** *Recommendation: some of the people who
   said the apps look AI-made*, plus a couple who haven't seen them.
4. **Restyle existing apps?** *Recommendation: Sport Conditions only, as the
   trial* (it doubles as the blind test); others only when you ask.
