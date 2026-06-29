# Determine current shell type
[[ "$_SHELL" != "zsh" ]] && _SHELL="bash"

# Make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# Set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# Set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

# Extra configuration files
# 1. Dynamically get the directory where THIS script lives
# and the script's own path (handles both Bash and Zsh)
if [ -n "$BASH_VERSION" ]; then
    __SELF="${BASH_SOURCE[0]}"
    CONFIG_DIR="$(cd "$(dirname "$__SELF")" && pwd)"
elif [ -n "$ZSH_VERSION" ]; then
    __SELF="${(%):-%x}"
    CONFIG_DIR="$(cd "$(dirname "$__SELF")" && pwd)"
else
    __SELF=""
    CONFIG_DIR="$HOME/.sh.d"
fi

CONFIG_DIR="$CONFIG_DIR/config.d"

# 2. Automatically loop through and source all .sh files in this directory
for config_file in "$CONFIG_DIR"/*.sh; do
    # Ensure the file exists and is readable (handles empty directory case)
    if [ -r "$config_file" ] && [ "$config_file" != "$__SELF" ]; then
        
        # Specific rule: Skip git-prompt.sh if the shell is not bash
        if [[ "$config_file" == *"git-prompt.sh" ]] && [[ "$_SHELL" != "bash" ]]; then
            continue
        fi

        source "$config_file"
    fi
done

# Clean up the variable so it doesn't clutter your environment
unset CONFIG_DIR

# Add extra paths
path_add "/sbin:/usr/sbin:/usr/local/sbin:$HOME/bin:$HOME/.local/bin";

# If not running interactively, don't do anything else
[ -z "$PS1" ] && return

# # Enforcing LANG=en_US.UTF-8
# if [ -z `locale | grep -i "LANG=en_US\.UTF-8"` ]; then
#     if groups | grep "\<sudo\>" &> /dev/null; then
#         echo "sudo locale-gen en_US.UTF-8";
#         sudo locale-gen en_US.UTF-8;
#         echo "sudo update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8";
#         sudo update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8
#     fi
# fi

# export LANG=en_US.UTF-8;

# Common variables

export HISTSIZE=1000;
export SAVEHIST=$HISTSIZE;
export HISTFILESIZE=10000;
export HISTFILE="$HOME/.cache/history";

mkdir -p "$HOME/.cache";

# Specific shell configurations
[ -f ~/.sh.d/bash_config.sh ] && source ~/.sh.d/bash_config.sh;
[ -f ~/.sh.d/zsh_config.sh ] && source ~/.sh.d/zsh_config.sh;

# Unset variables
unset color_prompt force_color_prompt __SELF

if [ -f "/usr/bin/ssh-add" ]; then
  # SSH agent
  SSH_ENV="$HOME/.cache/.ssh_environment"

  function start_agent {
      echo "Initialising new SSH agent..."
      /usr/bin/ssh-agent | sed 's/^echo/#echo/' > "${SSH_ENV}"
      chmod 600 "${SSH_ENV}"
      . "${SSH_ENV}" > /dev/null
      /usr/bin/ssh-add;
  }

  # Source SSH settings, if applicable

  if [ -f "${SSH_ENV}" ]; then
      . "${SSH_ENV}" > /dev/null
      #ps ${SSH_AGENT_PID} doesn't work under cywgin
      ps -ef | grep ${SSH_AGENT_PID} | grep ssh-agent$ > /dev/null || start_agent;
  else
      start_agent;
  fi

  # Automatically start attach tmux session when accessing with ssh
  if [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ]; then
    if [[ "$TERM" != screen* ]]; then
      if type mux &> /dev/null; then
        mux;
      fi
    fi
  fi
fi

# Configure git user and email if not available
type git 2>&1 >/dev/null && {
    if [[ $(git config --global --get user.name) == "" ]]; then
        if [[ "$GIT_USER" == "" ]]; then
            printf "Git user: ";
            read -r GIT_USER;
        fi
        git config --global user.name "$GIT_USER";
        unset GIT_USER;
    fi

    if [[ $(git config --global --get user.email) == "" ]]; then
        if [[ "$GIT_EMAIL" == "" ]]; then
            printf "Git email: ";
            read -r GIT_EMAIL;
        fi
        git config --global user.email "$GIT_EMAIL";
        unset GIT_EMAIL;
    fi

    if [[ -n "$GIT_SIGNING_KEY" ]]; then
        # set signing key only when not set globally
        if [[ $(git config --global --get user.signingkey) == "" ]]; then
            git config --global user.signingkey "$GIT_SIGNING_KEY";
            git config --global commit.gpgsign true;
        fi
        unset GIT_SIGNING_KEY;
    fi
}
