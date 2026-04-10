# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

Personal dotfiles repo targeting **Coder workspaces** on macOS/Linux. Installs shell configs for both Bash (via `bash-it`) and Zsh (via oh-my-zsh), with interactive Bash sessions automatically handing off to Zsh.

## Install

```bash
./install.sh
```

This symlinks configs into `$HOME`, installs `bash-it`, sets global git aliases, and appends shell hand-off and bash-it loader blocks to `~/.bashrc`. Idempotent — safe to re-run.

## Architecture

The repo has parallel Bash and Zsh tracks that must stay in sync:

- **Shell entry**: `.bash_profile` hands off to Zsh if interactive. `.zshrc` loads oh-my-zsh then sources `custom/smana.zsh`.
- **Custom shell config**: `custom/smana.bash` and `custom/smana.zsh` — environment variables, PATH setup, tool init (starship, zoxide, fzf), completions, and helper functions (`cd_plasma`, `init-workspace`). These two files duplicate logic for their respective shells; changes to one usually need mirroring in the other.
- **Aliases**: `aliases/smana.bash` and `aliases/smana.zsh` — currently identical files with git, kubectl, and python/uv aliases. Keep them in sync.
- **Prompt**: `.config/starship.toml` — shared Starship config used by both shells. Includes a custom Coder workspace name module.
- **Install script**: `install.sh` — symlinks everything, enables bash-it components, and sets global git aliases.

## Key conventions

- When adding aliases or env vars, update both the `.bash` and `.zsh` versions.
- Helper functions (`cd_plasma`, `init-workspace`) are duplicated in both `custom/smana.bash` and `custom/smana.zsh`.
- The install script uses `ln -sf` symlinks, not copies. Config files in `$HOME` point back to this repo.
- Git aliases are set globally via `git config --global` in `install.sh`, not in shell alias files (those use the `g*` prefix pattern instead).
