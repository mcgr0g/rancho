# настройка общих каталогов
в гостевой ububtu и хоcтовой windows

```
sudo apt-get update
sudo apt-get install virtualbox-guest-additions-iso
ls -la /usr/share/virtualbox/ | grep iso
sudo mount /usr/share/virtualbox/VBoxGuestAdditions.iso /media/cdrom
cd /media/cdrom
sudo ./VBoxLinuxAdditions.run
sudo reboot
```
метод рабочий, но не особо, у меня при старте сервис никак не добавлялся
сначала надо стартануть образ, потом в меню выбрать
> Devices -> Insert Guest Additions CD image to mount the ISO image.

Потом авторизоваться как root. Далее в терминале
```
apt-get install build-essential module-assistant
mount /dev/cdrom /media/cdrom/
cd /media/cdrom
sudo ./VBoxLinuxAdditions.run
sudo reboot
```
После ребута добавить своего пользователя в группу `sudo usermod --append --groups vboxsf USERNAME`
Каталог установленный в настройках virtualbox появится в /media