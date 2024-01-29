#!/usr/bin/gnuplot -persist
# Spécifie l'emplacement de l'interpréteur de script Gnuplot.

# Définit le titre du graphique.
set title 'Top 10 des plus longues routes'

# Définit le label de l'axe x.
set xlabel 'ID de la route'

# Définit le label de l'axe y.
set ylabel 'Distances (km)'

# Définit le fichier de sortie pour l'image générée.
set output './images/l_image.png'

# Désactive la légende (la clé) dans le graphique.
set key noenhanced

# Configure le terminal de sortie pour générer une image PNG avec la police "Times New Roman" de taille 20.
set terminal pngcairo enhanced font "Times News Roman,20" size 1920,1080

# Indique que le séparateur de données dans le fichier est le point-virgule.
set datafile separator ';'

# Définit la plage de valeurs sur l'axe y entre 0 et 2000, avec la valeur maximale déterminée automatiquement.
set yrange [0<*<2000:*]

# Configure les graduations automatiques sur l'axe y.
set ytics autofreq

# Configure les graduations sur l'axe x avec un intervalle de 1 unité.
set xtics 1 nomirror

# Définit le style de ligne avec une couleur grise et une épaisseur de 0.5.
set style line 100 lc rgb "grey" lw 0.5

# Active la grille avec le style de ligne défini précédemment.
set grid ls 100

# Configure le style des boîtes avec une couleur pleine, une largeur de bordure de 1.0 et une couleur de bordure qui est vert.
set style fill solid 1.0 border lc rgb "green"


# Configure la largeur des boîtes à 0.5, de manière relative.
set boxwidth 0.5 relativ

# Trace le graphique en utilisant les données du fichier CSV spécifié, avec les boîtes, en utilisant la deuxième colonne pour l'axe x et la première colonne pour l'axe y, avec des étiquettes sur l'axe x.
plot './temp/l_argument_top10_finish.csv' u (2*$0+1):1:xticlabel(2) with boxes notitle
