# Project workflow template

A document-driven way to build software with Claude Code (or any AI pair) one verified task at a time. It was taken from the OmniGun project, where it carried a game from an empty project through seven phases.

Claude starts every session with no memory of earlier ones. These files are that memory, split so each read stays cheap.

| File | Answers | Kind |
|---|---|---|
| `CLAUDE.md` | What rules apply every session? | Rules, loaded automatically, kept short |
| `ROADMAP.md` | In what order? What's done? What happened? | Plan + append-only logs |
| `HANDOFF.md` | What is true about the system right now? | Reference + bug log + current-state snapshot |
| `SPEC.md` | What are we building, and why? | Intent + one status table |
| `notes/` | Why did we decide that? | Scratchpads, merged into SPEC |
| `GLOSSARY.md` | What do our words mean? | The project's terms only; created when the first term is settled |
| `docs/adr/` | Why is this hard-to-reverse thing the way it is? | One short record per decision that is hard to reverse, surprising and a real trade-off; linked from the ROADMAP decisions log |

## Install (once per machine)

```powershell
.\install.ps1
```

This links each folder in `skills/` into `~/.claude/skills/` (directory junctions, so edits here apply at once) and adds a short block to `~/.claude/CLAUDE.md` so every session knows the workflow exists. Re-run it after adding a skill; `.\install.ps1 -Uninstall` removes both.

## The skills

| Skill | When | What it does |
|---|---|---|
| `/workflow-setup [description]` | New project, or one without ROADMAP/HANDOFF | Surveys the code, asks a few questions, designs the verification ladder, fills in the templates in `skills/workflow-setup/template/`. On a project that already has the workflow, audits it for drift instead. |
| `/next-task [count \| phase]` | Day to day | One task (or N, or to the gate): build, verify, note, commit, Run Log. Stops at 🧑 gates and on decision tasks. |
| `/phase-end [feedback \| passed]` | Last task of a phase done; after you've tried the gate | Full tests, HANDOFF map + snapshot, spec status, gate instructions, Run Log, then stops. Later turns your gate feedback into tasks, or records the pass. |

Each project's own `CLAUDE.md` and ROADMAP rules win over the skills, so a project can adjust the process (its spec can be a GDD or PRD, for example).

### Vendored from mattpocock/skills

Copied in from [mattpocock/skills](https://github.com/mattpocock/skills) (MIT); source commit and license in [THIRD_PARTY.md](THIRD_PARTY.md).

| Skill | When | What it does |
|---|---|---|
| `/grill-me` | Sharpening a plan with no repo under it | Interviews you a round at a time, with a recommended answer per question, until every decision is settled. Saves nothing. |
| `/grill-with-docs` | Same, inside a project | `grilling` + `domain-modeling`: the same interview, also writing `GLOSSARY.md` and ADRs (`docs/adr/`) as terms and decisions settle. |
| `grilling` | Called by the two above | The interview itself. Model-invoked on "grill" phrasing. |
| `domain-modeling` | Called by `grill-with-docs` | Challenges fuzzy terms, keeps `GLOSSARY.md`, offers an ADR only for hard-to-reverse, surprising trade-offs. |
| `diagnosing-bugs` | A bug that resists a first look | Builds a command that goes red on the bug before theorising, then minimise → hypothesise → instrument → fix + regression test. Model-invoked. |
| `prototype` | A design question that's hard to settle on paper | Throwaway code: a single HTML state-machine demo, or switchable UI variants. Model-invoked. |

## Without the skills

Copy `skills/workflow-setup/template/*` into the project root, search for `{{` and fill in the placeholders, design the verification ladder (below) before writing feature tasks, then start sessions with *"Read CLAUDE.md, ROADMAP.md and HANDOFF.md, then do the next task."*

## The loop

```
design in notes/ ─► decision into SPEC ─► tasks into ROADMAP
                                              │
     ┌────────────────────────────────────────┘
     ▼
take one task ─► build ─► verify (cheapest layer first) ─► commit ─► mark [x] + note
     │                                                                  │
     └──── 2 failures → [!] + note, move on                              ▼
                                                     phase end: 🧑 human gate
                                                     ├─ feedback → new tasks
                                                     ├─ overwrite HANDOFF §6
                                                     └─ update SPEC status table
```

## Designing the verification ladder

This is the one part you redesign for each project. Ask: **what is the cheapest way an agent can prove this works, without me?**

| Layer | Rule | Examples |
|---|---|---|
| 1. Unit tests | Keep the rules that decide outcomes in pure functions so they test without the app running | Validation, pricing, game rules, parsers |
| 2. Agent-callable debug surface | **Permanent** hooks, not throwaway scaffolding; they also help you when testing by hand | Debug CLI, admin/dev endpoints, seed scripts, cheat commands, feature flags |
| 3. UI / end-to-end | Automate what the hooks can't reach | Browser automation, simulator UI tests, screenshots |
| 🧑 Human gate | Only what a machine can't judge | Feel, UX, readability, taste |

| Domain | Layer 2 | Layer 3 |
|---|---|---|
| Web app | API calls / seed scripts against a dev server | Browser automation |
| CLI / library | Golden-file runs | Runs against real inputs |
| Data pipeline | A small fixture dataset end to end | A sample of real data |
| Mobile | Debug menu, deep links | Simulator UI tests |
| Game | Console cheat commands | Editor/UI automation, captures |

Each gate gets **one question** only a human can answer ("does the checkout feel trustworthy?", "is the state change readable at a glance?").

## Rules that keep the docs honest

- **Logs grow, snapshots get overwritten.** The Run Log, the decisions log and HANDOFF §4 are append-only; HANDOFF §6 and the SPEC status table are rewritten each phase. A snapshot that gets appended to turns into a second, messier log.
- **Build status lives in one table** (SPEC "Status"), not as inline "(planned)" tags that each go stale on their own.
- **Tasks are never deleted or reordered**, so the roadmap is also the audit trail.
- **Bugs are recorded as symptom → root cause → fix.** A lesson that applies every session becomes one line in CLAUDE.md Gotchas.
- **CLAUDE.md stays under ~150 lines**, because it costs context every session. Everything else is read on demand.
- **Two attempts, then move on.** This stops an agent from looping on a blocked task.

## Phase-end checklist

- [ ] All tasks `[x]` or `[!]` with a note
- [ ] Tests green; count recorded
- [ ] HANDOFF §1 updated for new areas; §6 overwritten
- [ ] SPEC status table updated
- [ ] Run Log entry
- [ ] 🧑 Gate instructions written in the ROADMAP (how to try it, what to confirm)
