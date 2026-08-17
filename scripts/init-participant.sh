#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 1 ]]; then
  echo "Usage: bash scripts/init-participant.sh <github-handle>" >&2
  exit 2
fi

handle="$1"
if [[ ! "$handle" =~ ^[A-Za-z0-9_.-]+$ ]]; then
  echo "Invalid GitHub handle: $handle" >&2
  exit 1
fi

repo_root="$(git rev-parse --show-toplevel 2>/dev/null || true)"
if [[ -z "$repo_root" ]]; then
  echo "Run this command inside the repository" >&2
  exit 1
fi
cd "$repo_root"

if [[ -n "$(git status --porcelain)" ]]; then
  echo "Working tree is not clean. Commit or stash your changes first." >&2
  exit 1
fi

branch="pilot-01/$handle"
folder="participants/$handle"

if [[ -e "$folder" ]]; then
  echo "$folder already exists" >&2
  exit 1
fi

if git show-ref --verify --quiet "refs/heads/$branch"; then
  echo "Local branch already exists: $branch" >&2
  exit 1
fi

git switch main
if git remote get-url origin >/dev/null 2>&1; then
  git pull --ff-only origin main
fi
git switch -c "$branch"
cp -R participants/_template "$folder"
git config core.hooksPath .githooks

echo "READY: $branch"
echo "NEXT: fill $folder/INPUT.md"
echo "GUARD: repo-local hook blocks direct pushes to main"
echo "CHECK: bash scripts/check-submission.sh $handle origin/main"
