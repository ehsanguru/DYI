# DYI
Basi DYI With the Things I have been Trying and Sorting For Endless Nights.

Setup.sh


Increase the Storage on "local" storage.

#First, navigate to "datacenter -> storage"
#Second, delete the "local-lvm" storage 
#Third, SSH into your server and run the follwing commands

lvremove /dev/pve/data
lvresize -l +100%FREE /dev/pve/root
resize2fs /dev/mapper/pve-root

#These commands resize the "local" storage.