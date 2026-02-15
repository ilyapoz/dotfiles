function preexec {
  # Update env from tmux
  [[ -o interactive ]] || return
  [[ "$TMUX" != "" ]] || return
  eval $(tmux show-environment -s)
}
