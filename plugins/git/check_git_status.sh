#!/bin/bash

# Git Repository Status Checker
# This script checks the status of each Git repository within the
# current directory and shows a summary of repositories with
# pending changes, no changes, or that are not Git repositories.

# Script title
echo -e "\n${BLUE}========== Git Repository Status Checker =========="
echo -e " ${NC}\n"

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

# Enable globbing to include hidden directories
shopt -s dotglob

# Define the list_files_recursive function
list_files_recursive() {
  local dir="$1"
  for file in "$dir"/*; do
    if [ -d "$file" ]; then
      echo "📁 ${DARK_BLUE}${file}/${NC}"
      list_files_recursive "$file"
    else
      echo "  ${file}"
    fi
  done
}

# Function to format long commit messages
format_commit_message() {
  local message="$1"
  local formatted_message=""
  local line_length=52
  while [ ${#message} -gt $line_length ]; do
    # Find the position of the last space within the line length
    local break_pos=$(echo "${message:0:$line_length}" | awk '{print length($0)-length($NF)}')
    if [[ $break_pos -eq 0 ]]; then
      break_pos=$line_length
    fi
    # Ensure we don't break words
    if [[ "${message:$break_pos:1}" != " " ]]; then
      break_pos=$(echo "${message:0:$break_pos}" | awk '{print length($0)-length($NF)}')
    fi
    if [[ $break_pos -eq 0 ]]; then
      break_pos=$line_length
    fi
    # Adjust break position to avoid cutting words
    while [[ "${message:$break_pos:1}" != " " && $break_pos -gt 0 ]]; do
      break_pos=$((break_pos - 1))
    done
    if [[ $break_pos -eq 0 ]]; then
      break_pos=$line_length
    fi
    formatted_message+="${message:0:$break_pos}\n    "
    message="${message:$break_pos}"
    # Remove leading spaces from the remaining message
    message=$(echo "$message" | sed 's/^ *//')
  done
  formatted_message+="$message"
  echo -e "$formatted_message"
}

# Function to display the last commit summary
display_last_commit_summary() {
  local dir="$1"
  cd "$dir"
  local short_hash=$(git log -1 --pretty=format:"%h")
  local commit_message=$(git log -1 --pretty=format:"%s")
  local formatted_message=$(format_commit_message "$commit_message")
  local commit_time=$(git log -1 --pretty=format:"%cr")
  local commit_author=$(git log -1 --pretty=format:"%an")
  local commit_date=$(git log -1 --date=format:"%A, %d %b %Y %H:%M" --pretty=format:"%cd")
  local files_changed=$(git diff-tree --no-commit-id --name-only -r "$short_hash")

  if [ "$first_summary" = true ]; then
    echo -e "${BLUE}========== Last Commit Summary ==========${NC}"
    first_summary=false
  fi

  echo -e "📁 ${DARK_BLUE}${dir}/${NC}"
  echo -e "* ${RED}${short_hash}${NC}"
  echo -e "    ${formatted_message}"
  echo -e "    ${GREEN}(${commit_time})${NC} <${CYAN}${commit_author}${NC}> --> ${YELLOW}${commit_date}${NC}"
  echo -e "    Files changed:"
  for file in $files_changed; do
    echo -e "    ${file}"
  done
  echo -e "${BLUE}==========================================${NC}"
  cd ..
}

# Function to get the last commit timestamp
get_last_commit_timestamp() {
  local dir="$1"
  cd "$dir"
  local timestamp=$(git log -1 --pretty=format:"%ct")
  cd ..
  echo "$timestamp"
}

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
  echo -e "${BLUE}========== Repo with changes ========== "
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
    echo -e "${BLUE}======= Repos without changes or Git tracking ======= ${NC}"
  fi
  for dir in "${no_changes[@]}"; do
    echo -e "📁 ${DARK_BLUE}${dir}/${NC}: ${GREEN}No changes${NC}"
  done
  for dir in "${not_git[@]}"; do
    echo -e "📁 ${DARK_BLUE}${dir}/${NC}: ${YELLOW}Not a Git repository${NC}"
  done
  echo -e "${BLUE}========================================== ${NC}"
fi

# Display last commit summary for all git repositories
count=0
first_summary=true
total_repos=$(( ${#with_changes[@]} + ${#no_changes[@]} ))

# Create an associative array to store directories and their commit timestamps
declare -A repo_timestamps
for dir in "${with_changes[@]}" "${no_changes[@]}"; do
  repo_timestamps["$dir"]=$(get_last_commit_timestamp "$dir")
done

# Sort directories by their commit timestamps in descending order
sorted_dirs=($(for dir in "${!repo_timestamps[@]}"; do echo "${repo_timestamps[$dir]}:$dir"; done | sort -t: -k1,1nr | cut -d: -f2))

for dir in "${sorted_dirs[@]}"; do
  display_last_commit_summary "$dir"
  count=$((count + 1))
  if (( count % 2 == 0 && count < total_repos )); then
    read -n 1 -s -r -p "Press any key to continue..."
    echo -e "\r\033[K"  # Clear the line after pressing a key
  fi
done
