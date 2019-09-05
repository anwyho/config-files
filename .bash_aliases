
# Overwrite default variables
command -v highlight >/dev/null && CAT_TYPE=highlight
command -v gls >/dev/null && LS=gls && LSOPTS="--color=auto --group-directories-first"

# File shortcuts
alias vimrc="vim ~/.vimrc"
alias bashrc="vim ~/.bashrc"
alias bash_aliases="vim ~/.bash_aliases"
alias bash_profile="vim ~/.profile"
alias profile="vim ~/.profile"

# Kubernetes
alias kdel="kubectl delete"
alias kdes="kubectl describe"
alias kg="kubectl get"
alias kgd="kubectl get deployments"
alias kgj="kubectl get jobs"
alias kgp="kubectl get pods"
alias kgs="kubectl get services"
alias kpf="kubectl port-forward"

# Git
alias g="git"
alias gf="git fetch"
alias gaa="git add -A"
alias gs="git status"

# Rust
alias rust-help="(sleep 4 && open http://localhost:3000 &) && mdbook serve"

# YoutubeDL
alias yt="youtube-dl --add-metadata -ic"  # download video link
alias yta="youtube-dl --add-metadata -xic"  # download only audio
alias YT="youtube-viewer"

# Built-In
alias ...='cd ../..'
alias ....='cd ../../..'

cdl() { cd "$@" && ls; }
cdls() { cd "$@" && ls; }
cdla() { cd "$@" && ls -a; }
cdlal() { cd "$@" && ls -lahF; }
cdlla() { cd "$@" && ls -lahF; }

alias ccat="${CAT_TYPE:-cat} --out-format=ansi"  # print file with syntax highlighting.
alias grep="grep --color=auto"  # highlight desired sequence.
alias ka="killall"  # end all processes

alias ls="${LS:-ls} -h $LSOPTS"
alias lsa="${LS:-ls} -ahF $LSOPTS"
alias lsl="${LS:-ls} -lhF $LSOPTS"
alias lsal="${LS:-ls} -lahF $LSOPTS"
alias lsla="${LS:-ls} -lahF $LSOPTS"

alias mkd="mkdir -pv"  # makes parent directories if necessary, verbosely

alias v="vim"  # vim
