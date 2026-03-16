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
4. Fetch latest and create an isolated git worktree: `git fetch origin main && git worktree add .para-worktrees/{task-name} -b para/{task-name} origin/main` (or `para/{task-name}-phase-N`)
5. Extract implementation steps from the plan as todos
6. Update `context/context.md` with the todo list and worktree path (this file lives in the main working tree)
7. Make the initial commit on the branch from within the worktree. Since `context/context.md` is in the main working tree, not the worktree, this first commit should instead be an empty commit to mark the start of the branch: `git -C .para-worktrees/{task-name} commit --allow-empty -m "chore: Initialize execution context for {task-name}"`

### `--no-worktree` Escape Hatch

When `--no-worktree` is specified, fall back to the legacy branch-based behavior: `git checkout -b para/{task-name}`. This still creates a branch — it just switches your current working directory to that branch instead of creating a separate worktree directory. There is no isolation: your main working tree moves to the new branch. Use this only for single-developer workflows where you don't need to keep the main working tree on its current branch.

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

## Commit-Per-Todo Rule (Spec-Driven TDD)

**Committing after each todo is mandatory. Each todo follows a spec-first, tests-first cycle.**

Before starting any todo, verify that the active plan references a spec file (`context/data/*-spec.yaml` or equivalent contract). If missing, prompt the user to create the spec before proceeding.

The agent works inside the worktree directory (`.para-worktrees/{task-name}/`). All file edits, test runs, and git operations happen within this directory, keeping the main working tree untouched.

> **Design note:** `context/context.md` is intentionally kept in the main working tree (not the worktree) so it remains accessible regardless of which worktree is active. All PARA commands read from and write to the main working tree's `context/` directory.

For each todo:
1. **Confirm spec + stubs exist** — locate the stub source file(s) for this step. If stubs are missing (planning was skipped), create them now from the spec before writing tests.
2. **Write tests first** — based on the plan's `Tests:` annotation and the spec. Tests import the stub and assert expected behavior; they should initially fail.
3. **Implement** — replace stub bodies with real logic to make tests pass.
4. **Verify** — run the test suite to confirm all tests pass.
5. Mark it `[x]` in `context/context.md` (in the main working tree)
6. Stage changes in the worktree: `git -C .para-worktrees/{task-name} add -A`
7. Commit from the worktree: `git -C .para-worktrees/{task-name} commit -m "todo text"`

If a todo has no meaningful automated tests (e.g., config changes, documentation, template updates), note this in the commit and skip steps 1–4.

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
