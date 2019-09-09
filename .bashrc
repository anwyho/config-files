#!/bin/sh

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

[[ -f ~/.bash_aliases ]] && . ~/.bash_aliases  # load aliases

shopt -s cmdhist
shopt -s histappend  # append to history file rather than overwriting
HISTCONTROL=ignoredups:ignorespace  # ignores in history
HISTSIZE=10000
HISTFILESIZE=20000
HISTTIMEFORMAT="%h-%d %H:%M:%S   "

# virtualenvwrapper configs
export WORKON_HOME=~/workspace/virtual_envs
export VIRTUALENVWRAPPER_PYTHON=/usr/local/bin/python3
export VIRTUALENVWRAPPER_SCRIPT=/usr/local/bin/virtualenvwrapper.sh
[[ -f VIRTUALENVWRAPPER_SCRIPT ]] && . /usr/local/bin/virtualenvwrapper_lazy.sh  # source virtualenvw script if exists

# All commands below have been appended and should be sorted.
