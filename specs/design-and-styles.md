# Spec: good design by default, and a library of styles

Status: **draft for the user's review** (27 Oct 2026). Nothing built yet.

## Goal
Every app the user builds looks good and is easy to use, without the user
learning design or paying for anything. Claude does the design work, using
proven methods and free resources, and the user only makes choices: which
style, and whether a screen feels right.

## The problem
- **Apps grow cluttered.** Features pile onto the main screen. The UX
  checklist (`reference/ux-checklist.md`) catches this only after a screen
  is built. Nothing at planning time asks "should this be on the main
  screen at all?"
- **Words on screen are too technical.** The rules make Claude write plainly
  *to the user*, but nothing covers labels, buttons and messages *inside the
  apps*.
- **Every app starts from the same look.** `templates/style.css` has one set
  of colours. There's no way to pick between styles the user likes, or to
  match a client's brand.
- **Claude has no design method.** The kick-off asks for apps the user
  likes, but nothing turns that into a deliberate look. AI-built pages tend
  to look generic.

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
- When designing a screen: Claude reads the design method (about 80 lines)
  and the app's own DESIGN.md. It never reads the whole library: only the
  chosen style, once, when it's copied in.
- One catch-up per existing project (about 1,000 tokens, once).

## What to build
Each part ends with something the user can see.

1. **A style gallery, for the user to pick from.** Claude gathers about 13
   candidate styles: about 8 from `VoltAgent/awesome-design-md` (descriptions
   of well-known sites' looks, MIT licence) and about 5 daisyUI themes (free
   colour sets, MIT). It picks calm styles that work on phones, and leaves
   out flashy ones. It builds `styles/gallery.html`: the same sample screen
   (a header, a headline card, a short list, a button, a settings sheet) in
   each style, with a switcher, on phone and desktop, in light and dark.
   **Then it stops, and the user picks 4–6.**
2. **The style library.** Each pick becomes `styles/<name>/`:
   - `DESIGN.md`: the feel in one paragraph, what it's good for, tokens,
     type, shapes, do's and don'ts. It's in the same shape as
     `templates/DESIGN.md`, so it can be copied straight into an app.
   - `tokens.css`: the `:root` colour block for `templates/style.css`,
     light and dark, plus the font, corner and shadow tokens.

   `styles/README.md` lists the styles, one line each, with credits.
   Brand names, logos and paid fonts are taken out: each style gets a
   plain name ("Calm", "Ledger") and a free font that looks similar.
   `templates/style.css` gains font tokens so a style can change the font.
3. **New apps ask "which style?"** In the kick-off (`SKILL.md`, section 1),
   Claude links to the gallery and asks the user to pick one. It copies
   that style's DESIGN.md and tokens into the app. The kick-off's "show,
   don't describe" mockups then use the chosen style.
4. **A design method Claude follows**: `reference/design-method.md`,
   read before designing any new screen. It borrows from Anthropic's
   official `frontend-design` skill (read in full first; check its licence
   before copying any text) and from the GOV.UK content guidance. It covers:
   - **Main screen, one tap, Settings.** Before building, sort every
     feature: used daily → main screen; now and then → one tap away;
     rarely → Settings; "nice to have" → the SPEC's "Later" list.
     `templates/specs/feature.md` gains a short "What's on screen"
     section, so this happens at planning time.
   - **Words on screen**: say what it does for the person, not how it
     works; everyday words; error messages say what happened and what to
     do. This becomes a short new section in `reference/ux-checklist.md`.
   - **Follow the chosen style**; no ad-hoc colours or fonts.
5. **A design review after building.** The `checker` subagent (a cheaper
   helper Claude that reviews finished work) gains a design pass when a step
   changes screens. It takes screenshots at phone and desktop width, and
   reviews them against the UX checklist and Nielsen's 10 usability
   heuristics (the standard review list). It reports; the user decides.
   It also runs **axe-core**, a free automatic accessibility check, in the
   page where the browser tool is available (cloud sessions), and says when
   it couldn't.
6. **Client styles**: `reference/client-style.md`, a recipe. Given a
   client's website address or brand guidelines document, Claude writes a
   DESIGN.md and tokens in their style, and shows one sample screen for the
   user to check. It saves them **in the client's project only**, never in
   the playbook (which is public). It checks the fonts' licences, and that
   the client is happy for their look to be used.
7. **Catch-up for existing apps.** One line at the top of each project's
   DESIGN.md: "Before designing a screen, read the playbook's
   `reference/design-method.md`." Apps keep their current look. Changing
   an app's style is a separate job, when the user asks for it.
8. **Canary, then release.** Sport Conditions uses it in one real session
   (a new or reworked screen). Then release as usual.

## Parts involved
- New: `styles/` (README, gallery, one folder per style),
  `reference/design-method.md`, `reference/client-style.md`.
- Changed: `SKILL.md` (kick-off), `templates/DESIGN.md` (pointer line),
  `templates/style.css` (font tokens), `templates/specs/feature.md` ("What's
  on screen"), `reference/ux-checklist.md` ("Words on screen" and the
  heuristics), `templates/.claude/agents/checker.md` (design pass),
  `shared/catch-up.md` (part 7), `docs/ARCHITECTURE.md` (the new folder),
  `docs/decisions.md` (where it lives, and why).
- Not changed: `shared/ai-dev-rules.md`.
- Outside sources (all free): awesome-design-md, daisyUI themes, Anthropic's
  frontend-design skill, GOV.UK guidance, axe-core (loaded from cdnjs, a
  free public file host, only during checks).

## Out of scope
- Anything paid (Mobbin, books, paid fonts, paid AI design tools).
- Teaching the user design theory.
- Restyling existing apps (offered separately, app by app).
- Any client's actual style (it lives in the client's repo, built when needed).
- Installing third-party design skills as they are. Claude reads them and
  takes the useful ideas, so nothing unreviewed runs in the user's sessions.

## How we'll check it's done
- The gallery opens on the user's phone. Each style is readable in light
  and dark, and nothing is wider than the screen at 375px.
- Every style passes the contrast check (4.5:1 for text) and axe-core shows
  no serious problems on the sample screen.
- A trial kick-off in a scratch folder asks "which style?" and copies the
  right files. The result matches the gallery.
- `wc -l shared/ai-dev-rules.md` is unchanged, and `bash tests/run.sh` passes.
- The checker's design pass, run on one Sport Conditions screen, reports
  real findings with screenshots.
- The canary session goes through with no problems.

## Risks and open questions
- **Not yet verified:** the quality of individual awesome-design-md files,
  and the frontend-design skill's licence. Both are checked in part 1 and
  part 4, before any copying.
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
4. **Existing apps get only the pointer line**, not a restyle (recommended).

## Build plan (sessions and models)
- Session 1, strongest model (design judgement): parts 1–3. Stop after the
  gallery for the user's picks.
- Session 2, mid model (to this spec): parts 4–7, then tests.
- Then the canary and release.
