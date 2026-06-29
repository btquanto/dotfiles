#!/bin/sh

_SHELL="bash";

[ -f ~/.sh.d/init.sh ] && source ~/.sh.d/init.sh;

if [ -f ~/.shellrc-local ]; then
    source ~/.shellrc-local;
else
    touch ~/.shellrc-local;
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
