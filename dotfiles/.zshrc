#!/bin/sh

_SHELL="zsh";

[ -f ~/.shell/init.sh ] && source ~/.shell/init.sh;

if [ -f ~/.shellrc-local ]; then
    source ~/.shellrc-local;
else
    touch ~/.shellrc-local;
fi