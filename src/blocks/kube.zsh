# --------------------------------------------- #
# | Docker block options
# --------------------------------------------- #
BLOX_BLOCK__KUBE_SYMBOL="${BLOX_BLOCK__KUBE_SYMBOL:-󱃾}"
BLOX_BLOCK__KUBE_COLOR="${BLOX_BLOCK__KUBE_COLOR:-111}"
# --------------------------------------------- #
# | The block itself
# --------------------------------------------- #
function blox_block__kube() {(
    [[ -z $KUBECONFIG ]] && return

    kube_context=$(cat $KUBECONFIG | tr -d '"' | grep -oPm 1 'current-context: \K.+' 2> /dev/null)

    if [[ -n $KUBENS ]]; then
      kubens=$KUBENS
      namespace_color=108
    else
      kubens=$(cat $KUBECONFIG | tr -d '"' | sed -n "/- context:/,/\s*name: $kube_context/p" | grep -oPm 1 '\s*namespace: \K.+')
      namespace_color=244
    fi

    blox_helper__build_block \
        "${BLOX_BLOCK__KUBE_COLOR}" \
        "${BLOX_BLOCK__KUBE_SYMBOL} ${kube_context} %F{$namespace_color}${kubens:-default}%f"
)}
