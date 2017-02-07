#!/bin/bash
#запуск под рутом?
if [ "$(id -u)" != "0" ];then echo "Sorry, you are not root.";exit 1;fi
# настройки для цветного вывода ошибки
red=$(tput setf 4)
green=$(tput setf 2)
reset=$(tput sgr0)
toend=$(tput hpa $(tput cols))$(tput cub 6)
# настройки для цветного вывода ошибки
red=$(tput setf 4)
green=$(tput setf 2)
reset=$(tput sgr0)
toend=$(tput hpa $(tput cols))$(tput cub 6)
# настройки окружения
hostn=$(cat /etc/hostname)
cdir=$(pwd)
## config ssh group ##
# cp /etc/ssh/sshd_config /etc/ssh/sshd_config.factory-defaults
cat <<EOT > /etc/ssh/sshd_config
Port 22
Protocol 2

HostKey /etc/ssh/ssh_host_rsa_key
HostKey /etc/ssh/ssh_host_dsa_key
HostKey /etc/ssh/ssh_host_ecdsa_key
HostKey /etc/ssh/ssh_host_ed25519_key
UsePrivilegeSeparation yes
KeyRegenerationInterval 3600
ServerKeyBits 1024
SyslogFacility AUTH
LogLevel INFO
LoginGraceTime 120
PermitRootLogin no
StrictModes yes

# AuthorizedKeysFile     %h/.ssh/authorized_keys
IgnoreRhosts yes
RhostsRSAAuthentication no
HostbasedAuthentication no
PermitEmptyPasswords no

X11Forwarding yes
X11DisplayOffset 10
PrintMotd no
PrintLastLog yes
TCPKeepAlive yes
AllowTcpForwarding yes
AcceptEnv LANG LC_*
UsePAM yes
Subsystem sftp /usr/lib/openssh/sftp-server

PasswordAuthentication no
ChallengeResponseAuthentication no
PubkeyAuthentication yes
AllowGroups keyonly
PermitEmptyPasswords no
# http://serverfault.com/a/285844
Match User stub 
    PasswordAuthentication yes
    AllowTCPForwarding no
    X11Forwarding no
Match all # http://serverfault.com/a/817368
EOT

service sshd restart
if [ $? -eq 0 ];then echo -n "${green}${toend}[OK]";echo -n "${reset}";
else echo -n "${red}${toend}[fail]";echo -n "${reset}";fi;echo
service sshd status