---
name: research
description: Perform deep codebase exploration and produce a context-compressed research document
model: opus
effort: high
---

Perform deep codebase exploration and produce a context-compressed research document. This document becomes the primary input for `/para:plan`.

## Usage

```
/para:research [task-description]
/para:research --scope=frontend    # Focus research on a specific area
/para:research --specs             # Emphasize API contract analysis
```

If no task description is provided, Claude will ask for one.

## What It Does

1. **Clarify focus** — if the task description is broad or ambiguous, use **AskUserQuestion** to clarify scope, depth, and any specific concerns before proceeding. Skip if the task is narrow and well-defined.

2. **Deep codebase exploration** — perform thorough investigation across the relevant area:
   - File structure and organization across the relevant area
   - Key interfaces and contracts (OpenAPI specs, TypeScript interfaces, Protobuf, shared types)
   - Test patterns, test coverage, and test framework conventions
   - Dependency map for affected components (what depends on what)
   - Error handling and graceful degradation patterns
   - Logging and observability patterns

3. **API contract analysis** — if the project has OpenAPI/Swagger specs, interface files, or shared type definitions:
   - Parse specs and cross-reference with actual implementation
   - Flag any inconsistencies between spec and implementation
   - Document the canonical source of truth for each contract

4. **Pattern recognition** — identify conventions, idioms, and anti-patterns that should inform planning:
   - How errors are handled and propagated
   - How dependencies are injected or wired
   - How config is managed (env vars, config files, feature flags)
   - Naming conventions, file organization patterns

5. **Produce research document** — write findings to `context/data/YYYY-MM-DD-task-name-research.md` using the template from `research-template.md`. The document should be:
   - **High-signal, low-noise** — include what matters for planning, not exhaustive file listings
   - **Structured for context compression** — a planner reading only this document should have sufficient context to create a detailed plan
   - **Honest about gaps** — explicitly call out what's undocumented, inconsistent, or surprising

6. **Update context** — add the research doc path to `context/context.md`'s `research_docs` array.

7. **Suggest next step** — recommend running `/para:plan`, noting the research doc is available as input.

## Options

### `--scope=<area>`

Focus research on a specific area of the codebase (e.g., `frontend`, `api`, `auth`, `database`). Without this flag, research covers the entire codebase relevant to the task description.

### `--specs`

Emphasize API contract analysis. Spend more effort on finding, parsing, and cross-referencing OpenAPI specs, interface definitions, and shared types. Useful when the task involves integration work or API changes.

## Research Quality Criteria

The research document should pass this test: **Could a Staff+ engineer read this document and create a detailed implementation plan without additional codebase exploration?**

If the answer is no, the research is not deep enough. Specifically:

- Every component mentioned should include its key files, public API, and dependencies
- Every interface boundary should have its contract documented
- Patterns should be described with concrete examples (file paths, function names), not vague descriptions
- Gaps and inconsistencies should be specific and actionable

## Context Update

After producing the research document, update `context/context.md`:

```json
{
  "research_docs": ["context/data/YYYY-MM-DD-task-name-research.md"],
  "last_updated": "{ISO timestamp}"
}
```

If `research_docs` doesn't exist in the metadata, add it.

## Example

```
User: /para:research rewrite-auth-middleware

Claude: [Uses Explore agent to deeply investigate auth-related code]
[Discovers existing middleware, session handling, token storage, OAuth flow]
[Cross-references OpenAPI spec with actual endpoints]
[Finds inconsistency: spec says JWT, implementation uses opaque tokens]

Creates: context/data/2025-12-18-rewrite-auth-middleware-research.md

Key findings:
- Auth middleware in src/middleware/auth.ts (450 lines, no tests)
- Session tokens stored in Redis with 24h TTL
- OpenAPI spec and implementation disagree on token format
- No graceful degradation when Redis is unavailable

Suggest running /para:plan to create an implementation plan using this research.
```

## Notes

- Research is optional but strongly recommended for non-trivial tasks
- The research doc lives in `context/data/` alongside specs and other input files
- `/para:plan` automatically checks for research docs and uses them as primary input
- Research docs should be treated as snapshots — they may become stale as the codebase changes
