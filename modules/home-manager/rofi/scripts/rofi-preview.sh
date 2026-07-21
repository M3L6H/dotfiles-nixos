#!/usr/bin/env bash

mkdir -p ~/.config/rofi/images
[ -f "$1" ] && ln -sf "$1" ~/.config/rofi/images/preview.png
