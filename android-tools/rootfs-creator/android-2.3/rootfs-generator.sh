#!/bin/bash
# Used to generate both an unpacked rootfs and a jffs2 image

# ANDROID_PRODUCT=generic # Use this if you haven't defined a new product in android
CURRENT_PATH=$(pwd)
ROOT="${CURRENT_PATH}/../.."
ANDROID_PRODUCT=picopc

#For a release build of android
ANDROID_SDK_IMAGES_PATH="/indevel/minibox-android/mydroid-2.3-picopc/out/target/product/$ANDROID_PRODUCT"
#For a debug build of android
#ANDROID_SDK_IMAGES_PATH="/indevel/minibox-android/mydroid-2.1-picopc/out/debug/target/product/$ANDROID_PRODUCT"

ANDROID_CUSTOM_CHANGES_PATH="${ROOT}/rootfs-custom-changes/android-2.3"
UNYAFFS_PATH="${ROOT}/tools/unyaffs"
DATE=$(date +%F-%H-%M-%S)
UNPACK_PATH="release-"$DATE

# For Google official apps
WITH_GAPPS=0
GAPPSZIP=gapps-gb-20110307-signed.zip
GAPPSMIRROR="http://goo-inside.me/gapps/"

. ./functions.sh

unpack_android
apply_changes

echo -e "Your android rootfs has been generated to ${CURRENT_PATH}/latest/\nYou can copy that directory content to SDCard"
exit

# Currently picoPC doesn't have nand memory so this section is skipped
# Ouput path for the built jffs2 rootfs
#OUTPUT_PATH="/indevel/minibox-android/android-images-rebuild/built-rootfs-images"
OUTPUT_PATH="/indevel/minibox-android/atmel-tools/flasher-minibox-android/rootfs/"
OUTPUT_FILENAME="android-atmel-2.1-release.jffs2"

echo -n "Enter resulting rootfs image name or [ENTER] for default name:"
read name

if [ -z $name ] 
then
    name=$OUTPUT_FILENAME
fi

pack_android_jffs2 $name
