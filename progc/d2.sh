#!/bin/bash
output_dir="./images"
# Chemin vers le fichier de données
cheminFichier="data.csv"

if [[ ! -f "$cheminFichier" ]]; then
    echo "Le fichier $cheminFichier n'existe pas. Veuillez vérifier le chemin du fichier."
    exit 1
fi

# Suite du script inchangée...
temps_debut=$(date +%s.%N)

echo "d2 arg trouvé"
# Besoin de trier par le nom du conducteur
# Puis ajouter chaque distance
# Afficher les 10 premiers avec les distances pour créer le graphique

# Séparer les champs avec ;, créer un tableau sum[route ID] += distance, puis imprimer chaque route ID avec sa somme (avec 3 décimales)
echo "Somme des distances par conducteur..."
LC_NUMERIC=C awk -F';' 'NR>1{sum[$6]+=$5} END{for(i in sum) printf "%s;%.6f\n", i, sum[i]}' ${cheminFichier} >"./temp/d2_argument_sum.csv"

# Trier les valeurs selon le deuxième champ (longueur), uniquement numérique, et en ordre inversé pour avoir les plus longues au sommet
echo "Tri des trajets par conducteur..."
sort -t';' -k2nr "./temp/d2_argument_sum.csv" >"./temp/sorted_d2_argument_sum.csv"

echo "Tri des conducteurs..."
# Obtenir les 10 premiers trajets les plus longs
head -n 10 "./temp/sorted_d2_argument_sum.csv" >"./temp/d2_argument_top10.csv"

cat "./temp/d2_argument_top10.csv" # Affichage des 10 premiers

 echo "Creating graph..."
echo " on peut voir le graphe dans image"
       
gnuplot ./progc/gnuplot/d2.gnu


#Fin chronomètre
temps_fin=$(date +%s.%N)

# Calculez la durée de traitement en secondes
duree_traitement=$(echo "($temps_fin - $temps_debut)/1" | bc)

# Affichez la durée de traitement
echo "Le traitement d2 a pris $duree_traitement secondes pour s'exécuter."
