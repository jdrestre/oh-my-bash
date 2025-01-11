#!/bin/bash
# Shows detailed log and counts modifications per file, sorting and listing up to the first file with a single modification

# Show the original superlog
git log --graph --decorate --pretty=format:'%Cred%h%Creset -%C(auto)%d%Creset%n%B%Cgreen(%ar) %C(bold blue)<%an>%Creset --> %C(bold yellow)%ad%Creset' --abbrev-commit --date=format:'%A, %d %b %Y %H:%M' --stat

echo ""
echo "Modifications per file (sorted, up to 1 change):"
echo ""

# Get the list of files and count the modifications
files=$(git ls-tree -r HEAD --name-only)
count=0
file_mods=()

for file in $files; do
  mod_count=$(git log --oneline -- $file | wc -l)
  file_mods+=("$mod_count $file")
done

# Sort and print the first 10 files
sorted_files=$(printf "%s\n" "${file_mods[@]}" | sort -nr)
echo "$sorted_files" | head -n 10 | awk '{print; if ($1 == 1) exit}'

# Check if any of the first 10 files has only 1 commit
if echo "$sorted_files" | head -n 10 | grep -q '^1 '; then
  exit 0
fi

# Ask if the user wants to continue
read -p "Do you want to continue seeing the rest of the files? (y/n): " choice
if [ "$choice" == "y" ]; then
  echo "$sorted_files" | tail -n +11 | awk '{print; if ($1 == 1) exit}'
fi
