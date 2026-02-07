# Plan: Fix hooks.json Nested Schema Structure

## Objective
Fix the hooks.json schema validation error by implementing the correct nested structure with matcher objects, and release version 1.2.3.

## Current State
- hooks.json has hooks directly in SessionStart array
- Claude Code plugin system expects matcher objects with nested hooks arrays
- Error: "Invalid input: expected array, received undefined" at path ["hooks", "SessionStart", 0, "hooks"]
- Change already made to hooks/hooks.json locally
- Documentation reviewed: https://code.claude.com/docs/en/hooks-guide

## Scope
1. Create bugfix branch
2. Commit the hooks.json fix
3. Push branch and create PR
4. Merge PR to main
5. Create and push version 1.2.3 tag
6. Update version in plugin.json and marketplace.json

## Tasks
- [ ] Create branch `fix/hooks-nested-schema-2026-02-08`
- [ ] Stage and commit hooks.json changes
- [ ] Push branch to origin
- [ ] Create PR via gh CLI
- [ ] Merge PR
- [ ] Checkout main and pull latest
- [ ] Update version to 1.2.3 in plugin files
- [ ] Create git tag v1.2.3
- [ ] Push tag to origin

## Technical Details
**File Changed:** `hooks/hooks.json`

**Change:**
```json
// Before (incorrect):
{
  "hooks": {
    "SessionStart": [
      {
        "action": "shell",
        "command": "./hooks/para-session-start.sh"
      }
    ]
  }
}

// After (correct - per documentation):
{
  "hooks": {
    "SessionStart": [
      {
        "matcher": "",           // Matcher object wrapper
        "hooks": [               // Nested hooks array
          {
            "type": "command",   // Changed from "action" to "type"
            "command": "./hooks/para-session-start.sh"
          }
        ]
      }
    ]
  }
}
```

**Key Changes:**
1. Wrapped hook in matcher object with `"matcher": ""`
2. Moved hook to nested `"hooks"` array
3. Changed `"action": "shell"` to `"type": "command"`

## Risks & Considerations
- Low risk: Single file change, schema fix only
- No breaking changes to functionality
- Patch version bump appropriate (1.2.2 → 1.2.3)
- This follows official documentation schema
- Completes the hooks.json schema fixes (third iteration)

## Data Sources
- Git repository
- hooks/hooks.json file
- Official documentation: https://code.claude.com/docs/en/hooks-guide

## Success Criteria
- [ ] PR created and merged
- [ ] Version 1.2.3 tagged and pushed
- [ ] Plugin loads without errors
- [ ] SessionStart hook continues to work

## Review Checklist
- [ ] Branch name follows convention
- [ ] Commit message is clear
- [ ] PR description explains the fix with documentation link
- [ ] Version bump is appropriate
