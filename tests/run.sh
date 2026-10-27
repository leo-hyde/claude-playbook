#!/usr/bin/env bash
# The playbook's kept tests: bash tests/run.sh (exit 0 = all passed).
# Builds throwaway playbooks and projects in a temporary folder, each with a local
# "GitHub" (a bare repo), and runs the scripts in shared/ and scripts/release.sh
# against them: the working copies, so uncommitted changes are tested too.
# Nothing here touches the network or the real repos.
# Runs on Linux and macOS (bash 3.2, BSD tools); the GitHub Action runs both.
# Changing a script? Add a case here.

set -u
ROOT=$(cd "$(dirname "$0")/.." && pwd)
T=$(mktemp -d "${TMPDIR:-/tmp}/playbook-tests.XXXXXX") || exit 1
trap 'rm -rf "$T"' EXIT

RULES_MAX_LINES=150      # shared/ai-dev-rules.md is read in every session of every project
RULES_CEILING=197        # its size on 27 Oct 2026: it mustn't grow. Remove once it's under the limit
START_MAX_CHARS=1500     # session-start output, read at the start of every session

# A clean, predictable environment: no real git config, home folder, network or GitHub.
export HOME="$T/home" GIT_CONFIG_NOSYSTEM=1
export GIT_AUTHOR_NAME=Test GIT_AUTHOR_EMAIL=test@example.invalid
export GIT_COMMITTER_NAME=Test GIT_COMMITTER_EMAIL=test@example.invalid
unset CLAUDE_CODE_REMOTE PLAYBOOK_DIR PLAYBOOK_SYNC_SRC PLAYBOOK_URL RELEASE_TEST_CMD
mkdir -p "$HOME" "$T/bin"
git config --global init.defaultBranch main 2>/dev/null
git config --global advice.detachedHead false
# Every nested "bash" is this one, so macOS runs everything on its bash 3.2.
ln -s "$BASH" "$T/bin/bash"
printf '#!/bin/sh\nexit 1\n' >"$T/bin/curl"   # GitHub's API "can't be reached": visibility says nothing
printf '#!/bin/sh\nexit 0\n' >"$T/bin/gh"     # a GitHub CLI with no open issues
chmod +x "$T/bin/curl" "$T/bin/gh"
export PATH="$T/bin:$PATH"

passed=0; failed=0
ok()  { passed=$((passed + 1)); echo "  ok    $1"; }
bad() { failed=$((failed + 1)); echo "  FAIL  $1"; [ -n "${2:-}" ] && printf '%s\n' "$2" | sed 's/^/          /' | head -15; }
# check "description" <command...>: passes if the command succeeds.
check() { local d=$1; shift; if "$@" >/dev/null 2>&1; then ok "$d"; else bad "$d" "${out:-}"; fi; }
has()   { case "$1" in *"$2"*) return 0 ;; esac; return 1; }
hasnt() { ! has "$1" "$2"; }
section() { echo; echo "$1"; }

# ---------- Fixtures ----------

# make_playbook name [stable|nostable]: a playbook on a local "GitHub" ($T/name.git) and a
# clone of it ($T/name). Release 1 is the working copy of shared/; main then gets one more
# commit, marked MAIN-ONLY, which is "pushed but not released".
make_playbook() {
  local name=$1 kind=${2:-stable} w=$T/$1-work
  git init -q --bare "$T/$name.git"
  git init -q "$w"
  mkdir -p "$w/shared" "$w/templates/.claude"
  cp "$ROOT"/shared/ai-dev-rules.md "$ROOT"/shared/session.sh "$ROOT"/shared/playbook-sync.sh \
     "$ROOT"/shared/setup.txt "$w/shared/"
  cp "$ROOT/templates/.claude/settings.json" "$w/templates/.claude/"
  printf '# Catch-ups\n\n## 2026-01-01-first: The first catch-up\n- Do the first thing.\n' >"$w/shared/catch-up.md"
  printf '# Releases\n\n## release-2026-01-01\nThe first line of the note.\n- More detail.\n' >"$w/RELEASES.md"
  ( cd "$w" && git add -A && git commit -q -m "release 1" &&
    git remote add origin "$T/$name.git" && git push -q origin main &&
    if [ "$kind" = stable ]; then git push -q origin main:stable; fi &&
    echo "MAIN-ONLY: not released yet" >>shared/ai-dev-rules.md &&
    git commit -q -am "unreleased change" && git push -q origin main )
  git clone -q "$T/$name.git" "$T/$name"
}

# make_project name [channel]: a project set up as the playbook expects, on its own local
# "GitHub", cloned to $T/p/name/repo (alone in its folder, so it has no attached siblings).
# Prints the clone's path.
make_project() {
  local name=$1 channel=${2:-} w=$T/p/$1/repo
  git init -q --bare "$T/p/$name.git" && mkdir -p "$T/p/$name" && git init -q "$w" || return 1
  (
    cd "$w" || exit 1
    mkdir -p docs scripts .claude/rules
    printf '# Project\n' >CLAUDE.md
    printf '# Live status\n\n## Handover\n| | |\n|---|---|\n| Next step | Test things |\n\n## Where we are\nTesting.\n' >docs/STATUS.md
    printf '# Decisions\n' >docs/decisions.md
    printf '# Catch-ups done\n- 2026-01-01-first: done.\n' >docs/playbook-catch-up.md
    printf '.claude/*\n!.claude/settings.json\n!.claude/rules/\n.session/\n' >.gitignore
    cp "$ROOT/templates/.claude/settings.json" .claude/settings.json
    cp "$ROOT/shared/session.sh" "$ROOT/shared/playbook-sync.sh" scripts/
    echo "old rules" >.claude/rules/playbook.md
    [ -n "$channel" ] && echo "$channel" >.claude/playbook-channel
    git add -A && { [ -z "$channel" ] || git add -f .claude/playbook-channel; } &&
      git commit -q -m "start" && git remote add origin "$T/p/$name.git" && git push -q -u origin main
  ) >/dev/null 2>&1 || return 1
  echo "$w"
}

# sync <project> <playbook clone> [env...]: run the project's sync; output in $out.
# Any shell or git error in its output is noted in $T/noise (checked at the end).
sync() {
  local p=$1 pb=$2; shift 2
  out=$(cd "$p" && env PLAYBOOK_DIR="$pb" "$@" bash scripts/playbook-sync.sh 2>&1)
  printf '%s\n' "$out" | grep -E 'No such file|command not found|syntax error|unbound variable|^fatal:|^error:|line [0-9]+:' |
    sed "s#^#${p#$T/p/}: #" >>"$T/noise"
}
rules_from_main() { grep -q MAIN-ONLY "$1/.claude/rules/playbook.md"; }
rules_from_stable() { [ -s "$1/.claude/rules/playbook.md" ] && ! rules_from_main "$1" && ! grep -qx "old rules" "$1/.claude/rules/playbook.md"; }
clean() { [ -z "$(git -C "$1" status --porcelain)" ]; }

echo "Playbook tests: bash $BASH_VERSION on $(uname -s)"
make_playbook pb stable
make_playbook pbnew nostable

# ---------- Syntax and budgets ----------
section "Syntax and budgets"
for f in "$ROOT"/shared/*.sh "$ROOT"/scripts/*.sh "$ROOT"/tests/run.sh; do
  out=$(bash -n "$f" 2>&1); check "bash -n ${f#$ROOT/}" [ -z "$out" ]
done
lines=$(wc -l <"$ROOT/shared/ai-dev-rules.md" | tr -d ' ')
if [ "$lines" -le "$RULES_MAX_LINES" ]; then
  ok "rules file is $lines lines (limit $RULES_MAX_LINES)"
elif [ "$lines" -le "$RULES_CEILING" ]; then
  ok "rules file is $lines lines: over the $RULES_MAX_LINES limit, not over today's $RULES_CEILING (it mustn't grow)"
else
  bad "rules file is $lines lines: over the $RULES_MAX_LINES limit and grown past $RULES_CEILING. Shorten it or move detail to reference/"
fi

# ---------- Sync: channels ----------
section "Sync: which playbook branch"
p=$(make_project stable-default)
sync "$p" "$T/pb"
check "no channel file: reads stable" rules_from_stable "$p"
check "prints the newest release note" has "$out" "Playbook: updated to release-2026-01-01: The first line of the note."
check "commits the update" clean "$p"
sync "$p" "$T/pb"
check "second run: up to date, no note" has "$out" "shared rules are up to date"

p=$(make_project canary main)
sync "$p" "$T/pb"
check "channel main (canary): reads main" rules_from_main "$p"
check "says it's the canary" has "$out" "(canary), not a release"

p=$(make_project explicit-stable stable)
sync "$p" "$T/pb"
check "channel stable: reads stable" rules_from_stable "$p"

p=$(make_project bad-channel nightly)
sync "$p" "$T/pb"
check "unknown channel: says so" has "$out" "SETUP: .claude/playbook-channel should read main or stable, not 'nightly'"
check "unknown channel: reads stable" rules_from_stable "$p"

p=$(make_project no-stable)
sync "$p" "$T/pbnew"
check "no stable branch yet: falls back to main" rules_from_main "$p"
check "says there's no stable yet" has "$out" "no stable branch yet"

p=$(make_project download)
out=$(cd "$p" && PLAYBOOK_URL="file://$T/pb.git" bash scripts/playbook-sync.sh 2>&1)
check "no clone nearby: downloads a copy and reads stable" rules_from_stable "$p"
check "the downloaded copy is kept out of git" clean "$p"
git -C "$T/pb-work" push -q origin main:stable   # a release since the copy was downloaded
out=$(cd "$p" && PLAYBOOK_URL="file://$T/pb.git" bash scripts/playbook-sync.sh 2>&1)
check "downloaded copy picks up the next release" rules_from_main "$p"
git -C "$T/pb-work" push -q -f origin main~1:stable   # back to release 1 for the other tests

p=$(make_project offline)
out=$(cd "$p" && PLAYBOOK_URL="file://$T/missing.git" bash scripts/playbook-sync.sh 2>&1)
check "playbook unreachable: says PLAYBOOK NOT SYNCED" has "$out" "PLAYBOOK NOT SYNCED"
check "playbook unreachable: keeps the copy it has" grep -qx "old rules" "$p/.claude/rules/playbook.md"

# ---------- Sync: change-over from scripts older than releases ----------
section "Sync: old scripts"
p=$(make_project old-before)
cp "$ROOT/tests/fixtures/old-playbook-sync.sh" "$p/scripts/playbook-sync.sh"
git -C "$p" commit -q -am "old sync script"
sync "$p" "$T/pbnew"
check "old script, no stable yet: syncs from main" rules_from_main "$p"
check "old script replaced by the new one" cmp -s "$p/scripts/playbook-sync.sh" "$ROOT/shared/playbook-sync.sh"

p=$(make_project old-after)
cp "$ROOT/tests/fixtures/old-playbook-sync.sh" "$p/scripts/playbook-sync.sh"
git -C "$p" commit -q -am "old sync script"
sync "$p" "$T/pb"
check "old script, after the first release: updates itself, then reads stable" rules_from_stable "$p"
check "old script replaced by the new one" cmp -s "$p/scripts/playbook-sync.sh" "$ROOT/shared/playbook-sync.sh"
sync "$p" "$T/pb"
check "next session: stays on stable" rules_from_stable "$p"

# ---------- Sync: set-up and catch-ups ----------
section "Sync: set-up (setup.txt) and catch-ups"
p=$(make_project setup)
( cd "$p" && printf '.claude/*\n' >.gitignore && echo '{"model": "x"}' >.claude/settings.json &&
  git rm -q docs/decisions.md && git commit -q -am "missing set-up" )
sync "$p" "$T/pb"
check "adds missing .gitignore lines" grep -qx ".session/" "$p/.gitignore"
check "adds the hooks" grep -q 'session.sh\\" start' "$p/.claude/settings.json"
check "keeps other settings" grep -q '"model": "x"' "$p/.claude/settings.json"
check "commits the set-up" has "$(git -C "$p" log -1 --format=%s)" "Playbook: complete the project set-up"
check "reports a missing file" has "$out" "SETUP: docs/decisions.md is missing"
sync "$p" "$T/pb"
check "second run: nothing more to add" hasnt "$out" "added what the playbook's set-up needs"

check "catch-up already recorded: not printed" hasnt "$out" "CATCH-UP DUE"
p=$(make_project catchup)
( cd "$p" && printf '# Catch-ups done\n' >docs/playbook-catch-up.md && git commit -q -am "none done" )
sync "$p" "$T/pb"
check "catch-up not recorded: CATCH-UP DUE" has "$out" "CATCH-UP DUE"
check "prints its id" has "$out" "2026-01-01-first"

# ---------- Session start ----------
section "Session start"
p=$(make_project start)
sync "$p" "$T/pb"
out=$(cd "$p" && PLAYBOOK_DIR="$T/pb" bash scripts/session.sh start 2>&1)
check "starts, syncs and shows the handover" has "$out" "| Next step | Test things |"
check "no other work listed" has "$out" "No other unfinished work"
chars=$(printf '%s' "$out" | wc -c | tr -d ' ')
check "output is $chars characters (limit $START_MAX_CHARS)" [ "$chars" -le "$START_MAX_CHARS" ]
git -C "$p" checkout -q -b other && echo x >"$p/other.txt" && git -C "$p" add other.txt &&
  git -C "$p" commit -q -m other && git -C "$p" push -q origin other && git -C "$p" checkout -q main
git -C "$p" branch -q -D other
out=$(cd "$p" && PLAYBOOK_DIR="$T/pb" bash scripts/session.sh start 2>&1)
check "lists another session's branch" has "$out" "  other: 2 commit(s) not on main"

# ---------- End-of-reply check ----------
section "End-of-reply check"
p=$(make_project check)
run_check() {  # env-setting [hook input]
  local input=${2:-'{}'}
  out=$(cd "$p" && printf '%s' "$input" | env "$1" bash scripts/session.sh check 2>&1); code=$?
}
run_check CLAUDE_CODE_REMOTE=true
check "cloud, all pushed: lets the reply end" [ "$code" -eq 0 ]
echo x >"$p/new.txt"
run_check CLAUDE_CODE_REMOTE=true
check "cloud, uncommitted work: blocks" [ "$code" -eq 2 ]
check "says what to do" has "$out" "Uncommitted changes. Commit them."
run_check CLAUDE_CODE_REMOTE=true '{"stop_hook_active": true}'
check "already retrying after a block: doesn't loop" [ "$code" -eq 0 ]
git -C "$p" add new.txt && git -C "$p" commit -q -m "unpushed work"
git -C "$p" checkout -q -b work
run_check CLAUDE_CODE_REMOTE=true
check "cloud, commits on no GitHub branch: blocks" has "$out" "Commits on no branch on GitHub"
if [ "$(uname -s)" = Darwin ]; then
  run_check CLAUDE_CODE_REMOTE=false
  check "Mac, unpushed: reminds, doesn't block" [ "$code" -eq 0 ]
  check "Mac reminder is a systemMessage" has "$out" '"systemMessage"'
fi
git -C "$p" push -q origin work
run_check CLAUDE_CODE_REMOTE=true
check "work pushed to its own branch: no docs check yet" [ "$code" -eq 0 ]
git -C "$p" checkout -q main && git -C "$p" merge -q work && git -C "$p" push -q origin main
run_check CLAUDE_CODE_REMOTE=true
check "work on main, STATUS.md not updated: blocks" has "$out" "Update STATUS.md"
echo "Done." >>"$p/docs/STATUS.md" && git -C "$p" commit -q -am "status" && git -C "$p" push -q origin main
run_check CLAUDE_CODE_REMOTE=true
check "STATUS.md updated: lets the reply end" [ "$code" -eq 0 ]
( cd "$p" && mkdir -p specs && echo "# Plan" >SPEC.md && git add SPEC.md && git commit -q -m "plan" &&
  echo "# Feature" >specs/feature.md && echo "More." >>docs/STATUS.md && git add -A && git commit -q -m "spec" &&
  git push -q origin main )
run_check CLAUDE_CODE_REMOTE=true
check "specs/ changed, SPEC.md not: blocks" has "$out" "specs/ changed on main since SPEC.md"
( cd "$p" && echo "- Feature" >>SPEC.md && echo "Planned." >>docs/STATUS.md && git commit -q -am "SPEC" && echo x >>.claude/rules/playbook.md &&
  git commit -q -am "Playbook: update shared files from claude-playbook" && git push -q origin main )
run_check CLAUDE_CODE_REMOTE=true
check "a playbook sync commit doesn't need a STATUS update" [ "$code" -eq 0 ]

# ---------- Coaching counter ----------
section "Coaching counter (busy)"
p=$(make_project coach)
head -c 20480 /dev/zero | tr '\0' x >"$T/transcript.jsonl"
input="{\"session_id\": \"s1\", \"transcript_path\": \"$T/transcript.jsonl\", \"prompt\": \"hi\"}"
quiet=yes; i=1
while [ $i -lt 15 ]; do
  o=$(cd "$p" && printf '%s' "$input" | bash scripts/session.sh busy 2>&1); [ -z "$o" ] || quiet=no
  i=$((i + 1))
done
check "messages 1 to 14: silent" [ "$quiet" = yes ]
out=$(cd "$p" && printf '%s' "$input" | bash scripts/session.sh busy 2>&1)
check "message 15: COACH line with the transcript size" has "$out" "COACH: this session has had 15 of Leo's messages (transcript 20 KB)"
out=$(cd "$p" && printf '{}' | bash scripts/session.sh busy 2>&1)
check "no session id: silent" [ -z "$out" ]

# ---------- Release script ----------
section "Release (scripts/release.sh)"
make_playbook rel stable
r=$T/rel
mkdir -p "$r/scripts" && cp "$ROOT/scripts/release.sh" "$r/scripts/release.sh"
git -C "$r" add scripts && git -C "$r" commit -q -m "release script" && git -C "$r" push -q origin main
release() { out=$(cd "$r" && env RELEASE_TEST_CMD="${TESTS:-true}" bash scripts/release.sh "$@" 2>&1 </dev/null); code=$?; }
stable_at() { git -C "$T/rel.git" rev-parse stable; }
before=$(stable_at)
tag=release-$(date +%Y-%m-%d)
release --yes
check "no release note for today: refuses" has "$out" "newest entry should be '## $tag'"
( cd "$r" && printf '# Releases\n\n## %s\nTest release.\n\n## release-2026-01-01\nOld.\n' "$tag" >RELEASES.md &&
  git commit -q -am "note" )
release --yes
check "main not pushed: refuses" has "$out" "isn't the same as main on GitHub"
git -C "$r" push -q origin main
TESTS=false release --yes
check "tests fail: refuses" has "$out" "RELEASE REFUSED: the tests failed"
check "nothing pushed after a refusal" [ "$(stable_at)" = "$before" ]
release
check "no terminal and no --yes: refuses, says to ask in chat" has "$out" "Ask the user in chat"
release --check
check "--check: passes" [ "$code" -eq 0 ]
check "--check: pushes nothing" [ "$(stable_at)" = "$before" ]
release --yes
check "--yes: releases" [ "$code" -eq 0 ]
check "stable moved to main" [ "$(stable_at)" = "$(git -C "$T/rel.git" rev-parse main)" ]
check "tagged $tag on GitHub" git -C "$T/rel.git" rev-parse -q --verify "refs/tags/$tag"
release --yes
check "nothing new: refuses" has "$out" "nothing to release"
( cd "$r" && echo "- more" >>shared/setup.txt && git commit -q -am "more" &&
  printf '# Releases\n\n## %s-2\nSecond today.\n' "$tag" >RELEASES.md && git commit -q -am "note 2" && git push -q origin main )
release --yes
check "second release in a day: tagged $tag-2" git -C "$T/rel.git" rev-parse -q --verify "refs/tags/$tag-2"
# A tag GitHub refuses (as cloud sessions' git may): stable still moves, and it says how to add the tag.
printf '#!/bin/sh\nwhile read old new ref; do case "$ref" in refs/tags/*) echo "tags refused" >&2; exit 1 ;; esac; done\n' \
  >"$T/rel.git/hooks/pre-receive" && chmod +x "$T/rel.git/hooks/pre-receive"
( cd "$r" && echo "- again" >>shared/setup.txt && git commit -q -am "again" &&
  printf '# Releases\n\n## %s-3\nThird today.\n\n## %s-2\nSecond today.\n' "$tag" "$tag" >RELEASES.md &&
  git commit -q -am "note 3" && git push -q origin main )
release --yes
check "tag refused: still released" [ "$(stable_at)" = "$(git -C "$T/rel.git" rev-parse main)" ]
check "tag refused: says how to add it" has "$out" "TAG NOT PUSHED"
( cd "$r" && echo "- once more" >>shared/setup.txt && git commit -q -am "once more" &&
  printf '# Releases\n\n## %s-4\nFourth today.\n\n## %s-3\nThird.\n' "$tag" "$tag" >RELEASES.md &&
  git commit -q -am "note 4" && git push -q origin main )
release --check
check "a release without its tag still counts: next is $tag-4" [ "$code" -eq 0 ]
rm -f "$T/rel.git/hooks/pre-receive"
( cd "$r" && echo x >stray.txt )
release --yes
check "uncommitted changes: refuses" has "$out" "uncommitted changes"

section "Error messages"
out=$(cat "$T/noise" 2>/dev/null)
check "no shell or git errors in any sync's output" [ -z "$out" ]

echo
echo "$passed passed, $failed failed."
[ "$failed" -eq 0 ]
