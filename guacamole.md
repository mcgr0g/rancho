# prerequisite
## install required packages
```
apt -y update && apt-get -y dist-upgrade
add-apt-repository ppa:webupd8team/java
apt -qq -y update
apt -y install libcairo2-dev libjpeg-turbo8-dev libpng12-dev libossp-uuid-dev libfreerdp-dev libpango1.0-dev libssh2-1-dev libtelnet-dev \
libvncserver-dev libpulse-dev libssl-dev libvorbis-dev libwebp-dev git build-essential autoconf libtool oracle-java8-installer tomcat8 \
tomcat8-admin tomcat8-common tomcat8-docs tomcat8-user maven postgresql-server-dev-9.5 postgresql-common postgresql-9.5 libpulse-dev \
libvorbis-dev freerdp ghostscript wget pwgen
if [[ $(apt-cache show tomcat8 | egrep "Version: 8.[5-9]" | wc -l) -gt 0 ]] then TOMCAT="tomcat8" else TOMCAT="tomcat7" fi
```

## create directories & files
```
mkdir -p /etc/guacamole
mkdir -p /etc/guacamole/lib
mkdir -p /etc/guacamole/extensions
touch /etc/guacamole/user-mapping.xml
```
# get the app
## configure GUACAMOLE_HOME for tomcat
```
GUACVERSION="1.0.0"
echo "" >> /etc/default/${TOMCAT}
# echo "" >> /etc/default/tomcat8
echo "# GUACAMOLE ENV VARIABLE" >> /etc/default/${TOMCAT}
echo "GUACAMOLE_HOME=/etc/guacamole" >> /etc/default/${TOMCAT}
cd /opt
```

## install guacamole server
```
git clone https://github.com/apache/incubator-guacamole-server.git
cd incubator-guacamole-server/
autoreconf -fi
./configure --with-init-dir=/etc/init.d
make && make install
ldconfig
systemctl enable guacd
```

## install guacamole client (web app)
```
cd /opt
git clone https://github.com/apache/incubator-guacamole-client.git
cd incubator-guacamole-client
mvn package
cp ./guacamole/target/guacamole-${GUACVERSION}.war /var/lib/${TOMCAT}/webapps/guacamole.war
# cp ./guacamole/target/guacamole-1.0.0.war /var/lib/${TOMCAT}/webapps/guacamole.war
```

## database config
```
posgresql
cp ./extensions/guacamole-auth-jdbc/modules/guacamole-auth-jdbc-postgresql/target/guacamole-auth-jdbc-postgresql-${GUACVERSION}.jar /etc/guacamole/extensions/
# cp ./extensions/guacamole-auth-jdbc/modules/guacamole-auth-jdbc-postgresql/target/guacamole-auth-jdbc-postgresql-1.0.0.jar /etc/guacamole/extensions/

mysql
# cp ./extensions/guacamole-auth-jdbc/modules/guacamole-auth-jdbc-mysql/target/guacamole-auth-jdbc-mysql-${GUACVERSION}.jar /etc/guacamole/extensions/
ldap
# cp ./extensions/guacamole-auth-ldap/target/guacamole-auth-ldap-${GUACVERSION}.jar /etc/guacamole/extensions/
```

### install postgresql connector
```
cd /usr/local/src
wget -c https://jdbc.postgresql.org/download/postgresql-42.2.5.jar
cp postgresql-42.0.0.jar /etc/guacamole/lib/
ln -s /usr/local/lib/freerdp/* /usr/lib/x86_64-linux-gnu/freerdp/.
```

# configure app

## configure guacamole properties
```
echo "#api-session-timeout: 60" >> /etc/guacamole/guacamole.properties
echo "available-languages: en" >> /etc/guacamole/guacamole.properties
echo "guacd-hostname: localhost" >> /etc/guacamole/guacamole.properties
echo "guacd-port: 4822" >> /etc/guacamole/guacamole.properties
echo "#guacd-ssl: true" >> /etc/guacamole/guacamole.properties
echo "lib-directory: /var/lib/tomcat8/webapps/guacamole/WEB-INF/classes" >> /etc/guacamole/guacamole.properties

# another auth providers
# echo "auth-provider: net.sourceforge.guacamole.net.basic.BasicFileAuthenticationProvider" >> /etc/guacamole/guacamole.properties
# echo "basic-user-mapping: /etc/guacamole/user-mapping.xml" >> /etc/guacamole/guacamole.properties
```

## configure postgresql for guacamole
```
echo "" >> /etc/guacamole/guacamole.properties
echo "postgresql-hostname: localhost" >> /etc/guacamole/guacamole.properties
echo "postgresql-port: 5432" >> /etc/guacamole/guacamole.properties
echo "postgresql-database: guacamole_db" >> /etc/guacamole/guacamole.properties
echo "postgresql-username: guacamole_user" >> /etc/guacamole/guacamole.properties
echo "postgresql-password: givemefuknaccess" >> /etc/guacamole/guacamole.properties
echo "postgresql-user-password-min-length: 8" >> /etc/guacamole/guacamole.properties
echo "postgresql-user-password-require-multiple-case: true" >> /etc/guacamole/guacamole.properties
echo "postgresql-user-password-require-symbol: true" >> /etc/guacamole/guacamole.properties
echo "postgresql-user-password-require-digit: true" >> /etc/guacamole/guacamole.properties
echo "postgresql-user-password-prohibit-username: true" >> /etc/guacamole/guacamole.properties
```

## link guacamole dir to tomcat
```
rm -rf /usr/share/${TOMCAT}/.guacamole
ln -s /etc/guacamole /usr/share/${TOMCAT}/.guacamole
service ${TOMCAT} restart
```
## postgresql provision the guacamole database
```
sudo su - postgres
cd /opt/incubator-guacamole-client/extensions/guacamole-auth-jdbc/modules/guacamole-auth-jdbc-postgresql/
#sudo -u postgres psql
#su postgres -
createdb guacamole_db
cat schema/*.sql | psql -d guacamole_db -f -
psql -d guacamole_db
CREATE USER guacamole_user WITH PASSWORD 'givemefuknaccess';
GRANT SELECT,INSERT,UPDATE,DELETE ON ALL TABLES IN SCHEMA public TO guacamole_user;
GRANT SELECT,USAGE ON ALL SEQUENCES IN SCHEMA public TO guacamole_user;
\q
```

## start
```
systemctl restart guacd

# guacd: /usr/local/sbin/guacd: error while loading shared libraries: libguac.so.12: cannot open shared object file: No such file
ldconfig

systemctl restart guacd
systemctl restart tomcat8
```

# nginx on router

##base
in `server{}` location
```
client_header_buffer_size    1k;
client_header_timeout        12;
large_client_header_buffers  2 1k;
client_body_buffer_size      10K;
client_body_timeout          12;
client_max_body_size         8m;
```

##new location
also in `server{}`
```
location /guac/ {
    proxy_pass http://buben.lan:8080/guacamole/;
    proxy_cookie_path /guacamole/ /guac/; ## because we have location: /guac/, instead of: /guacamole/
    proxy_buffering off;
    
    # Proxy parameters for WebSockets
    proxy_http_version 1.1;
    proxy_set_header        Host               $host;
    proxy_set_header        X-Real-IP          $remote_addr;
    proxy_set_header        X-Forwarded-For    $proxy_add_x_forwarded_for;
    proxy_set_header        X-Forwarded-Server $host;
    proxy_set_header        Upgrade            $http_upgrade;
    proxy_set_header        Connection         $http_connection;
    proxy_set_header        Connection         "Upgrade";
    proxy_set_header        Authorization      "";
    proxy_read_timeout      86400;
    proxy_redirect          off;
    access_log off;
}
```

# login
## default login
http://IP-ADDRESS:8080/guacamole/
guacadmin/guacadmin

## rdp
there is bug, new connection setup page dont know about `Guacamole Proxy Parameters (guacd)`
so set it by yourself:
Hostname = localhost
Port: 4822
Encryption: None

# slow to load?
apt-get install -y haveged