#!/bin/bash

echo "" > log.txt
DEVICE=$1

if [ -z $DEVICE ]
then
    echo "No disk specified. Please specify only the disk name without /dev/ (ie: sdf)"
    exit 1
fi

FULLPATH_DEVICE="/dev/$DEVICE"
IS_REMOVABLE=`cat /sys/block/$DEVICE/removable`

if [ -z "$IS_REMOVABLE" ]
then
    echo "Can't find the specified disk !"
    exit 1
fi

if [ "$IS_REMOVABLE" -ne  1 ]
then
    echo "Your specified device is not a removable device. You can never be too careful"
    exit 1
fi

if [ -z `which sfdisk` ]
then
    echo "sdfisk utility not found. Install it with apt-get install sfdisk (in Ubuntu)"
    exit 1
fi

echo "*   Creating partitions on $FULLPATH_DEVICE"
sfdisk >> log.txt 2>&1 $FULLPATH_DEVICE << EOF
,20,4
,,83
EOF

sleep 2

PART1="$FULLPATH_DEVICE"1
PART2="$FULLPATH_DEVICE"2

echo "*   Creating MSDOS filesystem on $PART1 for BOOT partition"
mkfs.msdos -n "BOOT" -F 16 $PART1
echo "*   Creating EXT3 filesystem on $PART2 for ROOTFS partition"
mkfs.ext3 -m 0 -L "ROOTFS" $PART2