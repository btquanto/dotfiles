# Dotfiles

Personal dotfiles that work across **bash**, **zsh**, **Debian-based distros**, **Fedora**, and **macOS**.

## Structure

```
dotfiles/     → $HOME/        (core shell configs — symlinked)
modules/      → $HOME/        (app-specific configs — symlinked)
configs/      → $HOME/.config/ (XDG-compliant configs — symlinked)
```

Backups go to `~/.local/backups/dotfiles/<timestamp>/`.

## Install

```bash
git clone https://github.com/btquanto/dotfiles.git
./dotfiles/install.py
```

The installer backs up existing dotfiles to `~/.local/backups/dotfiles/`, then symlinks the new ones into place. It also prompts for Git identity and signing key, and downloads `git-completion.bash`.

## Restore

```bash
./dotfiles/install.py --restore
```

Copies files from the latest backup back to `$HOME` (plain copies, not symlinks).

Debian dependencies (for zsh features):

```bash
sudo apt install zsh-syntax-highlighting autojump zsh-autosuggestions
```

## What's included

| Category | Tools / Configs |
|---|---|
| **Shells** | bash, zsh with modular framework (`~/.sh.d/`) |
| **Editor** | Vim with Pathogen, NERD Tree, wombat256mod |
| **Terminal** | tmux, screen, lf file manager |
| **Git** | Aliases, LFS, rerere, signed commits, vimdiff |
| **Databases** | psql, mysql client config |
| **Display** | Custom dircolors, colored `ls` |
| **Cloud/DevOps** | GCP, Kubernetes (kubectl), Docker aliases |
| **GitHub** | gh CLI, API query utilities |
| **Shell utils** | Archive extractor, PATH manager, tool installers |

The shell framework auto-sources files from `~/.sh.d/config.d/` in sorted order, then loads shell-specific config via `bash_config.sh` or `zsh_config.sh`. It manages SSH agent, auto-attaches tmux on SSH, and prompts for Git config if missing.

## Local configuration

Put local overrides in `~/.local/shrc.sh` — it won't be overwritten by the installer.

```bash
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
```

## Optional tools

These installer functions are available after setup:

- `install_lf` — terminal file manager
- `install_brew` — Homebrew package manager
- `install_nvm` — Node Version Manager
- `install_pyenv` — Python version manager
- `install_uv` — Fast Python package manager
