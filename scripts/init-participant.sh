#!/usr/bin/env bash
set -euo pipefail

usage() {
  echo "Usage: bash scripts/init-participant.sh <github-handle> [--test <run-id>]" >&2
}

if [[ $# -ne 1 && $# -ne 3 ]]; then
  usage
  exit 2
fi

handle="$1"
if [[ ! "$handle" =~ ^[A-Za-z0-9_.-]+$ ]]; then
  echo "Invalid GitHub handle: $handle" >&2
  exit 1
fi

mode="pilot"
run_id="pilot-01"
if [[ $# -eq 3 ]]; then
  if [[ "$2" != "--test" ]]; then
    usage
    exit 2
  fi
  mode="test"
  run_id="$3"
  if [[ ! "$run_id" =~ ^[A-Za-z0-9][A-Za-z0-9._-]*$ ]]; then
    echo "Invalid run ID: $run_id" >&2
    exit 1
  fi
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

if [[ "$mode" == "test" ]]; then
  branch="test/$run_id/$handle"
  base_branch="rehearsal/$run_id"
  baseline_tag="test-$run_id-start-$handle"
else
  branch="pilot-01/$handle"
  base_branch="main"
  baseline_tag="pilot-01-start-$handle"
fi
folder="participants/$handle"

if [[ -e "$folder" ]]; then
  echo "$folder already exists" >&2
  exit 1
fi

if git show-ref --verify --quiet "refs/heads/$branch"; then
  echo "Local branch already exists: $branch" >&2
  exit 1
fi

if git remote get-url origin >/dev/null 2>&1; then
  if ! git fetch origin "$base_branch"; then
    echo "Base branch is not available on origin: $base_branch" >&2
    exit 1
  fi
  git switch --detach "origin/$base_branch"
else
  if ! git show-ref --verify --quiet "refs/heads/$base_branch"; then
    echo "Base branch not found: $base_branch" >&2
    exit 1
  fi
  git switch "$base_branch"
fi
git switch -c "$branch"
cp -R participants/_template "$folder"
git config core.hooksPath .githooks

echo "READY: $branch"
echo "BASE: $base_branch"
echo "BASELINE: $baseline_tag"
echo "NEXT: fill $folder/INPUT.md"
echo "GUARD: repo-local hook blocks direct pushes to main and rehearsal branches"
echo "AGENT: say 'Я $handle. Продукт <название>. Начни Product Launch Lab.'"
echo "CHECK: bash scripts/check-submission.sh $handle origin/$base_branch"
