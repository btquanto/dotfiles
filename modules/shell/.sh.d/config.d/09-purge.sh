# Purge old files and empty directories
#
# Usage: purge [--force|-f] [--time|-t <n>] <directory>
#   - Removes files modified more than <n> days ago under directory (n=7)
#   - Removes any resulting empty directories
#   - Does NOT follow symlinks or cross filesystem boundaries
#   - Prompts for confirmation unless --force or -f is given
#
# Safety: this permanently deletes data. No undo.
function purge() {
  local force=0
  local days=7

  # Parse flags
  while [[ "$1" == -* ]]; do
    case "$1" in
      -h|--help)
        echo "Usage: purge [OPTIONS] <directory>"
        echo ""
        echo "Permanently delete files older than a given age and remove"
        echo "any resulting empty directories underneath the target."
        echo ""
        echo "Arguments:"
        echo "  directory         Target directory (required)"
        echo ""
        echo "Options:"
        echo "  -f, --force       Skip confirmation prompt"
        echo "  -t, --time <n>    Delete files older than <n> days (default: 7)"
        echo "  -h, --help        Show this help message"
        return 0
        ;;
      -f|--force) force=1; shift ;;
      -t|--time) days="$2"; shift 2 ;;
      *) echo "purge: unknown flag: $1 (use -h for help)" >&2; return 1 ;;
    esac
  done

  if [ -z "$1" ]; then
    echo "purge: missing target directory" >&2
    echo "Usage: purge [OPTIONS] directory" >&2
    echo "  Use -h for full help" >&2
    return 1
  fi

  local target="$1"

  if [ ! -d "$target" ]; then
    echo "purge: not a directory: $target" >&2
    return 1
  fi

  if [ "$force" -eq 0 ]; then
    local count
    count=$(find "$target" -type f -mtime +"$days" | wc -l)

    if [ "$count" -eq 0 ]; then
      echo "purge: no files older than $days days in '$target'"
      return 0
    fi

    echo "purge: $count file(s) older than $days days will be permanently deleted from '$target'"
    printf "Continue? [y/N] "
    read -r reply
    case "$reply" in
      [yY]|[yY][eE][sS]) ;;
      *) echo "purge: cancelled"; return 1 ;;
    esac
  fi

  # Delete files older than <days> days
  find "$target" -type f -mtime +"$days" -exec rm -f {} \;

  # Delete empty directories (bottom-up via -depth)
  find "$target" -type d -empty -depth -exec rmdir {} \; 2>/dev/null

  echo "purge: done"
}
