#!/bin/bash

# rajouter pour mettre dans l'ordre décroissant
filePath="data.csv"

if [[ ! -f "$filePath" ]]; then
    echo "Le fichier $filePath n'existe pas. Veuillez vérifier le chemin du fichier."
    exit 1
fi

# Reste du script inchangé...

 echo "d2 arg found"
        # need to sort by driver name
        # then add each distance
        # output the top 10 ones with distances to make the graph
        # make the graph

        # separate in fields with ;, create a array of sum[route ID] += distance, then print each route ID with it's sum (with 3 decimals)
        echo "Summing drivers routes..."
       LC_NUMERIC=C awk -F';' 'NR>1{sum[$6]+=$5} END{for(i in sum) printf "%s;%.6f\n", i, sum[i]}' ${filePath} >"./temp/d2_argument_sum.csv"
        # sort the value from the second field (length), and only numerical, and reversed to have the longest on top
        echo "Sorting drivers routes..."
        sort -t';' -k2n "./temp/d2_argument_sum.csv" >"./temp/sorted_d2_argument_sum.csv"
        echo "Sorting drivers..."
        # get the top 10 longest route
        tail -n 10 "./temp/sorted_d2_argument_sum.csv" >"./temp/d2_argument_top10.csv"
         cat "./temp/d2_argument_top10.csv" # to show the top 10

        


