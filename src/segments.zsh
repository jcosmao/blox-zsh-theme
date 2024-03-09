# ---------------------------------------------
# Helper functions

# Render a block
function blox_helper__render_block() {
  local block=$1
  local block_func="blox_block__${block}"

  if command -v "$block_func" &> /dev/null; then
    echo "${block}:$(${block_func})"
  else
    # Support for older versions of blox, where the block render function name
    # would be the same as the block name itself.
    echo "${block}:$(${block})"
  fi
}

# Build a given segment
function blox_helper__render_segment() {
  segment_name=$1; shift

  # For some reason, arrays cannot be assigned in typeset expressions in older versions of zsh.
  local blocks; blocks=( `echo $@` )
  typeset -A block_index=()
  local i=1
  for b in ${blocks[@]}; do
    block_index[$b]=$i
    i=$((i+1))
  done

  local segment=()

  # build block in // using zargs
  # https://stackoverflow.com/a/51549244
  autoload -Uz zargs
  results=()
  results=("${(@f)"$(zargs -P10 -n1 -- ${blocks[@]} -- blox_helper__render_block)"}")

  for r in "${results[@]}"; do

    block=$(echo $r | cut -d: -f1)
    result=$(echo $r | cut -d: -f2-)

    if [[ -n $result ]]; then
      [[ ${#segment} > 0 ]] && result+="$BLOX_CONF__BLOCK_SEPARATOR"
      segment[$block_index[$block]]="$result"
    fi
  done

  echo ${segment_name}:$(for s in ${segment[@]}; do echo $s; done)
}
