#!/bin/bash

echo "Enter Password: "
read password

echo -n $password | cryptsetup luksOpen /dev/mmcblk0p3 sec_store -
mount /dev/mapper/sec_store /root/secstorage

echo "Mounted secure partition! - Press Enter to Continue."
read nothing
