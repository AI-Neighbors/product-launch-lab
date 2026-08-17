#!/usr/bin/env bash
set -euo pipefail

usage() {
  echo "Usage: bash scripts/check-submission.sh <github-handle> [base-ref]" >&2
}

failures=0

fail() {
  echo "FAIL: $*" >&2
  failures=$((failures + 1))
}

pass() {
  echo "OK: $*"
}

if [[ $# -lt 1 || $# -gt 2 ]]; then
  usage
  exit 2
fi

handle="$1"

if [[ ! "$handle" =~ ^[A-Za-z0-9_.-]+$ ]]; then
  fail "invalid GitHub handle: $handle"
fi

repo_root="$(git rev-parse --show-toplevel 2>/dev/null || true)"
if [[ -z "$repo_root" ]]; then
  echo "FAIL: run this command inside the repository" >&2
  exit 1
fi
cd "$repo_root"

folder="participants/$handle"
submission="$folder/SUBMISSION.md"
required=(
  "$folder/INPUT.md"
  "$folder/01-POSITIONING.md"
  "$folder/02-DEMO.md"
  "$folder/03-DISTRIBUTION.md"
  "$submission"
)

branch="${GITHUB_HEAD_REF:-$(git branch --show-current)}"
expected_base_branch=""
expected_baseline_tag=""

case "$branch" in
  "pilot-01/$handle")
    expected_base_branch="main"
    expected_baseline_tag="pilot-01-start-$handle"
    ;;
  test/*/"$handle")
    run_id="${branch#test/}"
    run_id="${run_id%/"$handle"}"
    if [[ ! "$run_id" =~ ^[A-Za-z0-9][A-Za-z0-9._-]*$ ]]; then
      fail "invalid rehearsal run ID in branch: $branch"
    else
      expected_base_branch="rehearsal/$run_id"
      expected_baseline_tag="test-$run_id-start-$handle"
    fi
    ;;
  *)
    fail "expected pilot-01/$handle or test/<run-id>/$handle, found $branch"
    ;;
esac

if [[ -n "$expected_base_branch" ]]; then
  pass "branch matches participant"
fi

if [[ $# -eq 2 ]]; then
  base_ref="$2"
elif [[ -n "${BASE_REF:-}" ]]; then
  base_ref="$BASE_REF"
elif [[ -n "$expected_base_branch" ]]; then
  base_ref="origin/$expected_base_branch"
else
  base_ref="origin/main"
fi
if [[ -n "${GITHUB_BASE_REF:-}" && "$GITHUB_BASE_REF" != "$expected_base_branch" ]]; then
  fail "expected PR base $expected_base_branch, found $GITHUB_BASE_REF"
fi

for file in "${required[@]}"; do
  if [[ ! -s "$file" ]]; then
    fail "missing or empty $file"
    continue
  fi
  if grep -Fq "REPLACE_ME" "$file"; then
    fail "placeholder remains in $file"
  fi
done

field() {
  local label="$1"
  local line
  line="$(grep -F -m1 -- "- $label:" "$submission" 2>/dev/null || true)"
  printf '%s' "${line#*:}" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//'
}

if [[ -s "$submission" ]]; then
  participant="$(field "Participant GitHub handle")"
  product="$(field "Product")"
  one_liner="$(field "One-liner")"
  page_url="$(field "Product page URL")"
  video_url="$(field "Video URL")"
  proof="$(field "Proof")"
  limitation="$(field "Limitation")"
  cta="$(field "CTA")"
  metric="$(field "7-day metric")"
  first_send="$(field "First send/publish date")"
  baseline_tag="$(field "Baseline tag")"

  [[ "$participant" == "$handle" ]] || fail "Participant GitHub handle must equal $handle"
  [[ -n "$product" ]] || fail "Product is empty"
  [[ ${#one_liner} -ge 20 ]] || fail "One-liner is too short"
  if [[ ! "$page_url" =~ ^https:// ]] && [[ "$page_url" != "Product Card in 01-POSITIONING.md" ]]; then
    fail "Product page URL must be HTTPS or 'Product Card in 01-POSITIONING.md'"
  fi
  [[ "$video_url" =~ ^https:// ]] || fail "Video URL must use HTTPS"
  [[ "$video_url" != *"example.com"* ]] || fail "Video URL still points to example.com"
  [[ ${#proof} -ge 5 ]] || fail "Proof is empty or too short"
  [[ ${#limitation} -ge 5 ]] || fail "Limitation is empty or too short"
  [[ ${#cta} -ge 5 ]] || fail "CTA is empty or too short"
  [[ ${#metric} -ge 10 ]] || fail "7-day metric is empty or too short"
  [[ "$first_send" =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}$ ]] || fail "First send/publish date must be YYYY-MM-DD"
  [[ -n "$expected_baseline_tag" && "$baseline_tag" == "$expected_baseline_tag" ]] || \
    fail "Baseline tag must be $expected_baseline_tag"

  if [[ "${CHECK_VIDEO_URL:-0}" == "1" && "$video_url" =~ ^https:// ]]; then
    if curl -L --fail --silent --show-error --max-time 15 --head "$video_url" >/dev/null 2>&1 || \
       curl -L --fail --silent --show-error --max-time 15 --range 0-0 "$video_url" >/dev/null 2>&1; then
      pass "video URL responds"
    else
      fail "video URL did not respond; check sharing permissions"
    fi
  fi
fi

recipient_count="$(grep -Ec '^[[:space:]]*[0-9]+\.[[:space:]]+' "$folder/03-DISTRIBUTION.md" 2>/dev/null || true)"
if [[ "$recipient_count" -lt 10 ]]; then
  fail "03-DISTRIBUTION.md must list 10 recipients or places"
fi

changed_paths=""
if git rev-parse --verify "$base_ref^{commit}" >/dev/null 2>&1; then
  merge_base="$(git merge-base "$base_ref" HEAD)"
  changed_paths="$({
    git diff --name-only "$merge_base"...HEAD
    git diff --name-only
    git diff --cached --name-only
    git ls-files --others --exclude-standard
  } | sed '/^$/d' | sort -u)"
else
  fail "base ref not found: $base_ref"
fi

while IFS= read -r path; do
  [[ -z "$path" ]] && continue

  case "$path" in
    "$folder"/*) ;;
    *) fail "change outside $folder: $path" ;;
  esac

  lower_path="$(printf '%s' "$path" | tr '[:upper:]' '[:lower:]')"
  case "$lower_path" in
    *.mp4|*.mov|*.mkv|*.avi|*.webm)
      fail "video file must not be committed: $path"
      ;;
  esac

  if [[ -f "$path" ]]; then
    bytes="$(wc -c < "$path" | tr -d '[:space:]')"
    if [[ "$bytes" -gt 10485760 ]]; then
      fail "file exceeds 10 MiB: $path"
    fi
  fi
done <<< "$changed_paths"

if [[ "$failures" -gt 0 ]]; then
  echo "RESULT: $failures check(s) failed" >&2
  exit 1
fi

echo "RESULT: submission is ready for human review"
