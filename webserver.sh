#!/bin/bash

sudo apt-add-repository ppa:ansible/ansible
sudo apt update
sudo apt install -y firewalld ansible maven 


# Set up network configuration
sudo systemctl enable firewalld
sudo systemctl start firewalld
sudo firewall-cmd --zone=public --add-port=8080/tcp --permanent
sudo firewall-cmd --reload


cd SSITA-DevOps

# Install tomcat9
ansible-playbook ./Ansible/play.yml

# Deploy GeoCitizen on Tomcat9

db_ip="10.0.0.120"

old_serverip="localhost\|[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}"
vm_host=$(curl --silent --url "www.ifconfig.me" | tr "\n" " ")

old_dbip="postgresql:\/\/[a-zA-Z0-9.-]*"
new_dbip="postgresql:\/\/$db_ip"

## fix webserver ip
sed -i "s/$old_serverip/$vm_host/g" ./src/main/java/com/softserveinc/geocitizen/configuration/MongoConfig.java   
sed -i "s/$old_serverip/$vm_host/g" ./src/main/webapp/static/js/app.6313e3379203ca68a255.js.map
sed -i "s/$old_serverip/$vm_host/g" ./src/main/webapp/static/js/vendor.9ad8d2b4b9b02bdd427f.js.map
sed -i "s/$old_serverip/$vm_host/g" ./src/main/webapp/static/js/vendor.9ad8d2b4b9b02bdd427f.js
sed -i "s/$old_serverip/$vm_host/g" ./src/main/webapp/static/js/app.6313e3379203ca68a255.js
sed -i "s/$old_serverip/$vm_host/g" ./src/main/resources/application.properties

## fix db ip
sed -i "s/$old_dbip/$new_dbip/g" ./src/main/resources/application.properties

# Build citizen.war

mvn install

sudo cp ./target/citizen.war  /opt/tomcat/latest/webapps/

sudo systemctl restart tomcat