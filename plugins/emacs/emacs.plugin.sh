#!/bin/bash
# Function to clean Emacs backup and temporary files
function cemacs {
    
    # --- MEJORA 1: Parseo de argumentos ---
    # Si se pasa algún argumento, verificar si es ayuda.
    if [ $# -gt 0 ]; then
        case "$1" in
            --help|--examples)
                echo "Usage: cemacs"
                echo "  Interactively finds and deletes Emacs backup/temporary files from"
                echo "  the current directory and all subdirectories."
                echo ""
                echo "WHAT IT DELETES:"
                echo "  • *~ (Standard backups)"
                echo "  • .*~ (Hidden backups)"
                echo "  • *# (Auto-save files)"
                echo "  • #*# (Auto-save files)"
                echo "  • .#* (Lockfiles)"
                echo ""
                echo "This command takes no arguments. Just run 'cemacs' to start the scan."
                echo ""
                echo "───────────────────────────────────────────────────────────────"
                echo "                                                 by jdrestre"
                echo "───────────────────────────────────────────────────────────────"
                return 0
                ;;
            *)
                # Handle unknown arguments
                echo "cemacs: unknown argument: $1" >&2
                echo "This command takes no arguments. Run 'cemacs' without arguments." >&2
                echo "Try 'cemacs --help' for more information." >&2
                
                # AÑADIR FOOTER (al error)
                echo ""
                echo "───────────────────────────────────────────────────────────────"
                echo " ⚡️ cemacs command error.                      by jdrestre"
                echo " 📖 Use 'cemacs --help' for more info."
                echo "───────────────────────────────────────────────────────────────"
                return 1
                ;;
        esac
    fi
    # --- Fin del parseo ---

    # --- Lógica original (si no se pasaron argumentos) ---
    
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
        
        # AÑADIR FOOTER (al no encontrar)
        echo ""
        echo "───────────────────────────────────────────────────────────────"
        echo " ⚡️ cemacs scan complete. No files found.         by jdrestre"
        echo " 📖 Use 'cemacs --help' for more info."
        echo "───────────────────────────────────────────────────────────────"
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
            
            # AÑADIR FOOTER (al completar)
            echo ""
            echo "───────────────────────────────────────────────────────────────"
            echo " ⚡️ cemacs cleanup complete.                    by jdrestre"
            echo " 📖 Use 'cemacs --help' for more info."
            echo "───────────────────────────────────────────────────────────────"
            ;;
        *)
            echo "Deletion cancelled."

            # AÑADIR FOOTER (al cancelar)
            echo ""
            echo "───────────────────────────────────────────────────────────────"
            echo " ⚡️ cemacs cleanup cancelled.                   by jdrestre"
            echo " 📖 Use 'cemacs --help' for more info."
            echo "───────────────────────────────────────────────────────────────"
            return 1
            ;;
    esac
}
