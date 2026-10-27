# Design method: how Claude designs a screen

Read once per session, before designing a new screen or feature (the app's
DESIGN.md points here). It says **how** to design, in the order a designer
works. The specific rules to meet are in `reference/ux-checklist.md`
(**what** to check); this file doesn't repeat them. After building, a step
that adds or reworks a screen gets the design review
(`reference/design-review.md`).

The user isn't a designer and doesn't want to become one. Make the design
decisions, explain them in a line each, and ask only about taste (which
style, which of two layouts) or about what the app is for.

## 1. Purpose: one job per app, one job per screen
- Before anything visual, write down who it's for and the **one job** they
  open the app to do ("see when it's dry enough to walk the dog"). The kick-off
  in `SKILL.md` asks for it; it goes in SPEC.md.
- Each screen gets one job too, and **one main action**. If a screen has two
  jobs, it's two screens, or one of them is one tap away.
- Start from the person's need, not the data or the feature list. Real
  people ask "can I go out at 5?", not "show me the hourly forecast table".
  *(GOV.UK Service Manual: "start with user needs".)*

## 2. Structure: decide what goes where before building
This is the step that stops apps getting cluttered. Fill in the spec's
**"What's on screen"** section (`templates/specs/feature.md`) before
building, by sorting every feature and piece of information:

| How often it's needed | Where it goes |
|---|---|
| Every time the app is opened | **Main screen**: the answer and the one main action |
| Now and then | **One tap away**: detail, "Show all", secondary actions |
| Set once, rarely changed | **Settings**, with a sensible default so most people never go there |
| Nice to have, not needed yet | **Later**: SPEC.md's "Later" list, not built |

- **Show the answer first, the workings on request** (progressive disclosure:
  only the essentials up front, the rest when asked for). The main screen
  shows a summary; detail appears on tap.
- **Fewer choices per screen.** Each extra option slows everyone down (Hick's
  law: the more choices, the longer the decision). Prefer a good default to a
  setting, and a setting to a question.
- **Familiar beats clever.** People expect an app to work like the others
  they use (Jakob's law), so use the standard place and shape for things.
- If the main screen still feels busy, cut before restyling: move things
  down a level, merge two controls, or drop one.

## 3. Patterns: use the standard, tested way for common jobs
Don't invent a new way to do a common thing. The checklist's "Common
patterns" section lists the ones to follow: navigation, forms, errors,
empty screens, loading, confirmations and undo, settings, dialogs on phones.
They come from the GOV.UK Design System, Apple's Human Interface Guidelines
and Material Design, and from what worked in Sport Conditions.

## 4. Words on screen: write for the person, not the engineer
Words are part of the design, not decoration, and copy can make a screen
feel as templated as its layout. Write the real words while designing
(placeholder text hides problems), from the person's side of the screen:
what they're trying to do, in their words. Then check them against the
checklist's "Words on screen". *(GOV.UK style and error-message guidance;
Anthropic's frontend-design skill, "writing in design".)*

## 5. Look: follow the app's style, deliberately
- Use only the app's style tokens (DESIGN.md and the top of `style.css`):
  no one-off colours, fonts, corners or shadows. New app: pick a style from
  the playbook's `styles/` (see `styles/README.md`), or a client's brand
  (`reference/client-style.md`).
- **Spend boldness in one place.** One element per screen is the memorable
  thing (usually the answer on the main screen); everything around it stays
  quiet.
- **Structure means something**: borders, cards, numbers and labels only
  where they tell the person something true (a numbered list only for real
  steps; a card only for a separate thing).
- **Avoid the generic AI look**: the checklist's "Not generic" lines list
  the tells. When nothing in the brief asks for one of them, don't use it.
  *(Anthropic's frontend-design skill.)*
- Motion answers what the person did (opening, confirming); it doesn't
  decorate.

## 6. Accessibility: built in, not added later
Everyone should be able to use it: people with poor sight or colour
blindness, people using a screen reader (software that reads the screen
aloud), people with shaky hands. Use real HTML elements (a `button` for a
button, a `label` for every input), and meet the checklist's colour,
size and "Accessible to everyone" lines while building. The page check
(`tools/page-check.js`) measures what it can. *(WCAG 2.2, the web
accessibility standard; Vercel's web interface guidelines.)*

## 7. Check: measure, look, then ask the user
- While building, look at each new screen at phone width (375px) and
  desktop, light and dark, as the rules require.
- After the step, the design review (`reference/design-review.md`) measures
  with the page check, judges a few screenshots against the checklist and
  the 10 usability heuristics, and reports.
- **The user's reaction is the final test.** "This feels too busy" means go
  back to step 2, not restyle.

## Sources (all free; ideas used in our own words)
- GOV.UK Service Manual and Design System (Open Government Licence; code MIT):
  user needs, question pages (one thing per page), error messages, buttons.
- Nielsen Norman Group: the 10 usability heuristics; progressive disclosure.
- Laws of UX (lawsofux.com): Hick's law, Jakob's law, Fitts's law.
- Apple Human Interface Guidelines and Google Material Design: phone
  navigation, tap target sizes, sheets.
- WCAG 2.2 (W3C): contrast, target size, not relying on colour.
- Anthropic's frontend-design skill (Apache 2.0): deliberate style, boldness
  in one place, structure as information, the generic-AI tells, writing.
- Vercel's web interface guidelines (MIT): interaction, forms, content and
  accessibility details.
- Impeccable by Paul Bakaus (Apache 2.0): the idea of separate passes:
  critique (hierarchy, clarity), audit (accessibility, responsive), polish.
