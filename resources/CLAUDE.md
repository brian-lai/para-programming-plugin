# Global CLAUDE.md -- PARA Workflow Guide

> **Location:** `~/.claude/CLAUDE.md`
> **Purpose:** Defines the PARA workflow methodology for all projects.
> Project-specific context belongs in each project's local `CLAUDE.md`.

---

## Directory Structure

Every project using PARA has a `context/` directory:

```
project-root/
├── context/
│   ├── context.md              # Active session context (the master file)
│   ├── data/                   # Input/output files, payloads, datasets
│   ├── plans/                  # Pre-work plans
│   ├── summaries/              # Post-work summaries
│   ├── archives/               # Archived context.md snapshots
│   └── servers/                # MCP tool wrappers
├── .para-worktrees/            # Git worktree isolation (gitignored)
└── CLAUDE.md                   # Project-specific context
```

**File naming:** All context files use `YYYY-MM-DD-descriptive-name.ext` prefixes for chronological sorting. Exception: files in `context/servers/` use descriptive names only.

---

## The Master File -- `context/context.md`

Tracks active work with a human-readable summary and a JSON metadata block:

````markdown
# Current Work Summary
Enhancing payroll API with token-efficient MCP integration.

---
```json
{
  "active_context": [
    "context/plans/2025-11-08-payroll-api.md"
  ],
  "completed_summaries": [
    "context/summaries/2025-11-08-payroll-summary.md"
  ],
  "worktree_path": ".para-worktrees/payroll-api",
  "last_updated": "2025-11-08T15:20:00Z"
}
```
````

---

## When to Use PARA

**Use PARA** for any task that results in git changes: features, bug fixes, refactoring, config changes, migrations, tests, complex debugging.

**Skip PARA** for read-only or informational tasks: "What does X do?", "Show me the auth logic", "Explain how caching works."

---

## Workflow Loop

```
Plan → Review → Execute → Summarize → Archive
```

### 1. Plan (Collaborative)

1. **Ensure context directory exists:**
   ```bash
   mkdir -p context/{data,plans,summaries,archives,servers}
   ```

2. **Ask clarifying questions (CRITICAL):**
   - Use **AskUserQuestion** for 1-4 focused questions about scope, approach, constraints, and preferences
   - Skip only if the task is trivially simple with no meaningful choices
   - Explore the codebase *after* getting answers, not before

3. **Explore codebase:**
   - Identify existing patterns, conventions, and affected components

4. **Draft plan:**
   - Create `context/plans/YYYY-MM-DD-task-name.md`
   - Include: Objective, Approach, Risks, Success Criteria
   - For complex work (>5-10 files or multiple architectural layers), propose a phased plan:
     - Master plan: `YYYY-MM-DD-task-name.md`
     - Sub-plans: `YYYY-MM-DD-task-name-phase-1.md`, `...-phase-2.md`, etc.

**Default to asking questions.** Plans created collaboratively succeed more often than plans based on assumptions.

### 2. Review

Pause and request human validation of the plan before proceeding.

### 3. Execute

**Git workflow (mandatory in git repositories):**

1. **Create an isolated worktree:** `git worktree add .para-worktrees/{task-name} -b para/{task-name} main`
   - For phased plans: `.para-worktrees/{task-name}-phase-N` on branch `para/{task-name}-phase-N`
   - The agent works inside the worktree directory; the main working tree stays on its current branch

2. **Track todos in `context/context.md`** (in the main working tree) -- extract implementation steps from the plan as a checkbox list.

3. **Commit after EVERY completed todo (TDD cycle):**
   - Write tests first based on the plan's `Tests:` annotations
   - Implement the minimum code to make tests pass
   - Run the test suite to verify all tests pass
   - Mark the todo `[x]` in `context/context.md`
   - Commit from the worktree: `git -C .para-worktrees/{task-name} commit`
   - Each commit = one atomic, complete unit of work

**MCP integration:** Use wrappers in `context/servers/` to preprocess large data before passing results into model context.

### 4. Summarize

Write a report to `context/summaries/YYYY-MM-DD-task-name-summary.md` covering:
- What changed and why
- MCP tools or data sources used
- Key learnings

### 5. Archive

- Remove worktrees: `git worktree remove .para-worktrees/{task-name}` and `git worktree prune`
- Move `context/context.md` to `context/archives/YYYY-MM-DD-context.md`
- Create a fresh `context/context.md` seeded with any ongoing references
