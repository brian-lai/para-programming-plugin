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
3. **Create `context/context.md`** with initial structure:
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
4. **Create project `CLAUDE.md`** (if missing) from template based on `--template` option

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

Files created/updated:
- ~/.claude/CLAUDE.md (global methodology, if it didn't exist)
- context/context.md (fresh context file)
- CLAUDE.md (project-specific context, if it didn't exist)

Next steps:
1. Edit CLAUDE.md with your project-specific context
2. Create your first plan: /para:plan <task-description>
3. Check status: /para:status
4. Get help: /para:help
```
