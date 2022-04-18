#!/bin/bash

sudo yum update -y
sudo yum install postgresql-server postgresql-contrib -y

sudo postgresql-setup initdb
sudo systemctl start postgresql
sudo systemctl enable postgresql

sudo su -
sudo su postgres
psql

ALTER USER postgres WITH PASSWORD 'postgres';

# Create db for Geo Citizen
CREATE DATABASE ss_demo_1;

# Add tcp port 5432 in firewall-cmd
sudo firewall-cmd --zone=public --permanent --add-port=5432/tcp
sudo firewall-cmd --reload
sudo firewall-cmd --list-ports

# Change listening address

sudo sed -il "s/#listen_addresses = 'localhost'/listen_addresses = '*'/g" /var/lib/pgsql/data/postgresql.conf

# Add these two lines at end of file
sudo echo "host      all     all     0.0.0.0/0     md5" >> /var/lib/pgsql/data/pg_hba.conf
sudo echo "host      all     all     ::/0          md5" >> /var/lib/pgsql/data/pg_hba.conf

sudo systemctl restart postgresql.service
