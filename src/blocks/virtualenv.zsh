# ---------------------------------------------
# Virtualenv block configurations

BLOX_BLOCK__VIRTUALENV_COLOR="${BLOX_BLOCK__VIRTUALENV_COLOR:-green}"
BLOX_BLOCK__VIRTUALENV_SYMBOL="${BLOX_BLOCK__VIRTUALENV_SYMBOL:-󰌠}"

# ---------------------------------------------

function blox_block__virtualenv() {
  [[ -n "$VIRTUAL_ENV" ]] || return

  venv_path_part=$(basename "$VIRTUAL_ENV")

  if [ "$venv_path_part" != ".venv" ]; then
    venv_name="$venv_path_part"
  else
    venv_name=$(basename "$(dirname "$VIRTUAL_ENV")")
  fi

  blox_helper__build_block \
    "${BLOX_BLOCK__VIRTUALENV_COLOR}" \
    "${BLOX_BLOCK__VIRTUALENV_SYMBOL} ${venv_name}"
}
