#!/bin/bash
sudo apt update 
sudo apt upgrade -y
sudo apt -y install apache2
sudo systemctl enable --now apache2