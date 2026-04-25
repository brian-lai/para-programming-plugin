---
name: plan
description: Create a planning document through collaborative dialogue, with support for multi-phase plans
model: opus
effort: high
disable-model-invocation: true
---

Create a planning document through collaborative dialogue, with support for multi-phase plans.

## Usage

```
/para:plan [task-description]
```

If no task description is provided, Claude will ask for one.

## Collaborative Planning Process

**Planning is a dialogue, not a one-shot generation.**

When `/para:plan` is invoked:

1. **Identify ambiguities** in the task description -- scope, approach, constraints, preferences.

2. **Ask 1-4 clarifying questions** using **AskUserQuestion** before doing anything else:
   - Present options with trade-offs clearly explained
   - Reference existing codebase patterns when relevant ("I see you use X elsewhere, should we follow that?")
   - Skip only if ALL of these are true: task is very narrow, only one reasonable approach exists, no risk of breaking changes, user gave extremely detailed requirements.

3. **Check for research doc.** If a research document exists (`context/data/YYYY-MM-DD-task-name-research.md`), use it as primary input for steps 4-6. If no research doc exists for a non-trivial task, suggest running `/para:research` first.

4. **Explore the codebase** with clarifications in hand -- identify:
   - Existing patterns, conventions, and affected components
   - Complexity and existing test patterns (test framework, test file locations, naming conventions)
   - **Interface boundaries between systems** (APIs, message formats, shared types, database schemas used across modules)
   - **Existing graceful degradation patterns** (how the codebase currently handles external dependency failures, timeouts, retries)

5. **Draft spec + stubs:**
   - Create a spec file in `context/data/YYYY-MM-DD-task-name-spec.yaml` (OpenAPI/Swagger YAML for HTTP APIs; TypeScript interface file or markdown contract for UI components, modules, and scripts)
   - Create stub source files in the project tree with signatures matching the spec but no implementation (return `null`, `{}`, or `501 Not Implemented` as appropriate)
   - Reference the spec and stub file paths in the plan

6. **Determine plan type:**
   - **Simple plan** (single file) unless any of the following apply:
   - **Phased plan** (master + sub-plans) when at least one trigger is met:
     1. More than 5 files with cross-file refactoring (not just independent edits to many files)
     2. Work spans 2 or more architectural layers (e.g., API + UI + DB)
     3. Later work requires earlier work to be **merged** to `main` — not just complete — before it can begin (dependency chain)
   - If none of these triggers apply, use a simple plan. If proposing a phased plan, confirm with the user first.

7. **Draft the plan** applying Staff+ engineering criteria:
   - **Think about what NOT to build.** Explicitly state what is deferred or out of scope and why. Resist over-engineering -- if a simple approach works, prefer it and document the rationale.
   - **Identify interface boundaries.** Every boundary between systems, modules, or layers needs a defined contract (API spec, message schema, shared type, or interface definition). List each boundary and its contract.
   - **Address graceful degradation.** For every external dependency (databases, APIs, queues, third-party services), document what happens when it fails. Fill in a Failure Scenario / Expected Behavior table.
   - **Include observability.** Specify what gets logged (with correlation IDs), what gets metered or monitored, and what alerts should fire. Every cross-boundary call should be traceable.
   - **Document architecture decisions as a table:** Decision | Choice | Rationale | Alternatives Rejected. This makes trade-offs explicit and reviewable.
   - **Concrete test annotations on every implementation step.** Each step must have a `Tests:` annotation with specific function signatures, test case names, and key assertions -- not vague descriptions like "test the API".
   - **Checklist = commit.** Every implementation step MUST be written as a checkbox item (`- [ ] ...`) where the text serves as the git commit message. Keep items atomic -- one logical change per item.

8. **Self-review loop (2-3 rounds).** Before presenting the plan to the user, re-read the entire plan and revise it. This is NOT optional for any plan that spans more than 2-3 files.

   **Round 1 -- Correctness & Completeness:**
   - Are there technical bugs in the approach (wrong API usage, missing adapters, race conditions)?
   - Are any interface boundaries missing their contract definition?
   - Is anything over-engineered (building abstractions that aren't needed yet)?
   - Is anything under-engineered (hardcoding something that will immediately need to change)?
   - Are all file paths accurate and consistent across the plan?

   **Round 2 -- Testing & TDD:**
   - Do tests come BEFORE implementation in the ordering? (Contract tests and acceptance test skeleton should be written first.)
   - Is there a contract test suite for every interface boundary?
   - Is there an E2E acceptance test defined on day 1 (even if it stays red until later phases)?
   - Does the progressive regression rule make sense? (Which test suites go green at each step/phase?)
   - Are test annotations concrete (function signatures, test names, key assertions) rather than vague?

   **Round 3 (conditional) -- Consistency & Cross-references:**
   Run this round ONLY if Rounds 1 and 2 together produced more than 3 substantive changes to the plan.
   - Are all file paths, type names, and function signatures consistent between the master plan and sub-plans?
   - Does the progressive regression rule match the actual test suites defined?
   - Are architecture decisions reflected accurately in both the master plan tables and sub-plan implementation steps?

   **Convergence rule:** Stop self-review when a round produces fewer than 3 substantive edits. A "substantive edit" is a change to logic, structure, contracts, or test coverage -- not a typo fix or wording improvement.

9. **Present the plan** to the user for review. Note how many self-review rounds were completed and summarize the key changes made during self-review (e.g., "Self-review completed (2 rounds). Key changes: added missing error handling for Redis connection failures, reordered steps so contract tests come before implementation.").

10. **After the plan is written**, ask the user if they'd like to proceed. Use **AskUserQuestion** with options like:
    - "Run `/para:review --plan` for Staff+ review" -- independent subagent review before execution
    - "Yes, run `/para:execute`" -- proceed directly to implementation
    - "I'd like to make adjustments first" -- continue refining the plan
    For phased plans, the prompt should reference `/para:execute --phase=1` to start with the first phase.

## Plan Structure

### Simple Plan

File: `context/plans/YYYY-MM-DD-task-name.md`
Simple plans use the template at `plan-template.md`.

Sections:
- **Objective** -- what needs to be done
- **Core Principles** -- 3-6 engineering principles guiding the implementation
- **Spec** -- path to spec file (`context/data/YYYY-MM-DD-task-name-spec.yaml` or equivalent) and what it covers
- **Stubs** -- list of stub source files to be created and their locations
- **Architecture Decisions** -- table: Decision | Choice | Rationale | Alternatives Rejected
- **Interface Boundaries** -- every cross-system boundary with its contract
- **Graceful Degradation** -- table: Failure Scenario | Expected Behavior
- **Implementation Steps** -- checklist items (`- [ ] ...`) where each item is a commit message, with per-step `Tests:` annotations
- **Risks** -- potential issues and edge cases
- **Success Criteria** -- measurable outcomes
- **Testing Strategy** -- Contract Tests (written FIRST), Unit Tests, Integration Tests, Acceptance Test

### Phased Plan

Files:
- `context/plans/YYYY-MM-DD-task-name.md` — master plan using `phased-plan-master-template.md` (architecture-only reference document with core principles, architecture decisions, responsibility split, graceful degradation, progressive regression rule)
- `context/plans/YYYY-MM-DD-task-name-phase-1.md` — sub-plan using `phased-plan-sub-template.md` (self-contained implementation-ready sub-plan with TDD ordering)
- `context/plans/YYYY-MM-DD-task-name-phase-2.md`
- etc.

The master plan should be kept concise (1-3 pages) and never contain implementation steps. Each sub-plan should be independently executable -- someone should be able to work from a sub-plan without needing to read the master plan.

Each phase should be independently reviewable and mergeable.

## Context Update

After creating the plan, update `context/context.md`:
- Add plan file(s) to `active_context` array
- For phased plans, add `phased_execution` metadata with phase status tracking. See `../init/context-schema.md` for the full `phased_execution` field reference. Note: `branch` and `worktree_path` are set to `null` at plan time. They are populated by `/para:execute` when a phase begins execution.
- Update `last_updated` timestamp

## Example

```
User: /para:plan add-caching-layer

Claude: I'd like to clarify a few things before creating the plan:

[Uses AskUserQuestion with 2-3 questions about:]
- Cache backend preference (Redis, Memcached, in-memory)
- Scope (which data to cache, TTL strategy)
- Invalidation strategy (time-based, event-based, manual)

[After receiving answers, explores codebase, then creates plan]
[Runs 2 rounds of self-review, fixes test ordering and adds missing degradation scenario]

Creates: context/plans/2025-12-18-add-caching-layer.md
```

## Notes

- All project work MUST start with a plan (per PARA workflow)
- Master plans should be concise (1-3 pages); sub-plans should be self-contained and implementation-ready
- Don't ask questions you could answer by reading the codebase
- Bias towards 2-4 focused questions, not 10+ scattered ones
- Complex plans undergo 2-3 automatic self-review rounds before being presented for human review
