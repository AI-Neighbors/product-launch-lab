# Participant Kit changelog

`Participant Kit` is one versioned contract: Participant Coach, workbook, prompts,
participant templates and onboarding/submission guards. Each participant's `INPUT.md`
records its version and exact base commit.

Version rule: patch for fixes, minor for new capability, major for an incompatible flow.
Git tags use `participant-kit-vX.Y.Z`.

## 0.8.0 — 2026-08-21

- Adds read-only PR rescue guidance with one stage decision and next action.
- Adds synthetic local Coach contract evals for incomplete submissions, access
  blockers and rehearsal-base mistakes.
- Keeps promptfoo and Phoenix optional until a model runner or traced Coach
  service exists.

## 0.7.1 — 2026-08-21

- Detects missing GitHub push permission before participant work begins.
- Explains that `Triage` cannot push a participant branch and routes `403` to the organizer without blaming the participant.

## 0.7.0 — 2026-08-19

- Replaces conflicting per-document versions with one Participant Kit version.
- Records the Participant Kit version and base commit during initialization.
- Blocks capability changes in pull requests when version or changelog was not updated.

## 0.6.0 — 2026-08-17

- Supports idea, prototype and working-product stages.
- Uses an idea-stage gate before suggesting a minimal validation page.
- Detects setup and current round, then keeps one file and one next action active.
- Separates GitHub identity from public/contact identity.
- Preserves participant-folder scope and requires approval before external actions.
- Validates pilot and rehearsal branches against their correct PR base.
