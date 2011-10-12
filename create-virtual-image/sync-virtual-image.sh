#!/bin/bash
#(c) 2011 npavel@mini-box.com

export LC_ALL=C # force locale to prevent parsing problems

LOG="tmp/log.txt"
DATE=$(date +%F)
OUTPUT_DIR="./generated-images/"
OUTPUT_ZIP="image-${DATE}.zip"
IMAGE="tmp/image.img"
L1=/dev/loop0   #entire disk loop device
L2=/dev/loop1   #boot partition loop device
L3=/dev/loop2   #rootfs partition loop device

MOUNT_BOOT_D="boot" # this is where boot partition will be mounted
MOUNT_ROOTFS_D="rootfs" # this is where rootfs partition will be mounted

sync

umount $L3 >> $LOG 2>&1
umount $L2 >> $LOG 2>&1

losetup -d $L3 >> $LOG 2>&1
losetup -d $L2 >> $LOG 2>&1
losetup -d $L1 >> $LOG 2>&1

# TODO make a config/vars for this
IMAGE_PATH=`dirname ${IMAGE}`

echo -n "Enter name prefix or [ENTER] for default name $OUTPUT_ZIP:"
read prefix

if [ -z $prefix ] 
then
    name=${OUTPUT_DIR}${OUTPUT_ZIP}
    NEW_IMAGE_NAME="${IMAGE_PATH}/image-${DATE}.img"
else
    name="${OUTPUT_DIR}$prefix-$DATE.zip"
    NEW_IMAGE_NAME="${IMAGE_PATH}/$prefix-${DATE}.img"
fi

# rename the image file
mv ${IMAGE} ${NEW_IMAGE_NAME}
IMAGE=${NEW_IMAGE_NAME}

zip -9 -m -j $name $IMAGE #-j do not store path

