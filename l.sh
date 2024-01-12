#!/bin/bash

# Assurez-vous que le chemin vers votre fichier est correct
cheminFichier="data.csv"

if [[ ! -f "$cheminFichier" ]]; then
    echo "Le fichier $cheminFichier n'existe pas. Veuillez vérifier le chemin du fichier."
    exit 1
fi


echo "l arg trouvé"
# Besoin de trier par l'ID de trajet
# Additionner la distance de chaque étape
# Afficher les 10 premiers avec les distances et l'ID pour créer le graphique

# Séparer les champs avec ;, créer un tableau sum[route ID] += distance, puis imprimer chaque route ID avec sa somme (avec 3 décimales)
echo "Somme des distances des trajets..."
LC_NUMERIC=C awk -F';' 'NR>1{sum[$1]+=$5} END{for(i in sum) printf "%.6f;%s\n", sum[i], i}' ${cheminFichier} >"./temp/l_argument_sum.csv"

# Trier les valeurs selon le premier champ (longueur), uniquement numérique, et en ordre inversé pour avoir les plus longues au sommet
echo "Tri de la longueur des trajets..."
sort -t';' -k1nr "./temp/l_argument_sum.csv" >"./temp/sorted_l_argument_sum.csv"

echo "Tri des ID de trajets..."
# Obtenir les 10 trajets les plus longs
head -10 "./temp/sorted_l_argument_sum.csv" >"./temp/l_argument_top10.csv"
# Et les trier par ID
sort -t';' -k2nr "./temp/l_argument_top10.csv" >"./temp/l_argument_top10_finish.csv"
# Pour afficher les 10 premiers
cat "./temp/l_argument_top10_finish.csv"

#echo "Création du graphique..."
#gnuplot ./progc/gnuplot/l_script.gnu
echo -e "Terminé.\n"
#;;



