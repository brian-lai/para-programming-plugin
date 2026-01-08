#!/bin/bash
# para-resolve-paths.sh - Resolve repo-name/path format to absolute paths
# Usage: ./para-resolve-paths.sh <plan-key>

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

# Function to find a git repo by name
find_repo() {
  local repo_name="$1"
  local current_dir="$(pwd)"

  # Check current directory
  if [ -d ".git" ] && [ "$(basename "$current_dir")" = "$repo_name" ]; then
    echo "$current_dir"
    return 0
  fi

  # Check subdirectories
  if [ -d "$repo_name/.git" ]; then
    echo "$current_dir/$repo_name"
    return 0
  fi

  # Check parent directory's subdirectories
  local parent_dir="$(dirname "$current_dir")"
  if [ -d "$parent_dir/$repo_name/.git" ]; then
    echo "$parent_dir/$repo_name"
    return 0
  fi

  return 1
}

# Build list of found repos (for debug output)
FOUND_REPOS=""
CURRENT_DIR="$(pwd)"

# Scan for repos to show what we found
if [ -d ".git" ]; then
  REPO_NAME="$(basename "$CURRENT_DIR")"
  FOUND_REPOS="$FOUND_REPOS  - $REPO_NAME: $CURRENT_DIR\n"
fi

for dir in */; do
  if [ -d "${dir}.git" ]; then
    REPO_NAME="$(basename "$dir")"
    FOUND_REPOS="$FOUND_REPOS  - $REPO_NAME: $CURRENT_DIR/$dir\n"
  fi
done

PARENT_DIR="$(dirname "$CURRENT_DIR")"
for dir in "$PARENT_DIR"/*/; do
  if [ -d "${dir}.git" ]; then
    REPO_NAME="$(basename "$dir")"
    FOUND_REPOS="$FOUND_REPOS  - $REPO_NAME: ${dir%/}\n"
  fi
done

# Show found repos
if [ -n "$FOUND_REPOS" ]; then
  echo "Found repositories:" >&2
  echo -e "$FOUND_REPOS" >&2
else
  echo "Warning: No git repositories found" >&2
  echo "Searched: current dir, subdirs, parent's subdirs" >&2
fi

# Resolve each file path
while IFS= read -r FILE; do
  # Check if path has repo prefix (contains /)
  if [[ "$FILE" == */* ]]; then
    # Extract repo name (everything before first /)
    REPO_NAME="${FILE%%/*}"
    # Extract relative path (everything after first /)
    REL_PATH="${FILE#*/}"

    # Find the repo
    REPO_PATH=$(find_repo "$REPO_NAME")

    if [ -n "$REPO_PATH" ]; then
      # Resolve to absolute path
      echo "$REPO_PATH/$REL_PATH"
    else
      # Repo not found, output warning
      echo "Warning: Repository '$REPO_NAME' not found for: $FILE" >&2
      echo "$FILE"
    fi
  else
    # No repo prefix, assume current directory
    echo "$CURRENT_DIR/$FILE"
  fi
done <<< "$FILES"
