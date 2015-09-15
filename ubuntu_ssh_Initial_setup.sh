#!/bin/bash
#

# 1) Adds a standard admin or systems administration user to the machine;
# 2) Sets the admin users password;
# 3) Makes a directory '.ssh' in the admin users home directory;
# 4) Add a file 'authorized_keys' with your administration workstations public key;
# 5) Sets the correct permissions;
# 6) Adds the admin user as a sudoer;
# 7) Removes the ability to log in using ssh with a password.
# 
# The effect of this script is to deliver the ability for passwordless login to your new
# virtual machines from your administration workstation and passwordless sudo'ing. This 
# can save extensive amounts of time when your instancing many virtual or bare metal 
# machines on SoftLayer.
#
# Dependencies:
# 1) Generate SSH keys on your administration workstation;
# 2) Add this script as a standard post-install script to SoftLayer;
# 3) Set up your web accessible script - in my case on GitHub the URL is set as:
#
#
# License: MIT
# Copyright (c) 2015 Eamonn Killian, www.eamonnkillian.com
#
# Permission is hereby granted, free of charge, to any person obtaining a copy 
# of this software and associated documentation files (the "Software"), to deal 
# in the Software without restriction, including without limitation the rights 
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell 
# copies of the Software, and to permit persons to whom the Software is furnished 
# to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all 
# copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
# INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A 
# PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
# HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION 
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
# SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#
# First up we need to add our standard systems administration/devops user
#

adduser diablo
passwd diablo<<EOF
TNa3AGmybLtc
TNa3AGmybLtc
EOF

#
# Next we need to add the '.ssh' directory to our new users home directory
#

mkdir /home/diablo/.ssh

#
# Next we need to add our public key from the key files we generated on our
# administration workstation or the PC, Laptop or Mac your using as your 
# working client machine.
# 

echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDtx8dfK5rsxMJRSgV8MMFCQjAPk435SMnnnpqAmFldXQdAIqf/F55eAM/l2DMuWk6SLTXraktBNdlAN3edig5CX0B2CkPdHkvUusaI7bessXw9Lup/pA/UxinvUX8lv0aZwldMd60c3T5oAGdOK+RR/eTstQSr/wk2r9BH+Uouh3GBH3osHrZ66DKxoEWYRV3rDOKpLlWm8szyJ7ppJap8I+sWyvFbyal6iJ4mP+OnhTgBjJTpz5xLnXkutpaC+yp9qRrGNGFrqgeSW/MdyuLHrYG4XdKmWrz/Y4j1vbtTkmLAT3hIWtk8d682m4Lvs5rEMrtCqrErWR+6CqUAdGCV ehsan@iMac-ehsan.local"> /home/diablo/.ssh/authorized_keys

# 
# Now we need to make sure of the permissions and ownership of our ssh 
# directory and the authorized_keys file.
#

chown diablo /home/diablo/.ssh
chown diablo /home/diablo/.ssh/authorized_keys
chmod 700 /home/diablo/.ssh
chmod 400 /home/diablo/.ssh/authorized_keys

#
# Now we need to add our sysadm user to the sudoers file. In addition we will 
# make sure we don't have to use a password to sudo from the sysadm user.
#

echo "diablo	ALL=(ALL)	NOPASSWD:ALL" >> /etc/sudoers

# 
# Now we have a new sudoer user and a standard key exchange login we can harden
# the machine to remove the ability for anyone to ssh into our machine using a 
# password at all.
# 

sed '/PasswordAuthentication yes/d' /etc/ssh/sshd_config > /tmp/sshd_config
sed '/UsePAM yes/d' /etc/ssh/sshd_config > /tmp/sshd_config
sed '/ChallengeResponseAuthentication yes/d' > /tmp/sshd_config


echo "PasswordAuthentication no" >> /tmp/sshd_config
echo "UsePAM no" >> /tmp/sshd_config
echo "ChallengeResponseAuthentication no" >> /tmp/sshd_config
mv /tmp/sshd_config /etc/ssh/sshd_config
chmod 400 /etc/ssh/sshd_config

#
# Finally we can restart the SSH service
#

service ssh restart

