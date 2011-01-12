#!/bin/bash
#Script to create an virtual image with 2 partitions
#On first partition boot files can be added
#On second partition root fs files can be added
#The resulting image can be written with dd on a real device
#(c) 2011 npavel@mini-box.com

export LC_ALL=C # force locale to prevent parsing problems

IMAGE=image.img #image name don't change this without changing sync-virtual-image.sh
L1=/dev/loop0   #entire disk loop device
L2=/dev/loop1   #boot partition loop device
L3=/dev/loop2   #rootfs partition loop device

MOUNT_BOOT_D="boot" # this is where boot partition will be mounted
MOUNT_ROOTFS_D="rootfs" # this is where rootfs partition will be mounted

BS=512 # block size used
COUNT=524288 # BS * COUNT = image size change this to change image size
CYL=$(($COUNT/63/255)) # 255 heads, 63 sectors
BOOT_SIZE=24 # boot partition size in MB
BOOT_PERC=$((($BOOT_SIZE*1024 *1024*100)/($BS*$COUNT)+1)) #partition size percentage
BOOT_CYL=$(($CYL*BOOT_PERC/100+1))


date > log.txt 2>&1
echo "Creating a $((($BS*$COUNT)/1024/1024)) MB image with $BOOT_PERC% boot partition"
echo "Creating a image with $CYL cylinders, $BOOT_PERC % boot with $BOOT_CYL cylinders" >> log.txt 2>&1

mkdir -p $MOUNT_BOOT_D >> log.txt 2>&1
mkdir -p $MOUNT_ROOTFS_D >> log.txt 2>&1

umount $L3 >> log.txt 2>&1
umount $L2 >> log.txt 2>&1

losetup -d $L3 >> log.txt 2>&1
losetup -d $L2 >> log.txt 2>&1
losetup -d $L1 >> log.txt 2>&1

rm -f $IMAGE

echo -n "*   Creating empty disk image..."
dd if=/dev/zero of=$IMAGE bs=$BS count=$COUNT >> log.txt 2>&1
losetup $L1 image.img >> log.txt 2>&1
echo "done"

echo -n "*   Creating partitions on $L1 ..."
sfdisk -H 255 -S 63 -C $CYL >> log.txt 2>&1 $L1 << EOF
,$BOOT_CYL,4
,,83
EOF
sleep 2 #wait for partition probing
echo "done"

BOOT_P_OFFSET=$(($(fdisk -ul $L1 | grep ${L1}p1 | awk '{print $2}')*512))
BOOT_P_SIZE=$(($(fdisk -ul $L1 | grep ${L1}p1 | awk '{print $3}')*1024))
ROOT_P_OFFSET=$(($(fdisk -ul $L1 | grep ${L1}p2 | awk '{print $2}')*512))
ROOT_P_SIZE=$(($(fdisk -ul $L1 | grep ${L1}p2 | awk '{print $3}')*1024))

echo "BOOT: $BOOT_P_OFFSET, $BOOT_P_SIZE ROOTFS: $ROOT_P_OFFSET, $ROOT_P_SIZE" >> log.txt 2>&1

echo -n "*   Setting up virtual partitions..."
losetup -o $BOOT_P_OFFSET --sizelimit $BOOT_P_SIZE $L2 $L1
losetup -o $ROOT_P_OFFSET --sizelimit $ROOT_P_SIZE $L3 $L1
echo "done"
echo -n "*   Creating MSDOS filesystem for BOOT partition ..."
mkfs.msdos -n "BOOT" -F 16 $L2 >>log.txt 2>&1
echo "done"
echo -n "*   Creating EXT3 filesystem for ROOTFS partition ..."
mkfs.ext3 -m 0 -L "ROOTFS" $L3 >>log.txt 2>&1
echo "done"

echo -n "*   Mounting paritions ..."
mount $L2 $MOUNT_BOOT_D
mount $L3 $MOUNT_ROOTFS_D
echo "done"

echo "All done you can copy your files to $MOUNT_BOOT_D and $MOUNT_ROOTFS_D"
echo "Execute sync-virtual-image.sh to save what you copied when done"
