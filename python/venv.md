# virtualenv recept
Все зависит от того в каком окружении вы делаете и для чего.
Если это single-user - выбирайте путь шареда.
Если это какая то виртуалка в компании - выбирайте для всего сервера.
Главное [помните](https://github.com/pypa/pip/issues/5599), что pip установленный через системный менеджер пакетов безбожно устаревает и вслучае если его поставить и обновить в каталог пользователя, то пути порвутся к хренам

## single-user
на шаред хостинге придется делать все только для [себя](https://gist.github.com/saurabhshri/46e4069164b87a708b39d947e4527298#gistcomment-2276320)
```
python3 -V
wget https://bootstrap.pypa.io/get-pip.py
chmod +x get-pip.py
python3 get-pip.py --user
ls -la ~/.local/bin #появилось
echo "PATH=\$PATH:~/.local/bin" >> ~/.bashrc
source ~/.bashrc
cd ~/.local/bin
./pip install virtualenv --user
./pip install virtualenvwrapper --user
pip3 -V
```

### path config
каждому пользаку потребуется прописать
```
echo "export VIRTUALENVWRAPPER_PYTHON=/usr/bin/python3" >> ~/.bashrc
echo "source ~/.local/bin/virtualenvwrapper.sh" >> ~/.bashrc
export WORKON_HOME=~/proj/.virtualenvs
mkdir $WORKON_HOME
echo "export WORKON_HOME=$WORKON_HOME" >> ~/.bashrc
source ~/.bashrc
```

## multi-user
на личном сервере для [всех](https://askubuntu.com/a/244642)
```
sudo su
wget https://bootstrap.pypa.io/get-pip.py
chmod +x get-pip.py
python3 -m pip install virtualenv virtualenvwrapper
ls -la /usr/local/bin/virtualenvwrapper.sh
ctrl+d
```

### path config
каждому пользаку потребуется прописать
```
echo "export VIRTUALENVWRAPPER_PYTHON=/usr/bin/python3" >> ~/.bashrc
echo "source /usr/local/bin/virtualenvwrapper.sh" >> ~/.bashrc
export WORKON_HOME=~/proj/.virtualenvs
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
# покаыват пути до бинарей у "нового" песочного питона
python -c "import sys.path; print(path)"
# показывает пути до бинаря пипа
python -m pip -V
# ну и остальное для затравки
python -V
pip3 -V
pip -V
```
вуаля