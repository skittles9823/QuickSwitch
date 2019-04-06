#!/system/bin/sh
# Do NOT assume where your module will be located.
# ALWAYS use $MODDIR if you need to know where this script
# and module is placed.
# This will make sure your module will still work
# if Magisk change its mount point in the future
MODDIR=${0%/*}

# This script will be executed in late_start service mode
# Start logging
MODID=quickstepswitcher
set -x 2>$MODDIR/logs/$MODID-service.log

# Assign vars
SWITCHER_DIR=/data/user_de/0/xyz.paphonb.quickstepswitcher
SWITCHER_OUTPUT=$SWITCHER_DIR/files
DID_MOUNT_RW=
if [ -f "$SWITCHER_OUTPUT/lastChange" ]; then
  if [ -f "$SWITCHER_OUTPUT/isProduct" ]; then
    if [ -f "$SWITCHER_OUTPUT/output/QuickstepSwitcherOverlay.apk" ]; then
      is_mounted() {
        cat /proc/mounts | grep " `readlink -f $1` " 2>/dev/null
        return $?
      }
      is_mounted_rw() {
        cat /proc/mounts | grep " `readlink -f $1` " | grep " rw," 2>/dev/null
        return $?
      }
      mount_rw() {
        mount -o remount,rw $1
        DID_MOUNT_RW=$1
      }
      unmount_rw() {
        if [ "x$DID_MOUNT_RW" = "x$1" ]; then
          mount -o remount,ro $1
        fi
      }
      if [ -L "/product" ]; then
        PRODUCT=$MODDIR/system/product/overlay
      else
        PRODUCT=/product/overlay
      fi
      if [ $PRODUCT = "/product/overlay" ]; then
        while [ ! -f $PRODUCT/QuickstepSwitcherOverlay.apk ]; do
          sleep 1
          is_mounted " /product" || mount /product
          is_mounted_rw " /product" || mount_rw /product
          cp -rf $SWITCHER_OUTPUT/output/QuickstepSwitcherOverlay.apk $PRODUCT/QuickstepSwitcherOverlay.apk
        done
        chmod 644 $PRODUCT/QuickstepSwitcherOverlay.apk
        unmount_rw /product
      fi
      if [ -f "$PRODUCT/QuickstepSwitcherOverlay.apk" ]; then
        rm -rf $SWITCHER_OUTPUT/lastChange
      fi
    fi
  fi
fi

# Eventually this'll get implemented so it's usable
#if [ -f "$SWITCHER_OUTPUT/gridRecents" ]; then GRID=true; fi
#[ "$GRID" ] && resetprop ro.recents.grid true || resetprop ro.recents.grid false

# Send the logs to $SDCARD/Documents/$MODID/
[ -d /storage/emulated/0 ] && SDCARD=/storage/emulated/0 || SDCARD=/data/media/0
mkdir -p $SDCARD/Documents/$MODID
cp -rf $MODDIR/logs/$MODID* $SDCARD/Documents/$MODID/