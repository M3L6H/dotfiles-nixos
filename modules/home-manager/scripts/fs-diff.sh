#!/usr/bin/env bash
# Taken from https://mt_caret.github.io/blog/posts/2020-06-29-optin-state.html
# Usage: fs-diff /mnt/@home true true

VOLUME="${1:-/mnt/@}"
SAVE_DIFF="${2:-false}"
WITH_TIMESTAMPS="${3:-false}"

SKIP_DIRS="${HOME}/.cache"

OLD_TRANSID="$(btrfs subvolume find-new "${VOLUME}-blank" 9999999)"
OLD_TRANSID="${OLD_TRANSID#transid marker was }"

new_diff="/persist/$(basename "$VOLUME")-new-diff"

[ -f "$new_diff" ] && rm "$new_diff"

btrfs subvolume find-new "$VOLUME" "$OLD_TRANSID" |
sed '$d' |
cut -f17- -d' ' |
sort |
uniq |
while read path; do
  path="/${path}"
  if [ -L "$path" ]; then
    : # Ignore symbolic links, since they are likely from nixos anyway
  elif [ -d "$path" ]; then
    : # Ignore directories
  else
    skip='false'
    for d in $SKIP_DIRS; do
      if case "$path" in "$d"*) ;; *) false;; esac; then
        skip='true'
        break
      fi
    done
    if [ "$skip" != 'true' ]; then
      if [ "$SAVE_DIFF" != 'true' ] && [ "$WITH_TIMESTAMPS" != 'true' ]; then
        echo "${path}"
      else
        echo "${path} $(date -r "$path" '+%s')"
      fi
    fi
  fi
done > "$new_diff"

old_diff="/persist/$(basename "$VOLUME")-old-diff"

if [ -f "$old_diff" ]; then
  if [ "$WITH_TIMESTAMPS" = 'true' ]; then
    git diff --no-index "$old_diff" "$new_diff"
  else
    awk '{ print $1; }' "$old_diff" > "${old_diff}-no-timestamps"
    awk '{ print $1; }' "$new_diff" > "${new_diff}-no-timestamps"
    git diff --no-index "${old_diff}-no-timestamps" "${new_diff}-no-timestamps"
    rm "${old_diff}-no-timestamps" "${new_diff}-no-timestamps"
  fi
else
  if [ "$WITH_TIMESTAMPS" = 'true' ]; then
    less "$new_diff"
  else
    awk '{ print $1; }' "$new_diff" | less
  fi
fi

[ "$SAVE_DIFF" = 'true' ] && mv "$new_diff" "$old_diff" || rm "$new_diff"

