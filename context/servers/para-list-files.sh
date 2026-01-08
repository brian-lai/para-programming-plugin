#!/bin/bash
# para-list-files.sh - List files tracked for a plan key
# Usage: ./para-list-files.sh <plan-key>

set -e

PLAN_KEY="$1"

if [ -z "$PLAN_KEY" ]; then
  echo "Error: Plan key required" >&2
  echo "Usage: $0 <plan-key>" >&2
  echo "" >&2
  echo "Example: $0 CONTEXT-001" >&2
  exit 1
fi

CONTEXT_FILE="context/context.md"

if [ ! -f "$CONTEXT_FILE" ]; then
  echo "Error: $CONTEXT_FILE not found" >&2
  exit 1
fi

# Check if jq is installed
if ! command -v jq &> /dev/null; then
  echo "Error: jq is required but not installed" >&2
  echo "Install with: brew install jq (macOS) or apt-get install jq (Linux)" >&2
  exit 1
fi

# Extract JSON block from context.md (between ```json and ```)
JSON=$(sed -n '/```json/,/```/p' "$CONTEXT_FILE" | sed '1d;$d')

if [ -z "$JSON" ]; then
  echo "Error: No JSON block found in $CONTEXT_FILE" >&2
  exit 1
fi

# Check if plan key exists
if ! echo "$JSON" | jq -e ".active_context[\"$PLAN_KEY\"]" > /dev/null 2>&1; then
  echo "Error: Plan key '$PLAN_KEY' not found in active_context" >&2
  echo "" >&2
  echo "Available plan keys:" >&2
  echo "$JSON" | jq -r '.active_context | keys[]' 2>/dev/null | sed 's/^/  - /' >&2
  exit 1
fi

# Extract and output files array
FILES=$(echo "$JSON" | jq -r ".active_context[\"$PLAN_KEY\"].files[]?" 2>/dev/null)

if [ -z "$FILES" ]; then
  echo "No files tracked for plan key: $PLAN_KEY" >&2
  exit 0
fi

# Output each file
echo "$FILES"
