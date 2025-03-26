# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# Basic settings for bash
if [ -f ~/Linux_Setup/basics.bash ]; then
    . ~/Linux_Setup/basics.bash
fi

# Alias definitions and setup
if [ -f ~/Linux_Setup/aliases.bash ]; then
    . ~/Linux_Setup/aliases.bash
fi

# Custom bash setup for my PC
if [ -f ~/Linux_Setup/setup.bash ]; then
    . ~/Linux_Setup/setup.bash
fi

# Just some fun for the coolness factor B)
if [ -f ~/Linux_Setup/fun.bash ]; then
    . ~/Linux_Setup/fun.bash
fi











