#!/bin/bash

# Script to update packages on a Linux Debian/Ubuntu system in WSL (Windows Subsystem for Linux) when sudo apt-get upgrade cannot update them

upgrade_pkg() {
    # Update the package list
    sudo apt-get update
    sudo apt-get upgrade -y

    # Check if there are any packages that could not be upgraded to continue with the next step or stop the script
    if [ $(apt-get -s upgrade | grep "^Inst" | wc -l) -eq 0 ]; then
        echo "All packages are up to date by jdrestre"
        return 0
    fi

    # Create a list of upgradable packages
    upgradable=$(apt-get -s upgrade | grep "^Inst" | awk '{print $2}')

    # Loop through and upgrade each package
    for pkg in $upgradable; do
        sudo apt-get install -y $pkg
    done

    # Check if there are any packages that could not be upgraded
    echo "Checking for packages that could not be upgraded..."
    if [ $(apt-get -s upgrade | grep "^Inst" | wc -l) -gt 0 ]; then
        echo "Some packages could not be upgraded."
    else
        echo "All packages have been successfully upgraded."
    fi
}
