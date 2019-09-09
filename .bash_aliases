#!/bin/bash


# Workspaces
alias dws="cd ~/Dropbox/workspace/"
alias ws="cd ~/workspace/"


# File shortcuts
alias vrc="vim ~/.vimrc"
alias brc="vim ~/.bashrc"
alias bal="vim ~/.bash_aliases"
alias bpr="vim ~/.bash_profile"
alias pro="vim ~/.profile"
alias sp="source ~/.bash_profile"

# Kubernetes
kd() {
    # Opens Kubernetes dashboard and copies bearer token into clipboard.
    printf "Opening Kubernetes dashboard...\n"

    SECRET_NAME=default-token-m65mb
    [[ $(uname -s) == "Darwin*" ]] && copy="pbcopy"
    [[ $(uname -s) == "Linux*" ]] && copy="xclip -selection c"

    # Pull dashboard (fail silently)
    kubectl create -f https://raw.githubusercontent.com/kubernetes/dashboard/v1.10.1/src/deploy/recommended/kubernetes-dashboard.yaml 2>/dev/null &
    # Open in browser
    (sleep 5 && open http://127.0.0.1:8001/api/v1/namespaces/kube-system/services/https:kubernetes-dashboard:/proxy/#!/login &)
    sleep 3
    # Copy token to clipboard
    kubectl describe secret/${SECRET_NAME} \
        |grep token: \
        |sed 's/token:      //' \
        |${copy} \
        && kubectl proxy \
        || printf "Failed to get token.\n"
}
ke() { kubectl exec -it "$@" -- /bin/bash ; }
alias kapf="kubectl apply -f"
alias kdl="kubectl delete"
alias kds="kubectl describe"
alias kdsp="kubectl describe deployment"
alias kdsj="kubectl describe job"
alias kdsp="kubectl describe pod"
alias kdss="kubectl describe service"
alias kdssc="kubectl describe secret"
alias kg="kubectl get"
alias kcj="kubectl get cronjobs"
alias kgd="kubectl get deployments"
alias kgj="kubectl get jobs"
alias kgp="kubectl get pods"
alias kgs="kubectl get services"
alias kgsc="kubectl get secrets"
alias kp="kubectl proxy"
alias kpf="kubectl port-forward"

# Git
alias g="git"
alias gb="git branch"
alias gc="git checkout"
alias gcm="git commit"
alias gcmm="git commit -m"
alias gcb="git checkout -b"
alias gd="git diff"
alias gf="git fetch"
alias ga="git add"
alias gaa="git add -A"
alias gs="git status"
alias gst="git stash"
alias gsts="git stash save"
alias gstp="git stash pop"
alias gl="git lg"

# Go
go-get-help() {
    mkdir -p ${HOME}/workspace/ws_go
    pushd ${HOME}/workspace/ws_go
    git clone https://github.com/mmcgrana/gobyexample.git
    go get github.com/russross/blackfriday
    ./gobyexample/tools/build
    open ./gobyexample/public/index.html
}
alias go-help="open ${HOME}/workspace/ws_go/gobyexample/public/index.html || go-get-help"

# Rust
alias rust-help="(sleep 3 && open http://localhost:3000 &) && mdbook serve"

# YoutubeDL
alias yt="youtube-dl --add-metadata -ic"  # download video link
alias yta="youtube-dl --add-metadata -xic"  # download only audio
alias YT="youtube-viewer"

# Built-In
alias ...="cd ../.."
alias ....="cd ../../.."

cdl() { cd "$@" && ls; }
cdls() { cd "$@" && ls; }
cdla() { cd "$@" && ls -a; }
cdlal() { cd "$@" && ls -lahF; }
cdlla() { cd "$@" && ls -lahF; }

alias senv="env |sort"

# Overwrite default variables
command -v highlight >/dev/null && CAT_TYPE=highlight
command -v gls >/dev/null && LS=gls && LSOPTS="--color=auto --group-directories-first"

alias cat="${CAT_TYPE:-cat} --out-format=ansi"  # print file with syntax highlighting.
alias grep="grep --color=auto"  # highlight desired sequence.
alias ka="killall"  # end all processes

alias ls="${LS:-ls} -h $LSOPTS"
alias sl="${LS:-ls} -h $LSOPTS"
alias la="${LS:-ls} -ah $LSOPTS"
alias lsa="${LS:-ls} -ahF $LSOPTS"
alias lsl="${LS:-ls} -lhF $LSOPTS"
alias lsal="${LS:-ls} -lahF $LSOPTS"
alias lsla="${LS:-ls} -lahF $LSOPTS"

alias mkdir="mkdir -pv"  # makes parent directories if necessary, verbosely

alias v="vim"  # vim

# Just MBRDNA things
alias task="(taskell -v 2>/dev/null 1>/dev/null && taskell) || (printf "taskell is not installed.\n" && return 1)"
alias btpd="python3 ~/workspace/build_tag_push_docker.py"

pke() { kubectl exec -it "$@" --context=kubernetes-admin@kubernetes -- /bin/bash ; } 
alias pk="kubectl --context=kubernetes-admin@kubernetes"
alias pka="kubectl apply --context=kubernetes-admin@kubernetes"
alias pkapf="kubectl apply -f --context=kubernetes-admin@kubernetes"
alias pkat="kubetl attach --context=kubernetes-admin@kubernetes"
alias pkci="kubectl cluster-info --context=kubernetes-admin@kubernetes"
alias pkdl="kubectl delete --context=kubernetes-admin@kubernetes"
alias pkdld="kubectl delete deployment --context=kubernetes-admin@kubernetes"
alias pkdlj="kubectl delete job --context=kubernetes-admin@kubernetes"
alias pkdlp="kubectl delete pod --context=kubernetes-admin@kubernetes"
alias pkdls="kubectl delete service --context=kubernetes-admin@kubernetes"
alias pkdlsc="kubectl delete secret --context=kubernetes-admin@kubernetes"
alias pkds="kubectl describe --context=kubernetes-admin@kubernetes"
alias pkdsp="kubectl describe deployment --context=kubernetes-admin@kubernetes"
alias pkdsj="kubectl describe job --context=kubernetes-admin@kubernetes"
alias pkdsn="kubectl describe node --context=kubernetes-admin@kubernetes"
alias pkdsp="kubectl describe pod --context=kubernetes-admin@kubernetes"
alias pkdss="kubectl describe service --context=kubernetes-admin@kubernetes"
alias pkdssc="kubectl describe secret --context=kubernetes-admin@kubernetes"
alias pkg="kubectl get --context=kubernetes-admin@kubernetes"
alias pkcj="kubectl get cronjobs --context=kubernetes-admin@kubernetes"
alias pkgd="kubectl get deployments --context=kubernetes-admin@kubernetes"
alias pkgj="kubectl get jobs --context=kubernetes-admin@kubernetes"
alias pkgn="kubectl get nodes --context=kubernetes-admin@kubernetes"
alias pkgp="kubectl get pods --context=kubernetes-admin@kubernetes"
alias pkgs="kubectl get services --context=kubernetes-admin@kubernetes"
alias pkgsc="kubectl get secrets --context=kubernetes-admin@kubernetes"
alias pkl="kubectl logs --context=kubernetes-admin@kubernetes"
alias pklf="kubectl logs -f --context=kubernetes-admin@kubernetes"
alias pkp="kubectl proxy --context=kubernetes-admin@kubernetes"
alias pkpf="kubectl port-forward --context=kubernetes-admin@kubernetes"
