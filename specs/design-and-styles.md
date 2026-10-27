# Spec: good UX design by default, and a library of styles

Status: **draft for the user's review** (27 Oct 2026). Nothing built yet.

## Goal
Every app the user builds is easy to use and looks good, without the user
learning design or paying for anything. Claude does the design work, using
proven UX methods and free resources, and the user only makes choices:
which style, and whether a screen feels right.

Two halves:
- **A. The UX method**: how Claude decides what goes on each screen, how it
  behaves and what it says, and how it checks the result.
- **B. The style library**: how it looks, picked from styles the user likes
  or matched to a client.

## The problem
- **Apps grow cluttered.** Features pile onto the main screen. The UX
  checklist (`reference/ux-checklist.md`) catches this only after a screen
  is built. Nothing at planning time asks "should this be on the main
  screen at all?"
- **Words on screen are too technical.** The rules make Claude write plainly
  *to the user*, but nothing covers labels, buttons and messages *inside the
  apps*.
- **Claude has no design method.** It designs screen by screen, from habit.
  The checklist covers the look and phone layout well, but not purpose,
  structure, common patterns or an independent review. AI-built pages also
  tend to look generic.
- **Every app starts from the same look.** `templates/style.css` has one set
  of colours. There's no way to pick between styles the user likes, or to
  match a client's brand.

## Where it lives: in the playbook, in files read only when needed
Only three files are loaded into every session: the rules
(`.claude/rules/playbook.md`), `owner.md` and the project's CLAUDE.md.
Everything else in the playbook (`reference/`, `templates/`, and the new
`styles/`) costs nothing until Claude opens it. So this goes in the
playbook, and adds **nothing** to what every session loads.

A separate repo was considered and rejected. It would need attaching to
cloud sessions, its own sync and its own releases, which means more
sessions and more to go wrong, for no saving. Revisit this only if the
library grows large enough to slow the playbook download in cloud sessions
(it won't: the gallery is one file with no images).

**Cost per session:**
- Rules file: 0 lines added (it's at its 150-line limit).
- Project CLAUDE.md: unchanged.
- When designing a screen: Claude reads the UX method (about 120 lines)
  and the app's own DESIGN.md. It reads the checklist when checking. It
  never reads the whole style library: only the chosen style, once, when
  it's copied in.
- One catch-up per existing project (about 1,000 tokens, once).

## A. The UX method
A new file, `reference/design-method.md`, which Claude reads before
designing any new screen or feature. It's organised by the layers of UX
design, in the order a designer works through them. Each layer says what
Claude does, when, and where the idea comes from. Claude reads the sources
while writing the file and boils them down; the user doesn't need to read
them.

| Layer | What Claude does | When | Drawn from (all free) |
|---|---|---|---|
| 1. **Purpose** | Names who the app is for and the one main job it does for them. Each screen gets one job and one main action | Kick-off; each feature spec | GOV.UK Service Manual ("start with user needs") |
| 2. **Structure** (what goes where) | Sorts every feature by how often it's used: daily → main screen; now and then → one tap away; rarely → Settings; "nice to have" → the SPEC's "Later" list. Main answer first, detail on tap (progressive disclosure). Fewer choices per screen (Hick's law). Sensible defaults instead of options | Planning, in each feature spec, before building | Nielsen Norman Group (progressive disclosure), Laws of UX |
| 3. **Patterns** (how common things work) | Uses the standard, well-tested way for common jobs instead of inventing one: forms, errors, empty screens, confirmations, settings, navigation, undo | Building | GOV.UK Design System patterns, Apple Human Interface Guidelines, Material Design |
| 4. **Words on screen** | Says what it does for the person, not how it works. Everyday words, short labels, buttons that say what happens ("Save site", not "Submit"). Errors say what happened and what to do. No jargon | Building; checked at review | GOV.UK style guide and content design guidance |
| 5. **Look** | Follows the app's chosen style (part B). No one-off colours or fonts. Picks a deliberate direction, not the generic AI look | Building | Anthropic's `frontend-design` skill, the style library |
| 6. **Accessibility** | Contrast, text size, tap targets, never colour alone, works with a screen reader (software that reads the page aloud) | Building; automatic check at review | WCAG 2.2 (the web accessibility standard), axe-core |
| 7. **Checking** | Reviews the finished screens independently, with screenshots, against the checklist and the 10 usability heuristics. Reports to the user, who decides | After each step that changes screens | Nielsen's 10 usability heuristics, Vercel's web interface guidelines, Impeccable's critique and audit commands |

How it reaches the work:
- **Kick-off** (`SKILL.md`, section 1): adds "the one main job" (layer 1) and
  "which style?" (part B).
- **Feature specs** (`templates/specs/feature.md`): a new "What's on screen"
  section with the four buckets (main screen / one tap / Settings / Later),
  filled in before building (layer 2).
- **Checklist** (`reference/ux-checklist.md`): new short sections for
  "Purpose and structure", "Words on screen" and "Common patterns", plus
  the 10 heuristics as the review list. Its existing sections (glance first,
  colour, phone first, states, visual system) stay.
- **Design review** (`templates/.claude/agents/checker.md`): the `checker`
  subagent (a cheaper helper Claude that reviews finished work) gains a
  design pass when a step changes screens (layer 7, below).

Third-party skills (Impeccable, Vercel's guidelines, ui-ux-pro-max) are
**read for ideas, not installed**, so nothing unreviewed runs in the user's
sessions.

## B. The style library
- **A gallery to pick from.** About 13 candidate styles: about 8 from
  `VoltAgent/awesome-design-md` (descriptions of well-known sites' looks,
  MIT licence) and about 5 daisyUI themes (free colour sets, MIT). Calm
  styles that work on phones; no flashy ones.
- **The library.** The 4–6 the user picks, each in `styles/<name>/` with a
  `DESIGN.md` (feel, what it's good for, tokens, type, shapes, do's and
  don'ts) and `tokens.css` (colours light and dark, font, corners,
  shadows). Plain names ("Calm", "Ledger"); brand names, logos and paid
  fonts are taken out, and a free lookalike font is used.
- **Client styles**: a recipe (`reference/client-style.md`). From a client's
  website or brand guidelines, Claude writes a DESIGN.md and tokens in their
  style and shows one sample screen to check. They're saved **in the
  client's project only**, never in the playbook (which is public). Claude
  checks font licences, and that the client is happy for their look to be
  used.

## What to build
Each part ends with something the user can see.

1. **The style gallery.** `styles/gallery.html`: the same sample screen (a
   header, a headline card, a short list, a button, a settings sheet) in
   each candidate style, with a switcher, on phone and desktop, in light and
   dark. The sample screen itself follows the UX method, so the gallery also
   shows what the method produces. **Then stop: the user picks 4–6.**
2. **The style library**: the picks in `styles/<name>/`, with
   `styles/README.md` listing them one line each, with credits.
   `templates/style.css` gains font tokens so a style can change the font.
3. **The UX method**: `reference/design-method.md` (part A), the new
   checklist sections, and the "What's on screen" section in the feature
   spec template.
4. **The kick-off**: `SKILL.md` asks for the one main job and "which
   style?" (with the gallery link), copies the chosen style in, and makes
   its "show, don't describe" mockups in that style.
5. **The design review.** The checker's design pass takes screenshots at
   phone and desktop width, checks them against the checklist and the 10
   heuristics, and runs axe-core (a free automatic accessibility check)
   where the browser tool is available (cloud sessions). It reports
   findings with the screenshot each one refers to, and says what it
   couldn't check.
6. **Client styles**: `reference/client-style.md`.
7. **Catch-up for existing apps.** One line at the top of each project's
   DESIGN.md: "Before designing a screen, read the playbook's
   `reference/design-method.md`." Apps keep their current look. Changing
   an app's style or reworking its screens is a separate job, when the
   user asks.
8. **Canary, then release.** Sport Conditions uses it in one real session
   (a new or reworked screen). Then release as usual.

## Parts involved
- New: `reference/design-method.md`, `reference/client-style.md`, `styles/`
  (README, gallery, one folder per style).
- Changed: `SKILL.md` (kick-off), `reference/ux-checklist.md` (new sections
  and the heuristics), `templates/specs/feature.md` ("What's on screen"),
  `templates/DESIGN.md` (pointer line), `templates/style.css` (font
  tokens), `templates/.claude/agents/checker.md` (design pass),
  `shared/catch-up.md` (part 7), `docs/ARCHITECTURE.md` (the new files),
  `docs/decisions.md` (where it lives, and why).
- Not changed: `shared/ai-dev-rules.md`.
- Outside sources (all free): Nielsen Norman Group articles, Laws of UX,
  GOV.UK Service Manual, Design System and style guide, Apple Human
  Interface Guidelines, Material Design, WCAG 2.2, Anthropic's
  frontend-design skill, Vercel's web interface guidelines, Impeccable,
  awesome-design-md, daisyUI themes, axe-core (loaded from cdnjs, a free
  public file host, only during checks).

## Out of scope
- Anything paid (Mobbin, books, paid fonts, paid AI design tools).
- Teaching the user design theory.
- Testing with real users (watching people use the app). Worth doing for a
  public app; it'd be its own spec.
- Restyling or reworking existing apps (offered separately, app by app).
- Any client's actual style (it lives in the client's repo, built when needed).
- Installing third-party design skills as they are.

## How we'll check it's done
- The gallery opens on the user's phone. Each style is readable in light
  and dark, and nothing is wider than the screen at 375px.
- Every style passes the contrast check (4.5:1 for text), and axe-core shows
  no serious problems on the sample screen.
- `reference/design-method.md` covers all seven layers. Each rule is short
  enough to act on, and the source of each idea is named.
- A trial kick-off in a scratch folder asks for the main job and "which
  style?", fills in a "What's on screen" section, and copies the right
  style files. The result matches the gallery.
- A dry run of the method on one existing Sport Conditions screen: the
  design pass reports real findings, with screenshots, across structure,
  words and accessibility, not just the look.
- `wc -l shared/ai-dev-rules.md` is unchanged, and `bash tests/run.sh` passes.
- The canary session goes through with no problems.

## Risks and open questions
- **Not yet verified:** the quality of individual awesome-design-md files,
  and the licences of the frontend-design skill, Vercel's guidelines and
  Impeccable. These are checked before any text is copied; otherwise the
  ideas are written in our own words, with credit.
- **The method is only as good as Claude's judgement.** The design pass
  catches a lot, but only real people using the app show what's truly
  confusing. The user's own "this feels too busy" stays the final test.
- **The accessibility check needs a browser tool.** Cloud sessions have one.
  On the Mac (no Node.js), the checker says the check was skipped.
- **Publishing the gallery.** The playbook is public, so GitHub Pages
  (free) can show it at `https://leo-hyde.github.io/claude-playbook/styles/gallery.html`.
  Default: turn on Pages for the playbook. Otherwise, open the file from
  the repo.
- **Copying a well-known site's feel** is normal practice. Copying its name,
  logo or exact branding into a public app isn't, so the styles strip them.

## Decisions for the user
1. **Agree it lives in the playbook** (recommended), not a separate repo.
2. **4–6 styles in your library** (recommended); you pick them from the gallery.
3. **Turn on GitHub Pages for the playbook** so the gallery has a web
   address (recommended; free).
4. **Existing apps get only the pointer line**, not a rework (recommended).

## Build plan (sessions and models)
- Session 1, strongest model (design judgement): parts 1–3. The gallery
  first, then the UX method while the user picks styles.
- Session 2, mid model (to this spec): parts 4–7, then tests.
- Then the canary and release.
