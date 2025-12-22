# PARA-Programming Plugin for Claude Code

**Official Claude Code plugin for the PARA-Programming methodology**

Structured context management, persistent memory, and intelligent execution for AI-assisted development.

---

## 🚀 Quick Start

### Installation

```bash
# Add the PARA-Programming marketplace
/plugin marketplace add brian-lai/para-programming-plugin

# Install the plugin
/plugin install para-program@brian-lai/para-programming-plugin

# Initialize in your project
cd your-project
claude
/para-program:init
```

### First Task

```bash
# Start your first PARA task
/para-program:plan "implement user authentication"

# Review the plan (human approval step)

# Execute the plan
/para-program:execute

# Work through to-dos...

# Summarize when complete
/para-program:summarize
```

---

## 📋 What This Plugin Provides

### Slash Commands

- `/para-program:init` - Initialize PARA structure in project
- `/para-program:plan` - Create structured plan for task
- `/para-program:execute` - Start execution with branch and to-dos
- `/para-program:summarize` - Generate summary from completed work
- `/para-program:archive` - Archive context and reset
- `/para-program:status` - Show current workflow state
- `/para-program:check` - Decision helper for workflow

### Templates

- Plan template with Objective, Approach, Risks
- Summary template for documenting results
- Context template for session state
- Project CLAUDE.md templates (basic and full)

### Hooks

- Session start notifications
- Workflow guidance

### Resources

- Global CLAUDE.md methodology file
- Example workflows
- Documentation

---

## 🔁 The PARA Workflow

```
(Plan) → (Review) → (Execute) → (Summarize) → (Archive)
   ↓         ↑          ↓              ↓            ↓
/para-program:plan  Human   /para-program:execute  /para-program:summarize  /para-program:archive
```

### When to Use

**✅ ALWAYS for:**
- Code changes (features, bugs, refactoring)
- Architecture decisions
- Configuration changes
- Database modifications

**❌ SKIP for:**
- Informational queries
- Code explanations
- Navigation

---

## 📁 Directory Structure After Installation

```
your-project/
├── context/
│   ├── context.md              # Active session state
│   ├── data/                   # Input files, datasets
│   ├── plans/                  # Pre-work planning docs
│   ├── summaries/              # Post-work reports
│   ├── archives/               # Historical snapshots
│   └── servers/                # MCP tool wrappers
├── CLAUDE.md                   # Project-specific context
└── [your project files...]
```

---

## 💡 Complete Workflow Example

```bash
# 1. Start Claude Code in your project
claude

# 2. Initialize PARA (first time only)
/para-program:init

# 3. Check current status
/para-program:status

# 4. Create a plan
/para-program:plan "add dark mode support"

# [Claude creates context/plans/2025-12-22-add-dark-mode-support.md]
# [Human reviews and approves]

# 5. Start execution
/para-program:execute

# [Creates branch: para/add-dark-mode-support]
# [Updates context.md with to-do list]
# [Commits: "chore: Initialize execution context"]

# 6. Work through to-dos
# [Complete each item, commit as you go]
# [Mark items [x] in context.md]

# 7. Generate summary
/para-program:summarize

# [Claude analyzes git diff and creates summary]

# 8. Archive and prepare for next task
/para-program:archive
```

---

## 📚 Documentation

- **[Main Documentation](https://github.com/brian-lai/para-programming)** - Full PARA-Programming guide
- **[INSTALL.md](INSTALL.md)** - Detailed installation instructions
- **[CHANGELOG.md](CHANGELOG.md)** - Version history
- **[UPGRADING.md](UPGRADING.md)** - Migration and upgrade guides

---

## 🛠 Plugin Structure

```
para-programming-plugin/
├── .claude-plugin/
│   └── plugin.json          # Plugin manifest
├── commands/                # Slash commands
│   ├── para-init.md
│   ├── para-plan.md
│   ├── para-execute.md
│   ├── para-summarize.md
│   ├── para-archive.md
│   ├── para-status.md
│   └── para-check.md
├── hooks/                   # Event handlers
│   ├── hooks.json
│   └── para-session-start.sh
├── templates/               # File templates
│   ├── plan-template.md
│   ├── summary-template.md
│   ├── context-template.md
│   ├── claude-basic-template.md
│   └── claude-full-template.md
├── resources/               # Global methodology
│   └── CLAUDE.md
├── examples/                # Usage examples
├── scripts/                 # Installation scripts
└── docs/                    # Additional documentation
```

---

## 🎯 Key Features

### Structured Planning
Every task starts with a plan that includes:
- Clear objective
- Step-by-step approach
- Risk analysis
- Success criteria

### Persistent Context
Context persists across sessions:
- Active plans tracked in `context/context.md`
- Summaries document what was done
- Archives preserve historical state

### Git Integration
PARA workflow integrates with git:
- Creates feature branches automatically
- Tracks to-dos as commits
- Generates summaries from diffs

### Token Efficiency
Minimizes token usage through:
- Structured context files
- MCP preprocessing (optional)
- Selective loading of relevant context

---

## 🤝 Contributing

We welcome contributions! Areas for improvement:

- Additional commands
- MCP tools
- Templates for different tech stacks
- Documentation improvements
- Bug fixes

See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

---

## 📄 License

MIT License - see [LICENSE](LICENSE) for details.

---

## 🙏 Acknowledgments

- **Tiago Forte** - For the PARA method
- **Anthropic** - For Claude and Claude Code
- **The community** - For feedback and contributions

---

## 📞 Support

- **Issues:** [GitHub Issues](https://github.com/brian-lai/para-programming-plugin/issues)
- **Documentation:** [Main PARA Guide](https://github.com/brian-lai/para-programming)

---

**Build better software with structured AI collaboration! 🚀**
