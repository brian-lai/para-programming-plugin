# Command: execute

Execute the active plan by creating a branch and tracking todos. Supports both simple and phased plans.

## Usage

```
/para:execute                    # Auto-detect plan; prompts for phase if phased
/para:execute --phase=N          # Execute specific phase
/para:execute --branch=name      # Custom branch name (simple plans only)
/para:execute --no-branch        # Skip branch creation
```

## What It Does

1. Read the active plan from `context/context.md`
2. Detect simple vs phased plan (presence of `phased_execution` in JSON)
3. For phased plans, determine which phase to execute (prompt if not specified; verify previous phases are completed)
4. Create a git branch: `para/{task-name}` or `para/{task-name}-phase-N`
5. Extract implementation steps from the plan as todos
6. Update `context/context.md` with the todo list
7. Commit the context update as the first commit on the branch

## Prerequisites

- `context/context.md` must exist with an active plan
- If no active plan, error: "No active plan found. Run `/para:plan` first."
- If dirty git state, warn user and offer to continue or stash first
- If target branch already exists, ask: continue on it or create new?

## Context Update

Replace `context/context.md` with execution tracking format:

```markdown
# Current Work Summary

Executing: {Task Name}

**Branch:** `para/{task-name}`
**Plan:** context/plans/{plan-filename}

## To-Do List

- [ ] {Step 1 from plan}
- [ ] {Step 2 from plan}
- [ ] {Step 3 from plan}

## Progress Notes

_Update this section as you complete items._

---

```json
{
  "active_context": ["context/plans/{plan-filename}"],
  "completed_summaries": [],
  "execution_branch": "para/{task-name}",
  "execution_started": "{ISO timestamp}",
  "last_updated": "{ISO timestamp}"
}
```
```

For phased plans, add `phased_execution` block with phase statuses and `current_phase: N`. The branch becomes `para/{task-name}-phase-N` and both master and phase plans are listed in `active_context`.

## Commit-Per-Todo Rule

**Committing after each todo is mandatory.**

For each todo:
1. Implement the work
2. Mark it `[x]` in `context/context.md`
3. Stage changes: `git add -A`
4. Commit immediately with the todo text as the message

When all todos are complete, run `/para:summarize`.

## Edge Cases

- **No implementation steps in plan:** Prompt user to provide todos manually.
- **Multiple active plans:** Ask user which one to execute.
- **Branch already exists:** Ask: continue on existing branch, create with suffix, or cancel.
- **If a todo is too large:** Break it into smaller sub-items before implementing.

## Notes

- Branch naming follows `para/{task-name}` for easy identification
- For phased plans, each phase branches from `main` (assuming previous phases are merged)
- Run `/para:status` anytime to see current progress
