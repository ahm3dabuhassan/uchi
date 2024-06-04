#!/bin/bash

file=$1 # PNG, JPG, TXT, WEBP, PDF
declare -a magicBytes=("8950 4e47 0d0a 1a0a" "ffd8 ffe0" "42 4D" "EF BB BF" "6674 7970 6865 69" "5249 4646" "2550 4446 2d")
typeOfFile=
if [ -e $file ];
then
    echo "$file exists.";
    hexOfFile=$(xxd $file | head -n1 | cut -d" " -f 2,3,4,5,6,7,8,9);
    for ((i=0; i<=${#magicBytes}; i++)){
        if [[ ${hexOfFile} =~ ^[[:digit:][:space:][:alpha:]]*${magicBytes[i]}[[:digit:][:space:][:alpha:]]*$ ]];
        then 
            case ${magicBytes[$i]} in 
                "8950 4e47 0d0a 1a0a" ) 
                    echo "PNG FILE";;
                "ffd8 ffe0" ) 
                    echo "JPG FILE";;
                "6674 7970 6865 69" ) 
                    echo "HEIC FILE";;   
                "5249 4646" )
                    echo "WEBP FILE";;   
                "2550 4446 2d" ) 
                    echo "PDF FILE";;
            esac
        else 
            echo "No"
        fi
    }

else
    echo "$file not exists."
fi