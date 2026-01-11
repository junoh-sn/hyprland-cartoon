#!/usr/bin/env python3
import json
import urllib.request
import urllib.error

# Configuration
# Si l'auto-détection bug, mets ta ville entre guillemets, ex: "Paris"
CITY = "Paris" 
LANG = "fr"

def get_weather():
    try:
        url = f"https://wttr.in/{CITY}?format=j1&lang={LANG}"
        
        # --- CORRECTION ICI : On se fait passer pour un navigateur (Mozilla) ---
        req = urllib.request.Request(
            url, 
            headers={'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64)'}
        )
        
        with urllib.request.urlopen(req, timeout=5) as response:
            data = json.loads(response.read().decode())
            
            current = data['current_condition'][0]
            temp = current['temp_C']
            desc = current['lang_fr'][0]['value']
            
            # Icônes simplifiées
            desc_lower = desc.lower()
            icon = ""
            if "soleil" in desc_lower or "clair" in desc_lower: icon = ""
            elif "pluie" in desc_lower: icon = ""
            elif "neige" in desc_lower: icon = ""
            elif "nuage" in desc_lower: icon = ""
            
            text = f"{icon}  {temp}°C"
            tooltip = f"Météo: {desc}\nVille: {CITY or 'Auto'}"
            
            print(json.dumps({'text': text, 'tooltip': tooltip, 'class': 'weather'}))

    except Exception as e:
        # --- DEBUG : On affiche l'erreur exacte dans le terminal ---
        error_msg = str(e)
        print(json.dumps({'text': ' Erreur', 'tooltip': f"Erreur: {error_msg}"}))

if __name__ == "__main__":
    get_weather()

