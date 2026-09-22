#!/bin/bash
sudo yum update -y
sudo yum install git python3 python3-pip -y
sudo pip3 install flask 

cd /home/ec2-user

sudo rm -rf CPU-stersser
git clone https://github.com/dolev225/CPU-stersser.git

sudo cp /home/ec2-user/CPU-stersser/CPU-stress-code/cpu_stress.service /etc/systemd/system/

sudo systemctl daemon-reload
sudo systemctl enable cpu_stress.service
sudo systemctl start cpu_stress.service

sudo chown -R ec2-user:ec2-user /home/ec2-user/CPU-stersser