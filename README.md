# Intro

This is intended for my personal use. If you want to use it, follow the following steps.
This works in **Pop! OS 22.04**. I don't guarantee other operating systems. It generally would work fine in **bash** and **zsh** shell

1. The templates for the dotfiles are in the folders `dotfiles` and `modules`. Edit them as fit.
2. Run `install.py` and follow the instructions

# Install

Debian dependencies

    sudo apt install zsh-syntax-highlighting autojump zsh-autosuggestions

Copy and paste for the lazy me:

    git clone https://github.com/btquanto/dotfiles.git
    ./dotfiles/install.py

# Some optional tools you may want to install

## `lf` Terminal File Manager

```
wget https://github.com/gokcehan/lf/releases/download/r27/lf-linux-amd64.tar.gz
tar -xvf lf-linux-amd64.tar.gz
chmod +x lf
sudo mv lf /usr/bin/lf
rm lf-linux-amd64.tar.gz
```

## `nala` an alternative to `apt` package manager

Follow [nala's installation instructions on its wiki](https://gitlab.com/volian/nala/-/wikis/Installation)

## `homebrew` [a better package manager](https://brew.sh/)

```
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

## `nvm` [Node Version Manager](https://github.com/nvm-sh/nvm)

```
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
```

## `pyenv` Python version manager

```
curl https://pyenv.run | bash
```

# Local configuration

Local configuration should be put in `~/.shellrc-local`. Do not put local configuration in `.shell` folder. It will be deleted after install script runs.

```bash
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

