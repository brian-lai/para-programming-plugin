# Changelog

All notable changes to the PARA-Programming Claude Code skill will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Planned

- MCP tool implementations for automation
- GitHub Actions workflow for CI/CD
- Example projects demonstrating PARA methodology
- Video tutorials and screencasts
- Plugin API integration when available
- Additional language-specific templates
- Team collaboration features
- VS Code extension for non-Claude-Code users

## [2.1.0] - 2026-04-24

### Added

- **Canonical context.md schema** (`templates/context-schema.md`) — single source of truth for all `context/context.md` JSON fields, with field tables and three examples (idle, simple-plan, phased execution)
- **Motivation section** in `docs/METHODOLOGY.md` — preserves unique content from retired PRESENTATION.md (pair-programming philosophy, human-in-the-loop data-pipeline parallel, token-efficiency framing)

### Changed

- **Schema consolidation:** 7 files now reference `templates/context-schema.md` instead of inlining partial JSON schema subsets
- **Template wiring:** All 6 previously-orphaned templates are now referenced by their commands (plan-template, phased-plan templates, claude templates, context-template)
- **Plan template** (`templates/plan-template.md`) — added `## Spec` and `## Stubs` sections; renamed `## Risks & Edge Cases` to `## Risks` to match command spec
- **Phase-split criteria** (`commands/plan.md`) — replaced vague heuristic with 3 concrete triggers
- **PR-creation handoff** — clarified ownership between `/para:summarize` (standalone) and `/para:workflow` (orchestrated)
- **Workflow loop phrasing** — all 4 canonical files now use identical 7-step form with qualified review labels
- **resources/CLAUDE.md** — added 5-round review cap mention and spec-first TDD default note
- **README.md** — updated plugin-structure tree (9 templates, added examples/, removed scripts/)

### Removed

- `scripts/install.sh` and `scripts/uninstall.sh` — obsolete symlink-based install model
- `PRESENTATION.md` — unique content preserved in `docs/METHODOLOGY.md`
- `UPGRADING.md` — assumed obsolete symlink install model
- `RELEASE-NOTES.md` — frozen at v1.0.0; CHANGELOG.md is authoritative
- Dead `--branch=name` flag from `commands/execute.md`

## [2.0.0] - 2026-04-05

### Added

- **Staff+ Agent Workflow:** Full 7-step workflow loop — Research → Plan → Review Plan → Execute → Review PR → Summarize → Archive
- **New commands:** `/para:research` (deep codebase exploration), `/para:review` (Staff+ subagent review with 5-round convergence), `/para:workflow` (multi-phase orchestrator with `--auto` mode)
- **Research template** (`templates/research-template.md`) for structured codebase analysis output
- **Comprehensive methodology doc** (`docs/METHODOLOGY.md`) covering design philosophy, command deep-dives, and agent team patterns

### Changed

- **Plan command** (`commands/plan.md`): added research doc check, checklist=commit rule, 2-3 round self-review loop, Staff+ review option
- **Execute command** (`commands/execute.md`): reconciled TDD cycle to 6 spec-first steps (red → green → commit), enforced checklist text as commit message
- **Plan templates** (`templates/plan-template.md`, `templates/phased-plan-master-template.md`, `templates/phased-plan-sub-template.md`): restructured for TDD ordering, architecture decision tables, progressive regression
- **Help command** (`commands/help.md`): updated to 11 commands with workflow diagram
- **Global methodology** (`resources/CLAUDE.md`): complete v2 rewrite with 7-step workflow, research and dual review steps
- **README.md**: full rewrite with workflow-first positioning, all 11 commands listed, v2 examples
- **Version bump:** plugin manifests updated from v1.6.2 to v2.0.0

### Fixed

- Removed broken CONTRIBUTING.md link from README

## [1.2.0] - 2026-01-09

### Changed

- **BREAKING: Shortened Command Prefix:**
  - Changed plugin name from `para-program` to `para`
  - All commands now use shorter prefix: `/para:<command>` instead of `/para-program:<command>`
  - Example: `/para:plan`, `/para:execute`, `/para:status`
  - Update your muscle memory and scripts accordingly!

## [1.1.0] - 2026-01-09

### Added

- **Global CLAUDE.md Setup:**
  - `/para:init` now includes global CLAUDE.md setup step
  - Added `resources/` directory with CLAUDE.md template
  - Updated install script to handle global file setup

### Changed

- **Command Pattern Simplification:**
  - Simplified command pattern to `/para-program:<command>` format
  - Removed redundant `para-` prefix from individual command names
  - Updated init command output to show correct command prefixes

### Fixed

- Fixed command prefix display in `/para:init` output
- Fixed summarize and archive workflow issues
- Corrected plugin installation syntax in documentation

### Documentation

- Updated README with plugin-focused content
- Updated INSTALL.md with global setup instructions
- Emphasized commit-per-todo workflow in `/para:execute` command

## [1.0.0] - 2025-11-24

### Added

- **Slash Commands:**
  - `/para-program:init` - Initialize PARA structure in projects
  - `/para-program:plan` - Create structured planning documents
  - `/para-program:execute` - Start execution with branch and to-dos
  - `/para-program:summarize` - Generate summaries from work sessions
  - `/para-program:archive` - Archive completed contexts
  - `/para-program:status` - Display current workflow state
  - `/para-program:check` - Decision helper for workflow application
  - `/para-program:help` - Comprehensive PARA guide

- **Templates:**
  - Plan template with standard structure
  - Summary template for documenting results
  - Context template for session state
  - Basic and full CLAUDE.md templates for projects

- **Installation:**
  - Automated installation script (install.sh)
  - Automated uninstallation script (uninstall.sh)
  - Manual installation instructions
  - Cross-platform support (macOS, Linux, Windows)

- **Documentation:**
  - Comprehensive README with examples
  - Detailed INSTALL guide
  - Example workflow walkthrough
  - Troubleshooting section

- **Workflow Enforcement:**
  - Updated CLAUDE.md with strict workflow adherence rules
  - Clear decision tree for when to use PARA workflow
  - Examples of appropriate vs. inappropriate workflow usage

### Features

- **Automated Context Management:**
  - Date-prefixed files for chronological ordering
  - JSON-based context tracking
  - Automatic updates to context.md

- **Workflow Guidance:**
  - Intelligent next-action suggestions
  - Status detection (planning, executing, ready to summarize, etc.)
  - Built-in decision support for workflow application

- **Token Efficiency:**
  - MCP tool support for preprocessing
  - Structured templates minimize boilerplate
  - Selective context loading

- **Audit Trail:**
  - Complete history via archives
  - Timestamped plans and summaries
  - Git-integrated change tracking

---

## Version History

- **2.1.0** - Cleanup release: canonical schema, template wiring, prompt polish, docs consolidation
- **2.0.0** - Staff+ agent workflow: research, review, workflow commands; TDD-first execution; comprehensive methodology doc
- **1.2.0** - Shortened command prefix from `para-program` to `para`
- **1.1.0** - Global CLAUDE.md setup, command pattern simplification, bug fixes
- **1.0.0** - Initial release with core commands and documentation
