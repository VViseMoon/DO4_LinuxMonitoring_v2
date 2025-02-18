#!/bin/bash

source ../utils/helpers.sh
source functions.sh

start=$(date +%s.%N)
start_time=$(date +%T)

if [[ $# -ne 3 ]] || [[ $(check_format "$@") -eq 0 ]]
then
    print_error
    exit 1
fi

run_main "$@"

end=$(date +%s.%N)
end_time=$(date +%T)
value=$(echo "$start_time $end_time $start $end" | awk '{printf("Script start time: %s\nScript end time: %s\nScript execution time: %.2f sec\n", $1, $2, $4-$3)}')

echo "$value"
echo "$value" >> trash.log

