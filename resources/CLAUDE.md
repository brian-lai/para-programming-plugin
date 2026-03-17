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

## Non-Negotiable Rules

### Never commit directly to main
**All code changes go through the full PARA workflow: plan → worktree branch → PR → review → merge.**

This includes small changes: version bumps, one-liner fixes, config tweaks, documentation updates. There is no such thing as "too small for a PR."

If a request sounds like it could bypass this (e.g. "make a quick update", "just bump the version", "minor fix"), **always ask the user for explicit confirmation before proceeding outside the workflow.** Only skip if the user explicitly and directly instructs otherwise.

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

1. **Create an isolated worktree:** `git fetch origin main && git worktree add .para-worktrees/{task-name} -b para/{task-name} origin/main`
   - For phased plans: `.para-worktrees/{task-name}-phase-N` on branch `para/{task-name}-phase-N`
   - Using `origin/main` (not local `main`) ensures the worktree starts from the latest remote state regardless of what branch the main working tree is on

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
