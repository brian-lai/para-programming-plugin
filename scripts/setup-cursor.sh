#!/bin/bash
#
# PARA-Programming Cursor Setup Script
# Copies Cursor commands and rules into a project's .cursor/ directory
#
# Install from GitHub (no git clone):
#   curl -fsSL https://raw.githubusercontent.com/brian-lai/para-programming-plugin/main/scripts/setup-cursor.sh | bash -s -- --from-github
# Or into a specific directory:
#   curl -fsSL ... | bash -s -- --from-github /path/to/project
#

set -e

REPO="brian-lai/para-programming-plugin"
BRANCH="main"
FROM_GITHUB=false
TARGET="."
TMP_DIR=""

# Parse args: --from-github [target-dir]   or   [target-dir]
if [ "$1" = "--from-github" ]; then
    FROM_GITHUB=true
    shift
    TARGET="${1:-.}"
else
    TARGET="${1:-.}"
fi

if [ -n "$TARGET" ] && [ "$TARGET" != "." ]; then
    TARGET="$(cd "$TARGET" && pwd)"
else
    TARGET="$(pwd)"
fi

if [ "$FROM_GITHUB" = true ]; then
    BASE_URL="https://raw.githubusercontent.com/${REPO}/${BRANCH}"
    TMP_DIR="$(mktemp -d)"
    trap 'rm -rf "$TMP_DIR"' EXIT
    PLUGIN_ROOT="$TMP_DIR"
    mkdir -p "$PLUGIN_ROOT/cursor/commands" "$PLUGIN_ROOT/cursor/rules"

    echo "📥 Downloading from GitHub (${REPO} ${BRANCH})..."
    for name in para-init para-plan para-execute para-summarize para-archive para-status para-check para-help; do
        curl -fsSL "${BASE_URL}/cursor/commands/${name}.md" -o "$PLUGIN_ROOT/cursor/commands/${name}.md"
    done
    curl -fsSL "${BASE_URL}/cursor/rules/para-workflow.mdc" -o "$PLUGIN_ROOT/cursor/rules/para-workflow.mdc"
    echo ""
else
    SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
    PLUGIN_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
    if [ ! -d "$PLUGIN_ROOT/cursor/commands" ]; then
        echo "❌ cursor/commands not found at $PLUGIN_ROOT"
        echo "   Install from GitHub without cloning:"
        echo "   curl -fsSL https://raw.githubusercontent.com/${REPO}/main/scripts/setup-cursor.sh | bash -s -- --from-github"
        exit 1
    fi
fi

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  PARA-Programming Cursor Setup"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "  Target: $TARGET/.cursor/"
echo ""

mkdir -p "$TARGET/.cursor/commands"
mkdir -p "$TARGET/.cursor/rules"

echo "📋 Copying commands..."
for f in "$PLUGIN_ROOT/cursor/commands/"*.md; do
    [ -f "$f" ] || continue
    cp "$f" "$TARGET/.cursor/commands/"
    echo "   ✅ $(basename "$f")"
done

echo ""
echo "📐 Copying rules..."
for f in "$PLUGIN_ROOT/cursor/rules/"*.mdc; do
    [ -f "$f" ] || continue
    cp "$f" "$TARGET/.cursor/rules/"
    echo "   ✅ $(basename "$f")"
done

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  ✨ Cursor setup complete!"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "  In Cursor: type / in chat to see para-* commands."
echo "  First time? Run /para-init in your project, then /para-plan \"task\""
echo ""
