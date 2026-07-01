# ---------------------------------------------
# Host info block configurations

# User
BLOX_BLOCK__HOST_USER_SHOW_ALWAYS="${BLOX_BLOCK__HOST_USER_SHOW_ALWAYS:-false}"
BLOX_BLOCK__HOST_USER_SHOW_FQDN="${BLOX_BLOCK__HOST_USER_SHOW_FQDN:-false}"
BLOX_BLOCK__HOST_USER_HIDE="${BLOX_BLOCK__HOST_USER_HIDE:-false}"
BLOX_BLOCK__HOST_USER_COLOR="${BLOX_BLOCK__HOST_USER_COLOR:-yellow}"
BLOX_BLOCK__HOST_USER_ROOT_COLOR="${BLOX_BLOCK__HOST_USER_ROOT_COLOR:-red}"

# Machine
BLOX_BLOCK__HOST_MACHINE_SHOW_ALWAYS="${BLOX_BLOCK__HOST_MACHINE_SHOW_ALWAYS:-false}"
BLOX_BLOCK__HOST_MACHINE_COLOR="${BLOX_BLOCK__HOST_MACHINE_COLOR:-cyan}"
# Override displayed machine name (else %M fqdn / %m short is used)
BLOX_BLOCK__HOST_MACHINE_NAME="${BLOX_BLOCK__HOST_MACHINE_NAME:-}"

# ---------------------------------------------

function blox_block__host() {
  user_color=$BLOX_BLOCK__HOST_USER_COLOR

  [[ $USER == "root" ]] \
    && user_color=$BLOX_BLOCK__HOST_USER_ROOT_COLOR

  result=""

  # Check if the user info is needed
  if [[ $BLOX_BLOCK__HOST_USER_HIDE == false ]] \
     && { [[ $BLOX_BLOCK__HOST_USER_SHOW_ALWAYS != false ]] || [[ $(whoami | awk '{print $1}') != $USER ]]; }; then
    result+="%F{$user_color]%}%n%f"
  fi

  # Check if the machine name is needed
  if [[ $BLOX_BLOCK__HOST_MACHINE_SHOW_ALWAYS != false ]] || [[ -n $SSH_CONNECTION ]]; then

    [[ $result != "" ]] \
      && result+="%F{242}@%f"

    if [[ -n $BLOX_BLOCK__HOST_MACHINE_NAME ]]; then
       result+="%F{${BLOX_BLOCK__HOST_MACHINE_COLOR}]%}${BLOX_BLOCK__HOST_MACHINE_NAME}%f"
    elif [[ $BLOX_BLOCK__HOST_MACHINE_SHOW_FQDN != false ]]; then
       result+="%F{${BLOX_BLOCK__HOST_MACHINE_COLOR}]%}%M%f"
    else
       result+="%F{${BLOX_BLOCK__HOST_MACHINE_COLOR}]%}%m%f"
    fi
  fi

  if [[ $result != "" ]]; then
    echo "$result:"
  fi
}
