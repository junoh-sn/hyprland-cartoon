#!/bin/bash
# Se déplace dans le bon dossier pour éviter l'erreur "fatal : pas un dépôt git"
cd ~/Documents/Sauvegarde_Setup_Janvier

# Ajoute tous les nouveaux fichiers (en rouge dans ton git status)
git add .

# Crée la sauvegarde avec la date et l'heure
git commit -m "Sauvegarde Setup Mauve : $(date +'%d/%m/%Y %H:%M')"

# Envoie vers GitHub
git push

# Affiche une notification sur ton bureau
notify-send -i "github" "" GitHub à jour" "Tes fichiers CSS et scripts sont en sécurité."
