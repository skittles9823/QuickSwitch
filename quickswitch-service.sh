#!/system/bin/sh

# Assign vars
SWITCHER_DIR=/data/user_de/0/xyz.paphonb.quickstepswitcher
SWITCHER_OUTPUT=$SWITCHER_DIR/files
DID_MOUNT_RW=
MAGISK_VER_CODE=`grep MAGISK_VER_CODE /data/adb/magisk/util_functions.sh`

imageless_magisk() {
  [ $MAGISK_VER_CODE -gt 18100 ]
  return $?
}

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

if imageless_magisk; then
  MODDIR=/data/adb/modules/quickstepswitcher
else
  MODDIR=/sbin/.magisk/img/quickstepswitcher
fi

# Start logging
MODID=quickstepswitcher
set -x 2>$MODDIR/logs/$MODID-service.log

# Assign $STEPDIR var
if [ -d "/product/overlay" ]; then
  PRODUCT=true
  # Yay, magisk supports bind mounting /product now
  MAGISK_VER_CODE=$(grep "MAGISK_VER_CODE=" /data/adb/magisk/util_functions.sh | awk -F = '{ print $2 }')
  if [ $MAGISK_VER_CODE -ge "19308" ]; then
    MOUNTPRODUCT=
    STEPDIR=$MODDIR/system/product/overlay
  else
    MOUNTPRODUCT=true
    STEPDIR=/product/overlay
    is_mounted " /product" || mount /product
    is_mounted_rw " /product" || mount_rw /product
  fi
elif [ -d /oem/OP ];then
  OEM=true
  is_mounted " /oem" || mount /oem
  is_mounted_rw " /oem" || mount_rw /oem
  is_mounted " /oem/OP" || mount /oem/OP
  is_mounted_rw " /oem/OP" || mount_rw /oem/OP
  STEPDIR=/oem/OP/OPEN_US/overlay/framework
else
  PRODUCT=; OEM=; MOUNTPRODUCT=
  STEPDIR=$MODDIR/system/vendor/overlay
fi
if [ "$MOUNTPRODUCT" ]; then
  is_mounted " /product" || mount /product
  is_mounted_rw " /product" || mount_rw /product
elif [ "$OEM" ];then
  is_mounted " /oem" || mount /oem
  is_mounted_rw " /oem" || mount_rw /oem
  is_mounted " /oem/OP" || mount /oem/OP
  is_mounted_rw " /oem/OP" || mount_rw /oem/OP
fi

if [ ! -d "$MODDIR" ]; then
  if [ "$PRODUCT" == "true" -o "$OEM" == "true" ]; then
    while [ -f $STEPDIR/QuickstepSwitcherOverlay.apk ]; do
      if [ "$STEPDIR" == "/product/overlay" ]; then
        is_mounted " /product" || mount /product
        is_mounted_rw " /product" || mount_rw /product
      elif [ "$STEPDIR" == "/oem/OP/OPEN_US/overlay/framework" ];then
        is_mounted " /oem" || mount /oem
        is_mounted_rw " /oem" || mount_rw /oem
        is_mounted " /oem/OP" || mount /oem/OP
        is_mounted_rw " /oem/OP" || mount_rw /oem/OP
      fi
      rm $STEPDIR/QuickstepSwitcherOverlay.apk
    done
  fi
  if [ "$STEPDIR" == "/product/overlay" ]; then
    unmount_rw /product
  elif [ "$STEPDIR" == "/oem/OP/OPEN_US/overlay/framework" ]; then
    unmount_rw /oem/OP
    unmount_rw /oem
  fi
  rm -rf /data/resource-cache/*
  rm $0
  exit 0
elif [ -f "$MODDIR/disable" ]; then
  rm -rf /data/resource-cache/*
fi

# Hacky way to force the script to run if the post-fs-data.d script failed
while [ ! -d "$STEPDIR" ]; do
  mkdir -p $STEPDIR
  touch $SWITCHER_OUTPUT/lastChange
done

if [ -f "$SWITCHER_OUTPUT/lastChange" ]; then
  if [ -f "$SWITCHER_OUTPUT/output/QuickstepSwitcherOverlay.apk" ]; then
    while [ ! -f "$STEPDIR/QuickstepSwitcherOverlay.apk" ]; do
      sleep 1
      if [ "$STEPDIR" == "/product/overlay" ]; then
        is_mounted " /product" || mount /product
        is_mounted_rw " /product" || mount_rw /product
      elif [ "$STEPDIR" == "/oem/OP/OPEN_US/overlay/framework" ];then
        is_mounted " /oem" || mount /oem
        is_mounted_rw " /oem" || mount_rw /oem
        is_mounted " /oem/OP" || mount /oem/OP
        is_mounted_rw " /oem/OP" || mount_rw /oem/OP
      fi
      cp -rf $SWITCHER_OUTPUT/output/QuickstepSwitcherOverlay.apk $STEPDIR/QuickstepSwitcherOverlay.apk
    done
    chmod 644 $STEPDIR/QuickstepSwitcherOverlay.apk
    if [ "$STEPDIR" == "/product/overlay" ]; then
      unmount_rw /product
    elif [ "$STEPDIR" == "/oem/OP/OPEN_US/overlay/framework" ]; then
      unmount_rw /oem/OP
      unmount_rw /oem
    fi
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
