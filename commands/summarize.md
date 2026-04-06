# Command: summarize

Generate a summary document from the current work session. Supports both simple and phased plans.

## Usage

```
/para:summarize                   # Auto-detect active plan/phase
/para:summarize --phase=N         # Summarize specific phase
```

## What It Does

1. Reads `worktree_path` from `context/context.md` JSON metadata
2. Analyzes git changes from the worktree using `git -C {worktree_path} diff main...HEAD` and `git -C {worktree_path} log main..HEAD`
3. Reviews the active plan (or phase) from `context/context.md`
4. Creates summary in the **main working tree**: `context/summaries/YYYY-MM-DD-task-name-summary.md` (or `...-phase-N-summary.md`)
5. Updates `context/context.md`: moves plan from `active_context` to `completed_summaries`, updates timestamp
6. For phased plans, marks phase status as "completed"

## Summary Sections

- **Date & Status** -- when completed, success/failure
- **Changes Made** -- files modified/created with line references (from worktree diff)
- **Rationale** -- why these changes were made
- **MCP Tools Used** -- preprocessing tools utilized
- **Key Learnings** -- insights, follow-up tasks, gotchas
- **Test Results** -- pass/fail status, coverage metrics

## Implementation

1. Get current date in `YYYY-MM-DD` format
2. Read `context/context.md` to find active plan and `worktree_path`
3. If `worktree_path` is set, analyze changes with:
   - `git -C {worktree_path} diff main...HEAD` for file-level changes
   - `git -C {worktree_path} log main..HEAD --oneline` for commit history
4. If no `worktree_path` (legacy or `--no-worktree` execution), fall back to `git diff` and `git status` on current branch
5. Extract task name from plan filename
6. Create summary file in main working tree with template from `templates/summary-template.md`
7. Update `context/context.md` metadata
8. Display summary location

## Post-Summarize Guidance

After summarizing, the next steps are:
1. Push the branch: `git -C {worktree_path} push -u origin para/{task-name}`
2. Create a PR: `gh pr create` from the worktree branch
3. Run `/para:archive` to clean up the worktree and archive context
