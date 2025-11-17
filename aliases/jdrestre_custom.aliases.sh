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

# Function to perform custom cat operations
cat_custom() {
  if [ $# -eq 0 ]; then
    echo "cat: missing operand"
    echo "Try 'cat --help' for more information."
    return 1
  fi

  for file in "$@"; do
    if [ ! -e "$file" ]; then
      echo "cat: $file: No such file or directory"
      return 1
    fi
  done

  cat "$@" | fold -s -w 80 | sed "/^$/d"
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
