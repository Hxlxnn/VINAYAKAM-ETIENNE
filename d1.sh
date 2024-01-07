#!/bin/bash

# Assurez-vous que le chemin vers votre fichier est correct
filePath="data.csv"

if [[ ! -f "$filePath" ]]; then
    echo "Le fichier $filePath n'existe pas. Veuillez vérifier le chemin du fichier."
    exit 1
fi

# Reste du script inchangé...



    echo "d1 arg found"
    # need to sort by route id or driver name
    # count the number of different routes
    # output the top 10 with number of routes and names
    # make the graph

    # separate in fields with ;, create an array of sum[route ID] += distance, then print each route ID with its sum (with 3 decimals)
    echo "Summing drivers routes..."
    # if step ID is 1, add the route to the driver names, then at the end, print the name and its route amount
    awk -F';' '$2 == 1 {sum[$6]+=1} END{for(i in sum) printf "%s;%d\n", i, sum[i]}' "$filePath" >"./temp/d1_argument_sum.csv"
    # sort the value from the second field (length), and only numerical, and reversed to have the longest on top
    echo "Sorting drivers routes..."
    sort -t';' -k2nr "./temp/d1_argument_sum.csv" >"./temp/sorted_d1_argument_sum.csv"
    echo "Getting the top drivers..."
    # get the top 10 longest route
    head -10 "./temp/sorted_d1_argument_sum.csv" >"./temp/d1_argument_top10_pre.csv"
    sort -t';' -k2nr "./temp/d1_argument_top10_pre.csv" >"./temp/d1_argument_top10.csv"
     cat "./temp/d1_argument_top10.csv" # to show the top 10

   





