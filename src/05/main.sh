#!/bin/bash

path="../04/logs"
logs="$path/*.log"

if [[ $# -ne 1 ]] || [[ $1 -gt 4 ]] || [[ $1 -lt 1 ]]
    then 
    echo "Error. Example: main.sh 3"
    exit 1
fi

if ! ls "$path"/*.log 1> /dev/null 2>&1;
    then
    echo -e "Error.\nPlease make sure that there are files with the .log extension in the $path folder."
    exit 2
fi

if [[ $1 -eq 1 ]]
    then
    awk '{print $9, $0}' $logs | sort -k1,1n | cut -d' ' -f2-
fi

if [[ $1 -eq 2 ]]
    then
    awk '{print $1}' $logs | sort | uniq
fi

if [[ $1 -eq 3 ]]
    then
    awk '{print $9, $6, $7, $8}' $logs | grep "^[45]" | cut -d' ' -f2-
fi

if [[ $1 -eq 4 ]]
    then
    awk '{print $9, $1}' $logs | grep "^[45]" | cut -d' ' -f2- | sort | uniq
fi
