# Command: focus

Explicitly set the active plan key for smart context loading.

## What This Does

The `/para-focus` command allows you to explicitly specify which plan key should be active for context loading:

1. Sets the specified plan key as the active focus
2. Immediately loads all relevant files from `active_context.{plan-key}.files`
3. Injects those files into Claude's context window
4. Updates `context/context.md` with a focus timestamp
5. Subsequent commands will use this plan key's context

## Usage

```
/para-focus <plan-key>
```

### Examples

```bash
# Focus on a specific plan
/para-focus AUTH-123

# Switch between concurrent work streams
/para-focus PLAN-456
/para-focus fix_memory_leak

# Clear focus (use auto-detection)
/para-focus --clear
```

## When to Use This

### Explicit Focus Needed

Use `/para-focus` when:
- **Working on multiple concurrent plans** - Switch between different work streams
- **Auto-detection fails** - Plugin can't determine the right plan key
- **Starting a session** - Explicitly set context for the work you're about to do
- **After merging/completing work** - Switch to a different active plan

### Auto-Detection is Fine

You usually don't need `/para-focus` because the plugin auto-detects from:
1. Git branch name (e.g., `para/AUTH-123-...`)
2. Recent conversation mentions of plan keys
3. Last updated plan key in `context/context.md`

## How It Works

### Detection Priority

When you run `/para-focus PLAN-123`, the plugin:

1. **Validates plan key exists** in `active_context`
2. **Loads file paths** from `active_context.PLAN-123.files`
3. **Resolves repo paths** (handles multi-repo scenarios)
4. **Injects files** into Claude's context window
5. **Updates metadata** in `context/context.md`:
   ```json
   {
     "focus": {
       "plan_key": "PLAN-123",
       "focused_at": "2026-01-07T10:30:00Z"
     }
   }
   ```

### Multi-Repo Path Resolution

For multi-repo setups, the plugin:
- Scans parent directory for git repositories
- Builds a repo map: `{repo_name: absolute_path}`
- Resolves `repo-name/path/file.ts` to absolute paths
- Loads files from their resolved locations

**Example:**
```
Working directory: /Users/user/dev/my-project/
Repositories found:
- api-gateway: /Users/user/dev/my-project/api-gateway
- user-service: /Users/user/dev/my-project/user-service

Plan specifies:
- api-gateway/src/middleware/auth.ts
- user-service/src/models/user.ts

Plugin loads:
- /Users/user/dev/my-project/api-gateway/src/middleware/auth.ts
- /Users/user/dev/my-project/user-service/src/models/user.ts
```

## Output

After running `/para-focus PLAN-123`, you'll see:

```
## ✅ Context Focused

**Plan Key:** PLAN-123
**Files Loaded:** 12 files (23,450 tokens)

### Files in Context:
- api-gateway/src/middleware/auth.ts
- api-gateway/src/middleware/jwt.ts
- user-service/src/models/user.ts
- api-gateway/tests/auth.test.ts
... (8 more)

Claude now has focused context for PLAN-123.
```

## Token Budgeting

The plugin enforces token limits:
- **Default limit:** 50,000 tokens for context files
- **Configurable** via settings
- **Prioritization** if over budget:
  1. Plan files (highest priority)
  2. Recently modified files
  3. Other tracked files
  4. Least recently modified (dropped if needed)

## Options

```
/para-focus <plan-key>           # Focus on specific plan
/para-focus --clear              # Clear explicit focus, use auto-detection
/para-focus --status             # Show current focus and loaded files
/para-focus --list               # List all available plan keys
/para-focus <plan-key> --reload  # Reload context files (useful if files changed)
```

## Integration with Workflow

### During Planning

```bash
# Create plan
/para-plan AUTH-123 add-user-authentication

# Files are tracked in plan under "Relevant Files" section
# context.md updated with plan key and file paths
```

### During Execution

```bash
# Execute plan (auto-creates branch para/AUTH-123-...)
/para-execute

# Focus is automatically set based on branch name
# No need to run /para-focus manually

# But if auto-detection fails:
/para-focus AUTH-123
```

### Switching Between Plans

```bash
# Working on AUTH-123
/para-focus AUTH-123

# Need to check something in PLAN-456
/para-focus PLAN-456

# Back to AUTH-123
/para-focus AUTH-123
```

## Error Handling

### Plan Key Not Found

```
❌ Error: Plan key 'INVALID-KEY' not found in active_context.

Available plan keys:
- AUTH-123
- PLAN-456
- fix_memory_leak

Run /para-focus <plan-key> with a valid key.
```

### Repository Not Found

```
⚠️ Warning: Repository 'missing-repo' not found in working directory.

Files from 'missing-repo' will be skipped:
- missing-repo/src/file.ts

Found repositories:
- api-gateway: /Users/user/dev/api-gateway
- user-service: /Users/user/dev/user-service
```

### File Not Found

```
⚠️ Warning: 2 files not found and will be skipped:
- api-gateway/src/deleted-file.ts
- user-service/src/moved-file.ts

Run /para-sync AUTH-123 to update the file list.
```

### Token Budget Exceeded

```
⚠️ Warning: Context files exceed token budget (65,234 / 50,000 tokens).

Prioritizing files:
✅ Loaded: context/plans/2026-01-07-AUTH-123-auth.md (2,145 tokens)
✅ Loaded: api-gateway/src/middleware/auth.ts (3,890 tokens)
✅ Loaded: user-service/src/models/user.ts (1,234 tokens)
... (8 more files loaded)
⏭️ Skipped: api-gateway/tests/old-test.ts (least recently modified)
⏭️ Skipped: user-service/src/util/helper.ts (least recently modified)

Total loaded: 49,876 tokens (within budget)
```

## Best Practices

1. **Let auto-detection work first** - Only use `/para-focus` when needed
2. **Focus at session start** - Explicitly set context when beginning work
3. **Switch focus deliberately** - Use `/para-focus --status` to check current state
4. **Update files with `/para-sync`** - Keep tracked files current
5. **Check token usage** - Use `/para-focus --status` to see token counts

## Related Commands

- `/para-plan` - Create new plan with file tracking
- `/para-sync` - Update tracked files for a plan key
- `/para-execute` - Execute plan (auto-focuses based on branch)
- `/para-status` - Show overall PARA workflow status
- `/para-load` - Explicitly load additional files (beyond tracked ones)

## Notes

- Focus persists across commands until changed
- Git branch names with plan keys trigger auto-focus
- Multi-repo support requires Claude Code running from parent directory
- Token budget prevents context overflow
- Files are reloaded on `/para-focus --reload`
