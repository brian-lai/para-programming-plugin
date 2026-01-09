# Installation Guide

Complete installation instructions for the PARA-Programming Claude Code plugin.

---

## Prerequisites

Before installing, ensure you have:

- ✅ **Claude Code CLI** installed ([Get it here](https://claude.ai/claude-code))
- ✅ **Git** installed (for project version control)
- ✅ **Terminal access** (bash, zsh, or PowerShell)

---

## Plugin Installation (Recommended)

### Quick Install

```bash
# Add the PARA-Programming marketplace
/plugin marketplace add brian-lai/para-programming-plugin

# Install the plugin
/plugin install para@brian-lai/para-programming-plugin
```

That's it! The plugin is now installed and all commands are available.

### Verify Installation

Start Claude Code and check for PARA commands:

```bash
claude

# In Claude Code, check available commands:
/help
```

You should see commands prefixed with `/para:`:
- `/para:init`
- `/para:plan`
- `/para:execute`
- `/para:summarize`
- `/para:archive`
- `/para:status`
- `/para:check`

### First Use

Initialize PARA in your project:

```bash
cd your-project
claude
/para:init
```

This command automatically:
- **Creates `~/.claude/CLAUDE.md`** (if it doesn't exist) - the global workflow methodology file
- Creates the `context/` directory structure in your project
- Creates a project-level `CLAUDE.md` for project-specific context

The global methodology file is only created once and shared across all your projects.

---

## Installation Scopes

You can install the plugin at different scopes:

### User Scope (Recommended)

Available across all your projects:

```bash
/plugin install para@brian-lai/para-programming-plugin --scope user
```

### Project Scope

Only available in the current project (stored in `.claude/settings.json`):

```bash
/plugin install para@brian-lai/para-programming-plugin --scope project
```

### Local Scope

Personal installation for current project only (stored in `.claude/settings.local.json`, gitignored):

```bash
/plugin install para@brian-lai/para-programming-plugin --scope local
```

---

## Global Methodology File

The plugin includes a **global workflow methodology file** that gets installed to `~/.claude/CLAUDE.md`:

### What It Contains

- **PARA Workflow**: The Plan → Review → Execute → Summarize → Archive loop
- **When to Use PARA**: Guidelines for code changes vs. informational queries
- **Git Integration**: Branch naming, commit practices, todo tracking
- **Context Directory Structure**: How to organize `context/` directories
- **MCP Integration Patterns**: Token efficiency strategies

### How It's Installed

| Method | When Global File Is Created |
|--------|----------------------------|
| Plugin + `/para:init` | Automatically on first init (if missing) |
| Manual Installation | Via `cp resources/CLAUDE.md ~/.claude/CLAUDE.md` |

### Important Notes

- **Never overwrites**: If `~/.claude/CLAUDE.md` already exists, it is NOT modified
- **Shared across projects**: One global file applies to all your projects
- **Updates**: To get methodology updates, update the plugin and run `/para:init` in a project without an existing global file

---

## Updating the Plugin

To get the latest version:

```bash
/plugin update para@brian-lai/para-programming-plugin
```

---

## Uninstalling

To remove the plugin:

```bash
/plugin uninstall para@brian-lai/para-programming-plugin
```

---

## Alternative: Manual Installation (Legacy)

If you prefer not to use the plugin system, you can manually install the commands:

### Step 1: Clone the Repository

```bash
git clone https://github.com/brian-lai/para-programming-plugin.git
cd para-programming-plugin
```

### Step 2: Install Global Methodology

```bash
# Create Claude directory
mkdir -p ~/.claude

# Copy global methodology file
cp resources/CLAUDE.md ~/.claude/CLAUDE.md
```

### Step 3: Install Slash Commands

```bash
# Create commands directory
mkdir -p ~/.claude/commands

# Copy all PARA commands
cp commands/*.md ~/.claude/commands/
```

### Step 4: Verify Installation

```bash
# List installed commands
ls ~/.claude/commands/*.md

# Start Claude Code and check
claude
/help
```

---

## Troubleshooting

### Plugin Not Found

**Problem:** `/plugin install` shows "plugin not found"

**Solution:**
1. Verify marketplace is added:
   ```bash
   /plugin marketplace list
   ```
2. Re-add if needed:
   ```bash
   /plugin marketplace add brian-lai/para-programming-plugin
   ```

### Commands Not Appearing

**Problem:** PARA commands don't show up in `/help`

**Solution:**
1. Check plugin is installed:
   ```bash
   /plugin list
   ```
2. Reinstall if needed:
   ```bash
   /plugin install para@brian-lai/para-programming-plugin --scope user
   ```
3. Restart Claude Code

### Permission Errors (Linux/Mac)

**Problem:** "Permission denied" when installing

**Solution:**
```bash
# Ensure proper permissions on Claude directory
chmod -R u+rw ~/.claude
```

---

## Platform-Specific Notes

### macOS / Linux

- Default shell: bash or zsh
- Commands directory: `~/.claude/commands/`
- Plugin storage: `~/.claude/settings.json`

### Windows

- Use Git Bash, WSL, or PowerShell
- Commands directory: `C:\Users\YourName\.claude\commands\`
- Plugin storage: `C:\Users\YourName\.claude\settings.json`

---

## Next Steps

After successful installation:

1. **Initialize your project:** `/para:init`
2. **Try the example workflow:** See [examples/example-workflow.md](examples/example-workflow.md)
3. **Read the documentation:** [Main PARA Guide](https://github.com/brian-lai/para-programming)
4. **Start your first task:** `/para:plan "your task description"`

---

## Support

- **Plugin Issues:** [GitHub Issues](https://github.com/brian-lai/para-programming-plugin/issues)
- **Documentation:** [Main PARA Guide](https://github.com/brian-lai/para-programming)
- **Community:** [GitHub Discussions](https://github.com/brian-lai/para-programming-plugin/discussions)

---

**Installation complete! 🎉**

You're ready to start PARA-Programming with Claude Code.
