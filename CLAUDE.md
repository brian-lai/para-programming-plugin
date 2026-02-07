# PARA-Programming Plugin

This document contains project-specific context only.

# CRITICAL (MUST FOLLOW RULES)
**Workflow Methodology:** Follow the global workflow guide at `~/.claude/CLAUDE.md`

## About This Project

The PARA-Programming Plugin is a CLI tool that implements the PARA (Plan → Review → Execute → Summarize → Archive) methodology for structured AI-assisted development workflows. It provides commands for managing planning documents, execution tracking, summaries, and context archival.

## Tech Stack

- **Language:** TypeScript
- **Runtime:** Node.js
- **CLI Framework:** Custom command parsing
- **File Operations:** Node.js fs module

## Structure

```
para-programming-plugin/
├── resources/          # Global CLAUDE.md methodology file
├── commands/           # CLI command implementations
├── context/            # PARA workflow directories
│   ├── data/          # Input files, payloads, datasets
│   ├── plans/         # Pre-work planning documents
│   ├── summaries/     # Post-work reports
│   ├── archives/      # Historical context snapshots
│   └── servers/       # MCP tool wrappers
└── tests/             # Test suites
```

## Key Files

- `resources/CLAUDE.md`: Global workflow methodology template
- `commands/*.md`: Command implementations and documentation

## Conventions

- All context files use `YYYY-MM-DD-` date prefixes for chronological sorting
- Commands follow `/para:command-name` naming pattern
- Markdown is used for all documentation and context files

## Getting Started

```bash
# The plugin is loaded by Claude Code automatically
# Initialize PARA structure in a project:
/para:init

# Create a plan:
/para:plan <task-description>

# Check workflow status:
/para:status
```
