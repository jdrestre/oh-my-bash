#!/bin/bash

# Git Repository Status Checker
# This script checks the status of each Git repository within the
# current directory and shows a summary of repositories with
# pending changes, no changes, or that are not Git repositories.

# Script title
echo -e "\n${BLUE}========== Git Repository Status Checker ========== ${NC}\n"

# Define colors and styles
RED='\033[0;31m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
GREEN='\033[0;32m'
DARK_BLUE='\033[0;94m' # Dark blue
NC='\033[0m' # No color

# Arrays to store directories with changes, without changes, and
# those that are not Git repositories
with_changes=()
no_changes=()
not_git=()

# Function to list files and directories recursively
# list_files_recursive() {
  # local dir="$1"
  # find "$dir" -type f -or -type d
# }

# Traverse each subdirectory within the current directory
for dir in */; do
  if [ -d "$dir/.git" ]; then
    cd "$dir"
    # Check for pending changes
    if [ -n "$(git status --porcelain)" ]; then
      with_changes+=("${dir%/}")
    else
      no_changes+=("${dir%/}")
    fi
    cd ..
  else
    not_git+=("${dir%/}")
  fi
done

# Display titles and summaries
if [ ${#with_changes[@]} -gt 0 ]; then
  echo -e "${BLUE}========== Repositories with changes ========== ${NC}"
  for dir in "${with_changes[@]}"; do
    echo -e "📁 ${DARK_BLUE}${dir}/${NC}: ${RED}pending changes${NC}"
    cd "$dir"
    git status --short
    # List files and directories within untracked directories
    for untracked in $(git status --porcelain | grep '^??' | cut -d ' ' -f2); do
      if [ -d "$untracked" ]; then
        list_files_recursive "$untracked"
      fi
    done
    cd ..
  done
  echo -e "${BLUE}========================================== ${NC}"
fi

if [ ${#no_changes[@]} -gt 0 ] || [ ${#not_git[@]} -gt 0 ]; then
  if [ ${#with_changes[@]} -eq 0 ]; then
    echo -e "${BLUE}========== Repository Status ========== ${NC}"
  else
    echo -e "${BLUE}========== Repositories with no changes or Git tracking ========== ${NC}"
  fi
  for dir in "${no_changes[@]}"; do
    echo -e "📁 ${DARK_BLUE}${dir}/${NC}: ${GREEN}No changes${NC}"
  done
  for dir in "${not_git[@]}"; do
    echo -e "📁 ${DARK_BLUE}${dir}/${NC}: ${YELLOW}Not a Git repository${NC}"
  done
  echo -e "${BLUE}========================================== ${NC}"
fi
