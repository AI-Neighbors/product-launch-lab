#!/usr/bin/env bash
set -euo pipefail

# Self-tests create their own branches; ignore the enclosing GitHub PR context.
unset GITHUB_HEAD_REF GITHUB_BASE_REF

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
tmp_dir="$(mktemp -d "${TMPDIR:-/tmp}/product-launch-lab-test.XXXXXX")"
expected_kit_version="$(tr -d '[:space:]' < "$repo_root/VERSION")"

bash -n "$repo_root"/scripts/*.sh "$repo_root"/.githooks/pre-push
[[ -z "${1:-}" ]] || git -C "$repo_root" diff --check "${1}...HEAD"
bash "$repo_root/scripts/check-kit-version.sh" "${1:-}"
test -s "$repo_root/.agents/skills/participant-coach/SKILL.md"
test -s "$repo_root/kit/CHANGELOG.md"
grep -Fq '.agents/skills/participant-coach/SKILL.md' "$repo_root/AGENTS.md"
grep -Fq 'test/<run-id>/<handle>` | `rehearsal/<run-id>' "$repo_root/AGENTS.md"
grep -Fq 'Для test branch никогда не подставляй `origin/main`' "$repo_root/.agents/skills/participant-coach/SKILL.md"
grep -Fq 'git push --dry-run origin' "$repo_root/.agents/skills/participant-coach/SKILL.md"
grep -Fq 'Triage' "$repo_root/.agents/skills/participant-coach/SKILL.md"

cleanup() {
  if [[ -n "${tmp_dir:-}" && -d "$tmp_dir" && "$tmp_dir" == *product-launch-lab-test.* ]]; then
    rm -rf -- "$tmp_dir"
  fi
}
trap cleanup EXIT

mkdir -p "$tmp_dir/scripts" "$tmp_dir/participants" "$tmp_dir/.githooks"
cp "$repo_root/scripts/check-submission.sh" "$repo_root/scripts/init-participant.sh" "$tmp_dir/scripts/"
cp -R "$repo_root/participants/_template" "$tmp_dir/participants/"
cp "$repo_root/.githooks/pre-push" "$tmp_dir/.githooks/"
cp "$repo_root/VERSION" "$tmp_dir/"

cd "$tmp_dir"
git init -q -b main
git config user.name "Event Kit Test"
git config user.email "event-kit@example.invalid"
git add .
git commit -qm "test: baseline"
pilot_base="$(git rev-parse HEAD)"
bash scripts/init-participant.sh alex >/dev/null

grep -Fq -- "- Participant Kit version: $expected_kit_version" participants/alex/INPUT.md
grep -Fq -- "- Kit base commit: $pilot_base" participants/alex/INPUT.md

[[ "$(git config core.hooksPath)" == ".githooks" ]]
if printf 'refs/heads/main local refs/heads/main remote\n' | .githooks/pre-push origin example >/dev/null 2>&1; then
  echo "Expected pre-push hook to block main" >&2
  exit 1
fi
if printf 'refs/heads/rehearsal/test local refs/heads/rehearsal/test remote\n' | .githooks/pre-push origin example >/dev/null 2>&1; then
  echo "Expected pre-push hook to block rehearsal branch" >&2
  exit 1
fi
if ! printf 'refs/heads/rehearsal/test local refs/heads/rehearsal/test remote\n' | \
  EVENT_ADMIN_PUSH=1 .githooks/pre-push origin example >/dev/null 2>&1; then
  echo "Expected admin override to allow rehearsal branch" >&2
  exit 1
fi

fill_submission() {
  local handle="$1"
  local baseline_tag="$2"

  for file in "participants/$handle"/*.md; do
    sed -i.bak 's/REPLACE_ME/verified value/g' "$file"
  done
  find "participants/$handle" -name '*.bak' -delete

  sed -i.bak "s/- GitHub handle: verified value/- GitHub handle: $handle/" "participants/$handle/INPUT.md"
  sed -i.bak 's/- Public\/contact handle (optional): verified value/- Public\/contact handle (optional): @alex_neighbor/' "participants/$handle/INPUT.md"
  sed -i.bak "s/- Participant GitHub handle: verified value/- Participant GitHub handle: $handle/" "participants/$handle/SUBMISSION.md"
  sed -i.bak 's/- Public\/contact handle: verified value/- Public\/contact handle: @alex_neighbor/' "participants/$handle/SUBMISSION.md"
  sed -i.bak 's/- One-liner: verified value/- One-liner: A verified product outcome for a specific user/' "participants/$handle/SUBMISSION.md"
  sed -i.bak 's|- Product page URL: verified value|- Product page URL: https://product.example/|' "participants/$handle/SUBMISSION.md"
  sed -i.bak 's|- Video URL: verified value|- Video URL: https://video.example/demo|' "participants/$handle/SUBMISSION.md"
  sed -i.bak 's/- First send\/publish date: verified value/- First send\/publish date: 2026-08-24/' "participants/$handle/SUBMISSION.md"
  sed -i.bak "s/- Baseline tag: verified value/- Baseline tag: $baseline_tag/" "participants/$handle/SUBMISSION.md"
  find "participants/$handle" -name '*.bak' -delete
}

fill_submission alex pilot-01-start-alex

git add participants/alex
git commit -qm "test: valid participant"

bash scripts/check-submission.sh alex main >/dev/null

echo "unexpected" >> README.md
if bash scripts/check-submission.sh alex main >/dev/null 2>&1; then
  echo "Expected out-of-scope change to fail" >&2
  exit 1
fi
rm -f -- README.md

git switch -q main
git branch rehearsal/2026W34-healthos-01 main
bash scripts/init-participant.sh sam --test 2026W34-healthos-01 >/dev/null
fill_submission sam test-2026W34-healthos-01-start-sam
git add participants/sam
git commit -qm "test: valid rehearsal participant"

bash scripts/check-submission.sh sam rehearsal/2026W34-healthos-01 >/dev/null

if GITHUB_BASE_REF=main bash scripts/check-submission.sh sam rehearsal/2026W34-healthos-01 >/dev/null 2>&1; then
  echo "Expected wrong rehearsal PR base to fail" >&2
  exit 1
fi
if GITHUB_HEAD_REF=test/2026W34-healthos-01/wrong \
  bash scripts/check-submission.sh sam rehearsal/2026W34-healthos-01 >/dev/null 2>&1; then
  echo "Expected branch/handle mismatch to fail" >&2
  exit 1
fi

echo "RESULT: event-kit contract tests passed"
