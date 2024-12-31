# Function to clean Emacs backup and temporary files `virgulilla`
function cemacs {
    # Find files with specific patterns (~, .*~, #, #*#, .#*) in the current 
    # directory and subdirectories
    files=$(find . -type f \( -name '*~' -o -name '.*~' -o -name '*#' -o \
           -name '#*#' -o -name '.#*' \))
    
    # Check if any files were found
    if [ -n "$files" ]; then
        echo "Files to delete:"
        echo "$files"
        
        # Prompt the user for confirmation to delete the files
        read -p "Do you want to delete all these files? (y/n) " choice
        
        # If the user confirms (answers 'y'), delete the files
        if [ "$choice" = "y" ]; then
            echo "$files" | xargs rm
            echo "Files deleted."
        else
            echo "Deletion cancelled."
        fi
    else
        echo "No files found to delete."
    fi
}
