#!/bin/bash
#
###########
apt-get update -y && apt-get upgrade -y && apt-get dist-upgrade -y
apt-get autoclean -y
apt-get install build-essential wget curl nano sudo -y
sudo apt-get install linux-image-`uname -r` -y
###

useradd diablo -m -d /home/diablo -s /bin/bash
passwd diablo <<EOF
TNa3AGmybLtc
TNa3AGmybLtc
EOF


mkdir /home/diablo/.ssh
echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDtx8dfK5rsxMJRSgV8MMFCQjAPk435SMnnnpqAmFldXQdAIqf/F55eAM/l2DMuWk6SLTXraktBNdlAN3edig5CX0B2CkPdHkvUusaI7bessXw9Lup/pA/UxinvUX8lv0aZwldMd60c3T5oAGdOK+RR/eTstQSr/wk2r9BH+Uouh3GBH3osHrZ66DKxoEWYRV3rDOKpLlWm8szyJ7ppJap8I+sWyvFbyal6iJ4mP+OnhTgBjJTpz5xLnXkutpaC+yp9qRrGNGFrqgeSW/MdyuLHrYG4XdKmWrz/Y4j1vbtTkmLAT3hIWtk8d682m4Lvs5rEMrtCqrErWR+6CqUAdGCV ehsan@iMac-ehsan.local"> /home/diablo/.ssh/authorized_keys
chown diablo /home/diablo/.ssh
chown diablo /home/diablo/.ssh/authorized_keys

chmod 700 /home/diablo/.ssh
chmod 400 /home/diablo/.ssh/authorized_keys
####
echo "diablo	ALL=(ALL)	NOPASSWD:ALL" >> /etc/sudoers

#######
sed '/PasswordAuthentication yes/d' /etc/ssh/sshd_config > /tmp/sshd_config
sed '/UsePAM yes/d' /etc/ssh/sshd_config > /tmp/sshd_config
sed '/ChallengeResponseAuthentication yes/d' /etc/ssh/sshd_config  > /tmp/sshd_config
echo "PasswordAuthentication no" >> /tmp/sshd_config
echo "UsePAM no" >> /tmp/sshd_config
echo "ChallengeResponseAuthentication no" >> /tmp/sshd_config
#######

mv /tmp/sshd_config /etc/ssh/sshd_config
chmod 400 /etc/ssh/sshd_config

service ssh restart
