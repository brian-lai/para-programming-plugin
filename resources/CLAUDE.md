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
  "completed_summaries": [],
  "last_updated": "2025-11-08T15:20:00Z"
}
```
````

See `templates/context-schema.md` in the plugin directory for the full field reference (including `worktree_path`, `phased_execution`, `workflow`, and other execution-time fields).

---

## Non-Negotiable Rules

### Never commit directly to main
**All code changes go through the full PARA workflow: plan → worktree branch → PR → review → merge.**

This includes small changes: version bumps, one-liner fixes, config tweaks, documentation updates. There is no such thing as "too small for a PR."

If a request sounds like it could bypass this (e.g. "make a quick update", "just bump the version", "minor fix"), **always ask the user for explicit confirmation before proceeding outside the workflow.** Only skip if the user explicitly and directly instructs otherwise.

---

## When to Use PARA

**Use PARA** for any task that results in git changes: features, bug fixes, refactoring, config changes, migrations, tests, complex debugging.

**Skip PARA** for read-only or informational tasks: "What does X do?", "Show me the auth logic", "Explain how caching works."

---

## Workflow Loop

```
Research → Plan → Review Plan → Execute → Review PR → Summarize → Archive
```

For multi-phase work, use `/para:workflow` to orchestrate the full cycle automatically.

### 1. Research (Optional but Recommended)

Run `/para:research` to perform deep codebase exploration before planning:
- Produces a structured research doc at `context/data/YYYY-MM-DD-task-name-research.md`
- Covers architecture, components, API contracts, patterns, graceful degradation, gaps
- Becomes primary input for the planning phase

### 2. Plan (Collaborative)

1. **Ensure context directory exists:**
   ```bash
   mkdir -p context/{data,plans,summaries,archives,servers}
   ```

2. **Check for research doc** — use as primary input if available

3. **Ask clarifying questions (CRITICAL):**
   - Use **AskUserQuestion** for 1-4 focused questions about scope, approach, constraints, and preferences
   - Skip only if the task is trivially simple with no meaningful choices

4. **Explore codebase:**
   - Identify existing patterns, conventions, and affected components
   - Identify interface boundaries between systems and existing graceful degradation patterns

5. **Draft plan** applying Staff+ engineering criteria:
   - Core principles, architecture decisions, interface boundaries, graceful degradation
   - Implementation steps as checklist items (each item = one git commit message)
   - TDD ordering: tests before implementation
   - For complex work, propose a phased plan (master + sub-plans)
   - Complex plans undergo 2-3 automatic self-review rounds before being presented for human review

**Default to asking questions.** Plans created collaboratively succeed more often than plans based on assumptions.

### 3. Review Plan

Run `/para:review --plan` for independent Staff+ subagent review:
- Spawns a separate agent with Staff+ FAANG engineer persona
- Reviews architecture, TDD ordering, completeness, scope
- Loops until approved (MUST FIX → address → re-review)
- Review loops are capped at 5 rounds with convergence detection; see `commands/review.md` for details.

### 4. Execute

**Git workflow (mandatory in git repositories):**

1. **Create an isolated worktree:** `git fetch origin main && git worktree add .para-worktrees/{task-name} -b para/{task-name} origin/main`
   - For phased plans: `.para-worktrees/{task-name}-phase-N` on branch `para/{task-name}-phase-N`

2. **Track todos in `context/context.md`** — extract checklist items from the plan. Each item's text becomes the commit message.

3. **Commit after EVERY completed todo (TDD cycle):**
   - Confirm spec + stubs exist
   - Write tests first (red)
   - Implement to make tests pass (green)
   - Mark `[x]` in `context/context.md`
   - Commit with the checklist item text as the message

   `/para:execute` enforces spec + stubs + TDD for code-bearing plans. Plans that are markdown-only or docs-only may relax this in their Out-of-Scope section.

### 5. Review PR

Run `/para:review --pr` for independent Staff+ subagent review of the implementation:
- Checks commit-plan alignment, test quality, conventions
- Loops until approved
- Review loops are capped at 5 rounds with convergence detection; see `commands/review.md` for details.

### 6. Summarize

Write a report to `context/summaries/YYYY-MM-DD-task-name-summary.md` covering:
- What changed and why
- Key learnings
- Staff+ review results

### 7. Archive

- Remove worktrees: `git worktree remove .para-worktrees/{task-name}` and `git worktree prune`
- Move `context/context.md` to `context/archives/YYYY-MM-DD-context.md`
- Create a fresh `context/context.md` seeded with any ongoing references
