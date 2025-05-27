# #!/bin/env zsh

# #####  #### #   #
#    #  #     #   #
#   #    ###  #####
#  #        # #   #
# ##### ####  #   #

#  run configs  #


# Exit for non-interactive shell
[[ $- != *i* ]] && return

# ZSH Docs
# conditional expressions
# - https://zsh.sourceforge.io/Doc/Release/Conditional-Expressions.html#Conditional-Expressions

# `\r` resets the carret to the beginning of the line
echo -ne '  loading ~/.zshrc...\r'



####################
# Autoload Modules #
####################

# ref: `man zshbuiltins`
autoload -U colors && colors  # enable colors
autoload -Uz vcs_info  # for use in prompts
autoload -U add-zsh-hook  # hooks for prompts
autoload -U compinit && compinit
autoload -U edit-command-line




###################
# Utility Methods #
###################

# if a file exists, source it
function test_source() { [[ -f $1 ]] && source $1 }

# Elapsed time functions

# ZSH_START_TIME is -1 if no command is running. 
export ZSH_START_TIME=-1
# ZSH_CMD_RUNNING is 0 if no command is running.
export ZSH_CMD_RUNNING=0 # boolean

function milliseconds_since_epoch() {
  if command -v gdate &> /dev/null; then
    echo "$(($(gdate +%s%N) / 1000000))"
  else
    local seconds_since_epoch=$(($(date +%s)))
    echo "${seconds_since_epoch}000"
  fi
}

function start_exec_timer_ms() {
  export ZSH_START_TIME=$(milliseconds_since_epoch)
  export ZSH_CMD_RUNNING=1
}

function end_exec_timer_ms() {
  if (( ZSH_CMD_RUNNING == 0 )); then
    ZSH_START_TIME=-1
    return 0
  fi
  ZSH_CMD_RUNNING=0

  local current_time=$(milliseconds_since_epoch)
  export ZSH_ELAPSED_TIME=$(( current_time - ZSH_START_TIME ))
}

add-zsh-hook preexec start_exec_timer_ms
add-zsh-hook precmd end_exec_timer_ms
start_exec_timer_ms # for loading ~/.zshrc




###########
# Options #
###########

# See for all options
# ref: http://zsh.sourceforge.net/Doc/Release/Options.html#Options
set -o CORRECT  # prompt suggestions for mispelled commands
set -o NO_CASE_GLOB
set -o PROMPT_SUBST # parameter expansion in prompts
# set -o AUTO_CD # type folder name to `cd` to it

# History
set -o APPEND_HISTORY
set -o EXTENDED_HISTORY  # record timestamp of command
set -o HIST_REDUCE_BLANKS  # removes blank lines
set -o HIST_IGNORE_DUPS
set -o INC_APPEND_HISTORY_TIME  # add commands immediately after execution
set -o HIST_IGNORE_SPACE # if prefixed with space, don't add to history
HISTFILE="${HOME}/.zsh_history"
HISTSIZE=10000
SAVEHIST=10000
function history() { builtin fc -l -i "${@:-1}" ; }

# Change colors of `ls`
# ref: http://www.bigsoft.co.uk/blog/2008/04/11/configuring-ls_colors
export LS_COLORS='di=01;36:ln=01;34'

# Prevent text replacement on Mac
# TODO: Change this so it only runs every 20 days or so
defaults write -g WebAutomaticTextReplacementEnabled -bool false




#############
# Built-ins #
#############

# test_source ~/.aliasrc

alias v='vim'
alias nv='nvim'

rm() {
  if command -v trash >/dev/null 2>&1; then
    echo "Tip: Use 'trash [file]' for safer deletes."
  else
    echo "Tip: 'trash' not found. Install it with:"
    echo "  brew install trash"
  fi
  echo "Executing 'rm' as requested..."
  command rm "$@"
}

###########
# Plugins #
###########

# VI Mode

# ZLE - Z-Shell Line Editor
# ref: https://zsh.sourceforge.io/Guide/zshguide04.html

# Selects keymap 'viins', and also links it to 'main'
# ref: https://linux.die.net/man/1/zshzle
bindkey -v
export KEYTIMEOUT=1

# Edit line in vim with ctrl-t
zle -N edit-command-line
bindkey '^t' edit-command-line

# Remove `execute` prompt in normal mode
bindkey -rM vicmd ':'

# Change cursor shape based on mode
# Make sure vim plugin wincent/terminus is installed.
#   TODO: why? it seems to already be working
function zle-keymap-select {
  if [[ ${KEYMAP} == vicmd ]] || [[ $1 = 'block' ]]; then
    echo -ne '\e[1 q'
  elif [[ ${KEYMAP} == main ]] ||
       [[ ${KEYMAP} == viins ]] ||
       [[ ${KEYMAP} = '' ]] ||
       [[ $1 = 'beam' ]]; then
    echo -ne '\e[5 q'
  fi
}
zle -N zle-keymap-select
# Use beam shape cursor for each new prompt.
function initialize_the_beam() { echo -ne '\e[5 q'; }
# Initialize with the beam
initialize_the_beam
add-zsh-hook precmd initialize_the_beam


# ZSH Syntax Highlighting
# `brew install zsh-syntax-highlighting`
test_source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern)
typeset -gA ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_STYLES[suffix-alias]=fg=114,bold
ZSH_HIGHLIGHT_STYLES[precommand]=fg=114,bold
ZSH_HIGHLIGHT_STYLES[arg0]=fg=114
ZSH_HIGHLIGHT_STYLES[builtin]=fg=114,bold
ZSH_HIGHLIGHT_STYLES[history-expansion]=fg=38

# ZSH History Substring Search
# `brew install zsh-history-substring-search`
# ref: https://github.com/zsh-users/zsh-history-substring-search
# NOTE: Should go *after* ZSH Syntax Highlighting
test_source $(brew --prefix)/share/zsh-history-substring-search/zsh-history-substring-search.zsh
HISTORY_SUBSTRING_SEARCH_FUZZY=true
HISTORY_SUBSTRING_SEARCH_ENSURE_UNIQUE=true
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
bindkey -M vicmd 'k' history-substring-search-up
bindkey -M vicmd 'j' history-substring-search-down



######################
# Path Modifications #
######################

# NeoVim
[[ -d ~/.config/nvim ]] || ln -s ~/.vim ~/.config/nvim 2>/dev/null
[[ -f ~/.config/nvim/init.vim ]] || ln -s ~/.vimrc ~/.config/nvim/init.vim 2>/dev/null

# # RubyMine
# # for `rubymine` command
# export PATH="$PATH:/Applications/RubyMine.app/Contents/MacOS"

# # iTerm2
# test_source ~/.iterm2_shell_integration.zsh



#####################
# git Modifications #
#####################

# Git status after git commands
# default list of git commands `git status` is running after
gitPreAutoStatusCommands=( 'add' 'checkout' 'commit' 'fetch' 'mv' 'prune' 'push' 'rebase' 'reset' 'restore' 'rm' )

function element_in_array() {
  local e
  for e in "${@:2}"; do [[ "$e" == "$1" ]] && return 0; done
  return 1
}

function git() {
    command git $@
    if (element_in_array $1 $gitPreAutoStatusCommands); then
        echo -ne '\n\n'
        command git status
    fi
}


##########
# Prompt #
##########

# unused: 
# function _terminal_width() { stty size | cut -d" " -f2 ; }

function date_lower() { echo $(date +"%a %b %d" | tr '[:upper:]' '[:lower:]') }

function time_tz() {
  local tz=${1:-UTC}
  local format=${2:-"+%H:%M"}

  local system_date=$(date "+%Y%m%d")
  local tz_date=$(TZ="$tz" date "+%Y%m%d")
  local sign=''
  if (( tz_date > system_date )); then
    sign+="⁺"
  elif (( tz_date < system_date )); then
    sign+="⁻"
  fi

  echo "$(TZ="$tz" date "$format$sign %Z")"
}

function fmt_duration_ms() {
  local ms="$1"

  local hours=$(( ms / 3600000 ))
  local minutes=$(( (ms % 3600000) / 60000 ))
  local seconds=$(( (ms % 60000) / 1000 ))
  local milliseconds=$(( ms % 1000 ))

  if (( ms >= 3600000 )); then
    echo "${hours}h${minutes}m${seconds}s"
  elif (( ms >= 60000 )); then
    echo "${minutes}m${seconds}s"
  elif (( ms > 1000 )); then
    echo "$(printf '%d.%ds' "$seconds" "$(( milliseconds / 100 ))")"
  elif (( ms > 0 )); then
    echo "$(printf '%d.%03ds' "$seconds" "$(( milliseconds ))")"
  elif (( ms == 0 )); then
    echo "less than 1s" 
  else
    echo "Invalid input: negative milliseconds"
  fi
}

# exec_elapsed_time prints a string calculated by start_exec_timer and end_exec_timer_ms
function exec_elapsed_time() { fmt_duration_ms ${ZSH_ELAPSED_TIME} }

function repo() { basename -s .git $(\git remote get-url origin 2>/dev/null) 2>/dev/null }

function branch() { \git rev-parse --abbrev-ref HEAD 2>/dev/null }

function git_ahead_behind_status() {
  local remote_ref=$(\git rev-parse --abbrev-ref --symbolic-full-name @{u} 2>/dev/null)
  if [[ -n $remote_ref ]]; then
    local ahead_count=$(\git rev-list --count HEAD..$remote_ref 2>/dev/null)
    local behind_count=$(\git rev-list --count $remote_ref..HEAD 2>/dev/null)
    # 24, 22 - dark
    # 32, 35
    # 39, 41 - light
    # 75, 71 - more matte
    local ahead="%{%F{243}%}"${ahead_count}"▼%{%f%}"
    local behind="%{%F{243}%}"${behind_count}"▲%{%f%}"

    if [[ $ahead_count -gt 0 && $behind_count -gt 0 ]]; then
      echo $ahead$behind
    elif [[ $ahead_count -gt 0 ]]; then
      echo $ahead
    elif [[ $behind_count -gt 0 ]]; then
      echo $behind
    fi
  fi
}

function git_status_check() {
  local status_output=$(git status --porcelain 2>/dev/null)
  local staged_changes=$(echo $status_output | grep -E '^[MTADRCU]')
  local unstaged_changes=$(echo $status_output | grep -E '^ [MTADRCU]')
  if [[ -z "$status_output" ]]; then
    echo 0
  elif [[ -n "$unstaged_changes" && -n "$staged_changes" ]]; then
    echo 2
  elif [[ -n "$unstaged_changes" ]]; then
    echo 1
  else
    echo 3
  fi
}

function branch_has_remote_but_is_not_tracked() {
  local remote_url=$(\git remote get-url origin 2>/dev/null)
  local remote_branch=$(\git for-each-ref --format='%(upstream:short)' refs/heads/"$(\git rev-parse --abbrev-ref HEAD 2>/dev/null)" 2>/dev/null)
  [[ -n $remote_url && -z $remote_branch ]] && echo 1 || echo 0
}

function custom_pwd() {
  local git_root=$(\git rev-parse --show-toplevel 2>/dev/null)
  local current_dir=$(pwd)

  if [[ -n $git_root ]]; then
    local relative_path=${current_dir#$git_root}
    echo "${relative_path#/}"
  elif [[ $current_dir == $HOME ]]; then
    echo "~ %{%F{243}%}($(whoami))%{%f%}"
  elif [[ $current_dir == $HOME/* ]]; then
    local shortened_path="%{%F{243}%}$(whoami)/%{%f%}${current_dir#$HOME/}"
    echo "${shortened_path/#\//}"
  else
    echo "$current_dir"
  fi
}

function oscillate() {
  local lower=$1
  local upper=$2
  local command_history_number=$HISTCMD
  local range=$(( $upper - $lower + 1 ))
  local offset=$(( command_history_number % (range * 2) ))
  [[ $offset -ge $range ]] && offset=$(( 2 * range - offset - 1 ))
  echo $(( $upper - offset ))
}

function whereami() {
  local repo=$(repo)
  local branch=$(branch)
  local dir=$(custom_pwd)
  local git_status_check=$(git_status_check)
  local abs=$(git_ahead_behind_status)
  local grounded=$(branch_has_remote_but_is_not_tracked)
  [[ -n $repo || -n $dir ]] && echo -n "\n  "
  [[ -n $repo ]] && echo -n "%{%F{$(oscillate 71 75)}%}"$repo"%{%f%}"
  [[ -n $repo && -n $dir ]] && echo -n "/"
  [[ -n $dir ]] && echo -n "$dir"
  if [[ -n $branch ]]; then
    if (( $grounded == 1 )); then
      echo -n " %{%F{243}%}⏚%{%f%} "
    elif [[ -n $abs ]]; then
      echo -n " "$abs" "
    else
      echo -n " %{%F{243}%}➤%{%f%} "
    fi
  fi
  (( $git_status_check == 1 )) && echo -n "%{%F{131}%}✱%{%f%}" # orange, 131 
  (( $git_status_check == 2 )) && echo -n "%{%F{179}%}✱%{%f%}" # yellow, 222
  (( $git_status_check == 3 )) && echo -n "%{%F{71}%}✱%{%f%}" # green, 71
  [[ -n $branch ]] && echo -n $branch
}

touch ~/.hush_login
add-zsh-hook precmd () {printf "\n\n\n\n\n"}
# Retired 2025-05-26
# PROMPT='$(tput cuu 5)

# %{%F{243}%}↳%{%f%} $(date_lower) %{%F{243}%}@%{%f%} $(time_tz America/Los_Angeles +%H:%M:%S) %{%F{243}%}| $(time_tz America/Denver) | $(time_tz America/Chicago) | $(time_tz America/New_York) | $(time_tz)%{%f%}$(whereami)

#   '
PROMPT='$(tput cuu 5)

%{%F{243}%}↳%{%f%} $(date_lower) %{%F{243}%}@%{%f%} $(time_tz America/Los_Angeles +%H:%M:%S) %{%F{243}%}| $(time_tz)%{%f%}$(whereami)

'
add-zsh-hook preexec () {echo}


function elapsed_time() { print "↳ $(exec_elapsed_time)" }
function return_code() { print "%(?.%F{71}✔.%F{167}✖%?)%f" }
function right_prompt() { [[ $ZSH_START_TIME -ne -1 ]] && echo "   %F{243}$(elapsed_time)%f $(return_code)"}

# NOTE: Must be in single quotes to recompute values
# NOTE: The #PROMPT at the end of the next line is the length of $PROMPT
# ref: https://en.wikipedia.org/wiki/ANSI_escape_code#CSI_sequences
RPS1='%{$(tput cuu 2)%}$(right_prompt)%{$(tput cud 2)$(tput cuf ${#PROMPT})%}'





############
# Commands #
############

kill_at_port() {
  local port=$1
  local pids

  if [[ -n $port ]]; then
    pids=$(lsof -i ":$port" | awk '!/^COMMAND/ {print $2}' | sort -u | tr '\n' ' ')

    if [[ -n $pids ]]; then
      echo "Processes running on port $port: $pids"
      if [[ "$2" == "--dry-run" ]]; then
        echo "Dry run mode: Processes will not be killed."
      else
        echo "Killing the processes..."
        kill $pids
      fi
    else
      >&2 echo "No processes found on port $port."
      return 1
    fi
  else
    >&2 echo "Please provide a valid port number."
    return 1
  fi
}

function gpush() {
  local current_branch=$(\git rev-parse --abbrev-ref HEAD 2>/dev/null)

  if [[ -z $current_branch ]]; then
    echo "Not in a Git repository or unable to determine the current branch."
    return 1
  fi

  if [[ $current_branch == "main" ]]; then
    echo "Current branch is 'main'. Please enter a new branch name:"
    read -r new_branch_name

    # Check if the new branch name is provided
    if [[ -z $new_branch_name ]]; then
      echo "No branch name entered. Aborting."
      return 1
    fi

    # Create and checkout the new branch
    \git checkout -b "$new_branch_name"
    current_branch="$new_branch_name"
  fi

  local remote_url=$(\git config --get remote.origin.url)

  if [[ -z $remote_url ]]; then
    echo "Unable to retrieve the GitHub remote URL."
    return 1
  fi

  # Extract the organization/username and repository name from the remote URL
  local github_repo=$(echo "$remote_url" | sed -E -e 's/^.*(github\.com[:/]|github\.com[/:])//' -e 's/\.git$//')

  if [[ -z $github_repo ]]; then
    echo "Unable to parse the GitHub repository name from the remote URL."
    return 1
  fi

  # Check if the branch already exists on the remote origin
  if \git ls-remote --exit-code --heads origin "$current_branch" &>/dev/null; then
    local push_command="\git push origin $current_branch"
  else
    local push_command="\git push -u origin $current_branch"
  fi

  # Check if branch has changes to be pushed up, and early-exit if not
  local remote_ref=$(\git rev-parse --abbrev-ref --symbolic-full-name @{u} 2>/dev/null)
  local ahead_count=$(\git rev-list --count HEAD..$remote_ref)
  local behind_count=$(\git rev-list --count $remote_ref..HEAD)

  if [[ $ahead_count -gt 0 || $behind_count -gt 0 ]]; then
    echo "Changes found. Proceeding with the push..."
  else
    echo -e "No changes to be pushed.\n"
    \git status
    return 0
  fi

  # Check if the caller passed -f option for force-push
  if [[ $1 == "-f" ]]; then
    push_command+=" -f"
  fi

  # Perform the push
  eval "$push_command"

  local github_url="https://github.com/$github_repo/compare/main...$current_branch"
  if command -v xdg-open &>/dev/null; then
    xdg-open "$github_url"  # For Linux
  elif command -v open &>/dev/null; then
    open "$github_url"      # For macOS
  else
    echo "Unable to open the link automatically. Please visit: $github_url"
  fi
}


function git_commit() {
  local commands_to_run=()

  echo "Choose commands to run before committing:"
  echo "1. Run committer --fix"
  echo "2. Run bin/srb tc"
  echo "3. Run bin/packs update"
  echo "0. Continue without running any commands"

  echo -n "Enter your choices (e.g., 1 2 3): "
  read -r choices

  if [[ "$choices" =~ [1-3] ]]; then
    [[ "$choices" =~ 1 ]] && commands_to_run+=("committer --fix")
    [[ "$choices" =~ 2 ]] && commands_to_run+=("bin/srb tc")
    [[ "$choices" =~ 3 ]] && commands_to_run+=("bin/packs update")
  fi

  \git status

  echo -n "ADD all changes? (Y/n): "
  read -r add_all_changes
  [[ $add_all_changes == "" || $add_all_changes == "y" || $add_all_changes == "Y" ]] && commands_to_run=("\git add ." "${commands_to_run[@]}")

  prev_commit_msg=$(\git log -1 --pretty=%B)
  echo -e "\nPrevious commit message:\n\n$prev_commit_msg"

  echo -n "AMEND the previous commit? (y/N): "
  read -r amend_commit

  if [[ $amend_commit == "y" || $amend_commit == "Y" ]]; then
    echo -n "EDIT the commit message? (Y/n): "
    read -r edit_commit
  fi

  if [[ $amend_commit != "y" && $amend_commit != "Y" && ($edit_commit == "y" || $edit_commit == "Y" || $edit_commit == "") ]]; then
    echo -n "Press Enter to open Vim for editing the commit message..."
    read -r _  # Pause for user to press Enter
    commit_message=$(mktemp)
    echo "$prev_commit_msg" > "$commit_message"
    vim "$commit_message"  # Open Vim for editing the commit message
  fi

  echo -n "PUSH on success? (Y/n/f): "
  read -r push_commit

  # Execute the chosen commands at the end
  for cmd in "${commands_to_run[@]}"; do
    eval "$cmd"
    if [[ $? -ne 0 ]]; then
      echo "Command failed: $cmd"
      return 1
    fi
  done

  if [[ $amend_commit == "y" || $amend_commit == "Y" || $amend_commit == "" ]]; then
    if [[ -z $commit_message ]]; then
      \git commit --amend --no-edit
    else
      \git commit --amend -m "$commit_message"
    fi
  else
    if [[ -z $commit_message ]]; then
      \git commit
    else
      \git commit -m "$commit_message"
    fi
  fi

  if [[ $? -ne 0 ]]; then
    echo "Commit failed; early exiting"
    return 1  # Early exit if a command fails
  fi

  if [[ $push_commit == "y" || $push_commit == "Y" || $push_commit == "" ]]; then
    gpush
  elif [[ $push_commit == "f" || $push_commit == "F" ]]; then
    gpush -f
  fi
}

# TODO: aliases
#   github stuff
alias g='echo "git" && git'
alias gs='echo "git status" && git status'
alias gco='echo "git checkout" && git checkout'
alias gcob='echo "git checkout -b" && git checkout -b'
function ga { if [ $# -eq 0 ] ; then echo "git add ." && git add . ; else echo "git add" && git add "$@" ; fi }
alias cf='echo "committer --fix" && committer --fix'
alias gcm='echo "git commit -m" && git commit -m'
alias gca='echo "git commit --amend" && git commit --amend'
alias gcan='echo "git commit --amend --no-edit" && git commit --amend --no-edit'
alias gcane='gcan'
alias gcempty='echo "git commit --allow-empty-message --message=\"\"" && git commit --allow-empty-message --message=""'
alias gcf='echo "git commit --amend --no-edit && git push -f" && git commit --amend --no-edit && git push -f'
alias gp='echo "git push" && git push'
alias gpf='echo "git push -f" && git push -f'
function wippush {
  # TODO: echo the entire command
  # TODO: check out new branch if current branch is main
  git add .
  git commit -m 'WIP' -n # TODO: provide message
  git push # TODO: push set upstream if not already
}
# alias wippush='git add . && git commit -m "WIP" && '


alias rs='echo "bin/rspec" && bin/rspec --format documentation'
alias rsn='echo "bin/rspec --next-failure" && bin/rspec -n'
alias srb='echo "bin/srb tc" && bin/srb tc'
alias pu='echo "bin/pks update" && bin/pks update'
alias rc='echo "bin/rails console" && bin/rails c'
alias rr='echo "bin/rails runner" && bin/rails r'
alias mig='echo "bin/rails db:migrate" && bin/rails db:migrate'

# echo -n "Pry.commands.alias_command 'c', 'continue'\nPry.commands.alias_command 's', 'step'\nPry.commands.alias_command 'n', 'next'\n" > ~/.pryrc
# TODO: vimrc





#############
# OVERRIDES #
#############

# RSpec - don't show profiling info
export SPECOPT="--format documentation --no-profile"

[[ -f ~/.context_overrides ]] && source ~/.context_overrides
# Work
source ~/.gusto/init.sh >/dev/null 2>/dev/null # uh oh lol

export OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES DISABLE_SPRING=1
export USE_CODEOWNERS_RS=true






########
# INIT #
########

end_exec_timer_ms
# `\e[1A` scrolls up a line
echo -e "\r\e[1A\e[1A\e[38;5;71m✔\e[0m loaded ~/.zshrc in $(exec_elapsed_time).
                                        
                                        
                                        
⏻ welcome \e[38;5;216mAnthony\e[0m.                   


$(tput cuu 2)"
