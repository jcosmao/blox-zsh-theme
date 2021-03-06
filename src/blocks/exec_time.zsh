# ---------------------------------------------
# Execution time block configurations

BLOX_BLOCK__EXEC_TIME_MIN_ELAPSED="${BLOX_BLOCK__EXEC_TIME_MIN_ELAPSED:-5}"
BLOX_BLOCK__EXEC_TIME_PERSIST="${BLOX_BLOCK__EXEC_TIME_PERSIST:-false}"
BLOX_BLOCK__EXEC_TIME_COLOR="${BLOX_BLOCK__EXEC_TIME_COLOR:-yellow}"

BLOX_BLOCK__EXEC_TIME_START=""
BLOX_BLOCK__EXEC_TIME_STOP=""

# ---------------------------------------------
# Helper functions

# Turns seconds into human readable time
# https://github.com/sindresorhus/pure/blob/master/pure.zsh#L30
function blox_block__exec_time_helper__humen_time() {
  tmp=$1
  days=$(( tmp / 60 / 60 / 24 ))
  hours=$(( tmp / 60 / 60 % 24 ))
  minutes=$(( tmp / 60 % 60 ))
  seconds=$(( tmp % 60 ))
  (( $days > 0 )) && echo -n "${days}d "
  (( $hours > 0 )) && echo -n "${hours}h "
  (( $minutes > 0 )) && echo -n "${minutes}m "
  echo "${seconds}s"
}

# ---------------------------------------------
# Hooks

function blox_block__exec_time_hook__preexec() {
  unset BLOX_BLOCK__EXEC_TIME_STOP
  BLOX_BLOCK__EXEC_TIME_START=$EPOCHSECONDS
}

function blox_block__exec_time_hook__precmd() {
  [[ $BLOX_BLOCK__EXEC_TIME_PERSIST == false ]] \
    && unset BLOX_BLOCK__EXEC_TIME_START
}

# ---------------------------------------------

function blox_block__exec_time() {
  stop=${BLOX_BLOCK__EXEC_TIME_STOP:-$EPOCHSECONDS}
  start=${BLOX_BLOCK__EXEC_TIME_START:-$stop}

  elapsed=$(( $stop - $start ))

  [[ $elapsed -gt $BLOX_BLOCK__EXEC_TIME_MIN_ELAPSED ]] \
    || return

  result=""

  result="%F{${BLOX_BLOCK__EXEC_TIME_COLOR}}"
  result+="$(blox_block__exec_time_helper__humen_time $elapsed)";
  result+="%f"

  echo $result
}
