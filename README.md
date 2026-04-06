# PARA-Programming Plugin for Claude Code

Structured planning, automated execution, and independent review for AI-assisted development.

PARA turns ad-hoc prompting into a disciplined engineering process: every task gets a plan, every plan gets reviewed, every implementation follows TDD, and every commit maps to a checklist item. The workflow is designed for agent teams — autonomous agents that can research, plan, execute, review, and ship multi-phase projects with minimal human intervention.

---

## Quick Start

```bash
# Install the plugin
claude plugin add brian-lai/para-programming-plugin

# Initialize in your project
/para:init

# Run your first task end-to-end
/para:research "add user authentication"
/para:plan "add user authentication"
/para:review --plan
/para:workflow
```

That's it. `/para:workflow` handles execution, PR creation, independent review, summarization, and archival — phase by phase — until the work is done.

---

## The Workflow

```
Research → Plan → Review Plan → Execute → Review PR → Summarize → Archive
```

For multi-phase work, `/para:workflow` orchestrates this loop automatically across all phases. It creates worktrees for isolation, commits per checklist item, opens PRs, runs independent subagent reviews, and merges — pausing at phase boundaries for human approval (or running fully autonomously with `--auto`).

### Manual vs. Automated

You can run each step individually or let the workflow orchestrator handle it:

| Manual | Automated |
|--------|-----------|
| `/para:research` | `/para:workflow` runs the full |
| `/para:plan` | execute → PR → review → summarize |
| `/para:review --plan` | → archive → next phase loop |
| `/para:execute` | |
| `/para:review --pr` | Use `--auto` for fully autonomous |
| `/para:summarize` | Use `--skip-review` for speed |
| `/para:archive` | |

---

## Commands

| Command | Purpose |
|---------|---------|
| `/para:init` | Initialize PARA structure in a project |
| `/para:research <task>` | Deep codebase research before planning |
| `/para:plan <task>` | Create a structured implementation plan |
| `/para:review --plan\|--pr` | Independent subagent review loop |
| `/para:execute` | Create worktree, extract todos, start TDD execution |
| `/para:workflow` | Orchestrate full cycle across phases |
| `/para:summarize` | Generate post-work summary |
| `/para:archive` | Archive context, clean up worktrees |
| `/para:status` | Show current workflow state |
| `/para:check` | Decision helper: should this task use PARA? |
| `/para:help` | Quick reference guide |

---

## How It Works

### 1. Research

`/para:research` performs deep codebase exploration and produces a structured document covering architecture, components, API contracts, existing patterns, and gaps. This becomes the primary input for planning — no more ad-hoc exploration during plan creation.

### 2. Plan

`/para:plan` creates a collaborative implementation plan through dialogue. It asks clarifying questions, drafts specs and stubs, applies engineering criteria (interface boundaries, graceful degradation, architecture decisions), and runs 2-3 self-review rounds before presenting the plan.

Every implementation step is a checkbox item. Each checkbox becomes one git commit.

### 3. Review

`/para:review` spawns an independent subagent to review plans or PRs. The reviewer categorizes issues as MUST FIX, SHOULD FIX, or NIT, and the review loops — with a fresh subagent each round — until there are no blocking issues. Max 5 rounds with convergence detection.

### 4. Execute

`/para:execute` creates an isolated git worktree and works through each checklist item following a TDD cycle: confirm spec → write tests → run red → implement → run green → commit. The checklist text is the commit message.

### 5. Workflow

`/para:workflow` is the orchestrator. For each phase: execute → create PR → review PR → summarize → merge → archive → next phase. It tracks state in `context/context.md` for resumability — if interrupted, running it again picks up where it left off.

---

## Directory Structure

### Per-Project (created by `/para:init`)

```
your-project/
├── context/
│   ├── context.md              # Active session state
│   ├── data/                   # Research docs, specs, datasets
│   ├── plans/                  # Implementation plans
│   ├── summaries/              # Post-work reports
│   ├── archives/               # Historical context snapshots
│   └── servers/                # MCP tool wrappers
├── .para-worktrees/            # Git worktree isolation (gitignored)
└── CLAUDE.md                   # Project-specific context
```

### Global (created once)

```
~/.claude/
└── CLAUDE.md                   # PARA workflow methodology (shared across all projects)
```

---

## Complete Example

```bash
# Initialize (first time only)
/para:init

# Research the codebase before planning
/para:research "add dark mode support"
# → Creates context/data/2026-04-05-add-dark-mode-research.md

# Create a plan using the research
/para:plan "add dark mode support"
# → Asks clarifying questions
# → Creates context/plans/2026-04-05-add-dark-mode.md
# → Runs self-review (2 rounds)

# Independent review of the plan
/para:review --plan
# → Subagent reviews, flags issues
# → Address MUST FIX items, re-review until approved

# Run the full workflow
/para:workflow
# → Phase 1: creates worktree, implements with TDD, opens PR
# → Subagent reviews PR, loops until approved
# → Summarizes, merges, archives
# → Phase 2: repeats...
# → All phases complete. Done.
```

---

## When to Use PARA

**Use PARA** for any task that results in git changes: features, bug fixes, refactoring, config changes, migrations, tests, complex debugging.

**Skip PARA** for read-only or informational tasks: "What does X do?", "Show me the auth logic", "Explain how caching works." Use `/para:check` if unsure.

---

## Documentation

- **[Methodology and Rationale](docs/METHODOLOGY.md)** — Deep-dive on how each command works and why the workflow is structured this way
- **[Phased Plans Quick Reference](docs/phased-plans-quick-reference.md)** — Guide for multi-phase work
- **[Phased Plan Example](docs/phased-plan-example.md)** — Worked example of a phased plan
- **[INSTALL.md](INSTALL.md)** — Detailed installation instructions
- **[CHANGELOG.md](CHANGELOG.md)** — Version history
- **[UPGRADING.md](UPGRADING.md)** — Migration and upgrade guides

---

## Plugin Structure

```
para-programming-plugin/
├── .claude-plugin/
│   ├── plugin.json             # Plugin manifest
│   └── marketplace.json        # Marketplace metadata
├── commands/                   # Slash commands (11)
│   ├── init.md                 # Initialize PARA structure
│   ├── research.md             # Deep codebase research
│   ├── plan.md                 # Collaborative planning
│   ├── review.md               # Independent subagent review
│   ├── execute.md              # TDD execution with worktrees
│   ├── workflow.md             # Full-cycle orchestrator
│   ├── summarize.md            # Post-work summaries
│   ├── archive.md              # Context archival
│   ├── status.md               # Workflow state display
│   ├── check.md                # Decision helper
│   └── help.md                 # Quick reference
├── templates/                  # File templates (8)
│   ├── plan-template.md        # Implementation plan
│   ├── phased-plan-master-template.md  # Architecture reference
│   ├── phased-plan-sub-template.md     # Phase sub-plan
│   ├── research-template.md    # Research output
│   ├── summary-template.md     # Work summary
│   ├── context-template.md     # Session state
│   ├── claude-basic-template.md    # Project CLAUDE.md (minimal)
│   └── claude-full-template.md     # Project CLAUDE.md (comprehensive)
├── hooks/                      # Event handlers
│   ├── hooks.json
│   └── para-session-start.sh
├── resources/                  # Global methodology
│   └── CLAUDE.md
└── docs/                       # Documentation
```

---

## Contributing

We welcome contributions: additional commands, templates, documentation improvements, bug fixes. See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

## License

MIT License — see [LICENSE](LICENSE) for details.

## Acknowledgments

- **Tiago Forte** — For the PARA method
- **Anthropic** — For Claude and Claude Code

---

**[Read the full methodology and rationale](docs/METHODOLOGY.md)**
