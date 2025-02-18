#!/bin/bash

source ../utils/helpers.sh
source functions.sh

if [[ $# -ne 6 ]] || [[ $(check_format "$@") -eq 0 ]]
then
    print_error
    exit 1
fi

run_main "$@"
