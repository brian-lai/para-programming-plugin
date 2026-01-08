#!/bin/bash
# para-validate-files.sh - Validate which tracked files exist or are missing
# Usage: ./para-validate-files.sh <plan-key>

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

# Get list of files using para-list-files.sh
FILES=$("$SCRIPT_DIR/para-list-files.sh" "$PLAN_KEY" 2>/dev/null)

if [ -z "$FILES" ]; then
  echo "No files tracked for plan key: $PLAN_KEY"
  exit 0
fi

# Track counts
FOUND=0
MISSING=0
MISSING_FILES=()

# Check each file
while IFS= read -r FILE; do
  if [ -f "$FILE" ]; then
    echo "✅ $FILE"
    ((FOUND++))
  else
    echo "❌ $FILE"
    MISSING_FILES+=("$FILE")
    ((MISSING++))
  fi
done <<< "$FILES"

# Summary
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Summary for $PLAN_KEY:"
echo "  Found: $FOUND file(s)"
echo "  Missing: $MISSING file(s)"

if [ $MISSING -gt 0 ]; then
  echo ""
  echo "Missing files:"
  for FILE in "${MISSING_FILES[@]}"; do
    echo "  - $FILE"
  done
  echo ""
  echo "💡 Tip: Run para-sync to update the file list"
  exit 1
else
  echo ""
  echo "✨ All files found!"
  exit 0
fi
