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

1. Moves `context/context.md` to `context/archives/YYYY-MM-DD-HHMM-context.md`
2. Creates a fresh `context/context.md`:

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

3. Displays: archive location, confirmation of fresh context, readiness for new task

## When to Archive

- Work is complete and summarized
- All tests pass and changes are committed
- Ready to start a new, unrelated task

Do NOT archive if work is still in progress or you need the current context for continued work.

## Recovery

```bash
ls -lt context/archives/           # List archives
cp context/archives/2025-11-24-1430-context.md context/context.md   # Restore
```

## Notes

- Never delete archives -- they are your project memory
- Archives are searchable: `grep -r "keyword" context/archives/`
