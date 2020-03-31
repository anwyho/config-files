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
export PATH="$HOME/.cargo/bin:$PATH"  # rust/cargo


# All commands below have been appended and should be organized.
