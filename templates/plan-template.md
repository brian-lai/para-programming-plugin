# Plan: {TASK_NAME}

**Date:** {DATE}
**Status:** In Review

---

## Objective

[Clear statement of what needs to be accomplished]

## Core Principles

1. **[Principle 1].** [One-sentence explanation]
2. **[Principle 2].** [One-sentence explanation]
3. **[Principle 3].** [One-sentence explanation]

[3-6 principles that guide implementation decisions. These should be opinionated and specific to this task, not generic software engineering truisms.]

## Architecture Decisions

| Decision | Choice | Rationale | Alternatives Rejected |
|----------|--------|-----------|----------------------|
| [Decision 1] | [What was chosen] | [Why] | [What was considered and why it lost] |
| [Decision 2] | [What was chosen] | [Why] | [What was considered and why it lost] |

## Interface Boundaries

[Every cross-system, cross-module, or cross-layer boundary that this plan introduces or modifies. Each boundary needs a defined contract. Include when applicable — omit for simple tasks with no cross-boundary changes.]

### {Boundary 1 Name}

**Between:** [System A] and [System B]
**Contract:** [Interface definition, API spec path, message schema, or shared type]

```
[Contract sketch — function signature, type definition, or API shape]
```

## Graceful Degradation

[Include when the task involves external dependencies. Omit for purely internal changes.]

| Failure Scenario | Expected Behavior |
|-----------------|-------------------|
| [External dependency 1] unavailable | [What the system does — error message, fallback, retry policy] |
| [External dependency 2] times out | [What the system does] |

## Implementation Steps

> Each checklist item below maps to one git commit. The checkbox text is the commit message.
> Tests come BEFORE the implementation they cover (TDD).

- [ ] **Write contract tests for {boundary}**
  - [Sub-task]
  - **Tests:** `TestContractName` — [what it asserts]

- [ ] **Write acceptance test skeleton**
  - [Sub-task]
  - **Tests:** `TestAcceptanceName` — [stays red until step N]

- [ ] **Implement {component}**
  - [Sub-task]
  - [Sub-task]
  - **Makes green:** [Which contract tests now pass]

- [ ] **Implement {component}**
  - [Sub-task]
  - [Sub-task]
  - **Makes green:** [Which tests now pass, including acceptance test]

## Risks & Edge Cases

- **Risk 1:** [Description and mitigation]
- **Risk 2:** [Description and mitigation]

## Success Criteria

- [ ] [Criterion 1]
- [ ] [Criterion 2]
- [ ] [Criterion 3]
- [ ] All tests written and passing

## Testing Strategy

### Contract Tests (Written FIRST)

[Contract tests for every interface boundary defined above. These are written before any implementation.]

```
[Test suite sketch — function signatures, test case names, key assertions]
```

### Unit Tests

[Unit tests for business logic and pure functions.]

- `TestFunctionA` — [what it verifies]
- `TestFunctionB` — [what it verifies]

### Integration Tests

[Tests that verify components work together with real dependencies.]

- `TestIntegrationScenario1` — [what it verifies]
- `TestIntegrationScenario2` — [what it verifies]

### Acceptance Test

[One or more end-to-end tests that verify the feature works from the user's perspective. Written as a skeleton on day 1 — stays red until implementation is complete.]

```
[Test skeleton — compiles/parses but assertions fail]
```

## Review Checklist

- [ ] Does this approach align with project architecture?
- [ ] Are all interface boundaries identified with defined contracts?
- [ ] Is there a contract test for every interface boundary?
- [ ] Are all edge cases considered?
- [ ] Is graceful degradation defined for every external dependency?
- [ ] Is there an over-engineering check — are we building only what's needed?
- [ ] Do tests come before implementation in the step ordering (TDD)?
- [ ] Is observability addressed (logging with correlation IDs, monitoring)?
- [ ] Is the scope appropriate (not too large)?
- [ ] Are success criteria measurable?

---

**Next Step:** Please review this plan. When you're ready, run `/para:execute` to begin implementation.
