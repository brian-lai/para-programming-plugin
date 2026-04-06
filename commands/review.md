# Command: review

Spawn an independent subagent with a Staff+ FAANG engineer persona to review a plan or PR. The review loops until the reviewer explicitly approves.

## Usage

```
/para:review --plan                    # Review the active plan
/para:review --plan=path/to/plan.md    # Review a specific plan file
/para:review --pr                      # Review the current branch's changes as a PR
/para:review --pr=123                  # Review a specific PR number
/para:review --approve                 # Override: skip remaining review rounds and approve
```

## Staff+ FAANG Engineer Reviewer Persona

The subagent receives the following persona instructions:

> You are a Staff+ engineer at a FAANG company reviewing this work. You have high standards for:
> - **Architecture:** Clean boundaries, appropriate abstractions, no over-engineering
> - **Correctness:** Logic errors, race conditions, edge cases, error handling
> - **Testing:** TDD adherence, test coverage, test quality (not just quantity)
> - **Maintainability:** Code clarity, naming, documentation where needed
> - **Security:** Input validation, injection risks, secrets handling
> - **Performance:** Obvious inefficiencies, N+1 queries, unnecessary allocations
>
> Be specific and actionable in feedback. Reference exact file paths and line numbers.
> Categorize each issue as: **MUST FIX** (blocks approval) | **SHOULD FIX** (strong recommendation) | **NIT** (optional improvement).
> When there are no remaining MUST FIX issues, explicitly state: "APPROVED — ready to proceed."

## Plan Review Process

When `--plan` is specified:

1. **Identify the plan** — read from `context/context.md` active plan (or use the path provided).

2. **Spawn a subagent** with the Staff+ persona. The subagent reads the full plan (and all sub-plans for phased plans) and checks:
   - Are all interface boundaries identified with contracts?
   - Is TDD ordering correct (tests before implementation)?
   - Are checklist items atomic and commit-message-ready?
   - Is graceful degradation addressed for external dependencies?
   - Is scope appropriate (not over-engineered)?
   - Are architecture decisions documented with rationale?
   - Are test annotations concrete (function signatures, not vague descriptions)?

3. **Present review results** to the user with issues categorized as MUST FIX / SHOULD FIX / NIT.

## PR Review Process

When `--pr` is specified:

1. **Identify the PR** — use the current branch's PR (or the PR number provided). Run `gh pr diff` to get the full diff.

2. **Spawn a subagent** with the Staff+ persona. The subagent reads the diff, the changed files, and the active plan, then checks:
   - Does each commit match a plan checklist item?
   - Are tests written before implementation (check commit order)?
   - Do tests actually test meaningful behavior (not just smoke tests)?
   - Are there any untested code paths?
   - Does the code follow project conventions and patterns?
   - Are there any security concerns (input validation, secrets, injection)?

3. **Present review results** to the user with issues categorized as MUST FIX / SHOULD FIX / NIT.

## Review Loop

After the initial review (plan or PR), the loop proceeds:

4. **Address issues** — implement fixes for all MUST FIX items. Apply SHOULD FIX items where appropriate. NITs are optional.

5. **Re-submit for review** — spawn a **fresh** subagent (not the same one) with the Staff+ persona for independent re-review. A fresh subagent avoids anchoring bias from the previous round.

6. **Loop until approved** — repeat steps 4-5 until the reviewer explicitly states "APPROVED."

7. **Record approval** — note in `context/context.md` progress notes: "Staff+ review: APPROVED (N rounds)".

## Convergence & Escalation

**Maximum rounds:** 5. If the review has not converged after 5 rounds, escalate to the user:

> "Review has not converged after 5 rounds. Here are the remaining issues: [list]. Would you like to:
> 1. Continue addressing issues
> 2. Override and approve (`/para:review --approve`)
> 3. Revise the approach"

**Convergence check:** If two consecutive rounds produce the same MUST FIX issues (no progress), escalate immediately rather than waiting for round 5. This prevents infinite loops where fixes for one issue reintroduce another.

## Override

When `--approve` is specified:

1. Skip all remaining review rounds
2. Record in `context/context.md` progress notes: "Staff+ review: OVERRIDDEN by user"
3. Proceed to the next workflow step

Use sparingly — the review loop exists to catch real issues. Override is for cases where:
- The reviewer is flagging stylistic preferences that don't apply to this project
- The remaining issues are known and intentionally deferred
- Time pressure requires proceeding despite open items

## Notes

- Each review round spawns a fresh subagent for independence — never continue a previous reviewer's context
- The reviewer sees the same persona instructions every round for consistency
- Plan reviews check the plan document(s); PR reviews check the diff and commit history
- Review results are presented to the user, not silently applied — the user decides what to fix
- The `--approve` flag is a user-initiated override, not an automatic approval
