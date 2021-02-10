# --------------------------------------------- #
# | Docker block options
# --------------------------------------------- #
BLOX_BLOCK__DOCKER_SYMBOL="${BLOX_BLOCK__DOCKER_SYMBOL:- }"
BLOX_BLOCK__DOCKER_COLOR="${BLOX_BLOCK__DOCKER_COLOR:-81}"
# --------------------------------------------- #
# | The block itself
# --------------------------------------------- #
function blox_block__docker() {(
    [[ ! -f /.dockerenv ]] && return
    docker_id=$(cat /proc/self/cgroup | head -1 | cut -d/ -f3 | cut -c1-12)

    blox_helper__build_block \
        "${BLOX_BLOCK__DOCKER_COLOR}" \
        "${BLOX_BLOCK__DOCKER_SYMBOL} ${docker_id}"
)}
