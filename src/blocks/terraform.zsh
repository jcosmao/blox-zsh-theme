# ---------------------------------------------
# TERRAFORM block configurations

BLOX_BLOCK__TERRAFORM_COLOR="${BLOX_BLOCK__TERRAFORM_COLOR:-135}"
BLOX_BLOCK__TERRAFORM_SYMBOL="${BLOX_BLOCK__TERRAFORM_SYMBOL:-󱁢}"

# ---------------------------------------------

function blox_block__terraform() {
  which terraform &> /dev/null || return
  ls | grep -Pq '.*.(tf|tf.json)$' || return

  if [[ -n $TF_WORKSPACE ]]; then
    blox_helper__build_block \
      "${BLOX_BLOCK__TERRAFORM_COLOR}" \
      "${BLOX_BLOCK__TERRAFORM_SYMBOL} ${TF_WORKSPACE}"
  fi
}
