# PARA-Programming Plugin for Claude Code

**Official Claude Code plugin for the PARA-Programming methodology**

Structured context management, persistent memory, and intelligent execution for AI-assisted development.

---

## 🚀 Quick Start

### Installation

```bash
# Add the PARA-Programming marketplace
claude plugin marketplace add brian-lai/para-programming-plugin

# Install the plugin
claude plugin install para-programming@brian-lai --scope user

# Initialize in your project
cd your-project
claude
/para-init
```

### First Task

```bash
# Start your first PARA task
/para-plan "implement user authentication"

# Review the plan (human approval step)

# Execute the plan
/para-execute

# Work through to-dos...

# Summarize when complete
/para-summarize
```

---

## 📋 What This Plugin Provides

### Slash Commands

- `/para-init` - Initialize PARA structure in project
- `/para-plan` - Create structured plan for task
- `/para-execute` - Start execution with branch and to-dos
- `/para-summarize` - Generate summary from completed work
- `/para-archive` - Archive context and reset
- `/para-status` - Show current workflow state
- `/para-check` - Decision helper for workflow

### Templates

- Plan template with Objective, Approach, Risks
- Summary template for documenting results
- Context template for session state
- Project CLAUDE.md templates (basic and full)

### Hooks

- Session start notifications
- Workflow guidance

---

## 🔁 The PARA Workflow

```
(Plan) → (Review) → (Execute) → (Summarize) → (Archive)
   ↓         ↑          ↓              ↓            ↓
/para-plan  Human   /para-execute  /para-summarize  /para-archive
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
├── hooks/                   # Event handlers
├── templates/               # File templates
├── resources/               # Global methodology
└── examples/                # Usage examples
```

---

## 🤝 Contributing

We welcome contributions! See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

---

## 📄 License

MIT License - see [LICENSE](LICENSE) for details.

---

## 🙏 Acknowledgments

- **Tiago Forte** - For the PARA method
- **Anthropic** - For Claude and Claude Code
- **The community** - For feedback and contributions

---

**Build better software with structured AI collaboration! 🚀**
