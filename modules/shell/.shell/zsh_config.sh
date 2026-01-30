# ZSH Config

if [[ ! "$_SHELL" == "zsh" ]]; then
    return
fi

bindkey -e
zstyle ':completion:*' use-cache on
zstyle ':completion:*' menu select

setopt HIST_IGNORE_ALL_DUPS
setopt HIST_REDUCE_BLANKS
setopt SHARE_HISTORY
setopt HIST_FCNTL_LOCK
setopt HIST_LEX_WORDS
setopt EXTENDED_GLOB

setopt PROMPT_SUBST
autoload -Uz vcs_info

zstyle ':vcs_info:git:*' actionformats  '%F{8}[%F{124}%b%F{3}|%F{2}%a%F{8}]%f'
zstyle ':vcs_info:git:*' formats        '%F{8}[%F{124}%b%F{8}]%f'
zstyle ':vcs_info:*' enable git

_vcs_info_ps1() {
    vcs_info
    if [ -n "$vcs_info_msg_0_" ]; then
        echo "${vcs_info_msg_0_}"
    fi
}

if [[ -n $SSH_TTY || -n $SUDO_USER ]]
then
    host_color="%F{yellow}"
else
    host_color="%F{green}"
fi

if [[ $EUID == 0 ]]
then
    extra_style="%K{red}%S"
fi

_prompt() {
    echo "$extra_style%B$host_color%n@%m%f:%F{blue}%~%b$(_vcs_info_ps1)%f\$ ";
}
export PS1='$(_prompt)';

autoload -U compinit
zmodload zsh/complist
compinit
_comp_options+=(globdots)                           # Include hidden files.

bindkey "^[[3~"   delete-char                       # Delete key
bindkey "^[[H"    beginning-of-line                 # Home key
bindkey "^[[1;6D" beginning-of-line                 # Ctrl + Shift + Left Arrow (move to beginning of line)
bindkey "^[[F"    end-of-line                       # End key
bindkey "^[[1;6C" end-of-line                       # Ctrl + Shift + Right Arrow (move to end of line)
bindkey "\e[1;9D" backward-word                     # Alt/Option + Left Arrow (move backward by word)
bindkey "\e[1;9C" forward-word                      # Alt/Option + Right Arrow (move forward by word)
bindkey -s "^O"         'lf\n'                      # Ctrl + O (open 'lf' file manager)
