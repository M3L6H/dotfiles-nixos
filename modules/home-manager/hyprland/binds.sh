#!/usr/bin/env bash

binds="$(hyprctl binds | awk -v RS='bindd' -F '\n' 'BEGIN{OFS="\t"} { for(i=2; i<=7; i++) sub(/^[^:]+: /, "", $i); print $2, $4, $7; }')"

opts="$(echo "$binds" | awk -F '\t' '$2 != "" {
  flags = int($1);
  while (flags > 0) {
    if (flags >= 128) {
      printf "MOD5";
      flags -= 128;
    } else if (flags >= 64) {
      printf "SUPER";
      flags -= 64;
    } else if (flags >= 32) {
      printf "MOD3";
      flags -= 32;
    } else if (flags >= 16) {
      printf "MOD2";
      flags -= 16;
    } else if (flags >= 8) {
      printf "ALT";
      flags -= 8;
    } else if (flags >= 4) {
      printf "CTRL";
      flags -= 4;
    } else if (flags >= 2) {
      printf "CAPS";
      flags -= 2;
    } else if (flags >= 1) {
      printf "SHIFT";
      flags -= 1;
    }
    printf "+";
  }
  printf "%s  %s\n", $2, $3;
}')"

echo "$opts" | rofi -dmenu -i -p 'Keybinds'
