#!/bin/bash

sudo apt-get update  -y
sudo apt install default-jdk  -y
sudo apt install firewalld -y


# Set up network configuration
sudo systemctl enable firewalld
sudo systemctl start firewalld
sudo firewall-cmd --zone=public --add-port=8080/tcp --permanent
sudo firewall-cmd --reload


# Install tomcat9
sudo mkdir /opt/tomcat
sudo useradd -r -m -U -d /opt/tomcat -s /bin/false tomcat
sudo wget http://www.apache.org/dist/tomcat/tomcat-9/v9.0.62/bin/apache-tomcat-9.0.62.tar.gz -P /tmp
sudo tar xf /tmp/apache-tomcat-9*.tar.gz -C /opt/tomcat
sudo ln -s /opt/tomcat/apache-tomcat-9.0.62 /opt/tomcat/latest
sudo chown -RH tomcat: /opt/tomcat/latest
sudo sh -c 'chmod +x /opt/tomcat/latest/bin/*.sh'

sudo tee /etc/systemd/system/tomcat.service << EOL
[Unit]
Description=Tomcat 9 servlet container
After=network.target

[Service]
Type=forking

User=tomcat
Group=tomcat

Environment="JAVA_HOME=/usr/lib/jvm/default-java"
Environment="JAVA_OPTS=-Djava.security.egd=file:///dev/urandom -Djava.awt.headless=true"

Environment="CATALINA_BASE=/opt/tomcat/latest"
Environment="CATALINA_HOME=/opt/tomcat/latest"
Environment="CATALINA_PID=/opt/tomcat/latest/temp/tomcat.pid"
Environment="CATALINA_OPTS=-Xms512M -Xmx1024M -server -XX:+UseParallelGC"

ExecStart=/opt/tomcat/latest/bin/startup.sh
ExecStop=/opt/tomcat/latest/bin/shutdown.sh

[Install]
WantedBy=multi-user.target
EOL


sudo systemctl daemon-reload
sudo systemctl start tomcat
sudo systemctl enable tomcat
sudo ufw allow 8080/tcp

sudo tee /opt/tomcat/latest/conf/tomcat-users.xml << EOL
<tomcat-users>
<!--
   Comments
-->
   <role rolename="admin-gui"/>
   <role rolename="manager-gui"/>
   <user username="your_username" password="your_passwd" roles="admin-gui,manager-gui"/>
</tomcat-users>
EOL


sudo sed -i "s/<Valve className=/<\!--\n<Valve className=/g"  /opt/tomcat/latest/webapps/manager/META-INF/context.xml
sudo sed -i "s/<\/Context>/\n-->\n<\/Context>/g" /opt/tomcat/latest/webapps/manager/META-INF/context.xml
sudo sed -i "s/<Valve className=/<\!--\n<Valve className=/g"  /opt/tomcat/latest/webapps/host-manager/META-INF/context.xml
sudo sed -i "s/<\/Context>/\n-->\n<\/Context>/g"  /opt/tomcat/latest/webapps/host-manager/META-INF/context.xml

sudo systemctl restart tomcat


# Deploy GeoCitizen on Tomcat9

sudo apt install maven -y

git clone -b jenkins-pipeline https://github.com/eugenia-ponomarenko/SSITA-GeoCitizen-AWS.git

cd SSITA-GeoCitizen-AWS 

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