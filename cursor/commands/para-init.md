# PARA Init – Initialize PARA structure

Set up the complete PARA-Programming environment in this project.

## What to do

1. **Global methodology** – If `~/.claude/CLAUDE.md` does not exist, create `~/.claude` and copy or create the global PARA workflow file there (never overwrite if it exists).

2. **Project directories** – Create:

   ```
   context/data
   context/plans
   context/summaries
   context/archives
   context/servers
   ```

3. **context/context.md** – Create with:
   - A short "Current Work Summary" (e.g. "Ready to start first task.")
   - A JSON block: `active_context: []`, `completed_summaries: []`, `last_updated` (current ISO timestamp).

4. **Project CLAUDE.md** – If the project root has no `CLAUDE.md`, create one that references the global workflow at `~/.claude/CLAUDE.md` and adds project-specific context (or leave placeholders).

5. **Confirm** – List what was created and suggest next steps: run `/para-plan` with a task description, then `/para-status` and `/para-help` as needed.

## After setup

Tell the user the PARA workflow is ready and remind them: **Plan → Review → Execute → Summarize → Archive**. Use PARA for code changes and file modifications; skip it for simple questions and navigation.
