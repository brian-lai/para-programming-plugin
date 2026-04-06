# Command: help

Display the PARA-Programming quick-reference guide.

## Usage

```
/para:help
```

## Implementation

Display the following:

---

# PARA-Programming Quick Reference

**Workflow:** Research → Plan → Review → Execute → Review → Summarize → Archive

## When to Use PARA

**Use PARA** if the task results in git changes (features, bug fixes, refactoring, config, migrations, tests, complex debugging).

**Skip PARA** if the task is read-only or informational (questions, navigation, explanations).

## Commands

| Command | Purpose |
|---------|---------|
| `/para:init` | Initialize PARA structure in a project |
| `/para:research <task>` | Deep codebase research before planning |
| `/para:plan <task>` | Create a planning document (collaborative) |
| `/para:review --plan\|--pr` | Staff+ FAANG engineer review loop |
| `/para:execute` | Create worktree, extract todos, start execution |
| `/para:workflow` | Orchestrate full execute → review → summarize → archive cycle |
| `/para:summarize` | Generate post-work summary |
| `/para:archive` | Archive context and start fresh |
| `/para:status` | Check current workflow state |
| `/para:check` | Decision helper: should I use PARA for this? |
| `/para:help` | Show this reference |

## Typical Flow

```
/para:research Add user authentication
/para:plan Add user authentication
/para:review --plan
/para:workflow           # or manually:
  /para:execute          #   → Creates worktree, implements with TDD
  /para:review --pr      #   → Staff+ review loop
  /para:summarize        #   → Generate summary
  /para:archive          #   → Clean up worktree
```

## File Structure

```
context/
├── context.md       # Active session context
├── plans/           # YYYY-MM-DD-task-name.md
├── summaries/       # YYYY-MM-DD-task-name-summary.md
├── archives/        # YYYY-MM-DD-context.md
├── data/            # Input/output files
└── servers/         # MCP tool wrappers
```

## Tips

- Run `/para:status` to see where you are in the workflow
- Run `/para:check` if unsure whether a task needs PARA
- Full methodology details are in `~/.claude/CLAUDE.md`
