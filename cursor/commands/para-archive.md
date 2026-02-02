# PARA Archive – Archive context and reset for the next task

Archive the current context so you can start the next task with a clean slate.

## What to do

1. **Check** – Ensure `context/context.md` exists.

2. **Timestamp** – Use current time in `YYYY-MM-DD-HHMM` format.

3. **Move** – Move `context/context.md` to `context/archives/YYYY-MM-DD-HHMM-context.md`.

4. **New context** – Create a fresh `context/context.md` with:
   - A short "Current Work Summary" (e.g. "Ready for next task.")
   - JSON: `active_context: []`, `completed_summaries: []` (or carry forward recent summary paths if useful), `last_updated` (current ISO timestamp).

5. **Confirm** – Tell the user the previous context was archived and where. Remind them to run `/para-plan` for the next task and `/para-status` or `/para-help` as needed.

## When to use

- Work is done and summarized.
- Starting a new, unrelated task.
  Do not archive if work is still in progress or you need the current context for the next message.
