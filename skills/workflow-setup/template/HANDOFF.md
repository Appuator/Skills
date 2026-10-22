# {{PROJECT}} — Handoff

The project as it actually is: what a fresh session needs that the code doesn't say plainly.
Update at the end of every phase and after any bug fix. Read alongside `CLAUDE.md` (rules), `ROADMAP.md` (tasks + Run Log), `SPEC.md` (design).

| Section | Kind |
|---|---|
| §1–§3, §5 | Reference: keep current, edit in place |
| §4 Bugs & fixes | Log: append only |
| §6 Current state | Snapshot: **overwrite** at each phase end |

## 1. Architecture map
<!-- One row per area. Name the real classes/modules/files and the one thing about each that isn't obvious from reading it. -->
| Area | Classes / modules | Notes |
|---|---|---|
| {{area}} | `{{Name}}` | {{what it owns, how it's wired, where its config lives}} |

## 2. Build & run
- Commands: see `CLAUDE.md`.
- Config / settings locations: {{...}}
- Controls / entry points / debug commands: {{...}}

## 3. Hard facts
<!-- Measured numbers and constraints other work must respect: limits, timings, sizes, quotas, performance budgets. Say where each came from and how to re-measure it. -->
| Fact | Value | Source / how to re-check |
|---|---|---|
| {{metric}} | {{value}} | {{...}} |

## 4. Bugs & fixes (chronological)
*Format: YYYY-MM-DD: **Symptom** → root cause → fix (commit). End with the rule it teaches, if any; rules that apply every session are proposed for CLAUDE.md Gotchas (or an automated check) at phase end and added once approved at the gate.*

- {{date}}: **{{symptom}}** → {{root cause}} → {{fix}}. Rule: {{...}}

## 5. Verification notes
*Anything learned about how to test this project: tool quirks, timing, what can't be automated.*

- {{note}}

## 6. Current state & next steps
*Overwrite this section at each phase end; don't append. History lives in the ROADMAP Run Log.*

**Where we are (YYYY-MM-DD):** Phase {{N}} {{built / gate pending / done}}. {{K}} tests green. Branch `{{branch}}`.

**Next:** {{next task or gate}}

**To confirm at the gate:** {{interpretations made during the build that you should check}}

**What exists today:** {{3–6 bullets, details in §1}}

**Not built yet:** {{...}}

**Settled; don't reopen without the user:** {{decisions that looked like bugs or open questions but were decided}}

**Watch / known quirks:** {{...}}

**Quick start:** {{how to get to a useful state for testing in a few commands}}
