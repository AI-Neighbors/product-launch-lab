#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
tmp_dir="$(mktemp -d "${TMPDIR:-/tmp}/product-launch-lab-test.XXXXXX")"

test -s "$repo_root/.agents/skills/participant-coach/SKILL.md"
grep -Fq '.agents/skills/participant-coach/SKILL.md' "$repo_root/AGENTS.md"

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

cd "$tmp_dir"
git init -q -b main
git config user.name "Event Kit Test"
git config user.email "event-kit@example.invalid"
git add .
git commit -qm "test: baseline"
bash scripts/init-participant.sh alex >/dev/null

[[ "$(git config core.hooksPath)" == ".githooks" ]]
if printf 'refs/heads/main local refs/heads/main remote\n' | .githooks/pre-push origin example >/dev/null 2>&1; then
  echo "Expected pre-push hook to block main" >&2
  exit 1
fi

for file in participants/alex/*.md; do
  sed -i.bak 's/REPLACE_ME/verified value/g' "$file"
done
find participants/alex -name '*.bak' -delete

sed -i.bak 's/- Participant: verified value/- Participant: alex/' participants/alex/SUBMISSION.md
sed -i.bak 's/- One-liner: verified value/- One-liner: A verified product outcome for a specific user/' participants/alex/SUBMISSION.md
sed -i.bak 's|- Product page URL: verified value|- Product page URL: https://product.example/|' participants/alex/SUBMISSION.md
sed -i.bak 's|- Video URL: verified value|- Video URL: https://video.example/demo|' participants/alex/SUBMISSION.md
sed -i.bak 's/- First send\/publish date: verified value/- First send\/publish date: 2026-08-24/' participants/alex/SUBMISSION.md
sed -i.bak 's/- Baseline tag: verified value/- Baseline tag: pilot-01-start-alex/' participants/alex/SUBMISSION.md
find participants/alex -name '*.bak' -delete

git add participants/alex
git commit -qm "test: valid participant"

bash scripts/check-submission.sh alex main >/dev/null

echo "unexpected" >> README.md
if bash scripts/check-submission.sh alex main >/dev/null 2>&1; then
  echo "Expected out-of-scope change to fail" >&2
  exit 1
fi

echo "RESULT: event-kit contract tests passed"
