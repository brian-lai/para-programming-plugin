# Command: archive

Archive the current context to create a clean slate for the next task.

## Usage

```
/para:archive
/para:archive --fresh          # Completely empty context
/para:archive --seed           # Carry forward relevant context
```

Default: create fresh context with reference to completed summaries.

## What It Does

1. Read `context/context.md` and extract worktree metadata (`worktree_path`, or per-phase `worktree_path` entries for phased plans)
2. **Clean up worktrees:**
   - For each `worktree_path` found in metadata, run `git worktree remove {worktree_path}`
   - If the worktree has uncommitted changes, warn the user and require them to either commit or stash the changes first, then re-run `/para:archive`; do NOT force-remove (this would permanently destroy uncommitted work)
   - After removal, run `git worktree prune` to clean up stale references
   - Remove `.para-worktrees/` directory if empty
3. Move `context/context.md` to `context/archives/YYYY-MM-DD-HHMM-context.md`
4. Create a fresh `context/context.md`:

````markdown
# Current Work Summary

Ready for next task.

---
```json
{
  "active_context": [],
  "completed_summaries": [
    "context/summaries/YYYY-MM-DD-*.md"
  ],
  "last_updated": "TIMESTAMP"
}
```
````

5. Displays: archive location, worktrees removed, confirmation of fresh context, readiness for new task

## When to Archive

- Work is complete and summarized
- All tests pass and changes are committed
- Branch has been pushed and PR created (or merged)
- Ready to start a new, unrelated task

Do NOT archive if work is still in progress or you need the current context for continued work.

## Recovery

```bash
ls -lt context/archives/           # List archives
cp context/archives/2025-11-24-1430-context.md context/context.md   # Restore
```

To restore a worktree after archive (if branch still exists):
```bash
git worktree add .para-worktrees/{task-name} para/{task-name}
```

## Notes

- Never delete archives -- they are your project memory
- Archives are searchable: `grep -r "keyword" context/archives/`
- Worktree cleanup is automatic during archive; branches are preserved for PR/merge workflows
