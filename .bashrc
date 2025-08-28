# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# Basic settings for bash
if [ -f ~/Linux_Setup/scripts/basics.bash ]; then
    . ~/Linux_Setup/scripts/basics.bash
fi

# Alias definitions and setup
if [ -f ~/Linux_Setup/scripts/aliases.bash ]; then
    . ~/Linux_Setup/scripts/aliases.bash
fi

# Custom bash setup for my PC
if [ -f ~/Linux_Setup/scripts/setup.bash ]; then
    . ~/Linux_Setup/scripts/setup.bash
fi

# Just some fun for the coolness factor B)
# Main PC
if [ -f ~/Linux_Setup/scripts/diagnostics/main.bash ]; then
    . ~/Linux_Setup/scripts/diagnostics/main.bash
fi
# Babylon Server
# if [ -f ~/Linux_Setup/scripts/diagnostics/babylon.bash ]; then
#     . ~/Linux_Setup/scripts/diagnostics/babylon.bash
# fi


