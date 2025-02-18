#! /bin/bash

install_packages () {
    install_grafana_server &> /dev/null
    install_programm prometheus
    install_programm stress
}

check_all_installed () {
    packages=(
        grafana-server
        prometheus
        stress
    )

    for package in ${packages[*]}; do
        if [[ $(is_installed $package) == False ]]; then
            echo "error: couldn't install $package"
        fi
    done
}

install_grafana_server () {
    if [[ $(is_installed grafana-server) == False ]]; then
        sudo apt-get install -y adduser libfontconfig1 musl

        grafana_version="grafana_10.2.3_amd64.deb"
        wget https://dl.grafana.com/oss/release/$grafana_version
        sudo dpkg -i $grafana_version

        rm -rf $grafana_version
    fi
}

install_programm () {
    programm="$1"

    if [[ $(is_installed $programm) == False ]]; then
        sudo apt update &> /dev/null
        sudo apt install $programm &> /dev/null
    fi
}

is_installed () {
    programm="$1"

    answer=True
    if [[ $(which $programm) == "" ]]; then
        answer=False
    fi

    echo $answer
}