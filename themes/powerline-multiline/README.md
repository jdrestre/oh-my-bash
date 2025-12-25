# Powerline Multiline Theme

A colorful multiline theme, where the first line shows information about your shell session (divided into two parts, left and right), and the second one is where the shell commands are introduced.

**IMPORTANT:** This theme requires that [a font with the Powerline symbols](https://github.com/powerline/fonts) needs to be used in your terminal emulator, otherwise the prompt won't be displayed correctly, i.e. some of the additional icons and characters will be missing. Please follow your operating system's instructions to install one of the fonts from the above link and select it in your terminal emulator.

## Provided Information

* Current path
* Current username and hostname
* Current time
* An indicator when connected by SSH
* An indicator when `sudo` has the credentials cached (see the `sudo` manpage for more info about this)
* An indicator when the current shell is inside the Vim editor
* Battery charging status (depends on the [../../plugins/battery/battery.plugin.sh](battery plugin))
* SCM Repository status (e.g. Git, SVN)
* The current Python environment (Virtualenv, venv, and Conda are supported) in use
* The current Ruby environment (rvm and rbenv are supported) in use
* Last command exit code (only shown when the exit code is greater than 0)

## Configuration

This theme is pretty configurable, all the configuration is done by setting environment variables.

### Path Truncation (NEW)

The theme now includes intelligent path truncation to handle very long directory paths. By default, this feature is enabled. You can control it with:

    # Enable/disable path truncation (default: true)
    POWERLINE_ENABLE_PATH_TRUNCATION=true
    
    # Maximum width for the path before truncation (default: 40)
    POWERLINE_PATH_MAX_WIDTH=40

The truncation strategy works as follows:
1. If the path fits within the max width, it's displayed normally
2. If too long, directory names are abbreviated to their first letter: `/home/user/projects` → `~/p/projects`
3. If still too long, only the last 2 directories are shown: `/a/very/long/path/here` → `~/path/here`
4. Final fallback shows only the current directory name

Examples:
- Normal path: `~/my-project/src/components`
- Abbreviated: `~/m/s/components` (if too long)
- Minimal: `~/components` (if very long)

### Terminal Width Adaptation (NEW)

The theme now adapts dynamically to your terminal width:
- The right prompt segments (clock, battery, user info) are intelligently hidden if the terminal is too narrow
- The left prompt reserves approximately 70% of the terminal width, leaving 30% for the right prompt
- This prevents text overlap and ensures readability on small terminals

### User Information

By default, the username and hostname are shown on the right hand side, but you can change this behavior by setting the value of the following variable:

    POWERLINE_PROMPT_USER_INFO_MODE="sudo"

For now, the only supported value is `sudo`, which hides the username and hostname, and shows an indicator when `sudo` has the credentials cached. Other values have no effect at this time.

### Clock Format

By default, the current time is shown on the right hand side, you can change the format using the following variable:

    THEME_CLOCK_FORMAT="%H:%M:%S"

The time/date is printed by the `date` command, so refer to its man page to change the format.

### Segment Order

The contents of both prompt sides can be "reordered", all the "segments" (every piece of information) can take any place. The currently available segments are:

* battery
* clock
* cwd
* in_vim
* python_venv
* ruby
* scm
* user_info

Two variables can be defined to set the order of the prompt segments:

    POWERLINE_LEFT_PROMPT="scm python_venv ruby cwd"
    POWERLINE_RIGHT_PROMPT="in_vim clock battery user_info"

The example values above are the current default values, but if you want to remove anything from the prompt, simply remove the "string" that represents the segment from the corresponding variable.
