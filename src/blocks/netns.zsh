# --------------------------------------------- #
# | NETNS block options
# --------------------------------------------- #
BLOX_BLOCK__NETNS_SYMBOL="${BLOX_BLOCK__NETNS_SYMBOL:- }"
BLOX_BLOCK__NETNS_COLOR="${BLOX_BLOCK__NETNS_COLOR:-212}"
# --------------------------------------------- #
# | The block itself
# --------------------------------------------- #
function blox_block__netns() {(
  netns=$(ip netns identify $$)
  [[ -z $netns ]] && return

  blox_helper__build_block \
    "${BLOX_BLOCK__NETNS_COLOR}" \
    "${BLOX_BLOCK__NETNS_SYMBOL} $netns"
)}
