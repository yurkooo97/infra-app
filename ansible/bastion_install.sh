#!/bin/bash
sudo dnf update
sudo dnf install -y git
sudo dnf install -y python3-pip
pip install ansible
ansible-galaxy collection install amazon.aws --force
sudo pip3 install boto3
chmod 400 /home/ec2-user/.ssh/bastion

