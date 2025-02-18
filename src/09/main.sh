#!/bin/bash

install_utility() {
    utility=$1
    if ! command -v "$utility" &> /dev/null; then
        echo "Утилита $utility не найдена в системе."

        echo "Попытка установки $utility..."
        apt update
        apt install -y "$utility"

        if [ $? -eq 0 ]; then
            echo "Утилита $utility успешно установлена."
        else
            echo "Ошибка при установке утилиты $utility."
        fi
    else
        echo "Утилита $utility уже установлена в системе."
    fi
}

get_metrics() {
cpu=$(cat /proc/loadavg | awk '{print $1}')
ram=$(free  --mega  --si | awk '/^Mem/ {printf "%.3f\n",  $4/1024}')
disk=$(df -k / | grep -v system | awk '{printf "%.2f\n", $4/1024}')

echo -e "# HELP CPU Avarage CPU load.
# TYPE CPU gauge
CPU $cpu
# HELP RAM Available RAM
# TYPE RAM gauge
RAM $ram
# HELP free_disk_space Available space on disk
# TYPE free_disk_space gauge
free_disk_space $disk" > /var/www/metrics/metrics
}

if [[ $# -ne 0 ]]
    then 
    echo "Error. Example: main.sh"
    exit 1
fi

if [ "$(id -u)" -ne 0 ]; then
    echo "Этот скрипт должен быть запущен с правами суперпользователя (sudo)." >&2
    exit 1
fi

install_utility "nginx"

if [[ ! -d /var/www/metrics ]]
then
    mkdir /var/www/metrics
fi

if [[ ! -e /etc/nginx/sites-available/metrics ]]
then
    cp nginx_conf/metrics /etc/nginx/sites-available
    systemctl reload nginx.service
    ln -s /etc/nginx/sites-available/metrics /etc/nginx/sites-enabled
fi

echo "http://localhost:8181/metrics"

while true
do
    get_metrics
    sleep 3
done