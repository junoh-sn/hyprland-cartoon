#!/bin/bash

# Compter les mises à jour officielles (nécessite pacman-contrib)
updates_arch=$(checkupdates 2>/dev/null | wc -l)

# Compter les mises à jour AUR
updates_aur=$(yay -Qua 2>/dev/null | wc -l)

# Prévention des erreurs si la commande ne renvoie rien
updates_arch=${updates_arch:-0}
updates_aur=${updates_aur:-0}

total=$((updates_arch + updates_aur))

if [ "$total" -gt 0 ]; then
  tooltip="Mises à jour: $total\nArch: $updates_arch\nAUR: $updates_aur"
  class="pending"
else
  tooltip="Système à jour"
  class="updated"
fi

# Sortie au format JSON strict attendu par Waybar
printf '{"text": "%s", "tooltip": "%s", "class": "%s"}\n' "$total" "$tooltip" "$class"
