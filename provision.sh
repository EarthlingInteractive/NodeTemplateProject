# Used to provision!

set -euo pipefail


#### Install some packages needed by later steps

apt-get install -y wget


#### Set up Postgres

postgres_password='REJ#%*OfdaklJ*O4t5eH'

wget -q -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -
echo "deb http://apt.postgresql.org/pub/repos/apt/ trusty-pgdg main" >> /etc/apt/sources.list.d/postgresql.list
uniq /etc/apt/sources.list.d/postgresql.list >/tmp/postgresql.list
mv /tmp/postgresql.list /etc/apt/sources.list.d/postgresql.list

apt-get update -y
apt-get install -y postgresql-9.3 postgresql-contrib postgresql-9.3-postgis-2.1

service postgresql start

sed -i 's/127.0.0.1\/32/0.0.0.0\/0/g' /etc/postgresql/9.3/main/pg_hba.conf
sed -i "s/#listen_addresses = 'localhost'/listen_addresses = '*'/g" /etc/postgresql/9.3/main/postgresql.conf

sudo -u postgres psql -U postgres -d postgres -c "alter user postgres with password '${postgres_password}';"


apt-get install -y vim make openjdk-7-jdk git zip emacs24-nox screen


#### Install PHP

apt-get install -y \
    php5 php5-cli php5-curl php5-mcrypt php5-dev php5-pgsql php5-gd php5-tidy

wget -q 'https://getcomposer.org/installer' -O - | php
mv composer.phar /usr/local/bin/composer


#### Install node

curl -sL https://deb.nodesource.com/setup_4.x | sudo -E bash - > /dev/null
sudo apt-get install -y nodejs



###E Create the database

sudo -u vagrant make -C /vagrant build/db/create-database.sql
# Purposely leaving off the usual '-v ON_ERROR_STOP=1' for now
# so that reprovisioning will not crash due to the database
# already existing:
sudo -u postgres psql </vagrant/build/db/create-database.sql

echo "To run the server, 'vagrant ssh' and then"
echo "$ cd /vagrant"
echo "$ make upgrade-database run-server"
