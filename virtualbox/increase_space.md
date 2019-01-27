# как увеличить диск на гостевой ubuntu
у меня оно чет кончилось, `df -h` сказал, что заюзал я 100 процентов
```
Filesystem                  Size  Used Avail Use% Mounted on
udev                        2.0G     0  2.0G   0% /dev
tmpfs                       396M  5.6M  390M   2% /run
/dev/mapper/buben--vg-root   14G   13G  8.8M 100% /
tmpfs                       2.0G     0  2.0G   0% /dev/shm
tmpfs                       5.0M     0  5.0M   0% /run/lock
tmpfs                       2.0G     0  2.0G   0% /sys/fs/cgroup
/dev/sda1                   472M  154M  294M  35% /boot
shared                      692G  454G  238G  66% /media/sf_shared
tmpfs                       396M     0  396M   0% /run/user/1000
```
8 метров осталось! куда это годится? Кстати, строка `/dev/mapper/buben--vg-root` явно намекает, что диск buben смонтирован с помощью LVM. Окей, попробуем сресайзить его.

## гнилые советы
прежде всего стоит понять, что vdmk не поддерживает динамическое увеличение размера. Я довольно быстро удивился:
```
Код ошибки: VBOX_E_NOT_SUPPORTED (0x80BB0009)
Компонент:  MediumWrap
```
Это так же подтверждают форумчане: [раз](https://forums.virtualbox.org/viewtopic.php?f=2&t=74483#p344720) [два](https://forums.virtualbox.org/viewtopic.php?f=35&t=50661) [три](https://stackoverflow.com/a/11659046).
А все потому что vdmk это [родной формат](https://superuser.com/a/440384) VMWare и нехуй многого ожидать от него в VirualBox. Городить свои костыли к чужим костылям никто не будет, надо конвертить в vdi и использовать только его. Т.е. надо сначала конвертировать в vdi а потом уже вдувать гигабайты в образ. Ну это если вам не охота ставить кривенькую VMWare. Кривеньку, потому что она [не для простых смертных](http://www.vmgu.ru/news/virtualbox-vs-vmware-workstation) ([архив](http://archive.fo/5VvVv), [peeep](http://peeep.us/cc82838d)) Но и тут не все просто.

## ресайз образа в хост системе
[Сначала](https://stackoverflow.com/a/44124662) проверить что в путях у вас есть приблуды VirtualBox `VBoxManage --help`. Скорее всего нихера у вас не сработает, по этому проверяете командой `"C:\Program Files\Oracle\VirtualBox\VBoxManage.exe" --help`. Это кстати справедливо для x64 систем.

Потом перейдите в каталог с виртуалкой
```
e:
cd proj\vBox\buben01
echo %cd%
```
> E:\proj\vBox\buben01
```
"C:\Program Files\Oracle\VirtualBox\VBoxManage.exe" clonehd "E:\proj\vBox\buben01\buben.vmdk" "E:\proj\vBox\buben01\buben.vdi" --format vdi
"C:\Program Files\Oracle\VirtualBox\VBoxManage.exe" modifyhd "E:\proj\vBox\buben01\buben.vdi" --resize 35000
```
Ну как бы круто, да, вот только надо этот образ еще смонтировать. Проще и без геморроя сделать так
* создать виртуалку без диска
* перенести vdi вайл в новый каталог, созданный системой 
* в менеджере виртуальных носителей убить старую запись, если перенесли файл тупо копированием.
* в настройках новой виртуалки указать путь к этому диску
* там же подравить все остальные конфиги: проц, память, сетевой мост. Все слетело нахер.
* вставить liveCD от kubuntu

ну теперь грузимся, пол дела сделано.

## ресайз образа в гостевой системе
Одному богу известно, как я догадался поставить ubuntu поверх [lvm](http://mcgrog.blogspot.ru/2014/05/lvm.html) но это облегчило ситуацию. Всего то надо загрузиться и запустить `partitionmanager`. У него человеческий гуй, не надо всю эту вот ебалу с активацией/деатктивацей раздела. Может быть когда-нибудь дополню этот раздел консольными командами, но дико лень.

## прочие конфиги
меня оч убивает то, что после подобных манипуляций слетают старые ip. Вот прям жесть просто. По этому надо прописать статикой старые ip в файле.  Если чо, вам надо конфигурить это интерфейс `cat /etc/network/interfaces | grep -v lo | grep auto` у меня она с затейливым названием enp0s3 и по этому `sudo vim /etc/network/interfaces` я заполню так
```
auto enp0s3
#iface enp0s3 inet dhcp
iface enp0s3 inet static
   address 192.168.1.125
   netmask 255.255.255.0
   gateway 192.168.1.12 # там висит роутер на openwrt
   network 192.168.1.0 # ну тут без вариантов
   dns-nameservers 192.168.1.12 8.8.8.8
```
и перезапускаем `sudo service networking restart`