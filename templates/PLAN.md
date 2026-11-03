# <Project name>: the plan

Updated <date>. The one place that says what we're building, why, what's
done and what's next.

<!-- Rules for this file (for Claude):
- Every feature the user wants is here, built or not, with what it should
  do *now* (not what it first said). One line each.
- Grouped by state, so reading top to bottom is the board: Now, Next, Later,
  Paused, Done, Dropped. A feature moves between groups; it is never deleted.
- Now: has an open pull request, linked. Paused: its pull request is open
  with the "paused" label.
- Change this file in the same commit (or pull request) as the work. A change
  of mind also gets a line in docs/decisions.md (was, now, why).
- Before writing or changing a spec, list every feature under its objective
  and ask the user to confirm nothing is missing.
- No history and no detail: detail goes in specs/, reasons in decisions.md. -->

## Goal
<One or two sentences: the problem, who it's for, and what success looks like.>

## Objectives
1. **<Objective>:** <what it achieves, and how we'll know (a success measure)>
2. **<Objective>:** …

## Features
Each line: **name** (objective number): what it should do. [spec](specs/x.md) · [pull request](../../pull/1)

### Now
- **<Feature>** (1): <what it should do>. [pull request](../../pull/1)

### Next
- **<Feature>** (1): <what it should do>.

### Later
- **<Feature>** (2): <what it should do, and why it waits>.

### Paused
- (none)

### Done
- **<Feature>** (1): <what it does>. Checked <date>: <how>.

### Dropped
- **<Feature>**: <why>. See [decisions](docs/decisions.md).

## How it's built
<A few lines, only if there's no docs/ARCHITECTURE.md yet: the main tools and
data sources, and why.>
