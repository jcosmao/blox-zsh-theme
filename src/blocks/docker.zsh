# --------------------------------------------- #
# | Docker block options
# --------------------------------------------- #
BLOX_BLOCK__DOCKER_SYMBOL="${BLOX_BLOCK__DOCKER_SYMBOL:- }"
BLOX_BLOCK__DOCKER_COLOR="${BLOX_BLOCK__DOCKER_COLOR:-81}"
# --------------------------------------------- #
# | The block itself
# --------------------------------------------- #
function blox_block__docker() {
    [[ ! -f /.dockerenv ]] && return
    local docker_id=$(cat /proc/1/cgroup | grep /docker | cut -d: -f3 | cut -d/ -f3 | cut -c1-12  | sort -u)

    blox_helper__build_block \
        "${BLOX_BLOCK__DOCKER_COLOR}" \
        "${BLOX_BLOCK__DOCKER_SYMBOL} ${docker_id}"
}
