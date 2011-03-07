function unpack_android()
{
    #echo "Working in $CURRENT_PATH/$UNPACK_PATH"
    mkdir -p "$UNPACK_PATH"

    cd $UNPACK_PATH
    #unpack ramdisk (normal ramdisk img)
    echo -n "Unpacking android / ..."
    cat "$ANDROID_SDK_IMAGES_PATH/ramdisk.img" | gunzip | cpio -i
    cd "$CURRENT_PATH"

    echo -n "Unpacking android /system ..."
    #unpack system (yaffs2 img) that is mounted by android in /system
    mkdir -p "$UNPACK_PATH/system"
    cd "$UNPACK_PATH/system"
    $UNYAFFS_PATH/unyaffs "$ANDROID_SDK_IMAGES_PATH/system.img"
}

function apply_changes()
{
    cd "$CURRENT_PATH"
    #userdata.img is an empty file just create it's mount point on live fs
    mkdir -p "$UNPACK_PATH/data"

    #create other needed dirs
    mkdir -p "$UNPACK_PATH/bluetooth"
    mkdir -p "$UNPACK_PATH/cache"
    mkdir -p "$UNPACK_PATH/root"
    mkdir -p "$UNPACK_PATH/misc"


    # Add custom mini-box changes for picopc boards
    echo -n Performing custom changes...
    cp -a "$ANDROID_CUSTOM_CHANGES_PATH/"*  "$UNPACK_PATH/"
    # We don't need the emulator init
    rm -f "$UNPACK_PATH/init.goldfish.rc"
    # Silence dbus.conf permision denied
    chmod 444 "$CURRENT_PATH/$UNPACK_PATH/system/etc/dbus.conf"
    echo "done"
    # Create the latest link
    rm -f latest
    cd "$CURRENT_PATH"
    ln -sf "$UNPACK_PATH" latest
}


# parameter name of the output file
function pack_android_jffs2()
{
    mkfs.jffs2 -U -d latest -l -e 0x20000 -n -o "$OUTPUT_PATH/$1" -n
    # Remove the link
    rm -f "$OUTPUT_PATH/current.jffs2"
    ln -s "$OUTPUT_PATH/$1" "$OUTPUT_PATH/current.jffs2"
}
