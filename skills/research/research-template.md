# Research: {TASK_NAME}

**Date:** {DATE}
**Status:** Draft | Complete
**Scope:** [Full codebase | Focused on {area}]
**Focus:** [What we're researching and why — the task or area of the codebase being analyzed]

---

## High-Level Architecture

[System overview discovered from code. Include major components, their responsibilities, and how they connect.]

```
[ASCII diagram showing major components and data flow]
```

---

## Relevant Components

[Detailed analysis of each component that will be affected by the planned work.]

### {Component 1 Name}

- **Purpose:** [What it does]
- **Key files:** `path/to/file.ext`, `path/to/other.ext`
- **Public API / Interface:** [Key functions, endpoints, or exported types]
- **Dependencies:** [What it depends on — other components, external services, libraries]
- **Test coverage:** [Test file locations, framework used, coverage level]

### {Component 2 Name}

- **Purpose:** [What it does]
- **Key files:** `path/to/file.ext`
- **Public API / Interface:** [Key functions, endpoints, or exported types]
- **Dependencies:** [What it depends on]
- **Test coverage:** [Test file locations, framework used, coverage level]

---

## API Contracts

[Existing OpenAPI specs, interface definitions, message schemas, shared types discovered in the codebase.]

### {Contract 1 Name}

- **Location:** `path/to/spec.yaml` or `path/to/types.ts`
- **Type:** [OpenAPI / TypeScript interface / Protobuf / JSON Schema / etc.]
- **Covers:** [What endpoints or interactions it defines]
- **Spec-implementation consistency:** [Match / Mismatch — if mismatch, describe the divergence]

---

## Existing Patterns

[Conventions, patterns, and idioms used in the codebase. These should inform the plan.]

- **Error handling:** [How errors are caught, propagated, and reported]
- **Logging:** [Framework, log levels, correlation IDs, structured vs. unstructured]
- **Testing:** [Framework, file naming, fixture patterns, mocking approach]
- **Dependency injection:** [How dependencies are wired — constructor injection, modules, global state]
- **Config management:** [Environment variables, config files, feature flags]

---

## Graceful Degradation

[How the codebase currently handles external dependency failures.]

| External Dependency | Failure Handling |
|--------------------|-----------------|
| [Database] | [What happens — retry, circuit breaker, error message, fallback] |
| [External API] | [What happens] |
| [Cache] | [What happens] |

---

## Gaps & Inconsistencies

[Anything discovered that doesn't match up, is undocumented, or is surprising. These are important inputs for planning.]

- [Gap/inconsistency 1 — description and impact]
- [Gap/inconsistency 2 — description and impact]

---

## Recommendations

[Initial observations that should inform the plan. Not implementation steps — just directional guidance.]

- [Recommendation 1]
- [Recommendation 2]
- [Recommendation 3]
