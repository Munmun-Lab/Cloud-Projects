This is a **Linux shell script** used to prepare a complete:

```text
Jenkins + Docker + Java + Maven + AWS CLI + kubectl + eksctl
DevOps CI/CD Server
```

Mostly used on:

* AWS EC2
* Amazon Linux 2
* RHEL/CentOS

---

# What This Script Does Overall

```text
1. Updates Linux packages
2. Installs Java 17
3. Installs Jenkins
4. Installs Git
5. Installs NodeJS + npm
6. Installs Maven
7. Installs AWS CLI
8. Installs OWASP ZAP
9. Installs kubectl
10. Installs eksctl
11. Installs Docker
12. Gives Docker access to Jenkins
13. Starts services
```

---

# Step-by-Step Explanation

---

# 1. Script Interpreter

```bash id="5ys8sn"
#!/bin/bash
```

Means:

```text
Run this script using bash shell
```

---

# 2. Update Linux Packages

```bash id="qqgxvx"
sudo yum update
```

Updates installed packages metadata.

---

# 3. Add Jenkins Repository

```bash id="r5eeqx"
sudo wget -O /etc/yum.repos.d/jenkins.repo \
https://pkg.jenkins.io/redhat-stable/jenkins.repo
```

Downloads Jenkins repository file.

---

# Why?

Linux needs repository information to install Jenkins.

---

# 4. Import Jenkins GPG Key

```bash id="jlwmop"
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
```

Adds trusted signing key.

Purpose:

```text
Verify Jenkins packages are authentic
```

---

# 5. Upgrade Packages

```bash id="s1y0n6"
sudo yum upgrade -y
```

Upgrades all installed packages.

---

# 6. Install Java 17

```bash id="gbyqj5"
sudo dnf install java-17-amazon-corretto-devel -y
```

Installs:

```text
Amazon Corretto Java 17
```

---

# Why Java?

Jenkins runs on Java.

---

# Commented Old Versions

```bash id="88tyaa"
#sudo yum install jenkins java-1.8.0-openjdk-devel -y
#sudo amazon-linux-extras install java-openjdk11
```

These old Java versions are disabled.

---

# 7. Install Git

```bash id="ytjlwm"
sudo yum install git -y
```

Git required for:

* GitHub
* GitLab
* Jenkins pipelines

---

# 8. Install NodeJS + npm

```bash id="tn9myr"
sudo yum install nodejs npm -y
```

Used for:

* React
* Angular
* JavaScript builds

---

# 9. Install Maven Repository

```bash id="wkk0jm"
sudo wget http://repos.fedorapeople.org/repos/dchen/apache-maven/epel-apache-maven.repo \
-O /etc/yum.repos.d/epel-apache-maven.repo
```

Adds Maven repository.

---

# 10. Modify Repository Version

```bash id="3kx2ii"
sudo sed -i s/\$releasever/6/g /etc/yum.repos.d/epel-apache-maven.repo
```

Replaces:

```text
$releasever → 6
```

using:

```text
sed = stream editor
```

---

# 11. Install Maven

```bash id="f0s92x"
sudo yum install -y apache-maven
```

Used for:

* Java builds
* Spring Boot
* CI/CD pipelines

---

# 12. Set Java 17 as Default

```bash id="lymd90"
sudo update-alternatives --set java \
/usr/lib/jvm/java-17-amazon-corretto.x86_64/bin/java
```

Makes Java 17 default system Java.

---

# 13. Install Jenkins

```bash id="5k8mjlwm"
sudo yum install jenkins -y
```

Installs Jenkins service.

---

# 14. Change Jenkins Port

```bash id="b2ff8g"
sudo sed -i -e \
's/Environment="JENKINS_PORT=[0-9]\+"/Environment="JENKINS_PORT=8081"/' \
/usr/lib/systemd/system/jenkins.service
```

Changes Jenkins port:

```text
8080 → 8081
```

---

# Why?

Avoid port conflicts.

---

# 15. Reload Systemd

```bash id="ez3s75"
sudo systemctl daemon-reload
```

Reloads service definitions.

---

# 16. Start Jenkins

```bash id="jlwmt6"
sudo systemctl start jenkins
```

Starts Jenkins service.

---

# 17. Check Jenkins Status

```bash id="s6l4e7"
sudo systemctl status jenkins
```

Verifies Jenkins running.

---

# 18. Download AWS CLI

```bash id="6a5mhn"
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" \
-o "awscliv2.zip"
```

Downloads AWS CLI v2.

---

# 19. Install unzip

```bash id="3h3l89"
sudo yum install unzip -y
```

Needed to extract zip files.

---

# 20. Extract AWS CLI

```bash id="z6qjlwm"
sudo unzip awscliv2.zip
```

---

# 21. Install AWS CLI

```bash id="w06yhm"
sudo ./aws/install
```

Installs AWS command-line tool.

---

# 22. Install OWASP ZAP

```bash id="xkjlwm"
sudo wget https://github.com/zaproxy/zaproxy/releases/download/v2.14.0/ZAP_2_14_0_unix.sh
```

Downloads security scanning tool.

---

# Make Executable

```bash id="o40m9u"
sudo chmod +x ZAP_2_14_0_unix.sh
```

---

# Silent Install

```bash id="br2d6n"
sudo ./ZAP_2_14_0_unix.sh -q
```

`-q` = quiet install.

---

# 23. Install kubectl

```bash id="jlwm9j"
curl -o kubectl ...
```

Downloads Kubernetes CLI.

---

# Make Executable

```bash id="a1xjlwm"
chmod +x ./kubectl
```

---

# Add to PATH

```bash id="1bhp6m"
mkdir -p $HOME/bin
cp ./kubectl $HOME/bin/kubectl
export PATH=$PATH:$HOME/bin
```

Makes kubectl accessible globally.

---

# Copy System Wide

```bash id="rlqhh2"
sudo cp kubectl /usr/local/bin/
```

---

# 24. Install eksctl

```bash id="4yzn2e"
curl --silent --location ...
```

Installs EKS cluster management tool.

Used for:

```text
AWS EKS Kubernetes clusters
```

---

# Move Binary

```bash id="slyv1n"
sudo mv /tmp/eksctl /usr/local/bin
```

---

# 25. Install Docker

```bash id="rq2o0g"
sudo yum install docker -y
```

Installs Docker engine.

---

# 26. Add User to Docker Group

```bash id="8kvjlwm"
sudo usermod -aG docker $USER
```

Allows current user to run Docker without sudo.

---

# Add Jenkins to Docker Group

```bash id="sd4n48"
sudo usermod -aG docker jenkins
```

Important for:

```text
Jenkins Docker builds
```

---

# 27. Restart Jenkins

```bash id="y4jlwm"
sudo service jenkins restart
```

Reloads new group permissions.

---

# 28. Start Docker

```bash id="85ns3c"
sudo systemctl start docker
```

---

# Enable Docker at Boot

```bash id="u9bd32"
sudo systemctl enable docker
```

---

# Check Docker Status

```bash id="jlwm1p"
sudo systemctl status docker
```

---

# 29. Install jq

```bash id="bpxcc0"
sudo yum install jq -y
```

`jq` is JSON parser.

Very useful in:

* AWS CLI
* APIs
* Jenkins pipelines

---

# Final Architecture

```text id="ep2u0g"
                Jenkins
                   │
        ┌──────────┼──────────┐
        │          │          │
      Maven      npm       Docker
        │                     │
        └──────Build──────────┘
                   │
               kubectl
                   │
                 EKS
                   │
                 AWS
```

---

# This server can now do:

✅ CI/CD pipelines
✅ Docker builds
✅ Kubernetes deployment
✅ AWS deployment
✅ Java builds
✅ NodeJS builds
✅ Security scanning
✅ Git integration

---

# Important Improvement Suggestions

Some packages/URLs are outdated.

Modern improvements:

| Current            | Better Option        |
| ------------------ | -------------------- |
| yum                | dnf                  |
| Manual kubectl URL | EKS latest stable    |
| Old Maven repo     | Official Apache repo |
| Hardcoded versions | Variables            |
| No error handling  | Add `set -e`         |

---

# Recommended Safe Script Start

```bash id="y26myu"
#!/bin/bash
set -e
```

Meaning:

```text
Stop script immediately if any command fails
```
