#!/usr/bin/env bash
# Releases the playbook: moves `stable` (the branch every project syncs from) on to
# `main`, and tags it release-YYYY-MM-DD (-2, -3 for more than one on a day).
# A release reaches every project at its next session start, so it goes ahead only when:
#   - this is the playbook, on main, nothing unsaved, and main matches GitHub;
#   - RELEASES.md's newest entry is for this release (its heading is the new tag);
#   - bash tests/run.sh passes;
#   - the user says yes: asked here, or --yes once Claude has asked them in chat.
# It pushes stable, then the tag; if the tag is refused (cloud sessions), it says how to add it.
# Undo: revert the bad commit on main and release again. Never force-push stable.
#
#   scripts/release.sh          check, show what's going out, ask, push
#   scripts/release.sh --check  check and show only; pushes nothing
#   scripts/release.sh --yes    push without asking here (only after the user's yes)

set -u
cd "$(git rev-parse --show-toplevel)" || exit 1
mode=${1:-ask}
case "$mode" in ask|--check|--yes) ;; *) echo "Usage: $0 [--check | --yes]"; exit 1 ;; esac

die() { echo "RELEASE REFUSED: $*" >&2; exit 1; }

[ -f shared/ai-dev-rules.md ] || die "run this in the playbook repo."
[ "$(git rev-parse --abbrev-ref HEAD)" = main ] || die "switch to main first."
[ -z "$(git status --porcelain)" ] || die "there are uncommitted changes."
git fetch -q origin "+refs/heads/main:refs/remotes/origin/main" || die "couldn't reach GitHub."
git fetch -q origin "+refs/heads/stable:refs/remotes/origin/stable" 2>/dev/null   # missing before the first release
git fetch -q --tags origin 2>/dev/null
[ "$(git rev-parse HEAD)" = "$(git rev-parse origin/main)" ] ||
  die "main here isn't the same as main on GitHub. Push or pull first."

since=""
if git rev-parse -q --verify origin/stable >/dev/null; then
  git merge-base --is-ancestor origin/stable HEAD || die "stable has commits that main doesn't. Stop and tell the user."
  [ -n "$(git rev-list origin/stable..HEAD)" ] || die "nothing to release: stable is already at main."
  since=origin/stable..
fi

# A release counts as made if its tag exists or stable's RELEASES.md has its note
# (a cloud session can't always push tags).
released=$(git show origin/stable:RELEASES.md 2>/dev/null | awk '/^## release-/ { print $2 }')
taken() { git rev-parse -q --verify "refs/tags/$1" >/dev/null || printf '%s\n' "$released" | grep -qx -- "$1"; }
day=release-$(date +%Y-%m-%d); tag=$day; n=1
while taken "$tag"; do n=$((n + 1)); tag=$day-$n; done
newest=$(awk '/^## release-/ { print $2; exit }' RELEASES.md 2>/dev/null)
[ "$newest" = "$tag" ] || die "RELEASES.md's newest entry should be '## $tag' (found '${newest:-none}').
Add it on main: two or three plain lines on what changes for the user, and any catch-up."

echo "Running the tests..."
if ! out=$(bash -c "${RELEASE_TEST_CMD:-bash tests/run.sh}" 2>&1); then   # RELEASE_TEST_CMD: for the tests only
  printf '%s\n' "$out" | tail -20
  die "the tests failed."
fi
printf '%s\n' "$out" | tail -1

echo
echo "Release $tag. Going out to every project:"
git log --oneline ${since}HEAD | head -30
echo
echo "Release note:"
awk '/^## release-/ { if (seen) exit; seen = 1 } seen' RELEASES.md
echo

case "$mode" in
  --check) echo "Checks passed. Nothing pushed (--check)."; exit 0 ;;
  ask)
    [ -t 0 ] || die "no terminal to ask on. Ask the user in chat, then run: scripts/release.sh --yes"
    printf 'This reaches every project. Release %s? Type yes: ' "$tag"
    read -r answer
    [ "$answer" = yes ] || die "not confirmed." ;;
esac

# No force, so GitHub refuses if stable would lose commits.
git push -q origin "HEAD:refs/heads/stable" || die "GitHub refused the push to stable. Nothing was released."
echo "Released $tag. Every project picks it up at its next session start."
# The tag only marks the release; projects don't need it. Cloud sessions may not be allowed to push tags.
if ! { git tag "$tag" HEAD && git push -q origin "refs/tags/$tag"; } 2>/dev/null; then
  git tag -d "$tag" >/dev/null 2>&1
  echo "TAG NOT PUSHED: GitHub refused the tag. Tell the user; on the Mac, run in the playbook:"
  echo "  git fetch origin stable && git tag $tag $(git rev-parse --short HEAD) && git push origin $tag"
fi
