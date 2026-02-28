# Command: status

Display the current state of PARA context and workflow progress.

## Usage

```
/para:status
/para:status --verbose         # Include file contents preview
/para:status --files           # List all context files
```

## What It Does

1. Reads and parses `context/context.md`
2. Displays current work summary, active plans, and completed summaries
3. Shows worktree status (path, branch, existence)
4. Detects stale and orphaned worktrees
5. Detects workflow state and suggests next action

## Output Format

```
PARA Status

Current Work:
   Implementing user authentication system

Active Plans:
   context/plans/2025-11-24-user-auth.md (created 2h ago)

Worktree:
   Path: .para-worktrees/user-auth
   Branch: para/user-auth
   Status: active (directory exists, branch valid)

Completed Summaries:
   context/summaries/2025-11-23-api-setup-summary.md

Last Updated: 2025-11-24T14:30:00Z

Next Action:
   Continue executing the plan, or run /para:summarize when complete
```

## Worktree Health Checks

- **Active:** `worktree_path` in metadata, directory exists, branch is valid
- **Stale reference:** `worktree_path` in metadata but directory does not exist — warn: "Worktree referenced in context.md but directory missing. Run `/para:execute` to recreate or update context.md."
- **Orphaned worktree:** Directory exists in `.para-worktrees/` but is not referenced in `context/context.md` — warn: "Orphaned worktree found at `.para-worktrees/{name}`. Run `git worktree remove` to clean up or update context.md."
- **No worktree:** No `worktree_path` in metadata — normal for idle/planning states or legacy `--no-worktree` execution

## Implementation

1. Check if `context/context.md` exists
2. Parse the JSON block for `active_context`, `completed_summaries`, `worktree_path`, `last_updated`
3. Read the human-readable summary section
4. Check worktree state:
   - If `worktree_path` is set, verify the directory exists
   - List directories in `.para-worktrees/` and compare against metadata references
5. Check git status for uncommitted changes
6. Determine workflow state and suggest next action:
   - **No context** → `/para:init`
   - **Idle** → `/para:plan`
   - **Planning** → Review plan and begin execution
   - **Executing** → Continue work or `/para:summarize` if done
   - **Summarized** → `/para:archive`
