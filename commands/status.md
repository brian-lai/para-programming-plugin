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
3. Detects workflow state and suggests next action

## Output Format

```
PARA Status

Current Work:
   Implementing user authentication system

Active Plans:
   context/plans/2025-11-24-user-auth.md (created 2h ago)

Completed Summaries:
   context/summaries/2025-11-23-api-setup-summary.md

Last Updated: 2025-11-24T14:30:00Z

Next Action:
   Continue executing the plan, or run /para:summarize when complete
```

## Implementation

1. Check if `context/context.md` exists
2. Parse the JSON block for `active_context`, `completed_summaries`, `last_updated`
3. Read the human-readable summary section
4. Check git status for uncommitted changes
5. Determine workflow state and suggest next action:
   - **No context** → `/para:init`
   - **Idle** → `/para:plan`
   - **Planning** → Review plan and begin execution
   - **Executing** → Continue work or `/para:summarize` if done
   - **Summarized** → `/para:archive`
