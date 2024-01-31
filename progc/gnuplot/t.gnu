#!/usr/bin/gnuplot -persist
set title 'Top 10 des villes les plus traversées'
set xlabel 'Noms des villes'
set ylabel 'Quantité'
set output './images/t_image.png'
set key noenhanced

# Définir le terminal pour utiliser pngcairo, avec la police Times News Roman en taille 0.8
# et une taille d'image de 1920x1080
set terminal pngcairo enhanced font "Times News Roman,20" size 1920,1080
# Indiquer que le séparateur de données est la virgule dans notre fichier
set datafile separator ','

# Définir la plage y de 0 à la valeur maximale rencontrée dans les données
set yrange [0:*]

# Autoriser l'ajustement automatique de l'axe x
set auto x

# Faire pivoter les noms des colonnes de 45°
set xtics rotate by -45

# Définir le style des données
set style data histogram
set style histogram cluster gap 1

# Définir la couleur de la bordure des colonnes
set style fill solid border rgb "black"

# Définir les couleurs de remplissage des colonnes
set colorbox vertical origin screen 0.9, 0.2 size screen 0.05, 0.6 front noinvert bdefault

# Tracer par groupes de 2 colonnes
plot './temp/t_resultat.csv' using 2:xtic(1) title "Quantité traversée", \
        '' using 3:xtic(1) title "Quantité de départs de route"

