#!/usr/bin/env sh

INSOMNIA="$([ -f "$HOME/.local/state/no-suspend" ] && echo 'true' || echo 'false')"

# Don't lock while I'm trying to rebuild
touch "$HOME/.local/state/no-lock"

# Don't suspend while I'm trying to rebuild
touch "$HOME/.local/state/no-suspend"

2>&1 unbuffer home-manager switch "$@" | tee /tmp/home-manager.log

if ! "$INSOMNIA"; then
  rm -f "$HOME/.local/state/no-suspend"
fi

rm -f "$HOME/.local/state/no-lock"
