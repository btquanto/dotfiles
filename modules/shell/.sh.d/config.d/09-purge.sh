# Purge old files and empty directories
#
# Usage: purge [directory]
#   - Removes files modified more than 7 days ago under directory (default: cwd)
#   - Removes any resulting empty directories
#   - Does NOT follow symlinks or cross filesystem boundaries
#
# Safety: this permanently deletes data. No undo. No dry-run.
function purge() {
  local target="${1:-.}"

  if [ ! -d "$target" ]; then
    echo "purge: not a directory: $target" >&2
    return 1
  fi

  # Delete files older than 7 days
  find "$target" -type f -mtime +7 -exec rm -f {} \;

  # Delete empty directories (bottom-up via -depth)
  find "$target" -type d -empty -depth -exec rmdir {} \; 2>/dev/null
}
