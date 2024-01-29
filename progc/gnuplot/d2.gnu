#!/usr/bin/gnuplot -persist
# Définit le titre, les étiquettes des axes x et y, et la sortie
set title 'Top 10 des conducteurs ayant parcouru la plus grande distance'
set xlabel 'Distance parcourue (km)'
set ylabel 'Nom'
set output './images/d2_image.png'
set key noenhanced

# Définit le terminal pour utiliser pngcairo, avec la new roman en taille 0.8
# et une taille d'image de 1920x1080
set terminal pngcairo enhanced font "Times New Roman,20" size 1920,1080
# Indique que le séparateur de données est le point-virgule dans notre fichier
set datafile separator ';'

# Pour démarrer de 0 à auto, [0<*:*] est de 0 minimal auto à auto
set xrange [0<*:*]

# Nomirror est utilisé pour éviter les traits des deux côtés du graphique
# Configure une marque sur l'axe Y toutes les 1 unité
set ytics 1 nomirror
# Configure une marque sur l'axe X automatiquement
set xtics autofreq nomirror

# Style de la ligne, avec couleur et épaisseur
set style line 100 lc rgb "grey" lw 0.3
# Active la grille avec le style de ligne que nous avons défini
set grid ls 100

# Configure le style des boîtes (boxes) avec couleur, largeur et bordure
set style fill solid 1.0 border lt -1

# Variables pour configurer la largeur des boîtes
myBoxWidth = 0.5
# Variable pour configurer l'offset des boîtes
myOffset = 0.5
# Configure l'offset
set offsets 0,0,myOffset-myBoxWidth/2.,myOffset

# Trace les données horizontalement en utilisant boxxy
# Nous dessinons des rectangles aux coordonnées données : 0 en X, offset fois la ligne lue,
# pour la même ligne en X à l'offset vers le haut pour la largeur, la longueur de la valeur des données
# lc var détermine automatiquement la couleur, notitle masque le titre de couleur différente
plot './temp/d2_argument_top10.csv' using (myOffset*$2):0:(myOffset*$2):(myBoxWidth/2.):($0+1):ytic(1) with boxxy lc var notitle

