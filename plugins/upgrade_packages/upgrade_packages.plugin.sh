#!/bin/bash

# Script to update packages on a Linux Debian/Ubuntu system in WSL (Windows Subsystem for Linux) when sudo apt-get upgrade cannot update them

upgrade_pkg() {
    # Update the package list
    sudo apt-get update
    sudo apt-get upgrade -y

    # Check if there are any packages that could not be upgraded to continue with the next step or stop the script
    if [ $(apt list --upgradable 2>/dev/null | grep -v "Listing..." | wc -l) -eq 0 ]; then
        echo "All packages are up to date by jdrestre"
        return 0
    fi

    # Create a list of upgradable packages
    upgradable=$(apt list --upgradable 2>/dev/null | grep -v "Listing..." | awk -F/ '{print $1}')

    # Loop through and upgrade each package
    for pkg in $upgradable; do
        sudo apt-get install -y $pkg
    done

    # Check if there are any packages that could not be upgraded
    echo "Checking for packages that could not be upgraded..."
    if [ $(apt list --upgradable 2>/dev/null | grep -v "Listing..." | wc -l) -gt 0 ]; then
        echo "Some packages could not be upgraded."
    else
        echo "All packages have been successfully upgraded by jdrestre."
    fi
}
