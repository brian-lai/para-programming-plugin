# PARA Execute – Start execution with branch and to-dos

Execute the active plan: create a branch and turn the plan into a trackable to-do list in `context/context.md`.

## What to do

1. **Read context** – Open `context/context.md` and find the active plan(s). If there is a `phased_execution` block, treat this as a phased plan.

2. **Phased plan** – If phased, ask which phase to execute (or use the user’s choice). Create branch `para/{task-name}-phase-N`. Set that phase’s status to "in_progress" in context.

3. **Simple plan** – Create branch `para/{task-name}` (from the plan filename).

4. **Branch** – Create the git branch (e.g. `git checkout -b para/{task-name}`). If user said no branch or continue on current branch, skip branch creation.

5. **To-dos** – From the plan file(s), extract implementation steps into a clear to-do list. Update `context/context.md` with:
   - Human-readable “Current Work Summary” describing the task.
   - A to-do list (e.g. `- [ ] Step 1`, `- [ ] Step 2`).
   - Ensure the JSON block has the active plan in `active_context` and updated `last_updated`.

6. **First commit** – Commit the updated `context/context.md` with a message like "chore: Initialize execution context".

7. **Remind** – Tell the user to work through the to-dos, mark items `[x]` as done, and **commit after each completed to-do** with the to-do text as the commit message. When done, run `/para-summarize`.
