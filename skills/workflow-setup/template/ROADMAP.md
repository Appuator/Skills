# {{PROJECT}} — Roadmap

> **Companion docs:** `SPEC.md` (*what* we build) · this file (*order* and *how*) · `HANDOFF.md` (*what is true now*) · `CLAUDE.md` (*rules* every session) · `notes/` (reasoning behind decisions; merged into SPEC once decided, SPEC wins on conflicts) · `GLOSSARY.md` (the project's words) · `docs/adr/` (hard-to-reverse decisions).

## 1. Plan at a glance
<!-- A small diagram or list of phases in order. -->
```
Phase 0 Foundation ─► Phase 1 {{CORE}} ─► Phase 2 {{...}} ─► ...
```

**Why this order**
<!-- One bullet per non-obvious ordering choice: "X comes before Y because Y depends on X / X is the riskiest idea and should be proven while change is cheap." -->
- {{REASON}}

---

## 2. How we work

### 2.1 The document set
| File | Purpose | Kind | Updated |
|---|---|---|---|
| `CLAUDE.md` | Short, stable rules, commands, verification recipe, gotchas. Loaded every session. | Rules | Rarely, deliberately |
| `ROADMAP.md` | Phases, tasks, checkboxes, Run Log, decisions log | Plan + log | Every task |
| `HANDOFF.md` | Architecture map, bugs with root causes, hard-won facts, current state | Reference + snapshot (§6) | Phase end, after every bug |
| `SPEC.md` | What the project is, plus a status table of what is built | Intent | When the design changes; status at phase end |
| `notes/*.md` | Reasoning, options turned down, worked numbers | Scratchpad | During design |
| `GLOSSARY.md` | The project's own terms, one or two sentences each; no implementation details | Reference | When a term is settled |
| `docs/adr/*.md` | One short record per decision that is hard to reverse, surprising, and a real trade-off | Reference | When such a decision is made |

**Logs grow, snapshots get overwritten.** The Run Log and HANDOFF §4 are append-only. HANDOFF §6 and the SPEC status table are overwritten, never appended to.

### 2.2 Task rules
1. Work phases **top to bottom**; take **one** unchecked task, finish it, verify it, mark it `[x]`.
2. **One task = one commit**, with the task text as the message.
3. Blocked or failed twice → mark `[!]`, add a one-line note under it, move on. **No more than 2 attempts.**
4. Never delete or reorder tasks. Only change their status and append notes (`- Note (YYYY-MM-DD): ...`).
5. End each session with a **Run Log** entry (date, tasks done, blockers).
6. Every phase ends with a **🧑 human gate**. Don't start the next phase until it passes. Gate feedback becomes new tasks at the end of the phase.

Task markers: `[ ]` todo · `[x]` done · `[!]` blocked (note says why) · 🧑 human gate.

### 2.3 The per-task loop
```
Read CLAUDE.md + next ROADMAP task
        │
        ▼
Change code ──► build ──► unit tests ──► higher verification layers as needed
        │
        ▼
git status (catch generated junk) ──► commit ──► mark [x] + note ──► next task
```

### 2.4 Verification strategy (cheapest first)
| Layer | Tests | How |
|---|---|---|
| 1. Unit tests | Pure rules | {{TEST_CMD}} |
| 2. {{LAYER_2_NAME}} | Systems together | {{LAYER_2_HOW}} |
| 3. {{LAYER_3_NAME}} | UI and flows | {{LAYER_3_HOW}} |
| 🧑 Human gate | {{FEEL_UX_TASTE}} | You check it |

### 2.5 Keeping Claude's context clean
- Exclude generated folders from searches (listed in CLAUDE.md).
- Run long builds in a subagent that returns only success or the first error.
- One agent drives a shared resource (dev server, editor, device) at a time.

---

## 3. Phases

### Phase 0 — Foundation & workflow
**Goal:** an empty project that builds, runs, tests and commits, with the workflow in place.
- [ ] Create the project ({{STACK}}) and commit the empty skeleton.
- [ ] Fill in `CLAUDE.md`: build, test and run commands verified by actually running them.
- [ ] One trivial unit test that runs headless; record where results land.
- [ ] Layer 2 hook: the smallest agent-callable debug command (e.g. `ping`) that proves the app can be driven.
- [ ] `.gitignore` for generated folders; note them in CLAUDE.md search hygiene.
- [ ] Fill in `SPEC.md` overview and status table; `HANDOFF.md` §1 and §2.

**Done when:** a fresh session can build, test and drive the app using only CLAUDE.md.
**🧑 Gate:** you run the app yourself once and the commands in CLAUDE.md work for you.

### Phase 1 — {{CORE_IDEA}}
**Goal:** {{the riskiest or most distinctive part, proven first while change is cheap}}
**Spec:** SPEC.md §{{N}}
- [ ] {{task}}

**Done when:** {{objective check}}
**🧑 Gate:** {{the one question only a human can answer}}

---

## 4. Parked ideas (no tasks yet)
- {{idea}} — why it's parked

---

## 5. Run Log
<!-- Append-only. Newest at the bottom. -->
### YYYY-MM-DD — Phase N: K tasks | blockers: none; 🧑 gate pending
- What was done, test count, anything surprising. Next: ...

---

## 6. Decisions log
<!-- Append-only. Decisions that change the plan or the spec. A decision that is hard to reverse, surprising without context, and a real trade-off also gets an ADR (format: the domain-modeling skill's ADR-FORMAT.md); link it here rather than repeating it. -->
### YYYY-MM-DD — {{decision}}
- Options considered, what was chosen, why. SPEC section updated: §{{N}}. ADR: [`docs/adr/{{NNNN-slug}}.md`](docs/adr/{{NNNN-slug}}.md) (only if it qualifies).
