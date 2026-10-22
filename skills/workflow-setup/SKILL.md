---
name: workflow-setup
description: Set up the document-driven project workflow (CLAUDE.md rules, ROADMAP.md tasks and logs, HANDOFF.md current state, SPEC.md design, notes/ scratchpads) in a new or existing project, or audit a project that already has it. Use when the user starts a new project, says "set up the workflow", "bootstrap this project", "add a roadmap and handoff", or opens a project that has no ROADMAP.md/HANDOFF.md and wants to work task by task.
argument-hint: "[short description of the project]"
---

# workflow-setup

Install the workflow into the current project. The templates are in `template/` next to this file: `CLAUDE.md`, `ROADMAP.md`, `HANDOFF.md`, `SPEC.md`, `GLOSSARY.md`, `notes/README.md`. They contain `{{PLACEHOLDERS}}` and `<!-- guidance -->` comments. Read all six before you start; they define the target shape.

The outcome: a fresh Claude session can open this project, read `CLAUDE.md`, and build, test, drive the app and do the next task without asking anything.

## 1. Find out what's there

Check the project root and git state:
- **Already set up** (`ROADMAP.md` and `HANDOFF.md` exist, or `CLAUDE.md` says to read a roadmap/handoff): don't overwrite anything. Run the **audit** (section 6) instead.
- **Existing code, no workflow**: survey it first: languages, build files (`package.json`, `Cargo.toml`, `*.csproj`, `pyproject.toml`, `Makefile`, `*.uproject`, ...), test setup, generated folders, README. This feeds the commands, the architecture map and the ladder.
- **Empty or nearly empty**: the user's description is the only input; Phase 0 will create the project.
- An existing `CLAUDE.md` is merged into, never replaced: keep its content, add the missing sections.

## 2. Ask only what the files can't tell you

Use one `AskUserQuestion` round (up to 4 questions), skipping anything already answered by the user's message or the code:
1. What is being built and for whom, in one or two sentences (becomes the SPEC one-liner and overview).
2. How they want help (their background; whether to mentor, explain conventions, or just execute). This fills `CLAUDE.md` "How to help".
3. What only a human can judge here (feel, UX, visual quality, domain correctness). This becomes the 🧑 gate wording.
4. Locked-in decisions: stack, versions, hosting, anything not to revisit.

Recommend an answer for each when the code or description suggests one.

## 3. Design the verification ladder

This is the most important part, and it differs per project. For each layer, decide something Claude can **run on its own**:
1. **Unit tests**: the exact command and where results land. Which rules must be pure functions so they can be tested without the app running? Which public interfaces are the **test seams** (fewer and higher is better)? They go in `CLAUDE.md` "Test seams"; `/next-task` tests only through them.
2. **A permanent agent-callable debug surface**: debug CLI, dev-only API endpoints, seed/fixture scripts, console/cheat commands, feature flags. It must be permanent (it also helps the human test by hand), not throwaway scaffolding. If none exists, Phase 0 builds the smallest one (a `ping`).
3. **UI / end-to-end**: browser automation, simulator tests, screenshots, editor automation.
4. **🧑 Human gate**: only what the machine can't judge.

Note what can't be automated (e.g. OS input injection) so gates cover it. Examples by domain: web: API calls + browser automation; CLI: golden files; data: fixture dataset; mobile: debug menu + simulator; games: cheat commands + editor automation.

## 4. Write the files

Copy each template into the project root (skip a file that already exists; merge instead), then fill it in:
- **CLAUDE.md**: real commands (prefer ones you found in the repo), conventions observed in the code, the ladder, generated folders to exclude. Keep it **under ~150 lines**; remove the guidance comments.
- **SPEC.md**: overview, pillars, non-goals, one section per feature area that's known (each with its out-of-scope and testing lines), open questions. The **Status** table is the only place build status goes. Terms are defined in `GLOSSARY.md`, not here.
- **GLOSSARY.md**: only if the project already has its own terms (from the user's description or the code); follow the domain-modeling skill's `GLOSSARY-FORMAT.md`. Otherwise skip it: `/grill-with-docs` creates it when the first term is settled. Don't create `docs/adr/` up front either; the first ADR creates it.
- **ROADMAP.md**: keep §2 (process) as is. Tailor Phase 0 to this project (drop tasks already done in an existing codebase, mark them `[x]` with a note). Write Phase 1 around the **riskiest or most distinctive** idea, proven first while change is cheap; its tasks follow §2.3 "Writing tasks" (vertical slices, prefactor first, `(needs: ...)` only where order isn't enough). Show the Phase 1 task list to the user and adjust until they approve it. Sketch later phases as one line each; detail comes when they're next. Explain the order under "Why this order". Each phase has a goal, tasks, "Done when" and a **🧑 Gate** with one question only a human can answer.
- **HANDOFF.md**: for existing code, fill §1 (architecture map) from your survey: real names, one non-obvious fact each. Fill §6 with the starting state.
- **notes/README.md**: copy as is. If the user's design thinking is long or undecided, put it in `notes/<topic>-ideas.md` and only decisions in SPEC.

Placeholders you can't fill: leave them as `{{TODO: what's needed}}` and list them in your report. Never invent commands: run each build/test command once if it's cheap and safe; otherwise mark it unverified.

## 5. Finish

- Add generated folders to `.gitignore` if missing.
- Append the first Run Log entry: `### YYYY-MM-DD — Workflow set up | blockers: ...`.
- Show the user a short summary: the ladder, Phase 0–1 tasks, open `{{TODO}}`s. Ask before committing; if they agree, commit as `Set up project workflow` (if on the default branch with history, branch first).
- Tell them the next step: `/next-task`.

## 6. Audit (project already has the workflow)

Read `CLAUDE.md`, `ROADMAP.md`, `HANDOFF.md` and the spec (it may have another name, such as a GDD; `CLAUDE.md` says which). Report, don't fix, unless asked:
- `CLAUDE.md` over ~150 lines, or missing build/test/verify commands.
- HANDOFF §6 (current state) that has been appended to instead of overwritten: a chronological list of phases is the sign.
- Spec build status that disagrees with the ROADMAP (`[x]` tasks still marked planned, or inline "(planned)" tags that are stale).
- Tasks deleted or reordered (check `git log -p ROADMAP.md` if suspicious), `[!]` tasks without a note, a missing Run Log entry for recent commits.
- Gotchas repeated in HANDOFF §4 that should be a CLAUDE.md rule.
- Older layout: a Glossary section in the spec instead of `GLOSSARY.md`, or a `CLAUDE.md` without the decisions/ADR task rule or the "Test seams" and red-first lines in its verification recipe. Offer to move the glossary out and add the missing lines from the template.
- An ADR in `docs/adr/` with no decisions-log entry linking it.
Offer to fix what you found.
