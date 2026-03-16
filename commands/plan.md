# Command: plan

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

3. **Explore the codebase** with clarifications in hand -- identify patterns, conventions, affected components, complexity, and existing test patterns (test framework, test file locations, naming conventions).

4. **Draft spec + stubs:**
   - Create a spec file in `context/data/YYYY-MM-DD-task-name-spec.yaml` (OpenAPI/Swagger YAML for HTTP APIs; TypeScript interface file or markdown contract for UI components, modules, and scripts)
   - Create stub source files in the project tree with signatures matching the spec but no implementation (return `null`, `{}`, or `501 Not Implemented` as appropriate)
   - Reference the spec and stub file paths in the plan

5. **Determine plan type:**
   - **Simple plan** (single file) for straightforward tasks
   - **Phased plan** (master + sub-plans) when work spans >5-10 files, crosses architectural boundaries, or has natural dependency ordering
   - If proposing a phased plan, confirm with the user first.

6. **Draft the plan** and request human review.
   - Every implementation step MUST include a `Tests:` annotation specifying what tests to write
   - Include a Testing Strategy section with concrete, specific tests (not generic placeholders)
   - Tests should reference actual functions, modules, and behaviors from the codebase

7. **After the plan is written**, ask the user if they'd like to proceed to implementation by running `/para:execute`. Use **AskUserQuestion** with options like:
   - "Yes, run `/para:execute`" — proceed to implementation
   - "I'd like to make adjustments first" — continue refining the plan
   For phased plans, the prompt should reference `/para:execute --phase=1` to start with the first phase.

## Plan Structure

### Simple Plan

File: `context/plans/YYYY-MM-DD-task-name.md`

Sections:
- **Objective** -- what needs to be done
- **Spec** -- path to spec file (`context/data/YYYY-MM-DD-task-name-spec.yaml` or equivalent) and what it covers
- **Stubs** -- list of stub source files to be created and their locations
- **Approach** -- step-by-step methodology
- **Risks** -- potential issues and edge cases
- **Success Criteria** -- measurable outcomes
- **Testing Strategy** -- unit tests, integration tests, manual verification

### Phased Plan

Files:
- `context/plans/YYYY-MM-DD-task-name.md` (master plan: overall objective, phase breakdown, cross-phase risks, integration strategy)
- `context/plans/YYYY-MM-DD-task-name-phase-1.md` (detailed implementation steps, phase-specific risks, files to modify, independently verifiable success criteria)
- `context/plans/YYYY-MM-DD-task-name-phase-2.md`
- etc.

Each phase should be independently reviewable and mergeable. Sub-plan implementation steps must include per-step `Tests:` annotations specifying what to test.

## Context Update

After creating the plan, update `context/context.md`:
- Add plan file(s) to `active_context` array
- For phased plans, add `phased_execution` metadata with phase status tracking:
  ```json
  {
    "phased_execution": {
      "master_plan": "context/plans/YYYY-MM-DD-task-name.md",
      "phases": [
        { "phase": 1, "plan": "context/plans/YYYY-MM-DD-task-name-phase-1.md", "status": "pending", "branch": null, "worktree_path": null },
        { "phase": 2, "plan": "context/plans/YYYY-MM-DD-task-name-phase-2.md", "status": "pending", "branch": null, "worktree_path": null }
      ],
      "current_phase": null
    }
  }
  ```

Note: `branch` and `worktree_path` are set to `null` at plan time. They are populated by `/para:execute` when a phase begins execution.
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

Creates: context/plans/2025-12-18-add-caching-layer.md
```

## Notes

- All project work MUST start with a plan (per PARA workflow)
- Master plans should be concise (1-2 pages); sub-plans should be implementation-ready
- Don't ask questions you could answer by reading the codebase
- Bias towards 2-4 focused questions, not 10+ scattered ones
