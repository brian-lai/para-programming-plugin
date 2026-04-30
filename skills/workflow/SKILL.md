---
name: workflow
description: Orchestrate the full PARA execution cycle across phases
model: sonnet
effort: medium
---

Orchestrate the full PARA execution cycle across phases: execute → PR → review → summarize → archive → next phase. Supports both manual (pause at boundaries) and autonomous (`--auto`) modes.

## Usage

```
/para:workflow                     # Run workflow for active plan (pause at phase boundaries)
/para:workflow --auto              # Fully autonomous (no pause between phases)
/para:workflow --phase=N           # Start from a specific phase
/para:workflow --skip-review       # Skip Staff+ review loops (for speed)
```

## Prerequisites

- `context/context.md` must exist with an active phased plan
- For simple (non-phased) plans, use `/para:execute` directly — the workflow command is designed for multi-phase orchestration
- Git repository must be clean (or user confirms proceeding with dirty state)

## Process (Per Phase)

For each phase in the plan, the workflow runs these steps in order:

### Step 1: Execute

Run `/para:execute --phase=N`.

- Creates a worktree and branch for the phase
- Extracts checklist items as todos
- Implements each todo following the TDD cycle (red → green → commit)
- Each checklist item text becomes the commit message

### Step 2: Create PR

Create a pull request for the phase branch. This step owns PR creation for workflow runs. `/para:summarize` (Step 4) will detect that it's running inside the orchestrator and skip its standalone push/PR guidance.

- **PR title:** `para/{task-name} phase N: {phase title}`
- **PR body:** auto-generated from:
  - Phase objective (from sub-plan)
  - Commit list with descriptions
  - Checklist of implementation steps (checked off)
  - Link to plan file

### Step 3: Review

Run `/para:review --pr` (unless `--skip-review` is specified).

- Staff+ subagent reviews the PR
- Loop until approved (or user overrides)
- Apply fixes, create additional commits as needed
- Push fixes to the PR branch

### Step 4: Summarize

Run `/para:summarize --phase=N`.

- Generate phase summary to `context/summaries/`
- Record what changed, rationale, key learnings
- Mark phase as "completed" in `context/context.md`

### Step 5: Merge

Merge the PR.

- **Default mode:** Pause and ask user "Ready to merge Phase N PR? (Y/n)"
- **`--auto` mode:** Merge automatically after Staff+ review approval
- Use `gh pr merge --merge --delete-branch`

### Step 6: Archive

Run `/para:archive` for mid-workflow cleanup.

- For mid-workflow (more phases remaining): partial archive — update `context/context.md` to reflect completed phase, but don't create a full archive snapshot
- For final phase: full archive — move context to archives, create fresh context

### Step 7: Next Phase

If more phases remain:

- **Default mode:** Pause and ask "Ready to start Phase {N+1}? (Y/n)"
- **`--auto` mode:** Proceed immediately
- Pull latest main (with merged phase), update `context/context.md` to reflect new active phase
- Loop back to Step 1

## State Tracking

Track workflow progress in `context/context.md` metadata via the `workflow` object. See `../init/context-schema.md` for the full field reference.

This enables resumability — if the workflow is interrupted, running `/para:workflow` again picks up from the current step of the current phase.

## Error Handling

- **Step failure:** If any step fails (e.g., tests fail, PR has conflicts, review doesn't converge), pause and present the error to the user with options:
  1. Fix the issue and continue (`/para:workflow` resumes from current step)
  2. Skip the current step (`/para:workflow --skip-step=review`)
  3. Abort the workflow

- **Merge conflicts:** If the PR cannot be merged, pause and ask the user to resolve conflicts manually. After resolution, resume with `/para:workflow`.

- **Review non-convergence:** If the Staff+ review hits the 5-round limit, escalate per `/para:review` convergence rules. The workflow pauses until the user decides.

## Completion

When all phases are complete:

1. Run full archive (`/para:archive`)
2. Display summary of all phases:
   - Total phases completed
   - Total commits across all phases
   - PRs merged (with links)
   - Staff+ review rounds per phase
3. Suggest next steps (e.g., tag a release, update documentation)

## Notes

- The workflow command is an orchestrator — it delegates to existing commands (`/para:execute`, `/para:review`, `/para:summarize`, `/para:archive`)
- `--auto` mode still requires Staff+ review approval as a quality gate (unless `--skip-review` is also specified)
- Each phase creates its own PR, enabling incremental review and merge
- The workflow is resumable — state is tracked in `context/context.md`
- For single-phase plans, the workflow still works but is equivalent to running the commands manually
