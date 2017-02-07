#!/bin/bash
# настройки для цветного вывода ошибки
red=$(tput setf 4)
green=$(tput setf 2)
reset=$(tput sgr0)
toend=$(tput hpa $(tput cols))$(tput cub 6)
#запуск под рутом?
if [ "$(id -u)" != "0" ];then echo "Sorry, you are not root.";exit 1;fi

# настройки окружения
hostn=$(cat /etc/hostname)
dircur=$(pwd)
if [ "$(id -u)" != "0" ];then echo "Sorry, you are not root.";exit 1;fi

## start private data ##
dev1=dev1 # developer1
pass1=pass1
skey1=skey1

dev2=dev2 # developer2
pass2=pass2
skey2=skey2

robot=robot # script agent
skey3=skey3
pass3=pass3

owner1=owner1 # product owner1
skey4=skey4
pass4=pass4

owner2=owner2 # product owner2
skey5=skey5
pass5=pass5
## end private data ##

# если файла с приватными данными не будет, используем определенные, только что
source $dircur/users_init.sh
if [ $? -eq 0 ];then echo -n "${green}${toend}[OK]";echo -n "${reset}";
else echo -n "${red}${toend}[fail]";echo -n "${reset}";fi;echo

echo crating default users $dev1, $dev2, $robot, $owner1, $owner2 at host $hostn

## config ssh for users ##
#C=comment; P=old_passphrase; f=path_and_filename_of_key; q=silience_mode
mkdir /home/$dev1/.ssh
chmod 700 /home/$dev1/.ssh
ssh-keygen -t rsa -b 4096 -C "$dev1@$hostn" -P "$skey1" -f "/home/$dev1/.ssh/$dev1@$hostn.rsa" -q
cat /home/$dev1/.ssh/$dev1@$hostn.rsa.pub >> /home/$dev1/.ssh/authorized_keys
chown -R $dev1:$dev1 /home/$dev1/.ssh

mkdir /home/$dev2/.ssh
chmod 700 /home/$dev2/.ssh
ssh-keygen -t rsa -b 4096 -C "$dev2@$hostn" -P "$skey2" -f "/home/$dev2/.ssh/$dev2@$hostn.rsa" -q
cat /home/$dev2/.ssh/$dev2@$hostn.rsa.pub >> /home/$dev2/.ssh/authorized_keys
chown -R $dev2:$dev2 /home/$dev2/.ssh

mkdir /home/$robot/.ssh
chmod 700 /home/$robot/.ssh
ssh-keygen -t rsa -b 4096 -C "$robot@$hostn" -P "$skey3" -f "/home/$robot/.ssh/$robot@$hostn.rsa" -q
cat /home/$robot/.ssh/$robot@$hostn.rsa.pub >> /home/$robot/.ssh/authorized_keys
chown -R $robot:$robot /home/$robot/.ssh

mkdir /home/$owner1/.ssh
chmod 700 /home/$owner1/.ssh
ssh-keygen -t rsa -b 4096 -C "$owner1@$hostn" -P "$skey4" -f "/home/$owner1/.ssh/$owner1@$hostn.rsa" -q
cat /home/$owner1/.ssh/$owner1@$hostn.rsa.pub >> /home/$owner1/.ssh/authorized_keys
chown -R $owner1:$owner1 /home/$owner1/.ssh

mkdir /home/$owner2/.ssh
chmod 700 /home/$owner2/.ssh
ssh-keygen -t rsa -b 4096 -C "$owner2@$hostn" -P "$skey5" -f "/home/$owner2/.ssh/$owner2@$hostn.rsa" -q
cat /home/$owner2/.ssh/$owner2@$hostn.rsa.pub >> /home/$owner2/.ssh/authorized_keys
chown -R $owner2:$owner2 /home/$owner2/.ssh

cp /home/$dev1/.ssh/$dev1@$hostn.rsa /tmp
cp /home/$dev2/.ssh/$dev2@$hostn.rsa /tmp
cp /home/$robot/.ssh/$robot@$hostn.rsa /tmp
cp /home/$owner1/.ssh/$owner1@$hostn.rsa /tmp
cp /home/$owner2/.ssh/$owner2@$hostn.rsa /tmp
chown $dev1:$dev1 /tmp/*@$hostn.rsa
ls -la /tmp/
