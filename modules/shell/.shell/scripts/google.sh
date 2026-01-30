# =============================================================================
# GCP (Google Cloud Platform) Aliases
# =============================================================================

# gcloud shortcuts
alias gc='gcloud'
alias gci='gcloud compute instances'
alias gcil='gcloud compute instances list'
alias gcs='gcloud compute ssh'
alias gcsl='gcloud compute services list'

# GCP project management
alias gcp='gcloud config get-value project'
alias gcps='gcloud config set project'
alias gcpl='gcloud projects list'

# GCP authentication
alias gcauth='gcloud auth login --update-adc'
alias gcalist='gcloud auth list'
alias gcadc='gcloud auth application-default login'

# GKE (Google Kubernetes Engine) shortcuts
alias gke='gcloud container clusters'
alias gkel='gcloud container clusters list'
alias gkeg='gcloud container clusters get-credentials'

# GCP service accounts
alias gcsa='gcloud iam service-accounts'
alias gcsal='gcloud iam service-accounts list'

# GCP configuration
alias gcconf='gcloud config list'
alias gcconfl='gcloud config configurations list'
alias gcconfa='gcloud config configurations activate'

# =============================================================================
# Kubernetes (K8s) Aliases
# =============================================================================

# kubectl shortcuts
alias k='kubectl'
alias kc='kubectl'

# Get resources
alias kg='kubectl get'
alias kgp='kubectl get pods'
alias kgpa='kubectl get pods --all-namespaces'
alias kgs='kubectl get svc'
alias kgsa='kubectl get svc --all-namespaces'
alias kgd='kubectl get deployments'
alias kgda='kubectl get deployments --all-namespaces'
alias kgn='kubectl get nodes'
alias kgns='kubectl get namespaces'
alias kgi='kubectl get ingress'

# Describe resources
alias kd='kubectl describe'
alias kdp='kubectl describe pod'
alias kds='kubectl describe service'
alias kdd='kubectl describe deployment'

# Logs
alias kl='kubectl logs'
alias klf='kubectl logs -f'
alias klp='kubectl logs -p'  # previous container logs

# Execute commands in pods
alias ke='kubectl exec -it'
alias keti='kubectl exec -ti'

# Apply and delete
alias ka='kubectl apply -f'
alias kdel='kubectl delete'
alias kdelf='kubectl delete -f'

# Context and namespace management
alias kx='kubectl config current-context'
alias kxl='kubectl config get-contexts'
alias kxs='kubectl config use-context'
alias kns='kubectl config set-context --current --namespace'

# Port forwarding
alias kpf='kubectl port-forward'

# Top (resource usage)
alias ktop='kubectl top'
alias ktopn='kubectl top nodes'
alias ktopp='kubectl top pods'

# Edit resources
alias ked='kubectl edit'

# Scale deployments
alias kscale='kubectl scale deployment'

# Rollout management
alias kroll='kubectl rollout'
alias krolls='kubectl rollout status'
alias krollh='kubectl rollout history'
alias krollr='kubectl rollout restart'

# Watch resources
alias kw='watch kubectl get'
alias kwp='watch kubectl get pods'

# =============================================================================
# GitHub (gh CLI) Aliases
# =============================================================================

# Repository shortcuts
alias ghr='gh repo'
alias ghrc='gh repo create'
alias ghrl='gh repo list'
alias ghrv='gh repo view'
alias ghrc='gh repo clone'

# Pull request shortcuts
alias ghpr='gh pr'
alias ghprl='gh pr list'
alias ghprc='gh pr create'
alias ghprv='gh pr view'
alias ghprco='gh pr checkout'
alias ghprm='gh pr merge'
alias ghprs='gh pr status'

# Issue shortcuts
alias ghi='gh issue'
alias ghil='gh issue list'
alias ghic='gh issue create'
alias ghiv='gh issue view'
alias ghis='gh issue status'

# GitHub Actions/Workflow shortcuts
alias ghw='gh workflow'
alias ghwl='gh workflow list'
alias ghwr='gh workflow run'
alias ghwv='gh workflow view'

# Run shortcuts
alias ghr='gh run'
alias ghrl='gh run list'
alias ghrv='gh run view'
alias ghrw='gh run watch'

# Other useful GitHub shortcuts
alias ghs='gh status'
alias ghb='gh browse'  # open repo in browser
alias ghauth='gh auth login'
alias ghauthl='gh auth status'

# =============================================================================
# Git Aliases (bonus since you work with GitHub)
# =============================================================================

# Basic git shortcuts
alias g='git'
alias gs='git status'
alias ga='git add'
alias gaa='git add .'
alias gc='git commit'
alias gcm='git commit -m'
alias gp='git push'
alias gpl='git pull'
alias gf='git fetch'
alias gco='git checkout'
alias gcb='git checkout -b'
alias gb='git branch'
alias gba='git branch -a'
alias gd='git diff'
alias gl='git log'
alias glo='git log --oneline'
alias glog='git log --graph --oneline --decorate'
alias gst='git stash'
alias gstp='git stash pop'
alias gm='git merge'
alias gr='git rebase'
alias grs='git reset'
alias grh='git reset --hard'

# =============================================================================
# Combined/Workflow Aliases
# =============================================================================

# Quick context switching for GKE clusters
alias use-cluster='gcloud container clusters get-credentials'

# Get current GCP project and K8s context
alias ctx='echo "GCP Project: $(gcloud config get-value project 2>/dev/null)" && echo "K8s Context: $(kubectl config current-context 2>/dev/null)" && echo "K8s Namespace: $(kubectl config view --minify --output 'jsonpath={..namespace}' 2>/dev/null)"'

# Common debugging workflow
alias kdebug='kubectl run -it --rm debug --image=busybox --restart=Never -- sh'
