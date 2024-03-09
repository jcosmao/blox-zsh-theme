# ---------------------------------------------
# Virtualenv block configurations

BLOX_BLOCK__VIRTUALENV_COLOR="${BLOX_BLOCK__VIRTUALENV_COLOR:-green}"
BLOX_BLOCK__VIRTUALENV_SYMBOL="${BLOX_BLOCK__VIRTUALENV_SYMBOL:-󰌠}"

# ---------------------------------------------

function blox_block__virtualenv() {
  [[ -n "$VIRTUAL_ENV" ]] \
    || return

  blox_helper__build_block \
    "${BLOX_BLOCK__VIRTUALENV_COLOR}" \
    "${BLOX_BLOCK__VIRTUALENV_SYMBOL} ${VIRTUAL_ENV:t}"
}
