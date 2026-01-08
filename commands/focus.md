# Command: focus

Load relevant files for a specific plan key into your Claude Code session.

## What This Does

The focus workflow helps you manually load all relevant files for a plan key into Claude's context:

1. Use helper scripts to extract file paths from `context/context.md`
2. Resolve multi-repo paths to absolute paths
3. Generate a prompt to load those files
4. Copy and paste the prompt to Claude Code

**Note:** This is a manual workflow. Claude Code does not support automatic context injection or MCP plugins for this purpose.

## Usage

```bash
# Generate a prompt to load files for a plan key
./context/servers/para-generate-prompt.sh <plan-key>
```

### Example Workflow

```bash
# 1. List tracked files for a plan key
./context/servers/para-list-files.sh CONTEXT-001

# Output:
# para-programming-plugin/resources/CLAUDE.md
# para-programming-plugin/commands/plan.md
# para-programming-plugin/templates/plan-template.md

# 2. Validate which files exist
./context/servers/para-validate-files.sh CONTEXT-001

# Output shows files with repo prefixes as "missing" (expected)

# 3. Resolve to absolute paths
./context/servers/para-resolve-paths.sh CONTEXT-001

# Output:
# /Users/you/dev/para-programming-plugin/resources/CLAUDE.md
# /Users/you/dev/para-programming-plugin/commands/plan.md
# /Users/you/dev/para-programming-plugin/templates/plan-template.md

# 4. Generate prompt for Claude
./context/servers/para-generate-prompt.sh CONTEXT-001

# Output:
# Please read the following files for CONTEXT-001:
#
# - /Users/you/dev/para-programming-plugin/resources/CLAUDE.md
# - /Users/you/dev/para-programming-plugin/commands/plan.md
# - /Users/you/dev/para-programming-plugin/templates/plan-template.md
#
# These files contain the relevant context for the current work.

# 5. Copy the output and paste it as a message to Claude Code
```

## When to Use This

Use the focus workflow when:
- **Starting a work session** - Load relevant context at the beginning
- **Switching between plans** - Change which files are in context
- **After updating context.md** - Reload context when files change
- **Working across multiple repos** - Load files from different repositories

## Helper Scripts

All scripts are located in `context/servers/`:

### para-list-files.sh

Extracts raw file paths from `context/context.md` for a plan key.

```bash
./context/servers/para-list-files.sh <plan-key>
```

**Output:** List of files with repo prefixes (e.g., `repo-name/path/to/file`)

### para-validate-files.sh

Checks which files exist or are missing. Files with repo prefixes will show as missing (expected behavior - use resolve script next).

```bash
./context/servers/para-validate-files.sh <plan-key>
```

**Output:** Validation report with ✅/❌ for each file

### para-resolve-paths.sh

Resolves `repo-name/path` format to absolute paths by scanning for git repositories.

```bash
./context/servers/para-resolve-paths.sh <plan-key>
```

**Scans:**
- Current directory (if it's a git repo)
- Subdirectories (for git repos)
- Parent directory's subdirectories (for git repos)

**Output:** List of absolute file paths

### para-generate-prompt.sh

Generates a natural language prompt you can copy and paste to Claude Code.

```bash
./context/servers/para-generate-prompt.sh <plan-key>
```

**Output:** Formatted prompt ready to send to Claude

## Multi-Repo Support

The scripts support multi-repo work by:
1. Tracking files with repo prefix format: `repo-name/path/to/file`
2. Scanning for git repositories in current, subdirs, and parent's subdirs
3. Resolving repo prefixes to absolute paths

**Example:**

```json
{
  "active_context": {
    "AUTH-123": {
      "repos": ["api-gateway", "user-service"],
      "files": [
        "api-gateway/src/middleware/auth.ts",
        "user-service/src/models/user.ts"
      ]
    }
  }
}
```

When you run `para-resolve-paths.sh AUTH-123` from `/Users/you/dev/`, it finds:
- `api-gateway`: `/Users/you/dev/api-gateway`
- `user-service`: `/Users/you/dev/user-service`

And outputs:
- `/Users/you/dev/api-gateway/src/middleware/auth.ts`
- `/Users/you/dev/user-service/src/models/user.ts`

## Limitations

- **Manual process** - You must copy and paste the generated prompt to Claude
- **No auto-detection** - Scripts don't automatically detect which plan key to use
- **Requires jq** - Scripts use `jq` to parse JSON from context.md
- **Bash 3.2+** - Scripts are compatible with macOS default bash

## Best Practices

1. **Use generate script** - `para-generate-prompt.sh` gives you a ready-to-use prompt
2. **Update context.md regularly** - Keep file lists current as you work
3. **Check validation** - Run `para-validate-files.sh` to catch missing files
4. **Multi-repo from parent** - Run scripts from parent directory for multi-repo work
5. **Track essential files only** - Don't overload context with unnecessary files

## Integration with PARA Workflow

### During Planning

When you create a plan with `/para-plan`, add relevant files to the plan:

```markdown
## Relevant Files

- api-gateway/src/middleware/auth.ts
- user-service/src/models/user.ts
```

Then update `context/context.md`:

```json
{
  "active_context": {
    "AUTH-123": {
      "repos": ["api-gateway", "user-service"],
      "files": [
        "api-gateway/src/middleware/auth.ts",
        "user-service/src/models/user.ts"
      ],
      "plans": ["context/plans/2026-01-07-AUTH-123-auth.md"]
    }
  }
}
```

### During Execution

At the start of your work session:

```bash
# Generate prompt
./context/servers/para-generate-prompt.sh AUTH-123

# Copy output and paste to Claude Code
```

Claude will read all the files and have the full context for your work.

## Troubleshooting

### Plan key not found

```bash
Error: Plan key 'INVALID-KEY' not found in active_context

Available plan keys:
  - AUTH-123
  - CONTEXT-001
```

**Fix:** Use a valid plan key from the list.

### Repository not found

```bash
Warning: Repository 'missing-repo' not found for: missing-repo/src/file.ts
```

**Fix:**
- Ensure the repository exists in current, subdirs, or parent's subdirs
- Check that the directory has a `.git` folder
- Verify repo name matches directory name exactly

### File not found

```bash
❌ para-programming-plugin/resources/CLAUDE.md
```

**Fix:** This is expected for files with repo prefixes. Use `para-resolve-paths.sh` to convert to absolute paths.

### jq not installed

```bash
Error: jq is required but not installed
```

**Fix:** Install jq:
- macOS: `brew install jq`
- Linux: `apt-get install jq` or `yum install jq`

## Related Commands

- `/para-plan` - Create new plan with file tracking
- `/para-check` - Verify context.md structure and data integrity
- `/para-status` - Show current PARA workflow status

## Notes

- Scripts are deterministic and testable
- All scripts support piping and shell composition
- Scripts use `set -e` to fail fast on errors
- Scripts output to stdout, errors/warnings to stderr
