#!/bin/bash

# Retourne le code de sortie de la dernière commande : $?
# Nom du script : $0
# Nombre d'arguments : $#
# Liste des arguments : $*
# Arguments 0, 2 et 4 : $0 $2 $4
# Récupérer tous les arguments à partir du n-ième : ${@:n}
# Ignorer toujours la première ligne du fichier CSV
# Type de CSV : Route ID;Step ID;Town A;Town B;Distance;Driver name
# TODO Compter uniquement le temps d'exécution du script
# TODO Relire le PDF pour vérifier si tout est bien fait et est à la bonne place

# Fonction qui affiche un message avant de quitter le script, montrant le temps écoulé
ExitDisplay() {
    echo ""
    startTime=$1
    otherArgs=${@:2}
    if [ -n "${otherArgs}" ]; then
        echo -e ${otherArgs}
    fi

    # Affiche le temps d'exécution à partir du premier argument
    if [ ${startTime} == 0 ]; then
        echo "Temps d'exécution : 0s"
    else
        endTimeCount=$(date +%s)
        runtime=$(echo $((${endTimeCount} - ${startTime})))
        echo "Temps d'exécution : ${runtime}s"
    fi

    # Attend que l'utilisateur appuie sur une touche avant de quitter le script
    read -p "Appuyez sur n'importe quelle touche pour quitter"
    
    # Quitte le script
    exit
}

# Définir le titre de l'onglet selon nos besoins
echo -en "\033]0;CYTruck\a"

# Se déplacer vers le chemin absolu du dossier parent contenant ce script
# pour s'assurer que tous les scripts relatifs fonctionnent comme prévu
cd "$(dirname "$0")"

# Créer le dossier 'images' s'il n'existe pas déjà
if [ ! -d 'images' ]; then
    # Créer le dossier
    result=$(mkdir -p 'images')
    if [ $? != 0 ]; then
        echo "Erreur dans la configuration : $result"
    fi
    echo 'Dossier images créé.'
else
    echo 'Le dossier images existe déjà.'
fi

# Nettoyer si le dossier temp existe, ou le créer s'il n'est pas déjà fait
if [ ! -d './temp' ]; then
    # Créer le dossier
    result=$(mkdir -p 'temp')
    if [ $? != 0 ]; then
        echo "Erreur dans la configuration : $result"
    fi
    echo 'Dossier temp créé.'
elif [ -n "$(ls "./temp/")" ]; then
    echo 'Le dossier temp existe déjà, nettoyage...'
    oldDir=$(pwd)
    cd "temp"
    rm -r *
    cd "${oldDir}"
    echo 'Terminé.'
else
    echo 'Le dossier temp existe.'
fi

# Créer le dossier 'data' s'il n'existe pas déjà
if [ -d "./data" ]; then
    echo "Le répertoire \"data\" existe."
else
    mkdir -p 'data'
    echo 'Dossier data créé.'
fi

# Créer le dossier 'demo' s'il n'existe pas déjà
if [ -d "./demo/dir/" ]; then
    echo "Le répertoire \"demo\" existe."
else
    mkdir -p 'demo'
    echo 'Dossier demo créé.'
fi

# Commencer à mesurer le temps
startTimeCount=$(date +%s)

# Vérifier le nombre d'arguments, sinon quitter
if [ $# == 0 ]; then
    ExitDisplay ${startTimeCount} "Aucun argument trouvé. Utilisez \"-h\" pour obtenir de l'aide."
fi

# Vérifier chaque argument qui ne nécessite pas de fichier CSV
for arg in $*; do
    case $arg in
        "-h")
            # TODO Mettre à jour avec les commandes bonus (nettoyer)
            ExitDisplay ${startTimeCount} "Aide :\n
- path :\t Le chemin vers un fichier CSV avec les données. Il doit être le premier argument.\n
- \"-h\" :\t Affichera le message d'aide, qui est la liste des arguments et ce qu'ils font. Il n'exécutera aucun autre argument.\n
- \"-d1\":\t Afficher les 10 premiers conducteurs avec le plus de trajets.\n
- \"-d2\":\t Afficher les 10 premiers conducteurs avec la plus grande distance parcourue.\n
- \"-l\" :\t Afficher les 10 plus longues routes.\n
- \"-t\" :\t Afficher les 10 villes les plus traversées avec le nombre de conducteurs différents qui la traversent.\n
- \"-s\" :\t Distances minimales, maximales et moyennes pour chaque route.\n
- \"-c\" :\t Nettoyer les fichiers compilés. C'est-à-dire : -clean"
            ;;
        "-c" | "-clean")
            echo "Nettoyage des fichiers compilés..."
            make -f ./progc/Makefile clean
            # Ne pas arrêter si d'autres arguments sont trouvés
            if [ $# -gt 2 ]; then
                echo "Terminé."
            else
                ExitDisplay ${startTimeCount} "Terminé."
            fi
            ;;
    esac
done

# Compiler le programme si ce n'est pas déjà fait
if [ ! -d "./progc/bin" ] || [ ! -f "./progc/bin/CYTruck" ]; then
    # Vérifier si make et gcc sont installés
    if ! command -v make >/dev/null 2>&1; then
        ExitDisplay 0 "make n'a pas été trouvé"
    fi
    if ! command -v gcc >/dev/null 2>&1; then
        ExitDisplay 0 "gcc n'a pas été trouvé"
    fi
    compilation=$(make -f "./progc/Makefile" builddir)
    compilation=$(make -f "./progc/Makefile" objdir)
    compilation=$(make -f "./progc/Makefile")
    
    # Vérifier le résultat de la compilation du fichier
    if [ $? != 0 ]; then
        ExitDisplay 0 "Erreur pendant la compilation :\n${compilation}"
    fi
fi

# Chemin et nom du fichier CSV supposé
filePath=$1

# Vérifier s'il y a des arguments après le chemin du fichier
if [ $# -lt 2 ]; then
    ExitDisplay ${startTimeCount} "Vous avez besoin d'au moins un argument avec le chemin du fichier !"
fi

# Vérifier si le premier argument est un fichier se terminant par .csv
if [ ${filePath##*.} != "csv" ]; then
    ExitDisplay ${startTimeCount} "Le premier argument n'est pas un fichier CSV."
fi
if [ ! -f $filePath ]; then
    ExitDisplay ${startTimeCount} "Impossible de trouver le fichier CSV."
fi
# TODO Vérifier si la première ligne est le type correct du CSV souhaité ?

# Vérifier si gnuplot est installé
if ! command -v gnuplot >/dev/null 2>&1; then
    ExitDisplay 0 "gnuplot n'a pas été trouvé"
fi

