# =============================================================================
# Shell Check and Initialization
# =============================================================================

# Exit if the current shell is not ZSH
if [[ ! "$_SHELL" == "zsh" ]]; then
    return
fi

# =============================================================================
# History Settings
# =============================================================================

# Don't put duplicate lines or lines starting with space in the history.
setopt HIST_IGNORE_ALL_DUPS  # Ignore duplicate history entries
setopt HIST_IGNORE_SPACE     # Ignore commands that start with a space

# Append to the history file, don't overwrite it
setopt APPEND_HISTORY        # Append history to the file instead of overwriting
setopt INC_APPEND_HISTORY    # Append commands to the history file immediately

# Additional history options
setopt HIST_REDUCE_BLANKS    # Remove extra spaces from commands in history
setopt SHARE_HISTORY         # Share history across all ZSH sessions
setopt HIST_FCNTL_LOCK       # Prevent race conditions when accessing the history file
setopt HIST_LEX_WORDS        # Enable lexical word splitting for history expansion

# =============================================================================
# Terminal Behavior
# =============================================================================

# Enable extended globbing (e.g., **/*.txt for recursive matching)
setopt EXTENDED_GLOB

# Enable prompt substitution (allows commands in the prompt to be evaluated)
setopt PROMPT_SUBST

# =============================================================================
# Prompt Configuration
# =============================================================================

# Load VCS (Version Control System) information
autoload -Uz vcs_info

# Configure VCS info display for Git
zstyle ':vcs_info:git:*' actionformats  '%F{8}[%F{124}%b%F{3}|%F{2}%a%F{8}]%f'  # Format for actions (e.g., rebase, merge)
zstyle ':vcs_info:git:*' formats        '%F{8}[%F{124}%b%F{8}]%f'               # Format for branch display
zstyle ':vcs_info:*' enable git         # Enable VCS info for Git

# Function to display VCS info in the prompt
_vcs_info_ps1() {
    vcs_info
    if [ -n "$vcs_info_msg_0_" ]; then
        echo "${vcs_info_msg_0_}"
    fi
}

# Set host color based on whether the session is SSH or local
if [[ -n $SSH_TTY || -n $SUDO_USER ]]
then
    host_color="%F{yellow}"  # Yellow for SSH or sudo sessions
else
    host_color="%F{green}"   # Green for local sessions
fi

# Add extra style for root user
if [[ $EUID == 0 ]]
then
    extra_style="%K{red}%S"  # Red background and standout mode for root
fi

# Custom prompt
export PS1='$(echo "$extra_style%B$host_color%n@%m%f:%F{blue}%~%b$(_vcs_info_ps1)%f\$ ")'

# =============================================================================
# Tab Completion
# =============================================================================

# Enable and configure tab completion
autoload -Uz compinit
zmodload zsh/complist
if [[ -n ~/.zcompdump(#qN.mh+24) ]]; then
  compinit
else
  compinit -C
fi
_comp_options+=(globdots)  # Include hidden files in tab completion

# Source git completion for zsh if available (from git contrib)
[ -f ~/.sh.d/config.d/901-git-completion.zsh ] && source ~/.sh.d/config.d/901-git-completion.zsh

# =============================================================================
# Key Bindings
# =============================================================================

# Set Emacs keybindings for the shell
bindkey -e

# Key bindings for navigation and shortcuts
bindkey "^[[3~"   delete-char                       # Delete key
bindkey "^[[H"    beginning-of-line                 # Home key
bindkey "^[[1;6D" beginning-of-line                 # Ctrl + Shift + Left Arrow (move to beginning of line)
bindkey "^[[F"    end-of-line                       # End key
bindkey "^[[1;6C" end-of-line                       # Ctrl + Shift + Right Arrow (move to end of line)
bindkey "\e[1;9D" backward-word                     # Alt/Option + Left Arrow (move backward by word)
bindkey "\e[1;9C" forward-word                      # Alt/Option + Right Arrow (move forward by word)
bindkey -s "^O"         'lf\n'                      # Ctrl + O (open 'lf' file manager)
