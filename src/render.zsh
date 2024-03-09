# ---------------------------------------------
# Helper functions

# Calculate how many spaces we need to put between two segments
function blox_helper__calculate_spaces() {

  [[ $BLOX_DEBUG -ne 1 ]] && set +x

  # The segments
  local left=$1
  local right=$2

  # Strip ANSI escape characters
  local zero='%([BSUbfksu]|([FBK]|){*})'

  left=${#${(S%%)left//$~zero/}}
  right=${#${(S%%)right//$~zero/}}

  if [[ $right -le 1 ]]; then
    return 0
  fi

  # Desired spaces length
  local termwidth
  (( termwidth = ${COLUMNS} - ${left} - ${right} - ${BLOX_SEG__ADJUST_SPACING_WIDTH:-0}))

  # Calculate spaces
  local spacing=""
  for i in {3..$termwidth}; do
    spacing="${spacing} "
  done

  echo $spacing
}

# ---------------------------------------------
# Hooks

# Render the prompt
function blox_hook__render() {

  [[ $BLOX_DEBUG -ne 1 ]] && set +x

  # `EXTENDED_GLOB` may be required by some blocks. `LOCAL_OPTIONS` will enable
  # the option locally, meaning it'll restore to its previous state after the
  # function exits.
  setopt EXTENDED_GLOB LOCAL_OPTIONS

  local upper_left
  local upper_right
  local lower_left
  local lower_right

  local spacing

  [[ -n "$BLOX_CONF__PROMPT_PREFIX" ]] \
    && echo -ne "$BLOX_CONF__PROMPT_PREFIX"

  [[ $BLOX_DEBUG = 1 ]] && start=$(($(date +%s%N)/1000000))

  # build block in // using zargs
  # https://stackoverflow.com/a/51549244
  autoload -Uz zargs
  array=()
  all_args=(
    upper_left "$BLOX_SEG__UPPER_LEFT"
    upper_right "$BLOX_SEG__UPPER_RIGHT"
    lower_left "$BLOX_SEG__LOWER_LEFT"
    lower_right "$BLOX_SEG__LOWER_RIGHT"
  )
  results=("${(@f)"$(zargs -P4 -n2 -- ${all_args[@]} -- blox_helper__render_segment)"}")

  for r in ${results[@]}; do
    name=$(echo $r | cut -d: -f1)
    segment=$(echo $r | cut -d: -f2-)
    [[ $name = upper_left ]] && upper_left="$segment"
    [[ $name = upper_right ]] && upper_right="$segment"
    if [[ $BLOX_CONF__ONELINE == false ]]; then
      [[ $name = lower_left ]] && lower_left="$segment"
      [[ $name = lower_right ]] && lower_right="$segment"
    fi
  done

  if [[ $BLOX_CONF__ONELINE == false ]]; then
    spacing="$(blox_helper__calculate_spaces ${upper_left} ${upper_right})"
  fi

  if [[ $BLOX_DEBUG = 1 ]]; then
    finish=$(($(date +%s%N)/1000000))
    BLOX_BUILD_TIME=" (DEBUG prompt build time: $(( finish - start )) ms)"
  fi

  # In oneline mode, we set $PROMPT to the
  # upper left segment and $RPROMPT to the upper
  # right. In multiline mode, $RPROMPT goes to the bottom
  # line so we set the first line of $PROMPT to the upper segments
  # while the second line to only the the lower left. Then,
  # $RPROMPT is set to the lower right segment.

  # Check if in oneline mode
  if [[ $BLOX_CONF__ONELINE == true ]]; then
    PROMPT=" ${upper_left} "
    RPROMPT="${upper_right}"
  else

    if [[ $BLOX_CONF__UNIFIED_PROMPT == true ]]; then

      # When $BLOX_CONF__UNIFIED_PROMPT set to `true`, we'll render the entire prompt (besides of
      # the lower right segment) by assigning the result to $PROMPT (#8).
      PROMPT=" %{${upper_left}%}${spacing}%{${upper_right}%}
 ${lower_left} "
    else

      # Otherwise, we'll first render the upper segments separately, then the lower segments. Doing
      # this may solve some resizing issue (#2).
      print -rP " %{${upper_left}%}${spacing}%{${upper_right}%} "
      PROMPT="${BLOX_BUILD_TIME}${lower_left} "
    fi

    # Lower right prompt
    [[ -n "$lower_right" ]] \
      && RPROMPT="${lower_right}"
  fi

  # PROMPT2 (continuation interactive prompt)
  PROMPT2=' ${BLOX_BLOCK__SYMBOL_ALTERNATE} %_ >>> '
}
