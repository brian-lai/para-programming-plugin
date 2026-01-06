# Plan: Add Global CLAUDE.md Setup to Plugin Installation

## Objective

Update the PARA-Programming plugin so that installing the plugin also sets up the global `~/.claude/CLAUDE.md` methodology file. Currently, the plugin only provides project-level initialization via `/para-program:init`, missing the critical global workflow guide that defines how Claude should work across all projects.

## Background

The original `para-programming` repository includes a `claude/CLAUDE.md` file (942 lines) that serves as the **global workflow methodology**. This file defines:
- The Plan → Review → Execute → Summarize → Archive workflow
- When to use PARA vs. skip it
- MCP integration patterns
- Git workflow practices
- Token efficiency strategies
- Templates for local CLAUDE.md files

Without this global file at `~/.claude/CLAUDE.md`, users miss the core methodology that makes PARA-Programming work consistently across projects.

## Current State

1. **Plugin has**: Commands, hooks, templates for project-level setup
2. **Plugin lacks**: Global CLAUDE.md setup mechanism
3. **scripts/install.sh**: References `../CLAUDE.md` which doesn't exist in the plugin repo
4. **README.md line 192**: Mentions `resources/CLAUDE.md` which doesn't exist

## Approach

### Phase 1: Include Global CLAUDE.md in Plugin

1. **Create `resources/` directory** in the plugin
2. **Copy the global CLAUDE.md** from `para-programming/claude/CLAUDE.md` to `resources/CLAUDE.md`
3. **Update scripts/install.sh** to correctly reference `resources/CLAUDE.md`

### Phase 2: Enhance `/para-program:init` Command

4. **Modify `commands/init.md`** to include global CLAUDE.md setup as the first step:
   - Check if `~/.claude/CLAUDE.md` exists
   - If missing: create it by copying from `resources/CLAUDE.md`
   - If exists: skip (don't modify user's existing file)
   - Simple, deterministic behavior - no prompts, no options

5. **Implementation logic** (to add to init.md):
   ```
   1. Create ~/.claude/ directory if it doesn't exist
   2. If ~/.claude/CLAUDE.md does NOT exist:
      - Copy resources/CLAUDE.md to ~/.claude/CLAUDE.md
      - Report: "Created global methodology file"
   3. If ~/.claude/CLAUDE.md exists:
      - Report: "Global methodology file already exists (skipped)"
   4. Continue with existing project-level initialization...
   ```

### Phase 3: Update Documentation

6. **Update README.md** to document the global setup
7. **Update INSTALL.md** with global file information
8. **Fix broken references** to `resources/CLAUDE.md`

## Implementation Approach

**Simple & Deterministic:**
- `/para-program:init` always checks for global file first
- Creates if missing, skips if exists
- No prompts, no flags, no complexity
- User runs init once, everything is set up

## Files to Modify

| File | Change |
|------|--------|
| `resources/CLAUDE.md` | **Create** - Copy from para-programming repo |
| `commands/init.md` | **Modify** - Add global CLAUDE.md setup step |
| `scripts/install.sh` | **Fix** - Update path to resources/CLAUDE.md |
| `README.md` | **Update** - Document global file setup |
| `INSTALL.md` | **Update** - Add global setup instructions |

## Risks & Mitigations

| Risk | Impact | Mitigation |
|------|--------|------------|
| Overwriting existing `~/.claude/CLAUDE.md` | User loses customizations | Only create if file doesn't exist; never overwrite |
| Keeping files in sync | `resources/CLAUDE.md` may diverge from source | Document that source of truth is `para-programming` repo |

## Success Criteria

- [ ] Running `/para-program:init` creates `~/.claude/CLAUDE.md` if missing
- [ ] Existing `~/.claude/CLAUDE.md` files are never overwritten
- [ ] Global CLAUDE.md contains the full methodology from source
- [ ] `scripts/install.sh` works correctly for manual installation
- [ ] README.md accurately describes the setup process

## Data Sources

- Source file: `/Users/brianlai/dev/para-programming/claude/CLAUDE.md` (942 lines)
- Current install script: `scripts/install.sh`
- Current init command: `commands/init.md`

## Next Steps After Approval

1. Create `resources/` directory
2. Copy CLAUDE.md from para-programming repo
3. Modify `commands/init.md` to include global setup
4. Fix `scripts/install.sh` path reference
5. Update documentation
6. Test complete installation flow
