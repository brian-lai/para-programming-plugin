# PARA Plan – Create a plan for the current task

Create a planning document for the task the user describes (or ask for a task description if none was given).

## What to do

1. **Task** – Use the user’s task description from this chat, or ask for one.

2. **Scope** – Decide if this is a simple plan (one file) or a phased plan (master + sub-plans). Prefer a phased plan when:
   - Many files or layers (e.g. DB → API → frontend)
   - Multiple services or clear phases
   - Work benefits from incremental review/merge

3. **Simple plan**
   - Create `context/plans/YYYY-MM-DD-{task-name}.md` (sanitize task name: lowercase, hyphens).
   - Sections: Objective, Approach, Risks, Data Sources, MCP Tools (if any), Success Criteria.
   - Update `context/context.md`: add the plan path to `active_context`, set `last_updated`.

4. **Phased plan** (if you offered and user agreed)
   - Create master: `context/plans/YYYY-MM-DD-{task-name}.md` with overall objective and phase list.
   - Create one file per phase: `context/plans/YYYY-MM-DD-{task-name}-phase-1.md`, etc., with phase objective, steps, risks, success criteria.
   - Update `context/context.md`: add all plan paths to `active_context` and add a `phased_execution` block (master_plan, phases array with phase number, plan path, status "pending", current_phase null).

5. **Review** – Tell the user where the plan(s) live and ask them to review before running `/para-execute`.

## Notes

- Always use a `YYYY-MM-DD` date prefix for plan filenames.
- If the project has no `context/` yet, run the PARA init steps first (create directories and `context/context.md`).
