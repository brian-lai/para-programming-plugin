#!/bin/bash
#
# PARA-Programming SessionStart Hook
# Provides contextual guidance when Claude Code starts
#

# Get plugin directory (where this script lives)
PLUGIN_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# Check for version updates
VERSION_FILE="$HOME/.claude/.para-version-seen"
CURRENT_VERSION=$(grep '"version"' "$PLUGIN_DIR/.claude-plugin/plugin.json" | head -1 | sed 's/.*"version": "\(.*\)".*/\1/')

# Initialize version tracking if needed
mkdir -p "$HOME/.claude"
if [ ! -f "$VERSION_FILE" ]; then
    echo "$CURRENT_VERSION" > "$VERSION_FILE"
    LAST_VERSION=""
else
    LAST_VERSION=$(cat "$VERSION_FILE")
fi

# Check if version changed
VERSION_CHANGED=false
if [ -n "$LAST_VERSION" ] && [ "$LAST_VERSION" != "$CURRENT_VERSION" ]; then
    VERSION_CHANGED=true
    echo "$CURRENT_VERSION" > "$VERSION_FILE"
fi

# Build version update message if applicable
VERSION_MSG=""
if [ "$VERSION_CHANGED" = true ]; then
    VERSION_MSG="🎉 PARA-Programming updated to v${CURRENT_VERSION}\n   What's new: https://github.com/brian-lai/para-programming-plugin/releases/tag/v${CURRENT_VERSION}\n\n"
fi

# Check if context directory exists
if [ ! -d "context" ]; then
    # PARA not initialized in this project
    cat <<EOF
{
  "systemMessage": "${VERSION_MSG}💡 PARA-Programming available\n   Run /para:init to set up | /para:help for guide"
}
EOF
    exit 0
fi

# PARA is initialized - check status
ACTIVE_PLANS=$(find context/plans -name "*.md" -type f 2>/dev/null | wc -l | tr -d ' ')
SUMMARIES=$(find context/summaries -name "*.md" -type f 2>/dev/null | wc -l | tr -d ' ')

# Check if context.md exists and extract current state
if [ -f "context/context.md" ]; then
    CONTEXT_SUMMARY=$(head -3 context/context.md | tail -1 | sed 's/^[[:space:]]*//')
else
    CONTEXT_SUMMARY="No active work"
fi

# Build status message with better formatting
STATUS_LINE="📋 PARA: ${ACTIVE_PLANS} plan(s) • ${SUMMARIES} summary(ies)"

# Add current work if meaningful
if [[ ! "$CONTEXT_SUMMARY" =~ "Ready to start" ]] && [ -n "$CONTEXT_SUMMARY" ]; then
    # Truncate and clean up the summary
    CLEAN_SUMMARY=$(echo "$CONTEXT_SUMMARY" | sed 's/\*\*//g' | cut -c1-60)
    if [ ${#CONTEXT_SUMMARY} -gt 60 ]; then
        CLEAN_SUMMARY="${CLEAN_SUMMARY}..."
    fi
    CURRENT_LINE="   Current: ${CLEAN_SUMMARY}"
else
    CURRENT_LINE="   Ready for new work"
fi

# Output formatted status
cat <<EOF
{
  "systemMessage": "${VERSION_MSG}${STATUS_LINE}\n${CURRENT_LINE}\n   Commands: /para:plan /para:status /para:help"
}
EOF

exit 0
