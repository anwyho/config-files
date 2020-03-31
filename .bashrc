#!/bin/env bash

#    _               _
#   | |             | |
#   | |__   __ _ ___| |__  _ __ ___
#   | '_ \ / _` / __| '_ \| '__/ __|
#  _| |_) | (_| \__ \ | | | | | (__
# (_)_.__/ \__,_|___/_| |_|_|  \___|
# This runs on every interactive shell launch (perfect for aliases!).
# It should also contain bash-specific configs.
# source: https://unix.stackexchange.com/questions/129143/what-is-the-purpose-of-bashrc-and-how-does-it-work
# Inspiration from Luke Smith's .bashrc https://github.com/LukeSmithxyz/voidrice/blob/master/.bashrc

[[ -z $PS1 ]] && return  # if not running interactively, quit

[[ -f ~/.aliasrc ]] && . ~/.aliasrc  # load aliases

shopt -s cmdhist
shopt -s histappend  # append to history file rather than overwriting
HISTCONTROL=ignoredups:ignorespace  # ignores in history
HISTSIZE=10000
HISTFILESIZE=20000
HISTTIMEFORMAT="%h-%d %H:%M:%S   "

# Git Configs
# Show Git branch in prompt
git_branch() {
    git remote -v 2>/dev/null | grep anwyho/config-files >/dev/null || \
    git rev-parse --abbrev-ref HEAD 2>/dev/null
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
export PS1="${GREEN}${DATETIME_FORMAT}: ${DIM}\H\n${N}${CYAN}${BOLD}\u @ \W${N}${BLUE}${ITAL}\$(git_branch)${N} \$ "

# virtualenvwrapper configs
export WORKON_HOME=~/workspace/virtual_envs
export VIRTUALENVWRAPPER_PYTHON=/usr/local/bin/python3
export VIRTUALENVWRAPPER_SCRIPT=/usr/local/bin/virtualenvwrapper.sh
[[ -f VIRTUALENVWRAPPER_SCRIPT ]] && . /usr/local/bin/virtualenvwrapper_lazy.sh  # source virtualenvw script if exists

# added by Anaconda3 2019.10 installer
# >>> conda init >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$(CONDA_REPORT_ERRORS=false '/Users/ant/opt/anaconda3/bin/conda' shell.bash hook 2> /dev/null)"
if [ $? -eq 0 ]; then
    \eval "$__conda_setup"
else
    if [ -f "/Users/ant/opt/anaconda3/etc/profile.d/conda.sh" ]; then
        . "/Users/ant/opt/anaconda3/etc/profile.d/conda.sh"
        CONDA_CHANGEPS1=false conda activate base
    else
        \export PATH="/Users/ant/opt/anaconda3/bin:$PATH"
    fi
fi
unset __conda_setup
PS1="$(echo $PS1 | sed 's/(base) //') "
# <<< conda init <<<

# All commands below have been appended and should be sorted.
