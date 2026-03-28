#!/usr/bin/env bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(dirname "$SCRIPT_DIR")"
SKILLS_DIR="$REPO_DIR/.claude/skills"
DEST_DIR="${CLAUDE_CONFIG_DIR:-$HOME/.claude}/skills"

if [ ! -d "$SKILLS_DIR" ]; then
  echo "Error: $SKILLS_DIR not found."
  exit 1
fi

echo "Installing skills to $DEST_DIR ..."

mkdir -p "$DEST_DIR"

for skill_path in "$SKILLS_DIR"/*; do
  if [ -d "$skill_path" ]; then
    skill_name="$(basename "$skill_path")"
    dest_path="$DEST_DIR/$skill_name"

    if [ -d "$dest_path" ]; then
      echo "  [skip] $skill_name already exists"
      echo "    Remove existing skill at $dest_path"
      rm -rf "$dest_path"
      echo "    Reinstalling $skill_name ..."
      cp -r "$skill_path" "$dest_path"
      echo "  [done] $skill_name"
    else
      cp -r "$skill_path" "$dest_path"
      echo "  [done] $skill_name"
    fi
  fi
done

echo "Done."
