export ZSH="${HOME}/.oh-my-zsh"
ZSH_THEME=""
plugins=(git)

if [[ -d "${ZSH}" ]]; then
  source "${ZSH}/oh-my-zsh.sh"
fi

source "${HOME}/.dotfiles/custom/smana.zsh"
