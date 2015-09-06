#!/bin/bash
useradd diablo
passwd diablo <<EOF
Ludador3!!
Ludador3!!
EOF

mkdir /home/diablo/.ssh

echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC+JjFiWaIIM8mt6u/0BC7dEYiZ4cpvm76OoP6MKr1vM4AVJb8L6hwuen+U01Vt0pxPDpvBBlxYpo3I2eMYc4g/HpZKP3GgIWVHtgdhI800vCVaYoSohdPWuDJKoeAymUXw6QJJZoL0JJyJZqvpJscoHHCG9bTxHbFvqN7WI8kX6CnT1nttNILt7y3grYKt8NxvdaQjloKOvzmP9JchBdo9/Ooz0suzqtTs27VfEjEtvabolD53zfRPwHCN4eXw7MqbfLIFdteed0gSHtyl+E+lyyrknd69cWmnebqgdIBnTvS1K4CnRZ3NOAMnB3oirN0L2sNrdkRCXN99BKiHFHmF ehsan@iMac-ehsan.home" > /home/diablo/.ssh/authorized_keys

chown diablo /home/diablo/.ssh
chown diablo /home/diablo/.ssh/authorized_keys
chmod 700 /home/diablo/.ssh
chmod 400 /home/diablo/.ssh/authorized_hosts

echo "diablo 	ALL=(ALL) 	NOPASSWD:ALL" > /etc/sudoers

sed '/PasswordAuthentication yes/d'  /etc/ssh/sshd_config > /tmp/sshd_config
echo "PasswordAuthentication no " /tmp/ssh_config
mv /tmp/sshd_config /etc/ssh/sshd_config

chmod 400 /etc/ssh/sshd_config

service sshd restart

