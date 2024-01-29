#!/bin/bash

repertoireTemp="./temp"
mkdir -p "$repertoireTemp"
fichier_resultat="$repertoireTemp/resultat.txt"
fichier_final="$repertoireTemp/t_resultat.csv"
awk -F";" '
BEGIN {
    # Définir le séparateur de sortie comme une virgule
    OFS = ",";
}
{
    villes[$3]++;
    villes[$4]++;
    departs[$3]++;
}
END {
    PROCINFO["sorted_in"] = "@ind_str_asc";  # Utiliser un tableau associatif trié par ordre alphabétique
    
    # Créer un tableau pour stocker les résultats
    # Chaque élément est un tableau [ville, total, depart]
    for (ville in villes) {
        total = villes[ville]; # Nombre de fois où la ville apparait dans une ligne du csv
        depart = departs[ville]; # Nombre de fois que c\‘est une ville de départ
        villesTriees[ville] = total - depart; # Nombre de fois où la ville est traversée
    }

    # Trier manuellement les 10 villes les plus traversées
    for (i = 1; i <= 10; i++) {
        max = -1;
        for (ville in villesTriees) {
            if (villesTriees[ville] > max) {
                max = villesTriees[ville];
                maxVille = ville;
            }
        }
        if (maxVille != "") {
            # print maxVille, villes[maxVille], departs[maxVille];
            print maxVille, villesTriees[maxVille], departs[maxVille];
            delete villesTriees[maxVille];
        }
    }
}
' data.csv > "$fichier_resultat"
#compilation du programme C
gcc -o t t.c

#exécution du programme C
./t > "$fichier_final"


#RAJOUTER création courbe

