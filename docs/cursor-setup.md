# Cursor Setup for PARA-Programming

Use PARA-Programming in [Cursor](https://cursor.com) by adding the PARA slash commands and optional rules to your project or your user config.

---

## Quick setup (project)

Copy the Cursor commands and rules into your project so they appear when you type `/` in Cursor chat.

### Option A: Install from GitHub (no git clone)

From your **project root**, run:

```bash
curl -fsSL https://raw.githubusercontent.com/brian-lai/para-programming-plugin/main/scripts/setup-cursor.sh | bash -s -- --from-github
```

This downloads the script and the Cursor command/rule files from GitHub and installs them into `.cursor/` in the current directory. No git clone required.

To install into a specific directory:

```bash
curl -fsSL https://raw.githubusercontent.com/brian-lai/para-programming-plugin/main/scripts/setup-cursor.sh | bash -s -- --from-github /path/to/your/project
```

### Option B: Copy from this repo (if you have it)

```bash
# From your project root (not inside the plugin repo)
mkdir -p .cursor
cp -r /path/to/para-programming-plugin/cursor/commands .cursor/
cp -r /path/to/para-programming-plugin/cursor/rules .cursor/
```

Replace `/path/to/para-programming-plugin` with the actual path to your clone of the para-programming-plugin repo.

### Option C: Run the setup script (from plugin repo)

From inside the para-programming-plugin repo:

```bash
./scripts/setup-cursor.sh /path/to/your/project
```

This creates `.cursor/commands` and `.cursor/rules` in the target project and copies the PARA command and rule files.

### Option D: Global commands (all projects)

To have PARA commands available in every project:

```bash
mkdir -p ~/.cursor/commands
cp cursor/commands/*.md ~/.cursor/commands/
```

You can do this from a clone of the plugin repo. Global commands are merged with project commands when you type `/` in Cursor.

---

## What gets installed

### Commands (`.cursor/commands/`)

| Command          | Purpose                                       |
| ---------------- | --------------------------------------------- |
| `para-init`      | Initialize PARA structure in the project      |
| `para-plan`      | Create a plan for the current task            |
| `para-execute`   | Start execution (branch + to-dos)             |
| `para-summarize` | Generate summary from completed work          |
| `para-archive`   | Archive context and reset for next task       |
| `para-status`    | Show current workflow state                   |
| `para-check`     | Decide whether to use PARA or answer directly |
| `para-help`      | Full PARA guide                               |

In Cursor chat, type `/` and choose one of these (e.g. **para-init**, **para-plan**).

### Rules (`.cursor/rules/`)

- **para-workflow.mdc** – Applies when files under `context/` are in scope. Reminds the AI to use the PARA workflow for code changes and lists the slash commands.

Rules are optional; commands alone are enough to run the workflow.

---

## Verify

1. Open your project in Cursor.
2. Open the AI chat (e.g. Cmd+L or Ctrl+L).
3. Type `/`.
4. You should see the `para-*` commands in the list (and any other project or global commands).

---

## Updating

After pulling new versions of the plugin, re-run the copy or setup script to refresh `.cursor/commands` and `.cursor/rules` in your project (or in `~/.cursor/commands` for global).

---

## Uninstall

Remove the PARA command and rule files:

```bash
# Project only
rm -rf .cursor/commands/para-*.md .cursor/rules/para-workflow.mdc

# Global only
rm -f ~/.cursor/commands/para-*.md
```

---

## See also

- [INSTALL.md](../INSTALL.md) – Claude Code plugin installation
- [README.md](../README.md) – PARA workflow overview
- [Main PARA guide](https://github.com/brian-lai/para-programming)
