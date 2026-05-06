#!/bin/sh

_SHELL="bash";

[ -f ~/.sh.d/init.sh ] && source ~/.sh.d/init.sh;

if [ -f ~/.shellrc-local ]; then
    source ~/.shellrc-local;
else
    touch ~/.shellrc-local;
fi