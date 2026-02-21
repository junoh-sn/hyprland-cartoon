#!/usr/bin/env bash
# GTX 4070 stats
data=$(nvidia-smi --query-gpu=utilization.gpu,temperature.gpu,memory.used,memory.total --format=csv,noheader,nounits)

read gpu_util temp mem_used mem_total <<<"$data"

mem_perc=$((mem_used * 100 / mem_total))
tooltip="GPU: ${gpu_util}%\nTemp: ${temp}°C\nVRAM: ${mem_used}/${mem_total}MiB (${mem_perc}%)"

if [ "$gpu_util" -gt 80 ]; then
  state="high"
elif [ "$temp" -gt 75 ]; then
  state="med"
else
  state="low"
fi

printf '{"text": "󰒡 %s%% %s°", "tooltip": "%s", "class": "nvidia %s", "alt": "󰒡"}' \
  "$gpu_util" "$temp" "$tooltip" "$state"
