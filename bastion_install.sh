#!/bin/bash
sudo dnf update
sudo dnf install -y git
sudo dnf install -y python3-pip
pip install ansible
ansible-galaxy collection install amazon.aws --force
sudo pip3 install boto3
sudo chmod 400 ~/.ssh/bastion

