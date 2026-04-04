#!/bin/bash
if [ -d /proc/sys/net/ipv4/conf/tun0 ]; then
  echo '{"text":"●", "class":"connected", "tooltip":"VPN Connecté"}'
else
  echo '{"text":"●", "class":"disconnected", "tooltip":"VPN Déconnecté"}'
fi
