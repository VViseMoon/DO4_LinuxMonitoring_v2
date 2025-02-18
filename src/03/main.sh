#!/bin/bash

start_dir=~

check_log() {
    if [[ "$#" == 2 ]] && [[ -f $2 ]]
        then
        echo 1
    else
        echo 0
    fi
}

is_date() {
    local mask=$1
    if [[ $mask =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}:[0-9]{2} ]] && [[ $(date -d "$mask_date" 2>&1 | grep -c "invalid date") != 1 ]] 
        then
        echo "1"
    else
        echo "0"
    fi
}

compare_dates() {
    local from
    from=$(date -d "$1" +%s)
    local to
    to=$(date -d "$2" +%s)
    echo $(( from <= to )) 
}

check_dates() {
    if [[ "$#" == 3 ]] && [[ $(is_date "$2") == 1 ]] && [[ $(is_date "$3") == 1 ]] && [[ $(compare_dates "$2" "$3") == 1 ]]
        then
        echo 1
    else
        echo 0
    fi
}

get_date_from_name() {
    awk -F'_' '{print $2}' <<< "$1"
}

is_mask() {
    local mask=$1
    local mask_date
    mask_date=$(get_date_from_name "$mask")
    mask_date="${mask_date:4:2}-${mask_date:2:2}-${mask_date:0:2}"
    if [[ $mask =~ ^[a-z]{1,7}_[0-9]{6}$ ]] && [[ $(date -d "$mask_date" 2>&1 | grep "invalid date" -c ) != 1 ]]
        then
        echo "1"
    else
        echo "0"
    fi
}

check_mask() {
    if [[ "$#" == 2 ]] && [[ $(is_mask "$2") == 1 ]]
        then
        echo 1
    else
        echo 0
    fi
}

check_input() {
    local input_correct=0
    if [[ $1 == 1 ]]
        then
        input_correct=$(check_log "$@")
    fi
    if [[ $1 == 2 ]]
        then
        input_correct=$(check_dates "$@")
    fi
    if [[ $1 == 3 ]]
        then
        input_correct=$(check_mask "$@")
    fi
    echo "$input_correct"
}

get_template() {
    input_string=$1
    template=""
    for ((i = 0; i < ${#input_string}; i++)); do
        char="${input_string:$i:1}"
        if [[ $char =~ [a-zA-Z] ]]; then
            template+="$char+"
        else
            template+="$char"
        fi
    done
    template+="$"
    echo "$template"
}

clean_by_log() {
    grep "::$" "$2" | awk -F'::' '{print $1}' | xargs rm -rf
}

clean_by_time() {
    find $start_dir -newermt "$2" ! -newermt "$3" -type d | xargs rm -rf
}

clean_by_mask() {
    local template
    template=$(get_template "$2")
    local date_part
    date_part=$(get_date_from_name "$2")
    find $start_dir -type d -name "*$date_part"  | grep -E "$template" | xargs rm -rf
}

clean_up() {
    if [[ $1 == 1 ]]
        then
        clean_by_log "$@"
    fi
    if [[ $1 == 2 ]]
        then
        clean_by_time "$@"
    fi
    if [[ $1 == 3 ]]
        then
        clean_by_mask "$@"
    fi
}

if [[ $(check_input "$@") -ne 1 ]]
    then 
    echo -e "Error. Wrong format. Examples:
    main.sh 1 trash.log
    main.sh 2 2023-09-12T10:00:00 2023-09-12T12:12:12
    main.sh 3 abcd_120923"
    exit 1
fi

clean_up "$@"