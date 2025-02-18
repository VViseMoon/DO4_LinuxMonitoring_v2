#!/bin/bash

print_error() {
    echo "Error. Wrong format. Example: main.sh az az.az 3Mb"
}

check_format() {
    if [[ $(check_folder_name "$1") -eq 0 ]] || 
        [[ $(check_file_name "$2") -eq 0 ]] ||
        [[ $(check_file_size "$3" "Mb") -eq 0 ]]
        then
        echo 0
    else
        echo 1
    fi
}

run_main() {
    local max_filename_len=1000
    local max_foldername_len=20
    local log="trash.log"
    local free_space_min=$(( 1024 * 1024 ))
    local planned_folders_count=20
    local planned_files_count=30

    local chars_for_folder="$1"
    local file_chars
    file_chars=$(get_file_name "$2")
    local file_extension
    file_extension=".$(get_extension "$2")"
    local file_size_with_mb="$3"

    local suffix
    suffix=$(date +"_%d%m%y")
    local fs
    fs=$(df / | awk 'NR>1 {print $4}')

    local paths
    paths=( $(find ~ -maxdepth 4 -type d -writable 2>/dev/null | shuf | head -n 2) )
    local folders
    local min_filename_len=5
    folders=( $(generate_names "$chars_for_folder" "$planned_folders_count" "$max_filename_len" "$min_filename_len") )
    local filenames
    filenames=( $(generate_names "$file_chars" "$planned_files_count" "$max_foldername_len" "$min_filename_len") )

    local folders_total_max=${#folders[@]}
    local filenames_total_max=${#filenames[@]}
    local paths_total=${#paths[@]}

    for ((k = 0; k < paths_total && fs>free_space_min; k++))
        do
        local path
        path="$(realpath "${paths[k]}")/"
        local folders_total
        folders_total=$(( RANDOM % folders_total_max + 1 ))
        for ((i = 0; i < folders_total && fs>free_space_min; i++))
            do
            local full_folder_name="$path${folders[$i]}$suffix/"
            mkdir -p "$full_folder_name"
            logging $log "$full_folder_name"
            local filenames_total
            filenames_total=$(( RANDOM % filenames_total_max + 1 ))
            for ((j = 0; j < filenames_total && fs>free_space_min; j++))
                do
                local full_file_name="$full_folder_name${filenames[$j]}$suffix$file_extension"
                fallocate -l "$file_size_with_mb" "$full_file_name"
                logging $log "$full_file_name" "$file_size_with_mb"
                fs=$(df / | awk 'NR>1 {print $4}')
            done
        done
    done
}