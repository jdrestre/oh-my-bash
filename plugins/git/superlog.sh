#!/bin/bash
# Shows detailed log and counts modifications per file, sorting and listing up to the first file with a single modification

# Show the original superlog
git log --graph --decorate --pretty=format:'%Cred%h%Creset -%C(auto)%d%Creset%n%B%Cgreen(%ar) %C(bold blue)<%an>%Creset --> %C(bold yellow)%ad%Creset' --abbrev-commit --date=format:'%A, %d %b %Y %H:%M' --stat

echo ""
echo "Modifications per file (sorted, up to 1 change):"
echo ""

# Get the list of files and count the modifications
files=$(git ls-tree -r HEAD --name-only)
for file in $files; do
  count=$(git log --oneline -- $file | wc -l)
  echo "$count $file"
done | sort -nr | awk '{print; if ($1 == 1) exit}'
