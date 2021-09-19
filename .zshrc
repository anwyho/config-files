#!/bin/env zsh

#####  #### #   #
   #  #     #   #
  #    ###  #####
 #        # #   #
##### ####  #   #

#  run  configs  #

# Exit for non-interactive shell
[[ $- != *i* ]] && return
# Otherwise, cool greeting
# echo '
#            ^^                  @@@@@@@@@@              ^^
#                   ^^        @@@@@@@@@@@@@@@@    ^^
#               --           @@@@@@@@@@@@@@@@@@
#           __  )_) __      @@@@@@@@@@@@@@@@@@@@        ^^
# ~~~~~~~~~ )_) )_) )_) ~~~ &&&&&&&&&&&&&&&&&&&& ~~~~~~~ ~~~~~
# ~        __!___!___!__  ~ ~~~~~~~~~~~~~~~~~~~~ ~       ~~
#         ~\_ _ _ _ _ _/ ~~  ~~~~~~~~~~~~~ ~~~~  ~     ~~~
#     ~   ~~~~ ~~~ ~~~~   ~    ~~~~~~  ~~ ~~~       ~~ ~ ~~  ~
# ~  ~       ~ ~      ~           ~~ ~~~~~~  ~      ~~  ~
#       ~             ~        ~      ~      ~~   ~
# 
#                       s h i p   i t !
# 
# '


####################
# Autoload Modules #
####################

autoload -U colors && colors  # enable colors
autoload -Uz vcs_info  # for use in prompts
autoload -U add-zsh-hook  # hooks for prompts
autoload -U compinit
autoload edit-command-line


###########
# Options #
###########

# See for all options
# ref: http://zsh.sourceforge.net/Doc/Release/Options.html#Options
set -o AUTO_CD
set -o CORRECT  # prompt suggestions for mispelled commands
set -o NO_CASE_GLOB
set -o PROMPT_SUBST

# Change colors of `ls`
# ref: http://www.bigsoft.co.uk/blog/2008/04/11/configuring-ls_colors
export LS_COLORS='di=01;36:ln=01;34'

set -o APPEND_HISTORY
set -o EXTENDED_HISTORY  # record timestamp of command:w
set -o HIST_REDUCE_BLANKS  # removes blank lines
set -o HIST_IGNORE_DUPS
set -o INC_APPEND_HISTORY_TIME  # add commands immediately after execution
set -o SHARE_HISTORY
HISTFILE="${HOME}/.zsh_history"
HISTSIZE=10000
SAVEHIST=10000
function history() { builtin fc -l -i "${@:-1}" ; }



####################
# Prompt functions #
####################

# git_branch prints the current branch.
# Only for use in prompt.
function git_branch() {
  local branch
  branch="$(git remote -v 2>/dev/null | grep anwyho/config-files >/dev/null || git rev-parse --abbrev-ref HEAD 2>/dev/null)"
  if [[ -n $branch ]]; then
    if has_unstaged; then
      [[ $1 != "--no-flag" ]] && branch="${branch}${GIT_DIRTY_BRANCH_TAG:-*}"
      branch=" ${GIT_DIRTY_PREFIX:-%f%F{253\}git:}${branch}${GIT_DIRTY_SUFFIX:-%f}"
    else
      branch=" ${GIT_CLEAN_PREFIX:-%f%F{115\}git:}${branch}${GIT_CLEAN_SUFFIX:-%f}"
    fi  # has_unstaged
  fi  # branch exists
  echo $branch
}

# git_repo_name prints name of repo's enclosing directory, usually the name of the repo
# Only for use in prompt.
function git_repo_name() {
  local repo_path
  if repo_path="$(git rev-parse --show-toplevel 2>/dev/null)" && [[ -n "$repo_path" ]]; then
    echo ${repo_path:t}
  fi
}

# has_unstaged returns 0 if working tree is dirty, 1 if clean.
# Only for use in prompt.
function has_unstaged() {
  local wt_status
  local -a flags
  flags=('--porcelain')
  [[ "${DISABLE_UNTRACKED_FILES_DIRTY:-true}" == "true" ]] && flags+='--untracked-files=no'
  case "$GIT_STATUS_IGNORE_SUBMODULES" in
    git) ;;  # let git decide (this respects per-repo config in .gitmodules)
    *)  # if unset: ignore dirty submodules
        # other values are passed to --ignore-submodules
      flags+="--ignore-submodules=${GIT_STATUS_IGNORE_SUBMODULES:-dirty}"
      ;;
  esac
  working_tree_status=$(command git status ${flags} 2> /dev/null | tail -n1)
  [[ -n $working_tree_status ]] && return 0 || return 1
}

# random_notes prints out a line of music with an optional length.
function random_notes() {
  local length=${1:-20}
  printf "❴|𝄢 " 
  for (( i=0; i<${length}-7; ++i )); do 
    case $(( $RANDOM%30 )) in 
      0|1|2) printf "♪" ;;
      3|4|5) printf "♫" ;;
      6|7|8) printf "♬" ;;
      9|10|11) printf "♩" ;;
      12|13) printf "|" ;;
      *) printf " " ;;
    esac
  done
  print " ‖"
}


# Elapsed time functions

# ZSH_START_TIME is -1 if no command is running. 
export ZSH_START_TIME=-1
# ZSH_CMD_RUNNING is 0 if no command is running.
export ZSH_CMD_RUNNING=0 # boolean

# start_exec_timer sets variables to record the start of a command execution.
function start_exec_timer() {
  export ZSH_START_TIME=$(date +%s)
  export ZSH_CMD_RUNNING=1
}
add-zsh-hook preexec start_exec_timer

# end_exec_timer sets variables to calculate the elapsed time of an executed command.
# Must be called after start_exec_timer
function end_exec_timer() {
  if [[ ${ZSH_CMD_RUNNING} -eq 0 ]]; then
    export ZSH_START_TIME=-1
    return 0
  fi
  export ZSH_CMD_RUNNING=0
  export ZSH_ELAPSED_TIME=$(( $(date +%s) - ${ZSH_START_TIME} ))
}
add-zsh-hook precmd end_exec_timer

# _fmt_duration_s turns an integer of seconds into a string timestamp into the form 1h2m3s.
function _fmt_duration_s() {
  local s
  s=$1
  if (( s >= 3600 )); then
    h=$(( s / 3600 ))
    m=$(( s % 3600 / 60 ))
    s=$(( s % 60 ))
    echo "${h}h${m}m${s}s"
  elif (( s >= 60 )); then
    m=$(( s % 3600 / 60 ))
    s=$(( s % 60 ))
    echo "${m}m${s}s"
  elif (( s == 0 )); then
    echo "less than 1s"
  else
    echo "${s}s"
  fi
}

# exec_elapsed_time prints a string calculated by start_exec_timer and end_exec_timer
function exec_elapsed_time() { _fmt_duration_s ${ZSH_ELAPSED_TIME} }



##################
# Prompt Display #
##################

# %Mm machine hostname
# %E clear line
# %n username
# %* 24hr hh:mm:ss
# %w date day-dd
# %? return code of previous command
# ref: https://zsh.sourceforge.io/Doc/Release/Prompt-Expansion.html#Visual-effects
# Cool Glyphs
# ✌♪♫♬♩➤⚓⚑⚐♨☕☽☾∫⇶¶±¤»°⌫↲☒✝†❯✖▴
# NOTE: Must be in single quotes to recompute values

function _terminal_width() { stty size | cut -d" " -f2 ; }
# _exec_splitter creates a line of music the width of the terminal
function exec_splitter() { printf "\e[90m" && random_notes $(_terminal_width) ; }
add-zsh-hook precmd exec_splitter

function _formatted_date() { echo "%F{38}%D{%a} %F{117}%D{%b %d} %F{216}%D{%H:%M:%S} %F{229}%D{%Z}" ; }
function _current_directory() { echo "%~" ; }
function _git_info() { echo $(git_branch) ; }
function _python_venv() { echo $(venv_name 2>/dev/null) }
export VIRTUAL_ENV_DISABLE_PROMPT=1

PROMPT_HEADER='%E$(_formatted_date) %F{grey}@%f %F{193}$(_current_directory) %f$(_git_info) $(_python_venv)'
function prompt_header() { print -P $PROMPT_HEADER ; }
add-zsh-hook precmd prompt_header

PROMPT=' %F{24}%(!.%F{red}#%f.$%F{white} '

function _elapsed_time() { print "↳ $(exec_elapsed_time)" ; }
function _return_code() { print "%(?.%F{green}✔.%F{red}✖%?)%f" ; }
function _right_prompt() { [[ $ZSH_START_TIME -ne -1 ]] && echo " ‖  %F{243}$(_elapsed_time)%f $(_return_code)"}
# NOTE: The #PROMPT at the end of the next line is the length of the prompt
# ref: https://en.wikipedia.org/wiki/ANSI_escape_code#CSI_sequences
RPS1='%{$(tput cuu 2)%}$(_right_prompt)%{$(tput cud 2)$(tput cuf ${#PROMPT})%}'

# TODO: Research into this for prompt below screen
    # terminfo_down_sc=$terminfo[cud1]$terminfo[cuu1]$terminfo[sc]$terminfo[cud1]
    # function zle-line-init zle-keymap-select {
    #     PS1_2="${${KEYMAP/vicmd/-- NORMAL --}/(main|viins)/-- INSERT --}"
    #     PS1="%{$terminfo_down_sc$PS1_2$terminfo[rc]%}%~ %# "
    #     zle reset-prompt
    # }
    # preexec () { print -rn -- $terminfo[el]; }



######################
# Path Modifications #
######################

# Python
export PATH="${HOME}/.pyenv/shims:$PATH"
if command -v pyenv 1>/dev/null 2>&1; then eval "$(pyenv init -)"; fi

# Ruby
if command -v rbenv 1>/dev/null 2>&1; then eval "$(rbenv init -)"; fi

# Heroku
export PATH="/usr/local/heroku/bin:$PATH"

# NeoVim
[ -e ~/.config/nvim ] || ln -s ~/.vim ~/.config/nvim
[ -e ~/.config/nvim/init.vim ] || ln -s ~/.vimrc ~/.config/nvim/init.vim

# Google Cloud SDK
test -e "/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc" && source "/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc"
test -e "/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc" && source "/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc"

# iTerm2 Shell integration
test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

# Direnv
if command -v direnv 1>/dev/null 2>&1; then eval "$(direnv hook zsh)"; fi


#############
# Built-ins #
#############

[[ -f ~/.aliasrc ]] && source ~/.aliasrc

# NOTE: -g is a global alias, substituted in the middle of commands. It's ZSH specific.
alias -g ...='../..'
alias -g ....='../../..'
alias -g .....='../../../..'
alias -g ......='../../../../..'



#####################
# Autocomplete menu #
#####################

zstyle ':completion:*' menu select
zmodload zsh/complist
compinit
_comp_options+=(globdots)		# Include hidden files.
# Use Vim keys in tab complete menu:
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history



###########
# Vi mode #
###########

bindkey -v
export KEYTIMEOUT=1

# Edit line in vim with ctrl-t
zle -N edit-command-line
bindkey '^t' edit-command-line

# Change cursor shape based on mode
# Make sure vim plugin wincent/terminus is installed.
function zle-keymap-select {
  if [[ ${KEYMAP} == vicmd ]] ||
     [[ $1 = 'block' ]]; then
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
_initialize_beam() { echo -ne '\e[5 q'; }
# Initialize with beam
_initialize_beam
add-zsh-hook precmd _initialize_beam



###########
# Plugins #
###########

# ZSH Syntax Highlighting
# brew install zsh-syntax-highlighting
zsh_syntax_highlighting_path=/usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
[[ -f $zsh_syntax_highlighting_path ]] && source $zsh_syntax_highlighting_path
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern)
typeset -gA ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_STYLES[suffix-alias]=fg=114,bold
ZSH_HIGHLIGHT_STYLES[precommand]=fg=114,bold
ZSH_HIGHLIGHT_STYLES[arg0]=fg=114
ZSH_HIGHLIGHT_STYLES[builtin]=fg=114,bold
ZSH_HIGHLIGHT_STYLES[history-expansion]=fg=38

# ZSH History Substring Search
# brew install zsh-history-substring-search
zsh_history_substring_search=/usr/local/share/zsh-history-substring-search/zsh-history-substring-search.zsh
[[ -f $zsh_history_substring_search ]] && source $zsh_history_substring_search
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
bindkey -M vicmd 'k' history-substring-search-up
bindkey -M vicmd 'j' history-substring-search-down

# Git status after git commands
# default list of git commands `git status` is running after
gitPreAutoStatusCommands=(
    'add'
    'diff'
    'fetch'
    'push'
    'rm'
    'reset'
    'restore'
    'commit'
    'checkout'
    'mv'
    'init'
)

function _elementInArray() {
  local e
  for e in "${@:2}"; do [[ "$e" == "$1" ]] && return 0; done
  return 1
}

function git() {
    command git $@

    if (_elementInArray $1 $gitPreAutoStatusCommands); then
        printf "%0.s=" $( seq 1 1 72 ); echo ""
        command git status
    fi
}


_wakatime_heartbeat() {
  # Sends a heartbeat to the wakarime server before each command.
  # But it can be disabled by an environment variable:
  # Set `$WAKATIME_DO_NOT_TRACK` to non-empty value to skip the tracking.
  if (( WAKATIME_DO_NOT_TRACK )); then
    return  # Tracking is skipped!
  fi

  # Checks if `wakatime` is installed,
  # syntax is `zsh` specific, see: https://unix.stackexchange.com/a/237084
  if (( ! $+commands[wakatime] )); then
    echo 'wakatime cli is not installed, run:'
    echo '$ pip install wakatime'
    echo 'Or check that wakatime is in PATH'
    echo
    echo 'Time is not tracked for now.'
    return
  fi

  # We only send the last command to the wakatime.
  # We only send the first argument, which is a binary in 99% of cases.
  # It does not include any sensitive information.
  local last_command
  last_command=$(echo "$1" | cut -d ' ' -f1)

  # We only take the `root` directory name.
  # We detect `root` directories by `.git` folder.
  # If we are not in the git repository,
  # take the default `Terminal` project.
  local root_directory
  root_directory=$(
    git rev-parse --show-toplevel 2>/dev/null || echo 'Terminal'
  )

  # Checks if the app should work online, otherwise returns
  # a special option to turn `wakatime` sync off:
  local should_work_online
  if (( WAKATIME_DISABLE_OFFLINE )); then
    should_work_online='--disable-offline'
  else
    should_work_online=''
  fi

  wakatime --write \
    --plugin 'wakatime-zsh-plugin/0.2.1' \
    --entity-type app \
    --entity "$last_command" \
    --project "${root_directory:t}" \
    --language sh \
    --timeout "${WAKATIME_TIMEOUT:-5}" \
    $should_work_online \
    &>/dev/null </dev/null &!
}
add-zsh-hook preexec _wakatime_heartbeat

export WAKATIME_DO_NOT_TRACK=

