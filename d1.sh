#!/bin/bash

# Vérification de l'existence du fichier
cheminFichier="data.csv"
if [[ ! -f "$cheminFichier" ]]; then
    echo "Le fichier $cheminFichier n'existe pas. Veuillez vérifier le chemin du fichier."
    exit 1
fi

# Création des répertoires temporaires
repertoireTemp="./temp"
mkdir -p "$repertoireTemp"

# Déclaration des chemins des fichiers temporaires
fichierSomme="$repertoireTemp/d1_argument_sum.csv"
fichierTriee="$repertoireTemp/sorted_d1_argument_sum.csv"
fichierTop10Pre="$repertoireTemp/d1_argument_top10_pre.csv"
fichierTop10="$repertoireTemp/d1_argument_top10.csv"

# Étape de traitement
echo "d1 arg trouvé"
echo "Somme des trajets par conducteur..."
awk -F';' '$2 == 1 {somme[$6]+=1} END{for(i in somme) printf "%s;%d\n", i, somme[i]}' "$cheminFichier" >"$fichierSomme"
echo "Tri des trajets par conducteur..."
sort -t';' -k2nr "$fichierSomme" >"$fichierTriee"
echo "Obtention des 10 conducteurs principaux..."
head -10 "$fichierTriee" >"$fichierTop10Pre"
sort -t';' -k2nr "$fichierTop10Pre" >"$fichierTop10"
cat "$fichierTop10" # Affichage des 10 premiers

# Fin du script...





