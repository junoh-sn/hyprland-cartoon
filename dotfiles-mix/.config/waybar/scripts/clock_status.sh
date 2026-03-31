#!/usr/bin/env bash

hour=$(date +%H)

if [ "$hour" -ge 7 ] && [ "$hour" -lt 19 ]; then
  class="day"
else
  class="night"
fi

time=$(date +"%H:%M")

printf '{ "text": "%s", "class": "%s" }\n' "$time" "$class"
