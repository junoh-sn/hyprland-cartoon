import sys
import os

# Liste des caractères Nerd Font pour les barres (du plus bas au plus haut)
bars = [" ", " ", "▂", "▃", "▄", "▅", "▆", "▇", "█"]

def main():
    # Lance cava avec la config spéciale qu'on a créée
    command = "cava -p ~/.config/cava/config_waybar"
    process = os.popen(command)

    while True:
        line = process.readline().strip()
        if not line:
            break
            
        # Transforme les nombres de cava en symboles visuels
        output = ""
        for char in line.split(";"):
            if char:
                val = int(char)
                output += bars[val]
        
        # Envoie le résultat à Waybar
        print(output)
        sys.stdout.flush()

if __name__ == "__main__":
    main()
