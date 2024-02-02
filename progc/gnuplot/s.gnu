#!/usr/bin/gnuplot -persist
# Définition du titre du graphique
set title 'Longueur de section pour chaque itinéraire'
# Définition des étiquettes des axes
set xlabel 'ID de l\'itinéraire'
set ylabel 'Distances (km)'
# Définition du fichier de sortie pour l'image du graphique
set output './images/s_image.png'
# Désactivation de la légende (key)
set key noenhanced

# Définition du terminal en tant que pngcairo, avec la police Arial de taille 20
# et une taille d'image de 1920x1080 pixels
set terminal pngcairo enhanced font "arial,20" size 1920,1080
# Indication que le séparateur de données dans notre fichier est le point-virgule (;)
set datafile separator ';'

# Début de la section pour définir les plages d'axes, à partir de 0 pour la valeur minimale
# Les autres plages sont calculées automatiquement
# set yrange [0<*:0<*]  
# set xrange [0<*:0<*] 

# Définition automatique des plages pour chaque axe (x et x2, ainsi que y et y2)
# cbrnage est la palette de couleurs, rrange est utilisé pour définir la plage radiale en mode polaire
set xrange [ * : * ] noreverse writeback
set x2range [ * : * ] noreverse writeback
set yrange [ * : * ] noreverse writeback
set y2range [ * : * ] noreverse writeback
set cbrange [ * : * ] noreverse writeback
set rrange [ * : * ] noreverse writeback

# Utilisation de nomirror pour éviter les graduations sur les deux côtés du graphique
# Définition automatique des graduations sur l'axe y
set ytics autofreq
# Définition automatique des graduations sur l'axe x, avec rotation de l'étiquette de 90 degrés vers la droite
set xtics autofreq nomirror rotate by 90 right

# Définition du style de ligne avec couleur et épaisseur
set style line 100 lc rgb "grey" lw 0.5
# Activation de la grille avec le style de ligne défini précédemment
set grid ls 100

# (2*$0+1):2 est utilisé pour définir en x la valeur du numéro de ligne en cours de lecture,
# et en y la valeur du deuxième champ (pour la fonction lines)
# (2*$0+1):3:4 est utilisé pour utiliser le numéro de ligne en cours de lecture en tant que x,
# et pour remplir entre les valeurs y fournies par le troisième et quatrième champ (pour la fonction filled curves)
# lt -1 définit la couleur en noir, lw 2 définit l'épaisseur de la ligne
# lc rgb définit une couleur en utilisant les règles RGB 
# title définit le titre pour les fonctions utilisées (ligne et courbe remplie ici)

plot './temp/s_argument_resultat.csv' using (2*$0+1):2:xticlabel(1) with lines lt -1 lw 2 title 'Moyenne', \
    '' using (2*$0+1):3:4 with filledcurve lc rgb "#80FF8080" title 'Min/Max'

