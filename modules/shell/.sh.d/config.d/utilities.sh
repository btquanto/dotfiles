source ~/.sh.d/config.d/tmux.sh;
source ~/.sh.d/config.d/docker.sh;
source ~/.sh.d/config.d/alias.sh;
source ~/.sh.d/config.d/cloud-utils.sh;
source ~/.sh.d/config.d/gh.sh;

[[ $_SHELL == "bash" ]] && source ~/.sh.d/config.d/git-prompt.sh;

function line() {
    # Extract a specific line from a file
    line_number=$1
    file_path=$2
    sed -n "${line_number},${line_number}p;${line_number}q" "$file_path"
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

# extract - archive extractor
# usage: extract <file>
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
  # Add extra paths to the PATH environment variable
  local PATH_EXTRAS="$1"
  local PATHS=()
  
  # Split PATH and PATH_EXTRAS into individual paths
  IFS=':' ALL_PATHS=($PATH:$PATH_EXTRAS)
  
  for pth in "${ALL_PATHS[@]}"; do
      if [ -d "$pth" ]; then
          pth=$(realpath "$pth")
          # Add path if not already in PATHS
          if [[ ! " ${PATHS[*]} " =~ " $pth " ]]; then
              PATHS+=("$pth")
          fi
      fi
  done

  # Only update PATH if there are valid paths
  if [ ${#PATHS[@]} -gt 0 ]; then
      export PATH=$(IFS=:; echo "${PATHS[*]}")
  fi
}

function update_ssh_key_password() {
    KEY_FILE="$1"

    if [[ -z "$KEY_FILE" ]]; then
        echo "Usage: update_ssh_key_password <private_key_file>"
        return 1
    fi
        
    # Update SSH key password for the specified private key
    if [[ -f "$KEY_FILE" && ! "$KEY_FILE" =~ \.pub$ ]]; then
        echo "Updating password for key: $KEY_FILE"
        ssh-keygen -p -f "$KEY_FILE"
    else
        echo "Error: '$KEY_FILE' is not a valid private key file."
        return 1
    fi
}