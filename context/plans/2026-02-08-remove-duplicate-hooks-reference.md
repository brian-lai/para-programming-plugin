# Plan: Remove Duplicate Hooks Reference from plugin.json

## Objective
Fix duplicate hooks loading error by removing the hooks reference from plugin.json, and release version 1.2.4.

## Current State
- plugin.json has `"hooks": "./hooks/hooks.json"` field
- Claude Code automatically loads hooks/hooks.json from standard location
- This causes duplicate loading error
- Change already made to plugin.json locally

## Scope
1. Create bugfix branch
2. Commit the plugin.json fix
3. Push branch and create PR
4. Merge PR to main
5. Create and push version 1.2.4 tag
6. Update version in plugin.json and marketplace.json

## Tasks
- [ ] Create branch `fix/remove-duplicate-hooks-2026-02-08`
- [ ] Stage and commit plugin.json changes
- [ ] Push branch to origin
- [ ] Create PR via gh CLI
- [ ] Merge PR
- [ ] Checkout main and pull latest
- [ ] Update version to 1.2.4 in plugin files
- [ ] Create git tag v1.2.4
- [ ] Push tag to origin

## Technical Details
**File Changed:** `.claude-plugin/plugin.json`

**Change:**
```json
// Before (incorrect - causes duplicate loading):
{
  "name": "para",
  "version": "1.2.3",
  ...
  "hooks": "./hooks/hooks.json"  // ❌ Redundant - loaded automatically
}

// After (correct):
{
  "name": "para",
  "version": "1.2.4",
  ...
  // ✅ No hooks field - hooks/hooks.json loaded automatically
}
```

**Key Understanding:**
- Claude Code automatically loads `hooks/hooks.json` from the standard location
- The `"hooks"` field in plugin.json should only reference *additional* hook files
- Having both causes a "Duplicate hooks file detected" error

## Risks & Considerations
- Low risk: Single line removal from config file
- No breaking changes to functionality
- Patch version bump appropriate (1.2.3 → 1.2.4)
- Hooks will continue to work via automatic loading
- Follows Claude Code plugin conventions

## Data Sources
- Git repository
- .claude-plugin/plugin.json file
- Error message indicating duplicate loading

## Success Criteria
- [ ] PR created and merged
- [ ] Version 1.2.4 tagged and pushed
- [ ] Plugin loads without errors
- [ ] SessionStart hook continues to work
- [ ] No duplicate hooks warning

## Review Checklist
- [ ] Branch name follows convention
- [ ] Commit message is clear
- [ ] PR description explains the fix
- [ ] Version bump is appropriate
