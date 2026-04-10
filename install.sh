#!/bin/bash
set -eu

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"

# --- Install bash-it ---
if [ ! -d "$HOME/.bash_it" ]; then
    echo "Installing bash-it..."
    git clone --depth=1 https://github.com/Bash-it/bash-it.git "$HOME/.bash_it"
fi

# --- Enable bash-it components via symlinks ---
mkdir -p "$HOME/.bash_it/enabled"

# Aliases
for a in bash-it directory editor general; do
    ln -sf "$HOME/.bash_it/aliases/available/${a}.aliases.bash" \
           "$HOME/.bash_it/enabled/150---${a}.aliases.bash" 2>/dev/null || true
done

# Plugins
ln -sf "$HOME/.bash_it/plugins/available/base.plugin.bash" \
       "$HOME/.bash_it/enabled/250---base.plugin.bash"

# Completions
for c in bash-it docker git github-cli go kubectl terraform; do
    ln -sf "$HOME/.bash_it/completion/available/${c}.completion.bash" \
           "$HOME/.bash_it/enabled/350---${c}.completion.bash" 2>/dev/null || true
done
ln -sf "$HOME/.bash_it/completion/available/system.completion.bash" \
       "$HOME/.bash_it/enabled/325---system.completion.bash"
ln -sf "$HOME/.bash_it/completion/available/aliases.completion.bash" \
       "$HOME/.bash_it/enabled/800---aliases.completion.bash"

# --- Zsh plugins ---
mkdir -p "$HOME/.zsh"

if [ ! -d "$HOME/.zsh/zsh-syntax-highlighting" ]; then
    echo "Installing zsh-syntax-highlighting..."
    git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting.git \
        "$HOME/.zsh/zsh-syntax-highlighting"
fi

if [ ! -d "$HOME/.zsh/zsh-autosuggestions" ]; then
    echo "Installing zsh-autosuggestions..."
    git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions.git \
        "$HOME/.zsh/zsh-autosuggestions"
fi

# --- Symlink config files ---
mkdir -p ~/.config ~/.bash_it/custom ~/.bash_it/aliases

ln -sfn "$DOTFILES_DIR" "$HOME/.dotfiles"

ln -sf "$DOTFILES_DIR/.config/starship.toml" ~/.config/starship.toml
ln -sf "$DOTFILES_DIR/custom/smana.bash" ~/.bash_it/custom/smana.bash
ln -sf "$DOTFILES_DIR/aliases/smana.bash" ~/.bash_it/aliases/smana.bash
ln -sf "$DOTFILES_DIR/.zshrc" ~/.zshrc

# --- Ensure .bash_profile sources .bashrc (login shells) ---
ln -sf "$DOTFILES_DIR/.bash_profile" ~/.bash_profile

# --- Ensure interactive bash shells hand off to zsh ---
if ! grep -q 'hand off interactive bash shells to zsh' ~/.bashrc 2>/dev/null; then
    cat >> ~/.bashrc <<'BASHRC_ZSH'

# hand off interactive bash shells to zsh
if [[ $- == *i* ]] && command -v zsh >/dev/null 2>&1 && [[ -z "${ZSH_VERSION:-}" ]]; then
  exec zsh -l
fi
BASHRC_ZSH
fi

# --- Ensure .bashrc loads bash-it ---
if ! grep -q 'BASH_IT' ~/.bashrc 2>/dev/null; then
    cat >> ~/.bashrc <<'BASHRC'

# bash-it
export BASH_IT="$HOME/.bash_it"
export BASH_IT_THEME='pure'
export SCM_CHECK=true
unset MAILCHECK
source "$BASH_IT/bash_it.sh"
BASHRC
fi

# --- Git aliases ---
git config --global alias.s 'switch'
git config --global alias.st 'status'
git config --global alias.co 'checkout'
git config --global alias.br 'branch'
git config --global alias.ci 'commit'
git config --global alias.ca 'commit --amend'
git config --global alias.last 'log -1 --stat'
git config --global alias.lg 'log --oneline --decorate --graph'

# --- Claude Code native install (avoids sudo for auto-updates) ---
if command -v claude >/dev/null 2>&1; then
    echo "Installing Claude Code natively..."
    claude install
fi

echo "Dotfiles installed successfully."
