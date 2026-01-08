# Plan: Pragmatic Context Management with Helper Scripts

**Plan Key:** CONTEXT-001
**Date:** 2026-01-07
**Status:** In Review - REVISED

---

## 🔄 Plan Revision Note

**Original approach:** Document speculative "smart detection" and "auto-injection" features for a plugin that doesn't exist yet.

**Revised approach:** Build simple, testable bash scripts that help users manage relevant files for each plan key, working within Claude Code's existing capabilities.

**Why the pivot:**
- Claude Code already has access to all files - the issue is knowing *which* files to read
- We can't "inject" files into Claude's context from outside
- Documentation became 1,132 lines with speculative features
- Need deterministic, testable tools, not aspirational documentation

---

## Objective

Create practical helper scripts that:
1. Parse `context.md` to find files for a given plan key
2. Validate those files exist
3. Help Claude load the right files efficiently
4. Support multi-repo scenarios with clear path conventions

## Approach

### 1. Keep What Works (Already Built)
✅ **Enhanced `active_context` structure:**
```json
{
  "active_context": {
    "PLAN-123": {
      "repos": ["repo-name"],
      "files": ["repo-name/path/to/file.ts"],
      "plans": ["context/plans/..."],
      "data": ["context/data/..."]
    }
  }
}
```

✅ **"Relevant Files" section in plan template** - Documents which files matter

✅ **File path convention:** `repo-name/path/to/file` for multi-repo clarity

### 2. Build Simple Scripts (New)

Create **deterministic, testable bash scripts** in `context/servers/`:

#### Script 1: `para-list-files.sh`
```bash
#!/bin/bash
# Usage: para-list-files.sh <plan-key>
# Output: List of file paths for the plan key

PLAN_KEY=$1
# Parse context/context.md JSON
# Extract active_context.$PLAN_KEY.files[]
# Output each file path
```

#### Script 2: `para-validate-files.sh`
```bash
#!/bin/bash
# Usage: para-validate-files.sh <plan-key>
# Output: Validation results (✅ found, ❌ missing)

PLAN_KEY=$1
# Get files for plan key
# Check if each file exists
# Report missing files
```

#### Script 3: `para-resolve-paths.sh`
```bash
#!/bin/bash
# Usage: para-resolve-paths.sh <plan-key>
# Output: Absolute paths resolved from repo-name/path format

PLAN_KEY=$1
# Scan for git repos in current directory
# Build repo map
# Resolve repo-name/path to absolute paths
# Output absolute paths
```

#### Script 4: `para-generate-prompt.sh`
```bash
#!/bin/bash
# Usage: para-generate-prompt.sh <plan-key>
# Output: A prompt Claude can use to load files

PLAN_KEY=$1
# Get validated, resolved file paths
# Generate: "Please read the following files: X, Y, Z"
# Or: Generate multiple Read tool calls
```

### 3. Simplify Documentation

**Remove from CLAUDE.md (~130 lines):**
- ❌ "Smart detection" 5-level priority system
- ❌ "Auto-injection" mechanics
- ❌ Token budgeting and prioritization details
- ❌ Speculative MCP tool interfaces

**Keep in CLAUDE.md:**
- ✅ Enhanced context structure with repos/files
- ✅ File path convention
- ✅ Basic multi-repo support explanation
- ✅ How to use the helper scripts

**Target:** Reduce CLAUDE.md from 1,132 lines to ~800-900 lines

### 4. Update Command Documentation

**Simplify `/para-focus` (commands/focus.md):**
- Drop: Smart detection, auto-injection, token budgeting
- Keep: Setting active plan key, showing which files to read
- Add: How to use helper scripts

**Create minimal `/para-files` command:**
- Shows files for a plan key
- Runs `para-list-files.sh` internally
- Optionally validates them

## Implementation Steps

### Phase 1: Build Helper Scripts ⚡ NEW
- [ ] Create `context/servers/para-list-files.sh`
- [ ] Create `context/servers/para-validate-files.sh`
- [ ] Create `context/servers/para-resolve-paths.sh`
- [ ] Create `context/servers/para-generate-prompt.sh`
- [ ] Test scripts with current context.md
- [ ] Make scripts executable and document usage

### Phase 2: Simplify Documentation 🧹 NEW
- [ ] Remove speculative "Smart Context Loading" section from CLAUDE.md
- [ ] Add concise "Helper Scripts" section (20-30 lines)
- [ ] Simplify commands/focus.md (remove auto-injection details)
- [ ] Update context structure docs to focus on manual workflow

### Phase 3: Integration & Testing 🔗 NEW
- [ ] Test workflow: Create plan → populate files → use scripts → load files
- [ ] Validate multi-repo path resolution
- [ ] Document actual usage patterns
- [ ] Create examples in quickstart guide

### Phase 4: Optional Enhancements 🎁 FUTURE
- [ ] Script to sync plan "Relevant Files" → context.md
- [ ] Script to add/remove files from a plan key
- [ ] Basic file change detection (git diff)
- [ ] Integration with `/para-execute` to show files at start

## Relevant Files

### Repositories
- `para-programming-plugin` - PARA methodology plugin

### Files to Track
- `para-programming-plugin/resources/CLAUDE.md` - Global workflow (needs simplification)
- `para-programming-plugin/commands/focus.md` - Focus command (needs simplification)
- `para-programming-plugin/context/context.md` - Active context tracker
- `para-programming-plugin/templates/plan-template.md` - Plan template (already good)

### Rationale
These are the key documentation and template files that need updating to reflect the pragmatic approach.

## Success Criteria

**Scripts work:**
- [x] context.md structure supports repos/files/plans/data (already done)
- [x] Plan template has "Relevant Files" section (already done)
- [ ] `para-list-files.sh` extracts files from context.md correctly
- [ ] `para-validate-files.sh` reports which files exist/missing
- [ ] `para-resolve-paths.sh` handles multi-repo scenarios
- [ ] `para-generate-prompt.sh` creates usable prompts

**Documentation is concise:**
- [ ] CLAUDE.md reduced to ~800-900 lines
- [ ] Clear examples of using helper scripts
- [ ] No speculative/unimplemented features documented

**Workflow is practical:**
- [ ] User can create plan with relevant files
- [ ] User can run script to see which files to read
- [ ] Claude can easily load the right files
- [ ] Multi-repo scenarios work

## Benefits of This Approach

### ✅ Immediate Value
- Scripts work today, no waiting for MCP implementation
- Testable and debuggable
- Users can modify/extend scripts easily

### ✅ Fits Claude Code
- Works with existing `Read` tool
- No assumptions about auto-injection
- Claude decides when to load files

### ✅ Maintainable
- Simple bash scripts (~50 lines each)
- Easy to understand and modify
- Documentation matches reality

### ✅ Future-Proof
- Can wrap scripts in MCP later if desired
- Foundation for more automation
- Doesn't lock us into wrong abstractions

## What We're Explicitly NOT Building

❌ **Smart detection system** - Too complex, too many edge cases
❌ **Auto-injection into Claude's context** - Not how Claude Code works
❌ **Token budgeting/prioritization** - Premature optimization
❌ **MCP tools** - Can add later if scripts prove useful
❌ **Complex plugin infrastructure** - Keep it simple

## Review Checklist

- [ ] Does this approach make more sense than the original?
- [ ] Are the scripts simple and buildable?
- [ ] Will this actually help users manage context better?
- [ ] Is the scope reasonable for immediate implementation?
- [ ] Does simplifying CLAUDE.md improve clarity?

---

**Next Step:** Please review this revised plan. Does this pragmatic approach make more sense? Should we proceed with building scripts?
