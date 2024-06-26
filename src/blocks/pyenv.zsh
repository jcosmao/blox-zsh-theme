# ---------------------------------------------
# Pyenv block configurations

BLOX_BLOCK__PYENV_COLOR="${BLOX_BLOCK__PYENV_COLOR:-green}"
BLOX_BLOCK__PYENV_SYMBOL="${BLOX_BLOCK__PYENV_SYMBOL:-󰌠}"

# ---------------------------------------------
# Helper functions

function blox_block__pyenv_helper__get_version() {
  python_version=$( (python3 -V || python -V) 2> /dev/null | awk '{print $2}')
  echo -n "${python_version}"
}

function blox_pyenv__has_python_known_files() {
  ls -a | grep -Pq '^(.*\.py|pyproject.toml|.*requirements.txt|tox.ini|.python-version)$'
  return $?
}

# ---------------------------------------------

function blox_block__pyenv() {
  [[ -n $PYENV_ROOT ]] || return
  blox_pyenv__has_python_known_files || return

  python_version=$(blox_block__pyenv_helper__get_version)

  if [[ ! -z "${python_version}" ]]; then
    blox_helper__build_block \
      "${BLOX_BLOCK__PYENV_COLOR}" \
      "${BLOX_BLOCK__PYENV_SYMBOL} ${python_version}"
  fi
}
