#!/bin/bash

set -e

echo "======================================"
echo " DevOps Server Bootstrap Started"
echo "======================================"

# ------------------------------------
# Update System
# ------------------------------------

sudo dnf update -y

# ------------------------------------
# Install Base Utilities
# ------------------------------------

sudo dnf install -y \
  git \
  wget \
  curl \
  unzip \
  tar \
  jq \
  vim

# ------------------------------------
# Install Java 21 (LTS)
# ------------------------------------

sudo dnf install -y java-21-amazon-corretto-devel

java -version

# ------------------------------------
# Install Jenkins
# ------------------------------------

sudo wget -O /etc/yum.repos.d/jenkins.repo \
  https://pkg.jenkins.io/redhat-stable/jenkins.repo

sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key

sudo dnf install -y jenkins

# Change Jenkins Port (Optional)

sudo sed -i \
's/JENKINS_PORT="8080"/JENKINS_PORT="8081"/g' \
/usr/lib/systemd/system/jenkins.service

sudo systemctl daemon-reload

sudo systemctl enable jenkins
sudo systemctl start jenkins

# ------------------------------------
# Install Maven
# ------------------------------------

sudo dnf install -y maven

mvn -version

# ------------------------------------
# Install NodeJS + npm
# ------------------------------------

sudo dnf module enable nodejs:20 -y
sudo dnf install -y nodejs

node -v
npm -v

# ------------------------------------
# Install Docker CE
# ------------------------------------

sudo dnf remove docker \
                docker-client \
                docker-client-latest \
                docker-common \
                docker-latest \
                docker-latest-logrotate \
                docker-logrotate \
                docker-engine -y || true

sudo dnf install -y dnf-plugins-core

sudo dnf config-manager \
--add-repo \
https://download.docker.com/linux/centos/docker-ce.repo

sudo dnf install -y \
docker-ce \
docker-ce-cli \
containerd.io \
docker-buildx-plugin \
docker-compose-plugin

sudo systemctl enable docker
sudo systemctl start docker

# Add Users to Docker Group

sudo usermod -aG docker ec2-user || true
sudo usermod -aG docker jenkins || true

# ------------------------------------
# Install AWS CLI v2
# ------------------------------------

curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" \
-o "awscliv2.zip"

unzip -o awscliv2.zip

sudo ./aws/install --update

aws --version

# ------------------------------------
# Install kubectl (Latest Stable)
# ------------------------------------

curl -LO "https://dl.k8s.io/release/$(curl -L -s \
https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"

chmod +x kubectl

sudo mv kubectl /usr/local/bin/

kubectl version --client

# ------------------------------------
# Install eksctl
# ------------------------------------

ARCH=amd64
PLATFORM=$(uname -s)_$ARCH

curl -sLO \
"https://github.com/eksctl-io/eksctl/releases/latest/download/eksctl_${PLATFORM}.tar.gz"

tar -xzf eksctl_${PLATFORM}.tar.gz -C /tmp

sudo mv /tmp/eksctl /usr/local/bin

eksctl version

# ------------------------------------
# Install Helm
# ------------------------------------

curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

helm version

# ------------------------------------
# Install Trivy Security Scanner
# ------------------------------------

sudo rpm -ivh \
https://github.com/aquasecurity/trivy/releases/latest/download/trivy_0.56.2_Linux-64bit.rpm \
|| true

trivy --version

# ------------------------------------
# Install OWASP ZAP
# ------------------------------------

wget -O ZAP_latest_unix.sh \
https://github.com/zaproxy/zaproxy/releases/latest/download/ZAP_latest_unix.sh

chmod +x ZAP_latest_unix.sh

sudo ./ZAP_latest_unix.sh -q

# ------------------------------------
# Restart Jenkins
# ------------------------------------

sudo systemctl restart jenkins

# ------------------------------------
# Service Status
# ------------------------------------

echo "======================================"
echo " Service Status"
echo "======================================"

sudo systemctl status jenkins --no-pager
sudo systemctl status docker --no-pager

# ------------------------------------
# Final Versions
# ------------------------------------

echo "======================================"
echo " Installed Versions"
echo "======================================"

java -version
docker --version
aws --version
kubectl version --client
eksctl version
helm version
node -v
npm -v
mvn -version

echo "======================================"
echo " DevOps Bootstrap Completed"
echo "======================================"