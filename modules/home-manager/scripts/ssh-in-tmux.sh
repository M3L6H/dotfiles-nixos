#!/usr/bin/env sh

if [ -n "$TMUX" ]; then
  tmux detach -E "ssh $*"
else
  ssh "$@"
fi
