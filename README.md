# Intro

This is intended for my personal use. If you want to use it, follow the following steps.
This works in **Pop! OS 22.04**. I don't guarantee other operating systems. It generally would work fine in **bash** and **zsh** shell

1. The templates for the dotfiles are in the folders `dotfiles` and `modules`. Edit them as fit.
2. Run `install.sh` and follow the instructions

# Install

Debian dependencies

    sudo apt install zsh-syntax-highlighting autojump zsh-autosuggestions

Copy and paste for the lazy me:

    git clone https://github.com/btquanto/dotfiles.git
    ./dotfiles/install.sh

# Local configuration

Local configuration should be put in `~/.shellrc-local`. Do not put local configuration in `.shell` folder. It will be deleted after install script runs.

```
apt() {
  command nala "$@"
}

sudo() {
  if [ "$1" = "apt" ]; then
    shift
    command sudo nala "$@"
  else
    command sudo "$@"
  fi
}

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

# Restart your shell for the changes to take effect.

# Load pyenv-virtualenv automatically by adding
# the following to ~/.bashrc:

eval "$(pyenv virtualenv-init -)"
```
