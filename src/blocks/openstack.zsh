# --------------------------------------------- #
# | Openstack block options
# --------------------------------------------- #
BLOX_BLOCK__OPENSTACK_SYMBOL="${BLOX_BLOCK__OPENSTACK_SYMBOL:-󰅡}"
BLOX_BLOCK__OPENSTACK_COLOR="${BLOX_BLOCK__OPENSTACK_COLOR:-9}"

# --------------------------------------------- #
# | The block itself
# --------------------------------------------- #
function blox_block__openstack() {
    [[ -z $OS_PROJECT_NAME && -z $OS_TENANT_NAME ]] && return
    region_name=${OS_REGION_NAME:-..}

    display_name=''
    project_name=${OS_PROJECT_NAME:-$OS_TENANT_NAME}
    project_id=${OS_PROJECT_ID:-$OS_TENANT_ID}

    if [[ $project_name =~ '[0-9]+' && -n $project_id ]]; then
        display_name="id: ${project_id}"
    else
        display_name=$project_name
    fi

    blox_helper__build_block \
        "${BLOX_BLOCK__OPENSTACK_COLOR}" \
        "${BLOX_BLOCK__OPENSTACK_SYMBOL} ${region_name} %F{244}${display_name}%f"
}
