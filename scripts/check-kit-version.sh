#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$repo_root"

version="$(tr -d '[:space:]' < VERSION)"
if [[ ! "$version" =~ ^(0|[1-9][0-9]*)\.(0|[1-9][0-9]*)\.(0|[1-9][0-9]*)$ ]]; then
  echo "Invalid Participant Kit version: $version" >&2
  exit 1
fi
grep -Eq "^## ${version//./\\.} — [0-9]{4}-[0-9]{2}-[0-9]{2}$" kit/CHANGELOG.md || {
  echo "kit/CHANGELOG.md needs a dated ## $version entry" >&2
  exit 1
}

base_ref="${1:-}"
[[ -n "$base_ref" ]] || exit 0
git rev-parse --verify "$base_ref^{commit}" >/dev/null

changed="$(git diff --name-only "$base_ref"...HEAD -- \
  AGENTS.md .agents .githooks kit participants/_template \
  scripts/init-participant.sh scripts/check-submission.sh | \
  grep -v '^kit/CHANGELOG.md$' || true)"
[[ -n "$changed" ]] || exit 0

base_version="$(git show "$base_ref:VERSION" 2>/dev/null | tr -d '[:space:]' || true)"
[[ -n "$base_version" ]] || base_version="0.0.0"
if [[ ! "$base_version" =~ ^(0|[1-9][0-9]*)\.(0|[1-9][0-9]*)\.(0|[1-9][0-9]*)$ ]]; then
  echo "Invalid base Participant Kit version: $base_version" >&2
  exit 1
fi

IFS=. read -r major minor patch <<< "$version"
IFS=. read -r base_major base_minor base_patch <<< "$base_version"
if (( major < base_major ||
      (major == base_major && minor < base_minor) ||
      (major == base_major && minor == base_minor && patch <= base_patch) )); then
  echo "Participant Kit changed without version increment: $base_version -> $version" >&2
  exit 1
fi
