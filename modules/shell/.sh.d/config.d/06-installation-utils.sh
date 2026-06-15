#!/bin/bash

# Helper to check if a command exists
check_cmd() {
    command -v "$1" >/dev/null 2>&1
}

install_lf() {
    if ! check_cmd curl || ! check_cmd jq; then
        echo "Error: curl and jq are required to install lf."
        return 1
    fi

    VERSION=$(curl -fsSL https://api.github.com/repos/gokcehan/lf/releases/latest | jq -r '.tag_name' 2>/dev/null)

    if [ -z "$VERSION" ] || [ "$VERSION" == "null" ]; then
        echo "Error: Failed to fetch the latest version from GitHub."
        return 1
    fi

    echo "Latest lf version found: $VERSION"
    wget "https://github.com/gokcehan/lf/releases/download/$VERSION/lf-linux-amd64.tar.gz" 2>&1>/dev/null
    tar -xvf lf-linux-amd64.tar.gz
    chmod +x lf
    sudo mv lf /usr/bin/lf
    rm lf-linux-amd64.tar.gz
    echo "lf has been successfully installed/updated to $VERSION!"
}

install_brew() {
    if check_cmd brew; then
        echo "Homebrew is already installed."
        return 0
    fi

    echo "Installing Homebrew..."
    # Running the official Homebrew installation script non-interactively
    NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    # Set up environment for the current shell session
    if [ -d "/home/linuxbrew/.linuxbrew" ]; then
        eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    elif [ -d "/opt/homebrew" ]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi

    echo "Homebrew installation complete. Note: You may need to restart your terminal or source your rc file."
}

install_pyenv() {
    if check_cmd pyenv; then
        echo "pyenv is already installed."
        return 0
    fi

    echo "Installing pyenv..."
    # Official pyenv-installer script
    curl https://pyenv.run | bash

    echo "pyenv installed. Remember to add pyenv to your shell configuration (.bashrc/.zshrc)."
}

install_uv() {
    if check_cmd uv; then
        echo "uv is already installed."
        return 0
    fi

    echo "Installing uv (Astral Python installer/packaging tool)..."
    # Official uv standalone installer
    curl -LsSf https://astral.sh/uv/install.sh | sh
    
    echo "uv installed successfully!"
}

install_nvm() {
    if [ -d "$HOME/.nvm" ] || check_cmd nvm; then
        echo "nvm is already installed or ~/.nvm directory exists."
        return 0
    fi

    if ! check_cmd curl; then
        echo "Error: curl is required to install nvm."
        return 1
    fi

    echo "Installing nvm (Node Version Manager)..."
    # Fetches the latest installer script via the GitHub API to ensure we don't hardcode an old version
    NVM_VERSION=$(curl -fsSL https://api.github.com/repos/nvm-sh/nvm/releases/latest | jq -r '.tag_name' 2>/dev/null)
    
    # Fallback to a baseline version if API fails
    if [ -z "$NVM_VERSION" ] || [ "$NVM_VERSION" == "null" ]; then
        NVM_VERSION="v0.40.1"
    fi

    curl -o- "https://raw.githubusercontent.com/nvm-sh/nvm/$NVM_VERSION/install.sh" | bash

    echo "nvm $NVM_VERSION installed. Please restart your terminal or source your shell config to use it."
}