# Sonarqube

**Table of Contents**
 - [Sonarqube](#sonarqube)
    - [Installation](#installation)
    


https://www.sonarqube.org/
https://docs.sonarqube.org/latest/
and with the help of [this](https://thenewstack.io/how-to-install-the-sonarqube-security-analysis-platform/)

## Installation

**Hardware reqiurements**

```bash
sudo vim /etc/sysctl.conf
```

Add to the bottom (`shift+G`)

```bash
vm.max_map_count=524288
fs.file-max=131072
ulimit -n 131072
ulimit -u 8192
```

Then 

```bash
sudo vim /etc/security/limits.conf
```

Add to the bottom (`shift+G`)

```bash
sonarqube   -   nofile   131072
sonarqube   -   nproc    8192
```

In order for these changes to take effect, reboot the system

```bash
sudo reboot now
```

**Install OpenJDK 11**  

SonarQube depends on Java. For that, we’ll install OpenJDK 11, which can be done with the command:

```bash
sudo apt-get install openjdk-11-jdk -y
```

That was easy. Let’s move on.