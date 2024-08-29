# ---------------------------------------------
# GITSECRET block configurations

BLOX_BLOCK__GITSECRET_COLOR="${BLOX_BLOCK__GITSECRET_COLOR:-148}"
BLOX_BLOCK__GITSECRET_SYMBOL="${BLOX_BLOCK__GITSECRET_SYMBOL:- }"

# ---------------------------------------------

function blox_block__gitsecret() {
  if [[ -n $SECRETS_DIR ]]; then
    secret_name=$(basename $SECRETS_DIR)
    blox_helper__build_block \
      "${BLOX_BLOCK__GITSECRET_COLOR}" \
      "${BLOX_BLOCK__GITSECRET_SYMBOL} $secret_name"
  fi
}
