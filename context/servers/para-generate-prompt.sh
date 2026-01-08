#!/bin/bash
# para-generate-prompt.sh - Generate a prompt for Claude to load files
# Usage: ./para-generate-prompt.sh <plan-key>

set -e

PLAN_KEY="$1"

if [ -z "$PLAN_KEY" ]; then
  echo "Error: Plan key required" >&2
  echo "Usage: $0 <plan-key>" >&2
  echo "" >&2
  echo "Example: $0 CONTEXT-001" >&2
  exit 1
fi

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# Get resolved file paths using para-resolve-paths.sh
RESOLVED_PATHS=$("$SCRIPT_DIR/para-resolve-paths.sh" "$PLAN_KEY" 2>/dev/null)

if [ -z "$RESOLVED_PATHS" ]; then
  echo "No files tracked for plan key: $PLAN_KEY" >&2
  exit 0
fi

# Generate prompt
echo "Please read the following files for $PLAN_KEY:"
echo ""

while IFS= read -r FILE; do
  echo "- $FILE"
done <<< "$RESOLVED_PATHS"

echo ""
echo "These files contain the relevant context for the current work."
