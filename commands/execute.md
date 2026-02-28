# Command: execute

Execute the active plan by creating an isolated worktree and tracking todos. Supports both simple and phased plans.

## Usage

```
/para:execute                    # Auto-detect plan; prompts for phase if phased
/para:execute --phase=N          # Execute specific phase
/para:execute --branch=name      # Custom branch name (simple plans only)
/para:execute --no-worktree      # Skip worktree creation; fall back to git checkout -b
```

## What It Does

1. Read the active plan from `context/context.md`
2. Detect simple vs phased plan (presence of `phased_execution` in JSON)
3. For phased plans, determine which phase to execute (prompt if not specified; verify previous phases are completed)
4. Create an isolated git worktree: `git worktree add .para-worktrees/{task-name} -b para/{task-name} main` (or `para/{task-name}-phase-N`)
5. Extract implementation steps from the plan as todos
6. Update `context/context.md` with the todo list and worktree path
7. Commit the context update as the first commit on the branch (from within the worktree)

### `--no-worktree` Escape Hatch

When `--no-worktree` is specified, fall back to the legacy behavior: `git checkout -b para/{task-name}`. This switches the current working directory to the new branch instead of creating a separate worktree. Use this only when worktree isolation is not desired (e.g., single-developer local workflow with no parallel work).

## Prerequisites

- `context/context.md` must exist with an active plan
- If no active plan, error: "No active plan found. Run `/para:plan` first."
- If dirty git state, warn user and offer to continue or stash first
- Check `.gitignore` for `.para-worktrees/` entry; if missing, warn and suggest running `/para:init`
- If target worktree directory already exists, ask: continue in it, remove and recreate, or cancel
- If target branch already exists but no worktree, use `git worktree add .para-worktrees/{task-name} para/{task-name}` (without `-b`)

## Context Update

Replace `context/context.md` with execution tracking format:

```markdown
# Current Work Summary

Executing: {Task Name}

**Branch:** `para/{task-name}`
**Worktree:** `.para-worktrees/{task-name}`
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
  "worktree_path": ".para-worktrees/{task-name}",
  "execution_started": "{ISO timestamp}",
  "last_updated": "{ISO timestamp}"
}
```
```

For phased plans, add `phased_execution` block with phase statuses and `current_phase: N`. The branch becomes `para/{task-name}-phase-N`, the worktree becomes `.para-worktrees/{task-name}-phase-N`, and both master and phase plans are listed in `active_context`. Each phase entry includes `branch` and `worktree_path` fields:

```json
{
  "phased_execution": {
    "master_plan": "context/plans/YYYY-MM-DD-task-name.md",
    "phases": [
      { "phase": 1, "plan": "...", "status": "in_progress", "branch": "para/{task-name}-phase-1", "worktree_path": ".para-worktrees/{task-name}-phase-1" },
      { "phase": 2, "plan": "...", "status": "pending", "branch": null, "worktree_path": null }
    ],
    "current_phase": 1
  }
}
```

## Commit-Per-Todo Rule (TDD)

**Committing after each todo is mandatory. Each todo follows a tests-first cycle.**

The agent works inside the worktree directory (`.para-worktrees/{task-name}/`). All file edits, test runs, and git operations happen within this directory, keeping the main working tree untouched.

For each todo:
1. **Write tests first** — based on the plan's `Tests:` annotation for this step. Tests should initially fail.
2. **Implement** — write the minimum code to make the tests pass.
3. **Verify** — run the test suite to confirm all tests pass.
4. Mark it `[x]` in `context/context.md` (in the main working tree)
5. Stage changes in the worktree: `git -C .para-worktrees/{task-name} add -A`
6. Commit from the worktree: `git -C .para-worktrees/{task-name} commit -m "todo text"`

If a todo has no meaningful automated tests (e.g., config changes, documentation, template updates), note this in the commit and skip the test-writing step.

When all todos are complete, run `/para:summarize`.

## Edge Cases

- **No implementation steps in plan:** Prompt user to provide todos manually.
- **Multiple active plans:** Ask user which one to execute.
- **Worktree directory already exists:** Ask: continue in existing worktree, remove and recreate, or cancel.
- **Branch exists but no worktree:** Use `git worktree add` without `-b` flag to attach to existing branch.
- **Stale worktree (context.md references missing directory):** Warn user, offer to recreate or clean up metadata.
- **`.para-worktrees/` not in .gitignore:** Warn and suggest running `/para:init`.
- **If a todo is too large:** Break it into smaller sub-items before implementing.
- **User runs command from inside worktree:** Detect missing `context/context.md` relative to cwd, warn that commands should be run from the main working tree.

## Notes

- Worktree isolation keeps the main working tree on its current branch while the agent works in `.para-worktrees/`
- Branch naming follows `para/{task-name}` for easy identification
- For phased plans, each phase branches from `main` (assuming previous phases are merged)
- Run `/para:status` anytime to see current progress and worktree state
