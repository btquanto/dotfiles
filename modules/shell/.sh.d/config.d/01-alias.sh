
if command -v dircolors &> /dev/null; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
fi

# some git aliases
alias gl="git log --graph --oneline"
alias gvi="vim -p \`git diff --name-only\`"

alias ll='ls -l'
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

# More aliases
alias memwatch="watch -n 3 free -m"

if command -v grub-mkconfig &> /dev/null; then
    alias update-grub='sudo grub-mkconfig -o /boot/grub/grub.cfg'
fi

if [ -x "/Applications/Visual Studio Code.app/Contents/Resources/app/bin/code" ]; then
    alias code="/Applications/Visual\ Studio\ Code.app/Contents/Resources/app/bin/code"
fi

# If python command doesn't exist but python3 does, alias python to python3
if ! command -v python &> /dev/null && command -v python3 &> /dev/null; then
    alias python='python3'
fi
