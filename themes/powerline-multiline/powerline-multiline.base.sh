#! bash oh-my-bash.module

source "$OSH/themes/powerline/powerline.base.sh"

# Get terminal width (with fallback)
function __powerline_get_terminal_width {
  local width=${COLUMNS:-$(tput cols 2>/dev/null || echo 80)}
  echo "${width:-80}"
}

# Intelligent path truncation
# Truncates long paths while preserving readability
# Example: /home/user/very/long/project/path → ~/very/long/project/path
# Further: If still too long → ~/v/long/p/path
function __powerline_truncate_path {
  local path="$1"
  local max_width=${2:-40}  # Default max width for path
  
  # Replace home with ~
  path="${path#$HOME}"
  [[ "$path" = "$PWD" ]] && path="" && path="/"
  path="~${path}"
  
  # If path fits, return as-is
  if [[ ${#path} -le $max_width ]]; then
    echo "$path"
    return
  fi
  
  # Strategy 1: Abbreviate directory names to first letter
  local truncated=""
  local IFS='/'
  local parts=($path)
  
  for i in "${!parts[@]}"; do
    if [[ $i -eq 0 ]]; then
      # Keep the ~ or root
      truncated="${parts[i]}"
    elif [[ $i -eq $((${#parts[@]} - 1)) ]]; then
      # Always keep the last component (current dir)
      truncated="${truncated}/${parts[i]}"
    else
      # Abbreviate intermediate directories
      truncated="${truncated}/${parts[i]:0:1}"
    fi
  done
  
  # If abbreviation is still too long, use more aggressive truncation
  if [[ ${#truncated} -gt $max_width ]]; then
    # Keep only last 2 directories
    local last_parts=()
    IFS='/' read -ra parts <<< "$path"
    
    if [[ ${#parts[@]} -gt 2 ]]; then
      truncated="~/${parts[-2]}/${parts[-1]}"
    else
      truncated="$path"
    fi
  fi
  
  # Final fallback: just show the last component
  if [[ ${#truncated} -gt $max_width ]]; then
    truncated="~/${parts[-1]}"
  fi
  
  echo "$truncated"
}

function __powerline_last_status_prompt {
  (($1 != 0)) && _omb_util_print "$(set_color $LAST_STATUS_THEME_PROMPT_COLOR -) $1 $_omb_prompt_normal"
}

function __powerline_right_segment {
  local OLD_IFS=$IFS; IFS='|'
  local params=( $1 )
  IFS=$OLD_IFS
  local separator_char=$POWERLINE_RIGHT_SEPARATOR
  local padding=2
  local separator_color=""
  local text_color=${params[2]:-'-'}
  local terminal_width=$(__powerline_get_terminal_width)

  # Skip adding segment if right prompt is already too long
  # Reserve space for left prompt (roughly 50% of terminal width)
  local max_right_width=$((terminal_width / 2))
  if [[ $((RIGHT_PROMPT_LENGTH + ${#params[0]} + padding)) -gt $max_right_width ]]; then
    return
  fi

  if ((SEGMENTS_AT_RIGHT == 0)); then
    separator_color=$(set_color ${params[1]} -)
  else
    separator_color=$(set_color ${params[1]} $LAST_SEGMENT_COLOR)
    ((padding += 1))
  fi
  RIGHT_PROMPT+="$separator_color$separator_char$_omb_prompt_normal$(set_color $text_color ${params[1]}) ${params[0]} $_omb_prompt_normal$(set_color - $COLOR)$_omb_prompt_normal"
  RIGHT_PROMPT_LENGTH=$((${#params[0]} + RIGHT_PROMPT_LENGTH + padding))
  LAST_SEGMENT_COLOR=${params[1]}
  ((SEGMENTS_AT_RIGHT += 1))
}

function __powerline_prompt_command {
  local last_status=$? ## always the first
  local separator_char=$POWERLINE_PROMPT_CHAR
  local terminal_width=$(__powerline_get_terminal_width)
  
  # Dynamically calculate available space for left prompt (leave ~30% for right prompt)
  local available_width=$((terminal_width * 70 / 100))
  local move_cursor_rightmost="\033[$((terminal_width))C"

  local LEFT_PROMPT=""
  local RIGHT_PROMPT=""
  local RIGHT_PROMPT_LENGTH=0
  local SEGMENTS_AT_LEFT=0
  local SEGMENTS_AT_RIGHT=0
  local LAST_SEGMENT_COLOR=""

  ## left prompt ##
  for segment in $POWERLINE_LEFT_PROMPT; do
    # Skip CWD segment - will handle specially with truncation
    if [[ "$segment" == "cwd" ]]; then
      continue
    fi
    local info=$(__powerline_"$segment"_prompt)
    [[ $info ]] && __powerline_left_segment "$info"
  done
  
  # Add CWD segment with intelligent truncation
  if [[ "$POWERLINE_LEFT_PROMPT" == *"cwd"* ]]; then
    local cwd_path=$(pwd | sed "s|^${HOME}|~|")
    local max_cwd_width=$((available_width - 20))  # Reserve 20 chars for other segments
    [[ $max_cwd_width -lt 15 ]] && max_cwd_width=15
    
    local truncated_cwd=$(__powerline_truncate_path "$(pwd)" "$max_cwd_width")
    local cwd_segment="${truncated_cwd}|${CWD_THEME_PROMPT_COLOR}"
    [[ $cwd_segment ]] && __powerline_left_segment "$cwd_segment"
  fi
  
  [[ $LEFT_PROMPT ]] && LEFT_PROMPT+=$(set_color ${LAST_SEGMENT_COLOR} -)${separator_char}${_omb_prompt_normal}

  ## right prompt ##
  if [[ $POWERLINE_RIGHT_PROMPT ]]; then
    LEFT_PROMPT+=$move_cursor_rightmost
    for segment in $POWERLINE_RIGHT_PROMPT; do
      local info=$(__powerline_"$segment"_prompt)
      [[ $info ]] && __powerline_right_segment "$info"
    done
    LEFT_PROMPT+="\033[$((RIGHT_PROMPT_LENGTH + 2))D"
  fi

  PS1="$LEFT_PROMPT$RIGHT_PROMPT\n$(__powerline_last_status_prompt $last_status)$PROMPT_CHAR "
}
