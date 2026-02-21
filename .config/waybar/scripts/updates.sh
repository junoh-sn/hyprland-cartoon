#!/usr/bin/env bash
set -euo pipefail

repo_list="$(checkupdates 2>/dev/null || true)"
repo_count="$(printf '%s\n' "$repo_list" | sed '/^$/d' | wc -l | tr -d ' ')"

aur_list="$(yay -Qum 2>/dev/null || true)"
aur_count="$(printf '%s\n' "$aur_list" | sed '/^$/d' | wc -l | tr -d ' ')"

total=$((repo_count + aur_count))

# Tooltip avec \r (Waybar préfère \r à \n pour les tooltips JSON)
nl=$'\r'
tooltip="Pacman: ${repo_count}${nl}AUR: ${aur_count}"

if [ "$repo_count" -gt 0 ]; then
  tooltip="${tooltip}${nl}${nl}--- Pacman ---${nl}$(printf '%s\n' "$repo_list" | head -n 30 | sed ':a;N;$!ba;s/\n/\r/g')"
fi
if [ "$aur_count" -gt 0 ]; then
  tooltip="${tooltip}${nl}${nl}--- AUR ---${nl}$(printf '%s\n' "$aur_list" | head -n 30 | sed ':a;N;$!ba;s/\n/\r/g')"
fi

# JSON simple (class = STRING, pas tableau)
if [ "$total" -eq 0 ]; then
  text=" 0"
  class="updates none"
elif [ "$total" -lt 25 ]; then
  text="󰏔 ${total} (${repo_count}/${aur_count})"
  class="updates low"
else
  text="󰏔 ${total} (${repo_count}/${aur_count})"
  class="updates high"
fi

# printf direct (évite Python heredoc complexe)
printf '{"text": "%s", "tooltip": "%s", "class": "%s"}\n' \
  "$text" "$(echo "$tooltip" | sed 's/"/\\"/g;s/\r/\\r/g')" "$class"
