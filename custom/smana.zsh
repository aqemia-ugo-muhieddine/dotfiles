#!/usr/bin/env zsh

set +x +v

HISTSIZE=2000000
SAVEHIST=3000000
HISTFILE="${HOME}/.zsh_history"
setopt APPEND_HISTORY
setopt SHARE_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_FIND_NO_DUPS

bindkey "^[[A" history-beginning-search-backward
bindkey "^[[B" history-beginning-search-forward

export TIMEFMT=$'\nreal %E\tuser %U\tsys %S\tpcpu %P'
export EDITOR=vim
export KUBE_EDITOR=vim
export GOPATH="${HOME}/go"
export PATH="${PATH}:${GOPATH}/bin"
export PATH="${PATH}:${HOME}/.cargo/bin"
export PATH="${KREW_ROOT:-$HOME/.krew}/bin:${PATH}"
export TF_PLUGIN_CACHE_DIR="${HOME}/.terraform.d/plugin-cache"
export TG_PROVIDER_CACHE=true
export INIT_WORKSPACE_DIR="${INIT_WORKSPACE_DIR:-$HOME/work}"
export INIT_WORKSPACE_REPO="${INIT_WORKSPACE_REPO:-https://github.com/Aqemia/platform-research.git}"
export INIT_WORKSPACE_BRANCH="${INIT_WORKSPACE_BRANCH:-}"

command -v starship >/dev/null 2>&1 && eval "$(starship init zsh)"
command -v zoxide >/dev/null 2>&1 && eval "$(zoxide init --cmd cd zsh)"

autoload -Uz compinit
compinit -i

if command -v aws_completer >/dev/null 2>&1; then
  autoload -Uz bashcompinit
  bashcompinit
  complete -C "$(command -v aws_completer)" aws
fi

if command -v gh >/dev/null 2>&1; then
  eval "$(gh completion -s zsh)"
fi

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

[[ -f "${HOME}/.fzf.zsh" ]] && source "${HOME}/.fzf.zsh"
source "${HOME}/.dotfiles/aliases/smana.zsh"
