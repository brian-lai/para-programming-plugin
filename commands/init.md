# Command: init

Initialize PARA-Programming structure in the current project.

## Usage

```
/para:init
/para:init --template=basic    # Minimal project CLAUDE.md (default)
/para:init --template=full     # Comprehensive project CLAUDE.md
```

## What It Does

1. **Set up global methodology file** at `~/.claude/CLAUDE.md` (copied from `resources/CLAUDE.md` if missing; never overwrites existing)
2. **Create context directory structure:**
   ```bash
   mkdir -p context/{data,plans,summaries,archives,servers}
   ```
3. **Create `context/context.md`** seeded from `templates/context-template.md`:
   ````markdown
   # Current Work Summary

   Ready to start first task.

   ---
   ```json
   {
     "active_context": [],
     "completed_summaries": [],
     "last_updated": "TIMESTAMP"
   }
   ```
   ````
   See `templates/context-schema.md` for the full field reference.
4. **Create project `CLAUDE.md`** (if missing) from `templates/claude-basic-template.md` (default, `--template=basic`) or `templates/claude-full-template.md` (`--template=full`)
5. **Update `.gitignore`** to include `.para-worktrees/`:
   - If `.gitignore` exists, check for `.para-worktrees/` entry; append if missing
   - If `.gitignore` does not exist, create it with `.para-worktrees/` as its content
   - This prevents worktree directories from being tracked by git

## Success Output

After initialization, display:

```
PARA-Programming Structure Initialized

context/
├── archives/     # Historical context snapshots
├── data/         # Input files, payloads, datasets
├── plans/        # Pre-work planning documents
├── servers/      # MCP tool wrappers
├── summaries/    # Post-work reports
└── context.md    # Active session context

.para-worktrees/  # Git worktree isolation (gitignored)

Files created/updated:
- ~/.claude/CLAUDE.md (global methodology, if it didn't exist)
- context/context.md (fresh context file)
- CLAUDE.md (project-specific context, if it didn't exist)
- .gitignore (added .para-worktrees/ entry)

Next steps:
1. Edit CLAUDE.md with your project-specific context
2. Create your first plan: /para:plan <task-description>
3. Check status: /para:status
4. Get help: /para:help
```
