#!/bin/bash

install_utility() {
    utility=$1
    if ! command -v "$utility" &> /dev/null; then
        echo "Утилита $utility не найдена в системе."

        echo "Попытка установки $utility..."
        sudo apt update
        sudo apt install -y "$utility"

        if [ $? -eq 0 ]; then
            echo "Утилита $utility успешно установлена."
        else
            echo "Ошибка при установке утилиты $utility."
        fi
    else
        echo "Утилита $utility уже установлена в системе."
    fi
}

if [[ $# -ne 0 ]]
    then 
    echo "Error. Example: main.sh"
    exit 1
fi

install_utility "goaccess"
install_utility "nginx"
sudo goaccess ../04/logs/*.log -o /var/www/html/index.html --log-format=COMBINED --real-time-html