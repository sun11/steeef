# vim:et sts=2 sw=2 ft=zsh
#
# A customizable version of the steeef theme from
# https://github.com/robbyrussell/oh-my-zsh/blob/master/themes/steeef.zsh-theme
#
# Requires the `git-info` zmodule to be included in the .zimrc file.

# use extended color palette if available
if (( terminfo[colors] >= 256 )); then
  : ${USER_COLOR=135}
  : ${HOST_COLOR=166}
  : ${PWD_COLOR=118}
  : ${BRANCH_COLOR=81}
  : ${DIRTY_COLOR=166}
  : ${CLEAN_COLOR=118}
else
  : ${USER_COLOR=magenta}
  : ${HOST_COLOR=yellow}
  : ${PWD_COLOR=green}
  : ${BRANCH_COLOR=cyan}
fi
: ${CLEAN_COLOR=green}
: ${DIRTY_COLOR=yellow}
# VIRTUAL_ENV_DISABLE_PROMPT=1

setopt nopromptbang prompt{cr,percent,sp,subst}

typeset -gA git_info
if (( ${+functions[git-info]} )); then
  zstyle ':zim:git-info' verbose yes
  zstyle ':zim:git-info:branch' format '%b'
  zstyle ':zim:git-info:commit' format '%c'
  zstyle ':zim:git-info:action' format '(%F{${INDEXED_COLOR}}%s%f)'
  local git_dirty=${(e)git_info[dirty]}
  if [[ -n ${git_dirty} ]]; then
    git_color=${DIRTY_COLOR}
  else
    git_color=${CLEAN_COLOR}
  fi
  zstyle ':zim:git-info:dirty' format '%F{${git_color}}±'
  if [[ -n ${STASHED_IND} ]]; then
    zstyle ':zim:git-info:stashed' format '%F{${STASHED_COLOR}}${STASHED_IND}'
  fi
  zstyle ':zim:git-info:keys' format \
      'prompt' ' (%F{${BRANCH_COLOR}}%b%c%I%i%u%f%S%f)%s'

  autoload -Uz add-zsh-hook && add-zsh-hook precmd git-info
fi

PS1='%F{${USER_COLOR}}%n%f@%F{${HOST_COLOR}}%m%f:%F{${PWD_COLOR}}%~%f${(e)git_info[prompt]}${CONDA_DEFAULT_ENV:+" (%F{blue}${CONDA_DEFAULT_ENV:t}%f)"}
%(!.#.$) '
unset RPS1
