# PARA Help – Full PARA-Programming guide

Give a concise but complete overview of PARA-Programming and how to use it in Cursor.

## What to include

1. **What is PARA** – Structured workflow for AI-assisted development: plan before coding, capture outcomes. Goals: accuracy, token efficiency, auditability.

2. **The workflow** – Plan → Review → Execute → Summarize → Archive. Briefly say what each step is for.

3. **When to use PARA**
   - Use for: code changes, features, bugs, refactors, config, DB changes, tests, architecture decisions.
   - Skip for: "Where is X?", "How does Y work?", explanations, navigation, simple questions.

4. **Cursor commands** – List these and one-line descriptions:
   - `/para-init` – Initialize PARA in this project
   - `/para-plan` – Create a plan (add task description)
   - `/para-execute` – Start execution (branch + to-dos)
   - `/para-summarize` – Write summary from current work
   - `/para-archive` – Archive context for next task
   - `/para-status` – Show current state
   - `/para-check` – Decide: use PARA or answer directly
   - `/para-help` – This guide

5. **Quick start** – If no `context/` yet: run `/para-init`. Then `/para-plan "your task"`, review the plan, `/para-execute`, work through to-dos (commit each), then `/para-summarize` and `/para-archive`.

6. **Rule of thumb** – If it results in git changes, use PARA. If it’s read-only, skip it.

Keep the reply scannable (short paragraphs, bullets, maybe a small table). Offer to run a specific command if the user wants to try one next.
