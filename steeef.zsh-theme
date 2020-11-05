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
  local git_color
  local git_dirty=${(e)git_info[dirty]}
  if [[ -n ${git_dirty} ]]; then
    git_color=${DIRTY_COLOR}
  else
    git_color=${CLEAN_COLOR}
  fi

  zstyle ':zim:git-info' verbose no
  zstyle ':zim:git-info:branch' format '%b'
  zstyle ':zim:git-info:commit' format '%c'
  zstyle ':zim:git-info:action' format '(%F{${CLEAN_COLOR}}%s%f)'
  zstyle ':zim:git-info:unindexed' format '%F{${DIRTY_COLOR}'
  zstyle ':zim:git-info:indexed' format '%F{${CLEAN_COLOR}}±'
  zstyle ':zim:git-info:keys' format \
      'prompt' ' (%F{${BRANCH_COLOR}}%b%c%f%I%i%f)%s%f'

  autoload -Uz add-zsh-hook && add-zsh-hook precmd git-info
fi

PS1='%F{${USER_COLOR}}%n%f at %F{${HOST_COLOR}}%m%f in %F{${PWD_COLOR}}%~%f${(e)git_info[prompt]}${CONDA_DEFAULT_ENV:+" (%F{blue}${CONDA_DEFAULT_ENV:t}%f)"}
%(!.#.$) '
unset RPS1