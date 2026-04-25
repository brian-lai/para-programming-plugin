# context.md JSON Schema Reference

`context/context.md` is the master tracking file for every PARA session. It contains a human-readable summary followed by a fenced JSON metadata block. This document is the canonical reference for every field that may appear in that JSON block.

---

## Field Reference

### Top-Level Fields

| Field | Type | Required | Description |
|---|---|---|---|
| `active_context` | `string[]` | Yes | Paths to active plan files (e.g., `context/plans/YYYY-MM-DD-task-name.md`). Empty when idle. |
| `research_docs` | `string[]` | No | Paths to research documents produced by `/para:research`. |
| `completed_summaries` | `string[]` | Yes | Paths to summary files from completed work. Carried forward across archives. |
| `worktree_path` | `string \| null` | No | Path to the active git worktree (e.g., `.para-worktrees/task-name`). Set during simple-plan execution; `null` or absent when idle. |
| `execution_branch` | `string` | No | Git branch name for the current execution (e.g., `para/task-name`). Set during execution. |
| `execution_started` | `string` | No | ISO 8601 timestamp marking when execution began. |
| `phased_execution` | `object` | No | Present only for phased (multi-phase) plans. See Phased Execution Fields below. |
| `workflow` | `object` | No | Present only when `/para:workflow` is actively orchestrating. See Workflow Fields below. |
| `last_updated` | `string` | Yes | ISO 8601 timestamp of the most recent metadata update. |

### Phased Execution Fields (`phased_execution`)

| Field | Type | Description |
|---|---|---|
| `master_plan` | `string` | Path to the master plan file. |
| `phases` | `object[]` | Array of phase entries (see below). |
| `current_phase` | `number \| null` | Phase number currently being executed, or `null` if no phase is active. |
| `staff_review` | `string` | Optional. Summary of Staff+ review status (e.g., `"APPROVED (2 rounds)"`). |

### Phase Entry Fields (`phased_execution.phases[]`)

| Field | Type | Description |
|---|---|---|
| `phase` | `number` | Phase number (1-indexed). |
| `plan` | `string` | Path to this phase's sub-plan file. |
| `status` | `string` | One of: `"pending"`, `"in_progress"`, `"completed"`. |
| `branch` | `string \| null` | Git branch name for this phase. `null` until execution begins. |
| `worktree_path` | `string \| null` | Worktree directory for this phase. `null` until execution begins. |

### Workflow Fields (`workflow`)

| Field | Type | Description |
|---|---|---|
| `mode` | `string` | One of: `"default"`, `"auto"`. |
| `current_step` | `string` | One of: `"execute"`, `"pr"`, `"review"`, `"summarize"`, `"merge"`, `"archive"`. |
| `current_phase` | `number` | Phase number the workflow is currently processing. |
| `phases_completed` | `number[]` | Phase numbers that have been fully completed. |
| `started` | `string` | ISO 8601 timestamp of when the workflow began. |

---

## Examples

### Idle (fresh init or post-archive)

```json
{
  "active_context": [],
  "completed_summaries": [],
  "last_updated": "2026-01-15T10:00:00Z"
}
```

### Simple-Plan Execution

```json
{
  "active_context": [
    "context/plans/2026-01-15-add-caching-layer.md"
  ],
  "research_docs": [
    "context/data/2026-01-15-add-caching-layer-research.md"
  ],
  "completed_summaries": [],
  "execution_branch": "para/add-caching-layer",
  "worktree_path": ".para-worktrees/add-caching-layer",
  "execution_started": "2026-01-15T11:30:00Z",
  "last_updated": "2026-01-15T11:30:00Z"
}
```

### Phased Execution

```json
{
  "active_context": [
    "context/plans/2026-01-20-auth-rewrite.md",
    "context/plans/2026-01-20-auth-rewrite-phase-2.md"
  ],
  "research_docs": [
    "context/data/2026-01-20-auth-rewrite-research.md"
  ],
  "completed_summaries": [
    "context/summaries/2026-01-20-auth-rewrite-phase-1-summary.md"
  ],
  "phased_execution": {
    "master_plan": "context/plans/2026-01-20-auth-rewrite.md",
    "phases": [
      { "phase": 1, "plan": "context/plans/2026-01-20-auth-rewrite-phase-1.md", "status": "completed", "branch": "para/auth-rewrite-phase-1", "worktree_path": ".para-worktrees/auth-rewrite-phase-1" },
      { "phase": 2, "plan": "context/plans/2026-01-20-auth-rewrite-phase-2.md", "status": "in_progress", "branch": "para/auth-rewrite-phase-2", "worktree_path": ".para-worktrees/auth-rewrite-phase-2" },
      { "phase": 3, "plan": "context/plans/2026-01-20-auth-rewrite-phase-3.md", "status": "pending", "branch": null, "worktree_path": null }
    ],
    "current_phase": 2,
    "staff_review": "APPROVED (2 rounds)"
  },
  "workflow": {
    "mode": "auto",
    "current_step": "execute",
    "current_phase": 2,
    "phases_completed": [1],
    "started": "2026-01-20T09:00:00Z"
  },
  "last_updated": "2026-01-21T14:00:00Z"
}
```
