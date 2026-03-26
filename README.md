# dotfiles

Personal dotfiles for Coder workspaces.

## What gets installed

- `bash-it` for Bash shells
- repo-managed `.zshrc` for Zsh shells
- shared aliases for Bash and Zsh
- global Git aliases like `git s`, `git co`, `git lg`

## Apply the dotfiles

```bash
./install.sh
exec zsh
```

## Verify in a Coder workspace

```bash
readlink ~/.zshrc
git config --global --get alias.s
bindkey | grep history-beginning-search
```

If those point to this repo and `git s` works, the workspace picked up the changes.

## Bootstrap a repo workspace

Create the default workspace:

```bash
init-workspace
```

That command will:

- create `$HOME/work`
- clone `https://github.com/Aqemia/platform-research.git` into `$HOME/work/platform-research`
- write `work.code-workspace` at `$HOME/work/work.code-workspace`
- skip cloning and file creation if both already exist
