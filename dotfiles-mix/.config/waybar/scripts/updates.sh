#!/usr/bin/env bash

# ---------- Configuration ----------
MAX_LINES=15 # Nb max de paquets listés dans le tooltip
TRUNC_LEN=32 # Longueur max du nom de paquet

# ---------- Repos officiels (pacman via checkupdates) ----------
updates_arch="$(checkupdates 2>/dev/null || true)"
count_arch=$(printf '%s\n' "$updates_arch" | grep -c '^[^[:space:]]' || echo 0)

# ---------- AUR via yay ----------
if command -v yay >/dev/null 2>&1; then
  # yay -Qum : montre uniquement les paquets AUR à mettre à jour, sans -Sy (donc pas de partial upgrade).[web:160]
  updates_aur="$(yay -Qum 2>/dev/null || true)"
  count_aur=$(printf '%s\n' "$updates_aur" | grep -c '^[^[:space:]]' || echo 0)
else
  updates_aur=""
  count_aur=0
fi

total=$((count_arch + count_aur))

# ---------- Aucun update ----------
if [ "$total" -eq 0 ]; then
  printf '{ "text": "", "tooltip": "", "class": "updated" }\n'
  exit 0
fi

# ---------- Construction du tooltip ----------
tooltip="<b>Mises à jour : ${total}</b>\n"

if [ "$count_arch" -gt 0 ]; then
  tooltip="${tooltip}\n<span color=\"#7aa2ff\"><b>➤ Arch Linux (${count_arch})</b></span>\n"
  tooltip="${tooltip}$(printf '%s\n' "$updates_arch" |
    head -n "$MAX_LINES" |
    awk -v len="$TRUNC_LEN" '
        {
          pkg=$1;
          if (length(pkg) > len) pkg = substr(pkg,1,len-1)"…";
          printf " • %s\n", pkg
        }
      ')"
fi

if [ "$count_aur" -gt 0 ]; then
  tooltip="${tooltip}\n\n<span color=\"#bb9af7\"><b>➤ AUR (${count_aur})</b></span>\n"
  tooltip="${tooltip}$(printf '%s\n' "$updates_aur" |
    head -n "$MAX_LINES" |
    awk -v len="$TRUNC_LEN" '
        {
          pkg=$1;
          if (length(pkg) > len) pkg = substr(pkg,1,len-1)"…";
          printf " • %s\n", pkg
        }
      ')"
fi

# ---------- Sortie JSON Waybar ----------
printf '{ "text": "%s", "tooltip": "%s", "class": "has-updates" }\n' "$total" "$tooltip"
