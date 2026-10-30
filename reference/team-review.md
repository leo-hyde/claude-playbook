# Team review in Google Docs and Slides

**Version 1.0 · 30 Oct 2026 · Status: tested on one project (several review
rounds, Mac); the copy script and picture automation below are not built yet**

Use this when people who don't use GitHub (a client, a team, a manager) need
to read, comment on or change a document that lives in the repo.

- **Summary:** the loop in half a minute.
- **Plan and decisions:** one review round, step by step, and the rules.
- **Detail:** the exact connector calls, pictures, known problems.

## Summary
- **The repo file is the master.** Each document is a Markdown file in the
  repo; its history is the commits. Reviewers work on a Google Doc copy.
- **One round:** Claude makes a Doc copy; reviewers comment or suggest;
  Claude reads their changes, works them into the Markdown, raises the
  version and makes a fresh Doc for the next round. The old Doc stays as the
  record of that round's comments.
- **Every Google file Claude makes or edits says how to edit it,** so
  people's changes stay visible to AI (the lines are below).
- **Changes made in the repo are spotted too:** session start lists edits
  people made on github.com and `> To Claude` notes left in documents.

## Plan and decisions

### One review round
1. **Write or update the Markdown** in a session; commit it.
2. **Make the Doc copy** (a few minutes): upload the Markdown so Drive turns
   it into a Doc; take out GitHub-only parts (how to edit on GitHub,
   instructions for Claude, `> To Claude` notes); add the "How to edit"
   line near the top; add pictures (Detail).
3. **Name it by a fixed rule:** "<Document> v<version> (for <reviewer>'s
   review)". Record the new Doc's id where the project lists its files
   (usually CLAUDE.md), and mark the older copy superseded.
4. **Reviewers comment, or edit with Suggesting mode on,** so each change
   stays separate and named.
5. **Read the comments and suggestions,** work them into the Markdown, log
   who changed what in its change log, raise the version, commit.
6. **Make a new Doc for the next round.** Don't keep editing the old one.

### Rules
- **The "How to edit" line on every Google file Claude makes or edits.**
  - Docs, near the top: "How to edit: make changes with comments, or with
    Suggesting mode turned on (pencil icon, top right), so AI can see what
    you have changed."
  - Slides (no suggesting mode): a small grey line on slide 1: "How to edit:
    add a comment, or a speaker-notes line starting "To Claude:", so AI can
    see what you want changed." Read speaker notes for those lines.
  - Sheets: "How to edit: add a comment or a cell note, so AI can see what
    you have changed."
  - Other people's own files: ask before adding it.
- **Decks: agree the words first, as text in the repo, then build the deck
  once from that text.** Building and rebuilding slides to settle wording
  costs far more.
- **One wording, one home.** The same words copied into decks and Docs
  drift apart; when a term changes, list every copy that still uses the old
  one.
- **Source documents stay where they live** (Drive, a shared folder): link
  them with their file ids and read them with the connector, rather than
  copying them into the repo. Read only the parts the task needs.

## Detail

### Making the copy (tested on the Mac)
- **Upload:** the Google Drive connector's `create_file` with
  `contentMimeType: "text/markdown"` makes a real Doc with headings, lists,
  tables and links.
- **Editing an existing Doc or deck** needs the Google Docs and Slides
  editing connectors. The Drive connector alone can create files but not
  edit them; cloud sessions may not have the editing connectors.
- **Pictures:** the Docs API only inserts images from public web addresses,
  and the Drive connector can't share by link. What works: put a marker word
  (e.g. `PICTUREONEHERE`) where each picture goes; copy the PNGs into a
  Drive folder through the Mac's Google Drive folder
  (`~/Library/CloudStorage/GoogleDrive-<account>/...`; time-limit `ls`
  there, it can hang); then in a browser jump to each marker, select it and
  use Insert › Image › Drive. Afterwards search the Doc for any marker left.
  This needs the Mac and a browser.
- **Not yet tried:** a Google Apps Script (Google's own scripting, run under
  the user's account after a one-off approval) that swaps each marker for its
  picture, which would work from the phone too.

### Reading the review
- **Comments:** read the Doc with comments included (`includeComments: true`
  on the Drive connector's `read_file_content`).
- **Suggestions:** read with the Docs connector. Reading them as separate,
  named changes is not yet checked end to end.
- **Direct edits** (typed without Suggesting mode) are not flagged: compare
  the returned Doc's text with the Markdown that was sent.

### Known problems
- Each round makes a new Doc with a new link; nothing syncs by itself.
- The whole document passes through the conversation when making a copy,
  which costs tokens. A copy script (one command that strips the GitHub-only
  parts, adds the line and markers, and names the file) would fix most of
  this; not built yet.
- Anything only in the repo is invisible to people who don't use GitHub.

### Not proposed
Live two-way sync (much bigger; a new copy per round already gives a clear
record). Making the Google Doc the master: decide per document, only for one
the team edits heavily.

## Change log
- 1.0 (30 Oct 2026): first version, from a consulting project's review
  rounds.
