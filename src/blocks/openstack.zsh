# --------------------------------------------- #
# | Openstack block options
# --------------------------------------------- #
BLOX_BLOCK__OPENSTACK_SYMBOL="${BLOX_BLOCK__OPENSTACK_SYMBOL:- }"
BLOX_BLOCK__OPENSTACK_COLOR="${BLOX_BLOCK__OPENSTACK_COLOR:-9}"

# --------------------------------------------- #
# | The block itself
# --------------------------------------------- #
function blox_block__openstack() {
    [[ -z $OS_PROJECT_NAME ]] && return
    local region_name=${OS_REGION_NAME:-..}

    blox_helper__build_block \
        "${BLOX_BLOCK__OPENSTACK_COLOR}" \
        "${BLOX_BLOCK__OPENSTACK_SYMBOL} ${region_name}"
}
