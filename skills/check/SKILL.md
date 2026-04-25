---
name: check
description: Decision helper to determine if PARA workflow should be used for a given request
model: haiku
effort: low
---

Decision helper to determine if PARA workflow should be used for a given request.

## Usage

```
/para:check "Add user authentication to the API"
/para:check "Where is the auth middleware defined?"
```

## Decision Logic

```
Does this request require code/file changes?
├─ YES → USE PARA (Plan → Review → Execute → Summarize → Archive)
└─ NO  → SKIP PARA
         ├─ About project code? → Direct answer with file references
         └─ General question?   → Standard response
```

## Output Format

Display a short verdict with reasoning:

```
PARA Workflow Check

Request: "Add user authentication to the API"

  USE PARA WORKFLOW

Reason: This request requires code changes and file modifications.
Next: Run /para:plan to create an implementation plan.
```

For skip cases, replace with "SKIP PARA" and suggest providing a direct answer instead.
