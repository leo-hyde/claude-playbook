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
  mkdir -p "$w/shared" "$w/owner" "$w/templates/.claude/agents"
  cp "$ROOT"/shared/ai-dev-rules.md "$ROOT"/shared/session.sh "$ROOT"/shared/playbook-sync.sh \
     "$ROOT"/shared/setup.txt "$w/shared/"
  cp "$ROOT/owner/profile.md" "$w/owner/"
  cp "$ROOT/templates/.claude/settings.json" "$w/templates/.claude/"
  cp "$ROOT"/templates/.claude/agents/*.md "$w/templates/.claude/agents/"
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
out="Shorten it, or move detail to reference/."
check "rules file is $lines lines (limit $RULES_MAX_LINES)" [ "$lines" -le "$RULES_MAX_LINES" ]
# Owner details live in owner/; shared/ names the owner's account only in the playbook's address.
account=$(sed -n 's/^- GitHub: `\([^`]*\)`.*/\1/p' "$ROOT/owner/profile.md")
out=$(grep -rn "$account" "$ROOT/shared" | grep -v 'PLAYBOOK_URL=')
check "shared/ doesn't name the owner's account '$account' (except the playbook's address)" [ -n "$account" -a -z "$out" ]
out=$(grep -rnwi "leo" "$ROOT/shared" | grep -v 'PLAYBOOK_URL=')
check "shared/ doesn't name the owner" [ -z "$out" ]

# ---------- Sync: channels ----------
section "Sync: which playbook branch"
p=$(make_project stable-default)
sync "$p" "$T/pb"
check "no channel file: reads stable" rules_from_stable "$p"
check "copies the owner file to .claude/rules/owner.md" cmp -s "$p/.claude/rules/owner.md" "$ROOT/owner/profile.md"
check "copies the scout and checker subagents" cmp -s "$p/.claude/agents/checker.md" "$ROOT/templates/.claude/agents/checker.md"
check "the subagents are committed" git -C "$p" ls-files --error-unmatch .claude/agents/scout.md
check "says new subagents load from the next session" has "$out" "subagents (.claude/agents/) changed"
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

p=$(make_project self-update)
printf '# an older copy\n' >>"$p/scripts/playbook-sync.sh" && git -C "$p" commit -q -am "older sync script"
sync "$p" "$T/pb"
check "updates itself: replaced by the playbook's" cmp -s "$p/scripts/playbook-sync.sh" "$ROOT/shared/playbook-sync.sh"
check "updates itself: one report of what changed" [ "$(printf '%s\n' "$out" | grep -c 'from claude-playbook (committed')" -eq 1 ]
check "updates itself: no 'up to date' line after it" hasnt "$out" "shared rules are up to date"
check "updates itself: the report names the sync script and the rules" has "$out" "scripts/playbook-sync.sh"

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
check "prints one line for it: id and title" has "$out" "  2026-01-01-first: The first catch-up"
check "doesn't print the entry itself" hasnt "$out" "Do the first thing."
check "says where to read the entry" has "$out" "show origin/stable:shared/catch-up.md"

# ---------- Sync: a fork of the playbook ----------
section "Sync: a fork (its own owner/ and PLAYBOOK_URL)"
make_playbook fork stable
( cd "$T/fork-work" && printf '# About the user\nFORK OWNER\n' >owner/profile.md &&
  sed "s#^PLAYBOOK_URL=.*#PLAYBOOK_URL=\${PLAYBOOK_URL:-file://$T/fork.git}#" shared/playbook-sync.sh >sync.new &&
  mv sync.new shared/playbook-sync.sh && git commit -q -am "fork: owner and address" &&
  git push -q origin main && git push -q -f origin main:stable )
p=$(make_project fork-user)
cp "$T/fork-work/shared/playbook-sync.sh" "$p/scripts/playbook-sync.sh" && git -C "$p" commit -q -am "fork's sync"
out=$(cd "$p" && bash scripts/playbook-sync.sh 2>&1)
check "syncs from the fork's own address" grep -q "FORK OWNER" "$p/.claude/rules/owner.md"
check "keeps the fork's sync script" cmp -s "$p/scripts/playbook-sync.sh" "$T/fork-work/shared/playbook-sync.sh"

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
check "work on main, STATUS.md not updated: doesn't block (checked at push instead)" [ "$code" -eq 0 ]
check "work on main, STATUS.md not updated: says nothing" [ -z "$out" ]

# ---------- Push-to-main check ----------
section "Push-to-main docs check (push-check)"
p=$(make_project push)
push_check() {  # command line: what Claude is about to run
  local input
  input=$(python3 -c 'import json,sys; print(json.dumps({"tool_name": "Bash", "tool_input": {"command": sys.argv[1]}}))' "$1")
  out=$(cd "$p" && printf '%s' "$input" | bash scripts/session.sh push-check 2>&1); code=$?
}
echo x >"$p/app.txt" && git -C "$p" add app.txt && git -C "$p" commit -q -m "a feature"
push_check "git status"
check "not a push: allowed, silent" [ "$code" -eq 0 -a -z "$out" ]
push_check "git push origin HEAD:main"
check "push to main without STATUS.md: refused" [ "$code" -eq 2 ]
check "says what to update" has "$out" "docs/STATUS.md: update the Handover block"
push_check "git -c credential.helper= -c credential.helper='!/opt/homebrew/bin/gh auth git-credential' push origin HEAD:main"
check "the Mac's push command: refused too" [ "$code" -eq 2 ]
push_check "git add -A && git commit -m 'push it' && git push"
check "plain 'git push' on main: refused" [ "$code" -eq 2 ]
push_check "echo git push origin main"
check "'git push' only as text: allowed" [ "$code" -eq 0 ]
git -C "$p" checkout -q -b work
push_check "git push -u origin work"
check "push to the session's own branch: allowed" [ "$code" -eq 0 ]
push_check "git push origin work:main"
check "push of another branch to main: refused" [ "$code" -eq 2 ]
echo "Feature done." >>"$p/docs/STATUS.md" && git -C "$p" commit -q -am "status"
push_check "git push origin HEAD:main"
check "STATUS.md part of the push: allowed" [ "$code" -eq 0 ]
git -C "$p" push -q origin HEAD:main && git -C "$p" checkout -q main && git -C "$p" merge -q --ff-only work
( cd "$p" && echo y >>.claude/rules/playbook.md && git commit -q -am "Playbook: update shared files from claude-playbook" )
push_check "git push origin main"
check "only playbook sync commits: allowed" [ "$code" -eq 0 ]
git -C "$p" push -q origin main
( cd "$p" && mkdir -p specs && echo "# Plan" >SPEC.md && echo "Planned." >>docs/STATUS.md && git add -A &&
  git commit -q -m "plan" && git push -q origin main &&
  echo "# Feature" >specs/feature.md && echo "Spec." >>docs/STATUS.md && git add -A && git commit -q -m "spec" )
push_check "git push origin HEAD:main"
check "specs/ changed, SPEC.md not: refused" has "$out" "SPEC.md: specs/ changed"
( cd "$p" && echo "- Feature" >>SPEC.md && git commit -q -am "SPEC" )
push_check "git push origin HEAD:main"
check "SPEC.md updated too: allowed" [ "$code" -eq 0 ]
p_settings=$(python3 -c 'import json,sys; print(json.load(open(sys.argv[1]))["hooks"]["PreToolUse"][0]["hooks"][0]["command"])' "$ROOT/templates/.claude/settings.json")
check "the template's PreToolUse hook runs push-check" has "$p_settings" "session.sh\" push-check"

# ---------- Cost notes ----------
section "Cost notes (busy)"
p=$(make_project cost)
# transcript <file> <first context> <latest context> <minutes since the latest> [subagent context]
transcript() {
  python3 - "$@" <<'PY'
import json, sys, time
f, first, last, mins = sys.argv[1], int(sys.argv[2]), int(sys.argv[3]), int(sys.argv[4])
side = int(sys.argv[5]) if len(sys.argv) > 5 else 0
def entry(n, ago, sidechain=False):
    ts = time.strftime("%Y-%m-%dT%H:%M:%S.000Z", time.gmtime(time.time() - ago * 60))
    return json.dumps({"type": "assistant", "isSidechain": sidechain, "timestamp": ts,
        "message": {"usage": {"input_tokens": 2, "cache_read_input_tokens": n - 1002, "cache_creation_input_tokens": 1000}}})
with open(f, "w") as out:
    out.write(json.dumps({"type": "user", "message": {"content": "hi"}}) + "\n")
    out.write(entry(first, mins + 30) + "\n")
    if side:
        out.write(entry(side, mins, True) + "\n")
    out.write(entry(last, mins) + "\n")
PY
}
busy() {  # session id, transcript
  out=$(cd "$p" && printf '{"session_id": "%s", "transcript_path": "%s"}' "$1" "$2" | bash scripts/session.sh busy 2>&1)
}
transcript "$T/t1.jsonl" 60000 120000 1
busy s1 "$T/t1.jsonl"
check "2x a fresh session: silent" [ -z "$out" ]
transcript "$T/t1.jsonl" 60000 240000 1
busy s1 "$T/t1.jsonl"
check "4x: a COST note with the size and ratio" has "$out" "COST: each message now re-reads about 240k tokens, about 4× a fresh session's."
transcript "$T/t1.jsonl" 60000 250000 1
busy s1 "$T/t1.jsonl"
check "still 4x on the next message: silent (said once)" [ -z "$out" ]
transcript "$T/t1.jsonl" 60000 420000 1
busy s1 "$T/t1.jsonl"
check "7x: a second note" has "$out" "about 7× a fresh session's"
busy s1 "$T/t1.jsonl"
check "7x again: silent" [ -z "$out" ]
transcript "$T/t2.jsonl" 60000 90000 1 900000
busy s2 "$T/t2.jsonl"
check "a big subagent request doesn't count" [ -z "$out" ]
transcript "$T/t3.jsonl" 60000 150000 120
busy s3 "$T/t3.jsonl"
check "2.5x after a 2-hour break: cache note" has "$out" "COST: the cache has likely expired; this message re-processes about 150k tokens"
transcript "$T/t4.jsonl" 60000 90000 120
busy s4 "$T/t4.jsonl"
check "1.5x after a break: silent" [ -z "$out" ]
out=$(cd "$p" && printf '{}' | bash scripts/session.sh busy 2>&1)
check "no transcript: silent" [ -z "$out" ]
out=$(cd "$p" && printf '{"session_id": "s5", "transcript_path": "%s"}' "$T/missing.jsonl" | bash scripts/session.sh busy 2>&1)
check "transcript missing: silent" [ -z "$out" ]

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

section "Style library (tools/styles.py)"
out=$(python3 "$ROOT/tools/styles.py" check 2>&1)
check "every style passes contrast and its files are up to date" [ $? -eq 0 ]
s="$T/styles-copy"
mkdir -p "$s/tools" && cp "$ROOT/tools/styles.py" "$s/tools/" && cp -R "$ROOT/styles" "$s/styles"
python3 - "$s/styles/candidates.json" <<'PY'
import json, sys
p = sys.argv[1]; d = json.load(open(p))
d[0]["light"]["muted"] = d[0]["light"]["bg"]
json.dump(d, open(p, "w"))
PY
out=$(python3 "$s/tools/styles.py" check 2>&1)
check "a colour too pale to read fails the check" has "$out" "secondary text on the page"
out=$(python3 "$s/tools/styles.py" build 2>&1)
check "and isn't built" has "$out" "Not built"
cp "$ROOT/styles/candidates.json" "$s/styles/candidates.json"
lib=$(ls -d "$s"/styles/*/ | head -1)
echo "/* edited by hand */" >>"$lib/tokens.css"
out=$(python3 "$s/tools/styles.py" check 2>&1)
check "a hand-edited tokens.css is reported as out of date" has "$out" "out of date"
python3 "$s/tools/styles.py" build >/dev/null 2>&1
out=$(python3 "$s/tools/styles.py" check 2>&1)
check "build puts it right" [ $? -eq 0 ]

section "Error messages"
out=$(cat "$T/noise" 2>/dev/null)
check "no shell or git errors in any sync's output" [ -z "$out" ]

echo
echo "$passed passed, $failed failed."
[ "$failed" -eq 0 ]
