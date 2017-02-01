# shellinabox howto

This is app ([repo](https://github.com/shellinabox/shellinabox)) for ssh access from browser. Last chance to get access to your sandbox from anywhere, even if you cannot install [Secure Shell](https://chromium.googlesource.com/apps/libapps/+/master/nassh/doc/FAQ.md)

## installation
```
apt-get update
apt-get install git libssl-dev libpam0g-dev zlib1g-dev dh-autoreconf
apt-get install shellinabox 
reboot
```

## features
for solarized theme run this
```
wget https://raw.githubusercontent.com/mcgr0g/rancho/master/shellinabox/00_solarized.css
ls -la
cp 00_solarized.css /etc/shellinabox/options-available/
ln -s /etc/shellinabox/options-available/00_solarized.css /etc/shellinabox/options-enabled/
/etc/init.d/shellinabox restart
```
