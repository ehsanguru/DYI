#!/bin/sh
#
###########
apt-get update -y && apt-get upgrade -y && apt-get dist-upgrade -y
apt-get autoclean -y
apt-get install build-essential wget curl nano sudo -y
sudo apt-get install linux-image-`uname -r` -y
reboot 
