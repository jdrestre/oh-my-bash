#!/bin/bash
# Function to clean Emacs backup and temporary files
function cemacs {
    # Use mapfile to properly handle files with spaces/special characters
    mapfile -t files < <(find . -type f \( \
        -name '*~' -o \
        -name '.*~' -o \
        -name '*#' -o \
        -name '#*#' -o \
        -name '.#*' \
    \) 2>/dev/null)
    
    # Check if any files were found
    if [ ${#files[@]} -eq 0 ]; then
        echo "No Emacs temporary files found to delete."
        return 0
    fi
    
    # Display files to delete
    echo "Found ${#files[@]} Emacs temporary file(s):"
    printf '%s\n' "${files[@]}"
    echo ""
    
    # Prompt with more explicit options
    read -r -p "Delete all these files? [y/N] " choice
    
    # Use case for more robust input handling
    case "$choice" in
        [yY]|[yY][eE][sS])
            # Delete files one by one to handle errors gracefully
            local deleted=0
            local failed=0
            
            for file in "${files[@]}"; do
                if command rm -f -- "$file" 2>/dev/null; then
                    ((deleted++))
                else
                    echo "Warning: Could not delete '$file'" >&2
                    ((failed++))
                fi
            done
            
            echo "Deleted $deleted file(s)."
            [ $failed -gt 0 ] && echo "Failed to delete $failed file(s)." >&2
            ;;
        *)
            echo "Deletion cancelled."
            return 1
            ;;
    esac
}
