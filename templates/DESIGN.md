# <App name>: Design Guide

How the app looks and feels. Claude follows this for every new screen or
feature. Change it here first, then in the code.

## Inspiration
- **<App Leo likes>:** <what to take from it>
- **<App Leo finds annoying>:** <what to avoid>

## Principles
1. **Glance first.** The main question is answered in under 2 seconds, with a
   headline at the top. Detail comes on tap.
2. **Colour carries meaning.** Bright colours only for what matters;
   everything else (chrome, "no", empty, past) is calm grey.
3. **Never colour alone.** Also words, symbols, shape or brightness.
4. **Phone first.** Designed for one hand on a phone, then scaled up.
   Tap targets 44px or more. Nothing wider than the screen.
5. **Follow the phone.** Light or dark theme comes from the device.

## Design tokens (in `:root` in style.css; see the skill's templates/style.css)
| Token | Light | Dark | Used for |
|---|---|---|---|
| `--bg` | #eef1f5 | #0e1116 | page background |
| `--surface` | #ffffff | #171b22 | cards, dialogs |
| `--surface-2` | #f4f6f9 | #202631 | inputs, inner panels |
| `--text` | #111827 | #e8ecf2 | main text |
| `--muted` | #6b7280 | #98a2b3 | secondary text |
| `--border` | #e3e7ee | #2a313c | dividers |
| `--accent` | #2563eb | #5b8cff | buttons, active tab, links |
| `--good` / `--ok` | #22c55e / #fbbf24 | #2fd36b / #f5c04a | status colours (if needed) |
| `--no` | #eceff3 | #222833 | "no"/empty: calm grey |

- **Font:** the device's system font; `tabular-nums` for numbers.
- **Type sizes:** 12 / 14 / 16 / 20 / 26px. **Spacing:** multiples of 4px.
- **Corners:** 14px cards and dialogs, 6px small chips. Soft shadows, light mode only.

## Components
- **Header:** app name, status line ("updated 14:05"), refresh and settings buttons.
- **Navigation:** pill tabs at the top on desktop; a bottom tab bar with icons on phones.
- **Cards:** one per item, on `--surface`.
- **Dialogs:** centred on desktop; bottom sheets on phones with a grab handle
  and an always-visible action bar.
- **Toast:** short messages at the bottom, with Undo where something was removed.

## Phone layout (under 600px)
- Rows of controls wrap. Tabs at the bottom. Compact header. Full-width content.

## UX review
Use the skill's `reference/ux-checklist.md`; record findings and changes here.
