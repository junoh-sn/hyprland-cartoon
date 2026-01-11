#!/bin/bash
THEMES_DIR="$HOME/.config/waybar/themes"
choice=$(ls $THEMES_DIR | wofi --dmenu --hide-scroll --columns 2 --width 400 --height 100 --style ~/.config/wofi/style.css)
if [ -n "$choice" ]; then
  ln -sf "$THEMES_DIR/$choice/style.css" "$HOME/.config/waybar/style.css"
  killall -SIGUSR2 waybar
  notify-send "Thème $choice appliqué !"
fi
