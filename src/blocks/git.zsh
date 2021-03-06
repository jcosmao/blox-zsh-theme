# ---------------------------------------------
# Git block options

# Colors
BLOX_BLOCK__GIT_BRANCH_COLOR="${BLOX_BLOCK__GIT_BRANCH_COLOR:-242}"
BLOX_BLOCK__GIT_TAG_COLOR="${BLOX_BLOCK__GIT_TAG_COLOR:-34}"

# Commit hash
BLOX_BLOCK__GIT_COMMIT_SHOW="${BLOX_BLOCK__GIT_COMMIT_SHOW:-true}"
BLOX_BLOCK__GIT_COMMIT_COLOR="${BLOX_BLOCK__GIT_COMMIT_COLOR:-magenta}"

# Clean
BLOX_BLOCK__GIT_CLEAN_COLOR="${BLOX_BLOCK__GIT_CLEAN_COLOR:-green}"
BLOX_BLOCK__GIT_CLEAN_SYMBOL="${BLOX_BLOCK__GIT_CLEAN_SYMBOL:-✔}"

# Dirty
BLOX_BLOCK__GIT_DIRTY_COLOR="${BLOX_BLOCK__GIT_DIRTY_COLOR:-yellow}"
BLOX_BLOCK__GIT_DIRTY_SYMBOL="${BLOX_BLOCK__GIT_DIRTY_SYMBOL:-✘}"

# Stashed files
BLOX_BLOCK__GIT_STASHED_COLOR="${BLOX_BLOCK__GIT_STASHED_COLOR:-cyan}"
BLOX_BLOCK__GIT_STASHED_SYMBOL="${BLOX_BLOCK__GIT_STASHED_SYMBOL:-\$}"

# Unpulled
BLOX_BLOCK__GIT_UNPULLED_COLOR="${BLOX_BLOCK__GIT_UNPULLED_COLOR:-red}"
BLOX_BLOCK__GIT_UNPULLED_SYMBOL="${BLOX_BLOCK__GIT_UNPULLED_SYMBOL:-⇣}"

# Unpushed
BLOX_BLOCK__GIT_UNPUSHED_COLOR="${BLOX_BLOCK__GIT_UNPUSHED_COLOR:-blue}"
BLOX_BLOCK__GIT_UNPUSHED_SYMBOL="${BLOX_BLOCK__GIT_UNPUSHED_SYMBOL:-⇡}"

# Git repository block
BLOX_BLOCK__GIT_REPO_COLOR="${BLOX_BLOCK__GIT_REPO_COLOR:-208}"
BLOX_BLOCK__GIT_REPO_SYMBOL="${BLOX_BLOCK__GIT_REPO_SYMBOL:-}"

# ---------------------------------------------
# Themes

BLOX_BLOCK__GIT_THEME_CLEAN="%F{${BLOX_BLOCK__GIT_CLEAN_COLOR}]%}$BLOX_BLOCK__GIT_CLEAN_SYMBOL%f"
BLOX_BLOCK__GIT_THEME_DIRTY="%F{${BLOX_BLOCK__GIT_DIRTY_COLOR}]%}$BLOX_BLOCK__GIT_DIRTY_SYMBOL%f"
BLOX_BLOCK__GIT_THEME_STASHED="%F{${BLOX_BLOCK__GIT_STASHED_COLOR}]%}$BLOX_BLOCK__GIT_STASHED_SYMBOL%f"
BLOX_BLOCK__GIT_THEME_UNPULLED="%F{${BLOX_BLOCK__GIT_UNPULLED_COLOR}]%}$BLOX_BLOCK__GIT_UNPULLED_SYMBOL%f"
BLOX_BLOCK__GIT_THEME_UNPUSHED="%F{${BLOX_BLOCK__GIT_UNPUSHED_COLOR}]%}$BLOX_BLOCK__GIT_UNPUSHED_SYMBOL%f"

# ---------------------------------------------
# Helper functions

# Get commit hash (short)
function blox_block__git_helper__commit() {
  echo $(command git rev-parse --short HEAD  2> /dev/null)
}

function blox_block__git_helper__tag() {
  echo $(command git describe --tags 2> /dev/null)
}

# Get the current branch name
function blox_block__git_helper__branch() {
  ref=$(command git symbolic-ref HEAD 2> /dev/null) \
    || ref=$(command git rev-parse --short HEAD 2> /dev/null) \
    || return 0

  echo "${ref#refs/heads/}";
}

# Echo the appropriate symbol for branch's status
function blox_block__git_helper__status() {
  if [[ -z "$(git status --porcelain --ignore-submodules 2> /dev/null)" ]]; then
    echo " $BLOX_BLOCK__GIT_THEME_CLEAN"
  else
    echo " $BLOX_BLOCK__GIT_THEME_DIRTY"
  fi
}

# Echo the appropriate symbol if there are stashed files
function blox_block__git_helper__stashed_status() {
  if $(command git rev-parse --verify refs/stash &> /dev/null); then
    echo " $BLOX_BLOCK__GIT_THEME_STASHED"
  fi
}

# Echo the appropriate symbol for branch's remote status (pull/push)
# Need to do 'git fetch' before
function blox_block__git_helper__remote_status() {

  git_local=$(command git rev-parse @ 2> /dev/null)
  git_remote=$(command git rev-parse @{u} 2> /dev/null)
  git_base=$(command git merge-base @ @{u} 2> /dev/null)

  # First check that we have a remote
  if ! [[ ${git_remote} = "" ]]; then
    if [[ ${git_local} = ${git_remote} ]]; then
      echo ""
    elif [[ ${git_local} = ${git_base} ]]; then
      echo " $BLOX_BLOCK__GIT_THEME_UNPULLED"
    elif [[ ${git_remote} = ${git_base} ]]; then
      echo " $BLOX_BLOCK__GIT_THEME_UNPUSHED"
    else
      echo " $BLOX_BLOCK__GIT_THEME_UNPULLED $BLOX_BLOCK__GIT_THEME_UNPUSHED"
    fi
  fi
}

# Checks if the cwd is a git repo
function blox_block__git_helper__is_git_repo() {
  return $(git rev-parse --git-dir > /dev/null 2>&1)
}

function blox_block__git_helper__short_status() {
    git_status=$(git diff --shortstat 2> /dev/null)
    git_untrack=$(git status --short | grep '^??' | wc -l 2> /dev/null)
    if [[ -n $git_status || $git_untrack != 0 ]]; then
        git_file_untracked=$git_untrack
        git_file_changed=$(echo $git_status | grep -Po '\d+(?= files* changed)')
        git_line_added=$(echo $git_status | grep -Po '\d+(?= insertion)')
        git_line_deleted=$(echo $git_status | grep -Po '\d+(?= deletion)')

        local result=" "
        result+="%F{${BLOX_BLOCK__GIT_BRANCH_COLOR}}[%f"
        [[ -n $git_file_changed ]] && result+="%F{blue}${git_file_changed}c%f "
        [[ $git_file_untracked > 0 ]] && result+="%F{blue}${git_file_untracked}?%f "
        [[ -n $git_line_added ]] && result+="%F{green}${git_line_added}+%f "
        [[ -n $git_line_deleted ]] && result+="%F{red}${git_line_deleted}-%f"
        result+="%F{${BLOX_BLOCK__GIT_BRANCH_COLOR}}]%f"

        echo ${result}
    fi
}

# ---------------------------------------------
# The block itself

function blox_block__git() {

  if blox_block__git_helper__is_git_repo; then

    branch_name="$(blox_block__git_helper__branch)"
    tag_name="$(blox_block__git_helper__tag)"
    branch_status="$(blox_block__git_helper__status)"
    stashed_status="$(blox_block__git_helper__stashed_status)"
    remote_status="$(blox_block__git_helper__remote_status)"
    short_status="$(blox_block__git_helper__short_status)"

    result=""

    result+="%F{${BLOX_BLOCK__GIT_BRANCH_COLOR}}${branch_name}%f"
    [[ -n $tag_name ]] && result+="%F{${BLOX_BLOCK__GIT_TAG_COLOR}}${BLOX_CONF__BLOCK_PREFIX}${tag_name}${BLOX_CONF__BLOCK_SUFFIX}%f"

    [[ $BLOX_BLOCK__GIT_COMMIT_SHOW != false ]] \
      && commit_hash="$(blox_block__git_helper__commit)" \
      && result+="%F{${BLOX_BLOCK__GIT_COMMIT_COLOR}}${BLOX_CONF__BLOCK_PREFIX}${commit_hash}${BLOX_CONF__BLOCK_SUFFIX}%f"

    result+="${branch_status}"
    result+="${stashed_status}"
    result+="${remote_status}"
    result+="${short_status}"

    echo $result
  fi
}

function blox_block__git_repo_name() {
    blox_block__git_helper__is_git_repo || return 0
    repo=$( basename $(git config --get remote.origin.url) | sed -e 's/\.git$//' 2> /dev/null )

    blox_helper__build_block \
        "${BLOX_BLOCK__GIT_REPO_COLOR}" \
        "${BLOX_BLOCK__GIT_REPO_SYMBOL} ${repo}"
}
