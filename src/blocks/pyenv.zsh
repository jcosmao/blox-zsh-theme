# ---------------------------------------------
# Pyenv block configurations

BLOX_BLOCK__PYENV_COLOR="${BLOX_BLOCK__PYENV_COLOR:-green}"
BLOX_BLOCK__PYENV_SYMBOL="${BLOX_BLOCK__PYENV_SYMBOL:-}"

# ---------------------------------------------
# Helper functions

function blox_block__pyenv_helper__get_version() {
  echo -n "$(pyenv version-name 2>/dev/null)"
}

# ---------------------------------------------

function blox_block__pyenv() {
  [[ -n *.py(#qN^/) ]] \
    || return

  blox_helper__exists "pyenv" \
    || return

  python_version=$(blox_block__pyenv_helper__get_version)

  if [[ ! -z "${python_version}" ]]; then
    blox_helper__build_block \
      "${BLOX_BLOCK__PYENV_COLOR}" \
      "${BLOX_BLOCK__PYENV_SYMBOL} ${python_version}"
  fi
}
