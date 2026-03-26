#!/usr/bin/env bash

# Starship prompt
command -v starship &>/dev/null && eval "$(starship init bash)"

# Zoxide (cd replacement)
command -v zoxide &>/dev/null && eval "$(zoxide init --cmd cd bash)"

# History settings
export HISTSIZE=2000000
export HISTFILESIZE=3000000
export TIMEFORMAT=$'\nreal %3R\tuser %3U\tsys %3S\tpcpu %P\n'
export HISTTIMEFORMAT="%d/%m/%Y - %H:%M:%S > "
export HISTIGNORE="&:bg:fg:ll:"

export EDITOR=vim
export KUBE_EDITOR=vim

# AWS CLI completer
_aws_completer=$(command -v aws_completer 2>/dev/null)
[[ -n "$_aws_completer" ]] && complete -C "$_aws_completer" aws

# gh completion (fallback if bash-it github-cli completion isn't loaded)
if command -v gh &>/dev/null && ! complete -p gh &>/dev/null 2>&1; then
    eval "$(gh completion -s bash)"
fi

# Go
GOPATH=${HOME}/go
PATH=${PATH}:${GOPATH}/bin

# Cargo (Rust)
export PATH=$PATH:$HOME/.cargo/bin

# Krew
export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"

# Custom aliases
source ~/.bash_it/aliases/smana.bash

# FZF
[ -f ~/.fzf.bash ] && source ~/.fzf.bash

# Terragrunt cache
export TF_PLUGIN_CACHE_DIR=$HOME/.terraform.d/plugin-cache
export TG_PROVIDER_CACHE=true
export INIT_WORKSPACE_DIR="${INIT_WORKSPACE_DIR:-$HOME/work}"
export INIT_WORKSPACE_REPO="${INIT_WORKSPACE_REPO:-https://github.com/Aqemia/platform-research.git}"
export INIT_WORKSPACE_BRANCH="${INIT_WORKSPACE_BRANCH:-}"

init-workspace() {
    local workspace_dir repo_url target_dir workspace_file branch

    workspace_dir="${1:-$INIT_WORKSPACE_DIR}"
    repo_url="${2:-$INIT_WORKSPACE_REPO}"
    branch="${3:-$INIT_WORKSPACE_BRANCH}"

    mkdir -p "$workspace_dir" || return 1
    target_dir="${workspace_dir}"

    if [[ ! -d "$target_dir/.git" ]]; then
        if [[ -n "$branch" ]]; then
            git clone --branch "$branch" "$repo_url" "$target_dir" || return 1
        else
            git clone "$repo_url" "$target_dir" || return 1
        fi
    fi

    cd "$target_dir" || return 1
    workspace_file="${target_dir}/work.code-workspace"

    cat > "$workspace_file" <<EOF
{
  "folders": [
    {
      "path": "."
    }
  ],
  "settings": {
    "files.trimTrailingWhitespace": true,
    "files.insertFinalNewline": true,
    "editor.formatOnSave": true
  }
}
EOF

    echo "Workspace ready in ${target_dir}"
    echo "VS Code workspace file: ${workspace_file}"
}
