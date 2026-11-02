# Off-the-shelf tools vs the playbook: what to keep, replace or borrow

**Version 1.1 · 2 Nov 2026, 15:30 (UK time) · Status: decided by the user, 2 Nov 2026 (see `docs/decisions.md`)**

Made with the playbook's [research-to-doc method](../reference/research-to-doc.md):
brief, four research agents in parallel, a one-page outline, a fresh critic
(it changed five verdicts), a fact-checker on 14 claims, and a reader check.
All web sources were checked on 2 Nov 2026.

**Words used here.** A **rules file** is text Claude reads at the start of
every session. A **hook** runs a script automatically at a set moment. A
**subagent** is a second Claude that does one job and reports back. A
**skill** is a set of instructions Claude loads only when a task needs it. A
**plugin** is an add-on package of skills and hooks. **MCP connectors** let
Claude reach outside services such as Google Drive. **Canary/stable**: one
project gets playbook changes first (the canary), the rest only after a
release (stable). A **catch-up** is a one-off change every project applies to
its existing files. A **pull request** is a proposed change that a person
reviews before it goes in. The named tools are explained where they appear.

## Summary
- **The question:** is there a standard tool or framework that already does
  what the playbook does, so you can stop building your own?
- **The answer: no single one, and most of your building blocks are already
  the standard ones.** CLAUDE.md, rules files, hooks, subagents, skills,
  connectors (MCP) and GitHub as shared memory are how Anthropic and GitHub
  say to work. The frameworks that do exist (GitHub Spec Kit, BMAD, Kiro,
  Superpowers) are built for developer teams and are heavier than you need.
- **But you have built too much machinery.** Since the playbook began (22 Oct),
  18 of its 51 commits (about a third) changed the sync scripts or their tests,
  adding about 1,450 lines. No off-the-shelf tool can replace it, because
  cloud sessions ignore plugins. The fix is to do less: freeze it and simplify it.
- **The biggest wins come from the standards, not new tools:**
  1. move rules that only matter sometimes into **skills**, which load only
     when needed;
  2. prune the rules against **Anthropic's current best-practices page**,
     which now says some of your token-saving habits are no longer needed;
  3. for client work, a short **AI-use and client-data policy**, the way
     professional bodies now require.
- **Where nothing standard exists,** keep yours: the handover between parallel
  sessions and devices, plain-English writing for a non-developer, and the
  checks on AI-written documents.

## Plan and decisions

### Each part of the playbook
| Part | Verdict | Why | Effort |
|---|---|---|---|
| **Sync, releases (stable/canary), catch-ups, set-up check** | **Keep, freeze, simplify** | Plugins don't install in cloud sessions today [1] and can't carry always-loaded rules [2]. Copier (a tool that pushes template changes into existing projects) needs Python 3.10+ (the Mac has 3.9) and is run by hand [3]. But it has cost about a third of all playbook work so far | A playbook session: stop adding features; list what each check has caught; cut what caught nothing |
| **Rules file (150 lines)** | **Keep, but borrow skills and prune** | Skills load only when relevant and work in cloud sessions [1][4]. Situational rules (public-repo checks, catch-ups, "check feedback", starter prompts) can move into skills. Anthropic now says aggressive context management and "subagents to protect context" are habits you can stop [5]: the "Using tokens well" section and the `COST:` notes should shrink | One playbook session, strongest model. The sync needs to copy `.claude/skills/` as it copies agents |
| **Checking that a rule works** | **Borrow** | Anthropic's guide: give Claude a check it can run [5]. For rules, that means a few fixed test tasks re-run after a change, so pruning isn't guesswork | Small, with the row above |
| **SPEC.md, specs/, plan first** | **Keep** | Spec-driven frameworks turn a request into spec, plan and task files that the AI then builds from: GitHub's Spec Kit [6], BMAD (adds role-play agents such as product manager and architect) [7], Amazon's Kiro editor [8] and OpenSpec [9]. They but a critique found them verbose, hard to review and a poor fit for small steps [10]. Superpowers [11], a set of skills that enforces brainstorm, plan, test-first and review, is the closest match, but it is a plugin (Mac only) and would compete with your own process | None |
| **decisions.md** | **Keep** | It already records what was rejected, which is the core of MADR (a standard template for decision records): "considered options" [12]. One file per decision only helps tools you don't use | None |
| **STATUS.md handover, session checks** | **Keep** | No standard for handover across parallel sessions and devices was found | None |
| **research-to-doc and document checks** | **Keep** | No standard for checking AI-written research was found. Google design docs [13] match its shape | None |
| **Documents pipeline (repo master, team edits a Google Docs copy)** | **Review, in the project that uses it** | The usual way is to write where the reviewers are. The Mac now has Docs editing connectors, so the copy-and-read-back step may no longer be needed | Decide in that project |
| **Format standards: Diátaxis [14] (sorts guides into tutorials, how-tos, reference and explanation), C4 (a way to draw a system), GOV.UK's words-to-avoid list [15], Vale [16] (a tool that checks writing against style rules)** | **Later, only if a problem shows** | Each is sound, but none fixes a problem you've had. Vale has no plain-English or GOV.UK package, so it needs a custom style [16] | None now |
| **AGENTS.md** (a rules file other AI tools read) | **Adopt** (the user, 2 Nov: the playbook will be used with other people and other AI tools) | Claude Code reads it only when there is no CLAUDE.md, but a CLAUDE.md can import it [17] | A playbook session: design how the rules reach AGENTS.md |
| **Design method, styles, page check** | Not assessed | Out of scope of this note | None |

### The wider picture: standard ways of AI-supported work
| Approach | Status | For you |
|---|---|---|
| **Anthropic's best-practices page** [5] as the base for your rules | Vendor standard | **Adopt** (decision 1) |
| **Skills, hooks, subagents, MCP connectors, CLAUDE.md** [1][4] | Standard; already used | Keep using |
| **Issue → `@claude` on GitHub → pull request → human review** [18] | Becoming the default for developer teams: agents started over 40% of pull requests in Sept 2026 [19, secondary source] | **No for now.** It needs an API key and pay-per-use billing, and produces code reviews you can't easily judge. Phone sessions and "check feedback" already cover this |
| **A written AI-use policy and client-data rules** | Required by some professional bodies, e.g. RICS from 9 Mar 2026 [20] | **Adopt for client work**: which AI tools the contract allows, which plan and data terms apply, where client material may sit, and what you tell clients. Whether RICS applies to you: to confirm. Keep it in a private repo |
| **Spec-driven development frameworks** [6–11] | Promising, unproven [10] | Borrow ideas, don't install |
| **Organisation frameworks**: Google's DORA AI Capabilities Model [21] (seven habits that make AI help teams), and the NIST and ISO frameworks for managing AI risk | Standard for organisations | Not at solo scale. DORA's findings (small batches, version control, a clear AI stance) back what you already do |

### Decisions for you
1. **Prune the rules against Anthropic's page.** The "Using tokens well"
   section and the `COST:` notes shrink most. Recommend: yes, in a playbook
   session, with three or four fixed test tasks run before and after, so you
   can see nothing broke.
2. **Move situational rules into skills.** A separate job: it changes the
   sync too, so it is riskier. Recommend: yes, after 1, as its own step
   through the canary.
3. **Freeze the sync machinery, then measure before cutting.** Recommend:
   yes. No new checks unless something breaks. A playbook session first
   counts, from projects' git history, what each check has caught; only then
   does anything get cut, with your agreement.
4. **Write a one-page AI-use and client-data note for consulting work**:
   which AI tools each contract allows, which plan's data terms apply, where
   client material may sit, what you tell clients. Recommend: yes, Claude
   drafts it in the private consulting repo and you approve it. It's worth
   doing even if RICS doesn't apply, because client contracts decide it.
5. **Review the Google Docs pipeline** in that project: could the team edit
   the Google Doc as the master copy, now that the Mac can edit Docs? You'd
   only be agreeing to a short look, not a change. Recommend: yes, next
   session there.
6. **Don't install** Spec Kit, BMAD, Kiro, Superpowers, Copier or the
   `@claude` Action; skip Vale for now (AGENTS.md: adopted, see its row). Recommend: agree.
   Revisit plugins if cloud sessions start installing project plugins (a fact of today that may change).

## Detail

### What the playbook is (for this comparison)
A public repo with an always-loaded rules file (150 lines); a sync that copies
it and two scripts into each project at session start (`session.sh` 510
lines, `playbook-sync.sh` 213, `release.sh` 81, tests on Linux and macOS);
stable and canary release channels; one-off "catch-ups"; templates; two
subagents; 12 reference guides (about 1,200 lines); and the research-to-doc
method. The user works from a phone (cloud sessions) and a Mac.

### Key facts behind the verdicts
- **Plugins in cloud sessions:** "A cloud session doesn't install the plugins
  a repository turns on under enabledPlugins, including ones from the
  marketplaces it lists under extraKnownMarketplaces." A repo's CLAUDE.md,
  `.claude/rules/`, `.claude/skills/`, `.claude/agents/` and hooks do carry
  over [1]. This confirms the 23 Oct decision in `docs/decisions.md`.
- **Plugins can't carry rules:** "A CLAUDE.md at the plugin root isn't
  loaded as context ... put them in a skill." [2] Auto-update is off by
  default for third-party marketplaces [22]. No release channels are
  documented; a marketplace can be pinned to a git ref [22].
- **Copier:** needs Python 3.10 or newer [3]; `copier update` re-applies
  template changes and runs pre- and post-migrations, which would cover
  catch-ups [3]. It is run by hand, and conflicts in prose files are left
  for a person to resolve.
- **Anthropic's "What you can stop doing"** [5], quoted: "The context window
  is your main constraint, manage it aggressively" → "Most current models
  have a 1M-token window and compaction happens on its own ... `/clear`
  between tasks is still worth doing". "Use subagents to protect your
  context window" → "still great for parallel work, keeping noisy output
  out of your way, and independent review, but each of those costs extra
  tokens". "Describe your architecture and file layout in CLAUDE.md" →
  "Claude reads the repo itself."
- **Sync cost, measured** (`git log origin/main`, 22 Oct to 2 Nov 2026): 51
  commits; 18 touched `shared/session.sh`, `shared/playbook-sync.sh`,
  `shared/setup.txt`, `shared/catch-up.md`, `scripts/release.sh` or
  `tests/`; 1,452 lines added and 254 removed in the two scripts and the
  tests. Not measured: how many problems each check caught.
- **Frameworks** (stars on 2 Nov 2026): Spec Kit 145k, MIT, needs Python
  3.11+ and uv [6]; BMAD 55k, MIT, needs Node and Python, role personas [7];
  Kiro, a separate paid editor with a free tier [8]; OpenSpec 74k, needs Node
  22 [9]; Superpowers 311k, a Claude Code plugin [11]; Agent OS covers coding
  standards only [23].
- **Critique of spec-driven tools** [10]: Kiro was excessive for a small
  bug; Spec Kit's files were verbose and tedious to review; agents ignored
  parts of specs; heavy up-front specs clash with small steps.
- **Not confirmed, so not used:** Thoughtworks Radar rings for AGENTS.md,
  spec-driven development and "curated shared instructions" in Vol. 34;
  RICS's exact wording on client disclosure (check the PDF [20]); which tools
  support Agent Skills beyond Claude [4].

### Sources (all checked 2 Nov 2026)
1. https://code.claude.com/docs/en/cloud-environments ("What carries over")
2. https://code.claude.com/docs/en/plugins-reference
3. https://copier.readthedocs.io/en/stable/ and /updating/
4. https://agentskills.io
5. https://code.claude.com/docs/en/best-practices
6. https://github.com/github/spec-kit
7. https://github.com/bmad-code-org/BMAD-METHOD
8. https://kiro.dev/docs/specs/ and https://kiro.dev/pricing/
9. https://github.com/Fission-AI/OpenSpec
10. https://martinfowler.com/articles/exploring-gen-ai/sdd-3-tools.html (Böckeler, 15 Oct 2025)
11. https://github.com/obra/superpowers
12. https://adr.github.io/madr/ (MADR 4.0.0)
13. https://www.industrialempathy.com/posts/design-docs-at-google/
14. https://diataxis.fr/
15. https://guidance.publishing.service.gov.uk/writing-to-gov-uk-standards/style-guides/a-to-z-style-guide/
16. https://vale.sh/hub (27 packages; none for plain English or GOV.UK)
17. https://code.claude.com/docs/en/memory
18. https://code.claude.com/docs/en/github-actions
19. https://simonwillison.net/2026/Oct/28/github-octoverse-2026/ (secondary; the GitHub blog itself was not read)
20. https://www.rics.org/content/dam/ricsglobal/documents/standards/Responsible-use-of-artificial-intelligence-in-surveying-practice_September-2025.pdf
21. https://cloud.google.com/blog/products/ai-machine-learning/introducing-doras-inaugural-ai-capabilities-model
22. https://code.claude.com/docs/en/plugins/install.md and /plugins/loading.md
23. https://buildermethods.com/agent-os

### Out of scope
Making any of these changes; the design method, styles and page check.

## Change log
- 1.2 (2 Nov 2026): the user's decisions: recommendations agreed; AGENTS.md adopted; Anthropic's page checked at every monthly review; client work gets the AI-use rule (drafted in the consulting project).
- 1.1 (2 Nov 2026): after the reader check: words explained, decisions split and scoped.
- 1.0 (2 Nov 2026): first version.
