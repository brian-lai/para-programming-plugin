# PARA Status – Show current workflow state

Show where we are in the PARA workflow.

## What to do

1. **Read** – Open `context/context.md`. If it or the `context/` directory does not exist, say "PARA not initialized" and suggest running `/para-init`.

2. **Report** – Summarize in a clear, scannable format:
   - **Current work** – The human-readable summary at the top of context.md.
   - **Active plans** – List paths in `active_context` that are plans (in `context/plans/`).
   - **Completed summaries** – List paths in `completed_summaries` (and any in the JSON).
   - **Last updated** – The `last_updated` value from the JSON.
   - **Phased execution** – If `phased_execution` exists, show current phase and phase statuses.

3. **Next action** – Suggest the next step (e.g. "Continue executing the plan and run /para-summarize when done" or "Run /para-plan to create a plan" if there are no active plans).

Use a simple layout (e.g. short headings and bullet lists) so the user can scan quickly.
