# PARA Check – Should we use the PARA workflow?

Decide whether the user’s request should go through the full PARA workflow or be answered directly.

## What to do

1. **Request** – Use the user’s last message or the request they pasted (e.g. "Add auth to the API" or "Where is the login handler?").

2. **Apply this decision tree**
   - **Asking for code or file changes?** (features, bugs, refactors, config, DB, tests, docs that affect code) → **Use PARA**: create a plan, then execute, summarize, archive.
   - **Otherwise, asking about this project’s code?** (where is X, how does Y work) → **Skip PARA**: answer directly with file references.
   - **Otherwise** (general or off-topic) → **Skip PARA**: answer normally.

3. **Respond** – State clearly: "Use PARA workflow" or "Skip PARA; answer directly." Briefly say why (e.g. "This involves code changes" or "This is a read-only question"). If USE PARA, suggest running `/para-plan` with a short task description.

## Rule of thumb

If it would result in git changes to project files, use PARA. If it’s read-only or informational, skip PARA.
