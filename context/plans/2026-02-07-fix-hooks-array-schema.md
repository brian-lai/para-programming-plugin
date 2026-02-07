# Plan: Fix hooks.json Array Schema Error

## Objective
Fix the hooks.json schema validation error by changing SessionStart from object to array, create a PR, merge it, and release version 1.2.2.

## Current State
- hooks.json has SessionStart as an object
- Claude Code plugin system expects SessionStart to be an array of hook objects
- Error: "Invalid input: expected array, received object"
- Change already made to hooks/hooks.json locally

## Scope
1. Create bugfix branch
2. Commit the hooks.json fix
3. Push branch and create PR
4. Merge PR to main
5. Create and push version 1.2.2 tag
6. Update version in plugin.json and marketplace.json

## Tasks
- [ ] Create branch `fix/hooks-array-schema-2026-02-07`
- [ ] Stage and commit hooks.json changes
- [ ] Push branch to origin
- [ ] Create PR via gh CLI
- [ ] Merge PR
- [ ] Checkout main and pull latest
- [ ] Update version to 1.2.2 in plugin files
- [ ] Create git tag v1.2.2
- [ ] Push tag to origin

## Technical Details
**File Changed:** `hooks/hooks.json`

**Change:**
```json
// Before (incorrect):
{
  "hooks": {
    "SessionStart": {      // ❌ Object
      "action": "shell",
      "command": "./hooks/para-session-start.sh"
    }
  }
}

// After (correct):
{
  "hooks": {
    "SessionStart": [      // ✅ Array
      {
        "action": "shell",
        "command": "./hooks/para-session-start.sh"
      }
    ]
  }
}
```

## Risks & Considerations
- Low risk: Single file change, schema fix only
- No breaking changes to functionality
- Patch version bump appropriate (1.2.1 → 1.2.2)
- This completes the hooks.json schema fixes

## Data Sources
- Git repository
- hooks/hooks.json file

## Success Criteria
- [ ] PR created and merged
- [ ] Version 1.2.2 tagged and pushed
- [ ] Plugin loads without errors
- [ ] SessionStart hook continues to work

## Review Checklist
- [ ] Branch name follows convention
- [ ] Commit message is clear
- [ ] PR description explains the fix
- [ ] Version bump is appropriate
