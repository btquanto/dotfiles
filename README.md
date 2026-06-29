# Intro

This is intended for my personal use. If you want to use it, follow the following steps.
This should generally works well in **bash** and **zsh**. I've been switching between different OS'es, including Debian based distros, Fedora, and MacOS and been fixing anything that doesn't work.

1. The templates for the dotfiles are in the folders `dotfiles` and `modules`. Edit them as fit.
2. Run `install.py` and follow the instructions

# Install

Debian dependencies (if you use zsh)

    sudo apt install zsh-syntax-highlighting autojump zsh-autosuggestions

Copy and paste for the lazy me:

    git clone https://github.com/btquanto/dotfiles.git
    ./dotfiles/install.py

# Some optional tools you may want to install

## `lf` Terminal File Manager

```
# Fetch the latest release version tag from GitHub API
VERSION=$(curl -s https://api.github.com/repos/gokcehan/lf/releases/latest | jq -r '.tag_name')

# Check if VERSION was successfully retrieved
if [ -z "$VERSION" ] || [ "$VERSION" == "null" ]; then
    echo "Error: Failed to fetch the latest version from GitHub."
    exit 1
fi

echo "Latest version found: $VERSION"

# Download, extract, and install
wget "https://github.com/gokcehan/lf/releases/download/$VERSION/lf-linux-amd64.tar.gz"
tar -xvf lf-linux-amd64.tar.gz
chmod +x lf
sudo mv lf /usr/bin/lf
rm lf-linux-amd64.tar.gz

echo "lf has been successfully installed/updated to $VERSION!"
```

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

Local configuration should be put in `~/.local/shrc.sh`. Do not put local configuration in `.shell` folder. It will be deleted after install script runs.

```bash

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

