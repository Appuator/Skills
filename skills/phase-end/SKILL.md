---
name: phase-end
description: Close a ROADMAP phase in the document-driven workflow - full test run, HANDOFF.md architecture map and current-state snapshot rewritten, spec status updated, gate instructions written, Run Log entry - then stop for the human gate; also records gate feedback and a passed gate. Use when a phase's last task is done, or the user says "end the phase", "prep the gate", "the gate passed", "gate feedback", or reports playtest/review results.
argument-hint: "[feedback | passed]"
---

# phase-end

Two modes. No argument and the phase's tasks are all `[x]`/`[!]` → **close the phase**. The user reports gate results (`feedback`, `passed`, or describes what they saw) → **record the gate**.

The project's `CLAUDE.md` and `ROADMAP.md` §2 win where they differ from this file. The spec's name comes from `CLAUDE.md`.

## Close the phase
1. **Check it's done.** Every task in the phase is `[x]` or `[!]` with a note. If not, stop and say which remain.
2. **Full test run** using the `CLAUDE.md` commands. Record the count. If something fails, fix it as a normal task (HANDOFF §4 entry if it was a bug) before going on.
3. **HANDOFF.md**
   - §1: add or update a row for every area the phase touched (real names, the non-obvious fact, where tuning lives).
   - §3 / §5: new measured facts and testing lessons.
   - **§6: overwrite it** using the template's shape: where we are (date, phase, gate pending, test count, branch), next, what to confirm at the gate, what exists today, not built yet, settled decisions, quirks, quick start. Don't append; history goes in the Run Log. Keep anything still true from the old §6 (settled decisions, quirks), drop what is now history.
4. **Spec:** update the status table (or the project's equivalent: if it marks status inline, fix every marker for what this phase built). Also update any "Status" header.
5. **CLAUDE.md:** promote HANDOFF §4 rules that apply every session into Gotchas, one line each. Keep the file under ~150 lines; move long material to HANDOFF and point to it.
6. **Gate instructions** under the phase in ROADMAP, after its `🧑 Gate:` line:
   - `**Built YYYY-MM-DD, 🧑 gate pending.** How to try it:` with concrete steps (commands, debug hooks, where to go, what to compare).
   - `**Decisions to confirm at the gate:**` every interpretation made during the build.
7. **Run Log** entry: `### YYYY-MM-DD — Phase N: K tasks | blockers: ...; 🧑 gate pending`.
8. `git status` (revert generated/test-only files), commit as `Phase N built: docs, gate checklist, run log`.
9. **Stop.** Tell the user the gate question, how to try it, what to confirm. Don't start the next phase.

## Record the gate
1. Turn each piece of feedback into a task **appended at the end of the phase** (never inserted or reordered), e.g. `- [ ] Gate feedback (YYYY-MM-DD): <change>`. Decisions the user made go in the decisions log and the spec (plus a linked ADR if the decision is hard to reverse, surprising, and a real trade-off); answers to "confirm at the gate" go into §6 "Settled".
2. Feedback that needs work: say the follow-up tasks are queued; `/next-task phase` builds them, then this skill runs again.
3. **Passed** (the user says so explicitly): Run Log entry `### YYYY-MM-DD — Phase N gate | 🧑 gate passed`, and update HANDOFF §6 "Where we are" (phase done, gate passed, next phase). Commit as `Phase N gate passed`.
4. **Plan the next phase** if it's still a one-line sketch. Read the spec sections it covers, then draft its goal, tasks (following ROADMAP §2.3 "Writing tasks"), "Done when" and 🧑 gate question. Show the tasks as a numbered list (task, `needs` if any, what it makes work) and ask whether the size and order are right; adjust until the user approves, then write them into the ROADMAP and commit as `Plan Phase N+1`.
5. Never mark a gate passed on your own judgment.
