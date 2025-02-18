#!/bin/bash

# "153"
is_number() {
    if [[ $1 =~ ^[0-9]+$ ]] && [[ $1 -ne 0 ]]; then
        echo "1"
    else
        echo "0"
    fi
}

# "/random/dir
is_path() {
    if [[ -d $1 ]] && [[ -w $1 ]]; then
        echo "1"
    else
        echo "0"
    fi
}

# "abc.zxc"
get_file_name() {
    local name=$1
    awk -F"." '{print $1}' <<< "$name"
}

# "abc.zxc"
get_extension() {
    local name=$1
    awk -F"." '{print $2}' <<< "$name"
}

# "abcd"
check_folder_name() {
    local str=$1
    if [[ $str =~ ^[a-z]{1,7}$ ]]; then
        echo 1
    else
        echo 0
    fi
}

# "abc.zxc"
check_file_name() {
    local str=$1
    if [[ $str =~ ^[a-z]{1,7}.[a-z]{1,3}$ ]]; then
        echo 1
    else
        echo 0
    fi
}

# "3kb" 
check_file_size() {
    local size=$1
    local unit=$2
    if [[ $size =~ ^([1-9][0-9]?|100)"$unit"$ ]]; then
        echo 1
    else
        echo 0
    fi
}

# "3kb"
get_file_size() {
    local size=$1
    local unit=$2
    echo "${size%"$unit"}"
}

generate_names() {
    local chars=$1
    local total_filenames=$2
    local max_filename_len=$3
    local min_filename_len=$4
    echo "$chars $total_filenames $max_filename_len $min_filename_len" | python3 "$(pwd)/../utils/perm.py"
}

logging() {
    local log_path=$1
    local path=$2
    local created_date
    created_date=$(stat -c %w "$path")
    if [[ $# -eq 3 ]]
        then
        local size=$3
        echo "$path::$created_date::$size" >> "$log_path"
    else
        echo "$path::$created_date::" >> "$log_path"
    fi
}