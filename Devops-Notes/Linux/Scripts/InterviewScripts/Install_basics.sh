#!/bin/bash
sudo apt update -y 
sudo apt install docker.io -y 
sudo usermod -aG docker $USER 
sudo chmod 666 /var/run/docker.sock 
sudo systemctl enable docker 
sudo systemctl start docker
