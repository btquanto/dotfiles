#!/bin/sh

_SHELL="bash";
_LOCAL_CONFIG="$HOME/.local/shrc.sh";

[ -f ~/.sh.d/init.sh ] && source ~/.sh.d/init.sh;

test -f "$_LOCAL_CONFIG" && source "$_LOCAL_CONFIG" || touch "$_LOCAL_CONFIG";

# Define the list of commands that should trigger NVM to load
_nvm_commands=(${NVM_COMMANDS[@]:-nvm node npm npx})

for cmd in "${_nvm_commands[@]}"; do
    eval "$cmd() {
        unset -f ${_nvm_commands[*]}
        _load_nvm
        $cmd \"\$@\"
    }"
done
