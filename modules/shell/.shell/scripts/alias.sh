
test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"

# some git aliases
alias gl="git log --graph --oneline"
alias gvi="vim -p \`git diff --name-only\`"

alias ls='ls'
alias ll='ls -l'
# ls, the common ones I use a lot shortened for rapid fire usage
alias l='ls -lFh'     #size,show type,human readable
alias la='ls -lAFh'   #long list,show almost all,show type,human readable
alias lr='ls -tRFh'   #sorted by date,recursive,show type,human readable
alias lt='ls -ltFh'   #long list,sorted by date,show type,human readable
alias ll='ls -l'      #long list
alias ldot='ls -ld .*'
alias lS='ls -1FSsh'
alias lart='ls -1Fcart'
alias lrt='ls -1Fcrt'

alias grep='grep --color'
alias sgrep='grep -R -n -H -C 5 --exclude-dir={.git,.svn,CVS} '

alias t='tail -f'

if [[ $_SHELL == "zsh" ]]; then
    # Command line head / tail shortcuts
    alias -g H='| head'
    alias -g T='| tail'
    alias -g G='| grep'
    alias -g L="| less"
    alias -g M="| most"
    alias -g LL="2>&1 | less"
    alias -g CA="2>&1 | cat -A"
    alias -g NE="2> /dev/null"
    alias -g NUL="> /dev/null 2>&1"
    alias -g P="2>&1| pygmentize -l pytb"
fi

alias dud='du -d 1 -h'
alias duf='du -sh *'
alias fd='find . -type d -name'
alias ff='find . -type f -name'

alias h='history'
alias hgrep="fc -El 0 | grep"
alias help='man'
alias p='ps -f'
alias sortnr='sort -n -r'
alias unexport='unset'

alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias vi='vim'

alias update-grub='sudo grub-mkconfig -o /boot/grub/grub.cfg'
alias memwatch="watch -n 3 free -m"