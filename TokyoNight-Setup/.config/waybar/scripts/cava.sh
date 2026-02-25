#!/usr/bin/env bash
# Waybar Cava (pipewire) - sortie TOUJOURS visible

CFG="/tmp/waybar_cava.conf"

cat >"$CFG" <<'EOF'
[general]
bars = 14
framerate = 120
autosens = 1
sensitivity = 150

[input]
method = pipewire
source = auto

[output]
method = raw
raw_target = /dev/stdout
data_format = ascii
ascii_max_range = 7
bar_delimiter = 0
EOF

# Map 0-7 vers des barres, et si silence -> points
cava -p "$CFG" | while IFS= read -r line; do
  out="$line"
  out="${out//0/ }"
  out="${out//1/▁}"
  out="${out//2/▂}"
  out="${out//3/▃}"
  out="${out//4/▄}"
  out="${out//5/▅}"
  out="${out//6/▆}"
  out="${out//7/▇}"

  # Si ça ne contient que des espaces → fallback visible
  if [[ -z "${out// /}" ]]; then
    out="············"
  fi

  # Préfixe constant => le module a toujours une largeur
  echo "󰎆  $out"
done
