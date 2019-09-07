
# Overwrite default variables
command -v highlight >/dev/null && CAT_TYPE=highlight
command -v gls >/dev/null && LS=gls && LSOPTS="--color=auto --group-directories-first"

# File shortcuts
alias vimrc="vim ~/.vimrc"
alias bashrc="vim ~/.bashrc"
alias bash_aliases="vim ~/.bash_aliases"
alias bash_profile="vim ~/.bash_profile"
alias profile="vim ~/.profile"
alias asource="source ~/.bash_profile; source ~/.vimrc"

# Kubernetes
alias kapf="kubectl apply -f"
kd() {
    # Opens Kubernetes dashboard and copies bearer token into clipboard.
    printf "Opening Kubernetes dashboard..."

    SECRET_NAME=default-token-m65mb
    [[ $(uname -s) == "Darwin*" ]] && copy=pbcopy
    [[ $(uname -s) == "Linux*" ]] && copy=xclip

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
        || echo "Failed to get token."
}
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
ke() { kubectl exec -it "$@" -- /bin/bash ; }

# Git
alias g="git"
alias gf="git fetch"
alias gaa="git add -A"
alias gs="git status"

# Rust
alias rust-help="(sleep 3 && open http://localhost:3000 &) && mdbook serve"

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

alias cat="${CAT_TYPE:-cat} --out-format=ansi"  # print file with syntax highlighting.
alias grep="grep --color=auto"  # highlight desired sequence.
alias ka="killall"  # end all processes

alias ls="${LS:-ls} -h $LSOPTS"
alias lsa="${LS:-ls} -ahF $LSOPTS"
alias lsl="${LS:-ls} -lhF $LSOPTS"
alias lsal="${LS:-ls} -lahF $LSOPTS"
alias lsla="${LS:-ls} -lahF $LSOPTS"

alias mkd="mkdir -pv"  # makes parent directories if necessary, verbosely

alias v="vim"  # vim
