# ---------------------------------------------
# Pyenv block configurations

BLOX_BLOCK__PYENV_COLOR="${BLOX_BLOCK__PYENV_COLOR:-green}"
BLOX_BLOCK__PYENV_SYMBOL="${BLOX_BLOCK__PYENV_SYMBOL:-}"

# ---------------------------------------------
# Helper functions

function blox_block__pyenv_helper__get_version() {
  py_version=$(echo $PYENV_VIRTUAL_ENV | sed -nre "s,.*/versions/([^/]+)/.*,\1,p")
  if [[ -z $py_version ]]; then
    py_version=$(cat $PYENV_ROOT/version 2>/dev/null | grep -v system)
  fi
  echo -n "${py_version:t}"
}

# ---------------------------------------------

function blox_block__pyenv() {
  [[ -n $PYENV_ROOT ]] || return

  python_version=$(blox_block__pyenv_helper__get_version)

  if [[ ! -z "${python_version}" ]]; then
    blox_helper__build_block \
      "${BLOX_BLOCK__PYENV_COLOR}" \
      "${BLOX_BLOCK__PYENV_SYMBOL} ${python_version}"
  fi
}
