---
name: next-task
description: Do the next task from the project's ROADMAP.md, following the document-driven workflow - one task, verified with the cheapest test layer that proves it, one commit, checked off with a note, Run Log updated; stops at human playtest/review gates. Use when the user says "next task", "do the next task", "continue the roadmap", "keep going", "do N tasks", or "finish this phase", in a project that has ROADMAP.md and HANDOFF.md.
argument-hint: "[count | 'phase']"
---

# next-task

Run the per-task loop. Argument: nothing = one task; a number = that many tasks; `phase` = continue until the phase's 🧑 gate. Never go past a gate.

The project's own `CLAUDE.md` and `ROADMAP.md` §2 (task rules) win over this file wherever they differ. Doc names vary (the spec may be `SPEC.md`, a GDD, a PRD): `CLAUDE.md` says which files to read.

If the project has no `ROADMAP.md`/`HANDOFF.md`, stop and suggest `/workflow-setup`.

## 1. Orient
1. Read `CLAUDE.md`, then `ROADMAP.md` §2 (rules) and the current phase, then `HANDOFF.md` §6 (current state). Read the rest of HANDOFF only when the task touches an area (§1 map, §4 bugs in that area).
2. **Find the task:** the first `[ ]` in roadmap order. Skip `[!]` tasks (blocked), parked ideas, and tasks whose `(needs: ...)` task is `[!]`. If the current phase is still a one-line sketch with no tasks, stop: `/phase-end passed` plans it.
3. **Gate check:** if every task in the current phase is `[x]`/`[!]` and the Run Log doesn't say its 🧑 gate passed, **stop**: the phase is waiting for the human. If `/phase-end` hasn't run for it (no gate instructions under the phase), run that instead. Otherwise remind the user what to check at the gate.
4. **Decision tasks** ("Decide ...", open questions): don't decide for the user. Lay out the options with a recommendation, ask (`AskUserQuestion`), then record the answer where the task says (decisions log, spec) and continue.
5. Read every spec section, notes file and HANDOFF row the task names. Read later notes under the task (`- Note (date): ...`): they override the older task text.
6. Branch: follow the project's convention. If on the default branch and none is stated, create `phase-<n>-<slug>` before the first commit.

## 2. Build
- **Red first:** if the task adds or changes behavior a test can reach, write that test and watch it fail (§3 "Red before green") before writing the code.
- Follow the project's conventions in `CLAUDE.md` (naming, where logic vs config lives, required files).
- Put rules that decide outcomes in pure functions with unit tests.
- Keep tuning values in config/data, not code.
- Long or noisy builds: use the project's build subagent if `CLAUDE.md` names one, so build logs stay out of context.

## 3. Verify (cheapest layer first)
Use the ladder in `CLAUDE.md` "Verification recipe": unit tests, then the debug surface, then UI/end-to-end. Stop at the cheapest layer that actually proves the task's claim; a task that changes behavior the user sees needs a run of the real thing, not only unit tests. Record measured results (numbers, log lines, test counts) for the note.

**Seams.** Tests go through a public interface (a seam), never into internals, so they survive any refactor that keeps the behavior. Use the seam the task, the spec or `CLAUDE.md` "Test seams" names. If none is named, use the highest existing seam that reaches the behavior; add a new one only when nothing reaches it, and as high as possible. A seam you picked or added yourself is an interpretation: list it in the task note for the gate rather than stopping to ask. The `codebase-design` skill has the vocabulary if the seam's placement is itself the question.

**Red before green.** For new behavior or a bug fix, write the test first and run it. It must fail on the missing behavior (an assertion about the symptom), not on a compile error or a typo. Then write only enough code to pass it, one behavior per test-then-code cycle, never a batch of tests up front. Skip it when there is no new behavior to assert (refactors keep the existing tests green; config, docs). If you can't make a bug go red, the test is at the wrong seam or the bug is hard: use the `diagnosing-bugs` skill. Say in the note that you saw red.

**No tautological tests.** Each expected value comes from a source independent of the code: a literal worked out by hand, a number from the spec, a known-good output. A test that recomputes the answer the way the code does (`expect(add(a, b)).toBe(a + b)`), or a snapshot taken from the current code and accepted without checking it, passes by construction and proves nothing.

Things only a human can check (feel, UX, taste) are not failures: note them for the gate.

**Two attempts.** If the task fails or is blocked twice, mark it `[!]`, add `- Note (YYYY-MM-DD): <one line: why, what's needed>`, and move to the next task (or stop if it blocks everything after it). Don't loop.

## 4. Record and commit
1. Mark the task `[x]` and add `- Note (YYYY-MM-DD): ...` under it: what was built (real names), how it was verified, any interpretation the user should confirm at the gate. Never delete or reorder tasks, never rewrite another task's text.
2. **Bug found and fixed?** Append to HANDOFF §4: date, **symptom** → root cause → fix, and the rule it teaches. Don't edit `CLAUDE.md` or other process files yourself: `/phase-end` proposes rules that apply every session, and the human approves them at the gate.
3. New area or class that the HANDOFF §1 map doesn't cover? Add a row.
4. Design changed while building (the user decided something)? Update the spec and the ROADMAP decisions log. If the decision is hard to reverse, surprising, and a real trade-off, also write an ADR in `docs/adr/` and link it from the log entry. A new or sharpened term goes in `GLOSSARY.md`.
5. `git status`: revert generated, autosaved or test-only files. Then commit: **one task = one commit**, message = the task text (shorten a very long task to its first sentence).

## 5. Next or stop
- More tasks requested and no gate reached: go back to step 1.2.
- Done: append (or extend today's) Run Log entry: `### YYYY-MM-DD — Phase N: K tasks | blockers: ...; 🧑 gate pending`, with a line on what was done, the test count, and `Next: ...`. Commit it with the last task, or on its own as `Run log`.
- If the phase's last task just finished, run `/phase-end`.
- Report briefly: tasks done, verification evidence, anything `[!]`, what's next.
