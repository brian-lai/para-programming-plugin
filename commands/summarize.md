# Command: summarize

Generate a summary document from the current work session. Supports both simple and phased plans.

## Usage

```
/para:summarize                   # Auto-detect active plan/phase
/para:summarize --phase=N         # Summarize specific phase
```

## What It Does

1. Analyzes git changes (files modified, added, deleted)
2. Reviews the active plan (or phase) from `context/context.md`
3. Creates summary: `context/summaries/YYYY-MM-DD-task-name-summary.md` (or `...-phase-N-summary.md`)
4. Updates `context/context.md`: moves plan from `active_context` to `completed_summaries`, updates timestamp
5. For phased plans, marks phase status as "completed"

## Summary Sections

- **Date & Status** -- when completed, success/failure
- **Changes Made** -- files modified/created with line references
- **Rationale** -- why these changes were made
- **MCP Tools Used** -- preprocessing tools utilized
- **Key Learnings** -- insights, follow-up tasks, gotchas
- **Test Results** -- pass/fail status, coverage metrics

## Implementation

1. Get current date in `YYYY-MM-DD` format
2. Read `context/context.md` to find active plan
3. Run `git diff` and `git status` to analyze changes
4. Extract task name from plan filename
5. Create summary file with template from `templates/summary-template.md`
6. Update `context/context.md` metadata
7. Display summary location

After summarizing, run `/para:archive` to clean up.
