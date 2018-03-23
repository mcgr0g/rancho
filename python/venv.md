# virtualenv recept
Все зависит от того в каком окружении вы делаете и для чего.
Если это single-user - выбирайте путь шареда.
Если это какая то виртуалка в компании - выбирайте для всего сервера.

## single-user
на шаред хостинге придется делать все только для [себя](https://gist.github.com/saurabhshri/46e4069164b87a708b39d947e4527298#gistcomment-2276320)
```
python3 -V
wget https://bootstrap.pypa.io/get-pip.py
chmod +x get-pip.py
python3 get-pip.py --user
echo "PATH=\$PATH:~/.local/bin" >> ~/.bashrc
source ~/.bashrc
cd ~/.local/bin
ls -la ~/.local/bin
./pip install virtualenv --user
./pip install virtualenvwrapper --user
sudo python3 get-pip.py
pip3 -V

```

## multi-user
на личном сервере для [всех](https://askubuntu.com/a/244642)
```
sudo apt update
sudo apt-get upgrade
sudo apt-get install python3-pip -y
sudo pip3 install --user pip
pip3 install --upgrade pip
pip install --user virtualenv
```
## path config
каждому пользаку потребуется прописать
```
ls -la ~/.local/bin #ниче нету
pip install --user virtualenvwrapper
ls -la ~/.local/bin #появилось
pip3 completion --bash >> ~/.bashrc #опционально ставим автокомплит pip'у, команд не так много
echo "source /usr/share/virtualenvwrapper/virtualenvwrapper.sh" >> ~/.bashrc
echo "export VIRTUALENVWRAPPER_PYTHON=/usr/bin/python3" >> ~/.bashrc
echo "source ~/.local/bin/virtualenvwrapper.sh" >> ~/.bashrc
export WORKON_HOME=~/.virtualenvs
mkdir $WORKON_HOME
echo "export WORKON_HOME=$WORKON_HOME" >> ~/.bashrc
source ~/.bashrc
```
## test
а теперь запустим нормальное окружение с python3
```
python -V
mkvirtualenv test
# mkvirtualenv -p python3 test #это если стоит несколько версий
workon test
python -V
pip3 -V
pip -V
```