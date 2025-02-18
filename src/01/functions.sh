#!/bin/bash

print_error() {
    echo "Error. Wrong format. Example: main.sh /opt/test 4 az 5 az.az 3kb"
}

check_format() {
    if [[ $(is_path "$1") -eq 0 ]] || 
        [[ $(is_number "$2") -eq 0 ]] || 
        [[ $(check_folder_name "$3") -eq 0 ]] || 
        [[ $(is_number "$4") -eq 0 ]] || 
        [[ $(check_file_name "$5") -eq 0 ]] ||
        [[ $(check_file_size "$6" "kb") -eq 0 ]]
        then
        echo 0
    else
        echo 1
    fi
}

run_main() {
    local max_filename_len=100
    local max_foldername_len=60
    local folder_size=4
    local log="trash.log"
    local free_space_min=$(( 1024*1024 ))

    local path
    path="$(realpath "$1")/"
    local planned_folders_count="$2"
    local chars_for_folder="$3"
    local planned_files_count="$4"
    local file_chars
    file_chars=$(get_file_name "$5")
    local file_extension
    file_extension=".$(get_extension "$5")"
    local file_size_with_kb="$6"
    local file_size
    file_size=$(get_file_size "$file_size_with_kb" "kb")

    local suffix
    suffix=$(date +"_%d%m%y")
    local fs
    fs=$(df / | awk 'NR>1 {print $4}')

    local folders
    local min_filename_len=4
    folders=( $(generate_names "$chars_for_folder" "$planned_folders_count" "$max_filename_len" "$min_filename_len") )
    local filenames
    filenames=( $(generate_names "$file_chars" "$planned_files_count" "$max_foldername_len" "$min_filename_len") )

    local folders_total=${#folders[@]}
    local filenames_total=${#filenames[@]}

    if [[ $file_size -lt 4 ]]
    then
        file_size=4
    fi

    for ((i = 0; i < folders_total && fs>free_space_min; i++))
        do
        local full_folder_name="$path${folders[$i]}$suffix/"
        mkdir -p "$full_folder_name"
        logging $log "$full_folder_name"
        fs=$(( fs - folder_size ))
        for ((j = 0; j < filenames_total && fs>free_space_min; j++))
            do
            local full_file_name="$full_folder_name${filenames[$j]}$suffix$file_extension"
            fallocate -l "$file_size_with_kb" "$full_file_name"
            logging $log "$full_file_name" "$file_size_with_kb"
            fs=$(( fs - file_size ))
        done
    done
}
