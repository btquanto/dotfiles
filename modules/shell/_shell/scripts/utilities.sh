source ~/.shell/scripts/tmux.sh;
source ~/.shell/scripts/proxy.sh;
source ~/.shell/scripts/docker.sh;
source ~/.shell/scripts/alias.sh;

[[ $_SHELL == "bash" ]] && source ~/.shell/scripts/git-prompt.sh;

function line() {
    _line=$1
    _file=$2
     sed -n "${_line},${_line}p;${_line}q" $_file
}

function pipv() {
    PACKAGE_JSON_URL="https://pypi.org/pypi/${1}/json"
    curl -Ls "$PACKAGE_JSON_URL" | jq  -r '.releases | keys | .[]' | sort -V
}


function dirdiff() {
    if [[ ! -n $1 || ! -n $2 ]]; then
        echo "Error:you should input two dir!"
        exit
    fi

    # get diff files list (use '|' sign a pair of files)
    diff_file_list_str=`diff -ruNaq $1 $2 | awk '{print $2 " " $4 "|"}'`;

    # split list by '|'
    OLD_IFS="$IFS"
    IFS="|"
    diff_file_list=($diff_file_list_str)
    IFS="$OLD_IFS"

    # use vimdiff compare files from diff dir
    i=0
    while [ $i -lt ${#diff_file_list[*]} ]; do
        vimdiff ${diff_file_list[$((i++))]}
    done
}

#
# # ex - archive extractor
# # usage: ex <file>
function extract () {
  if [ -f $1 ] ; then
    case $1 in
      *.tar.bz2)   tar xjf $1   ;;
      *.tar.gz)    tar xzf $1   ;;
      *.tar.xz)    tar xJf $1   ;;
      *.bz2)       bunzip2 $1   ;;
      *.rar)       unrar x $1     ;;
      *.gz)        gunzip $1    ;;
      *.tar)       tar xf $1    ;;
      *.tbz2)      tar xjf $1   ;;
      *.tgz)       tar xzf $1   ;;
      *.zip)       unzip $1     ;;
      *.Z)         uncompress $1;;
      *.7z)        7z x $1      ;;
      *)           echo "'$1' cannot be extracted via extract()" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

function path_add () {
  # Extra paths
  # PATH_EXTRAS="/sbin:/usr/sbin:/usr/local/sbin:$HOME/bin:$HOME/.local/bin"
  PATH_EXTRAS="$1"
  PATHS=""
  for pth in $(echo $(echo "$PATH:$PATH_EXTRAS" | sed 's/:/\n/g')); do
      if [ -d $pth ]; then
          pth=$(realpath "$pth")
          echo ":${PATHS}:" | grep --quiet ":${pth}:" || {
              if [ -z "$PATHS" ]; then
                  PATHS="$pth";
              else
                  PATHS="${PATHS}:${pth}";
              fi
          }
      fi
  done

  export PATH="$PATHS";
}