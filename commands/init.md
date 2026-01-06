# Command: init

Initialize PARA-Programming structure in the current project.

## What This Does

This command sets up the complete PARA-Programming environment:

1. **Sets up global methodology file** at `~/.claude/CLAUDE.md` (if it doesn't exist)
   - This file defines the PARA workflow methodology
   - Only created if missing; existing files are never overwritten

2. Creates `context/` directory with subdirectories:
   - `context/data/` - Input files, payloads, datasets
   - `context/plans/` - Pre-work planning documents
   - `context/summaries/` - Post-work reports
   - `context/archives/` - Historical context snapshots
   - `context/servers/` - MCP tool wrappers

3. Creates `context/context.md` with initial structure

4. Creates project `CLAUDE.md` (if it doesn't exist) with reference to global methodology

5. Displays next steps for getting started

## Usage

```
/init
```

### Options

```
/init --template=basic    # Create minimal CLAUDE.md
/init --template=full     # Create comprehensive CLAUDE.md
```

## After Running

You'll have a complete PARA-Programming setup ready for your first task. Start by:

1. Editing `CLAUDE.md` with your project-specific context
2. Running `/plan` to create your first plan
3. Following the PARA workflow: Plan → Review → Execute → Summarize → Archive

## Implementation

### Step 0: Set Up Global Methodology File

First, ensure the global PARA methodology file exists at `~/.claude/CLAUDE.md`:

```bash
# Create ~/.claude directory if it doesn't exist
mkdir -p ~/.claude

# Copy global CLAUDE.md if it doesn't exist (never overwrite)
if [ ! -f ~/.claude/CLAUDE.md ]; then
    cp resources/CLAUDE.md ~/.claude/CLAUDE.md
    echo "Created global methodology file at ~/.claude/CLAUDE.md"
else
    echo "Global methodology file already exists (skipped)"
fi
```

**Important:** The global file is copied from the plugin's `resources/CLAUDE.md`. This file defines the PARA workflow methodology and is shared across all projects.

### Step 1: Create Project Directory Structure

Create the following directory structure:

```bash
mkdir -p context/{data,plans,summaries,archives,servers}
```

Create `context/context.md`:

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

If `CLAUDE.md` doesn't exist, create it from template based on `--template` option (default: basic).

After completing setup, display the following comprehensive success message:

---

## Success Output

After initialization completes, display:

```markdown
## ✅ PARA-Programming Structure Initialized

### Directory Structure Created

```
context/
├── archives/     # Historical context snapshots
├── data/         # Input files, payloads, datasets
├── plans/        # Pre-work planning documents
├── servers/      # MCP tool wrappers
├── summaries/    # Post-work reports
└── context.md    # Active session context
```

### Files Created/Updated

- **`~/.claude/CLAUDE.md`** - Global workflow methodology (if it didn't exist)
- **`context/context.md`** - Fresh context file ready for first task
- **`CLAUDE.md`** - Project-specific context (if it didn't exist)

---

## 📋 Quick Reference

**PARA Workflow:** Plan → Review → Execute → Summarize → Archive

| Use PARA For | Skip PARA For |
|--------------|---------------|
| Code changes, features, bug fixes | Simple queries ("What does X do?") |
| Architecture decisions | Code navigation ("Show me X") |
| Complex debugging | Explanations ("How does X work?") |
| File modifications | Quick lookups |
| Refactoring, optimizations | Read-only informational tasks |

**Rule of thumb:** If it results in git changes, use PARA workflow.

---

## 🚀 Next Steps

1. **Edit `CLAUDE.md`** with your project-specific context (architecture, tech stack, conventions)
2. **Create your first plan:** `/plan <task-description>`
3. **Check workflow status:** `/status`
4. **Get help anytime:** `/help`

---

## 📚 Available PARA Commands

- **`/plan`** - Create a new planning document
- **`/execute`** - Start execution: create branch and track to-dos
- **`/summarize`** - Generate post-work summary
- **`/archive`** - Archive current context
- **`/status`** - Check current workflow state
- **`/check`** - Decision helper (should I use PARA?)
- **`/help`** - Comprehensive PARA guide

---

## 💡 Getting Started Tips

**First time using PARA?**
1. Start with a small task to learn the workflow
2. Run `/help` to see the full guide
3. Use `/check` when unsure if a task needs PARA

**Example first task:**
```
/plan Add user authentication to API endpoints
```

Your PARA-Programming environment is ready! 🎉
```
