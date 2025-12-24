#!/bin/sh

DIR="${HOME}/.local/share/state/playerctl"

mkdir -p "$DIR" >/dev/null 2>&1

if [ -f "${DIR}/last-volume" ]; then
  playerctl volume "$(cat "${DIR}/last-volume")"
  rm "${DIR}/last-volume"
else
  playerctl volume >"${DIR}/last-volume"
  playerctl volume 0
fi
