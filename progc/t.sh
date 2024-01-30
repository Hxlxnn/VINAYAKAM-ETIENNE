#!/bin/bash

repertoireTemp="./temp"
mkdir -p "$repertoireTemp"
fichier_resultat="$repertoireTemp/resultat.txt"
fichier_final="$repertoireTemp/t_resultat.csv"
#Début chronomètre
temps_debut=$(date +%s.%N)
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

# Vérifier si la compilation a réussi
if [ $? -eq 0 ]; then
    echo "Compilation réussie. Exécution du programme..."

    # Exécuter le programme C + insertion des dponnées de sortie dans le fichier résultat
    ./t > "$fichier_final"

    # Vérifier si l'exécution s'est terminée avec succès
    if [ $? -eq 0 ]; then
        echo "Exécution réussie. Création du graphe." //création du graphe à rajouter
    else
        echo "Erreur lors de l'exécution du programme."
    fi

else
    echo "Erreur lors de la compilation du programme C."
fi
temps_fin=$(date +%s.%N)

# Calculez la durée de traitement en secondes
duree_traitement=$(echo "$temps_fin - $temps_debut" | bc)


# Affichez la durée de traitement
echo "Le traitement t a pris $duree_traitement secondes pour s'exécuter."

#RAJOUTER création courbe

