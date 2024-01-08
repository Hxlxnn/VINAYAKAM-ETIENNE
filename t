#!/bin/bash

# Assurez-vous que le chemin vers votre fichier est correct
filePath="data.csv"

if [[ ! -f "$filePath" ]]; then
    echo "Le fichier $filePath n'existe pas. Veuillez vérifier le chemin du fichier."
    exit 1
fi

# Reste du script inchangé...

        echo "l arg found"
        # need to sort by route id
        # sum the distance of each step
        # output the top 10 with distances and ID
        # make the graph

        # separate in fields with ;, create a array of sum[route ID] += distance, then print each route ID with it's sum (with 3 decimals)
        echo "Summing route's length..."
   LC_NUMERIC=C awk -F';' 'NR>1{sum[$1]+=$5} END{for(i in sum) printf "%.6f;%s\n", sum[i], i}' ${filePath} >"./temp/l_argument_sum.csv"
        # sort the value from the second field (length), and only numerical, and reversed to have the longest on top
        echo "Sorting route's length..."
        sort -t';' -k1nr "./temp/l_argument_sum.csv" >"./temp/sorted_l_argument_sum.csv"
        echo "Sorting route's ID..."
        # get the top 10 longest route
        head -10 "./temp/sorted_l_argument_sum.csv" >"./temp/l_argument_top10.csv"
        # and sort them by id
        sort -t';' -k2nr "./temp/l_argument_top10.csv" >"./temp/l_argument_top10_finish.csv"
        # to show the top 10
        cat "./temp/l_argument_top10_finish.csv"

        #echo "Creating graph..."
        #gnuplot ./progc/gnuplot/l_script.gnu
        echo -e "Done.\n"
        #;;


