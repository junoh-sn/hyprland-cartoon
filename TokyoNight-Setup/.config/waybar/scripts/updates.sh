#!/usr/bin/env bash

# -- Configuration --
# Nombre max de paquets à afficher dans le tooltip
MAX_LINES=15
# Tronquer les noms trop longs (pour l'esthétique)
TRUNC_LEN=25

# Récupération des mises à jour (silencieux)
updates_arch=$(checkupdates 2>/dev/null)
count_arch=$(echo "$updates_arch" | grep -c . || echo 0)

updates_aur=$(yay -Qua 2>/dev/null)
count_aur=$(echo "$updates_aur" | grep -c . || echo 0)

total=$((count_arch + count_aur))

# Si 0 update, JSON vide mais valide (ou texte vide pour cacher le module)
if [ "$total" -eq 0 ]; then
  echo '{"text": "", "tooltip": ""}'
  exit 0
fi

# Construction du tooltip
tooltip="<b>Mises à jour : ${total}</b>\n"

if [ "$count_arch" -gt 0 ]; then
  tooltip+="<span color='#7aa2f7'><b>Arch Linux ($count_arch)</b></span>\n"
  tooltip+=$(echo "$updates_arch" | head -n $MAX_LINES | awk -v len=$TRUNC_LEN '{
        pkg=$1; ver=$2 " -> " $4;
        if (length(pkg) > len) pkg=substr(pkg,1,len-2)"..";
        printf "📦 %-20s %s\\n", pkg, ver
    }')
  tooltip+="\n"
fi

if [ "$count_aur" -gt 0 ]; then
  tooltip+="\n<span color='#bb9af7'><b>AUR ($count_aur)</b></span>\n"
  tooltip+=$(echo "$updates_aur" | head -n $MAX_LINES | awk -v len=$TRUNC_LEN '{
        pkg=$1; ver=$2 " -> " $4;
        if (length(pkg) > len) pkg=substr(pkg,1,len-2)"..";
        printf "󰣇 %-20s %s\\n", pkg, ver
    }')
fi

# Échappement JSON via Python pour éviter les plantages sur caractères spéciaux
json_tooltip=$(python3 -c "import json, sys; print(json.dumps(sys.stdin.read()))" <<<"$tooltip")

# On retire les guillemets externes ajoutés par json.dumps car on l'insère dans un template JSON
json_tooltip=${json_tooltip:1:-1}

echo "{\"text\":\"󰏗 $total\", \"tooltip\":\"$json_tooltip\", \"class\":\"updates\"}"
