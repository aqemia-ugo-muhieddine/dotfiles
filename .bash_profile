if [[ $- == *i* ]] && command -v zsh >/dev/null 2>&1; then
  exec zsh -l
fi

if [ -f "$HOME/.bashrc" ]; then
  . "$HOME/.bashrc"
fi
