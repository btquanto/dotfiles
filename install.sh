#!/bin/bash

BASH_SOURCE=".$0";

if [[ ".$0" != ".$BASH_SOURCE" ]]; then
    echo "Sourcing this script is not allowed";
    return;
fi

bin_dir=$(dirname $(realpath $0));
home_dir="$(cd && pwd)";

cd "$bin_dir";

# Check if .env exists
if [ ! -f ".env" ]
then
    echo "Environment file not found. Creating one..." && echo;
    echo -n 'User: ' && read git_user
    echo -n 'Email: ' && read git_email
    echo "\
GIT_USER=\"$git_user\"
GIT_EMAIL=\"$git_email\"\
" > .env
fi;

set -o allexport
source .env
set +o allexport

timestamp=$(date +"%Y-%m-%d_%H:%M:%S");

mkdir -p dotfiles
mkdir -p history/$timestamp;

history_dir="$bin_dir/history/$timestamp"

ENV_VARS=""
for item in $(cat .env | grep -o "^[A-Z_]*"); do
    ENV_VARS="$ENV_VARS\$$item"
done

function make_backup() {
    if [ -d $1 ]; then
        echo "$1 -> $2"
        cp -R $1 $2;
    elif [ -f $1 ]; then
        echo "$1 -> $2"
        cp $1 $2;
    fi
}

function gen_dotfile() {
    if [ -d $1 ]; then
        echo "$1 -> $2"
        rm -rf $2;
        cp -R $1 $2;
    elif [ -f $1 ]; then
        echo "$1 -> $2"
        envsubst "$ENV_VARS" < $1 > $2;
    fi
}

echo "Backing up data..."

[ -f ~/.shellrc-local ] && make_backup $home_dir/.shellrc-local $history_dir/.shellrc-local;

for item in ./dotfiles/*; do
    item_name=$(sed '0,/_/s//./' <(echo $(basename $item)));
    make_backup $home_dir/$item_name $history_dir/$item_name;
done

for module in ./modules/*; do
    if [ -d $module ]; then
        for item in $module/*; do
            item_name=$(sed '0,/_/s//./' <(echo $(basename $item)));
            make_backup $home_dir/$item_name $history_dir/$item_name;
        done
    fi
done

mkdir -p $home_dir/.config;
mkdir -p $home_dir/.cache;
mkdir -p $history_dir/.config;

for config in ./configs/*; do
    if [ -d $config ]; then
        config=$(basename $config);
        make_backup $home_dir/.config/$config $history_dir/.config/$config;
    fi
done

echo && echo "Generating dotfiles..."

for item in ./dotfiles/*; do
    item_name=$(sed '0,/_/s//./' <(echo $(basename $item)));
    gen_dotfile $item $home_dir/$item_name;
done

for module in ./modules/*; do
    if [ -d $module ]; then
        for item in $module/*; do
            item_name=$(sed '0,/_/s//./' <(echo $(basename $item)));
            gen_dotfile $item $home_dir/$item_name;
        done
    fi
done

for config in ./configs/*; do
    if [ -d $config ]; then
        gen_dotfile $config $home_dir/.config/$(basename $config);
    fi
done