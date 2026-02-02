# PARA Summarize – Generate a summary from completed work

Generate a summary document from the current work and update context.

## What to do

1. **Context** – Read `context/context.md` to get the active plan path and (if present) phased_execution.

2. **Changes** – Run `git diff` and `git status` to see what changed since the plan started (or since the phase started for phased plans).

3. **Task name** – Derive the task name from the active plan filename (e.g. `2025-12-22-add-auth.md` → "add-auth").

4. **Summary file** – Create `context/summaries/YYYY-MM-DD-{task-name}-summary.md` (or `-phase-N-summary.md` for a phase). Include:
   - Date and status (e.g. completed)
   - What changed (files, brief description)
   - Why (from the plan)
   - Key learnings and follow-ups
   - Test/verification notes if relevant

5. **Update context** – In `context/context.md`:
   - Move the completed plan from `active_context` to `completed_summaries` (add the new summary path).
   - If phased, set the phase status to "completed".
   - Update `last_updated`.

6. **Confirm** – Show where the summary was written and suggest running `/para-archive` when ready for the next task.
