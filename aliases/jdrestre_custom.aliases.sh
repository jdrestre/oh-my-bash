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

  # MEJORA 1: Detectar flags y usar rm original directamente
  # Esto permite usar: rm -f, rm -rf, rm -i, etc.
  local has_flags=false
  for arg in "$@"; do
    if [[ "$arg" == -* ]]; then
      has_flags=true
      break
    fi
  done

  if $has_flags; then
    original_rm "$@"
    return $?
  fi

  # MEJORA 2: No fallar todo si un archivo no existe, solo advertir
  local files_to_delete=()
  local files_not_found=0
  
  for file in "$@"; do
    if [ ! -e "$file" ]; then
      echo "rm: cannot remove '$file': No such file or directory" >&2
      ((files_not_found++))
    else
      files_to_delete+=("$file")
    fi
  done

  # Si no hay archivos válidos, salir
  if [ ${#files_to_delete[@]} -eq 0 ]; then
    return 1
  fi

  # Initialize counters
  local count_files_listed=0
  local count_dirs_listed=0
  
  # MEJORA 3: Optimizar conteo - guardar resultados de find en arrays
  # En vez de ejecutar find múltiples veces
  echo ""
  for file in "${files_to_delete[@]}"; do
    if [ -d "$file" ]; then
      echo "Dir: $file"
      
      # Guardar archivos y directorios en arrays (UN solo find por tipo)
      mapfile -t dir_files < <(find "$file" -type f 2>/dev/null)
      mapfile -t dir_subdirs < <(find "$file" -type d 2>/dev/null)
      
      # Mostrar archivos (limitar a primeros 20 para no saturar)
      local file_count=${#dir_files[@]}
      if [ $file_count -le 20 ]; then
        printf '%s\n' "${dir_files[@]}"
      else
        printf '%s\n' "${dir_files[@]:0:20}"
        echo "... and $((file_count - 20)) more files"
      fi
      
      count_files_listed=$((count_files_listed + file_count))
      count_dirs_listed=$((count_dirs_listed + ${#dir_subdirs[@]}))
    else
      echo "File: $file"
      ((count_files_listed++))
    fi
  done
  
  echo ""
  # Display the summary of files and directories to delete
  echo "Files to delete: $count_files_listed"
  echo "Dirs to delete (including subdirs): $count_dirs_listed"
  
  # MEJORA 4: Confirmación adicional para directorios grandes (>30 archivos)
  if [ $count_files_listed -gt 30 ]; then
    echo ""
    echo "⚠️  WARNING: This will delete more than 30 files!"
    read -r -p "Are you sure you want to continue? [y/N] " confirm_large
    
    case "$confirm_large" in
      [yY]|[yY][eE][sS])
        # Continuar con la confirmación normal
        ;;
      *)
        echo "Cancelled."
        return 1
        ;;
    esac
  fi
  
  # MEJORA 5: Aceptar múltiples variantes de confirmación
  read -r -p "Delete? [y/N] " choice
  
  case "$choice" in
    [yY]|[yY][eE][sS])
      # Delete files and directories if confirmed
      local count_files_deleted=0
      local count_dirs_deleted=0
      local failed=0
      
      for file in "${files_to_delete[@]}"; do
        if [ -d "$file" ]; then
          # MEJORA 5: Reutilizar conteo previo en vez de ejecutar find otra vez
          # Contar antes de borrar
          local dir_file_count=$(find "$file" -type f 2>/dev/null | wc -l)
          local dir_dir_count=$(find "$file" -type d 2>/dev/null | wc -l)
          
          if original_rm -rf "$file" 2>/dev/null; then
            count_files_deleted=$((count_files_deleted + dir_file_count))
            count_dirs_deleted=$((count_dirs_deleted + dir_dir_count))
          else
            echo "Warning: Could not delete directory '$file'" >&2
            ((failed++))
          fi
        else
          if original_rm -f "$file" 2>/dev/null; then
            ((count_files_deleted++))
          else
            echo "Warning: Could not delete file '$file'" >&2
            ((failed++))
          fi
        fi
      done
      
      # Display deletion summary
      echo ""
      echo "Files deleted: $count_files_deleted"
      echo "Dirs deleted (including subdirs): $count_dirs_deleted"
      [ $failed -gt 0 ] && echo "Failed to delete $failed item(s)." >&2
      ;;
    *)
      # If cancelled, display message
      echo "Cancelled."
      return 1
      ;;
  esac
}

# Define alias for original cat command
alias original_cat='/bin/cat'

# Function to perform custom cat operations
cat_custom() {
  # Check if no arguments are provided (allow stdin)
  if [ $# -eq 0 ]; then
    # Read from stdin
    original_cat
    return $?
  fi

  # MEJORA 1: Parse custom flags
  local apply_wrap=false
  local apply_compact=false
  local wrap_width=80
  local files=()
  
  while [ $# -gt 0 ]; do
    case "$1" in
      --wrap|-w)
        apply_wrap=true
        shift
        ;;
      --compact|-c)
        apply_compact=true
        shift
        ;;
      --wrap=*)
        apply_wrap=true
        wrap_width="${1#*=}"
        shift
        ;;
      --help)
        echo "Usage: cat [OPTION]... [FILE]..."
        echo "Concatenate FILE(s) to standard output."
        echo ""
        echo "Custom options:"
        echo "  -w, --wrap         wrap long lines at 80 characters"
        echo "  --wrap=WIDTH       wrap long lines at WIDTH characters"
        echo "  -c, --compact      remove empty lines"
        echo "  --examples         show usage examples and guide"
        echo ""
        echo "Standard cat options:"
        original_cat --help 2>&1 | tail -n +3
        return 0
        ;;
      --examples)
        echo "╔═══════════════════════════════════════════════════════════════╗"
        echo "║           CAT CUSTOM - EXAMPLES & USE CASES                   ║"
        echo "╚═══════════════════════════════════════════════════════════════╝"
        echo ""
        echo "📖 BASIC USAGE:"
        echo "  cat file.txt                    Show file as-is (no formatting)"
        echo "  cat file1.txt file2.txt         Concatenate multiple files"
        echo ""
        echo "🔧 CUSTOM FORMATTING OPTIONS:"
        echo "  cat --wrap file.txt             Wrap long lines at 80 characters"
        echo "  cat --wrap=120 file.txt         Wrap at custom width (120 chars)"
        echo "  cat --compact file.txt          Remove all empty lines"
        echo "  cat -w -c file.txt              Wrap AND compact (both)"
        echo ""
        echo "📚 WHEN TO USE WHAT:"
        echo "  Code files (.py, .js, .java):   cat script.py        (no flags)"
        echo "  JSON/XML/CSV data:              cat data.json        (no flags)"
        echo "  Configuration files:            cat .env             (no flags)"
        echo "  Long emails/text:               cat --wrap email.txt"
        echo "  Logs with empty lines:          cat --compact app.log"
        echo "  Reading documents:              cat -w -c document.txt"
        echo ""
        echo "🎯 STANDARD CAT FLAGS ALSO WORK:"
        echo "  cat -n file.txt                 Number all output lines"
        echo "  cat -b file.txt                 Number non-empty lines only"
        echo "  cat -A file.txt                 Show all characters (tabs, EOL)"
        echo ""
        echo "💡 PRO TIPS:"
        echo "  • Don't use formatting flags on code or structured data"
        echo "  • Binary files are auto-detected (no formatting applied)"
        echo "  • Use --wrap for better readability of long text"
        echo "  • Use --compact to clean up logs and verbose output"
        echo "  • Combine flags: cat -w -c for wrap + compact together"
        echo ""
        echo "───────────────────────────────────────────────────────────────"
        echo "                                                     by jdrestre"
        echo "───────────────────────────────────────────────────────────────"
        return 0
        ;;
      --version)
        original_cat --version
        return 0
        ;;
      -*)
        # MEJORA 2: Any other flag, use original cat
        original_cat "$@"
        return $?
        ;;
      *)
        # It's a file
        files+=("$1")
        shift
        ;;
    esac
  done

  # If no files specified after parsing flags, use stdin
  if [ ${#files[@]} -eq 0 ]; then
    if $apply_wrap || $apply_compact; then
      local cmd="original_cat"
      $apply_wrap && cmd="$cmd | fold -s -w $wrap_width"
      $apply_compact && cmd="$cmd | sed '/^$/d'"
      eval "$cmd"
    else
      original_cat
    fi
    return $?
  fi

  # MEJORA 3: Validate files but don't fail all if one is missing
  local valid_files=()
  local has_errors=false
  
  for file in "${files[@]}"; do
    if [ ! -e "$file" ]; then
      echo "cat: $file: No such file or directory" >&2
      has_errors=true
    elif [ -d "$file" ]; then
      echo "cat: $file: Is a directory" >&2
      has_errors=true
    else
      valid_files+=("$file")
    fi
  done

  # If no valid files, return error
  if [ ${#valid_files[@]} -eq 0 ]; then
    return 1
  fi

  # MEJORA 4: Process valid files
  if $apply_wrap || $apply_compact; then
    # Apply custom formatting
    for file in "${valid_files[@]}"; do
      # MEJORA 5: Check if file is binary
      if file -b "$file" | grep -q "text"; then
        # Text file, apply formatting
        if $apply_wrap && $apply_compact; then
          original_cat "$file" | fold -s -w "$wrap_width" | sed '/^$/d'
        elif $apply_wrap; then
          original_cat "$file" | fold -s -w "$wrap_width"
        elif $apply_compact; then
          original_cat "$file" | sed '/^$/d'
        fi
      else
        # Binary file, show warning and use original cat
        echo "cat: $file: binary file detected, showing without formatting" >&2
        original_cat "$file"
      fi
    done
  else
    # No custom formatting, use original cat
    original_cat "${valid_files[@]}"
  fi

  # MEJORA 6: Show custom footer with help info
  echo ""
  echo "───────────────────────────────────────────────────────────────"
  echo "💡 Custom options: cat --wrap | cat --compact | cat -w -c"
  echo "📖 More info: cat --examples"
  echo "                                                     by jdrestre"
  echo "───────────────────────────────────────────────────────────────"

  # Return error code if there were any errors
  [ "$has_errors" = true ] && return 1 || return 0
}

alias rm='rm_custom'          # Create alias to use the custom rm function
alias cat='cat_custom'        # Create alias to use the custom cat function
alias emacs='emacs -nw'       # Run Emacs in terminal mode
alias supd='sudo apt update'  # Update APT package lists
alias supg='sudo apt upgrade' # Upgrade APT packages
alias py='python3'            # Python 3 execute alias
alias nl="nl -ba -d':' -fn -hn -i1 -l1 -n'ln' -s'  ' -v1 -w3" # Number lines
alias edge="/mnt/c/'Program Files (x86)'/Microsoft/Edge/Application/msedge.exe"   # Open Microsoft Edge
alias chrome="/mnt/c/'Program Files'/Google/Chrome/Application/chrome.exe" # Open Google Chrome
alias gcheck='~/.oh-my-bash/plugins/git/check_git_status.sh' # Git Repository Status Checker
# This script checks the status of each Git repository within the
# current directory and shows a summary of repositories with
# pending changes, no changes, or that are not Git repositories.
alias gsl='~/.oh-my-bash/plugins/git/superlog.sh' # Git Superlog + Files Changed
# Shows detailed log and counts modifications per file, sorting and listing up to the first file with a single modification
