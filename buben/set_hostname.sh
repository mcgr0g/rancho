#!/bin/bash
#script change hostname to value from 1st parameter
if [ ! -n "$1" ] 
then
    echo 'Missed argument : hostname'
    exit 1
fi

if [ "$(id -u)" != "0" ]; then
    echo "Sorry, you are not root."
    exit 1
fi

newhost=$1
hostn=$(cat /etc/hostname)
echo current hostname = $hostn , setting name ${newhost}

sudo hostname ${newhost}
sudo sed -i "s/$hostn/$newhost/g" /etc/hosts
sudo sed -i "s/$hostn/$newhost/g" /etc/hostname

sudo /etc/init.d/hostname.sh start
sudo /etc/init.d/networking restart

read -s -n 1 -p "Press any key to reboot"
sudo reboot
