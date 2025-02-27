# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

# Adjust the git_branch function to simply output the branch name without colors
git_branch() {
    # Check if the current directory is in a Git repository.
    if git rev-parse --git-dir > /dev/null 2>&1; then
        # Fetch the current Git branch name and format it.
        git_branch=$(git branch --show-current 2>/dev/null)
        if [ -n "$git_branch" ]; then
            echo "($git_branch)"
        fi
    fi
}

# Update PS1 to incorporate the git_branch function with color for the branch name
if [ "$color_prompt" = yes ]; then
    PS1="\${debian_chroot:+(\$debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\`if [ \$(git_branch) ]; then echo -e '\033[01;35m\['\$(git_branch)'\]\033[00m'; fi\`\]\[\033[00;37m\]\$ "
else
    PS1="\${debian_chroot:+(\$debian_chroot)}\u@\h:\w\[\`if [ \$(git_branch) ]; then echo -e '\033[01;35m\['\$(git_branch)'\]\033[00m'; fi\`\]\[\033[00;37m\]\$ "
fi

# Apply to xterm-based terminals
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;\${debian_chroot:+(\$debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac


# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi



# ROS 2 setup (START) ==================================================
# Load the ROS 2 Jazzy environment
source /opt/ros/jazzy/setup.bash

# Defines the ROS 2 communication domain (0 is default).
# Nodes must have the same domain ID to communicate
export ROS_DOMAIN_ID=0 

# 0: Allows ROS 2 to communicate with other devices on the network
# 1: Restricts ROS 2 communication to the local machine only
export ROS_LOCALHOST_ONLY=0

# Enables automatic discovery of all ROS 2 nodes 
# within the same subnet, allowing multi-device communication
export ROS_AUTOMATIC_DISCOVERY_RANGE=SUBNET
# ROS 2 setup (STOP) ==================================================



# Go Setup
export PATH=$PATH:/usr/local/go/bin



# D Language Setup
export PATH=~/dlang/dmd-2.109.1/linux/bin64:$PATH







