# Plan: Smart Context Loading with Relevant File Tracking

**Plan Key:** CONTEXT-001
**Date:** 2026-01-07
**Status:** In Review

---

## Objective

Enhance the PARA workflow to track and auto-load only relevant files for each plan key, reducing token usage and improving Claude's effectiveness through focused context. Support multi-repo work scenarios where a Claude Code session spans multiple repositories.

## Approach

### 1. Hybrid Storage Model
Store relevant file paths in **both** locations:
- **Plan files** declare what files they need (source of truth at creation)
- **context.md** aggregates and maintains the current state (runtime source of truth)

This provides:
- **Traceability**: Plan files document original intent
- **Flexibility**: context.md can be updated as work evolves
- **Low entropy**: Minimal redundancy, clear ownership

### 2. Multi-Repo Support
Add repository mapping to support work across multiple repos when Claude Code is opened from a parent directory:

```json
{
  "active_context": {
    "CONTEXT-001": {
      "repos": ["para-programming-plugin"],
      "files": [
        "para-programming-plugin/resources/CLAUDE.md",
        "para-programming-plugin/commands/plan.md"
      ],
      "plans": [
        "context/plans/2026-01-07-CONTEXT-001-smart-context-loading.md"
      ]
    }
  }
}
```

### 3. Smart Detection Mechanism
Plugin automatically detects active plan key from:
1. Most recent message mentioning a plan key
2. Current git branch name (if contains plan key)
3. Last active plan key from context.md
4. Explicit user specification with `/para-focus <plan-key>`

Once detected, plugin:
1. Reads `active_context` for that plan key
2. Resolves all file paths (handling multi-repo)
3. Injects minimal, relevant context into Claude's window
4. Updates context automatically as conversation evolves

## Implementation Steps

### Phase 1: Extend Context Structure

**Files to modify:**
- `resources/CLAUDE.md` - Document new active_context format
- `templates/plan-template.md` - Add "Relevant Files" section
- `commands/plan.md` - Update to populate relevant files

**New active_context structure:**
```json
{
  "active_context": {
    "<plan-key>": {
      "repos": ["<repo-name>", ...],
      "files": [
        "<repo-name>/path/to/file1",
        "<repo-name>/path/to/file2"
      ],
      "plans": [
        "context/plans/YYYY-MM-DD-<plan-key>-description.md"
      ],
      "data": [
        "context/data/YYYY-MM-DD-<plan-key>-data.json"
      ]
    }
  }
}
```

**Plan file additions:**
```markdown
## Relevant Files

### Repositories
- `para-programming-plugin` - Main plugin codebase

### Files to Track
- `para-programming-plugin/resources/CLAUDE.md` - Global workflow guide
- `para-programming-plugin/commands/plan.md` - Plan command documentation
- `para-programming-plugin/templates/plan-template.md` - Plan template

### Rationale
[Why these files are relevant to this plan]
```

### Phase 2: Smart Detection Logic

**New command: `/para-focus <plan-key>`**
- Explicitly sets the active plan key for the session
- Loads relevant context immediately
- Updates context.md with focus timestamp

**Detection priority:**
1. Explicit `/para-focus <plan-key>` command
2. Plan key mentioned in last N messages (scan conversation)
3. Git branch name parsing (e.g., `feature/CONTEXT-001-...`)
4. Last updated plan key in context.md
5. Prompt user to select from active plans

**Context injection points:**
- Before every Claude Code command execution
- When plan key focus changes
- When user explicitly requests with `/para-load`

### Phase 3: Plugin Context Management

**New MCP tools needed:**
1. `para_get_active_context(plan_key)` - Returns relevant files for a plan key
2. `para_detect_plan_key()` - Detects current plan key from context
3. `para_inject_context(plan_key)` - Injects relevant files into Claude's context
4. `para_update_context(plan_key, files)` - Updates tracked files for a plan key

**Smart features:**
1. **Auto-expansion**: If a file references another file (e.g., import), optionally include it
2. **Token budgeting**: Limit total context to configurable threshold (e.g., 50k tokens)
3. **Prioritization**: If over budget, prioritize files by relevance (plan > recently modified > others)
4. **Incremental loading**: Load full files initially, then only diffs on subsequent loads

### Phase 4: Multi-Repo Resolution

**Repo detection:**
- Scan current working directory for git repositories
- Build repo map: `{repo_name: absolute_path}`
- Resolve relative paths like `repo-name/path/to/file` to absolute paths

**Path resolution rules:**
```
para-programming-plugin/src/index.ts
  → /Users/user/dev/parent-dir/para-programming-plugin/src/index.ts

another-repo/README.md
  → /Users/user/dev/parent-dir/another-repo/README.md
```

**Error handling:**
- If repo not found, warn user and skip that file
- If file not found, warn user and skip that file
- Log all resolution issues to debug context loading

## Risks & Edge Cases

### Risk 1: Stale file lists
**Mitigation:**
- Add `/para-sync <plan-key>` command to rescan and update file list
- Plugin periodically validates that tracked files still exist
- Auto-remove deleted files from active_context

### Risk 2: Token budget exceeded
**Mitigation:**
- Implement token counting before injection
- Prioritize files: plans > data > source files
- Allow user to configure max tokens per plan key
- Provide `/para-context-stats` to show token usage

### Risk 3: Multi-repo path confusion
**Mitigation:**
- Always use `repo-name/` prefix in file paths
- Validate repo exists before adding to active_context
- Provide clear error messages when repo not found

### Risk 4: Detection ambiguity
**Mitigation:**
- Always prefer explicit `/para-focus` over auto-detection
- Show detected plan key to user for confirmation
- Allow user to override with `/para-focus <different-key>`

### Risk 5: Plan file vs context.md sync
**Mitigation:**
- context.md is always source of truth at runtime
- Plan files are documentation of original intent
- Provide `/para-reconcile` to sync plan file → context.md

## Data Sources

### Existing Files
- `resources/CLAUDE.md` - Current context.md structure
- `commands/plan.md` - Current plan command behavior
- `templates/plan-template.md` - Current plan template
- PR #3 - Recent plan key changes

### New Files to Create
- `commands/focus.md` - Documentation for `/para-focus` command
- `commands/sync.md` - Documentation for `/para-sync` command
- `commands/load.md` - Documentation for explicit context loading
- `context/servers/context-manager.ts` - MCP tool for context management

## MCP Tools

### To Implement
- `context/servers/context-manager.ts` - Core context loading/detection logic
  - Detect active plan key from conversation
  - Load relevant files from active_context
  - Inject into Claude's context window
  - Handle multi-repo path resolution

- `context/servers/repo-scanner.ts` - Multi-repo detection
  - Scan parent directory for git repos
  - Build repo map
  - Validate repo references

## Success Criteria

- [ ] active_context structure supports files, repos, plans, and data arrays
- [ ] Plan template includes "Relevant Files" section with repo and file tracking
- [ ] Smart detection successfully identifies plan key from conversation context
- [ ] Context injection works before Claude Code commands
- [ ] Multi-repo path resolution correctly maps `repo-name/path` to absolute paths
- [ ] Token counting prevents context overflow
- [ ] `/para-focus <plan-key>` command explicitly sets active context
- [ ] `/para-sync <plan-key>` validates and updates file lists
- [ ] Documentation updated in resources/CLAUDE.md with new structure
- [ ] Examples demonstrate multi-repo scenarios

## Token Efficiency Goals

**Current state:** Claude receives entire conversation history + any manually loaded files

**Target state:** Claude receives:
- Current conversation (unavoidable)
- Only files relevant to active plan key (10-50 files typical)
- Token budget: ~20-50k tokens for context files
- 50-80% reduction in irrelevant context

**Benefits:**
- More focused responses
- Faster response times
- Lower cost per session
- Better reasoning with smaller, relevant context

## Review Checklist

- [ ] Does the hybrid storage model (plan files + context.md) make sense?
- [ ] Is the smart detection approach clear and achievable?
- [ ] Are the multi-repo path resolution rules reasonable?
- [ ] Is the token budgeting approach sound?
- [ ] Are the new commands (`/para-focus`, `/para-sync`) intuitive?
- [ ] Does this align with the overall PARA methodology?
- [ ] Are there any security concerns with auto-loading files?

---

**Next Step:** Please review this plan. Does it align with your vision for smart context loading and multi-repo support? Any adjustments needed before execution?
