#!/bin/bash
#(c) 2011 npavel@mini-box.com

export LC_ALL=C # force locale to prevent parsing problems

DATE=$(date +%F)

OUTPUT_ZIP="android-2.1-eclair-${DATE}.zip"
IMAGE=image.img
L1=/dev/loop0   #entire disk loop device
L2=/dev/loop1   #boot partition loop device
L3=/dev/loop2   #rootfs partition loop device

MOUNT_BOOT_D="boot" # this is where boot partition will be mounted
MOUNT_ROOTFS_D="rootfs" # this is where rootfs partition will be mounted

sync

umount $L3 >> log.txt 2>&1
umount $L2 >> log.txt 2>&1

losetup -d $L3 >> log.txt 2>&1
losetup -d $L2 >> log.txt 2>&1
losetup -d $L1 >> log.txt 2>&1

echo -n "Enter name prefix or [ENTER] for default name $OUTPUT_ZIP:"
read prefix

if [ -z $prefix ] 
then
    name=$OUTPUT_ZIP
else
    name="$prefix-$DATE.zip"
fi


zip -9 $name $IMAGE