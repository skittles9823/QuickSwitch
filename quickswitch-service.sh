#!/system/bin/sh
MAGISK_VER_CODE=`grep MAGISK_VER_CODE /data/adb/magisk/util_functions.sh`
imageless_magisk() {
  [ $MAGISK_VER_CODE -gt 18100 ]
  return $?
}
if imageless_magisk; then
  MODDIR=/data/adb/modules/quickstepswitcher
else
  MODDIR=/sbin/.magisk/img/quickstepswitcher
fi
# Start logging
MODID=quickstepswitcher
set -x 2>$MODDIR/logs/$MODID-service.log

if [ -d "/product/overlay" -a ! -L "/product" ]; then
  if [ $MAGISK_VER_CODE -ge "19305" ]; then
    PRODUCT=$MODDIR/system/product/overlay
  else
    PRODUCT=/product/overlay
  fi
fi
if [ ! -d "$MODDIR" ]; then
  if [ ! -z "$PRODUCT" ]; then rm $PRODUCT/QuickstepSwitcherOverlay.apk; fi
  rm -rf /data/resource-cache/*
  rm $0
  exit 0
elif [ -f "$MODDIR/disable" ]; then
  rm -rf /data/resource-cache/*
fi

# Assign vars
SWITCHER_DIR=/data/user_de/0/xyz.paphonb.quickstepswitcher
SWITCHER_OUTPUT=$SWITCHER_DIR/files
DID_MOUNT_RW=
# Assign $STEPDIR var
if [ -f "$SWITCHER_OUTPUT/isProduct" ]; then
  PRODUCT=true
  # Yay, magisk supports bind mounting /product now
  if [ $MAGISK_VER_CODE -ge "19305" ]; then
    STEPDIR=$MODDIR/system/product/overlay
  else
    STEPDIR=/product/overlay
  fi
  # Try to mount /product
  if [ $STEPDIR = "/product/overlay" ]; then
    is_mounted " /product" || mount /product
    is_mounted_rw " /product" || mount_rw /product
  fi
else
  PRODUCT=false
  STEPDIR=$MODDIR/system/vendor/overlay
fi
while [ ! -d $STEPDIR ]; do
  mkdir -p $STEPDIR
done
if [ -f "$SWITCHER_OUTPUT/lastChange" ]; then
  if [ -f "$SWITCHER_OUTPUT/output/QuickstepSwitcherOverlay.apk" ]; then
    is_mounted() {
      grep " `readlink -f $1` " /proc/mounts 2>/dev/null
      return $?
    }
    is_mounted_rw() {
      grep " `readlink -f $1` " /proc/mounts | grep " rw," 2>/dev/null
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
    while [ ! -f $STEPDIR/QuickstepSwitcherOverlay.apk ]; do
      sleep 1
      if [ $STEPDIR = "/product/overlay" ]; then
        is_mounted " /product" || mount /product
        is_mounted_rw " /product" || mount_rw /product
      fi
      cp -rf $SWITCHER_OUTPUT/output/QuickstepSwitcherOverlay.apk $STEPDIR/QuickstepSwitcherOverlay.apk
    done
    chmod 644 $STEPDIR/QuickstepSwitcherOverlay.apk
    [ $STEPDIR = "/product/overlay" ] && unmount_rw /product
    if [ -f "$STEPDIR/QuickstepSwitcherOverlay.apk" ]; then
      rm -rf $SWITCHER_OUTPUT/lastChange
    fi
  fi
fi

# wew it werks
GRID= && [ -f "$SWITCHER_OUTPUT/gridRecents" ] && GRID=true
[ "$GRID" ] && resetprop ro.recents.grid true || resetprop ro.recents.grid false

# Send the logs to $SDCARD/Documents/$MODID/
[ -d /storage/emulated/0 ] && SDCARD=/storage/emulated/0 || SDCARD=/data/media/0
mkdir -p $SDCARD/Documents/$MODID
rm -rf $SDCARD/Documents/$MODID/*
cp -rf $MODDIR/logs/* $SDCARD/Documents/$MODID/
