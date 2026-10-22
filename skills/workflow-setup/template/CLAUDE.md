# {{PROJECT}} — Claude rules

<!-- Loaded every session: keep this file under ~150 lines. Put anything long in HANDOFF.md and point to it. Delete these HTML comments once filled in. -->

Read at session start: `ROADMAP.md` (next task + rules), `HANDOFF.md` (architecture, bugs, gotchas). Design: `SPEC.md` (what the project is; its status table says what is built). Read a `notes/*.md` file only when a task points to it; `SPEC.md` wins on conflicts. Use the terms in `GLOSSARY.md`; before changing an area, check `docs/adr/` for decisions that cover it.

## How to help
<!-- Who you are and how you want to be helped. Example: "Mentor a backend developer new to mobile: explain the why behind platform conventions, define terms, call out gotchas." -->
{{HOW_TO_HELP}}

## Locked-in decisions
<!-- Choices not to revisit without a deliberate decision: stack, versions, architecture style, hosting. One line each. -->
- {{DECISION}}

## Task rules
1. Top to bottom in ROADMAP; one task at a time; verify; mark `[x]`.
2. One task = one commit (message = task text).
3. Blocked or failed twice → `[!]` + one-line note, move on. Max 2 attempts.
4. Never delete/reorder tasks. Append a Run Log entry per session.
5. Stop at every 🧑 human gate.
6. At phase end: overwrite `HANDOFF.md` §6 (current state), update the `SPEC.md` status table. After any bug fix: add it to `HANDOFF.md` §4 (symptom → root cause → fix).
7. A lesson that applies every session becomes a line under Gotchas below.
8. Every decision gets a ROADMAP decisions-log entry. One that is hard to reverse, surprising without context, and a real trade-off also gets an ADR in `docs/adr/`, linked from that entry.

## Conventions
<!-- Naming, folder layout, where logic vs config lives. Example: "Business rules in pure functions with unit tests in tests/unit/." -->
- {{CONVENTION}}
- Tuning values / configuration live in config files, not hard-coded.
- Rules that decide outcomes go in pure functions with unit tests.

## Build & test
<!-- Exact commands, copy-pasteable. Note preconditions (e.g. "server must be stopped"). -->
- Build: `{{BUILD_CMD}}`
- Unit tests: `{{TEST_CMD}}` — where results land: {{TEST_OUTPUT}}
- Run locally: `{{RUN_CMD}}`
- Long or noisy builds run in a subagent that reports only success or the first real error.

## Verification recipe (cheapest first)
<!-- See README "Designing the verification ladder". Every layer must be something Claude can run on its own. -->
1. Unit tests (pure logic, no app running).
2. {{LAYER_2}} <!-- a permanent, agent-callable debug surface: debug CLI, admin endpoints, seed scripts, cheat commands -->
3. {{LAYER_3}} <!-- UI automation, end-to-end against a dev instance -->
- Test seams: {{SEAMS}} <!-- the few public interfaces tests go through, e.g. "pricing: quote(cart)", "API: HTTP routes via the test client". Tests never reach past these. -->
- Tests: write the failing test first and see it fail on the missing behavior; expected values come from the spec or a hand-worked example, never recomputed the way the code does.
- Human gate: {{WHAT_ONLY_A_HUMAN_CAN_CHECK}}
- Before every commit: `git status` — revert anything generated or test-only.

## Gotchas
<!-- Grows over time from HANDOFF §4. One line each, phrased as a rule. -->
- {{GOTCHA}}

## Search hygiene
- Exclude {{GENERATED_DIRS}} from searches.
- Glob before Grep.
