# Determine current shell type
[[ "$_SHELL" != "zsh" ]] && _SHELL="bash"

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

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

# Pre-defined functions
[ -f ~/.shell/scripts/utilities.sh ] && source ~/.shell/scripts/utilities.sh;

# Common variables

export HISTSIZE=1000;
export SAVEHIST=$HISTSIZE;
export HISTFILESIZE=10000;
export HISTFILE="$HOME/.cache/history";

# Specific shell configurations
[ -f ~/.shell/bash_config ] && source ~/.shell/bash_config;
[ -f ~/.shell/zsh_config ] && source ~/.shell/zsh_config;

# Unset variables
unset color_prompt force_color_prompt

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