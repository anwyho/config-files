#!/bin/sh

#    ___          __ _ _
#   | _ \_ _ ___ / _(_) |___
#  _|  _/ '_/ _ \  _| | / -_)
# (_)_| |_| \___/_| |_|_\___|
# .profile is ran at the start of a new login shell
# source: https://unix.stackexchange.com/questions/129143/what-is-the-purpose-of-bashrc-and-how-does-it-work

# This file should contain non-shell-specific configs.
#   I.e. bash configs should go in .bashrc.
# source: https://superuser.com/questions/183870/difference-between-bashrc-and-bash-profile
# Sick ASCII art generator: FIGlet command and http://patorjk.com/software/taag/

# Imports .bashrc
[[ -f ~/.bashrc ]] && source ~/.bashrc

# Extending PATH
export PATH="${HOME}/.local/bin:${PATH}"
export PATH="${PATH}:${HOME}/Library/Python/3.6/bin"  # local user python files
export PATH="/usr/local/opt/python@2/libexec/bin:$PATH"  # homebrew python2
export PATH="/usr/local/opt/python/libexec/bin:$PATH"  # homebrew python3
export PATH="$HOME/.cargo/bin:$PATH"  # rust/cargo

# Git Configs
# Show Git branch in prompt
parse_git_branch() { 
    git remote -v 2>/dev/null | grep anwyho/config-files >/dev/null || \
    git branch 2>/dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
}
# Modifying the prompt:
# https://misc.flogisoft.com/bash/tip_colors_and_formatting
# https://www.gnu.org/software/bash/manual/bashref.html#Controlling-the-Prompt
# \u username
# \h or \H hostname
# \d date Wed Sep 06
# \t or \T or \@ time (24hr vs 12hr vs 12hrw am/pm)
CYAN="\[\e[36m\]"
BLUE="\[\e[94m\]"
GREEN="\[\e[92m\]"
BOLD="\[\e[1m\]"
DIM="\[\e[2m\]"
ITAL="\[\e[3m\]"
N="\[\e[0m\]"  # reverts text to normal
DATETIME_FORMAT="\D{%a, %b %d,%l:%M:%S %p}"
export PS1="${GREEN}${DATETIME_FORMAT}: ${DIM}\H\n${N}${CYAN}${BOLD}\u @ \W${N}${BLUE}${ITAL}\$(parse_git_branch)${N} \$ "

# All commands below have been appended and should be organized.


# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/ant/workspace/google-cloud-sdk/path.bash.inc' ]; then . '/Users/ant/workspace/google-cloud-sdk/path.bash.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/ant/workspace/google-cloud-sdk/completion.bash.inc' ]; then . '/Users/ant/workspace/google-cloud-sdk/completion.bash.inc'; fi
