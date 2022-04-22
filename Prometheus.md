# Prometheus

**Table of Contents**
  - [Installation](#installation)
    - [Building from source](#building-from-source)
    - [Configuration Prometheus](#configuration-prometheus)
    - [Node Exporter](#node-exporter)
  - [Config](#config)

## Installation

[Docs](https://prometheus.io/docs/prometheus/latest/installation/)

### Building from source

To build Prometheus from source code, You need:
* Go [version 1.16 or greater](https://golang.org/doc/install).
* NodeJS [version 16 or greater](https://nodejs.org/).
* npm [version 7 or greater](https://www.npmjs.com/).


```bash
wget https://go.dev/dl/go1.18.1.linux-amd64.tar.gz
sudo rm -rf /usr/local/go && sudo tar -C /usr/local -xzf go1.18.1.linux-amd64.tar.gz
curl -L -s https://deb.nodesource.com/setup_16.x | sudo bash
sudo apt install -y nodejs
sudo npm install npm -g
```
(optional upgrade npm (check your output))

```bash
sudo npm install -g npm@8.7.0
```

Add `prometheus` and `node_exporter` user  

```bash
sudo useradd --no-create-home --shell /bin/false prometheus
sudo useradd --no-create-home --shell /bin/false node_exporter
```
You can also clone the repository yourself and build using `make build`, which will compile in
the web assets so that Prometheus can be run from anywhere:
> Execute next section with `root` user by `sudo su`  

```bash
cd /opt
git clone https://github.com/prometheus/prometheus.git
cd prometheus
make build
```
> You can exit now from root user by `exit`  


The Makefile provides several targets:

  * *build*: build the `prometheus` and `promtool` binaries (includes building and compiling in web assets)
  * *test*: run the tests
  * *test-short*: run the short tests
  * *format*: format the source code
  * *vet*: check the source code for common errors
  * *assets*: build the new experimental React UI

### Configuration Prometheus

An example of the above configuration file can be found [here.](https://github.com/prometheus/prometheus/blob/main/documentation/examples/prometheus.yml)  
Create file `prometheus.yml` with the following content:
```yaml
global:
  scrape_interval: 15s
  evaluation_interval: 15s

scrape_configs:
  - job_name: "prometheus"
    static_configs:
      - targets: ["localhost:9090"]
```

[Basic auth](https://prometheus.io/docs/guides/basic-auth/)

```bash
sudo apt install python3-bcrypt
sudo vim gen-pass.py
```
Content:
```python
import getpass
import bcrypt

password = getpass.getpass("password: ")
hashed_password = bcrypt.hashpw(password.encode("utf-8"), bcrypt.gensalt())
print(hashed_password.decode())
```
Run this code
```bash
python3 gen-pass.py
```
Create your password and save the hash.

Then create `web.yml`

```bash
sudo vim /opt/prometheus/web.yml
```
Conetent:
```yaml
basic_auth_users:
    admin: $2b$12$hNf2lSsxfm0.i4a.1kVpSOVyBCfIB51VRjgBUyv6kdnyTlgWj81Ay
```

> **Note**: In this case the **username** will be **admin** and this hash is for password **test**, you should change it according to your needs.


Then execute
```bash
sudo mkdir -p /var/lib/prometheus
sudo chown -R prometheus:prometheus /opt/prometheus
sudo chown -R prometheus:prometheus /var/lib/prometheus
```

Create service file

```bash
sudo vim /etc/systemd/system/prometheus.service
```
Content:

```service
[Unit]
Description=Prometheus
Wants=network-online.target
After=network-online.target

[Service]
User=prometheus
Group=prometheus
Type=simple
ExecStart=/opt/prometheus/prometheus \
    --config.file /opt/prometheus/prometheus.yml \
    --storage.tsdb.path /var/lib/prometheus/ \
    --web.config.file=/opt/prometheus/web.yml \
    --web.console.templates=/opt/prometheus/consoles \
    --web.console.libraries=/opt/prometheus/console_libraries

[Install]
WantedBy=multi-user.target
```

And make some adjustments in config file due to basic auth:

```yaml
scrape_configs:
  - job_name: "prometheus"
    scrape_interval: 15s
    basic_auth:
      username: admin             # this line is added
      password: {{YOUR_PASSWORD}} # this line is added
    static_configs:
      - targets: ["localhost:9090"]
```

Reload daemon and start service

```bash
sudo systemctl daemon-reload
sudo systemctl start prometheus
sudo systemctl enable prometheus
```

### Node Exporter

Download [latest release](https://prometheus.io/download/#node_exporter):

```bash
wget https://github.com/prometheus/node_exporter/releases/download/v1.3.1/node_exporter-1.3.1.linux-amd64.tar.gz

```
Extract
```bash
tar xvfz node_exporter-1.3.1.linux-amd64.tar.gz
sudo chown node_exporter:node_exporter node_exporter-1.3.1.linux-amd64/node_exporter
sudo mv node_exporter-1.3.1.linux-amd64/node_exporter /usr/local/bin/node_exporter
sudo rm -rf node_exporter-1.3.1.linux-amd64 node_exporter-1.3.1.linux-amd64.tar.gz
```

Create systemd service  

```bash
sudo vim /etc/systemd/system/node_exporter.service
```

Content:  

```service
[Unit]
Description=Node Exporter
Wants=network-online.target
After=network-online.target

[Service]
User=node_exporter
Group=node_exporter
Type=simple
ExecStart=/usr/local/bin/node_exporter --collector.ethtool --collector.network_route --collector.systemd

[Install]
WantedBy=multi-user.target
```

```bash
sudo systemctl daemon-reload
sudo systemctl start node_exporter
sudo systemctl enable node_exporter
sudo systemctl status node_exporter
```

Status should be running.

## Config

[Add supervisor monitoring](https://rtfm.co.ua/prometheus-node_exporter-monitoring-supervisord/)

[Add dynamic scraping](https://prometheus.io/docs/prometheus/latest/configuration/configuration/#gce_sd_config)  
Example config:
```yaml
scrape_configs:
# skipped data
  - job_name: 'GCP instances'
    scrape_interval: 15s
    gce_sd_configs:
         # US west 1b
      - project: "YOUR_PROJECT_ID"
        zone: "us-west1-b"
        port: 9100
# skipped data
```
[Jenkins monitoring](https://www.youtube.com/watch?v=3H9eNIf9KZs)

Example config:
```yaml
scrape_configs:
# skipped data
  - job_name: 'Jenkins'
    scrape_interval: 15s
    metrics_path: /prometheus/
    static_configs:
      - targets: ["10.138.0.8:8080"]
# skipped data
```

[Nginx monitoring](https://github.com/nginxinc/nginx-prometheus-exporter)  
`prometheus.yml`
```yaml
scrape_configs:
# skipped data
  - job_name: 'nginx-graphite-grafana'
    scrape_interval: 15s
    static_configs:
      - targets: ["10.138.0.17:9113"]
# skipped data
```

`/etc/supervisor/conf.d/nginx-prometheus-exporter.conf`  

```
[program:nginx-prometheus-exporter]

command = /usr/bin/nginx-prometheus-exporter -nginx.scrape-uri=http://127.0.0.1/nginx_status

autostart=true

autorestart=true

redirect_stderr = true
```

[Grafana monitoring](https://grafana.com/docs/grafana/latest/administration/view-server/internal-metrics/)

*Reverse proxy nginx rettings adjustment^*

```bash
server {
  server_name grafana.vladkarok.ml www.grafana.vladkarok.ml;

## DATA OMMITED

  location / {
    proxy_set_header Host $http_host;
    proxy_pass http://localhost:3000/;
  }
  location /metrics {
    proxy_set_header Host $http_host;
    proxy_pass http://localhost:3000/metrics;
    allow {{$IP_ADDRESS}};  # IP of the PROMETHEUS server
    deny all;
  }

## DATA OMMITED

```

[Variety of exporters](https://github.com/prometheus/prometheus/wiki/Default-port-allocations)

[Docker monitoring](https://docs.docker.com/config/daemon/prometheus/)