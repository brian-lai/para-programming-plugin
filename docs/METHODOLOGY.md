# PARA-Programming: Methodology and Rationale

This document explains how the PARA-Programming workflow is structured, what each command does under the hood, and why we believe this is the correct approach for building long-running tasks and systems with AI agents.

---

## Table of Contents

- [Motivation](#motivation)
- [The Problem](#the-problem)
- [The Workflow](#the-workflow)
- [Design Principles](#design-principles)
- [Commands In Depth](#commands-in-depth)
  - [init](#init)
  - [research](#research)
  - [plan](#plan)
  - [review](#review)
  - [execute](#execute)
  - [workflow](#workflow)
  - [summarize](#summarize)
  - [archive](#archive)
  - [status](#status)
  - [check](#check)
  - [help](#help)
- [Why This Structure Works](#why-this-structure-works)
- [The Agent Team Pattern](#the-agent-team-pattern)

---

## Motivation

PARA-Programming emerged from three insights about how AI collaboration should work.

**Treat AI as a pair-programming partner, not a code generator.** Like pair programming with a human, effective AI collaboration requires shared understanding through plans, review gates before execution, documented decisions and rationale, and clear communication of intent. The goal is collaboration, not delegation.

**Apply human-in-the-loop data pipeline principles.** The workflow's structure draws from experience building data pipelines for scientists working with non-deterministic data — systems where humans reviewed intermediate results before proceeding, creating audit trails of "what was analyzed, when, and why." Software development has the same properties: code changes are non-deterministic (many valid approaches), engineers need to review the AI's approach before implementation, and audit trails enable debugging and knowledge transfer. PARA applies the same pattern: structured phases with human review gates between each.

**Externalize memory into structure for token efficiency.** The `context/` directory acts as externalized long-term memory. Instead of loading an entire codebase into every prompt, PARA keeps only the relevant context active — the current plan, research docs, and progress state. The AI loads what it needs from the structured file system rather than carrying everything in context. This mirrors how human cognition works: short-term memory (the context window) is small and focused, while long-term memory (the file system) is large and persistent. The result is substantial token reduction through externalized memory, as demonstrated by [Anthropic's research on Model Context Protocol](https://www.anthropic.com/engineering/code-execution-with-mcp) which showed that externalized computation allows models to focus on reasoning with minimal, purposeful context.

---

## The Problem

AI-assisted development tends toward one of two failure modes:

1. **Ad-hoc prompting.** The developer types "add feature X" and hopes the agent gets it right. There's no plan, no review, no structured handoff. The agent explores the codebase on the fly, makes assumptions, and produces code that may or may not integrate well. Context is lost between sessions. There's no audit trail of what was built or why.

2. **Over-specification.** The developer writes a detailed specification up front and hands it to the agent as a single prompt. The agent follows instructions literally but can't adapt when the spec is wrong or incomplete. There's no feedback loop, no collaborative refinement, and no quality gate between planning and execution.

PARA addresses both by structuring the collaboration as a loop — Research, Plan, Review Plan, Execute, Review PR, Summarize, Archive — where each phase has a clear purpose, defined inputs and outputs, and explicit quality gates.

---

## The Workflow

```
Research → Plan → Review Plan → Execute → Review PR → Summarize → Archive
```

Each step produces an artifact that feeds the next:

| Step | Input | Output | Quality Gate |
|------|-------|--------|-------------|
| Research | Task description | `context/data/*-research.md` | Completeness check |
| Plan | Research doc + codebase | `context/plans/*.md` | 2-3 self-review rounds |
| Review Plan | Plan document | Approval or issues | Independent subagent |
| Execute | Approved plan | Git commits (1 per checklist item) | TDD (red → green) |
| Review PR | PR diff + plan | Approval or issues | Independent subagent |
| Summarize | Git diff + plan | `context/summaries/*.md` | — |
| Archive | Context state | `context/archives/*.md` | — |

For multi-phase work, `/para:workflow` orchestrates this loop across all phases automatically.

---

## Design Principles

### Research Before Planning

Planning from assumptions produces bad plans. The research phase forces deep codebase exploration before any decisions are made. The output is a structured document that serves as compressed context — a planner reading only the research doc should have enough information to create a detailed implementation plan without additional exploration.

This separation matters because research and planning are different cognitive tasks. Research is divergent: cast a wide net, discover patterns, find gaps. Planning is convergent: make decisions, define scope, order steps. Combining them leads to shallow research (you stop exploring once you have "enough" to start planning) or unfocused plans (you keep discovering new things mid-plan).

### Checklist Items Are Commit Messages

Every implementation step in a PARA plan is written as a checkbox item (`- [ ] ...`). During execution, the checkbox text becomes the git commit message verbatim. This creates a direct, auditable link between the plan and the implementation.

This constraint forces plan authors to write atomic, concrete steps. You can't write "implement the auth system" as a single checkbox — that's not a useful commit message. You're forced to decompose: "Add JWT validation middleware," "Create user session store," "Wire auth middleware into route handlers." Each item is one logical change, one commit, one reviewable unit.

### Independent Review via Subagents

Self-review catches errors, but it has a ceiling — you can't spot your own blind spots. PARA uses independent subagents for review: a separate agent that hasn't seen the planning process, doesn't share the planner's assumptions, and starts fresh with the artifact.

Each review round spawns a fresh subagent to prevent anchoring bias. The reviewer categorizes issues by severity (MUST FIX blocks approval, SHOULD FIX is a strong recommendation, NIT is optional), creating a clear decision framework. The loop continues until there are no blocking issues, with a cap at 5 rounds and convergence detection to prevent infinite loops.

### Worktree Isolation

During execution, PARA creates an isolated git worktree (`.para-worktrees/{task-name}`). The agent works entirely within this directory — all edits, test runs, and commits happen there. The main working tree stays untouched on whatever branch you were on.

This matters for agent workflows because it means you can continue working in your main tree while the agent executes in parallel. It also prevents accidental contamination: the agent can't modify files you're actively editing, and your work-in-progress can't leak into the agent's commits.

### Spec-Driven TDD

Before writing any code, the plan creates a spec file (OpenAPI, TypeScript interfaces, or markdown contract) and stub source files with signatures matching the spec. Tests are written against the stubs. Only then does implementation begin.

The TDD cycle in PARA is explicit about the "red" and "green" phases:

1. Confirm spec + stubs exist
2. Write tests (against stubs)
3. Run tests — see them fail (red). Confirm they fail for the right reason.
4. Implement — replace stub bodies with real logic
5. Run tests — see them pass (green)
6. Commit with the checklist item text as the message

This isn't TDD as an aspiration. It's TDD as a structural constraint enforced by the execution process.

### Context as Persistent Memory

All PARA artifacts live in the `context/` directory: plans, summaries, archives, research docs, specs. The master file (`context/context.md`) tracks what's active, what's completed, and what state the workflow is in. This metadata enables resumability — if a workflow is interrupted, it can pick up exactly where it left off.

Archives are never deleted. They form a searchable project memory: what was planned, what was built, what was learned, and what decisions were made. This is especially valuable for agent workflows where the agent may not have access to previous conversation history.

---

## Commands In Depth

### init

**Purpose:** Scaffold the PARA structure in a project.

**What it does:**
- Creates the `context/` directory tree (data, plans, summaries, archives, servers)
- Installs the global methodology file to `~/.claude/CLAUDE.md` (if missing — never overwrites)
- Creates a project-level `CLAUDE.md` from a template (basic or full)
- Creates the initial `context/context.md` with empty JSON metadata
- Adds `.para-worktrees/` to `.gitignore`

**Why it matters:** The directory structure is the foundation. Without it, no other command works. The methodology file in `~/.claude/CLAUDE.md` ensures consistent behavior across all projects. The `.gitignore` entry prevents worktree directories from being accidentally committed.

---

### research

**Purpose:** Deep codebase exploration producing a structured, context-compressed document.

**What it does:**
1. Clarifies scope with the user (using AskUserQuestion if the task is ambiguous)
2. Performs thorough codebase investigation: file structure, interfaces, contracts, test patterns, dependencies, error handling, logging
3. Cross-references API specs with implementation, flagging inconsistencies
4. Documents conventions and patterns (error handling, dependency injection, config management)
5. Writes findings to `context/data/YYYY-MM-DD-task-name-research.md`
6. Updates `context/context.md` with a reference to the research doc

**Key flags:**
- `--scope=<area>` — focus research on a specific part of the codebase
- `--specs` — emphasize API contract analysis

**Why it exists separately from planning:** Research is divergent (explore broadly), planning is convergent (make decisions). Keeping them separate means the research doc captures everything relevant, not just what the planner thought to look for. It also enables reuse — the same research doc can inform multiple plans.

---

### plan

**Purpose:** Collaboratively create a detailed, TDD-ordered implementation plan.

**What it does:**
1. Asks 1-4 clarifying questions before exploring anything
2. Checks for an existing research doc and uses it as primary input
3. Explores the codebase for patterns, conventions, interface boundaries, and test structure
4. Creates a spec file and stub source files
5. Determines whether the work needs a simple plan or a phased plan (master + sub-plans)
6. Drafts the plan with engineering criteria: core principles, architecture decisions, interface boundaries, graceful degradation, and checklist-style implementation steps with test annotations
7. Runs 2-3 self-review rounds (correctness, TDD ordering, consistency)
8. Presents the plan and asks the user how to proceed

**Plan structure:** Plans include architecture sections (decisions table, interface boundaries, graceful degradation) for context, and checklist-style implementation steps for execution. Each checklist item maps 1:1 to a git commit. Test annotations on each step specify concrete function signatures and assertions.

**Phased plans:** For complex work (>5-10 files, multiple architectural layers), the plan splits into a concise master plan (architecture-only, 1-3 pages) and self-contained sub-plans (one per phase). Each sub-plan copies the relevant context from the master plan so it can be executed independently.

**Why self-review is built in:** The plan command runs 2-3 review rounds automatically before showing the plan to the user. Round 1 checks correctness and completeness. Round 2 checks TDD ordering and test coverage. Round 3 (conditional) checks consistency across sub-plans. This catches the most common planning errors before they reach human review.

---

### review

**Purpose:** Independent quality gate using a subagent reviewer.

**What it does:**
1. Identifies the review target (plan document or PR diff)
2. Spawns a subagent with a senior engineer persona focused on architecture, correctness, testing, maintainability, security, and performance
3. The subagent reads the artifact and produces categorized feedback:
   - **MUST FIX** — blocks approval
   - **SHOULD FIX** — strong recommendation
   - **NIT** — optional improvement
4. Issues are presented to the user
5. After fixes, a fresh subagent is spawned for re-review (with the previous issue list and what was changed as context)
6. Loops until the reviewer states "APPROVED" or the user overrides

**Plan reviews check:** Interface boundaries, TDD ordering, checklist atomicity, graceful degradation, scope, architecture decisions, test annotation concreteness.

**PR reviews check:** Commit-plan alignment, test ordering in commit history, test quality, untested code paths, conventions, security.

**Convergence rules:** Max 5 rounds. If two consecutive rounds produce the same MUST FIX issues (no progress), escalate immediately. The user can override with `--approve` at any time.

**Why fresh subagents each round:** Continuing the same reviewer creates anchoring bias — they've already formed an opinion and may not re-evaluate with fresh eyes. A new subagent starts from the artifact itself, informed by (but not anchored to) the previous round's findings.

---

### execute

**Purpose:** Implement the plan with TDD in an isolated worktree.

**What it does:**
1. Reads the active plan from `context/context.md`
2. Creates an isolated git worktree from `origin/main`
3. Extracts checkbox items from the plan as todos
4. For each todo, follows the 6-step TDD cycle:
   - Confirm spec + stubs exist
   - Write tests first
   - Run tests to see them fail (red)
   - Implement to make tests pass
   - Run tests to see them pass (green)
   - Mark complete and commit with the checklist item text as the commit message
5. After all todos, suggests running `/para:review --pr`

**Why worktrees:** Git worktrees give full isolation without the overhead of cloning the repository. The agent works in `.para-worktrees/{task-name}/` while your main working tree stays exactly where it is. This is essential for agent teams — multiple agents can work on different phases in parallel, each in their own worktree.

**Why commit per todo:** Each commit represents one logical change, making the PR reviewable and the git history useful. If something breaks, you can bisect to the exact commit. If a review round requires changes, they're additional commits on top of the plan-driven ones, making the review trail clear.

---

### workflow

**Purpose:** Orchestrate the full execute → PR → review → summarize → archive → next phase cycle.

**What it does:** For each phase in the plan:
1. Runs `/para:execute --phase=N`
2. Creates a PR with auto-generated title and body
3. Runs `/para:review --pr` (subagent review loop)
4. Runs `/para:summarize --phase=N`
5. Merges the PR
6. Archives the phase context
7. Pulls latest main and starts the next phase

**Modes:**
- **Default** — pauses at phase boundaries ("Ready to start Phase 2?") and before merging
- **`--auto`** — fully autonomous, no pauses between phases
- **`--skip-review`** — skips the subagent review loop for speed

**State tracking:** Workflow progress is tracked in `context/context.md` metadata. If interrupted, running `/para:workflow` again resumes from the current step of the current phase.

**Why this command exists:** Without it, multi-phase execution requires manually running 6-7 commands per phase. The workflow command eliminates this overhead while preserving all quality gates. It's the primary interface for agent team workflows — you set it up and let it run.

---

### summarize

**Purpose:** Generate a post-execution summary documenting changes, rationale, and learnings.

**What it does:**
1. Analyzes git changes in the worktree (diff against main, commit history)
2. Reviews the active plan for context
3. Creates a summary document with: what changed, why, key learnings, and test results
4. Updates `context/context.md` to move the plan from active to completed
5. Suggests next steps (push branch, create PR, archive)

**Why formal summaries:** Summaries create institutional memory. When a future agent (or human) asks "why was this built this way?", the summary provides the answer — linked to the plan that motivated it and the commits that implemented it.

---

### archive

**Purpose:** Clean up worktrees and create a fresh context for the next task.

**What it does:**
1. Removes git worktrees created during execution
2. Moves `context/context.md` to `context/archives/YYYY-MM-DD-HHMM-context.md`
3. Creates a fresh `context/context.md` with references to completed summaries

**Safety:** Never force-removes worktrees with uncommitted changes. Archives are preserved indefinitely — they're the project's memory.

---

### status

**Purpose:** Display current workflow state and suggest next action.

**What it does:** Parses `context/context.md`, checks worktree health (active, stale, orphaned), determines workflow state (idle, planning, executing, summarized), and suggests the appropriate next command.

---

### check

**Purpose:** Quick decision helper — does this task need PARA?

**Logic:** Does it result in git changes? If yes, use PARA. If no (questions, explanations, navigation), skip it.

---

### help

**Purpose:** One-page quick reference with all commands, the typical flow, and file structure.

---

## Why This Structure Works

### For Long-Running Tasks

Long-running tasks fail when context is lost, scope creeps, or quality degrades over time. PARA addresses each:

- **Context preservation.** Research docs, plans, and summaries persist in `context/`. The workflow state in `context/context.md` enables resumability. Archives preserve the full history. An agent picking up work days later has everything it needs.

- **Scope containment.** The plan defines exactly what will be built — as a checklist of atomic items. Each item becomes one commit. There's no room for scope creep because the execution process follows the checklist literally. New requirements go into a new plan.

- **Quality maintenance.** Independent review at both the plan and PR stages catches issues before they compound. TDD ensures each change is tested. The commit-per-checklist-item structure means every change is reviewable in isolation.

### For Agent Teams

Agent team workflows — where multiple agents collaborate on a task — need structure that humans take for granted: shared understanding of what's being built, who's responsible for what, and how to verify quality.

PARA provides this structure:

- **Shared plan as contract.** The plan document is the single source of truth. The executing agent follows it. The reviewing agent checks against it. The summarizing agent references it.

- **Independent review prevents echo chambers.** The reviewing subagent hasn't seen the planning process and doesn't share the planner's assumptions. Fresh subagents each round prevent anchoring. This is the agent equivalent of code review — a second pair of eyes that can challenge decisions.

- **Worktree isolation enables parallelism.** Each phase gets its own worktree and branch. Multiple agents can work on different phases simultaneously. The workflow orchestrator manages the sequencing and merge order.

- **Resumability handles interruptions.** Agent workflows get interrupted — context limits, timeouts, user intervention. The workflow state in `context/context.md` means any agent can pick up exactly where the previous one left off.

### For Humans Supervising Agents

PARA gives humans control without requiring micromanagement:

- **Pause points.** The default workflow mode pauses at phase boundaries and before merging. The human can inspect, redirect, or stop.

- **Audit trail.** Every decision is documented: plans explain what and why, commits show what was built, reviews show what was challenged, summaries capture learnings.

- **Override capability.** The human can approve reviews early, skip phases, or abort the workflow. The system provides guardrails, not handcuffs.

---

## The Agent Team Pattern

The full agent team workflow looks like this:

```
Human: "Build feature X"
  ↓
Agent 1 (Researcher): Deep codebase exploration → research doc
  ↓
Agent 2 (Planner): Research doc → detailed plan with checklist
  ↓
Agent 3 (Reviewer): Independent plan review → approval
  ↓
Agent 4 (Executor): Plan → implementation with TDD → commits
  ↓
Agent 5 (Reviewer): Independent PR review → approval
  ↓
Agent 6 (Summarizer): Changes → summary document
  ↓
[Repeat for each phase]
```

In practice, `/para:workflow` handles agents 4-6 in a loop across all phases. The human's involvement is:

1. Describe the task
2. Answer clarifying questions during planning
3. Approve the plan (or delegate to `/para:review --plan`)
4. Run `/para:workflow` (or `/para:workflow --auto`)
5. Review the final result

Everything in between is automated, quality-gated, and resumable.
