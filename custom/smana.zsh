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
  local workspace_dir repo_url repo_name target_dir workspace_file

  workspace_dir="$HOME/work"
  repo_url="https://github.com/Aqemia/platform-research.git"
  repo_name="platform-research"
  target_dir="${workspace_dir}/${repo_name}"
  workspace_file="${workspace_dir}/work.code-workspace"

  mkdir -p "$workspace_dir" || return 1

  if [[ -d "$target_dir/.git" && -f "$workspace_file" ]]; then
    cd "$target_dir" || return 1
    echo "Workspace already ready in ${target_dir}"
    echo "VS Code workspace file already exists: ${workspace_file}"
    return 0
  fi

  if [[ ! -d "$target_dir/.git" ]]; then
    git clone "$repo_url" "$target_dir" || return 1
  fi

  cd "$target_dir" || return 1

  if [[ ! -f "$workspace_file" ]]; then
    cat > "$workspace_file" <<EOF
{
  "folders": [
    {
      "path": "./platform-research"
    }
  ],
  "settings": {
    "files.trimTrailingWhitespace": true,
    "files.insertFinalNewline": true,
    "editor.formatOnSave": true
  }
}
EOF
  fi

  echo "Workspace ready in ${target_dir}"
  echo "VS Code workspace file: ${workspace_file}"
}

[[ -f "${HOME}/.fzf.zsh" ]] && source "${HOME}/.fzf.zsh"
source "${HOME}/.dotfiles/aliases/smana.zsh"
