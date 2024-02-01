#!/bin/bash



# Créer le dossier "images" s'il n'existe pas déjà
if [ ! -d 'images' ]; then
    # Créer le répertoire
    result=$(mkdir -p 'images')
    if [ $? != 0 ]; then
        echo "Erreur dans la configuration :" $result
    fi
    echo 'Répertoire "images" créé.'
else
    echo 'Le répertoire "images" existe déjà.'
fi

# Nettoyer si le dossier temporaire existe, ou le créer s'il n'existe pas déjà
if [ ! -d './temp' ]; then
    # Créer le répertoire
    result=$(mkdir -p 'temp')
    if [ $? != 0 ]; then
        echo "Erreur dans la configuration :" $result
    fi
    echo 'Répertoire temporaire créé.'
elif [ -n "$(ls "./temp/")" ]; then
    echo 'Le répertoire temporaire existe déjà, nettoyage...'
    oldDir=$(pwd)
    cd "temp"
    rm -r *
    cd "${oldDir}"
    echo 'Terminé.'
else
    echo 'Le répertoire temporaire existe déjà.'
fi

# Créer le répertoire "data" s'il n'existe pas déjà
if [ -d "./data" ]; then
    echo "Le répertoire \"data\" existe."
else
    mkdir -p 'data'
    echo 'Répertoire "data" créé.'
fi

# Créer le répertoire "demo" s'il n'existe pas déjà
if [ -d "./demo/dir/" ]; then
    echo "Le répertoire \"demo\" existe."
else
    mkdir -p 'demo'
    echo 'Répertoire "demo" créé.'
fi
# Vérifie le nombre d'arguments, s'il est nul, quitte
if [ $# == 0 ]; then
    echo "Aucun argument trouvé. Utilisez \"-h\" pour obtenir de l'aide."
fi
# Vérifier si gnuplot est installé
if ! command -v gnuplot >/dev/null 2>&1; then
    ExitDisplay 0 "gnuplot n'a pas pu être trouvé"
fi

# Cas du -h
# Boucle pour parcourir les arguments
for arg in "$@"
do
    # Si l'argument est égal à "-h", alors on affiche l'aide
    if [ "$arg" == "-h" ]
    then
    echo "---------------------------------------------------"
    echo "Aide : Options possibles"
    echo "-d1 : Conducteurs avec le plus de trajets"
    echo "-d2 : Conducteurs et la plus grande distance"
    echo "-l : Les 10 trajets les plus longs"
    echo "-t : Les 10 villes les plus traversees "
    echo "-s : Statistiques sur les etapes"
    echo "---------------------------------------------------"

    exit 0
    fi

done


for arg in $*; do
    case $arg in

    "-d1")
        
        #Bien donner les droits 
        chmod 777 progc/gnuplot/d1.gnu
        chmod 777 temp/d1_argument_sum.csv
        chmod 777 temp/sorted_d1_argument_sum.csv
        chmod 777 temp/d1_argument_top10_pre.csv
        chmod 777 temp/d1_argument_top10.csv
        
        
# Chemin vers le fichier de données
repertoiredata="./data"
cheminFichier="$repertoiredata/data.csv"

if [[ ! -f "$cheminFichier" ]]; then
    echo "Le fichier $cheminFichier n'existe pas. Veuillez vérifier le chemin du fichier."
    exit 1
fi
#Début chronomètre
temps_debut=$(date +%s.%N)
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

  echo "Création du graph..."
  echo "vous pouvez retrouvez le graphe dans le dossiers image"
  


# Exécutez gnuplot avec le fichier
gnuplot ./progc/gnuplot/d1.gnu


xdg-open "images/d1_image.png"

#Fin chronomètre
temps_fin=$(date +%s.%N)

# Calculez la durée de traitement en secondes
duree_traitement=$(echo "$temps_fin - $temps_debut" | bc)

# Affichez la durée de traitement
echo "Le traitement d1 a pris $duree_traitement secondes pour s'exécuter."


# Fin du script...
        ;;
    "-d2")
    
  chmod 777 progc/gnuplot/2.gnu      
output_dir="./images"
# Chemin vers le fichier de données
repertoiredata="./data"
cheminFichier="$repertoiredata/data.csv"

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

xdg-open "images/d2_image.png"

#Fin chronomètre
temps_fin=$(date +%s.%N)

# Calculez la durée de traitement en secondes
duree_traitement=$(echo "($temps_fin - $temps_debut)/1" | bc)

# Affichez la durée de traitement
echo "Le traitement d2 a pris $duree_traitement secondes pour s'exécuter."
;;
   
    
    "-l")
     
     chmod 777 progc/gnuplot/l.gnu   

# Chemin vers le fichier de données
repertoiredata="./data"
cheminFichier="$repertoiredata/data.csv"

if [[ ! -f "$cheminFichier" ]]; then
    echo "Le fichier $cheminFichier n'existe pas. Veuillez vérifier le chemin du fichier."
    exit 1
fi
#Début chronomètre
temps_debut=$(date +%s.%N)


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

echo "Création du graphique..."
echo "le graphe se trouve dans le dossier image" 
gnuplot ./progc/gnuplot/l.gnu
xdg-open "images/l_image.png"
#Fin chronomètre
temps_fin=$(date +%s.%N)

# Calculez la durée de traitement en secondes
duree_traitement=$(echo "$temps_fin - $temps_debut" | bc)

# Affichez la durée de traitement
echo "Le traitement d1 a pris $duree_traitement secondes pour s'exécuter."

echo -e "Terminé.\n"
;;
 "-t")
 
chmod 777 progc/gnuplot/t.gnu
chmod 777 temp/resultat.txt
chmod 777 temp/resultat.csv
repertoireTemp="./temp"
#mkdir -p "$repertoireTemp"
# Chemin vers le fichier de données
repertoiredata="./data"
cheminFichier="$repertoiredata/data.csv"
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
' $cheminFichier > "$fichier_resultat"
#compilation du programme C
gcc -o t progc/t.c


#exécution du programme C

./t > "$fichier_final"
cat "./temp/t_resultat.csv"
gnuplot ./progc/gnuplot/t.gnu

xdg-open "images/t_image.png"
rm t

        ;;
    esac
done








