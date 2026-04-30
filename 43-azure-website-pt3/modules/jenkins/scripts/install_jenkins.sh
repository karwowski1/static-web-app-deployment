#!/bin/bash
set -e

sudo apt-get update
sudo apt-get install -y openjdk-17-jre git unzip gnupg software-properties-common curl wget

sudo curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | sudo gpg --dearmor -o /usr/share/keyrings/jenkins-keyring.asc
echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/" | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null

wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list

sudo apt-get update
sudo apt-get install -y jenkins terraform

curl -s https://raw.githubusercontent.com/terraform-linters/tflint/master/install_linux.sh | bash

sudo systemctl daemon-reload
sudo systemctl enable jenkins
sudo systemctl start jenkins