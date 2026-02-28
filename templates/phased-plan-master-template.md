# Master Plan: {TASK_NAME}

**Date:** {DATE}
**Status:** In Review
**Type:** Phased Plan

---

## Overview

### Objective

[Clear statement of the overall goal and what needs to be accomplished]

### Why Phased?

[Brief explanation of why this work is broken into phases - architectural boundaries, dependencies, review benefits, etc.]

---

## Phase Breakdown

### Phase 1: {PHASE_1_NAME}

**Objective:** [What this phase accomplishes]

**Key Deliverables:**
- [Deliverable 1]
- [Deliverable 2]

**Dependencies:** None (foundational phase)

**Plan:** `context/plans/{DATE}-{TASK_NAME}-phase-1.md`

---

### Phase 2: {PHASE_2_NAME}

**Objective:** [What this phase accomplishes]

**Key Deliverables:**
- [Deliverable 1]
- [Deliverable 2]

**Dependencies:** Phase 1 must be complete and merged

**Plan:** `context/plans/{DATE}-{TASK_NAME}-phase-2.md`

---

### Phase 3: {PHASE_3_NAME}

**Objective:** [What this phase accomplishes]

**Key Deliverables:**
- [Deliverable 1]
- [Deliverable 2]

**Dependencies:** Phase 2 must be complete and merged

**Plan:** `context/plans/{DATE}-{TASK_NAME}-phase-3.md`

---

[Add more phases as needed]

---

## Integration Strategy

### How Phases Connect

[Explain how the phases build on each other and integrate together]

### Testing Strategy

- **Phase-Level Testing:** [How each phase is tested — each phase follows TDD with per-step test criteria]
- **Integration Testing:** [How phases are tested together]
- **End-to-End Testing:** [Full system testing after all phases]

### Deployment Strategy

[Explain the deployment approach - will each phase be deployed separately, or all together after completion?]

---

## Cross-Phase Considerations

### Shared Risks

[Risks that span multiple phases or affect the overall approach]

- **Risk 1:** [Description and mitigation]
- **Risk 2:** [Description and mitigation]

### Data Sources

[Data sources, APIs, or external dependencies used across phases]

- [Source 1]: [Purpose and which phases use it]
- [Source 2]: [Purpose and which phases use it]

### MCP Tools

[Preprocessing tools that may be used across multiple phases]

- `context/servers/{tool}.ts` - [Purpose]

---

## Overall Success Criteria

These criteria must be met after ALL phases are complete:

- [ ] [Overall criterion 1]
- [ ] [Overall criterion 2]
- [ ] [Overall criterion 3]
- [ ] All phase-specific criteria met
- [ ] Integration testing passes
- [ ] Documentation updated

---

## Execution Plan

### Timeline Structure

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

## Review Checklist

Before beginning execution:

- [ ] Are all phases clearly defined?
- [ ] Are dependencies between phases explicit?
- [ ] Can each phase be reviewed and merged independently?
- [ ] Does each phase deliver incremental value?
- [ ] Are risks identified at both phase and cross-phase level?
- [ ] Is the integration strategy clear?
- [ ] Are success criteria measurable?

---

**Next Step:** Please review this master plan and all sub-plans. When you're ready, run `/para:execute --phase=1` to begin the first phase.
