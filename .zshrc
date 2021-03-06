#!/bin/env zsh

#####  #### #   #
   #  #     #   #
  #    ###  #####
 #        # #   #
##### ####  #   #

#  run  configs  #

# Exit for non-interactive shell
[[ $- != *i* ]] && return


####################
# Autoload Modules #
####################

autoload -U colors && colors  # enable colors
autoload -Uz vcs_info  # for use in prompts
autoload -U add-zsh-hook  # hooks for prompts
autoload -U compinit
autoload edit-command-line


####################
# Useful functions #
####################

# Git functions #

# Prints current branch
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
# Prints name of repo's enclosing directory, usually the name of the repo
function git_repo_name() {
  local repo_path
  if repo_path="$(git rev-parse --show-toplevel 2>/dev/null)" && [[ -n "$repo_path" ]]; then
    echo ${repo_path:t}
  fi
}
# Checks if working tree is dirty
function has_unstaged() {
  local wt_status
  local -a flags
  flags=('--porcelain')
  if [[ "${DISABLE_UNTRACKED_FILES_DIRTY:-true}" == "true" ]]; then
    flags+='--untracked-files=no'
  fi
  case "$GIT_STATUS_IGNORE_SUBMODULES" in
    git) ;;  # let git decide (this respects per-repo config in .gitmodules)
    *)  # if unset: ignore dirty submodules
        # other values are passed to --ignore-submodules
      flags+="--ignore-submodules=${GIT_STATUS_IGNORE_SUBMODULES:-dirty}"
      ;;
  esac
  wt_status=$(command git status ${flags} 2> /dev/null | tail -n1)
  [[ -n $wt_status ]] && return 0 || return 1
}

echo '
           ^^                  @@@@@@@@@@              ^^
                  ^^        @@@@@@@@@@@@@@@@    ^^
              --           @@@@@@@@@@@@@@@@@@
          __  )_) __      @@@@@@@@@@@@@@@@@@@@        ^^
~~~~~~~~~ )_) )_) )_) ~~~ &&&&&&&&&&&&&&&&&&&& ~~~~~~~ ~~~~~
~        __!___!___!__  ~ ~~~~~~~~~~~~~~~~~~~~ ~       ~~
        ~\_ _ _ _ _ _/ ~~  ~~~~~~~~~~~~~ ~~~~  ~     ~~~
    ~   ~~~~ ~~~ ~~~~   ~    ~~~~~~  ~~ ~~~       ~~ ~ ~~  ~
~  ~       ~ ~      ~           ~~ ~~~~~~  ~      ~~  ~
      ~             ~        ~      ~      ~~   ~

                      s h i p   i t !

'

# Elapsed time functions #

# TODO: Write some documentation on this
export ZSH_E_TIME=-1
export ZSH_CMD_RUNNING=0
function export_cmd_starttime() {
  export ZSH_E_TIME=$(( $(date +%s) * -1 ))
  export ZSH_CMD_RUNNING=1
}
function export_cmd_runtime() {
  if [[ ZSH_CMD_RUNNING -eq 0 ]]; then
    export ZSH_E_TIME=-1
    return 0
  fi
  export ZSH_CMD_RUNNING=0
  export ZSH_E_TIME=$(( $(date +%s) + ${ZSH_E_TIME} ))
}
add-zsh-hook preexec export_cmd_starttime
add-zsh-hook precmd export_cmd_runtime
function fmt_sec() {
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


# Prompt-related #

function notes() {
  local cmd_num
  cmd_num=$(history |tail -1 |grep -o -E '\d+' |head -1)
  case $(( $cmd_num % 3 )) in
    0) printf ♪♫♩ ;;
    1) printf ♫♩♪ ;;
    *) printf ♩♪♫ ;;
  esac
}


##########
# Prompt #
##########

# %Mm machine hostname
# %E clear line
# %n username
# %* 24hr hh:mm:ss
# %w date day-dd
# %? return code of previous command
# COOL GLYPHS
# ✌♪♫♬♩➤⚓⚑⚐♨☕☽☾∫⇶¶±¤»°⌫↲☒✝†❯✖

set -o prompt_subst
function elapsed_time() { [[ $ZSH_E_TIME -ne -1 ]] && echo "↳ $(fmt_sec $ZSH_E_TIME)" ; }
function invitation() { echo "$(notes) ❯❯❯" ; }
function return_code() { [[ $ZSH_E_TIME -ne -1 ]] && echo "%(?.%F{green}✔.%F{red}✖%?)%f" ; }
function venv_name() { [[ -n "$VIRTUAL_ENV" ]] && echo " py:${VIRTUAL_ENV:t}" ; }
export VIRTUAL_ENV_DISABLE_PROMPT=1
fmtd_date="%F{38}%D{%a} %F{117}%D{%b %d} %F{216}%D{%H:%M:%S} %F{229}%D{%Z}"
# return_code="%(?.%F{green}✔.%F{red}%?↲)%f"  # Non-zero return code of previous command
# Must be in single quotes to recompute values
PROMPT='%E${fmtd_date} %F{grey}@%f %F{193}%~%f$(git_branch)$(venv_name)
%F{24}%(!.%F{red}root#%f.$(invitation)) %F{white}'
RPS1='%F{243}$(elapsed_time)%f $(return_code)'

function split_runs() { echo "▴  ▴  ▴  ▴  ▴  ▴  ▴  ▴  ▴" ; }
add-zsh-hook precmd split_runs

# TODO: Look into this for prompt below screen
# terminfo_down_sc=$terminfo[cud1]$terminfo[cuu1]$terminfo[sc]$terminfo[cud1]
# function zle-line-init zle-keymap-select {
#     PS1_2="${${KEYMAP/vicmd/-- NORMAL --}/(main|viins)/-- INSERT --}"
#     PS1="%{$terminfo_down_sc$PS1_2$terminfo[rc]%}%~ %# "
#     zle reset-prompt
# }
# preexec () { print -rn -- $terminfo[el]; }


###########
# Options #
###########

# See for all options
# http://zsh.sourceforge.net/Doc/Release/Options.html#Options
set -o auto_cd
set -o correct  # prompt suggestions for mispelled commands


######################
# Path Modifications #
######################

# Set up global pip
# export PATH="$PATH:/Users/ant/Library/Python/3.7/bin"
export PATH="/Users/ant/.pyenv/shims:$PATH"
if command -v pyenv 1>/dev/null 2>&1; then
    eval "$(pyenv init -)"
fi

# Set up global Ruby path
if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi

# Set up Heroku path
PATH="/usr/local/heroku/bin:$PATH"

# Set up Go environment
export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin
mkdir -p $GOPATH/{src,bin}

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_comp

# NeoVim Setup
[ -e ~/.config/nvim ] || ln -s ~/.vim ~/.config/nvim
[ -e ~/.config/nvim/init.vim ] || ln -s ~/.vimrc ~/.config/nvim/init.vim

# Google Cloud SDK setup
test -e "/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc" && source "/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc"
test -e "/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc" && source "/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc"

# iTerm2 Shell integration
test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"


#############
# Built-ins #
#############

[[ -f ~/.aliasrc ]] && source ~/.aliasrc

set -o HIST_REDUCE_BLANKS  # removes blank lines
set -o HIST_IGNORE_DUPS
set -o EXTENDED_HISTORY  # record timestamp of command:w
set -o INC_APPEND_HISTORY_TIME  # add commands immediately after execution
HISTSIZE=10000
SAVEHIST=10000
function history() {
  builtin fc -l -i "${@:-1}"
}

# -g is a global alias, substituted in the middle of commands
alias -g ...='../..'
alias -g ....='../../..'
alias -g .....='../../../..'
alias -g ......='../../../../..'

export LS_COLORS='di=01;31'


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

# taken from http://stackoverflow.com/a/8574392/4647743
function elementInArray() {
  local e
  for e in "${@:2}"; do [[ "$e" == "$1" ]] && return 0; done
  return 1
}

function git() {
    command git $@

    if (elementInArray $1 $gitPreAutoStatusCommands); then
        # printf "%0.s-" $( seq 1 1 $(tput cols) ); echo ""
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
