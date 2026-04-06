# {TASK_NAME}

> **Master plan.** Phase-specific details are in sub-plan files. Load only the phase you're working on.

---

## Objective

[Clear statement of the overall goal. 2-3 sentences max.]

---

## Core Principles

1. **[Principle 1].** [One-sentence explanation]
2. **[Principle 2].** [One-sentence explanation]
3. **[Principle 3].** [One-sentence explanation]

[3-6 opinionated principles specific to this task. Not generic truisms.]

---

## Architecture

```
[ASCII diagram showing major components and data flow]
```

### Data/Event Flow

```
[Step-by-step flow showing how data moves through the system]
```

---

## Architecture Decisions

| Decision | Choice | Rationale | Alternatives Rejected |
|----------|--------|-----------|----------------------|
| [Decision 1] | [What was chosen] | [Why] | [What was considered and why it lost] |
| [Decision 2] | [What was chosen] | [Why] | [What was considered and why it lost] |

---

## Responsibility Split

| Responsibility | Owner |
|---------------|-------|
| [Responsibility 1] | [Component/module that owns it] |
| [Responsibility 2] | [Component/module that owns it] |

---

## Graceful Degradation

| Failure Scenario | Expected Behavior |
|-----------------|-------------------|
| [Dependency 1] down | [What happens — error message, fallback, retry] |
| [Dependency 2] down | [What happens] |
| [Dependency 3] returns errors | [What happens] |

---

## Phase Overview

| Phase | Title | Scope | Est. Time |
|-------|-------|-------|-----------|
| **{PHASE_1_ID}** | {PHASE_1_NAME} | [Brief scope] | [Time] |
| **{PHASE_2_ID}** | {PHASE_2_NAME} | [Brief scope] | [Time] |
| **{PHASE_3_ID}** | {PHASE_3_NAME} | [Brief scope] | [Time] |

### Progressive Regression Rule

```
Phase {PHASE_1_ID} → [which test suites go green]
Phase {PHASE_2_ID} → + [which additional test suites go green]
Phase {PHASE_3_ID} → + [which additional test suites go green, including E2E]
```

---

## Execution Plan

1. **Review all phases** - Ensure entire approach is sound before starting
2. **Execute Phase 1** - Run `/para:execute --phase=1` (creates worktree at `.para-worktrees/{task-name}-phase-1`)
3. **Summarize Phase 1** - Run `/para:summarize --phase=1` (analyzes diff from worktree)
4. **Review & Merge Phase 1** - Push branch, create PR, review, merge to main
5. **Execute Phase 2** - Run `/para:execute --phase=2` (creates new worktree from updated main)
6. **Continue** - Repeat summarize → review → merge → execute for remaining phases
7. **Final Verification** - Ensure overall success criteria met
8. **Archive** - Run `/para:archive` (removes all worktrees and prunes)

### Worktree & Branch Strategy

Each phase uses an isolated git worktree alongside a dedicated branch:

| Phase | Branch | Worktree Path |
|-------|--------|---------------|
| Phase 1 | `para/{task-name}-phase-1` | `.para-worktrees/{task-name}-phase-1` |
| Phase 2 | `para/{task-name}-phase-2` | `.para-worktrees/{task-name}-phase-2` |
| Phase 3 | `para/{task-name}-phase-3` | `.para-worktrees/{task-name}-phase-3` |

Each branch starts from `main` (with previous phases already merged). Worktrees are created by `/para:execute` and cleaned up by `/para:archive`.

---

## New Components

| Component | Location | Purpose |
|-----------|----------|---------|
| [Component 1] | `path/to/component/` | [What it does] |
| [Component 2] | `path/to/component/` | [What it does] |

---

## Security Model Summary

[Include this section if the task involves authentication, authorization, secrets, or cross-trust-boundary communication. Remove if not applicable.]

- **[Layer 1]:** [Description]
- **[Layer 2]:** [Description]

---

## Local Dev Setup

[Include this section if the task introduces new services, containers, or infrastructure that developers need to run locally. Remove if not applicable.]

```
[Terminal commands or docker-compose setup needed]
```

---

## Sub-Plans

- `{DATE}-{TASK_NAME}-phase-{PHASE_1_ID}.md` — [One-line description]
- `{DATE}-{TASK_NAME}-phase-{PHASE_2_ID}.md` — [One-line description]
- `{DATE}-{TASK_NAME}-phase-{PHASE_3_ID}.md` — [One-line description]
