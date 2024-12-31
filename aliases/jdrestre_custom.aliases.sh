# ****** jdrestre Custom Aliases *******

# Define alias for original rm command
alias original_rm='/bin/rm'

# Function to perform detailed rm operations
rm_custom() {
  # Check if no arguments are provided
  if [ $# -eq 0 ]; then
    echo "rm: missing operand"
    echo "Try 'rm --help' for more information."
    return 1
  fi

  # Check for --help or --version flags and call original rm
  if [[ "$1" == "--help" || "$1" == "--version" ]]; then
    original_rm "$1"
    return 0
  fi

  # Verify each file exists
  for file in "$@"; do
    if [ ! -e "$file" ]; then
      echo "rm: cannot remove '$file': No such file or directory"
      return 1
    fi
  done

  # Initialize counters
  count_files_listed=0
  count_dirs_listed=0
  count_files_deleted=0
  count_dirs_deleted=0
  
  # List files and directories to be deleted
  for file in "$@"; do
    if [ -d "$file" ]; then
      echo "Dir: $file"
      find "$file" -type f -print
      count_dirs_listed=$((count_dirs_listed + $(find "$file" -type d | wc -l)))
      count_files_listed=$((count_files_listed + $(find "$file" -type f | wc -l)))
    else
      echo "File: $file"
      count_files_listed=$((count_files_listed + 1))
    fi
  done
  
  # Display the summary of files and directories to delete
  echo "Files to delete: $count_files_listed"
  echo "Dirs to delete (including subdirs): $count_dirs_listed"
  
  # Prompt user for deletion confirmation
  read -p "Delete? [y/N] " choice
  if [[ "$choice" == [yY] ]]; then
    # Delete files and directories if confirmed
    for file in "$@"; do
      if [ -d "$file" ]; then
        count_dirs_deleted=$((count_dirs_deleted + $(find "$file" -type d | wc -l)))
        count_files_deleted=$((count_files_deleted + $(find "$file" -type f | wc -l)))
        original_rm -rf "$file"
      else
        count_files_deleted=$((count_files_deleted + 1))
        original_rm -f "$file"
      fi
    done
    
    # Display deletion summary
    echo "Files deleted: $count_files_deleted"
    echo "Dirs deleted (including subdirs): $count_dirs_deleted"
  else
    # If cancelled, display message
    echo "Cancelled."
  fi
}


alias rm='rm_custom'        # Create alias to use the custom rm function

