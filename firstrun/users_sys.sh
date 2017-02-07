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
cdir=$(pwd)
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

tuser=stub # юзер для быстрого и небезопасного подключения
pass6=pass6
## end private data ##
# если файла с приватными данными не будет, используем определенные, только что
source $cdir/users_init.sh
if [ $? -eq 0 ];then echo -n "${green}${toend}[OK]";echo -n "${reset}";
else echo -n "${red}${toend}[fail]";echo -n "${reset}";fi;echo

echo crating default users $dev1, $dev2, $robot, $owner1, $owner2, $tuser at host $hostn

## usual group configuration without acl ##
addgroup dev # группа для разрабов, из под нее можно редактировать исхода
addgroup keyonly # там только те, кому можно заходить по ключу ssh

#m=создать хомяк; U=создать и добавить группу пользователя; G=добавить в группы через запятую;
# useradd -mUG dev,sudo,keyonly enot # developer1
# passwd enot  #pass for developer1
groups $dev1
sudo usermod -a -G dev,keyonly $dev1
if [ $? -eq 0 ];then echo -n "${green}${toend}[OK]";echo -n "${reset}";
else echo -n "${red}${toend}[fail]";echo -n "${reset}";exit $?;fi;echo
groups $dev1

useradd -mUG dev,sudo,keyonly -s /bin/bash $dev2 
if [ $? -eq 0 ];then echo -n "${green}${toend}[OK]";echo -n "${reset}";
else echo -n "${red}${toend}[fail]";echo -n "${reset}";exit $?;fi;echo
echo "$dev2:$pass2" | sudo chpasswd  #pass 
cat /etc/passwd | grep $dev2
groups $dev2

useradd -mG www-data,keyonly -s /bin/bash $robot 
if [ $? -eq 0 ];then echo -n "${green}${toend}[OK]";echo -n "${reset}";
else echo -n "${red}${toend}[fail]";echo -n "${reset}";exit $?;fi;echo
echo "$robot:$pass3" | sudo chpasswdr # pass 
cat /etc/passwd | grep $robot
groups $robot

useradd -mUG www-data,keyonly -s /bin/bash $owner1 
if [ $? -eq 0 ];then echo -n "${green}${toend}[OK]";echo -n "${reset}";
else echo -n "${red}${toend}[fail]";echo -n "${reset}";exit $?;fi;echo
echo "$owner1:$pass4" | sudo chpasswd # pass
cat /etc/passwd | grep $owner1
groups $owner1

useradd -mUG www-data,keyonly -s /bin/bash $owner2 
if [ $? -eq 0 ];then echo -n "${green}${toend}[OK]";echo -n "${reset}";
else echo -n "${red}${toend}[fail]";echo -n "${reset}";exit $?;fi;echo
echo "$owner2:$pass5" | sudo chpasswd # pass 
cat /etc/passwd | grep $owner2
groups $owner2

useradd -mUG keyonly -s /bin/bash $tuser 
if [ $? -eq 0 ];then echo -n "${green}${toend}[OK]";echo -n "${reset}";
else echo -n "${red}${toend}[fail]";echo -n "${reset}";exit $?;fi;echo
echo "$tuser:$pass6" | sudo chpasswd #pass 
cat /etc/passwd | grep $tuser
groups $tuser
# подключаться по команде: su enot -
# запросить судо: sudo -S true

# userdel -r ubuntu #delete user from virtualbox default image
