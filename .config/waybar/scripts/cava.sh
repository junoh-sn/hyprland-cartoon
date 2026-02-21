#!/usr/bin/env bash
bars=(▁ ▂ ▃ ▄ ▅ ▆ ▇ █)

cfg="$(mktemp)"
cat >"$cfg" <<'EOF'
[general]
bars = 14

[input]
method = pulse
source = auto

[output]
method = raw
raw_target = /dev/stdout
data_format = ascii
ascii_max_range = 7
bar_delimiter = 59
frame_delimiter = 10
EOF

trap 'rm -f "$cfg"; pkill -P $$ cava 2>/dev/null' EXIT

cava -p "$cfg" 2>/dev/null | while read -r line; do
  line="${line//;/ }"

  out=""
  max=0

  for n in $line; do
    case "$n" in '' | *[!0-9]*) n=0 ;; esac
    ((n < 0)) && n=0
    ((n > 7)) && n=7
    ((n > max)) && max=$n
    out+="${bars[n]}"
  done

  if ((max <= 2)); then
    cls="low"
  elif ((max <= 5)); then
    cls="mid"
  else
    cls="high"
  fi

  printf '{"text":"%s","class":"%s","tooltip":false}\n' "$out" "$cls"
done
