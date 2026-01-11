#!/bin/bash

# 1. Récupération de l'IP Publique (avec un timeout de 2s pour ne pas bloquer la barre si pas de net)
RAW_IP=$(curl -s --max-time 2 https://api.ipify.org)

# 2. Masquage propre : On garde les 2 premiers blocs et on cache la fin
# Ex: 88.124.12.14 devient 88.124.*.*
MASKED_IP=$(echo "$RAW_IP" | awk -F. '{print $1"."$2".*.*"}')

# 3. Vérification de la connexion VPN (interface tun0)
if ip addr show tun0 2>/dev/null | grep -q "inet"; then
  # --- CONNECTÉ (VPN) ---
  ICON=""
  CLASS="connected"
  # Affichage : Cadenas fermé + IP masquée
  TEXT="$ICON  $MASKED_IP"
  # Au survol : On affiche "VPN Connecté" et l'IP réelle
  TOOLTIP="VPN Sécurisé\nIP: $RAW_IP"
else
  # --- DÉCONNECTÉ (Standard) ---
  ICON=""
  CLASS="disconnected"
  # Affichage : Cadenas ouvert + IP masquée
  TEXT="$ICON  $MASKED_IP"
  # Au survol : Attention
  TOOLTIP="⚠ VPN Déconnecté\nIP Publique: $RAW_IP"
fi

# Sortie JSON pour Waybar
echo "{\"text\": \"$TEXT\", \"class\": \"$CLASS\", \"tooltip\": \"$TOOLTIP\"}"
