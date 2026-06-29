#!/bin/sh

_SHELL="bash";
_LOCAL_CONFIG="$HOME/.local/shrc.sh";

[ -f ~/.sh.d/init.sh ] && source ~/.sh.d/init.sh;

if [ -f "$_LOCAL_CONFIG" ]; then
    source "$_LOCAL_CONFIG";
else
    touch "$_LOCAL_CONFIG";
fi

# Define the list of commands that should trigger NVM to load
_nvm_commands=(${NVM_COMMANDS:-nvm node npm npx})

# Dynamically create placeholder functions
for cmd in "${_nvm_commands[@]}"; do
    eval "$cmd() {
        unset -f ${_nvm_commands[*]}
        _load_nvm
        $cmd \"\$@\"
    }"
done
