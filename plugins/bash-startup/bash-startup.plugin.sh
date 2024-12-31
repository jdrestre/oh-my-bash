# Configuration for opening a new terminal window 

# Print a blank line for better readability
echo -e '\n'

# Display a random fortune in Spanish
fortune es

# Print the username "jdrestre" in a slanted font with colors using figlet and lolcat
# figlet jdrestre -f slant
# echo -e '\n'
figlet jdrestre -f slant | lolcat && echo -e '\n'

# Set the bold style for text
bold=$(tput bold)

# Display the current date and time information in a bold format
date +$'\033[1mToday is: %A, %d %B %Y%nTime: %H:%M:%S%nWeek of the year: %V%nDay of the year: %j\033[0m'

~/.oh-my-bash/plugins/bash-startup/.geek_ephemeris/dayValidator.sh
