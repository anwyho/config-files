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

# Keyboard shortcuts
cdl() { cd "$@" && ls; }
cdls() { cd "$@" && ls; }
cdla() { cd "$@" && ls -a; }
cdlal() { cd "$@" && ls -la; }
cdlla() { cd "$@" && ls -la; }
alias ccat="highlight --out-format=ansi"  # color cat - print file with syntax highlighting.
alias g="git"  # git
alias grep="grep --color=auto"  # color grep - highlight desired sequence.
alias ka="killall"  # end all processes
alias ls='gls -h --color=auto --group-directories-first'  # cool beans for ls
alias lsa='gls -ah --color=auto --group-directories-first'  # a nice ls -a shortcut
alias lsl='gls -lh --color=auto --group-directories-first'  # a nice ls -a shortcut
alias lsal='gls -alh --color=auto --group-directories-first'  # a nice ls -a shortcut
alias lsla='gls -alh --color=auto --group-directories-first'  # a nice ls -a shortcut
alias mkd="mkdir -pv"  # makes parent directories if necessary, verbosely
alias v="vim"  # vim

# virtualenvwrapper configs
export WORKON_HOME=~/workspace/virtual_envs
export VIRTUALENVWRAPPER_PYTHON=/usr/local/bin/python3
export VIRTUALENVWRAPPER_SCRIPT=/usr/local/bin/virtualenvwrapper.sh
[[ -f VIRTUALENVWRAPPER_SCRIPT ]] && . /usr/local/bin/virtualenvwrapper_lazy.sh  # source virtualenvw script if exists

# Internet
alias yt="youtube-dl --add-metadata -ic"  # download video link
alias yta="youtube-dl --add-metadata -xic"  # download only audio
alias YT="youtube-viewer"

# Simple pip -> pip3
# I don't want to type `pip3` all the time. I would rather type `pip`.
DIM='\[\033[2m\]'
NC='\[\033[0m\]'
# pip() {
#   # Formatting help provided by
#   # https://misc.flogisoft.com/bash/tip_colors_and_formatting
#   printf "${DIM}pip3 is being aliased as \`pip\`. Use \`pip2\` for the python2.7 version of pip. See \`~/.bashrc\` for more implementation info.${NC}\n"
#   pip3 "$@"
# }

# All commands below have been appended and should be sorted.
