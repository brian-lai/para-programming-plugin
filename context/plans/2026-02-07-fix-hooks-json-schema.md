# Plan: Fix hooks.json Schema Error

## Objective
Fix the hooks.json schema validation error by wrapping hooks in a top-level "hooks" property, create a PR, merge it, and release version 1.2.1.

## Current State
- hooks.json has hooks directly at root level
- Claude Code plugin system expects hooks under a "hooks" property
- Error: "Invalid input: expected record, received undefined"
- Change already made to hooks/hooks.json locally

## Scope
1. Create bugfix branch
2. Commit the hooks.json fix
3. Push branch and create PR
4. Merge PR to main
5. Create and push version 1.2.1 tag
6. Update version in package.json (if exists)

## Tasks
- [ ] Create branch `fix/hooks-json-schema-2026-02-07`
- [ ] Stage and commit hooks.json changes
- [ ] Push branch to origin
- [ ] Create PR via gh CLI
- [ ] Merge PR
- [ ] Checkout main and pull latest
- [ ] Update version to 1.2.1 in package.json (if exists)
- [ ] Create git tag v1.2.1
- [ ] Push tag to origin

## Technical Details
**File Changed:** `hooks/hooks.json`

**Change:**
```json
// Before (incorrect):
{
  "SessionStart": { ... }
}

// After (correct):
{
  "hooks": {
    "SessionStart": { ... }
  }
}
```

## Risks & Considerations
- Low risk: Single file change, schema fix only
- No breaking changes to functionality
- Patch version bump appropriate (1.2.0 → 1.2.1)

## Data Sources
- Git repository
- hooks/hooks.json file

## Success Criteria
- [ ] PR created and merged
- [ ] Version 1.2.1 tagged and pushed
- [ ] Plugin loads without errors
- [ ] SessionStart hook continues to work

## Review Checklist
- [ ] Branch name follows convention
- [ ] Commit message is clear
- [ ] PR description explains the fix
- [ ] Version bump is appropriate
