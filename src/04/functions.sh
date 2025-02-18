#!/bin/bash

# shellcheck disable=SC2154
# shellcheck disable=SC2207

min_length=100
max_length=2100

min_records=100
max_records=1000

rand() {
    echo "$(( RANDOM % $1 ))"
}

random_sorted_times() {
    local day=$1
    local day_ut
    day_ut=$(date -d "$day" +%s)
    local total
    total=$(( "$( rand $(( max_records - min_records )) )" + min_records ))
    local times_arr=()
    for (( i=0; i<total; i++ ))
    do
        times_arr+=( $((day_ut + "$( rand 24 )"*60*60 + "$( rand 60 )"*60 + "$( rand 60 )")) )
    done

    times_sorted=(
        $(
            for el in "${times_arr[@]}" 
                do 
                echo "$el"
            done | sort -n
        )
    )
    echo "${times_sorted[@]}"
}

generate_ip() {
    echo "212.150.$(( RANDOM%4 )).$(( RANDOM%255 + 1 ))"
}

format_date() {
    date -d "@$1" "+[%d/%b/%Y:%H:%M:%S %z]"
}

generate_request() {
    echo "${methods[$(rand ${#methods[@]})]} ${urls[$(rand ${#urls[@]})]} HTTP/1.1"
}

generate_code() {
    echo "${codes[$(rand ${#codes[@]})]}"
}

generate_length() {
    echo $(( RANDOM % $(( max_length - min_length )) + min_length ))
}

generate_site() {
    echo "${sites[$(rand ${#sites[@]})]}"
}

generate_agent() {
    echo "${agents[$(rand ${#agents[@]})]}"
}

generate_line() {
    local ip
    ip=$(generate_ip)
    local datetime_formatted
    datetime_formatted=$(format_date "$cur_time")
    local HTTP_request
    HTTP_request=$(generate_request)
    local code
    code=$(generate_code)
    local length
    length=$(generate_length)
    local site
    site=$(generate_site)
    local agent
    agent=$(generate_agent)
    echo "$ip - - $datetime_formatted \"$HTTP_request\" $code $length \"$site\" \"$agent\""
}

generate_log() {
    if [[ ! -d logs ]]
    then
        mkdir logs
    fi
    filename="logs/$1.log"
    echo -n > "$filename"
    cur_times=( $(random_sorted_times "$1") )
    for cur_time in "${cur_times[@]}"
    do
        line=$(generate_line)
        echo "$line" >> "$filename"
    done
}

run_main() {

    if [[ $# -gt 0 ]];
        then
        echo "Error"
        exit 1
    fi

    for day in "${days[@]}"
    do
        generate_log "$day"
    done
}