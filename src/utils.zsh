# ---------------------------------------------
# Utilities functions

# Check if command exists
function blox_helper__exists() {
  command -v "$1" &> /dev/null
}

# Build a "common" block
function blox_helper__build_block() {
  local -r color="$1"
  local -r contents="$2"
  local prefix="${3:-$BLOX_CONF__BLOCK_PREFIX}"
  local suffix="${4:-$BLOX_CONF__BLOCK_SUFFIX}"
  [[ $prefix = 'null' ]] && unset prefix
  [[ $suffix = 'null' ]] && unset suffix

  local result=""

  result+="%F{${color}}${prefix}"
  result+="${contents}%f";
  result+="%F{${color}}${suffix}%f"

  echo -n "$result"
}
