# ---------------------------------------------
# Background jobs block configurations

BLOX_BLOCK__BGJOBS_SYMBOL="${BLOX_BLOCK__BGJOBS_SYMBOL:- }"
BLOX_BLOCK__BGJOBS_COLOR="${BLOX_BLOCK__BGJOBS_COLOR:-magenta}"

# ---------------------------------------------

function blox_block__bgjobs() {
  bgjobs="%1(j.${BLOX_BLOCK__BGJOBS_SYMBOL}%j.)"
  echo "%F{${BLOX_BLOCK__BGJOBS_COLOR}}${bgjobs}%f"
}
