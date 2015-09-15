#!/bin/sh
#
###########
apt-get update && apt-get upgrade && apt-get dist-upgrade -y
apt-get autoremove && apt-get autoclean -y
apt-get install build-essential wget curl nano sudo -y
sudo apt-get install linux-image-`uname -r`
reboot 
